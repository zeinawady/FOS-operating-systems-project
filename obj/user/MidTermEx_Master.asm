
obj/user/MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 ba 01 00 00       	call   8001f0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	/*[1] CREATE SHARED VARIABLE & INITIALIZE IT*/
	int *X = smalloc("X", sizeof(int) , 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 a0 37 80 00       	push   $0x8037a0
  80004a:	e8 21 14 00 00       	call   801470 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	cprintf("Do you want to use semaphore (y/n)? ") ;
  80005e:	83 ec 0c             	sub    $0xc,%esp
  800061:	68 a4 37 80 00       	push   $0x8037a4
  800066:	e8 9e 03 00 00       	call   800409 <cprintf>
  80006b:	83 c4 10             	add    $0x10,%esp
	char select = getchar() ;
  80006e:	e8 60 01 00 00       	call   8001d3 <getchar>
  800073:	88 45 f3             	mov    %al,-0xd(%ebp)
	cputchar(select);
  800076:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
  80007a:	83 ec 0c             	sub    $0xc,%esp
  80007d:	50                   	push   %eax
  80007e:	e8 31 01 00 00       	call   8001b4 <cputchar>
  800083:	83 c4 10             	add    $0x10,%esp
	cputchar('\n');
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	6a 0a                	push   $0xa
  80008b:	e8 24 01 00 00       	call   8001b4 <cputchar>
  800090:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *useSem = smalloc("useSem", sizeof(int) , 0) ;
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	6a 00                	push   $0x0
  800098:	6a 04                	push   $0x4
  80009a:	68 c9 37 80 00       	push   $0x8037c9
  80009f:	e8 cc 13 00 00       	call   801470 <smalloc>
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*useSem = 0 ;
  8000aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == 'Y' || select == 'y')
  8000b3:	80 7d f3 59          	cmpb   $0x59,-0xd(%ebp)
  8000b7:	74 06                	je     8000bf <_main+0x87>
  8000b9:	80 7d f3 79          	cmpb   $0x79,-0xd(%ebp)
  8000bd:	75 09                	jne    8000c8 <_main+0x90>
		*useSem = 1 ;
  8000bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000c2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	struct semaphore T ;
	if (*useSem == 1)
  8000c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cb:	8b 00                	mov    (%eax),%eax
  8000cd:	83 f8 01             	cmp    $0x1,%eax
  8000d0:	75 16                	jne    8000e8 <_main+0xb0>
	{
		T = create_semaphore("T", 0);
  8000d2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  8000d5:	83 ec 04             	sub    $0x4,%esp
  8000d8:	6a 00                	push   $0x0
  8000da:	68 d0 37 80 00       	push   $0x8037d0
  8000df:	50                   	push   %eax
  8000e0:	e8 b5 30 00 00       	call   80319a <create_semaphore>
  8000e5:	83 c4 0c             	add    $0xc,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000e8:	83 ec 04             	sub    $0x4,%esp
  8000eb:	6a 01                	push   $0x1
  8000ed:	6a 04                	push   $0x4
  8000ef:	68 d2 37 80 00       	push   $0x8037d2
  8000f4:	e8 77 13 00 00       	call   801470 <smalloc>
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800102:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800108:	a1 20 50 80 00       	mov    0x805020,%eax
  80010d:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  800113:	a1 20 50 80 00       	mov    0x805020,%eax
  800118:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  80011e:	89 c1                	mov    %eax,%ecx
  800120:	a1 20 50 80 00       	mov    0x805020,%eax
  800125:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80012b:	52                   	push   %edx
  80012c:	51                   	push   %ecx
  80012d:	50                   	push   %eax
  80012e:	68 e0 37 80 00       	push   $0x8037e0
  800133:	e8 b1 19 00 00       	call   801ae9 <sys_create_env>
  800138:	83 c4 10             	add    $0x10,%esp
  80013b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80013e:	a1 20 50 80 00       	mov    0x805020,%eax
  800143:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  800149:	a1 20 50 80 00       	mov    0x805020,%eax
  80014e:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  800154:	89 c1                	mov    %eax,%ecx
  800156:	a1 20 50 80 00       	mov    0x805020,%eax
  80015b:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800161:	52                   	push   %edx
  800162:	51                   	push   %ecx
  800163:	50                   	push   %eax
  800164:	68 ea 37 80 00       	push   $0x8037ea
  800169:	e8 7b 19 00 00       	call   801ae9 <sys_create_env>
  80016e:	83 c4 10             	add    $0x10,%esp
  800171:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800174:	83 ec 0c             	sub    $0xc,%esp
  800177:	ff 75 e4             	pushl  -0x1c(%ebp)
  80017a:	e8 88 19 00 00       	call   801b07 <sys_run_env>
  80017f:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	ff 75 e0             	pushl  -0x20(%ebp)
  800188:	e8 7a 19 00 00       	call   801b07 <sys_run_env>
  80018d:	83 c4 10             	add    $0x10,%esp

	/*[5] BUSY-WAIT TILL FINISHING BOTH PROCESSES*/
	while (*numOfFinished != 2) ;
  800190:	90                   	nop
  800191:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800194:	8b 00                	mov    (%eax),%eax
  800196:	83 f8 02             	cmp    $0x2,%eax
  800199:	75 f6                	jne    800191 <_main+0x159>

	/*[6] PRINT X*/
	cprintf("Final value of X = %d\n", *X);
  80019b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80019e:	8b 00                	mov    (%eax),%eax
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	50                   	push   %eax
  8001a4:	68 f4 37 80 00       	push   $0x8037f4
  8001a9:	e8 5b 02 00 00       	call   800409 <cprintf>
  8001ae:	83 c4 10             	add    $0x10,%esp

	return;
  8001b1:	90                   	nop
}
  8001b2:	c9                   	leave  
  8001b3:	c3                   	ret    

008001b4 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8001ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bd:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8001c0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8001c4:	83 ec 0c             	sub    $0xc,%esp
  8001c7:	50                   	push   %eax
  8001c8:	e8 59 18 00 00       	call   801a26 <sys_cputc>
  8001cd:	83 c4 10             	add    $0x10,%esp
}
  8001d0:	90                   	nop
  8001d1:	c9                   	leave  
  8001d2:	c3                   	ret    

008001d3 <getchar>:


int
getchar(void)
{
  8001d3:	55                   	push   %ebp
  8001d4:	89 e5                	mov    %esp,%ebp
  8001d6:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8001d9:	e8 e4 16 00 00       	call   8018c2 <sys_cgetc>
  8001de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8001e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8001e4:	c9                   	leave  
  8001e5:	c3                   	ret    

008001e6 <iscons>:

int iscons(int fdnum)
{
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8001e9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8001ee:	5d                   	pop    %ebp
  8001ef:	c3                   	ret    

008001f0 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8001f6:	e8 5c 19 00 00       	call   801b57 <sys_getenvindex>
  8001fb:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8001fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800201:	89 d0                	mov    %edx,%eax
  800203:	c1 e0 02             	shl    $0x2,%eax
  800206:	01 d0                	add    %edx,%eax
  800208:	c1 e0 03             	shl    $0x3,%eax
  80020b:	01 d0                	add    %edx,%eax
  80020d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800214:	01 d0                	add    %edx,%eax
  800216:	c1 e0 02             	shl    $0x2,%eax
  800219:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80021e:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800223:	a1 20 50 80 00       	mov    0x805020,%eax
  800228:	8a 40 20             	mov    0x20(%eax),%al
  80022b:	84 c0                	test   %al,%al
  80022d:	74 0d                	je     80023c <libmain+0x4c>
		binaryname = myEnv->prog_name;
  80022f:	a1 20 50 80 00       	mov    0x805020,%eax
  800234:	83 c0 20             	add    $0x20,%eax
  800237:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80023c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800240:	7e 0a                	jle    80024c <libmain+0x5c>
		binaryname = argv[0];
  800242:	8b 45 0c             	mov    0xc(%ebp),%eax
  800245:	8b 00                	mov    (%eax),%eax
  800247:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80024c:	83 ec 08             	sub    $0x8,%esp
  80024f:	ff 75 0c             	pushl  0xc(%ebp)
  800252:	ff 75 08             	pushl  0x8(%ebp)
  800255:	e8 de fd ff ff       	call   800038 <_main>
  80025a:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80025d:	a1 00 50 80 00       	mov    0x805000,%eax
  800262:	85 c0                	test   %eax,%eax
  800264:	0f 84 9f 00 00 00    	je     800309 <libmain+0x119>
	{
		sys_lock_cons();
  80026a:	e8 6c 16 00 00       	call   8018db <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	68 24 38 80 00       	push   $0x803824
  800277:	e8 8d 01 00 00       	call   800409 <cprintf>
  80027c:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80027f:	a1 20 50 80 00       	mov    0x805020,%eax
  800284:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80028a:	a1 20 50 80 00       	mov    0x805020,%eax
  80028f:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800295:	83 ec 04             	sub    $0x4,%esp
  800298:	52                   	push   %edx
  800299:	50                   	push   %eax
  80029a:	68 4c 38 80 00       	push   $0x80384c
  80029f:	e8 65 01 00 00       	call   800409 <cprintf>
  8002a4:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002a7:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ac:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8002b2:	a1 20 50 80 00       	mov    0x805020,%eax
  8002b7:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8002bd:	a1 20 50 80 00       	mov    0x805020,%eax
  8002c2:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8002c8:	51                   	push   %ecx
  8002c9:	52                   	push   %edx
  8002ca:	50                   	push   %eax
  8002cb:	68 74 38 80 00       	push   $0x803874
  8002d0:	e8 34 01 00 00       	call   800409 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002d8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002dd:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8002e3:	83 ec 08             	sub    $0x8,%esp
  8002e6:	50                   	push   %eax
  8002e7:	68 cc 38 80 00       	push   $0x8038cc
  8002ec:	e8 18 01 00 00       	call   800409 <cprintf>
  8002f1:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 24 38 80 00       	push   $0x803824
  8002fc:	e8 08 01 00 00       	call   800409 <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800304:	e8 ec 15 00 00       	call   8018f5 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800309:	e8 19 00 00 00       	call   800327 <exit>
}
  80030e:	90                   	nop
  80030f:	c9                   	leave  
  800310:	c3                   	ret    

00800311 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	6a 00                	push   $0x0
  80031c:	e8 02 18 00 00       	call   801b23 <sys_destroy_env>
  800321:	83 c4 10             	add    $0x10,%esp
}
  800324:	90                   	nop
  800325:	c9                   	leave  
  800326:	c3                   	ret    

00800327 <exit>:

void
exit(void)
{
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80032d:	e8 57 18 00 00       	call   801b89 <sys_exit_env>
}
  800332:	90                   	nop
  800333:	c9                   	leave  
  800334:	c3                   	ret    

00800335 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
  800338:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80033b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033e:	8b 00                	mov    (%eax),%eax
  800340:	8d 48 01             	lea    0x1(%eax),%ecx
  800343:	8b 55 0c             	mov    0xc(%ebp),%edx
  800346:	89 0a                	mov    %ecx,(%edx)
  800348:	8b 55 08             	mov    0x8(%ebp),%edx
  80034b:	88 d1                	mov    %dl,%cl
  80034d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800350:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800354:	8b 45 0c             	mov    0xc(%ebp),%eax
  800357:	8b 00                	mov    (%eax),%eax
  800359:	3d ff 00 00 00       	cmp    $0xff,%eax
  80035e:	75 2c                	jne    80038c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800360:	a0 44 50 98 00       	mov    0x985044,%al
  800365:	0f b6 c0             	movzbl %al,%eax
  800368:	8b 55 0c             	mov    0xc(%ebp),%edx
  80036b:	8b 12                	mov    (%edx),%edx
  80036d:	89 d1                	mov    %edx,%ecx
  80036f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800372:	83 c2 08             	add    $0x8,%edx
  800375:	83 ec 04             	sub    $0x4,%esp
  800378:	50                   	push   %eax
  800379:	51                   	push   %ecx
  80037a:	52                   	push   %edx
  80037b:	e8 19 15 00 00       	call   801899 <sys_cputs>
  800380:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800383:	8b 45 0c             	mov    0xc(%ebp),%eax
  800386:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80038c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038f:	8b 40 04             	mov    0x4(%eax),%eax
  800392:	8d 50 01             	lea    0x1(%eax),%edx
  800395:	8b 45 0c             	mov    0xc(%ebp),%eax
  800398:	89 50 04             	mov    %edx,0x4(%eax)
}
  80039b:	90                   	nop
  80039c:	c9                   	leave  
  80039d:	c3                   	ret    

0080039e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80039e:	55                   	push   %ebp
  80039f:	89 e5                	mov    %esp,%ebp
  8003a1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003a7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003ae:	00 00 00 
	b.cnt = 0;
  8003b1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003b8:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8003bb:	ff 75 0c             	pushl  0xc(%ebp)
  8003be:	ff 75 08             	pushl  0x8(%ebp)
  8003c1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003c7:	50                   	push   %eax
  8003c8:	68 35 03 80 00       	push   $0x800335
  8003cd:	e8 11 02 00 00       	call   8005e3 <vprintfmt>
  8003d2:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8003d5:	a0 44 50 98 00       	mov    0x985044,%al
  8003da:	0f b6 c0             	movzbl %al,%eax
  8003dd:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8003e3:	83 ec 04             	sub    $0x4,%esp
  8003e6:	50                   	push   %eax
  8003e7:	52                   	push   %edx
  8003e8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003ee:	83 c0 08             	add    $0x8,%eax
  8003f1:	50                   	push   %eax
  8003f2:	e8 a2 14 00 00       	call   801899 <sys_cputs>
  8003f7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8003fa:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  800401:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800407:	c9                   	leave  
  800408:	c3                   	ret    

00800409 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80040f:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  800416:	8d 45 0c             	lea    0xc(%ebp),%eax
  800419:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80041c:	8b 45 08             	mov    0x8(%ebp),%eax
  80041f:	83 ec 08             	sub    $0x8,%esp
  800422:	ff 75 f4             	pushl  -0xc(%ebp)
  800425:	50                   	push   %eax
  800426:	e8 73 ff ff ff       	call   80039e <vcprintf>
  80042b:	83 c4 10             	add    $0x10,%esp
  80042e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800431:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800434:	c9                   	leave  
  800435:	c3                   	ret    

00800436 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800436:	55                   	push   %ebp
  800437:	89 e5                	mov    %esp,%ebp
  800439:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80043c:	e8 9a 14 00 00       	call   8018db <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800441:	8d 45 0c             	lea    0xc(%ebp),%eax
  800444:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800447:	8b 45 08             	mov    0x8(%ebp),%eax
  80044a:	83 ec 08             	sub    $0x8,%esp
  80044d:	ff 75 f4             	pushl  -0xc(%ebp)
  800450:	50                   	push   %eax
  800451:	e8 48 ff ff ff       	call   80039e <vcprintf>
  800456:	83 c4 10             	add    $0x10,%esp
  800459:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80045c:	e8 94 14 00 00       	call   8018f5 <sys_unlock_cons>
	return cnt;
  800461:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800464:	c9                   	leave  
  800465:	c3                   	ret    

00800466 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800466:	55                   	push   %ebp
  800467:	89 e5                	mov    %esp,%ebp
  800469:	53                   	push   %ebx
  80046a:	83 ec 14             	sub    $0x14,%esp
  80046d:	8b 45 10             	mov    0x10(%ebp),%eax
  800470:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800473:	8b 45 14             	mov    0x14(%ebp),%eax
  800476:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800479:	8b 45 18             	mov    0x18(%ebp),%eax
  80047c:	ba 00 00 00 00       	mov    $0x0,%edx
  800481:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800484:	77 55                	ja     8004db <printnum+0x75>
  800486:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800489:	72 05                	jb     800490 <printnum+0x2a>
  80048b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80048e:	77 4b                	ja     8004db <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800490:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800493:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800496:	8b 45 18             	mov    0x18(%ebp),%eax
  800499:	ba 00 00 00 00       	mov    $0x0,%edx
  80049e:	52                   	push   %edx
  80049f:	50                   	push   %eax
  8004a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8004a6:	e8 7d 30 00 00       	call   803528 <__udivdi3>
  8004ab:	83 c4 10             	add    $0x10,%esp
  8004ae:	83 ec 04             	sub    $0x4,%esp
  8004b1:	ff 75 20             	pushl  0x20(%ebp)
  8004b4:	53                   	push   %ebx
  8004b5:	ff 75 18             	pushl  0x18(%ebp)
  8004b8:	52                   	push   %edx
  8004b9:	50                   	push   %eax
  8004ba:	ff 75 0c             	pushl  0xc(%ebp)
  8004bd:	ff 75 08             	pushl  0x8(%ebp)
  8004c0:	e8 a1 ff ff ff       	call   800466 <printnum>
  8004c5:	83 c4 20             	add    $0x20,%esp
  8004c8:	eb 1a                	jmp    8004e4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004ca:	83 ec 08             	sub    $0x8,%esp
  8004cd:	ff 75 0c             	pushl  0xc(%ebp)
  8004d0:	ff 75 20             	pushl  0x20(%ebp)
  8004d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d6:	ff d0                	call   *%eax
  8004d8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004db:	ff 4d 1c             	decl   0x1c(%ebp)
  8004de:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004e2:	7f e6                	jg     8004ca <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004e4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004f2:	53                   	push   %ebx
  8004f3:	51                   	push   %ecx
  8004f4:	52                   	push   %edx
  8004f5:	50                   	push   %eax
  8004f6:	e8 3d 31 00 00       	call   803638 <__umoddi3>
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	05 f4 3a 80 00       	add    $0x803af4,%eax
  800503:	8a 00                	mov    (%eax),%al
  800505:	0f be c0             	movsbl %al,%eax
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	ff 75 0c             	pushl  0xc(%ebp)
  80050e:	50                   	push   %eax
  80050f:	8b 45 08             	mov    0x8(%ebp),%eax
  800512:	ff d0                	call   *%eax
  800514:	83 c4 10             	add    $0x10,%esp
}
  800517:	90                   	nop
  800518:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80051b:	c9                   	leave  
  80051c:	c3                   	ret    

0080051d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80051d:	55                   	push   %ebp
  80051e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800520:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800524:	7e 1c                	jle    800542 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800526:	8b 45 08             	mov    0x8(%ebp),%eax
  800529:	8b 00                	mov    (%eax),%eax
  80052b:	8d 50 08             	lea    0x8(%eax),%edx
  80052e:	8b 45 08             	mov    0x8(%ebp),%eax
  800531:	89 10                	mov    %edx,(%eax)
  800533:	8b 45 08             	mov    0x8(%ebp),%eax
  800536:	8b 00                	mov    (%eax),%eax
  800538:	83 e8 08             	sub    $0x8,%eax
  80053b:	8b 50 04             	mov    0x4(%eax),%edx
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	eb 40                	jmp    800582 <getuint+0x65>
	else if (lflag)
  800542:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800546:	74 1e                	je     800566 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800548:	8b 45 08             	mov    0x8(%ebp),%eax
  80054b:	8b 00                	mov    (%eax),%eax
  80054d:	8d 50 04             	lea    0x4(%eax),%edx
  800550:	8b 45 08             	mov    0x8(%ebp),%eax
  800553:	89 10                	mov    %edx,(%eax)
  800555:	8b 45 08             	mov    0x8(%ebp),%eax
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	83 e8 04             	sub    $0x4,%eax
  80055d:	8b 00                	mov    (%eax),%eax
  80055f:	ba 00 00 00 00       	mov    $0x0,%edx
  800564:	eb 1c                	jmp    800582 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800566:	8b 45 08             	mov    0x8(%ebp),%eax
  800569:	8b 00                	mov    (%eax),%eax
  80056b:	8d 50 04             	lea    0x4(%eax),%edx
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	89 10                	mov    %edx,(%eax)
  800573:	8b 45 08             	mov    0x8(%ebp),%eax
  800576:	8b 00                	mov    (%eax),%eax
  800578:	83 e8 04             	sub    $0x4,%eax
  80057b:	8b 00                	mov    (%eax),%eax
  80057d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800582:	5d                   	pop    %ebp
  800583:	c3                   	ret    

00800584 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800584:	55                   	push   %ebp
  800585:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800587:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80058b:	7e 1c                	jle    8005a9 <getint+0x25>
		return va_arg(*ap, long long);
  80058d:	8b 45 08             	mov    0x8(%ebp),%eax
  800590:	8b 00                	mov    (%eax),%eax
  800592:	8d 50 08             	lea    0x8(%eax),%edx
  800595:	8b 45 08             	mov    0x8(%ebp),%eax
  800598:	89 10                	mov    %edx,(%eax)
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	83 e8 08             	sub    $0x8,%eax
  8005a2:	8b 50 04             	mov    0x4(%eax),%edx
  8005a5:	8b 00                	mov    (%eax),%eax
  8005a7:	eb 38                	jmp    8005e1 <getint+0x5d>
	else if (lflag)
  8005a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005ad:	74 1a                	je     8005c9 <getint+0x45>
		return va_arg(*ap, long);
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	8b 00                	mov    (%eax),%eax
  8005b4:	8d 50 04             	lea    0x4(%eax),%edx
  8005b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ba:	89 10                	mov    %edx,(%eax)
  8005bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bf:	8b 00                	mov    (%eax),%eax
  8005c1:	83 e8 04             	sub    $0x4,%eax
  8005c4:	8b 00                	mov    (%eax),%eax
  8005c6:	99                   	cltd   
  8005c7:	eb 18                	jmp    8005e1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8005c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	8d 50 04             	lea    0x4(%eax),%edx
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d4:	89 10                	mov    %edx,(%eax)
  8005d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d9:	8b 00                	mov    (%eax),%eax
  8005db:	83 e8 04             	sub    $0x4,%eax
  8005de:	8b 00                	mov    (%eax),%eax
  8005e0:	99                   	cltd   
}
  8005e1:	5d                   	pop    %ebp
  8005e2:	c3                   	ret    

008005e3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005e3:	55                   	push   %ebp
  8005e4:	89 e5                	mov    %esp,%ebp
  8005e6:	56                   	push   %esi
  8005e7:	53                   	push   %ebx
  8005e8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005eb:	eb 17                	jmp    800604 <vprintfmt+0x21>
			if (ch == '\0')
  8005ed:	85 db                	test   %ebx,%ebx
  8005ef:	0f 84 c1 03 00 00    	je     8009b6 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8005f5:	83 ec 08             	sub    $0x8,%esp
  8005f8:	ff 75 0c             	pushl  0xc(%ebp)
  8005fb:	53                   	push   %ebx
  8005fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ff:	ff d0                	call   *%eax
  800601:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800604:	8b 45 10             	mov    0x10(%ebp),%eax
  800607:	8d 50 01             	lea    0x1(%eax),%edx
  80060a:	89 55 10             	mov    %edx,0x10(%ebp)
  80060d:	8a 00                	mov    (%eax),%al
  80060f:	0f b6 d8             	movzbl %al,%ebx
  800612:	83 fb 25             	cmp    $0x25,%ebx
  800615:	75 d6                	jne    8005ed <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800617:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80061b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800622:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800629:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800630:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800637:	8b 45 10             	mov    0x10(%ebp),%eax
  80063a:	8d 50 01             	lea    0x1(%eax),%edx
  80063d:	89 55 10             	mov    %edx,0x10(%ebp)
  800640:	8a 00                	mov    (%eax),%al
  800642:	0f b6 d8             	movzbl %al,%ebx
  800645:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800648:	83 f8 5b             	cmp    $0x5b,%eax
  80064b:	0f 87 3d 03 00 00    	ja     80098e <vprintfmt+0x3ab>
  800651:	8b 04 85 18 3b 80 00 	mov    0x803b18(,%eax,4),%eax
  800658:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80065a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80065e:	eb d7                	jmp    800637 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800660:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800664:	eb d1                	jmp    800637 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800666:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80066d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800670:	89 d0                	mov    %edx,%eax
  800672:	c1 e0 02             	shl    $0x2,%eax
  800675:	01 d0                	add    %edx,%eax
  800677:	01 c0                	add    %eax,%eax
  800679:	01 d8                	add    %ebx,%eax
  80067b:	83 e8 30             	sub    $0x30,%eax
  80067e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800681:	8b 45 10             	mov    0x10(%ebp),%eax
  800684:	8a 00                	mov    (%eax),%al
  800686:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800689:	83 fb 2f             	cmp    $0x2f,%ebx
  80068c:	7e 3e                	jle    8006cc <vprintfmt+0xe9>
  80068e:	83 fb 39             	cmp    $0x39,%ebx
  800691:	7f 39                	jg     8006cc <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800693:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800696:	eb d5                	jmp    80066d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	83 c0 04             	add    $0x4,%eax
  80069e:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	83 e8 04             	sub    $0x4,%eax
  8006a7:	8b 00                	mov    (%eax),%eax
  8006a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006ac:	eb 1f                	jmp    8006cd <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006ae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006b2:	79 83                	jns    800637 <vprintfmt+0x54>
				width = 0;
  8006b4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8006bb:	e9 77 ff ff ff       	jmp    800637 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8006c0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8006c7:	e9 6b ff ff ff       	jmp    800637 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8006cc:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006d1:	0f 89 60 ff ff ff    	jns    800637 <vprintfmt+0x54>
				width = precision, precision = -1;
  8006d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006dd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8006e4:	e9 4e ff ff ff       	jmp    800637 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006e9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8006ec:	e9 46 ff ff ff       	jmp    800637 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f4:	83 c0 04             	add    $0x4,%eax
  8006f7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fd:	83 e8 04             	sub    $0x4,%eax
  800700:	8b 00                	mov    (%eax),%eax
  800702:	83 ec 08             	sub    $0x8,%esp
  800705:	ff 75 0c             	pushl  0xc(%ebp)
  800708:	50                   	push   %eax
  800709:	8b 45 08             	mov    0x8(%ebp),%eax
  80070c:	ff d0                	call   *%eax
  80070e:	83 c4 10             	add    $0x10,%esp
			break;
  800711:	e9 9b 02 00 00       	jmp    8009b1 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800716:	8b 45 14             	mov    0x14(%ebp),%eax
  800719:	83 c0 04             	add    $0x4,%eax
  80071c:	89 45 14             	mov    %eax,0x14(%ebp)
  80071f:	8b 45 14             	mov    0x14(%ebp),%eax
  800722:	83 e8 04             	sub    $0x4,%eax
  800725:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800727:	85 db                	test   %ebx,%ebx
  800729:	79 02                	jns    80072d <vprintfmt+0x14a>
				err = -err;
  80072b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80072d:	83 fb 64             	cmp    $0x64,%ebx
  800730:	7f 0b                	jg     80073d <vprintfmt+0x15a>
  800732:	8b 34 9d 60 39 80 00 	mov    0x803960(,%ebx,4),%esi
  800739:	85 f6                	test   %esi,%esi
  80073b:	75 19                	jne    800756 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80073d:	53                   	push   %ebx
  80073e:	68 05 3b 80 00       	push   $0x803b05
  800743:	ff 75 0c             	pushl  0xc(%ebp)
  800746:	ff 75 08             	pushl  0x8(%ebp)
  800749:	e8 70 02 00 00       	call   8009be <printfmt>
  80074e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800751:	e9 5b 02 00 00       	jmp    8009b1 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800756:	56                   	push   %esi
  800757:	68 0e 3b 80 00       	push   $0x803b0e
  80075c:	ff 75 0c             	pushl  0xc(%ebp)
  80075f:	ff 75 08             	pushl  0x8(%ebp)
  800762:	e8 57 02 00 00       	call   8009be <printfmt>
  800767:	83 c4 10             	add    $0x10,%esp
			break;
  80076a:	e9 42 02 00 00       	jmp    8009b1 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80076f:	8b 45 14             	mov    0x14(%ebp),%eax
  800772:	83 c0 04             	add    $0x4,%eax
  800775:	89 45 14             	mov    %eax,0x14(%ebp)
  800778:	8b 45 14             	mov    0x14(%ebp),%eax
  80077b:	83 e8 04             	sub    $0x4,%eax
  80077e:	8b 30                	mov    (%eax),%esi
  800780:	85 f6                	test   %esi,%esi
  800782:	75 05                	jne    800789 <vprintfmt+0x1a6>
				p = "(null)";
  800784:	be 11 3b 80 00       	mov    $0x803b11,%esi
			if (width > 0 && padc != '-')
  800789:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80078d:	7e 6d                	jle    8007fc <vprintfmt+0x219>
  80078f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800793:	74 67                	je     8007fc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800795:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800798:	83 ec 08             	sub    $0x8,%esp
  80079b:	50                   	push   %eax
  80079c:	56                   	push   %esi
  80079d:	e8 1e 03 00 00       	call   800ac0 <strnlen>
  8007a2:	83 c4 10             	add    $0x10,%esp
  8007a5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007a8:	eb 16                	jmp    8007c0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007aa:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007ae:	83 ec 08             	sub    $0x8,%esp
  8007b1:	ff 75 0c             	pushl  0xc(%ebp)
  8007b4:	50                   	push   %eax
  8007b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b8:	ff d0                	call   *%eax
  8007ba:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007bd:	ff 4d e4             	decl   -0x1c(%ebp)
  8007c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007c4:	7f e4                	jg     8007aa <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007c6:	eb 34                	jmp    8007fc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8007c8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007cc:	74 1c                	je     8007ea <vprintfmt+0x207>
  8007ce:	83 fb 1f             	cmp    $0x1f,%ebx
  8007d1:	7e 05                	jle    8007d8 <vprintfmt+0x1f5>
  8007d3:	83 fb 7e             	cmp    $0x7e,%ebx
  8007d6:	7e 12                	jle    8007ea <vprintfmt+0x207>
					putch('?', putdat);
  8007d8:	83 ec 08             	sub    $0x8,%esp
  8007db:	ff 75 0c             	pushl  0xc(%ebp)
  8007de:	6a 3f                	push   $0x3f
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	ff d0                	call   *%eax
  8007e5:	83 c4 10             	add    $0x10,%esp
  8007e8:	eb 0f                	jmp    8007f9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	ff 75 0c             	pushl  0xc(%ebp)
  8007f0:	53                   	push   %ebx
  8007f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f4:	ff d0                	call   *%eax
  8007f6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007f9:	ff 4d e4             	decl   -0x1c(%ebp)
  8007fc:	89 f0                	mov    %esi,%eax
  8007fe:	8d 70 01             	lea    0x1(%eax),%esi
  800801:	8a 00                	mov    (%eax),%al
  800803:	0f be d8             	movsbl %al,%ebx
  800806:	85 db                	test   %ebx,%ebx
  800808:	74 24                	je     80082e <vprintfmt+0x24b>
  80080a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80080e:	78 b8                	js     8007c8 <vprintfmt+0x1e5>
  800810:	ff 4d e0             	decl   -0x20(%ebp)
  800813:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800817:	79 af                	jns    8007c8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800819:	eb 13                	jmp    80082e <vprintfmt+0x24b>
				putch(' ', putdat);
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	ff 75 0c             	pushl  0xc(%ebp)
  800821:	6a 20                	push   $0x20
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	ff d0                	call   *%eax
  800828:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80082b:	ff 4d e4             	decl   -0x1c(%ebp)
  80082e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800832:	7f e7                	jg     80081b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800834:	e9 78 01 00 00       	jmp    8009b1 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800839:	83 ec 08             	sub    $0x8,%esp
  80083c:	ff 75 e8             	pushl  -0x18(%ebp)
  80083f:	8d 45 14             	lea    0x14(%ebp),%eax
  800842:	50                   	push   %eax
  800843:	e8 3c fd ff ff       	call   800584 <getint>
  800848:	83 c4 10             	add    $0x10,%esp
  80084b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80084e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800854:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800857:	85 d2                	test   %edx,%edx
  800859:	79 23                	jns    80087e <vprintfmt+0x29b>
				putch('-', putdat);
  80085b:	83 ec 08             	sub    $0x8,%esp
  80085e:	ff 75 0c             	pushl  0xc(%ebp)
  800861:	6a 2d                	push   $0x2d
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	ff d0                	call   *%eax
  800868:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80086b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800871:	f7 d8                	neg    %eax
  800873:	83 d2 00             	adc    $0x0,%edx
  800876:	f7 da                	neg    %edx
  800878:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80087b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80087e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800885:	e9 bc 00 00 00       	jmp    800946 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80088a:	83 ec 08             	sub    $0x8,%esp
  80088d:	ff 75 e8             	pushl  -0x18(%ebp)
  800890:	8d 45 14             	lea    0x14(%ebp),%eax
  800893:	50                   	push   %eax
  800894:	e8 84 fc ff ff       	call   80051d <getuint>
  800899:	83 c4 10             	add    $0x10,%esp
  80089c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80089f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008a2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008a9:	e9 98 00 00 00       	jmp    800946 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	ff 75 0c             	pushl  0xc(%ebp)
  8008b4:	6a 58                	push   $0x58
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	ff d0                	call   *%eax
  8008bb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008be:	83 ec 08             	sub    $0x8,%esp
  8008c1:	ff 75 0c             	pushl  0xc(%ebp)
  8008c4:	6a 58                	push   $0x58
  8008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c9:	ff d0                	call   *%eax
  8008cb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008ce:	83 ec 08             	sub    $0x8,%esp
  8008d1:	ff 75 0c             	pushl  0xc(%ebp)
  8008d4:	6a 58                	push   $0x58
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	ff d0                	call   *%eax
  8008db:	83 c4 10             	add    $0x10,%esp
			break;
  8008de:	e9 ce 00 00 00       	jmp    8009b1 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8008e3:	83 ec 08             	sub    $0x8,%esp
  8008e6:	ff 75 0c             	pushl  0xc(%ebp)
  8008e9:	6a 30                	push   $0x30
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	ff d0                	call   *%eax
  8008f0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008f3:	83 ec 08             	sub    $0x8,%esp
  8008f6:	ff 75 0c             	pushl  0xc(%ebp)
  8008f9:	6a 78                	push   $0x78
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	ff d0                	call   *%eax
  800900:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800903:	8b 45 14             	mov    0x14(%ebp),%eax
  800906:	83 c0 04             	add    $0x4,%eax
  800909:	89 45 14             	mov    %eax,0x14(%ebp)
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	83 e8 04             	sub    $0x4,%eax
  800912:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800914:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800917:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80091e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800925:	eb 1f                	jmp    800946 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800927:	83 ec 08             	sub    $0x8,%esp
  80092a:	ff 75 e8             	pushl  -0x18(%ebp)
  80092d:	8d 45 14             	lea    0x14(%ebp),%eax
  800930:	50                   	push   %eax
  800931:	e8 e7 fb ff ff       	call   80051d <getuint>
  800936:	83 c4 10             	add    $0x10,%esp
  800939:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80093c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80093f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800946:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80094a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80094d:	83 ec 04             	sub    $0x4,%esp
  800950:	52                   	push   %edx
  800951:	ff 75 e4             	pushl  -0x1c(%ebp)
  800954:	50                   	push   %eax
  800955:	ff 75 f4             	pushl  -0xc(%ebp)
  800958:	ff 75 f0             	pushl  -0x10(%ebp)
  80095b:	ff 75 0c             	pushl  0xc(%ebp)
  80095e:	ff 75 08             	pushl  0x8(%ebp)
  800961:	e8 00 fb ff ff       	call   800466 <printnum>
  800966:	83 c4 20             	add    $0x20,%esp
			break;
  800969:	eb 46                	jmp    8009b1 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80096b:	83 ec 08             	sub    $0x8,%esp
  80096e:	ff 75 0c             	pushl  0xc(%ebp)
  800971:	53                   	push   %ebx
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
  800975:	ff d0                	call   *%eax
  800977:	83 c4 10             	add    $0x10,%esp
			break;
  80097a:	eb 35                	jmp    8009b1 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80097c:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  800983:	eb 2c                	jmp    8009b1 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800985:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  80098c:	eb 23                	jmp    8009b1 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80098e:	83 ec 08             	sub    $0x8,%esp
  800991:	ff 75 0c             	pushl  0xc(%ebp)
  800994:	6a 25                	push   $0x25
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	ff d0                	call   *%eax
  80099b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80099e:	ff 4d 10             	decl   0x10(%ebp)
  8009a1:	eb 03                	jmp    8009a6 <vprintfmt+0x3c3>
  8009a3:	ff 4d 10             	decl   0x10(%ebp)
  8009a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a9:	48                   	dec    %eax
  8009aa:	8a 00                	mov    (%eax),%al
  8009ac:	3c 25                	cmp    $0x25,%al
  8009ae:	75 f3                	jne    8009a3 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8009b0:	90                   	nop
		}
	}
  8009b1:	e9 35 fc ff ff       	jmp    8005eb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009b6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009ba:	5b                   	pop    %ebx
  8009bb:	5e                   	pop    %esi
  8009bc:	5d                   	pop    %ebp
  8009bd:	c3                   	ret    

008009be <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009be:	55                   	push   %ebp
  8009bf:	89 e5                	mov    %esp,%ebp
  8009c1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8009c4:	8d 45 10             	lea    0x10(%ebp),%eax
  8009c7:	83 c0 04             	add    $0x4,%eax
  8009ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8009cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8009d3:	50                   	push   %eax
  8009d4:	ff 75 0c             	pushl  0xc(%ebp)
  8009d7:	ff 75 08             	pushl  0x8(%ebp)
  8009da:	e8 04 fc ff ff       	call   8005e3 <vprintfmt>
  8009df:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8009e2:	90                   	nop
  8009e3:	c9                   	leave  
  8009e4:	c3                   	ret    

008009e5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8009e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009eb:	8b 40 08             	mov    0x8(%eax),%eax
  8009ee:	8d 50 01             	lea    0x1(%eax),%edx
  8009f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fa:	8b 10                	mov    (%eax),%edx
  8009fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ff:	8b 40 04             	mov    0x4(%eax),%eax
  800a02:	39 c2                	cmp    %eax,%edx
  800a04:	73 12                	jae    800a18 <sprintputch+0x33>
		*b->buf++ = ch;
  800a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a09:	8b 00                	mov    (%eax),%eax
  800a0b:	8d 48 01             	lea    0x1(%eax),%ecx
  800a0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a11:	89 0a                	mov    %ecx,(%edx)
  800a13:	8b 55 08             	mov    0x8(%ebp),%edx
  800a16:	88 10                	mov    %dl,(%eax)
}
  800a18:	90                   	nop
  800a19:	5d                   	pop    %ebp
  800a1a:	c3                   	ret    

00800a1b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	01 d0                	add    %edx,%eax
  800a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a40:	74 06                	je     800a48 <vsnprintf+0x2d>
  800a42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a46:	7f 07                	jg     800a4f <vsnprintf+0x34>
		return -E_INVAL;
  800a48:	b8 03 00 00 00       	mov    $0x3,%eax
  800a4d:	eb 20                	jmp    800a6f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a4f:	ff 75 14             	pushl  0x14(%ebp)
  800a52:	ff 75 10             	pushl  0x10(%ebp)
  800a55:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a58:	50                   	push   %eax
  800a59:	68 e5 09 80 00       	push   $0x8009e5
  800a5e:	e8 80 fb ff ff       	call   8005e3 <vprintfmt>
  800a63:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a69:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a6f:	c9                   	leave  
  800a70:	c3                   	ret    

00800a71 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a71:	55                   	push   %ebp
  800a72:	89 e5                	mov    %esp,%ebp
  800a74:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a77:	8d 45 10             	lea    0x10(%ebp),%eax
  800a7a:	83 c0 04             	add    $0x4,%eax
  800a7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a80:	8b 45 10             	mov    0x10(%ebp),%eax
  800a83:	ff 75 f4             	pushl  -0xc(%ebp)
  800a86:	50                   	push   %eax
  800a87:	ff 75 0c             	pushl  0xc(%ebp)
  800a8a:	ff 75 08             	pushl  0x8(%ebp)
  800a8d:	e8 89 ff ff ff       	call   800a1b <vsnprintf>
  800a92:	83 c4 10             	add    $0x10,%esp
  800a95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a9b:	c9                   	leave  
  800a9c:	c3                   	ret    

00800a9d <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800aa3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800aaa:	eb 06                	jmp    800ab2 <strlen+0x15>
		n++;
  800aac:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800aaf:	ff 45 08             	incl   0x8(%ebp)
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	8a 00                	mov    (%eax),%al
  800ab7:	84 c0                	test   %al,%al
  800ab9:	75 f1                	jne    800aac <strlen+0xf>
		n++;
	return n;
  800abb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800abe:	c9                   	leave  
  800abf:	c3                   	ret    

00800ac0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ac6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800acd:	eb 09                	jmp    800ad8 <strnlen+0x18>
		n++;
  800acf:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ad2:	ff 45 08             	incl   0x8(%ebp)
  800ad5:	ff 4d 0c             	decl   0xc(%ebp)
  800ad8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800adc:	74 09                	je     800ae7 <strnlen+0x27>
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	8a 00                	mov    (%eax),%al
  800ae3:	84 c0                	test   %al,%al
  800ae5:	75 e8                	jne    800acf <strnlen+0xf>
		n++;
	return n;
  800ae7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800aea:	c9                   	leave  
  800aeb:	c3                   	ret    

00800aec <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800af8:	90                   	nop
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	8d 50 01             	lea    0x1(%eax),%edx
  800aff:	89 55 08             	mov    %edx,0x8(%ebp)
  800b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b05:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b08:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b0b:	8a 12                	mov    (%edx),%dl
  800b0d:	88 10                	mov    %dl,(%eax)
  800b0f:	8a 00                	mov    (%eax),%al
  800b11:	84 c0                	test   %al,%al
  800b13:	75 e4                	jne    800af9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b15:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b18:	c9                   	leave  
  800b19:	c3                   	ret    

00800b1a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b2d:	eb 1f                	jmp    800b4e <strncpy+0x34>
		*dst++ = *src;
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8d 50 01             	lea    0x1(%eax),%edx
  800b35:	89 55 08             	mov    %edx,0x8(%ebp)
  800b38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3b:	8a 12                	mov    (%edx),%dl
  800b3d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b42:	8a 00                	mov    (%eax),%al
  800b44:	84 c0                	test   %al,%al
  800b46:	74 03                	je     800b4b <strncpy+0x31>
			src++;
  800b48:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b4b:	ff 45 fc             	incl   -0x4(%ebp)
  800b4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b51:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b54:	72 d9                	jb     800b2f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b56:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b59:	c9                   	leave  
  800b5a:	c3                   	ret    

00800b5b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b67:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b6b:	74 30                	je     800b9d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b6d:	eb 16                	jmp    800b85 <strlcpy+0x2a>
			*dst++ = *src++;
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	8d 50 01             	lea    0x1(%eax),%edx
  800b75:	89 55 08             	mov    %edx,0x8(%ebp)
  800b78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b7e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b81:	8a 12                	mov    (%edx),%dl
  800b83:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b85:	ff 4d 10             	decl   0x10(%ebp)
  800b88:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b8c:	74 09                	je     800b97 <strlcpy+0x3c>
  800b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b91:	8a 00                	mov    (%eax),%al
  800b93:	84 c0                	test   %al,%al
  800b95:	75 d8                	jne    800b6f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ba3:	29 c2                	sub    %eax,%edx
  800ba5:	89 d0                	mov    %edx,%eax
}
  800ba7:	c9                   	leave  
  800ba8:	c3                   	ret    

00800ba9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ba9:	55                   	push   %ebp
  800baa:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bac:	eb 06                	jmp    800bb4 <strcmp+0xb>
		p++, q++;
  800bae:	ff 45 08             	incl   0x8(%ebp)
  800bb1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	8a 00                	mov    (%eax),%al
  800bb9:	84 c0                	test   %al,%al
  800bbb:	74 0e                	je     800bcb <strcmp+0x22>
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	8a 10                	mov    (%eax),%dl
  800bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc5:	8a 00                	mov    (%eax),%al
  800bc7:	38 c2                	cmp    %al,%dl
  800bc9:	74 e3                	je     800bae <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	8a 00                	mov    (%eax),%al
  800bd0:	0f b6 d0             	movzbl %al,%edx
  800bd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd6:	8a 00                	mov    (%eax),%al
  800bd8:	0f b6 c0             	movzbl %al,%eax
  800bdb:	29 c2                	sub    %eax,%edx
  800bdd:	89 d0                	mov    %edx,%eax
}
  800bdf:	5d                   	pop    %ebp
  800be0:	c3                   	ret    

00800be1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800be4:	eb 09                	jmp    800bef <strncmp+0xe>
		n--, p++, q++;
  800be6:	ff 4d 10             	decl   0x10(%ebp)
  800be9:	ff 45 08             	incl   0x8(%ebp)
  800bec:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800bef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bf3:	74 17                	je     800c0c <strncmp+0x2b>
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	8a 00                	mov    (%eax),%al
  800bfa:	84 c0                	test   %al,%al
  800bfc:	74 0e                	je     800c0c <strncmp+0x2b>
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	8a 10                	mov    (%eax),%dl
  800c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c06:	8a 00                	mov    (%eax),%al
  800c08:	38 c2                	cmp    %al,%dl
  800c0a:	74 da                	je     800be6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c0c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c10:	75 07                	jne    800c19 <strncmp+0x38>
		return 0;
  800c12:	b8 00 00 00 00       	mov    $0x0,%eax
  800c17:	eb 14                	jmp    800c2d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	8a 00                	mov    (%eax),%al
  800c1e:	0f b6 d0             	movzbl %al,%edx
  800c21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c24:	8a 00                	mov    (%eax),%al
  800c26:	0f b6 c0             	movzbl %al,%eax
  800c29:	29 c2                	sub    %eax,%edx
  800c2b:	89 d0                	mov    %edx,%eax
}
  800c2d:	5d                   	pop    %ebp
  800c2e:	c3                   	ret    

00800c2f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	83 ec 04             	sub    $0x4,%esp
  800c35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c38:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c3b:	eb 12                	jmp    800c4f <strchr+0x20>
		if (*s == c)
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	8a 00                	mov    (%eax),%al
  800c42:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c45:	75 05                	jne    800c4c <strchr+0x1d>
			return (char *) s;
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	eb 11                	jmp    800c5d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c4c:	ff 45 08             	incl   0x8(%ebp)
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	8a 00                	mov    (%eax),%al
  800c54:	84 c0                	test   %al,%al
  800c56:	75 e5                	jne    800c3d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c5d:	c9                   	leave  
  800c5e:	c3                   	ret    

00800c5f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
  800c62:	83 ec 04             	sub    $0x4,%esp
  800c65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c68:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c6b:	eb 0d                	jmp    800c7a <strfind+0x1b>
		if (*s == c)
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	8a 00                	mov    (%eax),%al
  800c72:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c75:	74 0e                	je     800c85 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c77:	ff 45 08             	incl   0x8(%ebp)
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	8a 00                	mov    (%eax),%al
  800c7f:	84 c0                	test   %al,%al
  800c81:	75 ea                	jne    800c6d <strfind+0xe>
  800c83:	eb 01                	jmp    800c86 <strfind+0x27>
		if (*s == c)
			break;
  800c85:	90                   	nop
	return (char *) s;
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c89:	c9                   	leave  
  800c8a:	c3                   	ret    

00800c8b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800c97:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800c9d:	eb 0e                	jmp    800cad <memset+0x22>
		*p++ = c;
  800c9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca2:	8d 50 01             	lea    0x1(%eax),%edx
  800ca5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ca8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cab:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800cad:	ff 4d f8             	decl   -0x8(%ebp)
  800cb0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800cb4:	79 e9                	jns    800c9f <memset+0x14>
		*p++ = c;

	return v;
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cb9:	c9                   	leave  
  800cba:	c3                   	ret    

00800cbb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ccd:	eb 16                	jmp    800ce5 <memcpy+0x2a>
		*d++ = *s++;
  800ccf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cd2:	8d 50 01             	lea    0x1(%eax),%edx
  800cd5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cd8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cdb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cde:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ce1:	8a 12                	mov    (%edx),%dl
  800ce3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ce5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ceb:	89 55 10             	mov    %edx,0x10(%ebp)
  800cee:	85 c0                	test   %eax,%eax
  800cf0:	75 dd                	jne    800ccf <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf5:	c9                   	leave  
  800cf6:	c3                   	ret    

00800cf7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d0f:	73 50                	jae    800d61 <memmove+0x6a>
  800d11:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d14:	8b 45 10             	mov    0x10(%ebp),%eax
  800d17:	01 d0                	add    %edx,%eax
  800d19:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d1c:	76 43                	jbe    800d61 <memmove+0x6a>
		s += n;
  800d1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d21:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d24:	8b 45 10             	mov    0x10(%ebp),%eax
  800d27:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d2a:	eb 10                	jmp    800d3c <memmove+0x45>
			*--d = *--s;
  800d2c:	ff 4d f8             	decl   -0x8(%ebp)
  800d2f:	ff 4d fc             	decl   -0x4(%ebp)
  800d32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d35:	8a 10                	mov    (%eax),%dl
  800d37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d3a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d42:	89 55 10             	mov    %edx,0x10(%ebp)
  800d45:	85 c0                	test   %eax,%eax
  800d47:	75 e3                	jne    800d2c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d49:	eb 23                	jmp    800d6e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d4e:	8d 50 01             	lea    0x1(%eax),%edx
  800d51:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d54:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d57:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d5a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d5d:	8a 12                	mov    (%edx),%dl
  800d5f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d61:	8b 45 10             	mov    0x10(%ebp),%eax
  800d64:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d67:	89 55 10             	mov    %edx,0x10(%ebp)
  800d6a:	85 c0                	test   %eax,%eax
  800d6c:	75 dd                	jne    800d4b <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d71:	c9                   	leave  
  800d72:	c3                   	ret    

00800d73 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d82:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d85:	eb 2a                	jmp    800db1 <memcmp+0x3e>
		if (*s1 != *s2)
  800d87:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d8a:	8a 10                	mov    (%eax),%dl
  800d8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	38 c2                	cmp    %al,%dl
  800d93:	74 16                	je     800dab <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	0f b6 d0             	movzbl %al,%edx
  800d9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da0:	8a 00                	mov    (%eax),%al
  800da2:	0f b6 c0             	movzbl %al,%eax
  800da5:	29 c2                	sub    %eax,%edx
  800da7:	89 d0                	mov    %edx,%eax
  800da9:	eb 18                	jmp    800dc3 <memcmp+0x50>
		s1++, s2++;
  800dab:	ff 45 fc             	incl   -0x4(%ebp)
  800dae:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800db1:	8b 45 10             	mov    0x10(%ebp),%eax
  800db4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db7:	89 55 10             	mov    %edx,0x10(%ebp)
  800dba:	85 c0                	test   %eax,%eax
  800dbc:	75 c9                	jne    800d87 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800dbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800dcb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dce:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd1:	01 d0                	add    %edx,%eax
  800dd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800dd6:	eb 15                	jmp    800ded <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddb:	8a 00                	mov    (%eax),%al
  800ddd:	0f b6 d0             	movzbl %al,%edx
  800de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de3:	0f b6 c0             	movzbl %al,%eax
  800de6:	39 c2                	cmp    %eax,%edx
  800de8:	74 0d                	je     800df7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800dea:	ff 45 08             	incl   0x8(%ebp)
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800df3:	72 e3                	jb     800dd8 <memfind+0x13>
  800df5:	eb 01                	jmp    800df8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800df7:	90                   	nop
	return (void *) s;
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dfb:	c9                   	leave  
  800dfc:	c3                   	ret    

00800dfd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e0a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e11:	eb 03                	jmp    800e16 <strtol+0x19>
		s++;
  800e13:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	8a 00                	mov    (%eax),%al
  800e1b:	3c 20                	cmp    $0x20,%al
  800e1d:	74 f4                	je     800e13 <strtol+0x16>
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	3c 09                	cmp    $0x9,%al
  800e26:	74 eb                	je     800e13 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	3c 2b                	cmp    $0x2b,%al
  800e2f:	75 05                	jne    800e36 <strtol+0x39>
		s++;
  800e31:	ff 45 08             	incl   0x8(%ebp)
  800e34:	eb 13                	jmp    800e49 <strtol+0x4c>
	else if (*s == '-')
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
  800e39:	8a 00                	mov    (%eax),%al
  800e3b:	3c 2d                	cmp    $0x2d,%al
  800e3d:	75 0a                	jne    800e49 <strtol+0x4c>
		s++, neg = 1;
  800e3f:	ff 45 08             	incl   0x8(%ebp)
  800e42:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e4d:	74 06                	je     800e55 <strtol+0x58>
  800e4f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e53:	75 20                	jne    800e75 <strtol+0x78>
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	3c 30                	cmp    $0x30,%al
  800e5c:	75 17                	jne    800e75 <strtol+0x78>
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	40                   	inc    %eax
  800e62:	8a 00                	mov    (%eax),%al
  800e64:	3c 78                	cmp    $0x78,%al
  800e66:	75 0d                	jne    800e75 <strtol+0x78>
		s += 2, base = 16;
  800e68:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e6c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e73:	eb 28                	jmp    800e9d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e75:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e79:	75 15                	jne    800e90 <strtol+0x93>
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	8a 00                	mov    (%eax),%al
  800e80:	3c 30                	cmp    $0x30,%al
  800e82:	75 0c                	jne    800e90 <strtol+0x93>
		s++, base = 8;
  800e84:	ff 45 08             	incl   0x8(%ebp)
  800e87:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e8e:	eb 0d                	jmp    800e9d <strtol+0xa0>
	else if (base == 0)
  800e90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e94:	75 07                	jne    800e9d <strtol+0xa0>
		base = 10;
  800e96:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	8a 00                	mov    (%eax),%al
  800ea2:	3c 2f                	cmp    $0x2f,%al
  800ea4:	7e 19                	jle    800ebf <strtol+0xc2>
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	3c 39                	cmp    $0x39,%al
  800ead:	7f 10                	jg     800ebf <strtol+0xc2>
			dig = *s - '0';
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	8a 00                	mov    (%eax),%al
  800eb4:	0f be c0             	movsbl %al,%eax
  800eb7:	83 e8 30             	sub    $0x30,%eax
  800eba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ebd:	eb 42                	jmp    800f01 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	8a 00                	mov    (%eax),%al
  800ec4:	3c 60                	cmp    $0x60,%al
  800ec6:	7e 19                	jle    800ee1 <strtol+0xe4>
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	8a 00                	mov    (%eax),%al
  800ecd:	3c 7a                	cmp    $0x7a,%al
  800ecf:	7f 10                	jg     800ee1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	8a 00                	mov    (%eax),%al
  800ed6:	0f be c0             	movsbl %al,%eax
  800ed9:	83 e8 57             	sub    $0x57,%eax
  800edc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800edf:	eb 20                	jmp    800f01 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	8a 00                	mov    (%eax),%al
  800ee6:	3c 40                	cmp    $0x40,%al
  800ee8:	7e 39                	jle    800f23 <strtol+0x126>
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	8a 00                	mov    (%eax),%al
  800eef:	3c 5a                	cmp    $0x5a,%al
  800ef1:	7f 30                	jg     800f23 <strtol+0x126>
			dig = *s - 'A' + 10;
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	0f be c0             	movsbl %al,%eax
  800efb:	83 e8 37             	sub    $0x37,%eax
  800efe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f04:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f07:	7d 19                	jge    800f22 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f09:	ff 45 08             	incl   0x8(%ebp)
  800f0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f13:	89 c2                	mov    %eax,%edx
  800f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f18:	01 d0                	add    %edx,%eax
  800f1a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f1d:	e9 7b ff ff ff       	jmp    800e9d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f22:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f27:	74 08                	je     800f31 <strtol+0x134>
		*endptr = (char *) s;
  800f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f31:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f35:	74 07                	je     800f3e <strtol+0x141>
  800f37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3a:	f7 d8                	neg    %eax
  800f3c:	eb 03                	jmp    800f41 <strtol+0x144>
  800f3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f41:	c9                   	leave  
  800f42:	c3                   	ret    

00800f43 <ltostr>:

void
ltostr(long value, char *str)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f49:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f50:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f5b:	79 13                	jns    800f70 <ltostr+0x2d>
	{
		neg = 1;
  800f5d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f6a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f6d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f78:	99                   	cltd   
  800f79:	f7 f9                	idiv   %ecx
  800f7b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f81:	8d 50 01             	lea    0x1(%eax),%edx
  800f84:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f87:	89 c2                	mov    %eax,%edx
  800f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8c:	01 d0                	add    %edx,%eax
  800f8e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f91:	83 c2 30             	add    $0x30,%edx
  800f94:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f99:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f9e:	f7 e9                	imul   %ecx
  800fa0:	c1 fa 02             	sar    $0x2,%edx
  800fa3:	89 c8                	mov    %ecx,%eax
  800fa5:	c1 f8 1f             	sar    $0x1f,%eax
  800fa8:	29 c2                	sub    %eax,%edx
  800faa:	89 d0                	mov    %edx,%eax
  800fac:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800faf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fb3:	75 bb                	jne    800f70 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800fb5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800fbc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fbf:	48                   	dec    %eax
  800fc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800fc3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fc7:	74 3d                	je     801006 <ltostr+0xc3>
		start = 1 ;
  800fc9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800fd0:	eb 34                	jmp    801006 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800fd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd8:	01 d0                	add    %edx,%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800fdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe5:	01 c2                	add    %eax,%edx
  800fe7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800fea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fed:	01 c8                	add    %ecx,%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800ff3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff9:	01 c2                	add    %eax,%edx
  800ffb:	8a 45 eb             	mov    -0x15(%ebp),%al
  800ffe:	88 02                	mov    %al,(%edx)
		start++ ;
  801000:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801003:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801009:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80100c:	7c c4                	jl     800fd2 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80100e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801011:	8b 45 0c             	mov    0xc(%ebp),%eax
  801014:	01 d0                	add    %edx,%eax
  801016:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801019:	90                   	nop
  80101a:	c9                   	leave  
  80101b:	c3                   	ret    

0080101c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801022:	ff 75 08             	pushl  0x8(%ebp)
  801025:	e8 73 fa ff ff       	call   800a9d <strlen>
  80102a:	83 c4 04             	add    $0x4,%esp
  80102d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801030:	ff 75 0c             	pushl  0xc(%ebp)
  801033:	e8 65 fa ff ff       	call   800a9d <strlen>
  801038:	83 c4 04             	add    $0x4,%esp
  80103b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80103e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801045:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80104c:	eb 17                	jmp    801065 <strcconcat+0x49>
		final[s] = str1[s] ;
  80104e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801051:	8b 45 10             	mov    0x10(%ebp),%eax
  801054:	01 c2                	add    %eax,%edx
  801056:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	01 c8                	add    %ecx,%eax
  80105e:	8a 00                	mov    (%eax),%al
  801060:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801062:	ff 45 fc             	incl   -0x4(%ebp)
  801065:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801068:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80106b:	7c e1                	jl     80104e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80106d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801074:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80107b:	eb 1f                	jmp    80109c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80107d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801080:	8d 50 01             	lea    0x1(%eax),%edx
  801083:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801086:	89 c2                	mov    %eax,%edx
  801088:	8b 45 10             	mov    0x10(%ebp),%eax
  80108b:	01 c2                	add    %eax,%edx
  80108d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801090:	8b 45 0c             	mov    0xc(%ebp),%eax
  801093:	01 c8                	add    %ecx,%eax
  801095:	8a 00                	mov    (%eax),%al
  801097:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801099:	ff 45 f8             	incl   -0x8(%ebp)
  80109c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010a2:	7c d9                	jl     80107d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010aa:	01 d0                	add    %edx,%eax
  8010ac:	c6 00 00             	movb   $0x0,(%eax)
}
  8010af:	90                   	nop
  8010b0:	c9                   	leave  
  8010b1:	c3                   	ret    

008010b2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8010b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8010be:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c1:	8b 00                	mov    (%eax),%eax
  8010c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cd:	01 d0                	add    %edx,%eax
  8010cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010d5:	eb 0c                	jmp    8010e3 <strsplit+0x31>
			*string++ = 0;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8d 50 01             	lea    0x1(%eax),%edx
  8010dd:	89 55 08             	mov    %edx,0x8(%ebp)
  8010e0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	84 c0                	test   %al,%al
  8010ea:	74 18                	je     801104 <strsplit+0x52>
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	0f be c0             	movsbl %al,%eax
  8010f4:	50                   	push   %eax
  8010f5:	ff 75 0c             	pushl  0xc(%ebp)
  8010f8:	e8 32 fb ff ff       	call   800c2f <strchr>
  8010fd:	83 c4 08             	add    $0x8,%esp
  801100:	85 c0                	test   %eax,%eax
  801102:	75 d3                	jne    8010d7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	84 c0                	test   %al,%al
  80110b:	74 5a                	je     801167 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80110d:	8b 45 14             	mov    0x14(%ebp),%eax
  801110:	8b 00                	mov    (%eax),%eax
  801112:	83 f8 0f             	cmp    $0xf,%eax
  801115:	75 07                	jne    80111e <strsplit+0x6c>
		{
			return 0;
  801117:	b8 00 00 00 00       	mov    $0x0,%eax
  80111c:	eb 66                	jmp    801184 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80111e:	8b 45 14             	mov    0x14(%ebp),%eax
  801121:	8b 00                	mov    (%eax),%eax
  801123:	8d 48 01             	lea    0x1(%eax),%ecx
  801126:	8b 55 14             	mov    0x14(%ebp),%edx
  801129:	89 0a                	mov    %ecx,(%edx)
  80112b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801132:	8b 45 10             	mov    0x10(%ebp),%eax
  801135:	01 c2                	add    %eax,%edx
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80113c:	eb 03                	jmp    801141 <strsplit+0x8f>
			string++;
  80113e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	84 c0                	test   %al,%al
  801148:	74 8b                	je     8010d5 <strsplit+0x23>
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	0f be c0             	movsbl %al,%eax
  801152:	50                   	push   %eax
  801153:	ff 75 0c             	pushl  0xc(%ebp)
  801156:	e8 d4 fa ff ff       	call   800c2f <strchr>
  80115b:	83 c4 08             	add    $0x8,%esp
  80115e:	85 c0                	test   %eax,%eax
  801160:	74 dc                	je     80113e <strsplit+0x8c>
			string++;
	}
  801162:	e9 6e ff ff ff       	jmp    8010d5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801167:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801168:	8b 45 14             	mov    0x14(%ebp),%eax
  80116b:	8b 00                	mov    (%eax),%eax
  80116d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801174:	8b 45 10             	mov    0x10(%ebp),%eax
  801177:	01 d0                	add    %edx,%eax
  801179:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80117f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801184:	c9                   	leave  
  801185:	c3                   	ret    

00801186 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80118c:	83 ec 04             	sub    $0x4,%esp
  80118f:	68 88 3c 80 00       	push   $0x803c88
  801194:	68 3f 01 00 00       	push   $0x13f
  801199:	68 aa 3c 80 00       	push   $0x803caa
  80119e:	e8 9a 21 00 00       	call   80333d <_panic>

008011a3 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
  8011a6:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8011a9:	83 ec 0c             	sub    $0xc,%esp
  8011ac:	ff 75 08             	pushl  0x8(%ebp)
  8011af:	e8 90 0c 00 00       	call   801e44 <sys_sbrk>
  8011b4:	83 c4 10             	add    $0x10,%esp
}
  8011b7:	c9                   	leave  
  8011b8:	c3                   	ret    

008011b9 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  8011b9:	55                   	push   %ebp
  8011ba:	89 e5                	mov    %esp,%ebp
  8011bc:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8011bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c3:	75 0a                	jne    8011cf <malloc+0x16>
		return NULL;
  8011c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ca:	e9 9e 01 00 00       	jmp    80136d <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  8011cf:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8011d6:	77 2c                	ja     801204 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  8011d8:	e8 eb 0a 00 00       	call   801cc8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8011dd:	85 c0                	test   %eax,%eax
  8011df:	74 19                	je     8011fa <malloc+0x41>

			void * block = alloc_block_FF(size);
  8011e1:	83 ec 0c             	sub    $0xc,%esp
  8011e4:	ff 75 08             	pushl  0x8(%ebp)
  8011e7:	e8 85 11 00 00       	call   802371 <alloc_block_FF>
  8011ec:	83 c4 10             	add    $0x10,%esp
  8011ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  8011f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011f5:	e9 73 01 00 00       	jmp    80136d <malloc+0x1b4>
		} else {
			return NULL;
  8011fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ff:	e9 69 01 00 00       	jmp    80136d <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801204:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80120b:	8b 55 08             	mov    0x8(%ebp),%edx
  80120e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801211:	01 d0                	add    %edx,%eax
  801213:	48                   	dec    %eax
  801214:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801217:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80121a:	ba 00 00 00 00       	mov    $0x0,%edx
  80121f:	f7 75 e0             	divl   -0x20(%ebp)
  801222:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801225:	29 d0                	sub    %edx,%eax
  801227:	c1 e8 0c             	shr    $0xc,%eax
  80122a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  80122d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801234:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  80123b:	a1 20 50 80 00       	mov    0x805020,%eax
  801240:	8b 40 7c             	mov    0x7c(%eax),%eax
  801243:	05 00 10 00 00       	add    $0x1000,%eax
  801248:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  80124b:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801250:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801253:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801256:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80125d:	8b 55 08             	mov    0x8(%ebp),%edx
  801260:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801263:	01 d0                	add    %edx,%eax
  801265:	48                   	dec    %eax
  801266:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801269:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80126c:	ba 00 00 00 00       	mov    $0x0,%edx
  801271:	f7 75 cc             	divl   -0x34(%ebp)
  801274:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801277:	29 d0                	sub    %edx,%eax
  801279:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80127c:	76 0a                	jbe    801288 <malloc+0xcf>
		return NULL;
  80127e:	b8 00 00 00 00       	mov    $0x0,%eax
  801283:	e9 e5 00 00 00       	jmp    80136d <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801288:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80128b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80128e:	eb 48                	jmp    8012d8 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  801290:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801293:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801296:	c1 e8 0c             	shr    $0xc,%eax
  801299:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  80129c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80129f:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8012a6:	85 c0                	test   %eax,%eax
  8012a8:	75 11                	jne    8012bb <malloc+0x102>
			freePagesCount++;
  8012aa:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8012ad:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8012b1:	75 16                	jne    8012c9 <malloc+0x110>
				start = i;
  8012b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012b9:	eb 0e                	jmp    8012c9 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  8012bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8012c2:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  8012c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012cc:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8012cf:	74 12                	je     8012e3 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  8012d1:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8012d8:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8012df:	76 af                	jbe    801290 <malloc+0xd7>
  8012e1:	eb 01                	jmp    8012e4 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  8012e3:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  8012e4:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8012e8:	74 08                	je     8012f2 <malloc+0x139>
  8012ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ed:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8012f0:	74 07                	je     8012f9 <malloc+0x140>
		return NULL;
  8012f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f7:	eb 74                	jmp    80136d <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8012f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012fc:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8012ff:	c1 e8 0c             	shr    $0xc,%eax
  801302:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801305:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801308:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80130b:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801312:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801315:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801318:	eb 11                	jmp    80132b <malloc+0x172>
		markedPages[i] = 1;
  80131a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80131d:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801324:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801328:	ff 45 e8             	incl   -0x18(%ebp)
  80132b:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80132e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801331:	01 d0                	add    %edx,%eax
  801333:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801336:	77 e2                	ja     80131a <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801338:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80133f:	8b 55 08             	mov    0x8(%ebp),%edx
  801342:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801345:	01 d0                	add    %edx,%eax
  801347:	48                   	dec    %eax
  801348:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80134b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80134e:	ba 00 00 00 00       	mov    $0x0,%edx
  801353:	f7 75 bc             	divl   -0x44(%ebp)
  801356:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801359:	29 d0                	sub    %edx,%eax
  80135b:	83 ec 08             	sub    $0x8,%esp
  80135e:	50                   	push   %eax
  80135f:	ff 75 f0             	pushl  -0x10(%ebp)
  801362:	e8 14 0b 00 00       	call   801e7b <sys_allocate_user_mem>
  801367:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  80136a:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  80136d:	c9                   	leave  
  80136e:	c3                   	ret    

0080136f <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
  801372:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801375:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801379:	0f 84 ee 00 00 00    	je     80146d <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  80137f:	a1 20 50 80 00       	mov    0x805020,%eax
  801384:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801387:	3b 45 08             	cmp    0x8(%ebp),%eax
  80138a:	77 09                	ja     801395 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  80138c:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801393:	76 14                	jbe    8013a9 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801395:	83 ec 04             	sub    $0x4,%esp
  801398:	68 b8 3c 80 00       	push   $0x803cb8
  80139d:	6a 68                	push   $0x68
  80139f:	68 d2 3c 80 00       	push   $0x803cd2
  8013a4:	e8 94 1f 00 00       	call   80333d <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  8013a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8013ae:	8b 40 74             	mov    0x74(%eax),%eax
  8013b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8013b4:	77 20                	ja     8013d6 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  8013b6:	a1 20 50 80 00       	mov    0x805020,%eax
  8013bb:	8b 40 78             	mov    0x78(%eax),%eax
  8013be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8013c1:	76 13                	jbe    8013d6 <free+0x67>
		free_block(virtual_address);
  8013c3:	83 ec 0c             	sub    $0xc,%esp
  8013c6:	ff 75 08             	pushl  0x8(%ebp)
  8013c9:	e8 6c 16 00 00       	call   802a3a <free_block>
  8013ce:	83 c4 10             	add    $0x10,%esp
		return;
  8013d1:	e9 98 00 00 00       	jmp    80146e <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8013d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d9:	a1 20 50 80 00       	mov    0x805020,%eax
  8013de:	8b 40 7c             	mov    0x7c(%eax),%eax
  8013e1:	29 c2                	sub    %eax,%edx
  8013e3:	89 d0                	mov    %edx,%eax
  8013e5:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  8013ea:	c1 e8 0c             	shr    $0xc,%eax
  8013ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  8013f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8013f7:	eb 16                	jmp    80140f <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  8013f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013ff:	01 d0                	add    %edx,%eax
  801401:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  801408:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  80140c:	ff 45 f4             	incl   -0xc(%ebp)
  80140f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801412:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801419:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80141c:	7f db                	jg     8013f9 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  80141e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801421:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801428:	c1 e0 0c             	shl    $0xc,%eax
  80142b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801434:	eb 1a                	jmp    801450 <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801436:	83 ec 08             	sub    $0x8,%esp
  801439:	68 00 10 00 00       	push   $0x1000
  80143e:	ff 75 f0             	pushl  -0x10(%ebp)
  801441:	e8 19 0a 00 00       	call   801e5f <sys_free_user_mem>
  801446:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801449:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801450:	8b 55 08             	mov    0x8(%ebp),%edx
  801453:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801456:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801458:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80145b:	77 d9                	ja     801436 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  80145d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801460:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  801467:	00 00 00 00 
  80146b:	eb 01                	jmp    80146e <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  80146d:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  80146e:	c9                   	leave  
  80146f:	c3                   	ret    

00801470 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	83 ec 58             	sub    $0x58,%esp
  801476:	8b 45 10             	mov    0x10(%ebp),%eax
  801479:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  80147c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801480:	75 0a                	jne    80148c <smalloc+0x1c>
		return NULL;
  801482:	b8 00 00 00 00       	mov    $0x0,%eax
  801487:	e9 7d 01 00 00       	jmp    801609 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  80148c:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801493:	8b 55 0c             	mov    0xc(%ebp),%edx
  801496:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801499:	01 d0                	add    %edx,%eax
  80149b:	48                   	dec    %eax
  80149c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80149f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8014a7:	f7 75 e4             	divl   -0x1c(%ebp)
  8014aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ad:	29 d0                	sub    %edx,%eax
  8014af:	c1 e8 0c             	shr    $0xc,%eax
  8014b2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  8014b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8014bc:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8014c3:	a1 20 50 80 00       	mov    0x805020,%eax
  8014c8:	8b 40 7c             	mov    0x7c(%eax),%eax
  8014cb:	05 00 10 00 00       	add    $0x1000,%eax
  8014d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  8014d3:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8014d8:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8014db:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  8014de:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8014e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8014eb:	01 d0                	add    %edx,%eax
  8014ed:	48                   	dec    %eax
  8014ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8014f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8014f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f9:	f7 75 d0             	divl   -0x30(%ebp)
  8014fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8014ff:	29 d0                	sub    %edx,%eax
  801501:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801504:	76 0a                	jbe    801510 <smalloc+0xa0>
		return NULL;
  801506:	b8 00 00 00 00       	mov    $0x0,%eax
  80150b:	e9 f9 00 00 00       	jmp    801609 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801510:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801513:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801516:	eb 48                	jmp    801560 <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801518:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80151b:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80151e:	c1 e8 0c             	shr    $0xc,%eax
  801521:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801524:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801527:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  80152e:	85 c0                	test   %eax,%eax
  801530:	75 11                	jne    801543 <smalloc+0xd3>
			freePagesCount++;
  801532:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801535:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801539:	75 16                	jne    801551 <smalloc+0xe1>
				start = s;
  80153b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80153e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801541:	eb 0e                	jmp    801551 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  801543:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80154a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  801551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801554:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801557:	74 12                	je     80156b <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801559:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801560:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801567:	76 af                	jbe    801518 <smalloc+0xa8>
  801569:	eb 01                	jmp    80156c <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  80156b:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  80156c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801570:	74 08                	je     80157a <smalloc+0x10a>
  801572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801575:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801578:	74 0a                	je     801584 <smalloc+0x114>
		return NULL;
  80157a:	b8 00 00 00 00       	mov    $0x0,%eax
  80157f:	e9 85 00 00 00       	jmp    801609 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801587:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80158a:	c1 e8 0c             	shr    $0xc,%eax
  80158d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  801590:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801593:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801596:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  80159d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8015a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8015a3:	eb 11                	jmp    8015b6 <smalloc+0x146>
		markedPages[s] = 1;
  8015a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015a8:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  8015af:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8015b3:	ff 45 e8             	incl   -0x18(%ebp)
  8015b6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8015b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015bc:	01 d0                	add    %edx,%eax
  8015be:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8015c1:	77 e2                	ja     8015a5 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  8015c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015c6:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  8015ca:	52                   	push   %edx
  8015cb:	50                   	push   %eax
  8015cc:	ff 75 0c             	pushl  0xc(%ebp)
  8015cf:	ff 75 08             	pushl  0x8(%ebp)
  8015d2:	e8 8f 04 00 00       	call   801a66 <sys_createSharedObject>
  8015d7:	83 c4 10             	add    $0x10,%esp
  8015da:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  8015dd:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  8015e1:	78 12                	js     8015f5 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  8015e3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8015e6:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8015e9:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  8015f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f3:	eb 14                	jmp    801609 <smalloc+0x199>
	}
	free((void*) start);
  8015f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f8:	83 ec 0c             	sub    $0xc,%esp
  8015fb:	50                   	push   %eax
  8015fc:	e8 6e fd ff ff       	call   80136f <free>
  801601:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801604:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801609:	c9                   	leave  
  80160a:	c3                   	ret    

0080160b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
  80160e:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  801611:	83 ec 08             	sub    $0x8,%esp
  801614:	ff 75 0c             	pushl  0xc(%ebp)
  801617:	ff 75 08             	pushl  0x8(%ebp)
  80161a:	e8 71 04 00 00       	call   801a90 <sys_getSizeOfSharedObject>
  80161f:	83 c4 10             	add    $0x10,%esp
  801622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801625:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80162c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80162f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801632:	01 d0                	add    %edx,%eax
  801634:	48                   	dec    %eax
  801635:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801638:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80163b:	ba 00 00 00 00       	mov    $0x0,%edx
  801640:	f7 75 e0             	divl   -0x20(%ebp)
  801643:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801646:	29 d0                	sub    %edx,%eax
  801648:	c1 e8 0c             	shr    $0xc,%eax
  80164b:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  80164e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801655:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  80165c:	a1 20 50 80 00       	mov    0x805020,%eax
  801661:	8b 40 7c             	mov    0x7c(%eax),%eax
  801664:	05 00 10 00 00       	add    $0x1000,%eax
  801669:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  80166c:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801671:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801674:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801677:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80167e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801681:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801684:	01 d0                	add    %edx,%eax
  801686:	48                   	dec    %eax
  801687:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80168a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80168d:	ba 00 00 00 00       	mov    $0x0,%edx
  801692:	f7 75 cc             	divl   -0x34(%ebp)
  801695:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801698:	29 d0                	sub    %edx,%eax
  80169a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80169d:	76 0a                	jbe    8016a9 <sget+0x9e>
		return NULL;
  80169f:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a4:	e9 f7 00 00 00       	jmp    8017a0 <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8016a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016af:	eb 48                	jmp    8016f9 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  8016b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b4:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8016b7:	c1 e8 0c             	shr    $0xc,%eax
  8016ba:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  8016bd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8016c0:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8016c7:	85 c0                	test   %eax,%eax
  8016c9:	75 11                	jne    8016dc <sget+0xd1>
			free_Pages_Count++;
  8016cb:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8016ce:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8016d2:	75 16                	jne    8016ea <sget+0xdf>
				start = s;
  8016d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016da:	eb 0e                	jmp    8016ea <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  8016dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8016e3:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  8016ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ed:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8016f0:	74 12                	je     801704 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8016f2:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8016f9:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801700:	76 af                	jbe    8016b1 <sget+0xa6>
  801702:	eb 01                	jmp    801705 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  801704:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  801705:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801709:	74 08                	je     801713 <sget+0x108>
  80170b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170e:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801711:	74 0a                	je     80171d <sget+0x112>
		return NULL;
  801713:	b8 00 00 00 00       	mov    $0x0,%eax
  801718:	e9 83 00 00 00       	jmp    8017a0 <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  80171d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801720:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801723:	c1 e8 0c             	shr    $0xc,%eax
  801726:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  801729:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80172c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80172f:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801736:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801739:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80173c:	eb 11                	jmp    80174f <sget+0x144>
		markedPages[k] = 1;
  80173e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801741:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801748:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  80174c:	ff 45 e8             	incl   -0x18(%ebp)
  80174f:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801752:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801755:	01 d0                	add    %edx,%eax
  801757:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80175a:	77 e2                	ja     80173e <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  80175c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175f:	83 ec 04             	sub    $0x4,%esp
  801762:	50                   	push   %eax
  801763:	ff 75 0c             	pushl  0xc(%ebp)
  801766:	ff 75 08             	pushl  0x8(%ebp)
  801769:	e8 3f 03 00 00       	call   801aad <sys_getSharedObject>
  80176e:	83 c4 10             	add    $0x10,%esp
  801771:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  801774:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  801778:	78 12                	js     80178c <sget+0x181>
		shardIDs[startPage] = ss;
  80177a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80177d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801780:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801787:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178a:	eb 14                	jmp    8017a0 <sget+0x195>
	}
	free((void*) start);
  80178c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178f:	83 ec 0c             	sub    $0xc,%esp
  801792:	50                   	push   %eax
  801793:	e8 d7 fb ff ff       	call   80136f <free>
  801798:	83 c4 10             	add    $0x10,%esp
	return NULL;
  80179b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8017a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ab:	a1 20 50 80 00       	mov    0x805020,%eax
  8017b0:	8b 40 7c             	mov    0x7c(%eax),%eax
  8017b3:	29 c2                	sub    %eax,%edx
  8017b5:	89 d0                	mov    %edx,%eax
  8017b7:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  8017bc:	c1 e8 0c             	shr    $0xc,%eax
  8017bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  8017c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c5:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  8017cc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  8017cf:	83 ec 08             	sub    $0x8,%esp
  8017d2:	ff 75 08             	pushl  0x8(%ebp)
  8017d5:	ff 75 f0             	pushl  -0x10(%ebp)
  8017d8:	e8 ef 02 00 00       	call   801acc <sys_freeSharedObject>
  8017dd:	83 c4 10             	add    $0x10,%esp
  8017e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  8017e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017e7:	75 0e                	jne    8017f7 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  8017e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ec:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  8017f3:	ff ff ff ff 
	}

}
  8017f7:	90                   	nop
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801800:	83 ec 04             	sub    $0x4,%esp
  801803:	68 e0 3c 80 00       	push   $0x803ce0
  801808:	68 19 01 00 00       	push   $0x119
  80180d:	68 d2 3c 80 00       	push   $0x803cd2
  801812:	e8 26 1b 00 00       	call   80333d <_panic>

00801817 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80181d:	83 ec 04             	sub    $0x4,%esp
  801820:	68 06 3d 80 00       	push   $0x803d06
  801825:	68 23 01 00 00       	push   $0x123
  80182a:	68 d2 3c 80 00       	push   $0x803cd2
  80182f:	e8 09 1b 00 00       	call   80333d <_panic>

00801834 <shrink>:

}
void shrink(uint32 newSize) {
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80183a:	83 ec 04             	sub    $0x4,%esp
  80183d:	68 06 3d 80 00       	push   $0x803d06
  801842:	68 27 01 00 00       	push   $0x127
  801847:	68 d2 3c 80 00       	push   $0x803cd2
  80184c:	e8 ec 1a 00 00       	call   80333d <_panic>

00801851 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801857:	83 ec 04             	sub    $0x4,%esp
  80185a:	68 06 3d 80 00       	push   $0x803d06
  80185f:	68 2b 01 00 00       	push   $0x12b
  801864:	68 d2 3c 80 00       	push   $0x803cd2
  801869:	e8 cf 1a 00 00       	call   80333d <_panic>

0080186e <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
  801871:	57                   	push   %edi
  801872:	56                   	push   %esi
  801873:	53                   	push   %ebx
  801874:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801880:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801883:	8b 7d 18             	mov    0x18(%ebp),%edi
  801886:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801889:	cd 30                	int    $0x30
  80188b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  80188e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801891:	83 c4 10             	add    $0x10,%esp
  801894:	5b                   	pop    %ebx
  801895:	5e                   	pop    %esi
  801896:	5f                   	pop    %edi
  801897:	5d                   	pop    %ebp
  801898:	c3                   	ret    

00801899 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	83 ec 04             	sub    $0x4,%esp
  80189f:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8018a5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	52                   	push   %edx
  8018b1:	ff 75 0c             	pushl  0xc(%ebp)
  8018b4:	50                   	push   %eax
  8018b5:	6a 00                	push   $0x0
  8018b7:	e8 b2 ff ff ff       	call   80186e <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
}
  8018bf:	90                   	nop
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <sys_cgetc>:

int sys_cgetc(void) {
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 02                	push   $0x2
  8018d1:	e8 98 ff ff ff       	call   80186e <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
}
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <sys_lock_cons>:

void sys_lock_cons(void) {
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 03                	push   $0x3
  8018ea:	e8 7f ff ff ff       	call   80186e <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
}
  8018f2:	90                   	nop
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 04                	push   $0x4
  801904:	e8 65 ff ff ff       	call   80186e <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
}
  80190c:	90                   	nop
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801912:	8b 55 0c             	mov    0xc(%ebp),%edx
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	52                   	push   %edx
  80191f:	50                   	push   %eax
  801920:	6a 08                	push   $0x8
  801922:	e8 47 ff ff ff       	call   80186e <syscall>
  801927:	83 c4 18             	add    $0x18,%esp
}
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
  80192f:	56                   	push   %esi
  801930:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801931:	8b 75 18             	mov    0x18(%ebp),%esi
  801934:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801937:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80193a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	56                   	push   %esi
  801941:	53                   	push   %ebx
  801942:	51                   	push   %ecx
  801943:	52                   	push   %edx
  801944:	50                   	push   %eax
  801945:	6a 09                	push   $0x9
  801947:	e8 22 ff ff ff       	call   80186e <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  80194f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801952:	5b                   	pop    %ebx
  801953:	5e                   	pop    %esi
  801954:	5d                   	pop    %ebp
  801955:	c3                   	ret    

00801956 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801959:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	52                   	push   %edx
  801966:	50                   	push   %eax
  801967:	6a 0a                	push   $0xa
  801969:	e8 00 ff ff ff       	call   80186e <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	ff 75 0c             	pushl  0xc(%ebp)
  80197f:	ff 75 08             	pushl  0x8(%ebp)
  801982:	6a 0b                	push   $0xb
  801984:	e8 e5 fe ff ff       	call   80186e <syscall>
  801989:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 0c                	push   $0xc
  80199d:	e8 cc fe ff ff       	call   80186e <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 0d                	push   $0xd
  8019b6:	e8 b3 fe ff ff       	call   80186e <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 0e                	push   $0xe
  8019cf:	e8 9a fe ff ff       	call   80186e <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 0f                	push   $0xf
  8019e8:	e8 81 fe ff ff       	call   80186e <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	ff 75 08             	pushl  0x8(%ebp)
  801a00:	6a 10                	push   $0x10
  801a02:	e8 67 fe ff ff       	call   80186e <syscall>
  801a07:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <sys_scarce_memory>:

void sys_scarce_memory() {
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 11                	push   $0x11
  801a1b:	e8 4e fe ff ff       	call   80186e <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
}
  801a23:	90                   	nop
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_cputc>:

void sys_cputc(const char c) {
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	83 ec 04             	sub    $0x4,%esp
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a32:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	50                   	push   %eax
  801a3f:	6a 01                	push   $0x1
  801a41:	e8 28 fe ff ff       	call   80186e <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
}
  801a49:	90                   	nop
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 14                	push   $0x14
  801a5b:	e8 0e fe ff ff       	call   80186e <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
}
  801a63:	90                   	nop
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	83 ec 04             	sub    $0x4,%esp
  801a6c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801a72:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a75:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	6a 00                	push   $0x0
  801a7e:	51                   	push   %ecx
  801a7f:	52                   	push   %edx
  801a80:	ff 75 0c             	pushl  0xc(%ebp)
  801a83:	50                   	push   %eax
  801a84:	6a 15                	push   $0x15
  801a86:	e8 e3 fd ff ff       	call   80186e <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801a93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	52                   	push   %edx
  801aa0:	50                   	push   %eax
  801aa1:	6a 16                	push   $0x16
  801aa3:	e8 c6 fd ff ff       	call   80186e <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801ab0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ab3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	51                   	push   %ecx
  801abe:	52                   	push   %edx
  801abf:	50                   	push   %eax
  801ac0:	6a 17                	push   $0x17
  801ac2:	e8 a7 fd ff ff       	call   80186e <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801acf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	52                   	push   %edx
  801adc:	50                   	push   %eax
  801add:	6a 18                	push   $0x18
  801adf:	e8 8a fd ff ff       	call   80186e <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801aec:	8b 45 08             	mov    0x8(%ebp),%eax
  801aef:	6a 00                	push   $0x0
  801af1:	ff 75 14             	pushl  0x14(%ebp)
  801af4:	ff 75 10             	pushl  0x10(%ebp)
  801af7:	ff 75 0c             	pushl  0xc(%ebp)
  801afa:	50                   	push   %eax
  801afb:	6a 19                	push   $0x19
  801afd:	e8 6c fd ff ff       	call   80186e <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <sys_run_env>:

void sys_run_env(int32 envId) {
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	50                   	push   %eax
  801b16:	6a 1a                	push   $0x1a
  801b18:	e8 51 fd ff ff       	call   80186e <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
}
  801b20:	90                   	nop
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	50                   	push   %eax
  801b32:	6a 1b                	push   $0x1b
  801b34:	e8 35 fd ff ff       	call   80186e <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <sys_getenvid>:

int32 sys_getenvid(void) {
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 05                	push   $0x5
  801b4d:	e8 1c fd ff ff       	call   80186e <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 06                	push   $0x6
  801b66:	e8 03 fd ff ff       	call   80186e <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 07                	push   $0x7
  801b7f:	e8 ea fc ff ff       	call   80186e <syscall>
  801b84:	83 c4 18             	add    $0x18,%esp
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <sys_exit_env>:

void sys_exit_env(void) {
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 1c                	push   $0x1c
  801b98:	e8 d1 fc ff ff       	call   80186e <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
}
  801ba0:	90                   	nop
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
  801ba6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801ba9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bac:	8d 50 04             	lea    0x4(%eax),%edx
  801baf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	52                   	push   %edx
  801bb9:	50                   	push   %eax
  801bba:	6a 1d                	push   $0x1d
  801bbc:	e8 ad fc ff ff       	call   80186e <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801bc4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bcd:	89 01                	mov    %eax,(%ecx)
  801bcf:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd5:	c9                   	leave  
  801bd6:	c2 04 00             	ret    $0x4

00801bd9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	ff 75 10             	pushl  0x10(%ebp)
  801be3:	ff 75 0c             	pushl  0xc(%ebp)
  801be6:	ff 75 08             	pushl  0x8(%ebp)
  801be9:	6a 13                	push   $0x13
  801beb:	e8 7e fc ff ff       	call   80186e <syscall>
  801bf0:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801bf3:	90                   	nop
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <sys_rcr2>:
uint32 sys_rcr2() {
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 1e                	push   $0x1e
  801c05:	e8 64 fc ff ff       	call   80186e <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
  801c12:	83 ec 04             	sub    $0x4,%esp
  801c15:	8b 45 08             	mov    0x8(%ebp),%eax
  801c18:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c1b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	50                   	push   %eax
  801c28:	6a 1f                	push   $0x1f
  801c2a:	e8 3f fc ff ff       	call   80186e <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
	return;
  801c32:	90                   	nop
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <rsttst>:
void rsttst() {
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 21                	push   $0x21
  801c44:	e8 25 fc ff ff       	call   80186e <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
	return;
  801c4c:	90                   	nop
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	83 ec 04             	sub    $0x4,%esp
  801c55:	8b 45 14             	mov    0x14(%ebp),%eax
  801c58:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c5b:	8b 55 18             	mov    0x18(%ebp),%edx
  801c5e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c62:	52                   	push   %edx
  801c63:	50                   	push   %eax
  801c64:	ff 75 10             	pushl  0x10(%ebp)
  801c67:	ff 75 0c             	pushl  0xc(%ebp)
  801c6a:	ff 75 08             	pushl  0x8(%ebp)
  801c6d:	6a 20                	push   $0x20
  801c6f:	e8 fa fb ff ff       	call   80186e <syscall>
  801c74:	83 c4 18             	add    $0x18,%esp
	return;
  801c77:	90                   	nop
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <chktst>:
void chktst(uint32 n) {
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	ff 75 08             	pushl  0x8(%ebp)
  801c88:	6a 22                	push   $0x22
  801c8a:	e8 df fb ff ff       	call   80186e <syscall>
  801c8f:	83 c4 18             	add    $0x18,%esp
	return;
  801c92:	90                   	nop
}
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <inctst>:

void inctst() {
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 23                	push   $0x23
  801ca4:	e8 c5 fb ff ff       	call   80186e <syscall>
  801ca9:	83 c4 18             	add    $0x18,%esp
	return;
  801cac:	90                   	nop
}
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <gettst>:
uint32 gettst() {
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 24                	push   $0x24
  801cbe:	e8 ab fb ff ff       	call   80186e <syscall>
  801cc3:	83 c4 18             	add    $0x18,%esp
}
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
  801ccb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 25                	push   $0x25
  801cda:	e8 8f fb ff ff       	call   80186e <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
  801ce2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ce5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ce9:	75 07                	jne    801cf2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ceb:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf0:	eb 05                	jmp    801cf7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cf2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
  801cfc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 25                	push   $0x25
  801d0b:	e8 5e fb ff ff       	call   80186e <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
  801d13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d16:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d1a:	75 07                	jne    801d23 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d1c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d21:	eb 05                	jmp    801d28 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 25                	push   $0x25
  801d3c:	e8 2d fb ff ff       	call   80186e <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
  801d44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d47:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d4b:	75 07                	jne    801d54 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d4d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d52:	eb 05                	jmp    801d59 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 25                	push   $0x25
  801d6d:	e8 fc fa ff ff       	call   80186e <syscall>
  801d72:	83 c4 18             	add    $0x18,%esp
  801d75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d78:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d7c:	75 07                	jne    801d85 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d83:	eb 05                	jmp    801d8a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	ff 75 08             	pushl  0x8(%ebp)
  801d9a:	6a 26                	push   $0x26
  801d9c:	e8 cd fa ff ff       	call   80186e <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
	return;
  801da4:	90                   	nop
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
  801daa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801dab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801db1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	6a 00                	push   $0x0
  801db9:	53                   	push   %ebx
  801dba:	51                   	push   %ecx
  801dbb:	52                   	push   %edx
  801dbc:	50                   	push   %eax
  801dbd:	6a 27                	push   $0x27
  801dbf:	e8 aa fa ff ff       	call   80186e <syscall>
  801dc4:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801dc7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801dcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	52                   	push   %edx
  801ddc:	50                   	push   %eax
  801ddd:	6a 28                	push   $0x28
  801ddf:	e8 8a fa ff ff       	call   80186e <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801dec:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801def:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df2:	8b 45 08             	mov    0x8(%ebp),%eax
  801df5:	6a 00                	push   $0x0
  801df7:	51                   	push   %ecx
  801df8:	ff 75 10             	pushl  0x10(%ebp)
  801dfb:	52                   	push   %edx
  801dfc:	50                   	push   %eax
  801dfd:	6a 29                	push   $0x29
  801dff:	e8 6a fa ff ff       	call   80186e <syscall>
  801e04:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	ff 75 10             	pushl  0x10(%ebp)
  801e13:	ff 75 0c             	pushl  0xc(%ebp)
  801e16:	ff 75 08             	pushl  0x8(%ebp)
  801e19:	6a 12                	push   $0x12
  801e1b:	e8 4e fa ff ff       	call   80186e <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
	return;
  801e23:	90                   	nop
}
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801e29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	52                   	push   %edx
  801e36:	50                   	push   %eax
  801e37:	6a 2a                	push   $0x2a
  801e39:	e8 30 fa ff ff       	call   80186e <syscall>
  801e3e:	83 c4 18             	add    $0x18,%esp
	return;
  801e41:	90                   	nop
}
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801e47:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	50                   	push   %eax
  801e53:	6a 2b                	push   $0x2b
  801e55:	e8 14 fa ff ff       	call   80186e <syscall>
  801e5a:	83 c4 18             	add    $0x18,%esp
}
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    

00801e5f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	ff 75 0c             	pushl  0xc(%ebp)
  801e6b:	ff 75 08             	pushl  0x8(%ebp)
  801e6e:	6a 2c                	push   $0x2c
  801e70:	e8 f9 f9 ff ff       	call   80186e <syscall>
  801e75:	83 c4 18             	add    $0x18,%esp
	return;
  801e78:	90                   	nop
}
  801e79:	c9                   	leave  
  801e7a:	c3                   	ret    

00801e7b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	ff 75 0c             	pushl  0xc(%ebp)
  801e87:	ff 75 08             	pushl  0x8(%ebp)
  801e8a:	6a 2d                	push   $0x2d
  801e8c:	e8 dd f9 ff ff       	call   80186e <syscall>
  801e91:	83 c4 18             	add    $0x18,%esp
	return;
  801e94:	90                   	nop
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	50                   	push   %eax
  801ea6:	6a 2f                	push   $0x2f
  801ea8:	e8 c1 f9 ff ff       	call   80186e <syscall>
  801ead:	83 c4 18             	add    $0x18,%esp
	return;
  801eb0:	90                   	nop
}
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  801eb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	52                   	push   %edx
  801ec3:	50                   	push   %eax
  801ec4:	6a 30                	push   $0x30
  801ec6:	e8 a3 f9 ff ff       	call   80186e <syscall>
  801ecb:	83 c4 18             	add    $0x18,%esp
	return;
  801ece:	90                   	nop
}
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  801ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	50                   	push   %eax
  801ee0:	6a 31                	push   $0x31
  801ee2:	e8 87 f9 ff ff       	call   80186e <syscall>
  801ee7:	83 c4 18             	add    $0x18,%esp
	return;
  801eea:	90                   	nop
}
  801eeb:	c9                   	leave  
  801eec:	c3                   	ret    

00801eed <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801eed:	55                   	push   %ebp
  801eee:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801ef0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	52                   	push   %edx
  801efd:	50                   	push   %eax
  801efe:	6a 2e                	push   $0x2e
  801f00:	e8 69 f9 ff ff       	call   80186e <syscall>
  801f05:	83 c4 18             	add    $0x18,%esp
    return;
  801f08:	90                   	nop
}
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    

00801f0b <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	83 e8 04             	sub    $0x4,%eax
  801f17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f1d:	8b 00                	mov    (%eax),%eax
  801f1f:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f22:	c9                   	leave  
  801f23:	c3                   	ret    

00801f24 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2d:	83 e8 04             	sub    $0x4,%eax
  801f30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f36:	8b 00                	mov    (%eax),%eax
  801f38:	83 e0 01             	and    $0x1,%eax
  801f3b:	85 c0                	test   %eax,%eax
  801f3d:	0f 94 c0             	sete   %al
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f52:	83 f8 02             	cmp    $0x2,%eax
  801f55:	74 2b                	je     801f82 <alloc_block+0x40>
  801f57:	83 f8 02             	cmp    $0x2,%eax
  801f5a:	7f 07                	jg     801f63 <alloc_block+0x21>
  801f5c:	83 f8 01             	cmp    $0x1,%eax
  801f5f:	74 0e                	je     801f6f <alloc_block+0x2d>
  801f61:	eb 58                	jmp    801fbb <alloc_block+0x79>
  801f63:	83 f8 03             	cmp    $0x3,%eax
  801f66:	74 2d                	je     801f95 <alloc_block+0x53>
  801f68:	83 f8 04             	cmp    $0x4,%eax
  801f6b:	74 3b                	je     801fa8 <alloc_block+0x66>
  801f6d:	eb 4c                	jmp    801fbb <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f6f:	83 ec 0c             	sub    $0xc,%esp
  801f72:	ff 75 08             	pushl  0x8(%ebp)
  801f75:	e8 f7 03 00 00       	call   802371 <alloc_block_FF>
  801f7a:	83 c4 10             	add    $0x10,%esp
  801f7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f80:	eb 4a                	jmp    801fcc <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f82:	83 ec 0c             	sub    $0xc,%esp
  801f85:	ff 75 08             	pushl  0x8(%ebp)
  801f88:	e8 f0 11 00 00       	call   80317d <alloc_block_NF>
  801f8d:	83 c4 10             	add    $0x10,%esp
  801f90:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f93:	eb 37                	jmp    801fcc <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f95:	83 ec 0c             	sub    $0xc,%esp
  801f98:	ff 75 08             	pushl  0x8(%ebp)
  801f9b:	e8 08 08 00 00       	call   8027a8 <alloc_block_BF>
  801fa0:	83 c4 10             	add    $0x10,%esp
  801fa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fa6:	eb 24                	jmp    801fcc <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801fa8:	83 ec 0c             	sub    $0xc,%esp
  801fab:	ff 75 08             	pushl  0x8(%ebp)
  801fae:	e8 ad 11 00 00       	call   803160 <alloc_block_WF>
  801fb3:	83 c4 10             	add    $0x10,%esp
  801fb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fb9:	eb 11                	jmp    801fcc <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801fbb:	83 ec 0c             	sub    $0xc,%esp
  801fbe:	68 18 3d 80 00       	push   $0x803d18
  801fc3:	e8 41 e4 ff ff       	call   800409 <cprintf>
  801fc8:	83 c4 10             	add    $0x10,%esp
		break;
  801fcb:	90                   	nop
	}
	return va;
  801fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	53                   	push   %ebx
  801fd5:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801fd8:	83 ec 0c             	sub    $0xc,%esp
  801fdb:	68 38 3d 80 00       	push   $0x803d38
  801fe0:	e8 24 e4 ff ff       	call   800409 <cprintf>
  801fe5:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801fe8:	83 ec 0c             	sub    $0xc,%esp
  801feb:	68 63 3d 80 00       	push   $0x803d63
  801ff0:	e8 14 e4 ff ff       	call   800409 <cprintf>
  801ff5:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ffe:	eb 37                	jmp    802037 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802000:	83 ec 0c             	sub    $0xc,%esp
  802003:	ff 75 f4             	pushl  -0xc(%ebp)
  802006:	e8 19 ff ff ff       	call   801f24 <is_free_block>
  80200b:	83 c4 10             	add    $0x10,%esp
  80200e:	0f be d8             	movsbl %al,%ebx
  802011:	83 ec 0c             	sub    $0xc,%esp
  802014:	ff 75 f4             	pushl  -0xc(%ebp)
  802017:	e8 ef fe ff ff       	call   801f0b <get_block_size>
  80201c:	83 c4 10             	add    $0x10,%esp
  80201f:	83 ec 04             	sub    $0x4,%esp
  802022:	53                   	push   %ebx
  802023:	50                   	push   %eax
  802024:	68 7b 3d 80 00       	push   $0x803d7b
  802029:	e8 db e3 ff ff       	call   800409 <cprintf>
  80202e:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802031:	8b 45 10             	mov    0x10(%ebp),%eax
  802034:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802037:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80203b:	74 07                	je     802044 <print_blocks_list+0x73>
  80203d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802040:	8b 00                	mov    (%eax),%eax
  802042:	eb 05                	jmp    802049 <print_blocks_list+0x78>
  802044:	b8 00 00 00 00       	mov    $0x0,%eax
  802049:	89 45 10             	mov    %eax,0x10(%ebp)
  80204c:	8b 45 10             	mov    0x10(%ebp),%eax
  80204f:	85 c0                	test   %eax,%eax
  802051:	75 ad                	jne    802000 <print_blocks_list+0x2f>
  802053:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802057:	75 a7                	jne    802000 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802059:	83 ec 0c             	sub    $0xc,%esp
  80205c:	68 38 3d 80 00       	push   $0x803d38
  802061:	e8 a3 e3 ff ff       	call   800409 <cprintf>
  802066:	83 c4 10             	add    $0x10,%esp

}
  802069:	90                   	nop
  80206a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80206d:	c9                   	leave  
  80206e:	c3                   	ret    

0080206f <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80206f:	55                   	push   %ebp
  802070:	89 e5                	mov    %esp,%ebp
  802072:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802075:	8b 45 0c             	mov    0xc(%ebp),%eax
  802078:	83 e0 01             	and    $0x1,%eax
  80207b:	85 c0                	test   %eax,%eax
  80207d:	74 03                	je     802082 <initialize_dynamic_allocator+0x13>
  80207f:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  802082:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802086:	0f 84 f8 00 00 00    	je     802184 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  80208c:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  802093:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  802096:	a1 40 50 98 00       	mov    0x985040,%eax
  80209b:	85 c0                	test   %eax,%eax
  80209d:	0f 84 e2 00 00 00    	je     802185 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  8020a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8020a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ac:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  8020b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8020b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b8:	01 d0                	add    %edx,%eax
  8020ba:	83 e8 04             	sub    $0x4,%eax
  8020bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8020c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	83 c0 08             	add    $0x8,%eax
  8020cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  8020d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d5:	83 e8 08             	sub    $0x8,%eax
  8020d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  8020db:	83 ec 04             	sub    $0x4,%esp
  8020de:	6a 00                	push   $0x0
  8020e0:	ff 75 e8             	pushl  -0x18(%ebp)
  8020e3:	ff 75 ec             	pushl  -0x14(%ebp)
  8020e6:	e8 9c 00 00 00       	call   802187 <set_block_data>
  8020eb:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  8020ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  8020f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  802101:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  802108:	00 00 00 
  80210b:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  802112:	00 00 00 
  802115:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  80211c:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  80211f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802123:	75 17                	jne    80213c <initialize_dynamic_allocator+0xcd>
  802125:	83 ec 04             	sub    $0x4,%esp
  802128:	68 94 3d 80 00       	push   $0x803d94
  80212d:	68 80 00 00 00       	push   $0x80
  802132:	68 b7 3d 80 00       	push   $0x803db7
  802137:	e8 01 12 00 00       	call   80333d <_panic>
  80213c:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802142:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802145:	89 10                	mov    %edx,(%eax)
  802147:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80214a:	8b 00                	mov    (%eax),%eax
  80214c:	85 c0                	test   %eax,%eax
  80214e:	74 0d                	je     80215d <initialize_dynamic_allocator+0xee>
  802150:	a1 48 50 98 00       	mov    0x985048,%eax
  802155:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802158:	89 50 04             	mov    %edx,0x4(%eax)
  80215b:	eb 08                	jmp    802165 <initialize_dynamic_allocator+0xf6>
  80215d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802160:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802165:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802168:	a3 48 50 98 00       	mov    %eax,0x985048
  80216d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802170:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802177:	a1 54 50 98 00       	mov    0x985054,%eax
  80217c:	40                   	inc    %eax
  80217d:	a3 54 50 98 00       	mov    %eax,0x985054
  802182:	eb 01                	jmp    802185 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802184:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  802185:	c9                   	leave  
  802186:	c3                   	ret    

00802187 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
  80218a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  80218d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802190:	83 e0 01             	and    $0x1,%eax
  802193:	85 c0                	test   %eax,%eax
  802195:	74 03                	je     80219a <set_block_data+0x13>
	{
		totalSize++;
  802197:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	83 e8 04             	sub    $0x4,%eax
  8021a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  8021a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a6:	83 e0 fe             	and    $0xfffffffe,%eax
  8021a9:	89 c2                	mov    %eax,%edx
  8021ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ae:	83 e0 01             	and    $0x1,%eax
  8021b1:	09 c2                	or     %eax,%edx
  8021b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021b6:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  8021b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bb:	8d 50 f8             	lea    -0x8(%eax),%edx
  8021be:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c1:	01 d0                	add    %edx,%eax
  8021c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  8021c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c9:	83 e0 fe             	and    $0xfffffffe,%eax
  8021cc:	89 c2                	mov    %eax,%edx
  8021ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8021d1:	83 e0 01             	and    $0x1,%eax
  8021d4:	09 c2                	or     %eax,%edx
  8021d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021d9:	89 10                	mov    %edx,(%eax)
}
  8021db:	90                   	nop
  8021dc:	c9                   	leave  
  8021dd:	c3                   	ret    

008021de <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
  8021e1:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  8021e4:	a1 48 50 98 00       	mov    0x985048,%eax
  8021e9:	85 c0                	test   %eax,%eax
  8021eb:	75 68                	jne    802255 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  8021ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021f1:	75 17                	jne    80220a <insert_sorted_in_freeList+0x2c>
  8021f3:	83 ec 04             	sub    $0x4,%esp
  8021f6:	68 94 3d 80 00       	push   $0x803d94
  8021fb:	68 9d 00 00 00       	push   $0x9d
  802200:	68 b7 3d 80 00       	push   $0x803db7
  802205:	e8 33 11 00 00       	call   80333d <_panic>
  80220a:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802210:	8b 45 08             	mov    0x8(%ebp),%eax
  802213:	89 10                	mov    %edx,(%eax)
  802215:	8b 45 08             	mov    0x8(%ebp),%eax
  802218:	8b 00                	mov    (%eax),%eax
  80221a:	85 c0                	test   %eax,%eax
  80221c:	74 0d                	je     80222b <insert_sorted_in_freeList+0x4d>
  80221e:	a1 48 50 98 00       	mov    0x985048,%eax
  802223:	8b 55 08             	mov    0x8(%ebp),%edx
  802226:	89 50 04             	mov    %edx,0x4(%eax)
  802229:	eb 08                	jmp    802233 <insert_sorted_in_freeList+0x55>
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	a3 48 50 98 00       	mov    %eax,0x985048
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802245:	a1 54 50 98 00       	mov    0x985054,%eax
  80224a:	40                   	inc    %eax
  80224b:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  802250:	e9 1a 01 00 00       	jmp    80236f <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802255:	a1 48 50 98 00       	mov    0x985048,%eax
  80225a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80225d:	eb 7f                	jmp    8022de <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  80225f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802262:	3b 45 08             	cmp    0x8(%ebp),%eax
  802265:	76 6f                	jbe    8022d6 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  802267:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80226b:	74 06                	je     802273 <insert_sorted_in_freeList+0x95>
  80226d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802271:	75 17                	jne    80228a <insert_sorted_in_freeList+0xac>
  802273:	83 ec 04             	sub    $0x4,%esp
  802276:	68 d0 3d 80 00       	push   $0x803dd0
  80227b:	68 a6 00 00 00       	push   $0xa6
  802280:	68 b7 3d 80 00       	push   $0x803db7
  802285:	e8 b3 10 00 00       	call   80333d <_panic>
  80228a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228d:	8b 50 04             	mov    0x4(%eax),%edx
  802290:	8b 45 08             	mov    0x8(%ebp),%eax
  802293:	89 50 04             	mov    %edx,0x4(%eax)
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80229c:	89 10                	mov    %edx,(%eax)
  80229e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a1:	8b 40 04             	mov    0x4(%eax),%eax
  8022a4:	85 c0                	test   %eax,%eax
  8022a6:	74 0d                	je     8022b5 <insert_sorted_in_freeList+0xd7>
  8022a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ab:	8b 40 04             	mov    0x4(%eax),%eax
  8022ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b1:	89 10                	mov    %edx,(%eax)
  8022b3:	eb 08                	jmp    8022bd <insert_sorted_in_freeList+0xdf>
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	a3 48 50 98 00       	mov    %eax,0x985048
  8022bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c3:	89 50 04             	mov    %edx,0x4(%eax)
  8022c6:	a1 54 50 98 00       	mov    0x985054,%eax
  8022cb:	40                   	inc    %eax
  8022cc:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  8022d1:	e9 99 00 00 00       	jmp    80236f <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8022d6:	a1 50 50 98 00       	mov    0x985050,%eax
  8022db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e2:	74 07                	je     8022eb <insert_sorted_in_freeList+0x10d>
  8022e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e7:	8b 00                	mov    (%eax),%eax
  8022e9:	eb 05                	jmp    8022f0 <insert_sorted_in_freeList+0x112>
  8022eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f0:	a3 50 50 98 00       	mov    %eax,0x985050
  8022f5:	a1 50 50 98 00       	mov    0x985050,%eax
  8022fa:	85 c0                	test   %eax,%eax
  8022fc:	0f 85 5d ff ff ff    	jne    80225f <insert_sorted_in_freeList+0x81>
  802302:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802306:	0f 85 53 ff ff ff    	jne    80225f <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  80230c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802310:	75 17                	jne    802329 <insert_sorted_in_freeList+0x14b>
  802312:	83 ec 04             	sub    $0x4,%esp
  802315:	68 08 3e 80 00       	push   $0x803e08
  80231a:	68 ab 00 00 00       	push   $0xab
  80231f:	68 b7 3d 80 00       	push   $0x803db7
  802324:	e8 14 10 00 00       	call   80333d <_panic>
  802329:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  80232f:	8b 45 08             	mov    0x8(%ebp),%eax
  802332:	89 50 04             	mov    %edx,0x4(%eax)
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	8b 40 04             	mov    0x4(%eax),%eax
  80233b:	85 c0                	test   %eax,%eax
  80233d:	74 0c                	je     80234b <insert_sorted_in_freeList+0x16d>
  80233f:	a1 4c 50 98 00       	mov    0x98504c,%eax
  802344:	8b 55 08             	mov    0x8(%ebp),%edx
  802347:	89 10                	mov    %edx,(%eax)
  802349:	eb 08                	jmp    802353 <insert_sorted_in_freeList+0x175>
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	a3 48 50 98 00       	mov    %eax,0x985048
  802353:	8b 45 08             	mov    0x8(%ebp),%eax
  802356:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80235b:	8b 45 08             	mov    0x8(%ebp),%eax
  80235e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802364:	a1 54 50 98 00       	mov    0x985054,%eax
  802369:	40                   	inc    %eax
  80236a:	a3 54 50 98 00       	mov    %eax,0x985054
}
  80236f:	c9                   	leave  
  802370:	c3                   	ret    

00802371 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
  802374:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802377:	8b 45 08             	mov    0x8(%ebp),%eax
  80237a:	83 e0 01             	and    $0x1,%eax
  80237d:	85 c0                	test   %eax,%eax
  80237f:	74 03                	je     802384 <alloc_block_FF+0x13>
  802381:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802384:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802388:	77 07                	ja     802391 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80238a:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802391:	a1 40 50 98 00       	mov    0x985040,%eax
  802396:	85 c0                	test   %eax,%eax
  802398:	75 63                	jne    8023fd <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80239a:	8b 45 08             	mov    0x8(%ebp),%eax
  80239d:	83 c0 10             	add    $0x10,%eax
  8023a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8023a3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8023aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b0:	01 d0                	add    %edx,%eax
  8023b2:	48                   	dec    %eax
  8023b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8023b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8023be:	f7 75 ec             	divl   -0x14(%ebp)
  8023c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023c4:	29 d0                	sub    %edx,%eax
  8023c6:	c1 e8 0c             	shr    $0xc,%eax
  8023c9:	83 ec 0c             	sub    $0xc,%esp
  8023cc:	50                   	push   %eax
  8023cd:	e8 d1 ed ff ff       	call   8011a3 <sbrk>
  8023d2:	83 c4 10             	add    $0x10,%esp
  8023d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8023d8:	83 ec 0c             	sub    $0xc,%esp
  8023db:	6a 00                	push   $0x0
  8023dd:	e8 c1 ed ff ff       	call   8011a3 <sbrk>
  8023e2:	83 c4 10             	add    $0x10,%esp
  8023e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8023e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023eb:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8023ee:	83 ec 08             	sub    $0x8,%esp
  8023f1:	50                   	push   %eax
  8023f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8023f5:	e8 75 fc ff ff       	call   80206f <initialize_dynamic_allocator>
  8023fa:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  8023fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802401:	75 0a                	jne    80240d <alloc_block_FF+0x9c>
	{
		return NULL;
  802403:	b8 00 00 00 00       	mov    $0x0,%eax
  802408:	e9 99 03 00 00       	jmp    8027a6 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  80240d:	8b 45 08             	mov    0x8(%ebp),%eax
  802410:	83 c0 08             	add    $0x8,%eax
  802413:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802416:	a1 48 50 98 00       	mov    0x985048,%eax
  80241b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80241e:	e9 03 02 00 00       	jmp    802626 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802423:	83 ec 0c             	sub    $0xc,%esp
  802426:	ff 75 f4             	pushl  -0xc(%ebp)
  802429:	e8 dd fa ff ff       	call   801f0b <get_block_size>
  80242e:	83 c4 10             	add    $0x10,%esp
  802431:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802434:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802437:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80243a:	0f 82 de 01 00 00    	jb     80261e <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  802440:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802443:	83 c0 10             	add    $0x10,%eax
  802446:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802449:	0f 87 32 01 00 00    	ja     802581 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  80244f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802452:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802455:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802458:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80245e:	01 d0                	add    %edx,%eax
  802460:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  802463:	83 ec 04             	sub    $0x4,%esp
  802466:	6a 00                	push   $0x0
  802468:	ff 75 98             	pushl  -0x68(%ebp)
  80246b:	ff 75 94             	pushl  -0x6c(%ebp)
  80246e:	e8 14 fd ff ff       	call   802187 <set_block_data>
  802473:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802476:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80247a:	74 06                	je     802482 <alloc_block_FF+0x111>
  80247c:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  802480:	75 17                	jne    802499 <alloc_block_FF+0x128>
  802482:	83 ec 04             	sub    $0x4,%esp
  802485:	68 2c 3e 80 00       	push   $0x803e2c
  80248a:	68 de 00 00 00       	push   $0xde
  80248f:	68 b7 3d 80 00       	push   $0x803db7
  802494:	e8 a4 0e 00 00       	call   80333d <_panic>
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	8b 10                	mov    (%eax),%edx
  80249e:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8024a1:	89 10                	mov    %edx,(%eax)
  8024a3:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8024a6:	8b 00                	mov    (%eax),%eax
  8024a8:	85 c0                	test   %eax,%eax
  8024aa:	74 0b                	je     8024b7 <alloc_block_FF+0x146>
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	8b 00                	mov    (%eax),%eax
  8024b1:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8024b4:	89 50 04             	mov    %edx,0x4(%eax)
  8024b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ba:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8024bd:	89 10                	mov    %edx,(%eax)
  8024bf:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8024c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c5:	89 50 04             	mov    %edx,0x4(%eax)
  8024c8:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8024cb:	8b 00                	mov    (%eax),%eax
  8024cd:	85 c0                	test   %eax,%eax
  8024cf:	75 08                	jne    8024d9 <alloc_block_FF+0x168>
  8024d1:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8024d4:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8024d9:	a1 54 50 98 00       	mov    0x985054,%eax
  8024de:	40                   	inc    %eax
  8024df:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  8024e4:	83 ec 04             	sub    $0x4,%esp
  8024e7:	6a 01                	push   $0x1
  8024e9:	ff 75 dc             	pushl  -0x24(%ebp)
  8024ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8024ef:	e8 93 fc ff ff       	call   802187 <set_block_data>
  8024f4:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  8024f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024fb:	75 17                	jne    802514 <alloc_block_FF+0x1a3>
  8024fd:	83 ec 04             	sub    $0x4,%esp
  802500:	68 60 3e 80 00       	push   $0x803e60
  802505:	68 e3 00 00 00       	push   $0xe3
  80250a:	68 b7 3d 80 00       	push   $0x803db7
  80250f:	e8 29 0e 00 00       	call   80333d <_panic>
  802514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802517:	8b 00                	mov    (%eax),%eax
  802519:	85 c0                	test   %eax,%eax
  80251b:	74 10                	je     80252d <alloc_block_FF+0x1bc>
  80251d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802520:	8b 00                	mov    (%eax),%eax
  802522:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802525:	8b 52 04             	mov    0x4(%edx),%edx
  802528:	89 50 04             	mov    %edx,0x4(%eax)
  80252b:	eb 0b                	jmp    802538 <alloc_block_FF+0x1c7>
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	8b 40 04             	mov    0x4(%eax),%eax
  802533:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	8b 40 04             	mov    0x4(%eax),%eax
  80253e:	85 c0                	test   %eax,%eax
  802540:	74 0f                	je     802551 <alloc_block_FF+0x1e0>
  802542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802545:	8b 40 04             	mov    0x4(%eax),%eax
  802548:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254b:	8b 12                	mov    (%edx),%edx
  80254d:	89 10                	mov    %edx,(%eax)
  80254f:	eb 0a                	jmp    80255b <alloc_block_FF+0x1ea>
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	8b 00                	mov    (%eax),%eax
  802556:	a3 48 50 98 00       	mov    %eax,0x985048
  80255b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802567:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80256e:	a1 54 50 98 00       	mov    0x985054,%eax
  802573:	48                   	dec    %eax
  802574:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	e9 25 02 00 00       	jmp    8027a6 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  802581:	83 ec 04             	sub    $0x4,%esp
  802584:	6a 01                	push   $0x1
  802586:	ff 75 9c             	pushl  -0x64(%ebp)
  802589:	ff 75 f4             	pushl  -0xc(%ebp)
  80258c:	e8 f6 fb ff ff       	call   802187 <set_block_data>
  802591:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802594:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802598:	75 17                	jne    8025b1 <alloc_block_FF+0x240>
  80259a:	83 ec 04             	sub    $0x4,%esp
  80259d:	68 60 3e 80 00       	push   $0x803e60
  8025a2:	68 eb 00 00 00       	push   $0xeb
  8025a7:	68 b7 3d 80 00       	push   $0x803db7
  8025ac:	e8 8c 0d 00 00       	call   80333d <_panic>
  8025b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b4:	8b 00                	mov    (%eax),%eax
  8025b6:	85 c0                	test   %eax,%eax
  8025b8:	74 10                	je     8025ca <alloc_block_FF+0x259>
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	8b 00                	mov    (%eax),%eax
  8025bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c2:	8b 52 04             	mov    0x4(%edx),%edx
  8025c5:	89 50 04             	mov    %edx,0x4(%eax)
  8025c8:	eb 0b                	jmp    8025d5 <alloc_block_FF+0x264>
  8025ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cd:	8b 40 04             	mov    0x4(%eax),%eax
  8025d0:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	8b 40 04             	mov    0x4(%eax),%eax
  8025db:	85 c0                	test   %eax,%eax
  8025dd:	74 0f                	je     8025ee <alloc_block_FF+0x27d>
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	8b 40 04             	mov    0x4(%eax),%eax
  8025e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e8:	8b 12                	mov    (%edx),%edx
  8025ea:	89 10                	mov    %edx,(%eax)
  8025ec:	eb 0a                	jmp    8025f8 <alloc_block_FF+0x287>
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	8b 00                	mov    (%eax),%eax
  8025f3:	a3 48 50 98 00       	mov    %eax,0x985048
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802604:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80260b:	a1 54 50 98 00       	mov    0x985054,%eax
  802610:	48                   	dec    %eax
  802611:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802619:	e9 88 01 00 00       	jmp    8027a6 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  80261e:	a1 50 50 98 00       	mov    0x985050,%eax
  802623:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802626:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262a:	74 07                	je     802633 <alloc_block_FF+0x2c2>
  80262c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262f:	8b 00                	mov    (%eax),%eax
  802631:	eb 05                	jmp    802638 <alloc_block_FF+0x2c7>
  802633:	b8 00 00 00 00       	mov    $0x0,%eax
  802638:	a3 50 50 98 00       	mov    %eax,0x985050
  80263d:	a1 50 50 98 00       	mov    0x985050,%eax
  802642:	85 c0                	test   %eax,%eax
  802644:	0f 85 d9 fd ff ff    	jne    802423 <alloc_block_FF+0xb2>
  80264a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264e:	0f 85 cf fd ff ff    	jne    802423 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  802654:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80265b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80265e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802661:	01 d0                	add    %edx,%eax
  802663:	48                   	dec    %eax
  802664:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802667:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80266a:	ba 00 00 00 00       	mov    $0x0,%edx
  80266f:	f7 75 d8             	divl   -0x28(%ebp)
  802672:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802675:	29 d0                	sub    %edx,%eax
  802677:	c1 e8 0c             	shr    $0xc,%eax
  80267a:	83 ec 0c             	sub    $0xc,%esp
  80267d:	50                   	push   %eax
  80267e:	e8 20 eb ff ff       	call   8011a3 <sbrk>
  802683:	83 c4 10             	add    $0x10,%esp
  802686:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802689:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80268d:	75 0a                	jne    802699 <alloc_block_FF+0x328>
		return NULL;
  80268f:	b8 00 00 00 00       	mov    $0x0,%eax
  802694:	e9 0d 01 00 00       	jmp    8027a6 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  802699:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80269c:	83 e8 04             	sub    $0x4,%eax
  80269f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  8026a2:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  8026a9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026ac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026af:	01 d0                	add    %edx,%eax
  8026b1:	48                   	dec    %eax
  8026b2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8026b5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8026b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8026bd:	f7 75 c8             	divl   -0x38(%ebp)
  8026c0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8026c3:	29 d0                	sub    %edx,%eax
  8026c5:	c1 e8 02             	shr    $0x2,%eax
  8026c8:	c1 e0 02             	shl    $0x2,%eax
  8026cb:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  8026ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026d1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  8026d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026da:	83 e8 08             	sub    $0x8,%eax
  8026dd:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  8026e0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026e3:	8b 00                	mov    (%eax),%eax
  8026e5:	83 e0 fe             	and    $0xfffffffe,%eax
  8026e8:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  8026eb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026ee:	f7 d8                	neg    %eax
  8026f0:	89 c2                	mov    %eax,%edx
  8026f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026f5:	01 d0                	add    %edx,%eax
  8026f7:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  8026fa:	83 ec 0c             	sub    $0xc,%esp
  8026fd:	ff 75 b8             	pushl  -0x48(%ebp)
  802700:	e8 1f f8 ff ff       	call   801f24 <is_free_block>
  802705:	83 c4 10             	add    $0x10,%esp
  802708:	0f be c0             	movsbl %al,%eax
  80270b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  80270e:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802712:	74 42                	je     802756 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  802714:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80271b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80271e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802721:	01 d0                	add    %edx,%eax
  802723:	48                   	dec    %eax
  802724:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802727:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80272a:	ba 00 00 00 00       	mov    $0x0,%edx
  80272f:	f7 75 b0             	divl   -0x50(%ebp)
  802732:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802735:	29 d0                	sub    %edx,%eax
  802737:	89 c2                	mov    %eax,%edx
  802739:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80273c:	01 d0                	add    %edx,%eax
  80273e:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  802741:	83 ec 04             	sub    $0x4,%esp
  802744:	6a 00                	push   $0x0
  802746:	ff 75 a8             	pushl  -0x58(%ebp)
  802749:	ff 75 b8             	pushl  -0x48(%ebp)
  80274c:	e8 36 fa ff ff       	call   802187 <set_block_data>
  802751:	83 c4 10             	add    $0x10,%esp
  802754:	eb 42                	jmp    802798 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802756:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  80275d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802760:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802763:	01 d0                	add    %edx,%eax
  802765:	48                   	dec    %eax
  802766:	89 45 a0             	mov    %eax,-0x60(%ebp)
  802769:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80276c:	ba 00 00 00 00       	mov    $0x0,%edx
  802771:	f7 75 a4             	divl   -0x5c(%ebp)
  802774:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802777:	29 d0                	sub    %edx,%eax
  802779:	83 ec 04             	sub    $0x4,%esp
  80277c:	6a 00                	push   $0x0
  80277e:	50                   	push   %eax
  80277f:	ff 75 d0             	pushl  -0x30(%ebp)
  802782:	e8 00 fa ff ff       	call   802187 <set_block_data>
  802787:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  80278a:	83 ec 0c             	sub    $0xc,%esp
  80278d:	ff 75 d0             	pushl  -0x30(%ebp)
  802790:	e8 49 fa ff ff       	call   8021de <insert_sorted_in_freeList>
  802795:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802798:	83 ec 0c             	sub    $0xc,%esp
  80279b:	ff 75 08             	pushl  0x8(%ebp)
  80279e:	e8 ce fb ff ff       	call   802371 <alloc_block_FF>
  8027a3:	83 c4 10             	add    $0x10,%esp
}
  8027a6:	c9                   	leave  
  8027a7:	c3                   	ret    

008027a8 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8027a8:	55                   	push   %ebp
  8027a9:	89 e5                	mov    %esp,%ebp
  8027ab:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  8027ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027b2:	75 0a                	jne    8027be <alloc_block_BF+0x16>
	{
		return NULL;
  8027b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b9:	e9 7a 02 00 00       	jmp    802a38 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  8027be:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c1:	83 c0 08             	add    $0x8,%eax
  8027c4:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  8027c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  8027ce:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8027d5:	a1 48 50 98 00       	mov    0x985048,%eax
  8027da:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8027dd:	eb 32                	jmp    802811 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  8027df:	ff 75 ec             	pushl  -0x14(%ebp)
  8027e2:	e8 24 f7 ff ff       	call   801f0b <get_block_size>
  8027e7:	83 c4 04             	add    $0x4,%esp
  8027ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  8027ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8027f3:	72 14                	jb     802809 <alloc_block_BF+0x61>
  8027f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027fb:	73 0c                	jae    802809 <alloc_block_BF+0x61>
		{
			minBlk = block;
  8027fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802800:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  802803:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802806:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802809:	a1 50 50 98 00       	mov    0x985050,%eax
  80280e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802811:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802815:	74 07                	je     80281e <alloc_block_BF+0x76>
  802817:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281a:	8b 00                	mov    (%eax),%eax
  80281c:	eb 05                	jmp    802823 <alloc_block_BF+0x7b>
  80281e:	b8 00 00 00 00       	mov    $0x0,%eax
  802823:	a3 50 50 98 00       	mov    %eax,0x985050
  802828:	a1 50 50 98 00       	mov    0x985050,%eax
  80282d:	85 c0                	test   %eax,%eax
  80282f:	75 ae                	jne    8027df <alloc_block_BF+0x37>
  802831:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802835:	75 a8                	jne    8027df <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802837:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80283b:	75 22                	jne    80285f <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  80283d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802840:	83 ec 0c             	sub    $0xc,%esp
  802843:	50                   	push   %eax
  802844:	e8 5a e9 ff ff       	call   8011a3 <sbrk>
  802849:	83 c4 10             	add    $0x10,%esp
  80284c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  80284f:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802853:	75 0a                	jne    80285f <alloc_block_BF+0xb7>
			return NULL;
  802855:	b8 00 00 00 00       	mov    $0x0,%eax
  80285a:	e9 d9 01 00 00       	jmp    802a38 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  80285f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802862:	83 c0 10             	add    $0x10,%eax
  802865:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802868:	0f 87 32 01 00 00    	ja     8029a0 <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  80286e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802871:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802874:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802877:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80287d:	01 d0                	add    %edx,%eax
  80287f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  802882:	83 ec 04             	sub    $0x4,%esp
  802885:	6a 00                	push   $0x0
  802887:	ff 75 dc             	pushl  -0x24(%ebp)
  80288a:	ff 75 d8             	pushl  -0x28(%ebp)
  80288d:	e8 f5 f8 ff ff       	call   802187 <set_block_data>
  802892:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802895:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802899:	74 06                	je     8028a1 <alloc_block_BF+0xf9>
  80289b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80289f:	75 17                	jne    8028b8 <alloc_block_BF+0x110>
  8028a1:	83 ec 04             	sub    $0x4,%esp
  8028a4:	68 2c 3e 80 00       	push   $0x803e2c
  8028a9:	68 49 01 00 00       	push   $0x149
  8028ae:	68 b7 3d 80 00       	push   $0x803db7
  8028b3:	e8 85 0a 00 00       	call   80333d <_panic>
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	8b 10                	mov    (%eax),%edx
  8028bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8028c0:	89 10                	mov    %edx,(%eax)
  8028c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8028c5:	8b 00                	mov    (%eax),%eax
  8028c7:	85 c0                	test   %eax,%eax
  8028c9:	74 0b                	je     8028d6 <alloc_block_BF+0x12e>
  8028cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ce:	8b 00                	mov    (%eax),%eax
  8028d0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8028d3:	89 50 04             	mov    %edx,0x4(%eax)
  8028d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8028dc:	89 10                	mov    %edx,(%eax)
  8028de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8028e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e4:	89 50 04             	mov    %edx,0x4(%eax)
  8028e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8028ea:	8b 00                	mov    (%eax),%eax
  8028ec:	85 c0                	test   %eax,%eax
  8028ee:	75 08                	jne    8028f8 <alloc_block_BF+0x150>
  8028f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8028f3:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8028f8:	a1 54 50 98 00       	mov    0x985054,%eax
  8028fd:	40                   	inc    %eax
  8028fe:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802903:	83 ec 04             	sub    $0x4,%esp
  802906:	6a 01                	push   $0x1
  802908:	ff 75 e8             	pushl  -0x18(%ebp)
  80290b:	ff 75 f4             	pushl  -0xc(%ebp)
  80290e:	e8 74 f8 ff ff       	call   802187 <set_block_data>
  802913:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802916:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80291a:	75 17                	jne    802933 <alloc_block_BF+0x18b>
  80291c:	83 ec 04             	sub    $0x4,%esp
  80291f:	68 60 3e 80 00       	push   $0x803e60
  802924:	68 4e 01 00 00       	push   $0x14e
  802929:	68 b7 3d 80 00       	push   $0x803db7
  80292e:	e8 0a 0a 00 00       	call   80333d <_panic>
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	8b 00                	mov    (%eax),%eax
  802938:	85 c0                	test   %eax,%eax
  80293a:	74 10                	je     80294c <alloc_block_BF+0x1a4>
  80293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293f:	8b 00                	mov    (%eax),%eax
  802941:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802944:	8b 52 04             	mov    0x4(%edx),%edx
  802947:	89 50 04             	mov    %edx,0x4(%eax)
  80294a:	eb 0b                	jmp    802957 <alloc_block_BF+0x1af>
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	8b 40 04             	mov    0x4(%eax),%eax
  802952:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	8b 40 04             	mov    0x4(%eax),%eax
  80295d:	85 c0                	test   %eax,%eax
  80295f:	74 0f                	je     802970 <alloc_block_BF+0x1c8>
  802961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802964:	8b 40 04             	mov    0x4(%eax),%eax
  802967:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80296a:	8b 12                	mov    (%edx),%edx
  80296c:	89 10                	mov    %edx,(%eax)
  80296e:	eb 0a                	jmp    80297a <alloc_block_BF+0x1d2>
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 00                	mov    (%eax),%eax
  802975:	a3 48 50 98 00       	mov    %eax,0x985048
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80298d:	a1 54 50 98 00       	mov    0x985054,%eax
  802992:	48                   	dec    %eax
  802993:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	e9 98 00 00 00       	jmp    802a38 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  8029a0:	83 ec 04             	sub    $0x4,%esp
  8029a3:	6a 01                	push   $0x1
  8029a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8029a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8029ab:	e8 d7 f7 ff ff       	call   802187 <set_block_data>
  8029b0:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  8029b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b7:	75 17                	jne    8029d0 <alloc_block_BF+0x228>
  8029b9:	83 ec 04             	sub    $0x4,%esp
  8029bc:	68 60 3e 80 00       	push   $0x803e60
  8029c1:	68 56 01 00 00       	push   $0x156
  8029c6:	68 b7 3d 80 00       	push   $0x803db7
  8029cb:	e8 6d 09 00 00       	call   80333d <_panic>
  8029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d3:	8b 00                	mov    (%eax),%eax
  8029d5:	85 c0                	test   %eax,%eax
  8029d7:	74 10                	je     8029e9 <alloc_block_BF+0x241>
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	8b 00                	mov    (%eax),%eax
  8029de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029e1:	8b 52 04             	mov    0x4(%edx),%edx
  8029e4:	89 50 04             	mov    %edx,0x4(%eax)
  8029e7:	eb 0b                	jmp    8029f4 <alloc_block_BF+0x24c>
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	8b 40 04             	mov    0x4(%eax),%eax
  8029ef:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f7:	8b 40 04             	mov    0x4(%eax),%eax
  8029fa:	85 c0                	test   %eax,%eax
  8029fc:	74 0f                	je     802a0d <alloc_block_BF+0x265>
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	8b 40 04             	mov    0x4(%eax),%eax
  802a04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a07:	8b 12                	mov    (%edx),%edx
  802a09:	89 10                	mov    %edx,(%eax)
  802a0b:	eb 0a                	jmp    802a17 <alloc_block_BF+0x26f>
  802a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a10:	8b 00                	mov    (%eax),%eax
  802a12:	a3 48 50 98 00       	mov    %eax,0x985048
  802a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a2a:	a1 54 50 98 00       	mov    0x985054,%eax
  802a2f:	48                   	dec    %eax
  802a30:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802a38:	c9                   	leave  
  802a39:	c3                   	ret    

00802a3a <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802a3a:	55                   	push   %ebp
  802a3b:	89 e5                	mov    %esp,%ebp
  802a3d:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802a40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a44:	0f 84 6a 02 00 00    	je     802cb4 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  802a4a:	ff 75 08             	pushl  0x8(%ebp)
  802a4d:	e8 b9 f4 ff ff       	call   801f0b <get_block_size>
  802a52:	83 c4 04             	add    $0x4,%esp
  802a55:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  802a58:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5b:	83 e8 08             	sub    $0x8,%eax
  802a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  802a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a64:	8b 00                	mov    (%eax),%eax
  802a66:	83 e0 fe             	and    $0xfffffffe,%eax
  802a69:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  802a6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6f:	f7 d8                	neg    %eax
  802a71:	89 c2                	mov    %eax,%edx
  802a73:	8b 45 08             	mov    0x8(%ebp),%eax
  802a76:	01 d0                	add    %edx,%eax
  802a78:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802a7b:	ff 75 e8             	pushl  -0x18(%ebp)
  802a7e:	e8 a1 f4 ff ff       	call   801f24 <is_free_block>
  802a83:	83 c4 04             	add    $0x4,%esp
  802a86:	0f be c0             	movsbl %al,%eax
  802a89:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802a8c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a92:	01 d0                	add    %edx,%eax
  802a94:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802a97:	ff 75 e0             	pushl  -0x20(%ebp)
  802a9a:	e8 85 f4 ff ff       	call   801f24 <is_free_block>
  802a9f:	83 c4 04             	add    $0x4,%esp
  802aa2:	0f be c0             	movsbl %al,%eax
  802aa5:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802aa8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802aac:	75 34                	jne    802ae2 <free_block+0xa8>
  802aae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ab2:	75 2e                	jne    802ae2 <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802ab4:	ff 75 e8             	pushl  -0x18(%ebp)
  802ab7:	e8 4f f4 ff ff       	call   801f0b <get_block_size>
  802abc:	83 c4 04             	add    $0x4,%esp
  802abf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802ac2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ac8:	01 d0                	add    %edx,%eax
  802aca:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802acd:	6a 00                	push   $0x0
  802acf:	ff 75 d4             	pushl  -0x2c(%ebp)
  802ad2:	ff 75 e8             	pushl  -0x18(%ebp)
  802ad5:	e8 ad f6 ff ff       	call   802187 <set_block_data>
  802ada:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802add:	e9 d3 01 00 00       	jmp    802cb5 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802ae2:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802ae6:	0f 85 c8 00 00 00    	jne    802bb4 <free_block+0x17a>
  802aec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802af0:	0f 85 be 00 00 00    	jne    802bb4 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802af6:	ff 75 e0             	pushl  -0x20(%ebp)
  802af9:	e8 0d f4 ff ff       	call   801f0b <get_block_size>
  802afe:	83 c4 04             	add    $0x4,%esp
  802b01:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802b04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b07:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b0a:	01 d0                	add    %edx,%eax
  802b0c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802b0f:	6a 00                	push   $0x0
  802b11:	ff 75 cc             	pushl  -0x34(%ebp)
  802b14:	ff 75 08             	pushl  0x8(%ebp)
  802b17:	e8 6b f6 ff ff       	call   802187 <set_block_data>
  802b1c:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802b1f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b23:	75 17                	jne    802b3c <free_block+0x102>
  802b25:	83 ec 04             	sub    $0x4,%esp
  802b28:	68 60 3e 80 00       	push   $0x803e60
  802b2d:	68 87 01 00 00       	push   $0x187
  802b32:	68 b7 3d 80 00       	push   $0x803db7
  802b37:	e8 01 08 00 00       	call   80333d <_panic>
  802b3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b3f:	8b 00                	mov    (%eax),%eax
  802b41:	85 c0                	test   %eax,%eax
  802b43:	74 10                	je     802b55 <free_block+0x11b>
  802b45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b48:	8b 00                	mov    (%eax),%eax
  802b4a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b4d:	8b 52 04             	mov    0x4(%edx),%edx
  802b50:	89 50 04             	mov    %edx,0x4(%eax)
  802b53:	eb 0b                	jmp    802b60 <free_block+0x126>
  802b55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b58:	8b 40 04             	mov    0x4(%eax),%eax
  802b5b:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802b60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b63:	8b 40 04             	mov    0x4(%eax),%eax
  802b66:	85 c0                	test   %eax,%eax
  802b68:	74 0f                	je     802b79 <free_block+0x13f>
  802b6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b6d:	8b 40 04             	mov    0x4(%eax),%eax
  802b70:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b73:	8b 12                	mov    (%edx),%edx
  802b75:	89 10                	mov    %edx,(%eax)
  802b77:	eb 0a                	jmp    802b83 <free_block+0x149>
  802b79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b7c:	8b 00                	mov    (%eax),%eax
  802b7e:	a3 48 50 98 00       	mov    %eax,0x985048
  802b83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b96:	a1 54 50 98 00       	mov    0x985054,%eax
  802b9b:	48                   	dec    %eax
  802b9c:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802ba1:	83 ec 0c             	sub    $0xc,%esp
  802ba4:	ff 75 08             	pushl  0x8(%ebp)
  802ba7:	e8 32 f6 ff ff       	call   8021de <insert_sorted_in_freeList>
  802bac:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802baf:	e9 01 01 00 00       	jmp    802cb5 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  802bb4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802bb8:	0f 85 d3 00 00 00    	jne    802c91 <free_block+0x257>
  802bbe:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802bc2:	0f 85 c9 00 00 00    	jne    802c91 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  802bc8:	83 ec 0c             	sub    $0xc,%esp
  802bcb:	ff 75 e8             	pushl  -0x18(%ebp)
  802bce:	e8 38 f3 ff ff       	call   801f0b <get_block_size>
  802bd3:	83 c4 10             	add    $0x10,%esp
  802bd6:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  802bd9:	83 ec 0c             	sub    $0xc,%esp
  802bdc:	ff 75 e0             	pushl  -0x20(%ebp)
  802bdf:	e8 27 f3 ff ff       	call   801f0b <get_block_size>
  802be4:	83 c4 10             	add    $0x10,%esp
  802be7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  802bea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bed:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802bf0:	01 c2                	add    %eax,%edx
  802bf2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802bf5:	01 d0                	add    %edx,%eax
  802bf7:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  802bfa:	83 ec 04             	sub    $0x4,%esp
  802bfd:	6a 00                	push   $0x0
  802bff:	ff 75 c0             	pushl  -0x40(%ebp)
  802c02:	ff 75 e8             	pushl  -0x18(%ebp)
  802c05:	e8 7d f5 ff ff       	call   802187 <set_block_data>
  802c0a:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  802c0d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c11:	75 17                	jne    802c2a <free_block+0x1f0>
  802c13:	83 ec 04             	sub    $0x4,%esp
  802c16:	68 60 3e 80 00       	push   $0x803e60
  802c1b:	68 94 01 00 00       	push   $0x194
  802c20:	68 b7 3d 80 00       	push   $0x803db7
  802c25:	e8 13 07 00 00       	call   80333d <_panic>
  802c2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c2d:	8b 00                	mov    (%eax),%eax
  802c2f:	85 c0                	test   %eax,%eax
  802c31:	74 10                	je     802c43 <free_block+0x209>
  802c33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c36:	8b 00                	mov    (%eax),%eax
  802c38:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c3b:	8b 52 04             	mov    0x4(%edx),%edx
  802c3e:	89 50 04             	mov    %edx,0x4(%eax)
  802c41:	eb 0b                	jmp    802c4e <free_block+0x214>
  802c43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c46:	8b 40 04             	mov    0x4(%eax),%eax
  802c49:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802c4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c51:	8b 40 04             	mov    0x4(%eax),%eax
  802c54:	85 c0                	test   %eax,%eax
  802c56:	74 0f                	je     802c67 <free_block+0x22d>
  802c58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c5b:	8b 40 04             	mov    0x4(%eax),%eax
  802c5e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c61:	8b 12                	mov    (%edx),%edx
  802c63:	89 10                	mov    %edx,(%eax)
  802c65:	eb 0a                	jmp    802c71 <free_block+0x237>
  802c67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c6a:	8b 00                	mov    (%eax),%eax
  802c6c:	a3 48 50 98 00       	mov    %eax,0x985048
  802c71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c84:	a1 54 50 98 00       	mov    0x985054,%eax
  802c89:	48                   	dec    %eax
  802c8a:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  802c8f:	eb 24                	jmp    802cb5 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  802c91:	83 ec 04             	sub    $0x4,%esp
  802c94:	6a 00                	push   $0x0
  802c96:	ff 75 f4             	pushl  -0xc(%ebp)
  802c99:	ff 75 08             	pushl  0x8(%ebp)
  802c9c:	e8 e6 f4 ff ff       	call   802187 <set_block_data>
  802ca1:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802ca4:	83 ec 0c             	sub    $0xc,%esp
  802ca7:	ff 75 08             	pushl  0x8(%ebp)
  802caa:	e8 2f f5 ff ff       	call   8021de <insert_sorted_in_freeList>
  802caf:	83 c4 10             	add    $0x10,%esp
  802cb2:	eb 01                	jmp    802cb5 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  802cb4:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  802cb5:	c9                   	leave  
  802cb6:	c3                   	ret    

00802cb7 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802cb7:	55                   	push   %ebp
  802cb8:	89 e5                	mov    %esp,%ebp
  802cba:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  802cbd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cc1:	75 10                	jne    802cd3 <realloc_block_FF+0x1c>
  802cc3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cc7:	75 0a                	jne    802cd3 <realloc_block_FF+0x1c>
	{
		return NULL;
  802cc9:	b8 00 00 00 00       	mov    $0x0,%eax
  802cce:	e9 8b 04 00 00       	jmp    80315e <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  802cd3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cd7:	75 18                	jne    802cf1 <realloc_block_FF+0x3a>
	{
		free_block(va);
  802cd9:	83 ec 0c             	sub    $0xc,%esp
  802cdc:	ff 75 08             	pushl  0x8(%ebp)
  802cdf:	e8 56 fd ff ff       	call   802a3a <free_block>
  802ce4:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  802cec:	e9 6d 04 00 00       	jmp    80315e <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  802cf1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cf5:	75 13                	jne    802d0a <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  802cf7:	83 ec 0c             	sub    $0xc,%esp
  802cfa:	ff 75 0c             	pushl  0xc(%ebp)
  802cfd:	e8 6f f6 ff ff       	call   802371 <alloc_block_FF>
  802d02:	83 c4 10             	add    $0x10,%esp
  802d05:	e9 54 04 00 00       	jmp    80315e <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  802d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d0d:	83 e0 01             	and    $0x1,%eax
  802d10:	85 c0                	test   %eax,%eax
  802d12:	74 03                	je     802d17 <realloc_block_FF+0x60>
	{
		new_size++;
  802d14:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  802d17:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802d1b:	77 07                	ja     802d24 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  802d1d:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  802d24:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  802d28:	83 ec 0c             	sub    $0xc,%esp
  802d2b:	ff 75 08             	pushl  0x8(%ebp)
  802d2e:	e8 d8 f1 ff ff       	call   801f0b <get_block_size>
  802d33:	83 c4 10             	add    $0x10,%esp
  802d36:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  802d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d3f:	75 08                	jne    802d49 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  802d41:	8b 45 08             	mov    0x8(%ebp),%eax
  802d44:	e9 15 04 00 00       	jmp    80315e <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  802d49:	8b 55 08             	mov    0x8(%ebp),%edx
  802d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4f:	01 d0                	add    %edx,%eax
  802d51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802d54:	83 ec 0c             	sub    $0xc,%esp
  802d57:	ff 75 f0             	pushl  -0x10(%ebp)
  802d5a:	e8 c5 f1 ff ff       	call   801f24 <is_free_block>
  802d5f:	83 c4 10             	add    $0x10,%esp
  802d62:	0f be c0             	movsbl %al,%eax
  802d65:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  802d68:	83 ec 0c             	sub    $0xc,%esp
  802d6b:	ff 75 f0             	pushl  -0x10(%ebp)
  802d6e:	e8 98 f1 ff ff       	call   801f0b <get_block_size>
  802d73:	83 c4 10             	add    $0x10,%esp
  802d76:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  802d79:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d7c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802d7f:	0f 86 a7 02 00 00    	jbe    80302c <realloc_block_FF+0x375>
	{
		if(isNextFree)
  802d85:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d89:	0f 84 86 02 00 00    	je     803015 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  802d8f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d95:	01 d0                	add    %edx,%eax
  802d97:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d9a:	0f 85 b2 00 00 00    	jne    802e52 <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  802da0:	83 ec 0c             	sub    $0xc,%esp
  802da3:	ff 75 08             	pushl  0x8(%ebp)
  802da6:	e8 79 f1 ff ff       	call   801f24 <is_free_block>
  802dab:	83 c4 10             	add    $0x10,%esp
  802dae:	84 c0                	test   %al,%al
  802db0:	0f 94 c0             	sete   %al
  802db3:	0f b6 c0             	movzbl %al,%eax
  802db6:	83 ec 04             	sub    $0x4,%esp
  802db9:	50                   	push   %eax
  802dba:	ff 75 0c             	pushl  0xc(%ebp)
  802dbd:	ff 75 08             	pushl  0x8(%ebp)
  802dc0:	e8 c2 f3 ff ff       	call   802187 <set_block_data>
  802dc5:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  802dc8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dcc:	75 17                	jne    802de5 <realloc_block_FF+0x12e>
  802dce:	83 ec 04             	sub    $0x4,%esp
  802dd1:	68 60 3e 80 00       	push   $0x803e60
  802dd6:	68 db 01 00 00       	push   $0x1db
  802ddb:	68 b7 3d 80 00       	push   $0x803db7
  802de0:	e8 58 05 00 00       	call   80333d <_panic>
  802de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de8:	8b 00                	mov    (%eax),%eax
  802dea:	85 c0                	test   %eax,%eax
  802dec:	74 10                	je     802dfe <realloc_block_FF+0x147>
  802dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df1:	8b 00                	mov    (%eax),%eax
  802df3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802df6:	8b 52 04             	mov    0x4(%edx),%edx
  802df9:	89 50 04             	mov    %edx,0x4(%eax)
  802dfc:	eb 0b                	jmp    802e09 <realloc_block_FF+0x152>
  802dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e01:	8b 40 04             	mov    0x4(%eax),%eax
  802e04:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0c:	8b 40 04             	mov    0x4(%eax),%eax
  802e0f:	85 c0                	test   %eax,%eax
  802e11:	74 0f                	je     802e22 <realloc_block_FF+0x16b>
  802e13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e16:	8b 40 04             	mov    0x4(%eax),%eax
  802e19:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e1c:	8b 12                	mov    (%edx),%edx
  802e1e:	89 10                	mov    %edx,(%eax)
  802e20:	eb 0a                	jmp    802e2c <realloc_block_FF+0x175>
  802e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e25:	8b 00                	mov    (%eax),%eax
  802e27:	a3 48 50 98 00       	mov    %eax,0x985048
  802e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e3f:	a1 54 50 98 00       	mov    0x985054,%eax
  802e44:	48                   	dec    %eax
  802e45:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  802e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4d:	e9 0c 03 00 00       	jmp    80315e <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  802e52:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e58:	01 d0                	add    %edx,%eax
  802e5a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e5d:	0f 86 b2 01 00 00    	jbe    803015 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  802e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e66:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802e69:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  802e6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e6f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802e72:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  802e75:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  802e79:	0f 87 b8 00 00 00    	ja     802f37 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  802e7f:	83 ec 0c             	sub    $0xc,%esp
  802e82:	ff 75 08             	pushl  0x8(%ebp)
  802e85:	e8 9a f0 ff ff       	call   801f24 <is_free_block>
  802e8a:	83 c4 10             	add    $0x10,%esp
  802e8d:	84 c0                	test   %al,%al
  802e8f:	0f 94 c0             	sete   %al
  802e92:	0f b6 c0             	movzbl %al,%eax
  802e95:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802e98:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e9b:	01 ca                	add    %ecx,%edx
  802e9d:	83 ec 04             	sub    $0x4,%esp
  802ea0:	50                   	push   %eax
  802ea1:	52                   	push   %edx
  802ea2:	ff 75 08             	pushl  0x8(%ebp)
  802ea5:	e8 dd f2 ff ff       	call   802187 <set_block_data>
  802eaa:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  802ead:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eb1:	75 17                	jne    802eca <realloc_block_FF+0x213>
  802eb3:	83 ec 04             	sub    $0x4,%esp
  802eb6:	68 60 3e 80 00       	push   $0x803e60
  802ebb:	68 e8 01 00 00       	push   $0x1e8
  802ec0:	68 b7 3d 80 00       	push   $0x803db7
  802ec5:	e8 73 04 00 00       	call   80333d <_panic>
  802eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecd:	8b 00                	mov    (%eax),%eax
  802ecf:	85 c0                	test   %eax,%eax
  802ed1:	74 10                	je     802ee3 <realloc_block_FF+0x22c>
  802ed3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed6:	8b 00                	mov    (%eax),%eax
  802ed8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802edb:	8b 52 04             	mov    0x4(%edx),%edx
  802ede:	89 50 04             	mov    %edx,0x4(%eax)
  802ee1:	eb 0b                	jmp    802eee <realloc_block_FF+0x237>
  802ee3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee6:	8b 40 04             	mov    0x4(%eax),%eax
  802ee9:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef1:	8b 40 04             	mov    0x4(%eax),%eax
  802ef4:	85 c0                	test   %eax,%eax
  802ef6:	74 0f                	je     802f07 <realloc_block_FF+0x250>
  802ef8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efb:	8b 40 04             	mov    0x4(%eax),%eax
  802efe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f01:	8b 12                	mov    (%edx),%edx
  802f03:	89 10                	mov    %edx,(%eax)
  802f05:	eb 0a                	jmp    802f11 <realloc_block_FF+0x25a>
  802f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0a:	8b 00                	mov    (%eax),%eax
  802f0c:	a3 48 50 98 00       	mov    %eax,0x985048
  802f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f24:	a1 54 50 98 00       	mov    0x985054,%eax
  802f29:	48                   	dec    %eax
  802f2a:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  802f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f32:	e9 27 02 00 00       	jmp    80315e <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  802f37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f3b:	75 17                	jne    802f54 <realloc_block_FF+0x29d>
  802f3d:	83 ec 04             	sub    $0x4,%esp
  802f40:	68 60 3e 80 00       	push   $0x803e60
  802f45:	68 ed 01 00 00       	push   $0x1ed
  802f4a:	68 b7 3d 80 00       	push   $0x803db7
  802f4f:	e8 e9 03 00 00       	call   80333d <_panic>
  802f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f57:	8b 00                	mov    (%eax),%eax
  802f59:	85 c0                	test   %eax,%eax
  802f5b:	74 10                	je     802f6d <realloc_block_FF+0x2b6>
  802f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f60:	8b 00                	mov    (%eax),%eax
  802f62:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f65:	8b 52 04             	mov    0x4(%edx),%edx
  802f68:	89 50 04             	mov    %edx,0x4(%eax)
  802f6b:	eb 0b                	jmp    802f78 <realloc_block_FF+0x2c1>
  802f6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f70:	8b 40 04             	mov    0x4(%eax),%eax
  802f73:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802f78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7b:	8b 40 04             	mov    0x4(%eax),%eax
  802f7e:	85 c0                	test   %eax,%eax
  802f80:	74 0f                	je     802f91 <realloc_block_FF+0x2da>
  802f82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f85:	8b 40 04             	mov    0x4(%eax),%eax
  802f88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f8b:	8b 12                	mov    (%edx),%edx
  802f8d:	89 10                	mov    %edx,(%eax)
  802f8f:	eb 0a                	jmp    802f9b <realloc_block_FF+0x2e4>
  802f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f94:	8b 00                	mov    (%eax),%eax
  802f96:	a3 48 50 98 00       	mov    %eax,0x985048
  802f9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fae:	a1 54 50 98 00       	mov    0x985054,%eax
  802fb3:	48                   	dec    %eax
  802fb4:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  802fb9:	8b 55 08             	mov    0x8(%ebp),%edx
  802fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fbf:	01 d0                	add    %edx,%eax
  802fc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  802fc4:	83 ec 04             	sub    $0x4,%esp
  802fc7:	6a 00                	push   $0x0
  802fc9:	ff 75 e0             	pushl  -0x20(%ebp)
  802fcc:	ff 75 f0             	pushl  -0x10(%ebp)
  802fcf:	e8 b3 f1 ff ff       	call   802187 <set_block_data>
  802fd4:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  802fd7:	83 ec 0c             	sub    $0xc,%esp
  802fda:	ff 75 08             	pushl  0x8(%ebp)
  802fdd:	e8 42 ef ff ff       	call   801f24 <is_free_block>
  802fe2:	83 c4 10             	add    $0x10,%esp
  802fe5:	84 c0                	test   %al,%al
  802fe7:	0f 94 c0             	sete   %al
  802fea:	0f b6 c0             	movzbl %al,%eax
  802fed:	83 ec 04             	sub    $0x4,%esp
  802ff0:	50                   	push   %eax
  802ff1:	ff 75 0c             	pushl  0xc(%ebp)
  802ff4:	ff 75 08             	pushl  0x8(%ebp)
  802ff7:	e8 8b f1 ff ff       	call   802187 <set_block_data>
  802ffc:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  802fff:	83 ec 0c             	sub    $0xc,%esp
  803002:	ff 75 f0             	pushl  -0x10(%ebp)
  803005:	e8 d4 f1 ff ff       	call   8021de <insert_sorted_in_freeList>
  80300a:	83 c4 10             	add    $0x10,%esp
					return va;
  80300d:	8b 45 08             	mov    0x8(%ebp),%eax
  803010:	e9 49 01 00 00       	jmp    80315e <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803015:	8b 45 0c             	mov    0xc(%ebp),%eax
  803018:	83 e8 08             	sub    $0x8,%eax
  80301b:	83 ec 0c             	sub    $0xc,%esp
  80301e:	50                   	push   %eax
  80301f:	e8 4d f3 ff ff       	call   802371 <alloc_block_FF>
  803024:	83 c4 10             	add    $0x10,%esp
  803027:	e9 32 01 00 00       	jmp    80315e <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  80302c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80302f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803032:	0f 83 21 01 00 00    	jae    803159 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  803038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303b:	2b 45 0c             	sub    0xc(%ebp),%eax
  80303e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  803041:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  803045:	77 0e                	ja     803055 <realloc_block_FF+0x39e>
  803047:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80304b:	75 08                	jne    803055 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  80304d:	8b 45 08             	mov    0x8(%ebp),%eax
  803050:	e9 09 01 00 00       	jmp    80315e <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  803055:	8b 45 08             	mov    0x8(%ebp),%eax
  803058:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  80305b:	83 ec 0c             	sub    $0xc,%esp
  80305e:	ff 75 08             	pushl  0x8(%ebp)
  803061:	e8 be ee ff ff       	call   801f24 <is_free_block>
  803066:	83 c4 10             	add    $0x10,%esp
  803069:	84 c0                	test   %al,%al
  80306b:	0f 94 c0             	sete   %al
  80306e:	0f b6 c0             	movzbl %al,%eax
  803071:	83 ec 04             	sub    $0x4,%esp
  803074:	50                   	push   %eax
  803075:	ff 75 0c             	pushl  0xc(%ebp)
  803078:	ff 75 d8             	pushl  -0x28(%ebp)
  80307b:	e8 07 f1 ff ff       	call   802187 <set_block_data>
  803080:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  803083:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803086:	8b 45 0c             	mov    0xc(%ebp),%eax
  803089:	01 d0                	add    %edx,%eax
  80308b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  80308e:	83 ec 04             	sub    $0x4,%esp
  803091:	6a 00                	push   $0x0
  803093:	ff 75 dc             	pushl  -0x24(%ebp)
  803096:	ff 75 d4             	pushl  -0x2c(%ebp)
  803099:	e8 e9 f0 ff ff       	call   802187 <set_block_data>
  80309e:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  8030a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030a5:	0f 84 9b 00 00 00    	je     803146 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  8030ab:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b1:	01 d0                	add    %edx,%eax
  8030b3:	83 ec 04             	sub    $0x4,%esp
  8030b6:	6a 00                	push   $0x0
  8030b8:	50                   	push   %eax
  8030b9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8030bc:	e8 c6 f0 ff ff       	call   802187 <set_block_data>
  8030c1:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  8030c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030c8:	75 17                	jne    8030e1 <realloc_block_FF+0x42a>
  8030ca:	83 ec 04             	sub    $0x4,%esp
  8030cd:	68 60 3e 80 00       	push   $0x803e60
  8030d2:	68 10 02 00 00       	push   $0x210
  8030d7:	68 b7 3d 80 00       	push   $0x803db7
  8030dc:	e8 5c 02 00 00       	call   80333d <_panic>
  8030e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e4:	8b 00                	mov    (%eax),%eax
  8030e6:	85 c0                	test   %eax,%eax
  8030e8:	74 10                	je     8030fa <realloc_block_FF+0x443>
  8030ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ed:	8b 00                	mov    (%eax),%eax
  8030ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030f2:	8b 52 04             	mov    0x4(%edx),%edx
  8030f5:	89 50 04             	mov    %edx,0x4(%eax)
  8030f8:	eb 0b                	jmp    803105 <realloc_block_FF+0x44e>
  8030fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fd:	8b 40 04             	mov    0x4(%eax),%eax
  803100:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803105:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803108:	8b 40 04             	mov    0x4(%eax),%eax
  80310b:	85 c0                	test   %eax,%eax
  80310d:	74 0f                	je     80311e <realloc_block_FF+0x467>
  80310f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803112:	8b 40 04             	mov    0x4(%eax),%eax
  803115:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803118:	8b 12                	mov    (%edx),%edx
  80311a:	89 10                	mov    %edx,(%eax)
  80311c:	eb 0a                	jmp    803128 <realloc_block_FF+0x471>
  80311e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803121:	8b 00                	mov    (%eax),%eax
  803123:	a3 48 50 98 00       	mov    %eax,0x985048
  803128:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803131:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803134:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313b:	a1 54 50 98 00       	mov    0x985054,%eax
  803140:	48                   	dec    %eax
  803141:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  803146:	83 ec 0c             	sub    $0xc,%esp
  803149:	ff 75 d4             	pushl  -0x2c(%ebp)
  80314c:	e8 8d f0 ff ff       	call   8021de <insert_sorted_in_freeList>
  803151:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  803154:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803157:	eb 05                	jmp    80315e <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  803159:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80315e:	c9                   	leave  
  80315f:	c3                   	ret    

00803160 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803160:	55                   	push   %ebp
  803161:	89 e5                	mov    %esp,%ebp
  803163:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803166:	83 ec 04             	sub    $0x4,%esp
  803169:	68 80 3e 80 00       	push   $0x803e80
  80316e:	68 20 02 00 00       	push   $0x220
  803173:	68 b7 3d 80 00       	push   $0x803db7
  803178:	e8 c0 01 00 00       	call   80333d <_panic>

0080317d <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80317d:	55                   	push   %ebp
  80317e:	89 e5                	mov    %esp,%ebp
  803180:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803183:	83 ec 04             	sub    $0x4,%esp
  803186:	68 a8 3e 80 00       	push   $0x803ea8
  80318b:	68 28 02 00 00       	push   $0x228
  803190:	68 b7 3d 80 00       	push   $0x803db7
  803195:	e8 a3 01 00 00       	call   80333d <_panic>

0080319a <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80319a:	55                   	push   %ebp
  80319b:	89 e5                	mov    %esp,%ebp
  80319d:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("create_semaphore is not implemented yet");
	//Your Code is Here...

	//create object of __semdata struct and allocate it using smalloc with sizeof __semdata struct
	struct __semdata* semaphoryData = (struct __semdata *)smalloc(semaphoreName , sizeof(struct __semdata) ,1);
  8031a0:	83 ec 04             	sub    $0x4,%esp
  8031a3:	6a 01                	push   $0x1
  8031a5:	6a 58                	push   $0x58
  8031a7:	ff 75 0c             	pushl  0xc(%ebp)
  8031aa:	e8 c1 e2 ff ff       	call   801470 <smalloc>
  8031af:	83 c4 10             	add    $0x10,%esp
  8031b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  8031b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031b9:	75 14                	jne    8031cf <create_semaphore+0x35>
	{
		panic("Not Enough Space to allocate semdata object!!");
  8031bb:	83 ec 04             	sub    $0x4,%esp
  8031be:	68 d0 3e 80 00       	push   $0x803ed0
  8031c3:	6a 10                	push   $0x10
  8031c5:	68 fe 3e 80 00       	push   $0x803efe
  8031ca:	e8 6e 01 00 00       	call   80333d <_panic>
	}
	//aboveObject.queue pass it to init_queue() function
	sys_init_queue(&(semaphoryData->queue));
  8031cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d2:	83 ec 0c             	sub    $0xc,%esp
  8031d5:	50                   	push   %eax
  8031d6:	e8 bc ec ff ff       	call   801e97 <sys_init_queue>
  8031db:	83 c4 10             	add    $0x10,%esp
	//lock variable initially with zero
	semaphoryData->lock = 0;
  8031de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e1:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
	//initialize aboveObject with semaphore name and value
	strncpy(semaphoryData->name , semaphoreName , sizeof(semaphoryData->name));
  8031e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031eb:	83 c0 18             	add    $0x18,%eax
  8031ee:	83 ec 04             	sub    $0x4,%esp
  8031f1:	6a 40                	push   $0x40
  8031f3:	ff 75 0c             	pushl  0xc(%ebp)
  8031f6:	50                   	push   %eax
  8031f7:	e8 1e d9 ff ff       	call   800b1a <strncpy>
  8031fc:	83 c4 10             	add    $0x10,%esp
	semaphoryData->count = value;
  8031ff:	8b 55 10             	mov    0x10(%ebp),%edx
  803202:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803205:	89 50 10             	mov    %edx,0x10(%eax)

	//create object of semaphore struct
	struct semaphore semaphory;
	//add aboveObject to this semaphore object
	semaphory.semdata = semaphoryData;
  803208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//return semaphore object
	return semaphory;
  80320e:	8b 45 08             	mov    0x8(%ebp),%eax
  803211:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803214:	89 10                	mov    %edx,(%eax)
}
  803216:	8b 45 08             	mov    0x8(%ebp),%eax
  803219:	c9                   	leave  
  80321a:	c2 04 00             	ret    $0x4

0080321d <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80321d:	55                   	push   %ebp
  80321e:	89 e5                	mov    %esp,%ebp
  803220:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("get_semaphore is not implemented yet");
	//Your Code is Here...

	// get the semdata object that is allocated, using sget
	struct __semdata* semaphoryData = sget(ownerEnvID, semaphoreName);
  803223:	83 ec 08             	sub    $0x8,%esp
  803226:	ff 75 10             	pushl  0x10(%ebp)
  803229:	ff 75 0c             	pushl  0xc(%ebp)
  80322c:	e8 da e3 ff ff       	call   80160b <sget>
  803231:	83 c4 10             	add    $0x10,%esp
  803234:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  803237:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80323b:	75 14                	jne    803251 <get_semaphore+0x34>
	{
		panic("semdatat object does not exist!!");
  80323d:	83 ec 04             	sub    $0x4,%esp
  803240:	68 10 3f 80 00       	push   $0x803f10
  803245:	6a 2c                	push   $0x2c
  803247:	68 fe 3e 80 00       	push   $0x803efe
  80324c:	e8 ec 00 00 00       	call   80333d <_panic>
	}
	//create object of semaphore struct
	struct semaphore semaphory;
	//add semdata object to this semaphore object
	semaphory.semdata = semaphoryData;
  803251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803254:	89 45 f0             	mov    %eax,-0x10(%ebp)
	return semaphory;
  803257:	8b 45 08             	mov    0x8(%ebp),%eax
  80325a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80325d:	89 10                	mov    %edx,(%eax)
}
  80325f:	8b 45 08             	mov    0x8(%ebp),%eax
  803262:	c9                   	leave  
  803263:	c2 04 00             	ret    $0x4

00803266 <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  803266:	55                   	push   %ebp
  803267:	89 e5                	mov    %esp,%ebp
  803269:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("wait_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  80326c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  803273:	8b 45 08             	mov    0x8(%ebp),%eax
  803276:	8b 40 14             	mov    0x14(%eax),%eax
  803279:	8d 55 e8             	lea    -0x18(%ebp),%edx
  80327c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80327f:	89 45 f0             	mov    %eax,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803282:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803285:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803288:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80328b:	f0 87 02             	lock xchg %eax,(%edx)
  80328e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  803291:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803294:	85 c0                	test   %eax,%eax
  803296:	75 db                	jne    803273 <wait_semaphore+0xd>

	//decrement the semaphore counter
	sem.semdata->count--;
  803298:	8b 45 08             	mov    0x8(%ebp),%eax
  80329b:	8b 50 10             	mov    0x10(%eax),%edx
  80329e:	4a                   	dec    %edx
  80329f:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count < 0)
  8032a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a5:	8b 40 10             	mov    0x10(%eax),%eax
  8032a8:	85 c0                	test   %eax,%eax
  8032aa:	79 18                	jns    8032c4 <wait_semaphore+0x5e>
	{
		// block the current process
		sys_block_process(&(sem.semdata->queue),&(sem.semdata->lock));
  8032ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8032af:	8d 50 14             	lea    0x14(%eax),%edx
  8032b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b5:	83 ec 08             	sub    $0x8,%esp
  8032b8:	52                   	push   %edx
  8032b9:	50                   	push   %eax
  8032ba:	e8 f4 eb ff ff       	call   801eb3 <sys_block_process>
  8032bf:	83 c4 10             	add    $0x10,%esp
  8032c2:	eb 0a                	jmp    8032ce <wait_semaphore+0x68>
		return;
	}
	//release semaphore lock
	sem.semdata->lock = 0;
  8032c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c7:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  8032ce:	c9                   	leave  
  8032cf:	c3                   	ret    

008032d0 <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  8032d0:	55                   	push   %ebp
  8032d1:	89 e5                	mov    %esp,%ebp
  8032d3:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("signal_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  8032d6:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  8032dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e0:	8b 40 14             	mov    0x14(%eax),%eax
  8032e3:	8d 55 e8             	lea    -0x18(%ebp),%edx
  8032e6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8032e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8032ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8032f5:	f0 87 02             	lock xchg %eax,(%edx)
  8032f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  8032fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fe:	85 c0                	test   %eax,%eax
  803300:	75 db                	jne    8032dd <signal_semaphore+0xd>

	// increment the semaphore counter
	sem.semdata->count++;
  803302:	8b 45 08             	mov    0x8(%ebp),%eax
  803305:	8b 50 10             	mov    0x10(%eax),%edx
  803308:	42                   	inc    %edx
  803309:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count <= 0) {
  80330c:	8b 45 08             	mov    0x8(%ebp),%eax
  80330f:	8b 40 10             	mov    0x10(%eax),%eax
  803312:	85 c0                	test   %eax,%eax
  803314:	7f 0f                	jg     803325 <signal_semaphore+0x55>
		// unblock the current process
		sys_unblock_process(&(sem.semdata->queue));
  803316:	8b 45 08             	mov    0x8(%ebp),%eax
  803319:	83 ec 0c             	sub    $0xc,%esp
  80331c:	50                   	push   %eax
  80331d:	e8 af eb ff ff       	call   801ed1 <sys_unblock_process>
  803322:	83 c4 10             	add    $0x10,%esp
	}

	// release the lock
	sem.semdata->lock = 0;
  803325:	8b 45 08             	mov    0x8(%ebp),%eax
  803328:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  80332f:	90                   	nop
  803330:	c9                   	leave  
  803331:	c3                   	ret    

00803332 <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  803332:	55                   	push   %ebp
  803333:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803335:	8b 45 08             	mov    0x8(%ebp),%eax
  803338:	8b 40 10             	mov    0x10(%eax),%eax
}
  80333b:	5d                   	pop    %ebp
  80333c:	c3                   	ret    

0080333d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80333d:	55                   	push   %ebp
  80333e:	89 e5                	mov    %esp,%ebp
  803340:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803343:	8d 45 10             	lea    0x10(%ebp),%eax
  803346:	83 c0 04             	add    $0x4,%eax
  803349:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80334c:	a1 60 50 98 00       	mov    0x985060,%eax
  803351:	85 c0                	test   %eax,%eax
  803353:	74 16                	je     80336b <_panic+0x2e>
		cprintf("%s: ", argv0);
  803355:	a1 60 50 98 00       	mov    0x985060,%eax
  80335a:	83 ec 08             	sub    $0x8,%esp
  80335d:	50                   	push   %eax
  80335e:	68 34 3f 80 00       	push   $0x803f34
  803363:	e8 a1 d0 ff ff       	call   800409 <cprintf>
  803368:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80336b:	a1 04 50 80 00       	mov    0x805004,%eax
  803370:	ff 75 0c             	pushl  0xc(%ebp)
  803373:	ff 75 08             	pushl  0x8(%ebp)
  803376:	50                   	push   %eax
  803377:	68 39 3f 80 00       	push   $0x803f39
  80337c:	e8 88 d0 ff ff       	call   800409 <cprintf>
  803381:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803384:	8b 45 10             	mov    0x10(%ebp),%eax
  803387:	83 ec 08             	sub    $0x8,%esp
  80338a:	ff 75 f4             	pushl  -0xc(%ebp)
  80338d:	50                   	push   %eax
  80338e:	e8 0b d0 ff ff       	call   80039e <vcprintf>
  803393:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803396:	83 ec 08             	sub    $0x8,%esp
  803399:	6a 00                	push   $0x0
  80339b:	68 55 3f 80 00       	push   $0x803f55
  8033a0:	e8 f9 cf ff ff       	call   80039e <vcprintf>
  8033a5:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8033a8:	e8 7a cf ff ff       	call   800327 <exit>

	// should not return here
	while (1) ;
  8033ad:	eb fe                	jmp    8033ad <_panic+0x70>

008033af <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8033af:	55                   	push   %ebp
  8033b0:	89 e5                	mov    %esp,%ebp
  8033b2:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8033b5:	a1 20 50 80 00       	mov    0x805020,%eax
  8033ba:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8033c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c3:	39 c2                	cmp    %eax,%edx
  8033c5:	74 14                	je     8033db <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8033c7:	83 ec 04             	sub    $0x4,%esp
  8033ca:	68 58 3f 80 00       	push   $0x803f58
  8033cf:	6a 26                	push   $0x26
  8033d1:	68 a4 3f 80 00       	push   $0x803fa4
  8033d6:	e8 62 ff ff ff       	call   80333d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8033db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8033e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8033e9:	e9 c5 00 00 00       	jmp    8034b3 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8033ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fb:	01 d0                	add    %edx,%eax
  8033fd:	8b 00                	mov    (%eax),%eax
  8033ff:	85 c0                	test   %eax,%eax
  803401:	75 08                	jne    80340b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803403:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803406:	e9 a5 00 00 00       	jmp    8034b0 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80340b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803412:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803419:	eb 69                	jmp    803484 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80341b:	a1 20 50 80 00       	mov    0x805020,%eax
  803420:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  803426:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803429:	89 d0                	mov    %edx,%eax
  80342b:	01 c0                	add    %eax,%eax
  80342d:	01 d0                	add    %edx,%eax
  80342f:	c1 e0 03             	shl    $0x3,%eax
  803432:	01 c8                	add    %ecx,%eax
  803434:	8a 40 04             	mov    0x4(%eax),%al
  803437:	84 c0                	test   %al,%al
  803439:	75 46                	jne    803481 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80343b:	a1 20 50 80 00       	mov    0x805020,%eax
  803440:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  803446:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803449:	89 d0                	mov    %edx,%eax
  80344b:	01 c0                	add    %eax,%eax
  80344d:	01 d0                	add    %edx,%eax
  80344f:	c1 e0 03             	shl    $0x3,%eax
  803452:	01 c8                	add    %ecx,%eax
  803454:	8b 00                	mov    (%eax),%eax
  803456:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803459:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80345c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803461:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803466:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80346d:	8b 45 08             	mov    0x8(%ebp),%eax
  803470:	01 c8                	add    %ecx,%eax
  803472:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803474:	39 c2                	cmp    %eax,%edx
  803476:	75 09                	jne    803481 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803478:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80347f:	eb 15                	jmp    803496 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803481:	ff 45 e8             	incl   -0x18(%ebp)
  803484:	a1 20 50 80 00       	mov    0x805020,%eax
  803489:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80348f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803492:	39 c2                	cmp    %eax,%edx
  803494:	77 85                	ja     80341b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803496:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80349a:	75 14                	jne    8034b0 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80349c:	83 ec 04             	sub    $0x4,%esp
  80349f:	68 b0 3f 80 00       	push   $0x803fb0
  8034a4:	6a 3a                	push   $0x3a
  8034a6:	68 a4 3f 80 00       	push   $0x803fa4
  8034ab:	e8 8d fe ff ff       	call   80333d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8034b0:	ff 45 f0             	incl   -0x10(%ebp)
  8034b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8034b9:	0f 8c 2f ff ff ff    	jl     8033ee <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8034bf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8034c6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8034cd:	eb 26                	jmp    8034f5 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8034cf:	a1 20 50 80 00       	mov    0x805020,%eax
  8034d4:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8034da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034dd:	89 d0                	mov    %edx,%eax
  8034df:	01 c0                	add    %eax,%eax
  8034e1:	01 d0                	add    %edx,%eax
  8034e3:	c1 e0 03             	shl    $0x3,%eax
  8034e6:	01 c8                	add    %ecx,%eax
  8034e8:	8a 40 04             	mov    0x4(%eax),%al
  8034eb:	3c 01                	cmp    $0x1,%al
  8034ed:	75 03                	jne    8034f2 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8034ef:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8034f2:	ff 45 e0             	incl   -0x20(%ebp)
  8034f5:	a1 20 50 80 00       	mov    0x805020,%eax
  8034fa:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803500:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803503:	39 c2                	cmp    %eax,%edx
  803505:	77 c8                	ja     8034cf <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80350d:	74 14                	je     803523 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80350f:	83 ec 04             	sub    $0x4,%esp
  803512:	68 04 40 80 00       	push   $0x804004
  803517:	6a 44                	push   $0x44
  803519:	68 a4 3f 80 00       	push   $0x803fa4
  80351e:	e8 1a fe ff ff       	call   80333d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803523:	90                   	nop
  803524:	c9                   	leave  
  803525:	c3                   	ret    
  803526:	66 90                	xchg   %ax,%ax

00803528 <__udivdi3>:
  803528:	55                   	push   %ebp
  803529:	57                   	push   %edi
  80352a:	56                   	push   %esi
  80352b:	53                   	push   %ebx
  80352c:	83 ec 1c             	sub    $0x1c,%esp
  80352f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803533:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803537:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80353b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80353f:	89 ca                	mov    %ecx,%edx
  803541:	89 f8                	mov    %edi,%eax
  803543:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803547:	85 f6                	test   %esi,%esi
  803549:	75 2d                	jne    803578 <__udivdi3+0x50>
  80354b:	39 cf                	cmp    %ecx,%edi
  80354d:	77 65                	ja     8035b4 <__udivdi3+0x8c>
  80354f:	89 fd                	mov    %edi,%ebp
  803551:	85 ff                	test   %edi,%edi
  803553:	75 0b                	jne    803560 <__udivdi3+0x38>
  803555:	b8 01 00 00 00       	mov    $0x1,%eax
  80355a:	31 d2                	xor    %edx,%edx
  80355c:	f7 f7                	div    %edi
  80355e:	89 c5                	mov    %eax,%ebp
  803560:	31 d2                	xor    %edx,%edx
  803562:	89 c8                	mov    %ecx,%eax
  803564:	f7 f5                	div    %ebp
  803566:	89 c1                	mov    %eax,%ecx
  803568:	89 d8                	mov    %ebx,%eax
  80356a:	f7 f5                	div    %ebp
  80356c:	89 cf                	mov    %ecx,%edi
  80356e:	89 fa                	mov    %edi,%edx
  803570:	83 c4 1c             	add    $0x1c,%esp
  803573:	5b                   	pop    %ebx
  803574:	5e                   	pop    %esi
  803575:	5f                   	pop    %edi
  803576:	5d                   	pop    %ebp
  803577:	c3                   	ret    
  803578:	39 ce                	cmp    %ecx,%esi
  80357a:	77 28                	ja     8035a4 <__udivdi3+0x7c>
  80357c:	0f bd fe             	bsr    %esi,%edi
  80357f:	83 f7 1f             	xor    $0x1f,%edi
  803582:	75 40                	jne    8035c4 <__udivdi3+0x9c>
  803584:	39 ce                	cmp    %ecx,%esi
  803586:	72 0a                	jb     803592 <__udivdi3+0x6a>
  803588:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80358c:	0f 87 9e 00 00 00    	ja     803630 <__udivdi3+0x108>
  803592:	b8 01 00 00 00       	mov    $0x1,%eax
  803597:	89 fa                	mov    %edi,%edx
  803599:	83 c4 1c             	add    $0x1c,%esp
  80359c:	5b                   	pop    %ebx
  80359d:	5e                   	pop    %esi
  80359e:	5f                   	pop    %edi
  80359f:	5d                   	pop    %ebp
  8035a0:	c3                   	ret    
  8035a1:	8d 76 00             	lea    0x0(%esi),%esi
  8035a4:	31 ff                	xor    %edi,%edi
  8035a6:	31 c0                	xor    %eax,%eax
  8035a8:	89 fa                	mov    %edi,%edx
  8035aa:	83 c4 1c             	add    $0x1c,%esp
  8035ad:	5b                   	pop    %ebx
  8035ae:	5e                   	pop    %esi
  8035af:	5f                   	pop    %edi
  8035b0:	5d                   	pop    %ebp
  8035b1:	c3                   	ret    
  8035b2:	66 90                	xchg   %ax,%ax
  8035b4:	89 d8                	mov    %ebx,%eax
  8035b6:	f7 f7                	div    %edi
  8035b8:	31 ff                	xor    %edi,%edi
  8035ba:	89 fa                	mov    %edi,%edx
  8035bc:	83 c4 1c             	add    $0x1c,%esp
  8035bf:	5b                   	pop    %ebx
  8035c0:	5e                   	pop    %esi
  8035c1:	5f                   	pop    %edi
  8035c2:	5d                   	pop    %ebp
  8035c3:	c3                   	ret    
  8035c4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8035c9:	89 eb                	mov    %ebp,%ebx
  8035cb:	29 fb                	sub    %edi,%ebx
  8035cd:	89 f9                	mov    %edi,%ecx
  8035cf:	d3 e6                	shl    %cl,%esi
  8035d1:	89 c5                	mov    %eax,%ebp
  8035d3:	88 d9                	mov    %bl,%cl
  8035d5:	d3 ed                	shr    %cl,%ebp
  8035d7:	89 e9                	mov    %ebp,%ecx
  8035d9:	09 f1                	or     %esi,%ecx
  8035db:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8035df:	89 f9                	mov    %edi,%ecx
  8035e1:	d3 e0                	shl    %cl,%eax
  8035e3:	89 c5                	mov    %eax,%ebp
  8035e5:	89 d6                	mov    %edx,%esi
  8035e7:	88 d9                	mov    %bl,%cl
  8035e9:	d3 ee                	shr    %cl,%esi
  8035eb:	89 f9                	mov    %edi,%ecx
  8035ed:	d3 e2                	shl    %cl,%edx
  8035ef:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035f3:	88 d9                	mov    %bl,%cl
  8035f5:	d3 e8                	shr    %cl,%eax
  8035f7:	09 c2                	or     %eax,%edx
  8035f9:	89 d0                	mov    %edx,%eax
  8035fb:	89 f2                	mov    %esi,%edx
  8035fd:	f7 74 24 0c          	divl   0xc(%esp)
  803601:	89 d6                	mov    %edx,%esi
  803603:	89 c3                	mov    %eax,%ebx
  803605:	f7 e5                	mul    %ebp
  803607:	39 d6                	cmp    %edx,%esi
  803609:	72 19                	jb     803624 <__udivdi3+0xfc>
  80360b:	74 0b                	je     803618 <__udivdi3+0xf0>
  80360d:	89 d8                	mov    %ebx,%eax
  80360f:	31 ff                	xor    %edi,%edi
  803611:	e9 58 ff ff ff       	jmp    80356e <__udivdi3+0x46>
  803616:	66 90                	xchg   %ax,%ax
  803618:	8b 54 24 08          	mov    0x8(%esp),%edx
  80361c:	89 f9                	mov    %edi,%ecx
  80361e:	d3 e2                	shl    %cl,%edx
  803620:	39 c2                	cmp    %eax,%edx
  803622:	73 e9                	jae    80360d <__udivdi3+0xe5>
  803624:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803627:	31 ff                	xor    %edi,%edi
  803629:	e9 40 ff ff ff       	jmp    80356e <__udivdi3+0x46>
  80362e:	66 90                	xchg   %ax,%ax
  803630:	31 c0                	xor    %eax,%eax
  803632:	e9 37 ff ff ff       	jmp    80356e <__udivdi3+0x46>
  803637:	90                   	nop

00803638 <__umoddi3>:
  803638:	55                   	push   %ebp
  803639:	57                   	push   %edi
  80363a:	56                   	push   %esi
  80363b:	53                   	push   %ebx
  80363c:	83 ec 1c             	sub    $0x1c,%esp
  80363f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803643:	8b 74 24 34          	mov    0x34(%esp),%esi
  803647:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80364b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80364f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803653:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803657:	89 f3                	mov    %esi,%ebx
  803659:	89 fa                	mov    %edi,%edx
  80365b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80365f:	89 34 24             	mov    %esi,(%esp)
  803662:	85 c0                	test   %eax,%eax
  803664:	75 1a                	jne    803680 <__umoddi3+0x48>
  803666:	39 f7                	cmp    %esi,%edi
  803668:	0f 86 a2 00 00 00    	jbe    803710 <__umoddi3+0xd8>
  80366e:	89 c8                	mov    %ecx,%eax
  803670:	89 f2                	mov    %esi,%edx
  803672:	f7 f7                	div    %edi
  803674:	89 d0                	mov    %edx,%eax
  803676:	31 d2                	xor    %edx,%edx
  803678:	83 c4 1c             	add    $0x1c,%esp
  80367b:	5b                   	pop    %ebx
  80367c:	5e                   	pop    %esi
  80367d:	5f                   	pop    %edi
  80367e:	5d                   	pop    %ebp
  80367f:	c3                   	ret    
  803680:	39 f0                	cmp    %esi,%eax
  803682:	0f 87 ac 00 00 00    	ja     803734 <__umoddi3+0xfc>
  803688:	0f bd e8             	bsr    %eax,%ebp
  80368b:	83 f5 1f             	xor    $0x1f,%ebp
  80368e:	0f 84 ac 00 00 00    	je     803740 <__umoddi3+0x108>
  803694:	bf 20 00 00 00       	mov    $0x20,%edi
  803699:	29 ef                	sub    %ebp,%edi
  80369b:	89 fe                	mov    %edi,%esi
  80369d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036a1:	89 e9                	mov    %ebp,%ecx
  8036a3:	d3 e0                	shl    %cl,%eax
  8036a5:	89 d7                	mov    %edx,%edi
  8036a7:	89 f1                	mov    %esi,%ecx
  8036a9:	d3 ef                	shr    %cl,%edi
  8036ab:	09 c7                	or     %eax,%edi
  8036ad:	89 e9                	mov    %ebp,%ecx
  8036af:	d3 e2                	shl    %cl,%edx
  8036b1:	89 14 24             	mov    %edx,(%esp)
  8036b4:	89 d8                	mov    %ebx,%eax
  8036b6:	d3 e0                	shl    %cl,%eax
  8036b8:	89 c2                	mov    %eax,%edx
  8036ba:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036be:	d3 e0                	shl    %cl,%eax
  8036c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036c4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036c8:	89 f1                	mov    %esi,%ecx
  8036ca:	d3 e8                	shr    %cl,%eax
  8036cc:	09 d0                	or     %edx,%eax
  8036ce:	d3 eb                	shr    %cl,%ebx
  8036d0:	89 da                	mov    %ebx,%edx
  8036d2:	f7 f7                	div    %edi
  8036d4:	89 d3                	mov    %edx,%ebx
  8036d6:	f7 24 24             	mull   (%esp)
  8036d9:	89 c6                	mov    %eax,%esi
  8036db:	89 d1                	mov    %edx,%ecx
  8036dd:	39 d3                	cmp    %edx,%ebx
  8036df:	0f 82 87 00 00 00    	jb     80376c <__umoddi3+0x134>
  8036e5:	0f 84 91 00 00 00    	je     80377c <__umoddi3+0x144>
  8036eb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036ef:	29 f2                	sub    %esi,%edx
  8036f1:	19 cb                	sbb    %ecx,%ebx
  8036f3:	89 d8                	mov    %ebx,%eax
  8036f5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036f9:	d3 e0                	shl    %cl,%eax
  8036fb:	89 e9                	mov    %ebp,%ecx
  8036fd:	d3 ea                	shr    %cl,%edx
  8036ff:	09 d0                	or     %edx,%eax
  803701:	89 e9                	mov    %ebp,%ecx
  803703:	d3 eb                	shr    %cl,%ebx
  803705:	89 da                	mov    %ebx,%edx
  803707:	83 c4 1c             	add    $0x1c,%esp
  80370a:	5b                   	pop    %ebx
  80370b:	5e                   	pop    %esi
  80370c:	5f                   	pop    %edi
  80370d:	5d                   	pop    %ebp
  80370e:	c3                   	ret    
  80370f:	90                   	nop
  803710:	89 fd                	mov    %edi,%ebp
  803712:	85 ff                	test   %edi,%edi
  803714:	75 0b                	jne    803721 <__umoddi3+0xe9>
  803716:	b8 01 00 00 00       	mov    $0x1,%eax
  80371b:	31 d2                	xor    %edx,%edx
  80371d:	f7 f7                	div    %edi
  80371f:	89 c5                	mov    %eax,%ebp
  803721:	89 f0                	mov    %esi,%eax
  803723:	31 d2                	xor    %edx,%edx
  803725:	f7 f5                	div    %ebp
  803727:	89 c8                	mov    %ecx,%eax
  803729:	f7 f5                	div    %ebp
  80372b:	89 d0                	mov    %edx,%eax
  80372d:	e9 44 ff ff ff       	jmp    803676 <__umoddi3+0x3e>
  803732:	66 90                	xchg   %ax,%ax
  803734:	89 c8                	mov    %ecx,%eax
  803736:	89 f2                	mov    %esi,%edx
  803738:	83 c4 1c             	add    $0x1c,%esp
  80373b:	5b                   	pop    %ebx
  80373c:	5e                   	pop    %esi
  80373d:	5f                   	pop    %edi
  80373e:	5d                   	pop    %ebp
  80373f:	c3                   	ret    
  803740:	3b 04 24             	cmp    (%esp),%eax
  803743:	72 06                	jb     80374b <__umoddi3+0x113>
  803745:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803749:	77 0f                	ja     80375a <__umoddi3+0x122>
  80374b:	89 f2                	mov    %esi,%edx
  80374d:	29 f9                	sub    %edi,%ecx
  80374f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803753:	89 14 24             	mov    %edx,(%esp)
  803756:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80375a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80375e:	8b 14 24             	mov    (%esp),%edx
  803761:	83 c4 1c             	add    $0x1c,%esp
  803764:	5b                   	pop    %ebx
  803765:	5e                   	pop    %esi
  803766:	5f                   	pop    %edi
  803767:	5d                   	pop    %ebp
  803768:	c3                   	ret    
  803769:	8d 76 00             	lea    0x0(%esi),%esi
  80376c:	2b 04 24             	sub    (%esp),%eax
  80376f:	19 fa                	sbb    %edi,%edx
  803771:	89 d1                	mov    %edx,%ecx
  803773:	89 c6                	mov    %eax,%esi
  803775:	e9 71 ff ff ff       	jmp    8036eb <__umoddi3+0xb3>
  80377a:	66 90                	xchg   %ax,%ax
  80377c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803780:	72 ea                	jb     80376c <__umoddi3+0x134>
  803782:	89 d9                	mov    %ebx,%ecx
  803784:	e9 62 ff ff ff       	jmp    8036eb <__umoddi3+0xb3>
