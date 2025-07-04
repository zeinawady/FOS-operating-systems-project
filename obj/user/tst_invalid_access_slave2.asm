
obj/user/tst_invalid_access_slave2:     file format elf32-i386


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
  800031:	e8 31 00 00 00       	call   800067 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//[1] User address but READ-ONLY
	uint32 *ptr = (uint32*)USER_TOP;
  80003e:	c7 45 f4 00 00 c0 ee 	movl   $0xeec00000,-0xc(%ebp)
	*ptr = 100 ;
  800045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800048:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	inctst();
  80004e:	e8 d7 15 00 00       	call   80162a <inctst>
	panic("tst invalid access failed: Attempt to write on a READ-ONLY user page.\nThe env must be killed and shouldn't return here.");
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	68 20 1b 80 00       	push   $0x801b20
  80005b:	6a 0e                	push   $0xe
  80005d:	68 98 1b 80 00       	push   $0x801b98
  800062:	e8 45 01 00 00       	call   8001ac <_panic>

00800067 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800067:	55                   	push   %ebp
  800068:	89 e5                	mov    %esp,%ebp
  80006a:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80006d:	e8 7a 14 00 00       	call   8014ec <sys_getenvindex>
  800072:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800075:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800078:	89 d0                	mov    %edx,%eax
  80007a:	c1 e0 02             	shl    $0x2,%eax
  80007d:	01 d0                	add    %edx,%eax
  80007f:	c1 e0 03             	shl    $0x3,%eax
  800082:	01 d0                	add    %edx,%eax
  800084:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80008b:	01 d0                	add    %edx,%eax
  80008d:	c1 e0 02             	shl    $0x2,%eax
  800090:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800095:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80009a:	a1 08 30 80 00       	mov    0x803008,%eax
  80009f:	8a 40 20             	mov    0x20(%eax),%al
  8000a2:	84 c0                	test   %al,%al
  8000a4:	74 0d                	je     8000b3 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  8000a6:	a1 08 30 80 00       	mov    0x803008,%eax
  8000ab:	83 c0 20             	add    $0x20,%eax
  8000ae:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b7:	7e 0a                	jle    8000c3 <libmain+0x5c>
		binaryname = argv[0];
  8000b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000bc:	8b 00                	mov    (%eax),%eax
  8000be:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000c3:	83 ec 08             	sub    $0x8,%esp
  8000c6:	ff 75 0c             	pushl  0xc(%ebp)
  8000c9:	ff 75 08             	pushl  0x8(%ebp)
  8000cc:	e8 67 ff ff ff       	call   800038 <_main>
  8000d1:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000d4:	a1 00 30 80 00       	mov    0x803000,%eax
  8000d9:	85 c0                	test   %eax,%eax
  8000db:	0f 84 9f 00 00 00    	je     800180 <libmain+0x119>
	{
		sys_lock_cons();
  8000e1:	e8 8a 11 00 00       	call   801270 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 d4 1b 80 00       	push   $0x801bd4
  8000ee:	e8 76 03 00 00       	call   800469 <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000f6:	a1 08 30 80 00       	mov    0x803008,%eax
  8000fb:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800101:	a1 08 30 80 00       	mov    0x803008,%eax
  800106:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	52                   	push   %edx
  800110:	50                   	push   %eax
  800111:	68 fc 1b 80 00       	push   $0x801bfc
  800116:	e8 4e 03 00 00       	call   800469 <cprintf>
  80011b:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80011e:	a1 08 30 80 00       	mov    0x803008,%eax
  800123:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800129:	a1 08 30 80 00       	mov    0x803008,%eax
  80012e:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800134:	a1 08 30 80 00       	mov    0x803008,%eax
  800139:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80013f:	51                   	push   %ecx
  800140:	52                   	push   %edx
  800141:	50                   	push   %eax
  800142:	68 24 1c 80 00       	push   $0x801c24
  800147:	e8 1d 03 00 00       	call   800469 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80014f:	a1 08 30 80 00       	mov    0x803008,%eax
  800154:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80015a:	83 ec 08             	sub    $0x8,%esp
  80015d:	50                   	push   %eax
  80015e:	68 7c 1c 80 00       	push   $0x801c7c
  800163:	e8 01 03 00 00       	call   800469 <cprintf>
  800168:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80016b:	83 ec 0c             	sub    $0xc,%esp
  80016e:	68 d4 1b 80 00       	push   $0x801bd4
  800173:	e8 f1 02 00 00       	call   800469 <cprintf>
  800178:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80017b:	e8 0a 11 00 00       	call   80128a <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800180:	e8 19 00 00 00       	call   80019e <exit>
}
  800185:	90                   	nop
  800186:	c9                   	leave  
  800187:	c3                   	ret    

00800188 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80018e:	83 ec 0c             	sub    $0xc,%esp
  800191:	6a 00                	push   $0x0
  800193:	e8 20 13 00 00       	call   8014b8 <sys_destroy_env>
  800198:	83 c4 10             	add    $0x10,%esp
}
  80019b:	90                   	nop
  80019c:	c9                   	leave  
  80019d:	c3                   	ret    

0080019e <exit>:

void
exit(void)
{
  80019e:	55                   	push   %ebp
  80019f:	89 e5                	mov    %esp,%ebp
  8001a1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001a4:	e8 75 13 00 00       	call   80151e <sys_exit_env>
}
  8001a9:	90                   	nop
  8001aa:	c9                   	leave  
  8001ab:	c3                   	ret    

008001ac <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001b2:	8d 45 10             	lea    0x10(%ebp),%eax
  8001b5:	83 c0 04             	add    $0x4,%eax
  8001b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001bb:	a1 28 30 80 00       	mov    0x803028,%eax
  8001c0:	85 c0                	test   %eax,%eax
  8001c2:	74 16                	je     8001da <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001c4:	a1 28 30 80 00       	mov    0x803028,%eax
  8001c9:	83 ec 08             	sub    $0x8,%esp
  8001cc:	50                   	push   %eax
  8001cd:	68 90 1c 80 00       	push   $0x801c90
  8001d2:	e8 92 02 00 00       	call   800469 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001da:	a1 04 30 80 00       	mov    0x803004,%eax
  8001df:	ff 75 0c             	pushl  0xc(%ebp)
  8001e2:	ff 75 08             	pushl  0x8(%ebp)
  8001e5:	50                   	push   %eax
  8001e6:	68 95 1c 80 00       	push   $0x801c95
  8001eb:	e8 79 02 00 00       	call   800469 <cprintf>
  8001f0:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f6:	83 ec 08             	sub    $0x8,%esp
  8001f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8001fc:	50                   	push   %eax
  8001fd:	e8 fc 01 00 00       	call   8003fe <vcprintf>
  800202:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800205:	83 ec 08             	sub    $0x8,%esp
  800208:	6a 00                	push   $0x0
  80020a:	68 b1 1c 80 00       	push   $0x801cb1
  80020f:	e8 ea 01 00 00       	call   8003fe <vcprintf>
  800214:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800217:	e8 82 ff ff ff       	call   80019e <exit>

	// should not return here
	while (1) ;
  80021c:	eb fe                	jmp    80021c <_panic+0x70>

0080021e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800224:	a1 08 30 80 00       	mov    0x803008,%eax
  800229:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80022f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800232:	39 c2                	cmp    %eax,%edx
  800234:	74 14                	je     80024a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	68 b4 1c 80 00       	push   $0x801cb4
  80023e:	6a 26                	push   $0x26
  800240:	68 00 1d 80 00       	push   $0x801d00
  800245:	e8 62 ff ff ff       	call   8001ac <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80024a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800251:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800258:	e9 c5 00 00 00       	jmp    800322 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80025d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800260:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800267:	8b 45 08             	mov    0x8(%ebp),%eax
  80026a:	01 d0                	add    %edx,%eax
  80026c:	8b 00                	mov    (%eax),%eax
  80026e:	85 c0                	test   %eax,%eax
  800270:	75 08                	jne    80027a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800272:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800275:	e9 a5 00 00 00       	jmp    80031f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80027a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800281:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800288:	eb 69                	jmp    8002f3 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80028a:	a1 08 30 80 00       	mov    0x803008,%eax
  80028f:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800295:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800298:	89 d0                	mov    %edx,%eax
  80029a:	01 c0                	add    %eax,%eax
  80029c:	01 d0                	add    %edx,%eax
  80029e:	c1 e0 03             	shl    $0x3,%eax
  8002a1:	01 c8                	add    %ecx,%eax
  8002a3:	8a 40 04             	mov    0x4(%eax),%al
  8002a6:	84 c0                	test   %al,%al
  8002a8:	75 46                	jne    8002f0 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002aa:	a1 08 30 80 00       	mov    0x803008,%eax
  8002af:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8002b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002b8:	89 d0                	mov    %edx,%eax
  8002ba:	01 c0                	add    %eax,%eax
  8002bc:	01 d0                	add    %edx,%eax
  8002be:	c1 e0 03             	shl    $0x3,%eax
  8002c1:	01 c8                	add    %ecx,%eax
  8002c3:	8b 00                	mov    (%eax),%eax
  8002c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002d0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002df:	01 c8                	add    %ecx,%eax
  8002e1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002e3:	39 c2                	cmp    %eax,%edx
  8002e5:	75 09                	jne    8002f0 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002e7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002ee:	eb 15                	jmp    800305 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002f0:	ff 45 e8             	incl   -0x18(%ebp)
  8002f3:	a1 08 30 80 00       	mov    0x803008,%eax
  8002f8:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8002fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800301:	39 c2                	cmp    %eax,%edx
  800303:	77 85                	ja     80028a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800305:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800309:	75 14                	jne    80031f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80030b:	83 ec 04             	sub    $0x4,%esp
  80030e:	68 0c 1d 80 00       	push   $0x801d0c
  800313:	6a 3a                	push   $0x3a
  800315:	68 00 1d 80 00       	push   $0x801d00
  80031a:	e8 8d fe ff ff       	call   8001ac <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80031f:	ff 45 f0             	incl   -0x10(%ebp)
  800322:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800325:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800328:	0f 8c 2f ff ff ff    	jl     80025d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80032e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800335:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80033c:	eb 26                	jmp    800364 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80033e:	a1 08 30 80 00       	mov    0x803008,%eax
  800343:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800349:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80034c:	89 d0                	mov    %edx,%eax
  80034e:	01 c0                	add    %eax,%eax
  800350:	01 d0                	add    %edx,%eax
  800352:	c1 e0 03             	shl    $0x3,%eax
  800355:	01 c8                	add    %ecx,%eax
  800357:	8a 40 04             	mov    0x4(%eax),%al
  80035a:	3c 01                	cmp    $0x1,%al
  80035c:	75 03                	jne    800361 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80035e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800361:	ff 45 e0             	incl   -0x20(%ebp)
  800364:	a1 08 30 80 00       	mov    0x803008,%eax
  800369:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80036f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800372:	39 c2                	cmp    %eax,%edx
  800374:	77 c8                	ja     80033e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800379:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80037c:	74 14                	je     800392 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80037e:	83 ec 04             	sub    $0x4,%esp
  800381:	68 60 1d 80 00       	push   $0x801d60
  800386:	6a 44                	push   $0x44
  800388:	68 00 1d 80 00       	push   $0x801d00
  80038d:	e8 1a fe ff ff       	call   8001ac <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800392:	90                   	nop
  800393:	c9                   	leave  
  800394:	c3                   	ret    

00800395 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800395:	55                   	push   %ebp
  800396:	89 e5                	mov    %esp,%ebp
  800398:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80039b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80039e:	8b 00                	mov    (%eax),%eax
  8003a0:	8d 48 01             	lea    0x1(%eax),%ecx
  8003a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a6:	89 0a                	mov    %ecx,(%edx)
  8003a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ab:	88 d1                	mov    %dl,%cl
  8003ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b7:	8b 00                	mov    (%eax),%eax
  8003b9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003be:	75 2c                	jne    8003ec <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003c0:	a0 0c 30 80 00       	mov    0x80300c,%al
  8003c5:	0f b6 c0             	movzbl %al,%eax
  8003c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003cb:	8b 12                	mov    (%edx),%edx
  8003cd:	89 d1                	mov    %edx,%ecx
  8003cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003d2:	83 c2 08             	add    $0x8,%edx
  8003d5:	83 ec 04             	sub    $0x4,%esp
  8003d8:	50                   	push   %eax
  8003d9:	51                   	push   %ecx
  8003da:	52                   	push   %edx
  8003db:	e8 4e 0e 00 00       	call   80122e <sys_cputs>
  8003e0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ef:	8b 40 04             	mov    0x4(%eax),%eax
  8003f2:	8d 50 01             	lea    0x1(%eax),%edx
  8003f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003fb:	90                   	nop
  8003fc:	c9                   	leave  
  8003fd:	c3                   	ret    

008003fe <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003fe:	55                   	push   %ebp
  8003ff:	89 e5                	mov    %esp,%ebp
  800401:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800407:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80040e:	00 00 00 
	b.cnt = 0;
  800411:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800418:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80041b:	ff 75 0c             	pushl  0xc(%ebp)
  80041e:	ff 75 08             	pushl  0x8(%ebp)
  800421:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800427:	50                   	push   %eax
  800428:	68 95 03 80 00       	push   $0x800395
  80042d:	e8 11 02 00 00       	call   800643 <vprintfmt>
  800432:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800435:	a0 0c 30 80 00       	mov    0x80300c,%al
  80043a:	0f b6 c0             	movzbl %al,%eax
  80043d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800443:	83 ec 04             	sub    $0x4,%esp
  800446:	50                   	push   %eax
  800447:	52                   	push   %edx
  800448:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80044e:	83 c0 08             	add    $0x8,%eax
  800451:	50                   	push   %eax
  800452:	e8 d7 0d 00 00       	call   80122e <sys_cputs>
  800457:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80045a:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  800461:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800467:	c9                   	leave  
  800468:	c3                   	ret    

00800469 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800469:	55                   	push   %ebp
  80046a:	89 e5                	mov    %esp,%ebp
  80046c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80046f:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  800476:	8d 45 0c             	lea    0xc(%ebp),%eax
  800479:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80047c:	8b 45 08             	mov    0x8(%ebp),%eax
  80047f:	83 ec 08             	sub    $0x8,%esp
  800482:	ff 75 f4             	pushl  -0xc(%ebp)
  800485:	50                   	push   %eax
  800486:	e8 73 ff ff ff       	call   8003fe <vcprintf>
  80048b:	83 c4 10             	add    $0x10,%esp
  80048e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800491:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800494:	c9                   	leave  
  800495:	c3                   	ret    

00800496 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800496:	55                   	push   %ebp
  800497:	89 e5                	mov    %esp,%ebp
  800499:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80049c:	e8 cf 0d 00 00       	call   801270 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8004a1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8004a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004aa:	83 ec 08             	sub    $0x8,%esp
  8004ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8004b0:	50                   	push   %eax
  8004b1:	e8 48 ff ff ff       	call   8003fe <vcprintf>
  8004b6:	83 c4 10             	add    $0x10,%esp
  8004b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004bc:	e8 c9 0d 00 00       	call   80128a <sys_unlock_cons>
	return cnt;
  8004c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004c4:	c9                   	leave  
  8004c5:	c3                   	ret    

008004c6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004c6:	55                   	push   %ebp
  8004c7:	89 e5                	mov    %esp,%ebp
  8004c9:	53                   	push   %ebx
  8004ca:	83 ec 14             	sub    $0x14,%esp
  8004cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004d9:	8b 45 18             	mov    0x18(%ebp),%eax
  8004dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004e4:	77 55                	ja     80053b <printnum+0x75>
  8004e6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004e9:	72 05                	jb     8004f0 <printnum+0x2a>
  8004eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004ee:	77 4b                	ja     80053b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004f0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004f3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004f6:	8b 45 18             	mov    0x18(%ebp),%eax
  8004f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8004fe:	52                   	push   %edx
  8004ff:	50                   	push   %eax
  800500:	ff 75 f4             	pushl  -0xc(%ebp)
  800503:	ff 75 f0             	pushl  -0x10(%ebp)
  800506:	e8 95 13 00 00       	call   8018a0 <__udivdi3>
  80050b:	83 c4 10             	add    $0x10,%esp
  80050e:	83 ec 04             	sub    $0x4,%esp
  800511:	ff 75 20             	pushl  0x20(%ebp)
  800514:	53                   	push   %ebx
  800515:	ff 75 18             	pushl  0x18(%ebp)
  800518:	52                   	push   %edx
  800519:	50                   	push   %eax
  80051a:	ff 75 0c             	pushl  0xc(%ebp)
  80051d:	ff 75 08             	pushl  0x8(%ebp)
  800520:	e8 a1 ff ff ff       	call   8004c6 <printnum>
  800525:	83 c4 20             	add    $0x20,%esp
  800528:	eb 1a                	jmp    800544 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80052a:	83 ec 08             	sub    $0x8,%esp
  80052d:	ff 75 0c             	pushl  0xc(%ebp)
  800530:	ff 75 20             	pushl  0x20(%ebp)
  800533:	8b 45 08             	mov    0x8(%ebp),%eax
  800536:	ff d0                	call   *%eax
  800538:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80053b:	ff 4d 1c             	decl   0x1c(%ebp)
  80053e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800542:	7f e6                	jg     80052a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800544:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800547:	bb 00 00 00 00       	mov    $0x0,%ebx
  80054c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800552:	53                   	push   %ebx
  800553:	51                   	push   %ecx
  800554:	52                   	push   %edx
  800555:	50                   	push   %eax
  800556:	e8 55 14 00 00       	call   8019b0 <__umoddi3>
  80055b:	83 c4 10             	add    $0x10,%esp
  80055e:	05 d4 1f 80 00       	add    $0x801fd4,%eax
  800563:	8a 00                	mov    (%eax),%al
  800565:	0f be c0             	movsbl %al,%eax
  800568:	83 ec 08             	sub    $0x8,%esp
  80056b:	ff 75 0c             	pushl  0xc(%ebp)
  80056e:	50                   	push   %eax
  80056f:	8b 45 08             	mov    0x8(%ebp),%eax
  800572:	ff d0                	call   *%eax
  800574:	83 c4 10             	add    $0x10,%esp
}
  800577:	90                   	nop
  800578:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80057b:	c9                   	leave  
  80057c:	c3                   	ret    

0080057d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80057d:	55                   	push   %ebp
  80057e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800580:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800584:	7e 1c                	jle    8005a2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800586:	8b 45 08             	mov    0x8(%ebp),%eax
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	8d 50 08             	lea    0x8(%eax),%edx
  80058e:	8b 45 08             	mov    0x8(%ebp),%eax
  800591:	89 10                	mov    %edx,(%eax)
  800593:	8b 45 08             	mov    0x8(%ebp),%eax
  800596:	8b 00                	mov    (%eax),%eax
  800598:	83 e8 08             	sub    $0x8,%eax
  80059b:	8b 50 04             	mov    0x4(%eax),%edx
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	eb 40                	jmp    8005e2 <getuint+0x65>
	else if (lflag)
  8005a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005a6:	74 1e                	je     8005c6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ab:	8b 00                	mov    (%eax),%eax
  8005ad:	8d 50 04             	lea    0x4(%eax),%edx
  8005b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b3:	89 10                	mov    %edx,(%eax)
  8005b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b8:	8b 00                	mov    (%eax),%eax
  8005ba:	83 e8 04             	sub    $0x4,%eax
  8005bd:	8b 00                	mov    (%eax),%eax
  8005bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c4:	eb 1c                	jmp    8005e2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c9:	8b 00                	mov    (%eax),%eax
  8005cb:	8d 50 04             	lea    0x4(%eax),%edx
  8005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d1:	89 10                	mov    %edx,(%eax)
  8005d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	83 e8 04             	sub    $0x4,%eax
  8005db:	8b 00                	mov    (%eax),%eax
  8005dd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005e2:	5d                   	pop    %ebp
  8005e3:	c3                   	ret    

008005e4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005e4:	55                   	push   %ebp
  8005e5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005e7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005eb:	7e 1c                	jle    800609 <getint+0x25>
		return va_arg(*ap, long long);
  8005ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f0:	8b 00                	mov    (%eax),%eax
  8005f2:	8d 50 08             	lea    0x8(%eax),%edx
  8005f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f8:	89 10                	mov    %edx,(%eax)
  8005fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	83 e8 08             	sub    $0x8,%eax
  800602:	8b 50 04             	mov    0x4(%eax),%edx
  800605:	8b 00                	mov    (%eax),%eax
  800607:	eb 38                	jmp    800641 <getint+0x5d>
	else if (lflag)
  800609:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80060d:	74 1a                	je     800629 <getint+0x45>
		return va_arg(*ap, long);
  80060f:	8b 45 08             	mov    0x8(%ebp),%eax
  800612:	8b 00                	mov    (%eax),%eax
  800614:	8d 50 04             	lea    0x4(%eax),%edx
  800617:	8b 45 08             	mov    0x8(%ebp),%eax
  80061a:	89 10                	mov    %edx,(%eax)
  80061c:	8b 45 08             	mov    0x8(%ebp),%eax
  80061f:	8b 00                	mov    (%eax),%eax
  800621:	83 e8 04             	sub    $0x4,%eax
  800624:	8b 00                	mov    (%eax),%eax
  800626:	99                   	cltd   
  800627:	eb 18                	jmp    800641 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800629:	8b 45 08             	mov    0x8(%ebp),%eax
  80062c:	8b 00                	mov    (%eax),%eax
  80062e:	8d 50 04             	lea    0x4(%eax),%edx
  800631:	8b 45 08             	mov    0x8(%ebp),%eax
  800634:	89 10                	mov    %edx,(%eax)
  800636:	8b 45 08             	mov    0x8(%ebp),%eax
  800639:	8b 00                	mov    (%eax),%eax
  80063b:	83 e8 04             	sub    $0x4,%eax
  80063e:	8b 00                	mov    (%eax),%eax
  800640:	99                   	cltd   
}
  800641:	5d                   	pop    %ebp
  800642:	c3                   	ret    

00800643 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800643:	55                   	push   %ebp
  800644:	89 e5                	mov    %esp,%ebp
  800646:	56                   	push   %esi
  800647:	53                   	push   %ebx
  800648:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80064b:	eb 17                	jmp    800664 <vprintfmt+0x21>
			if (ch == '\0')
  80064d:	85 db                	test   %ebx,%ebx
  80064f:	0f 84 c1 03 00 00    	je     800a16 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800655:	83 ec 08             	sub    $0x8,%esp
  800658:	ff 75 0c             	pushl  0xc(%ebp)
  80065b:	53                   	push   %ebx
  80065c:	8b 45 08             	mov    0x8(%ebp),%eax
  80065f:	ff d0                	call   *%eax
  800661:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800664:	8b 45 10             	mov    0x10(%ebp),%eax
  800667:	8d 50 01             	lea    0x1(%eax),%edx
  80066a:	89 55 10             	mov    %edx,0x10(%ebp)
  80066d:	8a 00                	mov    (%eax),%al
  80066f:	0f b6 d8             	movzbl %al,%ebx
  800672:	83 fb 25             	cmp    $0x25,%ebx
  800675:	75 d6                	jne    80064d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800677:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80067b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800682:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800689:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800690:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800697:	8b 45 10             	mov    0x10(%ebp),%eax
  80069a:	8d 50 01             	lea    0x1(%eax),%edx
  80069d:	89 55 10             	mov    %edx,0x10(%ebp)
  8006a0:	8a 00                	mov    (%eax),%al
  8006a2:	0f b6 d8             	movzbl %al,%ebx
  8006a5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006a8:	83 f8 5b             	cmp    $0x5b,%eax
  8006ab:	0f 87 3d 03 00 00    	ja     8009ee <vprintfmt+0x3ab>
  8006b1:	8b 04 85 f8 1f 80 00 	mov    0x801ff8(,%eax,4),%eax
  8006b8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006ba:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006be:	eb d7                	jmp    800697 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006c0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006c4:	eb d1                	jmp    800697 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006c6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006d0:	89 d0                	mov    %edx,%eax
  8006d2:	c1 e0 02             	shl    $0x2,%eax
  8006d5:	01 d0                	add    %edx,%eax
  8006d7:	01 c0                	add    %eax,%eax
  8006d9:	01 d8                	add    %ebx,%eax
  8006db:	83 e8 30             	sub    $0x30,%eax
  8006de:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8006e4:	8a 00                	mov    (%eax),%al
  8006e6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006e9:	83 fb 2f             	cmp    $0x2f,%ebx
  8006ec:	7e 3e                	jle    80072c <vprintfmt+0xe9>
  8006ee:	83 fb 39             	cmp    $0x39,%ebx
  8006f1:	7f 39                	jg     80072c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006f3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006f6:	eb d5                	jmp    8006cd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fb:	83 c0 04             	add    $0x4,%eax
  8006fe:	89 45 14             	mov    %eax,0x14(%ebp)
  800701:	8b 45 14             	mov    0x14(%ebp),%eax
  800704:	83 e8 04             	sub    $0x4,%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80070c:	eb 1f                	jmp    80072d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80070e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800712:	79 83                	jns    800697 <vprintfmt+0x54>
				width = 0;
  800714:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80071b:	e9 77 ff ff ff       	jmp    800697 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800720:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800727:	e9 6b ff ff ff       	jmp    800697 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80072c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80072d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800731:	0f 89 60 ff ff ff    	jns    800697 <vprintfmt+0x54>
				width = precision, precision = -1;
  800737:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80073a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80073d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800744:	e9 4e ff ff ff       	jmp    800697 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800749:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80074c:	e9 46 ff ff ff       	jmp    800697 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	83 c0 04             	add    $0x4,%eax
  800757:	89 45 14             	mov    %eax,0x14(%ebp)
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	83 e8 04             	sub    $0x4,%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	83 ec 08             	sub    $0x8,%esp
  800765:	ff 75 0c             	pushl  0xc(%ebp)
  800768:	50                   	push   %eax
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	ff d0                	call   *%eax
  80076e:	83 c4 10             	add    $0x10,%esp
			break;
  800771:	e9 9b 02 00 00       	jmp    800a11 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800776:	8b 45 14             	mov    0x14(%ebp),%eax
  800779:	83 c0 04             	add    $0x4,%eax
  80077c:	89 45 14             	mov    %eax,0x14(%ebp)
  80077f:	8b 45 14             	mov    0x14(%ebp),%eax
  800782:	83 e8 04             	sub    $0x4,%eax
  800785:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800787:	85 db                	test   %ebx,%ebx
  800789:	79 02                	jns    80078d <vprintfmt+0x14a>
				err = -err;
  80078b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80078d:	83 fb 64             	cmp    $0x64,%ebx
  800790:	7f 0b                	jg     80079d <vprintfmt+0x15a>
  800792:	8b 34 9d 40 1e 80 00 	mov    0x801e40(,%ebx,4),%esi
  800799:	85 f6                	test   %esi,%esi
  80079b:	75 19                	jne    8007b6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80079d:	53                   	push   %ebx
  80079e:	68 e5 1f 80 00       	push   $0x801fe5
  8007a3:	ff 75 0c             	pushl  0xc(%ebp)
  8007a6:	ff 75 08             	pushl  0x8(%ebp)
  8007a9:	e8 70 02 00 00       	call   800a1e <printfmt>
  8007ae:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007b1:	e9 5b 02 00 00       	jmp    800a11 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007b6:	56                   	push   %esi
  8007b7:	68 ee 1f 80 00       	push   $0x801fee
  8007bc:	ff 75 0c             	pushl  0xc(%ebp)
  8007bf:	ff 75 08             	pushl  0x8(%ebp)
  8007c2:	e8 57 02 00 00       	call   800a1e <printfmt>
  8007c7:	83 c4 10             	add    $0x10,%esp
			break;
  8007ca:	e9 42 02 00 00       	jmp    800a11 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	83 c0 04             	add    $0x4,%eax
  8007d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007db:	83 e8 04             	sub    $0x4,%eax
  8007de:	8b 30                	mov    (%eax),%esi
  8007e0:	85 f6                	test   %esi,%esi
  8007e2:	75 05                	jne    8007e9 <vprintfmt+0x1a6>
				p = "(null)";
  8007e4:	be f1 1f 80 00       	mov    $0x801ff1,%esi
			if (width > 0 && padc != '-')
  8007e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ed:	7e 6d                	jle    80085c <vprintfmt+0x219>
  8007ef:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007f3:	74 67                	je     80085c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f8:	83 ec 08             	sub    $0x8,%esp
  8007fb:	50                   	push   %eax
  8007fc:	56                   	push   %esi
  8007fd:	e8 1e 03 00 00       	call   800b20 <strnlen>
  800802:	83 c4 10             	add    $0x10,%esp
  800805:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800808:	eb 16                	jmp    800820 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80080a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	ff 75 0c             	pushl  0xc(%ebp)
  800814:	50                   	push   %eax
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	ff d0                	call   *%eax
  80081a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80081d:	ff 4d e4             	decl   -0x1c(%ebp)
  800820:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800824:	7f e4                	jg     80080a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800826:	eb 34                	jmp    80085c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800828:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80082c:	74 1c                	je     80084a <vprintfmt+0x207>
  80082e:	83 fb 1f             	cmp    $0x1f,%ebx
  800831:	7e 05                	jle    800838 <vprintfmt+0x1f5>
  800833:	83 fb 7e             	cmp    $0x7e,%ebx
  800836:	7e 12                	jle    80084a <vprintfmt+0x207>
					putch('?', putdat);
  800838:	83 ec 08             	sub    $0x8,%esp
  80083b:	ff 75 0c             	pushl  0xc(%ebp)
  80083e:	6a 3f                	push   $0x3f
  800840:	8b 45 08             	mov    0x8(%ebp),%eax
  800843:	ff d0                	call   *%eax
  800845:	83 c4 10             	add    $0x10,%esp
  800848:	eb 0f                	jmp    800859 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80084a:	83 ec 08             	sub    $0x8,%esp
  80084d:	ff 75 0c             	pushl  0xc(%ebp)
  800850:	53                   	push   %ebx
  800851:	8b 45 08             	mov    0x8(%ebp),%eax
  800854:	ff d0                	call   *%eax
  800856:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800859:	ff 4d e4             	decl   -0x1c(%ebp)
  80085c:	89 f0                	mov    %esi,%eax
  80085e:	8d 70 01             	lea    0x1(%eax),%esi
  800861:	8a 00                	mov    (%eax),%al
  800863:	0f be d8             	movsbl %al,%ebx
  800866:	85 db                	test   %ebx,%ebx
  800868:	74 24                	je     80088e <vprintfmt+0x24b>
  80086a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80086e:	78 b8                	js     800828 <vprintfmt+0x1e5>
  800870:	ff 4d e0             	decl   -0x20(%ebp)
  800873:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800877:	79 af                	jns    800828 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800879:	eb 13                	jmp    80088e <vprintfmt+0x24b>
				putch(' ', putdat);
  80087b:	83 ec 08             	sub    $0x8,%esp
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	6a 20                	push   $0x20
  800883:	8b 45 08             	mov    0x8(%ebp),%eax
  800886:	ff d0                	call   *%eax
  800888:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80088b:	ff 4d e4             	decl   -0x1c(%ebp)
  80088e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800892:	7f e7                	jg     80087b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800894:	e9 78 01 00 00       	jmp    800a11 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800899:	83 ec 08             	sub    $0x8,%esp
  80089c:	ff 75 e8             	pushl  -0x18(%ebp)
  80089f:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a2:	50                   	push   %eax
  8008a3:	e8 3c fd ff ff       	call   8005e4 <getint>
  8008a8:	83 c4 10             	add    $0x10,%esp
  8008ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b7:	85 d2                	test   %edx,%edx
  8008b9:	79 23                	jns    8008de <vprintfmt+0x29b>
				putch('-', putdat);
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	ff 75 0c             	pushl  0xc(%ebp)
  8008c1:	6a 2d                	push   $0x2d
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	ff d0                	call   *%eax
  8008c8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008d1:	f7 d8                	neg    %eax
  8008d3:	83 d2 00             	adc    $0x0,%edx
  8008d6:	f7 da                	neg    %edx
  8008d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008db:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008de:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008e5:	e9 bc 00 00 00       	jmp    8009a6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008ea:	83 ec 08             	sub    $0x8,%esp
  8008ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8008f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8008f3:	50                   	push   %eax
  8008f4:	e8 84 fc ff ff       	call   80057d <getuint>
  8008f9:	83 c4 10             	add    $0x10,%esp
  8008fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800902:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800909:	e9 98 00 00 00       	jmp    8009a6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	ff 75 0c             	pushl  0xc(%ebp)
  800914:	6a 58                	push   $0x58
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	ff d0                	call   *%eax
  80091b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80091e:	83 ec 08             	sub    $0x8,%esp
  800921:	ff 75 0c             	pushl  0xc(%ebp)
  800924:	6a 58                	push   $0x58
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	ff d0                	call   *%eax
  80092b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80092e:	83 ec 08             	sub    $0x8,%esp
  800931:	ff 75 0c             	pushl  0xc(%ebp)
  800934:	6a 58                	push   $0x58
  800936:	8b 45 08             	mov    0x8(%ebp),%eax
  800939:	ff d0                	call   *%eax
  80093b:	83 c4 10             	add    $0x10,%esp
			break;
  80093e:	e9 ce 00 00 00       	jmp    800a11 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800943:	83 ec 08             	sub    $0x8,%esp
  800946:	ff 75 0c             	pushl  0xc(%ebp)
  800949:	6a 30                	push   $0x30
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	ff d0                	call   *%eax
  800950:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800953:	83 ec 08             	sub    $0x8,%esp
  800956:	ff 75 0c             	pushl  0xc(%ebp)
  800959:	6a 78                	push   $0x78
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	ff d0                	call   *%eax
  800960:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800963:	8b 45 14             	mov    0x14(%ebp),%eax
  800966:	83 c0 04             	add    $0x4,%eax
  800969:	89 45 14             	mov    %eax,0x14(%ebp)
  80096c:	8b 45 14             	mov    0x14(%ebp),%eax
  80096f:	83 e8 04             	sub    $0x4,%eax
  800972:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800974:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800977:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80097e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800985:	eb 1f                	jmp    8009a6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800987:	83 ec 08             	sub    $0x8,%esp
  80098a:	ff 75 e8             	pushl  -0x18(%ebp)
  80098d:	8d 45 14             	lea    0x14(%ebp),%eax
  800990:	50                   	push   %eax
  800991:	e8 e7 fb ff ff       	call   80057d <getuint>
  800996:	83 c4 10             	add    $0x10,%esp
  800999:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80099f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009a6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ad:	83 ec 04             	sub    $0x4,%esp
  8009b0:	52                   	push   %edx
  8009b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009b4:	50                   	push   %eax
  8009b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8009bb:	ff 75 0c             	pushl  0xc(%ebp)
  8009be:	ff 75 08             	pushl  0x8(%ebp)
  8009c1:	e8 00 fb ff ff       	call   8004c6 <printnum>
  8009c6:	83 c4 20             	add    $0x20,%esp
			break;
  8009c9:	eb 46                	jmp    800a11 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009cb:	83 ec 08             	sub    $0x8,%esp
  8009ce:	ff 75 0c             	pushl  0xc(%ebp)
  8009d1:	53                   	push   %ebx
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	ff d0                	call   *%eax
  8009d7:	83 c4 10             	add    $0x10,%esp
			break;
  8009da:	eb 35                	jmp    800a11 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009dc:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  8009e3:	eb 2c                	jmp    800a11 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009e5:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  8009ec:	eb 23                	jmp    800a11 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009ee:	83 ec 08             	sub    $0x8,%esp
  8009f1:	ff 75 0c             	pushl  0xc(%ebp)
  8009f4:	6a 25                	push   $0x25
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	ff d0                	call   *%eax
  8009fb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009fe:	ff 4d 10             	decl   0x10(%ebp)
  800a01:	eb 03                	jmp    800a06 <vprintfmt+0x3c3>
  800a03:	ff 4d 10             	decl   0x10(%ebp)
  800a06:	8b 45 10             	mov    0x10(%ebp),%eax
  800a09:	48                   	dec    %eax
  800a0a:	8a 00                	mov    (%eax),%al
  800a0c:	3c 25                	cmp    $0x25,%al
  800a0e:	75 f3                	jne    800a03 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a10:	90                   	nop
		}
	}
  800a11:	e9 35 fc ff ff       	jmp    80064b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a16:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a17:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a1a:	5b                   	pop    %ebx
  800a1b:	5e                   	pop    %esi
  800a1c:	5d                   	pop    %ebp
  800a1d:	c3                   	ret    

00800a1e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a24:	8d 45 10             	lea    0x10(%ebp),%eax
  800a27:	83 c0 04             	add    $0x4,%eax
  800a2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a30:	ff 75 f4             	pushl  -0xc(%ebp)
  800a33:	50                   	push   %eax
  800a34:	ff 75 0c             	pushl  0xc(%ebp)
  800a37:	ff 75 08             	pushl  0x8(%ebp)
  800a3a:	e8 04 fc ff ff       	call   800643 <vprintfmt>
  800a3f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a42:	90                   	nop
  800a43:	c9                   	leave  
  800a44:	c3                   	ret    

00800a45 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4b:	8b 40 08             	mov    0x8(%eax),%eax
  800a4e:	8d 50 01             	lea    0x1(%eax),%edx
  800a51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a54:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5a:	8b 10                	mov    (%eax),%edx
  800a5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5f:	8b 40 04             	mov    0x4(%eax),%eax
  800a62:	39 c2                	cmp    %eax,%edx
  800a64:	73 12                	jae    800a78 <sprintputch+0x33>
		*b->buf++ = ch;
  800a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a69:	8b 00                	mov    (%eax),%eax
  800a6b:	8d 48 01             	lea    0x1(%eax),%ecx
  800a6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a71:	89 0a                	mov    %ecx,(%edx)
  800a73:	8b 55 08             	mov    0x8(%ebp),%edx
  800a76:	88 10                	mov    %dl,(%eax)
}
  800a78:	90                   	nop
  800a79:	5d                   	pop    %ebp
  800a7a:	c3                   	ret    

00800a7b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	01 d0                	add    %edx,%eax
  800a92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800aa0:	74 06                	je     800aa8 <vsnprintf+0x2d>
  800aa2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aa6:	7f 07                	jg     800aaf <vsnprintf+0x34>
		return -E_INVAL;
  800aa8:	b8 03 00 00 00       	mov    $0x3,%eax
  800aad:	eb 20                	jmp    800acf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800aaf:	ff 75 14             	pushl  0x14(%ebp)
  800ab2:	ff 75 10             	pushl  0x10(%ebp)
  800ab5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ab8:	50                   	push   %eax
  800ab9:	68 45 0a 80 00       	push   $0x800a45
  800abe:	e8 80 fb ff ff       	call   800643 <vprintfmt>
  800ac3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ac6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800acf:	c9                   	leave  
  800ad0:	c3                   	ret    

00800ad1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ad7:	8d 45 10             	lea    0x10(%ebp),%eax
  800ada:	83 c0 04             	add    $0x4,%eax
  800add:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ae0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae3:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae6:	50                   	push   %eax
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	ff 75 08             	pushl  0x8(%ebp)
  800aed:	e8 89 ff ff ff       	call   800a7b <vsnprintf>
  800af2:	83 c4 10             	add    $0x10,%esp
  800af5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800afb:	c9                   	leave  
  800afc:	c3                   	ret    

00800afd <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
  800b00:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b0a:	eb 06                	jmp    800b12 <strlen+0x15>
		n++;
  800b0c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b0f:	ff 45 08             	incl   0x8(%ebp)
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	8a 00                	mov    (%eax),%al
  800b17:	84 c0                	test   %al,%al
  800b19:	75 f1                	jne    800b0c <strlen+0xf>
		n++;
	return n;
  800b1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b1e:	c9                   	leave  
  800b1f:	c3                   	ret    

00800b20 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b2d:	eb 09                	jmp    800b38 <strnlen+0x18>
		n++;
  800b2f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b32:	ff 45 08             	incl   0x8(%ebp)
  800b35:	ff 4d 0c             	decl   0xc(%ebp)
  800b38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b3c:	74 09                	je     800b47 <strnlen+0x27>
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	8a 00                	mov    (%eax),%al
  800b43:	84 c0                	test   %al,%al
  800b45:	75 e8                	jne    800b2f <strnlen+0xf>
		n++;
	return n;
  800b47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b4a:	c9                   	leave  
  800b4b:	c3                   	ret    

00800b4c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b58:	90                   	nop
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	8d 50 01             	lea    0x1(%eax),%edx
  800b5f:	89 55 08             	mov    %edx,0x8(%ebp)
  800b62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b65:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b68:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b6b:	8a 12                	mov    (%edx),%dl
  800b6d:	88 10                	mov    %dl,(%eax)
  800b6f:	8a 00                	mov    (%eax),%al
  800b71:	84 c0                	test   %al,%al
  800b73:	75 e4                	jne    800b59 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b78:	c9                   	leave  
  800b79:	c3                   	ret    

00800b7a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b8d:	eb 1f                	jmp    800bae <strncpy+0x34>
		*dst++ = *src;
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	8d 50 01             	lea    0x1(%eax),%edx
  800b95:	89 55 08             	mov    %edx,0x8(%ebp)
  800b98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9b:	8a 12                	mov    (%edx),%dl
  800b9d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba2:	8a 00                	mov    (%eax),%al
  800ba4:	84 c0                	test   %al,%al
  800ba6:	74 03                	je     800bab <strncpy+0x31>
			src++;
  800ba8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bab:	ff 45 fc             	incl   -0x4(%ebp)
  800bae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bb1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bb4:	72 d9                	jb     800b8f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800bb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bb9:	c9                   	leave  
  800bba:	c3                   	ret    

00800bbb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bcb:	74 30                	je     800bfd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bcd:	eb 16                	jmp    800be5 <strlcpy+0x2a>
			*dst++ = *src++;
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	8d 50 01             	lea    0x1(%eax),%edx
  800bd5:	89 55 08             	mov    %edx,0x8(%ebp)
  800bd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bdb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bde:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800be1:	8a 12                	mov    (%edx),%dl
  800be3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800be5:	ff 4d 10             	decl   0x10(%ebp)
  800be8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bec:	74 09                	je     800bf7 <strlcpy+0x3c>
  800bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf1:	8a 00                	mov    (%eax),%al
  800bf3:	84 c0                	test   %al,%al
  800bf5:	75 d8                	jne    800bcf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800c00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c03:	29 c2                	sub    %eax,%edx
  800c05:	89 d0                	mov    %edx,%eax
}
  800c07:	c9                   	leave  
  800c08:	c3                   	ret    

00800c09 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c0c:	eb 06                	jmp    800c14 <strcmp+0xb>
		p++, q++;
  800c0e:	ff 45 08             	incl   0x8(%ebp)
  800c11:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	8a 00                	mov    (%eax),%al
  800c19:	84 c0                	test   %al,%al
  800c1b:	74 0e                	je     800c2b <strcmp+0x22>
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	8a 10                	mov    (%eax),%dl
  800c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c25:	8a 00                	mov    (%eax),%al
  800c27:	38 c2                	cmp    %al,%dl
  800c29:	74 e3                	je     800c0e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	8a 00                	mov    (%eax),%al
  800c30:	0f b6 d0             	movzbl %al,%edx
  800c33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c36:	8a 00                	mov    (%eax),%al
  800c38:	0f b6 c0             	movzbl %al,%eax
  800c3b:	29 c2                	sub    %eax,%edx
  800c3d:	89 d0                	mov    %edx,%eax
}
  800c3f:	5d                   	pop    %ebp
  800c40:	c3                   	ret    

00800c41 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c41:	55                   	push   %ebp
  800c42:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c44:	eb 09                	jmp    800c4f <strncmp+0xe>
		n--, p++, q++;
  800c46:	ff 4d 10             	decl   0x10(%ebp)
  800c49:	ff 45 08             	incl   0x8(%ebp)
  800c4c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c53:	74 17                	je     800c6c <strncmp+0x2b>
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	8a 00                	mov    (%eax),%al
  800c5a:	84 c0                	test   %al,%al
  800c5c:	74 0e                	je     800c6c <strncmp+0x2b>
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	8a 10                	mov    (%eax),%dl
  800c63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c66:	8a 00                	mov    (%eax),%al
  800c68:	38 c2                	cmp    %al,%dl
  800c6a:	74 da                	je     800c46 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c70:	75 07                	jne    800c79 <strncmp+0x38>
		return 0;
  800c72:	b8 00 00 00 00       	mov    $0x0,%eax
  800c77:	eb 14                	jmp    800c8d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	8a 00                	mov    (%eax),%al
  800c7e:	0f b6 d0             	movzbl %al,%edx
  800c81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c84:	8a 00                	mov    (%eax),%al
  800c86:	0f b6 c0             	movzbl %al,%eax
  800c89:	29 c2                	sub    %eax,%edx
  800c8b:	89 d0                	mov    %edx,%eax
}
  800c8d:	5d                   	pop    %ebp
  800c8e:	c3                   	ret    

00800c8f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	83 ec 04             	sub    $0x4,%esp
  800c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c98:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c9b:	eb 12                	jmp    800caf <strchr+0x20>
		if (*s == c)
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8a 00                	mov    (%eax),%al
  800ca2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ca5:	75 05                	jne    800cac <strchr+0x1d>
			return (char *) s;
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	eb 11                	jmp    800cbd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cac:	ff 45 08             	incl   0x8(%ebp)
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	8a 00                	mov    (%eax),%al
  800cb4:	84 c0                	test   %al,%al
  800cb6:	75 e5                	jne    800c9d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cbd:	c9                   	leave  
  800cbe:	c3                   	ret    

00800cbf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	83 ec 04             	sub    $0x4,%esp
  800cc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ccb:	eb 0d                	jmp    800cda <strfind+0x1b>
		if (*s == c)
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	8a 00                	mov    (%eax),%al
  800cd2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cd5:	74 0e                	je     800ce5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cd7:	ff 45 08             	incl   0x8(%ebp)
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	84 c0                	test   %al,%al
  800ce1:	75 ea                	jne    800ccd <strfind+0xe>
  800ce3:	eb 01                	jmp    800ce6 <strfind+0x27>
		if (*s == c)
			break;
  800ce5:	90                   	nop
	return (char *) s;
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ce9:	c9                   	leave  
  800cea:	c3                   	ret    

00800ceb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cf7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cfd:	eb 0e                	jmp    800d0d <memset+0x22>
		*p++ = c;
  800cff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d02:	8d 50 01             	lea    0x1(%eax),%edx
  800d05:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d0d:	ff 4d f8             	decl   -0x8(%ebp)
  800d10:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d14:	79 e9                	jns    800cff <memset+0x14>
		*p++ = c;

	return v;
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d19:	c9                   	leave  
  800d1a:	c3                   	ret    

00800d1b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d2d:	eb 16                	jmp    800d45 <memcpy+0x2a>
		*d++ = *s++;
  800d2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d32:	8d 50 01             	lea    0x1(%eax),%edx
  800d35:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d38:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d41:	8a 12                	mov    (%edx),%dl
  800d43:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d45:	8b 45 10             	mov    0x10(%ebp),%eax
  800d48:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d4b:	89 55 10             	mov    %edx,0x10(%ebp)
  800d4e:	85 c0                	test   %eax,%eax
  800d50:	75 dd                	jne    800d2f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d55:	c9                   	leave  
  800d56:	c3                   	ret    

00800d57 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d6f:	73 50                	jae    800dc1 <memmove+0x6a>
  800d71:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d74:	8b 45 10             	mov    0x10(%ebp),%eax
  800d77:	01 d0                	add    %edx,%eax
  800d79:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d7c:	76 43                	jbe    800dc1 <memmove+0x6a>
		s += n;
  800d7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d81:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d84:	8b 45 10             	mov    0x10(%ebp),%eax
  800d87:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d8a:	eb 10                	jmp    800d9c <memmove+0x45>
			*--d = *--s;
  800d8c:	ff 4d f8             	decl   -0x8(%ebp)
  800d8f:	ff 4d fc             	decl   -0x4(%ebp)
  800d92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d95:	8a 10                	mov    (%eax),%dl
  800d97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d9a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da2:	89 55 10             	mov    %edx,0x10(%ebp)
  800da5:	85 c0                	test   %eax,%eax
  800da7:	75 e3                	jne    800d8c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800da9:	eb 23                	jmp    800dce <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800dab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dae:	8d 50 01             	lea    0x1(%eax),%edx
  800db1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800db4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800db7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dba:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dbd:	8a 12                	mov    (%edx),%dl
  800dbf:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc7:	89 55 10             	mov    %edx,0x10(%ebp)
  800dca:	85 c0                	test   %eax,%eax
  800dcc:	75 dd                	jne    800dab <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd1:	c9                   	leave  
  800dd2:	c3                   	ret    

00800dd3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800de5:	eb 2a                	jmp    800e11 <memcmp+0x3e>
		if (*s1 != *s2)
  800de7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dea:	8a 10                	mov    (%eax),%dl
  800dec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800def:	8a 00                	mov    (%eax),%al
  800df1:	38 c2                	cmp    %al,%dl
  800df3:	74 16                	je     800e0b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800df5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	0f b6 d0             	movzbl %al,%edx
  800dfd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e00:	8a 00                	mov    (%eax),%al
  800e02:	0f b6 c0             	movzbl %al,%eax
  800e05:	29 c2                	sub    %eax,%edx
  800e07:	89 d0                	mov    %edx,%eax
  800e09:	eb 18                	jmp    800e23 <memcmp+0x50>
		s1++, s2++;
  800e0b:	ff 45 fc             	incl   -0x4(%ebp)
  800e0e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e11:	8b 45 10             	mov    0x10(%ebp),%eax
  800e14:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e17:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1a:	85 c0                	test   %eax,%eax
  800e1c:	75 c9                	jne    800de7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e23:	c9                   	leave  
  800e24:	c3                   	ret    

00800e25 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e31:	01 d0                	add    %edx,%eax
  800e33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e36:	eb 15                	jmp    800e4d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	8a 00                	mov    (%eax),%al
  800e3d:	0f b6 d0             	movzbl %al,%edx
  800e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e43:	0f b6 c0             	movzbl %al,%eax
  800e46:	39 c2                	cmp    %eax,%edx
  800e48:	74 0d                	je     800e57 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e4a:	ff 45 08             	incl   0x8(%ebp)
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e53:	72 e3                	jb     800e38 <memfind+0x13>
  800e55:	eb 01                	jmp    800e58 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e57:	90                   	nop
	return (void *) s;
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5b:	c9                   	leave  
  800e5c:	c3                   	ret    

00800e5d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e63:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e6a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e71:	eb 03                	jmp    800e76 <strtol+0x19>
		s++;
  800e73:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	8a 00                	mov    (%eax),%al
  800e7b:	3c 20                	cmp    $0x20,%al
  800e7d:	74 f4                	je     800e73 <strtol+0x16>
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	8a 00                	mov    (%eax),%al
  800e84:	3c 09                	cmp    $0x9,%al
  800e86:	74 eb                	je     800e73 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	8a 00                	mov    (%eax),%al
  800e8d:	3c 2b                	cmp    $0x2b,%al
  800e8f:	75 05                	jne    800e96 <strtol+0x39>
		s++;
  800e91:	ff 45 08             	incl   0x8(%ebp)
  800e94:	eb 13                	jmp    800ea9 <strtol+0x4c>
	else if (*s == '-')
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	3c 2d                	cmp    $0x2d,%al
  800e9d:	75 0a                	jne    800ea9 <strtol+0x4c>
		s++, neg = 1;
  800e9f:	ff 45 08             	incl   0x8(%ebp)
  800ea2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ea9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ead:	74 06                	je     800eb5 <strtol+0x58>
  800eaf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800eb3:	75 20                	jne    800ed5 <strtol+0x78>
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	3c 30                	cmp    $0x30,%al
  800ebc:	75 17                	jne    800ed5 <strtol+0x78>
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	40                   	inc    %eax
  800ec2:	8a 00                	mov    (%eax),%al
  800ec4:	3c 78                	cmp    $0x78,%al
  800ec6:	75 0d                	jne    800ed5 <strtol+0x78>
		s += 2, base = 16;
  800ec8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ecc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ed3:	eb 28                	jmp    800efd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ed5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed9:	75 15                	jne    800ef0 <strtol+0x93>
  800edb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ede:	8a 00                	mov    (%eax),%al
  800ee0:	3c 30                	cmp    $0x30,%al
  800ee2:	75 0c                	jne    800ef0 <strtol+0x93>
		s++, base = 8;
  800ee4:	ff 45 08             	incl   0x8(%ebp)
  800ee7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800eee:	eb 0d                	jmp    800efd <strtol+0xa0>
	else if (base == 0)
  800ef0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef4:	75 07                	jne    800efd <strtol+0xa0>
		base = 10;
  800ef6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	3c 2f                	cmp    $0x2f,%al
  800f04:	7e 19                	jle    800f1f <strtol+0xc2>
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	8a 00                	mov    (%eax),%al
  800f0b:	3c 39                	cmp    $0x39,%al
  800f0d:	7f 10                	jg     800f1f <strtol+0xc2>
			dig = *s - '0';
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	0f be c0             	movsbl %al,%eax
  800f17:	83 e8 30             	sub    $0x30,%eax
  800f1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f1d:	eb 42                	jmp    800f61 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	3c 60                	cmp    $0x60,%al
  800f26:	7e 19                	jle    800f41 <strtol+0xe4>
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	8a 00                	mov    (%eax),%al
  800f2d:	3c 7a                	cmp    $0x7a,%al
  800f2f:	7f 10                	jg     800f41 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	0f be c0             	movsbl %al,%eax
  800f39:	83 e8 57             	sub    $0x57,%eax
  800f3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f3f:	eb 20                	jmp    800f61 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8a 00                	mov    (%eax),%al
  800f46:	3c 40                	cmp    $0x40,%al
  800f48:	7e 39                	jle    800f83 <strtol+0x126>
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	8a 00                	mov    (%eax),%al
  800f4f:	3c 5a                	cmp    $0x5a,%al
  800f51:	7f 30                	jg     800f83 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	0f be c0             	movsbl %al,%eax
  800f5b:	83 e8 37             	sub    $0x37,%eax
  800f5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f64:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f67:	7d 19                	jge    800f82 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f69:	ff 45 08             	incl   0x8(%ebp)
  800f6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f73:	89 c2                	mov    %eax,%edx
  800f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f78:	01 d0                	add    %edx,%eax
  800f7a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f7d:	e9 7b ff ff ff       	jmp    800efd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f82:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f87:	74 08                	je     800f91 <strtol+0x134>
		*endptr = (char *) s;
  800f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f91:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f95:	74 07                	je     800f9e <strtol+0x141>
  800f97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9a:	f7 d8                	neg    %eax
  800f9c:	eb 03                	jmp    800fa1 <strtol+0x144>
  800f9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fa1:	c9                   	leave  
  800fa2:	c3                   	ret    

00800fa3 <ltostr>:

void
ltostr(long value, char *str)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fa9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fb0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fbb:	79 13                	jns    800fd0 <ltostr+0x2d>
	{
		neg = 1;
  800fbd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fca:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fcd:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fd8:	99                   	cltd   
  800fd9:	f7 f9                	idiv   %ecx
  800fdb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fde:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe1:	8d 50 01             	lea    0x1(%eax),%edx
  800fe4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe7:	89 c2                	mov    %eax,%edx
  800fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fec:	01 d0                	add    %edx,%eax
  800fee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ff1:	83 c2 30             	add    $0x30,%edx
  800ff4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ff6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ffe:	f7 e9                	imul   %ecx
  801000:	c1 fa 02             	sar    $0x2,%edx
  801003:	89 c8                	mov    %ecx,%eax
  801005:	c1 f8 1f             	sar    $0x1f,%eax
  801008:	29 c2                	sub    %eax,%edx
  80100a:	89 d0                	mov    %edx,%eax
  80100c:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80100f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801013:	75 bb                	jne    800fd0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801015:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80101c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101f:	48                   	dec    %eax
  801020:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801023:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801027:	74 3d                	je     801066 <ltostr+0xc3>
		start = 1 ;
  801029:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801030:	eb 34                	jmp    801066 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801032:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801035:	8b 45 0c             	mov    0xc(%ebp),%eax
  801038:	01 d0                	add    %edx,%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80103f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801042:	8b 45 0c             	mov    0xc(%ebp),%eax
  801045:	01 c2                	add    %eax,%edx
  801047:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80104a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104d:	01 c8                	add    %ecx,%eax
  80104f:	8a 00                	mov    (%eax),%al
  801051:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801053:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801056:	8b 45 0c             	mov    0xc(%ebp),%eax
  801059:	01 c2                	add    %eax,%edx
  80105b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80105e:	88 02                	mov    %al,(%edx)
		start++ ;
  801060:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801063:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801069:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80106c:	7c c4                	jl     801032 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80106e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801071:	8b 45 0c             	mov    0xc(%ebp),%eax
  801074:	01 d0                	add    %edx,%eax
  801076:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801079:	90                   	nop
  80107a:	c9                   	leave  
  80107b:	c3                   	ret    

0080107c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80107c:	55                   	push   %ebp
  80107d:	89 e5                	mov    %esp,%ebp
  80107f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801082:	ff 75 08             	pushl  0x8(%ebp)
  801085:	e8 73 fa ff ff       	call   800afd <strlen>
  80108a:	83 c4 04             	add    $0x4,%esp
  80108d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801090:	ff 75 0c             	pushl  0xc(%ebp)
  801093:	e8 65 fa ff ff       	call   800afd <strlen>
  801098:	83 c4 04             	add    $0x4,%esp
  80109b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80109e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010ac:	eb 17                	jmp    8010c5 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b4:	01 c2                	add    %eax,%edx
  8010b6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	01 c8                	add    %ecx,%eax
  8010be:	8a 00                	mov    (%eax),%al
  8010c0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010c2:	ff 45 fc             	incl   -0x4(%ebp)
  8010c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010cb:	7c e1                	jl     8010ae <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010db:	eb 1f                	jmp    8010fc <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e0:	8d 50 01             	lea    0x1(%eax),%edx
  8010e3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010e6:	89 c2                	mov    %eax,%edx
  8010e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010eb:	01 c2                	add    %eax,%edx
  8010ed:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	01 c8                	add    %ecx,%eax
  8010f5:	8a 00                	mov    (%eax),%al
  8010f7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010f9:	ff 45 f8             	incl   -0x8(%ebp)
  8010fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801102:	7c d9                	jl     8010dd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801104:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801107:	8b 45 10             	mov    0x10(%ebp),%eax
  80110a:	01 d0                	add    %edx,%eax
  80110c:	c6 00 00             	movb   $0x0,(%eax)
}
  80110f:	90                   	nop
  801110:	c9                   	leave  
  801111:	c3                   	ret    

00801112 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801115:	8b 45 14             	mov    0x14(%ebp),%eax
  801118:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80111e:	8b 45 14             	mov    0x14(%ebp),%eax
  801121:	8b 00                	mov    (%eax),%eax
  801123:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80112a:	8b 45 10             	mov    0x10(%ebp),%eax
  80112d:	01 d0                	add    %edx,%eax
  80112f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801135:	eb 0c                	jmp    801143 <strsplit+0x31>
			*string++ = 0;
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	8d 50 01             	lea    0x1(%eax),%edx
  80113d:	89 55 08             	mov    %edx,0x8(%ebp)
  801140:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	8a 00                	mov    (%eax),%al
  801148:	84 c0                	test   %al,%al
  80114a:	74 18                	je     801164 <strsplit+0x52>
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	0f be c0             	movsbl %al,%eax
  801154:	50                   	push   %eax
  801155:	ff 75 0c             	pushl  0xc(%ebp)
  801158:	e8 32 fb ff ff       	call   800c8f <strchr>
  80115d:	83 c4 08             	add    $0x8,%esp
  801160:	85 c0                	test   %eax,%eax
  801162:	75 d3                	jne    801137 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	8a 00                	mov    (%eax),%al
  801169:	84 c0                	test   %al,%al
  80116b:	74 5a                	je     8011c7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80116d:	8b 45 14             	mov    0x14(%ebp),%eax
  801170:	8b 00                	mov    (%eax),%eax
  801172:	83 f8 0f             	cmp    $0xf,%eax
  801175:	75 07                	jne    80117e <strsplit+0x6c>
		{
			return 0;
  801177:	b8 00 00 00 00       	mov    $0x0,%eax
  80117c:	eb 66                	jmp    8011e4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80117e:	8b 45 14             	mov    0x14(%ebp),%eax
  801181:	8b 00                	mov    (%eax),%eax
  801183:	8d 48 01             	lea    0x1(%eax),%ecx
  801186:	8b 55 14             	mov    0x14(%ebp),%edx
  801189:	89 0a                	mov    %ecx,(%edx)
  80118b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801192:	8b 45 10             	mov    0x10(%ebp),%eax
  801195:	01 c2                	add    %eax,%edx
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119c:	eb 03                	jmp    8011a1 <strsplit+0x8f>
			string++;
  80119e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	84 c0                	test   %al,%al
  8011a8:	74 8b                	je     801135 <strsplit+0x23>
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	0f be c0             	movsbl %al,%eax
  8011b2:	50                   	push   %eax
  8011b3:	ff 75 0c             	pushl  0xc(%ebp)
  8011b6:	e8 d4 fa ff ff       	call   800c8f <strchr>
  8011bb:	83 c4 08             	add    $0x8,%esp
  8011be:	85 c0                	test   %eax,%eax
  8011c0:	74 dc                	je     80119e <strsplit+0x8c>
			string++;
	}
  8011c2:	e9 6e ff ff ff       	jmp    801135 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011c7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cb:	8b 00                	mov    (%eax),%eax
  8011cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d7:	01 d0                	add    %edx,%eax
  8011d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011df:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011e4:	c9                   	leave  
  8011e5:	c3                   	ret    

008011e6 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8011ec:	83 ec 04             	sub    $0x4,%esp
  8011ef:	68 68 21 80 00       	push   $0x802168
  8011f4:	68 3f 01 00 00       	push   $0x13f
  8011f9:	68 8a 21 80 00       	push   $0x80218a
  8011fe:	e8 a9 ef ff ff       	call   8001ac <_panic>

00801203 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
  801206:	57                   	push   %edi
  801207:	56                   	push   %esi
  801208:	53                   	push   %ebx
  801209:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801212:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801215:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801218:	8b 7d 18             	mov    0x18(%ebp),%edi
  80121b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80121e:	cd 30                	int    $0x30
  801220:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801223:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801226:	83 c4 10             	add    $0x10,%esp
  801229:	5b                   	pop    %ebx
  80122a:	5e                   	pop    %esi
  80122b:	5f                   	pop    %edi
  80122c:	5d                   	pop    %ebp
  80122d:	c3                   	ret    

0080122e <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
  801231:	83 ec 04             	sub    $0x4,%esp
  801234:	8b 45 10             	mov    0x10(%ebp),%eax
  801237:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  80123a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	6a 00                	push   $0x0
  801243:	6a 00                	push   $0x0
  801245:	52                   	push   %edx
  801246:	ff 75 0c             	pushl  0xc(%ebp)
  801249:	50                   	push   %eax
  80124a:	6a 00                	push   $0x0
  80124c:	e8 b2 ff ff ff       	call   801203 <syscall>
  801251:	83 c4 18             	add    $0x18,%esp
}
  801254:	90                   	nop
  801255:	c9                   	leave  
  801256:	c3                   	ret    

00801257 <sys_cgetc>:

int sys_cgetc(void) {
  801257:	55                   	push   %ebp
  801258:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80125a:	6a 00                	push   $0x0
  80125c:	6a 00                	push   $0x0
  80125e:	6a 00                	push   $0x0
  801260:	6a 00                	push   $0x0
  801262:	6a 00                	push   $0x0
  801264:	6a 02                	push   $0x2
  801266:	e8 98 ff ff ff       	call   801203 <syscall>
  80126b:	83 c4 18             	add    $0x18,%esp
}
  80126e:	c9                   	leave  
  80126f:	c3                   	ret    

00801270 <sys_lock_cons>:

void sys_lock_cons(void) {
  801270:	55                   	push   %ebp
  801271:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801273:	6a 00                	push   $0x0
  801275:	6a 00                	push   $0x0
  801277:	6a 00                	push   $0x0
  801279:	6a 00                	push   $0x0
  80127b:	6a 00                	push   $0x0
  80127d:	6a 03                	push   $0x3
  80127f:	e8 7f ff ff ff       	call   801203 <syscall>
  801284:	83 c4 18             	add    $0x18,%esp
}
  801287:	90                   	nop
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <sys_unlock_cons>:
void sys_unlock_cons(void) {
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80128d:	6a 00                	push   $0x0
  80128f:	6a 00                	push   $0x0
  801291:	6a 00                	push   $0x0
  801293:	6a 00                	push   $0x0
  801295:	6a 00                	push   $0x0
  801297:	6a 04                	push   $0x4
  801299:	e8 65 ff ff ff       	call   801203 <syscall>
  80129e:	83 c4 18             	add    $0x18,%esp
}
  8012a1:	90                   	nop
  8012a2:	c9                   	leave  
  8012a3:	c3                   	ret    

008012a4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  8012a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	6a 00                	push   $0x0
  8012af:	6a 00                	push   $0x0
  8012b1:	6a 00                	push   $0x0
  8012b3:	52                   	push   %edx
  8012b4:	50                   	push   %eax
  8012b5:	6a 08                	push   $0x8
  8012b7:	e8 47 ff ff ff       	call   801203 <syscall>
  8012bc:	83 c4 18             	add    $0x18,%esp
}
  8012bf:	c9                   	leave  
  8012c0:	c3                   	ret    

008012c1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
  8012c4:	56                   	push   %esi
  8012c5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  8012c6:	8b 75 18             	mov    0x18(%ebp),%esi
  8012c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	56                   	push   %esi
  8012d6:	53                   	push   %ebx
  8012d7:	51                   	push   %ecx
  8012d8:	52                   	push   %edx
  8012d9:	50                   	push   %eax
  8012da:	6a 09                	push   $0x9
  8012dc:	e8 22 ff ff ff       	call   801203 <syscall>
  8012e1:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  8012e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e7:	5b                   	pop    %ebx
  8012e8:	5e                   	pop    %esi
  8012e9:	5d                   	pop    %ebp
  8012ea:	c3                   	ret    

008012eb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	6a 00                	push   $0x0
  8012f6:	6a 00                	push   $0x0
  8012f8:	6a 00                	push   $0x0
  8012fa:	52                   	push   %edx
  8012fb:	50                   	push   %eax
  8012fc:	6a 0a                	push   $0xa
  8012fe:	e8 00 ff ff ff       	call   801203 <syscall>
  801303:	83 c4 18             	add    $0x18,%esp
}
  801306:	c9                   	leave  
  801307:	c3                   	ret    

00801308 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  80130b:	6a 00                	push   $0x0
  80130d:	6a 00                	push   $0x0
  80130f:	6a 00                	push   $0x0
  801311:	ff 75 0c             	pushl  0xc(%ebp)
  801314:	ff 75 08             	pushl  0x8(%ebp)
  801317:	6a 0b                	push   $0xb
  801319:	e8 e5 fe ff ff       	call   801203 <syscall>
  80131e:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801321:	c9                   	leave  
  801322:	c3                   	ret    

00801323 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801323:	55                   	push   %ebp
  801324:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801326:	6a 00                	push   $0x0
  801328:	6a 00                	push   $0x0
  80132a:	6a 00                	push   $0x0
  80132c:	6a 00                	push   $0x0
  80132e:	6a 00                	push   $0x0
  801330:	6a 0c                	push   $0xc
  801332:	e8 cc fe ff ff       	call   801203 <syscall>
  801337:	83 c4 18             	add    $0x18,%esp
}
  80133a:	c9                   	leave  
  80133b:	c3                   	ret    

0080133c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	6a 00                	push   $0x0
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 0d                	push   $0xd
  80134b:	e8 b3 fe ff ff       	call   801203 <syscall>
  801350:	83 c4 18             	add    $0x18,%esp
}
  801353:	c9                   	leave  
  801354:	c3                   	ret    

00801355 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801358:	6a 00                	push   $0x0
  80135a:	6a 00                	push   $0x0
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	6a 0e                	push   $0xe
  801364:	e8 9a fe ff ff       	call   801203 <syscall>
  801369:	83 c4 18             	add    $0x18,%esp
}
  80136c:	c9                   	leave  
  80136d:	c3                   	ret    

0080136e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801371:	6a 00                	push   $0x0
  801373:	6a 00                	push   $0x0
  801375:	6a 00                	push   $0x0
  801377:	6a 00                	push   $0x0
  801379:	6a 00                	push   $0x0
  80137b:	6a 0f                	push   $0xf
  80137d:	e8 81 fe ff ff       	call   801203 <syscall>
  801382:	83 c4 18             	add    $0x18,%esp
}
  801385:	c9                   	leave  
  801386:	c3                   	ret    

00801387 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801387:	55                   	push   %ebp
  801388:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  80138a:	6a 00                	push   $0x0
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	6a 00                	push   $0x0
  801392:	ff 75 08             	pushl  0x8(%ebp)
  801395:	6a 10                	push   $0x10
  801397:	e8 67 fe ff ff       	call   801203 <syscall>
  80139c:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  80139f:	c9                   	leave  
  8013a0:	c3                   	ret    

008013a1 <sys_scarce_memory>:

void sys_scarce_memory() {
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 11                	push   $0x11
  8013b0:	e8 4e fe ff ff       	call   801203 <syscall>
  8013b5:	83 c4 18             	add    $0x18,%esp
}
  8013b8:	90                   	nop
  8013b9:	c9                   	leave  
  8013ba:	c3                   	ret    

008013bb <sys_cputc>:

void sys_cputc(const char c) {
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	83 ec 04             	sub    $0x4,%esp
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013c7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 00                	push   $0x0
  8013d1:	6a 00                	push   $0x0
  8013d3:	50                   	push   %eax
  8013d4:	6a 01                	push   $0x1
  8013d6:	e8 28 fe ff ff       	call   801203 <syscall>
  8013db:	83 c4 18             	add    $0x18,%esp
}
  8013de:	90                   	nop
  8013df:	c9                   	leave  
  8013e0:	c3                   	ret    

008013e1 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 00                	push   $0x0
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 14                	push   $0x14
  8013f0:	e8 0e fe ff ff       	call   801203 <syscall>
  8013f5:	83 c4 18             	add    $0x18,%esp
}
  8013f8:	90                   	nop
  8013f9:	c9                   	leave  
  8013fa:	c3                   	ret    

008013fb <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
  8013fe:	83 ec 04             	sub    $0x4,%esp
  801401:	8b 45 10             	mov    0x10(%ebp),%eax
  801404:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801407:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80140a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	6a 00                	push   $0x0
  801413:	51                   	push   %ecx
  801414:	52                   	push   %edx
  801415:	ff 75 0c             	pushl  0xc(%ebp)
  801418:	50                   	push   %eax
  801419:	6a 15                	push   $0x15
  80141b:	e8 e3 fd ff ff       	call   801203 <syscall>
  801420:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801423:	c9                   	leave  
  801424:	c3                   	ret    

00801425 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801428:	8b 55 0c             	mov    0xc(%ebp),%edx
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	52                   	push   %edx
  801435:	50                   	push   %eax
  801436:	6a 16                	push   $0x16
  801438:	e8 c6 fd ff ff       	call   801203 <syscall>
  80143d:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801440:	c9                   	leave  
  801441:	c3                   	ret    

00801442 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801442:	55                   	push   %ebp
  801443:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801445:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801448:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	51                   	push   %ecx
  801453:	52                   	push   %edx
  801454:	50                   	push   %eax
  801455:	6a 17                	push   $0x17
  801457:	e8 a7 fd ff ff       	call   801203 <syscall>
  80145c:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  80145f:	c9                   	leave  
  801460:	c3                   	ret    

00801461 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801464:	8b 55 0c             	mov    0xc(%ebp),%edx
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	6a 00                	push   $0x0
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	52                   	push   %edx
  801471:	50                   	push   %eax
  801472:	6a 18                	push   $0x18
  801474:	e8 8a fd ff ff       	call   801203 <syscall>
  801479:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	6a 00                	push   $0x0
  801486:	ff 75 14             	pushl  0x14(%ebp)
  801489:	ff 75 10             	pushl  0x10(%ebp)
  80148c:	ff 75 0c             	pushl  0xc(%ebp)
  80148f:	50                   	push   %eax
  801490:	6a 19                	push   $0x19
  801492:	e8 6c fd ff ff       	call   801203 <syscall>
  801497:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <sys_run_env>:

void sys_run_env(int32 envId) {
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	50                   	push   %eax
  8014ab:	6a 1a                	push   $0x1a
  8014ad:	e8 51 fd ff ff       	call   801203 <syscall>
  8014b2:	83 c4 18             	add    $0x18,%esp
}
  8014b5:	90                   	nop
  8014b6:	c9                   	leave  
  8014b7:	c3                   	ret    

008014b8 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	50                   	push   %eax
  8014c7:	6a 1b                	push   $0x1b
  8014c9:	e8 35 fd ff ff       	call   801203 <syscall>
  8014ce:	83 c4 18             	add    $0x18,%esp
}
  8014d1:	c9                   	leave  
  8014d2:	c3                   	ret    

008014d3 <sys_getenvid>:

int32 sys_getenvid(void) {
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 05                	push   $0x5
  8014e2:	e8 1c fd ff ff       	call   801203 <syscall>
  8014e7:	83 c4 18             	add    $0x18,%esp
}
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 06                	push   $0x6
  8014fb:	e8 03 fd ff ff       	call   801203 <syscall>
  801500:	83 c4 18             	add    $0x18,%esp
}
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 07                	push   $0x7
  801514:	e8 ea fc ff ff       	call   801203 <syscall>
  801519:	83 c4 18             	add    $0x18,%esp
}
  80151c:	c9                   	leave  
  80151d:	c3                   	ret    

0080151e <sys_exit_env>:

void sys_exit_env(void) {
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 1c                	push   $0x1c
  80152d:	e8 d1 fc ff ff       	call   801203 <syscall>
  801532:	83 c4 18             	add    $0x18,%esp
}
  801535:	90                   	nop
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  80153e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801541:	8d 50 04             	lea    0x4(%eax),%edx
  801544:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	52                   	push   %edx
  80154e:	50                   	push   %eax
  80154f:	6a 1d                	push   $0x1d
  801551:	e8 ad fc ff ff       	call   801203 <syscall>
  801556:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801559:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80155c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80155f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801562:	89 01                	mov    %eax,(%ecx)
  801564:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	c9                   	leave  
  80156b:	c2 04 00             	ret    $0x4

0080156e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	ff 75 10             	pushl  0x10(%ebp)
  801578:	ff 75 0c             	pushl  0xc(%ebp)
  80157b:	ff 75 08             	pushl  0x8(%ebp)
  80157e:	6a 13                	push   $0x13
  801580:	e8 7e fc ff ff       	call   801203 <syscall>
  801585:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801588:	90                   	nop
}
  801589:	c9                   	leave  
  80158a:	c3                   	ret    

0080158b <sys_rcr2>:
uint32 sys_rcr2() {
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 1e                	push   $0x1e
  80159a:	e8 64 fc ff ff       	call   801203 <syscall>
  80159f:	83 c4 18             	add    $0x18,%esp
}
  8015a2:	c9                   	leave  
  8015a3:	c3                   	ret    

008015a4 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
  8015a7:	83 ec 04             	sub    $0x4,%esp
  8015aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015b0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	50                   	push   %eax
  8015bd:	6a 1f                	push   $0x1f
  8015bf:	e8 3f fc ff ff       	call   801203 <syscall>
  8015c4:	83 c4 18             	add    $0x18,%esp
	return;
  8015c7:	90                   	nop
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <rsttst>:
void rsttst() {
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 21                	push   $0x21
  8015d9:	e8 25 fc ff ff       	call   801203 <syscall>
  8015de:	83 c4 18             	add    $0x18,%esp
	return;
  8015e1:	90                   	nop
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	83 ec 04             	sub    $0x4,%esp
  8015ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015f0:	8b 55 18             	mov    0x18(%ebp),%edx
  8015f3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015f7:	52                   	push   %edx
  8015f8:	50                   	push   %eax
  8015f9:	ff 75 10             	pushl  0x10(%ebp)
  8015fc:	ff 75 0c             	pushl  0xc(%ebp)
  8015ff:	ff 75 08             	pushl  0x8(%ebp)
  801602:	6a 20                	push   $0x20
  801604:	e8 fa fb ff ff       	call   801203 <syscall>
  801609:	83 c4 18             	add    $0x18,%esp
	return;
  80160c:	90                   	nop
}
  80160d:	c9                   	leave  
  80160e:	c3                   	ret    

0080160f <chktst>:
void chktst(uint32 n) {
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	ff 75 08             	pushl  0x8(%ebp)
  80161d:	6a 22                	push   $0x22
  80161f:	e8 df fb ff ff       	call   801203 <syscall>
  801624:	83 c4 18             	add    $0x18,%esp
	return;
  801627:	90                   	nop
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <inctst>:

void inctst() {
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 23                	push   $0x23
  801639:	e8 c5 fb ff ff       	call   801203 <syscall>
  80163e:	83 c4 18             	add    $0x18,%esp
	return;
  801641:	90                   	nop
}
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <gettst>:
uint32 gettst() {
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 24                	push   $0x24
  801653:	e8 ab fb ff ff       	call   801203 <syscall>
  801658:	83 c4 18             	add    $0x18,%esp
}
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 25                	push   $0x25
  80166f:	e8 8f fb ff ff       	call   801203 <syscall>
  801674:	83 c4 18             	add    $0x18,%esp
  801677:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80167a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80167e:	75 07                	jne    801687 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801680:	b8 01 00 00 00       	mov    $0x1,%eax
  801685:	eb 05                	jmp    80168c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801687:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 25                	push   $0x25
  8016a0:	e8 5e fb ff ff       	call   801203 <syscall>
  8016a5:	83 c4 18             	add    $0x18,%esp
  8016a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016ab:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016af:	75 07                	jne    8016b8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8016b6:	eb 05                	jmp    8016bd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016bd:	c9                   	leave  
  8016be:	c3                   	ret    

008016bf <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 25                	push   $0x25
  8016d1:	e8 2d fb ff ff       	call   801203 <syscall>
  8016d6:	83 c4 18             	add    $0x18,%esp
  8016d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016dc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016e0:	75 07                	jne    8016e9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8016e7:	eb 05                	jmp    8016ee <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
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
  801702:	e8 fc fa ff ff       	call   801203 <syscall>
  801707:	83 c4 18             	add    $0x18,%esp
  80170a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80170d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801711:	75 07                	jne    80171a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801713:	b8 01 00 00 00       	mov    $0x1,%eax
  801718:	eb 05                	jmp    80171f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80171a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	ff 75 08             	pushl  0x8(%ebp)
  80172f:	6a 26                	push   $0x26
  801731:	e8 cd fa ff ff       	call   801203 <syscall>
  801736:	83 c4 18             	add    $0x18,%esp
	return;
  801739:	90                   	nop
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801740:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801743:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801746:	8b 55 0c             	mov    0xc(%ebp),%edx
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	6a 00                	push   $0x0
  80174e:	53                   	push   %ebx
  80174f:	51                   	push   %ecx
  801750:	52                   	push   %edx
  801751:	50                   	push   %eax
  801752:	6a 27                	push   $0x27
  801754:	e8 aa fa ff ff       	call   801203 <syscall>
  801759:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  80175c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801764:	8b 55 0c             	mov    0xc(%ebp),%edx
  801767:	8b 45 08             	mov    0x8(%ebp),%eax
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	52                   	push   %edx
  801771:	50                   	push   %eax
  801772:	6a 28                	push   $0x28
  801774:	e8 8a fa ff ff       	call   801203 <syscall>
  801779:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    

0080177e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801781:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801784:	8b 55 0c             	mov    0xc(%ebp),%edx
  801787:	8b 45 08             	mov    0x8(%ebp),%eax
  80178a:	6a 00                	push   $0x0
  80178c:	51                   	push   %ecx
  80178d:	ff 75 10             	pushl  0x10(%ebp)
  801790:	52                   	push   %edx
  801791:	50                   	push   %eax
  801792:	6a 29                	push   $0x29
  801794:	e8 6a fa ff ff       	call   801203 <syscall>
  801799:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    

0080179e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	ff 75 10             	pushl  0x10(%ebp)
  8017a8:	ff 75 0c             	pushl  0xc(%ebp)
  8017ab:	ff 75 08             	pushl  0x8(%ebp)
  8017ae:	6a 12                	push   $0x12
  8017b0:	e8 4e fa ff ff       	call   801203 <syscall>
  8017b5:	83 c4 18             	add    $0x18,%esp
	return;
  8017b8:	90                   	nop
}
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    

008017bb <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  8017be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	52                   	push   %edx
  8017cb:	50                   	push   %eax
  8017cc:	6a 2a                	push   $0x2a
  8017ce:	e8 30 fa ff ff       	call   801203 <syscall>
  8017d3:	83 c4 18             	add    $0x18,%esp
	return;
  8017d6:	90                   	nop
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	50                   	push   %eax
  8017e8:	6a 2b                	push   $0x2b
  8017ea:	e8 14 fa ff ff       	call   801203 <syscall>
  8017ef:	83 c4 18             	add    $0x18,%esp
}
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	ff 75 0c             	pushl  0xc(%ebp)
  801800:	ff 75 08             	pushl  0x8(%ebp)
  801803:	6a 2c                	push   $0x2c
  801805:	e8 f9 f9 ff ff       	call   801203 <syscall>
  80180a:	83 c4 18             	add    $0x18,%esp
	return;
  80180d:	90                   	nop
}
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	ff 75 0c             	pushl  0xc(%ebp)
  80181c:	ff 75 08             	pushl  0x8(%ebp)
  80181f:	6a 2d                	push   $0x2d
  801821:	e8 dd f9 ff ff       	call   801203 <syscall>
  801826:	83 c4 18             	add    $0x18,%esp
	return;
  801829:	90                   	nop
}
  80182a:	c9                   	leave  
  80182b:	c3                   	ret    

0080182c <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	50                   	push   %eax
  80183b:	6a 2f                	push   $0x2f
  80183d:	e8 c1 f9 ff ff       	call   801203 <syscall>
  801842:	83 c4 18             	add    $0x18,%esp
	return;
  801845:	90                   	nop
}
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  80184b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	52                   	push   %edx
  801858:	50                   	push   %eax
  801859:	6a 30                	push   $0x30
  80185b:	e8 a3 f9 ff ff       	call   801203 <syscall>
  801860:	83 c4 18             	add    $0x18,%esp
	return;
  801863:	90                   	nop
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	50                   	push   %eax
  801875:	6a 31                	push   $0x31
  801877:	e8 87 f9 ff ff       	call   801203 <syscall>
  80187c:	83 c4 18             	add    $0x18,%esp
	return;
  80187f:	90                   	nop
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801885:	8b 55 0c             	mov    0xc(%ebp),%edx
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	52                   	push   %edx
  801892:	50                   	push   %eax
  801893:	6a 2e                	push   $0x2e
  801895:	e8 69 f9 ff ff       	call   801203 <syscall>
  80189a:	83 c4 18             	add    $0x18,%esp
    return;
  80189d:	90                   	nop
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <__udivdi3>:
  8018a0:	55                   	push   %ebp
  8018a1:	57                   	push   %edi
  8018a2:	56                   	push   %esi
  8018a3:	53                   	push   %ebx
  8018a4:	83 ec 1c             	sub    $0x1c,%esp
  8018a7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8018ab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8018af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018b7:	89 ca                	mov    %ecx,%edx
  8018b9:	89 f8                	mov    %edi,%eax
  8018bb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8018bf:	85 f6                	test   %esi,%esi
  8018c1:	75 2d                	jne    8018f0 <__udivdi3+0x50>
  8018c3:	39 cf                	cmp    %ecx,%edi
  8018c5:	77 65                	ja     80192c <__udivdi3+0x8c>
  8018c7:	89 fd                	mov    %edi,%ebp
  8018c9:	85 ff                	test   %edi,%edi
  8018cb:	75 0b                	jne    8018d8 <__udivdi3+0x38>
  8018cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8018d2:	31 d2                	xor    %edx,%edx
  8018d4:	f7 f7                	div    %edi
  8018d6:	89 c5                	mov    %eax,%ebp
  8018d8:	31 d2                	xor    %edx,%edx
  8018da:	89 c8                	mov    %ecx,%eax
  8018dc:	f7 f5                	div    %ebp
  8018de:	89 c1                	mov    %eax,%ecx
  8018e0:	89 d8                	mov    %ebx,%eax
  8018e2:	f7 f5                	div    %ebp
  8018e4:	89 cf                	mov    %ecx,%edi
  8018e6:	89 fa                	mov    %edi,%edx
  8018e8:	83 c4 1c             	add    $0x1c,%esp
  8018eb:	5b                   	pop    %ebx
  8018ec:	5e                   	pop    %esi
  8018ed:	5f                   	pop    %edi
  8018ee:	5d                   	pop    %ebp
  8018ef:	c3                   	ret    
  8018f0:	39 ce                	cmp    %ecx,%esi
  8018f2:	77 28                	ja     80191c <__udivdi3+0x7c>
  8018f4:	0f bd fe             	bsr    %esi,%edi
  8018f7:	83 f7 1f             	xor    $0x1f,%edi
  8018fa:	75 40                	jne    80193c <__udivdi3+0x9c>
  8018fc:	39 ce                	cmp    %ecx,%esi
  8018fe:	72 0a                	jb     80190a <__udivdi3+0x6a>
  801900:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801904:	0f 87 9e 00 00 00    	ja     8019a8 <__udivdi3+0x108>
  80190a:	b8 01 00 00 00       	mov    $0x1,%eax
  80190f:	89 fa                	mov    %edi,%edx
  801911:	83 c4 1c             	add    $0x1c,%esp
  801914:	5b                   	pop    %ebx
  801915:	5e                   	pop    %esi
  801916:	5f                   	pop    %edi
  801917:	5d                   	pop    %ebp
  801918:	c3                   	ret    
  801919:	8d 76 00             	lea    0x0(%esi),%esi
  80191c:	31 ff                	xor    %edi,%edi
  80191e:	31 c0                	xor    %eax,%eax
  801920:	89 fa                	mov    %edi,%edx
  801922:	83 c4 1c             	add    $0x1c,%esp
  801925:	5b                   	pop    %ebx
  801926:	5e                   	pop    %esi
  801927:	5f                   	pop    %edi
  801928:	5d                   	pop    %ebp
  801929:	c3                   	ret    
  80192a:	66 90                	xchg   %ax,%ax
  80192c:	89 d8                	mov    %ebx,%eax
  80192e:	f7 f7                	div    %edi
  801930:	31 ff                	xor    %edi,%edi
  801932:	89 fa                	mov    %edi,%edx
  801934:	83 c4 1c             	add    $0x1c,%esp
  801937:	5b                   	pop    %ebx
  801938:	5e                   	pop    %esi
  801939:	5f                   	pop    %edi
  80193a:	5d                   	pop    %ebp
  80193b:	c3                   	ret    
  80193c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801941:	89 eb                	mov    %ebp,%ebx
  801943:	29 fb                	sub    %edi,%ebx
  801945:	89 f9                	mov    %edi,%ecx
  801947:	d3 e6                	shl    %cl,%esi
  801949:	89 c5                	mov    %eax,%ebp
  80194b:	88 d9                	mov    %bl,%cl
  80194d:	d3 ed                	shr    %cl,%ebp
  80194f:	89 e9                	mov    %ebp,%ecx
  801951:	09 f1                	or     %esi,%ecx
  801953:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801957:	89 f9                	mov    %edi,%ecx
  801959:	d3 e0                	shl    %cl,%eax
  80195b:	89 c5                	mov    %eax,%ebp
  80195d:	89 d6                	mov    %edx,%esi
  80195f:	88 d9                	mov    %bl,%cl
  801961:	d3 ee                	shr    %cl,%esi
  801963:	89 f9                	mov    %edi,%ecx
  801965:	d3 e2                	shl    %cl,%edx
  801967:	8b 44 24 08          	mov    0x8(%esp),%eax
  80196b:	88 d9                	mov    %bl,%cl
  80196d:	d3 e8                	shr    %cl,%eax
  80196f:	09 c2                	or     %eax,%edx
  801971:	89 d0                	mov    %edx,%eax
  801973:	89 f2                	mov    %esi,%edx
  801975:	f7 74 24 0c          	divl   0xc(%esp)
  801979:	89 d6                	mov    %edx,%esi
  80197b:	89 c3                	mov    %eax,%ebx
  80197d:	f7 e5                	mul    %ebp
  80197f:	39 d6                	cmp    %edx,%esi
  801981:	72 19                	jb     80199c <__udivdi3+0xfc>
  801983:	74 0b                	je     801990 <__udivdi3+0xf0>
  801985:	89 d8                	mov    %ebx,%eax
  801987:	31 ff                	xor    %edi,%edi
  801989:	e9 58 ff ff ff       	jmp    8018e6 <__udivdi3+0x46>
  80198e:	66 90                	xchg   %ax,%ax
  801990:	8b 54 24 08          	mov    0x8(%esp),%edx
  801994:	89 f9                	mov    %edi,%ecx
  801996:	d3 e2                	shl    %cl,%edx
  801998:	39 c2                	cmp    %eax,%edx
  80199a:	73 e9                	jae    801985 <__udivdi3+0xe5>
  80199c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80199f:	31 ff                	xor    %edi,%edi
  8019a1:	e9 40 ff ff ff       	jmp    8018e6 <__udivdi3+0x46>
  8019a6:	66 90                	xchg   %ax,%ax
  8019a8:	31 c0                	xor    %eax,%eax
  8019aa:	e9 37 ff ff ff       	jmp    8018e6 <__udivdi3+0x46>
  8019af:	90                   	nop

008019b0 <__umoddi3>:
  8019b0:	55                   	push   %ebp
  8019b1:	57                   	push   %edi
  8019b2:	56                   	push   %esi
  8019b3:	53                   	push   %ebx
  8019b4:	83 ec 1c             	sub    $0x1c,%esp
  8019b7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8019bb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8019bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019c3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8019c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019cf:	89 f3                	mov    %esi,%ebx
  8019d1:	89 fa                	mov    %edi,%edx
  8019d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019d7:	89 34 24             	mov    %esi,(%esp)
  8019da:	85 c0                	test   %eax,%eax
  8019dc:	75 1a                	jne    8019f8 <__umoddi3+0x48>
  8019de:	39 f7                	cmp    %esi,%edi
  8019e0:	0f 86 a2 00 00 00    	jbe    801a88 <__umoddi3+0xd8>
  8019e6:	89 c8                	mov    %ecx,%eax
  8019e8:	89 f2                	mov    %esi,%edx
  8019ea:	f7 f7                	div    %edi
  8019ec:	89 d0                	mov    %edx,%eax
  8019ee:	31 d2                	xor    %edx,%edx
  8019f0:	83 c4 1c             	add    $0x1c,%esp
  8019f3:	5b                   	pop    %ebx
  8019f4:	5e                   	pop    %esi
  8019f5:	5f                   	pop    %edi
  8019f6:	5d                   	pop    %ebp
  8019f7:	c3                   	ret    
  8019f8:	39 f0                	cmp    %esi,%eax
  8019fa:	0f 87 ac 00 00 00    	ja     801aac <__umoddi3+0xfc>
  801a00:	0f bd e8             	bsr    %eax,%ebp
  801a03:	83 f5 1f             	xor    $0x1f,%ebp
  801a06:	0f 84 ac 00 00 00    	je     801ab8 <__umoddi3+0x108>
  801a0c:	bf 20 00 00 00       	mov    $0x20,%edi
  801a11:	29 ef                	sub    %ebp,%edi
  801a13:	89 fe                	mov    %edi,%esi
  801a15:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a19:	89 e9                	mov    %ebp,%ecx
  801a1b:	d3 e0                	shl    %cl,%eax
  801a1d:	89 d7                	mov    %edx,%edi
  801a1f:	89 f1                	mov    %esi,%ecx
  801a21:	d3 ef                	shr    %cl,%edi
  801a23:	09 c7                	or     %eax,%edi
  801a25:	89 e9                	mov    %ebp,%ecx
  801a27:	d3 e2                	shl    %cl,%edx
  801a29:	89 14 24             	mov    %edx,(%esp)
  801a2c:	89 d8                	mov    %ebx,%eax
  801a2e:	d3 e0                	shl    %cl,%eax
  801a30:	89 c2                	mov    %eax,%edx
  801a32:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a36:	d3 e0                	shl    %cl,%eax
  801a38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a3c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a40:	89 f1                	mov    %esi,%ecx
  801a42:	d3 e8                	shr    %cl,%eax
  801a44:	09 d0                	or     %edx,%eax
  801a46:	d3 eb                	shr    %cl,%ebx
  801a48:	89 da                	mov    %ebx,%edx
  801a4a:	f7 f7                	div    %edi
  801a4c:	89 d3                	mov    %edx,%ebx
  801a4e:	f7 24 24             	mull   (%esp)
  801a51:	89 c6                	mov    %eax,%esi
  801a53:	89 d1                	mov    %edx,%ecx
  801a55:	39 d3                	cmp    %edx,%ebx
  801a57:	0f 82 87 00 00 00    	jb     801ae4 <__umoddi3+0x134>
  801a5d:	0f 84 91 00 00 00    	je     801af4 <__umoddi3+0x144>
  801a63:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a67:	29 f2                	sub    %esi,%edx
  801a69:	19 cb                	sbb    %ecx,%ebx
  801a6b:	89 d8                	mov    %ebx,%eax
  801a6d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a71:	d3 e0                	shl    %cl,%eax
  801a73:	89 e9                	mov    %ebp,%ecx
  801a75:	d3 ea                	shr    %cl,%edx
  801a77:	09 d0                	or     %edx,%eax
  801a79:	89 e9                	mov    %ebp,%ecx
  801a7b:	d3 eb                	shr    %cl,%ebx
  801a7d:	89 da                	mov    %ebx,%edx
  801a7f:	83 c4 1c             	add    $0x1c,%esp
  801a82:	5b                   	pop    %ebx
  801a83:	5e                   	pop    %esi
  801a84:	5f                   	pop    %edi
  801a85:	5d                   	pop    %ebp
  801a86:	c3                   	ret    
  801a87:	90                   	nop
  801a88:	89 fd                	mov    %edi,%ebp
  801a8a:	85 ff                	test   %edi,%edi
  801a8c:	75 0b                	jne    801a99 <__umoddi3+0xe9>
  801a8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a93:	31 d2                	xor    %edx,%edx
  801a95:	f7 f7                	div    %edi
  801a97:	89 c5                	mov    %eax,%ebp
  801a99:	89 f0                	mov    %esi,%eax
  801a9b:	31 d2                	xor    %edx,%edx
  801a9d:	f7 f5                	div    %ebp
  801a9f:	89 c8                	mov    %ecx,%eax
  801aa1:	f7 f5                	div    %ebp
  801aa3:	89 d0                	mov    %edx,%eax
  801aa5:	e9 44 ff ff ff       	jmp    8019ee <__umoddi3+0x3e>
  801aaa:	66 90                	xchg   %ax,%ax
  801aac:	89 c8                	mov    %ecx,%eax
  801aae:	89 f2                	mov    %esi,%edx
  801ab0:	83 c4 1c             	add    $0x1c,%esp
  801ab3:	5b                   	pop    %ebx
  801ab4:	5e                   	pop    %esi
  801ab5:	5f                   	pop    %edi
  801ab6:	5d                   	pop    %ebp
  801ab7:	c3                   	ret    
  801ab8:	3b 04 24             	cmp    (%esp),%eax
  801abb:	72 06                	jb     801ac3 <__umoddi3+0x113>
  801abd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ac1:	77 0f                	ja     801ad2 <__umoddi3+0x122>
  801ac3:	89 f2                	mov    %esi,%edx
  801ac5:	29 f9                	sub    %edi,%ecx
  801ac7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801acb:	89 14 24             	mov    %edx,(%esp)
  801ace:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ad2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ad6:	8b 14 24             	mov    (%esp),%edx
  801ad9:	83 c4 1c             	add    $0x1c,%esp
  801adc:	5b                   	pop    %ebx
  801add:	5e                   	pop    %esi
  801ade:	5f                   	pop    %edi
  801adf:	5d                   	pop    %ebp
  801ae0:	c3                   	ret    
  801ae1:	8d 76 00             	lea    0x0(%esi),%esi
  801ae4:	2b 04 24             	sub    (%esp),%eax
  801ae7:	19 fa                	sbb    %edi,%edx
  801ae9:	89 d1                	mov    %edx,%ecx
  801aeb:	89 c6                	mov    %eax,%esi
  801aed:	e9 71 ff ff ff       	jmp    801a63 <__umoddi3+0xb3>
  801af2:	66 90                	xchg   %ax,%ax
  801af4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801af8:	72 ea                	jb     801ae4 <__umoddi3+0x134>
  801afa:	89 d9                	mov    %ebx,%ecx
  801afc:	e9 62 ff ff ff       	jmp    801a63 <__umoddi3+0xb3>
