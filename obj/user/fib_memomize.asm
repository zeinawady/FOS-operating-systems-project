
obj/user/fib_memomize:     file format elf32-i386


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
  800031:	e8 7f 01 00 00       	call   8001b5 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int64 fibonacci(int n, int64 *memo);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	int index=0;
  800041:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	char buff1[256];
	atomic_readline("Please enter Fibonacci index:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 00 38 80 00       	push   $0x803800
  800057:	e8 05 0b 00 00       	call   800b61 <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	index = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 58 0f 00 00       	call   800fca <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int64 *memo = malloc((index+1) * sizeof(int64));
  800078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007b:	40                   	inc    %eax
  80007c:	c1 e0 03             	shl    $0x3,%eax
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	e8 fe 12 00 00       	call   801386 <malloc>
  800088:	83 c4 10             	add    $0x10,%esp
  80008b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (int i = 0; i <= index; ++i)
  80008e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800095:	eb 1f                	jmp    8000b6 <_main+0x7e>
	{
		memo[i] = 0;
  800097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80009a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8000a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a4:	01 d0                	add    %edx,%eax
  8000a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8000ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	char buff1[256];
	atomic_readline("Please enter Fibonacci index:", buff1);
	index = strtol(buff1, NULL, 10);

	int64 *memo = malloc((index+1) * sizeof(int64));
	for (int i = 0; i <= index; ++i)
  8000b3:	ff 45 f4             	incl   -0xc(%ebp)
  8000b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000bc:	7e d9                	jle    800097 <_main+0x5f>
	{
		memo[i] = 0;
	}
	int64 res = fibonacci(index, memo) ;
  8000be:	83 ec 08             	sub    $0x8,%esp
  8000c1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8000c7:	e8 35 00 00 00       	call   800101 <fibonacci>
  8000cc:	83 c4 10             	add    $0x10,%esp
  8000cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)

	free(memo);
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000db:	e8 5c 14 00 00       	call   80153c <free>
  8000e0:	83 c4 10             	add    $0x10,%esp

	atomic_cprintf("Fibonacci #%d = %lld\n",index, res);
  8000e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e6:	ff 75 e0             	pushl  -0x20(%ebp)
  8000e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8000ec:	68 1e 38 80 00       	push   $0x80381e
  8000f1:	e8 05 03 00 00       	call   8003fb <atomic_cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000f9:	e8 64 1d 00 00       	call   801e62 <inctst>
	return;
  8000fe:	90                   	nop
}
  8000ff:	c9                   	leave  
  800100:	c3                   	ret    

00800101 <fibonacci>:


int64 fibonacci(int n, int64 *memo)
{
  800101:	55                   	push   %ebp
  800102:	89 e5                	mov    %esp,%ebp
  800104:	57                   	push   %edi
  800105:	56                   	push   %esi
  800106:	53                   	push   %ebx
  800107:	83 ec 0c             	sub    $0xc,%esp
	if (memo[n]!=0)	return memo[n];
  80010a:	8b 45 08             	mov    0x8(%ebp),%eax
  80010d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800114:	8b 45 0c             	mov    0xc(%ebp),%eax
  800117:	01 d0                	add    %edx,%eax
  800119:	8b 50 04             	mov    0x4(%eax),%edx
  80011c:	8b 00                	mov    (%eax),%eax
  80011e:	09 d0                	or     %edx,%eax
  800120:	85 c0                	test   %eax,%eax
  800122:	74 16                	je     80013a <fibonacci+0x39>
  800124:	8b 45 08             	mov    0x8(%ebp),%eax
  800127:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80012e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800131:	01 d0                	add    %edx,%eax
  800133:	8b 50 04             	mov    0x4(%eax),%edx
  800136:	8b 00                	mov    (%eax),%eax
  800138:	eb 73                	jmp    8001ad <fibonacci+0xac>
	if (n <= 1)
  80013a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80013e:	7f 23                	jg     800163 <fibonacci+0x62>
		return memo[n] = 1 ;
  800140:	8b 45 08             	mov    0x8(%ebp),%eax
  800143:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80014a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80014d:	01 d0                	add    %edx,%eax
  80014f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  800155:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80015c:	8b 50 04             	mov    0x4(%eax),%edx
  80015f:	8b 00                	mov    (%eax),%eax
  800161:	eb 4a                	jmp    8001ad <fibonacci+0xac>
	return (memo[n] = fibonacci(n-1, memo) + fibonacci(n-2, memo)) ;
  800163:	8b 45 08             	mov    0x8(%ebp),%eax
  800166:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80016d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800170:	8d 3c 02             	lea    (%edx,%eax,1),%edi
  800173:	8b 45 08             	mov    0x8(%ebp),%eax
  800176:	48                   	dec    %eax
  800177:	83 ec 08             	sub    $0x8,%esp
  80017a:	ff 75 0c             	pushl  0xc(%ebp)
  80017d:	50                   	push   %eax
  80017e:	e8 7e ff ff ff       	call   800101 <fibonacci>
  800183:	83 c4 10             	add    $0x10,%esp
  800186:	89 c3                	mov    %eax,%ebx
  800188:	89 d6                	mov    %edx,%esi
  80018a:	8b 45 08             	mov    0x8(%ebp),%eax
  80018d:	83 e8 02             	sub    $0x2,%eax
  800190:	83 ec 08             	sub    $0x8,%esp
  800193:	ff 75 0c             	pushl  0xc(%ebp)
  800196:	50                   	push   %eax
  800197:	e8 65 ff ff ff       	call   800101 <fibonacci>
  80019c:	83 c4 10             	add    $0x10,%esp
  80019f:	01 d8                	add    %ebx,%eax
  8001a1:	11 f2                	adc    %esi,%edx
  8001a3:	89 07                	mov    %eax,(%edi)
  8001a5:	89 57 04             	mov    %edx,0x4(%edi)
  8001a8:	8b 07                	mov    (%edi),%eax
  8001aa:	8b 57 04             	mov    0x4(%edi),%edx
}
  8001ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b0:	5b                   	pop    %ebx
  8001b1:	5e                   	pop    %esi
  8001b2:	5f                   	pop    %edi
  8001b3:	5d                   	pop    %ebp
  8001b4:	c3                   	ret    

008001b5 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8001bb:	e8 64 1b 00 00       	call   801d24 <sys_getenvindex>
  8001c0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8001c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001c6:	89 d0                	mov    %edx,%eax
  8001c8:	c1 e0 02             	shl    $0x2,%eax
  8001cb:	01 d0                	add    %edx,%eax
  8001cd:	c1 e0 03             	shl    $0x3,%eax
  8001d0:	01 d0                	add    %edx,%eax
  8001d2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8001d9:	01 d0                	add    %edx,%eax
  8001db:	c1 e0 02             	shl    $0x2,%eax
  8001de:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001e3:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001e8:	a1 20 50 80 00       	mov    0x805020,%eax
  8001ed:	8a 40 20             	mov    0x20(%eax),%al
  8001f0:	84 c0                	test   %al,%al
  8001f2:	74 0d                	je     800201 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  8001f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8001f9:	83 c0 20             	add    $0x20,%eax
  8001fc:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800201:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800205:	7e 0a                	jle    800211 <libmain+0x5c>
		binaryname = argv[0];
  800207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020a:	8b 00                	mov    (%eax),%eax
  80020c:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800211:	83 ec 08             	sub    $0x8,%esp
  800214:	ff 75 0c             	pushl  0xc(%ebp)
  800217:	ff 75 08             	pushl  0x8(%ebp)
  80021a:	e8 19 fe ff ff       	call   800038 <_main>
  80021f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800222:	a1 00 50 80 00       	mov    0x805000,%eax
  800227:	85 c0                	test   %eax,%eax
  800229:	0f 84 9f 00 00 00    	je     8002ce <libmain+0x119>
	{
		sys_lock_cons();
  80022f:	e8 74 18 00 00       	call   801aa8 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 4c 38 80 00       	push   $0x80384c
  80023c:	e8 8d 01 00 00       	call   8003ce <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800244:	a1 20 50 80 00       	mov    0x805020,%eax
  800249:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80024f:	a1 20 50 80 00       	mov    0x805020,%eax
  800254:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80025a:	83 ec 04             	sub    $0x4,%esp
  80025d:	52                   	push   %edx
  80025e:	50                   	push   %eax
  80025f:	68 74 38 80 00       	push   $0x803874
  800264:	e8 65 01 00 00       	call   8003ce <cprintf>
  800269:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80026c:	a1 20 50 80 00       	mov    0x805020,%eax
  800271:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800277:	a1 20 50 80 00       	mov    0x805020,%eax
  80027c:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800282:	a1 20 50 80 00       	mov    0x805020,%eax
  800287:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80028d:	51                   	push   %ecx
  80028e:	52                   	push   %edx
  80028f:	50                   	push   %eax
  800290:	68 9c 38 80 00       	push   $0x80389c
  800295:	e8 34 01 00 00       	call   8003ce <cprintf>
  80029a:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80029d:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a2:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8002a8:	83 ec 08             	sub    $0x8,%esp
  8002ab:	50                   	push   %eax
  8002ac:	68 f4 38 80 00       	push   $0x8038f4
  8002b1:	e8 18 01 00 00       	call   8003ce <cprintf>
  8002b6:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002b9:	83 ec 0c             	sub    $0xc,%esp
  8002bc:	68 4c 38 80 00       	push   $0x80384c
  8002c1:	e8 08 01 00 00       	call   8003ce <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002c9:	e8 f4 17 00 00       	call   801ac2 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002ce:	e8 19 00 00 00       	call   8002ec <exit>
}
  8002d3:	90                   	nop
  8002d4:	c9                   	leave  
  8002d5:	c3                   	ret    

008002d6 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002dc:	83 ec 0c             	sub    $0xc,%esp
  8002df:	6a 00                	push   $0x0
  8002e1:	e8 0a 1a 00 00       	call   801cf0 <sys_destroy_env>
  8002e6:	83 c4 10             	add    $0x10,%esp
}
  8002e9:	90                   	nop
  8002ea:	c9                   	leave  
  8002eb:	c3                   	ret    

008002ec <exit>:

void
exit(void)
{
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002f2:	e8 5f 1a 00 00       	call   801d56 <sys_exit_env>
}
  8002f7:	90                   	nop
  8002f8:	c9                   	leave  
  8002f9:	c3                   	ret    

008002fa <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002fa:	55                   	push   %ebp
  8002fb:	89 e5                	mov    %esp,%ebp
  8002fd:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800300:	8b 45 0c             	mov    0xc(%ebp),%eax
  800303:	8b 00                	mov    (%eax),%eax
  800305:	8d 48 01             	lea    0x1(%eax),%ecx
  800308:	8b 55 0c             	mov    0xc(%ebp),%edx
  80030b:	89 0a                	mov    %ecx,(%edx)
  80030d:	8b 55 08             	mov    0x8(%ebp),%edx
  800310:	88 d1                	mov    %dl,%cl
  800312:	8b 55 0c             	mov    0xc(%ebp),%edx
  800315:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800319:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031c:	8b 00                	mov    (%eax),%eax
  80031e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800323:	75 2c                	jne    800351 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800325:	a0 44 50 98 00       	mov    0x985044,%al
  80032a:	0f b6 c0             	movzbl %al,%eax
  80032d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800330:	8b 12                	mov    (%edx),%edx
  800332:	89 d1                	mov    %edx,%ecx
  800334:	8b 55 0c             	mov    0xc(%ebp),%edx
  800337:	83 c2 08             	add    $0x8,%edx
  80033a:	83 ec 04             	sub    $0x4,%esp
  80033d:	50                   	push   %eax
  80033e:	51                   	push   %ecx
  80033f:	52                   	push   %edx
  800340:	e8 21 17 00 00       	call   801a66 <sys_cputs>
  800345:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800351:	8b 45 0c             	mov    0xc(%ebp),%eax
  800354:	8b 40 04             	mov    0x4(%eax),%eax
  800357:	8d 50 01             	lea    0x1(%eax),%edx
  80035a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80035d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800360:	90                   	nop
  800361:	c9                   	leave  
  800362:	c3                   	ret    

00800363 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800363:	55                   	push   %ebp
  800364:	89 e5                	mov    %esp,%ebp
  800366:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80036c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800373:	00 00 00 
	b.cnt = 0;
  800376:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80037d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800380:	ff 75 0c             	pushl  0xc(%ebp)
  800383:	ff 75 08             	pushl  0x8(%ebp)
  800386:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80038c:	50                   	push   %eax
  80038d:	68 fa 02 80 00       	push   $0x8002fa
  800392:	e8 11 02 00 00       	call   8005a8 <vprintfmt>
  800397:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80039a:	a0 44 50 98 00       	mov    0x985044,%al
  80039f:	0f b6 c0             	movzbl %al,%eax
  8003a2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8003a8:	83 ec 04             	sub    $0x4,%esp
  8003ab:	50                   	push   %eax
  8003ac:	52                   	push   %edx
  8003ad:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003b3:	83 c0 08             	add    $0x8,%eax
  8003b6:	50                   	push   %eax
  8003b7:	e8 aa 16 00 00       	call   801a66 <sys_cputs>
  8003bc:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8003bf:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  8003c6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8003cc:	c9                   	leave  
  8003cd:	c3                   	ret    

008003ce <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8003ce:	55                   	push   %ebp
  8003cf:	89 e5                	mov    %esp,%ebp
  8003d1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003d4:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  8003db:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e4:	83 ec 08             	sub    $0x8,%esp
  8003e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ea:	50                   	push   %eax
  8003eb:	e8 73 ff ff ff       	call   800363 <vcprintf>
  8003f0:	83 c4 10             	add    $0x10,%esp
  8003f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003f9:	c9                   	leave  
  8003fa:	c3                   	ret    

008003fb <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003fb:	55                   	push   %ebp
  8003fc:	89 e5                	mov    %esp,%ebp
  8003fe:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800401:	e8 a2 16 00 00       	call   801aa8 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800406:	8d 45 0c             	lea    0xc(%ebp),%eax
  800409:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80040c:	8b 45 08             	mov    0x8(%ebp),%eax
  80040f:	83 ec 08             	sub    $0x8,%esp
  800412:	ff 75 f4             	pushl  -0xc(%ebp)
  800415:	50                   	push   %eax
  800416:	e8 48 ff ff ff       	call   800363 <vcprintf>
  80041b:	83 c4 10             	add    $0x10,%esp
  80041e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800421:	e8 9c 16 00 00       	call   801ac2 <sys_unlock_cons>
	return cnt;
  800426:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800429:	c9                   	leave  
  80042a:	c3                   	ret    

0080042b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80042b:	55                   	push   %ebp
  80042c:	89 e5                	mov    %esp,%ebp
  80042e:	53                   	push   %ebx
  80042f:	83 ec 14             	sub    $0x14,%esp
  800432:	8b 45 10             	mov    0x10(%ebp),%eax
  800435:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800438:	8b 45 14             	mov    0x14(%ebp),%eax
  80043b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80043e:	8b 45 18             	mov    0x18(%ebp),%eax
  800441:	ba 00 00 00 00       	mov    $0x0,%edx
  800446:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800449:	77 55                	ja     8004a0 <printnum+0x75>
  80044b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80044e:	72 05                	jb     800455 <printnum+0x2a>
  800450:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800453:	77 4b                	ja     8004a0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800455:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800458:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80045b:	8b 45 18             	mov    0x18(%ebp),%eax
  80045e:	ba 00 00 00 00       	mov    $0x0,%edx
  800463:	52                   	push   %edx
  800464:	50                   	push   %eax
  800465:	ff 75 f4             	pushl  -0xc(%ebp)
  800468:	ff 75 f0             	pushl  -0x10(%ebp)
  80046b:	e8 1c 31 00 00       	call   80358c <__udivdi3>
  800470:	83 c4 10             	add    $0x10,%esp
  800473:	83 ec 04             	sub    $0x4,%esp
  800476:	ff 75 20             	pushl  0x20(%ebp)
  800479:	53                   	push   %ebx
  80047a:	ff 75 18             	pushl  0x18(%ebp)
  80047d:	52                   	push   %edx
  80047e:	50                   	push   %eax
  80047f:	ff 75 0c             	pushl  0xc(%ebp)
  800482:	ff 75 08             	pushl  0x8(%ebp)
  800485:	e8 a1 ff ff ff       	call   80042b <printnum>
  80048a:	83 c4 20             	add    $0x20,%esp
  80048d:	eb 1a                	jmp    8004a9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	ff 75 0c             	pushl  0xc(%ebp)
  800495:	ff 75 20             	pushl  0x20(%ebp)
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	ff d0                	call   *%eax
  80049d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004a0:	ff 4d 1c             	decl   0x1c(%ebp)
  8004a3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004a7:	7f e6                	jg     80048f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004a9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004b7:	53                   	push   %ebx
  8004b8:	51                   	push   %ecx
  8004b9:	52                   	push   %edx
  8004ba:	50                   	push   %eax
  8004bb:	e8 dc 31 00 00       	call   80369c <__umoddi3>
  8004c0:	83 c4 10             	add    $0x10,%esp
  8004c3:	05 34 3b 80 00       	add    $0x803b34,%eax
  8004c8:	8a 00                	mov    (%eax),%al
  8004ca:	0f be c0             	movsbl %al,%eax
  8004cd:	83 ec 08             	sub    $0x8,%esp
  8004d0:	ff 75 0c             	pushl  0xc(%ebp)
  8004d3:	50                   	push   %eax
  8004d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d7:	ff d0                	call   *%eax
  8004d9:	83 c4 10             	add    $0x10,%esp
}
  8004dc:	90                   	nop
  8004dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004e0:	c9                   	leave  
  8004e1:	c3                   	ret    

008004e2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004e2:	55                   	push   %ebp
  8004e3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004e5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004e9:	7e 1c                	jle    800507 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ee:	8b 00                	mov    (%eax),%eax
  8004f0:	8d 50 08             	lea    0x8(%eax),%edx
  8004f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f6:	89 10                	mov    %edx,(%eax)
  8004f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fb:	8b 00                	mov    (%eax),%eax
  8004fd:	83 e8 08             	sub    $0x8,%eax
  800500:	8b 50 04             	mov    0x4(%eax),%edx
  800503:	8b 00                	mov    (%eax),%eax
  800505:	eb 40                	jmp    800547 <getuint+0x65>
	else if (lflag)
  800507:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80050b:	74 1e                	je     80052b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	8d 50 04             	lea    0x4(%eax),%edx
  800515:	8b 45 08             	mov    0x8(%ebp),%eax
  800518:	89 10                	mov    %edx,(%eax)
  80051a:	8b 45 08             	mov    0x8(%ebp),%eax
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	83 e8 04             	sub    $0x4,%eax
  800522:	8b 00                	mov    (%eax),%eax
  800524:	ba 00 00 00 00       	mov    $0x0,%edx
  800529:	eb 1c                	jmp    800547 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80052b:	8b 45 08             	mov    0x8(%ebp),%eax
  80052e:	8b 00                	mov    (%eax),%eax
  800530:	8d 50 04             	lea    0x4(%eax),%edx
  800533:	8b 45 08             	mov    0x8(%ebp),%eax
  800536:	89 10                	mov    %edx,(%eax)
  800538:	8b 45 08             	mov    0x8(%ebp),%eax
  80053b:	8b 00                	mov    (%eax),%eax
  80053d:	83 e8 04             	sub    $0x4,%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800547:	5d                   	pop    %ebp
  800548:	c3                   	ret    

00800549 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800549:	55                   	push   %ebp
  80054a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80054c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800550:	7e 1c                	jle    80056e <getint+0x25>
		return va_arg(*ap, long long);
  800552:	8b 45 08             	mov    0x8(%ebp),%eax
  800555:	8b 00                	mov    (%eax),%eax
  800557:	8d 50 08             	lea    0x8(%eax),%edx
  80055a:	8b 45 08             	mov    0x8(%ebp),%eax
  80055d:	89 10                	mov    %edx,(%eax)
  80055f:	8b 45 08             	mov    0x8(%ebp),%eax
  800562:	8b 00                	mov    (%eax),%eax
  800564:	83 e8 08             	sub    $0x8,%eax
  800567:	8b 50 04             	mov    0x4(%eax),%edx
  80056a:	8b 00                	mov    (%eax),%eax
  80056c:	eb 38                	jmp    8005a6 <getint+0x5d>
	else if (lflag)
  80056e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800572:	74 1a                	je     80058e <getint+0x45>
		return va_arg(*ap, long);
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	8b 00                	mov    (%eax),%eax
  800579:	8d 50 04             	lea    0x4(%eax),%edx
  80057c:	8b 45 08             	mov    0x8(%ebp),%eax
  80057f:	89 10                	mov    %edx,(%eax)
  800581:	8b 45 08             	mov    0x8(%ebp),%eax
  800584:	8b 00                	mov    (%eax),%eax
  800586:	83 e8 04             	sub    $0x4,%eax
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	99                   	cltd   
  80058c:	eb 18                	jmp    8005a6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80058e:	8b 45 08             	mov    0x8(%ebp),%eax
  800591:	8b 00                	mov    (%eax),%eax
  800593:	8d 50 04             	lea    0x4(%eax),%edx
  800596:	8b 45 08             	mov    0x8(%ebp),%eax
  800599:	89 10                	mov    %edx,(%eax)
  80059b:	8b 45 08             	mov    0x8(%ebp),%eax
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	83 e8 04             	sub    $0x4,%eax
  8005a3:	8b 00                	mov    (%eax),%eax
  8005a5:	99                   	cltd   
}
  8005a6:	5d                   	pop    %ebp
  8005a7:	c3                   	ret    

008005a8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005a8:	55                   	push   %ebp
  8005a9:	89 e5                	mov    %esp,%ebp
  8005ab:	56                   	push   %esi
  8005ac:	53                   	push   %ebx
  8005ad:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005b0:	eb 17                	jmp    8005c9 <vprintfmt+0x21>
			if (ch == '\0')
  8005b2:	85 db                	test   %ebx,%ebx
  8005b4:	0f 84 c1 03 00 00    	je     80097b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8005ba:	83 ec 08             	sub    $0x8,%esp
  8005bd:	ff 75 0c             	pushl  0xc(%ebp)
  8005c0:	53                   	push   %ebx
  8005c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c4:	ff d0                	call   *%eax
  8005c6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cc:	8d 50 01             	lea    0x1(%eax),%edx
  8005cf:	89 55 10             	mov    %edx,0x10(%ebp)
  8005d2:	8a 00                	mov    (%eax),%al
  8005d4:	0f b6 d8             	movzbl %al,%ebx
  8005d7:	83 fb 25             	cmp    $0x25,%ebx
  8005da:	75 d6                	jne    8005b2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005dc:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005e0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005e7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005ee:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005f5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ff:	8d 50 01             	lea    0x1(%eax),%edx
  800602:	89 55 10             	mov    %edx,0x10(%ebp)
  800605:	8a 00                	mov    (%eax),%al
  800607:	0f b6 d8             	movzbl %al,%ebx
  80060a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80060d:	83 f8 5b             	cmp    $0x5b,%eax
  800610:	0f 87 3d 03 00 00    	ja     800953 <vprintfmt+0x3ab>
  800616:	8b 04 85 58 3b 80 00 	mov    0x803b58(,%eax,4),%eax
  80061d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80061f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800623:	eb d7                	jmp    8005fc <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800625:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800629:	eb d1                	jmp    8005fc <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80062b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800632:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800635:	89 d0                	mov    %edx,%eax
  800637:	c1 e0 02             	shl    $0x2,%eax
  80063a:	01 d0                	add    %edx,%eax
  80063c:	01 c0                	add    %eax,%eax
  80063e:	01 d8                	add    %ebx,%eax
  800640:	83 e8 30             	sub    $0x30,%eax
  800643:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800646:	8b 45 10             	mov    0x10(%ebp),%eax
  800649:	8a 00                	mov    (%eax),%al
  80064b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80064e:	83 fb 2f             	cmp    $0x2f,%ebx
  800651:	7e 3e                	jle    800691 <vprintfmt+0xe9>
  800653:	83 fb 39             	cmp    $0x39,%ebx
  800656:	7f 39                	jg     800691 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800658:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80065b:	eb d5                	jmp    800632 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80065d:	8b 45 14             	mov    0x14(%ebp),%eax
  800660:	83 c0 04             	add    $0x4,%eax
  800663:	89 45 14             	mov    %eax,0x14(%ebp)
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	83 e8 04             	sub    $0x4,%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800671:	eb 1f                	jmp    800692 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800673:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800677:	79 83                	jns    8005fc <vprintfmt+0x54>
				width = 0;
  800679:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800680:	e9 77 ff ff ff       	jmp    8005fc <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800685:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80068c:	e9 6b ff ff ff       	jmp    8005fc <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800691:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800692:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800696:	0f 89 60 ff ff ff    	jns    8005fc <vprintfmt+0x54>
				width = precision, precision = -1;
  80069c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80069f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006a2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8006a9:	e9 4e ff ff ff       	jmp    8005fc <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006ae:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8006b1:	e9 46 ff ff ff       	jmp    8005fc <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b9:	83 c0 04             	add    $0x4,%eax
  8006bc:	89 45 14             	mov    %eax,0x14(%ebp)
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	83 e8 04             	sub    $0x4,%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	83 ec 08             	sub    $0x8,%esp
  8006ca:	ff 75 0c             	pushl  0xc(%ebp)
  8006cd:	50                   	push   %eax
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	ff d0                	call   *%eax
  8006d3:	83 c4 10             	add    $0x10,%esp
			break;
  8006d6:	e9 9b 02 00 00       	jmp    800976 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	83 c0 04             	add    $0x4,%eax
  8006e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	83 e8 04             	sub    $0x4,%eax
  8006ea:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006ec:	85 db                	test   %ebx,%ebx
  8006ee:	79 02                	jns    8006f2 <vprintfmt+0x14a>
				err = -err;
  8006f0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006f2:	83 fb 64             	cmp    $0x64,%ebx
  8006f5:	7f 0b                	jg     800702 <vprintfmt+0x15a>
  8006f7:	8b 34 9d a0 39 80 00 	mov    0x8039a0(,%ebx,4),%esi
  8006fe:	85 f6                	test   %esi,%esi
  800700:	75 19                	jne    80071b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800702:	53                   	push   %ebx
  800703:	68 45 3b 80 00       	push   $0x803b45
  800708:	ff 75 0c             	pushl  0xc(%ebp)
  80070b:	ff 75 08             	pushl  0x8(%ebp)
  80070e:	e8 70 02 00 00       	call   800983 <printfmt>
  800713:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800716:	e9 5b 02 00 00       	jmp    800976 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80071b:	56                   	push   %esi
  80071c:	68 4e 3b 80 00       	push   $0x803b4e
  800721:	ff 75 0c             	pushl  0xc(%ebp)
  800724:	ff 75 08             	pushl  0x8(%ebp)
  800727:	e8 57 02 00 00       	call   800983 <printfmt>
  80072c:	83 c4 10             	add    $0x10,%esp
			break;
  80072f:	e9 42 02 00 00       	jmp    800976 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	83 c0 04             	add    $0x4,%eax
  80073a:	89 45 14             	mov    %eax,0x14(%ebp)
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	83 e8 04             	sub    $0x4,%eax
  800743:	8b 30                	mov    (%eax),%esi
  800745:	85 f6                	test   %esi,%esi
  800747:	75 05                	jne    80074e <vprintfmt+0x1a6>
				p = "(null)";
  800749:	be 51 3b 80 00       	mov    $0x803b51,%esi
			if (width > 0 && padc != '-')
  80074e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800752:	7e 6d                	jle    8007c1 <vprintfmt+0x219>
  800754:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800758:	74 67                	je     8007c1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80075a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	50                   	push   %eax
  800761:	56                   	push   %esi
  800762:	e8 26 05 00 00       	call   800c8d <strnlen>
  800767:	83 c4 10             	add    $0x10,%esp
  80076a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80076d:	eb 16                	jmp    800785 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80076f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800773:	83 ec 08             	sub    $0x8,%esp
  800776:	ff 75 0c             	pushl  0xc(%ebp)
  800779:	50                   	push   %eax
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	ff d0                	call   *%eax
  80077f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800782:	ff 4d e4             	decl   -0x1c(%ebp)
  800785:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800789:	7f e4                	jg     80076f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80078b:	eb 34                	jmp    8007c1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80078d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800791:	74 1c                	je     8007af <vprintfmt+0x207>
  800793:	83 fb 1f             	cmp    $0x1f,%ebx
  800796:	7e 05                	jle    80079d <vprintfmt+0x1f5>
  800798:	83 fb 7e             	cmp    $0x7e,%ebx
  80079b:	7e 12                	jle    8007af <vprintfmt+0x207>
					putch('?', putdat);
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	ff 75 0c             	pushl  0xc(%ebp)
  8007a3:	6a 3f                	push   $0x3f
  8007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a8:	ff d0                	call   *%eax
  8007aa:	83 c4 10             	add    $0x10,%esp
  8007ad:	eb 0f                	jmp    8007be <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	ff 75 0c             	pushl  0xc(%ebp)
  8007b5:	53                   	push   %ebx
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	ff d0                	call   *%eax
  8007bb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007be:	ff 4d e4             	decl   -0x1c(%ebp)
  8007c1:	89 f0                	mov    %esi,%eax
  8007c3:	8d 70 01             	lea    0x1(%eax),%esi
  8007c6:	8a 00                	mov    (%eax),%al
  8007c8:	0f be d8             	movsbl %al,%ebx
  8007cb:	85 db                	test   %ebx,%ebx
  8007cd:	74 24                	je     8007f3 <vprintfmt+0x24b>
  8007cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007d3:	78 b8                	js     80078d <vprintfmt+0x1e5>
  8007d5:	ff 4d e0             	decl   -0x20(%ebp)
  8007d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007dc:	79 af                	jns    80078d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007de:	eb 13                	jmp    8007f3 <vprintfmt+0x24b>
				putch(' ', putdat);
  8007e0:	83 ec 08             	sub    $0x8,%esp
  8007e3:	ff 75 0c             	pushl  0xc(%ebp)
  8007e6:	6a 20                	push   $0x20
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	ff d0                	call   *%eax
  8007ed:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007f0:	ff 4d e4             	decl   -0x1c(%ebp)
  8007f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f7:	7f e7                	jg     8007e0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007f9:	e9 78 01 00 00       	jmp    800976 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007fe:	83 ec 08             	sub    $0x8,%esp
  800801:	ff 75 e8             	pushl  -0x18(%ebp)
  800804:	8d 45 14             	lea    0x14(%ebp),%eax
  800807:	50                   	push   %eax
  800808:	e8 3c fd ff ff       	call   800549 <getint>
  80080d:	83 c4 10             	add    $0x10,%esp
  800810:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800813:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800816:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800819:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80081c:	85 d2                	test   %edx,%edx
  80081e:	79 23                	jns    800843 <vprintfmt+0x29b>
				putch('-', putdat);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	ff 75 0c             	pushl  0xc(%ebp)
  800826:	6a 2d                	push   $0x2d
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	ff d0                	call   *%eax
  80082d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800833:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800836:	f7 d8                	neg    %eax
  800838:	83 d2 00             	adc    $0x0,%edx
  80083b:	f7 da                	neg    %edx
  80083d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800840:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800843:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80084a:	e9 bc 00 00 00       	jmp    80090b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80084f:	83 ec 08             	sub    $0x8,%esp
  800852:	ff 75 e8             	pushl  -0x18(%ebp)
  800855:	8d 45 14             	lea    0x14(%ebp),%eax
  800858:	50                   	push   %eax
  800859:	e8 84 fc ff ff       	call   8004e2 <getuint>
  80085e:	83 c4 10             	add    $0x10,%esp
  800861:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800864:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800867:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80086e:	e9 98 00 00 00       	jmp    80090b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800873:	83 ec 08             	sub    $0x8,%esp
  800876:	ff 75 0c             	pushl  0xc(%ebp)
  800879:	6a 58                	push   $0x58
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	ff d0                	call   *%eax
  800880:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	ff 75 0c             	pushl  0xc(%ebp)
  800889:	6a 58                	push   $0x58
  80088b:	8b 45 08             	mov    0x8(%ebp),%eax
  80088e:	ff d0                	call   *%eax
  800890:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800893:	83 ec 08             	sub    $0x8,%esp
  800896:	ff 75 0c             	pushl  0xc(%ebp)
  800899:	6a 58                	push   $0x58
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	ff d0                	call   *%eax
  8008a0:	83 c4 10             	add    $0x10,%esp
			break;
  8008a3:	e9 ce 00 00 00       	jmp    800976 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8008a8:	83 ec 08             	sub    $0x8,%esp
  8008ab:	ff 75 0c             	pushl  0xc(%ebp)
  8008ae:	6a 30                	push   $0x30
  8008b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b3:	ff d0                	call   *%eax
  8008b5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008b8:	83 ec 08             	sub    $0x8,%esp
  8008bb:	ff 75 0c             	pushl  0xc(%ebp)
  8008be:	6a 78                	push   $0x78
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	ff d0                	call   *%eax
  8008c5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8008c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cb:	83 c0 04             	add    $0x4,%eax
  8008ce:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d4:	83 e8 04             	sub    $0x4,%eax
  8008d7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008e3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008ea:	eb 1f                	jmp    80090b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008ec:	83 ec 08             	sub    $0x8,%esp
  8008ef:	ff 75 e8             	pushl  -0x18(%ebp)
  8008f2:	8d 45 14             	lea    0x14(%ebp),%eax
  8008f5:	50                   	push   %eax
  8008f6:	e8 e7 fb ff ff       	call   8004e2 <getuint>
  8008fb:	83 c4 10             	add    $0x10,%esp
  8008fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800901:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800904:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80090b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80090f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800912:	83 ec 04             	sub    $0x4,%esp
  800915:	52                   	push   %edx
  800916:	ff 75 e4             	pushl  -0x1c(%ebp)
  800919:	50                   	push   %eax
  80091a:	ff 75 f4             	pushl  -0xc(%ebp)
  80091d:	ff 75 f0             	pushl  -0x10(%ebp)
  800920:	ff 75 0c             	pushl  0xc(%ebp)
  800923:	ff 75 08             	pushl  0x8(%ebp)
  800926:	e8 00 fb ff ff       	call   80042b <printnum>
  80092b:	83 c4 20             	add    $0x20,%esp
			break;
  80092e:	eb 46                	jmp    800976 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800930:	83 ec 08             	sub    $0x8,%esp
  800933:	ff 75 0c             	pushl  0xc(%ebp)
  800936:	53                   	push   %ebx
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	ff d0                	call   *%eax
  80093c:	83 c4 10             	add    $0x10,%esp
			break;
  80093f:	eb 35                	jmp    800976 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800941:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  800948:	eb 2c                	jmp    800976 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80094a:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  800951:	eb 23                	jmp    800976 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800953:	83 ec 08             	sub    $0x8,%esp
  800956:	ff 75 0c             	pushl  0xc(%ebp)
  800959:	6a 25                	push   $0x25
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	ff d0                	call   *%eax
  800960:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800963:	ff 4d 10             	decl   0x10(%ebp)
  800966:	eb 03                	jmp    80096b <vprintfmt+0x3c3>
  800968:	ff 4d 10             	decl   0x10(%ebp)
  80096b:	8b 45 10             	mov    0x10(%ebp),%eax
  80096e:	48                   	dec    %eax
  80096f:	8a 00                	mov    (%eax),%al
  800971:	3c 25                	cmp    $0x25,%al
  800973:	75 f3                	jne    800968 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800975:	90                   	nop
		}
	}
  800976:	e9 35 fc ff ff       	jmp    8005b0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80097b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80097c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80097f:	5b                   	pop    %ebx
  800980:	5e                   	pop    %esi
  800981:	5d                   	pop    %ebp
  800982:	c3                   	ret    

00800983 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800989:	8d 45 10             	lea    0x10(%ebp),%eax
  80098c:	83 c0 04             	add    $0x4,%eax
  80098f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800992:	8b 45 10             	mov    0x10(%ebp),%eax
  800995:	ff 75 f4             	pushl  -0xc(%ebp)
  800998:	50                   	push   %eax
  800999:	ff 75 0c             	pushl  0xc(%ebp)
  80099c:	ff 75 08             	pushl  0x8(%ebp)
  80099f:	e8 04 fc ff ff       	call   8005a8 <vprintfmt>
  8009a4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8009a7:	90                   	nop
  8009a8:	c9                   	leave  
  8009a9:	c3                   	ret    

008009aa <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8009ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b0:	8b 40 08             	mov    0x8(%eax),%eax
  8009b3:	8d 50 01             	lea    0x1(%eax),%edx
  8009b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009bf:	8b 10                	mov    (%eax),%edx
  8009c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c4:	8b 40 04             	mov    0x4(%eax),%eax
  8009c7:	39 c2                	cmp    %eax,%edx
  8009c9:	73 12                	jae    8009dd <sprintputch+0x33>
		*b->buf++ = ch;
  8009cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ce:	8b 00                	mov    (%eax),%eax
  8009d0:	8d 48 01             	lea    0x1(%eax),%ecx
  8009d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d6:	89 0a                	mov    %ecx,(%edx)
  8009d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8009db:	88 10                	mov    %dl,(%eax)
}
  8009dd:	90                   	nop
  8009de:	5d                   	pop    %ebp
  8009df:	c3                   	ret    

008009e0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	01 d0                	add    %edx,%eax
  8009f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a05:	74 06                	je     800a0d <vsnprintf+0x2d>
  800a07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a0b:	7f 07                	jg     800a14 <vsnprintf+0x34>
		return -E_INVAL;
  800a0d:	b8 03 00 00 00       	mov    $0x3,%eax
  800a12:	eb 20                	jmp    800a34 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a14:	ff 75 14             	pushl  0x14(%ebp)
  800a17:	ff 75 10             	pushl  0x10(%ebp)
  800a1a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a1d:	50                   	push   %eax
  800a1e:	68 aa 09 80 00       	push   $0x8009aa
  800a23:	e8 80 fb ff ff       	call   8005a8 <vprintfmt>
  800a28:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a2e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a34:	c9                   	leave  
  800a35:	c3                   	ret    

00800a36 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a36:	55                   	push   %ebp
  800a37:	89 e5                	mov    %esp,%ebp
  800a39:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a3c:	8d 45 10             	lea    0x10(%ebp),%eax
  800a3f:	83 c0 04             	add    $0x4,%eax
  800a42:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a45:	8b 45 10             	mov    0x10(%ebp),%eax
  800a48:	ff 75 f4             	pushl  -0xc(%ebp)
  800a4b:	50                   	push   %eax
  800a4c:	ff 75 0c             	pushl  0xc(%ebp)
  800a4f:	ff 75 08             	pushl  0x8(%ebp)
  800a52:	e8 89 ff ff ff       	call   8009e0 <vsnprintf>
  800a57:	83 c4 10             	add    $0x10,%esp
  800a5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a60:	c9                   	leave  
  800a61:	c3                   	ret    

00800a62 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800a62:	55                   	push   %ebp
  800a63:	89 e5                	mov    %esp,%ebp
  800a65:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800a68:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a6c:	74 13                	je     800a81 <readline+0x1f>
		cprintf("%s", prompt);
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	ff 75 08             	pushl  0x8(%ebp)
  800a74:	68 c8 3c 80 00       	push   $0x803cc8
  800a79:	e8 50 f9 ff ff       	call   8003ce <cprintf>
  800a7e:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a88:	83 ec 0c             	sub    $0xc,%esp
  800a8b:	6a 00                	push   $0x0
  800a8d:	e8 07 29 00 00       	call   803399 <iscons>
  800a92:	83 c4 10             	add    $0x10,%esp
  800a95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a98:	e8 e9 28 00 00       	call   803386 <getchar>
  800a9d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800aa0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800aa4:	79 22                	jns    800ac8 <readline+0x66>
			if (c != -E_EOF)
  800aa6:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800aaa:	0f 84 ad 00 00 00    	je     800b5d <readline+0xfb>
				cprintf("read error: %e\n", c);
  800ab0:	83 ec 08             	sub    $0x8,%esp
  800ab3:	ff 75 ec             	pushl  -0x14(%ebp)
  800ab6:	68 cb 3c 80 00       	push   $0x803ccb
  800abb:	e8 0e f9 ff ff       	call   8003ce <cprintf>
  800ac0:	83 c4 10             	add    $0x10,%esp
			break;
  800ac3:	e9 95 00 00 00       	jmp    800b5d <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ac8:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800acc:	7e 34                	jle    800b02 <readline+0xa0>
  800ace:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ad5:	7f 2b                	jg     800b02 <readline+0xa0>
			if (echoing)
  800ad7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800adb:	74 0e                	je     800aeb <readline+0x89>
				cputchar(c);
  800add:	83 ec 0c             	sub    $0xc,%esp
  800ae0:	ff 75 ec             	pushl  -0x14(%ebp)
  800ae3:	e8 7f 28 00 00       	call   803367 <cputchar>
  800ae8:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800aee:	8d 50 01             	lea    0x1(%eax),%edx
  800af1:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800af4:	89 c2                	mov    %eax,%edx
  800af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af9:	01 d0                	add    %edx,%eax
  800afb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800afe:	88 10                	mov    %dl,(%eax)
  800b00:	eb 56                	jmp    800b58 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800b02:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b06:	75 1f                	jne    800b27 <readline+0xc5>
  800b08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b0c:	7e 19                	jle    800b27 <readline+0xc5>
			if (echoing)
  800b0e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b12:	74 0e                	je     800b22 <readline+0xc0>
				cputchar(c);
  800b14:	83 ec 0c             	sub    $0xc,%esp
  800b17:	ff 75 ec             	pushl  -0x14(%ebp)
  800b1a:	e8 48 28 00 00       	call   803367 <cputchar>
  800b1f:	83 c4 10             	add    $0x10,%esp

			i--;
  800b22:	ff 4d f4             	decl   -0xc(%ebp)
  800b25:	eb 31                	jmp    800b58 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800b27:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b2b:	74 0a                	je     800b37 <readline+0xd5>
  800b2d:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b31:	0f 85 61 ff ff ff    	jne    800a98 <readline+0x36>
			if (echoing)
  800b37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b3b:	74 0e                	je     800b4b <readline+0xe9>
				cputchar(c);
  800b3d:	83 ec 0c             	sub    $0xc,%esp
  800b40:	ff 75 ec             	pushl  -0x14(%ebp)
  800b43:	e8 1f 28 00 00       	call   803367 <cputchar>
  800b48:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800b4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b51:	01 d0                	add    %edx,%eax
  800b53:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800b56:	eb 06                	jmp    800b5e <readline+0xfc>
		}
	}
  800b58:	e9 3b ff ff ff       	jmp    800a98 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800b5d:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800b5e:	90                   	nop
  800b5f:	c9                   	leave  
  800b60:	c3                   	ret    

00800b61 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800b67:	e8 3c 0f 00 00       	call   801aa8 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b70:	74 13                	je     800b85 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b72:	83 ec 08             	sub    $0x8,%esp
  800b75:	ff 75 08             	pushl  0x8(%ebp)
  800b78:	68 c8 3c 80 00       	push   $0x803cc8
  800b7d:	e8 4c f8 ff ff       	call   8003ce <cprintf>
  800b82:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b8c:	83 ec 0c             	sub    $0xc,%esp
  800b8f:	6a 00                	push   $0x0
  800b91:	e8 03 28 00 00       	call   803399 <iscons>
  800b96:	83 c4 10             	add    $0x10,%esp
  800b99:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b9c:	e8 e5 27 00 00       	call   803386 <getchar>
  800ba1:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800ba4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ba8:	79 22                	jns    800bcc <atomic_readline+0x6b>
				if (c != -E_EOF)
  800baa:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800bae:	0f 84 ad 00 00 00    	je     800c61 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800bb4:	83 ec 08             	sub    $0x8,%esp
  800bb7:	ff 75 ec             	pushl  -0x14(%ebp)
  800bba:	68 cb 3c 80 00       	push   $0x803ccb
  800bbf:	e8 0a f8 ff ff       	call   8003ce <cprintf>
  800bc4:	83 c4 10             	add    $0x10,%esp
				break;
  800bc7:	e9 95 00 00 00       	jmp    800c61 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800bcc:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800bd0:	7e 34                	jle    800c06 <atomic_readline+0xa5>
  800bd2:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800bd9:	7f 2b                	jg     800c06 <atomic_readline+0xa5>
				if (echoing)
  800bdb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bdf:	74 0e                	je     800bef <atomic_readline+0x8e>
					cputchar(c);
  800be1:	83 ec 0c             	sub    $0xc,%esp
  800be4:	ff 75 ec             	pushl  -0x14(%ebp)
  800be7:	e8 7b 27 00 00       	call   803367 <cputchar>
  800bec:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bf2:	8d 50 01             	lea    0x1(%eax),%edx
  800bf5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800bf8:	89 c2                	mov    %eax,%edx
  800bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfd:	01 d0                	add    %edx,%eax
  800bff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800c02:	88 10                	mov    %dl,(%eax)
  800c04:	eb 56                	jmp    800c5c <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800c06:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800c0a:	75 1f                	jne    800c2b <atomic_readline+0xca>
  800c0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800c10:	7e 19                	jle    800c2b <atomic_readline+0xca>
				if (echoing)
  800c12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c16:	74 0e                	je     800c26 <atomic_readline+0xc5>
					cputchar(c);
  800c18:	83 ec 0c             	sub    $0xc,%esp
  800c1b:	ff 75 ec             	pushl  -0x14(%ebp)
  800c1e:	e8 44 27 00 00       	call   803367 <cputchar>
  800c23:	83 c4 10             	add    $0x10,%esp
				i--;
  800c26:	ff 4d f4             	decl   -0xc(%ebp)
  800c29:	eb 31                	jmp    800c5c <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800c2b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800c2f:	74 0a                	je     800c3b <atomic_readline+0xda>
  800c31:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800c35:	0f 85 61 ff ff ff    	jne    800b9c <atomic_readline+0x3b>
				if (echoing)
  800c3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c3f:	74 0e                	je     800c4f <atomic_readline+0xee>
					cputchar(c);
  800c41:	83 ec 0c             	sub    $0xc,%esp
  800c44:	ff 75 ec             	pushl  -0x14(%ebp)
  800c47:	e8 1b 27 00 00       	call   803367 <cputchar>
  800c4c:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800c4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c55:	01 d0                	add    %edx,%eax
  800c57:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800c5a:	eb 06                	jmp    800c62 <atomic_readline+0x101>
			}
		}
  800c5c:	e9 3b ff ff ff       	jmp    800b9c <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800c61:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800c62:	e8 5b 0e 00 00       	call   801ac2 <sys_unlock_cons>
}
  800c67:	90                   	nop
  800c68:	c9                   	leave  
  800c69:	c3                   	ret    

00800c6a <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c70:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c77:	eb 06                	jmp    800c7f <strlen+0x15>
		n++;
  800c79:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c7c:	ff 45 08             	incl   0x8(%ebp)
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	8a 00                	mov    (%eax),%al
  800c84:	84 c0                	test   %al,%al
  800c86:	75 f1                	jne    800c79 <strlen+0xf>
		n++;
	return n;
  800c88:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c8b:	c9                   	leave  
  800c8c:	c3                   	ret    

00800c8d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c93:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c9a:	eb 09                	jmp    800ca5 <strnlen+0x18>
		n++;
  800c9c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c9f:	ff 45 08             	incl   0x8(%ebp)
  800ca2:	ff 4d 0c             	decl   0xc(%ebp)
  800ca5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca9:	74 09                	je     800cb4 <strnlen+0x27>
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	8a 00                	mov    (%eax),%al
  800cb0:	84 c0                	test   %al,%al
  800cb2:	75 e8                	jne    800c9c <strnlen+0xf>
		n++;
	return n;
  800cb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb7:	c9                   	leave  
  800cb8:	c3                   	ret    

00800cb9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
  800cbc:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cc5:	90                   	nop
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	8d 50 01             	lea    0x1(%eax),%edx
  800ccc:	89 55 08             	mov    %edx,0x8(%ebp)
  800ccf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd8:	8a 12                	mov    (%edx),%dl
  800cda:	88 10                	mov    %dl,(%eax)
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	84 c0                	test   %al,%al
  800ce0:	75 e4                	jne    800cc6 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ce2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce5:	c9                   	leave  
  800ce6:	c3                   	ret    

00800ce7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cf3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cfa:	eb 1f                	jmp    800d1b <strncpy+0x34>
		*dst++ = *src;
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	8d 50 01             	lea    0x1(%eax),%edx
  800d02:	89 55 08             	mov    %edx,0x8(%ebp)
  800d05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d08:	8a 12                	mov    (%edx),%dl
  800d0a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0f:	8a 00                	mov    (%eax),%al
  800d11:	84 c0                	test   %al,%al
  800d13:	74 03                	je     800d18 <strncpy+0x31>
			src++;
  800d15:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d18:	ff 45 fc             	incl   -0x4(%ebp)
  800d1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d1e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d21:	72 d9                	jb     800cfc <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d23:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d26:	c9                   	leave  
  800d27:	c3                   	ret    

00800d28 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d38:	74 30                	je     800d6a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d3a:	eb 16                	jmp    800d52 <strlcpy+0x2a>
			*dst++ = *src++;
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	8d 50 01             	lea    0x1(%eax),%edx
  800d42:	89 55 08             	mov    %edx,0x8(%ebp)
  800d45:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d48:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d4b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d4e:	8a 12                	mov    (%edx),%dl
  800d50:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d52:	ff 4d 10             	decl   0x10(%ebp)
  800d55:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d59:	74 09                	je     800d64 <strlcpy+0x3c>
  800d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5e:	8a 00                	mov    (%eax),%al
  800d60:	84 c0                	test   %al,%al
  800d62:	75 d8                	jne    800d3c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d70:	29 c2                	sub    %eax,%edx
  800d72:	89 d0                	mov    %edx,%eax
}
  800d74:	c9                   	leave  
  800d75:	c3                   	ret    

00800d76 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d79:	eb 06                	jmp    800d81 <strcmp+0xb>
		p++, q++;
  800d7b:	ff 45 08             	incl   0x8(%ebp)
  800d7e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	84 c0                	test   %al,%al
  800d88:	74 0e                	je     800d98 <strcmp+0x22>
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 10                	mov    (%eax),%dl
  800d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d92:	8a 00                	mov    (%eax),%al
  800d94:	38 c2                	cmp    %al,%dl
  800d96:	74 e3                	je     800d7b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	8a 00                	mov    (%eax),%al
  800d9d:	0f b6 d0             	movzbl %al,%edx
  800da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da3:	8a 00                	mov    (%eax),%al
  800da5:	0f b6 c0             	movzbl %al,%eax
  800da8:	29 c2                	sub    %eax,%edx
  800daa:	89 d0                	mov    %edx,%eax
}
  800dac:	5d                   	pop    %ebp
  800dad:	c3                   	ret    

00800dae <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800db1:	eb 09                	jmp    800dbc <strncmp+0xe>
		n--, p++, q++;
  800db3:	ff 4d 10             	decl   0x10(%ebp)
  800db6:	ff 45 08             	incl   0x8(%ebp)
  800db9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dbc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc0:	74 17                	je     800dd9 <strncmp+0x2b>
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	8a 00                	mov    (%eax),%al
  800dc7:	84 c0                	test   %al,%al
  800dc9:	74 0e                	je     800dd9 <strncmp+0x2b>
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	8a 10                	mov    (%eax),%dl
  800dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd3:	8a 00                	mov    (%eax),%al
  800dd5:	38 c2                	cmp    %al,%dl
  800dd7:	74 da                	je     800db3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dd9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ddd:	75 07                	jne    800de6 <strncmp+0x38>
		return 0;
  800ddf:	b8 00 00 00 00       	mov    $0x0,%eax
  800de4:	eb 14                	jmp    800dfa <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	8a 00                	mov    (%eax),%al
  800deb:	0f b6 d0             	movzbl %al,%edx
  800dee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df1:	8a 00                	mov    (%eax),%al
  800df3:	0f b6 c0             	movzbl %al,%eax
  800df6:	29 c2                	sub    %eax,%edx
  800df8:	89 d0                	mov    %edx,%eax
}
  800dfa:	5d                   	pop    %ebp
  800dfb:	c3                   	ret    

00800dfc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	83 ec 04             	sub    $0x4,%esp
  800e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e05:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e08:	eb 12                	jmp    800e1c <strchr+0x20>
		if (*s == c)
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0d:	8a 00                	mov    (%eax),%al
  800e0f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e12:	75 05                	jne    800e19 <strchr+0x1d>
			return (char *) s;
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	eb 11                	jmp    800e2a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e19:	ff 45 08             	incl   0x8(%ebp)
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	84 c0                	test   %al,%al
  800e23:	75 e5                	jne    800e0a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e2a:	c9                   	leave  
  800e2b:	c3                   	ret    

00800e2c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 04             	sub    $0x4,%esp
  800e32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e35:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e38:	eb 0d                	jmp    800e47 <strfind+0x1b>
		if (*s == c)
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	8a 00                	mov    (%eax),%al
  800e3f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e42:	74 0e                	je     800e52 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e44:	ff 45 08             	incl   0x8(%ebp)
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	8a 00                	mov    (%eax),%al
  800e4c:	84 c0                	test   %al,%al
  800e4e:	75 ea                	jne    800e3a <strfind+0xe>
  800e50:	eb 01                	jmp    800e53 <strfind+0x27>
		if (*s == c)
			break;
  800e52:	90                   	nop
	return (char *) s;
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e56:	c9                   	leave  
  800e57:	c3                   	ret    

00800e58 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e64:	8b 45 10             	mov    0x10(%ebp),%eax
  800e67:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e6a:	eb 0e                	jmp    800e7a <memset+0x22>
		*p++ = c;
  800e6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e6f:	8d 50 01             	lea    0x1(%eax),%edx
  800e72:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e78:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e7a:	ff 4d f8             	decl   -0x8(%ebp)
  800e7d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e81:	79 e9                	jns    800e6c <memset+0x14>
		*p++ = c;

	return v;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e86:	c9                   	leave  
  800e87:	c3                   	ret    

00800e88 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e9a:	eb 16                	jmp    800eb2 <memcpy+0x2a>
		*d++ = *s++;
  800e9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9f:	8d 50 01             	lea    0x1(%eax),%edx
  800ea2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ea5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eab:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eae:	8a 12                	mov    (%edx),%dl
  800eb0:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800eb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb8:	89 55 10             	mov    %edx,0x10(%ebp)
  800ebb:	85 c0                	test   %eax,%eax
  800ebd:	75 dd                	jne    800e9c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec2:	c9                   	leave  
  800ec3:	c3                   	ret    

00800ec4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800edc:	73 50                	jae    800f2e <memmove+0x6a>
  800ede:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee4:	01 d0                	add    %edx,%eax
  800ee6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ee9:	76 43                	jbe    800f2e <memmove+0x6a>
		s += n;
  800eeb:	8b 45 10             	mov    0x10(%ebp),%eax
  800eee:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ef1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ef7:	eb 10                	jmp    800f09 <memmove+0x45>
			*--d = *--s;
  800ef9:	ff 4d f8             	decl   -0x8(%ebp)
  800efc:	ff 4d fc             	decl   -0x4(%ebp)
  800eff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f02:	8a 10                	mov    (%eax),%dl
  800f04:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f07:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f09:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f0f:	89 55 10             	mov    %edx,0x10(%ebp)
  800f12:	85 c0                	test   %eax,%eax
  800f14:	75 e3                	jne    800ef9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f16:	eb 23                	jmp    800f3b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1b:	8d 50 01             	lea    0x1(%eax),%edx
  800f1e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f24:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f27:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f2a:	8a 12                	mov    (%edx),%dl
  800f2c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f34:	89 55 10             	mov    %edx,0x10(%ebp)
  800f37:	85 c0                	test   %eax,%eax
  800f39:	75 dd                	jne    800f18 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3e:	c9                   	leave  
  800f3f:	c3                   	ret    

00800f40 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f52:	eb 2a                	jmp    800f7e <memcmp+0x3e>
		if (*s1 != *s2)
  800f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f57:	8a 10                	mov    (%eax),%dl
  800f59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	38 c2                	cmp    %al,%dl
  800f60:	74 16                	je     800f78 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f65:	8a 00                	mov    (%eax),%al
  800f67:	0f b6 d0             	movzbl %al,%edx
  800f6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	0f b6 c0             	movzbl %al,%eax
  800f72:	29 c2                	sub    %eax,%edx
  800f74:	89 d0                	mov    %edx,%eax
  800f76:	eb 18                	jmp    800f90 <memcmp+0x50>
		s1++, s2++;
  800f78:	ff 45 fc             	incl   -0x4(%ebp)
  800f7b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f81:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f84:	89 55 10             	mov    %edx,0x10(%ebp)
  800f87:	85 c0                	test   %eax,%eax
  800f89:	75 c9                	jne    800f54 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f90:	c9                   	leave  
  800f91:	c3                   	ret    

00800f92 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f98:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9e:	01 d0                	add    %edx,%eax
  800fa0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fa3:	eb 15                	jmp    800fba <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	0f b6 d0             	movzbl %al,%edx
  800fad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb0:	0f b6 c0             	movzbl %al,%eax
  800fb3:	39 c2                	cmp    %eax,%edx
  800fb5:	74 0d                	je     800fc4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fb7:	ff 45 08             	incl   0x8(%ebp)
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fc0:	72 e3                	jb     800fa5 <memfind+0x13>
  800fc2:	eb 01                	jmp    800fc5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fc4:	90                   	nop
	return (void *) s;
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc8:	c9                   	leave  
  800fc9:	c3                   	ret    

00800fca <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fca:	55                   	push   %ebp
  800fcb:	89 e5                	mov    %esp,%ebp
  800fcd:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fd0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fd7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fde:	eb 03                	jmp    800fe3 <strtol+0x19>
		s++;
  800fe0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	3c 20                	cmp    $0x20,%al
  800fea:	74 f4                	je     800fe0 <strtol+0x16>
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	3c 09                	cmp    $0x9,%al
  800ff3:	74 eb                	je     800fe0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	3c 2b                	cmp    $0x2b,%al
  800ffc:	75 05                	jne    801003 <strtol+0x39>
		s++;
  800ffe:	ff 45 08             	incl   0x8(%ebp)
  801001:	eb 13                	jmp    801016 <strtol+0x4c>
	else if (*s == '-')
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	3c 2d                	cmp    $0x2d,%al
  80100a:	75 0a                	jne    801016 <strtol+0x4c>
		s++, neg = 1;
  80100c:	ff 45 08             	incl   0x8(%ebp)
  80100f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801016:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80101a:	74 06                	je     801022 <strtol+0x58>
  80101c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801020:	75 20                	jne    801042 <strtol+0x78>
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	3c 30                	cmp    $0x30,%al
  801029:	75 17                	jne    801042 <strtol+0x78>
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	40                   	inc    %eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	3c 78                	cmp    $0x78,%al
  801033:	75 0d                	jne    801042 <strtol+0x78>
		s += 2, base = 16;
  801035:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801039:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801040:	eb 28                	jmp    80106a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801042:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801046:	75 15                	jne    80105d <strtol+0x93>
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	3c 30                	cmp    $0x30,%al
  80104f:	75 0c                	jne    80105d <strtol+0x93>
		s++, base = 8;
  801051:	ff 45 08             	incl   0x8(%ebp)
  801054:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80105b:	eb 0d                	jmp    80106a <strtol+0xa0>
	else if (base == 0)
  80105d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801061:	75 07                	jne    80106a <strtol+0xa0>
		base = 10;
  801063:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	8a 00                	mov    (%eax),%al
  80106f:	3c 2f                	cmp    $0x2f,%al
  801071:	7e 19                	jle    80108c <strtol+0xc2>
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	8a 00                	mov    (%eax),%al
  801078:	3c 39                	cmp    $0x39,%al
  80107a:	7f 10                	jg     80108c <strtol+0xc2>
			dig = *s - '0';
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8a 00                	mov    (%eax),%al
  801081:	0f be c0             	movsbl %al,%eax
  801084:	83 e8 30             	sub    $0x30,%eax
  801087:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80108a:	eb 42                	jmp    8010ce <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80108c:	8b 45 08             	mov    0x8(%ebp),%eax
  80108f:	8a 00                	mov    (%eax),%al
  801091:	3c 60                	cmp    $0x60,%al
  801093:	7e 19                	jle    8010ae <strtol+0xe4>
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	3c 7a                	cmp    $0x7a,%al
  80109c:	7f 10                	jg     8010ae <strtol+0xe4>
			dig = *s - 'a' + 10;
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8a 00                	mov    (%eax),%al
  8010a3:	0f be c0             	movsbl %al,%eax
  8010a6:	83 e8 57             	sub    $0x57,%eax
  8010a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010ac:	eb 20                	jmp    8010ce <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	3c 40                	cmp    $0x40,%al
  8010b5:	7e 39                	jle    8010f0 <strtol+0x126>
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	3c 5a                	cmp    $0x5a,%al
  8010be:	7f 30                	jg     8010f0 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	0f be c0             	movsbl %al,%eax
  8010c8:	83 e8 37             	sub    $0x37,%eax
  8010cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010d4:	7d 19                	jge    8010ef <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010d6:	ff 45 08             	incl   0x8(%ebp)
  8010d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010dc:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010e0:	89 c2                	mov    %eax,%edx
  8010e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e5:	01 d0                	add    %edx,%eax
  8010e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010ea:	e9 7b ff ff ff       	jmp    80106a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010ef:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010f4:	74 08                	je     8010fe <strtol+0x134>
		*endptr = (char *) s;
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fc:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801102:	74 07                	je     80110b <strtol+0x141>
  801104:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801107:	f7 d8                	neg    %eax
  801109:	eb 03                	jmp    80110e <strtol+0x144>
  80110b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80110e:	c9                   	leave  
  80110f:	c3                   	ret    

00801110 <ltostr>:

void
ltostr(long value, char *str)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
  801113:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801116:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80111d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801124:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801128:	79 13                	jns    80113d <ltostr+0x2d>
	{
		neg = 1;
  80112a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801131:	8b 45 0c             	mov    0xc(%ebp),%eax
  801134:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801137:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80113a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
  801140:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801145:	99                   	cltd   
  801146:	f7 f9                	idiv   %ecx
  801148:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80114b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80114e:	8d 50 01             	lea    0x1(%eax),%edx
  801151:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801154:	89 c2                	mov    %eax,%edx
  801156:	8b 45 0c             	mov    0xc(%ebp),%eax
  801159:	01 d0                	add    %edx,%eax
  80115b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80115e:	83 c2 30             	add    $0x30,%edx
  801161:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801163:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801166:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80116b:	f7 e9                	imul   %ecx
  80116d:	c1 fa 02             	sar    $0x2,%edx
  801170:	89 c8                	mov    %ecx,%eax
  801172:	c1 f8 1f             	sar    $0x1f,%eax
  801175:	29 c2                	sub    %eax,%edx
  801177:	89 d0                	mov    %edx,%eax
  801179:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80117c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801180:	75 bb                	jne    80113d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801182:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801189:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118c:	48                   	dec    %eax
  80118d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801190:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801194:	74 3d                	je     8011d3 <ltostr+0xc3>
		start = 1 ;
  801196:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80119d:	eb 34                	jmp    8011d3 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80119f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	8a 00                	mov    (%eax),%al
  8011a9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b2:	01 c2                	add    %eax,%edx
  8011b4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ba:	01 c8                	add    %ecx,%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c6:	01 c2                	add    %eax,%edx
  8011c8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011cb:	88 02                	mov    %al,(%edx)
		start++ ;
  8011cd:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011d0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d9:	7c c4                	jl     80119f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011db:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e1:	01 d0                	add    %edx,%eax
  8011e3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011e6:	90                   	nop
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    

008011e9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011ef:	ff 75 08             	pushl  0x8(%ebp)
  8011f2:	e8 73 fa ff ff       	call   800c6a <strlen>
  8011f7:	83 c4 04             	add    $0x4,%esp
  8011fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011fd:	ff 75 0c             	pushl  0xc(%ebp)
  801200:	e8 65 fa ff ff       	call   800c6a <strlen>
  801205:	83 c4 04             	add    $0x4,%esp
  801208:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80120b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801212:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801219:	eb 17                	jmp    801232 <strcconcat+0x49>
		final[s] = str1[s] ;
  80121b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80121e:	8b 45 10             	mov    0x10(%ebp),%eax
  801221:	01 c2                	add    %eax,%edx
  801223:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	01 c8                	add    %ecx,%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80122f:	ff 45 fc             	incl   -0x4(%ebp)
  801232:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801235:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801238:	7c e1                	jl     80121b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80123a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801241:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801248:	eb 1f                	jmp    801269 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80124a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80124d:	8d 50 01             	lea    0x1(%eax),%edx
  801250:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801253:	89 c2                	mov    %eax,%edx
  801255:	8b 45 10             	mov    0x10(%ebp),%eax
  801258:	01 c2                	add    %eax,%edx
  80125a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80125d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801260:	01 c8                	add    %ecx,%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801266:	ff 45 f8             	incl   -0x8(%ebp)
  801269:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80126f:	7c d9                	jl     80124a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801271:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801274:	8b 45 10             	mov    0x10(%ebp),%eax
  801277:	01 d0                	add    %edx,%eax
  801279:	c6 00 00             	movb   $0x0,(%eax)
}
  80127c:	90                   	nop
  80127d:	c9                   	leave  
  80127e:	c3                   	ret    

0080127f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801282:	8b 45 14             	mov    0x14(%ebp),%eax
  801285:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80128b:	8b 45 14             	mov    0x14(%ebp),%eax
  80128e:	8b 00                	mov    (%eax),%eax
  801290:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801297:	8b 45 10             	mov    0x10(%ebp),%eax
  80129a:	01 d0                	add    %edx,%eax
  80129c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012a2:	eb 0c                	jmp    8012b0 <strsplit+0x31>
			*string++ = 0;
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8d 50 01             	lea    0x1(%eax),%edx
  8012aa:	89 55 08             	mov    %edx,0x8(%ebp)
  8012ad:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	84 c0                	test   %al,%al
  8012b7:	74 18                	je     8012d1 <strsplit+0x52>
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	8a 00                	mov    (%eax),%al
  8012be:	0f be c0             	movsbl %al,%eax
  8012c1:	50                   	push   %eax
  8012c2:	ff 75 0c             	pushl  0xc(%ebp)
  8012c5:	e8 32 fb ff ff       	call   800dfc <strchr>
  8012ca:	83 c4 08             	add    $0x8,%esp
  8012cd:	85 c0                	test   %eax,%eax
  8012cf:	75 d3                	jne    8012a4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	74 5a                	je     801334 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012da:	8b 45 14             	mov    0x14(%ebp),%eax
  8012dd:	8b 00                	mov    (%eax),%eax
  8012df:	83 f8 0f             	cmp    $0xf,%eax
  8012e2:	75 07                	jne    8012eb <strsplit+0x6c>
		{
			return 0;
  8012e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e9:	eb 66                	jmp    801351 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ee:	8b 00                	mov    (%eax),%eax
  8012f0:	8d 48 01             	lea    0x1(%eax),%ecx
  8012f3:	8b 55 14             	mov    0x14(%ebp),%edx
  8012f6:	89 0a                	mov    %ecx,(%edx)
  8012f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801302:	01 c2                	add    %eax,%edx
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801309:	eb 03                	jmp    80130e <strsplit+0x8f>
			string++;
  80130b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	84 c0                	test   %al,%al
  801315:	74 8b                	je     8012a2 <strsplit+0x23>
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	0f be c0             	movsbl %al,%eax
  80131f:	50                   	push   %eax
  801320:	ff 75 0c             	pushl  0xc(%ebp)
  801323:	e8 d4 fa ff ff       	call   800dfc <strchr>
  801328:	83 c4 08             	add    $0x8,%esp
  80132b:	85 c0                	test   %eax,%eax
  80132d:	74 dc                	je     80130b <strsplit+0x8c>
			string++;
	}
  80132f:	e9 6e ff ff ff       	jmp    8012a2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801334:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801335:	8b 45 14             	mov    0x14(%ebp),%eax
  801338:	8b 00                	mov    (%eax),%eax
  80133a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801341:	8b 45 10             	mov    0x10(%ebp),%eax
  801344:	01 d0                	add    %edx,%eax
  801346:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80134c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801351:	c9                   	leave  
  801352:	c3                   	ret    

00801353 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
  801356:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801359:	83 ec 04             	sub    $0x4,%esp
  80135c:	68 dc 3c 80 00       	push   $0x803cdc
  801361:	68 3f 01 00 00       	push   $0x13f
  801366:	68 fe 3c 80 00       	push   $0x803cfe
  80136b:	e8 33 20 00 00       	call   8033a3 <_panic>

00801370 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801376:	83 ec 0c             	sub    $0xc,%esp
  801379:	ff 75 08             	pushl  0x8(%ebp)
  80137c:	e8 90 0c 00 00       	call   802011 <sys_sbrk>
  801381:	83 c4 10             	add    $0x10,%esp
}
  801384:	c9                   	leave  
  801385:	c3                   	ret    

00801386 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
  801389:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  80138c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801390:	75 0a                	jne    80139c <malloc+0x16>
		return NULL;
  801392:	b8 00 00 00 00       	mov    $0x0,%eax
  801397:	e9 9e 01 00 00       	jmp    80153a <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  80139c:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8013a3:	77 2c                	ja     8013d1 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  8013a5:	e8 eb 0a 00 00       	call   801e95 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013aa:	85 c0                	test   %eax,%eax
  8013ac:	74 19                	je     8013c7 <malloc+0x41>

			void * block = alloc_block_FF(size);
  8013ae:	83 ec 0c             	sub    $0xc,%esp
  8013b1:	ff 75 08             	pushl  0x8(%ebp)
  8013b4:	e8 85 11 00 00       	call   80253e <alloc_block_FF>
  8013b9:	83 c4 10             	add    $0x10,%esp
  8013bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  8013bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013c2:	e9 73 01 00 00       	jmp    80153a <malloc+0x1b4>
		} else {
			return NULL;
  8013c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013cc:	e9 69 01 00 00       	jmp    80153a <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8013d1:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8013d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8013db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013de:	01 d0                	add    %edx,%eax
  8013e0:	48                   	dec    %eax
  8013e1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ec:	f7 75 e0             	divl   -0x20(%ebp)
  8013ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013f2:	29 d0                	sub    %edx,%eax
  8013f4:	c1 e8 0c             	shr    $0xc,%eax
  8013f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  8013fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801401:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801408:	a1 20 50 80 00       	mov    0x805020,%eax
  80140d:	8b 40 7c             	mov    0x7c(%eax),%eax
  801410:	05 00 10 00 00       	add    $0x1000,%eax
  801415:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801418:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80141d:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801420:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801423:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80142a:	8b 55 08             	mov    0x8(%ebp),%edx
  80142d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801430:	01 d0                	add    %edx,%eax
  801432:	48                   	dec    %eax
  801433:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801436:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801439:	ba 00 00 00 00       	mov    $0x0,%edx
  80143e:	f7 75 cc             	divl   -0x34(%ebp)
  801441:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801444:	29 d0                	sub    %edx,%eax
  801446:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801449:	76 0a                	jbe    801455 <malloc+0xcf>
		return NULL;
  80144b:	b8 00 00 00 00       	mov    $0x0,%eax
  801450:	e9 e5 00 00 00       	jmp    80153a <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801455:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801458:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80145b:	eb 48                	jmp    8014a5 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  80145d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801460:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801463:	c1 e8 0c             	shr    $0xc,%eax
  801466:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801469:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80146c:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801473:	85 c0                	test   %eax,%eax
  801475:	75 11                	jne    801488 <malloc+0x102>
			freePagesCount++;
  801477:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  80147a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80147e:	75 16                	jne    801496 <malloc+0x110>
				start = i;
  801480:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801483:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801486:	eb 0e                	jmp    801496 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801488:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80148f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801499:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80149c:	74 12                	je     8014b0 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  80149e:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8014a5:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8014ac:	76 af                	jbe    80145d <malloc+0xd7>
  8014ae:	eb 01                	jmp    8014b1 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  8014b0:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  8014b1:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8014b5:	74 08                	je     8014bf <malloc+0x139>
  8014b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ba:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8014bd:	74 07                	je     8014c6 <malloc+0x140>
		return NULL;
  8014bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c4:	eb 74                	jmp    80153a <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8014c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c9:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8014cc:	c1 e8 0c             	shr    $0xc,%eax
  8014cf:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  8014d2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8014d5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8014d8:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  8014df:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8014e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8014e5:	eb 11                	jmp    8014f8 <malloc+0x172>
		markedPages[i] = 1;
  8014e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014ea:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  8014f1:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  8014f5:	ff 45 e8             	incl   -0x18(%ebp)
  8014f8:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8014fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014fe:	01 d0                	add    %edx,%eax
  801500:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801503:	77 e2                	ja     8014e7 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801505:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80150c:	8b 55 08             	mov    0x8(%ebp),%edx
  80150f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801512:	01 d0                	add    %edx,%eax
  801514:	48                   	dec    %eax
  801515:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801518:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80151b:	ba 00 00 00 00       	mov    $0x0,%edx
  801520:	f7 75 bc             	divl   -0x44(%ebp)
  801523:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801526:	29 d0                	sub    %edx,%eax
  801528:	83 ec 08             	sub    $0x8,%esp
  80152b:	50                   	push   %eax
  80152c:	ff 75 f0             	pushl  -0x10(%ebp)
  80152f:	e8 14 0b 00 00       	call   802048 <sys_allocate_user_mem>
  801534:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  801537:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  80153a:	c9                   	leave  
  80153b:	c3                   	ret    

0080153c <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
  80153f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801542:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801546:	0f 84 ee 00 00 00    	je     80163a <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  80154c:	a1 20 50 80 00       	mov    0x805020,%eax
  801551:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801554:	3b 45 08             	cmp    0x8(%ebp),%eax
  801557:	77 09                	ja     801562 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801559:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801560:	76 14                	jbe    801576 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801562:	83 ec 04             	sub    $0x4,%esp
  801565:	68 0c 3d 80 00       	push   $0x803d0c
  80156a:	6a 68                	push   $0x68
  80156c:	68 26 3d 80 00       	push   $0x803d26
  801571:	e8 2d 1e 00 00       	call   8033a3 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  801576:	a1 20 50 80 00       	mov    0x805020,%eax
  80157b:	8b 40 74             	mov    0x74(%eax),%eax
  80157e:	3b 45 08             	cmp    0x8(%ebp),%eax
  801581:	77 20                	ja     8015a3 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801583:	a1 20 50 80 00       	mov    0x805020,%eax
  801588:	8b 40 78             	mov    0x78(%eax),%eax
  80158b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80158e:	76 13                	jbe    8015a3 <free+0x67>
		free_block(virtual_address);
  801590:	83 ec 0c             	sub    $0xc,%esp
  801593:	ff 75 08             	pushl  0x8(%ebp)
  801596:	e8 6c 16 00 00       	call   802c07 <free_block>
  80159b:	83 c4 10             	add    $0x10,%esp
		return;
  80159e:	e9 98 00 00 00       	jmp    80163b <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8015a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8015a6:	a1 20 50 80 00       	mov    0x805020,%eax
  8015ab:	8b 40 7c             	mov    0x7c(%eax),%eax
  8015ae:	29 c2                	sub    %eax,%edx
  8015b0:	89 d0                	mov    %edx,%eax
  8015b2:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  8015b7:	c1 e8 0c             	shr    $0xc,%eax
  8015ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  8015bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8015c4:	eb 16                	jmp    8015dc <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  8015c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015cc:	01 d0                	add    %edx,%eax
  8015ce:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  8015d5:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  8015d9:	ff 45 f4             	incl   -0xc(%ebp)
  8015dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015df:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  8015e6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015e9:	7f db                	jg     8015c6 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  8015eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ee:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  8015f5:	c1 e0 0c             	shl    $0xc,%eax
  8015f8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  8015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801601:	eb 1a                	jmp    80161d <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801603:	83 ec 08             	sub    $0x8,%esp
  801606:	68 00 10 00 00       	push   $0x1000
  80160b:	ff 75 f0             	pushl  -0x10(%ebp)
  80160e:	e8 19 0a 00 00       	call   80202c <sys_free_user_mem>
  801613:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801616:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  80161d:	8b 55 08             	mov    0x8(%ebp),%edx
  801620:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801623:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801625:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801628:	77 d9                	ja     801603 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  80162a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80162d:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  801634:	00 00 00 00 
  801638:	eb 01                	jmp    80163b <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  80163a:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  80163b:	c9                   	leave  
  80163c:	c3                   	ret    

0080163d <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	83 ec 58             	sub    $0x58,%esp
  801643:	8b 45 10             	mov    0x10(%ebp),%eax
  801646:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801649:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80164d:	75 0a                	jne    801659 <smalloc+0x1c>
		return NULL;
  80164f:	b8 00 00 00 00       	mov    $0x0,%eax
  801654:	e9 7d 01 00 00       	jmp    8017d6 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801659:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801660:	8b 55 0c             	mov    0xc(%ebp),%edx
  801663:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801666:	01 d0                	add    %edx,%eax
  801668:	48                   	dec    %eax
  801669:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80166c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80166f:	ba 00 00 00 00       	mov    $0x0,%edx
  801674:	f7 75 e4             	divl   -0x1c(%ebp)
  801677:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80167a:	29 d0                	sub    %edx,%eax
  80167c:	c1 e8 0c             	shr    $0xc,%eax
  80167f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801682:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801689:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801690:	a1 20 50 80 00       	mov    0x805020,%eax
  801695:	8b 40 7c             	mov    0x7c(%eax),%eax
  801698:	05 00 10 00 00       	add    $0x1000,%eax
  80169d:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  8016a0:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8016a5:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8016a8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  8016ab:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8016b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8016b8:	01 d0                	add    %edx,%eax
  8016ba:	48                   	dec    %eax
  8016bb:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8016be:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8016c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c6:	f7 75 d0             	divl   -0x30(%ebp)
  8016c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8016cc:	29 d0                	sub    %edx,%eax
  8016ce:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8016d1:	76 0a                	jbe    8016dd <smalloc+0xa0>
		return NULL;
  8016d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d8:	e9 f9 00 00 00       	jmp    8017d6 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8016dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016e3:	eb 48                	jmp    80172d <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  8016e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e8:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8016eb:	c1 e8 0c             	shr    $0xc,%eax
  8016ee:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  8016f1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8016f4:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8016fb:	85 c0                	test   %eax,%eax
  8016fd:	75 11                	jne    801710 <smalloc+0xd3>
			freePagesCount++;
  8016ff:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801702:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801706:	75 16                	jne    80171e <smalloc+0xe1>
				start = s;
  801708:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80170b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80170e:	eb 0e                	jmp    80171e <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  801710:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801717:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  80171e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801721:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801724:	74 12                	je     801738 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801726:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  80172d:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801734:	76 af                	jbe    8016e5 <smalloc+0xa8>
  801736:	eb 01                	jmp    801739 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  801738:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  801739:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80173d:	74 08                	je     801747 <smalloc+0x10a>
  80173f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801742:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801745:	74 0a                	je     801751 <smalloc+0x114>
		return NULL;
  801747:	b8 00 00 00 00       	mov    $0x0,%eax
  80174c:	e9 85 00 00 00       	jmp    8017d6 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801751:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801754:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801757:	c1 e8 0c             	shr    $0xc,%eax
  80175a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  80175d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801760:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801763:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  80176a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80176d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801770:	eb 11                	jmp    801783 <smalloc+0x146>
		markedPages[s] = 1;
  801772:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801775:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  80177c:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801780:	ff 45 e8             	incl   -0x18(%ebp)
  801783:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801786:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801789:	01 d0                	add    %edx,%eax
  80178b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80178e:	77 e2                	ja     801772 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  801790:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801793:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801797:	52                   	push   %edx
  801798:	50                   	push   %eax
  801799:	ff 75 0c             	pushl  0xc(%ebp)
  80179c:	ff 75 08             	pushl  0x8(%ebp)
  80179f:	e8 8f 04 00 00       	call   801c33 <sys_createSharedObject>
  8017a4:	83 c4 10             	add    $0x10,%esp
  8017a7:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  8017aa:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  8017ae:	78 12                	js     8017c2 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  8017b0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8017b3:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8017b6:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  8017bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c0:	eb 14                	jmp    8017d6 <smalloc+0x199>
	}
	free((void*) start);
  8017c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c5:	83 ec 0c             	sub    $0xc,%esp
  8017c8:	50                   	push   %eax
  8017c9:	e8 6e fd ff ff       	call   80153c <free>
  8017ce:	83 c4 10             	add    $0x10,%esp
	return NULL;
  8017d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  8017de:	83 ec 08             	sub    $0x8,%esp
  8017e1:	ff 75 0c             	pushl  0xc(%ebp)
  8017e4:	ff 75 08             	pushl  0x8(%ebp)
  8017e7:	e8 71 04 00 00       	call   801c5d <sys_getSizeOfSharedObject>
  8017ec:	83 c4 10             	add    $0x10,%esp
  8017ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8017f2:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8017f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017ff:	01 d0                	add    %edx,%eax
  801801:	48                   	dec    %eax
  801802:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801805:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801808:	ba 00 00 00 00       	mov    $0x0,%edx
  80180d:	f7 75 e0             	divl   -0x20(%ebp)
  801810:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801813:	29 d0                	sub    %edx,%eax
  801815:	c1 e8 0c             	shr    $0xc,%eax
  801818:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  80181b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801822:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  801829:	a1 20 50 80 00       	mov    0x805020,%eax
  80182e:	8b 40 7c             	mov    0x7c(%eax),%eax
  801831:	05 00 10 00 00       	add    $0x1000,%eax
  801836:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  801839:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80183e:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801841:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801844:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80184b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80184e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801851:	01 d0                	add    %edx,%eax
  801853:	48                   	dec    %eax
  801854:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801857:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80185a:	ba 00 00 00 00       	mov    $0x0,%edx
  80185f:	f7 75 cc             	divl   -0x34(%ebp)
  801862:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801865:	29 d0                	sub    %edx,%eax
  801867:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80186a:	76 0a                	jbe    801876 <sget+0x9e>
		return NULL;
  80186c:	b8 00 00 00 00       	mov    $0x0,%eax
  801871:	e9 f7 00 00 00       	jmp    80196d <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801876:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801879:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80187c:	eb 48                	jmp    8018c6 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  80187e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801881:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801884:	c1 e8 0c             	shr    $0xc,%eax
  801887:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  80188a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80188d:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801894:	85 c0                	test   %eax,%eax
  801896:	75 11                	jne    8018a9 <sget+0xd1>
			free_Pages_Count++;
  801898:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  80189b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80189f:	75 16                	jne    8018b7 <sget+0xdf>
				start = s;
  8018a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018a7:	eb 0e                	jmp    8018b7 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  8018a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8018b0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  8018b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ba:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8018bd:	74 12                	je     8018d1 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8018bf:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8018c6:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8018cd:	76 af                	jbe    80187e <sget+0xa6>
  8018cf:	eb 01                	jmp    8018d2 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  8018d1:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  8018d2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8018d6:	74 08                	je     8018e0 <sget+0x108>
  8018d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018db:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8018de:	74 0a                	je     8018ea <sget+0x112>
		return NULL;
  8018e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e5:	e9 83 00 00 00       	jmp    80196d <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  8018ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ed:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8018f0:	c1 e8 0c             	shr    $0xc,%eax
  8018f3:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  8018f6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8018f9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018fc:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801903:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801906:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801909:	eb 11                	jmp    80191c <sget+0x144>
		markedPages[k] = 1;
  80190b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80190e:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801915:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801919:	ff 45 e8             	incl   -0x18(%ebp)
  80191c:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80191f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801922:	01 d0                	add    %edx,%eax
  801924:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801927:	77 e2                	ja     80190b <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  801929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192c:	83 ec 04             	sub    $0x4,%esp
  80192f:	50                   	push   %eax
  801930:	ff 75 0c             	pushl  0xc(%ebp)
  801933:	ff 75 08             	pushl  0x8(%ebp)
  801936:	e8 3f 03 00 00       	call   801c7a <sys_getSharedObject>
  80193b:	83 c4 10             	add    $0x10,%esp
  80193e:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  801941:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  801945:	78 12                	js     801959 <sget+0x181>
		shardIDs[startPage] = ss;
  801947:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80194a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80194d:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801954:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801957:	eb 14                	jmp    80196d <sget+0x195>
	}
	free((void*) start);
  801959:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80195c:	83 ec 0c             	sub    $0xc,%esp
  80195f:	50                   	push   %eax
  801960:	e8 d7 fb ff ff       	call   80153c <free>
  801965:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801968:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
  801972:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801975:	8b 55 08             	mov    0x8(%ebp),%edx
  801978:	a1 20 50 80 00       	mov    0x805020,%eax
  80197d:	8b 40 7c             	mov    0x7c(%eax),%eax
  801980:	29 c2                	sub    %eax,%edx
  801982:	89 d0                	mov    %edx,%eax
  801984:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  801989:	c1 e8 0c             	shr    $0xc,%eax
  80198c:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  80198f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801992:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  801999:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  80199c:	83 ec 08             	sub    $0x8,%esp
  80199f:	ff 75 08             	pushl  0x8(%ebp)
  8019a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8019a5:	e8 ef 02 00 00       	call   801c99 <sys_freeSharedObject>
  8019aa:	83 c4 10             	add    $0x10,%esp
  8019ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  8019b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019b4:	75 0e                	jne    8019c4 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  8019b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b9:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  8019c0:	ff ff ff ff 
	}

}
  8019c4:	90                   	nop
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
  8019ca:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019cd:	83 ec 04             	sub    $0x4,%esp
  8019d0:	68 34 3d 80 00       	push   $0x803d34
  8019d5:	68 19 01 00 00       	push   $0x119
  8019da:	68 26 3d 80 00       	push   $0x803d26
  8019df:	e8 bf 19 00 00       	call   8033a3 <_panic>

008019e4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019ea:	83 ec 04             	sub    $0x4,%esp
  8019ed:	68 5a 3d 80 00       	push   $0x803d5a
  8019f2:	68 23 01 00 00       	push   $0x123
  8019f7:	68 26 3d 80 00       	push   $0x803d26
  8019fc:	e8 a2 19 00 00       	call   8033a3 <_panic>

00801a01 <shrink>:

}
void shrink(uint32 newSize) {
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a07:	83 ec 04             	sub    $0x4,%esp
  801a0a:	68 5a 3d 80 00       	push   $0x803d5a
  801a0f:	68 27 01 00 00       	push   $0x127
  801a14:	68 26 3d 80 00       	push   $0x803d26
  801a19:	e8 85 19 00 00       	call   8033a3 <_panic>

00801a1e <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
  801a21:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a24:	83 ec 04             	sub    $0x4,%esp
  801a27:	68 5a 3d 80 00       	push   $0x803d5a
  801a2c:	68 2b 01 00 00       	push   $0x12b
  801a31:	68 26 3d 80 00       	push   $0x803d26
  801a36:	e8 68 19 00 00       	call   8033a3 <_panic>

00801a3b <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
  801a3e:	57                   	push   %edi
  801a3f:	56                   	push   %esi
  801a40:	53                   	push   %ebx
  801a41:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a4d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a50:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a53:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a56:	cd 30                	int    $0x30
  801a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801a5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a5e:	83 c4 10             	add    $0x10,%esp
  801a61:	5b                   	pop    %ebx
  801a62:	5e                   	pop    %esi
  801a63:	5f                   	pop    %edi
  801a64:	5d                   	pop    %ebp
  801a65:	c3                   	ret    

00801a66 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	83 ec 04             	sub    $0x4,%esp
  801a6c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801a72:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	52                   	push   %edx
  801a7e:	ff 75 0c             	pushl  0xc(%ebp)
  801a81:	50                   	push   %eax
  801a82:	6a 00                	push   $0x0
  801a84:	e8 b2 ff ff ff       	call   801a3b <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	90                   	nop
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <sys_cgetc>:

int sys_cgetc(void) {
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 02                	push   $0x2
  801a9e:	e8 98 ff ff ff       	call   801a3b <syscall>
  801aa3:	83 c4 18             	add    $0x18,%esp
}
  801aa6:	c9                   	leave  
  801aa7:	c3                   	ret    

00801aa8 <sys_lock_cons>:

void sys_lock_cons(void) {
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 03                	push   $0x3
  801ab7:	e8 7f ff ff ff       	call   801a3b <syscall>
  801abc:	83 c4 18             	add    $0x18,%esp
}
  801abf:	90                   	nop
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 04                	push   $0x4
  801ad1:	e8 65 ff ff ff       	call   801a3b <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp
}
  801ad9:	90                   	nop
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801adf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	52                   	push   %edx
  801aec:	50                   	push   %eax
  801aed:	6a 08                	push   $0x8
  801aef:	e8 47 ff ff ff       	call   801a3b <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
  801afc:	56                   	push   %esi
  801afd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801afe:	8b 75 18             	mov    0x18(%ebp),%esi
  801b01:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b04:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0d:	56                   	push   %esi
  801b0e:	53                   	push   %ebx
  801b0f:	51                   	push   %ecx
  801b10:	52                   	push   %edx
  801b11:	50                   	push   %eax
  801b12:	6a 09                	push   $0x9
  801b14:	e8 22 ff ff ff       	call   801a3b <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801b1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b1f:	5b                   	pop    %ebx
  801b20:	5e                   	pop    %esi
  801b21:	5d                   	pop    %ebp
  801b22:	c3                   	ret    

00801b23 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	52                   	push   %edx
  801b33:	50                   	push   %eax
  801b34:	6a 0a                	push   $0xa
  801b36:	e8 00 ff ff ff       	call   801a3b <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	ff 75 0c             	pushl  0xc(%ebp)
  801b4c:	ff 75 08             	pushl  0x8(%ebp)
  801b4f:	6a 0b                	push   $0xb
  801b51:	e8 e5 fe ff ff       	call   801a3b <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 0c                	push   $0xc
  801b6a:	e8 cc fe ff ff       	call   801a3b <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 0d                	push   $0xd
  801b83:	e8 b3 fe ff ff       	call   801a3b <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
}
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 0e                	push   $0xe
  801b9c:	e8 9a fe ff ff       	call   801a3b <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 0f                	push   $0xf
  801bb5:	e8 81 fe ff ff       	call   801a3b <syscall>
  801bba:	83 c4 18             	add    $0x18,%esp
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	ff 75 08             	pushl  0x8(%ebp)
  801bcd:	6a 10                	push   $0x10
  801bcf:	e8 67 fe ff ff       	call   801a3b <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <sys_scarce_memory>:

void sys_scarce_memory() {
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 11                	push   $0x11
  801be8:	e8 4e fe ff ff       	call   801a3b <syscall>
  801bed:	83 c4 18             	add    $0x18,%esp
}
  801bf0:	90                   	nop
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <sys_cputc>:

void sys_cputc(const char c) {
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	83 ec 04             	sub    $0x4,%esp
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801bff:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	50                   	push   %eax
  801c0c:	6a 01                	push   $0x1
  801c0e:	e8 28 fe ff ff       	call   801a3b <syscall>
  801c13:	83 c4 18             	add    $0x18,%esp
}
  801c16:	90                   	nop
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    

00801c19 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 14                	push   $0x14
  801c28:	e8 0e fe ff ff       	call   801a3b <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
}
  801c30:	90                   	nop
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
  801c36:	83 ec 04             	sub    $0x4,%esp
  801c39:	8b 45 10             	mov    0x10(%ebp),%eax
  801c3c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801c3f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c42:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	6a 00                	push   $0x0
  801c4b:	51                   	push   %ecx
  801c4c:	52                   	push   %edx
  801c4d:	ff 75 0c             	pushl  0xc(%ebp)
  801c50:	50                   	push   %eax
  801c51:	6a 15                	push   $0x15
  801c53:	e8 e3 fd ff ff       	call   801a3b <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801c60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c63:	8b 45 08             	mov    0x8(%ebp),%eax
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	52                   	push   %edx
  801c6d:	50                   	push   %eax
  801c6e:	6a 16                	push   $0x16
  801c70:	e8 c6 fd ff ff       	call   801a3b <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801c7d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	51                   	push   %ecx
  801c8b:	52                   	push   %edx
  801c8c:	50                   	push   %eax
  801c8d:	6a 17                	push   $0x17
  801c8f:	e8 a7 fd ff ff       	call   801a3b <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801c9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	52                   	push   %edx
  801ca9:	50                   	push   %eax
  801caa:	6a 18                	push   $0x18
  801cac:	e8 8a fd ff ff       	call   801a3b <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbc:	6a 00                	push   $0x0
  801cbe:	ff 75 14             	pushl  0x14(%ebp)
  801cc1:	ff 75 10             	pushl  0x10(%ebp)
  801cc4:	ff 75 0c             	pushl  0xc(%ebp)
  801cc7:	50                   	push   %eax
  801cc8:	6a 19                	push   $0x19
  801cca:	e8 6c fd ff ff       	call   801a3b <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <sys_run_env>:

void sys_run_env(int32 envId) {
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	50                   	push   %eax
  801ce3:	6a 1a                	push   $0x1a
  801ce5:	e8 51 fd ff ff       	call   801a3b <syscall>
  801cea:	83 c4 18             	add    $0x18,%esp
}
  801ced:	90                   	nop
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	50                   	push   %eax
  801cff:	6a 1b                	push   $0x1b
  801d01:	e8 35 fd ff ff       	call   801a3b <syscall>
  801d06:	83 c4 18             	add    $0x18,%esp
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <sys_getenvid>:

int32 sys_getenvid(void) {
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 05                	push   $0x5
  801d1a:	e8 1c fd ff ff       	call   801a3b <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
}
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 06                	push   $0x6
  801d33:	e8 03 fd ff ff       	call   801a3b <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 07                	push   $0x7
  801d4c:	e8 ea fc ff ff       	call   801a3b <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
}
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <sys_exit_env>:

void sys_exit_env(void) {
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 1c                	push   $0x1c
  801d65:	e8 d1 fc ff ff       	call   801a3b <syscall>
  801d6a:	83 c4 18             	add    $0x18,%esp
}
  801d6d:	90                   	nop
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801d76:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d79:	8d 50 04             	lea    0x4(%eax),%edx
  801d7c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	52                   	push   %edx
  801d86:	50                   	push   %eax
  801d87:	6a 1d                	push   $0x1d
  801d89:	e8 ad fc ff ff       	call   801a3b <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801d91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d9a:	89 01                	mov    %eax,(%ecx)
  801d9c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801da2:	c9                   	leave  
  801da3:	c2 04 00             	ret    $0x4

00801da6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	ff 75 10             	pushl  0x10(%ebp)
  801db0:	ff 75 0c             	pushl  0xc(%ebp)
  801db3:	ff 75 08             	pushl  0x8(%ebp)
  801db6:	6a 13                	push   $0x13
  801db8:	e8 7e fc ff ff       	call   801a3b <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801dc0:	90                   	nop
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <sys_rcr2>:
uint32 sys_rcr2() {
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 1e                	push   $0x1e
  801dd2:	e8 64 fc ff ff       	call   801a3b <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	83 ec 04             	sub    $0x4,%esp
  801de2:	8b 45 08             	mov    0x8(%ebp),%eax
  801de5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801de8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	50                   	push   %eax
  801df5:	6a 1f                	push   $0x1f
  801df7:	e8 3f fc ff ff       	call   801a3b <syscall>
  801dfc:	83 c4 18             	add    $0x18,%esp
	return;
  801dff:	90                   	nop
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <rsttst>:
void rsttst() {
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 21                	push   $0x21
  801e11:	e8 25 fc ff ff       	call   801a3b <syscall>
  801e16:	83 c4 18             	add    $0x18,%esp
	return;
  801e19:	90                   	nop
}
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
  801e1f:	83 ec 04             	sub    $0x4,%esp
  801e22:	8b 45 14             	mov    0x14(%ebp),%eax
  801e25:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e28:	8b 55 18             	mov    0x18(%ebp),%edx
  801e2b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e2f:	52                   	push   %edx
  801e30:	50                   	push   %eax
  801e31:	ff 75 10             	pushl  0x10(%ebp)
  801e34:	ff 75 0c             	pushl  0xc(%ebp)
  801e37:	ff 75 08             	pushl  0x8(%ebp)
  801e3a:	6a 20                	push   $0x20
  801e3c:	e8 fa fb ff ff       	call   801a3b <syscall>
  801e41:	83 c4 18             	add    $0x18,%esp
	return;
  801e44:	90                   	nop
}
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    

00801e47 <chktst>:
void chktst(uint32 n) {
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	ff 75 08             	pushl  0x8(%ebp)
  801e55:	6a 22                	push   $0x22
  801e57:	e8 df fb ff ff       	call   801a3b <syscall>
  801e5c:	83 c4 18             	add    $0x18,%esp
	return;
  801e5f:	90                   	nop
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <inctst>:

void inctst() {
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 23                	push   $0x23
  801e71:	e8 c5 fb ff ff       	call   801a3b <syscall>
  801e76:	83 c4 18             	add    $0x18,%esp
	return;
  801e79:	90                   	nop
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <gettst>:
uint32 gettst() {
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 24                	push   $0x24
  801e8b:	e8 ab fb ff ff       	call   801a3b <syscall>
  801e90:	83 c4 18             	add    $0x18,%esp
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 25                	push   $0x25
  801ea7:	e8 8f fb ff ff       	call   801a3b <syscall>
  801eac:	83 c4 18             	add    $0x18,%esp
  801eaf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801eb2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801eb6:	75 07                	jne    801ebf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801eb8:	b8 01 00 00 00       	mov    $0x1,%eax
  801ebd:	eb 05                	jmp    801ec4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ebf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 25                	push   $0x25
  801ed8:	e8 5e fb ff ff       	call   801a3b <syscall>
  801edd:	83 c4 18             	add    $0x18,%esp
  801ee0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ee3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ee7:	75 07                	jne    801ef0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ee9:	b8 01 00 00 00       	mov    $0x1,%eax
  801eee:	eb 05                	jmp    801ef5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ef0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 25                	push   $0x25
  801f09:	e8 2d fb ff ff       	call   801a3b <syscall>
  801f0e:	83 c4 18             	add    $0x18,%esp
  801f11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f14:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f18:	75 07                	jne    801f21 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f1a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f1f:	eb 05                	jmp    801f26 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    

00801f28 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
  801f2b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 25                	push   $0x25
  801f3a:	e8 fc fa ff ff       	call   801a3b <syscall>
  801f3f:	83 c4 18             	add    $0x18,%esp
  801f42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f45:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f49:	75 07                	jne    801f52 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f4b:	b8 01 00 00 00       	mov    $0x1,%eax
  801f50:	eb 05                	jmp    801f57 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f57:	c9                   	leave  
  801f58:	c3                   	ret    

00801f59 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	ff 75 08             	pushl  0x8(%ebp)
  801f67:	6a 26                	push   $0x26
  801f69:	e8 cd fa ff ff       	call   801a3b <syscall>
  801f6e:	83 c4 18             	add    $0x18,%esp
	return;
  801f71:	90                   	nop
}
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
  801f77:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801f78:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f81:	8b 45 08             	mov    0x8(%ebp),%eax
  801f84:	6a 00                	push   $0x0
  801f86:	53                   	push   %ebx
  801f87:	51                   	push   %ecx
  801f88:	52                   	push   %edx
  801f89:	50                   	push   %eax
  801f8a:	6a 27                	push   $0x27
  801f8c:	e8 aa fa ff ff       	call   801a3b <syscall>
  801f91:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801f94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801f9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	52                   	push   %edx
  801fa9:	50                   	push   %eax
  801faa:	6a 28                	push   $0x28
  801fac:	e8 8a fa ff ff       	call   801a3b <syscall>
  801fb1:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801fb9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc2:	6a 00                	push   $0x0
  801fc4:	51                   	push   %ecx
  801fc5:	ff 75 10             	pushl  0x10(%ebp)
  801fc8:	52                   	push   %edx
  801fc9:	50                   	push   %eax
  801fca:	6a 29                	push   $0x29
  801fcc:	e8 6a fa ff ff       	call   801a3b <syscall>
  801fd1:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801fd4:	c9                   	leave  
  801fd5:	c3                   	ret    

00801fd6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	ff 75 10             	pushl  0x10(%ebp)
  801fe0:	ff 75 0c             	pushl  0xc(%ebp)
  801fe3:	ff 75 08             	pushl  0x8(%ebp)
  801fe6:	6a 12                	push   $0x12
  801fe8:	e8 4e fa ff ff       	call   801a3b <syscall>
  801fed:	83 c4 18             	add    $0x18,%esp
	return;
  801ff0:	90                   	nop
}
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801ff6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	52                   	push   %edx
  802003:	50                   	push   %eax
  802004:	6a 2a                	push   $0x2a
  802006:	e8 30 fa ff ff       	call   801a3b <syscall>
  80200b:	83 c4 18             	add    $0x18,%esp
	return;
  80200e:	90                   	nop
}
  80200f:	c9                   	leave  
  802010:	c3                   	ret    

00802011 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	50                   	push   %eax
  802020:	6a 2b                	push   $0x2b
  802022:	e8 14 fa ff ff       	call   801a3b <syscall>
  802027:	83 c4 18             	add    $0x18,%esp
}
  80202a:	c9                   	leave  
  80202b:	c3                   	ret    

0080202c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	ff 75 0c             	pushl  0xc(%ebp)
  802038:	ff 75 08             	pushl  0x8(%ebp)
  80203b:	6a 2c                	push   $0x2c
  80203d:	e8 f9 f9 ff ff       	call   801a3b <syscall>
  802042:	83 c4 18             	add    $0x18,%esp
	return;
  802045:	90                   	nop
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	ff 75 0c             	pushl  0xc(%ebp)
  802054:	ff 75 08             	pushl  0x8(%ebp)
  802057:	6a 2d                	push   $0x2d
  802059:	e8 dd f9 ff ff       	call   801a3b <syscall>
  80205e:	83 c4 18             	add    $0x18,%esp
	return;
  802061:	90                   	nop
}
  802062:	c9                   	leave  
  802063:	c3                   	ret    

00802064 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  802067:	8b 45 08             	mov    0x8(%ebp),%eax
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	50                   	push   %eax
  802073:	6a 2f                	push   $0x2f
  802075:	e8 c1 f9 ff ff       	call   801a3b <syscall>
  80207a:	83 c4 18             	add    $0x18,%esp
	return;
  80207d:	90                   	nop
}
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  802083:	8b 55 0c             	mov    0xc(%ebp),%edx
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	52                   	push   %edx
  802090:	50                   	push   %eax
  802091:	6a 30                	push   $0x30
  802093:	e8 a3 f9 ff ff       	call   801a3b <syscall>
  802098:	83 c4 18             	add    $0x18,%esp
	return;
  80209b:	90                   	nop
}
  80209c:	c9                   	leave  
  80209d:	c3                   	ret    

0080209e <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  8020a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	50                   	push   %eax
  8020ad:	6a 31                	push   $0x31
  8020af:	e8 87 f9 ff ff       	call   801a3b <syscall>
  8020b4:	83 c4 18             	add    $0x18,%esp
	return;
  8020b7:	90                   	nop
}
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    

008020ba <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8020bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	52                   	push   %edx
  8020ca:	50                   	push   %eax
  8020cb:	6a 2e                	push   $0x2e
  8020cd:	e8 69 f9 ff ff       	call   801a3b <syscall>
  8020d2:	83 c4 18             	add    $0x18,%esp
    return;
  8020d5:	90                   	nop
}
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
  8020db:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e1:	83 e8 04             	sub    $0x4,%eax
  8020e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8020e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ea:	8b 00                	mov    (%eax),%eax
  8020ec:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    

008020f1 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
  8020f4:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fa:	83 e8 04             	sub    $0x4,%eax
  8020fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802100:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802103:	8b 00                	mov    (%eax),%eax
  802105:	83 e0 01             	and    $0x1,%eax
  802108:	85 c0                	test   %eax,%eax
  80210a:	0f 94 c0             	sete   %al
}
  80210d:	c9                   	leave  
  80210e:	c3                   	ret    

0080210f <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
  802112:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802115:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80211c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211f:	83 f8 02             	cmp    $0x2,%eax
  802122:	74 2b                	je     80214f <alloc_block+0x40>
  802124:	83 f8 02             	cmp    $0x2,%eax
  802127:	7f 07                	jg     802130 <alloc_block+0x21>
  802129:	83 f8 01             	cmp    $0x1,%eax
  80212c:	74 0e                	je     80213c <alloc_block+0x2d>
  80212e:	eb 58                	jmp    802188 <alloc_block+0x79>
  802130:	83 f8 03             	cmp    $0x3,%eax
  802133:	74 2d                	je     802162 <alloc_block+0x53>
  802135:	83 f8 04             	cmp    $0x4,%eax
  802138:	74 3b                	je     802175 <alloc_block+0x66>
  80213a:	eb 4c                	jmp    802188 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80213c:	83 ec 0c             	sub    $0xc,%esp
  80213f:	ff 75 08             	pushl  0x8(%ebp)
  802142:	e8 f7 03 00 00       	call   80253e <alloc_block_FF>
  802147:	83 c4 10             	add    $0x10,%esp
  80214a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80214d:	eb 4a                	jmp    802199 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80214f:	83 ec 0c             	sub    $0xc,%esp
  802152:	ff 75 08             	pushl  0x8(%ebp)
  802155:	e8 f0 11 00 00       	call   80334a <alloc_block_NF>
  80215a:	83 c4 10             	add    $0x10,%esp
  80215d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802160:	eb 37                	jmp    802199 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802162:	83 ec 0c             	sub    $0xc,%esp
  802165:	ff 75 08             	pushl  0x8(%ebp)
  802168:	e8 08 08 00 00       	call   802975 <alloc_block_BF>
  80216d:	83 c4 10             	add    $0x10,%esp
  802170:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802173:	eb 24                	jmp    802199 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802175:	83 ec 0c             	sub    $0xc,%esp
  802178:	ff 75 08             	pushl  0x8(%ebp)
  80217b:	e8 ad 11 00 00       	call   80332d <alloc_block_WF>
  802180:	83 c4 10             	add    $0x10,%esp
  802183:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802186:	eb 11                	jmp    802199 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802188:	83 ec 0c             	sub    $0xc,%esp
  80218b:	68 6c 3d 80 00       	push   $0x803d6c
  802190:	e8 39 e2 ff ff       	call   8003ce <cprintf>
  802195:	83 c4 10             	add    $0x10,%esp
		break;
  802198:	90                   	nop
	}
	return va;
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80219c:	c9                   	leave  
  80219d:	c3                   	ret    

0080219e <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
  8021a1:	53                   	push   %ebx
  8021a2:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8021a5:	83 ec 0c             	sub    $0xc,%esp
  8021a8:	68 8c 3d 80 00       	push   $0x803d8c
  8021ad:	e8 1c e2 ff ff       	call   8003ce <cprintf>
  8021b2:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8021b5:	83 ec 0c             	sub    $0xc,%esp
  8021b8:	68 b7 3d 80 00       	push   $0x803db7
  8021bd:	e8 0c e2 ff ff       	call   8003ce <cprintf>
  8021c2:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021cb:	eb 37                	jmp    802204 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8021cd:	83 ec 0c             	sub    $0xc,%esp
  8021d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8021d3:	e8 19 ff ff ff       	call   8020f1 <is_free_block>
  8021d8:	83 c4 10             	add    $0x10,%esp
  8021db:	0f be d8             	movsbl %al,%ebx
  8021de:	83 ec 0c             	sub    $0xc,%esp
  8021e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8021e4:	e8 ef fe ff ff       	call   8020d8 <get_block_size>
  8021e9:	83 c4 10             	add    $0x10,%esp
  8021ec:	83 ec 04             	sub    $0x4,%esp
  8021ef:	53                   	push   %ebx
  8021f0:	50                   	push   %eax
  8021f1:	68 cf 3d 80 00       	push   $0x803dcf
  8021f6:	e8 d3 e1 ff ff       	call   8003ce <cprintf>
  8021fb:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8021fe:	8b 45 10             	mov    0x10(%ebp),%eax
  802201:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802204:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802208:	74 07                	je     802211 <print_blocks_list+0x73>
  80220a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220d:	8b 00                	mov    (%eax),%eax
  80220f:	eb 05                	jmp    802216 <print_blocks_list+0x78>
  802211:	b8 00 00 00 00       	mov    $0x0,%eax
  802216:	89 45 10             	mov    %eax,0x10(%ebp)
  802219:	8b 45 10             	mov    0x10(%ebp),%eax
  80221c:	85 c0                	test   %eax,%eax
  80221e:	75 ad                	jne    8021cd <print_blocks_list+0x2f>
  802220:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802224:	75 a7                	jne    8021cd <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802226:	83 ec 0c             	sub    $0xc,%esp
  802229:	68 8c 3d 80 00       	push   $0x803d8c
  80222e:	e8 9b e1 ff ff       	call   8003ce <cprintf>
  802233:	83 c4 10             	add    $0x10,%esp

}
  802236:	90                   	nop
  802237:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    

0080223c <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
  80223f:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802242:	8b 45 0c             	mov    0xc(%ebp),%eax
  802245:	83 e0 01             	and    $0x1,%eax
  802248:	85 c0                	test   %eax,%eax
  80224a:	74 03                	je     80224f <initialize_dynamic_allocator+0x13>
  80224c:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  80224f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802253:	0f 84 f8 00 00 00    	je     802351 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  802259:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  802260:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  802263:	a1 40 50 98 00       	mov    0x985040,%eax
  802268:	85 c0                	test   %eax,%eax
  80226a:	0f 84 e2 00 00 00    	je     802352 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  802270:	8b 45 08             	mov    0x8(%ebp),%eax
  802273:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802279:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  80227f:	8b 55 08             	mov    0x8(%ebp),%edx
  802282:	8b 45 0c             	mov    0xc(%ebp),%eax
  802285:	01 d0                	add    %edx,%eax
  802287:	83 e8 04             	sub    $0x4,%eax
  80228a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  80228d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802290:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	83 c0 08             	add    $0x8,%eax
  80229c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  80229f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a2:	83 e8 08             	sub    $0x8,%eax
  8022a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  8022a8:	83 ec 04             	sub    $0x4,%esp
  8022ab:	6a 00                	push   $0x0
  8022ad:	ff 75 e8             	pushl  -0x18(%ebp)
  8022b0:	ff 75 ec             	pushl  -0x14(%ebp)
  8022b3:	e8 9c 00 00 00       	call   802354 <set_block_data>
  8022b8:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  8022bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  8022c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  8022ce:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  8022d5:	00 00 00 
  8022d8:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  8022df:	00 00 00 
  8022e2:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  8022e9:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  8022ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022f0:	75 17                	jne    802309 <initialize_dynamic_allocator+0xcd>
  8022f2:	83 ec 04             	sub    $0x4,%esp
  8022f5:	68 e8 3d 80 00       	push   $0x803de8
  8022fa:	68 80 00 00 00       	push   $0x80
  8022ff:	68 0b 3e 80 00       	push   $0x803e0b
  802304:	e8 9a 10 00 00       	call   8033a3 <_panic>
  802309:	8b 15 48 50 98 00    	mov    0x985048,%edx
  80230f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802312:	89 10                	mov    %edx,(%eax)
  802314:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802317:	8b 00                	mov    (%eax),%eax
  802319:	85 c0                	test   %eax,%eax
  80231b:	74 0d                	je     80232a <initialize_dynamic_allocator+0xee>
  80231d:	a1 48 50 98 00       	mov    0x985048,%eax
  802322:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802325:	89 50 04             	mov    %edx,0x4(%eax)
  802328:	eb 08                	jmp    802332 <initialize_dynamic_allocator+0xf6>
  80232a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80232d:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802332:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802335:	a3 48 50 98 00       	mov    %eax,0x985048
  80233a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80233d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802344:	a1 54 50 98 00       	mov    0x985054,%eax
  802349:	40                   	inc    %eax
  80234a:	a3 54 50 98 00       	mov    %eax,0x985054
  80234f:	eb 01                	jmp    802352 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802351:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  802352:	c9                   	leave  
  802353:	c3                   	ret    

00802354 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
  802357:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  80235a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80235d:	83 e0 01             	and    $0x1,%eax
  802360:	85 c0                	test   %eax,%eax
  802362:	74 03                	je     802367 <set_block_data+0x13>
	{
		totalSize++;
  802364:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  802367:	8b 45 08             	mov    0x8(%ebp),%eax
  80236a:	83 e8 04             	sub    $0x4,%eax
  80236d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  802370:	8b 45 0c             	mov    0xc(%ebp),%eax
  802373:	83 e0 fe             	and    $0xfffffffe,%eax
  802376:	89 c2                	mov    %eax,%edx
  802378:	8b 45 10             	mov    0x10(%ebp),%eax
  80237b:	83 e0 01             	and    $0x1,%eax
  80237e:	09 c2                	or     %eax,%edx
  802380:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802383:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  802385:	8b 45 0c             	mov    0xc(%ebp),%eax
  802388:	8d 50 f8             	lea    -0x8(%eax),%edx
  80238b:	8b 45 08             	mov    0x8(%ebp),%eax
  80238e:	01 d0                	add    %edx,%eax
  802390:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  802393:	8b 45 0c             	mov    0xc(%ebp),%eax
  802396:	83 e0 fe             	and    $0xfffffffe,%eax
  802399:	89 c2                	mov    %eax,%edx
  80239b:	8b 45 10             	mov    0x10(%ebp),%eax
  80239e:	83 e0 01             	and    $0x1,%eax
  8023a1:	09 c2                	or     %eax,%edx
  8023a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023a6:	89 10                	mov    %edx,(%eax)
}
  8023a8:	90                   	nop
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
  8023ae:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  8023b1:	a1 48 50 98 00       	mov    0x985048,%eax
  8023b6:	85 c0                	test   %eax,%eax
  8023b8:	75 68                	jne    802422 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  8023ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023be:	75 17                	jne    8023d7 <insert_sorted_in_freeList+0x2c>
  8023c0:	83 ec 04             	sub    $0x4,%esp
  8023c3:	68 e8 3d 80 00       	push   $0x803de8
  8023c8:	68 9d 00 00 00       	push   $0x9d
  8023cd:	68 0b 3e 80 00       	push   $0x803e0b
  8023d2:	e8 cc 0f 00 00       	call   8033a3 <_panic>
  8023d7:	8b 15 48 50 98 00    	mov    0x985048,%edx
  8023dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e0:	89 10                	mov    %edx,(%eax)
  8023e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e5:	8b 00                	mov    (%eax),%eax
  8023e7:	85 c0                	test   %eax,%eax
  8023e9:	74 0d                	je     8023f8 <insert_sorted_in_freeList+0x4d>
  8023eb:	a1 48 50 98 00       	mov    0x985048,%eax
  8023f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f3:	89 50 04             	mov    %edx,0x4(%eax)
  8023f6:	eb 08                	jmp    802400 <insert_sorted_in_freeList+0x55>
  8023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fb:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802400:	8b 45 08             	mov    0x8(%ebp),%eax
  802403:	a3 48 50 98 00       	mov    %eax,0x985048
  802408:	8b 45 08             	mov    0x8(%ebp),%eax
  80240b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802412:	a1 54 50 98 00       	mov    0x985054,%eax
  802417:	40                   	inc    %eax
  802418:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  80241d:	e9 1a 01 00 00       	jmp    80253c <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802422:	a1 48 50 98 00       	mov    0x985048,%eax
  802427:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80242a:	eb 7f                	jmp    8024ab <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  80242c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802432:	76 6f                	jbe    8024a3 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  802434:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802438:	74 06                	je     802440 <insert_sorted_in_freeList+0x95>
  80243a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80243e:	75 17                	jne    802457 <insert_sorted_in_freeList+0xac>
  802440:	83 ec 04             	sub    $0x4,%esp
  802443:	68 24 3e 80 00       	push   $0x803e24
  802448:	68 a6 00 00 00       	push   $0xa6
  80244d:	68 0b 3e 80 00       	push   $0x803e0b
  802452:	e8 4c 0f 00 00       	call   8033a3 <_panic>
  802457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245a:	8b 50 04             	mov    0x4(%eax),%edx
  80245d:	8b 45 08             	mov    0x8(%ebp),%eax
  802460:	89 50 04             	mov    %edx,0x4(%eax)
  802463:	8b 45 08             	mov    0x8(%ebp),%eax
  802466:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802469:	89 10                	mov    %edx,(%eax)
  80246b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246e:	8b 40 04             	mov    0x4(%eax),%eax
  802471:	85 c0                	test   %eax,%eax
  802473:	74 0d                	je     802482 <insert_sorted_in_freeList+0xd7>
  802475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802478:	8b 40 04             	mov    0x4(%eax),%eax
  80247b:	8b 55 08             	mov    0x8(%ebp),%edx
  80247e:	89 10                	mov    %edx,(%eax)
  802480:	eb 08                	jmp    80248a <insert_sorted_in_freeList+0xdf>
  802482:	8b 45 08             	mov    0x8(%ebp),%eax
  802485:	a3 48 50 98 00       	mov    %eax,0x985048
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	8b 55 08             	mov    0x8(%ebp),%edx
  802490:	89 50 04             	mov    %edx,0x4(%eax)
  802493:	a1 54 50 98 00       	mov    0x985054,%eax
  802498:	40                   	inc    %eax
  802499:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  80249e:	e9 99 00 00 00       	jmp    80253c <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8024a3:	a1 50 50 98 00       	mov    0x985050,%eax
  8024a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024af:	74 07                	je     8024b8 <insert_sorted_in_freeList+0x10d>
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	8b 00                	mov    (%eax),%eax
  8024b6:	eb 05                	jmp    8024bd <insert_sorted_in_freeList+0x112>
  8024b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bd:	a3 50 50 98 00       	mov    %eax,0x985050
  8024c2:	a1 50 50 98 00       	mov    0x985050,%eax
  8024c7:	85 c0                	test   %eax,%eax
  8024c9:	0f 85 5d ff ff ff    	jne    80242c <insert_sorted_in_freeList+0x81>
  8024cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d3:	0f 85 53 ff ff ff    	jne    80242c <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  8024d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024dd:	75 17                	jne    8024f6 <insert_sorted_in_freeList+0x14b>
  8024df:	83 ec 04             	sub    $0x4,%esp
  8024e2:	68 5c 3e 80 00       	push   $0x803e5c
  8024e7:	68 ab 00 00 00       	push   $0xab
  8024ec:	68 0b 3e 80 00       	push   $0x803e0b
  8024f1:	e8 ad 0e 00 00       	call   8033a3 <_panic>
  8024f6:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  8024fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ff:	89 50 04             	mov    %edx,0x4(%eax)
  802502:	8b 45 08             	mov    0x8(%ebp),%eax
  802505:	8b 40 04             	mov    0x4(%eax),%eax
  802508:	85 c0                	test   %eax,%eax
  80250a:	74 0c                	je     802518 <insert_sorted_in_freeList+0x16d>
  80250c:	a1 4c 50 98 00       	mov    0x98504c,%eax
  802511:	8b 55 08             	mov    0x8(%ebp),%edx
  802514:	89 10                	mov    %edx,(%eax)
  802516:	eb 08                	jmp    802520 <insert_sorted_in_freeList+0x175>
  802518:	8b 45 08             	mov    0x8(%ebp),%eax
  80251b:	a3 48 50 98 00       	mov    %eax,0x985048
  802520:	8b 45 08             	mov    0x8(%ebp),%eax
  802523:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802528:	8b 45 08             	mov    0x8(%ebp),%eax
  80252b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802531:	a1 54 50 98 00       	mov    0x985054,%eax
  802536:	40                   	inc    %eax
  802537:	a3 54 50 98 00       	mov    %eax,0x985054
}
  80253c:	c9                   	leave  
  80253d:	c3                   	ret    

0080253e <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  80253e:	55                   	push   %ebp
  80253f:	89 e5                	mov    %esp,%ebp
  802541:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802544:	8b 45 08             	mov    0x8(%ebp),%eax
  802547:	83 e0 01             	and    $0x1,%eax
  80254a:	85 c0                	test   %eax,%eax
  80254c:	74 03                	je     802551 <alloc_block_FF+0x13>
  80254e:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802551:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802555:	77 07                	ja     80255e <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802557:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80255e:	a1 40 50 98 00       	mov    0x985040,%eax
  802563:	85 c0                	test   %eax,%eax
  802565:	75 63                	jne    8025ca <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802567:	8b 45 08             	mov    0x8(%ebp),%eax
  80256a:	83 c0 10             	add    $0x10,%eax
  80256d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802570:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802577:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80257a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80257d:	01 d0                	add    %edx,%eax
  80257f:	48                   	dec    %eax
  802580:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802583:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802586:	ba 00 00 00 00       	mov    $0x0,%edx
  80258b:	f7 75 ec             	divl   -0x14(%ebp)
  80258e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802591:	29 d0                	sub    %edx,%eax
  802593:	c1 e8 0c             	shr    $0xc,%eax
  802596:	83 ec 0c             	sub    $0xc,%esp
  802599:	50                   	push   %eax
  80259a:	e8 d1 ed ff ff       	call   801370 <sbrk>
  80259f:	83 c4 10             	add    $0x10,%esp
  8025a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8025a5:	83 ec 0c             	sub    $0xc,%esp
  8025a8:	6a 00                	push   $0x0
  8025aa:	e8 c1 ed ff ff       	call   801370 <sbrk>
  8025af:	83 c4 10             	add    $0x10,%esp
  8025b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8025b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025b8:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8025bb:	83 ec 08             	sub    $0x8,%esp
  8025be:	50                   	push   %eax
  8025bf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8025c2:	e8 75 fc ff ff       	call   80223c <initialize_dynamic_allocator>
  8025c7:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  8025ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025ce:	75 0a                	jne    8025da <alloc_block_FF+0x9c>
	{
		return NULL;
  8025d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d5:	e9 99 03 00 00       	jmp    802973 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  8025da:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dd:	83 c0 08             	add    $0x8,%eax
  8025e0:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8025e3:	a1 48 50 98 00       	mov    0x985048,%eax
  8025e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025eb:	e9 03 02 00 00       	jmp    8027f3 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  8025f0:	83 ec 0c             	sub    $0xc,%esp
  8025f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8025f6:	e8 dd fa ff ff       	call   8020d8 <get_block_size>
  8025fb:	83 c4 10             	add    $0x10,%esp
  8025fe:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802601:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802604:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802607:	0f 82 de 01 00 00    	jb     8027eb <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  80260d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802610:	83 c0 10             	add    $0x10,%eax
  802613:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802616:	0f 87 32 01 00 00    	ja     80274e <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  80261c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80261f:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802622:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802625:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802628:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80262b:	01 d0                	add    %edx,%eax
  80262d:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  802630:	83 ec 04             	sub    $0x4,%esp
  802633:	6a 00                	push   $0x0
  802635:	ff 75 98             	pushl  -0x68(%ebp)
  802638:	ff 75 94             	pushl  -0x6c(%ebp)
  80263b:	e8 14 fd ff ff       	call   802354 <set_block_data>
  802640:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802643:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802647:	74 06                	je     80264f <alloc_block_FF+0x111>
  802649:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  80264d:	75 17                	jne    802666 <alloc_block_FF+0x128>
  80264f:	83 ec 04             	sub    $0x4,%esp
  802652:	68 80 3e 80 00       	push   $0x803e80
  802657:	68 de 00 00 00       	push   $0xde
  80265c:	68 0b 3e 80 00       	push   $0x803e0b
  802661:	e8 3d 0d 00 00       	call   8033a3 <_panic>
  802666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802669:	8b 10                	mov    (%eax),%edx
  80266b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80266e:	89 10                	mov    %edx,(%eax)
  802670:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802673:	8b 00                	mov    (%eax),%eax
  802675:	85 c0                	test   %eax,%eax
  802677:	74 0b                	je     802684 <alloc_block_FF+0x146>
  802679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267c:	8b 00                	mov    (%eax),%eax
  80267e:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802681:	89 50 04             	mov    %edx,0x4(%eax)
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	8b 55 94             	mov    -0x6c(%ebp),%edx
  80268a:	89 10                	mov    %edx,(%eax)
  80268c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80268f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802692:	89 50 04             	mov    %edx,0x4(%eax)
  802695:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802698:	8b 00                	mov    (%eax),%eax
  80269a:	85 c0                	test   %eax,%eax
  80269c:	75 08                	jne    8026a6 <alloc_block_FF+0x168>
  80269e:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8026a1:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8026a6:	a1 54 50 98 00       	mov    0x985054,%eax
  8026ab:	40                   	inc    %eax
  8026ac:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  8026b1:	83 ec 04             	sub    $0x4,%esp
  8026b4:	6a 01                	push   $0x1
  8026b6:	ff 75 dc             	pushl  -0x24(%ebp)
  8026b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8026bc:	e8 93 fc ff ff       	call   802354 <set_block_data>
  8026c1:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  8026c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c8:	75 17                	jne    8026e1 <alloc_block_FF+0x1a3>
  8026ca:	83 ec 04             	sub    $0x4,%esp
  8026cd:	68 b4 3e 80 00       	push   $0x803eb4
  8026d2:	68 e3 00 00 00       	push   $0xe3
  8026d7:	68 0b 3e 80 00       	push   $0x803e0b
  8026dc:	e8 c2 0c 00 00       	call   8033a3 <_panic>
  8026e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e4:	8b 00                	mov    (%eax),%eax
  8026e6:	85 c0                	test   %eax,%eax
  8026e8:	74 10                	je     8026fa <alloc_block_FF+0x1bc>
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	8b 00                	mov    (%eax),%eax
  8026ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f2:	8b 52 04             	mov    0x4(%edx),%edx
  8026f5:	89 50 04             	mov    %edx,0x4(%eax)
  8026f8:	eb 0b                	jmp    802705 <alloc_block_FF+0x1c7>
  8026fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fd:	8b 40 04             	mov    0x4(%eax),%eax
  802700:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	8b 40 04             	mov    0x4(%eax),%eax
  80270b:	85 c0                	test   %eax,%eax
  80270d:	74 0f                	je     80271e <alloc_block_FF+0x1e0>
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	8b 40 04             	mov    0x4(%eax),%eax
  802715:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802718:	8b 12                	mov    (%edx),%edx
  80271a:	89 10                	mov    %edx,(%eax)
  80271c:	eb 0a                	jmp    802728 <alloc_block_FF+0x1ea>
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	8b 00                	mov    (%eax),%eax
  802723:	a3 48 50 98 00       	mov    %eax,0x985048
  802728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802734:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80273b:	a1 54 50 98 00       	mov    0x985054,%eax
  802740:	48                   	dec    %eax
  802741:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	e9 25 02 00 00       	jmp    802973 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  80274e:	83 ec 04             	sub    $0x4,%esp
  802751:	6a 01                	push   $0x1
  802753:	ff 75 9c             	pushl  -0x64(%ebp)
  802756:	ff 75 f4             	pushl  -0xc(%ebp)
  802759:	e8 f6 fb ff ff       	call   802354 <set_block_data>
  80275e:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802761:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802765:	75 17                	jne    80277e <alloc_block_FF+0x240>
  802767:	83 ec 04             	sub    $0x4,%esp
  80276a:	68 b4 3e 80 00       	push   $0x803eb4
  80276f:	68 eb 00 00 00       	push   $0xeb
  802774:	68 0b 3e 80 00       	push   $0x803e0b
  802779:	e8 25 0c 00 00       	call   8033a3 <_panic>
  80277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802781:	8b 00                	mov    (%eax),%eax
  802783:	85 c0                	test   %eax,%eax
  802785:	74 10                	je     802797 <alloc_block_FF+0x259>
  802787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278a:	8b 00                	mov    (%eax),%eax
  80278c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80278f:	8b 52 04             	mov    0x4(%edx),%edx
  802792:	89 50 04             	mov    %edx,0x4(%eax)
  802795:	eb 0b                	jmp    8027a2 <alloc_block_FF+0x264>
  802797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279a:	8b 40 04             	mov    0x4(%eax),%eax
  80279d:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	8b 40 04             	mov    0x4(%eax),%eax
  8027a8:	85 c0                	test   %eax,%eax
  8027aa:	74 0f                	je     8027bb <alloc_block_FF+0x27d>
  8027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027af:	8b 40 04             	mov    0x4(%eax),%eax
  8027b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b5:	8b 12                	mov    (%edx),%edx
  8027b7:	89 10                	mov    %edx,(%eax)
  8027b9:	eb 0a                	jmp    8027c5 <alloc_block_FF+0x287>
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	8b 00                	mov    (%eax),%eax
  8027c0:	a3 48 50 98 00       	mov    %eax,0x985048
  8027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d8:	a1 54 50 98 00       	mov    0x985054,%eax
  8027dd:	48                   	dec    %eax
  8027de:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	e9 88 01 00 00       	jmp    802973 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8027eb:	a1 50 50 98 00       	mov    0x985050,%eax
  8027f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f7:	74 07                	je     802800 <alloc_block_FF+0x2c2>
  8027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fc:	8b 00                	mov    (%eax),%eax
  8027fe:	eb 05                	jmp    802805 <alloc_block_FF+0x2c7>
  802800:	b8 00 00 00 00       	mov    $0x0,%eax
  802805:	a3 50 50 98 00       	mov    %eax,0x985050
  80280a:	a1 50 50 98 00       	mov    0x985050,%eax
  80280f:	85 c0                	test   %eax,%eax
  802811:	0f 85 d9 fd ff ff    	jne    8025f0 <alloc_block_FF+0xb2>
  802817:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281b:	0f 85 cf fd ff ff    	jne    8025f0 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  802821:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802828:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80282b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80282e:	01 d0                	add    %edx,%eax
  802830:	48                   	dec    %eax
  802831:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802834:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802837:	ba 00 00 00 00       	mov    $0x0,%edx
  80283c:	f7 75 d8             	divl   -0x28(%ebp)
  80283f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802842:	29 d0                	sub    %edx,%eax
  802844:	c1 e8 0c             	shr    $0xc,%eax
  802847:	83 ec 0c             	sub    $0xc,%esp
  80284a:	50                   	push   %eax
  80284b:	e8 20 eb ff ff       	call   801370 <sbrk>
  802850:	83 c4 10             	add    $0x10,%esp
  802853:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802856:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80285a:	75 0a                	jne    802866 <alloc_block_FF+0x328>
		return NULL;
  80285c:	b8 00 00 00 00       	mov    $0x0,%eax
  802861:	e9 0d 01 00 00       	jmp    802973 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  802866:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802869:	83 e8 04             	sub    $0x4,%eax
  80286c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  80286f:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  802876:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802879:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80287c:	01 d0                	add    %edx,%eax
  80287e:	48                   	dec    %eax
  80287f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802882:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802885:	ba 00 00 00 00       	mov    $0x0,%edx
  80288a:	f7 75 c8             	divl   -0x38(%ebp)
  80288d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802890:	29 d0                	sub    %edx,%eax
  802892:	c1 e8 02             	shr    $0x2,%eax
  802895:	c1 e0 02             	shl    $0x2,%eax
  802898:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  80289b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80289e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  8028a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028a7:	83 e8 08             	sub    $0x8,%eax
  8028aa:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  8028ad:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028b0:	8b 00                	mov    (%eax),%eax
  8028b2:	83 e0 fe             	and    $0xfffffffe,%eax
  8028b5:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  8028b8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8028bb:	f7 d8                	neg    %eax
  8028bd:	89 c2                	mov    %eax,%edx
  8028bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028c2:	01 d0                	add    %edx,%eax
  8028c4:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  8028c7:	83 ec 0c             	sub    $0xc,%esp
  8028ca:	ff 75 b8             	pushl  -0x48(%ebp)
  8028cd:	e8 1f f8 ff ff       	call   8020f1 <is_free_block>
  8028d2:	83 c4 10             	add    $0x10,%esp
  8028d5:	0f be c0             	movsbl %al,%eax
  8028d8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  8028db:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8028df:	74 42                	je     802923 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  8028e1:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8028e8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028eb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028ee:	01 d0                	add    %edx,%eax
  8028f0:	48                   	dec    %eax
  8028f1:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8028f4:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8028f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8028fc:	f7 75 b0             	divl   -0x50(%ebp)
  8028ff:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802902:	29 d0                	sub    %edx,%eax
  802904:	89 c2                	mov    %eax,%edx
  802906:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802909:	01 d0                	add    %edx,%eax
  80290b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  80290e:	83 ec 04             	sub    $0x4,%esp
  802911:	6a 00                	push   $0x0
  802913:	ff 75 a8             	pushl  -0x58(%ebp)
  802916:	ff 75 b8             	pushl  -0x48(%ebp)
  802919:	e8 36 fa ff ff       	call   802354 <set_block_data>
  80291e:	83 c4 10             	add    $0x10,%esp
  802921:	eb 42                	jmp    802965 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802923:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  80292a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80292d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802930:	01 d0                	add    %edx,%eax
  802932:	48                   	dec    %eax
  802933:	89 45 a0             	mov    %eax,-0x60(%ebp)
  802936:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802939:	ba 00 00 00 00       	mov    $0x0,%edx
  80293e:	f7 75 a4             	divl   -0x5c(%ebp)
  802941:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802944:	29 d0                	sub    %edx,%eax
  802946:	83 ec 04             	sub    $0x4,%esp
  802949:	6a 00                	push   $0x0
  80294b:	50                   	push   %eax
  80294c:	ff 75 d0             	pushl  -0x30(%ebp)
  80294f:	e8 00 fa ff ff       	call   802354 <set_block_data>
  802954:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802957:	83 ec 0c             	sub    $0xc,%esp
  80295a:	ff 75 d0             	pushl  -0x30(%ebp)
  80295d:	e8 49 fa ff ff       	call   8023ab <insert_sorted_in_freeList>
  802962:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802965:	83 ec 0c             	sub    $0xc,%esp
  802968:	ff 75 08             	pushl  0x8(%ebp)
  80296b:	e8 ce fb ff ff       	call   80253e <alloc_block_FF>
  802970:	83 c4 10             	add    $0x10,%esp
}
  802973:	c9                   	leave  
  802974:	c3                   	ret    

00802975 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802975:	55                   	push   %ebp
  802976:	89 e5                	mov    %esp,%ebp
  802978:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  80297b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80297f:	75 0a                	jne    80298b <alloc_block_BF+0x16>
	{
		return NULL;
  802981:	b8 00 00 00 00       	mov    $0x0,%eax
  802986:	e9 7a 02 00 00       	jmp    802c05 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  80298b:	8b 45 08             	mov    0x8(%ebp),%eax
  80298e:	83 c0 08             	add    $0x8,%eax
  802991:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802994:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  80299b:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8029a2:	a1 48 50 98 00       	mov    0x985048,%eax
  8029a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8029aa:	eb 32                	jmp    8029de <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  8029ac:	ff 75 ec             	pushl  -0x14(%ebp)
  8029af:	e8 24 f7 ff ff       	call   8020d8 <get_block_size>
  8029b4:	83 c4 04             	add    $0x4,%esp
  8029b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  8029ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029bd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8029c0:	72 14                	jb     8029d6 <alloc_block_BF+0x61>
  8029c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029c8:	73 0c                	jae    8029d6 <alloc_block_BF+0x61>
		{
			minBlk = block;
  8029ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  8029d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8029d6:	a1 50 50 98 00       	mov    0x985050,%eax
  8029db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8029de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029e2:	74 07                	je     8029eb <alloc_block_BF+0x76>
  8029e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e7:	8b 00                	mov    (%eax),%eax
  8029e9:	eb 05                	jmp    8029f0 <alloc_block_BF+0x7b>
  8029eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f0:	a3 50 50 98 00       	mov    %eax,0x985050
  8029f5:	a1 50 50 98 00       	mov    0x985050,%eax
  8029fa:	85 c0                	test   %eax,%eax
  8029fc:	75 ae                	jne    8029ac <alloc_block_BF+0x37>
  8029fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a02:	75 a8                	jne    8029ac <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802a04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a08:	75 22                	jne    802a2c <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802a0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a0d:	83 ec 0c             	sub    $0xc,%esp
  802a10:	50                   	push   %eax
  802a11:	e8 5a e9 ff ff       	call   801370 <sbrk>
  802a16:	83 c4 10             	add    $0x10,%esp
  802a19:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  802a1c:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802a20:	75 0a                	jne    802a2c <alloc_block_BF+0xb7>
			return NULL;
  802a22:	b8 00 00 00 00       	mov    $0x0,%eax
  802a27:	e9 d9 01 00 00       	jmp    802c05 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  802a2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2f:	83 c0 10             	add    $0x10,%eax
  802a32:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a35:	0f 87 32 01 00 00    	ja     802b6d <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  802a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802a41:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802a44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a4a:	01 d0                	add    %edx,%eax
  802a4c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  802a4f:	83 ec 04             	sub    $0x4,%esp
  802a52:	6a 00                	push   $0x0
  802a54:	ff 75 dc             	pushl  -0x24(%ebp)
  802a57:	ff 75 d8             	pushl  -0x28(%ebp)
  802a5a:	e8 f5 f8 ff ff       	call   802354 <set_block_data>
  802a5f:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802a62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a66:	74 06                	je     802a6e <alloc_block_BF+0xf9>
  802a68:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802a6c:	75 17                	jne    802a85 <alloc_block_BF+0x110>
  802a6e:	83 ec 04             	sub    $0x4,%esp
  802a71:	68 80 3e 80 00       	push   $0x803e80
  802a76:	68 49 01 00 00       	push   $0x149
  802a7b:	68 0b 3e 80 00       	push   $0x803e0b
  802a80:	e8 1e 09 00 00       	call   8033a3 <_panic>
  802a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a88:	8b 10                	mov    (%eax),%edx
  802a8a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a8d:	89 10                	mov    %edx,(%eax)
  802a8f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a92:	8b 00                	mov    (%eax),%eax
  802a94:	85 c0                	test   %eax,%eax
  802a96:	74 0b                	je     802aa3 <alloc_block_BF+0x12e>
  802a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9b:	8b 00                	mov    (%eax),%eax
  802a9d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802aa0:	89 50 04             	mov    %edx,0x4(%eax)
  802aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802aa9:	89 10                	mov    %edx,(%eax)
  802aab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802aae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab1:	89 50 04             	mov    %edx,0x4(%eax)
  802ab4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ab7:	8b 00                	mov    (%eax),%eax
  802ab9:	85 c0                	test   %eax,%eax
  802abb:	75 08                	jne    802ac5 <alloc_block_BF+0x150>
  802abd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ac0:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802ac5:	a1 54 50 98 00       	mov    0x985054,%eax
  802aca:	40                   	inc    %eax
  802acb:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802ad0:	83 ec 04             	sub    $0x4,%esp
  802ad3:	6a 01                	push   $0x1
  802ad5:	ff 75 e8             	pushl  -0x18(%ebp)
  802ad8:	ff 75 f4             	pushl  -0xc(%ebp)
  802adb:	e8 74 f8 ff ff       	call   802354 <set_block_data>
  802ae0:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802ae3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae7:	75 17                	jne    802b00 <alloc_block_BF+0x18b>
  802ae9:	83 ec 04             	sub    $0x4,%esp
  802aec:	68 b4 3e 80 00       	push   $0x803eb4
  802af1:	68 4e 01 00 00       	push   $0x14e
  802af6:	68 0b 3e 80 00       	push   $0x803e0b
  802afb:	e8 a3 08 00 00       	call   8033a3 <_panic>
  802b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b03:	8b 00                	mov    (%eax),%eax
  802b05:	85 c0                	test   %eax,%eax
  802b07:	74 10                	je     802b19 <alloc_block_BF+0x1a4>
  802b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0c:	8b 00                	mov    (%eax),%eax
  802b0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b11:	8b 52 04             	mov    0x4(%edx),%edx
  802b14:	89 50 04             	mov    %edx,0x4(%eax)
  802b17:	eb 0b                	jmp    802b24 <alloc_block_BF+0x1af>
  802b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1c:	8b 40 04             	mov    0x4(%eax),%eax
  802b1f:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b27:	8b 40 04             	mov    0x4(%eax),%eax
  802b2a:	85 c0                	test   %eax,%eax
  802b2c:	74 0f                	je     802b3d <alloc_block_BF+0x1c8>
  802b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b31:	8b 40 04             	mov    0x4(%eax),%eax
  802b34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b37:	8b 12                	mov    (%edx),%edx
  802b39:	89 10                	mov    %edx,(%eax)
  802b3b:	eb 0a                	jmp    802b47 <alloc_block_BF+0x1d2>
  802b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b40:	8b 00                	mov    (%eax),%eax
  802b42:	a3 48 50 98 00       	mov    %eax,0x985048
  802b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5a:	a1 54 50 98 00       	mov    0x985054,%eax
  802b5f:	48                   	dec    %eax
  802b60:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b68:	e9 98 00 00 00       	jmp    802c05 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  802b6d:	83 ec 04             	sub    $0x4,%esp
  802b70:	6a 01                	push   $0x1
  802b72:	ff 75 f0             	pushl  -0x10(%ebp)
  802b75:	ff 75 f4             	pushl  -0xc(%ebp)
  802b78:	e8 d7 f7 ff ff       	call   802354 <set_block_data>
  802b7d:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802b80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b84:	75 17                	jne    802b9d <alloc_block_BF+0x228>
  802b86:	83 ec 04             	sub    $0x4,%esp
  802b89:	68 b4 3e 80 00       	push   $0x803eb4
  802b8e:	68 56 01 00 00       	push   $0x156
  802b93:	68 0b 3e 80 00       	push   $0x803e0b
  802b98:	e8 06 08 00 00       	call   8033a3 <_panic>
  802b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba0:	8b 00                	mov    (%eax),%eax
  802ba2:	85 c0                	test   %eax,%eax
  802ba4:	74 10                	je     802bb6 <alloc_block_BF+0x241>
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	8b 00                	mov    (%eax),%eax
  802bab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bae:	8b 52 04             	mov    0x4(%edx),%edx
  802bb1:	89 50 04             	mov    %edx,0x4(%eax)
  802bb4:	eb 0b                	jmp    802bc1 <alloc_block_BF+0x24c>
  802bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb9:	8b 40 04             	mov    0x4(%eax),%eax
  802bbc:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc4:	8b 40 04             	mov    0x4(%eax),%eax
  802bc7:	85 c0                	test   %eax,%eax
  802bc9:	74 0f                	je     802bda <alloc_block_BF+0x265>
  802bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bce:	8b 40 04             	mov    0x4(%eax),%eax
  802bd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd4:	8b 12                	mov    (%edx),%edx
  802bd6:	89 10                	mov    %edx,(%eax)
  802bd8:	eb 0a                	jmp    802be4 <alloc_block_BF+0x26f>
  802bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdd:	8b 00                	mov    (%eax),%eax
  802bdf:	a3 48 50 98 00       	mov    %eax,0x985048
  802be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf7:	a1 54 50 98 00       	mov    0x985054,%eax
  802bfc:	48                   	dec    %eax
  802bfd:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802c05:	c9                   	leave  
  802c06:	c3                   	ret    

00802c07 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802c07:	55                   	push   %ebp
  802c08:	89 e5                	mov    %esp,%ebp
  802c0a:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802c0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c11:	0f 84 6a 02 00 00    	je     802e81 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  802c17:	ff 75 08             	pushl  0x8(%ebp)
  802c1a:	e8 b9 f4 ff ff       	call   8020d8 <get_block_size>
  802c1f:	83 c4 04             	add    $0x4,%esp
  802c22:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  802c25:	8b 45 08             	mov    0x8(%ebp),%eax
  802c28:	83 e8 08             	sub    $0x8,%eax
  802c2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  802c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c31:	8b 00                	mov    (%eax),%eax
  802c33:	83 e0 fe             	and    $0xfffffffe,%eax
  802c36:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  802c39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3c:	f7 d8                	neg    %eax
  802c3e:	89 c2                	mov    %eax,%edx
  802c40:	8b 45 08             	mov    0x8(%ebp),%eax
  802c43:	01 d0                	add    %edx,%eax
  802c45:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802c48:	ff 75 e8             	pushl  -0x18(%ebp)
  802c4b:	e8 a1 f4 ff ff       	call   8020f1 <is_free_block>
  802c50:	83 c4 04             	add    $0x4,%esp
  802c53:	0f be c0             	movsbl %al,%eax
  802c56:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802c59:	8b 55 08             	mov    0x8(%ebp),%edx
  802c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5f:	01 d0                	add    %edx,%eax
  802c61:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802c64:	ff 75 e0             	pushl  -0x20(%ebp)
  802c67:	e8 85 f4 ff ff       	call   8020f1 <is_free_block>
  802c6c:	83 c4 04             	add    $0x4,%esp
  802c6f:	0f be c0             	movsbl %al,%eax
  802c72:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802c75:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802c79:	75 34                	jne    802caf <free_block+0xa8>
  802c7b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802c7f:	75 2e                	jne    802caf <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802c81:	ff 75 e8             	pushl  -0x18(%ebp)
  802c84:	e8 4f f4 ff ff       	call   8020d8 <get_block_size>
  802c89:	83 c4 04             	add    $0x4,%esp
  802c8c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802c8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c92:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c95:	01 d0                	add    %edx,%eax
  802c97:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802c9a:	6a 00                	push   $0x0
  802c9c:	ff 75 d4             	pushl  -0x2c(%ebp)
  802c9f:	ff 75 e8             	pushl  -0x18(%ebp)
  802ca2:	e8 ad f6 ff ff       	call   802354 <set_block_data>
  802ca7:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802caa:	e9 d3 01 00 00       	jmp    802e82 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802caf:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802cb3:	0f 85 c8 00 00 00    	jne    802d81 <free_block+0x17a>
  802cb9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802cbd:	0f 85 be 00 00 00    	jne    802d81 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802cc3:	ff 75 e0             	pushl  -0x20(%ebp)
  802cc6:	e8 0d f4 ff ff       	call   8020d8 <get_block_size>
  802ccb:	83 c4 04             	add    $0x4,%esp
  802cce:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802cd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802cd7:	01 d0                	add    %edx,%eax
  802cd9:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802cdc:	6a 00                	push   $0x0
  802cde:	ff 75 cc             	pushl  -0x34(%ebp)
  802ce1:	ff 75 08             	pushl  0x8(%ebp)
  802ce4:	e8 6b f6 ff ff       	call   802354 <set_block_data>
  802ce9:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802cec:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802cf0:	75 17                	jne    802d09 <free_block+0x102>
  802cf2:	83 ec 04             	sub    $0x4,%esp
  802cf5:	68 b4 3e 80 00       	push   $0x803eb4
  802cfa:	68 87 01 00 00       	push   $0x187
  802cff:	68 0b 3e 80 00       	push   $0x803e0b
  802d04:	e8 9a 06 00 00       	call   8033a3 <_panic>
  802d09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d0c:	8b 00                	mov    (%eax),%eax
  802d0e:	85 c0                	test   %eax,%eax
  802d10:	74 10                	je     802d22 <free_block+0x11b>
  802d12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d15:	8b 00                	mov    (%eax),%eax
  802d17:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d1a:	8b 52 04             	mov    0x4(%edx),%edx
  802d1d:	89 50 04             	mov    %edx,0x4(%eax)
  802d20:	eb 0b                	jmp    802d2d <free_block+0x126>
  802d22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d25:	8b 40 04             	mov    0x4(%eax),%eax
  802d28:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802d2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d30:	8b 40 04             	mov    0x4(%eax),%eax
  802d33:	85 c0                	test   %eax,%eax
  802d35:	74 0f                	je     802d46 <free_block+0x13f>
  802d37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d3a:	8b 40 04             	mov    0x4(%eax),%eax
  802d3d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d40:	8b 12                	mov    (%edx),%edx
  802d42:	89 10                	mov    %edx,(%eax)
  802d44:	eb 0a                	jmp    802d50 <free_block+0x149>
  802d46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d49:	8b 00                	mov    (%eax),%eax
  802d4b:	a3 48 50 98 00       	mov    %eax,0x985048
  802d50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d63:	a1 54 50 98 00       	mov    0x985054,%eax
  802d68:	48                   	dec    %eax
  802d69:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802d6e:	83 ec 0c             	sub    $0xc,%esp
  802d71:	ff 75 08             	pushl  0x8(%ebp)
  802d74:	e8 32 f6 ff ff       	call   8023ab <insert_sorted_in_freeList>
  802d79:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802d7c:	e9 01 01 00 00       	jmp    802e82 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  802d81:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802d85:	0f 85 d3 00 00 00    	jne    802e5e <free_block+0x257>
  802d8b:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802d8f:	0f 85 c9 00 00 00    	jne    802e5e <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  802d95:	83 ec 0c             	sub    $0xc,%esp
  802d98:	ff 75 e8             	pushl  -0x18(%ebp)
  802d9b:	e8 38 f3 ff ff       	call   8020d8 <get_block_size>
  802da0:	83 c4 10             	add    $0x10,%esp
  802da3:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  802da6:	83 ec 0c             	sub    $0xc,%esp
  802da9:	ff 75 e0             	pushl  -0x20(%ebp)
  802dac:	e8 27 f3 ff ff       	call   8020d8 <get_block_size>
  802db1:	83 c4 10             	add    $0x10,%esp
  802db4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  802db7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dba:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802dbd:	01 c2                	add    %eax,%edx
  802dbf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802dc2:	01 d0                	add    %edx,%eax
  802dc4:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  802dc7:	83 ec 04             	sub    $0x4,%esp
  802dca:	6a 00                	push   $0x0
  802dcc:	ff 75 c0             	pushl  -0x40(%ebp)
  802dcf:	ff 75 e8             	pushl  -0x18(%ebp)
  802dd2:	e8 7d f5 ff ff       	call   802354 <set_block_data>
  802dd7:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  802dda:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802dde:	75 17                	jne    802df7 <free_block+0x1f0>
  802de0:	83 ec 04             	sub    $0x4,%esp
  802de3:	68 b4 3e 80 00       	push   $0x803eb4
  802de8:	68 94 01 00 00       	push   $0x194
  802ded:	68 0b 3e 80 00       	push   $0x803e0b
  802df2:	e8 ac 05 00 00       	call   8033a3 <_panic>
  802df7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dfa:	8b 00                	mov    (%eax),%eax
  802dfc:	85 c0                	test   %eax,%eax
  802dfe:	74 10                	je     802e10 <free_block+0x209>
  802e00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e03:	8b 00                	mov    (%eax),%eax
  802e05:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e08:	8b 52 04             	mov    0x4(%edx),%edx
  802e0b:	89 50 04             	mov    %edx,0x4(%eax)
  802e0e:	eb 0b                	jmp    802e1b <free_block+0x214>
  802e10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e13:	8b 40 04             	mov    0x4(%eax),%eax
  802e16:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802e1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e1e:	8b 40 04             	mov    0x4(%eax),%eax
  802e21:	85 c0                	test   %eax,%eax
  802e23:	74 0f                	je     802e34 <free_block+0x22d>
  802e25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e28:	8b 40 04             	mov    0x4(%eax),%eax
  802e2b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e2e:	8b 12                	mov    (%edx),%edx
  802e30:	89 10                	mov    %edx,(%eax)
  802e32:	eb 0a                	jmp    802e3e <free_block+0x237>
  802e34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e37:	8b 00                	mov    (%eax),%eax
  802e39:	a3 48 50 98 00       	mov    %eax,0x985048
  802e3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e51:	a1 54 50 98 00       	mov    0x985054,%eax
  802e56:	48                   	dec    %eax
  802e57:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  802e5c:	eb 24                	jmp    802e82 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  802e5e:	83 ec 04             	sub    $0x4,%esp
  802e61:	6a 00                	push   $0x0
  802e63:	ff 75 f4             	pushl  -0xc(%ebp)
  802e66:	ff 75 08             	pushl  0x8(%ebp)
  802e69:	e8 e6 f4 ff ff       	call   802354 <set_block_data>
  802e6e:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802e71:	83 ec 0c             	sub    $0xc,%esp
  802e74:	ff 75 08             	pushl  0x8(%ebp)
  802e77:	e8 2f f5 ff ff       	call   8023ab <insert_sorted_in_freeList>
  802e7c:	83 c4 10             	add    $0x10,%esp
  802e7f:	eb 01                	jmp    802e82 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  802e81:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  802e82:	c9                   	leave  
  802e83:	c3                   	ret    

00802e84 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802e84:	55                   	push   %ebp
  802e85:	89 e5                	mov    %esp,%ebp
  802e87:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  802e8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e8e:	75 10                	jne    802ea0 <realloc_block_FF+0x1c>
  802e90:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e94:	75 0a                	jne    802ea0 <realloc_block_FF+0x1c>
	{
		return NULL;
  802e96:	b8 00 00 00 00       	mov    $0x0,%eax
  802e9b:	e9 8b 04 00 00       	jmp    80332b <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  802ea0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ea4:	75 18                	jne    802ebe <realloc_block_FF+0x3a>
	{
		free_block(va);
  802ea6:	83 ec 0c             	sub    $0xc,%esp
  802ea9:	ff 75 08             	pushl  0x8(%ebp)
  802eac:	e8 56 fd ff ff       	call   802c07 <free_block>
  802eb1:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802eb4:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb9:	e9 6d 04 00 00       	jmp    80332b <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  802ebe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec2:	75 13                	jne    802ed7 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  802ec4:	83 ec 0c             	sub    $0xc,%esp
  802ec7:	ff 75 0c             	pushl  0xc(%ebp)
  802eca:	e8 6f f6 ff ff       	call   80253e <alloc_block_FF>
  802ecf:	83 c4 10             	add    $0x10,%esp
  802ed2:	e9 54 04 00 00       	jmp    80332b <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  802ed7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eda:	83 e0 01             	and    $0x1,%eax
  802edd:	85 c0                	test   %eax,%eax
  802edf:	74 03                	je     802ee4 <realloc_block_FF+0x60>
	{
		new_size++;
  802ee1:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  802ee4:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802ee8:	77 07                	ja     802ef1 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  802eea:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  802ef1:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  802ef5:	83 ec 0c             	sub    $0xc,%esp
  802ef8:	ff 75 08             	pushl  0x8(%ebp)
  802efb:	e8 d8 f1 ff ff       	call   8020d8 <get_block_size>
  802f00:	83 c4 10             	add    $0x10,%esp
  802f03:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  802f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f09:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f0c:	75 08                	jne    802f16 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  802f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f11:	e9 15 04 00 00       	jmp    80332b <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  802f16:	8b 55 08             	mov    0x8(%ebp),%edx
  802f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1c:	01 d0                	add    %edx,%eax
  802f1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802f21:	83 ec 0c             	sub    $0xc,%esp
  802f24:	ff 75 f0             	pushl  -0x10(%ebp)
  802f27:	e8 c5 f1 ff ff       	call   8020f1 <is_free_block>
  802f2c:	83 c4 10             	add    $0x10,%esp
  802f2f:	0f be c0             	movsbl %al,%eax
  802f32:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  802f35:	83 ec 0c             	sub    $0xc,%esp
  802f38:	ff 75 f0             	pushl  -0x10(%ebp)
  802f3b:	e8 98 f1 ff ff       	call   8020d8 <get_block_size>
  802f40:	83 c4 10             	add    $0x10,%esp
  802f43:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  802f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f49:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802f4c:	0f 86 a7 02 00 00    	jbe    8031f9 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  802f52:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f56:	0f 84 86 02 00 00    	je     8031e2 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  802f5c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f62:	01 d0                	add    %edx,%eax
  802f64:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f67:	0f 85 b2 00 00 00    	jne    80301f <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  802f6d:	83 ec 0c             	sub    $0xc,%esp
  802f70:	ff 75 08             	pushl  0x8(%ebp)
  802f73:	e8 79 f1 ff ff       	call   8020f1 <is_free_block>
  802f78:	83 c4 10             	add    $0x10,%esp
  802f7b:	84 c0                	test   %al,%al
  802f7d:	0f 94 c0             	sete   %al
  802f80:	0f b6 c0             	movzbl %al,%eax
  802f83:	83 ec 04             	sub    $0x4,%esp
  802f86:	50                   	push   %eax
  802f87:	ff 75 0c             	pushl  0xc(%ebp)
  802f8a:	ff 75 08             	pushl  0x8(%ebp)
  802f8d:	e8 c2 f3 ff ff       	call   802354 <set_block_data>
  802f92:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  802f95:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f99:	75 17                	jne    802fb2 <realloc_block_FF+0x12e>
  802f9b:	83 ec 04             	sub    $0x4,%esp
  802f9e:	68 b4 3e 80 00       	push   $0x803eb4
  802fa3:	68 db 01 00 00       	push   $0x1db
  802fa8:	68 0b 3e 80 00       	push   $0x803e0b
  802fad:	e8 f1 03 00 00       	call   8033a3 <_panic>
  802fb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb5:	8b 00                	mov    (%eax),%eax
  802fb7:	85 c0                	test   %eax,%eax
  802fb9:	74 10                	je     802fcb <realloc_block_FF+0x147>
  802fbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbe:	8b 00                	mov    (%eax),%eax
  802fc0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fc3:	8b 52 04             	mov    0x4(%edx),%edx
  802fc6:	89 50 04             	mov    %edx,0x4(%eax)
  802fc9:	eb 0b                	jmp    802fd6 <realloc_block_FF+0x152>
  802fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fce:	8b 40 04             	mov    0x4(%eax),%eax
  802fd1:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802fd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd9:	8b 40 04             	mov    0x4(%eax),%eax
  802fdc:	85 c0                	test   %eax,%eax
  802fde:	74 0f                	je     802fef <realloc_block_FF+0x16b>
  802fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe3:	8b 40 04             	mov    0x4(%eax),%eax
  802fe6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fe9:	8b 12                	mov    (%edx),%edx
  802feb:	89 10                	mov    %edx,(%eax)
  802fed:	eb 0a                	jmp    802ff9 <realloc_block_FF+0x175>
  802fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff2:	8b 00                	mov    (%eax),%eax
  802ff4:	a3 48 50 98 00       	mov    %eax,0x985048
  802ff9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803002:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803005:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80300c:	a1 54 50 98 00       	mov    0x985054,%eax
  803011:	48                   	dec    %eax
  803012:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  803017:	8b 45 08             	mov    0x8(%ebp),%eax
  80301a:	e9 0c 03 00 00       	jmp    80332b <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  80301f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803025:	01 d0                	add    %edx,%eax
  803027:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80302a:	0f 86 b2 01 00 00    	jbe    8031e2 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  803030:	8b 45 0c             	mov    0xc(%ebp),%eax
  803033:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803036:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  803039:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80303f:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  803042:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  803046:	0f 87 b8 00 00 00    	ja     803104 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  80304c:	83 ec 0c             	sub    $0xc,%esp
  80304f:	ff 75 08             	pushl  0x8(%ebp)
  803052:	e8 9a f0 ff ff       	call   8020f1 <is_free_block>
  803057:	83 c4 10             	add    $0x10,%esp
  80305a:	84 c0                	test   %al,%al
  80305c:	0f 94 c0             	sete   %al
  80305f:	0f b6 c0             	movzbl %al,%eax
  803062:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803065:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803068:	01 ca                	add    %ecx,%edx
  80306a:	83 ec 04             	sub    $0x4,%esp
  80306d:	50                   	push   %eax
  80306e:	52                   	push   %edx
  80306f:	ff 75 08             	pushl  0x8(%ebp)
  803072:	e8 dd f2 ff ff       	call   802354 <set_block_data>
  803077:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  80307a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80307e:	75 17                	jne    803097 <realloc_block_FF+0x213>
  803080:	83 ec 04             	sub    $0x4,%esp
  803083:	68 b4 3e 80 00       	push   $0x803eb4
  803088:	68 e8 01 00 00       	push   $0x1e8
  80308d:	68 0b 3e 80 00       	push   $0x803e0b
  803092:	e8 0c 03 00 00       	call   8033a3 <_panic>
  803097:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309a:	8b 00                	mov    (%eax),%eax
  80309c:	85 c0                	test   %eax,%eax
  80309e:	74 10                	je     8030b0 <realloc_block_FF+0x22c>
  8030a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a3:	8b 00                	mov    (%eax),%eax
  8030a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030a8:	8b 52 04             	mov    0x4(%edx),%edx
  8030ab:	89 50 04             	mov    %edx,0x4(%eax)
  8030ae:	eb 0b                	jmp    8030bb <realloc_block_FF+0x237>
  8030b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b3:	8b 40 04             	mov    0x4(%eax),%eax
  8030b6:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8030bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030be:	8b 40 04             	mov    0x4(%eax),%eax
  8030c1:	85 c0                	test   %eax,%eax
  8030c3:	74 0f                	je     8030d4 <realloc_block_FF+0x250>
  8030c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c8:	8b 40 04             	mov    0x4(%eax),%eax
  8030cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030ce:	8b 12                	mov    (%edx),%edx
  8030d0:	89 10                	mov    %edx,(%eax)
  8030d2:	eb 0a                	jmp    8030de <realloc_block_FF+0x25a>
  8030d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d7:	8b 00                	mov    (%eax),%eax
  8030d9:	a3 48 50 98 00       	mov    %eax,0x985048
  8030de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f1:	a1 54 50 98 00       	mov    0x985054,%eax
  8030f6:	48                   	dec    %eax
  8030f7:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  8030fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ff:	e9 27 02 00 00       	jmp    80332b <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803104:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803108:	75 17                	jne    803121 <realloc_block_FF+0x29d>
  80310a:	83 ec 04             	sub    $0x4,%esp
  80310d:	68 b4 3e 80 00       	push   $0x803eb4
  803112:	68 ed 01 00 00       	push   $0x1ed
  803117:	68 0b 3e 80 00       	push   $0x803e0b
  80311c:	e8 82 02 00 00       	call   8033a3 <_panic>
  803121:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803124:	8b 00                	mov    (%eax),%eax
  803126:	85 c0                	test   %eax,%eax
  803128:	74 10                	je     80313a <realloc_block_FF+0x2b6>
  80312a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312d:	8b 00                	mov    (%eax),%eax
  80312f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803132:	8b 52 04             	mov    0x4(%edx),%edx
  803135:	89 50 04             	mov    %edx,0x4(%eax)
  803138:	eb 0b                	jmp    803145 <realloc_block_FF+0x2c1>
  80313a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313d:	8b 40 04             	mov    0x4(%eax),%eax
  803140:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803145:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803148:	8b 40 04             	mov    0x4(%eax),%eax
  80314b:	85 c0                	test   %eax,%eax
  80314d:	74 0f                	je     80315e <realloc_block_FF+0x2da>
  80314f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803152:	8b 40 04             	mov    0x4(%eax),%eax
  803155:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803158:	8b 12                	mov    (%edx),%edx
  80315a:	89 10                	mov    %edx,(%eax)
  80315c:	eb 0a                	jmp    803168 <realloc_block_FF+0x2e4>
  80315e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803161:	8b 00                	mov    (%eax),%eax
  803163:	a3 48 50 98 00       	mov    %eax,0x985048
  803168:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803174:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80317b:	a1 54 50 98 00       	mov    0x985054,%eax
  803180:	48                   	dec    %eax
  803181:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  803186:	8b 55 08             	mov    0x8(%ebp),%edx
  803189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80318c:	01 d0                	add    %edx,%eax
  80318e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  803191:	83 ec 04             	sub    $0x4,%esp
  803194:	6a 00                	push   $0x0
  803196:	ff 75 e0             	pushl  -0x20(%ebp)
  803199:	ff 75 f0             	pushl  -0x10(%ebp)
  80319c:	e8 b3 f1 ff ff       	call   802354 <set_block_data>
  8031a1:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  8031a4:	83 ec 0c             	sub    $0xc,%esp
  8031a7:	ff 75 08             	pushl  0x8(%ebp)
  8031aa:	e8 42 ef ff ff       	call   8020f1 <is_free_block>
  8031af:	83 c4 10             	add    $0x10,%esp
  8031b2:	84 c0                	test   %al,%al
  8031b4:	0f 94 c0             	sete   %al
  8031b7:	0f b6 c0             	movzbl %al,%eax
  8031ba:	83 ec 04             	sub    $0x4,%esp
  8031bd:	50                   	push   %eax
  8031be:	ff 75 0c             	pushl  0xc(%ebp)
  8031c1:	ff 75 08             	pushl  0x8(%ebp)
  8031c4:	e8 8b f1 ff ff       	call   802354 <set_block_data>
  8031c9:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  8031cc:	83 ec 0c             	sub    $0xc,%esp
  8031cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8031d2:	e8 d4 f1 ff ff       	call   8023ab <insert_sorted_in_freeList>
  8031d7:	83 c4 10             	add    $0x10,%esp
					return va;
  8031da:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dd:	e9 49 01 00 00       	jmp    80332b <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  8031e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031e5:	83 e8 08             	sub    $0x8,%eax
  8031e8:	83 ec 0c             	sub    $0xc,%esp
  8031eb:	50                   	push   %eax
  8031ec:	e8 4d f3 ff ff       	call   80253e <alloc_block_FF>
  8031f1:	83 c4 10             	add    $0x10,%esp
  8031f4:	e9 32 01 00 00       	jmp    80332b <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  8031f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8031ff:	0f 83 21 01 00 00    	jae    803326 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  803205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803208:	2b 45 0c             	sub    0xc(%ebp),%eax
  80320b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  80320e:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  803212:	77 0e                	ja     803222 <realloc_block_FF+0x39e>
  803214:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803218:	75 08                	jne    803222 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  80321a:	8b 45 08             	mov    0x8(%ebp),%eax
  80321d:	e9 09 01 00 00       	jmp    80332b <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  803222:	8b 45 08             	mov    0x8(%ebp),%eax
  803225:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  803228:	83 ec 0c             	sub    $0xc,%esp
  80322b:	ff 75 08             	pushl  0x8(%ebp)
  80322e:	e8 be ee ff ff       	call   8020f1 <is_free_block>
  803233:	83 c4 10             	add    $0x10,%esp
  803236:	84 c0                	test   %al,%al
  803238:	0f 94 c0             	sete   %al
  80323b:	0f b6 c0             	movzbl %al,%eax
  80323e:	83 ec 04             	sub    $0x4,%esp
  803241:	50                   	push   %eax
  803242:	ff 75 0c             	pushl  0xc(%ebp)
  803245:	ff 75 d8             	pushl  -0x28(%ebp)
  803248:	e8 07 f1 ff ff       	call   802354 <set_block_data>
  80324d:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  803250:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803253:	8b 45 0c             	mov    0xc(%ebp),%eax
  803256:	01 d0                	add    %edx,%eax
  803258:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  80325b:	83 ec 04             	sub    $0x4,%esp
  80325e:	6a 00                	push   $0x0
  803260:	ff 75 dc             	pushl  -0x24(%ebp)
  803263:	ff 75 d4             	pushl  -0x2c(%ebp)
  803266:	e8 e9 f0 ff ff       	call   802354 <set_block_data>
  80326b:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  80326e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803272:	0f 84 9b 00 00 00    	je     803313 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  803278:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80327b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327e:	01 d0                	add    %edx,%eax
  803280:	83 ec 04             	sub    $0x4,%esp
  803283:	6a 00                	push   $0x0
  803285:	50                   	push   %eax
  803286:	ff 75 d4             	pushl  -0x2c(%ebp)
  803289:	e8 c6 f0 ff ff       	call   802354 <set_block_data>
  80328e:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  803291:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803295:	75 17                	jne    8032ae <realloc_block_FF+0x42a>
  803297:	83 ec 04             	sub    $0x4,%esp
  80329a:	68 b4 3e 80 00       	push   $0x803eb4
  80329f:	68 10 02 00 00       	push   $0x210
  8032a4:	68 0b 3e 80 00       	push   $0x803e0b
  8032a9:	e8 f5 00 00 00       	call   8033a3 <_panic>
  8032ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b1:	8b 00                	mov    (%eax),%eax
  8032b3:	85 c0                	test   %eax,%eax
  8032b5:	74 10                	je     8032c7 <realloc_block_FF+0x443>
  8032b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ba:	8b 00                	mov    (%eax),%eax
  8032bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032bf:	8b 52 04             	mov    0x4(%edx),%edx
  8032c2:	89 50 04             	mov    %edx,0x4(%eax)
  8032c5:	eb 0b                	jmp    8032d2 <realloc_block_FF+0x44e>
  8032c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ca:	8b 40 04             	mov    0x4(%eax),%eax
  8032cd:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8032d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d5:	8b 40 04             	mov    0x4(%eax),%eax
  8032d8:	85 c0                	test   %eax,%eax
  8032da:	74 0f                	je     8032eb <realloc_block_FF+0x467>
  8032dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032df:	8b 40 04             	mov    0x4(%eax),%eax
  8032e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032e5:	8b 12                	mov    (%edx),%edx
  8032e7:	89 10                	mov    %edx,(%eax)
  8032e9:	eb 0a                	jmp    8032f5 <realloc_block_FF+0x471>
  8032eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ee:	8b 00                	mov    (%eax),%eax
  8032f0:	a3 48 50 98 00       	mov    %eax,0x985048
  8032f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803301:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803308:	a1 54 50 98 00       	mov    0x985054,%eax
  80330d:	48                   	dec    %eax
  80330e:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  803313:	83 ec 0c             	sub    $0xc,%esp
  803316:	ff 75 d4             	pushl  -0x2c(%ebp)
  803319:	e8 8d f0 ff ff       	call   8023ab <insert_sorted_in_freeList>
  80331e:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  803321:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803324:	eb 05                	jmp    80332b <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  803326:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80332b:	c9                   	leave  
  80332c:	c3                   	ret    

0080332d <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80332d:	55                   	push   %ebp
  80332e:	89 e5                	mov    %esp,%ebp
  803330:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803333:	83 ec 04             	sub    $0x4,%esp
  803336:	68 d4 3e 80 00       	push   $0x803ed4
  80333b:	68 20 02 00 00       	push   $0x220
  803340:	68 0b 3e 80 00       	push   $0x803e0b
  803345:	e8 59 00 00 00       	call   8033a3 <_panic>

0080334a <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80334a:	55                   	push   %ebp
  80334b:	89 e5                	mov    %esp,%ebp
  80334d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803350:	83 ec 04             	sub    $0x4,%esp
  803353:	68 fc 3e 80 00       	push   $0x803efc
  803358:	68 28 02 00 00       	push   $0x228
  80335d:	68 0b 3e 80 00       	push   $0x803e0b
  803362:	e8 3c 00 00 00       	call   8033a3 <_panic>

00803367 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  803367:	55                   	push   %ebp
  803368:	89 e5                	mov    %esp,%ebp
  80336a:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80336d:	8b 45 08             	mov    0x8(%ebp),%eax
  803370:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  803373:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  803377:	83 ec 0c             	sub    $0xc,%esp
  80337a:	50                   	push   %eax
  80337b:	e8 73 e8 ff ff       	call   801bf3 <sys_cputc>
  803380:	83 c4 10             	add    $0x10,%esp
}
  803383:	90                   	nop
  803384:	c9                   	leave  
  803385:	c3                   	ret    

00803386 <getchar>:


int
getchar(void)
{
  803386:	55                   	push   %ebp
  803387:	89 e5                	mov    %esp,%ebp
  803389:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  80338c:	e8 fe e6 ff ff       	call   801a8f <sys_cgetc>
  803391:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  803394:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  803397:	c9                   	leave  
  803398:	c3                   	ret    

00803399 <iscons>:

int iscons(int fdnum)
{
  803399:	55                   	push   %ebp
  80339a:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80339c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8033a1:	5d                   	pop    %ebp
  8033a2:	c3                   	ret    

008033a3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8033a3:	55                   	push   %ebp
  8033a4:	89 e5                	mov    %esp,%ebp
  8033a6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8033a9:	8d 45 10             	lea    0x10(%ebp),%eax
  8033ac:	83 c0 04             	add    $0x4,%eax
  8033af:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8033b2:	a1 60 50 98 00       	mov    0x985060,%eax
  8033b7:	85 c0                	test   %eax,%eax
  8033b9:	74 16                	je     8033d1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8033bb:	a1 60 50 98 00       	mov    0x985060,%eax
  8033c0:	83 ec 08             	sub    $0x8,%esp
  8033c3:	50                   	push   %eax
  8033c4:	68 24 3f 80 00       	push   $0x803f24
  8033c9:	e8 00 d0 ff ff       	call   8003ce <cprintf>
  8033ce:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8033d1:	a1 04 50 80 00       	mov    0x805004,%eax
  8033d6:	ff 75 0c             	pushl  0xc(%ebp)
  8033d9:	ff 75 08             	pushl  0x8(%ebp)
  8033dc:	50                   	push   %eax
  8033dd:	68 29 3f 80 00       	push   $0x803f29
  8033e2:	e8 e7 cf ff ff       	call   8003ce <cprintf>
  8033e7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8033ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8033ed:	83 ec 08             	sub    $0x8,%esp
  8033f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8033f3:	50                   	push   %eax
  8033f4:	e8 6a cf ff ff       	call   800363 <vcprintf>
  8033f9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8033fc:	83 ec 08             	sub    $0x8,%esp
  8033ff:	6a 00                	push   $0x0
  803401:	68 45 3f 80 00       	push   $0x803f45
  803406:	e8 58 cf ff ff       	call   800363 <vcprintf>
  80340b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80340e:	e8 d9 ce ff ff       	call   8002ec <exit>

	// should not return here
	while (1) ;
  803413:	eb fe                	jmp    803413 <_panic+0x70>

00803415 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803415:	55                   	push   %ebp
  803416:	89 e5                	mov    %esp,%ebp
  803418:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80341b:	a1 20 50 80 00       	mov    0x805020,%eax
  803420:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803426:	8b 45 0c             	mov    0xc(%ebp),%eax
  803429:	39 c2                	cmp    %eax,%edx
  80342b:	74 14                	je     803441 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80342d:	83 ec 04             	sub    $0x4,%esp
  803430:	68 48 3f 80 00       	push   $0x803f48
  803435:	6a 26                	push   $0x26
  803437:	68 94 3f 80 00       	push   $0x803f94
  80343c:	e8 62 ff ff ff       	call   8033a3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803441:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803448:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80344f:	e9 c5 00 00 00       	jmp    803519 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803454:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803457:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80345e:	8b 45 08             	mov    0x8(%ebp),%eax
  803461:	01 d0                	add    %edx,%eax
  803463:	8b 00                	mov    (%eax),%eax
  803465:	85 c0                	test   %eax,%eax
  803467:	75 08                	jne    803471 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803469:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80346c:	e9 a5 00 00 00       	jmp    803516 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803471:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803478:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80347f:	eb 69                	jmp    8034ea <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803481:	a1 20 50 80 00       	mov    0x805020,%eax
  803486:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80348c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80348f:	89 d0                	mov    %edx,%eax
  803491:	01 c0                	add    %eax,%eax
  803493:	01 d0                	add    %edx,%eax
  803495:	c1 e0 03             	shl    $0x3,%eax
  803498:	01 c8                	add    %ecx,%eax
  80349a:	8a 40 04             	mov    0x4(%eax),%al
  80349d:	84 c0                	test   %al,%al
  80349f:	75 46                	jne    8034e7 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8034a1:	a1 20 50 80 00       	mov    0x805020,%eax
  8034a6:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8034ac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034af:	89 d0                	mov    %edx,%eax
  8034b1:	01 c0                	add    %eax,%eax
  8034b3:	01 d0                	add    %edx,%eax
  8034b5:	c1 e0 03             	shl    $0x3,%eax
  8034b8:	01 c8                	add    %ecx,%eax
  8034ba:	8b 00                	mov    (%eax),%eax
  8034bc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8034bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8034c7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8034c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034cc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8034d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d6:	01 c8                	add    %ecx,%eax
  8034d8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8034da:	39 c2                	cmp    %eax,%edx
  8034dc:	75 09                	jne    8034e7 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8034de:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8034e5:	eb 15                	jmp    8034fc <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8034e7:	ff 45 e8             	incl   -0x18(%ebp)
  8034ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8034ef:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8034f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f8:	39 c2                	cmp    %eax,%edx
  8034fa:	77 85                	ja     803481 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8034fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803500:	75 14                	jne    803516 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803502:	83 ec 04             	sub    $0x4,%esp
  803505:	68 a0 3f 80 00       	push   $0x803fa0
  80350a:	6a 3a                	push   $0x3a
  80350c:	68 94 3f 80 00       	push   $0x803f94
  803511:	e8 8d fe ff ff       	call   8033a3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803516:	ff 45 f0             	incl   -0x10(%ebp)
  803519:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80351c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80351f:	0f 8c 2f ff ff ff    	jl     803454 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803525:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80352c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803533:	eb 26                	jmp    80355b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803535:	a1 20 50 80 00       	mov    0x805020,%eax
  80353a:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  803540:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803543:	89 d0                	mov    %edx,%eax
  803545:	01 c0                	add    %eax,%eax
  803547:	01 d0                	add    %edx,%eax
  803549:	c1 e0 03             	shl    $0x3,%eax
  80354c:	01 c8                	add    %ecx,%eax
  80354e:	8a 40 04             	mov    0x4(%eax),%al
  803551:	3c 01                	cmp    $0x1,%al
  803553:	75 03                	jne    803558 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803555:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803558:	ff 45 e0             	incl   -0x20(%ebp)
  80355b:	a1 20 50 80 00       	mov    0x805020,%eax
  803560:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803566:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803569:	39 c2                	cmp    %eax,%edx
  80356b:	77 c8                	ja     803535 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80356d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803570:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803573:	74 14                	je     803589 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803575:	83 ec 04             	sub    $0x4,%esp
  803578:	68 f4 3f 80 00       	push   $0x803ff4
  80357d:	6a 44                	push   $0x44
  80357f:	68 94 3f 80 00       	push   $0x803f94
  803584:	e8 1a fe ff ff       	call   8033a3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803589:	90                   	nop
  80358a:	c9                   	leave  
  80358b:	c3                   	ret    

0080358c <__udivdi3>:
  80358c:	55                   	push   %ebp
  80358d:	57                   	push   %edi
  80358e:	56                   	push   %esi
  80358f:	53                   	push   %ebx
  803590:	83 ec 1c             	sub    $0x1c,%esp
  803593:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803597:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80359b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80359f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035a3:	89 ca                	mov    %ecx,%edx
  8035a5:	89 f8                	mov    %edi,%eax
  8035a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8035ab:	85 f6                	test   %esi,%esi
  8035ad:	75 2d                	jne    8035dc <__udivdi3+0x50>
  8035af:	39 cf                	cmp    %ecx,%edi
  8035b1:	77 65                	ja     803618 <__udivdi3+0x8c>
  8035b3:	89 fd                	mov    %edi,%ebp
  8035b5:	85 ff                	test   %edi,%edi
  8035b7:	75 0b                	jne    8035c4 <__udivdi3+0x38>
  8035b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8035be:	31 d2                	xor    %edx,%edx
  8035c0:	f7 f7                	div    %edi
  8035c2:	89 c5                	mov    %eax,%ebp
  8035c4:	31 d2                	xor    %edx,%edx
  8035c6:	89 c8                	mov    %ecx,%eax
  8035c8:	f7 f5                	div    %ebp
  8035ca:	89 c1                	mov    %eax,%ecx
  8035cc:	89 d8                	mov    %ebx,%eax
  8035ce:	f7 f5                	div    %ebp
  8035d0:	89 cf                	mov    %ecx,%edi
  8035d2:	89 fa                	mov    %edi,%edx
  8035d4:	83 c4 1c             	add    $0x1c,%esp
  8035d7:	5b                   	pop    %ebx
  8035d8:	5e                   	pop    %esi
  8035d9:	5f                   	pop    %edi
  8035da:	5d                   	pop    %ebp
  8035db:	c3                   	ret    
  8035dc:	39 ce                	cmp    %ecx,%esi
  8035de:	77 28                	ja     803608 <__udivdi3+0x7c>
  8035e0:	0f bd fe             	bsr    %esi,%edi
  8035e3:	83 f7 1f             	xor    $0x1f,%edi
  8035e6:	75 40                	jne    803628 <__udivdi3+0x9c>
  8035e8:	39 ce                	cmp    %ecx,%esi
  8035ea:	72 0a                	jb     8035f6 <__udivdi3+0x6a>
  8035ec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035f0:	0f 87 9e 00 00 00    	ja     803694 <__udivdi3+0x108>
  8035f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8035fb:	89 fa                	mov    %edi,%edx
  8035fd:	83 c4 1c             	add    $0x1c,%esp
  803600:	5b                   	pop    %ebx
  803601:	5e                   	pop    %esi
  803602:	5f                   	pop    %edi
  803603:	5d                   	pop    %ebp
  803604:	c3                   	ret    
  803605:	8d 76 00             	lea    0x0(%esi),%esi
  803608:	31 ff                	xor    %edi,%edi
  80360a:	31 c0                	xor    %eax,%eax
  80360c:	89 fa                	mov    %edi,%edx
  80360e:	83 c4 1c             	add    $0x1c,%esp
  803611:	5b                   	pop    %ebx
  803612:	5e                   	pop    %esi
  803613:	5f                   	pop    %edi
  803614:	5d                   	pop    %ebp
  803615:	c3                   	ret    
  803616:	66 90                	xchg   %ax,%ax
  803618:	89 d8                	mov    %ebx,%eax
  80361a:	f7 f7                	div    %edi
  80361c:	31 ff                	xor    %edi,%edi
  80361e:	89 fa                	mov    %edi,%edx
  803620:	83 c4 1c             	add    $0x1c,%esp
  803623:	5b                   	pop    %ebx
  803624:	5e                   	pop    %esi
  803625:	5f                   	pop    %edi
  803626:	5d                   	pop    %ebp
  803627:	c3                   	ret    
  803628:	bd 20 00 00 00       	mov    $0x20,%ebp
  80362d:	89 eb                	mov    %ebp,%ebx
  80362f:	29 fb                	sub    %edi,%ebx
  803631:	89 f9                	mov    %edi,%ecx
  803633:	d3 e6                	shl    %cl,%esi
  803635:	89 c5                	mov    %eax,%ebp
  803637:	88 d9                	mov    %bl,%cl
  803639:	d3 ed                	shr    %cl,%ebp
  80363b:	89 e9                	mov    %ebp,%ecx
  80363d:	09 f1                	or     %esi,%ecx
  80363f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803643:	89 f9                	mov    %edi,%ecx
  803645:	d3 e0                	shl    %cl,%eax
  803647:	89 c5                	mov    %eax,%ebp
  803649:	89 d6                	mov    %edx,%esi
  80364b:	88 d9                	mov    %bl,%cl
  80364d:	d3 ee                	shr    %cl,%esi
  80364f:	89 f9                	mov    %edi,%ecx
  803651:	d3 e2                	shl    %cl,%edx
  803653:	8b 44 24 08          	mov    0x8(%esp),%eax
  803657:	88 d9                	mov    %bl,%cl
  803659:	d3 e8                	shr    %cl,%eax
  80365b:	09 c2                	or     %eax,%edx
  80365d:	89 d0                	mov    %edx,%eax
  80365f:	89 f2                	mov    %esi,%edx
  803661:	f7 74 24 0c          	divl   0xc(%esp)
  803665:	89 d6                	mov    %edx,%esi
  803667:	89 c3                	mov    %eax,%ebx
  803669:	f7 e5                	mul    %ebp
  80366b:	39 d6                	cmp    %edx,%esi
  80366d:	72 19                	jb     803688 <__udivdi3+0xfc>
  80366f:	74 0b                	je     80367c <__udivdi3+0xf0>
  803671:	89 d8                	mov    %ebx,%eax
  803673:	31 ff                	xor    %edi,%edi
  803675:	e9 58 ff ff ff       	jmp    8035d2 <__udivdi3+0x46>
  80367a:	66 90                	xchg   %ax,%ax
  80367c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803680:	89 f9                	mov    %edi,%ecx
  803682:	d3 e2                	shl    %cl,%edx
  803684:	39 c2                	cmp    %eax,%edx
  803686:	73 e9                	jae    803671 <__udivdi3+0xe5>
  803688:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80368b:	31 ff                	xor    %edi,%edi
  80368d:	e9 40 ff ff ff       	jmp    8035d2 <__udivdi3+0x46>
  803692:	66 90                	xchg   %ax,%ax
  803694:	31 c0                	xor    %eax,%eax
  803696:	e9 37 ff ff ff       	jmp    8035d2 <__udivdi3+0x46>
  80369b:	90                   	nop

0080369c <__umoddi3>:
  80369c:	55                   	push   %ebp
  80369d:	57                   	push   %edi
  80369e:	56                   	push   %esi
  80369f:	53                   	push   %ebx
  8036a0:	83 ec 1c             	sub    $0x1c,%esp
  8036a3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8036a7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8036ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036af:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8036b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036bb:	89 f3                	mov    %esi,%ebx
  8036bd:	89 fa                	mov    %edi,%edx
  8036bf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036c3:	89 34 24             	mov    %esi,(%esp)
  8036c6:	85 c0                	test   %eax,%eax
  8036c8:	75 1a                	jne    8036e4 <__umoddi3+0x48>
  8036ca:	39 f7                	cmp    %esi,%edi
  8036cc:	0f 86 a2 00 00 00    	jbe    803774 <__umoddi3+0xd8>
  8036d2:	89 c8                	mov    %ecx,%eax
  8036d4:	89 f2                	mov    %esi,%edx
  8036d6:	f7 f7                	div    %edi
  8036d8:	89 d0                	mov    %edx,%eax
  8036da:	31 d2                	xor    %edx,%edx
  8036dc:	83 c4 1c             	add    $0x1c,%esp
  8036df:	5b                   	pop    %ebx
  8036e0:	5e                   	pop    %esi
  8036e1:	5f                   	pop    %edi
  8036e2:	5d                   	pop    %ebp
  8036e3:	c3                   	ret    
  8036e4:	39 f0                	cmp    %esi,%eax
  8036e6:	0f 87 ac 00 00 00    	ja     803798 <__umoddi3+0xfc>
  8036ec:	0f bd e8             	bsr    %eax,%ebp
  8036ef:	83 f5 1f             	xor    $0x1f,%ebp
  8036f2:	0f 84 ac 00 00 00    	je     8037a4 <__umoddi3+0x108>
  8036f8:	bf 20 00 00 00       	mov    $0x20,%edi
  8036fd:	29 ef                	sub    %ebp,%edi
  8036ff:	89 fe                	mov    %edi,%esi
  803701:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803705:	89 e9                	mov    %ebp,%ecx
  803707:	d3 e0                	shl    %cl,%eax
  803709:	89 d7                	mov    %edx,%edi
  80370b:	89 f1                	mov    %esi,%ecx
  80370d:	d3 ef                	shr    %cl,%edi
  80370f:	09 c7                	or     %eax,%edi
  803711:	89 e9                	mov    %ebp,%ecx
  803713:	d3 e2                	shl    %cl,%edx
  803715:	89 14 24             	mov    %edx,(%esp)
  803718:	89 d8                	mov    %ebx,%eax
  80371a:	d3 e0                	shl    %cl,%eax
  80371c:	89 c2                	mov    %eax,%edx
  80371e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803722:	d3 e0                	shl    %cl,%eax
  803724:	89 44 24 04          	mov    %eax,0x4(%esp)
  803728:	8b 44 24 08          	mov    0x8(%esp),%eax
  80372c:	89 f1                	mov    %esi,%ecx
  80372e:	d3 e8                	shr    %cl,%eax
  803730:	09 d0                	or     %edx,%eax
  803732:	d3 eb                	shr    %cl,%ebx
  803734:	89 da                	mov    %ebx,%edx
  803736:	f7 f7                	div    %edi
  803738:	89 d3                	mov    %edx,%ebx
  80373a:	f7 24 24             	mull   (%esp)
  80373d:	89 c6                	mov    %eax,%esi
  80373f:	89 d1                	mov    %edx,%ecx
  803741:	39 d3                	cmp    %edx,%ebx
  803743:	0f 82 87 00 00 00    	jb     8037d0 <__umoddi3+0x134>
  803749:	0f 84 91 00 00 00    	je     8037e0 <__umoddi3+0x144>
  80374f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803753:	29 f2                	sub    %esi,%edx
  803755:	19 cb                	sbb    %ecx,%ebx
  803757:	89 d8                	mov    %ebx,%eax
  803759:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80375d:	d3 e0                	shl    %cl,%eax
  80375f:	89 e9                	mov    %ebp,%ecx
  803761:	d3 ea                	shr    %cl,%edx
  803763:	09 d0                	or     %edx,%eax
  803765:	89 e9                	mov    %ebp,%ecx
  803767:	d3 eb                	shr    %cl,%ebx
  803769:	89 da                	mov    %ebx,%edx
  80376b:	83 c4 1c             	add    $0x1c,%esp
  80376e:	5b                   	pop    %ebx
  80376f:	5e                   	pop    %esi
  803770:	5f                   	pop    %edi
  803771:	5d                   	pop    %ebp
  803772:	c3                   	ret    
  803773:	90                   	nop
  803774:	89 fd                	mov    %edi,%ebp
  803776:	85 ff                	test   %edi,%edi
  803778:	75 0b                	jne    803785 <__umoddi3+0xe9>
  80377a:	b8 01 00 00 00       	mov    $0x1,%eax
  80377f:	31 d2                	xor    %edx,%edx
  803781:	f7 f7                	div    %edi
  803783:	89 c5                	mov    %eax,%ebp
  803785:	89 f0                	mov    %esi,%eax
  803787:	31 d2                	xor    %edx,%edx
  803789:	f7 f5                	div    %ebp
  80378b:	89 c8                	mov    %ecx,%eax
  80378d:	f7 f5                	div    %ebp
  80378f:	89 d0                	mov    %edx,%eax
  803791:	e9 44 ff ff ff       	jmp    8036da <__umoddi3+0x3e>
  803796:	66 90                	xchg   %ax,%ax
  803798:	89 c8                	mov    %ecx,%eax
  80379a:	89 f2                	mov    %esi,%edx
  80379c:	83 c4 1c             	add    $0x1c,%esp
  80379f:	5b                   	pop    %ebx
  8037a0:	5e                   	pop    %esi
  8037a1:	5f                   	pop    %edi
  8037a2:	5d                   	pop    %ebp
  8037a3:	c3                   	ret    
  8037a4:	3b 04 24             	cmp    (%esp),%eax
  8037a7:	72 06                	jb     8037af <__umoddi3+0x113>
  8037a9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8037ad:	77 0f                	ja     8037be <__umoddi3+0x122>
  8037af:	89 f2                	mov    %esi,%edx
  8037b1:	29 f9                	sub    %edi,%ecx
  8037b3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037b7:	89 14 24             	mov    %edx,(%esp)
  8037ba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037be:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037c2:	8b 14 24             	mov    (%esp),%edx
  8037c5:	83 c4 1c             	add    $0x1c,%esp
  8037c8:	5b                   	pop    %ebx
  8037c9:	5e                   	pop    %esi
  8037ca:	5f                   	pop    %edi
  8037cb:	5d                   	pop    %ebp
  8037cc:	c3                   	ret    
  8037cd:	8d 76 00             	lea    0x0(%esi),%esi
  8037d0:	2b 04 24             	sub    (%esp),%eax
  8037d3:	19 fa                	sbb    %edi,%edx
  8037d5:	89 d1                	mov    %edx,%ecx
  8037d7:	89 c6                	mov    %eax,%esi
  8037d9:	e9 71 ff ff ff       	jmp    80374f <__umoddi3+0xb3>
  8037de:	66 90                	xchg   %ax,%ax
  8037e0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037e4:	72 ea                	jb     8037d0 <__umoddi3+0x134>
  8037e6:	89 d9                	mov    %ebx,%ecx
  8037e8:	e9 62 ff ff ff       	jmp    80374f <__umoddi3+0xb3>
