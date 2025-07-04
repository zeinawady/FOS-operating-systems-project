
obj/user/tst_syscalls_2:     file format elf32-i386


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
  800031:	e8 fb 00 00 00       	call   800131 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the correct validation of system call params
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	rsttst();
  80003e:	e8 68 14 00 00       	call   8014ab <rsttst>
	int ID1 = sys_create_env("tsc2_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800043:	a1 08 30 80 00       	mov    0x803008,%eax
  800048:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  80004e:	a1 08 30 80 00       	mov    0x803008,%eax
  800053:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  800059:	89 c1                	mov    %eax,%ecx
  80005b:	a1 08 30 80 00       	mov    0x803008,%eax
  800060:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800066:	52                   	push   %edx
  800067:	51                   	push   %ecx
  800068:	50                   	push   %eax
  800069:	68 a0 1c 80 00       	push   $0x801ca0
  80006e:	e8 ec 12 00 00       	call   80135f <sys_create_env>
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_run_env(ID1);
  800079:	83 ec 0c             	sub    $0xc,%esp
  80007c:	ff 75 f4             	pushl  -0xc(%ebp)
  80007f:	e8 f9 12 00 00       	call   80137d <sys_run_env>
  800084:	83 c4 10             	add    $0x10,%esp

	int ID2 = sys_create_env("tsc2_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800087:	a1 08 30 80 00       	mov    0x803008,%eax
  80008c:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  800092:	a1 08 30 80 00       	mov    0x803008,%eax
  800097:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  80009d:	89 c1                	mov    %eax,%ecx
  80009f:	a1 08 30 80 00       	mov    0x803008,%eax
  8000a4:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000aa:	52                   	push   %edx
  8000ab:	51                   	push   %ecx
  8000ac:	50                   	push   %eax
  8000ad:	68 ac 1c 80 00       	push   $0x801cac
  8000b2:	e8 a8 12 00 00       	call   80135f <sys_create_env>
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	sys_run_env(ID2);

	int ID3 = sys_create_env("tsc2_slave3", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000bd:	a1 08 30 80 00       	mov    0x803008,%eax
  8000c2:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  8000c8:	a1 08 30 80 00       	mov    0x803008,%eax
  8000cd:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  8000d3:	89 c1                	mov    %eax,%ecx
  8000d5:	a1 08 30 80 00       	mov    0x803008,%eax
  8000da:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000e0:	52                   	push   %edx
  8000e1:	51                   	push   %ecx
  8000e2:	50                   	push   %eax
  8000e3:	68 b8 1c 80 00       	push   $0x801cb8
  8000e8:	e8 72 12 00 00       	call   80135f <sys_create_env>
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
//	sys_run_env(ID3);
	env_sleep(10000);
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	68 10 27 00 00       	push   $0x2710
  8000fb:	e8 81 16 00 00       	call   801781 <env_sleep>
  800100:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  800103:	e8 1d 14 00 00       	call   801525 <gettst>
  800108:	85 c0                	test   %eax,%eax
  80010a:	74 12                	je     80011e <_main+0xe6>
		cprintf("\ntst_syscalls_2 Failed.\n");
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	68 c4 1c 80 00       	push   $0x801cc4
  800114:	e8 31 02 00 00       	call   80034a <cprintf>
  800119:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("\nCongratulations... tst system calls #2 completed successfully\n");

}
  80011c:	eb 10                	jmp    80012e <_main+0xf6>
	env_sleep(10000);

	if (gettst() != 0)
		cprintf("\ntst_syscalls_2 Failed.\n");
	else
		cprintf("\nCongratulations... tst system calls #2 completed successfully\n");
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 e0 1c 80 00       	push   $0x801ce0
  800126:	e8 1f 02 00 00       	call   80034a <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp

}
  80012e:	90                   	nop
  80012f:	c9                   	leave  
  800130:	c3                   	ret    

00800131 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800131:	55                   	push   %ebp
  800132:	89 e5                	mov    %esp,%ebp
  800134:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800137:	e8 91 12 00 00       	call   8013cd <sys_getenvindex>
  80013c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80013f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800142:	89 d0                	mov    %edx,%eax
  800144:	c1 e0 02             	shl    $0x2,%eax
  800147:	01 d0                	add    %edx,%eax
  800149:	c1 e0 03             	shl    $0x3,%eax
  80014c:	01 d0                	add    %edx,%eax
  80014e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800155:	01 d0                	add    %edx,%eax
  800157:	c1 e0 02             	shl    $0x2,%eax
  80015a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80015f:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800164:	a1 08 30 80 00       	mov    0x803008,%eax
  800169:	8a 40 20             	mov    0x20(%eax),%al
  80016c:	84 c0                	test   %al,%al
  80016e:	74 0d                	je     80017d <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800170:	a1 08 30 80 00       	mov    0x803008,%eax
  800175:	83 c0 20             	add    $0x20,%eax
  800178:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80017d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800181:	7e 0a                	jle    80018d <libmain+0x5c>
		binaryname = argv[0];
  800183:	8b 45 0c             	mov    0xc(%ebp),%eax
  800186:	8b 00                	mov    (%eax),%eax
  800188:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 0c             	pushl  0xc(%ebp)
  800193:	ff 75 08             	pushl  0x8(%ebp)
  800196:	e8 9d fe ff ff       	call   800038 <_main>
  80019b:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80019e:	a1 00 30 80 00       	mov    0x803000,%eax
  8001a3:	85 c0                	test   %eax,%eax
  8001a5:	0f 84 9f 00 00 00    	je     80024a <libmain+0x119>
	{
		sys_lock_cons();
  8001ab:	e8 a1 0f 00 00       	call   801151 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001b0:	83 ec 0c             	sub    $0xc,%esp
  8001b3:	68 38 1d 80 00       	push   $0x801d38
  8001b8:	e8 8d 01 00 00       	call   80034a <cprintf>
  8001bd:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c0:	a1 08 30 80 00       	mov    0x803008,%eax
  8001c5:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001cb:	a1 08 30 80 00       	mov    0x803008,%eax
  8001d0:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8001d6:	83 ec 04             	sub    $0x4,%esp
  8001d9:	52                   	push   %edx
  8001da:	50                   	push   %eax
  8001db:	68 60 1d 80 00       	push   $0x801d60
  8001e0:	e8 65 01 00 00       	call   80034a <cprintf>
  8001e5:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e8:	a1 08 30 80 00       	mov    0x803008,%eax
  8001ed:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8001f3:	a1 08 30 80 00       	mov    0x803008,%eax
  8001f8:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8001fe:	a1 08 30 80 00       	mov    0x803008,%eax
  800203:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800209:	51                   	push   %ecx
  80020a:	52                   	push   %edx
  80020b:	50                   	push   %eax
  80020c:	68 88 1d 80 00       	push   $0x801d88
  800211:	e8 34 01 00 00       	call   80034a <cprintf>
  800216:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800219:	a1 08 30 80 00       	mov    0x803008,%eax
  80021e:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800224:	83 ec 08             	sub    $0x8,%esp
  800227:	50                   	push   %eax
  800228:	68 e0 1d 80 00       	push   $0x801de0
  80022d:	e8 18 01 00 00       	call   80034a <cprintf>
  800232:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800235:	83 ec 0c             	sub    $0xc,%esp
  800238:	68 38 1d 80 00       	push   $0x801d38
  80023d:	e8 08 01 00 00       	call   80034a <cprintf>
  800242:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800245:	e8 21 0f 00 00       	call   80116b <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80024a:	e8 19 00 00 00       	call   800268 <exit>
}
  80024f:	90                   	nop
  800250:	c9                   	leave  
  800251:	c3                   	ret    

00800252 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800258:	83 ec 0c             	sub    $0xc,%esp
  80025b:	6a 00                	push   $0x0
  80025d:	e8 37 11 00 00       	call   801399 <sys_destroy_env>
  800262:	83 c4 10             	add    $0x10,%esp
}
  800265:	90                   	nop
  800266:	c9                   	leave  
  800267:	c3                   	ret    

00800268 <exit>:

void
exit(void)
{
  800268:	55                   	push   %ebp
  800269:	89 e5                	mov    %esp,%ebp
  80026b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80026e:	e8 8c 11 00 00       	call   8013ff <sys_exit_env>
}
  800273:	90                   	nop
  800274:	c9                   	leave  
  800275:	c3                   	ret    

00800276 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800276:	55                   	push   %ebp
  800277:	89 e5                	mov    %esp,%ebp
  800279:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80027c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027f:	8b 00                	mov    (%eax),%eax
  800281:	8d 48 01             	lea    0x1(%eax),%ecx
  800284:	8b 55 0c             	mov    0xc(%ebp),%edx
  800287:	89 0a                	mov    %ecx,(%edx)
  800289:	8b 55 08             	mov    0x8(%ebp),%edx
  80028c:	88 d1                	mov    %dl,%cl
  80028e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800291:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800295:	8b 45 0c             	mov    0xc(%ebp),%eax
  800298:	8b 00                	mov    (%eax),%eax
  80029a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80029f:	75 2c                	jne    8002cd <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002a1:	a0 0c 30 80 00       	mov    0x80300c,%al
  8002a6:	0f b6 c0             	movzbl %al,%eax
  8002a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ac:	8b 12                	mov    (%edx),%edx
  8002ae:	89 d1                	mov    %edx,%ecx
  8002b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b3:	83 c2 08             	add    $0x8,%edx
  8002b6:	83 ec 04             	sub    $0x4,%esp
  8002b9:	50                   	push   %eax
  8002ba:	51                   	push   %ecx
  8002bb:	52                   	push   %edx
  8002bc:	e8 4e 0e 00 00       	call   80110f <sys_cputs>
  8002c1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d0:	8b 40 04             	mov    0x4(%eax),%eax
  8002d3:	8d 50 01             	lea    0x1(%eax),%edx
  8002d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002dc:	90                   	nop
  8002dd:	c9                   	leave  
  8002de:	c3                   	ret    

008002df <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002df:	55                   	push   %ebp
  8002e0:	89 e5                	mov    %esp,%ebp
  8002e2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002e8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ef:	00 00 00 
	b.cnt = 0;
  8002f2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f9:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002fc:	ff 75 0c             	pushl  0xc(%ebp)
  8002ff:	ff 75 08             	pushl  0x8(%ebp)
  800302:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800308:	50                   	push   %eax
  800309:	68 76 02 80 00       	push   $0x800276
  80030e:	e8 11 02 00 00       	call   800524 <vprintfmt>
  800313:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800316:	a0 0c 30 80 00       	mov    0x80300c,%al
  80031b:	0f b6 c0             	movzbl %al,%eax
  80031e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800324:	83 ec 04             	sub    $0x4,%esp
  800327:	50                   	push   %eax
  800328:	52                   	push   %edx
  800329:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80032f:	83 c0 08             	add    $0x8,%eax
  800332:	50                   	push   %eax
  800333:	e8 d7 0d 00 00       	call   80110f <sys_cputs>
  800338:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80033b:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  800342:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800348:	c9                   	leave  
  800349:	c3                   	ret    

0080034a <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80034a:	55                   	push   %ebp
  80034b:	89 e5                	mov    %esp,%ebp
  80034d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800350:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  800357:	8d 45 0c             	lea    0xc(%ebp),%eax
  80035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80035d:	8b 45 08             	mov    0x8(%ebp),%eax
  800360:	83 ec 08             	sub    $0x8,%esp
  800363:	ff 75 f4             	pushl  -0xc(%ebp)
  800366:	50                   	push   %eax
  800367:	e8 73 ff ff ff       	call   8002df <vcprintf>
  80036c:	83 c4 10             	add    $0x10,%esp
  80036f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800372:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800375:	c9                   	leave  
  800376:	c3                   	ret    

00800377 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800377:	55                   	push   %ebp
  800378:	89 e5                	mov    %esp,%ebp
  80037a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80037d:	e8 cf 0d 00 00       	call   801151 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800382:	8d 45 0c             	lea    0xc(%ebp),%eax
  800385:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	83 ec 08             	sub    $0x8,%esp
  80038e:	ff 75 f4             	pushl  -0xc(%ebp)
  800391:	50                   	push   %eax
  800392:	e8 48 ff ff ff       	call   8002df <vcprintf>
  800397:	83 c4 10             	add    $0x10,%esp
  80039a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80039d:	e8 c9 0d 00 00       	call   80116b <sys_unlock_cons>
	return cnt;
  8003a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a5:	c9                   	leave  
  8003a6:	c3                   	ret    

008003a7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a7:	55                   	push   %ebp
  8003a8:	89 e5                	mov    %esp,%ebp
  8003aa:	53                   	push   %ebx
  8003ab:	83 ec 14             	sub    $0x14,%esp
  8003ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003ba:	8b 45 18             	mov    0x18(%ebp),%eax
  8003bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003c5:	77 55                	ja     80041c <printnum+0x75>
  8003c7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003ca:	72 05                	jb     8003d1 <printnum+0x2a>
  8003cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003cf:	77 4b                	ja     80041c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003d4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003d7:	8b 45 18             	mov    0x18(%ebp),%eax
  8003da:	ba 00 00 00 00       	mov    $0x0,%edx
  8003df:	52                   	push   %edx
  8003e0:	50                   	push   %eax
  8003e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e4:	ff 75 f0             	pushl  -0x10(%ebp)
  8003e7:	e8 34 16 00 00       	call   801a20 <__udivdi3>
  8003ec:	83 c4 10             	add    $0x10,%esp
  8003ef:	83 ec 04             	sub    $0x4,%esp
  8003f2:	ff 75 20             	pushl  0x20(%ebp)
  8003f5:	53                   	push   %ebx
  8003f6:	ff 75 18             	pushl  0x18(%ebp)
  8003f9:	52                   	push   %edx
  8003fa:	50                   	push   %eax
  8003fb:	ff 75 0c             	pushl  0xc(%ebp)
  8003fe:	ff 75 08             	pushl  0x8(%ebp)
  800401:	e8 a1 ff ff ff       	call   8003a7 <printnum>
  800406:	83 c4 20             	add    $0x20,%esp
  800409:	eb 1a                	jmp    800425 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80040b:	83 ec 08             	sub    $0x8,%esp
  80040e:	ff 75 0c             	pushl  0xc(%ebp)
  800411:	ff 75 20             	pushl  0x20(%ebp)
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	ff d0                	call   *%eax
  800419:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80041c:	ff 4d 1c             	decl   0x1c(%ebp)
  80041f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800423:	7f e6                	jg     80040b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800425:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800428:	bb 00 00 00 00       	mov    $0x0,%ebx
  80042d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800430:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800433:	53                   	push   %ebx
  800434:	51                   	push   %ecx
  800435:	52                   	push   %edx
  800436:	50                   	push   %eax
  800437:	e8 f4 16 00 00       	call   801b30 <__umoddi3>
  80043c:	83 c4 10             	add    $0x10,%esp
  80043f:	05 14 20 80 00       	add    $0x802014,%eax
  800444:	8a 00                	mov    (%eax),%al
  800446:	0f be c0             	movsbl %al,%eax
  800449:	83 ec 08             	sub    $0x8,%esp
  80044c:	ff 75 0c             	pushl  0xc(%ebp)
  80044f:	50                   	push   %eax
  800450:	8b 45 08             	mov    0x8(%ebp),%eax
  800453:	ff d0                	call   *%eax
  800455:	83 c4 10             	add    $0x10,%esp
}
  800458:	90                   	nop
  800459:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80045c:	c9                   	leave  
  80045d:	c3                   	ret    

0080045e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80045e:	55                   	push   %ebp
  80045f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800461:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800465:	7e 1c                	jle    800483 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800467:	8b 45 08             	mov    0x8(%ebp),%eax
  80046a:	8b 00                	mov    (%eax),%eax
  80046c:	8d 50 08             	lea    0x8(%eax),%edx
  80046f:	8b 45 08             	mov    0x8(%ebp),%eax
  800472:	89 10                	mov    %edx,(%eax)
  800474:	8b 45 08             	mov    0x8(%ebp),%eax
  800477:	8b 00                	mov    (%eax),%eax
  800479:	83 e8 08             	sub    $0x8,%eax
  80047c:	8b 50 04             	mov    0x4(%eax),%edx
  80047f:	8b 00                	mov    (%eax),%eax
  800481:	eb 40                	jmp    8004c3 <getuint+0x65>
	else if (lflag)
  800483:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800487:	74 1e                	je     8004a7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800489:	8b 45 08             	mov    0x8(%ebp),%eax
  80048c:	8b 00                	mov    (%eax),%eax
  80048e:	8d 50 04             	lea    0x4(%eax),%edx
  800491:	8b 45 08             	mov    0x8(%ebp),%eax
  800494:	89 10                	mov    %edx,(%eax)
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	8b 00                	mov    (%eax),%eax
  80049b:	83 e8 04             	sub    $0x4,%eax
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a5:	eb 1c                	jmp    8004c3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004aa:	8b 00                	mov    (%eax),%eax
  8004ac:	8d 50 04             	lea    0x4(%eax),%edx
  8004af:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b2:	89 10                	mov    %edx,(%eax)
  8004b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	83 e8 04             	sub    $0x4,%eax
  8004bc:	8b 00                	mov    (%eax),%eax
  8004be:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004c3:	5d                   	pop    %ebp
  8004c4:	c3                   	ret    

008004c5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004c5:	55                   	push   %ebp
  8004c6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004c8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004cc:	7e 1c                	jle    8004ea <getint+0x25>
		return va_arg(*ap, long long);
  8004ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d1:	8b 00                	mov    (%eax),%eax
  8004d3:	8d 50 08             	lea    0x8(%eax),%edx
  8004d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d9:	89 10                	mov    %edx,(%eax)
  8004db:	8b 45 08             	mov    0x8(%ebp),%eax
  8004de:	8b 00                	mov    (%eax),%eax
  8004e0:	83 e8 08             	sub    $0x8,%eax
  8004e3:	8b 50 04             	mov    0x4(%eax),%edx
  8004e6:	8b 00                	mov    (%eax),%eax
  8004e8:	eb 38                	jmp    800522 <getint+0x5d>
	else if (lflag)
  8004ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004ee:	74 1a                	je     80050a <getint+0x45>
		return va_arg(*ap, long);
  8004f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f3:	8b 00                	mov    (%eax),%eax
  8004f5:	8d 50 04             	lea    0x4(%eax),%edx
  8004f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fb:	89 10                	mov    %edx,(%eax)
  8004fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800500:	8b 00                	mov    (%eax),%eax
  800502:	83 e8 04             	sub    $0x4,%eax
  800505:	8b 00                	mov    (%eax),%eax
  800507:	99                   	cltd   
  800508:	eb 18                	jmp    800522 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80050a:	8b 45 08             	mov    0x8(%ebp),%eax
  80050d:	8b 00                	mov    (%eax),%eax
  80050f:	8d 50 04             	lea    0x4(%eax),%edx
  800512:	8b 45 08             	mov    0x8(%ebp),%eax
  800515:	89 10                	mov    %edx,(%eax)
  800517:	8b 45 08             	mov    0x8(%ebp),%eax
  80051a:	8b 00                	mov    (%eax),%eax
  80051c:	83 e8 04             	sub    $0x4,%eax
  80051f:	8b 00                	mov    (%eax),%eax
  800521:	99                   	cltd   
}
  800522:	5d                   	pop    %ebp
  800523:	c3                   	ret    

00800524 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800524:	55                   	push   %ebp
  800525:	89 e5                	mov    %esp,%ebp
  800527:	56                   	push   %esi
  800528:	53                   	push   %ebx
  800529:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80052c:	eb 17                	jmp    800545 <vprintfmt+0x21>
			if (ch == '\0')
  80052e:	85 db                	test   %ebx,%ebx
  800530:	0f 84 c1 03 00 00    	je     8008f7 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800536:	83 ec 08             	sub    $0x8,%esp
  800539:	ff 75 0c             	pushl  0xc(%ebp)
  80053c:	53                   	push   %ebx
  80053d:	8b 45 08             	mov    0x8(%ebp),%eax
  800540:	ff d0                	call   *%eax
  800542:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800545:	8b 45 10             	mov    0x10(%ebp),%eax
  800548:	8d 50 01             	lea    0x1(%eax),%edx
  80054b:	89 55 10             	mov    %edx,0x10(%ebp)
  80054e:	8a 00                	mov    (%eax),%al
  800550:	0f b6 d8             	movzbl %al,%ebx
  800553:	83 fb 25             	cmp    $0x25,%ebx
  800556:	75 d6                	jne    80052e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800558:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80055c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800563:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80056a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800571:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800578:	8b 45 10             	mov    0x10(%ebp),%eax
  80057b:	8d 50 01             	lea    0x1(%eax),%edx
  80057e:	89 55 10             	mov    %edx,0x10(%ebp)
  800581:	8a 00                	mov    (%eax),%al
  800583:	0f b6 d8             	movzbl %al,%ebx
  800586:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800589:	83 f8 5b             	cmp    $0x5b,%eax
  80058c:	0f 87 3d 03 00 00    	ja     8008cf <vprintfmt+0x3ab>
  800592:	8b 04 85 38 20 80 00 	mov    0x802038(,%eax,4),%eax
  800599:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80059b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80059f:	eb d7                	jmp    800578 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005a1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005a5:	eb d1                	jmp    800578 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005a7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005ae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b1:	89 d0                	mov    %edx,%eax
  8005b3:	c1 e0 02             	shl    $0x2,%eax
  8005b6:	01 d0                	add    %edx,%eax
  8005b8:	01 c0                	add    %eax,%eax
  8005ba:	01 d8                	add    %ebx,%eax
  8005bc:	83 e8 30             	sub    $0x30,%eax
  8005bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c5:	8a 00                	mov    (%eax),%al
  8005c7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005ca:	83 fb 2f             	cmp    $0x2f,%ebx
  8005cd:	7e 3e                	jle    80060d <vprintfmt+0xe9>
  8005cf:	83 fb 39             	cmp    $0x39,%ebx
  8005d2:	7f 39                	jg     80060d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005d7:	eb d5                	jmp    8005ae <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	83 c0 04             	add    $0x4,%eax
  8005df:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	83 e8 04             	sub    $0x4,%eax
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005ed:	eb 1f                	jmp    80060e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f3:	79 83                	jns    800578 <vprintfmt+0x54>
				width = 0;
  8005f5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005fc:	e9 77 ff ff ff       	jmp    800578 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800601:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800608:	e9 6b ff ff ff       	jmp    800578 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80060d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80060e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800612:	0f 89 60 ff ff ff    	jns    800578 <vprintfmt+0x54>
				width = precision, precision = -1;
  800618:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80061b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80061e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800625:	e9 4e ff ff ff       	jmp    800578 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80062a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80062d:	e9 46 ff ff ff       	jmp    800578 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	83 c0 04             	add    $0x4,%eax
  800638:	89 45 14             	mov    %eax,0x14(%ebp)
  80063b:	8b 45 14             	mov    0x14(%ebp),%eax
  80063e:	83 e8 04             	sub    $0x4,%eax
  800641:	8b 00                	mov    (%eax),%eax
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	ff 75 0c             	pushl  0xc(%ebp)
  800649:	50                   	push   %eax
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	ff d0                	call   *%eax
  80064f:	83 c4 10             	add    $0x10,%esp
			break;
  800652:	e9 9b 02 00 00       	jmp    8008f2 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	83 c0 04             	add    $0x4,%eax
  80065d:	89 45 14             	mov    %eax,0x14(%ebp)
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	83 e8 04             	sub    $0x4,%eax
  800666:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800668:	85 db                	test   %ebx,%ebx
  80066a:	79 02                	jns    80066e <vprintfmt+0x14a>
				err = -err;
  80066c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80066e:	83 fb 64             	cmp    $0x64,%ebx
  800671:	7f 0b                	jg     80067e <vprintfmt+0x15a>
  800673:	8b 34 9d 80 1e 80 00 	mov    0x801e80(,%ebx,4),%esi
  80067a:	85 f6                	test   %esi,%esi
  80067c:	75 19                	jne    800697 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80067e:	53                   	push   %ebx
  80067f:	68 25 20 80 00       	push   $0x802025
  800684:	ff 75 0c             	pushl  0xc(%ebp)
  800687:	ff 75 08             	pushl  0x8(%ebp)
  80068a:	e8 70 02 00 00       	call   8008ff <printfmt>
  80068f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800692:	e9 5b 02 00 00       	jmp    8008f2 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800697:	56                   	push   %esi
  800698:	68 2e 20 80 00       	push   $0x80202e
  80069d:	ff 75 0c             	pushl  0xc(%ebp)
  8006a0:	ff 75 08             	pushl  0x8(%ebp)
  8006a3:	e8 57 02 00 00       	call   8008ff <printfmt>
  8006a8:	83 c4 10             	add    $0x10,%esp
			break;
  8006ab:	e9 42 02 00 00       	jmp    8008f2 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b3:	83 c0 04             	add    $0x4,%eax
  8006b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bc:	83 e8 04             	sub    $0x4,%eax
  8006bf:	8b 30                	mov    (%eax),%esi
  8006c1:	85 f6                	test   %esi,%esi
  8006c3:	75 05                	jne    8006ca <vprintfmt+0x1a6>
				p = "(null)";
  8006c5:	be 31 20 80 00       	mov    $0x802031,%esi
			if (width > 0 && padc != '-')
  8006ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ce:	7e 6d                	jle    80073d <vprintfmt+0x219>
  8006d0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006d4:	74 67                	je     80073d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	50                   	push   %eax
  8006dd:	56                   	push   %esi
  8006de:	e8 1e 03 00 00       	call   800a01 <strnlen>
  8006e3:	83 c4 10             	add    $0x10,%esp
  8006e6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006e9:	eb 16                	jmp    800701 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006eb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006ef:	83 ec 08             	sub    $0x8,%esp
  8006f2:	ff 75 0c             	pushl  0xc(%ebp)
  8006f5:	50                   	push   %eax
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	ff d0                	call   *%eax
  8006fb:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006fe:	ff 4d e4             	decl   -0x1c(%ebp)
  800701:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800705:	7f e4                	jg     8006eb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800707:	eb 34                	jmp    80073d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800709:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80070d:	74 1c                	je     80072b <vprintfmt+0x207>
  80070f:	83 fb 1f             	cmp    $0x1f,%ebx
  800712:	7e 05                	jle    800719 <vprintfmt+0x1f5>
  800714:	83 fb 7e             	cmp    $0x7e,%ebx
  800717:	7e 12                	jle    80072b <vprintfmt+0x207>
					putch('?', putdat);
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	ff 75 0c             	pushl  0xc(%ebp)
  80071f:	6a 3f                	push   $0x3f
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	ff d0                	call   *%eax
  800726:	83 c4 10             	add    $0x10,%esp
  800729:	eb 0f                	jmp    80073a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	ff 75 0c             	pushl  0xc(%ebp)
  800731:	53                   	push   %ebx
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	ff d0                	call   *%eax
  800737:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80073a:	ff 4d e4             	decl   -0x1c(%ebp)
  80073d:	89 f0                	mov    %esi,%eax
  80073f:	8d 70 01             	lea    0x1(%eax),%esi
  800742:	8a 00                	mov    (%eax),%al
  800744:	0f be d8             	movsbl %al,%ebx
  800747:	85 db                	test   %ebx,%ebx
  800749:	74 24                	je     80076f <vprintfmt+0x24b>
  80074b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80074f:	78 b8                	js     800709 <vprintfmt+0x1e5>
  800751:	ff 4d e0             	decl   -0x20(%ebp)
  800754:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800758:	79 af                	jns    800709 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80075a:	eb 13                	jmp    80076f <vprintfmt+0x24b>
				putch(' ', putdat);
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	ff 75 0c             	pushl  0xc(%ebp)
  800762:	6a 20                	push   $0x20
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	ff d0                	call   *%eax
  800769:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80076c:	ff 4d e4             	decl   -0x1c(%ebp)
  80076f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800773:	7f e7                	jg     80075c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800775:	e9 78 01 00 00       	jmp    8008f2 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80077a:	83 ec 08             	sub    $0x8,%esp
  80077d:	ff 75 e8             	pushl  -0x18(%ebp)
  800780:	8d 45 14             	lea    0x14(%ebp),%eax
  800783:	50                   	push   %eax
  800784:	e8 3c fd ff ff       	call   8004c5 <getint>
  800789:	83 c4 10             	add    $0x10,%esp
  80078c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80078f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800792:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800795:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800798:	85 d2                	test   %edx,%edx
  80079a:	79 23                	jns    8007bf <vprintfmt+0x29b>
				putch('-', putdat);
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	ff 75 0c             	pushl  0xc(%ebp)
  8007a2:	6a 2d                	push   $0x2d
  8007a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a7:	ff d0                	call   *%eax
  8007a9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007b2:	f7 d8                	neg    %eax
  8007b4:	83 d2 00             	adc    $0x0,%edx
  8007b7:	f7 da                	neg    %edx
  8007b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007bc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007bf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007c6:	e9 bc 00 00 00       	jmp    800887 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	ff 75 e8             	pushl  -0x18(%ebp)
  8007d1:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d4:	50                   	push   %eax
  8007d5:	e8 84 fc ff ff       	call   80045e <getuint>
  8007da:	83 c4 10             	add    $0x10,%esp
  8007dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007e3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007ea:	e9 98 00 00 00       	jmp    800887 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007ef:	83 ec 08             	sub    $0x8,%esp
  8007f2:	ff 75 0c             	pushl  0xc(%ebp)
  8007f5:	6a 58                	push   $0x58
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	ff d0                	call   *%eax
  8007fc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007ff:	83 ec 08             	sub    $0x8,%esp
  800802:	ff 75 0c             	pushl  0xc(%ebp)
  800805:	6a 58                	push   $0x58
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	ff d0                	call   *%eax
  80080c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80080f:	83 ec 08             	sub    $0x8,%esp
  800812:	ff 75 0c             	pushl  0xc(%ebp)
  800815:	6a 58                	push   $0x58
  800817:	8b 45 08             	mov    0x8(%ebp),%eax
  80081a:	ff d0                	call   *%eax
  80081c:	83 c4 10             	add    $0x10,%esp
			break;
  80081f:	e9 ce 00 00 00       	jmp    8008f2 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800824:	83 ec 08             	sub    $0x8,%esp
  800827:	ff 75 0c             	pushl  0xc(%ebp)
  80082a:	6a 30                	push   $0x30
  80082c:	8b 45 08             	mov    0x8(%ebp),%eax
  80082f:	ff d0                	call   *%eax
  800831:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800834:	83 ec 08             	sub    $0x8,%esp
  800837:	ff 75 0c             	pushl  0xc(%ebp)
  80083a:	6a 78                	push   $0x78
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	ff d0                	call   *%eax
  800841:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800844:	8b 45 14             	mov    0x14(%ebp),%eax
  800847:	83 c0 04             	add    $0x4,%eax
  80084a:	89 45 14             	mov    %eax,0x14(%ebp)
  80084d:	8b 45 14             	mov    0x14(%ebp),%eax
  800850:	83 e8 04             	sub    $0x4,%eax
  800853:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800855:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800858:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80085f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800866:	eb 1f                	jmp    800887 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800868:	83 ec 08             	sub    $0x8,%esp
  80086b:	ff 75 e8             	pushl  -0x18(%ebp)
  80086e:	8d 45 14             	lea    0x14(%ebp),%eax
  800871:	50                   	push   %eax
  800872:	e8 e7 fb ff ff       	call   80045e <getuint>
  800877:	83 c4 10             	add    $0x10,%esp
  80087a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80087d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800880:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800887:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80088b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80088e:	83 ec 04             	sub    $0x4,%esp
  800891:	52                   	push   %edx
  800892:	ff 75 e4             	pushl  -0x1c(%ebp)
  800895:	50                   	push   %eax
  800896:	ff 75 f4             	pushl  -0xc(%ebp)
  800899:	ff 75 f0             	pushl  -0x10(%ebp)
  80089c:	ff 75 0c             	pushl  0xc(%ebp)
  80089f:	ff 75 08             	pushl  0x8(%ebp)
  8008a2:	e8 00 fb ff ff       	call   8003a7 <printnum>
  8008a7:	83 c4 20             	add    $0x20,%esp
			break;
  8008aa:	eb 46                	jmp    8008f2 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008ac:	83 ec 08             	sub    $0x8,%esp
  8008af:	ff 75 0c             	pushl  0xc(%ebp)
  8008b2:	53                   	push   %ebx
  8008b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b6:	ff d0                	call   *%eax
  8008b8:	83 c4 10             	add    $0x10,%esp
			break;
  8008bb:	eb 35                	jmp    8008f2 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8008bd:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  8008c4:	eb 2c                	jmp    8008f2 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8008c6:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  8008cd:	eb 23                	jmp    8008f2 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008cf:	83 ec 08             	sub    $0x8,%esp
  8008d2:	ff 75 0c             	pushl  0xc(%ebp)
  8008d5:	6a 25                	push   $0x25
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	ff d0                	call   *%eax
  8008dc:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008df:	ff 4d 10             	decl   0x10(%ebp)
  8008e2:	eb 03                	jmp    8008e7 <vprintfmt+0x3c3>
  8008e4:	ff 4d 10             	decl   0x10(%ebp)
  8008e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ea:	48                   	dec    %eax
  8008eb:	8a 00                	mov    (%eax),%al
  8008ed:	3c 25                	cmp    $0x25,%al
  8008ef:	75 f3                	jne    8008e4 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008f1:	90                   	nop
		}
	}
  8008f2:	e9 35 fc ff ff       	jmp    80052c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008f7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008fb:	5b                   	pop    %ebx
  8008fc:	5e                   	pop    %esi
  8008fd:	5d                   	pop    %ebp
  8008fe:	c3                   	ret    

008008ff <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008ff:	55                   	push   %ebp
  800900:	89 e5                	mov    %esp,%ebp
  800902:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800905:	8d 45 10             	lea    0x10(%ebp),%eax
  800908:	83 c0 04             	add    $0x4,%eax
  80090b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80090e:	8b 45 10             	mov    0x10(%ebp),%eax
  800911:	ff 75 f4             	pushl  -0xc(%ebp)
  800914:	50                   	push   %eax
  800915:	ff 75 0c             	pushl  0xc(%ebp)
  800918:	ff 75 08             	pushl  0x8(%ebp)
  80091b:	e8 04 fc ff ff       	call   800524 <vprintfmt>
  800920:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800923:	90                   	nop
  800924:	c9                   	leave  
  800925:	c3                   	ret    

00800926 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092c:	8b 40 08             	mov    0x8(%eax),%eax
  80092f:	8d 50 01             	lea    0x1(%eax),%edx
  800932:	8b 45 0c             	mov    0xc(%ebp),%eax
  800935:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800938:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093b:	8b 10                	mov    (%eax),%edx
  80093d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800940:	8b 40 04             	mov    0x4(%eax),%eax
  800943:	39 c2                	cmp    %eax,%edx
  800945:	73 12                	jae    800959 <sprintputch+0x33>
		*b->buf++ = ch;
  800947:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094a:	8b 00                	mov    (%eax),%eax
  80094c:	8d 48 01             	lea    0x1(%eax),%ecx
  80094f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800952:	89 0a                	mov    %ecx,(%edx)
  800954:	8b 55 08             	mov    0x8(%ebp),%edx
  800957:	88 10                	mov    %dl,(%eax)
}
  800959:	90                   	nop
  80095a:	5d                   	pop    %ebp
  80095b:	c3                   	ret    

0080095c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80095c:	55                   	push   %ebp
  80095d:	89 e5                	mov    %esp,%ebp
  80095f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800968:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	01 d0                	add    %edx,%eax
  800973:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800976:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80097d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800981:	74 06                	je     800989 <vsnprintf+0x2d>
  800983:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800987:	7f 07                	jg     800990 <vsnprintf+0x34>
		return -E_INVAL;
  800989:	b8 03 00 00 00       	mov    $0x3,%eax
  80098e:	eb 20                	jmp    8009b0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800990:	ff 75 14             	pushl  0x14(%ebp)
  800993:	ff 75 10             	pushl  0x10(%ebp)
  800996:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800999:	50                   	push   %eax
  80099a:	68 26 09 80 00       	push   $0x800926
  80099f:	e8 80 fb ff ff       	call   800524 <vprintfmt>
  8009a4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009aa:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009b0:	c9                   	leave  
  8009b1:	c3                   	ret    

008009b2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009b2:	55                   	push   %ebp
  8009b3:	89 e5                	mov    %esp,%ebp
  8009b5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009b8:	8d 45 10             	lea    0x10(%ebp),%eax
  8009bb:	83 c0 04             	add    $0x4,%eax
  8009be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8009c7:	50                   	push   %eax
  8009c8:	ff 75 0c             	pushl  0xc(%ebp)
  8009cb:	ff 75 08             	pushl  0x8(%ebp)
  8009ce:	e8 89 ff ff ff       	call   80095c <vsnprintf>
  8009d3:	83 c4 10             	add    $0x10,%esp
  8009d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009dc:	c9                   	leave  
  8009dd:	c3                   	ret    

008009de <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8009de:	55                   	push   %ebp
  8009df:	89 e5                	mov    %esp,%ebp
  8009e1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009eb:	eb 06                	jmp    8009f3 <strlen+0x15>
		n++;
  8009ed:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009f0:	ff 45 08             	incl   0x8(%ebp)
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	8a 00                	mov    (%eax),%al
  8009f8:	84 c0                	test   %al,%al
  8009fa:	75 f1                	jne    8009ed <strlen+0xf>
		n++;
	return n;
  8009fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009ff:	c9                   	leave  
  800a00:	c3                   	ret    

00800a01 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a01:	55                   	push   %ebp
  800a02:	89 e5                	mov    %esp,%ebp
  800a04:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a07:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a0e:	eb 09                	jmp    800a19 <strnlen+0x18>
		n++;
  800a10:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a13:	ff 45 08             	incl   0x8(%ebp)
  800a16:	ff 4d 0c             	decl   0xc(%ebp)
  800a19:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a1d:	74 09                	je     800a28 <strnlen+0x27>
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	8a 00                	mov    (%eax),%al
  800a24:	84 c0                	test   %al,%al
  800a26:	75 e8                	jne    800a10 <strnlen+0xf>
		n++;
	return n;
  800a28:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a2b:	c9                   	leave  
  800a2c:	c3                   	ret    

00800a2d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a2d:	55                   	push   %ebp
  800a2e:	89 e5                	mov    %esp,%ebp
  800a30:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a39:	90                   	nop
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	8d 50 01             	lea    0x1(%eax),%edx
  800a40:	89 55 08             	mov    %edx,0x8(%ebp)
  800a43:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a46:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a49:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a4c:	8a 12                	mov    (%edx),%dl
  800a4e:	88 10                	mov    %dl,(%eax)
  800a50:	8a 00                	mov    (%eax),%al
  800a52:	84 c0                	test   %al,%al
  800a54:	75 e4                	jne    800a3a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a56:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a59:	c9                   	leave  
  800a5a:	c3                   	ret    

00800a5b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a67:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a6e:	eb 1f                	jmp    800a8f <strncpy+0x34>
		*dst++ = *src;
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	8d 50 01             	lea    0x1(%eax),%edx
  800a76:	89 55 08             	mov    %edx,0x8(%ebp)
  800a79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7c:	8a 12                	mov    (%edx),%dl
  800a7e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a83:	8a 00                	mov    (%eax),%al
  800a85:	84 c0                	test   %al,%al
  800a87:	74 03                	je     800a8c <strncpy+0x31>
			src++;
  800a89:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a8c:	ff 45 fc             	incl   -0x4(%ebp)
  800a8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a92:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a95:	72 d9                	jb     800a70 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a97:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a9a:	c9                   	leave  
  800a9b:	c3                   	ret    

00800a9c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800aa8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aac:	74 30                	je     800ade <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800aae:	eb 16                	jmp    800ac6 <strlcpy+0x2a>
			*dst++ = *src++;
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	8d 50 01             	lea    0x1(%eax),%edx
  800ab6:	89 55 08             	mov    %edx,0x8(%ebp)
  800ab9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800abc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800abf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ac2:	8a 12                	mov    (%edx),%dl
  800ac4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ac6:	ff 4d 10             	decl   0x10(%ebp)
  800ac9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800acd:	74 09                	je     800ad8 <strlcpy+0x3c>
  800acf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad2:	8a 00                	mov    (%eax),%al
  800ad4:	84 c0                	test   %al,%al
  800ad6:	75 d8                	jne    800ab0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ade:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ae4:	29 c2                	sub    %eax,%edx
  800ae6:	89 d0                	mov    %edx,%eax
}
  800ae8:	c9                   	leave  
  800ae9:	c3                   	ret    

00800aea <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800aed:	eb 06                	jmp    800af5 <strcmp+0xb>
		p++, q++;
  800aef:	ff 45 08             	incl   0x8(%ebp)
  800af2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	8a 00                	mov    (%eax),%al
  800afa:	84 c0                	test   %al,%al
  800afc:	74 0e                	je     800b0c <strcmp+0x22>
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	8a 10                	mov    (%eax),%dl
  800b03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b06:	8a 00                	mov    (%eax),%al
  800b08:	38 c2                	cmp    %al,%dl
  800b0a:	74 e3                	je     800aef <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	8a 00                	mov    (%eax),%al
  800b11:	0f b6 d0             	movzbl %al,%edx
  800b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b17:	8a 00                	mov    (%eax),%al
  800b19:	0f b6 c0             	movzbl %al,%eax
  800b1c:	29 c2                	sub    %eax,%edx
  800b1e:	89 d0                	mov    %edx,%eax
}
  800b20:	5d                   	pop    %ebp
  800b21:	c3                   	ret    

00800b22 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b25:	eb 09                	jmp    800b30 <strncmp+0xe>
		n--, p++, q++;
  800b27:	ff 4d 10             	decl   0x10(%ebp)
  800b2a:	ff 45 08             	incl   0x8(%ebp)
  800b2d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b34:	74 17                	je     800b4d <strncmp+0x2b>
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	8a 00                	mov    (%eax),%al
  800b3b:	84 c0                	test   %al,%al
  800b3d:	74 0e                	je     800b4d <strncmp+0x2b>
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	8a 10                	mov    (%eax),%dl
  800b44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b47:	8a 00                	mov    (%eax),%al
  800b49:	38 c2                	cmp    %al,%dl
  800b4b:	74 da                	je     800b27 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b51:	75 07                	jne    800b5a <strncmp+0x38>
		return 0;
  800b53:	b8 00 00 00 00       	mov    $0x0,%eax
  800b58:	eb 14                	jmp    800b6e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	8a 00                	mov    (%eax),%al
  800b5f:	0f b6 d0             	movzbl %al,%edx
  800b62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b65:	8a 00                	mov    (%eax),%al
  800b67:	0f b6 c0             	movzbl %al,%eax
  800b6a:	29 c2                	sub    %eax,%edx
  800b6c:	89 d0                	mov    %edx,%eax
}
  800b6e:	5d                   	pop    %ebp
  800b6f:	c3                   	ret    

00800b70 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	83 ec 04             	sub    $0x4,%esp
  800b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b79:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b7c:	eb 12                	jmp    800b90 <strchr+0x20>
		if (*s == c)
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	8a 00                	mov    (%eax),%al
  800b83:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b86:	75 05                	jne    800b8d <strchr+0x1d>
			return (char *) s;
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	eb 11                	jmp    800b9e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b8d:	ff 45 08             	incl   0x8(%ebp)
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
  800b93:	8a 00                	mov    (%eax),%al
  800b95:	84 c0                	test   %al,%al
  800b97:	75 e5                	jne    800b7e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b9e:	c9                   	leave  
  800b9f:	c3                   	ret    

00800ba0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	83 ec 04             	sub    $0x4,%esp
  800ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bac:	eb 0d                	jmp    800bbb <strfind+0x1b>
		if (*s == c)
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	8a 00                	mov    (%eax),%al
  800bb3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bb6:	74 0e                	je     800bc6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bb8:	ff 45 08             	incl   0x8(%ebp)
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	8a 00                	mov    (%eax),%al
  800bc0:	84 c0                	test   %al,%al
  800bc2:	75 ea                	jne    800bae <strfind+0xe>
  800bc4:	eb 01                	jmp    800bc7 <strfind+0x27>
		if (*s == c)
			break;
  800bc6:	90                   	nop
	return (char *) s;
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bca:	c9                   	leave  
  800bcb:	c3                   	ret    

00800bcc <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bd8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bdb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bde:	eb 0e                	jmp    800bee <memset+0x22>
		*p++ = c;
  800be0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be3:	8d 50 01             	lea    0x1(%eax),%edx
  800be6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800be9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bec:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800bee:	ff 4d f8             	decl   -0x8(%ebp)
  800bf1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800bf5:	79 e9                	jns    800be0 <memset+0x14>
		*p++ = c;

	return v;
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c0e:	eb 16                	jmp    800c26 <memcpy+0x2a>
		*d++ = *s++;
  800c10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c13:	8d 50 01             	lea    0x1(%eax),%edx
  800c16:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c19:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c1c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c1f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c22:	8a 12                	mov    (%edx),%dl
  800c24:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c26:	8b 45 10             	mov    0x10(%ebp),%eax
  800c29:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c2c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c2f:	85 c0                	test   %eax,%eax
  800c31:	75 dd                	jne    800c10 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c36:	c9                   	leave  
  800c37:	c3                   	ret    

00800c38 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c38:	55                   	push   %ebp
  800c39:	89 e5                	mov    %esp,%ebp
  800c3b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c4d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c50:	73 50                	jae    800ca2 <memmove+0x6a>
  800c52:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c55:	8b 45 10             	mov    0x10(%ebp),%eax
  800c58:	01 d0                	add    %edx,%eax
  800c5a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c5d:	76 43                	jbe    800ca2 <memmove+0x6a>
		s += n;
  800c5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c62:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c65:	8b 45 10             	mov    0x10(%ebp),%eax
  800c68:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c6b:	eb 10                	jmp    800c7d <memmove+0x45>
			*--d = *--s;
  800c6d:	ff 4d f8             	decl   -0x8(%ebp)
  800c70:	ff 4d fc             	decl   -0x4(%ebp)
  800c73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c76:	8a 10                	mov    (%eax),%dl
  800c78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c7b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c80:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c83:	89 55 10             	mov    %edx,0x10(%ebp)
  800c86:	85 c0                	test   %eax,%eax
  800c88:	75 e3                	jne    800c6d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c8a:	eb 23                	jmp    800caf <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c8f:	8d 50 01             	lea    0x1(%eax),%edx
  800c92:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c95:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c98:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c9b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c9e:	8a 12                	mov    (%edx),%dl
  800ca0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ca2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca8:	89 55 10             	mov    %edx,0x10(%ebp)
  800cab:	85 c0                	test   %eax,%eax
  800cad:	75 dd                	jne    800c8c <memmove+0x54>
			*d++ = *s++;

	return dst;
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cb2:	c9                   	leave  
  800cb3:	c3                   	ret    

00800cb4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cc6:	eb 2a                	jmp    800cf2 <memcmp+0x3e>
		if (*s1 != *s2)
  800cc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ccb:	8a 10                	mov    (%eax),%dl
  800ccd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cd0:	8a 00                	mov    (%eax),%al
  800cd2:	38 c2                	cmp    %al,%dl
  800cd4:	74 16                	je     800cec <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd9:	8a 00                	mov    (%eax),%al
  800cdb:	0f b6 d0             	movzbl %al,%edx
  800cde:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ce1:	8a 00                	mov    (%eax),%al
  800ce3:	0f b6 c0             	movzbl %al,%eax
  800ce6:	29 c2                	sub    %eax,%edx
  800ce8:	89 d0                	mov    %edx,%eax
  800cea:	eb 18                	jmp    800d04 <memcmp+0x50>
		s1++, s2++;
  800cec:	ff 45 fc             	incl   -0x4(%ebp)
  800cef:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800cf2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cf8:	89 55 10             	mov    %edx,0x10(%ebp)
  800cfb:	85 c0                	test   %eax,%eax
  800cfd:	75 c9                	jne    800cc8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800cff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d04:	c9                   	leave  
  800d05:	c3                   	ret    

00800d06 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d12:	01 d0                	add    %edx,%eax
  800d14:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d17:	eb 15                	jmp    800d2e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8a 00                	mov    (%eax),%al
  800d1e:	0f b6 d0             	movzbl %al,%edx
  800d21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d24:	0f b6 c0             	movzbl %al,%eax
  800d27:	39 c2                	cmp    %eax,%edx
  800d29:	74 0d                	je     800d38 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d2b:	ff 45 08             	incl   0x8(%ebp)
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d34:	72 e3                	jb     800d19 <memfind+0x13>
  800d36:	eb 01                	jmp    800d39 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d38:	90                   	nop
	return (void *) s;
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d3c:	c9                   	leave  
  800d3d:	c3                   	ret    

00800d3e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d3e:	55                   	push   %ebp
  800d3f:	89 e5                	mov    %esp,%ebp
  800d41:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d44:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d4b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d52:	eb 03                	jmp    800d57 <strtol+0x19>
		s++;
  800d54:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	8a 00                	mov    (%eax),%al
  800d5c:	3c 20                	cmp    $0x20,%al
  800d5e:	74 f4                	je     800d54 <strtol+0x16>
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	8a 00                	mov    (%eax),%al
  800d65:	3c 09                	cmp    $0x9,%al
  800d67:	74 eb                	je     800d54 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	8a 00                	mov    (%eax),%al
  800d6e:	3c 2b                	cmp    $0x2b,%al
  800d70:	75 05                	jne    800d77 <strtol+0x39>
		s++;
  800d72:	ff 45 08             	incl   0x8(%ebp)
  800d75:	eb 13                	jmp    800d8a <strtol+0x4c>
	else if (*s == '-')
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	3c 2d                	cmp    $0x2d,%al
  800d7e:	75 0a                	jne    800d8a <strtol+0x4c>
		s++, neg = 1;
  800d80:	ff 45 08             	incl   0x8(%ebp)
  800d83:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d8a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8e:	74 06                	je     800d96 <strtol+0x58>
  800d90:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d94:	75 20                	jne    800db6 <strtol+0x78>
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	3c 30                	cmp    $0x30,%al
  800d9d:	75 17                	jne    800db6 <strtol+0x78>
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800da2:	40                   	inc    %eax
  800da3:	8a 00                	mov    (%eax),%al
  800da5:	3c 78                	cmp    $0x78,%al
  800da7:	75 0d                	jne    800db6 <strtol+0x78>
		s += 2, base = 16;
  800da9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dad:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800db4:	eb 28                	jmp    800dde <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800db6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dba:	75 15                	jne    800dd1 <strtol+0x93>
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8a 00                	mov    (%eax),%al
  800dc1:	3c 30                	cmp    $0x30,%al
  800dc3:	75 0c                	jne    800dd1 <strtol+0x93>
		s++, base = 8;
  800dc5:	ff 45 08             	incl   0x8(%ebp)
  800dc8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dcf:	eb 0d                	jmp    800dde <strtol+0xa0>
	else if (base == 0)
  800dd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd5:	75 07                	jne    800dde <strtol+0xa0>
		base = 10;
  800dd7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	8a 00                	mov    (%eax),%al
  800de3:	3c 2f                	cmp    $0x2f,%al
  800de5:	7e 19                	jle    800e00 <strtol+0xc2>
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	3c 39                	cmp    $0x39,%al
  800dee:	7f 10                	jg     800e00 <strtol+0xc2>
			dig = *s - '0';
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	8a 00                	mov    (%eax),%al
  800df5:	0f be c0             	movsbl %al,%eax
  800df8:	83 e8 30             	sub    $0x30,%eax
  800dfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dfe:	eb 42                	jmp    800e42 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	8a 00                	mov    (%eax),%al
  800e05:	3c 60                	cmp    $0x60,%al
  800e07:	7e 19                	jle    800e22 <strtol+0xe4>
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	3c 7a                	cmp    $0x7a,%al
  800e10:	7f 10                	jg     800e22 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	8a 00                	mov    (%eax),%al
  800e17:	0f be c0             	movsbl %al,%eax
  800e1a:	83 e8 57             	sub    $0x57,%eax
  800e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e20:	eb 20                	jmp    800e42 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	8a 00                	mov    (%eax),%al
  800e27:	3c 40                	cmp    $0x40,%al
  800e29:	7e 39                	jle    800e64 <strtol+0x126>
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	8a 00                	mov    (%eax),%al
  800e30:	3c 5a                	cmp    $0x5a,%al
  800e32:	7f 30                	jg     800e64 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	8a 00                	mov    (%eax),%al
  800e39:	0f be c0             	movsbl %al,%eax
  800e3c:	83 e8 37             	sub    $0x37,%eax
  800e3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e45:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e48:	7d 19                	jge    800e63 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e4a:	ff 45 08             	incl   0x8(%ebp)
  800e4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e50:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e54:	89 c2                	mov    %eax,%edx
  800e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e59:	01 d0                	add    %edx,%eax
  800e5b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e5e:	e9 7b ff ff ff       	jmp    800dde <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e63:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e68:	74 08                	je     800e72 <strtol+0x134>
		*endptr = (char *) s;
  800e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e70:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e72:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e76:	74 07                	je     800e7f <strtol+0x141>
  800e78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7b:	f7 d8                	neg    %eax
  800e7d:	eb 03                	jmp    800e82 <strtol+0x144>
  800e7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e82:	c9                   	leave  
  800e83:	c3                   	ret    

00800e84 <ltostr>:

void
ltostr(long value, char *str)
{
  800e84:	55                   	push   %ebp
  800e85:	89 e5                	mov    %esp,%ebp
  800e87:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e91:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e9c:	79 13                	jns    800eb1 <ltostr+0x2d>
	{
		neg = 1;
  800e9e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800eab:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800eae:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800eb9:	99                   	cltd   
  800eba:	f7 f9                	idiv   %ecx
  800ebc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ebf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec2:	8d 50 01             	lea    0x1(%eax),%edx
  800ec5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ec8:	89 c2                	mov    %eax,%edx
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	01 d0                	add    %edx,%eax
  800ecf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ed2:	83 c2 30             	add    $0x30,%edx
  800ed5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ed7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eda:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800edf:	f7 e9                	imul   %ecx
  800ee1:	c1 fa 02             	sar    $0x2,%edx
  800ee4:	89 c8                	mov    %ecx,%eax
  800ee6:	c1 f8 1f             	sar    $0x1f,%eax
  800ee9:	29 c2                	sub    %eax,%edx
  800eeb:	89 d0                	mov    %edx,%eax
  800eed:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800ef0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ef4:	75 bb                	jne    800eb1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800ef6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800efd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f00:	48                   	dec    %eax
  800f01:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f04:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f08:	74 3d                	je     800f47 <ltostr+0xc3>
		start = 1 ;
  800f0a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f11:	eb 34                	jmp    800f47 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800f13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f19:	01 d0                	add    %edx,%eax
  800f1b:	8a 00                	mov    (%eax),%al
  800f1d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f26:	01 c2                	add    %eax,%edx
  800f28:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2e:	01 c8                	add    %ecx,%eax
  800f30:	8a 00                	mov    (%eax),%al
  800f32:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f34:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3a:	01 c2                	add    %eax,%edx
  800f3c:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f3f:	88 02                	mov    %al,(%edx)
		start++ ;
  800f41:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f44:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f4a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f4d:	7c c4                	jl     800f13 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f4f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f55:	01 d0                	add    %edx,%eax
  800f57:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f5a:	90                   	nop
  800f5b:	c9                   	leave  
  800f5c:	c3                   	ret    

00800f5d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f5d:	55                   	push   %ebp
  800f5e:	89 e5                	mov    %esp,%ebp
  800f60:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f63:	ff 75 08             	pushl  0x8(%ebp)
  800f66:	e8 73 fa ff ff       	call   8009de <strlen>
  800f6b:	83 c4 04             	add    $0x4,%esp
  800f6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f71:	ff 75 0c             	pushl  0xc(%ebp)
  800f74:	e8 65 fa ff ff       	call   8009de <strlen>
  800f79:	83 c4 04             	add    $0x4,%esp
  800f7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f8d:	eb 17                	jmp    800fa6 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f8f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f92:	8b 45 10             	mov    0x10(%ebp),%eax
  800f95:	01 c2                	add    %eax,%edx
  800f97:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	01 c8                	add    %ecx,%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fa3:	ff 45 fc             	incl   -0x4(%ebp)
  800fa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fac:	7c e1                	jl     800f8f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fb5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fbc:	eb 1f                	jmp    800fdd <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc1:	8d 50 01             	lea    0x1(%eax),%edx
  800fc4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fc7:	89 c2                	mov    %eax,%edx
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	01 c2                	add    %eax,%edx
  800fce:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd4:	01 c8                	add    %ecx,%eax
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800fda:	ff 45 f8             	incl   -0x8(%ebp)
  800fdd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fe3:	7c d9                	jl     800fbe <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800fe5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe8:	8b 45 10             	mov    0x10(%ebp),%eax
  800feb:	01 d0                	add    %edx,%eax
  800fed:	c6 00 00             	movb   $0x0,(%eax)
}
  800ff0:	90                   	nop
  800ff1:	c9                   	leave  
  800ff2:	c3                   	ret    

00800ff3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800ff6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800fff:	8b 45 14             	mov    0x14(%ebp),%eax
  801002:	8b 00                	mov    (%eax),%eax
  801004:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80100b:	8b 45 10             	mov    0x10(%ebp),%eax
  80100e:	01 d0                	add    %edx,%eax
  801010:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801016:	eb 0c                	jmp    801024 <strsplit+0x31>
			*string++ = 0;
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	8d 50 01             	lea    0x1(%eax),%edx
  80101e:	89 55 08             	mov    %edx,0x8(%ebp)
  801021:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	8a 00                	mov    (%eax),%al
  801029:	84 c0                	test   %al,%al
  80102b:	74 18                	je     801045 <strsplit+0x52>
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	0f be c0             	movsbl %al,%eax
  801035:	50                   	push   %eax
  801036:	ff 75 0c             	pushl  0xc(%ebp)
  801039:	e8 32 fb ff ff       	call   800b70 <strchr>
  80103e:	83 c4 08             	add    $0x8,%esp
  801041:	85 c0                	test   %eax,%eax
  801043:	75 d3                	jne    801018 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	8a 00                	mov    (%eax),%al
  80104a:	84 c0                	test   %al,%al
  80104c:	74 5a                	je     8010a8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80104e:	8b 45 14             	mov    0x14(%ebp),%eax
  801051:	8b 00                	mov    (%eax),%eax
  801053:	83 f8 0f             	cmp    $0xf,%eax
  801056:	75 07                	jne    80105f <strsplit+0x6c>
		{
			return 0;
  801058:	b8 00 00 00 00       	mov    $0x0,%eax
  80105d:	eb 66                	jmp    8010c5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80105f:	8b 45 14             	mov    0x14(%ebp),%eax
  801062:	8b 00                	mov    (%eax),%eax
  801064:	8d 48 01             	lea    0x1(%eax),%ecx
  801067:	8b 55 14             	mov    0x14(%ebp),%edx
  80106a:	89 0a                	mov    %ecx,(%edx)
  80106c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801073:	8b 45 10             	mov    0x10(%ebp),%eax
  801076:	01 c2                	add    %eax,%edx
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80107d:	eb 03                	jmp    801082 <strsplit+0x8f>
			string++;
  80107f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	84 c0                	test   %al,%al
  801089:	74 8b                	je     801016 <strsplit+0x23>
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	0f be c0             	movsbl %al,%eax
  801093:	50                   	push   %eax
  801094:	ff 75 0c             	pushl  0xc(%ebp)
  801097:	e8 d4 fa ff ff       	call   800b70 <strchr>
  80109c:	83 c4 08             	add    $0x8,%esp
  80109f:	85 c0                	test   %eax,%eax
  8010a1:	74 dc                	je     80107f <strsplit+0x8c>
			string++;
	}
  8010a3:	e9 6e ff ff ff       	jmp    801016 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010a8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ac:	8b 00                	mov    (%eax),%eax
  8010ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b8:	01 d0                	add    %edx,%eax
  8010ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010c0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010c5:	c9                   	leave  
  8010c6:	c3                   	ret    

008010c7 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8010cd:	83 ec 04             	sub    $0x4,%esp
  8010d0:	68 a8 21 80 00       	push   $0x8021a8
  8010d5:	68 3f 01 00 00       	push   $0x13f
  8010da:	68 ca 21 80 00       	push   $0x8021ca
  8010df:	e8 51 07 00 00       	call   801835 <_panic>

008010e4 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8010e4:	55                   	push   %ebp
  8010e5:	89 e5                	mov    %esp,%ebp
  8010e7:	57                   	push   %edi
  8010e8:	56                   	push   %esi
  8010e9:	53                   	push   %ebx
  8010ea:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010f6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010f9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8010fc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8010ff:	cd 30                	int    $0x30
  801101:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801104:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801107:	83 c4 10             	add    $0x10,%esp
  80110a:	5b                   	pop    %ebx
  80110b:	5e                   	pop    %esi
  80110c:	5f                   	pop    %edi
  80110d:	5d                   	pop    %ebp
  80110e:	c3                   	ret    

0080110f <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  80110f:	55                   	push   %ebp
  801110:	89 e5                	mov    %esp,%ebp
  801112:	83 ec 04             	sub    $0x4,%esp
  801115:	8b 45 10             	mov    0x10(%ebp),%eax
  801118:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  80111b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
  801122:	6a 00                	push   $0x0
  801124:	6a 00                	push   $0x0
  801126:	52                   	push   %edx
  801127:	ff 75 0c             	pushl  0xc(%ebp)
  80112a:	50                   	push   %eax
  80112b:	6a 00                	push   $0x0
  80112d:	e8 b2 ff ff ff       	call   8010e4 <syscall>
  801132:	83 c4 18             	add    $0x18,%esp
}
  801135:	90                   	nop
  801136:	c9                   	leave  
  801137:	c3                   	ret    

00801138 <sys_cgetc>:

int sys_cgetc(void) {
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80113b:	6a 00                	push   $0x0
  80113d:	6a 00                	push   $0x0
  80113f:	6a 00                	push   $0x0
  801141:	6a 00                	push   $0x0
  801143:	6a 00                	push   $0x0
  801145:	6a 02                	push   $0x2
  801147:	e8 98 ff ff ff       	call   8010e4 <syscall>
  80114c:	83 c4 18             	add    $0x18,%esp
}
  80114f:	c9                   	leave  
  801150:	c3                   	ret    

00801151 <sys_lock_cons>:

void sys_lock_cons(void) {
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801154:	6a 00                	push   $0x0
  801156:	6a 00                	push   $0x0
  801158:	6a 00                	push   $0x0
  80115a:	6a 00                	push   $0x0
  80115c:	6a 00                	push   $0x0
  80115e:	6a 03                	push   $0x3
  801160:	e8 7f ff ff ff       	call   8010e4 <syscall>
  801165:	83 c4 18             	add    $0x18,%esp
}
  801168:	90                   	nop
  801169:	c9                   	leave  
  80116a:	c3                   	ret    

0080116b <sys_unlock_cons>:
void sys_unlock_cons(void) {
  80116b:	55                   	push   %ebp
  80116c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80116e:	6a 00                	push   $0x0
  801170:	6a 00                	push   $0x0
  801172:	6a 00                	push   $0x0
  801174:	6a 00                	push   $0x0
  801176:	6a 00                	push   $0x0
  801178:	6a 04                	push   $0x4
  80117a:	e8 65 ff ff ff       	call   8010e4 <syscall>
  80117f:	83 c4 18             	add    $0x18,%esp
}
  801182:	90                   	nop
  801183:	c9                   	leave  
  801184:	c3                   	ret    

00801185 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801185:	55                   	push   %ebp
  801186:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801188:	8b 55 0c             	mov    0xc(%ebp),%edx
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	6a 00                	push   $0x0
  801190:	6a 00                	push   $0x0
  801192:	6a 00                	push   $0x0
  801194:	52                   	push   %edx
  801195:	50                   	push   %eax
  801196:	6a 08                	push   $0x8
  801198:	e8 47 ff ff ff       	call   8010e4 <syscall>
  80119d:	83 c4 18             	add    $0x18,%esp
}
  8011a0:	c9                   	leave  
  8011a1:	c3                   	ret    

008011a2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	56                   	push   %esi
  8011a6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  8011a7:	8b 75 18             	mov    0x18(%ebp),%esi
  8011aa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011ad:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	56                   	push   %esi
  8011b7:	53                   	push   %ebx
  8011b8:	51                   	push   %ecx
  8011b9:	52                   	push   %edx
  8011ba:	50                   	push   %eax
  8011bb:	6a 09                	push   $0x9
  8011bd:	e8 22 ff ff ff       	call   8010e4 <syscall>
  8011c2:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  8011c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011c8:	5b                   	pop    %ebx
  8011c9:	5e                   	pop    %esi
  8011ca:	5d                   	pop    %ebp
  8011cb:	c3                   	ret    

008011cc <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  8011cc:	55                   	push   %ebp
  8011cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8011cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	6a 00                	push   $0x0
  8011d7:	6a 00                	push   $0x0
  8011d9:	6a 00                	push   $0x0
  8011db:	52                   	push   %edx
  8011dc:	50                   	push   %eax
  8011dd:	6a 0a                	push   $0xa
  8011df:	e8 00 ff ff ff       	call   8010e4 <syscall>
  8011e4:	83 c4 18             	add    $0x18,%esp
}
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    

008011e9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  8011ec:	6a 00                	push   $0x0
  8011ee:	6a 00                	push   $0x0
  8011f0:	6a 00                	push   $0x0
  8011f2:	ff 75 0c             	pushl  0xc(%ebp)
  8011f5:	ff 75 08             	pushl  0x8(%ebp)
  8011f8:	6a 0b                	push   $0xb
  8011fa:	e8 e5 fe ff ff       	call   8010e4 <syscall>
  8011ff:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801202:	c9                   	leave  
  801203:	c3                   	ret    

00801204 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801204:	55                   	push   %ebp
  801205:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801207:	6a 00                	push   $0x0
  801209:	6a 00                	push   $0x0
  80120b:	6a 00                	push   $0x0
  80120d:	6a 00                	push   $0x0
  80120f:	6a 00                	push   $0x0
  801211:	6a 0c                	push   $0xc
  801213:	e8 cc fe ff ff       	call   8010e4 <syscall>
  801218:	83 c4 18             	add    $0x18,%esp
}
  80121b:	c9                   	leave  
  80121c:	c3                   	ret    

0080121d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801220:	6a 00                	push   $0x0
  801222:	6a 00                	push   $0x0
  801224:	6a 00                	push   $0x0
  801226:	6a 00                	push   $0x0
  801228:	6a 00                	push   $0x0
  80122a:	6a 0d                	push   $0xd
  80122c:	e8 b3 fe ff ff       	call   8010e4 <syscall>
  801231:	83 c4 18             	add    $0x18,%esp
}
  801234:	c9                   	leave  
  801235:	c3                   	ret    

00801236 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801239:	6a 00                	push   $0x0
  80123b:	6a 00                	push   $0x0
  80123d:	6a 00                	push   $0x0
  80123f:	6a 00                	push   $0x0
  801241:	6a 00                	push   $0x0
  801243:	6a 0e                	push   $0xe
  801245:	e8 9a fe ff ff       	call   8010e4 <syscall>
  80124a:	83 c4 18             	add    $0x18,%esp
}
  80124d:	c9                   	leave  
  80124e:	c3                   	ret    

0080124f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  80124f:	55                   	push   %ebp
  801250:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801252:	6a 00                	push   $0x0
  801254:	6a 00                	push   $0x0
  801256:	6a 00                	push   $0x0
  801258:	6a 00                	push   $0x0
  80125a:	6a 00                	push   $0x0
  80125c:	6a 0f                	push   $0xf
  80125e:	e8 81 fe ff ff       	call   8010e4 <syscall>
  801263:	83 c4 18             	add    $0x18,%esp
}
  801266:	c9                   	leave  
  801267:	c3                   	ret    

00801268 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801268:	55                   	push   %ebp
  801269:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  80126b:	6a 00                	push   $0x0
  80126d:	6a 00                	push   $0x0
  80126f:	6a 00                	push   $0x0
  801271:	6a 00                	push   $0x0
  801273:	ff 75 08             	pushl  0x8(%ebp)
  801276:	6a 10                	push   $0x10
  801278:	e8 67 fe ff ff       	call   8010e4 <syscall>
  80127d:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801280:	c9                   	leave  
  801281:	c3                   	ret    

00801282 <sys_scarce_memory>:

void sys_scarce_memory() {
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801285:	6a 00                	push   $0x0
  801287:	6a 00                	push   $0x0
  801289:	6a 00                	push   $0x0
  80128b:	6a 00                	push   $0x0
  80128d:	6a 00                	push   $0x0
  80128f:	6a 11                	push   $0x11
  801291:	e8 4e fe ff ff       	call   8010e4 <syscall>
  801296:	83 c4 18             	add    $0x18,%esp
}
  801299:	90                   	nop
  80129a:	c9                   	leave  
  80129b:	c3                   	ret    

0080129c <sys_cputc>:

void sys_cputc(const char c) {
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	83 ec 04             	sub    $0x4,%esp
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8012a8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8012ac:	6a 00                	push   $0x0
  8012ae:	6a 00                	push   $0x0
  8012b0:	6a 00                	push   $0x0
  8012b2:	6a 00                	push   $0x0
  8012b4:	50                   	push   %eax
  8012b5:	6a 01                	push   $0x1
  8012b7:	e8 28 fe ff ff       	call   8010e4 <syscall>
  8012bc:	83 c4 18             	add    $0x18,%esp
}
  8012bf:	90                   	nop
  8012c0:	c9                   	leave  
  8012c1:	c3                   	ret    

008012c2 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  8012c2:	55                   	push   %ebp
  8012c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  8012c5:	6a 00                	push   $0x0
  8012c7:	6a 00                	push   $0x0
  8012c9:	6a 00                	push   $0x0
  8012cb:	6a 00                	push   $0x0
  8012cd:	6a 00                	push   $0x0
  8012cf:	6a 14                	push   $0x14
  8012d1:	e8 0e fe ff ff       	call   8010e4 <syscall>
  8012d6:	83 c4 18             	add    $0x18,%esp
}
  8012d9:	90                   	nop
  8012da:	c9                   	leave  
  8012db:	c3                   	ret    

008012dc <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8012dc:	55                   	push   %ebp
  8012dd:	89 e5                	mov    %esp,%ebp
  8012df:	83 ec 04             	sub    $0x4,%esp
  8012e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  8012e8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8012eb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f2:	6a 00                	push   $0x0
  8012f4:	51                   	push   %ecx
  8012f5:	52                   	push   %edx
  8012f6:	ff 75 0c             	pushl  0xc(%ebp)
  8012f9:	50                   	push   %eax
  8012fa:	6a 15                	push   $0x15
  8012fc:	e8 e3 fd ff ff       	call   8010e4 <syscall>
  801301:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801304:	c9                   	leave  
  801305:	c3                   	ret    

00801306 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801309:	8b 55 0c             	mov    0xc(%ebp),%edx
  80130c:	8b 45 08             	mov    0x8(%ebp),%eax
  80130f:	6a 00                	push   $0x0
  801311:	6a 00                	push   $0x0
  801313:	6a 00                	push   $0x0
  801315:	52                   	push   %edx
  801316:	50                   	push   %eax
  801317:	6a 16                	push   $0x16
  801319:	e8 c6 fd ff ff       	call   8010e4 <syscall>
  80131e:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801321:	c9                   	leave  
  801322:	c3                   	ret    

00801323 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801323:	55                   	push   %ebp
  801324:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801326:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801329:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	6a 00                	push   $0x0
  801331:	6a 00                	push   $0x0
  801333:	51                   	push   %ecx
  801334:	52                   	push   %edx
  801335:	50                   	push   %eax
  801336:	6a 17                	push   $0x17
  801338:	e8 a7 fd ff ff       	call   8010e4 <syscall>
  80133d:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801340:	c9                   	leave  
  801341:	c3                   	ret    

00801342 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801345:	8b 55 0c             	mov    0xc(%ebp),%edx
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	6a 00                	push   $0x0
  801351:	52                   	push   %edx
  801352:	50                   	push   %eax
  801353:	6a 18                	push   $0x18
  801355:	e8 8a fd ff ff       	call   8010e4 <syscall>
  80135a:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  80135d:	c9                   	leave  
  80135e:	c3                   	ret    

0080135f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	6a 00                	push   $0x0
  801367:	ff 75 14             	pushl  0x14(%ebp)
  80136a:	ff 75 10             	pushl  0x10(%ebp)
  80136d:	ff 75 0c             	pushl  0xc(%ebp)
  801370:	50                   	push   %eax
  801371:	6a 19                	push   $0x19
  801373:	e8 6c fd ff ff       	call   8010e4 <syscall>
  801378:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  80137b:	c9                   	leave  
  80137c:	c3                   	ret    

0080137d <sys_run_env>:

void sys_run_env(int32 envId) {
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	50                   	push   %eax
  80138c:	6a 1a                	push   $0x1a
  80138e:	e8 51 fd ff ff       	call   8010e4 <syscall>
  801393:	83 c4 18             	add    $0x18,%esp
}
  801396:	90                   	nop
  801397:	c9                   	leave  
  801398:	c3                   	ret    

00801399 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	50                   	push   %eax
  8013a8:	6a 1b                	push   $0x1b
  8013aa:	e8 35 fd ff ff       	call   8010e4 <syscall>
  8013af:	83 c4 18             	add    $0x18,%esp
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <sys_getenvid>:

int32 sys_getenvid(void) {
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 05                	push   $0x5
  8013c3:	e8 1c fd ff ff       	call   8010e4 <syscall>
  8013c8:	83 c4 18             	add    $0x18,%esp
}
  8013cb:	c9                   	leave  
  8013cc:	c3                   	ret    

008013cd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 06                	push   $0x6
  8013dc:	e8 03 fd ff ff       	call   8010e4 <syscall>
  8013e1:	83 c4 18             	add    $0x18,%esp
}
  8013e4:	c9                   	leave  
  8013e5:	c3                   	ret    

008013e6 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  8013e6:	55                   	push   %ebp
  8013e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 07                	push   $0x7
  8013f5:	e8 ea fc ff ff       	call   8010e4 <syscall>
  8013fa:	83 c4 18             	add    $0x18,%esp
}
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <sys_exit_env>:

void sys_exit_env(void) {
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801402:	6a 00                	push   $0x0
  801404:	6a 00                	push   $0x0
  801406:	6a 00                	push   $0x0
  801408:	6a 00                	push   $0x0
  80140a:	6a 00                	push   $0x0
  80140c:	6a 1c                	push   $0x1c
  80140e:	e8 d1 fc ff ff       	call   8010e4 <syscall>
  801413:	83 c4 18             	add    $0x18,%esp
}
  801416:	90                   	nop
  801417:	c9                   	leave  
  801418:	c3                   	ret    

00801419 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801419:	55                   	push   %ebp
  80141a:	89 e5                	mov    %esp,%ebp
  80141c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  80141f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801422:	8d 50 04             	lea    0x4(%eax),%edx
  801425:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	52                   	push   %edx
  80142f:	50                   	push   %eax
  801430:	6a 1d                	push   $0x1d
  801432:	e8 ad fc ff ff       	call   8010e4 <syscall>
  801437:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  80143a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80143d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801440:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801443:	89 01                	mov    %eax,(%ecx)
  801445:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801448:	8b 45 08             	mov    0x8(%ebp),%eax
  80144b:	c9                   	leave  
  80144c:	c2 04 00             	ret    $0x4

0080144f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	ff 75 10             	pushl  0x10(%ebp)
  801459:	ff 75 0c             	pushl  0xc(%ebp)
  80145c:	ff 75 08             	pushl  0x8(%ebp)
  80145f:	6a 13                	push   $0x13
  801461:	e8 7e fc ff ff       	call   8010e4 <syscall>
  801466:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801469:	90                   	nop
}
  80146a:	c9                   	leave  
  80146b:	c3                   	ret    

0080146c <sys_rcr2>:
uint32 sys_rcr2() {
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	6a 00                	push   $0x0
  801479:	6a 1e                	push   $0x1e
  80147b:	e8 64 fc ff ff       	call   8010e4 <syscall>
  801480:	83 c4 18             	add    $0x18,%esp
}
  801483:	c9                   	leave  
  801484:	c3                   	ret    

00801485 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	83 ec 04             	sub    $0x4,%esp
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801491:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	6a 00                	push   $0x0
  80149d:	50                   	push   %eax
  80149e:	6a 1f                	push   $0x1f
  8014a0:	e8 3f fc ff ff       	call   8010e4 <syscall>
  8014a5:	83 c4 18             	add    $0x18,%esp
	return;
  8014a8:	90                   	nop
}
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <rsttst>:
void rsttst() {
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 21                	push   $0x21
  8014ba:	e8 25 fc ff ff       	call   8010e4 <syscall>
  8014bf:	83 c4 18             	add    $0x18,%esp
	return;
  8014c2:	90                   	nop
}
  8014c3:	c9                   	leave  
  8014c4:	c3                   	ret    

008014c5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
  8014c8:	83 ec 04             	sub    $0x4,%esp
  8014cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8014d1:	8b 55 18             	mov    0x18(%ebp),%edx
  8014d4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014d8:	52                   	push   %edx
  8014d9:	50                   	push   %eax
  8014da:	ff 75 10             	pushl  0x10(%ebp)
  8014dd:	ff 75 0c             	pushl  0xc(%ebp)
  8014e0:	ff 75 08             	pushl  0x8(%ebp)
  8014e3:	6a 20                	push   $0x20
  8014e5:	e8 fa fb ff ff       	call   8010e4 <syscall>
  8014ea:	83 c4 18             	add    $0x18,%esp
	return;
  8014ed:	90                   	nop
}
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <chktst>:
void chktst(uint32 n) {
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	ff 75 08             	pushl  0x8(%ebp)
  8014fe:	6a 22                	push   $0x22
  801500:	e8 df fb ff ff       	call   8010e4 <syscall>
  801505:	83 c4 18             	add    $0x18,%esp
	return;
  801508:	90                   	nop
}
  801509:	c9                   	leave  
  80150a:	c3                   	ret    

0080150b <inctst>:

void inctst() {
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 23                	push   $0x23
  80151a:	e8 c5 fb ff ff       	call   8010e4 <syscall>
  80151f:	83 c4 18             	add    $0x18,%esp
	return;
  801522:	90                   	nop
}
  801523:	c9                   	leave  
  801524:	c3                   	ret    

00801525 <gettst>:
uint32 gettst() {
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	6a 24                	push   $0x24
  801534:	e8 ab fb ff ff       	call   8010e4 <syscall>
  801539:	83 c4 18             	add    $0x18,%esp
}
  80153c:	c9                   	leave  
  80153d:	c3                   	ret    

0080153e <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
  801541:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	6a 25                	push   $0x25
  801550:	e8 8f fb ff ff       	call   8010e4 <syscall>
  801555:	83 c4 18             	add    $0x18,%esp
  801558:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80155b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80155f:	75 07                	jne    801568 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801561:	b8 01 00 00 00       	mov    $0x1,%eax
  801566:	eb 05                	jmp    80156d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801568:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80156d:	c9                   	leave  
  80156e:	c3                   	ret    

0080156f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
  801572:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	6a 25                	push   $0x25
  801581:	e8 5e fb ff ff       	call   8010e4 <syscall>
  801586:	83 c4 18             	add    $0x18,%esp
  801589:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80158c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801590:	75 07                	jne    801599 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801592:	b8 01 00 00 00       	mov    $0x1,%eax
  801597:	eb 05                	jmp    80159e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801599:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 25                	push   $0x25
  8015b2:	e8 2d fb ff ff       	call   8010e4 <syscall>
  8015b7:	83 c4 18             	add    $0x18,%esp
  8015ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8015bd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8015c1:	75 07                	jne    8015ca <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8015c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8015c8:	eb 05                	jmp    8015cf <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8015ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015cf:	c9                   	leave  
  8015d0:	c3                   	ret    

008015d1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
  8015d4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 25                	push   $0x25
  8015e3:	e8 fc fa ff ff       	call   8010e4 <syscall>
  8015e8:	83 c4 18             	add    $0x18,%esp
  8015eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8015ee:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8015f2:	75 07                	jne    8015fb <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8015f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8015f9:	eb 05                	jmp    801600 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8015fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	ff 75 08             	pushl  0x8(%ebp)
  801610:	6a 26                	push   $0x26
  801612:	e8 cd fa ff ff       	call   8010e4 <syscall>
  801617:	83 c4 18             	add    $0x18,%esp
	return;
  80161a:	90                   	nop
}
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801621:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801624:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801627:	8b 55 0c             	mov    0xc(%ebp),%edx
  80162a:	8b 45 08             	mov    0x8(%ebp),%eax
  80162d:	6a 00                	push   $0x0
  80162f:	53                   	push   %ebx
  801630:	51                   	push   %ecx
  801631:	52                   	push   %edx
  801632:	50                   	push   %eax
  801633:	6a 27                	push   $0x27
  801635:	e8 aa fa ff ff       	call   8010e4 <syscall>
  80163a:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  80163d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801640:	c9                   	leave  
  801641:	c3                   	ret    

00801642 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801645:	8b 55 0c             	mov    0xc(%ebp),%edx
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	52                   	push   %edx
  801652:	50                   	push   %eax
  801653:	6a 28                	push   $0x28
  801655:	e8 8a fa ff ff       	call   8010e4 <syscall>
  80165a:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801662:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801665:	8b 55 0c             	mov    0xc(%ebp),%edx
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	6a 00                	push   $0x0
  80166d:	51                   	push   %ecx
  80166e:	ff 75 10             	pushl  0x10(%ebp)
  801671:	52                   	push   %edx
  801672:	50                   	push   %eax
  801673:	6a 29                	push   $0x29
  801675:	e8 6a fa ff ff       	call   8010e4 <syscall>
  80167a:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    

0080167f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	ff 75 10             	pushl  0x10(%ebp)
  801689:	ff 75 0c             	pushl  0xc(%ebp)
  80168c:	ff 75 08             	pushl  0x8(%ebp)
  80168f:	6a 12                	push   $0x12
  801691:	e8 4e fa ff ff       	call   8010e4 <syscall>
  801696:	83 c4 18             	add    $0x18,%esp
	return;
  801699:	90                   	nop
}
  80169a:	c9                   	leave  
  80169b:	c3                   	ret    

0080169c <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  80169f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	52                   	push   %edx
  8016ac:	50                   	push   %eax
  8016ad:	6a 2a                	push   $0x2a
  8016af:	e8 30 fa ff ff       	call   8010e4 <syscall>
  8016b4:	83 c4 18             	add    $0x18,%esp
	return;
  8016b7:	90                   	nop
}
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8016bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	50                   	push   %eax
  8016c9:	6a 2b                	push   $0x2b
  8016cb:	e8 14 fa ff ff       	call   8010e4 <syscall>
  8016d0:	83 c4 18             	add    $0x18,%esp
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	ff 75 0c             	pushl  0xc(%ebp)
  8016e1:	ff 75 08             	pushl  0x8(%ebp)
  8016e4:	6a 2c                	push   $0x2c
  8016e6:	e8 f9 f9 ff ff       	call   8010e4 <syscall>
  8016eb:	83 c4 18             	add    $0x18,%esp
	return;
  8016ee:	90                   	nop
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	ff 75 0c             	pushl  0xc(%ebp)
  8016fd:	ff 75 08             	pushl  0x8(%ebp)
  801700:	6a 2d                	push   $0x2d
  801702:	e8 dd f9 ff ff       	call   8010e4 <syscall>
  801707:	83 c4 18             	add    $0x18,%esp
	return;
  80170a:	90                   	nop
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	50                   	push   %eax
  80171c:	6a 2f                	push   $0x2f
  80171e:	e8 c1 f9 ff ff       	call   8010e4 <syscall>
  801723:	83 c4 18             	add    $0x18,%esp
	return;
  801726:	90                   	nop
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  80172c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172f:	8b 45 08             	mov    0x8(%ebp),%eax
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	52                   	push   %edx
  801739:	50                   	push   %eax
  80173a:	6a 30                	push   $0x30
  80173c:	e8 a3 f9 ff ff       	call   8010e4 <syscall>
  801741:	83 c4 18             	add    $0x18,%esp
	return;
  801744:	90                   	nop
}
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	50                   	push   %eax
  801756:	6a 31                	push   $0x31
  801758:	e8 87 f9 ff ff       	call   8010e4 <syscall>
  80175d:	83 c4 18             	add    $0x18,%esp
	return;
  801760:	90                   	nop
}
  801761:	c9                   	leave  
  801762:	c3                   	ret    

00801763 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801766:	8b 55 0c             	mov    0xc(%ebp),%edx
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	52                   	push   %edx
  801773:	50                   	push   %eax
  801774:	6a 2e                	push   $0x2e
  801776:	e8 69 f9 ff ff       	call   8010e4 <syscall>
  80177b:	83 c4 18             	add    $0x18,%esp
    return;
  80177e:	90                   	nop
}
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801787:	8b 55 08             	mov    0x8(%ebp),%edx
  80178a:	89 d0                	mov    %edx,%eax
  80178c:	c1 e0 02             	shl    $0x2,%eax
  80178f:	01 d0                	add    %edx,%eax
  801791:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801798:	01 d0                	add    %edx,%eax
  80179a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017a1:	01 d0                	add    %edx,%eax
  8017a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017aa:	01 d0                	add    %edx,%eax
  8017ac:	c1 e0 04             	shl    $0x4,%eax
  8017af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8017b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8017b9:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8017bc:	83 ec 0c             	sub    $0xc,%esp
  8017bf:	50                   	push   %eax
  8017c0:	e8 54 fc ff ff       	call   801419 <sys_get_virtual_time>
  8017c5:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8017c8:	eb 41                	jmp    80180b <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8017ca:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8017cd:	83 ec 0c             	sub    $0xc,%esp
  8017d0:	50                   	push   %eax
  8017d1:	e8 43 fc ff ff       	call   801419 <sys_get_virtual_time>
  8017d6:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8017d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017df:	29 c2                	sub    %eax,%edx
  8017e1:	89 d0                	mov    %edx,%eax
  8017e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8017e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ec:	89 d1                	mov    %edx,%ecx
  8017ee:	29 c1                	sub    %eax,%ecx
  8017f0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8017f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017f6:	39 c2                	cmp    %eax,%edx
  8017f8:	0f 97 c0             	seta   %al
  8017fb:	0f b6 c0             	movzbl %al,%eax
  8017fe:	29 c1                	sub    %eax,%ecx
  801800:	89 c8                	mov    %ecx,%eax
  801802:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801805:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801808:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80180b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801811:	72 b7                	jb     8017ca <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801813:	90                   	nop
  801814:	c9                   	leave  
  801815:	c3                   	ret    

00801816 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
  801819:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80181c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801823:	eb 03                	jmp    801828 <busy_wait+0x12>
  801825:	ff 45 fc             	incl   -0x4(%ebp)
  801828:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80182e:	72 f5                	jb     801825 <busy_wait+0xf>
	return i;
  801830:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80183b:	8d 45 10             	lea    0x10(%ebp),%eax
  80183e:	83 c0 04             	add    $0x4,%eax
  801841:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801844:	a1 28 30 80 00       	mov    0x803028,%eax
  801849:	85 c0                	test   %eax,%eax
  80184b:	74 16                	je     801863 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80184d:	a1 28 30 80 00       	mov    0x803028,%eax
  801852:	83 ec 08             	sub    $0x8,%esp
  801855:	50                   	push   %eax
  801856:	68 d8 21 80 00       	push   $0x8021d8
  80185b:	e8 ea ea ff ff       	call   80034a <cprintf>
  801860:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801863:	a1 04 30 80 00       	mov    0x803004,%eax
  801868:	ff 75 0c             	pushl  0xc(%ebp)
  80186b:	ff 75 08             	pushl  0x8(%ebp)
  80186e:	50                   	push   %eax
  80186f:	68 dd 21 80 00       	push   $0x8021dd
  801874:	e8 d1 ea ff ff       	call   80034a <cprintf>
  801879:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80187c:	8b 45 10             	mov    0x10(%ebp),%eax
  80187f:	83 ec 08             	sub    $0x8,%esp
  801882:	ff 75 f4             	pushl  -0xc(%ebp)
  801885:	50                   	push   %eax
  801886:	e8 54 ea ff ff       	call   8002df <vcprintf>
  80188b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80188e:	83 ec 08             	sub    $0x8,%esp
  801891:	6a 00                	push   $0x0
  801893:	68 f9 21 80 00       	push   $0x8021f9
  801898:	e8 42 ea ff ff       	call   8002df <vcprintf>
  80189d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8018a0:	e8 c3 e9 ff ff       	call   800268 <exit>

	// should not return here
	while (1) ;
  8018a5:	eb fe                	jmp    8018a5 <_panic+0x70>

008018a7 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
  8018aa:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8018ad:	a1 08 30 80 00       	mov    0x803008,%eax
  8018b2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8018b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018bb:	39 c2                	cmp    %eax,%edx
  8018bd:	74 14                	je     8018d3 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8018bf:	83 ec 04             	sub    $0x4,%esp
  8018c2:	68 fc 21 80 00       	push   $0x8021fc
  8018c7:	6a 26                	push   $0x26
  8018c9:	68 48 22 80 00       	push   $0x802248
  8018ce:	e8 62 ff ff ff       	call   801835 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8018d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8018da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8018e1:	e9 c5 00 00 00       	jmp    8019ab <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8018e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	01 d0                	add    %edx,%eax
  8018f5:	8b 00                	mov    (%eax),%eax
  8018f7:	85 c0                	test   %eax,%eax
  8018f9:	75 08                	jne    801903 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8018fb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8018fe:	e9 a5 00 00 00       	jmp    8019a8 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801903:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80190a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801911:	eb 69                	jmp    80197c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801913:	a1 08 30 80 00       	mov    0x803008,%eax
  801918:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80191e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801921:	89 d0                	mov    %edx,%eax
  801923:	01 c0                	add    %eax,%eax
  801925:	01 d0                	add    %edx,%eax
  801927:	c1 e0 03             	shl    $0x3,%eax
  80192a:	01 c8                	add    %ecx,%eax
  80192c:	8a 40 04             	mov    0x4(%eax),%al
  80192f:	84 c0                	test   %al,%al
  801931:	75 46                	jne    801979 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801933:	a1 08 30 80 00       	mov    0x803008,%eax
  801938:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80193e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801941:	89 d0                	mov    %edx,%eax
  801943:	01 c0                	add    %eax,%eax
  801945:	01 d0                	add    %edx,%eax
  801947:	c1 e0 03             	shl    $0x3,%eax
  80194a:	01 c8                	add    %ecx,%eax
  80194c:	8b 00                	mov    (%eax),%eax
  80194e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801951:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801954:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801959:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80195b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80195e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801965:	8b 45 08             	mov    0x8(%ebp),%eax
  801968:	01 c8                	add    %ecx,%eax
  80196a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80196c:	39 c2                	cmp    %eax,%edx
  80196e:	75 09                	jne    801979 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801970:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801977:	eb 15                	jmp    80198e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801979:	ff 45 e8             	incl   -0x18(%ebp)
  80197c:	a1 08 30 80 00       	mov    0x803008,%eax
  801981:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801987:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80198a:	39 c2                	cmp    %eax,%edx
  80198c:	77 85                	ja     801913 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80198e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801992:	75 14                	jne    8019a8 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801994:	83 ec 04             	sub    $0x4,%esp
  801997:	68 54 22 80 00       	push   $0x802254
  80199c:	6a 3a                	push   $0x3a
  80199e:	68 48 22 80 00       	push   $0x802248
  8019a3:	e8 8d fe ff ff       	call   801835 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8019a8:	ff 45 f0             	incl   -0x10(%ebp)
  8019ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8019b1:	0f 8c 2f ff ff ff    	jl     8018e6 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8019b7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019be:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8019c5:	eb 26                	jmp    8019ed <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8019c7:	a1 08 30 80 00       	mov    0x803008,%eax
  8019cc:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8019d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019d5:	89 d0                	mov    %edx,%eax
  8019d7:	01 c0                	add    %eax,%eax
  8019d9:	01 d0                	add    %edx,%eax
  8019db:	c1 e0 03             	shl    $0x3,%eax
  8019de:	01 c8                	add    %ecx,%eax
  8019e0:	8a 40 04             	mov    0x4(%eax),%al
  8019e3:	3c 01                	cmp    $0x1,%al
  8019e5:	75 03                	jne    8019ea <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8019e7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019ea:	ff 45 e0             	incl   -0x20(%ebp)
  8019ed:	a1 08 30 80 00       	mov    0x803008,%eax
  8019f2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8019f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019fb:	39 c2                	cmp    %eax,%edx
  8019fd:	77 c8                	ja     8019c7 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8019ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a02:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801a05:	74 14                	je     801a1b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801a07:	83 ec 04             	sub    $0x4,%esp
  801a0a:	68 a8 22 80 00       	push   $0x8022a8
  801a0f:	6a 44                	push   $0x44
  801a11:	68 48 22 80 00       	push   $0x802248
  801a16:	e8 1a fe ff ff       	call   801835 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801a1b:	90                   	nop
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    
  801a1e:	66 90                	xchg   %ax,%ax

00801a20 <__udivdi3>:
  801a20:	55                   	push   %ebp
  801a21:	57                   	push   %edi
  801a22:	56                   	push   %esi
  801a23:	53                   	push   %ebx
  801a24:	83 ec 1c             	sub    $0x1c,%esp
  801a27:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a2b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a33:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a37:	89 ca                	mov    %ecx,%edx
  801a39:	89 f8                	mov    %edi,%eax
  801a3b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a3f:	85 f6                	test   %esi,%esi
  801a41:	75 2d                	jne    801a70 <__udivdi3+0x50>
  801a43:	39 cf                	cmp    %ecx,%edi
  801a45:	77 65                	ja     801aac <__udivdi3+0x8c>
  801a47:	89 fd                	mov    %edi,%ebp
  801a49:	85 ff                	test   %edi,%edi
  801a4b:	75 0b                	jne    801a58 <__udivdi3+0x38>
  801a4d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a52:	31 d2                	xor    %edx,%edx
  801a54:	f7 f7                	div    %edi
  801a56:	89 c5                	mov    %eax,%ebp
  801a58:	31 d2                	xor    %edx,%edx
  801a5a:	89 c8                	mov    %ecx,%eax
  801a5c:	f7 f5                	div    %ebp
  801a5e:	89 c1                	mov    %eax,%ecx
  801a60:	89 d8                	mov    %ebx,%eax
  801a62:	f7 f5                	div    %ebp
  801a64:	89 cf                	mov    %ecx,%edi
  801a66:	89 fa                	mov    %edi,%edx
  801a68:	83 c4 1c             	add    $0x1c,%esp
  801a6b:	5b                   	pop    %ebx
  801a6c:	5e                   	pop    %esi
  801a6d:	5f                   	pop    %edi
  801a6e:	5d                   	pop    %ebp
  801a6f:	c3                   	ret    
  801a70:	39 ce                	cmp    %ecx,%esi
  801a72:	77 28                	ja     801a9c <__udivdi3+0x7c>
  801a74:	0f bd fe             	bsr    %esi,%edi
  801a77:	83 f7 1f             	xor    $0x1f,%edi
  801a7a:	75 40                	jne    801abc <__udivdi3+0x9c>
  801a7c:	39 ce                	cmp    %ecx,%esi
  801a7e:	72 0a                	jb     801a8a <__udivdi3+0x6a>
  801a80:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a84:	0f 87 9e 00 00 00    	ja     801b28 <__udivdi3+0x108>
  801a8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a8f:	89 fa                	mov    %edi,%edx
  801a91:	83 c4 1c             	add    $0x1c,%esp
  801a94:	5b                   	pop    %ebx
  801a95:	5e                   	pop    %esi
  801a96:	5f                   	pop    %edi
  801a97:	5d                   	pop    %ebp
  801a98:	c3                   	ret    
  801a99:	8d 76 00             	lea    0x0(%esi),%esi
  801a9c:	31 ff                	xor    %edi,%edi
  801a9e:	31 c0                	xor    %eax,%eax
  801aa0:	89 fa                	mov    %edi,%edx
  801aa2:	83 c4 1c             	add    $0x1c,%esp
  801aa5:	5b                   	pop    %ebx
  801aa6:	5e                   	pop    %esi
  801aa7:	5f                   	pop    %edi
  801aa8:	5d                   	pop    %ebp
  801aa9:	c3                   	ret    
  801aaa:	66 90                	xchg   %ax,%ax
  801aac:	89 d8                	mov    %ebx,%eax
  801aae:	f7 f7                	div    %edi
  801ab0:	31 ff                	xor    %edi,%edi
  801ab2:	89 fa                	mov    %edi,%edx
  801ab4:	83 c4 1c             	add    $0x1c,%esp
  801ab7:	5b                   	pop    %ebx
  801ab8:	5e                   	pop    %esi
  801ab9:	5f                   	pop    %edi
  801aba:	5d                   	pop    %ebp
  801abb:	c3                   	ret    
  801abc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ac1:	89 eb                	mov    %ebp,%ebx
  801ac3:	29 fb                	sub    %edi,%ebx
  801ac5:	89 f9                	mov    %edi,%ecx
  801ac7:	d3 e6                	shl    %cl,%esi
  801ac9:	89 c5                	mov    %eax,%ebp
  801acb:	88 d9                	mov    %bl,%cl
  801acd:	d3 ed                	shr    %cl,%ebp
  801acf:	89 e9                	mov    %ebp,%ecx
  801ad1:	09 f1                	or     %esi,%ecx
  801ad3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ad7:	89 f9                	mov    %edi,%ecx
  801ad9:	d3 e0                	shl    %cl,%eax
  801adb:	89 c5                	mov    %eax,%ebp
  801add:	89 d6                	mov    %edx,%esi
  801adf:	88 d9                	mov    %bl,%cl
  801ae1:	d3 ee                	shr    %cl,%esi
  801ae3:	89 f9                	mov    %edi,%ecx
  801ae5:	d3 e2                	shl    %cl,%edx
  801ae7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801aeb:	88 d9                	mov    %bl,%cl
  801aed:	d3 e8                	shr    %cl,%eax
  801aef:	09 c2                	or     %eax,%edx
  801af1:	89 d0                	mov    %edx,%eax
  801af3:	89 f2                	mov    %esi,%edx
  801af5:	f7 74 24 0c          	divl   0xc(%esp)
  801af9:	89 d6                	mov    %edx,%esi
  801afb:	89 c3                	mov    %eax,%ebx
  801afd:	f7 e5                	mul    %ebp
  801aff:	39 d6                	cmp    %edx,%esi
  801b01:	72 19                	jb     801b1c <__udivdi3+0xfc>
  801b03:	74 0b                	je     801b10 <__udivdi3+0xf0>
  801b05:	89 d8                	mov    %ebx,%eax
  801b07:	31 ff                	xor    %edi,%edi
  801b09:	e9 58 ff ff ff       	jmp    801a66 <__udivdi3+0x46>
  801b0e:	66 90                	xchg   %ax,%ax
  801b10:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b14:	89 f9                	mov    %edi,%ecx
  801b16:	d3 e2                	shl    %cl,%edx
  801b18:	39 c2                	cmp    %eax,%edx
  801b1a:	73 e9                	jae    801b05 <__udivdi3+0xe5>
  801b1c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b1f:	31 ff                	xor    %edi,%edi
  801b21:	e9 40 ff ff ff       	jmp    801a66 <__udivdi3+0x46>
  801b26:	66 90                	xchg   %ax,%ax
  801b28:	31 c0                	xor    %eax,%eax
  801b2a:	e9 37 ff ff ff       	jmp    801a66 <__udivdi3+0x46>
  801b2f:	90                   	nop

00801b30 <__umoddi3>:
  801b30:	55                   	push   %ebp
  801b31:	57                   	push   %edi
  801b32:	56                   	push   %esi
  801b33:	53                   	push   %ebx
  801b34:	83 ec 1c             	sub    $0x1c,%esp
  801b37:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b3b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b43:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b4b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b4f:	89 f3                	mov    %esi,%ebx
  801b51:	89 fa                	mov    %edi,%edx
  801b53:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b57:	89 34 24             	mov    %esi,(%esp)
  801b5a:	85 c0                	test   %eax,%eax
  801b5c:	75 1a                	jne    801b78 <__umoddi3+0x48>
  801b5e:	39 f7                	cmp    %esi,%edi
  801b60:	0f 86 a2 00 00 00    	jbe    801c08 <__umoddi3+0xd8>
  801b66:	89 c8                	mov    %ecx,%eax
  801b68:	89 f2                	mov    %esi,%edx
  801b6a:	f7 f7                	div    %edi
  801b6c:	89 d0                	mov    %edx,%eax
  801b6e:	31 d2                	xor    %edx,%edx
  801b70:	83 c4 1c             	add    $0x1c,%esp
  801b73:	5b                   	pop    %ebx
  801b74:	5e                   	pop    %esi
  801b75:	5f                   	pop    %edi
  801b76:	5d                   	pop    %ebp
  801b77:	c3                   	ret    
  801b78:	39 f0                	cmp    %esi,%eax
  801b7a:	0f 87 ac 00 00 00    	ja     801c2c <__umoddi3+0xfc>
  801b80:	0f bd e8             	bsr    %eax,%ebp
  801b83:	83 f5 1f             	xor    $0x1f,%ebp
  801b86:	0f 84 ac 00 00 00    	je     801c38 <__umoddi3+0x108>
  801b8c:	bf 20 00 00 00       	mov    $0x20,%edi
  801b91:	29 ef                	sub    %ebp,%edi
  801b93:	89 fe                	mov    %edi,%esi
  801b95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b99:	89 e9                	mov    %ebp,%ecx
  801b9b:	d3 e0                	shl    %cl,%eax
  801b9d:	89 d7                	mov    %edx,%edi
  801b9f:	89 f1                	mov    %esi,%ecx
  801ba1:	d3 ef                	shr    %cl,%edi
  801ba3:	09 c7                	or     %eax,%edi
  801ba5:	89 e9                	mov    %ebp,%ecx
  801ba7:	d3 e2                	shl    %cl,%edx
  801ba9:	89 14 24             	mov    %edx,(%esp)
  801bac:	89 d8                	mov    %ebx,%eax
  801bae:	d3 e0                	shl    %cl,%eax
  801bb0:	89 c2                	mov    %eax,%edx
  801bb2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bb6:	d3 e0                	shl    %cl,%eax
  801bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bbc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bc0:	89 f1                	mov    %esi,%ecx
  801bc2:	d3 e8                	shr    %cl,%eax
  801bc4:	09 d0                	or     %edx,%eax
  801bc6:	d3 eb                	shr    %cl,%ebx
  801bc8:	89 da                	mov    %ebx,%edx
  801bca:	f7 f7                	div    %edi
  801bcc:	89 d3                	mov    %edx,%ebx
  801bce:	f7 24 24             	mull   (%esp)
  801bd1:	89 c6                	mov    %eax,%esi
  801bd3:	89 d1                	mov    %edx,%ecx
  801bd5:	39 d3                	cmp    %edx,%ebx
  801bd7:	0f 82 87 00 00 00    	jb     801c64 <__umoddi3+0x134>
  801bdd:	0f 84 91 00 00 00    	je     801c74 <__umoddi3+0x144>
  801be3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801be7:	29 f2                	sub    %esi,%edx
  801be9:	19 cb                	sbb    %ecx,%ebx
  801beb:	89 d8                	mov    %ebx,%eax
  801bed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bf1:	d3 e0                	shl    %cl,%eax
  801bf3:	89 e9                	mov    %ebp,%ecx
  801bf5:	d3 ea                	shr    %cl,%edx
  801bf7:	09 d0                	or     %edx,%eax
  801bf9:	89 e9                	mov    %ebp,%ecx
  801bfb:	d3 eb                	shr    %cl,%ebx
  801bfd:	89 da                	mov    %ebx,%edx
  801bff:	83 c4 1c             	add    $0x1c,%esp
  801c02:	5b                   	pop    %ebx
  801c03:	5e                   	pop    %esi
  801c04:	5f                   	pop    %edi
  801c05:	5d                   	pop    %ebp
  801c06:	c3                   	ret    
  801c07:	90                   	nop
  801c08:	89 fd                	mov    %edi,%ebp
  801c0a:	85 ff                	test   %edi,%edi
  801c0c:	75 0b                	jne    801c19 <__umoddi3+0xe9>
  801c0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c13:	31 d2                	xor    %edx,%edx
  801c15:	f7 f7                	div    %edi
  801c17:	89 c5                	mov    %eax,%ebp
  801c19:	89 f0                	mov    %esi,%eax
  801c1b:	31 d2                	xor    %edx,%edx
  801c1d:	f7 f5                	div    %ebp
  801c1f:	89 c8                	mov    %ecx,%eax
  801c21:	f7 f5                	div    %ebp
  801c23:	89 d0                	mov    %edx,%eax
  801c25:	e9 44 ff ff ff       	jmp    801b6e <__umoddi3+0x3e>
  801c2a:	66 90                	xchg   %ax,%ax
  801c2c:	89 c8                	mov    %ecx,%eax
  801c2e:	89 f2                	mov    %esi,%edx
  801c30:	83 c4 1c             	add    $0x1c,%esp
  801c33:	5b                   	pop    %ebx
  801c34:	5e                   	pop    %esi
  801c35:	5f                   	pop    %edi
  801c36:	5d                   	pop    %ebp
  801c37:	c3                   	ret    
  801c38:	3b 04 24             	cmp    (%esp),%eax
  801c3b:	72 06                	jb     801c43 <__umoddi3+0x113>
  801c3d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c41:	77 0f                	ja     801c52 <__umoddi3+0x122>
  801c43:	89 f2                	mov    %esi,%edx
  801c45:	29 f9                	sub    %edi,%ecx
  801c47:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c4b:	89 14 24             	mov    %edx,(%esp)
  801c4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c52:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c56:	8b 14 24             	mov    (%esp),%edx
  801c59:	83 c4 1c             	add    $0x1c,%esp
  801c5c:	5b                   	pop    %ebx
  801c5d:	5e                   	pop    %esi
  801c5e:	5f                   	pop    %edi
  801c5f:	5d                   	pop    %ebp
  801c60:	c3                   	ret    
  801c61:	8d 76 00             	lea    0x0(%esi),%esi
  801c64:	2b 04 24             	sub    (%esp),%eax
  801c67:	19 fa                	sbb    %edi,%edx
  801c69:	89 d1                	mov    %edx,%ecx
  801c6b:	89 c6                	mov    %eax,%esi
  801c6d:	e9 71 ff ff ff       	jmp    801be3 <__umoddi3+0xb3>
  801c72:	66 90                	xchg   %ax,%ax
  801c74:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c78:	72 ea                	jb     801c64 <__umoddi3+0x134>
  801c7a:	89 d9                	mov    %ebx,%ecx
  801c7c:	e9 62 ff ff ff       	jmp    801be3 <__umoddi3+0xb3>
