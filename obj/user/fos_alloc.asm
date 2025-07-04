
obj/user/fos_alloc:     file format elf32-i386


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
  800031:	e8 02 01 00 00       	call   800138 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//uint32 size = 2*1024*1024 +120*4096+1;
	//uint32 size = 1*1024*1024 + 256*1024;
	//uint32 size = 1*1024*1024;
	uint32 size = 100;
  80003e:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%ebp)

	unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  800045:	83 ec 0c             	sub    $0xc,%esp
  800048:	ff 75 f0             	pushl  -0x10(%ebp)
  80004b:	e8 b1 10 00 00       	call   801101 <malloc>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	89 45 ec             	mov    %eax,-0x14(%ebp)
	atomic_cprintf("x allocated at %x\n",x);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	68 40 35 80 00       	push   $0x803540
  800061:	e8 18 03 00 00       	call   80037e <atomic_cprintf>
  800066:	83 c4 10             	add    $0x10,%esp

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  800069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800070:	eb 20                	jmp    800092 <_main+0x5a>
	{
		x[i] = i%256 ;
  800072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800078:	01 c2                	add    %eax,%edx
  80007a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007d:	25 ff 00 00 80       	and    $0x800000ff,%eax
  800082:	85 c0                	test   %eax,%eax
  800084:	79 07                	jns    80008d <_main+0x55>
  800086:	48                   	dec    %eax
  800087:	0d 00 ff ff ff       	or     $0xffffff00,%eax
  80008c:	40                   	inc    %eax
  80008d:	88 02                	mov    %al,(%edx)

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  80008f:	ff 45 f4             	incl   -0xc(%ebp)
  800092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800095:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800098:	72 d8                	jb     800072 <_main+0x3a>
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  80009a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009d:	83 e8 07             	sub    $0x7,%eax
  8000a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000a3:	eb 24                	jmp    8000c9 <_main+0x91>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
  8000a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	8a 00                	mov    (%eax),%al
  8000af:	0f b6 c0             	movzbl %al,%eax
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	68 53 35 80 00       	push   $0x803553
  8000be:	e8 bb 02 00 00       	call   80037e <atomic_cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  8000c6:	ff 45 f4             	incl   -0xc(%ebp)
  8000c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000cf:	72 d4                	jb     8000a5 <_main+0x6d>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
	
	free(x);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d7:	e8 db 11 00 00       	call   8012b7 <free>
  8000dc:	83 c4 10             	add    $0x10,%esp

	x = malloc(sizeof(unsigned char)*size) ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e5:	e8 17 10 00 00       	call   801101 <malloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	for (i = size-7 ; i < size ; i++)
  8000f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000f3:	83 e8 07             	sub    $0x7,%eax
  8000f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000f9:	eb 24                	jmp    80011f <_main+0xe7>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
  8000fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	8a 00                	mov    (%eax),%al
  800105:	0f b6 c0             	movzbl %al,%eax
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	50                   	push   %eax
  80010c:	ff 75 f4             	pushl  -0xc(%ebp)
  80010f:	68 53 35 80 00       	push   $0x803553
  800114:	e8 65 02 00 00       	call   80037e <atomic_cprintf>
  800119:	83 c4 10             	add    $0x10,%esp
	
	free(x);

	x = malloc(sizeof(unsigned char)*size) ;
	
	for (i = size-7 ; i < size ; i++)
  80011c:	ff 45 f4             	incl   -0xc(%ebp)
  80011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800122:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800125:	72 d4                	jb     8000fb <_main+0xc3>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
	}

	free(x);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 ec             	pushl  -0x14(%ebp)
  80012d:	e8 85 11 00 00       	call   8012b7 <free>
  800132:	83 c4 10             	add    $0x10,%esp
	
	return;	
  800135:	90                   	nop
}
  800136:	c9                   	leave  
  800137:	c3                   	ret    

00800138 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80013e:	e8 5c 19 00 00       	call   801a9f <sys_getenvindex>
  800143:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800146:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800149:	89 d0                	mov    %edx,%eax
  80014b:	c1 e0 02             	shl    $0x2,%eax
  80014e:	01 d0                	add    %edx,%eax
  800150:	c1 e0 03             	shl    $0x3,%eax
  800153:	01 d0                	add    %edx,%eax
  800155:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80015c:	01 d0                	add    %edx,%eax
  80015e:	c1 e0 02             	shl    $0x2,%eax
  800161:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800166:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016b:	a1 20 40 80 00       	mov    0x804020,%eax
  800170:	8a 40 20             	mov    0x20(%eax),%al
  800173:	84 c0                	test   %al,%al
  800175:	74 0d                	je     800184 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800177:	a1 20 40 80 00       	mov    0x804020,%eax
  80017c:	83 c0 20             	add    $0x20,%eax
  80017f:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800184:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800188:	7e 0a                	jle    800194 <libmain+0x5c>
		binaryname = argv[0];
  80018a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018d:	8b 00                	mov    (%eax),%eax
  80018f:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800194:	83 ec 08             	sub    $0x8,%esp
  800197:	ff 75 0c             	pushl  0xc(%ebp)
  80019a:	ff 75 08             	pushl  0x8(%ebp)
  80019d:	e8 96 fe ff ff       	call   800038 <_main>
  8001a2:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001a5:	a1 00 40 80 00       	mov    0x804000,%eax
  8001aa:	85 c0                	test   %eax,%eax
  8001ac:	0f 84 9f 00 00 00    	je     800251 <libmain+0x119>
	{
		sys_lock_cons();
  8001b2:	e8 6c 16 00 00       	call   801823 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	68 78 35 80 00       	push   $0x803578
  8001bf:	e8 8d 01 00 00       	call   800351 <cprintf>
  8001c4:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c7:	a1 20 40 80 00       	mov    0x804020,%eax
  8001cc:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001d2:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d7:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8001dd:	83 ec 04             	sub    $0x4,%esp
  8001e0:	52                   	push   %edx
  8001e1:	50                   	push   %eax
  8001e2:	68 a0 35 80 00       	push   $0x8035a0
  8001e7:	e8 65 01 00 00       	call   800351 <cprintf>
  8001ec:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001ef:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f4:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8001fa:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ff:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800205:	a1 20 40 80 00       	mov    0x804020,%eax
  80020a:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800210:	51                   	push   %ecx
  800211:	52                   	push   %edx
  800212:	50                   	push   %eax
  800213:	68 c8 35 80 00       	push   $0x8035c8
  800218:	e8 34 01 00 00       	call   800351 <cprintf>
  80021d:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800220:	a1 20 40 80 00       	mov    0x804020,%eax
  800225:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80022b:	83 ec 08             	sub    $0x8,%esp
  80022e:	50                   	push   %eax
  80022f:	68 20 36 80 00       	push   $0x803620
  800234:	e8 18 01 00 00       	call   800351 <cprintf>
  800239:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80023c:	83 ec 0c             	sub    $0xc,%esp
  80023f:	68 78 35 80 00       	push   $0x803578
  800244:	e8 08 01 00 00       	call   800351 <cprintf>
  800249:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80024c:	e8 ec 15 00 00       	call   80183d <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800251:	e8 19 00 00 00       	call   80026f <exit>
}
  800256:	90                   	nop
  800257:	c9                   	leave  
  800258:	c3                   	ret    

00800259 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80025f:	83 ec 0c             	sub    $0xc,%esp
  800262:	6a 00                	push   $0x0
  800264:	e8 02 18 00 00       	call   801a6b <sys_destroy_env>
  800269:	83 c4 10             	add    $0x10,%esp
}
  80026c:	90                   	nop
  80026d:	c9                   	leave  
  80026e:	c3                   	ret    

0080026f <exit>:

void
exit(void)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800275:	e8 57 18 00 00       	call   801ad1 <sys_exit_env>
}
  80027a:	90                   	nop
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800283:	8b 45 0c             	mov    0xc(%ebp),%eax
  800286:	8b 00                	mov    (%eax),%eax
  800288:	8d 48 01             	lea    0x1(%eax),%ecx
  80028b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028e:	89 0a                	mov    %ecx,(%edx)
  800290:	8b 55 08             	mov    0x8(%ebp),%edx
  800293:	88 d1                	mov    %dl,%cl
  800295:	8b 55 0c             	mov    0xc(%ebp),%edx
  800298:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80029c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029f:	8b 00                	mov    (%eax),%eax
  8002a1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a6:	75 2c                	jne    8002d4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002a8:	a0 44 40 98 00       	mov    0x984044,%al
  8002ad:	0f b6 c0             	movzbl %al,%eax
  8002b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b3:	8b 12                	mov    (%edx),%edx
  8002b5:	89 d1                	mov    %edx,%ecx
  8002b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ba:	83 c2 08             	add    $0x8,%edx
  8002bd:	83 ec 04             	sub    $0x4,%esp
  8002c0:	50                   	push   %eax
  8002c1:	51                   	push   %ecx
  8002c2:	52                   	push   %edx
  8002c3:	e8 19 15 00 00       	call   8017e1 <sys_cputs>
  8002c8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d7:	8b 40 04             	mov    0x4(%eax),%eax
  8002da:	8d 50 01             	lea    0x1(%eax),%edx
  8002dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e0:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002e3:	90                   	nop
  8002e4:	c9                   	leave  
  8002e5:	c3                   	ret    

008002e6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002ef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002f6:	00 00 00 
	b.cnt = 0;
  8002f9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800300:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800303:	ff 75 0c             	pushl  0xc(%ebp)
  800306:	ff 75 08             	pushl  0x8(%ebp)
  800309:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80030f:	50                   	push   %eax
  800310:	68 7d 02 80 00       	push   $0x80027d
  800315:	e8 11 02 00 00       	call   80052b <vprintfmt>
  80031a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80031d:	a0 44 40 98 00       	mov    0x984044,%al
  800322:	0f b6 c0             	movzbl %al,%eax
  800325:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80032b:	83 ec 04             	sub    $0x4,%esp
  80032e:	50                   	push   %eax
  80032f:	52                   	push   %edx
  800330:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800336:	83 c0 08             	add    $0x8,%eax
  800339:	50                   	push   %eax
  80033a:	e8 a2 14 00 00       	call   8017e1 <sys_cputs>
  80033f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800342:	c6 05 44 40 98 00 00 	movb   $0x0,0x984044
	return b.cnt;
  800349:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80034f:	c9                   	leave  
  800350:	c3                   	ret    

00800351 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800351:	55                   	push   %ebp
  800352:	89 e5                	mov    %esp,%ebp
  800354:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800357:	c6 05 44 40 98 00 01 	movb   $0x1,0x984044
	va_start(ap, fmt);
  80035e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800361:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800364:	8b 45 08             	mov    0x8(%ebp),%eax
  800367:	83 ec 08             	sub    $0x8,%esp
  80036a:	ff 75 f4             	pushl  -0xc(%ebp)
  80036d:	50                   	push   %eax
  80036e:	e8 73 ff ff ff       	call   8002e6 <vcprintf>
  800373:	83 c4 10             	add    $0x10,%esp
  800376:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800379:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80037c:	c9                   	leave  
  80037d:	c3                   	ret    

0080037e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800384:	e8 9a 14 00 00       	call   801823 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800389:	8d 45 0c             	lea    0xc(%ebp),%eax
  80038c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	83 ec 08             	sub    $0x8,%esp
  800395:	ff 75 f4             	pushl  -0xc(%ebp)
  800398:	50                   	push   %eax
  800399:	e8 48 ff ff ff       	call   8002e6 <vcprintf>
  80039e:	83 c4 10             	add    $0x10,%esp
  8003a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8003a4:	e8 94 14 00 00       	call   80183d <sys_unlock_cons>
	return cnt;
  8003a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003ac:	c9                   	leave  
  8003ad:	c3                   	ret    

008003ae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003ae:	55                   	push   %ebp
  8003af:	89 e5                	mov    %esp,%ebp
  8003b1:	53                   	push   %ebx
  8003b2:	83 ec 14             	sub    $0x14,%esp
  8003b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c1:	8b 45 18             	mov    0x18(%ebp),%eax
  8003c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003cc:	77 55                	ja     800423 <printnum+0x75>
  8003ce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003d1:	72 05                	jb     8003d8 <printnum+0x2a>
  8003d3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003d6:	77 4b                	ja     800423 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003db:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003de:	8b 45 18             	mov    0x18(%ebp),%eax
  8003e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e6:	52                   	push   %edx
  8003e7:	50                   	push   %eax
  8003e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8003eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8003ee:	e8 d9 2e 00 00       	call   8032cc <__udivdi3>
  8003f3:	83 c4 10             	add    $0x10,%esp
  8003f6:	83 ec 04             	sub    $0x4,%esp
  8003f9:	ff 75 20             	pushl  0x20(%ebp)
  8003fc:	53                   	push   %ebx
  8003fd:	ff 75 18             	pushl  0x18(%ebp)
  800400:	52                   	push   %edx
  800401:	50                   	push   %eax
  800402:	ff 75 0c             	pushl  0xc(%ebp)
  800405:	ff 75 08             	pushl  0x8(%ebp)
  800408:	e8 a1 ff ff ff       	call   8003ae <printnum>
  80040d:	83 c4 20             	add    $0x20,%esp
  800410:	eb 1a                	jmp    80042c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800412:	83 ec 08             	sub    $0x8,%esp
  800415:	ff 75 0c             	pushl  0xc(%ebp)
  800418:	ff 75 20             	pushl  0x20(%ebp)
  80041b:	8b 45 08             	mov    0x8(%ebp),%eax
  80041e:	ff d0                	call   *%eax
  800420:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800423:	ff 4d 1c             	decl   0x1c(%ebp)
  800426:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80042a:	7f e6                	jg     800412 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80042c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80042f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800434:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800437:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80043a:	53                   	push   %ebx
  80043b:	51                   	push   %ecx
  80043c:	52                   	push   %edx
  80043d:	50                   	push   %eax
  80043e:	e8 99 2f 00 00       	call   8033dc <__umoddi3>
  800443:	83 c4 10             	add    $0x10,%esp
  800446:	05 54 38 80 00       	add    $0x803854,%eax
  80044b:	8a 00                	mov    (%eax),%al
  80044d:	0f be c0             	movsbl %al,%eax
  800450:	83 ec 08             	sub    $0x8,%esp
  800453:	ff 75 0c             	pushl  0xc(%ebp)
  800456:	50                   	push   %eax
  800457:	8b 45 08             	mov    0x8(%ebp),%eax
  80045a:	ff d0                	call   *%eax
  80045c:	83 c4 10             	add    $0x10,%esp
}
  80045f:	90                   	nop
  800460:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800463:	c9                   	leave  
  800464:	c3                   	ret    

00800465 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800465:	55                   	push   %ebp
  800466:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800468:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80046c:	7e 1c                	jle    80048a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80046e:	8b 45 08             	mov    0x8(%ebp),%eax
  800471:	8b 00                	mov    (%eax),%eax
  800473:	8d 50 08             	lea    0x8(%eax),%edx
  800476:	8b 45 08             	mov    0x8(%ebp),%eax
  800479:	89 10                	mov    %edx,(%eax)
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	8b 00                	mov    (%eax),%eax
  800480:	83 e8 08             	sub    $0x8,%eax
  800483:	8b 50 04             	mov    0x4(%eax),%edx
  800486:	8b 00                	mov    (%eax),%eax
  800488:	eb 40                	jmp    8004ca <getuint+0x65>
	else if (lflag)
  80048a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80048e:	74 1e                	je     8004ae <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800490:	8b 45 08             	mov    0x8(%ebp),%eax
  800493:	8b 00                	mov    (%eax),%eax
  800495:	8d 50 04             	lea    0x4(%eax),%edx
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	89 10                	mov    %edx,(%eax)
  80049d:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a0:	8b 00                	mov    (%eax),%eax
  8004a2:	83 e8 04             	sub    $0x4,%eax
  8004a5:	8b 00                	mov    (%eax),%eax
  8004a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ac:	eb 1c                	jmp    8004ca <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	8d 50 04             	lea    0x4(%eax),%edx
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	89 10                	mov    %edx,(%eax)
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	8b 00                	mov    (%eax),%eax
  8004c0:	83 e8 04             	sub    $0x4,%eax
  8004c3:	8b 00                	mov    (%eax),%eax
  8004c5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004ca:	5d                   	pop    %ebp
  8004cb:	c3                   	ret    

008004cc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004cc:	55                   	push   %ebp
  8004cd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004cf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004d3:	7e 1c                	jle    8004f1 <getint+0x25>
		return va_arg(*ap, long long);
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	8b 00                	mov    (%eax),%eax
  8004da:	8d 50 08             	lea    0x8(%eax),%edx
  8004dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e0:	89 10                	mov    %edx,(%eax)
  8004e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	83 e8 08             	sub    $0x8,%eax
  8004ea:	8b 50 04             	mov    0x4(%eax),%edx
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	eb 38                	jmp    800529 <getint+0x5d>
	else if (lflag)
  8004f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004f5:	74 1a                	je     800511 <getint+0x45>
		return va_arg(*ap, long);
  8004f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	8d 50 04             	lea    0x4(%eax),%edx
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	89 10                	mov    %edx,(%eax)
  800504:	8b 45 08             	mov    0x8(%ebp),%eax
  800507:	8b 00                	mov    (%eax),%eax
  800509:	83 e8 04             	sub    $0x4,%eax
  80050c:	8b 00                	mov    (%eax),%eax
  80050e:	99                   	cltd   
  80050f:	eb 18                	jmp    800529 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800511:	8b 45 08             	mov    0x8(%ebp),%eax
  800514:	8b 00                	mov    (%eax),%eax
  800516:	8d 50 04             	lea    0x4(%eax),%edx
  800519:	8b 45 08             	mov    0x8(%ebp),%eax
  80051c:	89 10                	mov    %edx,(%eax)
  80051e:	8b 45 08             	mov    0x8(%ebp),%eax
  800521:	8b 00                	mov    (%eax),%eax
  800523:	83 e8 04             	sub    $0x4,%eax
  800526:	8b 00                	mov    (%eax),%eax
  800528:	99                   	cltd   
}
  800529:	5d                   	pop    %ebp
  80052a:	c3                   	ret    

0080052b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80052b:	55                   	push   %ebp
  80052c:	89 e5                	mov    %esp,%ebp
  80052e:	56                   	push   %esi
  80052f:	53                   	push   %ebx
  800530:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800533:	eb 17                	jmp    80054c <vprintfmt+0x21>
			if (ch == '\0')
  800535:	85 db                	test   %ebx,%ebx
  800537:	0f 84 c1 03 00 00    	je     8008fe <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80053d:	83 ec 08             	sub    $0x8,%esp
  800540:	ff 75 0c             	pushl  0xc(%ebp)
  800543:	53                   	push   %ebx
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	ff d0                	call   *%eax
  800549:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80054c:	8b 45 10             	mov    0x10(%ebp),%eax
  80054f:	8d 50 01             	lea    0x1(%eax),%edx
  800552:	89 55 10             	mov    %edx,0x10(%ebp)
  800555:	8a 00                	mov    (%eax),%al
  800557:	0f b6 d8             	movzbl %al,%ebx
  80055a:	83 fb 25             	cmp    $0x25,%ebx
  80055d:	75 d6                	jne    800535 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80055f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800563:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80056a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800571:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800578:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057f:	8b 45 10             	mov    0x10(%ebp),%eax
  800582:	8d 50 01             	lea    0x1(%eax),%edx
  800585:	89 55 10             	mov    %edx,0x10(%ebp)
  800588:	8a 00                	mov    (%eax),%al
  80058a:	0f b6 d8             	movzbl %al,%ebx
  80058d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800590:	83 f8 5b             	cmp    $0x5b,%eax
  800593:	0f 87 3d 03 00 00    	ja     8008d6 <vprintfmt+0x3ab>
  800599:	8b 04 85 78 38 80 00 	mov    0x803878(,%eax,4),%eax
  8005a0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005a2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005a6:	eb d7                	jmp    80057f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005a8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005ac:	eb d1                	jmp    80057f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b8:	89 d0                	mov    %edx,%eax
  8005ba:	c1 e0 02             	shl    $0x2,%eax
  8005bd:	01 d0                	add    %edx,%eax
  8005bf:	01 c0                	add    %eax,%eax
  8005c1:	01 d8                	add    %ebx,%eax
  8005c3:	83 e8 30             	sub    $0x30,%eax
  8005c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cc:	8a 00                	mov    (%eax),%al
  8005ce:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005d1:	83 fb 2f             	cmp    $0x2f,%ebx
  8005d4:	7e 3e                	jle    800614 <vprintfmt+0xe9>
  8005d6:	83 fb 39             	cmp    $0x39,%ebx
  8005d9:	7f 39                	jg     800614 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005db:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005de:	eb d5                	jmp    8005b5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	83 c0 04             	add    $0x4,%eax
  8005e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	83 e8 04             	sub    $0x4,%eax
  8005ef:	8b 00                	mov    (%eax),%eax
  8005f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005f4:	eb 1f                	jmp    800615 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005fa:	79 83                	jns    80057f <vprintfmt+0x54>
				width = 0;
  8005fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800603:	e9 77 ff ff ff       	jmp    80057f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800608:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80060f:	e9 6b ff ff ff       	jmp    80057f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800614:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800615:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800619:	0f 89 60 ff ff ff    	jns    80057f <vprintfmt+0x54>
				width = precision, precision = -1;
  80061f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800625:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80062c:	e9 4e ff ff ff       	jmp    80057f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800631:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800634:	e9 46 ff ff ff       	jmp    80057f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	83 c0 04             	add    $0x4,%eax
  80063f:	89 45 14             	mov    %eax,0x14(%ebp)
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	83 e8 04             	sub    $0x4,%eax
  800648:	8b 00                	mov    (%eax),%eax
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	ff 75 0c             	pushl  0xc(%ebp)
  800650:	50                   	push   %eax
  800651:	8b 45 08             	mov    0x8(%ebp),%eax
  800654:	ff d0                	call   *%eax
  800656:	83 c4 10             	add    $0x10,%esp
			break;
  800659:	e9 9b 02 00 00       	jmp    8008f9 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	83 c0 04             	add    $0x4,%eax
  800664:	89 45 14             	mov    %eax,0x14(%ebp)
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	83 e8 04             	sub    $0x4,%eax
  80066d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80066f:	85 db                	test   %ebx,%ebx
  800671:	79 02                	jns    800675 <vprintfmt+0x14a>
				err = -err;
  800673:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800675:	83 fb 64             	cmp    $0x64,%ebx
  800678:	7f 0b                	jg     800685 <vprintfmt+0x15a>
  80067a:	8b 34 9d c0 36 80 00 	mov    0x8036c0(,%ebx,4),%esi
  800681:	85 f6                	test   %esi,%esi
  800683:	75 19                	jne    80069e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800685:	53                   	push   %ebx
  800686:	68 65 38 80 00       	push   $0x803865
  80068b:	ff 75 0c             	pushl  0xc(%ebp)
  80068e:	ff 75 08             	pushl  0x8(%ebp)
  800691:	e8 70 02 00 00       	call   800906 <printfmt>
  800696:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800699:	e9 5b 02 00 00       	jmp    8008f9 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80069e:	56                   	push   %esi
  80069f:	68 6e 38 80 00       	push   $0x80386e
  8006a4:	ff 75 0c             	pushl  0xc(%ebp)
  8006a7:	ff 75 08             	pushl  0x8(%ebp)
  8006aa:	e8 57 02 00 00       	call   800906 <printfmt>
  8006af:	83 c4 10             	add    $0x10,%esp
			break;
  8006b2:	e9 42 02 00 00       	jmp    8008f9 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	83 c0 04             	add    $0x4,%eax
  8006bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c3:	83 e8 04             	sub    $0x4,%eax
  8006c6:	8b 30                	mov    (%eax),%esi
  8006c8:	85 f6                	test   %esi,%esi
  8006ca:	75 05                	jne    8006d1 <vprintfmt+0x1a6>
				p = "(null)";
  8006cc:	be 71 38 80 00       	mov    $0x803871,%esi
			if (width > 0 && padc != '-')
  8006d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006d5:	7e 6d                	jle    800744 <vprintfmt+0x219>
  8006d7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006db:	74 67                	je     800744 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006e0:	83 ec 08             	sub    $0x8,%esp
  8006e3:	50                   	push   %eax
  8006e4:	56                   	push   %esi
  8006e5:	e8 1e 03 00 00       	call   800a08 <strnlen>
  8006ea:	83 c4 10             	add    $0x10,%esp
  8006ed:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006f0:	eb 16                	jmp    800708 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006f2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006f6:	83 ec 08             	sub    $0x8,%esp
  8006f9:	ff 75 0c             	pushl  0xc(%ebp)
  8006fc:	50                   	push   %eax
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	ff d0                	call   *%eax
  800702:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800705:	ff 4d e4             	decl   -0x1c(%ebp)
  800708:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80070c:	7f e4                	jg     8006f2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80070e:	eb 34                	jmp    800744 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800710:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800714:	74 1c                	je     800732 <vprintfmt+0x207>
  800716:	83 fb 1f             	cmp    $0x1f,%ebx
  800719:	7e 05                	jle    800720 <vprintfmt+0x1f5>
  80071b:	83 fb 7e             	cmp    $0x7e,%ebx
  80071e:	7e 12                	jle    800732 <vprintfmt+0x207>
					putch('?', putdat);
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	ff 75 0c             	pushl  0xc(%ebp)
  800726:	6a 3f                	push   $0x3f
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	ff d0                	call   *%eax
  80072d:	83 c4 10             	add    $0x10,%esp
  800730:	eb 0f                	jmp    800741 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800732:	83 ec 08             	sub    $0x8,%esp
  800735:	ff 75 0c             	pushl  0xc(%ebp)
  800738:	53                   	push   %ebx
  800739:	8b 45 08             	mov    0x8(%ebp),%eax
  80073c:	ff d0                	call   *%eax
  80073e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800741:	ff 4d e4             	decl   -0x1c(%ebp)
  800744:	89 f0                	mov    %esi,%eax
  800746:	8d 70 01             	lea    0x1(%eax),%esi
  800749:	8a 00                	mov    (%eax),%al
  80074b:	0f be d8             	movsbl %al,%ebx
  80074e:	85 db                	test   %ebx,%ebx
  800750:	74 24                	je     800776 <vprintfmt+0x24b>
  800752:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800756:	78 b8                	js     800710 <vprintfmt+0x1e5>
  800758:	ff 4d e0             	decl   -0x20(%ebp)
  80075b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80075f:	79 af                	jns    800710 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800761:	eb 13                	jmp    800776 <vprintfmt+0x24b>
				putch(' ', putdat);
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	ff 75 0c             	pushl  0xc(%ebp)
  800769:	6a 20                	push   $0x20
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	ff d0                	call   *%eax
  800770:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800773:	ff 4d e4             	decl   -0x1c(%ebp)
  800776:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80077a:	7f e7                	jg     800763 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80077c:	e9 78 01 00 00       	jmp    8008f9 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	ff 75 e8             	pushl  -0x18(%ebp)
  800787:	8d 45 14             	lea    0x14(%ebp),%eax
  80078a:	50                   	push   %eax
  80078b:	e8 3c fd ff ff       	call   8004cc <getint>
  800790:	83 c4 10             	add    $0x10,%esp
  800793:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800796:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800799:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80079c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80079f:	85 d2                	test   %edx,%edx
  8007a1:	79 23                	jns    8007c6 <vprintfmt+0x29b>
				putch('-', putdat);
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	ff 75 0c             	pushl  0xc(%ebp)
  8007a9:	6a 2d                	push   $0x2d
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	ff d0                	call   *%eax
  8007b0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007b9:	f7 d8                	neg    %eax
  8007bb:	83 d2 00             	adc    $0x0,%edx
  8007be:	f7 da                	neg    %edx
  8007c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007c6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007cd:	e9 bc 00 00 00       	jmp    80088e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007d2:	83 ec 08             	sub    $0x8,%esp
  8007d5:	ff 75 e8             	pushl  -0x18(%ebp)
  8007d8:	8d 45 14             	lea    0x14(%ebp),%eax
  8007db:	50                   	push   %eax
  8007dc:	e8 84 fc ff ff       	call   800465 <getuint>
  8007e1:	83 c4 10             	add    $0x10,%esp
  8007e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007ea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007f1:	e9 98 00 00 00       	jmp    80088e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007f6:	83 ec 08             	sub    $0x8,%esp
  8007f9:	ff 75 0c             	pushl  0xc(%ebp)
  8007fc:	6a 58                	push   $0x58
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	ff d0                	call   *%eax
  800803:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800806:	83 ec 08             	sub    $0x8,%esp
  800809:	ff 75 0c             	pushl  0xc(%ebp)
  80080c:	6a 58                	push   $0x58
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	ff d0                	call   *%eax
  800813:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800816:	83 ec 08             	sub    $0x8,%esp
  800819:	ff 75 0c             	pushl  0xc(%ebp)
  80081c:	6a 58                	push   $0x58
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	ff d0                	call   *%eax
  800823:	83 c4 10             	add    $0x10,%esp
			break;
  800826:	e9 ce 00 00 00       	jmp    8008f9 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	ff 75 0c             	pushl  0xc(%ebp)
  800831:	6a 30                	push   $0x30
  800833:	8b 45 08             	mov    0x8(%ebp),%eax
  800836:	ff d0                	call   *%eax
  800838:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	ff 75 0c             	pushl  0xc(%ebp)
  800841:	6a 78                	push   $0x78
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	ff d0                	call   *%eax
  800848:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80084b:	8b 45 14             	mov    0x14(%ebp),%eax
  80084e:	83 c0 04             	add    $0x4,%eax
  800851:	89 45 14             	mov    %eax,0x14(%ebp)
  800854:	8b 45 14             	mov    0x14(%ebp),%eax
  800857:	83 e8 04             	sub    $0x4,%eax
  80085a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80085c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80085f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800866:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80086d:	eb 1f                	jmp    80088e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	ff 75 e8             	pushl  -0x18(%ebp)
  800875:	8d 45 14             	lea    0x14(%ebp),%eax
  800878:	50                   	push   %eax
  800879:	e8 e7 fb ff ff       	call   800465 <getuint>
  80087e:	83 c4 10             	add    $0x10,%esp
  800881:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800884:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800887:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80088e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800892:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800895:	83 ec 04             	sub    $0x4,%esp
  800898:	52                   	push   %edx
  800899:	ff 75 e4             	pushl  -0x1c(%ebp)
  80089c:	50                   	push   %eax
  80089d:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8008a3:	ff 75 0c             	pushl  0xc(%ebp)
  8008a6:	ff 75 08             	pushl  0x8(%ebp)
  8008a9:	e8 00 fb ff ff       	call   8003ae <printnum>
  8008ae:	83 c4 20             	add    $0x20,%esp
			break;
  8008b1:	eb 46                	jmp    8008f9 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008b3:	83 ec 08             	sub    $0x8,%esp
  8008b6:	ff 75 0c             	pushl  0xc(%ebp)
  8008b9:	53                   	push   %ebx
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	ff d0                	call   *%eax
  8008bf:	83 c4 10             	add    $0x10,%esp
			break;
  8008c2:	eb 35                	jmp    8008f9 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8008c4:	c6 05 44 40 98 00 00 	movb   $0x0,0x984044
			break;
  8008cb:	eb 2c                	jmp    8008f9 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8008cd:	c6 05 44 40 98 00 01 	movb   $0x1,0x984044
			break;
  8008d4:	eb 23                	jmp    8008f9 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008d6:	83 ec 08             	sub    $0x8,%esp
  8008d9:	ff 75 0c             	pushl  0xc(%ebp)
  8008dc:	6a 25                	push   $0x25
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	ff d0                	call   *%eax
  8008e3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008e6:	ff 4d 10             	decl   0x10(%ebp)
  8008e9:	eb 03                	jmp    8008ee <vprintfmt+0x3c3>
  8008eb:	ff 4d 10             	decl   0x10(%ebp)
  8008ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f1:	48                   	dec    %eax
  8008f2:	8a 00                	mov    (%eax),%al
  8008f4:	3c 25                	cmp    $0x25,%al
  8008f6:	75 f3                	jne    8008eb <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008f8:	90                   	nop
		}
	}
  8008f9:	e9 35 fc ff ff       	jmp    800533 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008fe:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800902:	5b                   	pop    %ebx
  800903:	5e                   	pop    %esi
  800904:	5d                   	pop    %ebp
  800905:	c3                   	ret    

00800906 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
  800909:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80090c:	8d 45 10             	lea    0x10(%ebp),%eax
  80090f:	83 c0 04             	add    $0x4,%eax
  800912:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800915:	8b 45 10             	mov    0x10(%ebp),%eax
  800918:	ff 75 f4             	pushl  -0xc(%ebp)
  80091b:	50                   	push   %eax
  80091c:	ff 75 0c             	pushl  0xc(%ebp)
  80091f:	ff 75 08             	pushl  0x8(%ebp)
  800922:	e8 04 fc ff ff       	call   80052b <vprintfmt>
  800927:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80092a:	90                   	nop
  80092b:	c9                   	leave  
  80092c:	c3                   	ret    

0080092d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800930:	8b 45 0c             	mov    0xc(%ebp),%eax
  800933:	8b 40 08             	mov    0x8(%eax),%eax
  800936:	8d 50 01             	lea    0x1(%eax),%edx
  800939:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80093f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800942:	8b 10                	mov    (%eax),%edx
  800944:	8b 45 0c             	mov    0xc(%ebp),%eax
  800947:	8b 40 04             	mov    0x4(%eax),%eax
  80094a:	39 c2                	cmp    %eax,%edx
  80094c:	73 12                	jae    800960 <sprintputch+0x33>
		*b->buf++ = ch;
  80094e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800951:	8b 00                	mov    (%eax),%eax
  800953:	8d 48 01             	lea    0x1(%eax),%ecx
  800956:	8b 55 0c             	mov    0xc(%ebp),%edx
  800959:	89 0a                	mov    %ecx,(%edx)
  80095b:	8b 55 08             	mov    0x8(%ebp),%edx
  80095e:	88 10                	mov    %dl,(%eax)
}
  800960:	90                   	nop
  800961:	5d                   	pop    %ebp
  800962:	c3                   	ret    

00800963 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80096f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800972:	8d 50 ff             	lea    -0x1(%eax),%edx
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	01 d0                	add    %edx,%eax
  80097a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800984:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800988:	74 06                	je     800990 <vsnprintf+0x2d>
  80098a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80098e:	7f 07                	jg     800997 <vsnprintf+0x34>
		return -E_INVAL;
  800990:	b8 03 00 00 00       	mov    $0x3,%eax
  800995:	eb 20                	jmp    8009b7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800997:	ff 75 14             	pushl  0x14(%ebp)
  80099a:	ff 75 10             	pushl  0x10(%ebp)
  80099d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009a0:	50                   	push   %eax
  8009a1:	68 2d 09 80 00       	push   $0x80092d
  8009a6:	e8 80 fb ff ff       	call   80052b <vprintfmt>
  8009ab:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009b1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009b7:	c9                   	leave  
  8009b8:	c3                   	ret    

008009b9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009bf:	8d 45 10             	lea    0x10(%ebp),%eax
  8009c2:	83 c0 04             	add    $0x4,%eax
  8009c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ce:	50                   	push   %eax
  8009cf:	ff 75 0c             	pushl  0xc(%ebp)
  8009d2:	ff 75 08             	pushl  0x8(%ebp)
  8009d5:	e8 89 ff ff ff       	call   800963 <vsnprintf>
  8009da:	83 c4 10             	add    $0x10,%esp
  8009dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009e3:	c9                   	leave  
  8009e4:	c3                   	ret    

008009e5 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009f2:	eb 06                	jmp    8009fa <strlen+0x15>
		n++;
  8009f4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009f7:	ff 45 08             	incl   0x8(%ebp)
  8009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fd:	8a 00                	mov    (%eax),%al
  8009ff:	84 c0                	test   %al,%al
  800a01:	75 f1                	jne    8009f4 <strlen+0xf>
		n++;
	return n;
  800a03:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a06:	c9                   	leave  
  800a07:	c3                   	ret    

00800a08 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a08:	55                   	push   %ebp
  800a09:	89 e5                	mov    %esp,%ebp
  800a0b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a15:	eb 09                	jmp    800a20 <strnlen+0x18>
		n++;
  800a17:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a1a:	ff 45 08             	incl   0x8(%ebp)
  800a1d:	ff 4d 0c             	decl   0xc(%ebp)
  800a20:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a24:	74 09                	je     800a2f <strnlen+0x27>
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	8a 00                	mov    (%eax),%al
  800a2b:	84 c0                	test   %al,%al
  800a2d:	75 e8                	jne    800a17 <strnlen+0xf>
		n++;
	return n;
  800a2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a32:	c9                   	leave  
  800a33:	c3                   	ret    

00800a34 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a40:	90                   	nop
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	8d 50 01             	lea    0x1(%eax),%edx
  800a47:	89 55 08             	mov    %edx,0x8(%ebp)
  800a4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a50:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a53:	8a 12                	mov    (%edx),%dl
  800a55:	88 10                	mov    %dl,(%eax)
  800a57:	8a 00                	mov    (%eax),%al
  800a59:	84 c0                	test   %al,%al
  800a5b:	75 e4                	jne    800a41 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a60:	c9                   	leave  
  800a61:	c3                   	ret    

00800a62 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a62:	55                   	push   %ebp
  800a63:	89 e5                	mov    %esp,%ebp
  800a65:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a68:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a75:	eb 1f                	jmp    800a96 <strncpy+0x34>
		*dst++ = *src;
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	8d 50 01             	lea    0x1(%eax),%edx
  800a7d:	89 55 08             	mov    %edx,0x8(%ebp)
  800a80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a83:	8a 12                	mov    (%edx),%dl
  800a85:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8a:	8a 00                	mov    (%eax),%al
  800a8c:	84 c0                	test   %al,%al
  800a8e:	74 03                	je     800a93 <strncpy+0x31>
			src++;
  800a90:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a93:	ff 45 fc             	incl   -0x4(%ebp)
  800a96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a99:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a9c:	72 d9                	jb     800a77 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800aa1:	c9                   	leave  
  800aa2:	c3                   	ret    

00800aa3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800aaf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ab3:	74 30                	je     800ae5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ab5:	eb 16                	jmp    800acd <strlcpy+0x2a>
			*dst++ = *src++;
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	8d 50 01             	lea    0x1(%eax),%edx
  800abd:	89 55 08             	mov    %edx,0x8(%ebp)
  800ac0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ac6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ac9:	8a 12                	mov    (%edx),%dl
  800acb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800acd:	ff 4d 10             	decl   0x10(%ebp)
  800ad0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ad4:	74 09                	je     800adf <strlcpy+0x3c>
  800ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad9:	8a 00                	mov    (%eax),%al
  800adb:	84 c0                	test   %al,%al
  800add:	75 d8                	jne    800ab7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ae5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800aeb:	29 c2                	sub    %eax,%edx
  800aed:	89 d0                	mov    %edx,%eax
}
  800aef:	c9                   	leave  
  800af0:	c3                   	ret    

00800af1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800af1:	55                   	push   %ebp
  800af2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800af4:	eb 06                	jmp    800afc <strcmp+0xb>
		p++, q++;
  800af6:	ff 45 08             	incl   0x8(%ebp)
  800af9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	8a 00                	mov    (%eax),%al
  800b01:	84 c0                	test   %al,%al
  800b03:	74 0e                	je     800b13 <strcmp+0x22>
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	8a 10                	mov    (%eax),%dl
  800b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0d:	8a 00                	mov    (%eax),%al
  800b0f:	38 c2                	cmp    %al,%dl
  800b11:	74 e3                	je     800af6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	8a 00                	mov    (%eax),%al
  800b18:	0f b6 d0             	movzbl %al,%edx
  800b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1e:	8a 00                	mov    (%eax),%al
  800b20:	0f b6 c0             	movzbl %al,%eax
  800b23:	29 c2                	sub    %eax,%edx
  800b25:	89 d0                	mov    %edx,%eax
}
  800b27:	5d                   	pop    %ebp
  800b28:	c3                   	ret    

00800b29 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b2c:	eb 09                	jmp    800b37 <strncmp+0xe>
		n--, p++, q++;
  800b2e:	ff 4d 10             	decl   0x10(%ebp)
  800b31:	ff 45 08             	incl   0x8(%ebp)
  800b34:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b3b:	74 17                	je     800b54 <strncmp+0x2b>
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	8a 00                	mov    (%eax),%al
  800b42:	84 c0                	test   %al,%al
  800b44:	74 0e                	je     800b54 <strncmp+0x2b>
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	8a 10                	mov    (%eax),%dl
  800b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4e:	8a 00                	mov    (%eax),%al
  800b50:	38 c2                	cmp    %al,%dl
  800b52:	74 da                	je     800b2e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b54:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b58:	75 07                	jne    800b61 <strncmp+0x38>
		return 0;
  800b5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5f:	eb 14                	jmp    800b75 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	8a 00                	mov    (%eax),%al
  800b66:	0f b6 d0             	movzbl %al,%edx
  800b69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6c:	8a 00                	mov    (%eax),%al
  800b6e:	0f b6 c0             	movzbl %al,%eax
  800b71:	29 c2                	sub    %eax,%edx
  800b73:	89 d0                	mov    %edx,%eax
}
  800b75:	5d                   	pop    %ebp
  800b76:	c3                   	ret    

00800b77 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	83 ec 04             	sub    $0x4,%esp
  800b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b80:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b83:	eb 12                	jmp    800b97 <strchr+0x20>
		if (*s == c)
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	8a 00                	mov    (%eax),%al
  800b8a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b8d:	75 05                	jne    800b94 <strchr+0x1d>
			return (char *) s;
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	eb 11                	jmp    800ba5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b94:	ff 45 08             	incl   0x8(%ebp)
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	8a 00                	mov    (%eax),%al
  800b9c:	84 c0                	test   %al,%al
  800b9e:	75 e5                	jne    800b85 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ba0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ba5:	c9                   	leave  
  800ba6:	c3                   	ret    

00800ba7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	83 ec 04             	sub    $0x4,%esp
  800bad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bb3:	eb 0d                	jmp    800bc2 <strfind+0x1b>
		if (*s == c)
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	8a 00                	mov    (%eax),%al
  800bba:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bbd:	74 0e                	je     800bcd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bbf:	ff 45 08             	incl   0x8(%ebp)
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	8a 00                	mov    (%eax),%al
  800bc7:	84 c0                	test   %al,%al
  800bc9:	75 ea                	jne    800bb5 <strfind+0xe>
  800bcb:	eb 01                	jmp    800bce <strfind+0x27>
		if (*s == c)
			break;
  800bcd:	90                   	nop
	return (char *) s;
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bd1:	c9                   	leave  
  800bd2:	c3                   	ret    

00800bd3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800be2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800be5:	eb 0e                	jmp    800bf5 <memset+0x22>
		*p++ = c;
  800be7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bea:	8d 50 01             	lea    0x1(%eax),%edx
  800bed:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800bf0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800bf5:	ff 4d f8             	decl   -0x8(%ebp)
  800bf8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800bfc:	79 e9                	jns    800be7 <memset+0x14>
		*p++ = c;

	return v;
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c01:	c9                   	leave  
  800c02:	c3                   	ret    

00800c03 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c15:	eb 16                	jmp    800c2d <memcpy+0x2a>
		*d++ = *s++;
  800c17:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c1a:	8d 50 01             	lea    0x1(%eax),%edx
  800c1d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c20:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c23:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c26:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c29:	8a 12                	mov    (%edx),%dl
  800c2b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c30:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c33:	89 55 10             	mov    %edx,0x10(%ebp)
  800c36:	85 c0                	test   %eax,%eax
  800c38:	75 dd                	jne    800c17 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c3d:	c9                   	leave  
  800c3e:	c3                   	ret    

00800c3f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
  800c42:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c48:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c54:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c57:	73 50                	jae    800ca9 <memmove+0x6a>
  800c59:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5f:	01 d0                	add    %edx,%eax
  800c61:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c64:	76 43                	jbe    800ca9 <memmove+0x6a>
		s += n;
  800c66:	8b 45 10             	mov    0x10(%ebp),%eax
  800c69:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c72:	eb 10                	jmp    800c84 <memmove+0x45>
			*--d = *--s;
  800c74:	ff 4d f8             	decl   -0x8(%ebp)
  800c77:	ff 4d fc             	decl   -0x4(%ebp)
  800c7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c7d:	8a 10                	mov    (%eax),%dl
  800c7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c82:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c84:	8b 45 10             	mov    0x10(%ebp),%eax
  800c87:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c8a:	89 55 10             	mov    %edx,0x10(%ebp)
  800c8d:	85 c0                	test   %eax,%eax
  800c8f:	75 e3                	jne    800c74 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c91:	eb 23                	jmp    800cb6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c96:	8d 50 01             	lea    0x1(%eax),%edx
  800c99:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c9c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c9f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ca2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ca5:	8a 12                	mov    (%edx),%dl
  800ca7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ca9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cac:	8d 50 ff             	lea    -0x1(%eax),%edx
  800caf:	89 55 10             	mov    %edx,0x10(%ebp)
  800cb2:	85 c0                	test   %eax,%eax
  800cb4:	75 dd                	jne    800c93 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cb9:	c9                   	leave  
  800cba:	c3                   	ret    

00800cbb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cca:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ccd:	eb 2a                	jmp    800cf9 <memcmp+0x3e>
		if (*s1 != *s2)
  800ccf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd2:	8a 10                	mov    (%eax),%dl
  800cd4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cd7:	8a 00                	mov    (%eax),%al
  800cd9:	38 c2                	cmp    %al,%dl
  800cdb:	74 16                	je     800cf3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	0f b6 d0             	movzbl %al,%edx
  800ce5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	0f b6 c0             	movzbl %al,%eax
  800ced:	29 c2                	sub    %eax,%edx
  800cef:	89 d0                	mov    %edx,%eax
  800cf1:	eb 18                	jmp    800d0b <memcmp+0x50>
		s1++, s2++;
  800cf3:	ff 45 fc             	incl   -0x4(%ebp)
  800cf6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800cf9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cff:	89 55 10             	mov    %edx,0x10(%ebp)
  800d02:	85 c0                	test   %eax,%eax
  800d04:	75 c9                	jne    800ccf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d0b:	c9                   	leave  
  800d0c:	c3                   	ret    

00800d0d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d13:	8b 55 08             	mov    0x8(%ebp),%edx
  800d16:	8b 45 10             	mov    0x10(%ebp),%eax
  800d19:	01 d0                	add    %edx,%eax
  800d1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d1e:	eb 15                	jmp    800d35 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	8a 00                	mov    (%eax),%al
  800d25:	0f b6 d0             	movzbl %al,%edx
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	0f b6 c0             	movzbl %al,%eax
  800d2e:	39 c2                	cmp    %eax,%edx
  800d30:	74 0d                	je     800d3f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d32:	ff 45 08             	incl   0x8(%ebp)
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
  800d38:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d3b:	72 e3                	jb     800d20 <memfind+0x13>
  800d3d:	eb 01                	jmp    800d40 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d3f:	90                   	nop
	return (void *) s;
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d43:	c9                   	leave  
  800d44:	c3                   	ret    

00800d45 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d45:	55                   	push   %ebp
  800d46:	89 e5                	mov    %esp,%ebp
  800d48:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d4b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d52:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d59:	eb 03                	jmp    800d5e <strtol+0x19>
		s++;
  800d5b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	8a 00                	mov    (%eax),%al
  800d63:	3c 20                	cmp    $0x20,%al
  800d65:	74 f4                	je     800d5b <strtol+0x16>
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	3c 09                	cmp    $0x9,%al
  800d6e:	74 eb                	je     800d5b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	3c 2b                	cmp    $0x2b,%al
  800d77:	75 05                	jne    800d7e <strtol+0x39>
		s++;
  800d79:	ff 45 08             	incl   0x8(%ebp)
  800d7c:	eb 13                	jmp    800d91 <strtol+0x4c>
	else if (*s == '-')
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8a 00                	mov    (%eax),%al
  800d83:	3c 2d                	cmp    $0x2d,%al
  800d85:	75 0a                	jne    800d91 <strtol+0x4c>
		s++, neg = 1;
  800d87:	ff 45 08             	incl   0x8(%ebp)
  800d8a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d95:	74 06                	je     800d9d <strtol+0x58>
  800d97:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d9b:	75 20                	jne    800dbd <strtol+0x78>
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	8a 00                	mov    (%eax),%al
  800da2:	3c 30                	cmp    $0x30,%al
  800da4:	75 17                	jne    800dbd <strtol+0x78>
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	40                   	inc    %eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	3c 78                	cmp    $0x78,%al
  800dae:	75 0d                	jne    800dbd <strtol+0x78>
		s += 2, base = 16;
  800db0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800db4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dbb:	eb 28                	jmp    800de5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc1:	75 15                	jne    800dd8 <strtol+0x93>
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8a 00                	mov    (%eax),%al
  800dc8:	3c 30                	cmp    $0x30,%al
  800dca:	75 0c                	jne    800dd8 <strtol+0x93>
		s++, base = 8;
  800dcc:	ff 45 08             	incl   0x8(%ebp)
  800dcf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dd6:	eb 0d                	jmp    800de5 <strtol+0xa0>
	else if (base == 0)
  800dd8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ddc:	75 07                	jne    800de5 <strtol+0xa0>
		base = 10;
  800dde:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	8a 00                	mov    (%eax),%al
  800dea:	3c 2f                	cmp    $0x2f,%al
  800dec:	7e 19                	jle    800e07 <strtol+0xc2>
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	8a 00                	mov    (%eax),%al
  800df3:	3c 39                	cmp    $0x39,%al
  800df5:	7f 10                	jg     800e07 <strtol+0xc2>
			dig = *s - '0';
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	8a 00                	mov    (%eax),%al
  800dfc:	0f be c0             	movsbl %al,%eax
  800dff:	83 e8 30             	sub    $0x30,%eax
  800e02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e05:	eb 42                	jmp    800e49 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8a 00                	mov    (%eax),%al
  800e0c:	3c 60                	cmp    $0x60,%al
  800e0e:	7e 19                	jle    800e29 <strtol+0xe4>
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	3c 7a                	cmp    $0x7a,%al
  800e17:	7f 10                	jg     800e29 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e19:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1c:	8a 00                	mov    (%eax),%al
  800e1e:	0f be c0             	movsbl %al,%eax
  800e21:	83 e8 57             	sub    $0x57,%eax
  800e24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e27:	eb 20                	jmp    800e49 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	3c 40                	cmp    $0x40,%al
  800e30:	7e 39                	jle    800e6b <strtol+0x126>
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	3c 5a                	cmp    $0x5a,%al
  800e39:	7f 30                	jg     800e6b <strtol+0x126>
			dig = *s - 'A' + 10;
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	0f be c0             	movsbl %al,%eax
  800e43:	83 e8 37             	sub    $0x37,%eax
  800e46:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e4c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e4f:	7d 19                	jge    800e6a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e51:	ff 45 08             	incl   0x8(%ebp)
  800e54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e57:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e5b:	89 c2                	mov    %eax,%edx
  800e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e60:	01 d0                	add    %edx,%eax
  800e62:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e65:	e9 7b ff ff ff       	jmp    800de5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e6a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e6f:	74 08                	je     800e79 <strtol+0x134>
		*endptr = (char *) s;
  800e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e74:	8b 55 08             	mov    0x8(%ebp),%edx
  800e77:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e79:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e7d:	74 07                	je     800e86 <strtol+0x141>
  800e7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e82:	f7 d8                	neg    %eax
  800e84:	eb 03                	jmp    800e89 <strtol+0x144>
  800e86:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e89:	c9                   	leave  
  800e8a:	c3                   	ret    

00800e8b <ltostr>:

void
ltostr(long value, char *str)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e98:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ea3:	79 13                	jns    800eb8 <ltostr+0x2d>
	{
		neg = 1;
  800ea5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800eac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800eb2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800eb5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ec0:	99                   	cltd   
  800ec1:	f7 f9                	idiv   %ecx
  800ec3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ec6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec9:	8d 50 01             	lea    0x1(%eax),%edx
  800ecc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ecf:	89 c2                	mov    %eax,%edx
  800ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed4:	01 d0                	add    %edx,%eax
  800ed6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ed9:	83 c2 30             	add    $0x30,%edx
  800edc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ede:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ee1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ee6:	f7 e9                	imul   %ecx
  800ee8:	c1 fa 02             	sar    $0x2,%edx
  800eeb:	89 c8                	mov    %ecx,%eax
  800eed:	c1 f8 1f             	sar    $0x1f,%eax
  800ef0:	29 c2                	sub    %eax,%edx
  800ef2:	89 d0                	mov    %edx,%eax
  800ef4:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800ef7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800efb:	75 bb                	jne    800eb8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800efd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f04:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f07:	48                   	dec    %eax
  800f08:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f0f:	74 3d                	je     800f4e <ltostr+0xc3>
		start = 1 ;
  800f11:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f18:	eb 34                	jmp    800f4e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800f1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f20:	01 d0                	add    %edx,%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2d:	01 c2                	add    %eax,%edx
  800f2f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f35:	01 c8                	add    %ecx,%eax
  800f37:	8a 00                	mov    (%eax),%al
  800f39:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f41:	01 c2                	add    %eax,%edx
  800f43:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f46:	88 02                	mov    %al,(%edx)
		start++ ;
  800f48:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f4b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f51:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f54:	7c c4                	jl     800f1a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f56:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5c:	01 d0                	add    %edx,%eax
  800f5e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f61:	90                   	nop
  800f62:	c9                   	leave  
  800f63:	c3                   	ret    

00800f64 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f6a:	ff 75 08             	pushl  0x8(%ebp)
  800f6d:	e8 73 fa ff ff       	call   8009e5 <strlen>
  800f72:	83 c4 04             	add    $0x4,%esp
  800f75:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f78:	ff 75 0c             	pushl  0xc(%ebp)
  800f7b:	e8 65 fa ff ff       	call   8009e5 <strlen>
  800f80:	83 c4 04             	add    $0x4,%esp
  800f83:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f94:	eb 17                	jmp    800fad <strcconcat+0x49>
		final[s] = str1[s] ;
  800f96:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f99:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9c:	01 c2                	add    %eax,%edx
  800f9e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	01 c8                	add    %ecx,%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800faa:	ff 45 fc             	incl   -0x4(%ebp)
  800fad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fb3:	7c e1                	jl     800f96 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fb5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fbc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fc3:	eb 1f                	jmp    800fe4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc8:	8d 50 01             	lea    0x1(%eax),%edx
  800fcb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fce:	89 c2                	mov    %eax,%edx
  800fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd3:	01 c2                	add    %eax,%edx
  800fd5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdb:	01 c8                	add    %ecx,%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800fe1:	ff 45 f8             	incl   -0x8(%ebp)
  800fe4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fea:	7c d9                	jl     800fc5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800fec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fef:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff2:	01 d0                	add    %edx,%eax
  800ff4:	c6 00 00             	movb   $0x0,(%eax)
}
  800ff7:	90                   	nop
  800ff8:	c9                   	leave  
  800ff9:	c3                   	ret    

00800ffa <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800ffd:	8b 45 14             	mov    0x14(%ebp),%eax
  801000:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801006:	8b 45 14             	mov    0x14(%ebp),%eax
  801009:	8b 00                	mov    (%eax),%eax
  80100b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801012:	8b 45 10             	mov    0x10(%ebp),%eax
  801015:	01 d0                	add    %edx,%eax
  801017:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80101d:	eb 0c                	jmp    80102b <strsplit+0x31>
			*string++ = 0;
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	8d 50 01             	lea    0x1(%eax),%edx
  801025:	89 55 08             	mov    %edx,0x8(%ebp)
  801028:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	8a 00                	mov    (%eax),%al
  801030:	84 c0                	test   %al,%al
  801032:	74 18                	je     80104c <strsplit+0x52>
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
  801037:	8a 00                	mov    (%eax),%al
  801039:	0f be c0             	movsbl %al,%eax
  80103c:	50                   	push   %eax
  80103d:	ff 75 0c             	pushl  0xc(%ebp)
  801040:	e8 32 fb ff ff       	call   800b77 <strchr>
  801045:	83 c4 08             	add    $0x8,%esp
  801048:	85 c0                	test   %eax,%eax
  80104a:	75 d3                	jne    80101f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	8a 00                	mov    (%eax),%al
  801051:	84 c0                	test   %al,%al
  801053:	74 5a                	je     8010af <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801055:	8b 45 14             	mov    0x14(%ebp),%eax
  801058:	8b 00                	mov    (%eax),%eax
  80105a:	83 f8 0f             	cmp    $0xf,%eax
  80105d:	75 07                	jne    801066 <strsplit+0x6c>
		{
			return 0;
  80105f:	b8 00 00 00 00       	mov    $0x0,%eax
  801064:	eb 66                	jmp    8010cc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801066:	8b 45 14             	mov    0x14(%ebp),%eax
  801069:	8b 00                	mov    (%eax),%eax
  80106b:	8d 48 01             	lea    0x1(%eax),%ecx
  80106e:	8b 55 14             	mov    0x14(%ebp),%edx
  801071:	89 0a                	mov    %ecx,(%edx)
  801073:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80107a:	8b 45 10             	mov    0x10(%ebp),%eax
  80107d:	01 c2                	add    %eax,%edx
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801084:	eb 03                	jmp    801089 <strsplit+0x8f>
			string++;
  801086:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	8a 00                	mov    (%eax),%al
  80108e:	84 c0                	test   %al,%al
  801090:	74 8b                	je     80101d <strsplit+0x23>
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	8a 00                	mov    (%eax),%al
  801097:	0f be c0             	movsbl %al,%eax
  80109a:	50                   	push   %eax
  80109b:	ff 75 0c             	pushl  0xc(%ebp)
  80109e:	e8 d4 fa ff ff       	call   800b77 <strchr>
  8010a3:	83 c4 08             	add    $0x8,%esp
  8010a6:	85 c0                	test   %eax,%eax
  8010a8:	74 dc                	je     801086 <strsplit+0x8c>
			string++;
	}
  8010aa:	e9 6e ff ff ff       	jmp    80101d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010af:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b3:	8b 00                	mov    (%eax),%eax
  8010b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010bf:	01 d0                	add    %edx,%eax
  8010c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010c7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010cc:	c9                   	leave  
  8010cd:	c3                   	ret    

008010ce <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8010ce:	55                   	push   %ebp
  8010cf:	89 e5                	mov    %esp,%ebp
  8010d1:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8010d4:	83 ec 04             	sub    $0x4,%esp
  8010d7:	68 e8 39 80 00       	push   $0x8039e8
  8010dc:	68 3f 01 00 00       	push   $0x13f
  8010e1:	68 0a 3a 80 00       	push   $0x803a0a
  8010e6:	e8 f7 1f 00 00       	call   8030e2 <_panic>

008010eb <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  8010eb:	55                   	push   %ebp
  8010ec:	89 e5                	mov    %esp,%ebp
  8010ee:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8010f1:	83 ec 0c             	sub    $0xc,%esp
  8010f4:	ff 75 08             	pushl  0x8(%ebp)
  8010f7:	e8 90 0c 00 00       	call   801d8c <sys_sbrk>
  8010fc:	83 c4 10             	add    $0x10,%esp
}
  8010ff:	c9                   	leave  
  801100:	c3                   	ret    

00801101 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
  801104:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801107:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80110b:	75 0a                	jne    801117 <malloc+0x16>
		return NULL;
  80110d:	b8 00 00 00 00       	mov    $0x0,%eax
  801112:	e9 9e 01 00 00       	jmp    8012b5 <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801117:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80111e:	77 2c                	ja     80114c <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801120:	e8 eb 0a 00 00       	call   801c10 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801125:	85 c0                	test   %eax,%eax
  801127:	74 19                	je     801142 <malloc+0x41>

			void * block = alloc_block_FF(size);
  801129:	83 ec 0c             	sub    $0xc,%esp
  80112c:	ff 75 08             	pushl  0x8(%ebp)
  80112f:	e8 85 11 00 00       	call   8022b9 <alloc_block_FF>
  801134:	83 c4 10             	add    $0x10,%esp
  801137:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  80113a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80113d:	e9 73 01 00 00       	jmp    8012b5 <malloc+0x1b4>
		} else {
			return NULL;
  801142:	b8 00 00 00 00       	mov    $0x0,%eax
  801147:	e9 69 01 00 00       	jmp    8012b5 <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  80114c:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801153:	8b 55 08             	mov    0x8(%ebp),%edx
  801156:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801159:	01 d0                	add    %edx,%eax
  80115b:	48                   	dec    %eax
  80115c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80115f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801162:	ba 00 00 00 00       	mov    $0x0,%edx
  801167:	f7 75 e0             	divl   -0x20(%ebp)
  80116a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80116d:	29 d0                	sub    %edx,%eax
  80116f:	c1 e8 0c             	shr    $0xc,%eax
  801172:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  801175:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  80117c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801183:	a1 20 40 80 00       	mov    0x804020,%eax
  801188:	8b 40 7c             	mov    0x7c(%eax),%eax
  80118b:	05 00 10 00 00       	add    $0x1000,%eax
  801190:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801193:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801198:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80119b:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  80119e:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8011a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8011ab:	01 d0                	add    %edx,%eax
  8011ad:	48                   	dec    %eax
  8011ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8011b1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8011b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8011b9:	f7 75 cc             	divl   -0x34(%ebp)
  8011bc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8011bf:	29 d0                	sub    %edx,%eax
  8011c1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8011c4:	76 0a                	jbe    8011d0 <malloc+0xcf>
		return NULL;
  8011c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8011cb:	e9 e5 00 00 00       	jmp    8012b5 <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  8011d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8011d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011d6:	eb 48                	jmp    801220 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  8011d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011db:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8011de:	c1 e8 0c             	shr    $0xc,%eax
  8011e1:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  8011e4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8011e7:	8b 04 85 40 40 90 00 	mov    0x904040(,%eax,4),%eax
  8011ee:	85 c0                	test   %eax,%eax
  8011f0:	75 11                	jne    801203 <malloc+0x102>
			freePagesCount++;
  8011f2:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8011f5:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8011f9:	75 16                	jne    801211 <malloc+0x110>
				start = i;
  8011fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801201:	eb 0e                	jmp    801211 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801203:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80120a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801214:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801217:	74 12                	je     80122b <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801219:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801220:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801227:	76 af                	jbe    8011d8 <malloc+0xd7>
  801229:	eb 01                	jmp    80122c <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  80122b:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  80122c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801230:	74 08                	je     80123a <malloc+0x139>
  801232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801235:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801238:	74 07                	je     801241 <malloc+0x140>
		return NULL;
  80123a:	b8 00 00 00 00       	mov    $0x0,%eax
  80123f:	eb 74                	jmp    8012b5 <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801241:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801244:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801247:	c1 e8 0c             	shr    $0xc,%eax
  80124a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  80124d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801250:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801253:	89 14 85 40 40 80 00 	mov    %edx,0x804040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  80125a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80125d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801260:	eb 11                	jmp    801273 <malloc+0x172>
		markedPages[i] = 1;
  801262:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801265:	c7 04 85 40 40 90 00 	movl   $0x1,0x904040(,%eax,4)
  80126c:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801270:	ff 45 e8             	incl   -0x18(%ebp)
  801273:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801276:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801279:	01 d0                	add    %edx,%eax
  80127b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80127e:	77 e2                	ja     801262 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801280:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801287:	8b 55 08             	mov    0x8(%ebp),%edx
  80128a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80128d:	01 d0                	add    %edx,%eax
  80128f:	48                   	dec    %eax
  801290:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801293:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801296:	ba 00 00 00 00       	mov    $0x0,%edx
  80129b:	f7 75 bc             	divl   -0x44(%ebp)
  80129e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8012a1:	29 d0                	sub    %edx,%eax
  8012a3:	83 ec 08             	sub    $0x8,%esp
  8012a6:	50                   	push   %eax
  8012a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8012aa:	e8 14 0b 00 00       	call   801dc3 <sys_allocate_user_mem>
  8012af:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  8012b2:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  8012b5:	c9                   	leave  
  8012b6:	c3                   	ret    

008012b7 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
  8012ba:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  8012bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012c1:	0f 84 ee 00 00 00    	je     8013b5 <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  8012c7:	a1 20 40 80 00       	mov    0x804020,%eax
  8012cc:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  8012cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8012d2:	77 09                	ja     8012dd <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  8012d4:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  8012db:	76 14                	jbe    8012f1 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  8012dd:	83 ec 04             	sub    $0x4,%esp
  8012e0:	68 18 3a 80 00       	push   $0x803a18
  8012e5:	6a 68                	push   $0x68
  8012e7:	68 32 3a 80 00       	push   $0x803a32
  8012ec:	e8 f1 1d 00 00       	call   8030e2 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  8012f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8012f6:	8b 40 74             	mov    0x74(%eax),%eax
  8012f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8012fc:	77 20                	ja     80131e <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  8012fe:	a1 20 40 80 00       	mov    0x804020,%eax
  801303:	8b 40 78             	mov    0x78(%eax),%eax
  801306:	3b 45 08             	cmp    0x8(%ebp),%eax
  801309:	76 13                	jbe    80131e <free+0x67>
		free_block(virtual_address);
  80130b:	83 ec 0c             	sub    $0xc,%esp
  80130e:	ff 75 08             	pushl  0x8(%ebp)
  801311:	e8 6c 16 00 00       	call   802982 <free_block>
  801316:	83 c4 10             	add    $0x10,%esp
		return;
  801319:	e9 98 00 00 00       	jmp    8013b6 <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  80131e:	8b 55 08             	mov    0x8(%ebp),%edx
  801321:	a1 20 40 80 00       	mov    0x804020,%eax
  801326:	8b 40 7c             	mov    0x7c(%eax),%eax
  801329:	29 c2                	sub    %eax,%edx
  80132b:	89 d0                	mov    %edx,%eax
  80132d:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801332:	c1 e8 0c             	shr    $0xc,%eax
  801335:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801338:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80133f:	eb 16                	jmp    801357 <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801341:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801344:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801347:	01 d0                	add    %edx,%eax
  801349:	c7 04 85 40 40 90 00 	movl   $0x0,0x904040(,%eax,4)
  801350:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801354:	ff 45 f4             	incl   -0xc(%ebp)
  801357:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80135a:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801361:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801364:	7f db                	jg     801341 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  801366:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801369:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801370:	c1 e0 0c             	shl    $0xc,%eax
  801373:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  801376:	8b 45 08             	mov    0x8(%ebp),%eax
  801379:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80137c:	eb 1a                	jmp    801398 <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  80137e:	83 ec 08             	sub    $0x8,%esp
  801381:	68 00 10 00 00       	push   $0x1000
  801386:	ff 75 f0             	pushl  -0x10(%ebp)
  801389:	e8 19 0a 00 00       	call   801da7 <sys_free_user_mem>
  80138e:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801391:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801398:	8b 55 08             	mov    0x8(%ebp),%edx
  80139b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80139e:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  8013a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013a3:	77 d9                	ja     80137e <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  8013a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013a8:	c7 04 85 40 40 80 00 	movl   $0x0,0x804040(,%eax,4)
  8013af:	00 00 00 00 
  8013b3:	eb 01                	jmp    8013b6 <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  8013b5:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  8013b6:	c9                   	leave  
  8013b7:	c3                   	ret    

008013b8 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
  8013bb:	83 ec 58             	sub    $0x58,%esp
  8013be:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c1:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8013c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013c8:	75 0a                	jne    8013d4 <smalloc+0x1c>
		return NULL;
  8013ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8013cf:	e9 7d 01 00 00       	jmp    801551 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8013d4:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8013db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013e1:	01 d0                	add    %edx,%eax
  8013e3:	48                   	dec    %eax
  8013e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ef:	f7 75 e4             	divl   -0x1c(%ebp)
  8013f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013f5:	29 d0                	sub    %edx,%eax
  8013f7:	c1 e8 0c             	shr    $0xc,%eax
  8013fa:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  8013fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801404:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  80140b:	a1 20 40 80 00       	mov    0x804020,%eax
  801410:	8b 40 7c             	mov    0x7c(%eax),%eax
  801413:	05 00 10 00 00       	add    $0x1000,%eax
  801418:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  80141b:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801420:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801423:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801426:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80142d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801430:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801433:	01 d0                	add    %edx,%eax
  801435:	48                   	dec    %eax
  801436:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801439:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80143c:	ba 00 00 00 00       	mov    $0x0,%edx
  801441:	f7 75 d0             	divl   -0x30(%ebp)
  801444:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801447:	29 d0                	sub    %edx,%eax
  801449:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80144c:	76 0a                	jbe    801458 <smalloc+0xa0>
		return NULL;
  80144e:	b8 00 00 00 00       	mov    $0x0,%eax
  801453:	e9 f9 00 00 00       	jmp    801551 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801458:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80145b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80145e:	eb 48                	jmp    8014a8 <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801460:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801463:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801466:	c1 e8 0c             	shr    $0xc,%eax
  801469:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  80146c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80146f:	8b 04 85 40 40 90 00 	mov    0x904040(,%eax,4),%eax
  801476:	85 c0                	test   %eax,%eax
  801478:	75 11                	jne    80148b <smalloc+0xd3>
			freePagesCount++;
  80147a:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  80147d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801481:	75 16                	jne    801499 <smalloc+0xe1>
				start = s;
  801483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801486:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801489:	eb 0e                	jmp    801499 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  80148b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801492:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  801499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80149c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80149f:	74 12                	je     8014b3 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8014a1:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8014a8:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8014af:	76 af                	jbe    801460 <smalloc+0xa8>
  8014b1:	eb 01                	jmp    8014b4 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  8014b3:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  8014b4:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8014b8:	74 08                	je     8014c2 <smalloc+0x10a>
  8014ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8014c0:	74 0a                	je     8014cc <smalloc+0x114>
		return NULL;
  8014c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c7:	e9 85 00 00 00       	jmp    801551 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8014cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014cf:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8014d2:	c1 e8 0c             	shr    $0xc,%eax
  8014d5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  8014d8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014db:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8014de:	89 14 85 40 40 80 00 	mov    %edx,0x804040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8014e5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8014e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8014eb:	eb 11                	jmp    8014fe <smalloc+0x146>
		markedPages[s] = 1;
  8014ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014f0:	c7 04 85 40 40 90 00 	movl   $0x1,0x904040(,%eax,4)
  8014f7:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8014fb:	ff 45 e8             	incl   -0x18(%ebp)
  8014fe:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801501:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801504:	01 d0                	add    %edx,%eax
  801506:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801509:	77 e2                	ja     8014ed <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  80150b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80150e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801512:	52                   	push   %edx
  801513:	50                   	push   %eax
  801514:	ff 75 0c             	pushl  0xc(%ebp)
  801517:	ff 75 08             	pushl  0x8(%ebp)
  80151a:	e8 8f 04 00 00       	call   8019ae <sys_createSharedObject>
  80151f:	83 c4 10             	add    $0x10,%esp
  801522:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  801525:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  801529:	78 12                	js     80153d <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  80152b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80152e:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801531:	89 14 85 40 40 88 00 	mov    %edx,0x884040(,%eax,4)
		return (void*) start;
  801538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153b:	eb 14                	jmp    801551 <smalloc+0x199>
	}
	free((void*) start);
  80153d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801540:	83 ec 0c             	sub    $0xc,%esp
  801543:	50                   	push   %eax
  801544:	e8 6e fd ff ff       	call   8012b7 <free>
  801549:	83 c4 10             	add    $0x10,%esp
	return NULL;
  80154c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801551:	c9                   	leave  
  801552:	c3                   	ret    

00801553 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  801559:	83 ec 08             	sub    $0x8,%esp
  80155c:	ff 75 0c             	pushl  0xc(%ebp)
  80155f:	ff 75 08             	pushl  0x8(%ebp)
  801562:	e8 71 04 00 00       	call   8019d8 <sys_getSizeOfSharedObject>
  801567:	83 c4 10             	add    $0x10,%esp
  80156a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  80156d:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801574:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801577:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80157a:	01 d0                	add    %edx,%eax
  80157c:	48                   	dec    %eax
  80157d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801580:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801583:	ba 00 00 00 00       	mov    $0x0,%edx
  801588:	f7 75 e0             	divl   -0x20(%ebp)
  80158b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80158e:	29 d0                	sub    %edx,%eax
  801590:	c1 e8 0c             	shr    $0xc,%eax
  801593:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  801596:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  80159d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  8015a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8015a9:	8b 40 7c             	mov    0x7c(%eax),%eax
  8015ac:	05 00 10 00 00       	add    $0x1000,%eax
  8015b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  8015b4:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8015b9:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8015bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  8015bf:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8015c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8015cc:	01 d0                	add    %edx,%eax
  8015ce:	48                   	dec    %eax
  8015cf:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8015d2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8015d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015da:	f7 75 cc             	divl   -0x34(%ebp)
  8015dd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8015e0:	29 d0                	sub    %edx,%eax
  8015e2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8015e5:	76 0a                	jbe    8015f1 <sget+0x9e>
		return NULL;
  8015e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ec:	e9 f7 00 00 00       	jmp    8016e8 <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8015f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8015f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015f7:	eb 48                	jmp    801641 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  8015f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015fc:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8015ff:	c1 e8 0c             	shr    $0xc,%eax
  801602:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  801605:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801608:	8b 04 85 40 40 90 00 	mov    0x904040(,%eax,4),%eax
  80160f:	85 c0                	test   %eax,%eax
  801611:	75 11                	jne    801624 <sget+0xd1>
			free_Pages_Count++;
  801613:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801616:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80161a:	75 16                	jne    801632 <sget+0xdf>
				start = s;
  80161c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80161f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801622:	eb 0e                	jmp    801632 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  801624:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80162b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  801632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801635:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801638:	74 12                	je     80164c <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80163a:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801641:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801648:	76 af                	jbe    8015f9 <sget+0xa6>
  80164a:	eb 01                	jmp    80164d <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  80164c:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  80164d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801651:	74 08                	je     80165b <sget+0x108>
  801653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801656:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801659:	74 0a                	je     801665 <sget+0x112>
		return NULL;
  80165b:	b8 00 00 00 00       	mov    $0x0,%eax
  801660:	e9 83 00 00 00       	jmp    8016e8 <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  801665:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801668:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80166b:	c1 e8 0c             	shr    $0xc,%eax
  80166e:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  801671:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801674:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801677:	89 14 85 40 40 80 00 	mov    %edx,0x804040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  80167e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801681:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801684:	eb 11                	jmp    801697 <sget+0x144>
		markedPages[k] = 1;
  801686:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801689:	c7 04 85 40 40 90 00 	movl   $0x1,0x904040(,%eax,4)
  801690:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801694:	ff 45 e8             	incl   -0x18(%ebp)
  801697:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80169a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80169d:	01 d0                	add    %edx,%eax
  80169f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8016a2:	77 e2                	ja     801686 <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  8016a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a7:	83 ec 04             	sub    $0x4,%esp
  8016aa:	50                   	push   %eax
  8016ab:	ff 75 0c             	pushl  0xc(%ebp)
  8016ae:	ff 75 08             	pushl  0x8(%ebp)
  8016b1:	e8 3f 03 00 00       	call   8019f5 <sys_getSharedObject>
  8016b6:	83 c4 10             	add    $0x10,%esp
  8016b9:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  8016bc:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  8016c0:	78 12                	js     8016d4 <sget+0x181>
		shardIDs[startPage] = ss;
  8016c2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8016c5:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8016c8:	89 14 85 40 40 88 00 	mov    %edx,0x884040(,%eax,4)
		return (void*) start;
  8016cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d2:	eb 14                	jmp    8016e8 <sget+0x195>
	}
	free((void*) start);
  8016d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d7:	83 ec 0c             	sub    $0xc,%esp
  8016da:	50                   	push   %eax
  8016db:	e8 d7 fb ff ff       	call   8012b7 <free>
  8016e0:	83 c4 10             	add    $0x10,%esp
	return NULL;
  8016e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    

008016ea <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
  8016ed:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8016f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8016f3:	a1 20 40 80 00       	mov    0x804020,%eax
  8016f8:	8b 40 7c             	mov    0x7c(%eax),%eax
  8016fb:	29 c2                	sub    %eax,%edx
  8016fd:	89 d0                	mov    %edx,%eax
  8016ff:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  801704:	c1 e8 0c             	shr    $0xc,%eax
  801707:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  80170a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170d:	8b 04 85 40 40 88 00 	mov    0x884040(,%eax,4),%eax
  801714:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  801717:	83 ec 08             	sub    $0x8,%esp
  80171a:	ff 75 08             	pushl  0x8(%ebp)
  80171d:	ff 75 f0             	pushl  -0x10(%ebp)
  801720:	e8 ef 02 00 00       	call   801a14 <sys_freeSharedObject>
  801725:	83 c4 10             	add    $0x10,%esp
  801728:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  80172b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80172f:	75 0e                	jne    80173f <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  801731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801734:	c7 04 85 40 40 88 00 	movl   $0xffffffff,0x884040(,%eax,4)
  80173b:	ff ff ff ff 
	}

}
  80173f:	90                   	nop
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801748:	83 ec 04             	sub    $0x4,%esp
  80174b:	68 40 3a 80 00       	push   $0x803a40
  801750:	68 19 01 00 00       	push   $0x119
  801755:	68 32 3a 80 00       	push   $0x803a32
  80175a:	e8 83 19 00 00       	call   8030e2 <_panic>

0080175f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801765:	83 ec 04             	sub    $0x4,%esp
  801768:	68 66 3a 80 00       	push   $0x803a66
  80176d:	68 23 01 00 00       	push   $0x123
  801772:	68 32 3a 80 00       	push   $0x803a32
  801777:	e8 66 19 00 00       	call   8030e2 <_panic>

0080177c <shrink>:

}
void shrink(uint32 newSize) {
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
  80177f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801782:	83 ec 04             	sub    $0x4,%esp
  801785:	68 66 3a 80 00       	push   $0x803a66
  80178a:	68 27 01 00 00       	push   $0x127
  80178f:	68 32 3a 80 00       	push   $0x803a32
  801794:	e8 49 19 00 00       	call   8030e2 <_panic>

00801799 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801799:	55                   	push   %ebp
  80179a:	89 e5                	mov    %esp,%ebp
  80179c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80179f:	83 ec 04             	sub    $0x4,%esp
  8017a2:	68 66 3a 80 00       	push   $0x803a66
  8017a7:	68 2b 01 00 00       	push   $0x12b
  8017ac:	68 32 3a 80 00       	push   $0x803a32
  8017b1:	e8 2c 19 00 00       	call   8030e2 <_panic>

008017b6 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	57                   	push   %edi
  8017ba:	56                   	push   %esi
  8017bb:	53                   	push   %ebx
  8017bc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017c8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017cb:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017ce:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017d1:	cd 30                	int    $0x30
  8017d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  8017d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017d9:	83 c4 10             	add    $0x10,%esp
  8017dc:	5b                   	pop    %ebx
  8017dd:	5e                   	pop    %esi
  8017de:	5f                   	pop    %edi
  8017df:	5d                   	pop    %ebp
  8017e0:	c3                   	ret    

008017e1 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	83 ec 04             	sub    $0x4,%esp
  8017e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8017ed:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	52                   	push   %edx
  8017f9:	ff 75 0c             	pushl  0xc(%ebp)
  8017fc:	50                   	push   %eax
  8017fd:	6a 00                	push   $0x0
  8017ff:	e8 b2 ff ff ff       	call   8017b6 <syscall>
  801804:	83 c4 18             	add    $0x18,%esp
}
  801807:	90                   	nop
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <sys_cgetc>:

int sys_cgetc(void) {
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 02                	push   $0x2
  801819:	e8 98 ff ff ff       	call   8017b6 <syscall>
  80181e:	83 c4 18             	add    $0x18,%esp
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <sys_lock_cons>:

void sys_lock_cons(void) {
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 03                	push   $0x3
  801832:	e8 7f ff ff ff       	call   8017b6 <syscall>
  801837:	83 c4 18             	add    $0x18,%esp
}
  80183a:	90                   	nop
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <sys_unlock_cons>:
void sys_unlock_cons(void) {
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 04                	push   $0x4
  80184c:	e8 65 ff ff ff       	call   8017b6 <syscall>
  801851:	83 c4 18             	add    $0x18,%esp
}
  801854:	90                   	nop
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  80185a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185d:	8b 45 08             	mov    0x8(%ebp),%eax
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	52                   	push   %edx
  801867:	50                   	push   %eax
  801868:	6a 08                	push   $0x8
  80186a:	e8 47 ff ff ff       	call   8017b6 <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
}
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
  801877:	56                   	push   %esi
  801878:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801879:	8b 75 18             	mov    0x18(%ebp),%esi
  80187c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80187f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801882:	8b 55 0c             	mov    0xc(%ebp),%edx
  801885:	8b 45 08             	mov    0x8(%ebp),%eax
  801888:	56                   	push   %esi
  801889:	53                   	push   %ebx
  80188a:	51                   	push   %ecx
  80188b:	52                   	push   %edx
  80188c:	50                   	push   %eax
  80188d:	6a 09                	push   $0x9
  80188f:	e8 22 ff ff ff       	call   8017b6 <syscall>
  801894:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801897:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80189a:	5b                   	pop    %ebx
  80189b:	5e                   	pop    %esi
  80189c:	5d                   	pop    %ebp
  80189d:	c3                   	ret    

0080189e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	52                   	push   %edx
  8018ae:	50                   	push   %eax
  8018af:	6a 0a                	push   $0xa
  8018b1:	e8 00 ff ff ff       	call   8017b6 <syscall>
  8018b6:	83 c4 18             	add    $0x18,%esp
}
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	ff 75 0c             	pushl  0xc(%ebp)
  8018c7:	ff 75 08             	pushl  0x8(%ebp)
  8018ca:	6a 0b                	push   $0xb
  8018cc:	e8 e5 fe ff ff       	call   8017b6 <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 0c                	push   $0xc
  8018e5:	e8 cc fe ff ff       	call   8017b6 <syscall>
  8018ea:	83 c4 18             	add    $0x18,%esp
}
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 0d                	push   $0xd
  8018fe:	e8 b3 fe ff ff       	call   8017b6 <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 0e                	push   $0xe
  801917:	e8 9a fe ff ff       	call   8017b6 <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 0f                	push   $0xf
  801930:	e8 81 fe ff ff       	call   8017b6 <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	ff 75 08             	pushl  0x8(%ebp)
  801948:	6a 10                	push   $0x10
  80194a:	e8 67 fe ff ff       	call   8017b6 <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801952:	c9                   	leave  
  801953:	c3                   	ret    

00801954 <sys_scarce_memory>:

void sys_scarce_memory() {
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 11                	push   $0x11
  801963:	e8 4e fe ff ff       	call   8017b6 <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
}
  80196b:	90                   	nop
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <sys_cputc>:

void sys_cputc(const char c) {
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	83 ec 04             	sub    $0x4,%esp
  801974:	8b 45 08             	mov    0x8(%ebp),%eax
  801977:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80197a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	50                   	push   %eax
  801987:	6a 01                	push   $0x1
  801989:	e8 28 fe ff ff       	call   8017b6 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
}
  801991:	90                   	nop
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 14                	push   $0x14
  8019a3:	e8 0e fe ff ff       	call   8017b6 <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	90                   	nop
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
  8019b1:	83 ec 04             	sub    $0x4,%esp
  8019b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  8019ba:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019bd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c4:	6a 00                	push   $0x0
  8019c6:	51                   	push   %ecx
  8019c7:	52                   	push   %edx
  8019c8:	ff 75 0c             	pushl  0xc(%ebp)
  8019cb:	50                   	push   %eax
  8019cc:	6a 15                	push   $0x15
  8019ce:	e8 e3 fd ff ff       	call   8017b6 <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  8019db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019de:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	52                   	push   %edx
  8019e8:	50                   	push   %eax
  8019e9:	6a 16                	push   $0x16
  8019eb:	e8 c6 fd ff ff       	call   8017b6 <syscall>
  8019f0:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  8019f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	51                   	push   %ecx
  801a06:	52                   	push   %edx
  801a07:	50                   	push   %eax
  801a08:	6a 17                	push   $0x17
  801a0a:	e8 a7 fd ff ff       	call   8017b6 <syscall>
  801a0f:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801a17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	52                   	push   %edx
  801a24:	50                   	push   %eax
  801a25:	6a 18                	push   $0x18
  801a27:	e8 8a fd ff ff       	call   8017b6 <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	6a 00                	push   $0x0
  801a39:	ff 75 14             	pushl  0x14(%ebp)
  801a3c:	ff 75 10             	pushl  0x10(%ebp)
  801a3f:	ff 75 0c             	pushl  0xc(%ebp)
  801a42:	50                   	push   %eax
  801a43:	6a 19                	push   $0x19
  801a45:	e8 6c fd ff ff       	call   8017b6 <syscall>
  801a4a:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <sys_run_env>:

void sys_run_env(int32 envId) {
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801a52:	8b 45 08             	mov    0x8(%ebp),%eax
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	50                   	push   %eax
  801a5e:	6a 1a                	push   $0x1a
  801a60:	e8 51 fd ff ff       	call   8017b6 <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	90                   	nop
  801a69:	c9                   	leave  
  801a6a:	c3                   	ret    

00801a6b <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	50                   	push   %eax
  801a7a:	6a 1b                	push   $0x1b
  801a7c:	e8 35 fd ff ff       	call   8017b6 <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sys_getenvid>:

int32 sys_getenvid(void) {
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 05                	push   $0x5
  801a95:	e8 1c fd ff ff       	call   8017b6 <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
}
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 06                	push   $0x6
  801aae:	e8 03 fd ff ff       	call   8017b6 <syscall>
  801ab3:	83 c4 18             	add    $0x18,%esp
}
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 07                	push   $0x7
  801ac7:	e8 ea fc ff ff       	call   8017b6 <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
}
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <sys_exit_env>:

void sys_exit_env(void) {
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 1c                	push   $0x1c
  801ae0:	e8 d1 fc ff ff       	call   8017b6 <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
}
  801ae8:	90                   	nop
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801af1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801af4:	8d 50 04             	lea    0x4(%eax),%edx
  801af7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	52                   	push   %edx
  801b01:	50                   	push   %eax
  801b02:	6a 1d                	push   $0x1d
  801b04:	e8 ad fc ff ff       	call   8017b6 <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801b0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b12:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b15:	89 01                	mov    %eax,(%ecx)
  801b17:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1d:	c9                   	leave  
  801b1e:	c2 04 00             	ret    $0x4

00801b21 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	ff 75 10             	pushl  0x10(%ebp)
  801b2b:	ff 75 0c             	pushl  0xc(%ebp)
  801b2e:	ff 75 08             	pushl  0x8(%ebp)
  801b31:	6a 13                	push   $0x13
  801b33:	e8 7e fc ff ff       	call   8017b6 <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801b3b:	90                   	nop
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <sys_rcr2>:
uint32 sys_rcr2() {
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 1e                	push   $0x1e
  801b4d:	e8 64 fc ff ff       	call   8017b6 <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
  801b5a:	83 ec 04             	sub    $0x4,%esp
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b63:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	50                   	push   %eax
  801b70:	6a 1f                	push   $0x1f
  801b72:	e8 3f fc ff ff       	call   8017b6 <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
	return;
  801b7a:	90                   	nop
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <rsttst>:
void rsttst() {
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 21                	push   $0x21
  801b8c:	e8 25 fc ff ff       	call   8017b6 <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
	return;
  801b94:	90                   	nop
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	83 ec 04             	sub    $0x4,%esp
  801b9d:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ba3:	8b 55 18             	mov    0x18(%ebp),%edx
  801ba6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801baa:	52                   	push   %edx
  801bab:	50                   	push   %eax
  801bac:	ff 75 10             	pushl  0x10(%ebp)
  801baf:	ff 75 0c             	pushl  0xc(%ebp)
  801bb2:	ff 75 08             	pushl  0x8(%ebp)
  801bb5:	6a 20                	push   $0x20
  801bb7:	e8 fa fb ff ff       	call   8017b6 <syscall>
  801bbc:	83 c4 18             	add    $0x18,%esp
	return;
  801bbf:	90                   	nop
}
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <chktst>:
void chktst(uint32 n) {
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	ff 75 08             	pushl  0x8(%ebp)
  801bd0:	6a 22                	push   $0x22
  801bd2:	e8 df fb ff ff       	call   8017b6 <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
	return;
  801bda:	90                   	nop
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <inctst>:

void inctst() {
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 23                	push   $0x23
  801bec:	e8 c5 fb ff ff       	call   8017b6 <syscall>
  801bf1:	83 c4 18             	add    $0x18,%esp
	return;
  801bf4:	90                   	nop
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <gettst>:
uint32 gettst() {
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 24                	push   $0x24
  801c06:	e8 ab fb ff ff       	call   8017b6 <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
}
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 25                	push   $0x25
  801c22:	e8 8f fb ff ff       	call   8017b6 <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
  801c2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c2d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c31:	75 07                	jne    801c3a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c33:	b8 01 00 00 00       	mov    $0x1,%eax
  801c38:	eb 05                	jmp    801c3f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
  801c44:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 25                	push   $0x25
  801c53:	e8 5e fb ff ff       	call   8017b6 <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
  801c5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c5e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c62:	75 07                	jne    801c6b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c64:	b8 01 00 00 00       	mov    $0x1,%eax
  801c69:	eb 05                	jmp    801c70 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c70:	c9                   	leave  
  801c71:	c3                   	ret    

00801c72 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
  801c75:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 25                	push   $0x25
  801c84:	e8 2d fb ff ff       	call   8017b6 <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
  801c8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c8f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c93:	75 07                	jne    801c9c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c95:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9a:	eb 05                	jmp    801ca1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 25                	push   $0x25
  801cb5:	e8 fc fa ff ff       	call   8017b6 <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
  801cbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cc0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cc4:	75 07                	jne    801ccd <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ccb:	eb 05                	jmp    801cd2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ccd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	ff 75 08             	pushl  0x8(%ebp)
  801ce2:	6a 26                	push   $0x26
  801ce4:	e8 cd fa ff ff       	call   8017b6 <syscall>
  801ce9:	83 c4 18             	add    $0x18,%esp
	return;
  801cec:	90                   	nop
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801cf3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cf6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cff:	6a 00                	push   $0x0
  801d01:	53                   	push   %ebx
  801d02:	51                   	push   %ecx
  801d03:	52                   	push   %edx
  801d04:	50                   	push   %eax
  801d05:	6a 27                	push   $0x27
  801d07:	e8 aa fa ff ff       	call   8017b6 <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801d0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801d17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	52                   	push   %edx
  801d24:	50                   	push   %eax
  801d25:	6a 28                	push   $0x28
  801d27:	e8 8a fa ff ff       	call   8017b6 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801d2f:	c9                   	leave  
  801d30:	c3                   	ret    

00801d31 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801d34:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3d:	6a 00                	push   $0x0
  801d3f:	51                   	push   %ecx
  801d40:	ff 75 10             	pushl  0x10(%ebp)
  801d43:	52                   	push   %edx
  801d44:	50                   	push   %eax
  801d45:	6a 29                	push   $0x29
  801d47:	e8 6a fa ff ff       	call   8017b6 <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	ff 75 10             	pushl  0x10(%ebp)
  801d5b:	ff 75 0c             	pushl  0xc(%ebp)
  801d5e:	ff 75 08             	pushl  0x8(%ebp)
  801d61:	6a 12                	push   $0x12
  801d63:	e8 4e fa ff ff       	call   8017b6 <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
	return;
  801d6b:	90                   	nop
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801d71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	52                   	push   %edx
  801d7e:	50                   	push   %eax
  801d7f:	6a 2a                	push   $0x2a
  801d81:	e8 30 fa ff ff       	call   8017b6 <syscall>
  801d86:	83 c4 18             	add    $0x18,%esp
	return;
  801d89:	90                   	nop
}
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	50                   	push   %eax
  801d9b:	6a 2b                	push   $0x2b
  801d9d:	e8 14 fa ff ff       	call   8017b6 <syscall>
  801da2:	83 c4 18             	add    $0x18,%esp
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	ff 75 0c             	pushl  0xc(%ebp)
  801db3:	ff 75 08             	pushl  0x8(%ebp)
  801db6:	6a 2c                	push   $0x2c
  801db8:	e8 f9 f9 ff ff       	call   8017b6 <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
	return;
  801dc0:	90                   	nop
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	ff 75 0c             	pushl  0xc(%ebp)
  801dcf:	ff 75 08             	pushl  0x8(%ebp)
  801dd2:	6a 2d                	push   $0x2d
  801dd4:	e8 dd f9 ff ff       	call   8017b6 <syscall>
  801dd9:	83 c4 18             	add    $0x18,%esp
	return;
  801ddc:	90                   	nop
}
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801de2:	8b 45 08             	mov    0x8(%ebp),%eax
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	50                   	push   %eax
  801dee:	6a 2f                	push   $0x2f
  801df0:	e8 c1 f9 ff ff       	call   8017b6 <syscall>
  801df5:	83 c4 18             	add    $0x18,%esp
	return;
  801df8:	90                   	nop
}
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    

00801dfb <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  801dfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e01:	8b 45 08             	mov    0x8(%ebp),%eax
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	52                   	push   %edx
  801e0b:	50                   	push   %eax
  801e0c:	6a 30                	push   $0x30
  801e0e:	e8 a3 f9 ff ff       	call   8017b6 <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
	return;
  801e16:	90                   	nop
}
  801e17:	c9                   	leave  
  801e18:	c3                   	ret    

00801e19 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  801e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	50                   	push   %eax
  801e28:	6a 31                	push   $0x31
  801e2a:	e8 87 f9 ff ff       	call   8017b6 <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
	return;
  801e32:	90                   	nop
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801e38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	52                   	push   %edx
  801e45:	50                   	push   %eax
  801e46:	6a 2e                	push   $0x2e
  801e48:	e8 69 f9 ff ff       	call   8017b6 <syscall>
  801e4d:	83 c4 18             	add    $0x18,%esp
    return;
  801e50:	90                   	nop
}
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
  801e56:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e59:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5c:	83 e8 04             	sub    $0x4,%eax
  801e5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801e62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e65:	8b 00                	mov    (%eax),%eax
  801e67:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e72:	8b 45 08             	mov    0x8(%ebp),%eax
  801e75:	83 e8 04             	sub    $0x4,%eax
  801e78:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801e7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e7e:	8b 00                	mov    (%eax),%eax
  801e80:	83 e0 01             	and    $0x1,%eax
  801e83:	85 c0                	test   %eax,%eax
  801e85:	0f 94 c0             	sete   %al
}
  801e88:	c9                   	leave  
  801e89:	c3                   	ret    

00801e8a <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
  801e8d:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801e90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9a:	83 f8 02             	cmp    $0x2,%eax
  801e9d:	74 2b                	je     801eca <alloc_block+0x40>
  801e9f:	83 f8 02             	cmp    $0x2,%eax
  801ea2:	7f 07                	jg     801eab <alloc_block+0x21>
  801ea4:	83 f8 01             	cmp    $0x1,%eax
  801ea7:	74 0e                	je     801eb7 <alloc_block+0x2d>
  801ea9:	eb 58                	jmp    801f03 <alloc_block+0x79>
  801eab:	83 f8 03             	cmp    $0x3,%eax
  801eae:	74 2d                	je     801edd <alloc_block+0x53>
  801eb0:	83 f8 04             	cmp    $0x4,%eax
  801eb3:	74 3b                	je     801ef0 <alloc_block+0x66>
  801eb5:	eb 4c                	jmp    801f03 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801eb7:	83 ec 0c             	sub    $0xc,%esp
  801eba:	ff 75 08             	pushl  0x8(%ebp)
  801ebd:	e8 f7 03 00 00       	call   8022b9 <alloc_block_FF>
  801ec2:	83 c4 10             	add    $0x10,%esp
  801ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ec8:	eb 4a                	jmp    801f14 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801eca:	83 ec 0c             	sub    $0xc,%esp
  801ecd:	ff 75 08             	pushl  0x8(%ebp)
  801ed0:	e8 f0 11 00 00       	call   8030c5 <alloc_block_NF>
  801ed5:	83 c4 10             	add    $0x10,%esp
  801ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801edb:	eb 37                	jmp    801f14 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801edd:	83 ec 0c             	sub    $0xc,%esp
  801ee0:	ff 75 08             	pushl  0x8(%ebp)
  801ee3:	e8 08 08 00 00       	call   8026f0 <alloc_block_BF>
  801ee8:	83 c4 10             	add    $0x10,%esp
  801eeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801eee:	eb 24                	jmp    801f14 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801ef0:	83 ec 0c             	sub    $0xc,%esp
  801ef3:	ff 75 08             	pushl  0x8(%ebp)
  801ef6:	e8 ad 11 00 00       	call   8030a8 <alloc_block_WF>
  801efb:	83 c4 10             	add    $0x10,%esp
  801efe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f01:	eb 11                	jmp    801f14 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f03:	83 ec 0c             	sub    $0xc,%esp
  801f06:	68 78 3a 80 00       	push   $0x803a78
  801f0b:	e8 41 e4 ff ff       	call   800351 <cprintf>
  801f10:	83 c4 10             	add    $0x10,%esp
		break;
  801f13:	90                   	nop
	}
	return va;
  801f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
  801f1c:	53                   	push   %ebx
  801f1d:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801f20:	83 ec 0c             	sub    $0xc,%esp
  801f23:	68 98 3a 80 00       	push   $0x803a98
  801f28:	e8 24 e4 ff ff       	call   800351 <cprintf>
  801f2d:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801f30:	83 ec 0c             	sub    $0xc,%esp
  801f33:	68 c3 3a 80 00       	push   $0x803ac3
  801f38:	e8 14 e4 ff ff       	call   800351 <cprintf>
  801f3d:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801f40:	8b 45 08             	mov    0x8(%ebp),%eax
  801f43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f46:	eb 37                	jmp    801f7f <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801f48:	83 ec 0c             	sub    $0xc,%esp
  801f4b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f4e:	e8 19 ff ff ff       	call   801e6c <is_free_block>
  801f53:	83 c4 10             	add    $0x10,%esp
  801f56:	0f be d8             	movsbl %al,%ebx
  801f59:	83 ec 0c             	sub    $0xc,%esp
  801f5c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f5f:	e8 ef fe ff ff       	call   801e53 <get_block_size>
  801f64:	83 c4 10             	add    $0x10,%esp
  801f67:	83 ec 04             	sub    $0x4,%esp
  801f6a:	53                   	push   %ebx
  801f6b:	50                   	push   %eax
  801f6c:	68 db 3a 80 00       	push   $0x803adb
  801f71:	e8 db e3 ff ff       	call   800351 <cprintf>
  801f76:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801f79:	8b 45 10             	mov    0x10(%ebp),%eax
  801f7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f83:	74 07                	je     801f8c <print_blocks_list+0x73>
  801f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f88:	8b 00                	mov    (%eax),%eax
  801f8a:	eb 05                	jmp    801f91 <print_blocks_list+0x78>
  801f8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f91:	89 45 10             	mov    %eax,0x10(%ebp)
  801f94:	8b 45 10             	mov    0x10(%ebp),%eax
  801f97:	85 c0                	test   %eax,%eax
  801f99:	75 ad                	jne    801f48 <print_blocks_list+0x2f>
  801f9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f9f:	75 a7                	jne    801f48 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801fa1:	83 ec 0c             	sub    $0xc,%esp
  801fa4:	68 98 3a 80 00       	push   $0x803a98
  801fa9:	e8 a3 e3 ff ff       	call   800351 <cprintf>
  801fae:	83 c4 10             	add    $0x10,%esp

}
  801fb1:	90                   	nop
  801fb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
  801fba:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc0:	83 e0 01             	and    $0x1,%eax
  801fc3:	85 c0                	test   %eax,%eax
  801fc5:	74 03                	je     801fca <initialize_dynamic_allocator+0x13>
  801fc7:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  801fca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fce:	0f 84 f8 00 00 00    	je     8020cc <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  801fd4:	c7 05 40 40 98 00 01 	movl   $0x1,0x984040
  801fdb:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  801fde:	a1 40 40 98 00       	mov    0x984040,%eax
  801fe3:	85 c0                	test   %eax,%eax
  801fe5:	0f 84 e2 00 00 00    	je     8020cd <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  801ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  801ffa:	8b 55 08             	mov    0x8(%ebp),%edx
  801ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802000:	01 d0                	add    %edx,%eax
  802002:	83 e8 04             	sub    $0x4,%eax
  802005:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802008:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  802011:	8b 45 08             	mov    0x8(%ebp),%eax
  802014:	83 c0 08             	add    $0x8,%eax
  802017:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  80201a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80201d:	83 e8 08             	sub    $0x8,%eax
  802020:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  802023:	83 ec 04             	sub    $0x4,%esp
  802026:	6a 00                	push   $0x0
  802028:	ff 75 e8             	pushl  -0x18(%ebp)
  80202b:	ff 75 ec             	pushl  -0x14(%ebp)
  80202e:	e8 9c 00 00 00       	call   8020cf <set_block_data>
  802033:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  802036:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802039:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  80203f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802042:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  802049:	c7 05 48 40 98 00 00 	movl   $0x0,0x984048
  802050:	00 00 00 
  802053:	c7 05 4c 40 98 00 00 	movl   $0x0,0x98404c
  80205a:	00 00 00 
  80205d:	c7 05 54 40 98 00 00 	movl   $0x0,0x984054
  802064:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  802067:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80206b:	75 17                	jne    802084 <initialize_dynamic_allocator+0xcd>
  80206d:	83 ec 04             	sub    $0x4,%esp
  802070:	68 f4 3a 80 00       	push   $0x803af4
  802075:	68 80 00 00 00       	push   $0x80
  80207a:	68 17 3b 80 00       	push   $0x803b17
  80207f:	e8 5e 10 00 00       	call   8030e2 <_panic>
  802084:	8b 15 48 40 98 00    	mov    0x984048,%edx
  80208a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80208d:	89 10                	mov    %edx,(%eax)
  80208f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802092:	8b 00                	mov    (%eax),%eax
  802094:	85 c0                	test   %eax,%eax
  802096:	74 0d                	je     8020a5 <initialize_dynamic_allocator+0xee>
  802098:	a1 48 40 98 00       	mov    0x984048,%eax
  80209d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020a0:	89 50 04             	mov    %edx,0x4(%eax)
  8020a3:	eb 08                	jmp    8020ad <initialize_dynamic_allocator+0xf6>
  8020a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a8:	a3 4c 40 98 00       	mov    %eax,0x98404c
  8020ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b0:	a3 48 40 98 00       	mov    %eax,0x984048
  8020b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020bf:	a1 54 40 98 00       	mov    0x984054,%eax
  8020c4:	40                   	inc    %eax
  8020c5:	a3 54 40 98 00       	mov    %eax,0x984054
  8020ca:	eb 01                	jmp    8020cd <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  8020cc:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    

008020cf <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  8020d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d8:	83 e0 01             	and    $0x1,%eax
  8020db:	85 c0                	test   %eax,%eax
  8020dd:	74 03                	je     8020e2 <set_block_data+0x13>
	{
		totalSize++;
  8020df:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  8020e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e5:	83 e8 04             	sub    $0x4,%eax
  8020e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  8020eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ee:	83 e0 fe             	and    $0xfffffffe,%eax
  8020f1:	89 c2                	mov    %eax,%edx
  8020f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8020f6:	83 e0 01             	and    $0x1,%eax
  8020f9:	09 c2                	or     %eax,%edx
  8020fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020fe:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  802100:	8b 45 0c             	mov    0xc(%ebp),%eax
  802103:	8d 50 f8             	lea    -0x8(%eax),%edx
  802106:	8b 45 08             	mov    0x8(%ebp),%eax
  802109:	01 d0                	add    %edx,%eax
  80210b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  80210e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802111:	83 e0 fe             	and    $0xfffffffe,%eax
  802114:	89 c2                	mov    %eax,%edx
  802116:	8b 45 10             	mov    0x10(%ebp),%eax
  802119:	83 e0 01             	and    $0x1,%eax
  80211c:	09 c2                	or     %eax,%edx
  80211e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802121:	89 10                	mov    %edx,(%eax)
}
  802123:	90                   	nop
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
  802129:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  80212c:	a1 48 40 98 00       	mov    0x984048,%eax
  802131:	85 c0                	test   %eax,%eax
  802133:	75 68                	jne    80219d <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  802135:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802139:	75 17                	jne    802152 <insert_sorted_in_freeList+0x2c>
  80213b:	83 ec 04             	sub    $0x4,%esp
  80213e:	68 f4 3a 80 00       	push   $0x803af4
  802143:	68 9d 00 00 00       	push   $0x9d
  802148:	68 17 3b 80 00       	push   $0x803b17
  80214d:	e8 90 0f 00 00       	call   8030e2 <_panic>
  802152:	8b 15 48 40 98 00    	mov    0x984048,%edx
  802158:	8b 45 08             	mov    0x8(%ebp),%eax
  80215b:	89 10                	mov    %edx,(%eax)
  80215d:	8b 45 08             	mov    0x8(%ebp),%eax
  802160:	8b 00                	mov    (%eax),%eax
  802162:	85 c0                	test   %eax,%eax
  802164:	74 0d                	je     802173 <insert_sorted_in_freeList+0x4d>
  802166:	a1 48 40 98 00       	mov    0x984048,%eax
  80216b:	8b 55 08             	mov    0x8(%ebp),%edx
  80216e:	89 50 04             	mov    %edx,0x4(%eax)
  802171:	eb 08                	jmp    80217b <insert_sorted_in_freeList+0x55>
  802173:	8b 45 08             	mov    0x8(%ebp),%eax
  802176:	a3 4c 40 98 00       	mov    %eax,0x98404c
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	a3 48 40 98 00       	mov    %eax,0x984048
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80218d:	a1 54 40 98 00       	mov    0x984054,%eax
  802192:	40                   	inc    %eax
  802193:	a3 54 40 98 00       	mov    %eax,0x984054
		return;
  802198:	e9 1a 01 00 00       	jmp    8022b7 <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  80219d:	a1 48 40 98 00       	mov    0x984048,%eax
  8021a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a5:	eb 7f                	jmp    802226 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  8021a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021ad:	76 6f                	jbe    80221e <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  8021af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b3:	74 06                	je     8021bb <insert_sorted_in_freeList+0x95>
  8021b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021b9:	75 17                	jne    8021d2 <insert_sorted_in_freeList+0xac>
  8021bb:	83 ec 04             	sub    $0x4,%esp
  8021be:	68 30 3b 80 00       	push   $0x803b30
  8021c3:	68 a6 00 00 00       	push   $0xa6
  8021c8:	68 17 3b 80 00       	push   $0x803b17
  8021cd:	e8 10 0f 00 00       	call   8030e2 <_panic>
  8021d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d5:	8b 50 04             	mov    0x4(%eax),%edx
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	89 50 04             	mov    %edx,0x4(%eax)
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e4:	89 10                	mov    %edx,(%eax)
  8021e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e9:	8b 40 04             	mov    0x4(%eax),%eax
  8021ec:	85 c0                	test   %eax,%eax
  8021ee:	74 0d                	je     8021fd <insert_sorted_in_freeList+0xd7>
  8021f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f3:	8b 40 04             	mov    0x4(%eax),%eax
  8021f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f9:	89 10                	mov    %edx,(%eax)
  8021fb:	eb 08                	jmp    802205 <insert_sorted_in_freeList+0xdf>
  8021fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802200:	a3 48 40 98 00       	mov    %eax,0x984048
  802205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802208:	8b 55 08             	mov    0x8(%ebp),%edx
  80220b:	89 50 04             	mov    %edx,0x4(%eax)
  80220e:	a1 54 40 98 00       	mov    0x984054,%eax
  802213:	40                   	inc    %eax
  802214:	a3 54 40 98 00       	mov    %eax,0x984054
			return;
  802219:	e9 99 00 00 00       	jmp    8022b7 <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  80221e:	a1 50 40 98 00       	mov    0x984050,%eax
  802223:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802226:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222a:	74 07                	je     802233 <insert_sorted_in_freeList+0x10d>
  80222c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222f:	8b 00                	mov    (%eax),%eax
  802231:	eb 05                	jmp    802238 <insert_sorted_in_freeList+0x112>
  802233:	b8 00 00 00 00       	mov    $0x0,%eax
  802238:	a3 50 40 98 00       	mov    %eax,0x984050
  80223d:	a1 50 40 98 00       	mov    0x984050,%eax
  802242:	85 c0                	test   %eax,%eax
  802244:	0f 85 5d ff ff ff    	jne    8021a7 <insert_sorted_in_freeList+0x81>
  80224a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80224e:	0f 85 53 ff ff ff    	jne    8021a7 <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  802254:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802258:	75 17                	jne    802271 <insert_sorted_in_freeList+0x14b>
  80225a:	83 ec 04             	sub    $0x4,%esp
  80225d:	68 68 3b 80 00       	push   $0x803b68
  802262:	68 ab 00 00 00       	push   $0xab
  802267:	68 17 3b 80 00       	push   $0x803b17
  80226c:	e8 71 0e 00 00       	call   8030e2 <_panic>
  802271:	8b 15 4c 40 98 00    	mov    0x98404c,%edx
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	89 50 04             	mov    %edx,0x4(%eax)
  80227d:	8b 45 08             	mov    0x8(%ebp),%eax
  802280:	8b 40 04             	mov    0x4(%eax),%eax
  802283:	85 c0                	test   %eax,%eax
  802285:	74 0c                	je     802293 <insert_sorted_in_freeList+0x16d>
  802287:	a1 4c 40 98 00       	mov    0x98404c,%eax
  80228c:	8b 55 08             	mov    0x8(%ebp),%edx
  80228f:	89 10                	mov    %edx,(%eax)
  802291:	eb 08                	jmp    80229b <insert_sorted_in_freeList+0x175>
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	a3 48 40 98 00       	mov    %eax,0x984048
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	a3 4c 40 98 00       	mov    %eax,0x98404c
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022ac:	a1 54 40 98 00       	mov    0x984054,%eax
  8022b1:	40                   	inc    %eax
  8022b2:	a3 54 40 98 00       	mov    %eax,0x984054
}
  8022b7:	c9                   	leave  
  8022b8:	c3                   	ret    

008022b9 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
  8022bc:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	83 e0 01             	and    $0x1,%eax
  8022c5:	85 c0                	test   %eax,%eax
  8022c7:	74 03                	je     8022cc <alloc_block_FF+0x13>
  8022c9:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8022cc:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8022d0:	77 07                	ja     8022d9 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8022d2:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8022d9:	a1 40 40 98 00       	mov    0x984040,%eax
  8022de:	85 c0                	test   %eax,%eax
  8022e0:	75 63                	jne    802345 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e5:	83 c0 10             	add    $0x10,%eax
  8022e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8022eb:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8022f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022f8:	01 d0                	add    %edx,%eax
  8022fa:	48                   	dec    %eax
  8022fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8022fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802301:	ba 00 00 00 00       	mov    $0x0,%edx
  802306:	f7 75 ec             	divl   -0x14(%ebp)
  802309:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80230c:	29 d0                	sub    %edx,%eax
  80230e:	c1 e8 0c             	shr    $0xc,%eax
  802311:	83 ec 0c             	sub    $0xc,%esp
  802314:	50                   	push   %eax
  802315:	e8 d1 ed ff ff       	call   8010eb <sbrk>
  80231a:	83 c4 10             	add    $0x10,%esp
  80231d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802320:	83 ec 0c             	sub    $0xc,%esp
  802323:	6a 00                	push   $0x0
  802325:	e8 c1 ed ff ff       	call   8010eb <sbrk>
  80232a:	83 c4 10             	add    $0x10,%esp
  80232d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802330:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802333:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802336:	83 ec 08             	sub    $0x8,%esp
  802339:	50                   	push   %eax
  80233a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80233d:	e8 75 fc ff ff       	call   801fb7 <initialize_dynamic_allocator>
  802342:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  802345:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802349:	75 0a                	jne    802355 <alloc_block_FF+0x9c>
	{
		return NULL;
  80234b:	b8 00 00 00 00       	mov    $0x0,%eax
  802350:	e9 99 03 00 00       	jmp    8026ee <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802355:	8b 45 08             	mov    0x8(%ebp),%eax
  802358:	83 c0 08             	add    $0x8,%eax
  80235b:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  80235e:	a1 48 40 98 00       	mov    0x984048,%eax
  802363:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802366:	e9 03 02 00 00       	jmp    80256e <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  80236b:	83 ec 0c             	sub    $0xc,%esp
  80236e:	ff 75 f4             	pushl  -0xc(%ebp)
  802371:	e8 dd fa ff ff       	call   801e53 <get_block_size>
  802376:	83 c4 10             	add    $0x10,%esp
  802379:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  80237c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80237f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802382:	0f 82 de 01 00 00    	jb     802566 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  802388:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80238b:	83 c0 10             	add    $0x10,%eax
  80238e:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802391:	0f 87 32 01 00 00    	ja     8024c9 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  802397:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80239a:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80239d:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  8023a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023a6:	01 d0                	add    %edx,%eax
  8023a8:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  8023ab:	83 ec 04             	sub    $0x4,%esp
  8023ae:	6a 00                	push   $0x0
  8023b0:	ff 75 98             	pushl  -0x68(%ebp)
  8023b3:	ff 75 94             	pushl  -0x6c(%ebp)
  8023b6:	e8 14 fd ff ff       	call   8020cf <set_block_data>
  8023bb:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  8023be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c2:	74 06                	je     8023ca <alloc_block_FF+0x111>
  8023c4:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  8023c8:	75 17                	jne    8023e1 <alloc_block_FF+0x128>
  8023ca:	83 ec 04             	sub    $0x4,%esp
  8023cd:	68 8c 3b 80 00       	push   $0x803b8c
  8023d2:	68 de 00 00 00       	push   $0xde
  8023d7:	68 17 3b 80 00       	push   $0x803b17
  8023dc:	e8 01 0d 00 00       	call   8030e2 <_panic>
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 10                	mov    (%eax),%edx
  8023e6:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8023e9:	89 10                	mov    %edx,(%eax)
  8023eb:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8023ee:	8b 00                	mov    (%eax),%eax
  8023f0:	85 c0                	test   %eax,%eax
  8023f2:	74 0b                	je     8023ff <alloc_block_FF+0x146>
  8023f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f7:	8b 00                	mov    (%eax),%eax
  8023f9:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8023fc:	89 50 04             	mov    %edx,0x4(%eax)
  8023ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802402:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802405:	89 10                	mov    %edx,(%eax)
  802407:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80240a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80240d:	89 50 04             	mov    %edx,0x4(%eax)
  802410:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802413:	8b 00                	mov    (%eax),%eax
  802415:	85 c0                	test   %eax,%eax
  802417:	75 08                	jne    802421 <alloc_block_FF+0x168>
  802419:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80241c:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802421:	a1 54 40 98 00       	mov    0x984054,%eax
  802426:	40                   	inc    %eax
  802427:	a3 54 40 98 00       	mov    %eax,0x984054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  80242c:	83 ec 04             	sub    $0x4,%esp
  80242f:	6a 01                	push   $0x1
  802431:	ff 75 dc             	pushl  -0x24(%ebp)
  802434:	ff 75 f4             	pushl  -0xc(%ebp)
  802437:	e8 93 fc ff ff       	call   8020cf <set_block_data>
  80243c:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  80243f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802443:	75 17                	jne    80245c <alloc_block_FF+0x1a3>
  802445:	83 ec 04             	sub    $0x4,%esp
  802448:	68 c0 3b 80 00       	push   $0x803bc0
  80244d:	68 e3 00 00 00       	push   $0xe3
  802452:	68 17 3b 80 00       	push   $0x803b17
  802457:	e8 86 0c 00 00       	call   8030e2 <_panic>
  80245c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245f:	8b 00                	mov    (%eax),%eax
  802461:	85 c0                	test   %eax,%eax
  802463:	74 10                	je     802475 <alloc_block_FF+0x1bc>
  802465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802468:	8b 00                	mov    (%eax),%eax
  80246a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246d:	8b 52 04             	mov    0x4(%edx),%edx
  802470:	89 50 04             	mov    %edx,0x4(%eax)
  802473:	eb 0b                	jmp    802480 <alloc_block_FF+0x1c7>
  802475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802478:	8b 40 04             	mov    0x4(%eax),%eax
  80247b:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802483:	8b 40 04             	mov    0x4(%eax),%eax
  802486:	85 c0                	test   %eax,%eax
  802488:	74 0f                	je     802499 <alloc_block_FF+0x1e0>
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	8b 40 04             	mov    0x4(%eax),%eax
  802490:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802493:	8b 12                	mov    (%edx),%edx
  802495:	89 10                	mov    %edx,(%eax)
  802497:	eb 0a                	jmp    8024a3 <alloc_block_FF+0x1ea>
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	8b 00                	mov    (%eax),%eax
  80249e:	a3 48 40 98 00       	mov    %eax,0x984048
  8024a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024b6:	a1 54 40 98 00       	mov    0x984054,%eax
  8024bb:	48                   	dec    %eax
  8024bc:	a3 54 40 98 00       	mov    %eax,0x984054
				return (void*)((uint32*)block);
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	e9 25 02 00 00       	jmp    8026ee <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  8024c9:	83 ec 04             	sub    $0x4,%esp
  8024cc:	6a 01                	push   $0x1
  8024ce:	ff 75 9c             	pushl  -0x64(%ebp)
  8024d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8024d4:	e8 f6 fb ff ff       	call   8020cf <set_block_data>
  8024d9:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  8024dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e0:	75 17                	jne    8024f9 <alloc_block_FF+0x240>
  8024e2:	83 ec 04             	sub    $0x4,%esp
  8024e5:	68 c0 3b 80 00       	push   $0x803bc0
  8024ea:	68 eb 00 00 00       	push   $0xeb
  8024ef:	68 17 3b 80 00       	push   $0x803b17
  8024f4:	e8 e9 0b 00 00       	call   8030e2 <_panic>
  8024f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fc:	8b 00                	mov    (%eax),%eax
  8024fe:	85 c0                	test   %eax,%eax
  802500:	74 10                	je     802512 <alloc_block_FF+0x259>
  802502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802505:	8b 00                	mov    (%eax),%eax
  802507:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250a:	8b 52 04             	mov    0x4(%edx),%edx
  80250d:	89 50 04             	mov    %edx,0x4(%eax)
  802510:	eb 0b                	jmp    80251d <alloc_block_FF+0x264>
  802512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802515:	8b 40 04             	mov    0x4(%eax),%eax
  802518:	a3 4c 40 98 00       	mov    %eax,0x98404c
  80251d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802520:	8b 40 04             	mov    0x4(%eax),%eax
  802523:	85 c0                	test   %eax,%eax
  802525:	74 0f                	je     802536 <alloc_block_FF+0x27d>
  802527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252a:	8b 40 04             	mov    0x4(%eax),%eax
  80252d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802530:	8b 12                	mov    (%edx),%edx
  802532:	89 10                	mov    %edx,(%eax)
  802534:	eb 0a                	jmp    802540 <alloc_block_FF+0x287>
  802536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802539:	8b 00                	mov    (%eax),%eax
  80253b:	a3 48 40 98 00       	mov    %eax,0x984048
  802540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802543:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802553:	a1 54 40 98 00       	mov    0x984054,%eax
  802558:	48                   	dec    %eax
  802559:	a3 54 40 98 00       	mov    %eax,0x984054
				return (void*)((uint32*)block);
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	e9 88 01 00 00       	jmp    8026ee <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802566:	a1 50 40 98 00       	mov    0x984050,%eax
  80256b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80256e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802572:	74 07                	je     80257b <alloc_block_FF+0x2c2>
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	8b 00                	mov    (%eax),%eax
  802579:	eb 05                	jmp    802580 <alloc_block_FF+0x2c7>
  80257b:	b8 00 00 00 00       	mov    $0x0,%eax
  802580:	a3 50 40 98 00       	mov    %eax,0x984050
  802585:	a1 50 40 98 00       	mov    0x984050,%eax
  80258a:	85 c0                	test   %eax,%eax
  80258c:	0f 85 d9 fd ff ff    	jne    80236b <alloc_block_FF+0xb2>
  802592:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802596:	0f 85 cf fd ff ff    	jne    80236b <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  80259c:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8025a3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025a9:	01 d0                	add    %edx,%eax
  8025ab:	48                   	dec    %eax
  8025ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8025af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8025b7:	f7 75 d8             	divl   -0x28(%ebp)
  8025ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025bd:	29 d0                	sub    %edx,%eax
  8025bf:	c1 e8 0c             	shr    $0xc,%eax
  8025c2:	83 ec 0c             	sub    $0xc,%esp
  8025c5:	50                   	push   %eax
  8025c6:	e8 20 eb ff ff       	call   8010eb <sbrk>
  8025cb:	83 c4 10             	add    $0x10,%esp
  8025ce:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  8025d1:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8025d5:	75 0a                	jne    8025e1 <alloc_block_FF+0x328>
		return NULL;
  8025d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025dc:	e9 0d 01 00 00       	jmp    8026ee <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  8025e1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025e4:	83 e8 04             	sub    $0x4,%eax
  8025e7:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  8025ea:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  8025f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025f7:	01 d0                	add    %edx,%eax
  8025f9:	48                   	dec    %eax
  8025fa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8025fd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802600:	ba 00 00 00 00       	mov    $0x0,%edx
  802605:	f7 75 c8             	divl   -0x38(%ebp)
  802608:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80260b:	29 d0                	sub    %edx,%eax
  80260d:	c1 e8 02             	shr    $0x2,%eax
  802610:	c1 e0 02             	shl    $0x2,%eax
  802613:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  802616:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802619:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  80261f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802622:	83 e8 08             	sub    $0x8,%eax
  802625:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  802628:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80262b:	8b 00                	mov    (%eax),%eax
  80262d:	83 e0 fe             	and    $0xfffffffe,%eax
  802630:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  802633:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802636:	f7 d8                	neg    %eax
  802638:	89 c2                	mov    %eax,%edx
  80263a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80263d:	01 d0                	add    %edx,%eax
  80263f:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  802642:	83 ec 0c             	sub    $0xc,%esp
  802645:	ff 75 b8             	pushl  -0x48(%ebp)
  802648:	e8 1f f8 ff ff       	call   801e6c <is_free_block>
  80264d:	83 c4 10             	add    $0x10,%esp
  802650:	0f be c0             	movsbl %al,%eax
  802653:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  802656:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  80265a:	74 42                	je     80269e <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  80265c:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802663:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802666:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802669:	01 d0                	add    %edx,%eax
  80266b:	48                   	dec    %eax
  80266c:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80266f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802672:	ba 00 00 00 00       	mov    $0x0,%edx
  802677:	f7 75 b0             	divl   -0x50(%ebp)
  80267a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80267d:	29 d0                	sub    %edx,%eax
  80267f:	89 c2                	mov    %eax,%edx
  802681:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802684:	01 d0                	add    %edx,%eax
  802686:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  802689:	83 ec 04             	sub    $0x4,%esp
  80268c:	6a 00                	push   $0x0
  80268e:	ff 75 a8             	pushl  -0x58(%ebp)
  802691:	ff 75 b8             	pushl  -0x48(%ebp)
  802694:	e8 36 fa ff ff       	call   8020cf <set_block_data>
  802699:	83 c4 10             	add    $0x10,%esp
  80269c:	eb 42                	jmp    8026e0 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  80269e:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  8026a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026a8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8026ab:	01 d0                	add    %edx,%eax
  8026ad:	48                   	dec    %eax
  8026ae:	89 45 a0             	mov    %eax,-0x60(%ebp)
  8026b1:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8026b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8026b9:	f7 75 a4             	divl   -0x5c(%ebp)
  8026bc:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8026bf:	29 d0                	sub    %edx,%eax
  8026c1:	83 ec 04             	sub    $0x4,%esp
  8026c4:	6a 00                	push   $0x0
  8026c6:	50                   	push   %eax
  8026c7:	ff 75 d0             	pushl  -0x30(%ebp)
  8026ca:	e8 00 fa ff ff       	call   8020cf <set_block_data>
  8026cf:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  8026d2:	83 ec 0c             	sub    $0xc,%esp
  8026d5:	ff 75 d0             	pushl  -0x30(%ebp)
  8026d8:	e8 49 fa ff ff       	call   802126 <insert_sorted_in_freeList>
  8026dd:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  8026e0:	83 ec 0c             	sub    $0xc,%esp
  8026e3:	ff 75 08             	pushl  0x8(%ebp)
  8026e6:	e8 ce fb ff ff       	call   8022b9 <alloc_block_FF>
  8026eb:	83 c4 10             	add    $0x10,%esp
}
  8026ee:	c9                   	leave  
  8026ef:	c3                   	ret    

008026f0 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8026f0:	55                   	push   %ebp
  8026f1:	89 e5                	mov    %esp,%ebp
  8026f3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  8026f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026fa:	75 0a                	jne    802706 <alloc_block_BF+0x16>
	{
		return NULL;
  8026fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802701:	e9 7a 02 00 00       	jmp    802980 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802706:	8b 45 08             	mov    0x8(%ebp),%eax
  802709:	83 c0 08             	add    $0x8,%eax
  80270c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  80270f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  802716:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  80271d:	a1 48 40 98 00       	mov    0x984048,%eax
  802722:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802725:	eb 32                	jmp    802759 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  802727:	ff 75 ec             	pushl  -0x14(%ebp)
  80272a:	e8 24 f7 ff ff       	call   801e53 <get_block_size>
  80272f:	83 c4 04             	add    $0x4,%esp
  802732:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  802735:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802738:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80273b:	72 14                	jb     802751 <alloc_block_BF+0x61>
  80273d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802740:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802743:	73 0c                	jae    802751 <alloc_block_BF+0x61>
		{
			minBlk = block;
  802745:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802748:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  80274b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802751:	a1 50 40 98 00       	mov    0x984050,%eax
  802756:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802759:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80275d:	74 07                	je     802766 <alloc_block_BF+0x76>
  80275f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802762:	8b 00                	mov    (%eax),%eax
  802764:	eb 05                	jmp    80276b <alloc_block_BF+0x7b>
  802766:	b8 00 00 00 00       	mov    $0x0,%eax
  80276b:	a3 50 40 98 00       	mov    %eax,0x984050
  802770:	a1 50 40 98 00       	mov    0x984050,%eax
  802775:	85 c0                	test   %eax,%eax
  802777:	75 ae                	jne    802727 <alloc_block_BF+0x37>
  802779:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80277d:	75 a8                	jne    802727 <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  80277f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802783:	75 22                	jne    8027a7 <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802785:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802788:	83 ec 0c             	sub    $0xc,%esp
  80278b:	50                   	push   %eax
  80278c:	e8 5a e9 ff ff       	call   8010eb <sbrk>
  802791:	83 c4 10             	add    $0x10,%esp
  802794:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  802797:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80279b:	75 0a                	jne    8027a7 <alloc_block_BF+0xb7>
			return NULL;
  80279d:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a2:	e9 d9 01 00 00       	jmp    802980 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  8027a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027aa:	83 c0 10             	add    $0x10,%eax
  8027ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027b0:	0f 87 32 01 00 00    	ja     8028e8 <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  8027b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b9:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8027bc:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  8027bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027c5:	01 d0                	add    %edx,%eax
  8027c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  8027ca:	83 ec 04             	sub    $0x4,%esp
  8027cd:	6a 00                	push   $0x0
  8027cf:	ff 75 dc             	pushl  -0x24(%ebp)
  8027d2:	ff 75 d8             	pushl  -0x28(%ebp)
  8027d5:	e8 f5 f8 ff ff       	call   8020cf <set_block_data>
  8027da:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  8027dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e1:	74 06                	je     8027e9 <alloc_block_BF+0xf9>
  8027e3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8027e7:	75 17                	jne    802800 <alloc_block_BF+0x110>
  8027e9:	83 ec 04             	sub    $0x4,%esp
  8027ec:	68 8c 3b 80 00       	push   $0x803b8c
  8027f1:	68 49 01 00 00       	push   $0x149
  8027f6:	68 17 3b 80 00       	push   $0x803b17
  8027fb:	e8 e2 08 00 00       	call   8030e2 <_panic>
  802800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802803:	8b 10                	mov    (%eax),%edx
  802805:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802808:	89 10                	mov    %edx,(%eax)
  80280a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80280d:	8b 00                	mov    (%eax),%eax
  80280f:	85 c0                	test   %eax,%eax
  802811:	74 0b                	je     80281e <alloc_block_BF+0x12e>
  802813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802816:	8b 00                	mov    (%eax),%eax
  802818:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80281b:	89 50 04             	mov    %edx,0x4(%eax)
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802824:	89 10                	mov    %edx,(%eax)
  802826:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802829:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80282c:	89 50 04             	mov    %edx,0x4(%eax)
  80282f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802832:	8b 00                	mov    (%eax),%eax
  802834:	85 c0                	test   %eax,%eax
  802836:	75 08                	jne    802840 <alloc_block_BF+0x150>
  802838:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80283b:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802840:	a1 54 40 98 00       	mov    0x984054,%eax
  802845:	40                   	inc    %eax
  802846:	a3 54 40 98 00       	mov    %eax,0x984054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  80284b:	83 ec 04             	sub    $0x4,%esp
  80284e:	6a 01                	push   $0x1
  802850:	ff 75 e8             	pushl  -0x18(%ebp)
  802853:	ff 75 f4             	pushl  -0xc(%ebp)
  802856:	e8 74 f8 ff ff       	call   8020cf <set_block_data>
  80285b:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  80285e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802862:	75 17                	jne    80287b <alloc_block_BF+0x18b>
  802864:	83 ec 04             	sub    $0x4,%esp
  802867:	68 c0 3b 80 00       	push   $0x803bc0
  80286c:	68 4e 01 00 00       	push   $0x14e
  802871:	68 17 3b 80 00       	push   $0x803b17
  802876:	e8 67 08 00 00       	call   8030e2 <_panic>
  80287b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287e:	8b 00                	mov    (%eax),%eax
  802880:	85 c0                	test   %eax,%eax
  802882:	74 10                	je     802894 <alloc_block_BF+0x1a4>
  802884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802887:	8b 00                	mov    (%eax),%eax
  802889:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80288c:	8b 52 04             	mov    0x4(%edx),%edx
  80288f:	89 50 04             	mov    %edx,0x4(%eax)
  802892:	eb 0b                	jmp    80289f <alloc_block_BF+0x1af>
  802894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802897:	8b 40 04             	mov    0x4(%eax),%eax
  80289a:	a3 4c 40 98 00       	mov    %eax,0x98404c
  80289f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a2:	8b 40 04             	mov    0x4(%eax),%eax
  8028a5:	85 c0                	test   %eax,%eax
  8028a7:	74 0f                	je     8028b8 <alloc_block_BF+0x1c8>
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	8b 40 04             	mov    0x4(%eax),%eax
  8028af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b2:	8b 12                	mov    (%edx),%edx
  8028b4:	89 10                	mov    %edx,(%eax)
  8028b6:	eb 0a                	jmp    8028c2 <alloc_block_BF+0x1d2>
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	8b 00                	mov    (%eax),%eax
  8028bd:	a3 48 40 98 00       	mov    %eax,0x984048
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d5:	a1 54 40 98 00       	mov    0x984054,%eax
  8028da:	48                   	dec    %eax
  8028db:	a3 54 40 98 00       	mov    %eax,0x984054
		return (void*)((uint32*)minBlk);
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	e9 98 00 00 00       	jmp    802980 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  8028e8:	83 ec 04             	sub    $0x4,%esp
  8028eb:	6a 01                	push   $0x1
  8028ed:	ff 75 f0             	pushl  -0x10(%ebp)
  8028f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8028f3:	e8 d7 f7 ff ff       	call   8020cf <set_block_data>
  8028f8:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  8028fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ff:	75 17                	jne    802918 <alloc_block_BF+0x228>
  802901:	83 ec 04             	sub    $0x4,%esp
  802904:	68 c0 3b 80 00       	push   $0x803bc0
  802909:	68 56 01 00 00       	push   $0x156
  80290e:	68 17 3b 80 00       	push   $0x803b17
  802913:	e8 ca 07 00 00       	call   8030e2 <_panic>
  802918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291b:	8b 00                	mov    (%eax),%eax
  80291d:	85 c0                	test   %eax,%eax
  80291f:	74 10                	je     802931 <alloc_block_BF+0x241>
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	8b 00                	mov    (%eax),%eax
  802926:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802929:	8b 52 04             	mov    0x4(%edx),%edx
  80292c:	89 50 04             	mov    %edx,0x4(%eax)
  80292f:	eb 0b                	jmp    80293c <alloc_block_BF+0x24c>
  802931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802934:	8b 40 04             	mov    0x4(%eax),%eax
  802937:	a3 4c 40 98 00       	mov    %eax,0x98404c
  80293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293f:	8b 40 04             	mov    0x4(%eax),%eax
  802942:	85 c0                	test   %eax,%eax
  802944:	74 0f                	je     802955 <alloc_block_BF+0x265>
  802946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802949:	8b 40 04             	mov    0x4(%eax),%eax
  80294c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80294f:	8b 12                	mov    (%edx),%edx
  802951:	89 10                	mov    %edx,(%eax)
  802953:	eb 0a                	jmp    80295f <alloc_block_BF+0x26f>
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	8b 00                	mov    (%eax),%eax
  80295a:	a3 48 40 98 00       	mov    %eax,0x984048
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802972:	a1 54 40 98 00       	mov    0x984054,%eax
  802977:	48                   	dec    %eax
  802978:	a3 54 40 98 00       	mov    %eax,0x984054
		return (void*)((uint32*)minBlk);
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802980:	c9                   	leave  
  802981:	c3                   	ret    

00802982 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802982:	55                   	push   %ebp
  802983:	89 e5                	mov    %esp,%ebp
  802985:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802988:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80298c:	0f 84 6a 02 00 00    	je     802bfc <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  802992:	ff 75 08             	pushl  0x8(%ebp)
  802995:	e8 b9 f4 ff ff       	call   801e53 <get_block_size>
  80299a:	83 c4 04             	add    $0x4,%esp
  80299d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	83 e8 08             	sub    $0x8,%eax
  8029a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  8029a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ac:	8b 00                	mov    (%eax),%eax
  8029ae:	83 e0 fe             	and    $0xfffffffe,%eax
  8029b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  8029b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b7:	f7 d8                	neg    %eax
  8029b9:	89 c2                	mov    %eax,%edx
  8029bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029be:	01 d0                	add    %edx,%eax
  8029c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  8029c3:	ff 75 e8             	pushl  -0x18(%ebp)
  8029c6:	e8 a1 f4 ff ff       	call   801e6c <is_free_block>
  8029cb:	83 c4 04             	add    $0x4,%esp
  8029ce:	0f be c0             	movsbl %al,%eax
  8029d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  8029d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029da:	01 d0                	add    %edx,%eax
  8029dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  8029df:	ff 75 e0             	pushl  -0x20(%ebp)
  8029e2:	e8 85 f4 ff ff       	call   801e6c <is_free_block>
  8029e7:	83 c4 04             	add    $0x4,%esp
  8029ea:	0f be c0             	movsbl %al,%eax
  8029ed:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  8029f0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8029f4:	75 34                	jne    802a2a <free_block+0xa8>
  8029f6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8029fa:	75 2e                	jne    802a2a <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  8029fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8029ff:	e8 4f f4 ff ff       	call   801e53 <get_block_size>
  802a04:	83 c4 04             	add    $0x4,%esp
  802a07:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802a0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a0d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a10:	01 d0                	add    %edx,%eax
  802a12:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802a15:	6a 00                	push   $0x0
  802a17:	ff 75 d4             	pushl  -0x2c(%ebp)
  802a1a:	ff 75 e8             	pushl  -0x18(%ebp)
  802a1d:	e8 ad f6 ff ff       	call   8020cf <set_block_data>
  802a22:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802a25:	e9 d3 01 00 00       	jmp    802bfd <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802a2a:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802a2e:	0f 85 c8 00 00 00    	jne    802afc <free_block+0x17a>
  802a34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a38:	0f 85 be 00 00 00    	jne    802afc <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802a3e:	ff 75 e0             	pushl  -0x20(%ebp)
  802a41:	e8 0d f4 ff ff       	call   801e53 <get_block_size>
  802a46:	83 c4 04             	add    $0x4,%esp
  802a49:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802a4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a4f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a52:	01 d0                	add    %edx,%eax
  802a54:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802a57:	6a 00                	push   $0x0
  802a59:	ff 75 cc             	pushl  -0x34(%ebp)
  802a5c:	ff 75 08             	pushl  0x8(%ebp)
  802a5f:	e8 6b f6 ff ff       	call   8020cf <set_block_data>
  802a64:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802a67:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a6b:	75 17                	jne    802a84 <free_block+0x102>
  802a6d:	83 ec 04             	sub    $0x4,%esp
  802a70:	68 c0 3b 80 00       	push   $0x803bc0
  802a75:	68 87 01 00 00       	push   $0x187
  802a7a:	68 17 3b 80 00       	push   $0x803b17
  802a7f:	e8 5e 06 00 00       	call   8030e2 <_panic>
  802a84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a87:	8b 00                	mov    (%eax),%eax
  802a89:	85 c0                	test   %eax,%eax
  802a8b:	74 10                	je     802a9d <free_block+0x11b>
  802a8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a90:	8b 00                	mov    (%eax),%eax
  802a92:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a95:	8b 52 04             	mov    0x4(%edx),%edx
  802a98:	89 50 04             	mov    %edx,0x4(%eax)
  802a9b:	eb 0b                	jmp    802aa8 <free_block+0x126>
  802a9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa0:	8b 40 04             	mov    0x4(%eax),%eax
  802aa3:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802aa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aab:	8b 40 04             	mov    0x4(%eax),%eax
  802aae:	85 c0                	test   %eax,%eax
  802ab0:	74 0f                	je     802ac1 <free_block+0x13f>
  802ab2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ab5:	8b 40 04             	mov    0x4(%eax),%eax
  802ab8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802abb:	8b 12                	mov    (%edx),%edx
  802abd:	89 10                	mov    %edx,(%eax)
  802abf:	eb 0a                	jmp    802acb <free_block+0x149>
  802ac1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ac4:	8b 00                	mov    (%eax),%eax
  802ac6:	a3 48 40 98 00       	mov    %eax,0x984048
  802acb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ace:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ad7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ade:	a1 54 40 98 00       	mov    0x984054,%eax
  802ae3:	48                   	dec    %eax
  802ae4:	a3 54 40 98 00       	mov    %eax,0x984054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802ae9:	83 ec 0c             	sub    $0xc,%esp
  802aec:	ff 75 08             	pushl  0x8(%ebp)
  802aef:	e8 32 f6 ff ff       	call   802126 <insert_sorted_in_freeList>
  802af4:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802af7:	e9 01 01 00 00       	jmp    802bfd <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  802afc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802b00:	0f 85 d3 00 00 00    	jne    802bd9 <free_block+0x257>
  802b06:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802b0a:	0f 85 c9 00 00 00    	jne    802bd9 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  802b10:	83 ec 0c             	sub    $0xc,%esp
  802b13:	ff 75 e8             	pushl  -0x18(%ebp)
  802b16:	e8 38 f3 ff ff       	call   801e53 <get_block_size>
  802b1b:	83 c4 10             	add    $0x10,%esp
  802b1e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  802b21:	83 ec 0c             	sub    $0xc,%esp
  802b24:	ff 75 e0             	pushl  -0x20(%ebp)
  802b27:	e8 27 f3 ff ff       	call   801e53 <get_block_size>
  802b2c:	83 c4 10             	add    $0x10,%esp
  802b2f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  802b32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b35:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b38:	01 c2                	add    %eax,%edx
  802b3a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b3d:	01 d0                	add    %edx,%eax
  802b3f:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  802b42:	83 ec 04             	sub    $0x4,%esp
  802b45:	6a 00                	push   $0x0
  802b47:	ff 75 c0             	pushl  -0x40(%ebp)
  802b4a:	ff 75 e8             	pushl  -0x18(%ebp)
  802b4d:	e8 7d f5 ff ff       	call   8020cf <set_block_data>
  802b52:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  802b55:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b59:	75 17                	jne    802b72 <free_block+0x1f0>
  802b5b:	83 ec 04             	sub    $0x4,%esp
  802b5e:	68 c0 3b 80 00       	push   $0x803bc0
  802b63:	68 94 01 00 00       	push   $0x194
  802b68:	68 17 3b 80 00       	push   $0x803b17
  802b6d:	e8 70 05 00 00       	call   8030e2 <_panic>
  802b72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b75:	8b 00                	mov    (%eax),%eax
  802b77:	85 c0                	test   %eax,%eax
  802b79:	74 10                	je     802b8b <free_block+0x209>
  802b7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b7e:	8b 00                	mov    (%eax),%eax
  802b80:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b83:	8b 52 04             	mov    0x4(%edx),%edx
  802b86:	89 50 04             	mov    %edx,0x4(%eax)
  802b89:	eb 0b                	jmp    802b96 <free_block+0x214>
  802b8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b8e:	8b 40 04             	mov    0x4(%eax),%eax
  802b91:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802b96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b99:	8b 40 04             	mov    0x4(%eax),%eax
  802b9c:	85 c0                	test   %eax,%eax
  802b9e:	74 0f                	je     802baf <free_block+0x22d>
  802ba0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ba3:	8b 40 04             	mov    0x4(%eax),%eax
  802ba6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ba9:	8b 12                	mov    (%edx),%edx
  802bab:	89 10                	mov    %edx,(%eax)
  802bad:	eb 0a                	jmp    802bb9 <free_block+0x237>
  802baf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb2:	8b 00                	mov    (%eax),%eax
  802bb4:	a3 48 40 98 00       	mov    %eax,0x984048
  802bb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bbc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bcc:	a1 54 40 98 00       	mov    0x984054,%eax
  802bd1:	48                   	dec    %eax
  802bd2:	a3 54 40 98 00       	mov    %eax,0x984054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  802bd7:	eb 24                	jmp    802bfd <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  802bd9:	83 ec 04             	sub    $0x4,%esp
  802bdc:	6a 00                	push   $0x0
  802bde:	ff 75 f4             	pushl  -0xc(%ebp)
  802be1:	ff 75 08             	pushl  0x8(%ebp)
  802be4:	e8 e6 f4 ff ff       	call   8020cf <set_block_data>
  802be9:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802bec:	83 ec 0c             	sub    $0xc,%esp
  802bef:	ff 75 08             	pushl  0x8(%ebp)
  802bf2:	e8 2f f5 ff ff       	call   802126 <insert_sorted_in_freeList>
  802bf7:	83 c4 10             	add    $0x10,%esp
  802bfa:	eb 01                	jmp    802bfd <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  802bfc:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  802bfd:	c9                   	leave  
  802bfe:	c3                   	ret    

00802bff <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802bff:	55                   	push   %ebp
  802c00:	89 e5                	mov    %esp,%ebp
  802c02:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  802c05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c09:	75 10                	jne    802c1b <realloc_block_FF+0x1c>
  802c0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c0f:	75 0a                	jne    802c1b <realloc_block_FF+0x1c>
	{
		return NULL;
  802c11:	b8 00 00 00 00       	mov    $0x0,%eax
  802c16:	e9 8b 04 00 00       	jmp    8030a6 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  802c1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c1f:	75 18                	jne    802c39 <realloc_block_FF+0x3a>
	{
		free_block(va);
  802c21:	83 ec 0c             	sub    $0xc,%esp
  802c24:	ff 75 08             	pushl  0x8(%ebp)
  802c27:	e8 56 fd ff ff       	call   802982 <free_block>
  802c2c:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802c2f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c34:	e9 6d 04 00 00       	jmp    8030a6 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  802c39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c3d:	75 13                	jne    802c52 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  802c3f:	83 ec 0c             	sub    $0xc,%esp
  802c42:	ff 75 0c             	pushl  0xc(%ebp)
  802c45:	e8 6f f6 ff ff       	call   8022b9 <alloc_block_FF>
  802c4a:	83 c4 10             	add    $0x10,%esp
  802c4d:	e9 54 04 00 00       	jmp    8030a6 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  802c52:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c55:	83 e0 01             	and    $0x1,%eax
  802c58:	85 c0                	test   %eax,%eax
  802c5a:	74 03                	je     802c5f <realloc_block_FF+0x60>
	{
		new_size++;
  802c5c:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  802c5f:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802c63:	77 07                	ja     802c6c <realloc_block_FF+0x6d>
	{
		new_size = 8;
  802c65:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  802c6c:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  802c70:	83 ec 0c             	sub    $0xc,%esp
  802c73:	ff 75 08             	pushl  0x8(%ebp)
  802c76:	e8 d8 f1 ff ff       	call   801e53 <get_block_size>
  802c7b:	83 c4 10             	add    $0x10,%esp
  802c7e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c87:	75 08                	jne    802c91 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  802c89:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8c:	e9 15 04 00 00       	jmp    8030a6 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  802c91:	8b 55 08             	mov    0x8(%ebp),%edx
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	01 d0                	add    %edx,%eax
  802c99:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802c9c:	83 ec 0c             	sub    $0xc,%esp
  802c9f:	ff 75 f0             	pushl  -0x10(%ebp)
  802ca2:	e8 c5 f1 ff ff       	call   801e6c <is_free_block>
  802ca7:	83 c4 10             	add    $0x10,%esp
  802caa:	0f be c0             	movsbl %al,%eax
  802cad:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  802cb0:	83 ec 0c             	sub    $0xc,%esp
  802cb3:	ff 75 f0             	pushl  -0x10(%ebp)
  802cb6:	e8 98 f1 ff ff       	call   801e53 <get_block_size>
  802cbb:	83 c4 10             	add    $0x10,%esp
  802cbe:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  802cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cc4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802cc7:	0f 86 a7 02 00 00    	jbe    802f74 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  802ccd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cd1:	0f 84 86 02 00 00    	je     802f5d <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  802cd7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdd:	01 d0                	add    %edx,%eax
  802cdf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ce2:	0f 85 b2 00 00 00    	jne    802d9a <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  802ce8:	83 ec 0c             	sub    $0xc,%esp
  802ceb:	ff 75 08             	pushl  0x8(%ebp)
  802cee:	e8 79 f1 ff ff       	call   801e6c <is_free_block>
  802cf3:	83 c4 10             	add    $0x10,%esp
  802cf6:	84 c0                	test   %al,%al
  802cf8:	0f 94 c0             	sete   %al
  802cfb:	0f b6 c0             	movzbl %al,%eax
  802cfe:	83 ec 04             	sub    $0x4,%esp
  802d01:	50                   	push   %eax
  802d02:	ff 75 0c             	pushl  0xc(%ebp)
  802d05:	ff 75 08             	pushl  0x8(%ebp)
  802d08:	e8 c2 f3 ff ff       	call   8020cf <set_block_data>
  802d0d:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  802d10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d14:	75 17                	jne    802d2d <realloc_block_FF+0x12e>
  802d16:	83 ec 04             	sub    $0x4,%esp
  802d19:	68 c0 3b 80 00       	push   $0x803bc0
  802d1e:	68 db 01 00 00       	push   $0x1db
  802d23:	68 17 3b 80 00       	push   $0x803b17
  802d28:	e8 b5 03 00 00       	call   8030e2 <_panic>
  802d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d30:	8b 00                	mov    (%eax),%eax
  802d32:	85 c0                	test   %eax,%eax
  802d34:	74 10                	je     802d46 <realloc_block_FF+0x147>
  802d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d39:	8b 00                	mov    (%eax),%eax
  802d3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d3e:	8b 52 04             	mov    0x4(%edx),%edx
  802d41:	89 50 04             	mov    %edx,0x4(%eax)
  802d44:	eb 0b                	jmp    802d51 <realloc_block_FF+0x152>
  802d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d49:	8b 40 04             	mov    0x4(%eax),%eax
  802d4c:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d54:	8b 40 04             	mov    0x4(%eax),%eax
  802d57:	85 c0                	test   %eax,%eax
  802d59:	74 0f                	je     802d6a <realloc_block_FF+0x16b>
  802d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5e:	8b 40 04             	mov    0x4(%eax),%eax
  802d61:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d64:	8b 12                	mov    (%edx),%edx
  802d66:	89 10                	mov    %edx,(%eax)
  802d68:	eb 0a                	jmp    802d74 <realloc_block_FF+0x175>
  802d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6d:	8b 00                	mov    (%eax),%eax
  802d6f:	a3 48 40 98 00       	mov    %eax,0x984048
  802d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d87:	a1 54 40 98 00       	mov    0x984054,%eax
  802d8c:	48                   	dec    %eax
  802d8d:	a3 54 40 98 00       	mov    %eax,0x984054
				return va;
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	e9 0c 03 00 00       	jmp    8030a6 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  802d9a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da0:	01 d0                	add    %edx,%eax
  802da2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802da5:	0f 86 b2 01 00 00    	jbe    802f5d <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  802dab:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dae:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802db1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  802db4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802db7:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802dba:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  802dbd:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  802dc1:	0f 87 b8 00 00 00    	ja     802e7f <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  802dc7:	83 ec 0c             	sub    $0xc,%esp
  802dca:	ff 75 08             	pushl  0x8(%ebp)
  802dcd:	e8 9a f0 ff ff       	call   801e6c <is_free_block>
  802dd2:	83 c4 10             	add    $0x10,%esp
  802dd5:	84 c0                	test   %al,%al
  802dd7:	0f 94 c0             	sete   %al
  802dda:	0f b6 c0             	movzbl %al,%eax
  802ddd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802de0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802de3:	01 ca                	add    %ecx,%edx
  802de5:	83 ec 04             	sub    $0x4,%esp
  802de8:	50                   	push   %eax
  802de9:	52                   	push   %edx
  802dea:	ff 75 08             	pushl  0x8(%ebp)
  802ded:	e8 dd f2 ff ff       	call   8020cf <set_block_data>
  802df2:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  802df5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802df9:	75 17                	jne    802e12 <realloc_block_FF+0x213>
  802dfb:	83 ec 04             	sub    $0x4,%esp
  802dfe:	68 c0 3b 80 00       	push   $0x803bc0
  802e03:	68 e8 01 00 00       	push   $0x1e8
  802e08:	68 17 3b 80 00       	push   $0x803b17
  802e0d:	e8 d0 02 00 00       	call   8030e2 <_panic>
  802e12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e15:	8b 00                	mov    (%eax),%eax
  802e17:	85 c0                	test   %eax,%eax
  802e19:	74 10                	je     802e2b <realloc_block_FF+0x22c>
  802e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1e:	8b 00                	mov    (%eax),%eax
  802e20:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e23:	8b 52 04             	mov    0x4(%edx),%edx
  802e26:	89 50 04             	mov    %edx,0x4(%eax)
  802e29:	eb 0b                	jmp    802e36 <realloc_block_FF+0x237>
  802e2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2e:	8b 40 04             	mov    0x4(%eax),%eax
  802e31:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802e36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e39:	8b 40 04             	mov    0x4(%eax),%eax
  802e3c:	85 c0                	test   %eax,%eax
  802e3e:	74 0f                	je     802e4f <realloc_block_FF+0x250>
  802e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e43:	8b 40 04             	mov    0x4(%eax),%eax
  802e46:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e49:	8b 12                	mov    (%edx),%edx
  802e4b:	89 10                	mov    %edx,(%eax)
  802e4d:	eb 0a                	jmp    802e59 <realloc_block_FF+0x25a>
  802e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e52:	8b 00                	mov    (%eax),%eax
  802e54:	a3 48 40 98 00       	mov    %eax,0x984048
  802e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6c:	a1 54 40 98 00       	mov    0x984054,%eax
  802e71:	48                   	dec    %eax
  802e72:	a3 54 40 98 00       	mov    %eax,0x984054
					return va;
  802e77:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7a:	e9 27 02 00 00       	jmp    8030a6 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  802e7f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e83:	75 17                	jne    802e9c <realloc_block_FF+0x29d>
  802e85:	83 ec 04             	sub    $0x4,%esp
  802e88:	68 c0 3b 80 00       	push   $0x803bc0
  802e8d:	68 ed 01 00 00       	push   $0x1ed
  802e92:	68 17 3b 80 00       	push   $0x803b17
  802e97:	e8 46 02 00 00       	call   8030e2 <_panic>
  802e9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9f:	8b 00                	mov    (%eax),%eax
  802ea1:	85 c0                	test   %eax,%eax
  802ea3:	74 10                	je     802eb5 <realloc_block_FF+0x2b6>
  802ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea8:	8b 00                	mov    (%eax),%eax
  802eaa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ead:	8b 52 04             	mov    0x4(%edx),%edx
  802eb0:	89 50 04             	mov    %edx,0x4(%eax)
  802eb3:	eb 0b                	jmp    802ec0 <realloc_block_FF+0x2c1>
  802eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb8:	8b 40 04             	mov    0x4(%eax),%eax
  802ebb:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec3:	8b 40 04             	mov    0x4(%eax),%eax
  802ec6:	85 c0                	test   %eax,%eax
  802ec8:	74 0f                	je     802ed9 <realloc_block_FF+0x2da>
  802eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecd:	8b 40 04             	mov    0x4(%eax),%eax
  802ed0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ed3:	8b 12                	mov    (%edx),%edx
  802ed5:	89 10                	mov    %edx,(%eax)
  802ed7:	eb 0a                	jmp    802ee3 <realloc_block_FF+0x2e4>
  802ed9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edc:	8b 00                	mov    (%eax),%eax
  802ede:	a3 48 40 98 00       	mov    %eax,0x984048
  802ee3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef6:	a1 54 40 98 00       	mov    0x984054,%eax
  802efb:	48                   	dec    %eax
  802efc:	a3 54 40 98 00       	mov    %eax,0x984054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  802f01:	8b 55 08             	mov    0x8(%ebp),%edx
  802f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f07:	01 d0                	add    %edx,%eax
  802f09:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  802f0c:	83 ec 04             	sub    $0x4,%esp
  802f0f:	6a 00                	push   $0x0
  802f11:	ff 75 e0             	pushl  -0x20(%ebp)
  802f14:	ff 75 f0             	pushl  -0x10(%ebp)
  802f17:	e8 b3 f1 ff ff       	call   8020cf <set_block_data>
  802f1c:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  802f1f:	83 ec 0c             	sub    $0xc,%esp
  802f22:	ff 75 08             	pushl  0x8(%ebp)
  802f25:	e8 42 ef ff ff       	call   801e6c <is_free_block>
  802f2a:	83 c4 10             	add    $0x10,%esp
  802f2d:	84 c0                	test   %al,%al
  802f2f:	0f 94 c0             	sete   %al
  802f32:	0f b6 c0             	movzbl %al,%eax
  802f35:	83 ec 04             	sub    $0x4,%esp
  802f38:	50                   	push   %eax
  802f39:	ff 75 0c             	pushl  0xc(%ebp)
  802f3c:	ff 75 08             	pushl  0x8(%ebp)
  802f3f:	e8 8b f1 ff ff       	call   8020cf <set_block_data>
  802f44:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  802f47:	83 ec 0c             	sub    $0xc,%esp
  802f4a:	ff 75 f0             	pushl  -0x10(%ebp)
  802f4d:	e8 d4 f1 ff ff       	call   802126 <insert_sorted_in_freeList>
  802f52:	83 c4 10             	add    $0x10,%esp
					return va;
  802f55:	8b 45 08             	mov    0x8(%ebp),%eax
  802f58:	e9 49 01 00 00       	jmp    8030a6 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  802f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f60:	83 e8 08             	sub    $0x8,%eax
  802f63:	83 ec 0c             	sub    $0xc,%esp
  802f66:	50                   	push   %eax
  802f67:	e8 4d f3 ff ff       	call   8022b9 <alloc_block_FF>
  802f6c:	83 c4 10             	add    $0x10,%esp
  802f6f:	e9 32 01 00 00       	jmp    8030a6 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  802f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f77:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802f7a:	0f 83 21 01 00 00    	jae    8030a1 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  802f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f83:	2b 45 0c             	sub    0xc(%ebp),%eax
  802f86:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  802f89:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  802f8d:	77 0e                	ja     802f9d <realloc_block_FF+0x39e>
  802f8f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f93:	75 08                	jne    802f9d <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  802f95:	8b 45 08             	mov    0x8(%ebp),%eax
  802f98:	e9 09 01 00 00       	jmp    8030a6 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  802f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa0:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  802fa3:	83 ec 0c             	sub    $0xc,%esp
  802fa6:	ff 75 08             	pushl  0x8(%ebp)
  802fa9:	e8 be ee ff ff       	call   801e6c <is_free_block>
  802fae:	83 c4 10             	add    $0x10,%esp
  802fb1:	84 c0                	test   %al,%al
  802fb3:	0f 94 c0             	sete   %al
  802fb6:	0f b6 c0             	movzbl %al,%eax
  802fb9:	83 ec 04             	sub    $0x4,%esp
  802fbc:	50                   	push   %eax
  802fbd:	ff 75 0c             	pushl  0xc(%ebp)
  802fc0:	ff 75 d8             	pushl  -0x28(%ebp)
  802fc3:	e8 07 f1 ff ff       	call   8020cf <set_block_data>
  802fc8:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  802fcb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd1:	01 d0                	add    %edx,%eax
  802fd3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  802fd6:	83 ec 04             	sub    $0x4,%esp
  802fd9:	6a 00                	push   $0x0
  802fdb:	ff 75 dc             	pushl  -0x24(%ebp)
  802fde:	ff 75 d4             	pushl  -0x2c(%ebp)
  802fe1:	e8 e9 f0 ff ff       	call   8020cf <set_block_data>
  802fe6:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  802fe9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fed:	0f 84 9b 00 00 00    	je     80308e <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  802ff3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ff6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff9:	01 d0                	add    %edx,%eax
  802ffb:	83 ec 04             	sub    $0x4,%esp
  802ffe:	6a 00                	push   $0x0
  803000:	50                   	push   %eax
  803001:	ff 75 d4             	pushl  -0x2c(%ebp)
  803004:	e8 c6 f0 ff ff       	call   8020cf <set_block_data>
  803009:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  80300c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803010:	75 17                	jne    803029 <realloc_block_FF+0x42a>
  803012:	83 ec 04             	sub    $0x4,%esp
  803015:	68 c0 3b 80 00       	push   $0x803bc0
  80301a:	68 10 02 00 00       	push   $0x210
  80301f:	68 17 3b 80 00       	push   $0x803b17
  803024:	e8 b9 00 00 00       	call   8030e2 <_panic>
  803029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302c:	8b 00                	mov    (%eax),%eax
  80302e:	85 c0                	test   %eax,%eax
  803030:	74 10                	je     803042 <realloc_block_FF+0x443>
  803032:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803035:	8b 00                	mov    (%eax),%eax
  803037:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80303a:	8b 52 04             	mov    0x4(%edx),%edx
  80303d:	89 50 04             	mov    %edx,0x4(%eax)
  803040:	eb 0b                	jmp    80304d <realloc_block_FF+0x44e>
  803042:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803045:	8b 40 04             	mov    0x4(%eax),%eax
  803048:	a3 4c 40 98 00       	mov    %eax,0x98404c
  80304d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803050:	8b 40 04             	mov    0x4(%eax),%eax
  803053:	85 c0                	test   %eax,%eax
  803055:	74 0f                	je     803066 <realloc_block_FF+0x467>
  803057:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305a:	8b 40 04             	mov    0x4(%eax),%eax
  80305d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803060:	8b 12                	mov    (%edx),%edx
  803062:	89 10                	mov    %edx,(%eax)
  803064:	eb 0a                	jmp    803070 <realloc_block_FF+0x471>
  803066:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803069:	8b 00                	mov    (%eax),%eax
  80306b:	a3 48 40 98 00       	mov    %eax,0x984048
  803070:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803073:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803079:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803083:	a1 54 40 98 00       	mov    0x984054,%eax
  803088:	48                   	dec    %eax
  803089:	a3 54 40 98 00       	mov    %eax,0x984054
			}
			insert_sorted_in_freeList(remainingBlk);
  80308e:	83 ec 0c             	sub    $0xc,%esp
  803091:	ff 75 d4             	pushl  -0x2c(%ebp)
  803094:	e8 8d f0 ff ff       	call   802126 <insert_sorted_in_freeList>
  803099:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  80309c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80309f:	eb 05                	jmp    8030a6 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  8030a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030a6:	c9                   	leave  
  8030a7:	c3                   	ret    

008030a8 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8030a8:	55                   	push   %ebp
  8030a9:	89 e5                	mov    %esp,%ebp
  8030ab:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8030ae:	83 ec 04             	sub    $0x4,%esp
  8030b1:	68 e0 3b 80 00       	push   $0x803be0
  8030b6:	68 20 02 00 00       	push   $0x220
  8030bb:	68 17 3b 80 00       	push   $0x803b17
  8030c0:	e8 1d 00 00 00       	call   8030e2 <_panic>

008030c5 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8030c5:	55                   	push   %ebp
  8030c6:	89 e5                	mov    %esp,%ebp
  8030c8:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8030cb:	83 ec 04             	sub    $0x4,%esp
  8030ce:	68 08 3c 80 00       	push   $0x803c08
  8030d3:	68 28 02 00 00       	push   $0x228
  8030d8:	68 17 3b 80 00       	push   $0x803b17
  8030dd:	e8 00 00 00 00       	call   8030e2 <_panic>

008030e2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8030e2:	55                   	push   %ebp
  8030e3:	89 e5                	mov    %esp,%ebp
  8030e5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8030e8:	8d 45 10             	lea    0x10(%ebp),%eax
  8030eb:	83 c0 04             	add    $0x4,%eax
  8030ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8030f1:	a1 60 40 98 00       	mov    0x984060,%eax
  8030f6:	85 c0                	test   %eax,%eax
  8030f8:	74 16                	je     803110 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8030fa:	a1 60 40 98 00       	mov    0x984060,%eax
  8030ff:	83 ec 08             	sub    $0x8,%esp
  803102:	50                   	push   %eax
  803103:	68 30 3c 80 00       	push   $0x803c30
  803108:	e8 44 d2 ff ff       	call   800351 <cprintf>
  80310d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803110:	a1 04 40 80 00       	mov    0x804004,%eax
  803115:	ff 75 0c             	pushl  0xc(%ebp)
  803118:	ff 75 08             	pushl  0x8(%ebp)
  80311b:	50                   	push   %eax
  80311c:	68 35 3c 80 00       	push   $0x803c35
  803121:	e8 2b d2 ff ff       	call   800351 <cprintf>
  803126:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803129:	8b 45 10             	mov    0x10(%ebp),%eax
  80312c:	83 ec 08             	sub    $0x8,%esp
  80312f:	ff 75 f4             	pushl  -0xc(%ebp)
  803132:	50                   	push   %eax
  803133:	e8 ae d1 ff ff       	call   8002e6 <vcprintf>
  803138:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80313b:	83 ec 08             	sub    $0x8,%esp
  80313e:	6a 00                	push   $0x0
  803140:	68 51 3c 80 00       	push   $0x803c51
  803145:	e8 9c d1 ff ff       	call   8002e6 <vcprintf>
  80314a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80314d:	e8 1d d1 ff ff       	call   80026f <exit>

	// should not return here
	while (1) ;
  803152:	eb fe                	jmp    803152 <_panic+0x70>

00803154 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803154:	55                   	push   %ebp
  803155:	89 e5                	mov    %esp,%ebp
  803157:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80315a:	a1 20 40 80 00       	mov    0x804020,%eax
  80315f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803165:	8b 45 0c             	mov    0xc(%ebp),%eax
  803168:	39 c2                	cmp    %eax,%edx
  80316a:	74 14                	je     803180 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80316c:	83 ec 04             	sub    $0x4,%esp
  80316f:	68 54 3c 80 00       	push   $0x803c54
  803174:	6a 26                	push   $0x26
  803176:	68 a0 3c 80 00       	push   $0x803ca0
  80317b:	e8 62 ff ff ff       	call   8030e2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803180:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803187:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80318e:	e9 c5 00 00 00       	jmp    803258 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803193:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803196:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80319d:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a0:	01 d0                	add    %edx,%eax
  8031a2:	8b 00                	mov    (%eax),%eax
  8031a4:	85 c0                	test   %eax,%eax
  8031a6:	75 08                	jne    8031b0 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8031a8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8031ab:	e9 a5 00 00 00       	jmp    803255 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8031b0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8031b7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8031be:	eb 69                	jmp    803229 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8031c0:	a1 20 40 80 00       	mov    0x804020,%eax
  8031c5:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8031cb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ce:	89 d0                	mov    %edx,%eax
  8031d0:	01 c0                	add    %eax,%eax
  8031d2:	01 d0                	add    %edx,%eax
  8031d4:	c1 e0 03             	shl    $0x3,%eax
  8031d7:	01 c8                	add    %ecx,%eax
  8031d9:	8a 40 04             	mov    0x4(%eax),%al
  8031dc:	84 c0                	test   %al,%al
  8031de:	75 46                	jne    803226 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8031e0:	a1 20 40 80 00       	mov    0x804020,%eax
  8031e5:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8031eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ee:	89 d0                	mov    %edx,%eax
  8031f0:	01 c0                	add    %eax,%eax
  8031f2:	01 d0                	add    %edx,%eax
  8031f4:	c1 e0 03             	shl    $0x3,%eax
  8031f7:	01 c8                	add    %ecx,%eax
  8031f9:	8b 00                	mov    (%eax),%eax
  8031fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8031fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803201:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803206:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803208:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803212:	8b 45 08             	mov    0x8(%ebp),%eax
  803215:	01 c8                	add    %ecx,%eax
  803217:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803219:	39 c2                	cmp    %eax,%edx
  80321b:	75 09                	jne    803226 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80321d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803224:	eb 15                	jmp    80323b <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803226:	ff 45 e8             	incl   -0x18(%ebp)
  803229:	a1 20 40 80 00       	mov    0x804020,%eax
  80322e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803234:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803237:	39 c2                	cmp    %eax,%edx
  803239:	77 85                	ja     8031c0 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80323b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80323f:	75 14                	jne    803255 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803241:	83 ec 04             	sub    $0x4,%esp
  803244:	68 ac 3c 80 00       	push   $0x803cac
  803249:	6a 3a                	push   $0x3a
  80324b:	68 a0 3c 80 00       	push   $0x803ca0
  803250:	e8 8d fe ff ff       	call   8030e2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803255:	ff 45 f0             	incl   -0x10(%ebp)
  803258:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80325e:	0f 8c 2f ff ff ff    	jl     803193 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803264:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80326b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803272:	eb 26                	jmp    80329a <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803274:	a1 20 40 80 00       	mov    0x804020,%eax
  803279:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80327f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803282:	89 d0                	mov    %edx,%eax
  803284:	01 c0                	add    %eax,%eax
  803286:	01 d0                	add    %edx,%eax
  803288:	c1 e0 03             	shl    $0x3,%eax
  80328b:	01 c8                	add    %ecx,%eax
  80328d:	8a 40 04             	mov    0x4(%eax),%al
  803290:	3c 01                	cmp    $0x1,%al
  803292:	75 03                	jne    803297 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803294:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803297:	ff 45 e0             	incl   -0x20(%ebp)
  80329a:	a1 20 40 80 00       	mov    0x804020,%eax
  80329f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8032a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032a8:	39 c2                	cmp    %eax,%edx
  8032aa:	77 c8                	ja     803274 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8032ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032af:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8032b2:	74 14                	je     8032c8 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8032b4:	83 ec 04             	sub    $0x4,%esp
  8032b7:	68 00 3d 80 00       	push   $0x803d00
  8032bc:	6a 44                	push   $0x44
  8032be:	68 a0 3c 80 00       	push   $0x803ca0
  8032c3:	e8 1a fe ff ff       	call   8030e2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8032c8:	90                   	nop
  8032c9:	c9                   	leave  
  8032ca:	c3                   	ret    
  8032cb:	90                   	nop

008032cc <__udivdi3>:
  8032cc:	55                   	push   %ebp
  8032cd:	57                   	push   %edi
  8032ce:	56                   	push   %esi
  8032cf:	53                   	push   %ebx
  8032d0:	83 ec 1c             	sub    $0x1c,%esp
  8032d3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8032d7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8032db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8032e3:	89 ca                	mov    %ecx,%edx
  8032e5:	89 f8                	mov    %edi,%eax
  8032e7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8032eb:	85 f6                	test   %esi,%esi
  8032ed:	75 2d                	jne    80331c <__udivdi3+0x50>
  8032ef:	39 cf                	cmp    %ecx,%edi
  8032f1:	77 65                	ja     803358 <__udivdi3+0x8c>
  8032f3:	89 fd                	mov    %edi,%ebp
  8032f5:	85 ff                	test   %edi,%edi
  8032f7:	75 0b                	jne    803304 <__udivdi3+0x38>
  8032f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8032fe:	31 d2                	xor    %edx,%edx
  803300:	f7 f7                	div    %edi
  803302:	89 c5                	mov    %eax,%ebp
  803304:	31 d2                	xor    %edx,%edx
  803306:	89 c8                	mov    %ecx,%eax
  803308:	f7 f5                	div    %ebp
  80330a:	89 c1                	mov    %eax,%ecx
  80330c:	89 d8                	mov    %ebx,%eax
  80330e:	f7 f5                	div    %ebp
  803310:	89 cf                	mov    %ecx,%edi
  803312:	89 fa                	mov    %edi,%edx
  803314:	83 c4 1c             	add    $0x1c,%esp
  803317:	5b                   	pop    %ebx
  803318:	5e                   	pop    %esi
  803319:	5f                   	pop    %edi
  80331a:	5d                   	pop    %ebp
  80331b:	c3                   	ret    
  80331c:	39 ce                	cmp    %ecx,%esi
  80331e:	77 28                	ja     803348 <__udivdi3+0x7c>
  803320:	0f bd fe             	bsr    %esi,%edi
  803323:	83 f7 1f             	xor    $0x1f,%edi
  803326:	75 40                	jne    803368 <__udivdi3+0x9c>
  803328:	39 ce                	cmp    %ecx,%esi
  80332a:	72 0a                	jb     803336 <__udivdi3+0x6a>
  80332c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803330:	0f 87 9e 00 00 00    	ja     8033d4 <__udivdi3+0x108>
  803336:	b8 01 00 00 00       	mov    $0x1,%eax
  80333b:	89 fa                	mov    %edi,%edx
  80333d:	83 c4 1c             	add    $0x1c,%esp
  803340:	5b                   	pop    %ebx
  803341:	5e                   	pop    %esi
  803342:	5f                   	pop    %edi
  803343:	5d                   	pop    %ebp
  803344:	c3                   	ret    
  803345:	8d 76 00             	lea    0x0(%esi),%esi
  803348:	31 ff                	xor    %edi,%edi
  80334a:	31 c0                	xor    %eax,%eax
  80334c:	89 fa                	mov    %edi,%edx
  80334e:	83 c4 1c             	add    $0x1c,%esp
  803351:	5b                   	pop    %ebx
  803352:	5e                   	pop    %esi
  803353:	5f                   	pop    %edi
  803354:	5d                   	pop    %ebp
  803355:	c3                   	ret    
  803356:	66 90                	xchg   %ax,%ax
  803358:	89 d8                	mov    %ebx,%eax
  80335a:	f7 f7                	div    %edi
  80335c:	31 ff                	xor    %edi,%edi
  80335e:	89 fa                	mov    %edi,%edx
  803360:	83 c4 1c             	add    $0x1c,%esp
  803363:	5b                   	pop    %ebx
  803364:	5e                   	pop    %esi
  803365:	5f                   	pop    %edi
  803366:	5d                   	pop    %ebp
  803367:	c3                   	ret    
  803368:	bd 20 00 00 00       	mov    $0x20,%ebp
  80336d:	89 eb                	mov    %ebp,%ebx
  80336f:	29 fb                	sub    %edi,%ebx
  803371:	89 f9                	mov    %edi,%ecx
  803373:	d3 e6                	shl    %cl,%esi
  803375:	89 c5                	mov    %eax,%ebp
  803377:	88 d9                	mov    %bl,%cl
  803379:	d3 ed                	shr    %cl,%ebp
  80337b:	89 e9                	mov    %ebp,%ecx
  80337d:	09 f1                	or     %esi,%ecx
  80337f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803383:	89 f9                	mov    %edi,%ecx
  803385:	d3 e0                	shl    %cl,%eax
  803387:	89 c5                	mov    %eax,%ebp
  803389:	89 d6                	mov    %edx,%esi
  80338b:	88 d9                	mov    %bl,%cl
  80338d:	d3 ee                	shr    %cl,%esi
  80338f:	89 f9                	mov    %edi,%ecx
  803391:	d3 e2                	shl    %cl,%edx
  803393:	8b 44 24 08          	mov    0x8(%esp),%eax
  803397:	88 d9                	mov    %bl,%cl
  803399:	d3 e8                	shr    %cl,%eax
  80339b:	09 c2                	or     %eax,%edx
  80339d:	89 d0                	mov    %edx,%eax
  80339f:	89 f2                	mov    %esi,%edx
  8033a1:	f7 74 24 0c          	divl   0xc(%esp)
  8033a5:	89 d6                	mov    %edx,%esi
  8033a7:	89 c3                	mov    %eax,%ebx
  8033a9:	f7 e5                	mul    %ebp
  8033ab:	39 d6                	cmp    %edx,%esi
  8033ad:	72 19                	jb     8033c8 <__udivdi3+0xfc>
  8033af:	74 0b                	je     8033bc <__udivdi3+0xf0>
  8033b1:	89 d8                	mov    %ebx,%eax
  8033b3:	31 ff                	xor    %edi,%edi
  8033b5:	e9 58 ff ff ff       	jmp    803312 <__udivdi3+0x46>
  8033ba:	66 90                	xchg   %ax,%ax
  8033bc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8033c0:	89 f9                	mov    %edi,%ecx
  8033c2:	d3 e2                	shl    %cl,%edx
  8033c4:	39 c2                	cmp    %eax,%edx
  8033c6:	73 e9                	jae    8033b1 <__udivdi3+0xe5>
  8033c8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8033cb:	31 ff                	xor    %edi,%edi
  8033cd:	e9 40 ff ff ff       	jmp    803312 <__udivdi3+0x46>
  8033d2:	66 90                	xchg   %ax,%ax
  8033d4:	31 c0                	xor    %eax,%eax
  8033d6:	e9 37 ff ff ff       	jmp    803312 <__udivdi3+0x46>
  8033db:	90                   	nop

008033dc <__umoddi3>:
  8033dc:	55                   	push   %ebp
  8033dd:	57                   	push   %edi
  8033de:	56                   	push   %esi
  8033df:	53                   	push   %ebx
  8033e0:	83 ec 1c             	sub    $0x1c,%esp
  8033e3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8033e7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8033eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033ef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8033f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033fb:	89 f3                	mov    %esi,%ebx
  8033fd:	89 fa                	mov    %edi,%edx
  8033ff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803403:	89 34 24             	mov    %esi,(%esp)
  803406:	85 c0                	test   %eax,%eax
  803408:	75 1a                	jne    803424 <__umoddi3+0x48>
  80340a:	39 f7                	cmp    %esi,%edi
  80340c:	0f 86 a2 00 00 00    	jbe    8034b4 <__umoddi3+0xd8>
  803412:	89 c8                	mov    %ecx,%eax
  803414:	89 f2                	mov    %esi,%edx
  803416:	f7 f7                	div    %edi
  803418:	89 d0                	mov    %edx,%eax
  80341a:	31 d2                	xor    %edx,%edx
  80341c:	83 c4 1c             	add    $0x1c,%esp
  80341f:	5b                   	pop    %ebx
  803420:	5e                   	pop    %esi
  803421:	5f                   	pop    %edi
  803422:	5d                   	pop    %ebp
  803423:	c3                   	ret    
  803424:	39 f0                	cmp    %esi,%eax
  803426:	0f 87 ac 00 00 00    	ja     8034d8 <__umoddi3+0xfc>
  80342c:	0f bd e8             	bsr    %eax,%ebp
  80342f:	83 f5 1f             	xor    $0x1f,%ebp
  803432:	0f 84 ac 00 00 00    	je     8034e4 <__umoddi3+0x108>
  803438:	bf 20 00 00 00       	mov    $0x20,%edi
  80343d:	29 ef                	sub    %ebp,%edi
  80343f:	89 fe                	mov    %edi,%esi
  803441:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803445:	89 e9                	mov    %ebp,%ecx
  803447:	d3 e0                	shl    %cl,%eax
  803449:	89 d7                	mov    %edx,%edi
  80344b:	89 f1                	mov    %esi,%ecx
  80344d:	d3 ef                	shr    %cl,%edi
  80344f:	09 c7                	or     %eax,%edi
  803451:	89 e9                	mov    %ebp,%ecx
  803453:	d3 e2                	shl    %cl,%edx
  803455:	89 14 24             	mov    %edx,(%esp)
  803458:	89 d8                	mov    %ebx,%eax
  80345a:	d3 e0                	shl    %cl,%eax
  80345c:	89 c2                	mov    %eax,%edx
  80345e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803462:	d3 e0                	shl    %cl,%eax
  803464:	89 44 24 04          	mov    %eax,0x4(%esp)
  803468:	8b 44 24 08          	mov    0x8(%esp),%eax
  80346c:	89 f1                	mov    %esi,%ecx
  80346e:	d3 e8                	shr    %cl,%eax
  803470:	09 d0                	or     %edx,%eax
  803472:	d3 eb                	shr    %cl,%ebx
  803474:	89 da                	mov    %ebx,%edx
  803476:	f7 f7                	div    %edi
  803478:	89 d3                	mov    %edx,%ebx
  80347a:	f7 24 24             	mull   (%esp)
  80347d:	89 c6                	mov    %eax,%esi
  80347f:	89 d1                	mov    %edx,%ecx
  803481:	39 d3                	cmp    %edx,%ebx
  803483:	0f 82 87 00 00 00    	jb     803510 <__umoddi3+0x134>
  803489:	0f 84 91 00 00 00    	je     803520 <__umoddi3+0x144>
  80348f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803493:	29 f2                	sub    %esi,%edx
  803495:	19 cb                	sbb    %ecx,%ebx
  803497:	89 d8                	mov    %ebx,%eax
  803499:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80349d:	d3 e0                	shl    %cl,%eax
  80349f:	89 e9                	mov    %ebp,%ecx
  8034a1:	d3 ea                	shr    %cl,%edx
  8034a3:	09 d0                	or     %edx,%eax
  8034a5:	89 e9                	mov    %ebp,%ecx
  8034a7:	d3 eb                	shr    %cl,%ebx
  8034a9:	89 da                	mov    %ebx,%edx
  8034ab:	83 c4 1c             	add    $0x1c,%esp
  8034ae:	5b                   	pop    %ebx
  8034af:	5e                   	pop    %esi
  8034b0:	5f                   	pop    %edi
  8034b1:	5d                   	pop    %ebp
  8034b2:	c3                   	ret    
  8034b3:	90                   	nop
  8034b4:	89 fd                	mov    %edi,%ebp
  8034b6:	85 ff                	test   %edi,%edi
  8034b8:	75 0b                	jne    8034c5 <__umoddi3+0xe9>
  8034ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8034bf:	31 d2                	xor    %edx,%edx
  8034c1:	f7 f7                	div    %edi
  8034c3:	89 c5                	mov    %eax,%ebp
  8034c5:	89 f0                	mov    %esi,%eax
  8034c7:	31 d2                	xor    %edx,%edx
  8034c9:	f7 f5                	div    %ebp
  8034cb:	89 c8                	mov    %ecx,%eax
  8034cd:	f7 f5                	div    %ebp
  8034cf:	89 d0                	mov    %edx,%eax
  8034d1:	e9 44 ff ff ff       	jmp    80341a <__umoddi3+0x3e>
  8034d6:	66 90                	xchg   %ax,%ax
  8034d8:	89 c8                	mov    %ecx,%eax
  8034da:	89 f2                	mov    %esi,%edx
  8034dc:	83 c4 1c             	add    $0x1c,%esp
  8034df:	5b                   	pop    %ebx
  8034e0:	5e                   	pop    %esi
  8034e1:	5f                   	pop    %edi
  8034e2:	5d                   	pop    %ebp
  8034e3:	c3                   	ret    
  8034e4:	3b 04 24             	cmp    (%esp),%eax
  8034e7:	72 06                	jb     8034ef <__umoddi3+0x113>
  8034e9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8034ed:	77 0f                	ja     8034fe <__umoddi3+0x122>
  8034ef:	89 f2                	mov    %esi,%edx
  8034f1:	29 f9                	sub    %edi,%ecx
  8034f3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8034f7:	89 14 24             	mov    %edx,(%esp)
  8034fa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034fe:	8b 44 24 04          	mov    0x4(%esp),%eax
  803502:	8b 14 24             	mov    (%esp),%edx
  803505:	83 c4 1c             	add    $0x1c,%esp
  803508:	5b                   	pop    %ebx
  803509:	5e                   	pop    %esi
  80350a:	5f                   	pop    %edi
  80350b:	5d                   	pop    %ebp
  80350c:	c3                   	ret    
  80350d:	8d 76 00             	lea    0x0(%esi),%esi
  803510:	2b 04 24             	sub    (%esp),%eax
  803513:	19 fa                	sbb    %edi,%edx
  803515:	89 d1                	mov    %edx,%ecx
  803517:	89 c6                	mov    %eax,%esi
  803519:	e9 71 ff ff ff       	jmp    80348f <__umoddi3+0xb3>
  80351e:	66 90                	xchg   %ax,%ax
  803520:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803524:	72 ea                	jb     803510 <__umoddi3+0x134>
  803526:	89 d9                	mov    %ebx,%ecx
  803528:	e9 62 ff ff ff       	jmp    80348f <__umoddi3+0xb3>
