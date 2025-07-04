
obj/user/fib_loop:     file format elf32-i386


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
  800031:	e8 41 01 00 00       	call   800177 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int64 fibonacci(int n, int64 *memo);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int index=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	atomic_readline("Please enter Fibonacci index:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 c0 37 80 00       	push   $0x8037c0
  800057:	e8 c7 0a 00 00       	call   800b23 <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	index = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 1a 0f 00 00       	call   800f8c <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int64 *memo = malloc((index+1) * sizeof(int64));
  800078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007b:	40                   	inc    %eax
  80007c:	c1 e0 03             	shl    $0x3,%eax
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	e8 c0 12 00 00       	call   801348 <malloc>
  800088:	83 c4 10             	add    $0x10,%esp
  80008b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int64 res = fibonacci(index, memo) ;
  80008e:	83 ec 08             	sub    $0x8,%esp
  800091:	ff 75 f0             	pushl  -0x10(%ebp)
  800094:	ff 75 f4             	pushl  -0xc(%ebp)
  800097:	e8 35 00 00 00       	call   8000d1 <fibonacci>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8000a2:	89 55 ec             	mov    %edx,-0x14(%ebp)

	free(memo);
  8000a5:	83 ec 0c             	sub    $0xc,%esp
  8000a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8000ab:	e8 4e 14 00 00       	call   8014fe <free>
  8000b0:	83 c4 10             	add    $0x10,%esp

	atomic_cprintf("Fibonacci #%d = %lld\n",index, res);
  8000b3:	ff 75 ec             	pushl  -0x14(%ebp)
  8000b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8000bc:	68 de 37 80 00       	push   $0x8037de
  8000c1:	e8 f7 02 00 00       	call   8003bd <atomic_cprintf>
  8000c6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000c9:	e8 56 1d 00 00       	call   801e24 <inctst>
	return;
  8000ce:	90                   	nop
}
  8000cf:	c9                   	leave  
  8000d0:	c3                   	ret    

008000d1 <fibonacci>:


int64 fibonacci(int n, int64 *memo)
{
  8000d1:	55                   	push   %ebp
  8000d2:	89 e5                	mov    %esp,%ebp
  8000d4:	56                   	push   %esi
  8000d5:	53                   	push   %ebx
  8000d6:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i <= n; ++i)
  8000d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000e0:	eb 72                	jmp    800154 <fibonacci+0x83>
	{
		if (i <= 1)
  8000e2:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8000e6:	7f 1e                	jg     800106 <fibonacci+0x35>
			memo[i] = 1;
  8000e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000eb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8000f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000f5:	01 d0                	add    %edx,%eax
  8000f7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  8000fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  800104:	eb 4b                	jmp    800151 <fibonacci+0x80>
		else
			memo[i] = memo[i-1] + memo[i-2] ;
  800106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800109:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800110:	8b 45 0c             	mov    0xc(%ebp),%eax
  800113:	8d 34 02             	lea    (%edx,%eax,1),%esi
  800116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800119:	05 ff ff ff 1f       	add    $0x1fffffff,%eax
  80011e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800125:	8b 45 0c             	mov    0xc(%ebp),%eax
  800128:	01 d0                	add    %edx,%eax
  80012a:	8b 08                	mov    (%eax),%ecx
  80012c:	8b 58 04             	mov    0x4(%eax),%ebx
  80012f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800132:	05 fe ff ff 1f       	add    $0x1ffffffe,%eax
  800137:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80013e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800141:	01 d0                	add    %edx,%eax
  800143:	8b 50 04             	mov    0x4(%eax),%edx
  800146:	8b 00                	mov    (%eax),%eax
  800148:	01 c8                	add    %ecx,%eax
  80014a:	11 da                	adc    %ebx,%edx
  80014c:	89 06                	mov    %eax,(%esi)
  80014e:	89 56 04             	mov    %edx,0x4(%esi)
}


int64 fibonacci(int n, int64 *memo)
{
	for (int i = 0; i <= n; ++i)
  800151:	ff 45 f4             	incl   -0xc(%ebp)
  800154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800157:	3b 45 08             	cmp    0x8(%ebp),%eax
  80015a:	7e 86                	jle    8000e2 <fibonacci+0x11>
		if (i <= 1)
			memo[i] = 1;
		else
			memo[i] = memo[i-1] + memo[i-2] ;
	}
	return memo[n];
  80015c:	8b 45 08             	mov    0x8(%ebp),%eax
  80015f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800166:	8b 45 0c             	mov    0xc(%ebp),%eax
  800169:	01 d0                	add    %edx,%eax
  80016b:	8b 50 04             	mov    0x4(%eax),%edx
  80016e:	8b 00                	mov    (%eax),%eax
}
  800170:	83 c4 10             	add    $0x10,%esp
  800173:	5b                   	pop    %ebx
  800174:	5e                   	pop    %esi
  800175:	5d                   	pop    %ebp
  800176:	c3                   	ret    

00800177 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800177:	55                   	push   %ebp
  800178:	89 e5                	mov    %esp,%ebp
  80017a:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80017d:	e8 64 1b 00 00       	call   801ce6 <sys_getenvindex>
  800182:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800185:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800188:	89 d0                	mov    %edx,%eax
  80018a:	c1 e0 02             	shl    $0x2,%eax
  80018d:	01 d0                	add    %edx,%eax
  80018f:	c1 e0 03             	shl    $0x3,%eax
  800192:	01 d0                	add    %edx,%eax
  800194:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80019b:	01 d0                	add    %edx,%eax
  80019d:	c1 e0 02             	shl    $0x2,%eax
  8001a0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a5:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001aa:	a1 20 40 80 00       	mov    0x804020,%eax
  8001af:	8a 40 20             	mov    0x20(%eax),%al
  8001b2:	84 c0                	test   %al,%al
  8001b4:	74 0d                	je     8001c3 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  8001b6:	a1 20 40 80 00       	mov    0x804020,%eax
  8001bb:	83 c0 20             	add    $0x20,%eax
  8001be:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001c7:	7e 0a                	jle    8001d3 <libmain+0x5c>
		binaryname = argv[0];
  8001c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001cc:	8b 00                	mov    (%eax),%eax
  8001ce:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  8001d3:	83 ec 08             	sub    $0x8,%esp
  8001d6:	ff 75 0c             	pushl  0xc(%ebp)
  8001d9:	ff 75 08             	pushl  0x8(%ebp)
  8001dc:	e8 57 fe ff ff       	call   800038 <_main>
  8001e1:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001e4:	a1 00 40 80 00       	mov    0x804000,%eax
  8001e9:	85 c0                	test   %eax,%eax
  8001eb:	0f 84 9f 00 00 00    	je     800290 <libmain+0x119>
	{
		sys_lock_cons();
  8001f1:	e8 74 18 00 00       	call   801a6a <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001f6:	83 ec 0c             	sub    $0xc,%esp
  8001f9:	68 0c 38 80 00       	push   $0x80380c
  8001fe:	e8 8d 01 00 00       	call   800390 <cprintf>
  800203:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800206:	a1 20 40 80 00       	mov    0x804020,%eax
  80020b:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800211:	a1 20 40 80 00       	mov    0x804020,%eax
  800216:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	52                   	push   %edx
  800220:	50                   	push   %eax
  800221:	68 34 38 80 00       	push   $0x803834
  800226:	e8 65 01 00 00       	call   800390 <cprintf>
  80022b:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80022e:	a1 20 40 80 00       	mov    0x804020,%eax
  800233:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800239:	a1 20 40 80 00       	mov    0x804020,%eax
  80023e:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800244:	a1 20 40 80 00       	mov    0x804020,%eax
  800249:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80024f:	51                   	push   %ecx
  800250:	52                   	push   %edx
  800251:	50                   	push   %eax
  800252:	68 5c 38 80 00       	push   $0x80385c
  800257:	e8 34 01 00 00       	call   800390 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80025f:	a1 20 40 80 00       	mov    0x804020,%eax
  800264:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	50                   	push   %eax
  80026e:	68 b4 38 80 00       	push   $0x8038b4
  800273:	e8 18 01 00 00       	call   800390 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	68 0c 38 80 00       	push   $0x80380c
  800283:	e8 08 01 00 00       	call   800390 <cprintf>
  800288:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80028b:	e8 f4 17 00 00       	call   801a84 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800290:	e8 19 00 00 00       	call   8002ae <exit>
}
  800295:	90                   	nop
  800296:	c9                   	leave  
  800297:	c3                   	ret    

00800298 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800298:	55                   	push   %ebp
  800299:	89 e5                	mov    %esp,%ebp
  80029b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80029e:	83 ec 0c             	sub    $0xc,%esp
  8002a1:	6a 00                	push   $0x0
  8002a3:	e8 0a 1a 00 00       	call   801cb2 <sys_destroy_env>
  8002a8:	83 c4 10             	add    $0x10,%esp
}
  8002ab:	90                   	nop
  8002ac:	c9                   	leave  
  8002ad:	c3                   	ret    

008002ae <exit>:

void
exit(void)
{
  8002ae:	55                   	push   %ebp
  8002af:	89 e5                	mov    %esp,%ebp
  8002b1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002b4:	e8 5f 1a 00 00       	call   801d18 <sys_exit_env>
}
  8002b9:	90                   	nop
  8002ba:	c9                   	leave  
  8002bb:	c3                   	ret    

008002bc <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c5:	8b 00                	mov    (%eax),%eax
  8002c7:	8d 48 01             	lea    0x1(%eax),%ecx
  8002ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002cd:	89 0a                	mov    %ecx,(%edx)
  8002cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d2:	88 d1                	mov    %dl,%cl
  8002d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002d7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002de:	8b 00                	mov    (%eax),%eax
  8002e0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002e5:	75 2c                	jne    800313 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002e7:	a0 44 40 98 00       	mov    0x984044,%al
  8002ec:	0f b6 c0             	movzbl %al,%eax
  8002ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f2:	8b 12                	mov    (%edx),%edx
  8002f4:	89 d1                	mov    %edx,%ecx
  8002f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f9:	83 c2 08             	add    $0x8,%edx
  8002fc:	83 ec 04             	sub    $0x4,%esp
  8002ff:	50                   	push   %eax
  800300:	51                   	push   %ecx
  800301:	52                   	push   %edx
  800302:	e8 21 17 00 00       	call   801a28 <sys_cputs>
  800307:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80030a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800313:	8b 45 0c             	mov    0xc(%ebp),%eax
  800316:	8b 40 04             	mov    0x4(%eax),%eax
  800319:	8d 50 01             	lea    0x1(%eax),%edx
  80031c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800322:	90                   	nop
  800323:	c9                   	leave  
  800324:	c3                   	ret    

00800325 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800325:	55                   	push   %ebp
  800326:	89 e5                	mov    %esp,%ebp
  800328:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80032e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800335:	00 00 00 
	b.cnt = 0;
  800338:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80033f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800342:	ff 75 0c             	pushl  0xc(%ebp)
  800345:	ff 75 08             	pushl  0x8(%ebp)
  800348:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80034e:	50                   	push   %eax
  80034f:	68 bc 02 80 00       	push   $0x8002bc
  800354:	e8 11 02 00 00       	call   80056a <vprintfmt>
  800359:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80035c:	a0 44 40 98 00       	mov    0x984044,%al
  800361:	0f b6 c0             	movzbl %al,%eax
  800364:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80036a:	83 ec 04             	sub    $0x4,%esp
  80036d:	50                   	push   %eax
  80036e:	52                   	push   %edx
  80036f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800375:	83 c0 08             	add    $0x8,%eax
  800378:	50                   	push   %eax
  800379:	e8 aa 16 00 00       	call   801a28 <sys_cputs>
  80037e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800381:	c6 05 44 40 98 00 00 	movb   $0x0,0x984044
	return b.cnt;
  800388:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800396:	c6 05 44 40 98 00 01 	movb   $0x1,0x984044
	va_start(ap, fmt);
  80039d:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a6:	83 ec 08             	sub    $0x8,%esp
  8003a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ac:	50                   	push   %eax
  8003ad:	e8 73 ff ff ff       	call   800325 <vcprintf>
  8003b2:	83 c4 10             	add    $0x10,%esp
  8003b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003bb:	c9                   	leave  
  8003bc:	c3                   	ret    

008003bd <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003c3:	e8 a2 16 00 00       	call   801a6a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003c8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8003ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d1:	83 ec 08             	sub    $0x8,%esp
  8003d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8003d7:	50                   	push   %eax
  8003d8:	e8 48 ff ff ff       	call   800325 <vcprintf>
  8003dd:	83 c4 10             	add    $0x10,%esp
  8003e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8003e3:	e8 9c 16 00 00       	call   801a84 <sys_unlock_cons>
	return cnt;
  8003e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003eb:	c9                   	leave  
  8003ec:	c3                   	ret    

008003ed <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003ed:	55                   	push   %ebp
  8003ee:	89 e5                	mov    %esp,%ebp
  8003f0:	53                   	push   %ebx
  8003f1:	83 ec 14             	sub    $0x14,%esp
  8003f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8003f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800400:	8b 45 18             	mov    0x18(%ebp),%eax
  800403:	ba 00 00 00 00       	mov    $0x0,%edx
  800408:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80040b:	77 55                	ja     800462 <printnum+0x75>
  80040d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800410:	72 05                	jb     800417 <printnum+0x2a>
  800412:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800415:	77 4b                	ja     800462 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800417:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80041a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80041d:	8b 45 18             	mov    0x18(%ebp),%eax
  800420:	ba 00 00 00 00       	mov    $0x0,%edx
  800425:	52                   	push   %edx
  800426:	50                   	push   %eax
  800427:	ff 75 f4             	pushl  -0xc(%ebp)
  80042a:	ff 75 f0             	pushl  -0x10(%ebp)
  80042d:	e8 1e 31 00 00       	call   803550 <__udivdi3>
  800432:	83 c4 10             	add    $0x10,%esp
  800435:	83 ec 04             	sub    $0x4,%esp
  800438:	ff 75 20             	pushl  0x20(%ebp)
  80043b:	53                   	push   %ebx
  80043c:	ff 75 18             	pushl  0x18(%ebp)
  80043f:	52                   	push   %edx
  800440:	50                   	push   %eax
  800441:	ff 75 0c             	pushl  0xc(%ebp)
  800444:	ff 75 08             	pushl  0x8(%ebp)
  800447:	e8 a1 ff ff ff       	call   8003ed <printnum>
  80044c:	83 c4 20             	add    $0x20,%esp
  80044f:	eb 1a                	jmp    80046b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800451:	83 ec 08             	sub    $0x8,%esp
  800454:	ff 75 0c             	pushl  0xc(%ebp)
  800457:	ff 75 20             	pushl  0x20(%ebp)
  80045a:	8b 45 08             	mov    0x8(%ebp),%eax
  80045d:	ff d0                	call   *%eax
  80045f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800462:	ff 4d 1c             	decl   0x1c(%ebp)
  800465:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800469:	7f e6                	jg     800451 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80046b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80046e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800476:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800479:	53                   	push   %ebx
  80047a:	51                   	push   %ecx
  80047b:	52                   	push   %edx
  80047c:	50                   	push   %eax
  80047d:	e8 de 31 00 00       	call   803660 <__umoddi3>
  800482:	83 c4 10             	add    $0x10,%esp
  800485:	05 f4 3a 80 00       	add    $0x803af4,%eax
  80048a:	8a 00                	mov    (%eax),%al
  80048c:	0f be c0             	movsbl %al,%eax
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	ff 75 0c             	pushl  0xc(%ebp)
  800495:	50                   	push   %eax
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	ff d0                	call   *%eax
  80049b:	83 c4 10             	add    $0x10,%esp
}
  80049e:	90                   	nop
  80049f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004a2:	c9                   	leave  
  8004a3:	c3                   	ret    

008004a4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004a4:	55                   	push   %ebp
  8004a5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004a7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004ab:	7e 1c                	jle    8004c9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	8d 50 08             	lea    0x8(%eax),%edx
  8004b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b8:	89 10                	mov    %edx,(%eax)
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	8b 00                	mov    (%eax),%eax
  8004bf:	83 e8 08             	sub    $0x8,%eax
  8004c2:	8b 50 04             	mov    0x4(%eax),%edx
  8004c5:	8b 00                	mov    (%eax),%eax
  8004c7:	eb 40                	jmp    800509 <getuint+0x65>
	else if (lflag)
  8004c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004cd:	74 1e                	je     8004ed <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d2:	8b 00                	mov    (%eax),%eax
  8004d4:	8d 50 04             	lea    0x4(%eax),%edx
  8004d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004da:	89 10                	mov    %edx,(%eax)
  8004dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004df:	8b 00                	mov    (%eax),%eax
  8004e1:	83 e8 04             	sub    $0x4,%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8004eb:	eb 1c                	jmp    800509 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f0:	8b 00                	mov    (%eax),%eax
  8004f2:	8d 50 04             	lea    0x4(%eax),%edx
  8004f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f8:	89 10                	mov    %edx,(%eax)
  8004fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fd:	8b 00                	mov    (%eax),%eax
  8004ff:	83 e8 04             	sub    $0x4,%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800509:	5d                   	pop    %ebp
  80050a:	c3                   	ret    

0080050b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80050e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800512:	7e 1c                	jle    800530 <getint+0x25>
		return va_arg(*ap, long long);
  800514:	8b 45 08             	mov    0x8(%ebp),%eax
  800517:	8b 00                	mov    (%eax),%eax
  800519:	8d 50 08             	lea    0x8(%eax),%edx
  80051c:	8b 45 08             	mov    0x8(%ebp),%eax
  80051f:	89 10                	mov    %edx,(%eax)
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	8b 00                	mov    (%eax),%eax
  800526:	83 e8 08             	sub    $0x8,%eax
  800529:	8b 50 04             	mov    0x4(%eax),%edx
  80052c:	8b 00                	mov    (%eax),%eax
  80052e:	eb 38                	jmp    800568 <getint+0x5d>
	else if (lflag)
  800530:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800534:	74 1a                	je     800550 <getint+0x45>
		return va_arg(*ap, long);
  800536:	8b 45 08             	mov    0x8(%ebp),%eax
  800539:	8b 00                	mov    (%eax),%eax
  80053b:	8d 50 04             	lea    0x4(%eax),%edx
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	89 10                	mov    %edx,(%eax)
  800543:	8b 45 08             	mov    0x8(%ebp),%eax
  800546:	8b 00                	mov    (%eax),%eax
  800548:	83 e8 04             	sub    $0x4,%eax
  80054b:	8b 00                	mov    (%eax),%eax
  80054d:	99                   	cltd   
  80054e:	eb 18                	jmp    800568 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800550:	8b 45 08             	mov    0x8(%ebp),%eax
  800553:	8b 00                	mov    (%eax),%eax
  800555:	8d 50 04             	lea    0x4(%eax),%edx
  800558:	8b 45 08             	mov    0x8(%ebp),%eax
  80055b:	89 10                	mov    %edx,(%eax)
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	8b 00                	mov    (%eax),%eax
  800562:	83 e8 04             	sub    $0x4,%eax
  800565:	8b 00                	mov    (%eax),%eax
  800567:	99                   	cltd   
}
  800568:	5d                   	pop    %ebp
  800569:	c3                   	ret    

0080056a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80056a:	55                   	push   %ebp
  80056b:	89 e5                	mov    %esp,%ebp
  80056d:	56                   	push   %esi
  80056e:	53                   	push   %ebx
  80056f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800572:	eb 17                	jmp    80058b <vprintfmt+0x21>
			if (ch == '\0')
  800574:	85 db                	test   %ebx,%ebx
  800576:	0f 84 c1 03 00 00    	je     80093d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80057c:	83 ec 08             	sub    $0x8,%esp
  80057f:	ff 75 0c             	pushl  0xc(%ebp)
  800582:	53                   	push   %ebx
  800583:	8b 45 08             	mov    0x8(%ebp),%eax
  800586:	ff d0                	call   *%eax
  800588:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80058b:	8b 45 10             	mov    0x10(%ebp),%eax
  80058e:	8d 50 01             	lea    0x1(%eax),%edx
  800591:	89 55 10             	mov    %edx,0x10(%ebp)
  800594:	8a 00                	mov    (%eax),%al
  800596:	0f b6 d8             	movzbl %al,%ebx
  800599:	83 fb 25             	cmp    $0x25,%ebx
  80059c:	75 d6                	jne    800574 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80059e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005a2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005a9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005b0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005b7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005be:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c1:	8d 50 01             	lea    0x1(%eax),%edx
  8005c4:	89 55 10             	mov    %edx,0x10(%ebp)
  8005c7:	8a 00                	mov    (%eax),%al
  8005c9:	0f b6 d8             	movzbl %al,%ebx
  8005cc:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005cf:	83 f8 5b             	cmp    $0x5b,%eax
  8005d2:	0f 87 3d 03 00 00    	ja     800915 <vprintfmt+0x3ab>
  8005d8:	8b 04 85 18 3b 80 00 	mov    0x803b18(,%eax,4),%eax
  8005df:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005e1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005e5:	eb d7                	jmp    8005be <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005e7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005eb:	eb d1                	jmp    8005be <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005ed:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005f7:	89 d0                	mov    %edx,%eax
  8005f9:	c1 e0 02             	shl    $0x2,%eax
  8005fc:	01 d0                	add    %edx,%eax
  8005fe:	01 c0                	add    %eax,%eax
  800600:	01 d8                	add    %ebx,%eax
  800602:	83 e8 30             	sub    $0x30,%eax
  800605:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800608:	8b 45 10             	mov    0x10(%ebp),%eax
  80060b:	8a 00                	mov    (%eax),%al
  80060d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800610:	83 fb 2f             	cmp    $0x2f,%ebx
  800613:	7e 3e                	jle    800653 <vprintfmt+0xe9>
  800615:	83 fb 39             	cmp    $0x39,%ebx
  800618:	7f 39                	jg     800653 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80061a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80061d:	eb d5                	jmp    8005f4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	83 c0 04             	add    $0x4,%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	83 e8 04             	sub    $0x4,%eax
  80062e:	8b 00                	mov    (%eax),%eax
  800630:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800633:	eb 1f                	jmp    800654 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800635:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800639:	79 83                	jns    8005be <vprintfmt+0x54>
				width = 0;
  80063b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800642:	e9 77 ff ff ff       	jmp    8005be <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800647:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80064e:	e9 6b ff ff ff       	jmp    8005be <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800653:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800654:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800658:	0f 89 60 ff ff ff    	jns    8005be <vprintfmt+0x54>
				width = precision, precision = -1;
  80065e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800661:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800664:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80066b:	e9 4e ff ff ff       	jmp    8005be <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800670:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800673:	e9 46 ff ff ff       	jmp    8005be <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800678:	8b 45 14             	mov    0x14(%ebp),%eax
  80067b:	83 c0 04             	add    $0x4,%eax
  80067e:	89 45 14             	mov    %eax,0x14(%ebp)
  800681:	8b 45 14             	mov    0x14(%ebp),%eax
  800684:	83 e8 04             	sub    $0x4,%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	83 ec 08             	sub    $0x8,%esp
  80068c:	ff 75 0c             	pushl  0xc(%ebp)
  80068f:	50                   	push   %eax
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	ff d0                	call   *%eax
  800695:	83 c4 10             	add    $0x10,%esp
			break;
  800698:	e9 9b 02 00 00       	jmp    800938 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	83 c0 04             	add    $0x4,%eax
  8006a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a9:	83 e8 04             	sub    $0x4,%eax
  8006ac:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006ae:	85 db                	test   %ebx,%ebx
  8006b0:	79 02                	jns    8006b4 <vprintfmt+0x14a>
				err = -err;
  8006b2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006b4:	83 fb 64             	cmp    $0x64,%ebx
  8006b7:	7f 0b                	jg     8006c4 <vprintfmt+0x15a>
  8006b9:	8b 34 9d 60 39 80 00 	mov    0x803960(,%ebx,4),%esi
  8006c0:	85 f6                	test   %esi,%esi
  8006c2:	75 19                	jne    8006dd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006c4:	53                   	push   %ebx
  8006c5:	68 05 3b 80 00       	push   $0x803b05
  8006ca:	ff 75 0c             	pushl  0xc(%ebp)
  8006cd:	ff 75 08             	pushl  0x8(%ebp)
  8006d0:	e8 70 02 00 00       	call   800945 <printfmt>
  8006d5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006d8:	e9 5b 02 00 00       	jmp    800938 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006dd:	56                   	push   %esi
  8006de:	68 0e 3b 80 00       	push   $0x803b0e
  8006e3:	ff 75 0c             	pushl  0xc(%ebp)
  8006e6:	ff 75 08             	pushl  0x8(%ebp)
  8006e9:	e8 57 02 00 00       	call   800945 <printfmt>
  8006ee:	83 c4 10             	add    $0x10,%esp
			break;
  8006f1:	e9 42 02 00 00       	jmp    800938 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	83 c0 04             	add    $0x4,%eax
  8006fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	83 e8 04             	sub    $0x4,%eax
  800705:	8b 30                	mov    (%eax),%esi
  800707:	85 f6                	test   %esi,%esi
  800709:	75 05                	jne    800710 <vprintfmt+0x1a6>
				p = "(null)";
  80070b:	be 11 3b 80 00       	mov    $0x803b11,%esi
			if (width > 0 && padc != '-')
  800710:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800714:	7e 6d                	jle    800783 <vprintfmt+0x219>
  800716:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80071a:	74 67                	je     800783 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80071c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80071f:	83 ec 08             	sub    $0x8,%esp
  800722:	50                   	push   %eax
  800723:	56                   	push   %esi
  800724:	e8 26 05 00 00       	call   800c4f <strnlen>
  800729:	83 c4 10             	add    $0x10,%esp
  80072c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80072f:	eb 16                	jmp    800747 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800731:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800735:	83 ec 08             	sub    $0x8,%esp
  800738:	ff 75 0c             	pushl  0xc(%ebp)
  80073b:	50                   	push   %eax
  80073c:	8b 45 08             	mov    0x8(%ebp),%eax
  80073f:	ff d0                	call   *%eax
  800741:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800744:	ff 4d e4             	decl   -0x1c(%ebp)
  800747:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80074b:	7f e4                	jg     800731 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80074d:	eb 34                	jmp    800783 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80074f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800753:	74 1c                	je     800771 <vprintfmt+0x207>
  800755:	83 fb 1f             	cmp    $0x1f,%ebx
  800758:	7e 05                	jle    80075f <vprintfmt+0x1f5>
  80075a:	83 fb 7e             	cmp    $0x7e,%ebx
  80075d:	7e 12                	jle    800771 <vprintfmt+0x207>
					putch('?', putdat);
  80075f:	83 ec 08             	sub    $0x8,%esp
  800762:	ff 75 0c             	pushl  0xc(%ebp)
  800765:	6a 3f                	push   $0x3f
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	ff d0                	call   *%eax
  80076c:	83 c4 10             	add    $0x10,%esp
  80076f:	eb 0f                	jmp    800780 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 0c             	pushl  0xc(%ebp)
  800777:	53                   	push   %ebx
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	ff d0                	call   *%eax
  80077d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800780:	ff 4d e4             	decl   -0x1c(%ebp)
  800783:	89 f0                	mov    %esi,%eax
  800785:	8d 70 01             	lea    0x1(%eax),%esi
  800788:	8a 00                	mov    (%eax),%al
  80078a:	0f be d8             	movsbl %al,%ebx
  80078d:	85 db                	test   %ebx,%ebx
  80078f:	74 24                	je     8007b5 <vprintfmt+0x24b>
  800791:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800795:	78 b8                	js     80074f <vprintfmt+0x1e5>
  800797:	ff 4d e0             	decl   -0x20(%ebp)
  80079a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80079e:	79 af                	jns    80074f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007a0:	eb 13                	jmp    8007b5 <vprintfmt+0x24b>
				putch(' ', putdat);
  8007a2:	83 ec 08             	sub    $0x8,%esp
  8007a5:	ff 75 0c             	pushl  0xc(%ebp)
  8007a8:	6a 20                	push   $0x20
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	ff d0                	call   *%eax
  8007af:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007b2:	ff 4d e4             	decl   -0x1c(%ebp)
  8007b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007b9:	7f e7                	jg     8007a2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007bb:	e9 78 01 00 00       	jmp    800938 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007c0:	83 ec 08             	sub    $0x8,%esp
  8007c3:	ff 75 e8             	pushl  -0x18(%ebp)
  8007c6:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c9:	50                   	push   %eax
  8007ca:	e8 3c fd ff ff       	call   80050b <getint>
  8007cf:	83 c4 10             	add    $0x10,%esp
  8007d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007de:	85 d2                	test   %edx,%edx
  8007e0:	79 23                	jns    800805 <vprintfmt+0x29b>
				putch('-', putdat);
  8007e2:	83 ec 08             	sub    $0x8,%esp
  8007e5:	ff 75 0c             	pushl  0xc(%ebp)
  8007e8:	6a 2d                	push   $0x2d
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	ff d0                	call   *%eax
  8007ef:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007f8:	f7 d8                	neg    %eax
  8007fa:	83 d2 00             	adc    $0x0,%edx
  8007fd:	f7 da                	neg    %edx
  8007ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800802:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800805:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80080c:	e9 bc 00 00 00       	jmp    8008cd <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800811:	83 ec 08             	sub    $0x8,%esp
  800814:	ff 75 e8             	pushl  -0x18(%ebp)
  800817:	8d 45 14             	lea    0x14(%ebp),%eax
  80081a:	50                   	push   %eax
  80081b:	e8 84 fc ff ff       	call   8004a4 <getuint>
  800820:	83 c4 10             	add    $0x10,%esp
  800823:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800826:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800829:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800830:	e9 98 00 00 00       	jmp    8008cd <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800835:	83 ec 08             	sub    $0x8,%esp
  800838:	ff 75 0c             	pushl  0xc(%ebp)
  80083b:	6a 58                	push   $0x58
  80083d:	8b 45 08             	mov    0x8(%ebp),%eax
  800840:	ff d0                	call   *%eax
  800842:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	ff 75 0c             	pushl  0xc(%ebp)
  80084b:	6a 58                	push   $0x58
  80084d:	8b 45 08             	mov    0x8(%ebp),%eax
  800850:	ff d0                	call   *%eax
  800852:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	ff 75 0c             	pushl  0xc(%ebp)
  80085b:	6a 58                	push   $0x58
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	ff d0                	call   *%eax
  800862:	83 c4 10             	add    $0x10,%esp
			break;
  800865:	e9 ce 00 00 00       	jmp    800938 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	6a 30                	push   $0x30
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	ff d0                	call   *%eax
  800877:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80087a:	83 ec 08             	sub    $0x8,%esp
  80087d:	ff 75 0c             	pushl  0xc(%ebp)
  800880:	6a 78                	push   $0x78
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	ff d0                	call   *%eax
  800887:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80088a:	8b 45 14             	mov    0x14(%ebp),%eax
  80088d:	83 c0 04             	add    $0x4,%eax
  800890:	89 45 14             	mov    %eax,0x14(%ebp)
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	83 e8 04             	sub    $0x4,%eax
  800899:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80089b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80089e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008a5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008ac:	eb 1f                	jmp    8008cd <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	ff 75 e8             	pushl  -0x18(%ebp)
  8008b4:	8d 45 14             	lea    0x14(%ebp),%eax
  8008b7:	50                   	push   %eax
  8008b8:	e8 e7 fb ff ff       	call   8004a4 <getuint>
  8008bd:	83 c4 10             	add    $0x10,%esp
  8008c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008c6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008cd:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008d4:	83 ec 04             	sub    $0x4,%esp
  8008d7:	52                   	push   %edx
  8008d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008db:	50                   	push   %eax
  8008dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8008df:	ff 75 f0             	pushl  -0x10(%ebp)
  8008e2:	ff 75 0c             	pushl  0xc(%ebp)
  8008e5:	ff 75 08             	pushl  0x8(%ebp)
  8008e8:	e8 00 fb ff ff       	call   8003ed <printnum>
  8008ed:	83 c4 20             	add    $0x20,%esp
			break;
  8008f0:	eb 46                	jmp    800938 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	ff 75 0c             	pushl  0xc(%ebp)
  8008f8:	53                   	push   %ebx
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	ff d0                	call   *%eax
  8008fe:	83 c4 10             	add    $0x10,%esp
			break;
  800901:	eb 35                	jmp    800938 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800903:	c6 05 44 40 98 00 00 	movb   $0x0,0x984044
			break;
  80090a:	eb 2c                	jmp    800938 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80090c:	c6 05 44 40 98 00 01 	movb   $0x1,0x984044
			break;
  800913:	eb 23                	jmp    800938 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800915:	83 ec 08             	sub    $0x8,%esp
  800918:	ff 75 0c             	pushl  0xc(%ebp)
  80091b:	6a 25                	push   $0x25
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	ff d0                	call   *%eax
  800922:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800925:	ff 4d 10             	decl   0x10(%ebp)
  800928:	eb 03                	jmp    80092d <vprintfmt+0x3c3>
  80092a:	ff 4d 10             	decl   0x10(%ebp)
  80092d:	8b 45 10             	mov    0x10(%ebp),%eax
  800930:	48                   	dec    %eax
  800931:	8a 00                	mov    (%eax),%al
  800933:	3c 25                	cmp    $0x25,%al
  800935:	75 f3                	jne    80092a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800937:	90                   	nop
		}
	}
  800938:	e9 35 fc ff ff       	jmp    800572 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80093d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80093e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800941:	5b                   	pop    %ebx
  800942:	5e                   	pop    %esi
  800943:	5d                   	pop    %ebp
  800944:	c3                   	ret    

00800945 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
  800948:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80094b:	8d 45 10             	lea    0x10(%ebp),%eax
  80094e:	83 c0 04             	add    $0x4,%eax
  800951:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800954:	8b 45 10             	mov    0x10(%ebp),%eax
  800957:	ff 75 f4             	pushl  -0xc(%ebp)
  80095a:	50                   	push   %eax
  80095b:	ff 75 0c             	pushl  0xc(%ebp)
  80095e:	ff 75 08             	pushl  0x8(%ebp)
  800961:	e8 04 fc ff ff       	call   80056a <vprintfmt>
  800966:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800969:	90                   	nop
  80096a:	c9                   	leave  
  80096b:	c3                   	ret    

0080096c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80096c:	55                   	push   %ebp
  80096d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80096f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800972:	8b 40 08             	mov    0x8(%eax),%eax
  800975:	8d 50 01             	lea    0x1(%eax),%edx
  800978:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80097e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800981:	8b 10                	mov    (%eax),%edx
  800983:	8b 45 0c             	mov    0xc(%ebp),%eax
  800986:	8b 40 04             	mov    0x4(%eax),%eax
  800989:	39 c2                	cmp    %eax,%edx
  80098b:	73 12                	jae    80099f <sprintputch+0x33>
		*b->buf++ = ch;
  80098d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800990:	8b 00                	mov    (%eax),%eax
  800992:	8d 48 01             	lea    0x1(%eax),%ecx
  800995:	8b 55 0c             	mov    0xc(%ebp),%edx
  800998:	89 0a                	mov    %ecx,(%edx)
  80099a:	8b 55 08             	mov    0x8(%ebp),%edx
  80099d:	88 10                	mov    %dl,(%eax)
}
  80099f:	90                   	nop
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    

008009a2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b7:	01 d0                	add    %edx,%eax
  8009b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009c7:	74 06                	je     8009cf <vsnprintf+0x2d>
  8009c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009cd:	7f 07                	jg     8009d6 <vsnprintf+0x34>
		return -E_INVAL;
  8009cf:	b8 03 00 00 00       	mov    $0x3,%eax
  8009d4:	eb 20                	jmp    8009f6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009d6:	ff 75 14             	pushl  0x14(%ebp)
  8009d9:	ff 75 10             	pushl  0x10(%ebp)
  8009dc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009df:	50                   	push   %eax
  8009e0:	68 6c 09 80 00       	push   $0x80096c
  8009e5:	e8 80 fb ff ff       	call   80056a <vprintfmt>
  8009ea:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009f0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009f6:	c9                   	leave  
  8009f7:	c3                   	ret    

008009f8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009f8:	55                   	push   %ebp
  8009f9:	89 e5                	mov    %esp,%ebp
  8009fb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009fe:	8d 45 10             	lea    0x10(%ebp),%eax
  800a01:	83 c0 04             	add    $0x4,%eax
  800a04:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a07:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a0d:	50                   	push   %eax
  800a0e:	ff 75 0c             	pushl  0xc(%ebp)
  800a11:	ff 75 08             	pushl  0x8(%ebp)
  800a14:	e8 89 ff ff ff       	call   8009a2 <vsnprintf>
  800a19:	83 c4 10             	add    $0x10,%esp
  800a1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a22:	c9                   	leave  
  800a23:	c3                   	ret    

00800a24 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800a2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a2e:	74 13                	je     800a43 <readline+0x1f>
		cprintf("%s", prompt);
  800a30:	83 ec 08             	sub    $0x8,%esp
  800a33:	ff 75 08             	pushl  0x8(%ebp)
  800a36:	68 88 3c 80 00       	push   $0x803c88
  800a3b:	e8 50 f9 ff ff       	call   800390 <cprintf>
  800a40:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a4a:	83 ec 0c             	sub    $0xc,%esp
  800a4d:	6a 00                	push   $0x0
  800a4f:	e8 07 29 00 00       	call   80335b <iscons>
  800a54:	83 c4 10             	add    $0x10,%esp
  800a57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a5a:	e8 e9 28 00 00       	call   803348 <getchar>
  800a5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800a62:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a66:	79 22                	jns    800a8a <readline+0x66>
			if (c != -E_EOF)
  800a68:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800a6c:	0f 84 ad 00 00 00    	je     800b1f <readline+0xfb>
				cprintf("read error: %e\n", c);
  800a72:	83 ec 08             	sub    $0x8,%esp
  800a75:	ff 75 ec             	pushl  -0x14(%ebp)
  800a78:	68 8b 3c 80 00       	push   $0x803c8b
  800a7d:	e8 0e f9 ff ff       	call   800390 <cprintf>
  800a82:	83 c4 10             	add    $0x10,%esp
			break;
  800a85:	e9 95 00 00 00       	jmp    800b1f <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800a8a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800a8e:	7e 34                	jle    800ac4 <readline+0xa0>
  800a90:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800a97:	7f 2b                	jg     800ac4 <readline+0xa0>
			if (echoing)
  800a99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a9d:	74 0e                	je     800aad <readline+0x89>
				cputchar(c);
  800a9f:	83 ec 0c             	sub    $0xc,%esp
  800aa2:	ff 75 ec             	pushl  -0x14(%ebp)
  800aa5:	e8 7f 28 00 00       	call   803329 <cputchar>
  800aaa:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ab0:	8d 50 01             	lea    0x1(%eax),%edx
  800ab3:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800ab6:	89 c2                	mov    %eax,%edx
  800ab8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abb:	01 d0                	add    %edx,%eax
  800abd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ac0:	88 10                	mov    %dl,(%eax)
  800ac2:	eb 56                	jmp    800b1a <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800ac4:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800ac8:	75 1f                	jne    800ae9 <readline+0xc5>
  800aca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ace:	7e 19                	jle    800ae9 <readline+0xc5>
			if (echoing)
  800ad0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ad4:	74 0e                	je     800ae4 <readline+0xc0>
				cputchar(c);
  800ad6:	83 ec 0c             	sub    $0xc,%esp
  800ad9:	ff 75 ec             	pushl  -0x14(%ebp)
  800adc:	e8 48 28 00 00       	call   803329 <cputchar>
  800ae1:	83 c4 10             	add    $0x10,%esp

			i--;
  800ae4:	ff 4d f4             	decl   -0xc(%ebp)
  800ae7:	eb 31                	jmp    800b1a <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800ae9:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800aed:	74 0a                	je     800af9 <readline+0xd5>
  800aef:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800af3:	0f 85 61 ff ff ff    	jne    800a5a <readline+0x36>
			if (echoing)
  800af9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800afd:	74 0e                	je     800b0d <readline+0xe9>
				cputchar(c);
  800aff:	83 ec 0c             	sub    $0xc,%esp
  800b02:	ff 75 ec             	pushl  -0x14(%ebp)
  800b05:	e8 1f 28 00 00       	call   803329 <cputchar>
  800b0a:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800b0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b13:	01 d0                	add    %edx,%eax
  800b15:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800b18:	eb 06                	jmp    800b20 <readline+0xfc>
		}
	}
  800b1a:	e9 3b ff ff ff       	jmp    800a5a <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800b1f:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800b20:	90                   	nop
  800b21:	c9                   	leave  
  800b22:	c3                   	ret    

00800b23 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800b29:	e8 3c 0f 00 00       	call   801a6a <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b32:	74 13                	je     800b47 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b34:	83 ec 08             	sub    $0x8,%esp
  800b37:	ff 75 08             	pushl  0x8(%ebp)
  800b3a:	68 88 3c 80 00       	push   $0x803c88
  800b3f:	e8 4c f8 ff ff       	call   800390 <cprintf>
  800b44:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b4e:	83 ec 0c             	sub    $0xc,%esp
  800b51:	6a 00                	push   $0x0
  800b53:	e8 03 28 00 00       	call   80335b <iscons>
  800b58:	83 c4 10             	add    $0x10,%esp
  800b5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b5e:	e8 e5 27 00 00       	call   803348 <getchar>
  800b63:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800b66:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b6a:	79 22                	jns    800b8e <atomic_readline+0x6b>
				if (c != -E_EOF)
  800b6c:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800b70:	0f 84 ad 00 00 00    	je     800c23 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800b76:	83 ec 08             	sub    $0x8,%esp
  800b79:	ff 75 ec             	pushl  -0x14(%ebp)
  800b7c:	68 8b 3c 80 00       	push   $0x803c8b
  800b81:	e8 0a f8 ff ff       	call   800390 <cprintf>
  800b86:	83 c4 10             	add    $0x10,%esp
				break;
  800b89:	e9 95 00 00 00       	jmp    800c23 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800b8e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800b92:	7e 34                	jle    800bc8 <atomic_readline+0xa5>
  800b94:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800b9b:	7f 2b                	jg     800bc8 <atomic_readline+0xa5>
				if (echoing)
  800b9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ba1:	74 0e                	je     800bb1 <atomic_readline+0x8e>
					cputchar(c);
  800ba3:	83 ec 0c             	sub    $0xc,%esp
  800ba6:	ff 75 ec             	pushl  -0x14(%ebp)
  800ba9:	e8 7b 27 00 00       	call   803329 <cputchar>
  800bae:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bb4:	8d 50 01             	lea    0x1(%eax),%edx
  800bb7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800bba:	89 c2                	mov    %eax,%edx
  800bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbf:	01 d0                	add    %edx,%eax
  800bc1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800bc4:	88 10                	mov    %dl,(%eax)
  800bc6:	eb 56                	jmp    800c1e <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800bc8:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800bcc:	75 1f                	jne    800bed <atomic_readline+0xca>
  800bce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800bd2:	7e 19                	jle    800bed <atomic_readline+0xca>
				if (echoing)
  800bd4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bd8:	74 0e                	je     800be8 <atomic_readline+0xc5>
					cputchar(c);
  800bda:	83 ec 0c             	sub    $0xc,%esp
  800bdd:	ff 75 ec             	pushl  -0x14(%ebp)
  800be0:	e8 44 27 00 00       	call   803329 <cputchar>
  800be5:	83 c4 10             	add    $0x10,%esp
				i--;
  800be8:	ff 4d f4             	decl   -0xc(%ebp)
  800beb:	eb 31                	jmp    800c1e <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800bed:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800bf1:	74 0a                	je     800bfd <atomic_readline+0xda>
  800bf3:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800bf7:	0f 85 61 ff ff ff    	jne    800b5e <atomic_readline+0x3b>
				if (echoing)
  800bfd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c01:	74 0e                	je     800c11 <atomic_readline+0xee>
					cputchar(c);
  800c03:	83 ec 0c             	sub    $0xc,%esp
  800c06:	ff 75 ec             	pushl  -0x14(%ebp)
  800c09:	e8 1b 27 00 00       	call   803329 <cputchar>
  800c0e:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800c11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c17:	01 d0                	add    %edx,%eax
  800c19:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800c1c:	eb 06                	jmp    800c24 <atomic_readline+0x101>
			}
		}
  800c1e:	e9 3b ff ff ff       	jmp    800b5e <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800c23:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800c24:	e8 5b 0e 00 00       	call   801a84 <sys_unlock_cons>
}
  800c29:	90                   	nop
  800c2a:	c9                   	leave  
  800c2b:	c3                   	ret    

00800c2c <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c39:	eb 06                	jmp    800c41 <strlen+0x15>
		n++;
  800c3b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c3e:	ff 45 08             	incl   0x8(%ebp)
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	8a 00                	mov    (%eax),%al
  800c46:	84 c0                	test   %al,%al
  800c48:	75 f1                	jne    800c3b <strlen+0xf>
		n++;
	return n;
  800c4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c4d:	c9                   	leave  
  800c4e:	c3                   	ret    

00800c4f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c5c:	eb 09                	jmp    800c67 <strnlen+0x18>
		n++;
  800c5e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c61:	ff 45 08             	incl   0x8(%ebp)
  800c64:	ff 4d 0c             	decl   0xc(%ebp)
  800c67:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c6b:	74 09                	je     800c76 <strnlen+0x27>
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	8a 00                	mov    (%eax),%al
  800c72:	84 c0                	test   %al,%al
  800c74:	75 e8                	jne    800c5e <strnlen+0xf>
		n++;
	return n;
  800c76:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c79:	c9                   	leave  
  800c7a:	c3                   	ret    

00800c7b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c81:	8b 45 08             	mov    0x8(%ebp),%eax
  800c84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c87:	90                   	nop
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	8d 50 01             	lea    0x1(%eax),%edx
  800c8e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c91:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c94:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c97:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c9a:	8a 12                	mov    (%edx),%dl
  800c9c:	88 10                	mov    %dl,(%eax)
  800c9e:	8a 00                	mov    (%eax),%al
  800ca0:	84 c0                	test   %al,%al
  800ca2:	75 e4                	jne    800c88 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ca4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ca7:	c9                   	leave  
  800ca8:	c3                   	ret    

00800ca9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cbc:	eb 1f                	jmp    800cdd <strncpy+0x34>
		*dst++ = *src;
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8d 50 01             	lea    0x1(%eax),%edx
  800cc4:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cca:	8a 12                	mov    (%edx),%dl
  800ccc:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd1:	8a 00                	mov    (%eax),%al
  800cd3:	84 c0                	test   %al,%al
  800cd5:	74 03                	je     800cda <strncpy+0x31>
			src++;
  800cd7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cda:	ff 45 fc             	incl   -0x4(%ebp)
  800cdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ce3:	72 d9                	jb     800cbe <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ce5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ce8:	c9                   	leave  
  800ce9:	c3                   	ret    

00800cea <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cf6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cfa:	74 30                	je     800d2c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cfc:	eb 16                	jmp    800d14 <strlcpy+0x2a>
			*dst++ = *src++;
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	8d 50 01             	lea    0x1(%eax),%edx
  800d04:	89 55 08             	mov    %edx,0x8(%ebp)
  800d07:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d0d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d10:	8a 12                	mov    (%edx),%dl
  800d12:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d14:	ff 4d 10             	decl   0x10(%ebp)
  800d17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1b:	74 09                	je     800d26 <strlcpy+0x3c>
  800d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d20:	8a 00                	mov    (%eax),%al
  800d22:	84 c0                	test   %al,%al
  800d24:	75 d8                	jne    800cfe <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d32:	29 c2                	sub    %eax,%edx
  800d34:	89 d0                	mov    %edx,%eax
}
  800d36:	c9                   	leave  
  800d37:	c3                   	ret    

00800d38 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d3b:	eb 06                	jmp    800d43 <strcmp+0xb>
		p++, q++;
  800d3d:	ff 45 08             	incl   0x8(%ebp)
  800d40:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	84 c0                	test   %al,%al
  800d4a:	74 0e                	je     800d5a <strcmp+0x22>
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8a 10                	mov    (%eax),%dl
  800d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d54:	8a 00                	mov    (%eax),%al
  800d56:	38 c2                	cmp    %al,%dl
  800d58:	74 e3                	je     800d3d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	8a 00                	mov    (%eax),%al
  800d5f:	0f b6 d0             	movzbl %al,%edx
  800d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	0f b6 c0             	movzbl %al,%eax
  800d6a:	29 c2                	sub    %eax,%edx
  800d6c:	89 d0                	mov    %edx,%eax
}
  800d6e:	5d                   	pop    %ebp
  800d6f:	c3                   	ret    

00800d70 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d73:	eb 09                	jmp    800d7e <strncmp+0xe>
		n--, p++, q++;
  800d75:	ff 4d 10             	decl   0x10(%ebp)
  800d78:	ff 45 08             	incl   0x8(%ebp)
  800d7b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d82:	74 17                	je     800d9b <strncmp+0x2b>
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	8a 00                	mov    (%eax),%al
  800d89:	84 c0                	test   %al,%al
  800d8b:	74 0e                	je     800d9b <strncmp+0x2b>
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	8a 10                	mov    (%eax),%dl
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	38 c2                	cmp    %al,%dl
  800d99:	74 da                	je     800d75 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d9b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d9f:	75 07                	jne    800da8 <strncmp+0x38>
		return 0;
  800da1:	b8 00 00 00 00       	mov    $0x0,%eax
  800da6:	eb 14                	jmp    800dbc <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	0f b6 d0             	movzbl %al,%edx
  800db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db3:	8a 00                	mov    (%eax),%al
  800db5:	0f b6 c0             	movzbl %al,%eax
  800db8:	29 c2                	sub    %eax,%edx
  800dba:	89 d0                	mov    %edx,%eax
}
  800dbc:	5d                   	pop    %ebp
  800dbd:	c3                   	ret    

00800dbe <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
  800dc1:	83 ec 04             	sub    $0x4,%esp
  800dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dca:	eb 12                	jmp    800dde <strchr+0x20>
		if (*s == c)
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dd4:	75 05                	jne    800ddb <strchr+0x1d>
			return (char *) s;
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd9:	eb 11                	jmp    800dec <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ddb:	ff 45 08             	incl   0x8(%ebp)
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	8a 00                	mov    (%eax),%al
  800de3:	84 c0                	test   %al,%al
  800de5:	75 e5                	jne    800dcc <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800de7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dec:	c9                   	leave  
  800ded:	c3                   	ret    

00800dee <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	83 ec 04             	sub    $0x4,%esp
  800df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dfa:	eb 0d                	jmp    800e09 <strfind+0x1b>
		if (*s == c)
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e04:	74 0e                	je     800e14 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e06:	ff 45 08             	incl   0x8(%ebp)
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	84 c0                	test   %al,%al
  800e10:	75 ea                	jne    800dfc <strfind+0xe>
  800e12:	eb 01                	jmp    800e15 <strfind+0x27>
		if (*s == c)
			break;
  800e14:	90                   	nop
	return (char *) s;
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e18:	c9                   	leave  
  800e19:	c3                   	ret    

00800e1a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e26:	8b 45 10             	mov    0x10(%ebp),%eax
  800e29:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e2c:	eb 0e                	jmp    800e3c <memset+0x22>
		*p++ = c;
  800e2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e31:	8d 50 01             	lea    0x1(%eax),%edx
  800e34:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e3c:	ff 4d f8             	decl   -0x8(%ebp)
  800e3f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e43:	79 e9                	jns    800e2e <memset+0x14>
		*p++ = c;

	return v;
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e48:	c9                   	leave  
  800e49:	c3                   	ret    

00800e4a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e5c:	eb 16                	jmp    800e74 <memcpy+0x2a>
		*d++ = *s++;
  800e5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e61:	8d 50 01             	lea    0x1(%eax),%edx
  800e64:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e67:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e6a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e6d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e70:	8a 12                	mov    (%edx),%dl
  800e72:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e74:	8b 45 10             	mov    0x10(%ebp),%eax
  800e77:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e7a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e7d:	85 c0                	test   %eax,%eax
  800e7f:	75 dd                	jne    800e5e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e84:	c9                   	leave  
  800e85:	c3                   	ret    

00800e86 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e92:	8b 45 08             	mov    0x8(%ebp),%eax
  800e95:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e9e:	73 50                	jae    800ef0 <memmove+0x6a>
  800ea0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea6:	01 d0                	add    %edx,%eax
  800ea8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eab:	76 43                	jbe    800ef0 <memmove+0x6a>
		s += n;
  800ead:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800eb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eb9:	eb 10                	jmp    800ecb <memmove+0x45>
			*--d = *--s;
  800ebb:	ff 4d f8             	decl   -0x8(%ebp)
  800ebe:	ff 4d fc             	decl   -0x4(%ebp)
  800ec1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec4:	8a 10                	mov    (%eax),%dl
  800ec6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ecb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ece:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed4:	85 c0                	test   %eax,%eax
  800ed6:	75 e3                	jne    800ebb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ed8:	eb 23                	jmp    800efd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800eda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800edd:	8d 50 01             	lea    0x1(%eax),%edx
  800ee0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eec:	8a 12                	mov    (%edx),%dl
  800eee:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ef0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef6:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef9:	85 c0                	test   %eax,%eax
  800efb:	75 dd                	jne    800eda <memmove+0x54>
			*d++ = *s++;

	return dst;
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f00:	c9                   	leave  
  800f01:	c3                   	ret    

00800f02 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f02:	55                   	push   %ebp
  800f03:	89 e5                	mov    %esp,%ebp
  800f05:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f11:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f14:	eb 2a                	jmp    800f40 <memcmp+0x3e>
		if (*s1 != *s2)
  800f16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f19:	8a 10                	mov    (%eax),%dl
  800f1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1e:	8a 00                	mov    (%eax),%al
  800f20:	38 c2                	cmp    %al,%dl
  800f22:	74 16                	je     800f3a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f27:	8a 00                	mov    (%eax),%al
  800f29:	0f b6 d0             	movzbl %al,%edx
  800f2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	0f b6 c0             	movzbl %al,%eax
  800f34:	29 c2                	sub    %eax,%edx
  800f36:	89 d0                	mov    %edx,%eax
  800f38:	eb 18                	jmp    800f52 <memcmp+0x50>
		s1++, s2++;
  800f3a:	ff 45 fc             	incl   -0x4(%ebp)
  800f3d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f40:	8b 45 10             	mov    0x10(%ebp),%eax
  800f43:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f46:	89 55 10             	mov    %edx,0x10(%ebp)
  800f49:	85 c0                	test   %eax,%eax
  800f4b:	75 c9                	jne    800f16 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f52:	c9                   	leave  
  800f53:	c3                   	ret    

00800f54 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f54:	55                   	push   %ebp
  800f55:	89 e5                	mov    %esp,%ebp
  800f57:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f60:	01 d0                	add    %edx,%eax
  800f62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f65:	eb 15                	jmp    800f7c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	8a 00                	mov    (%eax),%al
  800f6c:	0f b6 d0             	movzbl %al,%edx
  800f6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f72:	0f b6 c0             	movzbl %al,%eax
  800f75:	39 c2                	cmp    %eax,%edx
  800f77:	74 0d                	je     800f86 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f79:	ff 45 08             	incl   0x8(%ebp)
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f82:	72 e3                	jb     800f67 <memfind+0x13>
  800f84:	eb 01                	jmp    800f87 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f86:	90                   	nop
	return (void *) s;
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f8a:	c9                   	leave  
  800f8b:	c3                   	ret    

00800f8c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f99:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fa0:	eb 03                	jmp    800fa5 <strtol+0x19>
		s++;
  800fa2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	3c 20                	cmp    $0x20,%al
  800fac:	74 f4                	je     800fa2 <strtol+0x16>
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	3c 09                	cmp    $0x9,%al
  800fb5:	74 eb                	je     800fa2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	3c 2b                	cmp    $0x2b,%al
  800fbe:	75 05                	jne    800fc5 <strtol+0x39>
		s++;
  800fc0:	ff 45 08             	incl   0x8(%ebp)
  800fc3:	eb 13                	jmp    800fd8 <strtol+0x4c>
	else if (*s == '-')
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	8a 00                	mov    (%eax),%al
  800fca:	3c 2d                	cmp    $0x2d,%al
  800fcc:	75 0a                	jne    800fd8 <strtol+0x4c>
		s++, neg = 1;
  800fce:	ff 45 08             	incl   0x8(%ebp)
  800fd1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fd8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fdc:	74 06                	je     800fe4 <strtol+0x58>
  800fde:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fe2:	75 20                	jne    801004 <strtol+0x78>
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	3c 30                	cmp    $0x30,%al
  800feb:	75 17                	jne    801004 <strtol+0x78>
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	40                   	inc    %eax
  800ff1:	8a 00                	mov    (%eax),%al
  800ff3:	3c 78                	cmp    $0x78,%al
  800ff5:	75 0d                	jne    801004 <strtol+0x78>
		s += 2, base = 16;
  800ff7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ffb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801002:	eb 28                	jmp    80102c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801004:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801008:	75 15                	jne    80101f <strtol+0x93>
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	3c 30                	cmp    $0x30,%al
  801011:	75 0c                	jne    80101f <strtol+0x93>
		s++, base = 8;
  801013:	ff 45 08             	incl   0x8(%ebp)
  801016:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80101d:	eb 0d                	jmp    80102c <strtol+0xa0>
	else if (base == 0)
  80101f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801023:	75 07                	jne    80102c <strtol+0xa0>
		base = 10;
  801025:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	3c 2f                	cmp    $0x2f,%al
  801033:	7e 19                	jle    80104e <strtol+0xc2>
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	3c 39                	cmp    $0x39,%al
  80103c:	7f 10                	jg     80104e <strtol+0xc2>
			dig = *s - '0';
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	0f be c0             	movsbl %al,%eax
  801046:	83 e8 30             	sub    $0x30,%eax
  801049:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80104c:	eb 42                	jmp    801090 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
  801051:	8a 00                	mov    (%eax),%al
  801053:	3c 60                	cmp    $0x60,%al
  801055:	7e 19                	jle    801070 <strtol+0xe4>
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	8a 00                	mov    (%eax),%al
  80105c:	3c 7a                	cmp    $0x7a,%al
  80105e:	7f 10                	jg     801070 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	8a 00                	mov    (%eax),%al
  801065:	0f be c0             	movsbl %al,%eax
  801068:	83 e8 57             	sub    $0x57,%eax
  80106b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80106e:	eb 20                	jmp    801090 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	8a 00                	mov    (%eax),%al
  801075:	3c 40                	cmp    $0x40,%al
  801077:	7e 39                	jle    8010b2 <strtol+0x126>
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	3c 5a                	cmp    $0x5a,%al
  801080:	7f 30                	jg     8010b2 <strtol+0x126>
			dig = *s - 'A' + 10;
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	0f be c0             	movsbl %al,%eax
  80108a:	83 e8 37             	sub    $0x37,%eax
  80108d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801093:	3b 45 10             	cmp    0x10(%ebp),%eax
  801096:	7d 19                	jge    8010b1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801098:	ff 45 08             	incl   0x8(%ebp)
  80109b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109e:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010a2:	89 c2                	mov    %eax,%edx
  8010a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010a7:	01 d0                	add    %edx,%eax
  8010a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010ac:	e9 7b ff ff ff       	jmp    80102c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010b1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010b6:	74 08                	je     8010c0 <strtol+0x134>
		*endptr = (char *) s;
  8010b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010be:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010c4:	74 07                	je     8010cd <strtol+0x141>
  8010c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c9:	f7 d8                	neg    %eax
  8010cb:	eb 03                	jmp    8010d0 <strtol+0x144>
  8010cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010d0:	c9                   	leave  
  8010d1:	c3                   	ret    

008010d2 <ltostr>:

void
ltostr(long value, char *str)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010ea:	79 13                	jns    8010ff <ltostr+0x2d>
	{
		neg = 1;
  8010ec:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010f9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010fc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801102:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801107:	99                   	cltd   
  801108:	f7 f9                	idiv   %ecx
  80110a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80110d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801110:	8d 50 01             	lea    0x1(%eax),%edx
  801113:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801116:	89 c2                	mov    %eax,%edx
  801118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111b:	01 d0                	add    %edx,%eax
  80111d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801120:	83 c2 30             	add    $0x30,%edx
  801123:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801125:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801128:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80112d:	f7 e9                	imul   %ecx
  80112f:	c1 fa 02             	sar    $0x2,%edx
  801132:	89 c8                	mov    %ecx,%eax
  801134:	c1 f8 1f             	sar    $0x1f,%eax
  801137:	29 c2                	sub    %eax,%edx
  801139:	89 d0                	mov    %edx,%eax
  80113b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80113e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801142:	75 bb                	jne    8010ff <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801144:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80114b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80114e:	48                   	dec    %eax
  80114f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801152:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801156:	74 3d                	je     801195 <ltostr+0xc3>
		start = 1 ;
  801158:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80115f:	eb 34                	jmp    801195 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801161:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801164:	8b 45 0c             	mov    0xc(%ebp),%eax
  801167:	01 d0                	add    %edx,%eax
  801169:	8a 00                	mov    (%eax),%al
  80116b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80116e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801171:	8b 45 0c             	mov    0xc(%ebp),%eax
  801174:	01 c2                	add    %eax,%edx
  801176:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117c:	01 c8                	add    %ecx,%eax
  80117e:	8a 00                	mov    (%eax),%al
  801180:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801182:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801185:	8b 45 0c             	mov    0xc(%ebp),%eax
  801188:	01 c2                	add    %eax,%edx
  80118a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80118d:	88 02                	mov    %al,(%edx)
		start++ ;
  80118f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801192:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801198:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80119b:	7c c4                	jl     801161 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80119d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a3:	01 d0                	add    %edx,%eax
  8011a5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011a8:	90                   	nop
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011b1:	ff 75 08             	pushl  0x8(%ebp)
  8011b4:	e8 73 fa ff ff       	call   800c2c <strlen>
  8011b9:	83 c4 04             	add    $0x4,%esp
  8011bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011bf:	ff 75 0c             	pushl  0xc(%ebp)
  8011c2:	e8 65 fa ff ff       	call   800c2c <strlen>
  8011c7:	83 c4 04             	add    $0x4,%esp
  8011ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011db:	eb 17                	jmp    8011f4 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e3:	01 c2                	add    %eax,%edx
  8011e5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	01 c8                	add    %ecx,%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011f1:	ff 45 fc             	incl   -0x4(%ebp)
  8011f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011fa:	7c e1                	jl     8011dd <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011fc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801203:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80120a:	eb 1f                	jmp    80122b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80120c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80120f:	8d 50 01             	lea    0x1(%eax),%edx
  801212:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801215:	89 c2                	mov    %eax,%edx
  801217:	8b 45 10             	mov    0x10(%ebp),%eax
  80121a:	01 c2                	add    %eax,%edx
  80121c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80121f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801222:	01 c8                	add    %ecx,%eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801228:	ff 45 f8             	incl   -0x8(%ebp)
  80122b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80122e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801231:	7c d9                	jl     80120c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801233:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801236:	8b 45 10             	mov    0x10(%ebp),%eax
  801239:	01 d0                	add    %edx,%eax
  80123b:	c6 00 00             	movb   $0x0,(%eax)
}
  80123e:	90                   	nop
  80123f:	c9                   	leave  
  801240:	c3                   	ret    

00801241 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801241:	55                   	push   %ebp
  801242:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801244:	8b 45 14             	mov    0x14(%ebp),%eax
  801247:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80124d:	8b 45 14             	mov    0x14(%ebp),%eax
  801250:	8b 00                	mov    (%eax),%eax
  801252:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801259:	8b 45 10             	mov    0x10(%ebp),%eax
  80125c:	01 d0                	add    %edx,%eax
  80125e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801264:	eb 0c                	jmp    801272 <strsplit+0x31>
			*string++ = 0;
  801266:	8b 45 08             	mov    0x8(%ebp),%eax
  801269:	8d 50 01             	lea    0x1(%eax),%edx
  80126c:	89 55 08             	mov    %edx,0x8(%ebp)
  80126f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	84 c0                	test   %al,%al
  801279:	74 18                	je     801293 <strsplit+0x52>
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	8a 00                	mov    (%eax),%al
  801280:	0f be c0             	movsbl %al,%eax
  801283:	50                   	push   %eax
  801284:	ff 75 0c             	pushl  0xc(%ebp)
  801287:	e8 32 fb ff ff       	call   800dbe <strchr>
  80128c:	83 c4 08             	add    $0x8,%esp
  80128f:	85 c0                	test   %eax,%eax
  801291:	75 d3                	jne    801266 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801293:	8b 45 08             	mov    0x8(%ebp),%eax
  801296:	8a 00                	mov    (%eax),%al
  801298:	84 c0                	test   %al,%al
  80129a:	74 5a                	je     8012f6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80129c:	8b 45 14             	mov    0x14(%ebp),%eax
  80129f:	8b 00                	mov    (%eax),%eax
  8012a1:	83 f8 0f             	cmp    $0xf,%eax
  8012a4:	75 07                	jne    8012ad <strsplit+0x6c>
		{
			return 0;
  8012a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ab:	eb 66                	jmp    801313 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b0:	8b 00                	mov    (%eax),%eax
  8012b2:	8d 48 01             	lea    0x1(%eax),%ecx
  8012b5:	8b 55 14             	mov    0x14(%ebp),%edx
  8012b8:	89 0a                	mov    %ecx,(%edx)
  8012ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c4:	01 c2                	add    %eax,%edx
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012cb:	eb 03                	jmp    8012d0 <strsplit+0x8f>
			string++;
  8012cd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	84 c0                	test   %al,%al
  8012d7:	74 8b                	je     801264 <strsplit+0x23>
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	0f be c0             	movsbl %al,%eax
  8012e1:	50                   	push   %eax
  8012e2:	ff 75 0c             	pushl  0xc(%ebp)
  8012e5:	e8 d4 fa ff ff       	call   800dbe <strchr>
  8012ea:	83 c4 08             	add    $0x8,%esp
  8012ed:	85 c0                	test   %eax,%eax
  8012ef:	74 dc                	je     8012cd <strsplit+0x8c>
			string++;
	}
  8012f1:	e9 6e ff ff ff       	jmp    801264 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012f6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fa:	8b 00                	mov    (%eax),%eax
  8012fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801303:	8b 45 10             	mov    0x10(%ebp),%eax
  801306:	01 d0                	add    %edx,%eax
  801308:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80130e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
  801318:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80131b:	83 ec 04             	sub    $0x4,%esp
  80131e:	68 9c 3c 80 00       	push   $0x803c9c
  801323:	68 3f 01 00 00       	push   $0x13f
  801328:	68 be 3c 80 00       	push   $0x803cbe
  80132d:	e8 33 20 00 00       	call   803365 <_panic>

00801332 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
  801335:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801338:	83 ec 0c             	sub    $0xc,%esp
  80133b:	ff 75 08             	pushl  0x8(%ebp)
  80133e:	e8 90 0c 00 00       	call   801fd3 <sys_sbrk>
  801343:	83 c4 10             	add    $0x10,%esp
}
  801346:	c9                   	leave  
  801347:	c3                   	ret    

00801348 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
  80134b:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  80134e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801352:	75 0a                	jne    80135e <malloc+0x16>
		return NULL;
  801354:	b8 00 00 00 00       	mov    $0x0,%eax
  801359:	e9 9e 01 00 00       	jmp    8014fc <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  80135e:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801365:	77 2c                	ja     801393 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801367:	e8 eb 0a 00 00       	call   801e57 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80136c:	85 c0                	test   %eax,%eax
  80136e:	74 19                	je     801389 <malloc+0x41>

			void * block = alloc_block_FF(size);
  801370:	83 ec 0c             	sub    $0xc,%esp
  801373:	ff 75 08             	pushl  0x8(%ebp)
  801376:	e8 85 11 00 00       	call   802500 <alloc_block_FF>
  80137b:	83 c4 10             	add    $0x10,%esp
  80137e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  801381:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801384:	e9 73 01 00 00       	jmp    8014fc <malloc+0x1b4>
		} else {
			return NULL;
  801389:	b8 00 00 00 00       	mov    $0x0,%eax
  80138e:	e9 69 01 00 00       	jmp    8014fc <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801393:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80139a:	8b 55 08             	mov    0x8(%ebp),%edx
  80139d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013a0:	01 d0                	add    %edx,%eax
  8013a2:	48                   	dec    %eax
  8013a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ae:	f7 75 e0             	divl   -0x20(%ebp)
  8013b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013b4:	29 d0                	sub    %edx,%eax
  8013b6:	c1 e8 0c             	shr    $0xc,%eax
  8013b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  8013bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8013c3:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8013ca:	a1 20 40 80 00       	mov    0x804020,%eax
  8013cf:	8b 40 7c             	mov    0x7c(%eax),%eax
  8013d2:	05 00 10 00 00       	add    $0x1000,%eax
  8013d7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  8013da:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8013df:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8013e2:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  8013e5:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8013ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8013f2:	01 d0                	add    %edx,%eax
  8013f4:	48                   	dec    %eax
  8013f5:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8013f8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8013fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801400:	f7 75 cc             	divl   -0x34(%ebp)
  801403:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801406:	29 d0                	sub    %edx,%eax
  801408:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80140b:	76 0a                	jbe    801417 <malloc+0xcf>
		return NULL;
  80140d:	b8 00 00 00 00       	mov    $0x0,%eax
  801412:	e9 e5 00 00 00       	jmp    8014fc <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801417:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80141a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80141d:	eb 48                	jmp    801467 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  80141f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801422:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801425:	c1 e8 0c             	shr    $0xc,%eax
  801428:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  80142b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80142e:	8b 04 85 40 40 90 00 	mov    0x904040(,%eax,4),%eax
  801435:	85 c0                	test   %eax,%eax
  801437:	75 11                	jne    80144a <malloc+0x102>
			freePagesCount++;
  801439:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  80143c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801440:	75 16                	jne    801458 <malloc+0x110>
				start = i;
  801442:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801445:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801448:	eb 0e                	jmp    801458 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  80144a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801451:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80145e:	74 12                	je     801472 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801460:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801467:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80146e:	76 af                	jbe    80141f <malloc+0xd7>
  801470:	eb 01                	jmp    801473 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  801472:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  801473:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801477:	74 08                	je     801481 <malloc+0x139>
  801479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80147f:	74 07                	je     801488 <malloc+0x140>
		return NULL;
  801481:	b8 00 00 00 00       	mov    $0x0,%eax
  801486:	eb 74                	jmp    8014fc <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801488:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148b:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80148e:	c1 e8 0c             	shr    $0xc,%eax
  801491:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801494:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801497:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80149a:	89 14 85 40 40 80 00 	mov    %edx,0x804040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  8014a1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8014a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8014a7:	eb 11                	jmp    8014ba <malloc+0x172>
		markedPages[i] = 1;
  8014a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014ac:	c7 04 85 40 40 90 00 	movl   $0x1,0x904040(,%eax,4)
  8014b3:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  8014b7:	ff 45 e8             	incl   -0x18(%ebp)
  8014ba:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8014bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014c0:	01 d0                	add    %edx,%eax
  8014c2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8014c5:	77 e2                	ja     8014a9 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  8014c7:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8014ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8014d4:	01 d0                	add    %edx,%eax
  8014d6:	48                   	dec    %eax
  8014d7:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8014da:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8014dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e2:	f7 75 bc             	divl   -0x44(%ebp)
  8014e5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8014e8:	29 d0                	sub    %edx,%eax
  8014ea:	83 ec 08             	sub    $0x8,%esp
  8014ed:	50                   	push   %eax
  8014ee:	ff 75 f0             	pushl  -0x10(%ebp)
  8014f1:	e8 14 0b 00 00       	call   80200a <sys_allocate_user_mem>
  8014f6:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  8014f9:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
  801501:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801504:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801508:	0f 84 ee 00 00 00    	je     8015fc <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  80150e:	a1 20 40 80 00       	mov    0x804020,%eax
  801513:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801516:	3b 45 08             	cmp    0x8(%ebp),%eax
  801519:	77 09                	ja     801524 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  80151b:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801522:	76 14                	jbe    801538 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801524:	83 ec 04             	sub    $0x4,%esp
  801527:	68 cc 3c 80 00       	push   $0x803ccc
  80152c:	6a 68                	push   $0x68
  80152e:	68 e6 3c 80 00       	push   $0x803ce6
  801533:	e8 2d 1e 00 00       	call   803365 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  801538:	a1 20 40 80 00       	mov    0x804020,%eax
  80153d:	8b 40 74             	mov    0x74(%eax),%eax
  801540:	3b 45 08             	cmp    0x8(%ebp),%eax
  801543:	77 20                	ja     801565 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801545:	a1 20 40 80 00       	mov    0x804020,%eax
  80154a:	8b 40 78             	mov    0x78(%eax),%eax
  80154d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801550:	76 13                	jbe    801565 <free+0x67>
		free_block(virtual_address);
  801552:	83 ec 0c             	sub    $0xc,%esp
  801555:	ff 75 08             	pushl  0x8(%ebp)
  801558:	e8 6c 16 00 00       	call   802bc9 <free_block>
  80155d:	83 c4 10             	add    $0x10,%esp
		return;
  801560:	e9 98 00 00 00       	jmp    8015fd <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801565:	8b 55 08             	mov    0x8(%ebp),%edx
  801568:	a1 20 40 80 00       	mov    0x804020,%eax
  80156d:	8b 40 7c             	mov    0x7c(%eax),%eax
  801570:	29 c2                	sub    %eax,%edx
  801572:	89 d0                	mov    %edx,%eax
  801574:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801579:	c1 e8 0c             	shr    $0xc,%eax
  80157c:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  80157f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801586:	eb 16                	jmp    80159e <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801588:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80158b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80158e:	01 d0                	add    %edx,%eax
  801590:	c7 04 85 40 40 90 00 	movl   $0x0,0x904040(,%eax,4)
  801597:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  80159b:	ff 45 f4             	incl   -0xc(%ebp)
  80159e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a1:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  8015a8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015ab:	7f db                	jg     801588 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  8015ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b0:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  8015b7:	c1 e0 0c             	shl    $0xc,%eax
  8015ba:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015c3:	eb 1a                	jmp    8015df <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  8015c5:	83 ec 08             	sub    $0x8,%esp
  8015c8:	68 00 10 00 00       	push   $0x1000
  8015cd:	ff 75 f0             	pushl  -0x10(%ebp)
  8015d0:	e8 19 0a 00 00       	call   801fee <sys_free_user_mem>
  8015d5:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  8015d8:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8015df:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015e5:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  8015e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015ea:	77 d9                	ja     8015c5 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  8015ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ef:	c7 04 85 40 40 80 00 	movl   $0x0,0x804040(,%eax,4)
  8015f6:	00 00 00 00 
  8015fa:	eb 01                	jmp    8015fd <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  8015fc:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 58             	sub    $0x58,%esp
  801605:	8b 45 10             	mov    0x10(%ebp),%eax
  801608:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  80160b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80160f:	75 0a                	jne    80161b <smalloc+0x1c>
		return NULL;
  801611:	b8 00 00 00 00       	mov    $0x0,%eax
  801616:	e9 7d 01 00 00       	jmp    801798 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  80161b:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801622:	8b 55 0c             	mov    0xc(%ebp),%edx
  801625:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801628:	01 d0                	add    %edx,%eax
  80162a:	48                   	dec    %eax
  80162b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80162e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801631:	ba 00 00 00 00       	mov    $0x0,%edx
  801636:	f7 75 e4             	divl   -0x1c(%ebp)
  801639:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80163c:	29 d0                	sub    %edx,%eax
  80163e:	c1 e8 0c             	shr    $0xc,%eax
  801641:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801644:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  80164b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801652:	a1 20 40 80 00       	mov    0x804020,%eax
  801657:	8b 40 7c             	mov    0x7c(%eax),%eax
  80165a:	05 00 10 00 00       	add    $0x1000,%eax
  80165f:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801662:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801667:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80166a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  80166d:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801674:	8b 55 0c             	mov    0xc(%ebp),%edx
  801677:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80167a:	01 d0                	add    %edx,%eax
  80167c:	48                   	dec    %eax
  80167d:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801680:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801683:	ba 00 00 00 00       	mov    $0x0,%edx
  801688:	f7 75 d0             	divl   -0x30(%ebp)
  80168b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80168e:	29 d0                	sub    %edx,%eax
  801690:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801693:	76 0a                	jbe    80169f <smalloc+0xa0>
		return NULL;
  801695:	b8 00 00 00 00       	mov    $0x0,%eax
  80169a:	e9 f9 00 00 00       	jmp    801798 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80169f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016a5:	eb 48                	jmp    8016ef <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  8016a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016aa:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8016ad:	c1 e8 0c             	shr    $0xc,%eax
  8016b0:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  8016b3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8016b6:	8b 04 85 40 40 90 00 	mov    0x904040(,%eax,4),%eax
  8016bd:	85 c0                	test   %eax,%eax
  8016bf:	75 11                	jne    8016d2 <smalloc+0xd3>
			freePagesCount++;
  8016c1:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8016c4:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8016c8:	75 16                	jne    8016e0 <smalloc+0xe1>
				start = s;
  8016ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016d0:	eb 0e                	jmp    8016e0 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  8016d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8016d9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  8016e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8016e6:	74 12                	je     8016fa <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8016e8:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8016ef:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8016f6:	76 af                	jbe    8016a7 <smalloc+0xa8>
  8016f8:	eb 01                	jmp    8016fb <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  8016fa:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  8016fb:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8016ff:	74 08                	je     801709 <smalloc+0x10a>
  801701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801704:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801707:	74 0a                	je     801713 <smalloc+0x114>
		return NULL;
  801709:	b8 00 00 00 00       	mov    $0x0,%eax
  80170e:	e9 85 00 00 00       	jmp    801798 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801716:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801719:	c1 e8 0c             	shr    $0xc,%eax
  80171c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  80171f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801722:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801725:	89 14 85 40 40 80 00 	mov    %edx,0x804040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  80172c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80172f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801732:	eb 11                	jmp    801745 <smalloc+0x146>
		markedPages[s] = 1;
  801734:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801737:	c7 04 85 40 40 90 00 	movl   $0x1,0x904040(,%eax,4)
  80173e:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801742:	ff 45 e8             	incl   -0x18(%ebp)
  801745:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801748:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80174b:	01 d0                	add    %edx,%eax
  80174d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801750:	77 e2                	ja     801734 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  801752:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801755:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801759:	52                   	push   %edx
  80175a:	50                   	push   %eax
  80175b:	ff 75 0c             	pushl  0xc(%ebp)
  80175e:	ff 75 08             	pushl  0x8(%ebp)
  801761:	e8 8f 04 00 00       	call   801bf5 <sys_createSharedObject>
  801766:	83 c4 10             	add    $0x10,%esp
  801769:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  80176c:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  801770:	78 12                	js     801784 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  801772:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801775:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801778:	89 14 85 40 40 88 00 	mov    %edx,0x884040(,%eax,4)
		return (void*) start;
  80177f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801782:	eb 14                	jmp    801798 <smalloc+0x199>
	}
	free((void*) start);
  801784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801787:	83 ec 0c             	sub    $0xc,%esp
  80178a:	50                   	push   %eax
  80178b:	e8 6e fd ff ff       	call   8014fe <free>
  801790:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801793:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  8017a0:	83 ec 08             	sub    $0x8,%esp
  8017a3:	ff 75 0c             	pushl  0xc(%ebp)
  8017a6:	ff 75 08             	pushl  0x8(%ebp)
  8017a9:	e8 71 04 00 00       	call   801c1f <sys_getSizeOfSharedObject>
  8017ae:	83 c4 10             	add    $0x10,%esp
  8017b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8017b4:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8017bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017c1:	01 d0                	add    %edx,%eax
  8017c3:	48                   	dec    %eax
  8017c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8017c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8017cf:	f7 75 e0             	divl   -0x20(%ebp)
  8017d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017d5:	29 d0                	sub    %edx,%eax
  8017d7:	c1 e8 0c             	shr    $0xc,%eax
  8017da:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  8017dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8017e4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  8017eb:	a1 20 40 80 00       	mov    0x804020,%eax
  8017f0:	8b 40 7c             	mov    0x7c(%eax),%eax
  8017f3:	05 00 10 00 00       	add    $0x1000,%eax
  8017f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  8017fb:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801800:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801803:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801806:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80180d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801810:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801813:	01 d0                	add    %edx,%eax
  801815:	48                   	dec    %eax
  801816:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801819:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80181c:	ba 00 00 00 00       	mov    $0x0,%edx
  801821:	f7 75 cc             	divl   -0x34(%ebp)
  801824:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801827:	29 d0                	sub    %edx,%eax
  801829:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80182c:	76 0a                	jbe    801838 <sget+0x9e>
		return NULL;
  80182e:	b8 00 00 00 00       	mov    $0x0,%eax
  801833:	e9 f7 00 00 00       	jmp    80192f <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801838:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80183b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80183e:	eb 48                	jmp    801888 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  801840:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801843:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801846:	c1 e8 0c             	shr    $0xc,%eax
  801849:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  80184c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80184f:	8b 04 85 40 40 90 00 	mov    0x904040(,%eax,4),%eax
  801856:	85 c0                	test   %eax,%eax
  801858:	75 11                	jne    80186b <sget+0xd1>
			free_Pages_Count++;
  80185a:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  80185d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801861:	75 16                	jne    801879 <sget+0xdf>
				start = s;
  801863:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801866:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801869:	eb 0e                	jmp    801879 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  80186b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801872:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  801879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80187f:	74 12                	je     801893 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801881:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801888:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80188f:	76 af                	jbe    801840 <sget+0xa6>
  801891:	eb 01                	jmp    801894 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  801893:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  801894:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801898:	74 08                	je     8018a2 <sget+0x108>
  80189a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189d:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8018a0:	74 0a                	je     8018ac <sget+0x112>
		return NULL;
  8018a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a7:	e9 83 00 00 00       	jmp    80192f <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  8018ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018af:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8018b2:	c1 e8 0c             	shr    $0xc,%eax
  8018b5:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  8018b8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8018bb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018be:	89 14 85 40 40 80 00 	mov    %edx,0x804040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  8018c5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8018cb:	eb 11                	jmp    8018de <sget+0x144>
		markedPages[k] = 1;
  8018cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018d0:	c7 04 85 40 40 90 00 	movl   $0x1,0x904040(,%eax,4)
  8018d7:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  8018db:	ff 45 e8             	incl   -0x18(%ebp)
  8018de:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8018e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018e4:	01 d0                	add    %edx,%eax
  8018e6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8018e9:	77 e2                	ja     8018cd <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  8018eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ee:	83 ec 04             	sub    $0x4,%esp
  8018f1:	50                   	push   %eax
  8018f2:	ff 75 0c             	pushl  0xc(%ebp)
  8018f5:	ff 75 08             	pushl  0x8(%ebp)
  8018f8:	e8 3f 03 00 00       	call   801c3c <sys_getSharedObject>
  8018fd:	83 c4 10             	add    $0x10,%esp
  801900:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  801903:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  801907:	78 12                	js     80191b <sget+0x181>
		shardIDs[startPage] = ss;
  801909:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80190c:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80190f:	89 14 85 40 40 88 00 	mov    %edx,0x884040(,%eax,4)
		return (void*) start;
  801916:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801919:	eb 14                	jmp    80192f <sget+0x195>
	}
	free((void*) start);
  80191b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191e:	83 ec 0c             	sub    $0xc,%esp
  801921:	50                   	push   %eax
  801922:	e8 d7 fb ff ff       	call   8014fe <free>
  801927:	83 c4 10             	add    $0x10,%esp
	return NULL;
  80192a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801937:	8b 55 08             	mov    0x8(%ebp),%edx
  80193a:	a1 20 40 80 00       	mov    0x804020,%eax
  80193f:	8b 40 7c             	mov    0x7c(%eax),%eax
  801942:	29 c2                	sub    %eax,%edx
  801944:	89 d0                	mov    %edx,%eax
  801946:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  80194b:	c1 e8 0c             	shr    $0xc,%eax
  80194e:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  801951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801954:	8b 04 85 40 40 88 00 	mov    0x884040(,%eax,4),%eax
  80195b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  80195e:	83 ec 08             	sub    $0x8,%esp
  801961:	ff 75 08             	pushl  0x8(%ebp)
  801964:	ff 75 f0             	pushl  -0x10(%ebp)
  801967:	e8 ef 02 00 00       	call   801c5b <sys_freeSharedObject>
  80196c:	83 c4 10             	add    $0x10,%esp
  80196f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  801972:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801976:	75 0e                	jne    801986 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  801978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197b:	c7 04 85 40 40 88 00 	movl   $0xffffffff,0x884040(,%eax,4)
  801982:	ff ff ff ff 
	}

}
  801986:	90                   	nop
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80198f:	83 ec 04             	sub    $0x4,%esp
  801992:	68 f4 3c 80 00       	push   $0x803cf4
  801997:	68 19 01 00 00       	push   $0x119
  80199c:	68 e6 3c 80 00       	push   $0x803ce6
  8019a1:	e8 bf 19 00 00       	call   803365 <_panic>

008019a6 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
  8019a9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019ac:	83 ec 04             	sub    $0x4,%esp
  8019af:	68 1a 3d 80 00       	push   $0x803d1a
  8019b4:	68 23 01 00 00       	push   $0x123
  8019b9:	68 e6 3c 80 00       	push   $0x803ce6
  8019be:	e8 a2 19 00 00       	call   803365 <_panic>

008019c3 <shrink>:

}
void shrink(uint32 newSize) {
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019c9:	83 ec 04             	sub    $0x4,%esp
  8019cc:	68 1a 3d 80 00       	push   $0x803d1a
  8019d1:	68 27 01 00 00       	push   $0x127
  8019d6:	68 e6 3c 80 00       	push   $0x803ce6
  8019db:	e8 85 19 00 00       	call   803365 <_panic>

008019e0 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019e6:	83 ec 04             	sub    $0x4,%esp
  8019e9:	68 1a 3d 80 00       	push   $0x803d1a
  8019ee:	68 2b 01 00 00       	push   $0x12b
  8019f3:	68 e6 3c 80 00       	push   $0x803ce6
  8019f8:	e8 68 19 00 00       	call   803365 <_panic>

008019fd <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	57                   	push   %edi
  801a01:	56                   	push   %esi
  801a02:	53                   	push   %ebx
  801a03:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a06:	8b 45 08             	mov    0x8(%ebp),%eax
  801a09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a0f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a12:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a15:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a18:	cd 30                	int    $0x30
  801a1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a20:	83 c4 10             	add    $0x10,%esp
  801a23:	5b                   	pop    %ebx
  801a24:	5e                   	pop    %esi
  801a25:	5f                   	pop    %edi
  801a26:	5d                   	pop    %ebp
  801a27:	c3                   	ret    

00801a28 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
  801a2b:	83 ec 04             	sub    $0x4,%esp
  801a2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a31:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801a34:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	52                   	push   %edx
  801a40:	ff 75 0c             	pushl  0xc(%ebp)
  801a43:	50                   	push   %eax
  801a44:	6a 00                	push   $0x0
  801a46:	e8 b2 ff ff ff       	call   8019fd <syscall>
  801a4b:	83 c4 18             	add    $0x18,%esp
}
  801a4e:	90                   	nop
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <sys_cgetc>:

int sys_cgetc(void) {
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 02                	push   $0x2
  801a60:	e8 98 ff ff ff       	call   8019fd <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_lock_cons>:

void sys_lock_cons(void) {
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 03                	push   $0x3
  801a79:	e8 7f ff ff ff       	call   8019fd <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
}
  801a81:	90                   	nop
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 04                	push   $0x4
  801a93:	e8 65 ff ff ff       	call   8019fd <syscall>
  801a98:	83 c4 18             	add    $0x18,%esp
}
  801a9b:	90                   	nop
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801aa1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	52                   	push   %edx
  801aae:	50                   	push   %eax
  801aaf:	6a 08                	push   $0x8
  801ab1:	e8 47 ff ff ff       	call   8019fd <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	56                   	push   %esi
  801abf:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801ac0:	8b 75 18             	mov    0x18(%ebp),%esi
  801ac3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ac6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ac9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	56                   	push   %esi
  801ad0:	53                   	push   %ebx
  801ad1:	51                   	push   %ecx
  801ad2:	52                   	push   %edx
  801ad3:	50                   	push   %eax
  801ad4:	6a 09                	push   $0x9
  801ad6:	e8 22 ff ff ff       	call   8019fd <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801ade:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae1:	5b                   	pop    %ebx
  801ae2:	5e                   	pop    %esi
  801ae3:	5d                   	pop    %ebp
  801ae4:	c3                   	ret    

00801ae5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ae8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	52                   	push   %edx
  801af5:	50                   	push   %eax
  801af6:	6a 0a                	push   $0xa
  801af8:	e8 00 ff ff ff       	call   8019fd <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	ff 75 0c             	pushl  0xc(%ebp)
  801b0e:	ff 75 08             	pushl  0x8(%ebp)
  801b11:	6a 0b                	push   $0xb
  801b13:	e8 e5 fe ff ff       	call   8019fd <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 0c                	push   $0xc
  801b2c:	e8 cc fe ff ff       	call   8019fd <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 0d                	push   $0xd
  801b45:	e8 b3 fe ff ff       	call   8019fd <syscall>
  801b4a:	83 c4 18             	add    $0x18,%esp
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 0e                	push   $0xe
  801b5e:	e8 9a fe ff ff       	call   8019fd <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 0f                	push   $0xf
  801b77:	e8 81 fe ff ff       	call   8019fd <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	ff 75 08             	pushl  0x8(%ebp)
  801b8f:	6a 10                	push   $0x10
  801b91:	e8 67 fe ff ff       	call   8019fd <syscall>
  801b96:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <sys_scarce_memory>:

void sys_scarce_memory() {
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 11                	push   $0x11
  801baa:	e8 4e fe ff ff       	call   8019fd <syscall>
  801baf:	83 c4 18             	add    $0x18,%esp
}
  801bb2:	90                   	nop
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <sys_cputc>:

void sys_cputc(const char c) {
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
  801bb8:	83 ec 04             	sub    $0x4,%esp
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801bc1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	50                   	push   %eax
  801bce:	6a 01                	push   $0x1
  801bd0:	e8 28 fe ff ff       	call   8019fd <syscall>
  801bd5:	83 c4 18             	add    $0x18,%esp
}
  801bd8:	90                   	nop
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 14                	push   $0x14
  801bea:	e8 0e fe ff ff       	call   8019fd <syscall>
  801bef:	83 c4 18             	add    $0x18,%esp
}
  801bf2:	90                   	nop
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
  801bf8:	83 ec 04             	sub    $0x4,%esp
  801bfb:	8b 45 10             	mov    0x10(%ebp),%eax
  801bfe:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801c01:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c04:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c08:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0b:	6a 00                	push   $0x0
  801c0d:	51                   	push   %ecx
  801c0e:	52                   	push   %edx
  801c0f:	ff 75 0c             	pushl  0xc(%ebp)
  801c12:	50                   	push   %eax
  801c13:	6a 15                	push   $0x15
  801c15:	e8 e3 fd ff ff       	call   8019fd <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801c22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c25:	8b 45 08             	mov    0x8(%ebp),%eax
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	52                   	push   %edx
  801c2f:	50                   	push   %eax
  801c30:	6a 16                	push   $0x16
  801c32:	e8 c6 fd ff ff       	call   8019fd <syscall>
  801c37:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801c3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	51                   	push   %ecx
  801c4d:	52                   	push   %edx
  801c4e:	50                   	push   %eax
  801c4f:	6a 17                	push   $0x17
  801c51:	e8 a7 fd ff ff       	call   8019fd <syscall>
  801c56:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801c5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	52                   	push   %edx
  801c6b:	50                   	push   %eax
  801c6c:	6a 18                	push   $0x18
  801c6e:	e8 8a fd ff ff       	call   8019fd <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7e:	6a 00                	push   $0x0
  801c80:	ff 75 14             	pushl  0x14(%ebp)
  801c83:	ff 75 10             	pushl  0x10(%ebp)
  801c86:	ff 75 0c             	pushl  0xc(%ebp)
  801c89:	50                   	push   %eax
  801c8a:	6a 19                	push   $0x19
  801c8c:	e8 6c fd ff ff       	call   8019fd <syscall>
  801c91:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <sys_run_env>:

void sys_run_env(int32 envId) {
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801c99:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	50                   	push   %eax
  801ca5:	6a 1a                	push   $0x1a
  801ca7:	e8 51 fd ff ff       	call   8019fd <syscall>
  801cac:	83 c4 18             	add    $0x18,%esp
}
  801caf:	90                   	nop
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	50                   	push   %eax
  801cc1:	6a 1b                	push   $0x1b
  801cc3:	e8 35 fd ff ff       	call   8019fd <syscall>
  801cc8:	83 c4 18             	add    $0x18,%esp
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <sys_getenvid>:

int32 sys_getenvid(void) {
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 05                	push   $0x5
  801cdc:	e8 1c fd ff ff       	call   8019fd <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
}
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 06                	push   $0x6
  801cf5:	e8 03 fd ff ff       	call   8019fd <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 07                	push   $0x7
  801d0e:	e8 ea fc ff ff       	call   8019fd <syscall>
  801d13:	83 c4 18             	add    $0x18,%esp
}
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <sys_exit_env>:

void sys_exit_env(void) {
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 1c                	push   $0x1c
  801d27:	e8 d1 fc ff ff       	call   8019fd <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
}
  801d2f:	90                   	nop
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801d38:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d3b:	8d 50 04             	lea    0x4(%eax),%edx
  801d3e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	52                   	push   %edx
  801d48:	50                   	push   %eax
  801d49:	6a 1d                	push   $0x1d
  801d4b:	e8 ad fc ff ff       	call   8019fd <syscall>
  801d50:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801d53:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d56:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d59:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d5c:	89 01                	mov    %eax,(%ecx)
  801d5e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d61:	8b 45 08             	mov    0x8(%ebp),%eax
  801d64:	c9                   	leave  
  801d65:	c2 04 00             	ret    $0x4

00801d68 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	ff 75 10             	pushl  0x10(%ebp)
  801d72:	ff 75 0c             	pushl  0xc(%ebp)
  801d75:	ff 75 08             	pushl  0x8(%ebp)
  801d78:	6a 13                	push   $0x13
  801d7a:	e8 7e fc ff ff       	call   8019fd <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801d82:	90                   	nop
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <sys_rcr2>:
uint32 sys_rcr2() {
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 1e                	push   $0x1e
  801d94:	e8 64 fc ff ff       	call   8019fd <syscall>
  801d99:	83 c4 18             	add    $0x18,%esp
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
  801da1:	83 ec 04             	sub    $0x4,%esp
  801da4:	8b 45 08             	mov    0x8(%ebp),%eax
  801da7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801daa:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	50                   	push   %eax
  801db7:	6a 1f                	push   $0x1f
  801db9:	e8 3f fc ff ff       	call   8019fd <syscall>
  801dbe:	83 c4 18             	add    $0x18,%esp
	return;
  801dc1:	90                   	nop
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <rsttst>:
void rsttst() {
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 21                	push   $0x21
  801dd3:	e8 25 fc ff ff       	call   8019fd <syscall>
  801dd8:	83 c4 18             	add    $0x18,%esp
	return;
  801ddb:	90                   	nop
}
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    

00801dde <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
  801de1:	83 ec 04             	sub    $0x4,%esp
  801de4:	8b 45 14             	mov    0x14(%ebp),%eax
  801de7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dea:	8b 55 18             	mov    0x18(%ebp),%edx
  801ded:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801df1:	52                   	push   %edx
  801df2:	50                   	push   %eax
  801df3:	ff 75 10             	pushl  0x10(%ebp)
  801df6:	ff 75 0c             	pushl  0xc(%ebp)
  801df9:	ff 75 08             	pushl  0x8(%ebp)
  801dfc:	6a 20                	push   $0x20
  801dfe:	e8 fa fb ff ff       	call   8019fd <syscall>
  801e03:	83 c4 18             	add    $0x18,%esp
	return;
  801e06:	90                   	nop
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <chktst>:
void chktst(uint32 n) {
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	ff 75 08             	pushl  0x8(%ebp)
  801e17:	6a 22                	push   $0x22
  801e19:	e8 df fb ff ff       	call   8019fd <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
	return;
  801e21:	90                   	nop
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <inctst>:

void inctst() {
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 23                	push   $0x23
  801e33:	e8 c5 fb ff ff       	call   8019fd <syscall>
  801e38:	83 c4 18             	add    $0x18,%esp
	return;
  801e3b:	90                   	nop
}
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <gettst>:
uint32 gettst() {
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 24                	push   $0x24
  801e4d:	e8 ab fb ff ff       	call   8019fd <syscall>
  801e52:	83 c4 18             	add    $0x18,%esp
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
  801e5a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 25                	push   $0x25
  801e69:	e8 8f fb ff ff       	call   8019fd <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
  801e71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e74:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e78:	75 07                	jne    801e81 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7f:	eb 05                	jmp    801e86 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 25                	push   $0x25
  801e9a:	e8 5e fb ff ff       	call   8019fd <syscall>
  801e9f:	83 c4 18             	add    $0x18,%esp
  801ea2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ea5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ea9:	75 07                	jne    801eb2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801eab:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb0:	eb 05                	jmp    801eb7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801eb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
  801ebc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 25                	push   $0x25
  801ecb:	e8 2d fb ff ff       	call   8019fd <syscall>
  801ed0:	83 c4 18             	add    $0x18,%esp
  801ed3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ed6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801eda:	75 07                	jne    801ee3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801edc:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee1:	eb 05                	jmp    801ee8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ee3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 25                	push   $0x25
  801efc:	e8 fc fa ff ff       	call   8019fd <syscall>
  801f01:	83 c4 18             	add    $0x18,%esp
  801f04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f07:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f0b:	75 07                	jne    801f14 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f0d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f12:	eb 05                	jmp    801f19 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	ff 75 08             	pushl  0x8(%ebp)
  801f29:	6a 26                	push   $0x26
  801f2b:	e8 cd fa ff ff       	call   8019fd <syscall>
  801f30:	83 c4 18             	add    $0x18,%esp
	return;
  801f33:	90                   	nop
}
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    

00801f36 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
  801f39:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801f3a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f43:	8b 45 08             	mov    0x8(%ebp),%eax
  801f46:	6a 00                	push   $0x0
  801f48:	53                   	push   %ebx
  801f49:	51                   	push   %ecx
  801f4a:	52                   	push   %edx
  801f4b:	50                   	push   %eax
  801f4c:	6a 27                	push   $0x27
  801f4e:	e8 aa fa ff ff       	call   8019fd <syscall>
  801f53:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801f56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    

00801f5b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801f5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f61:	8b 45 08             	mov    0x8(%ebp),%eax
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	52                   	push   %edx
  801f6b:	50                   	push   %eax
  801f6c:	6a 28                	push   $0x28
  801f6e:	e8 8a fa ff ff       	call   8019fd <syscall>
  801f73:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801f7b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f81:	8b 45 08             	mov    0x8(%ebp),%eax
  801f84:	6a 00                	push   $0x0
  801f86:	51                   	push   %ecx
  801f87:	ff 75 10             	pushl  0x10(%ebp)
  801f8a:	52                   	push   %edx
  801f8b:	50                   	push   %eax
  801f8c:	6a 29                	push   $0x29
  801f8e:	e8 6a fa ff ff       	call   8019fd <syscall>
  801f93:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    

00801f98 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	ff 75 10             	pushl  0x10(%ebp)
  801fa2:	ff 75 0c             	pushl  0xc(%ebp)
  801fa5:	ff 75 08             	pushl  0x8(%ebp)
  801fa8:	6a 12                	push   $0x12
  801faa:	e8 4e fa ff ff       	call   8019fd <syscall>
  801faf:	83 c4 18             	add    $0x18,%esp
	return;
  801fb2:	90                   	nop
}
  801fb3:	c9                   	leave  
  801fb4:	c3                   	ret    

00801fb5 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801fb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	52                   	push   %edx
  801fc5:	50                   	push   %eax
  801fc6:	6a 2a                	push   $0x2a
  801fc8:	e8 30 fa ff ff       	call   8019fd <syscall>
  801fcd:	83 c4 18             	add    $0x18,%esp
	return;
  801fd0:	90                   	nop
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	50                   	push   %eax
  801fe2:	6a 2b                	push   $0x2b
  801fe4:	e8 14 fa ff ff       	call   8019fd <syscall>
  801fe9:	83 c4 18             	add    $0x18,%esp
}
  801fec:	c9                   	leave  
  801fed:	c3                   	ret    

00801fee <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	ff 75 0c             	pushl  0xc(%ebp)
  801ffa:	ff 75 08             	pushl  0x8(%ebp)
  801ffd:	6a 2c                	push   $0x2c
  801fff:	e8 f9 f9 ff ff       	call   8019fd <syscall>
  802004:	83 c4 18             	add    $0x18,%esp
	return;
  802007:	90                   	nop
}
  802008:	c9                   	leave  
  802009:	c3                   	ret    

0080200a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	ff 75 0c             	pushl  0xc(%ebp)
  802016:	ff 75 08             	pushl  0x8(%ebp)
  802019:	6a 2d                	push   $0x2d
  80201b:	e8 dd f9 ff ff       	call   8019fd <syscall>
  802020:	83 c4 18             	add    $0x18,%esp
	return;
  802023:	90                   	nop
}
  802024:	c9                   	leave  
  802025:	c3                   	ret    

00802026 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  802029:	8b 45 08             	mov    0x8(%ebp),%eax
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	50                   	push   %eax
  802035:	6a 2f                	push   $0x2f
  802037:	e8 c1 f9 ff ff       	call   8019fd <syscall>
  80203c:	83 c4 18             	add    $0x18,%esp
	return;
  80203f:	90                   	nop
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  802045:	8b 55 0c             	mov    0xc(%ebp),%edx
  802048:	8b 45 08             	mov    0x8(%ebp),%eax
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	52                   	push   %edx
  802052:	50                   	push   %eax
  802053:	6a 30                	push   $0x30
  802055:	e8 a3 f9 ff ff       	call   8019fd <syscall>
  80205a:	83 c4 18             	add    $0x18,%esp
	return;
  80205d:	90                   	nop
}
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  802063:	8b 45 08             	mov    0x8(%ebp),%eax
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	50                   	push   %eax
  80206f:	6a 31                	push   $0x31
  802071:	e8 87 f9 ff ff       	call   8019fd <syscall>
  802076:	83 c4 18             	add    $0x18,%esp
	return;
  802079:	90                   	nop
}
  80207a:	c9                   	leave  
  80207b:	c3                   	ret    

0080207c <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80207f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802082:	8b 45 08             	mov    0x8(%ebp),%eax
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	52                   	push   %edx
  80208c:	50                   	push   %eax
  80208d:	6a 2e                	push   $0x2e
  80208f:	e8 69 f9 ff ff       	call   8019fd <syscall>
  802094:	83 c4 18             	add    $0x18,%esp
    return;
  802097:	90                   	nop
}
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a3:	83 e8 04             	sub    $0x4,%eax
  8020a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8020a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ac:	8b 00                	mov    (%eax),%eax
  8020ae:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bc:	83 e8 04             	sub    $0x4,%eax
  8020bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8020c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020c5:	8b 00                	mov    (%eax),%eax
  8020c7:	83 e0 01             	and    $0x1,%eax
  8020ca:	85 c0                	test   %eax,%eax
  8020cc:	0f 94 c0             	sete   %al
}
  8020cf:	c9                   	leave  
  8020d0:	c3                   	ret    

008020d1 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
  8020d4:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8020d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8020de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e1:	83 f8 02             	cmp    $0x2,%eax
  8020e4:	74 2b                	je     802111 <alloc_block+0x40>
  8020e6:	83 f8 02             	cmp    $0x2,%eax
  8020e9:	7f 07                	jg     8020f2 <alloc_block+0x21>
  8020eb:	83 f8 01             	cmp    $0x1,%eax
  8020ee:	74 0e                	je     8020fe <alloc_block+0x2d>
  8020f0:	eb 58                	jmp    80214a <alloc_block+0x79>
  8020f2:	83 f8 03             	cmp    $0x3,%eax
  8020f5:	74 2d                	je     802124 <alloc_block+0x53>
  8020f7:	83 f8 04             	cmp    $0x4,%eax
  8020fa:	74 3b                	je     802137 <alloc_block+0x66>
  8020fc:	eb 4c                	jmp    80214a <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8020fe:	83 ec 0c             	sub    $0xc,%esp
  802101:	ff 75 08             	pushl  0x8(%ebp)
  802104:	e8 f7 03 00 00       	call   802500 <alloc_block_FF>
  802109:	83 c4 10             	add    $0x10,%esp
  80210c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80210f:	eb 4a                	jmp    80215b <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802111:	83 ec 0c             	sub    $0xc,%esp
  802114:	ff 75 08             	pushl  0x8(%ebp)
  802117:	e8 f0 11 00 00       	call   80330c <alloc_block_NF>
  80211c:	83 c4 10             	add    $0x10,%esp
  80211f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802122:	eb 37                	jmp    80215b <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802124:	83 ec 0c             	sub    $0xc,%esp
  802127:	ff 75 08             	pushl  0x8(%ebp)
  80212a:	e8 08 08 00 00       	call   802937 <alloc_block_BF>
  80212f:	83 c4 10             	add    $0x10,%esp
  802132:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802135:	eb 24                	jmp    80215b <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802137:	83 ec 0c             	sub    $0xc,%esp
  80213a:	ff 75 08             	pushl  0x8(%ebp)
  80213d:	e8 ad 11 00 00       	call   8032ef <alloc_block_WF>
  802142:	83 c4 10             	add    $0x10,%esp
  802145:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802148:	eb 11                	jmp    80215b <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80214a:	83 ec 0c             	sub    $0xc,%esp
  80214d:	68 2c 3d 80 00       	push   $0x803d2c
  802152:	e8 39 e2 ff ff       	call   800390 <cprintf>
  802157:	83 c4 10             	add    $0x10,%esp
		break;
  80215a:	90                   	nop
	}
	return va;
  80215b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
  802163:	53                   	push   %ebx
  802164:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802167:	83 ec 0c             	sub    $0xc,%esp
  80216a:	68 4c 3d 80 00       	push   $0x803d4c
  80216f:	e8 1c e2 ff ff       	call   800390 <cprintf>
  802174:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802177:	83 ec 0c             	sub    $0xc,%esp
  80217a:	68 77 3d 80 00       	push   $0x803d77
  80217f:	e8 0c e2 ff ff       	call   800390 <cprintf>
  802184:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80218d:	eb 37                	jmp    8021c6 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80218f:	83 ec 0c             	sub    $0xc,%esp
  802192:	ff 75 f4             	pushl  -0xc(%ebp)
  802195:	e8 19 ff ff ff       	call   8020b3 <is_free_block>
  80219a:	83 c4 10             	add    $0x10,%esp
  80219d:	0f be d8             	movsbl %al,%ebx
  8021a0:	83 ec 0c             	sub    $0xc,%esp
  8021a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8021a6:	e8 ef fe ff ff       	call   80209a <get_block_size>
  8021ab:	83 c4 10             	add    $0x10,%esp
  8021ae:	83 ec 04             	sub    $0x4,%esp
  8021b1:	53                   	push   %ebx
  8021b2:	50                   	push   %eax
  8021b3:	68 8f 3d 80 00       	push   $0x803d8f
  8021b8:	e8 d3 e1 ff ff       	call   800390 <cprintf>
  8021bd:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8021c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ca:	74 07                	je     8021d3 <print_blocks_list+0x73>
  8021cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cf:	8b 00                	mov    (%eax),%eax
  8021d1:	eb 05                	jmp    8021d8 <print_blocks_list+0x78>
  8021d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d8:	89 45 10             	mov    %eax,0x10(%ebp)
  8021db:	8b 45 10             	mov    0x10(%ebp),%eax
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	75 ad                	jne    80218f <print_blocks_list+0x2f>
  8021e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e6:	75 a7                	jne    80218f <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8021e8:	83 ec 0c             	sub    $0xc,%esp
  8021eb:	68 4c 3d 80 00       	push   $0x803d4c
  8021f0:	e8 9b e1 ff ff       	call   800390 <cprintf>
  8021f5:	83 c4 10             	add    $0x10,%esp

}
  8021f8:	90                   	nop
  8021f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021fc:	c9                   	leave  
  8021fd:	c3                   	ret    

008021fe <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
  802201:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802204:	8b 45 0c             	mov    0xc(%ebp),%eax
  802207:	83 e0 01             	and    $0x1,%eax
  80220a:	85 c0                	test   %eax,%eax
  80220c:	74 03                	je     802211 <initialize_dynamic_allocator+0x13>
  80220e:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  802211:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802215:	0f 84 f8 00 00 00    	je     802313 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  80221b:	c7 05 40 40 98 00 01 	movl   $0x1,0x984040
  802222:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  802225:	a1 40 40 98 00       	mov    0x984040,%eax
  80222a:	85 c0                	test   %eax,%eax
  80222c:	0f 84 e2 00 00 00    	je     802314 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  802241:	8b 55 08             	mov    0x8(%ebp),%edx
  802244:	8b 45 0c             	mov    0xc(%ebp),%eax
  802247:	01 d0                	add    %edx,%eax
  802249:	83 e8 04             	sub    $0x4,%eax
  80224c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  80224f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802252:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  802258:	8b 45 08             	mov    0x8(%ebp),%eax
  80225b:	83 c0 08             	add    $0x8,%eax
  80225e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  802261:	8b 45 0c             	mov    0xc(%ebp),%eax
  802264:	83 e8 08             	sub    $0x8,%eax
  802267:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  80226a:	83 ec 04             	sub    $0x4,%esp
  80226d:	6a 00                	push   $0x0
  80226f:	ff 75 e8             	pushl  -0x18(%ebp)
  802272:	ff 75 ec             	pushl  -0x14(%ebp)
  802275:	e8 9c 00 00 00       	call   802316 <set_block_data>
  80227a:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  80227d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802280:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802286:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802289:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  802290:	c7 05 48 40 98 00 00 	movl   $0x0,0x984048
  802297:	00 00 00 
  80229a:	c7 05 4c 40 98 00 00 	movl   $0x0,0x98404c
  8022a1:	00 00 00 
  8022a4:	c7 05 54 40 98 00 00 	movl   $0x0,0x984054
  8022ab:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  8022ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022b2:	75 17                	jne    8022cb <initialize_dynamic_allocator+0xcd>
  8022b4:	83 ec 04             	sub    $0x4,%esp
  8022b7:	68 a8 3d 80 00       	push   $0x803da8
  8022bc:	68 80 00 00 00       	push   $0x80
  8022c1:	68 cb 3d 80 00       	push   $0x803dcb
  8022c6:	e8 9a 10 00 00       	call   803365 <_panic>
  8022cb:	8b 15 48 40 98 00    	mov    0x984048,%edx
  8022d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022d4:	89 10                	mov    %edx,(%eax)
  8022d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022d9:	8b 00                	mov    (%eax),%eax
  8022db:	85 c0                	test   %eax,%eax
  8022dd:	74 0d                	je     8022ec <initialize_dynamic_allocator+0xee>
  8022df:	a1 48 40 98 00       	mov    0x984048,%eax
  8022e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022e7:	89 50 04             	mov    %edx,0x4(%eax)
  8022ea:	eb 08                	jmp    8022f4 <initialize_dynamic_allocator+0xf6>
  8022ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ef:	a3 4c 40 98 00       	mov    %eax,0x98404c
  8022f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022f7:	a3 48 40 98 00       	mov    %eax,0x984048
  8022fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802306:	a1 54 40 98 00       	mov    0x984054,%eax
  80230b:	40                   	inc    %eax
  80230c:	a3 54 40 98 00       	mov    %eax,0x984054
  802311:	eb 01                	jmp    802314 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802313:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  802314:	c9                   	leave  
  802315:	c3                   	ret    

00802316 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
  802319:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  80231c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80231f:	83 e0 01             	and    $0x1,%eax
  802322:	85 c0                	test   %eax,%eax
  802324:	74 03                	je     802329 <set_block_data+0x13>
	{
		totalSize++;
  802326:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	83 e8 04             	sub    $0x4,%eax
  80232f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  802332:	8b 45 0c             	mov    0xc(%ebp),%eax
  802335:	83 e0 fe             	and    $0xfffffffe,%eax
  802338:	89 c2                	mov    %eax,%edx
  80233a:	8b 45 10             	mov    0x10(%ebp),%eax
  80233d:	83 e0 01             	and    $0x1,%eax
  802340:	09 c2                	or     %eax,%edx
  802342:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802345:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  802347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80234a:	8d 50 f8             	lea    -0x8(%eax),%edx
  80234d:	8b 45 08             	mov    0x8(%ebp),%eax
  802350:	01 d0                	add    %edx,%eax
  802352:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  802355:	8b 45 0c             	mov    0xc(%ebp),%eax
  802358:	83 e0 fe             	and    $0xfffffffe,%eax
  80235b:	89 c2                	mov    %eax,%edx
  80235d:	8b 45 10             	mov    0x10(%ebp),%eax
  802360:	83 e0 01             	and    $0x1,%eax
  802363:	09 c2                	or     %eax,%edx
  802365:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802368:	89 10                	mov    %edx,(%eax)
}
  80236a:	90                   	nop
  80236b:	c9                   	leave  
  80236c:	c3                   	ret    

0080236d <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  80236d:	55                   	push   %ebp
  80236e:	89 e5                	mov    %esp,%ebp
  802370:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  802373:	a1 48 40 98 00       	mov    0x984048,%eax
  802378:	85 c0                	test   %eax,%eax
  80237a:	75 68                	jne    8023e4 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  80237c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802380:	75 17                	jne    802399 <insert_sorted_in_freeList+0x2c>
  802382:	83 ec 04             	sub    $0x4,%esp
  802385:	68 a8 3d 80 00       	push   $0x803da8
  80238a:	68 9d 00 00 00       	push   $0x9d
  80238f:	68 cb 3d 80 00       	push   $0x803dcb
  802394:	e8 cc 0f 00 00       	call   803365 <_panic>
  802399:	8b 15 48 40 98 00    	mov    0x984048,%edx
  80239f:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a2:	89 10                	mov    %edx,(%eax)
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	8b 00                	mov    (%eax),%eax
  8023a9:	85 c0                	test   %eax,%eax
  8023ab:	74 0d                	je     8023ba <insert_sorted_in_freeList+0x4d>
  8023ad:	a1 48 40 98 00       	mov    0x984048,%eax
  8023b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8023b5:	89 50 04             	mov    %edx,0x4(%eax)
  8023b8:	eb 08                	jmp    8023c2 <insert_sorted_in_freeList+0x55>
  8023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bd:	a3 4c 40 98 00       	mov    %eax,0x98404c
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	a3 48 40 98 00       	mov    %eax,0x984048
  8023ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023d4:	a1 54 40 98 00       	mov    0x984054,%eax
  8023d9:	40                   	inc    %eax
  8023da:	a3 54 40 98 00       	mov    %eax,0x984054
		return;
  8023df:	e9 1a 01 00 00       	jmp    8024fe <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8023e4:	a1 48 40 98 00       	mov    0x984048,%eax
  8023e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ec:	eb 7f                	jmp    80246d <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  8023ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f4:	76 6f                	jbe    802465 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  8023f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023fa:	74 06                	je     802402 <insert_sorted_in_freeList+0x95>
  8023fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802400:	75 17                	jne    802419 <insert_sorted_in_freeList+0xac>
  802402:	83 ec 04             	sub    $0x4,%esp
  802405:	68 e4 3d 80 00       	push   $0x803de4
  80240a:	68 a6 00 00 00       	push   $0xa6
  80240f:	68 cb 3d 80 00       	push   $0x803dcb
  802414:	e8 4c 0f 00 00       	call   803365 <_panic>
  802419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241c:	8b 50 04             	mov    0x4(%eax),%edx
  80241f:	8b 45 08             	mov    0x8(%ebp),%eax
  802422:	89 50 04             	mov    %edx,0x4(%eax)
  802425:	8b 45 08             	mov    0x8(%ebp),%eax
  802428:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242b:	89 10                	mov    %edx,(%eax)
  80242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802430:	8b 40 04             	mov    0x4(%eax),%eax
  802433:	85 c0                	test   %eax,%eax
  802435:	74 0d                	je     802444 <insert_sorted_in_freeList+0xd7>
  802437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243a:	8b 40 04             	mov    0x4(%eax),%eax
  80243d:	8b 55 08             	mov    0x8(%ebp),%edx
  802440:	89 10                	mov    %edx,(%eax)
  802442:	eb 08                	jmp    80244c <insert_sorted_in_freeList+0xdf>
  802444:	8b 45 08             	mov    0x8(%ebp),%eax
  802447:	a3 48 40 98 00       	mov    %eax,0x984048
  80244c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244f:	8b 55 08             	mov    0x8(%ebp),%edx
  802452:	89 50 04             	mov    %edx,0x4(%eax)
  802455:	a1 54 40 98 00       	mov    0x984054,%eax
  80245a:	40                   	inc    %eax
  80245b:	a3 54 40 98 00       	mov    %eax,0x984054
			return;
  802460:	e9 99 00 00 00       	jmp    8024fe <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802465:	a1 50 40 98 00       	mov    0x984050,%eax
  80246a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80246d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802471:	74 07                	je     80247a <insert_sorted_in_freeList+0x10d>
  802473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802476:	8b 00                	mov    (%eax),%eax
  802478:	eb 05                	jmp    80247f <insert_sorted_in_freeList+0x112>
  80247a:	b8 00 00 00 00       	mov    $0x0,%eax
  80247f:	a3 50 40 98 00       	mov    %eax,0x984050
  802484:	a1 50 40 98 00       	mov    0x984050,%eax
  802489:	85 c0                	test   %eax,%eax
  80248b:	0f 85 5d ff ff ff    	jne    8023ee <insert_sorted_in_freeList+0x81>
  802491:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802495:	0f 85 53 ff ff ff    	jne    8023ee <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  80249b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80249f:	75 17                	jne    8024b8 <insert_sorted_in_freeList+0x14b>
  8024a1:	83 ec 04             	sub    $0x4,%esp
  8024a4:	68 1c 3e 80 00       	push   $0x803e1c
  8024a9:	68 ab 00 00 00       	push   $0xab
  8024ae:	68 cb 3d 80 00       	push   $0x803dcb
  8024b3:	e8 ad 0e 00 00       	call   803365 <_panic>
  8024b8:	8b 15 4c 40 98 00    	mov    0x98404c,%edx
  8024be:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c1:	89 50 04             	mov    %edx,0x4(%eax)
  8024c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c7:	8b 40 04             	mov    0x4(%eax),%eax
  8024ca:	85 c0                	test   %eax,%eax
  8024cc:	74 0c                	je     8024da <insert_sorted_in_freeList+0x16d>
  8024ce:	a1 4c 40 98 00       	mov    0x98404c,%eax
  8024d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8024d6:	89 10                	mov    %edx,(%eax)
  8024d8:	eb 08                	jmp    8024e2 <insert_sorted_in_freeList+0x175>
  8024da:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dd:	a3 48 40 98 00       	mov    %eax,0x984048
  8024e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e5:	a3 4c 40 98 00       	mov    %eax,0x98404c
  8024ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024f3:	a1 54 40 98 00       	mov    0x984054,%eax
  8024f8:	40                   	inc    %eax
  8024f9:	a3 54 40 98 00       	mov    %eax,0x984054
}
  8024fe:	c9                   	leave  
  8024ff:	c3                   	ret    

00802500 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
  802503:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802506:	8b 45 08             	mov    0x8(%ebp),%eax
  802509:	83 e0 01             	and    $0x1,%eax
  80250c:	85 c0                	test   %eax,%eax
  80250e:	74 03                	je     802513 <alloc_block_FF+0x13>
  802510:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802513:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802517:	77 07                	ja     802520 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802519:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802520:	a1 40 40 98 00       	mov    0x984040,%eax
  802525:	85 c0                	test   %eax,%eax
  802527:	75 63                	jne    80258c <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802529:	8b 45 08             	mov    0x8(%ebp),%eax
  80252c:	83 c0 10             	add    $0x10,%eax
  80252f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802532:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802539:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80253c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253f:	01 d0                	add    %edx,%eax
  802541:	48                   	dec    %eax
  802542:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802545:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802548:	ba 00 00 00 00       	mov    $0x0,%edx
  80254d:	f7 75 ec             	divl   -0x14(%ebp)
  802550:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802553:	29 d0                	sub    %edx,%eax
  802555:	c1 e8 0c             	shr    $0xc,%eax
  802558:	83 ec 0c             	sub    $0xc,%esp
  80255b:	50                   	push   %eax
  80255c:	e8 d1 ed ff ff       	call   801332 <sbrk>
  802561:	83 c4 10             	add    $0x10,%esp
  802564:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802567:	83 ec 0c             	sub    $0xc,%esp
  80256a:	6a 00                	push   $0x0
  80256c:	e8 c1 ed ff ff       	call   801332 <sbrk>
  802571:	83 c4 10             	add    $0x10,%esp
  802574:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802577:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80257a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80257d:	83 ec 08             	sub    $0x8,%esp
  802580:	50                   	push   %eax
  802581:	ff 75 e4             	pushl  -0x1c(%ebp)
  802584:	e8 75 fc ff ff       	call   8021fe <initialize_dynamic_allocator>
  802589:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  80258c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802590:	75 0a                	jne    80259c <alloc_block_FF+0x9c>
	{
		return NULL;
  802592:	b8 00 00 00 00       	mov    $0x0,%eax
  802597:	e9 99 03 00 00       	jmp    802935 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  80259c:	8b 45 08             	mov    0x8(%ebp),%eax
  80259f:	83 c0 08             	add    $0x8,%eax
  8025a2:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8025a5:	a1 48 40 98 00       	mov    0x984048,%eax
  8025aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ad:	e9 03 02 00 00       	jmp    8027b5 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  8025b2:	83 ec 0c             	sub    $0xc,%esp
  8025b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8025b8:	e8 dd fa ff ff       	call   80209a <get_block_size>
  8025bd:	83 c4 10             	add    $0x10,%esp
  8025c0:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  8025c3:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8025c6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8025c9:	0f 82 de 01 00 00    	jb     8027ad <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  8025cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025d2:	83 c0 10             	add    $0x10,%eax
  8025d5:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  8025d8:	0f 87 32 01 00 00    	ja     802710 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  8025de:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8025e1:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8025e4:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  8025e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025ed:	01 d0                	add    %edx,%eax
  8025ef:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  8025f2:	83 ec 04             	sub    $0x4,%esp
  8025f5:	6a 00                	push   $0x0
  8025f7:	ff 75 98             	pushl  -0x68(%ebp)
  8025fa:	ff 75 94             	pushl  -0x6c(%ebp)
  8025fd:	e8 14 fd ff ff       	call   802316 <set_block_data>
  802602:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802605:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802609:	74 06                	je     802611 <alloc_block_FF+0x111>
  80260b:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  80260f:	75 17                	jne    802628 <alloc_block_FF+0x128>
  802611:	83 ec 04             	sub    $0x4,%esp
  802614:	68 40 3e 80 00       	push   $0x803e40
  802619:	68 de 00 00 00       	push   $0xde
  80261e:	68 cb 3d 80 00       	push   $0x803dcb
  802623:	e8 3d 0d 00 00       	call   803365 <_panic>
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	8b 10                	mov    (%eax),%edx
  80262d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802630:	89 10                	mov    %edx,(%eax)
  802632:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802635:	8b 00                	mov    (%eax),%eax
  802637:	85 c0                	test   %eax,%eax
  802639:	74 0b                	je     802646 <alloc_block_FF+0x146>
  80263b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263e:	8b 00                	mov    (%eax),%eax
  802640:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802643:	89 50 04             	mov    %edx,0x4(%eax)
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	8b 55 94             	mov    -0x6c(%ebp),%edx
  80264c:	89 10                	mov    %edx,(%eax)
  80264e:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802651:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802654:	89 50 04             	mov    %edx,0x4(%eax)
  802657:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80265a:	8b 00                	mov    (%eax),%eax
  80265c:	85 c0                	test   %eax,%eax
  80265e:	75 08                	jne    802668 <alloc_block_FF+0x168>
  802660:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802663:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802668:	a1 54 40 98 00       	mov    0x984054,%eax
  80266d:	40                   	inc    %eax
  80266e:	a3 54 40 98 00       	mov    %eax,0x984054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802673:	83 ec 04             	sub    $0x4,%esp
  802676:	6a 01                	push   $0x1
  802678:	ff 75 dc             	pushl  -0x24(%ebp)
  80267b:	ff 75 f4             	pushl  -0xc(%ebp)
  80267e:	e8 93 fc ff ff       	call   802316 <set_block_data>
  802683:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802686:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80268a:	75 17                	jne    8026a3 <alloc_block_FF+0x1a3>
  80268c:	83 ec 04             	sub    $0x4,%esp
  80268f:	68 74 3e 80 00       	push   $0x803e74
  802694:	68 e3 00 00 00       	push   $0xe3
  802699:	68 cb 3d 80 00       	push   $0x803dcb
  80269e:	e8 c2 0c 00 00       	call   803365 <_panic>
  8026a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a6:	8b 00                	mov    (%eax),%eax
  8026a8:	85 c0                	test   %eax,%eax
  8026aa:	74 10                	je     8026bc <alloc_block_FF+0x1bc>
  8026ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026af:	8b 00                	mov    (%eax),%eax
  8026b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b4:	8b 52 04             	mov    0x4(%edx),%edx
  8026b7:	89 50 04             	mov    %edx,0x4(%eax)
  8026ba:	eb 0b                	jmp    8026c7 <alloc_block_FF+0x1c7>
  8026bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bf:	8b 40 04             	mov    0x4(%eax),%eax
  8026c2:	a3 4c 40 98 00       	mov    %eax,0x98404c
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	8b 40 04             	mov    0x4(%eax),%eax
  8026cd:	85 c0                	test   %eax,%eax
  8026cf:	74 0f                	je     8026e0 <alloc_block_FF+0x1e0>
  8026d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d4:	8b 40 04             	mov    0x4(%eax),%eax
  8026d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026da:	8b 12                	mov    (%edx),%edx
  8026dc:	89 10                	mov    %edx,(%eax)
  8026de:	eb 0a                	jmp    8026ea <alloc_block_FF+0x1ea>
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	8b 00                	mov    (%eax),%eax
  8026e5:	a3 48 40 98 00       	mov    %eax,0x984048
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026fd:	a1 54 40 98 00       	mov    0x984054,%eax
  802702:	48                   	dec    %eax
  802703:	a3 54 40 98 00       	mov    %eax,0x984054
				return (void*)((uint32*)block);
  802708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270b:	e9 25 02 00 00       	jmp    802935 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  802710:	83 ec 04             	sub    $0x4,%esp
  802713:	6a 01                	push   $0x1
  802715:	ff 75 9c             	pushl  -0x64(%ebp)
  802718:	ff 75 f4             	pushl  -0xc(%ebp)
  80271b:	e8 f6 fb ff ff       	call   802316 <set_block_data>
  802720:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802723:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802727:	75 17                	jne    802740 <alloc_block_FF+0x240>
  802729:	83 ec 04             	sub    $0x4,%esp
  80272c:	68 74 3e 80 00       	push   $0x803e74
  802731:	68 eb 00 00 00       	push   $0xeb
  802736:	68 cb 3d 80 00       	push   $0x803dcb
  80273b:	e8 25 0c 00 00       	call   803365 <_panic>
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	8b 00                	mov    (%eax),%eax
  802745:	85 c0                	test   %eax,%eax
  802747:	74 10                	je     802759 <alloc_block_FF+0x259>
  802749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274c:	8b 00                	mov    (%eax),%eax
  80274e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802751:	8b 52 04             	mov    0x4(%edx),%edx
  802754:	89 50 04             	mov    %edx,0x4(%eax)
  802757:	eb 0b                	jmp    802764 <alloc_block_FF+0x264>
  802759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275c:	8b 40 04             	mov    0x4(%eax),%eax
  80275f:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	8b 40 04             	mov    0x4(%eax),%eax
  80276a:	85 c0                	test   %eax,%eax
  80276c:	74 0f                	je     80277d <alloc_block_FF+0x27d>
  80276e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802771:	8b 40 04             	mov    0x4(%eax),%eax
  802774:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802777:	8b 12                	mov    (%edx),%edx
  802779:	89 10                	mov    %edx,(%eax)
  80277b:	eb 0a                	jmp    802787 <alloc_block_FF+0x287>
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	8b 00                	mov    (%eax),%eax
  802782:	a3 48 40 98 00       	mov    %eax,0x984048
  802787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802793:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80279a:	a1 54 40 98 00       	mov    0x984054,%eax
  80279f:	48                   	dec    %eax
  8027a0:	a3 54 40 98 00       	mov    %eax,0x984054
				return (void*)((uint32*)block);
  8027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a8:	e9 88 01 00 00       	jmp    802935 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8027ad:	a1 50 40 98 00       	mov    0x984050,%eax
  8027b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b9:	74 07                	je     8027c2 <alloc_block_FF+0x2c2>
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	8b 00                	mov    (%eax),%eax
  8027c0:	eb 05                	jmp    8027c7 <alloc_block_FF+0x2c7>
  8027c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c7:	a3 50 40 98 00       	mov    %eax,0x984050
  8027cc:	a1 50 40 98 00       	mov    0x984050,%eax
  8027d1:	85 c0                	test   %eax,%eax
  8027d3:	0f 85 d9 fd ff ff    	jne    8025b2 <alloc_block_FF+0xb2>
  8027d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027dd:	0f 85 cf fd ff ff    	jne    8025b2 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  8027e3:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8027ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8027f0:	01 d0                	add    %edx,%eax
  8027f2:	48                   	dec    %eax
  8027f3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8027f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8027fe:	f7 75 d8             	divl   -0x28(%ebp)
  802801:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802804:	29 d0                	sub    %edx,%eax
  802806:	c1 e8 0c             	shr    $0xc,%eax
  802809:	83 ec 0c             	sub    $0xc,%esp
  80280c:	50                   	push   %eax
  80280d:	e8 20 eb ff ff       	call   801332 <sbrk>
  802812:	83 c4 10             	add    $0x10,%esp
  802815:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802818:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80281c:	75 0a                	jne    802828 <alloc_block_FF+0x328>
		return NULL;
  80281e:	b8 00 00 00 00       	mov    $0x0,%eax
  802823:	e9 0d 01 00 00       	jmp    802935 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  802828:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80282b:	83 e8 04             	sub    $0x4,%eax
  80282e:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  802831:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  802838:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80283b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80283e:	01 d0                	add    %edx,%eax
  802840:	48                   	dec    %eax
  802841:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802844:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802847:	ba 00 00 00 00       	mov    $0x0,%edx
  80284c:	f7 75 c8             	divl   -0x38(%ebp)
  80284f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802852:	29 d0                	sub    %edx,%eax
  802854:	c1 e8 02             	shr    $0x2,%eax
  802857:	c1 e0 02             	shl    $0x2,%eax
  80285a:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  80285d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802860:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  802866:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802869:	83 e8 08             	sub    $0x8,%eax
  80286c:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  80286f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802872:	8b 00                	mov    (%eax),%eax
  802874:	83 e0 fe             	and    $0xfffffffe,%eax
  802877:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  80287a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80287d:	f7 d8                	neg    %eax
  80287f:	89 c2                	mov    %eax,%edx
  802881:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802884:	01 d0                	add    %edx,%eax
  802886:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  802889:	83 ec 0c             	sub    $0xc,%esp
  80288c:	ff 75 b8             	pushl  -0x48(%ebp)
  80288f:	e8 1f f8 ff ff       	call   8020b3 <is_free_block>
  802894:	83 c4 10             	add    $0x10,%esp
  802897:	0f be c0             	movsbl %al,%eax
  80289a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  80289d:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8028a1:	74 42                	je     8028e5 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  8028a3:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8028aa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028ad:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028b0:	01 d0                	add    %edx,%eax
  8028b2:	48                   	dec    %eax
  8028b3:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8028b6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8028b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8028be:	f7 75 b0             	divl   -0x50(%ebp)
  8028c1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8028c4:	29 d0                	sub    %edx,%eax
  8028c6:	89 c2                	mov    %eax,%edx
  8028c8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8028cb:	01 d0                	add    %edx,%eax
  8028cd:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  8028d0:	83 ec 04             	sub    $0x4,%esp
  8028d3:	6a 00                	push   $0x0
  8028d5:	ff 75 a8             	pushl  -0x58(%ebp)
  8028d8:	ff 75 b8             	pushl  -0x48(%ebp)
  8028db:	e8 36 fa ff ff       	call   802316 <set_block_data>
  8028e0:	83 c4 10             	add    $0x10,%esp
  8028e3:	eb 42                	jmp    802927 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  8028e5:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  8028ec:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028ef:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028f2:	01 d0                	add    %edx,%eax
  8028f4:	48                   	dec    %eax
  8028f5:	89 45 a0             	mov    %eax,-0x60(%ebp)
  8028f8:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8028fb:	ba 00 00 00 00       	mov    $0x0,%edx
  802900:	f7 75 a4             	divl   -0x5c(%ebp)
  802903:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802906:	29 d0                	sub    %edx,%eax
  802908:	83 ec 04             	sub    $0x4,%esp
  80290b:	6a 00                	push   $0x0
  80290d:	50                   	push   %eax
  80290e:	ff 75 d0             	pushl  -0x30(%ebp)
  802911:	e8 00 fa ff ff       	call   802316 <set_block_data>
  802916:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802919:	83 ec 0c             	sub    $0xc,%esp
  80291c:	ff 75 d0             	pushl  -0x30(%ebp)
  80291f:	e8 49 fa ff ff       	call   80236d <insert_sorted_in_freeList>
  802924:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802927:	83 ec 0c             	sub    $0xc,%esp
  80292a:	ff 75 08             	pushl  0x8(%ebp)
  80292d:	e8 ce fb ff ff       	call   802500 <alloc_block_FF>
  802932:	83 c4 10             	add    $0x10,%esp
}
  802935:	c9                   	leave  
  802936:	c3                   	ret    

00802937 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802937:	55                   	push   %ebp
  802938:	89 e5                	mov    %esp,%ebp
  80293a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  80293d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802941:	75 0a                	jne    80294d <alloc_block_BF+0x16>
	{
		return NULL;
  802943:	b8 00 00 00 00       	mov    $0x0,%eax
  802948:	e9 7a 02 00 00       	jmp    802bc7 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  80294d:	8b 45 08             	mov    0x8(%ebp),%eax
  802950:	83 c0 08             	add    $0x8,%eax
  802953:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802956:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  80295d:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802964:	a1 48 40 98 00       	mov    0x984048,%eax
  802969:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80296c:	eb 32                	jmp    8029a0 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  80296e:	ff 75 ec             	pushl  -0x14(%ebp)
  802971:	e8 24 f7 ff ff       	call   80209a <get_block_size>
  802976:	83 c4 04             	add    $0x4,%esp
  802979:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  80297c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80297f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802982:	72 14                	jb     802998 <alloc_block_BF+0x61>
  802984:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802987:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80298a:	73 0c                	jae    802998 <alloc_block_BF+0x61>
		{
			minBlk = block;
  80298c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298f:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  802992:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802995:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802998:	a1 50 40 98 00       	mov    0x984050,%eax
  80299d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8029a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029a4:	74 07                	je     8029ad <alloc_block_BF+0x76>
  8029a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a9:	8b 00                	mov    (%eax),%eax
  8029ab:	eb 05                	jmp    8029b2 <alloc_block_BF+0x7b>
  8029ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b2:	a3 50 40 98 00       	mov    %eax,0x984050
  8029b7:	a1 50 40 98 00       	mov    0x984050,%eax
  8029bc:	85 c0                	test   %eax,%eax
  8029be:	75 ae                	jne    80296e <alloc_block_BF+0x37>
  8029c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029c4:	75 a8                	jne    80296e <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  8029c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ca:	75 22                	jne    8029ee <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  8029cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029cf:	83 ec 0c             	sub    $0xc,%esp
  8029d2:	50                   	push   %eax
  8029d3:	e8 5a e9 ff ff       	call   801332 <sbrk>
  8029d8:	83 c4 10             	add    $0x10,%esp
  8029db:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  8029de:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8029e2:	75 0a                	jne    8029ee <alloc_block_BF+0xb7>
			return NULL;
  8029e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e9:	e9 d9 01 00 00       	jmp    802bc7 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  8029ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f1:	83 c0 10             	add    $0x10,%eax
  8029f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029f7:	0f 87 32 01 00 00    	ja     802b2f <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  8029fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a00:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802a03:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802a06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a0c:	01 d0                	add    %edx,%eax
  802a0e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  802a11:	83 ec 04             	sub    $0x4,%esp
  802a14:	6a 00                	push   $0x0
  802a16:	ff 75 dc             	pushl  -0x24(%ebp)
  802a19:	ff 75 d8             	pushl  -0x28(%ebp)
  802a1c:	e8 f5 f8 ff ff       	call   802316 <set_block_data>
  802a21:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802a24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a28:	74 06                	je     802a30 <alloc_block_BF+0xf9>
  802a2a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802a2e:	75 17                	jne    802a47 <alloc_block_BF+0x110>
  802a30:	83 ec 04             	sub    $0x4,%esp
  802a33:	68 40 3e 80 00       	push   $0x803e40
  802a38:	68 49 01 00 00       	push   $0x149
  802a3d:	68 cb 3d 80 00       	push   $0x803dcb
  802a42:	e8 1e 09 00 00       	call   803365 <_panic>
  802a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4a:	8b 10                	mov    (%eax),%edx
  802a4c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a4f:	89 10                	mov    %edx,(%eax)
  802a51:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a54:	8b 00                	mov    (%eax),%eax
  802a56:	85 c0                	test   %eax,%eax
  802a58:	74 0b                	je     802a65 <alloc_block_BF+0x12e>
  802a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5d:	8b 00                	mov    (%eax),%eax
  802a5f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a62:	89 50 04             	mov    %edx,0x4(%eax)
  802a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a68:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a6b:	89 10                	mov    %edx,(%eax)
  802a6d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a73:	89 50 04             	mov    %edx,0x4(%eax)
  802a76:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a79:	8b 00                	mov    (%eax),%eax
  802a7b:	85 c0                	test   %eax,%eax
  802a7d:	75 08                	jne    802a87 <alloc_block_BF+0x150>
  802a7f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a82:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802a87:	a1 54 40 98 00       	mov    0x984054,%eax
  802a8c:	40                   	inc    %eax
  802a8d:	a3 54 40 98 00       	mov    %eax,0x984054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802a92:	83 ec 04             	sub    $0x4,%esp
  802a95:	6a 01                	push   $0x1
  802a97:	ff 75 e8             	pushl  -0x18(%ebp)
  802a9a:	ff 75 f4             	pushl  -0xc(%ebp)
  802a9d:	e8 74 f8 ff ff       	call   802316 <set_block_data>
  802aa2:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802aa5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa9:	75 17                	jne    802ac2 <alloc_block_BF+0x18b>
  802aab:	83 ec 04             	sub    $0x4,%esp
  802aae:	68 74 3e 80 00       	push   $0x803e74
  802ab3:	68 4e 01 00 00       	push   $0x14e
  802ab8:	68 cb 3d 80 00       	push   $0x803dcb
  802abd:	e8 a3 08 00 00       	call   803365 <_panic>
  802ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac5:	8b 00                	mov    (%eax),%eax
  802ac7:	85 c0                	test   %eax,%eax
  802ac9:	74 10                	je     802adb <alloc_block_BF+0x1a4>
  802acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ace:	8b 00                	mov    (%eax),%eax
  802ad0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad3:	8b 52 04             	mov    0x4(%edx),%edx
  802ad6:	89 50 04             	mov    %edx,0x4(%eax)
  802ad9:	eb 0b                	jmp    802ae6 <alloc_block_BF+0x1af>
  802adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ade:	8b 40 04             	mov    0x4(%eax),%eax
  802ae1:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	8b 40 04             	mov    0x4(%eax),%eax
  802aec:	85 c0                	test   %eax,%eax
  802aee:	74 0f                	je     802aff <alloc_block_BF+0x1c8>
  802af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af3:	8b 40 04             	mov    0x4(%eax),%eax
  802af6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af9:	8b 12                	mov    (%edx),%edx
  802afb:	89 10                	mov    %edx,(%eax)
  802afd:	eb 0a                	jmp    802b09 <alloc_block_BF+0x1d2>
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	8b 00                	mov    (%eax),%eax
  802b04:	a3 48 40 98 00       	mov    %eax,0x984048
  802b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b1c:	a1 54 40 98 00       	mov    0x984054,%eax
  802b21:	48                   	dec    %eax
  802b22:	a3 54 40 98 00       	mov    %eax,0x984054
		return (void*)((uint32*)minBlk);
  802b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2a:	e9 98 00 00 00       	jmp    802bc7 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  802b2f:	83 ec 04             	sub    $0x4,%esp
  802b32:	6a 01                	push   $0x1
  802b34:	ff 75 f0             	pushl  -0x10(%ebp)
  802b37:	ff 75 f4             	pushl  -0xc(%ebp)
  802b3a:	e8 d7 f7 ff ff       	call   802316 <set_block_data>
  802b3f:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802b42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b46:	75 17                	jne    802b5f <alloc_block_BF+0x228>
  802b48:	83 ec 04             	sub    $0x4,%esp
  802b4b:	68 74 3e 80 00       	push   $0x803e74
  802b50:	68 56 01 00 00       	push   $0x156
  802b55:	68 cb 3d 80 00       	push   $0x803dcb
  802b5a:	e8 06 08 00 00       	call   803365 <_panic>
  802b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b62:	8b 00                	mov    (%eax),%eax
  802b64:	85 c0                	test   %eax,%eax
  802b66:	74 10                	je     802b78 <alloc_block_BF+0x241>
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	8b 00                	mov    (%eax),%eax
  802b6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b70:	8b 52 04             	mov    0x4(%edx),%edx
  802b73:	89 50 04             	mov    %edx,0x4(%eax)
  802b76:	eb 0b                	jmp    802b83 <alloc_block_BF+0x24c>
  802b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7b:	8b 40 04             	mov    0x4(%eax),%eax
  802b7e:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b86:	8b 40 04             	mov    0x4(%eax),%eax
  802b89:	85 c0                	test   %eax,%eax
  802b8b:	74 0f                	je     802b9c <alloc_block_BF+0x265>
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	8b 40 04             	mov    0x4(%eax),%eax
  802b93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b96:	8b 12                	mov    (%edx),%edx
  802b98:	89 10                	mov    %edx,(%eax)
  802b9a:	eb 0a                	jmp    802ba6 <alloc_block_BF+0x26f>
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	8b 00                	mov    (%eax),%eax
  802ba1:	a3 48 40 98 00       	mov    %eax,0x984048
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb9:	a1 54 40 98 00       	mov    0x984054,%eax
  802bbe:	48                   	dec    %eax
  802bbf:	a3 54 40 98 00       	mov    %eax,0x984054
		return (void*)((uint32*)minBlk);
  802bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802bc7:	c9                   	leave  
  802bc8:	c3                   	ret    

00802bc9 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802bc9:	55                   	push   %ebp
  802bca:	89 e5                	mov    %esp,%ebp
  802bcc:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802bcf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bd3:	0f 84 6a 02 00 00    	je     802e43 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  802bd9:	ff 75 08             	pushl  0x8(%ebp)
  802bdc:	e8 b9 f4 ff ff       	call   80209a <get_block_size>
  802be1:	83 c4 04             	add    $0x4,%esp
  802be4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  802be7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bea:	83 e8 08             	sub    $0x8,%eax
  802bed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  802bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf3:	8b 00                	mov    (%eax),%eax
  802bf5:	83 e0 fe             	and    $0xfffffffe,%eax
  802bf8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  802bfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfe:	f7 d8                	neg    %eax
  802c00:	89 c2                	mov    %eax,%edx
  802c02:	8b 45 08             	mov    0x8(%ebp),%eax
  802c05:	01 d0                	add    %edx,%eax
  802c07:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802c0a:	ff 75 e8             	pushl  -0x18(%ebp)
  802c0d:	e8 a1 f4 ff ff       	call   8020b3 <is_free_block>
  802c12:	83 c4 04             	add    $0x4,%esp
  802c15:	0f be c0             	movsbl %al,%eax
  802c18:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802c1b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c21:	01 d0                	add    %edx,%eax
  802c23:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802c26:	ff 75 e0             	pushl  -0x20(%ebp)
  802c29:	e8 85 f4 ff ff       	call   8020b3 <is_free_block>
  802c2e:	83 c4 04             	add    $0x4,%esp
  802c31:	0f be c0             	movsbl %al,%eax
  802c34:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802c37:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802c3b:	75 34                	jne    802c71 <free_block+0xa8>
  802c3d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802c41:	75 2e                	jne    802c71 <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802c43:	ff 75 e8             	pushl  -0x18(%ebp)
  802c46:	e8 4f f4 ff ff       	call   80209a <get_block_size>
  802c4b:	83 c4 04             	add    $0x4,%esp
  802c4e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802c51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c54:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c57:	01 d0                	add    %edx,%eax
  802c59:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802c5c:	6a 00                	push   $0x0
  802c5e:	ff 75 d4             	pushl  -0x2c(%ebp)
  802c61:	ff 75 e8             	pushl  -0x18(%ebp)
  802c64:	e8 ad f6 ff ff       	call   802316 <set_block_data>
  802c69:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802c6c:	e9 d3 01 00 00       	jmp    802e44 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802c71:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802c75:	0f 85 c8 00 00 00    	jne    802d43 <free_block+0x17a>
  802c7b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c7f:	0f 85 be 00 00 00    	jne    802d43 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802c85:	ff 75 e0             	pushl  -0x20(%ebp)
  802c88:	e8 0d f4 ff ff       	call   80209a <get_block_size>
  802c8d:	83 c4 04             	add    $0x4,%esp
  802c90:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802c93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c96:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c99:	01 d0                	add    %edx,%eax
  802c9b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802c9e:	6a 00                	push   $0x0
  802ca0:	ff 75 cc             	pushl  -0x34(%ebp)
  802ca3:	ff 75 08             	pushl  0x8(%ebp)
  802ca6:	e8 6b f6 ff ff       	call   802316 <set_block_data>
  802cab:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802cae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802cb2:	75 17                	jne    802ccb <free_block+0x102>
  802cb4:	83 ec 04             	sub    $0x4,%esp
  802cb7:	68 74 3e 80 00       	push   $0x803e74
  802cbc:	68 87 01 00 00       	push   $0x187
  802cc1:	68 cb 3d 80 00       	push   $0x803dcb
  802cc6:	e8 9a 06 00 00       	call   803365 <_panic>
  802ccb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cce:	8b 00                	mov    (%eax),%eax
  802cd0:	85 c0                	test   %eax,%eax
  802cd2:	74 10                	je     802ce4 <free_block+0x11b>
  802cd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cd7:	8b 00                	mov    (%eax),%eax
  802cd9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cdc:	8b 52 04             	mov    0x4(%edx),%edx
  802cdf:	89 50 04             	mov    %edx,0x4(%eax)
  802ce2:	eb 0b                	jmp    802cef <free_block+0x126>
  802ce4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ce7:	8b 40 04             	mov    0x4(%eax),%eax
  802cea:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802cef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cf2:	8b 40 04             	mov    0x4(%eax),%eax
  802cf5:	85 c0                	test   %eax,%eax
  802cf7:	74 0f                	je     802d08 <free_block+0x13f>
  802cf9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cfc:	8b 40 04             	mov    0x4(%eax),%eax
  802cff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d02:	8b 12                	mov    (%edx),%edx
  802d04:	89 10                	mov    %edx,(%eax)
  802d06:	eb 0a                	jmp    802d12 <free_block+0x149>
  802d08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d0b:	8b 00                	mov    (%eax),%eax
  802d0d:	a3 48 40 98 00       	mov    %eax,0x984048
  802d12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d25:	a1 54 40 98 00       	mov    0x984054,%eax
  802d2a:	48                   	dec    %eax
  802d2b:	a3 54 40 98 00       	mov    %eax,0x984054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802d30:	83 ec 0c             	sub    $0xc,%esp
  802d33:	ff 75 08             	pushl  0x8(%ebp)
  802d36:	e8 32 f6 ff ff       	call   80236d <insert_sorted_in_freeList>
  802d3b:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802d3e:	e9 01 01 00 00       	jmp    802e44 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  802d43:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802d47:	0f 85 d3 00 00 00    	jne    802e20 <free_block+0x257>
  802d4d:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802d51:	0f 85 c9 00 00 00    	jne    802e20 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  802d57:	83 ec 0c             	sub    $0xc,%esp
  802d5a:	ff 75 e8             	pushl  -0x18(%ebp)
  802d5d:	e8 38 f3 ff ff       	call   80209a <get_block_size>
  802d62:	83 c4 10             	add    $0x10,%esp
  802d65:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  802d68:	83 ec 0c             	sub    $0xc,%esp
  802d6b:	ff 75 e0             	pushl  -0x20(%ebp)
  802d6e:	e8 27 f3 ff ff       	call   80209a <get_block_size>
  802d73:	83 c4 10             	add    $0x10,%esp
  802d76:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  802d79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d7c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d7f:	01 c2                	add    %eax,%edx
  802d81:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d84:	01 d0                	add    %edx,%eax
  802d86:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  802d89:	83 ec 04             	sub    $0x4,%esp
  802d8c:	6a 00                	push   $0x0
  802d8e:	ff 75 c0             	pushl  -0x40(%ebp)
  802d91:	ff 75 e8             	pushl  -0x18(%ebp)
  802d94:	e8 7d f5 ff ff       	call   802316 <set_block_data>
  802d99:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  802d9c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802da0:	75 17                	jne    802db9 <free_block+0x1f0>
  802da2:	83 ec 04             	sub    $0x4,%esp
  802da5:	68 74 3e 80 00       	push   $0x803e74
  802daa:	68 94 01 00 00       	push   $0x194
  802daf:	68 cb 3d 80 00       	push   $0x803dcb
  802db4:	e8 ac 05 00 00       	call   803365 <_panic>
  802db9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dbc:	8b 00                	mov    (%eax),%eax
  802dbe:	85 c0                	test   %eax,%eax
  802dc0:	74 10                	je     802dd2 <free_block+0x209>
  802dc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dc5:	8b 00                	mov    (%eax),%eax
  802dc7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dca:	8b 52 04             	mov    0x4(%edx),%edx
  802dcd:	89 50 04             	mov    %edx,0x4(%eax)
  802dd0:	eb 0b                	jmp    802ddd <free_block+0x214>
  802dd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dd5:	8b 40 04             	mov    0x4(%eax),%eax
  802dd8:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802ddd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802de0:	8b 40 04             	mov    0x4(%eax),%eax
  802de3:	85 c0                	test   %eax,%eax
  802de5:	74 0f                	je     802df6 <free_block+0x22d>
  802de7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dea:	8b 40 04             	mov    0x4(%eax),%eax
  802ded:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802df0:	8b 12                	mov    (%edx),%edx
  802df2:	89 10                	mov    %edx,(%eax)
  802df4:	eb 0a                	jmp    802e00 <free_block+0x237>
  802df6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802df9:	8b 00                	mov    (%eax),%eax
  802dfb:	a3 48 40 98 00       	mov    %eax,0x984048
  802e00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e13:	a1 54 40 98 00       	mov    0x984054,%eax
  802e18:	48                   	dec    %eax
  802e19:	a3 54 40 98 00       	mov    %eax,0x984054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  802e1e:	eb 24                	jmp    802e44 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  802e20:	83 ec 04             	sub    $0x4,%esp
  802e23:	6a 00                	push   $0x0
  802e25:	ff 75 f4             	pushl  -0xc(%ebp)
  802e28:	ff 75 08             	pushl  0x8(%ebp)
  802e2b:	e8 e6 f4 ff ff       	call   802316 <set_block_data>
  802e30:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802e33:	83 ec 0c             	sub    $0xc,%esp
  802e36:	ff 75 08             	pushl  0x8(%ebp)
  802e39:	e8 2f f5 ff ff       	call   80236d <insert_sorted_in_freeList>
  802e3e:	83 c4 10             	add    $0x10,%esp
  802e41:	eb 01                	jmp    802e44 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  802e43:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  802e44:	c9                   	leave  
  802e45:	c3                   	ret    

00802e46 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802e46:	55                   	push   %ebp
  802e47:	89 e5                	mov    %esp,%ebp
  802e49:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  802e4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e50:	75 10                	jne    802e62 <realloc_block_FF+0x1c>
  802e52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e56:	75 0a                	jne    802e62 <realloc_block_FF+0x1c>
	{
		return NULL;
  802e58:	b8 00 00 00 00       	mov    $0x0,%eax
  802e5d:	e9 8b 04 00 00       	jmp    8032ed <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  802e62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e66:	75 18                	jne    802e80 <realloc_block_FF+0x3a>
	{
		free_block(va);
  802e68:	83 ec 0c             	sub    $0xc,%esp
  802e6b:	ff 75 08             	pushl  0x8(%ebp)
  802e6e:	e8 56 fd ff ff       	call   802bc9 <free_block>
  802e73:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802e76:	b8 00 00 00 00       	mov    $0x0,%eax
  802e7b:	e9 6d 04 00 00       	jmp    8032ed <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  802e80:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e84:	75 13                	jne    802e99 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  802e86:	83 ec 0c             	sub    $0xc,%esp
  802e89:	ff 75 0c             	pushl  0xc(%ebp)
  802e8c:	e8 6f f6 ff ff       	call   802500 <alloc_block_FF>
  802e91:	83 c4 10             	add    $0x10,%esp
  802e94:	e9 54 04 00 00       	jmp    8032ed <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  802e99:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9c:	83 e0 01             	and    $0x1,%eax
  802e9f:	85 c0                	test   %eax,%eax
  802ea1:	74 03                	je     802ea6 <realloc_block_FF+0x60>
	{
		new_size++;
  802ea3:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  802ea6:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802eaa:	77 07                	ja     802eb3 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  802eac:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  802eb3:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  802eb7:	83 ec 0c             	sub    $0xc,%esp
  802eba:	ff 75 08             	pushl  0x8(%ebp)
  802ebd:	e8 d8 f1 ff ff       	call   80209a <get_block_size>
  802ec2:	83 c4 10             	add    $0x10,%esp
  802ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  802ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ece:	75 08                	jne    802ed8 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	e9 15 04 00 00       	jmp    8032ed <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  802ed8:	8b 55 08             	mov    0x8(%ebp),%edx
  802edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ede:	01 d0                	add    %edx,%eax
  802ee0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802ee3:	83 ec 0c             	sub    $0xc,%esp
  802ee6:	ff 75 f0             	pushl  -0x10(%ebp)
  802ee9:	e8 c5 f1 ff ff       	call   8020b3 <is_free_block>
  802eee:	83 c4 10             	add    $0x10,%esp
  802ef1:	0f be c0             	movsbl %al,%eax
  802ef4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  802ef7:	83 ec 0c             	sub    $0xc,%esp
  802efa:	ff 75 f0             	pushl  -0x10(%ebp)
  802efd:	e8 98 f1 ff ff       	call   80209a <get_block_size>
  802f02:	83 c4 10             	add    $0x10,%esp
  802f05:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  802f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f0b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802f0e:	0f 86 a7 02 00 00    	jbe    8031bb <realloc_block_FF+0x375>
	{
		if(isNextFree)
  802f14:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f18:	0f 84 86 02 00 00    	je     8031a4 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  802f1e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f24:	01 d0                	add    %edx,%eax
  802f26:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f29:	0f 85 b2 00 00 00    	jne    802fe1 <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  802f2f:	83 ec 0c             	sub    $0xc,%esp
  802f32:	ff 75 08             	pushl  0x8(%ebp)
  802f35:	e8 79 f1 ff ff       	call   8020b3 <is_free_block>
  802f3a:	83 c4 10             	add    $0x10,%esp
  802f3d:	84 c0                	test   %al,%al
  802f3f:	0f 94 c0             	sete   %al
  802f42:	0f b6 c0             	movzbl %al,%eax
  802f45:	83 ec 04             	sub    $0x4,%esp
  802f48:	50                   	push   %eax
  802f49:	ff 75 0c             	pushl  0xc(%ebp)
  802f4c:	ff 75 08             	pushl  0x8(%ebp)
  802f4f:	e8 c2 f3 ff ff       	call   802316 <set_block_data>
  802f54:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  802f57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f5b:	75 17                	jne    802f74 <realloc_block_FF+0x12e>
  802f5d:	83 ec 04             	sub    $0x4,%esp
  802f60:	68 74 3e 80 00       	push   $0x803e74
  802f65:	68 db 01 00 00       	push   $0x1db
  802f6a:	68 cb 3d 80 00       	push   $0x803dcb
  802f6f:	e8 f1 03 00 00       	call   803365 <_panic>
  802f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f77:	8b 00                	mov    (%eax),%eax
  802f79:	85 c0                	test   %eax,%eax
  802f7b:	74 10                	je     802f8d <realloc_block_FF+0x147>
  802f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f80:	8b 00                	mov    (%eax),%eax
  802f82:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f85:	8b 52 04             	mov    0x4(%edx),%edx
  802f88:	89 50 04             	mov    %edx,0x4(%eax)
  802f8b:	eb 0b                	jmp    802f98 <realloc_block_FF+0x152>
  802f8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f90:	8b 40 04             	mov    0x4(%eax),%eax
  802f93:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802f98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9b:	8b 40 04             	mov    0x4(%eax),%eax
  802f9e:	85 c0                	test   %eax,%eax
  802fa0:	74 0f                	je     802fb1 <realloc_block_FF+0x16b>
  802fa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa5:	8b 40 04             	mov    0x4(%eax),%eax
  802fa8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fab:	8b 12                	mov    (%edx),%edx
  802fad:	89 10                	mov    %edx,(%eax)
  802faf:	eb 0a                	jmp    802fbb <realloc_block_FF+0x175>
  802fb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb4:	8b 00                	mov    (%eax),%eax
  802fb6:	a3 48 40 98 00       	mov    %eax,0x984048
  802fbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fce:	a1 54 40 98 00       	mov    0x984054,%eax
  802fd3:	48                   	dec    %eax
  802fd4:	a3 54 40 98 00       	mov    %eax,0x984054
				return va;
  802fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdc:	e9 0c 03 00 00       	jmp    8032ed <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  802fe1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe7:	01 d0                	add    %edx,%eax
  802fe9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802fec:	0f 86 b2 01 00 00    	jbe    8031a4 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  802ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff5:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802ff8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  802ffb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffe:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803001:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  803004:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  803008:	0f 87 b8 00 00 00    	ja     8030c6 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  80300e:	83 ec 0c             	sub    $0xc,%esp
  803011:	ff 75 08             	pushl  0x8(%ebp)
  803014:	e8 9a f0 ff ff       	call   8020b3 <is_free_block>
  803019:	83 c4 10             	add    $0x10,%esp
  80301c:	84 c0                	test   %al,%al
  80301e:	0f 94 c0             	sete   %al
  803021:	0f b6 c0             	movzbl %al,%eax
  803024:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803027:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80302a:	01 ca                	add    %ecx,%edx
  80302c:	83 ec 04             	sub    $0x4,%esp
  80302f:	50                   	push   %eax
  803030:	52                   	push   %edx
  803031:	ff 75 08             	pushl  0x8(%ebp)
  803034:	e8 dd f2 ff ff       	call   802316 <set_block_data>
  803039:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  80303c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803040:	75 17                	jne    803059 <realloc_block_FF+0x213>
  803042:	83 ec 04             	sub    $0x4,%esp
  803045:	68 74 3e 80 00       	push   $0x803e74
  80304a:	68 e8 01 00 00       	push   $0x1e8
  80304f:	68 cb 3d 80 00       	push   $0x803dcb
  803054:	e8 0c 03 00 00       	call   803365 <_panic>
  803059:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305c:	8b 00                	mov    (%eax),%eax
  80305e:	85 c0                	test   %eax,%eax
  803060:	74 10                	je     803072 <realloc_block_FF+0x22c>
  803062:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803065:	8b 00                	mov    (%eax),%eax
  803067:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80306a:	8b 52 04             	mov    0x4(%edx),%edx
  80306d:	89 50 04             	mov    %edx,0x4(%eax)
  803070:	eb 0b                	jmp    80307d <realloc_block_FF+0x237>
  803072:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803075:	8b 40 04             	mov    0x4(%eax),%eax
  803078:	a3 4c 40 98 00       	mov    %eax,0x98404c
  80307d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803080:	8b 40 04             	mov    0x4(%eax),%eax
  803083:	85 c0                	test   %eax,%eax
  803085:	74 0f                	je     803096 <realloc_block_FF+0x250>
  803087:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80308a:	8b 40 04             	mov    0x4(%eax),%eax
  80308d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803090:	8b 12                	mov    (%edx),%edx
  803092:	89 10                	mov    %edx,(%eax)
  803094:	eb 0a                	jmp    8030a0 <realloc_block_FF+0x25a>
  803096:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803099:	8b 00                	mov    (%eax),%eax
  80309b:	a3 48 40 98 00       	mov    %eax,0x984048
  8030a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b3:	a1 54 40 98 00       	mov    0x984054,%eax
  8030b8:	48                   	dec    %eax
  8030b9:	a3 54 40 98 00       	mov    %eax,0x984054
					return va;
  8030be:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c1:	e9 27 02 00 00       	jmp    8032ed <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8030c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030ca:	75 17                	jne    8030e3 <realloc_block_FF+0x29d>
  8030cc:	83 ec 04             	sub    $0x4,%esp
  8030cf:	68 74 3e 80 00       	push   $0x803e74
  8030d4:	68 ed 01 00 00       	push   $0x1ed
  8030d9:	68 cb 3d 80 00       	push   $0x803dcb
  8030de:	e8 82 02 00 00       	call   803365 <_panic>
  8030e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e6:	8b 00                	mov    (%eax),%eax
  8030e8:	85 c0                	test   %eax,%eax
  8030ea:	74 10                	je     8030fc <realloc_block_FF+0x2b6>
  8030ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ef:	8b 00                	mov    (%eax),%eax
  8030f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030f4:	8b 52 04             	mov    0x4(%edx),%edx
  8030f7:	89 50 04             	mov    %edx,0x4(%eax)
  8030fa:	eb 0b                	jmp    803107 <realloc_block_FF+0x2c1>
  8030fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ff:	8b 40 04             	mov    0x4(%eax),%eax
  803102:	a3 4c 40 98 00       	mov    %eax,0x98404c
  803107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310a:	8b 40 04             	mov    0x4(%eax),%eax
  80310d:	85 c0                	test   %eax,%eax
  80310f:	74 0f                	je     803120 <realloc_block_FF+0x2da>
  803111:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803114:	8b 40 04             	mov    0x4(%eax),%eax
  803117:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80311a:	8b 12                	mov    (%edx),%edx
  80311c:	89 10                	mov    %edx,(%eax)
  80311e:	eb 0a                	jmp    80312a <realloc_block_FF+0x2e4>
  803120:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803123:	8b 00                	mov    (%eax),%eax
  803125:	a3 48 40 98 00       	mov    %eax,0x984048
  80312a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803136:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313d:	a1 54 40 98 00       	mov    0x984054,%eax
  803142:	48                   	dec    %eax
  803143:	a3 54 40 98 00       	mov    %eax,0x984054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  803148:	8b 55 08             	mov    0x8(%ebp),%edx
  80314b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80314e:	01 d0                	add    %edx,%eax
  803150:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  803153:	83 ec 04             	sub    $0x4,%esp
  803156:	6a 00                	push   $0x0
  803158:	ff 75 e0             	pushl  -0x20(%ebp)
  80315b:	ff 75 f0             	pushl  -0x10(%ebp)
  80315e:	e8 b3 f1 ff ff       	call   802316 <set_block_data>
  803163:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  803166:	83 ec 0c             	sub    $0xc,%esp
  803169:	ff 75 08             	pushl  0x8(%ebp)
  80316c:	e8 42 ef ff ff       	call   8020b3 <is_free_block>
  803171:	83 c4 10             	add    $0x10,%esp
  803174:	84 c0                	test   %al,%al
  803176:	0f 94 c0             	sete   %al
  803179:	0f b6 c0             	movzbl %al,%eax
  80317c:	83 ec 04             	sub    $0x4,%esp
  80317f:	50                   	push   %eax
  803180:	ff 75 0c             	pushl  0xc(%ebp)
  803183:	ff 75 08             	pushl  0x8(%ebp)
  803186:	e8 8b f1 ff ff       	call   802316 <set_block_data>
  80318b:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  80318e:	83 ec 0c             	sub    $0xc,%esp
  803191:	ff 75 f0             	pushl  -0x10(%ebp)
  803194:	e8 d4 f1 ff ff       	call   80236d <insert_sorted_in_freeList>
  803199:	83 c4 10             	add    $0x10,%esp
					return va;
  80319c:	8b 45 08             	mov    0x8(%ebp),%eax
  80319f:	e9 49 01 00 00       	jmp    8032ed <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  8031a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031a7:	83 e8 08             	sub    $0x8,%eax
  8031aa:	83 ec 0c             	sub    $0xc,%esp
  8031ad:	50                   	push   %eax
  8031ae:	e8 4d f3 ff ff       	call   802500 <alloc_block_FF>
  8031b3:	83 c4 10             	add    $0x10,%esp
  8031b6:	e9 32 01 00 00       	jmp    8032ed <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  8031bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031be:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8031c1:	0f 83 21 01 00 00    	jae    8032e8 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  8031c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ca:	2b 45 0c             	sub    0xc(%ebp),%eax
  8031cd:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  8031d0:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  8031d4:	77 0e                	ja     8031e4 <realloc_block_FF+0x39e>
  8031d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031da:	75 08                	jne    8031e4 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  8031dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031df:	e9 09 01 00 00       	jmp    8032ed <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  8031e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  8031ea:	83 ec 0c             	sub    $0xc,%esp
  8031ed:	ff 75 08             	pushl  0x8(%ebp)
  8031f0:	e8 be ee ff ff       	call   8020b3 <is_free_block>
  8031f5:	83 c4 10             	add    $0x10,%esp
  8031f8:	84 c0                	test   %al,%al
  8031fa:	0f 94 c0             	sete   %al
  8031fd:	0f b6 c0             	movzbl %al,%eax
  803200:	83 ec 04             	sub    $0x4,%esp
  803203:	50                   	push   %eax
  803204:	ff 75 0c             	pushl  0xc(%ebp)
  803207:	ff 75 d8             	pushl  -0x28(%ebp)
  80320a:	e8 07 f1 ff ff       	call   802316 <set_block_data>
  80320f:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  803212:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803215:	8b 45 0c             	mov    0xc(%ebp),%eax
  803218:	01 d0                	add    %edx,%eax
  80321a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  80321d:	83 ec 04             	sub    $0x4,%esp
  803220:	6a 00                	push   $0x0
  803222:	ff 75 dc             	pushl  -0x24(%ebp)
  803225:	ff 75 d4             	pushl  -0x2c(%ebp)
  803228:	e8 e9 f0 ff ff       	call   802316 <set_block_data>
  80322d:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  803230:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803234:	0f 84 9b 00 00 00    	je     8032d5 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  80323a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80323d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803240:	01 d0                	add    %edx,%eax
  803242:	83 ec 04             	sub    $0x4,%esp
  803245:	6a 00                	push   $0x0
  803247:	50                   	push   %eax
  803248:	ff 75 d4             	pushl  -0x2c(%ebp)
  80324b:	e8 c6 f0 ff ff       	call   802316 <set_block_data>
  803250:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  803253:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803257:	75 17                	jne    803270 <realloc_block_FF+0x42a>
  803259:	83 ec 04             	sub    $0x4,%esp
  80325c:	68 74 3e 80 00       	push   $0x803e74
  803261:	68 10 02 00 00       	push   $0x210
  803266:	68 cb 3d 80 00       	push   $0x803dcb
  80326b:	e8 f5 00 00 00       	call   803365 <_panic>
  803270:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803273:	8b 00                	mov    (%eax),%eax
  803275:	85 c0                	test   %eax,%eax
  803277:	74 10                	je     803289 <realloc_block_FF+0x443>
  803279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327c:	8b 00                	mov    (%eax),%eax
  80327e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803281:	8b 52 04             	mov    0x4(%edx),%edx
  803284:	89 50 04             	mov    %edx,0x4(%eax)
  803287:	eb 0b                	jmp    803294 <realloc_block_FF+0x44e>
  803289:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80328c:	8b 40 04             	mov    0x4(%eax),%eax
  80328f:	a3 4c 40 98 00       	mov    %eax,0x98404c
  803294:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803297:	8b 40 04             	mov    0x4(%eax),%eax
  80329a:	85 c0                	test   %eax,%eax
  80329c:	74 0f                	je     8032ad <realloc_block_FF+0x467>
  80329e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a1:	8b 40 04             	mov    0x4(%eax),%eax
  8032a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032a7:	8b 12                	mov    (%edx),%edx
  8032a9:	89 10                	mov    %edx,(%eax)
  8032ab:	eb 0a                	jmp    8032b7 <realloc_block_FF+0x471>
  8032ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b0:	8b 00                	mov    (%eax),%eax
  8032b2:	a3 48 40 98 00       	mov    %eax,0x984048
  8032b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ca:	a1 54 40 98 00       	mov    0x984054,%eax
  8032cf:	48                   	dec    %eax
  8032d0:	a3 54 40 98 00       	mov    %eax,0x984054
			}
			insert_sorted_in_freeList(remainingBlk);
  8032d5:	83 ec 0c             	sub    $0xc,%esp
  8032d8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8032db:	e8 8d f0 ff ff       	call   80236d <insert_sorted_in_freeList>
  8032e0:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  8032e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032e6:	eb 05                	jmp    8032ed <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  8032e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032ed:	c9                   	leave  
  8032ee:	c3                   	ret    

008032ef <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8032ef:	55                   	push   %ebp
  8032f0:	89 e5                	mov    %esp,%ebp
  8032f2:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8032f5:	83 ec 04             	sub    $0x4,%esp
  8032f8:	68 94 3e 80 00       	push   $0x803e94
  8032fd:	68 20 02 00 00       	push   $0x220
  803302:	68 cb 3d 80 00       	push   $0x803dcb
  803307:	e8 59 00 00 00       	call   803365 <_panic>

0080330c <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80330c:	55                   	push   %ebp
  80330d:	89 e5                	mov    %esp,%ebp
  80330f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803312:	83 ec 04             	sub    $0x4,%esp
  803315:	68 bc 3e 80 00       	push   $0x803ebc
  80331a:	68 28 02 00 00       	push   $0x228
  80331f:	68 cb 3d 80 00       	push   $0x803dcb
  803324:	e8 3c 00 00 00       	call   803365 <_panic>

00803329 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  803329:	55                   	push   %ebp
  80332a:	89 e5                	mov    %esp,%ebp
  80332c:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80332f:	8b 45 08             	mov    0x8(%ebp),%eax
  803332:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  803335:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  803339:	83 ec 0c             	sub    $0xc,%esp
  80333c:	50                   	push   %eax
  80333d:	e8 73 e8 ff ff       	call   801bb5 <sys_cputc>
  803342:	83 c4 10             	add    $0x10,%esp
}
  803345:	90                   	nop
  803346:	c9                   	leave  
  803347:	c3                   	ret    

00803348 <getchar>:


int
getchar(void)
{
  803348:	55                   	push   %ebp
  803349:	89 e5                	mov    %esp,%ebp
  80334b:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  80334e:	e8 fe e6 ff ff       	call   801a51 <sys_cgetc>
  803353:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  803356:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  803359:	c9                   	leave  
  80335a:	c3                   	ret    

0080335b <iscons>:

int iscons(int fdnum)
{
  80335b:	55                   	push   %ebp
  80335c:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80335e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803363:	5d                   	pop    %ebp
  803364:	c3                   	ret    

00803365 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803365:	55                   	push   %ebp
  803366:	89 e5                	mov    %esp,%ebp
  803368:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80336b:	8d 45 10             	lea    0x10(%ebp),%eax
  80336e:	83 c0 04             	add    $0x4,%eax
  803371:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803374:	a1 60 40 98 00       	mov    0x984060,%eax
  803379:	85 c0                	test   %eax,%eax
  80337b:	74 16                	je     803393 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80337d:	a1 60 40 98 00       	mov    0x984060,%eax
  803382:	83 ec 08             	sub    $0x8,%esp
  803385:	50                   	push   %eax
  803386:	68 e4 3e 80 00       	push   $0x803ee4
  80338b:	e8 00 d0 ff ff       	call   800390 <cprintf>
  803390:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803393:	a1 04 40 80 00       	mov    0x804004,%eax
  803398:	ff 75 0c             	pushl  0xc(%ebp)
  80339b:	ff 75 08             	pushl  0x8(%ebp)
  80339e:	50                   	push   %eax
  80339f:	68 e9 3e 80 00       	push   $0x803ee9
  8033a4:	e8 e7 cf ff ff       	call   800390 <cprintf>
  8033a9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8033ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8033af:	83 ec 08             	sub    $0x8,%esp
  8033b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8033b5:	50                   	push   %eax
  8033b6:	e8 6a cf ff ff       	call   800325 <vcprintf>
  8033bb:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8033be:	83 ec 08             	sub    $0x8,%esp
  8033c1:	6a 00                	push   $0x0
  8033c3:	68 05 3f 80 00       	push   $0x803f05
  8033c8:	e8 58 cf ff ff       	call   800325 <vcprintf>
  8033cd:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8033d0:	e8 d9 ce ff ff       	call   8002ae <exit>

	// should not return here
	while (1) ;
  8033d5:	eb fe                	jmp    8033d5 <_panic+0x70>

008033d7 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8033d7:	55                   	push   %ebp
  8033d8:	89 e5                	mov    %esp,%ebp
  8033da:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8033dd:	a1 20 40 80 00       	mov    0x804020,%eax
  8033e2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8033e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033eb:	39 c2                	cmp    %eax,%edx
  8033ed:	74 14                	je     803403 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8033ef:	83 ec 04             	sub    $0x4,%esp
  8033f2:	68 08 3f 80 00       	push   $0x803f08
  8033f7:	6a 26                	push   $0x26
  8033f9:	68 54 3f 80 00       	push   $0x803f54
  8033fe:	e8 62 ff ff ff       	call   803365 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803403:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80340a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803411:	e9 c5 00 00 00       	jmp    8034db <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803416:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803419:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803420:	8b 45 08             	mov    0x8(%ebp),%eax
  803423:	01 d0                	add    %edx,%eax
  803425:	8b 00                	mov    (%eax),%eax
  803427:	85 c0                	test   %eax,%eax
  803429:	75 08                	jne    803433 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80342b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80342e:	e9 a5 00 00 00       	jmp    8034d8 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803433:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80343a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803441:	eb 69                	jmp    8034ac <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803443:	a1 20 40 80 00       	mov    0x804020,%eax
  803448:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80344e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803451:	89 d0                	mov    %edx,%eax
  803453:	01 c0                	add    %eax,%eax
  803455:	01 d0                	add    %edx,%eax
  803457:	c1 e0 03             	shl    $0x3,%eax
  80345a:	01 c8                	add    %ecx,%eax
  80345c:	8a 40 04             	mov    0x4(%eax),%al
  80345f:	84 c0                	test   %al,%al
  803461:	75 46                	jne    8034a9 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803463:	a1 20 40 80 00       	mov    0x804020,%eax
  803468:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80346e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803471:	89 d0                	mov    %edx,%eax
  803473:	01 c0                	add    %eax,%eax
  803475:	01 d0                	add    %edx,%eax
  803477:	c1 e0 03             	shl    $0x3,%eax
  80347a:	01 c8                	add    %ecx,%eax
  80347c:	8b 00                	mov    (%eax),%eax
  80347e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803481:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803484:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803489:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80348b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803495:	8b 45 08             	mov    0x8(%ebp),%eax
  803498:	01 c8                	add    %ecx,%eax
  80349a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80349c:	39 c2                	cmp    %eax,%edx
  80349e:	75 09                	jne    8034a9 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8034a0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8034a7:	eb 15                	jmp    8034be <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8034a9:	ff 45 e8             	incl   -0x18(%ebp)
  8034ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8034b1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8034b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ba:	39 c2                	cmp    %eax,%edx
  8034bc:	77 85                	ja     803443 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8034be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034c2:	75 14                	jne    8034d8 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8034c4:	83 ec 04             	sub    $0x4,%esp
  8034c7:	68 60 3f 80 00       	push   $0x803f60
  8034cc:	6a 3a                	push   $0x3a
  8034ce:	68 54 3f 80 00       	push   $0x803f54
  8034d3:	e8 8d fe ff ff       	call   803365 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8034d8:	ff 45 f0             	incl   -0x10(%ebp)
  8034db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034de:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8034e1:	0f 8c 2f ff ff ff    	jl     803416 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8034e7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8034ee:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8034f5:	eb 26                	jmp    80351d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8034f7:	a1 20 40 80 00       	mov    0x804020,%eax
  8034fc:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  803502:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803505:	89 d0                	mov    %edx,%eax
  803507:	01 c0                	add    %eax,%eax
  803509:	01 d0                	add    %edx,%eax
  80350b:	c1 e0 03             	shl    $0x3,%eax
  80350e:	01 c8                	add    %ecx,%eax
  803510:	8a 40 04             	mov    0x4(%eax),%al
  803513:	3c 01                	cmp    $0x1,%al
  803515:	75 03                	jne    80351a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803517:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80351a:	ff 45 e0             	incl   -0x20(%ebp)
  80351d:	a1 20 40 80 00       	mov    0x804020,%eax
  803522:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803528:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80352b:	39 c2                	cmp    %eax,%edx
  80352d:	77 c8                	ja     8034f7 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80352f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803532:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803535:	74 14                	je     80354b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803537:	83 ec 04             	sub    $0x4,%esp
  80353a:	68 b4 3f 80 00       	push   $0x803fb4
  80353f:	6a 44                	push   $0x44
  803541:	68 54 3f 80 00       	push   $0x803f54
  803546:	e8 1a fe ff ff       	call   803365 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80354b:	90                   	nop
  80354c:	c9                   	leave  
  80354d:	c3                   	ret    
  80354e:	66 90                	xchg   %ax,%ax

00803550 <__udivdi3>:
  803550:	55                   	push   %ebp
  803551:	57                   	push   %edi
  803552:	56                   	push   %esi
  803553:	53                   	push   %ebx
  803554:	83 ec 1c             	sub    $0x1c,%esp
  803557:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80355b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80355f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803563:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803567:	89 ca                	mov    %ecx,%edx
  803569:	89 f8                	mov    %edi,%eax
  80356b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80356f:	85 f6                	test   %esi,%esi
  803571:	75 2d                	jne    8035a0 <__udivdi3+0x50>
  803573:	39 cf                	cmp    %ecx,%edi
  803575:	77 65                	ja     8035dc <__udivdi3+0x8c>
  803577:	89 fd                	mov    %edi,%ebp
  803579:	85 ff                	test   %edi,%edi
  80357b:	75 0b                	jne    803588 <__udivdi3+0x38>
  80357d:	b8 01 00 00 00       	mov    $0x1,%eax
  803582:	31 d2                	xor    %edx,%edx
  803584:	f7 f7                	div    %edi
  803586:	89 c5                	mov    %eax,%ebp
  803588:	31 d2                	xor    %edx,%edx
  80358a:	89 c8                	mov    %ecx,%eax
  80358c:	f7 f5                	div    %ebp
  80358e:	89 c1                	mov    %eax,%ecx
  803590:	89 d8                	mov    %ebx,%eax
  803592:	f7 f5                	div    %ebp
  803594:	89 cf                	mov    %ecx,%edi
  803596:	89 fa                	mov    %edi,%edx
  803598:	83 c4 1c             	add    $0x1c,%esp
  80359b:	5b                   	pop    %ebx
  80359c:	5e                   	pop    %esi
  80359d:	5f                   	pop    %edi
  80359e:	5d                   	pop    %ebp
  80359f:	c3                   	ret    
  8035a0:	39 ce                	cmp    %ecx,%esi
  8035a2:	77 28                	ja     8035cc <__udivdi3+0x7c>
  8035a4:	0f bd fe             	bsr    %esi,%edi
  8035a7:	83 f7 1f             	xor    $0x1f,%edi
  8035aa:	75 40                	jne    8035ec <__udivdi3+0x9c>
  8035ac:	39 ce                	cmp    %ecx,%esi
  8035ae:	72 0a                	jb     8035ba <__udivdi3+0x6a>
  8035b0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035b4:	0f 87 9e 00 00 00    	ja     803658 <__udivdi3+0x108>
  8035ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8035bf:	89 fa                	mov    %edi,%edx
  8035c1:	83 c4 1c             	add    $0x1c,%esp
  8035c4:	5b                   	pop    %ebx
  8035c5:	5e                   	pop    %esi
  8035c6:	5f                   	pop    %edi
  8035c7:	5d                   	pop    %ebp
  8035c8:	c3                   	ret    
  8035c9:	8d 76 00             	lea    0x0(%esi),%esi
  8035cc:	31 ff                	xor    %edi,%edi
  8035ce:	31 c0                	xor    %eax,%eax
  8035d0:	89 fa                	mov    %edi,%edx
  8035d2:	83 c4 1c             	add    $0x1c,%esp
  8035d5:	5b                   	pop    %ebx
  8035d6:	5e                   	pop    %esi
  8035d7:	5f                   	pop    %edi
  8035d8:	5d                   	pop    %ebp
  8035d9:	c3                   	ret    
  8035da:	66 90                	xchg   %ax,%ax
  8035dc:	89 d8                	mov    %ebx,%eax
  8035de:	f7 f7                	div    %edi
  8035e0:	31 ff                	xor    %edi,%edi
  8035e2:	89 fa                	mov    %edi,%edx
  8035e4:	83 c4 1c             	add    $0x1c,%esp
  8035e7:	5b                   	pop    %ebx
  8035e8:	5e                   	pop    %esi
  8035e9:	5f                   	pop    %edi
  8035ea:	5d                   	pop    %ebp
  8035eb:	c3                   	ret    
  8035ec:	bd 20 00 00 00       	mov    $0x20,%ebp
  8035f1:	89 eb                	mov    %ebp,%ebx
  8035f3:	29 fb                	sub    %edi,%ebx
  8035f5:	89 f9                	mov    %edi,%ecx
  8035f7:	d3 e6                	shl    %cl,%esi
  8035f9:	89 c5                	mov    %eax,%ebp
  8035fb:	88 d9                	mov    %bl,%cl
  8035fd:	d3 ed                	shr    %cl,%ebp
  8035ff:	89 e9                	mov    %ebp,%ecx
  803601:	09 f1                	or     %esi,%ecx
  803603:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803607:	89 f9                	mov    %edi,%ecx
  803609:	d3 e0                	shl    %cl,%eax
  80360b:	89 c5                	mov    %eax,%ebp
  80360d:	89 d6                	mov    %edx,%esi
  80360f:	88 d9                	mov    %bl,%cl
  803611:	d3 ee                	shr    %cl,%esi
  803613:	89 f9                	mov    %edi,%ecx
  803615:	d3 e2                	shl    %cl,%edx
  803617:	8b 44 24 08          	mov    0x8(%esp),%eax
  80361b:	88 d9                	mov    %bl,%cl
  80361d:	d3 e8                	shr    %cl,%eax
  80361f:	09 c2                	or     %eax,%edx
  803621:	89 d0                	mov    %edx,%eax
  803623:	89 f2                	mov    %esi,%edx
  803625:	f7 74 24 0c          	divl   0xc(%esp)
  803629:	89 d6                	mov    %edx,%esi
  80362b:	89 c3                	mov    %eax,%ebx
  80362d:	f7 e5                	mul    %ebp
  80362f:	39 d6                	cmp    %edx,%esi
  803631:	72 19                	jb     80364c <__udivdi3+0xfc>
  803633:	74 0b                	je     803640 <__udivdi3+0xf0>
  803635:	89 d8                	mov    %ebx,%eax
  803637:	31 ff                	xor    %edi,%edi
  803639:	e9 58 ff ff ff       	jmp    803596 <__udivdi3+0x46>
  80363e:	66 90                	xchg   %ax,%ax
  803640:	8b 54 24 08          	mov    0x8(%esp),%edx
  803644:	89 f9                	mov    %edi,%ecx
  803646:	d3 e2                	shl    %cl,%edx
  803648:	39 c2                	cmp    %eax,%edx
  80364a:	73 e9                	jae    803635 <__udivdi3+0xe5>
  80364c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80364f:	31 ff                	xor    %edi,%edi
  803651:	e9 40 ff ff ff       	jmp    803596 <__udivdi3+0x46>
  803656:	66 90                	xchg   %ax,%ax
  803658:	31 c0                	xor    %eax,%eax
  80365a:	e9 37 ff ff ff       	jmp    803596 <__udivdi3+0x46>
  80365f:	90                   	nop

00803660 <__umoddi3>:
  803660:	55                   	push   %ebp
  803661:	57                   	push   %edi
  803662:	56                   	push   %esi
  803663:	53                   	push   %ebx
  803664:	83 ec 1c             	sub    $0x1c,%esp
  803667:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80366b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80366f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803673:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803677:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80367b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80367f:	89 f3                	mov    %esi,%ebx
  803681:	89 fa                	mov    %edi,%edx
  803683:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803687:	89 34 24             	mov    %esi,(%esp)
  80368a:	85 c0                	test   %eax,%eax
  80368c:	75 1a                	jne    8036a8 <__umoddi3+0x48>
  80368e:	39 f7                	cmp    %esi,%edi
  803690:	0f 86 a2 00 00 00    	jbe    803738 <__umoddi3+0xd8>
  803696:	89 c8                	mov    %ecx,%eax
  803698:	89 f2                	mov    %esi,%edx
  80369a:	f7 f7                	div    %edi
  80369c:	89 d0                	mov    %edx,%eax
  80369e:	31 d2                	xor    %edx,%edx
  8036a0:	83 c4 1c             	add    $0x1c,%esp
  8036a3:	5b                   	pop    %ebx
  8036a4:	5e                   	pop    %esi
  8036a5:	5f                   	pop    %edi
  8036a6:	5d                   	pop    %ebp
  8036a7:	c3                   	ret    
  8036a8:	39 f0                	cmp    %esi,%eax
  8036aa:	0f 87 ac 00 00 00    	ja     80375c <__umoddi3+0xfc>
  8036b0:	0f bd e8             	bsr    %eax,%ebp
  8036b3:	83 f5 1f             	xor    $0x1f,%ebp
  8036b6:	0f 84 ac 00 00 00    	je     803768 <__umoddi3+0x108>
  8036bc:	bf 20 00 00 00       	mov    $0x20,%edi
  8036c1:	29 ef                	sub    %ebp,%edi
  8036c3:	89 fe                	mov    %edi,%esi
  8036c5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036c9:	89 e9                	mov    %ebp,%ecx
  8036cb:	d3 e0                	shl    %cl,%eax
  8036cd:	89 d7                	mov    %edx,%edi
  8036cf:	89 f1                	mov    %esi,%ecx
  8036d1:	d3 ef                	shr    %cl,%edi
  8036d3:	09 c7                	or     %eax,%edi
  8036d5:	89 e9                	mov    %ebp,%ecx
  8036d7:	d3 e2                	shl    %cl,%edx
  8036d9:	89 14 24             	mov    %edx,(%esp)
  8036dc:	89 d8                	mov    %ebx,%eax
  8036de:	d3 e0                	shl    %cl,%eax
  8036e0:	89 c2                	mov    %eax,%edx
  8036e2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036e6:	d3 e0                	shl    %cl,%eax
  8036e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036ec:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036f0:	89 f1                	mov    %esi,%ecx
  8036f2:	d3 e8                	shr    %cl,%eax
  8036f4:	09 d0                	or     %edx,%eax
  8036f6:	d3 eb                	shr    %cl,%ebx
  8036f8:	89 da                	mov    %ebx,%edx
  8036fa:	f7 f7                	div    %edi
  8036fc:	89 d3                	mov    %edx,%ebx
  8036fe:	f7 24 24             	mull   (%esp)
  803701:	89 c6                	mov    %eax,%esi
  803703:	89 d1                	mov    %edx,%ecx
  803705:	39 d3                	cmp    %edx,%ebx
  803707:	0f 82 87 00 00 00    	jb     803794 <__umoddi3+0x134>
  80370d:	0f 84 91 00 00 00    	je     8037a4 <__umoddi3+0x144>
  803713:	8b 54 24 04          	mov    0x4(%esp),%edx
  803717:	29 f2                	sub    %esi,%edx
  803719:	19 cb                	sbb    %ecx,%ebx
  80371b:	89 d8                	mov    %ebx,%eax
  80371d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803721:	d3 e0                	shl    %cl,%eax
  803723:	89 e9                	mov    %ebp,%ecx
  803725:	d3 ea                	shr    %cl,%edx
  803727:	09 d0                	or     %edx,%eax
  803729:	89 e9                	mov    %ebp,%ecx
  80372b:	d3 eb                	shr    %cl,%ebx
  80372d:	89 da                	mov    %ebx,%edx
  80372f:	83 c4 1c             	add    $0x1c,%esp
  803732:	5b                   	pop    %ebx
  803733:	5e                   	pop    %esi
  803734:	5f                   	pop    %edi
  803735:	5d                   	pop    %ebp
  803736:	c3                   	ret    
  803737:	90                   	nop
  803738:	89 fd                	mov    %edi,%ebp
  80373a:	85 ff                	test   %edi,%edi
  80373c:	75 0b                	jne    803749 <__umoddi3+0xe9>
  80373e:	b8 01 00 00 00       	mov    $0x1,%eax
  803743:	31 d2                	xor    %edx,%edx
  803745:	f7 f7                	div    %edi
  803747:	89 c5                	mov    %eax,%ebp
  803749:	89 f0                	mov    %esi,%eax
  80374b:	31 d2                	xor    %edx,%edx
  80374d:	f7 f5                	div    %ebp
  80374f:	89 c8                	mov    %ecx,%eax
  803751:	f7 f5                	div    %ebp
  803753:	89 d0                	mov    %edx,%eax
  803755:	e9 44 ff ff ff       	jmp    80369e <__umoddi3+0x3e>
  80375a:	66 90                	xchg   %ax,%ax
  80375c:	89 c8                	mov    %ecx,%eax
  80375e:	89 f2                	mov    %esi,%edx
  803760:	83 c4 1c             	add    $0x1c,%esp
  803763:	5b                   	pop    %ebx
  803764:	5e                   	pop    %esi
  803765:	5f                   	pop    %edi
  803766:	5d                   	pop    %ebp
  803767:	c3                   	ret    
  803768:	3b 04 24             	cmp    (%esp),%eax
  80376b:	72 06                	jb     803773 <__umoddi3+0x113>
  80376d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803771:	77 0f                	ja     803782 <__umoddi3+0x122>
  803773:	89 f2                	mov    %esi,%edx
  803775:	29 f9                	sub    %edi,%ecx
  803777:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80377b:	89 14 24             	mov    %edx,(%esp)
  80377e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803782:	8b 44 24 04          	mov    0x4(%esp),%eax
  803786:	8b 14 24             	mov    (%esp),%edx
  803789:	83 c4 1c             	add    $0x1c,%esp
  80378c:	5b                   	pop    %ebx
  80378d:	5e                   	pop    %esi
  80378e:	5f                   	pop    %edi
  80378f:	5d                   	pop    %ebp
  803790:	c3                   	ret    
  803791:	8d 76 00             	lea    0x0(%esi),%esi
  803794:	2b 04 24             	sub    (%esp),%eax
  803797:	19 fa                	sbb    %edi,%edx
  803799:	89 d1                	mov    %edx,%ecx
  80379b:	89 c6                	mov    %eax,%esi
  80379d:	e9 71 ff ff ff       	jmp    803713 <__umoddi3+0xb3>
  8037a2:	66 90                	xchg   %ax,%ax
  8037a4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037a8:	72 ea                	jb     803794 <__umoddi3+0x134>
  8037aa:	89 d9                	mov    %ebx,%ecx
  8037ac:	e9 62 ff ff ff       	jmp    803713 <__umoddi3+0xb3>
