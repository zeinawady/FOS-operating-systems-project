
obj/user/tst_invalid_access_slave4:     file format elf32-i386


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
  800031:	e8 5c 00 00 00       	call   800092 <libmain>
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
	//[4] Not in Page File, Not Stack & Not Heap
	uint32 kilo = 1024;
  80003e:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)
	{
		uint32 size = 4*kilo;
  800045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800048:	c1 e0 02             	shl    $0x2,%eax
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

		unsigned char *x = (unsigned char *)(0x00200000-PAGE_SIZE);
  80004e:	c7 45 e8 00 f0 1f 00 	movl   $0x1ff000,-0x18(%ebp)

		int i=0;
  800055:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for(;i< size+20;i++)
  80005c:	eb 0e                	jmp    80006c <_main+0x34>
		{
			x[i]=-1;
  80005e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800061:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800064:	01 d0                	add    %edx,%eax
  800066:	c6 00 ff             	movb   $0xff,(%eax)
		uint32 size = 4*kilo;

		unsigned char *x = (unsigned char *)(0x00200000-PAGE_SIZE);

		int i=0;
		for(;i< size+20;i++)
  800069:	ff 45 f4             	incl   -0xc(%ebp)
  80006c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80006f:	8d 50 14             	lea    0x14(%eax),%edx
  800072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800075:	39 c2                	cmp    %eax,%edx
  800077:	77 e5                	ja     80005e <_main+0x26>
		{
			x[i]=-1;
		}
	}

	inctst();
  800079:	e8 d7 15 00 00       	call   801655 <inctst>
	panic("tst invalid access failed: Attempt to access page that's not exist in page file, neither stack or heap.\nThe env must be killed and shouldn't return here.");
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	68 40 1b 80 00       	push   $0x801b40
  800086:	6a 18                	push   $0x18
  800088:	68 dc 1b 80 00       	push   $0x801bdc
  80008d:	e8 45 01 00 00       	call   8001d7 <_panic>

00800092 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800092:	55                   	push   %ebp
  800093:	89 e5                	mov    %esp,%ebp
  800095:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800098:	e8 7a 14 00 00       	call   801517 <sys_getenvindex>
  80009d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a3:	89 d0                	mov    %edx,%eax
  8000a5:	c1 e0 02             	shl    $0x2,%eax
  8000a8:	01 d0                	add    %edx,%eax
  8000aa:	c1 e0 03             	shl    $0x3,%eax
  8000ad:	01 d0                	add    %edx,%eax
  8000af:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8000b6:	01 d0                	add    %edx,%eax
  8000b8:	c1 e0 02             	shl    $0x2,%eax
  8000bb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000c0:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000c5:	a1 08 30 80 00       	mov    0x803008,%eax
  8000ca:	8a 40 20             	mov    0x20(%eax),%al
  8000cd:	84 c0                	test   %al,%al
  8000cf:	74 0d                	je     8000de <libmain+0x4c>
		binaryname = myEnv->prog_name;
  8000d1:	a1 08 30 80 00       	mov    0x803008,%eax
  8000d6:	83 c0 20             	add    $0x20,%eax
  8000d9:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000e2:	7e 0a                	jle    8000ee <libmain+0x5c>
		binaryname = argv[0];
  8000e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000e7:	8b 00                	mov    (%eax),%eax
  8000e9:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000ee:	83 ec 08             	sub    $0x8,%esp
  8000f1:	ff 75 0c             	pushl  0xc(%ebp)
  8000f4:	ff 75 08             	pushl  0x8(%ebp)
  8000f7:	e8 3c ff ff ff       	call   800038 <_main>
  8000fc:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000ff:	a1 00 30 80 00       	mov    0x803000,%eax
  800104:	85 c0                	test   %eax,%eax
  800106:	0f 84 9f 00 00 00    	je     8001ab <libmain+0x119>
	{
		sys_lock_cons();
  80010c:	e8 8a 11 00 00       	call   80129b <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	68 18 1c 80 00       	push   $0x801c18
  800119:	e8 76 03 00 00       	call   800494 <cprintf>
  80011e:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800121:	a1 08 30 80 00       	mov    0x803008,%eax
  800126:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80012c:	a1 08 30 80 00       	mov    0x803008,%eax
  800131:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	52                   	push   %edx
  80013b:	50                   	push   %eax
  80013c:	68 40 1c 80 00       	push   $0x801c40
  800141:	e8 4e 03 00 00       	call   800494 <cprintf>
  800146:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800149:	a1 08 30 80 00       	mov    0x803008,%eax
  80014e:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800154:	a1 08 30 80 00       	mov    0x803008,%eax
  800159:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80015f:	a1 08 30 80 00       	mov    0x803008,%eax
  800164:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80016a:	51                   	push   %ecx
  80016b:	52                   	push   %edx
  80016c:	50                   	push   %eax
  80016d:	68 68 1c 80 00       	push   $0x801c68
  800172:	e8 1d 03 00 00       	call   800494 <cprintf>
  800177:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80017a:	a1 08 30 80 00       	mov    0x803008,%eax
  80017f:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800185:	83 ec 08             	sub    $0x8,%esp
  800188:	50                   	push   %eax
  800189:	68 c0 1c 80 00       	push   $0x801cc0
  80018e:	e8 01 03 00 00       	call   800494 <cprintf>
  800193:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800196:	83 ec 0c             	sub    $0xc,%esp
  800199:	68 18 1c 80 00       	push   $0x801c18
  80019e:	e8 f1 02 00 00       	call   800494 <cprintf>
  8001a3:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001a6:	e8 0a 11 00 00       	call   8012b5 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001ab:	e8 19 00 00 00       	call   8001c9 <exit>
}
  8001b0:	90                   	nop
  8001b1:	c9                   	leave  
  8001b2:	c3                   	ret    

008001b3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001b3:	55                   	push   %ebp
  8001b4:	89 e5                	mov    %esp,%ebp
  8001b6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	6a 00                	push   $0x0
  8001be:	e8 20 13 00 00       	call   8014e3 <sys_destroy_env>
  8001c3:	83 c4 10             	add    $0x10,%esp
}
  8001c6:	90                   	nop
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    

008001c9 <exit>:

void
exit(void)
{
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001cf:	e8 75 13 00 00       	call   801549 <sys_exit_env>
}
  8001d4:	90                   	nop
  8001d5:	c9                   	leave  
  8001d6:	c3                   	ret    

008001d7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001d7:	55                   	push   %ebp
  8001d8:	89 e5                	mov    %esp,%ebp
  8001da:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001dd:	8d 45 10             	lea    0x10(%ebp),%eax
  8001e0:	83 c0 04             	add    $0x4,%eax
  8001e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001e6:	a1 28 30 80 00       	mov    0x803028,%eax
  8001eb:	85 c0                	test   %eax,%eax
  8001ed:	74 16                	je     800205 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001ef:	a1 28 30 80 00       	mov    0x803028,%eax
  8001f4:	83 ec 08             	sub    $0x8,%esp
  8001f7:	50                   	push   %eax
  8001f8:	68 d4 1c 80 00       	push   $0x801cd4
  8001fd:	e8 92 02 00 00       	call   800494 <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800205:	a1 04 30 80 00       	mov    0x803004,%eax
  80020a:	ff 75 0c             	pushl  0xc(%ebp)
  80020d:	ff 75 08             	pushl  0x8(%ebp)
  800210:	50                   	push   %eax
  800211:	68 d9 1c 80 00       	push   $0x801cd9
  800216:	e8 79 02 00 00       	call   800494 <cprintf>
  80021b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80021e:	8b 45 10             	mov    0x10(%ebp),%eax
  800221:	83 ec 08             	sub    $0x8,%esp
  800224:	ff 75 f4             	pushl  -0xc(%ebp)
  800227:	50                   	push   %eax
  800228:	e8 fc 01 00 00       	call   800429 <vcprintf>
  80022d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	6a 00                	push   $0x0
  800235:	68 f5 1c 80 00       	push   $0x801cf5
  80023a:	e8 ea 01 00 00       	call   800429 <vcprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800242:	e8 82 ff ff ff       	call   8001c9 <exit>

	// should not return here
	while (1) ;
  800247:	eb fe                	jmp    800247 <_panic+0x70>

00800249 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800249:	55                   	push   %ebp
  80024a:	89 e5                	mov    %esp,%ebp
  80024c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80024f:	a1 08 30 80 00       	mov    0x803008,%eax
  800254:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80025a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80025d:	39 c2                	cmp    %eax,%edx
  80025f:	74 14                	je     800275 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800261:	83 ec 04             	sub    $0x4,%esp
  800264:	68 f8 1c 80 00       	push   $0x801cf8
  800269:	6a 26                	push   $0x26
  80026b:	68 44 1d 80 00       	push   $0x801d44
  800270:	e8 62 ff ff ff       	call   8001d7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800275:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80027c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800283:	e9 c5 00 00 00       	jmp    80034d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800288:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80028b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800292:	8b 45 08             	mov    0x8(%ebp),%eax
  800295:	01 d0                	add    %edx,%eax
  800297:	8b 00                	mov    (%eax),%eax
  800299:	85 c0                	test   %eax,%eax
  80029b:	75 08                	jne    8002a5 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80029d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8002a0:	e9 a5 00 00 00       	jmp    80034a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8002a5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002ac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002b3:	eb 69                	jmp    80031e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8002b5:	a1 08 30 80 00       	mov    0x803008,%eax
  8002ba:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8002c0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002c3:	89 d0                	mov    %edx,%eax
  8002c5:	01 c0                	add    %eax,%eax
  8002c7:	01 d0                	add    %edx,%eax
  8002c9:	c1 e0 03             	shl    $0x3,%eax
  8002cc:	01 c8                	add    %ecx,%eax
  8002ce:	8a 40 04             	mov    0x4(%eax),%al
  8002d1:	84 c0                	test   %al,%al
  8002d3:	75 46                	jne    80031b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002d5:	a1 08 30 80 00       	mov    0x803008,%eax
  8002da:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8002e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002e3:	89 d0                	mov    %edx,%eax
  8002e5:	01 c0                	add    %eax,%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	c1 e0 03             	shl    $0x3,%eax
  8002ec:	01 c8                	add    %ecx,%eax
  8002ee:	8b 00                	mov    (%eax),%eax
  8002f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002fb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800300:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800307:	8b 45 08             	mov    0x8(%ebp),%eax
  80030a:	01 c8                	add    %ecx,%eax
  80030c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80030e:	39 c2                	cmp    %eax,%edx
  800310:	75 09                	jne    80031b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800312:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800319:	eb 15                	jmp    800330 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80031b:	ff 45 e8             	incl   -0x18(%ebp)
  80031e:	a1 08 30 80 00       	mov    0x803008,%eax
  800323:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800329:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80032c:	39 c2                	cmp    %eax,%edx
  80032e:	77 85                	ja     8002b5 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800330:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800334:	75 14                	jne    80034a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800336:	83 ec 04             	sub    $0x4,%esp
  800339:	68 50 1d 80 00       	push   $0x801d50
  80033e:	6a 3a                	push   $0x3a
  800340:	68 44 1d 80 00       	push   $0x801d44
  800345:	e8 8d fe ff ff       	call   8001d7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80034a:	ff 45 f0             	incl   -0x10(%ebp)
  80034d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800350:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800353:	0f 8c 2f ff ff ff    	jl     800288 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800359:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800360:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800367:	eb 26                	jmp    80038f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800369:	a1 08 30 80 00       	mov    0x803008,%eax
  80036e:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800374:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800377:	89 d0                	mov    %edx,%eax
  800379:	01 c0                	add    %eax,%eax
  80037b:	01 d0                	add    %edx,%eax
  80037d:	c1 e0 03             	shl    $0x3,%eax
  800380:	01 c8                	add    %ecx,%eax
  800382:	8a 40 04             	mov    0x4(%eax),%al
  800385:	3c 01                	cmp    $0x1,%al
  800387:	75 03                	jne    80038c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800389:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80038c:	ff 45 e0             	incl   -0x20(%ebp)
  80038f:	a1 08 30 80 00       	mov    0x803008,%eax
  800394:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80039a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80039d:	39 c2                	cmp    %eax,%edx
  80039f:	77 c8                	ja     800369 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8003a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003a4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003a7:	74 14                	je     8003bd <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8003a9:	83 ec 04             	sub    $0x4,%esp
  8003ac:	68 a4 1d 80 00       	push   $0x801da4
  8003b1:	6a 44                	push   $0x44
  8003b3:	68 44 1d 80 00       	push   $0x801d44
  8003b8:	e8 1a fe ff ff       	call   8001d7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8003bd:	90                   	nop
  8003be:	c9                   	leave  
  8003bf:	c3                   	ret    

008003c0 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8003c0:	55                   	push   %ebp
  8003c1:	89 e5                	mov    %esp,%ebp
  8003c3:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8003c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c9:	8b 00                	mov    (%eax),%eax
  8003cb:	8d 48 01             	lea    0x1(%eax),%ecx
  8003ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003d1:	89 0a                	mov    %ecx,(%edx)
  8003d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8003d6:	88 d1                	mov    %dl,%cl
  8003d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003db:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e2:	8b 00                	mov    (%eax),%eax
  8003e4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003e9:	75 2c                	jne    800417 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003eb:	a0 0c 30 80 00       	mov    0x80300c,%al
  8003f0:	0f b6 c0             	movzbl %al,%eax
  8003f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003f6:	8b 12                	mov    (%edx),%edx
  8003f8:	89 d1                	mov    %edx,%ecx
  8003fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003fd:	83 c2 08             	add    $0x8,%edx
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	50                   	push   %eax
  800404:	51                   	push   %ecx
  800405:	52                   	push   %edx
  800406:	e8 4e 0e 00 00       	call   801259 <sys_cputs>
  80040b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80040e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800411:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800417:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041a:	8b 40 04             	mov    0x4(%eax),%eax
  80041d:	8d 50 01             	lea    0x1(%eax),%edx
  800420:	8b 45 0c             	mov    0xc(%ebp),%eax
  800423:	89 50 04             	mov    %edx,0x4(%eax)
}
  800426:	90                   	nop
  800427:	c9                   	leave  
  800428:	c3                   	ret    

00800429 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800429:	55                   	push   %ebp
  80042a:	89 e5                	mov    %esp,%ebp
  80042c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800432:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800439:	00 00 00 
	b.cnt = 0;
  80043c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800443:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800446:	ff 75 0c             	pushl  0xc(%ebp)
  800449:	ff 75 08             	pushl  0x8(%ebp)
  80044c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800452:	50                   	push   %eax
  800453:	68 c0 03 80 00       	push   $0x8003c0
  800458:	e8 11 02 00 00       	call   80066e <vprintfmt>
  80045d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800460:	a0 0c 30 80 00       	mov    0x80300c,%al
  800465:	0f b6 c0             	movzbl %al,%eax
  800468:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80046e:	83 ec 04             	sub    $0x4,%esp
  800471:	50                   	push   %eax
  800472:	52                   	push   %edx
  800473:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800479:	83 c0 08             	add    $0x8,%eax
  80047c:	50                   	push   %eax
  80047d:	e8 d7 0d 00 00       	call   801259 <sys_cputs>
  800482:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800485:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  80048c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800492:	c9                   	leave  
  800493:	c3                   	ret    

00800494 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800494:	55                   	push   %ebp
  800495:	89 e5                	mov    %esp,%ebp
  800497:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80049a:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  8004a1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004aa:	83 ec 08             	sub    $0x8,%esp
  8004ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8004b0:	50                   	push   %eax
  8004b1:	e8 73 ff ff ff       	call   800429 <vcprintf>
  8004b6:	83 c4 10             	add    $0x10,%esp
  8004b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8004bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004bf:	c9                   	leave  
  8004c0:	c3                   	ret    

008004c1 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8004c1:	55                   	push   %ebp
  8004c2:	89 e5                	mov    %esp,%ebp
  8004c4:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8004c7:	e8 cf 0d 00 00       	call   80129b <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8004cc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8004d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d5:	83 ec 08             	sub    $0x8,%esp
  8004d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8004db:	50                   	push   %eax
  8004dc:	e8 48 ff ff ff       	call   800429 <vcprintf>
  8004e1:	83 c4 10             	add    $0x10,%esp
  8004e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004e7:	e8 c9 0d 00 00       	call   8012b5 <sys_unlock_cons>
	return cnt;
  8004ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004ef:	c9                   	leave  
  8004f0:	c3                   	ret    

008004f1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004f1:	55                   	push   %ebp
  8004f2:	89 e5                	mov    %esp,%ebp
  8004f4:	53                   	push   %ebx
  8004f5:	83 ec 14             	sub    $0x14,%esp
  8004f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800501:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800504:	8b 45 18             	mov    0x18(%ebp),%eax
  800507:	ba 00 00 00 00       	mov    $0x0,%edx
  80050c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80050f:	77 55                	ja     800566 <printnum+0x75>
  800511:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800514:	72 05                	jb     80051b <printnum+0x2a>
  800516:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800519:	77 4b                	ja     800566 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80051b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80051e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800521:	8b 45 18             	mov    0x18(%ebp),%eax
  800524:	ba 00 00 00 00       	mov    $0x0,%edx
  800529:	52                   	push   %edx
  80052a:	50                   	push   %eax
  80052b:	ff 75 f4             	pushl  -0xc(%ebp)
  80052e:	ff 75 f0             	pushl  -0x10(%ebp)
  800531:	e8 96 13 00 00       	call   8018cc <__udivdi3>
  800536:	83 c4 10             	add    $0x10,%esp
  800539:	83 ec 04             	sub    $0x4,%esp
  80053c:	ff 75 20             	pushl  0x20(%ebp)
  80053f:	53                   	push   %ebx
  800540:	ff 75 18             	pushl  0x18(%ebp)
  800543:	52                   	push   %edx
  800544:	50                   	push   %eax
  800545:	ff 75 0c             	pushl  0xc(%ebp)
  800548:	ff 75 08             	pushl  0x8(%ebp)
  80054b:	e8 a1 ff ff ff       	call   8004f1 <printnum>
  800550:	83 c4 20             	add    $0x20,%esp
  800553:	eb 1a                	jmp    80056f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800555:	83 ec 08             	sub    $0x8,%esp
  800558:	ff 75 0c             	pushl  0xc(%ebp)
  80055b:	ff 75 20             	pushl  0x20(%ebp)
  80055e:	8b 45 08             	mov    0x8(%ebp),%eax
  800561:	ff d0                	call   *%eax
  800563:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800566:	ff 4d 1c             	decl   0x1c(%ebp)
  800569:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80056d:	7f e6                	jg     800555 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80056f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800572:	bb 00 00 00 00       	mov    $0x0,%ebx
  800577:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80057a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80057d:	53                   	push   %ebx
  80057e:	51                   	push   %ecx
  80057f:	52                   	push   %edx
  800580:	50                   	push   %eax
  800581:	e8 56 14 00 00       	call   8019dc <__umoddi3>
  800586:	83 c4 10             	add    $0x10,%esp
  800589:	05 14 20 80 00       	add    $0x802014,%eax
  80058e:	8a 00                	mov    (%eax),%al
  800590:	0f be c0             	movsbl %al,%eax
  800593:	83 ec 08             	sub    $0x8,%esp
  800596:	ff 75 0c             	pushl  0xc(%ebp)
  800599:	50                   	push   %eax
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	ff d0                	call   *%eax
  80059f:	83 c4 10             	add    $0x10,%esp
}
  8005a2:	90                   	nop
  8005a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005a6:	c9                   	leave  
  8005a7:	c3                   	ret    

008005a8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005a8:	55                   	push   %ebp
  8005a9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005ab:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005af:	7e 1c                	jle    8005cd <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8005b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b4:	8b 00                	mov    (%eax),%eax
  8005b6:	8d 50 08             	lea    0x8(%eax),%edx
  8005b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bc:	89 10                	mov    %edx,(%eax)
  8005be:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	83 e8 08             	sub    $0x8,%eax
  8005c6:	8b 50 04             	mov    0x4(%eax),%edx
  8005c9:	8b 00                	mov    (%eax),%eax
  8005cb:	eb 40                	jmp    80060d <getuint+0x65>
	else if (lflag)
  8005cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005d1:	74 1e                	je     8005f1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	8d 50 04             	lea    0x4(%eax),%edx
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	89 10                	mov    %edx,(%eax)
  8005e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e3:	8b 00                	mov    (%eax),%eax
  8005e5:	83 e8 04             	sub    $0x4,%eax
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ef:	eb 1c                	jmp    80060d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f4:	8b 00                	mov    (%eax),%eax
  8005f6:	8d 50 04             	lea    0x4(%eax),%edx
  8005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fc:	89 10                	mov    %edx,(%eax)
  8005fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800601:	8b 00                	mov    (%eax),%eax
  800603:	83 e8 04             	sub    $0x4,%eax
  800606:	8b 00                	mov    (%eax),%eax
  800608:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80060d:	5d                   	pop    %ebp
  80060e:	c3                   	ret    

0080060f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80060f:	55                   	push   %ebp
  800610:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800612:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800616:	7e 1c                	jle    800634 <getint+0x25>
		return va_arg(*ap, long long);
  800618:	8b 45 08             	mov    0x8(%ebp),%eax
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	8d 50 08             	lea    0x8(%eax),%edx
  800620:	8b 45 08             	mov    0x8(%ebp),%eax
  800623:	89 10                	mov    %edx,(%eax)
  800625:	8b 45 08             	mov    0x8(%ebp),%eax
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	83 e8 08             	sub    $0x8,%eax
  80062d:	8b 50 04             	mov    0x4(%eax),%edx
  800630:	8b 00                	mov    (%eax),%eax
  800632:	eb 38                	jmp    80066c <getint+0x5d>
	else if (lflag)
  800634:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800638:	74 1a                	je     800654 <getint+0x45>
		return va_arg(*ap, long);
  80063a:	8b 45 08             	mov    0x8(%ebp),%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	8d 50 04             	lea    0x4(%eax),%edx
  800642:	8b 45 08             	mov    0x8(%ebp),%eax
  800645:	89 10                	mov    %edx,(%eax)
  800647:	8b 45 08             	mov    0x8(%ebp),%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	83 e8 04             	sub    $0x4,%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	99                   	cltd   
  800652:	eb 18                	jmp    80066c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800654:	8b 45 08             	mov    0x8(%ebp),%eax
  800657:	8b 00                	mov    (%eax),%eax
  800659:	8d 50 04             	lea    0x4(%eax),%edx
  80065c:	8b 45 08             	mov    0x8(%ebp),%eax
  80065f:	89 10                	mov    %edx,(%eax)
  800661:	8b 45 08             	mov    0x8(%ebp),%eax
  800664:	8b 00                	mov    (%eax),%eax
  800666:	83 e8 04             	sub    $0x4,%eax
  800669:	8b 00                	mov    (%eax),%eax
  80066b:	99                   	cltd   
}
  80066c:	5d                   	pop    %ebp
  80066d:	c3                   	ret    

0080066e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80066e:	55                   	push   %ebp
  80066f:	89 e5                	mov    %esp,%ebp
  800671:	56                   	push   %esi
  800672:	53                   	push   %ebx
  800673:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800676:	eb 17                	jmp    80068f <vprintfmt+0x21>
			if (ch == '\0')
  800678:	85 db                	test   %ebx,%ebx
  80067a:	0f 84 c1 03 00 00    	je     800a41 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800680:	83 ec 08             	sub    $0x8,%esp
  800683:	ff 75 0c             	pushl  0xc(%ebp)
  800686:	53                   	push   %ebx
  800687:	8b 45 08             	mov    0x8(%ebp),%eax
  80068a:	ff d0                	call   *%eax
  80068c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80068f:	8b 45 10             	mov    0x10(%ebp),%eax
  800692:	8d 50 01             	lea    0x1(%eax),%edx
  800695:	89 55 10             	mov    %edx,0x10(%ebp)
  800698:	8a 00                	mov    (%eax),%al
  80069a:	0f b6 d8             	movzbl %al,%ebx
  80069d:	83 fb 25             	cmp    $0x25,%ebx
  8006a0:	75 d6                	jne    800678 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006a2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8006a6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8006ad:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006b4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8006bb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8006c5:	8d 50 01             	lea    0x1(%eax),%edx
  8006c8:	89 55 10             	mov    %edx,0x10(%ebp)
  8006cb:	8a 00                	mov    (%eax),%al
  8006cd:	0f b6 d8             	movzbl %al,%ebx
  8006d0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006d3:	83 f8 5b             	cmp    $0x5b,%eax
  8006d6:	0f 87 3d 03 00 00    	ja     800a19 <vprintfmt+0x3ab>
  8006dc:	8b 04 85 38 20 80 00 	mov    0x802038(,%eax,4),%eax
  8006e3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006e5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006e9:	eb d7                	jmp    8006c2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006eb:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006ef:	eb d1                	jmp    8006c2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006f1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006fb:	89 d0                	mov    %edx,%eax
  8006fd:	c1 e0 02             	shl    $0x2,%eax
  800700:	01 d0                	add    %edx,%eax
  800702:	01 c0                	add    %eax,%eax
  800704:	01 d8                	add    %ebx,%eax
  800706:	83 e8 30             	sub    $0x30,%eax
  800709:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80070c:	8b 45 10             	mov    0x10(%ebp),%eax
  80070f:	8a 00                	mov    (%eax),%al
  800711:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800714:	83 fb 2f             	cmp    $0x2f,%ebx
  800717:	7e 3e                	jle    800757 <vprintfmt+0xe9>
  800719:	83 fb 39             	cmp    $0x39,%ebx
  80071c:	7f 39                	jg     800757 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80071e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800721:	eb d5                	jmp    8006f8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	83 c0 04             	add    $0x4,%eax
  800729:	89 45 14             	mov    %eax,0x14(%ebp)
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	83 e8 04             	sub    $0x4,%eax
  800732:	8b 00                	mov    (%eax),%eax
  800734:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800737:	eb 1f                	jmp    800758 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800739:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80073d:	79 83                	jns    8006c2 <vprintfmt+0x54>
				width = 0;
  80073f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800746:	e9 77 ff ff ff       	jmp    8006c2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80074b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800752:	e9 6b ff ff ff       	jmp    8006c2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800757:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800758:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80075c:	0f 89 60 ff ff ff    	jns    8006c2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800762:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800765:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800768:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80076f:	e9 4e ff ff ff       	jmp    8006c2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800774:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800777:	e9 46 ff ff ff       	jmp    8006c2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	83 c0 04             	add    $0x4,%eax
  800782:	89 45 14             	mov    %eax,0x14(%ebp)
  800785:	8b 45 14             	mov    0x14(%ebp),%eax
  800788:	83 e8 04             	sub    $0x4,%eax
  80078b:	8b 00                	mov    (%eax),%eax
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	ff 75 0c             	pushl  0xc(%ebp)
  800793:	50                   	push   %eax
  800794:	8b 45 08             	mov    0x8(%ebp),%eax
  800797:	ff d0                	call   *%eax
  800799:	83 c4 10             	add    $0x10,%esp
			break;
  80079c:	e9 9b 02 00 00       	jmp    800a3c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8007a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a4:	83 c0 04             	add    $0x4,%eax
  8007a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8007aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ad:	83 e8 04             	sub    $0x4,%eax
  8007b0:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8007b2:	85 db                	test   %ebx,%ebx
  8007b4:	79 02                	jns    8007b8 <vprintfmt+0x14a>
				err = -err;
  8007b6:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007b8:	83 fb 64             	cmp    $0x64,%ebx
  8007bb:	7f 0b                	jg     8007c8 <vprintfmt+0x15a>
  8007bd:	8b 34 9d 80 1e 80 00 	mov    0x801e80(,%ebx,4),%esi
  8007c4:	85 f6                	test   %esi,%esi
  8007c6:	75 19                	jne    8007e1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007c8:	53                   	push   %ebx
  8007c9:	68 25 20 80 00       	push   $0x802025
  8007ce:	ff 75 0c             	pushl  0xc(%ebp)
  8007d1:	ff 75 08             	pushl  0x8(%ebp)
  8007d4:	e8 70 02 00 00       	call   800a49 <printfmt>
  8007d9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007dc:	e9 5b 02 00 00       	jmp    800a3c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007e1:	56                   	push   %esi
  8007e2:	68 2e 20 80 00       	push   $0x80202e
  8007e7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ea:	ff 75 08             	pushl  0x8(%ebp)
  8007ed:	e8 57 02 00 00       	call   800a49 <printfmt>
  8007f2:	83 c4 10             	add    $0x10,%esp
			break;
  8007f5:	e9 42 02 00 00       	jmp    800a3c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fd:	83 c0 04             	add    $0x4,%eax
  800800:	89 45 14             	mov    %eax,0x14(%ebp)
  800803:	8b 45 14             	mov    0x14(%ebp),%eax
  800806:	83 e8 04             	sub    $0x4,%eax
  800809:	8b 30                	mov    (%eax),%esi
  80080b:	85 f6                	test   %esi,%esi
  80080d:	75 05                	jne    800814 <vprintfmt+0x1a6>
				p = "(null)";
  80080f:	be 31 20 80 00       	mov    $0x802031,%esi
			if (width > 0 && padc != '-')
  800814:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800818:	7e 6d                	jle    800887 <vprintfmt+0x219>
  80081a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80081e:	74 67                	je     800887 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800820:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800823:	83 ec 08             	sub    $0x8,%esp
  800826:	50                   	push   %eax
  800827:	56                   	push   %esi
  800828:	e8 1e 03 00 00       	call   800b4b <strnlen>
  80082d:	83 c4 10             	add    $0x10,%esp
  800830:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800833:	eb 16                	jmp    80084b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800835:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800839:	83 ec 08             	sub    $0x8,%esp
  80083c:	ff 75 0c             	pushl  0xc(%ebp)
  80083f:	50                   	push   %eax
  800840:	8b 45 08             	mov    0x8(%ebp),%eax
  800843:	ff d0                	call   *%eax
  800845:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800848:	ff 4d e4             	decl   -0x1c(%ebp)
  80084b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084f:	7f e4                	jg     800835 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800851:	eb 34                	jmp    800887 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800853:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800857:	74 1c                	je     800875 <vprintfmt+0x207>
  800859:	83 fb 1f             	cmp    $0x1f,%ebx
  80085c:	7e 05                	jle    800863 <vprintfmt+0x1f5>
  80085e:	83 fb 7e             	cmp    $0x7e,%ebx
  800861:	7e 12                	jle    800875 <vprintfmt+0x207>
					putch('?', putdat);
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	ff 75 0c             	pushl  0xc(%ebp)
  800869:	6a 3f                	push   $0x3f
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	ff d0                	call   *%eax
  800870:	83 c4 10             	add    $0x10,%esp
  800873:	eb 0f                	jmp    800884 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800875:	83 ec 08             	sub    $0x8,%esp
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	53                   	push   %ebx
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	ff d0                	call   *%eax
  800881:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800884:	ff 4d e4             	decl   -0x1c(%ebp)
  800887:	89 f0                	mov    %esi,%eax
  800889:	8d 70 01             	lea    0x1(%eax),%esi
  80088c:	8a 00                	mov    (%eax),%al
  80088e:	0f be d8             	movsbl %al,%ebx
  800891:	85 db                	test   %ebx,%ebx
  800893:	74 24                	je     8008b9 <vprintfmt+0x24b>
  800895:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800899:	78 b8                	js     800853 <vprintfmt+0x1e5>
  80089b:	ff 4d e0             	decl   -0x20(%ebp)
  80089e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008a2:	79 af                	jns    800853 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008a4:	eb 13                	jmp    8008b9 <vprintfmt+0x24b>
				putch(' ', putdat);
  8008a6:	83 ec 08             	sub    $0x8,%esp
  8008a9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ac:	6a 20                	push   $0x20
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	ff d0                	call   *%eax
  8008b3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008b6:	ff 4d e4             	decl   -0x1c(%ebp)
  8008b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008bd:	7f e7                	jg     8008a6 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8008bf:	e9 78 01 00 00       	jmp    800a3c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008c4:	83 ec 08             	sub    $0x8,%esp
  8008c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8008ca:	8d 45 14             	lea    0x14(%ebp),%eax
  8008cd:	50                   	push   %eax
  8008ce:	e8 3c fd ff ff       	call   80060f <getint>
  8008d3:	83 c4 10             	add    $0x10,%esp
  8008d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008e2:	85 d2                	test   %edx,%edx
  8008e4:	79 23                	jns    800909 <vprintfmt+0x29b>
				putch('-', putdat);
  8008e6:	83 ec 08             	sub    $0x8,%esp
  8008e9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ec:	6a 2d                	push   $0x2d
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	ff d0                	call   *%eax
  8008f3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008fc:	f7 d8                	neg    %eax
  8008fe:	83 d2 00             	adc    $0x0,%edx
  800901:	f7 da                	neg    %edx
  800903:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800906:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800909:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800910:	e9 bc 00 00 00       	jmp    8009d1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800915:	83 ec 08             	sub    $0x8,%esp
  800918:	ff 75 e8             	pushl  -0x18(%ebp)
  80091b:	8d 45 14             	lea    0x14(%ebp),%eax
  80091e:	50                   	push   %eax
  80091f:	e8 84 fc ff ff       	call   8005a8 <getuint>
  800924:	83 c4 10             	add    $0x10,%esp
  800927:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80092a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80092d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800934:	e9 98 00 00 00       	jmp    8009d1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800939:	83 ec 08             	sub    $0x8,%esp
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	6a 58                	push   $0x58
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	ff d0                	call   *%eax
  800946:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800949:	83 ec 08             	sub    $0x8,%esp
  80094c:	ff 75 0c             	pushl  0xc(%ebp)
  80094f:	6a 58                	push   $0x58
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	ff d0                	call   *%eax
  800956:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800959:	83 ec 08             	sub    $0x8,%esp
  80095c:	ff 75 0c             	pushl  0xc(%ebp)
  80095f:	6a 58                	push   $0x58
  800961:	8b 45 08             	mov    0x8(%ebp),%eax
  800964:	ff d0                	call   *%eax
  800966:	83 c4 10             	add    $0x10,%esp
			break;
  800969:	e9 ce 00 00 00       	jmp    800a3c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80096e:	83 ec 08             	sub    $0x8,%esp
  800971:	ff 75 0c             	pushl  0xc(%ebp)
  800974:	6a 30                	push   $0x30
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	ff d0                	call   *%eax
  80097b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80097e:	83 ec 08             	sub    $0x8,%esp
  800981:	ff 75 0c             	pushl  0xc(%ebp)
  800984:	6a 78                	push   $0x78
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	ff d0                	call   *%eax
  80098b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80098e:	8b 45 14             	mov    0x14(%ebp),%eax
  800991:	83 c0 04             	add    $0x4,%eax
  800994:	89 45 14             	mov    %eax,0x14(%ebp)
  800997:	8b 45 14             	mov    0x14(%ebp),%eax
  80099a:	83 e8 04             	sub    $0x4,%eax
  80099d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80099f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8009a9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8009b0:	eb 1f                	jmp    8009d1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8009b2:	83 ec 08             	sub    $0x8,%esp
  8009b5:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bb:	50                   	push   %eax
  8009bc:	e8 e7 fb ff ff       	call   8005a8 <getuint>
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009ca:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009d1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009d8:	83 ec 04             	sub    $0x4,%esp
  8009db:	52                   	push   %edx
  8009dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009df:	50                   	push   %eax
  8009e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8009e6:	ff 75 0c             	pushl  0xc(%ebp)
  8009e9:	ff 75 08             	pushl  0x8(%ebp)
  8009ec:	e8 00 fb ff ff       	call   8004f1 <printnum>
  8009f1:	83 c4 20             	add    $0x20,%esp
			break;
  8009f4:	eb 46                	jmp    800a3c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009f6:	83 ec 08             	sub    $0x8,%esp
  8009f9:	ff 75 0c             	pushl  0xc(%ebp)
  8009fc:	53                   	push   %ebx
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	ff d0                	call   *%eax
  800a02:	83 c4 10             	add    $0x10,%esp
			break;
  800a05:	eb 35                	jmp    800a3c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a07:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  800a0e:	eb 2c                	jmp    800a3c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a10:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  800a17:	eb 23                	jmp    800a3c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a19:	83 ec 08             	sub    $0x8,%esp
  800a1c:	ff 75 0c             	pushl  0xc(%ebp)
  800a1f:	6a 25                	push   $0x25
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	ff d0                	call   *%eax
  800a26:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a29:	ff 4d 10             	decl   0x10(%ebp)
  800a2c:	eb 03                	jmp    800a31 <vprintfmt+0x3c3>
  800a2e:	ff 4d 10             	decl   0x10(%ebp)
  800a31:	8b 45 10             	mov    0x10(%ebp),%eax
  800a34:	48                   	dec    %eax
  800a35:	8a 00                	mov    (%eax),%al
  800a37:	3c 25                	cmp    $0x25,%al
  800a39:	75 f3                	jne    800a2e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a3b:	90                   	nop
		}
	}
  800a3c:	e9 35 fc ff ff       	jmp    800676 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a41:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a45:	5b                   	pop    %ebx
  800a46:	5e                   	pop    %esi
  800a47:	5d                   	pop    %ebp
  800a48:	c3                   	ret    

00800a49 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a49:	55                   	push   %ebp
  800a4a:	89 e5                	mov    %esp,%ebp
  800a4c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a4f:	8d 45 10             	lea    0x10(%ebp),%eax
  800a52:	83 c0 04             	add    $0x4,%eax
  800a55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a58:	8b 45 10             	mov    0x10(%ebp),%eax
  800a5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a5e:	50                   	push   %eax
  800a5f:	ff 75 0c             	pushl  0xc(%ebp)
  800a62:	ff 75 08             	pushl  0x8(%ebp)
  800a65:	e8 04 fc ff ff       	call   80066e <vprintfmt>
  800a6a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a6d:	90                   	nop
  800a6e:	c9                   	leave  
  800a6f:	c3                   	ret    

00800a70 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a76:	8b 40 08             	mov    0x8(%eax),%eax
  800a79:	8d 50 01             	lea    0x1(%eax),%edx
  800a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a85:	8b 10                	mov    (%eax),%edx
  800a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8a:	8b 40 04             	mov    0x4(%eax),%eax
  800a8d:	39 c2                	cmp    %eax,%edx
  800a8f:	73 12                	jae    800aa3 <sprintputch+0x33>
		*b->buf++ = ch;
  800a91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a94:	8b 00                	mov    (%eax),%eax
  800a96:	8d 48 01             	lea    0x1(%eax),%ecx
  800a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9c:	89 0a                	mov    %ecx,(%edx)
  800a9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800aa1:	88 10                	mov    %dl,(%eax)
}
  800aa3:	90                   	nop
  800aa4:	5d                   	pop    %ebp
  800aa5:	c3                   	ret    

00800aa6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800aa6:	55                   	push   %ebp
  800aa7:	89 e5                	mov    %esp,%ebp
  800aa9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800aac:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ab2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  800abb:	01 d0                	add    %edx,%eax
  800abd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ac7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800acb:	74 06                	je     800ad3 <vsnprintf+0x2d>
  800acd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad1:	7f 07                	jg     800ada <vsnprintf+0x34>
		return -E_INVAL;
  800ad3:	b8 03 00 00 00       	mov    $0x3,%eax
  800ad8:	eb 20                	jmp    800afa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ada:	ff 75 14             	pushl  0x14(%ebp)
  800add:	ff 75 10             	pushl  0x10(%ebp)
  800ae0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ae3:	50                   	push   %eax
  800ae4:	68 70 0a 80 00       	push   $0x800a70
  800ae9:	e8 80 fb ff ff       	call   80066e <vprintfmt>
  800aee:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800af1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800af4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800afa:	c9                   	leave  
  800afb:	c3                   	ret    

00800afc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b02:	8d 45 10             	lea    0x10(%ebp),%eax
  800b05:	83 c0 04             	add    $0x4,%eax
  800b08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b0e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b11:	50                   	push   %eax
  800b12:	ff 75 0c             	pushl  0xc(%ebp)
  800b15:	ff 75 08             	pushl  0x8(%ebp)
  800b18:	e8 89 ff ff ff       	call   800aa6 <vsnprintf>
  800b1d:	83 c4 10             	add    $0x10,%esp
  800b20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b23:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b26:	c9                   	leave  
  800b27:	c3                   	ret    

00800b28 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b35:	eb 06                	jmp    800b3d <strlen+0x15>
		n++;
  800b37:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b3a:	ff 45 08             	incl   0x8(%ebp)
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	8a 00                	mov    (%eax),%al
  800b42:	84 c0                	test   %al,%al
  800b44:	75 f1                	jne    800b37 <strlen+0xf>
		n++;
	return n;
  800b46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b49:	c9                   	leave  
  800b4a:	c3                   	ret    

00800b4b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b58:	eb 09                	jmp    800b63 <strnlen+0x18>
		n++;
  800b5a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b5d:	ff 45 08             	incl   0x8(%ebp)
  800b60:	ff 4d 0c             	decl   0xc(%ebp)
  800b63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b67:	74 09                	je     800b72 <strnlen+0x27>
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	8a 00                	mov    (%eax),%al
  800b6e:	84 c0                	test   %al,%al
  800b70:	75 e8                	jne    800b5a <strnlen+0xf>
		n++;
	return n;
  800b72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b75:	c9                   	leave  
  800b76:	c3                   	ret    

00800b77 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b83:	90                   	nop
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	8d 50 01             	lea    0x1(%eax),%edx
  800b8a:	89 55 08             	mov    %edx,0x8(%ebp)
  800b8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b90:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b93:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b96:	8a 12                	mov    (%edx),%dl
  800b98:	88 10                	mov    %dl,(%eax)
  800b9a:	8a 00                	mov    (%eax),%al
  800b9c:	84 c0                	test   %al,%al
  800b9e:	75 e4                	jne    800b84 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ba0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ba3:	c9                   	leave  
  800ba4:	c3                   	ret    

00800ba5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800bab:	8b 45 08             	mov    0x8(%ebp),%eax
  800bae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800bb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb8:	eb 1f                	jmp    800bd9 <strncpy+0x34>
		*dst++ = *src;
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	8d 50 01             	lea    0x1(%eax),%edx
  800bc0:	89 55 08             	mov    %edx,0x8(%ebp)
  800bc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc6:	8a 12                	mov    (%edx),%dl
  800bc8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcd:	8a 00                	mov    (%eax),%al
  800bcf:	84 c0                	test   %al,%al
  800bd1:	74 03                	je     800bd6 <strncpy+0x31>
			src++;
  800bd3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bd6:	ff 45 fc             	incl   -0x4(%ebp)
  800bd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bdc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bdf:	72 d9                	jb     800bba <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800be1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800be4:	c9                   	leave  
  800be5:	c3                   	ret    

00800be6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bf2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bf6:	74 30                	je     800c28 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bf8:	eb 16                	jmp    800c10 <strlcpy+0x2a>
			*dst++ = *src++;
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	8d 50 01             	lea    0x1(%eax),%edx
  800c00:	89 55 08             	mov    %edx,0x8(%ebp)
  800c03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c06:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c09:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c0c:	8a 12                	mov    (%edx),%dl
  800c0e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c10:	ff 4d 10             	decl   0x10(%ebp)
  800c13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c17:	74 09                	je     800c22 <strlcpy+0x3c>
  800c19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1c:	8a 00                	mov    (%eax),%al
  800c1e:	84 c0                	test   %al,%al
  800c20:	75 d8                	jne    800bfa <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c28:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c2e:	29 c2                	sub    %eax,%edx
  800c30:	89 d0                	mov    %edx,%eax
}
  800c32:	c9                   	leave  
  800c33:	c3                   	ret    

00800c34 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c37:	eb 06                	jmp    800c3f <strcmp+0xb>
		p++, q++;
  800c39:	ff 45 08             	incl   0x8(%ebp)
  800c3c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	8a 00                	mov    (%eax),%al
  800c44:	84 c0                	test   %al,%al
  800c46:	74 0e                	je     800c56 <strcmp+0x22>
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8a 10                	mov    (%eax),%dl
  800c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c50:	8a 00                	mov    (%eax),%al
  800c52:	38 c2                	cmp    %al,%dl
  800c54:	74 e3                	je     800c39 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	8a 00                	mov    (%eax),%al
  800c5b:	0f b6 d0             	movzbl %al,%edx
  800c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c61:	8a 00                	mov    (%eax),%al
  800c63:	0f b6 c0             	movzbl %al,%eax
  800c66:	29 c2                	sub    %eax,%edx
  800c68:	89 d0                	mov    %edx,%eax
}
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    

00800c6c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c6f:	eb 09                	jmp    800c7a <strncmp+0xe>
		n--, p++, q++;
  800c71:	ff 4d 10             	decl   0x10(%ebp)
  800c74:	ff 45 08             	incl   0x8(%ebp)
  800c77:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c7e:	74 17                	je     800c97 <strncmp+0x2b>
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	8a 00                	mov    (%eax),%al
  800c85:	84 c0                	test   %al,%al
  800c87:	74 0e                	je     800c97 <strncmp+0x2b>
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	8a 10                	mov    (%eax),%dl
  800c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	38 c2                	cmp    %al,%dl
  800c95:	74 da                	je     800c71 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c9b:	75 07                	jne    800ca4 <strncmp+0x38>
		return 0;
  800c9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca2:	eb 14                	jmp    800cb8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	8a 00                	mov    (%eax),%al
  800ca9:	0f b6 d0             	movzbl %al,%edx
  800cac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	0f b6 c0             	movzbl %al,%eax
  800cb4:	29 c2                	sub    %eax,%edx
  800cb6:	89 d0                	mov    %edx,%eax
}
  800cb8:	5d                   	pop    %ebp
  800cb9:	c3                   	ret    

00800cba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	83 ec 04             	sub    $0x4,%esp
  800cc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cc6:	eb 12                	jmp    800cda <strchr+0x20>
		if (*s == c)
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	8a 00                	mov    (%eax),%al
  800ccd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cd0:	75 05                	jne    800cd7 <strchr+0x1d>
			return (char *) s;
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	eb 11                	jmp    800ce8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cd7:	ff 45 08             	incl   0x8(%ebp)
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	84 c0                	test   %al,%al
  800ce1:	75 e5                	jne    800cc8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ce3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ce8:	c9                   	leave  
  800ce9:	c3                   	ret    

00800cea <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	83 ec 04             	sub    $0x4,%esp
  800cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cf6:	eb 0d                	jmp    800d05 <strfind+0x1b>
		if (*s == c)
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	8a 00                	mov    (%eax),%al
  800cfd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d00:	74 0e                	je     800d10 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d02:	ff 45 08             	incl   0x8(%ebp)
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	84 c0                	test   %al,%al
  800d0c:	75 ea                	jne    800cf8 <strfind+0xe>
  800d0e:	eb 01                	jmp    800d11 <strfind+0x27>
		if (*s == c)
			break;
  800d10:	90                   	nop
	return (char *) s;
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d14:	c9                   	leave  
  800d15:	c3                   	ret    

00800d16 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d22:	8b 45 10             	mov    0x10(%ebp),%eax
  800d25:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d28:	eb 0e                	jmp    800d38 <memset+0x22>
		*p++ = c;
  800d2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d2d:	8d 50 01             	lea    0x1(%eax),%edx
  800d30:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d36:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d38:	ff 4d f8             	decl   -0x8(%ebp)
  800d3b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d3f:	79 e9                	jns    800d2a <memset+0x14>
		*p++ = c;

	return v;
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d44:	c9                   	leave  
  800d45:	c3                   	ret    

00800d46 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d58:	eb 16                	jmp    800d70 <memcpy+0x2a>
		*d++ = *s++;
  800d5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d5d:	8d 50 01             	lea    0x1(%eax),%edx
  800d60:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d66:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d69:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d6c:	8a 12                	mov    (%edx),%dl
  800d6e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d70:	8b 45 10             	mov    0x10(%ebp),%eax
  800d73:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d76:	89 55 10             	mov    %edx,0x10(%ebp)
  800d79:	85 c0                	test   %eax,%eax
  800d7b:	75 dd                	jne    800d5a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d80:	c9                   	leave  
  800d81:	c3                   	ret    

00800d82 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d97:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d9a:	73 50                	jae    800dec <memmove+0x6a>
  800d9c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800da2:	01 d0                	add    %edx,%eax
  800da4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800da7:	76 43                	jbe    800dec <memmove+0x6a>
		s += n;
  800da9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dac:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800daf:	8b 45 10             	mov    0x10(%ebp),%eax
  800db2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800db5:	eb 10                	jmp    800dc7 <memmove+0x45>
			*--d = *--s;
  800db7:	ff 4d f8             	decl   -0x8(%ebp)
  800dba:	ff 4d fc             	decl   -0x4(%ebp)
  800dbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc0:	8a 10                	mov    (%eax),%dl
  800dc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800dc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dca:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dcd:	89 55 10             	mov    %edx,0x10(%ebp)
  800dd0:	85 c0                	test   %eax,%eax
  800dd2:	75 e3                	jne    800db7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dd4:	eb 23                	jmp    800df9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800dd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd9:	8d 50 01             	lea    0x1(%eax),%edx
  800ddc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ddf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800de2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800de8:	8a 12                	mov    (%edx),%dl
  800dea:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dec:	8b 45 10             	mov    0x10(%ebp),%eax
  800def:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df2:	89 55 10             	mov    %edx,0x10(%ebp)
  800df5:	85 c0                	test   %eax,%eax
  800df7:	75 dd                	jne    800dd6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dfc:	c9                   	leave  
  800dfd:	c3                   	ret    

00800dfe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dfe:	55                   	push   %ebp
  800dff:	89 e5                	mov    %esp,%ebp
  800e01:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e10:	eb 2a                	jmp    800e3c <memcmp+0x3e>
		if (*s1 != *s2)
  800e12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e15:	8a 10                	mov    (%eax),%dl
  800e17:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	38 c2                	cmp    %al,%dl
  800e1e:	74 16                	je     800e36 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	0f b6 d0             	movzbl %al,%edx
  800e28:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	0f b6 c0             	movzbl %al,%eax
  800e30:	29 c2                	sub    %eax,%edx
  800e32:	89 d0                	mov    %edx,%eax
  800e34:	eb 18                	jmp    800e4e <memcmp+0x50>
		s1++, s2++;
  800e36:	ff 45 fc             	incl   -0x4(%ebp)
  800e39:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e42:	89 55 10             	mov    %edx,0x10(%ebp)
  800e45:	85 c0                	test   %eax,%eax
  800e47:	75 c9                	jne    800e12 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e4e:	c9                   	leave  
  800e4f:	c3                   	ret    

00800e50 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e56:	8b 55 08             	mov    0x8(%ebp),%edx
  800e59:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5c:	01 d0                	add    %edx,%eax
  800e5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e61:	eb 15                	jmp    800e78 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	8a 00                	mov    (%eax),%al
  800e68:	0f b6 d0             	movzbl %al,%edx
  800e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6e:	0f b6 c0             	movzbl %al,%eax
  800e71:	39 c2                	cmp    %eax,%edx
  800e73:	74 0d                	je     800e82 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e75:	ff 45 08             	incl   0x8(%ebp)
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e7e:	72 e3                	jb     800e63 <memfind+0x13>
  800e80:	eb 01                	jmp    800e83 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e82:	90                   	nop
	return (void *) s;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e86:	c9                   	leave  
  800e87:	c3                   	ret    

00800e88 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e95:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e9c:	eb 03                	jmp    800ea1 <strtol+0x19>
		s++;
  800e9e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	8a 00                	mov    (%eax),%al
  800ea6:	3c 20                	cmp    $0x20,%al
  800ea8:	74 f4                	je     800e9e <strtol+0x16>
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	8a 00                	mov    (%eax),%al
  800eaf:	3c 09                	cmp    $0x9,%al
  800eb1:	74 eb                	je     800e9e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	8a 00                	mov    (%eax),%al
  800eb8:	3c 2b                	cmp    $0x2b,%al
  800eba:	75 05                	jne    800ec1 <strtol+0x39>
		s++;
  800ebc:	ff 45 08             	incl   0x8(%ebp)
  800ebf:	eb 13                	jmp    800ed4 <strtol+0x4c>
	else if (*s == '-')
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	8a 00                	mov    (%eax),%al
  800ec6:	3c 2d                	cmp    $0x2d,%al
  800ec8:	75 0a                	jne    800ed4 <strtol+0x4c>
		s++, neg = 1;
  800eca:	ff 45 08             	incl   0x8(%ebp)
  800ecd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ed4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed8:	74 06                	je     800ee0 <strtol+0x58>
  800eda:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ede:	75 20                	jne    800f00 <strtol+0x78>
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	8a 00                	mov    (%eax),%al
  800ee5:	3c 30                	cmp    $0x30,%al
  800ee7:	75 17                	jne    800f00 <strtol+0x78>
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	40                   	inc    %eax
  800eed:	8a 00                	mov    (%eax),%al
  800eef:	3c 78                	cmp    $0x78,%al
  800ef1:	75 0d                	jne    800f00 <strtol+0x78>
		s += 2, base = 16;
  800ef3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ef7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800efe:	eb 28                	jmp    800f28 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f04:	75 15                	jne    800f1b <strtol+0x93>
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	8a 00                	mov    (%eax),%al
  800f0b:	3c 30                	cmp    $0x30,%al
  800f0d:	75 0c                	jne    800f1b <strtol+0x93>
		s++, base = 8;
  800f0f:	ff 45 08             	incl   0x8(%ebp)
  800f12:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f19:	eb 0d                	jmp    800f28 <strtol+0xa0>
	else if (base == 0)
  800f1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1f:	75 07                	jne    800f28 <strtol+0xa0>
		base = 10;
  800f21:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	8a 00                	mov    (%eax),%al
  800f2d:	3c 2f                	cmp    $0x2f,%al
  800f2f:	7e 19                	jle    800f4a <strtol+0xc2>
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	3c 39                	cmp    $0x39,%al
  800f38:	7f 10                	jg     800f4a <strtol+0xc2>
			dig = *s - '0';
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	0f be c0             	movsbl %al,%eax
  800f42:	83 e8 30             	sub    $0x30,%eax
  800f45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f48:	eb 42                	jmp    800f8c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	8a 00                	mov    (%eax),%al
  800f4f:	3c 60                	cmp    $0x60,%al
  800f51:	7e 19                	jle    800f6c <strtol+0xe4>
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	3c 7a                	cmp    $0x7a,%al
  800f5a:	7f 10                	jg     800f6c <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	8a 00                	mov    (%eax),%al
  800f61:	0f be c0             	movsbl %al,%eax
  800f64:	83 e8 57             	sub    $0x57,%eax
  800f67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f6a:	eb 20                	jmp    800f8c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	3c 40                	cmp    $0x40,%al
  800f73:	7e 39                	jle    800fae <strtol+0x126>
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	3c 5a                	cmp    $0x5a,%al
  800f7c:	7f 30                	jg     800fae <strtol+0x126>
			dig = *s - 'A' + 10;
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	0f be c0             	movsbl %al,%eax
  800f86:	83 e8 37             	sub    $0x37,%eax
  800f89:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f8f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f92:	7d 19                	jge    800fad <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f94:	ff 45 08             	incl   0x8(%ebp)
  800f97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f9e:	89 c2                	mov    %eax,%edx
  800fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fa3:	01 d0                	add    %edx,%eax
  800fa5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800fa8:	e9 7b ff ff ff       	jmp    800f28 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800fad:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800fae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fb2:	74 08                	je     800fbc <strtol+0x134>
		*endptr = (char *) s;
  800fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800fba:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800fbc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fc0:	74 07                	je     800fc9 <strtol+0x141>
  800fc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc5:	f7 d8                	neg    %eax
  800fc7:	eb 03                	jmp    800fcc <strtol+0x144>
  800fc9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fcc:	c9                   	leave  
  800fcd:	c3                   	ret    

00800fce <ltostr>:

void
ltostr(long value, char *str)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fdb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fe2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fe6:	79 13                	jns    800ffb <ltostr+0x2d>
	{
		neg = 1;
  800fe8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ff5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ff8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801003:	99                   	cltd   
  801004:	f7 f9                	idiv   %ecx
  801006:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801009:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80100c:	8d 50 01             	lea    0x1(%eax),%edx
  80100f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801012:	89 c2                	mov    %eax,%edx
  801014:	8b 45 0c             	mov    0xc(%ebp),%eax
  801017:	01 d0                	add    %edx,%eax
  801019:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80101c:	83 c2 30             	add    $0x30,%edx
  80101f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801021:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801024:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801029:	f7 e9                	imul   %ecx
  80102b:	c1 fa 02             	sar    $0x2,%edx
  80102e:	89 c8                	mov    %ecx,%eax
  801030:	c1 f8 1f             	sar    $0x1f,%eax
  801033:	29 c2                	sub    %eax,%edx
  801035:	89 d0                	mov    %edx,%eax
  801037:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80103a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80103e:	75 bb                	jne    800ffb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801040:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801047:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104a:	48                   	dec    %eax
  80104b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80104e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801052:	74 3d                	je     801091 <ltostr+0xc3>
		start = 1 ;
  801054:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80105b:	eb 34                	jmp    801091 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80105d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801060:	8b 45 0c             	mov    0xc(%ebp),%eax
  801063:	01 d0                	add    %edx,%eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80106a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80106d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801070:	01 c2                	add    %eax,%edx
  801072:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801075:	8b 45 0c             	mov    0xc(%ebp),%eax
  801078:	01 c8                	add    %ecx,%eax
  80107a:	8a 00                	mov    (%eax),%al
  80107c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80107e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801081:	8b 45 0c             	mov    0xc(%ebp),%eax
  801084:	01 c2                	add    %eax,%edx
  801086:	8a 45 eb             	mov    -0x15(%ebp),%al
  801089:	88 02                	mov    %al,(%edx)
		start++ ;
  80108b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80108e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801094:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801097:	7c c4                	jl     80105d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801099:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80109c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109f:	01 d0                	add    %edx,%eax
  8010a1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8010a4:	90                   	nop
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8010ad:	ff 75 08             	pushl  0x8(%ebp)
  8010b0:	e8 73 fa ff ff       	call   800b28 <strlen>
  8010b5:	83 c4 04             	add    $0x4,%esp
  8010b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8010bb:	ff 75 0c             	pushl  0xc(%ebp)
  8010be:	e8 65 fa ff ff       	call   800b28 <strlen>
  8010c3:	83 c4 04             	add    $0x4,%esp
  8010c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010d7:	eb 17                	jmp    8010f0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010df:	01 c2                	add    %eax,%edx
  8010e1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	01 c8                	add    %ecx,%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010ed:	ff 45 fc             	incl   -0x4(%ebp)
  8010f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010f6:	7c e1                	jl     8010d9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010f8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010ff:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801106:	eb 1f                	jmp    801127 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801108:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110b:	8d 50 01             	lea    0x1(%eax),%edx
  80110e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801111:	89 c2                	mov    %eax,%edx
  801113:	8b 45 10             	mov    0x10(%ebp),%eax
  801116:	01 c2                	add    %eax,%edx
  801118:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80111b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111e:	01 c8                	add    %ecx,%eax
  801120:	8a 00                	mov    (%eax),%al
  801122:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801124:	ff 45 f8             	incl   -0x8(%ebp)
  801127:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80112d:	7c d9                	jl     801108 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80112f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801132:	8b 45 10             	mov    0x10(%ebp),%eax
  801135:	01 d0                	add    %edx,%eax
  801137:	c6 00 00             	movb   $0x0,(%eax)
}
  80113a:	90                   	nop
  80113b:	c9                   	leave  
  80113c:	c3                   	ret    

0080113d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801140:	8b 45 14             	mov    0x14(%ebp),%eax
  801143:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801149:	8b 45 14             	mov    0x14(%ebp),%eax
  80114c:	8b 00                	mov    (%eax),%eax
  80114e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801155:	8b 45 10             	mov    0x10(%ebp),%eax
  801158:	01 d0                	add    %edx,%eax
  80115a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801160:	eb 0c                	jmp    80116e <strsplit+0x31>
			*string++ = 0;
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	8d 50 01             	lea    0x1(%eax),%edx
  801168:	89 55 08             	mov    %edx,0x8(%ebp)
  80116b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	84 c0                	test   %al,%al
  801175:	74 18                	je     80118f <strsplit+0x52>
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	0f be c0             	movsbl %al,%eax
  80117f:	50                   	push   %eax
  801180:	ff 75 0c             	pushl  0xc(%ebp)
  801183:	e8 32 fb ff ff       	call   800cba <strchr>
  801188:	83 c4 08             	add    $0x8,%esp
  80118b:	85 c0                	test   %eax,%eax
  80118d:	75 d3                	jne    801162 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8a 00                	mov    (%eax),%al
  801194:	84 c0                	test   %al,%al
  801196:	74 5a                	je     8011f2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801198:	8b 45 14             	mov    0x14(%ebp),%eax
  80119b:	8b 00                	mov    (%eax),%eax
  80119d:	83 f8 0f             	cmp    $0xf,%eax
  8011a0:	75 07                	jne    8011a9 <strsplit+0x6c>
		{
			return 0;
  8011a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a7:	eb 66                	jmp    80120f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8011a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ac:	8b 00                	mov    (%eax),%eax
  8011ae:	8d 48 01             	lea    0x1(%eax),%ecx
  8011b1:	8b 55 14             	mov    0x14(%ebp),%edx
  8011b4:	89 0a                	mov    %ecx,(%edx)
  8011b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c0:	01 c2                	add    %eax,%edx
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011c7:	eb 03                	jmp    8011cc <strsplit+0x8f>
			string++;
  8011c9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	84 c0                	test   %al,%al
  8011d3:	74 8b                	je     801160 <strsplit+0x23>
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	0f be c0             	movsbl %al,%eax
  8011dd:	50                   	push   %eax
  8011de:	ff 75 0c             	pushl  0xc(%ebp)
  8011e1:	e8 d4 fa ff ff       	call   800cba <strchr>
  8011e6:	83 c4 08             	add    $0x8,%esp
  8011e9:	85 c0                	test   %eax,%eax
  8011eb:	74 dc                	je     8011c9 <strsplit+0x8c>
			string++;
	}
  8011ed:	e9 6e ff ff ff       	jmp    801160 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011f2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f6:	8b 00                	mov    (%eax),%eax
  8011f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801202:	01 d0                	add    %edx,%eax
  801204:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80120a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80120f:	c9                   	leave  
  801210:	c3                   	ret    

00801211 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801217:	83 ec 04             	sub    $0x4,%esp
  80121a:	68 a8 21 80 00       	push   $0x8021a8
  80121f:	68 3f 01 00 00       	push   $0x13f
  801224:	68 ca 21 80 00       	push   $0x8021ca
  801229:	e8 a9 ef ff ff       	call   8001d7 <_panic>

0080122e <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
  801231:	57                   	push   %edi
  801232:	56                   	push   %esi
  801233:	53                   	push   %ebx
  801234:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80123d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801240:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801243:	8b 7d 18             	mov    0x18(%ebp),%edi
  801246:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801249:	cd 30                	int    $0x30
  80124b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  80124e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801251:	83 c4 10             	add    $0x10,%esp
  801254:	5b                   	pop    %ebx
  801255:	5e                   	pop    %esi
  801256:	5f                   	pop    %edi
  801257:	5d                   	pop    %ebp
  801258:	c3                   	ret    

00801259 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801259:	55                   	push   %ebp
  80125a:	89 e5                	mov    %esp,%ebp
  80125c:	83 ec 04             	sub    $0x4,%esp
  80125f:	8b 45 10             	mov    0x10(%ebp),%eax
  801262:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801265:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	6a 00                	push   $0x0
  80126e:	6a 00                	push   $0x0
  801270:	52                   	push   %edx
  801271:	ff 75 0c             	pushl  0xc(%ebp)
  801274:	50                   	push   %eax
  801275:	6a 00                	push   $0x0
  801277:	e8 b2 ff ff ff       	call   80122e <syscall>
  80127c:	83 c4 18             	add    $0x18,%esp
}
  80127f:	90                   	nop
  801280:	c9                   	leave  
  801281:	c3                   	ret    

00801282 <sys_cgetc>:

int sys_cgetc(void) {
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801285:	6a 00                	push   $0x0
  801287:	6a 00                	push   $0x0
  801289:	6a 00                	push   $0x0
  80128b:	6a 00                	push   $0x0
  80128d:	6a 00                	push   $0x0
  80128f:	6a 02                	push   $0x2
  801291:	e8 98 ff ff ff       	call   80122e <syscall>
  801296:	83 c4 18             	add    $0x18,%esp
}
  801299:	c9                   	leave  
  80129a:	c3                   	ret    

0080129b <sys_lock_cons>:

void sys_lock_cons(void) {
  80129b:	55                   	push   %ebp
  80129c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80129e:	6a 00                	push   $0x0
  8012a0:	6a 00                	push   $0x0
  8012a2:	6a 00                	push   $0x0
  8012a4:	6a 00                	push   $0x0
  8012a6:	6a 00                	push   $0x0
  8012a8:	6a 03                	push   $0x3
  8012aa:	e8 7f ff ff ff       	call   80122e <syscall>
  8012af:	83 c4 18             	add    $0x18,%esp
}
  8012b2:	90                   	nop
  8012b3:	c9                   	leave  
  8012b4:	c3                   	ret    

008012b5 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8012b8:	6a 00                	push   $0x0
  8012ba:	6a 00                	push   $0x0
  8012bc:	6a 00                	push   $0x0
  8012be:	6a 00                	push   $0x0
  8012c0:	6a 00                	push   $0x0
  8012c2:	6a 04                	push   $0x4
  8012c4:	e8 65 ff ff ff       	call   80122e <syscall>
  8012c9:	83 c4 18             	add    $0x18,%esp
}
  8012cc:	90                   	nop
  8012cd:	c9                   	leave  
  8012ce:	c3                   	ret    

008012cf <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  8012d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d8:	6a 00                	push   $0x0
  8012da:	6a 00                	push   $0x0
  8012dc:	6a 00                	push   $0x0
  8012de:	52                   	push   %edx
  8012df:	50                   	push   %eax
  8012e0:	6a 08                	push   $0x8
  8012e2:	e8 47 ff ff ff       	call   80122e <syscall>
  8012e7:	83 c4 18             	add    $0x18,%esp
}
  8012ea:	c9                   	leave  
  8012eb:	c3                   	ret    

008012ec <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	56                   	push   %esi
  8012f0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  8012f1:	8b 75 18             	mov    0x18(%ebp),%esi
  8012f4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	56                   	push   %esi
  801301:	53                   	push   %ebx
  801302:	51                   	push   %ecx
  801303:	52                   	push   %edx
  801304:	50                   	push   %eax
  801305:	6a 09                	push   $0x9
  801307:	e8 22 ff ff ff       	call   80122e <syscall>
  80130c:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  80130f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801312:	5b                   	pop    %ebx
  801313:	5e                   	pop    %esi
  801314:	5d                   	pop    %ebp
  801315:	c3                   	ret    

00801316 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801319:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	6a 00                	push   $0x0
  801325:	52                   	push   %edx
  801326:	50                   	push   %eax
  801327:	6a 0a                	push   $0xa
  801329:	e8 00 ff ff ff       	call   80122e <syscall>
  80132e:	83 c4 18             	add    $0x18,%esp
}
  801331:	c9                   	leave  
  801332:	c3                   	ret    

00801333 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801336:	6a 00                	push   $0x0
  801338:	6a 00                	push   $0x0
  80133a:	6a 00                	push   $0x0
  80133c:	ff 75 0c             	pushl  0xc(%ebp)
  80133f:	ff 75 08             	pushl  0x8(%ebp)
  801342:	6a 0b                	push   $0xb
  801344:	e8 e5 fe ff ff       	call   80122e <syscall>
  801349:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    

0080134e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801351:	6a 00                	push   $0x0
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	6a 00                	push   $0x0
  80135b:	6a 0c                	push   $0xc
  80135d:	e8 cc fe ff ff       	call   80122e <syscall>
  801362:	83 c4 18             	add    $0x18,%esp
}
  801365:	c9                   	leave  
  801366:	c3                   	ret    

00801367 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80136a:	6a 00                	push   $0x0
  80136c:	6a 00                	push   $0x0
  80136e:	6a 00                	push   $0x0
  801370:	6a 00                	push   $0x0
  801372:	6a 00                	push   $0x0
  801374:	6a 0d                	push   $0xd
  801376:	e8 b3 fe ff ff       	call   80122e <syscall>
  80137b:	83 c4 18             	add    $0x18,%esp
}
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 0e                	push   $0xe
  80138f:	e8 9a fe ff ff       	call   80122e <syscall>
  801394:	83 c4 18             	add    $0x18,%esp
}
  801397:	c9                   	leave  
  801398:	c3                   	ret    

00801399 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 0f                	push   $0xf
  8013a8:	e8 81 fe ff ff       	call   80122e <syscall>
  8013ad:	83 c4 18             	add    $0x18,%esp
}
  8013b0:	c9                   	leave  
  8013b1:	c3                   	ret    

008013b2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  8013b2:	55                   	push   %ebp
  8013b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	ff 75 08             	pushl  0x8(%ebp)
  8013c0:	6a 10                	push   $0x10
  8013c2:	e8 67 fe ff ff       	call   80122e <syscall>
  8013c7:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  8013ca:	c9                   	leave  
  8013cb:	c3                   	ret    

008013cc <sys_scarce_memory>:

void sys_scarce_memory() {
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  8013cf:	6a 00                	push   $0x0
  8013d1:	6a 00                	push   $0x0
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 11                	push   $0x11
  8013db:	e8 4e fe ff ff       	call   80122e <syscall>
  8013e0:	83 c4 18             	add    $0x18,%esp
}
  8013e3:	90                   	nop
  8013e4:	c9                   	leave  
  8013e5:	c3                   	ret    

008013e6 <sys_cputc>:

void sys_cputc(const char c) {
  8013e6:	55                   	push   %ebp
  8013e7:	89 e5                	mov    %esp,%ebp
  8013e9:	83 ec 04             	sub    $0x4,%esp
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013f2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	50                   	push   %eax
  8013ff:	6a 01                	push   $0x1
  801401:	e8 28 fe ff ff       	call   80122e <syscall>
  801406:	83 c4 18             	add    $0x18,%esp
}
  801409:	90                   	nop
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    

0080140c <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  80140f:	6a 00                	push   $0x0
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	6a 14                	push   $0x14
  80141b:	e8 0e fe ff ff       	call   80122e <syscall>
  801420:	83 c4 18             	add    $0x18,%esp
}
  801423:	90                   	nop
  801424:	c9                   	leave  
  801425:	c3                   	ret    

00801426 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
  801429:	83 ec 04             	sub    $0x4,%esp
  80142c:	8b 45 10             	mov    0x10(%ebp),%eax
  80142f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801432:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801435:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	6a 00                	push   $0x0
  80143e:	51                   	push   %ecx
  80143f:	52                   	push   %edx
  801440:	ff 75 0c             	pushl  0xc(%ebp)
  801443:	50                   	push   %eax
  801444:	6a 15                	push   $0x15
  801446:	e8 e3 fd ff ff       	call   80122e <syscall>
  80144b:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    

00801450 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801453:	8b 55 0c             	mov    0xc(%ebp),%edx
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	6a 00                	push   $0x0
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	52                   	push   %edx
  801460:	50                   	push   %eax
  801461:	6a 16                	push   $0x16
  801463:	e8 c6 fd ff ff       	call   80122e <syscall>
  801468:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  80146b:	c9                   	leave  
  80146c:	c3                   	ret    

0080146d <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801470:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801473:	8b 55 0c             	mov    0xc(%ebp),%edx
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	51                   	push   %ecx
  80147e:	52                   	push   %edx
  80147f:	50                   	push   %eax
  801480:	6a 17                	push   $0x17
  801482:	e8 a7 fd ff ff       	call   80122e <syscall>
  801487:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  80148f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	52                   	push   %edx
  80149c:	50                   	push   %eax
  80149d:	6a 18                	push   $0x18
  80149f:	e8 8a fd ff ff       	call   80122e <syscall>
  8014a4:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    

008014a9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	6a 00                	push   $0x0
  8014b1:	ff 75 14             	pushl  0x14(%ebp)
  8014b4:	ff 75 10             	pushl  0x10(%ebp)
  8014b7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ba:	50                   	push   %eax
  8014bb:	6a 19                	push   $0x19
  8014bd:	e8 6c fd ff ff       	call   80122e <syscall>
  8014c2:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <sys_run_env>:

void sys_run_env(int32 envId) {
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	6a 00                	push   $0x0
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 00                	push   $0x0
  8014d5:	50                   	push   %eax
  8014d6:	6a 1a                	push   $0x1a
  8014d8:	e8 51 fd ff ff       	call   80122e <syscall>
  8014dd:	83 c4 18             	add    $0x18,%esp
}
  8014e0:	90                   	nop
  8014e1:	c9                   	leave  
  8014e2:	c3                   	ret    

008014e3 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	50                   	push   %eax
  8014f2:	6a 1b                	push   $0x1b
  8014f4:	e8 35 fd ff ff       	call   80122e <syscall>
  8014f9:	83 c4 18             	add    $0x18,%esp
}
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <sys_getenvid>:

int32 sys_getenvid(void) {
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 05                	push   $0x5
  80150d:	e8 1c fd ff ff       	call   80122e <syscall>
  801512:	83 c4 18             	add    $0x18,%esp
}
  801515:	c9                   	leave  
  801516:	c3                   	ret    

00801517 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	6a 06                	push   $0x6
  801526:	e8 03 fd ff ff       	call   80122e <syscall>
  80152b:	83 c4 18             	add    $0x18,%esp
}
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 07                	push   $0x7
  80153f:	e8 ea fc ff ff       	call   80122e <syscall>
  801544:	83 c4 18             	add    $0x18,%esp
}
  801547:	c9                   	leave  
  801548:	c3                   	ret    

00801549 <sys_exit_env>:

void sys_exit_env(void) {
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	6a 1c                	push   $0x1c
  801558:	e8 d1 fc ff ff       	call   80122e <syscall>
  80155d:	83 c4 18             	add    $0x18,%esp
}
  801560:	90                   	nop
  801561:	c9                   	leave  
  801562:	c3                   	ret    

00801563 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
  801566:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801569:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80156c:	8d 50 04             	lea    0x4(%eax),%edx
  80156f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801572:	6a 00                	push   $0x0
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	52                   	push   %edx
  801579:	50                   	push   %eax
  80157a:	6a 1d                	push   $0x1d
  80157c:	e8 ad fc ff ff       	call   80122e <syscall>
  801581:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801584:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801587:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80158a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80158d:	89 01                	mov    %eax,(%ecx)
  80158f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	c9                   	leave  
  801596:	c2 04 00             	ret    $0x4

00801599 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	ff 75 10             	pushl  0x10(%ebp)
  8015a3:	ff 75 0c             	pushl  0xc(%ebp)
  8015a6:	ff 75 08             	pushl  0x8(%ebp)
  8015a9:	6a 13                	push   $0x13
  8015ab:	e8 7e fc ff ff       	call   80122e <syscall>
  8015b0:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  8015b3:	90                   	nop
}
  8015b4:	c9                   	leave  
  8015b5:	c3                   	ret    

008015b6 <sys_rcr2>:
uint32 sys_rcr2() {
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 1e                	push   $0x1e
  8015c5:	e8 64 fc ff ff       	call   80122e <syscall>
  8015ca:	83 c4 18             	add    $0x18,%esp
}
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    

008015cf <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015db:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	50                   	push   %eax
  8015e8:	6a 1f                	push   $0x1f
  8015ea:	e8 3f fc ff ff       	call   80122e <syscall>
  8015ef:	83 c4 18             	add    $0x18,%esp
	return;
  8015f2:	90                   	nop
}
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    

008015f5 <rsttst>:
void rsttst() {
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 21                	push   $0x21
  801604:	e8 25 fc ff ff       	call   80122e <syscall>
  801609:	83 c4 18             	add    $0x18,%esp
	return;
  80160c:	90                   	nop
}
  80160d:	c9                   	leave  
  80160e:	c3                   	ret    

0080160f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
  801612:	83 ec 04             	sub    $0x4,%esp
  801615:	8b 45 14             	mov    0x14(%ebp),%eax
  801618:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80161b:	8b 55 18             	mov    0x18(%ebp),%edx
  80161e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801622:	52                   	push   %edx
  801623:	50                   	push   %eax
  801624:	ff 75 10             	pushl  0x10(%ebp)
  801627:	ff 75 0c             	pushl  0xc(%ebp)
  80162a:	ff 75 08             	pushl  0x8(%ebp)
  80162d:	6a 20                	push   $0x20
  80162f:	e8 fa fb ff ff       	call   80122e <syscall>
  801634:	83 c4 18             	add    $0x18,%esp
	return;
  801637:	90                   	nop
}
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <chktst>:
void chktst(uint32 n) {
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	ff 75 08             	pushl  0x8(%ebp)
  801648:	6a 22                	push   $0x22
  80164a:	e8 df fb ff ff       	call   80122e <syscall>
  80164f:	83 c4 18             	add    $0x18,%esp
	return;
  801652:	90                   	nop
}
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <inctst>:

void inctst() {
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 23                	push   $0x23
  801664:	e8 c5 fb ff ff       	call   80122e <syscall>
  801669:	83 c4 18             	add    $0x18,%esp
	return;
  80166c:	90                   	nop
}
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <gettst>:
uint32 gettst() {
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 24                	push   $0x24
  80167e:	e8 ab fb ff ff       	call   80122e <syscall>
  801683:	83 c4 18             	add    $0x18,%esp
}
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 25                	push   $0x25
  80169a:	e8 8f fb ff ff       	call   80122e <syscall>
  80169f:	83 c4 18             	add    $0x18,%esp
  8016a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8016a5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8016a9:	75 07                	jne    8016b2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8016ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8016b0:	eb 05                	jmp    8016b7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8016b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
  8016bc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 25                	push   $0x25
  8016cb:	e8 5e fb ff ff       	call   80122e <syscall>
  8016d0:	83 c4 18             	add    $0x18,%esp
  8016d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016d6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016da:	75 07                	jne    8016e3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016dc:	b8 01 00 00 00       	mov    $0x1,%eax
  8016e1:	eb 05                	jmp    8016e8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    

008016ea <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
  8016ed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 25                	push   $0x25
  8016fc:	e8 2d fb ff ff       	call   80122e <syscall>
  801701:	83 c4 18             	add    $0x18,%esp
  801704:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801707:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80170b:	75 07                	jne    801714 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80170d:	b8 01 00 00 00       	mov    $0x1,%eax
  801712:	eb 05                	jmp    801719 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801714:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801719:	c9                   	leave  
  80171a:	c3                   	ret    

0080171b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
  80171e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 25                	push   $0x25
  80172d:	e8 fc fa ff ff       	call   80122e <syscall>
  801732:	83 c4 18             	add    $0x18,%esp
  801735:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801738:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80173c:	75 07                	jne    801745 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80173e:	b8 01 00 00 00       	mov    $0x1,%eax
  801743:	eb 05                	jmp    80174a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801745:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	ff 75 08             	pushl  0x8(%ebp)
  80175a:	6a 26                	push   $0x26
  80175c:	e8 cd fa ff ff       	call   80122e <syscall>
  801761:	83 c4 18             	add    $0x18,%esp
	return;
  801764:	90                   	nop
}
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  80176b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80176e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801771:	8b 55 0c             	mov    0xc(%ebp),%edx
  801774:	8b 45 08             	mov    0x8(%ebp),%eax
  801777:	6a 00                	push   $0x0
  801779:	53                   	push   %ebx
  80177a:	51                   	push   %ecx
  80177b:	52                   	push   %edx
  80177c:	50                   	push   %eax
  80177d:	6a 27                	push   $0x27
  80177f:	e8 aa fa ff ff       	call   80122e <syscall>
  801784:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801787:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  80178f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	52                   	push   %edx
  80179c:	50                   	push   %eax
  80179d:	6a 28                	push   $0x28
  80179f:	e8 8a fa ff ff       	call   80122e <syscall>
  8017a4:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  8017ac:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b5:	6a 00                	push   $0x0
  8017b7:	51                   	push   %ecx
  8017b8:	ff 75 10             	pushl  0x10(%ebp)
  8017bb:	52                   	push   %edx
  8017bc:	50                   	push   %eax
  8017bd:	6a 29                	push   $0x29
  8017bf:	e8 6a fa ff ff       	call   80122e <syscall>
  8017c4:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	ff 75 10             	pushl  0x10(%ebp)
  8017d3:	ff 75 0c             	pushl  0xc(%ebp)
  8017d6:	ff 75 08             	pushl  0x8(%ebp)
  8017d9:	6a 12                	push   $0x12
  8017db:	e8 4e fa ff ff       	call   80122e <syscall>
  8017e0:	83 c4 18             	add    $0x18,%esp
	return;
  8017e3:	90                   	nop
}
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  8017e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	52                   	push   %edx
  8017f6:	50                   	push   %eax
  8017f7:	6a 2a                	push   $0x2a
  8017f9:	e8 30 fa ff ff       	call   80122e <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
	return;
  801801:	90                   	nop
}
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	50                   	push   %eax
  801813:	6a 2b                	push   $0x2b
  801815:	e8 14 fa ff ff       	call   80122e <syscall>
  80181a:	83 c4 18             	add    $0x18,%esp
}
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	ff 75 0c             	pushl  0xc(%ebp)
  80182b:	ff 75 08             	pushl  0x8(%ebp)
  80182e:	6a 2c                	push   $0x2c
  801830:	e8 f9 f9 ff ff       	call   80122e <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
	return;
  801838:	90                   	nop
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	ff 75 0c             	pushl  0xc(%ebp)
  801847:	ff 75 08             	pushl  0x8(%ebp)
  80184a:	6a 2d                	push   $0x2d
  80184c:	e8 dd f9 ff ff       	call   80122e <syscall>
  801851:	83 c4 18             	add    $0x18,%esp
	return;
  801854:	90                   	nop
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	50                   	push   %eax
  801866:	6a 2f                	push   $0x2f
  801868:	e8 c1 f9 ff ff       	call   80122e <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
	return;
  801870:	90                   	nop
}
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  801876:	8b 55 0c             	mov    0xc(%ebp),%edx
  801879:	8b 45 08             	mov    0x8(%ebp),%eax
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	52                   	push   %edx
  801883:	50                   	push   %eax
  801884:	6a 30                	push   $0x30
  801886:	e8 a3 f9 ff ff       	call   80122e <syscall>
  80188b:	83 c4 18             	add    $0x18,%esp
	return;
  80188e:	90                   	nop
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	50                   	push   %eax
  8018a0:	6a 31                	push   $0x31
  8018a2:	e8 87 f9 ff ff       	call   80122e <syscall>
  8018a7:	83 c4 18             	add    $0x18,%esp
	return;
  8018aa:	90                   	nop
}
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8018b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	52                   	push   %edx
  8018bd:	50                   	push   %eax
  8018be:	6a 2e                	push   $0x2e
  8018c0:	e8 69 f9 ff ff       	call   80122e <syscall>
  8018c5:	83 c4 18             	add    $0x18,%esp
    return;
  8018c8:	90                   	nop
}
  8018c9:	c9                   	leave  
  8018ca:	c3                   	ret    
  8018cb:	90                   	nop

008018cc <__udivdi3>:
  8018cc:	55                   	push   %ebp
  8018cd:	57                   	push   %edi
  8018ce:	56                   	push   %esi
  8018cf:	53                   	push   %ebx
  8018d0:	83 ec 1c             	sub    $0x1c,%esp
  8018d3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8018d7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8018db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018e3:	89 ca                	mov    %ecx,%edx
  8018e5:	89 f8                	mov    %edi,%eax
  8018e7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8018eb:	85 f6                	test   %esi,%esi
  8018ed:	75 2d                	jne    80191c <__udivdi3+0x50>
  8018ef:	39 cf                	cmp    %ecx,%edi
  8018f1:	77 65                	ja     801958 <__udivdi3+0x8c>
  8018f3:	89 fd                	mov    %edi,%ebp
  8018f5:	85 ff                	test   %edi,%edi
  8018f7:	75 0b                	jne    801904 <__udivdi3+0x38>
  8018f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8018fe:	31 d2                	xor    %edx,%edx
  801900:	f7 f7                	div    %edi
  801902:	89 c5                	mov    %eax,%ebp
  801904:	31 d2                	xor    %edx,%edx
  801906:	89 c8                	mov    %ecx,%eax
  801908:	f7 f5                	div    %ebp
  80190a:	89 c1                	mov    %eax,%ecx
  80190c:	89 d8                	mov    %ebx,%eax
  80190e:	f7 f5                	div    %ebp
  801910:	89 cf                	mov    %ecx,%edi
  801912:	89 fa                	mov    %edi,%edx
  801914:	83 c4 1c             	add    $0x1c,%esp
  801917:	5b                   	pop    %ebx
  801918:	5e                   	pop    %esi
  801919:	5f                   	pop    %edi
  80191a:	5d                   	pop    %ebp
  80191b:	c3                   	ret    
  80191c:	39 ce                	cmp    %ecx,%esi
  80191e:	77 28                	ja     801948 <__udivdi3+0x7c>
  801920:	0f bd fe             	bsr    %esi,%edi
  801923:	83 f7 1f             	xor    $0x1f,%edi
  801926:	75 40                	jne    801968 <__udivdi3+0x9c>
  801928:	39 ce                	cmp    %ecx,%esi
  80192a:	72 0a                	jb     801936 <__udivdi3+0x6a>
  80192c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801930:	0f 87 9e 00 00 00    	ja     8019d4 <__udivdi3+0x108>
  801936:	b8 01 00 00 00       	mov    $0x1,%eax
  80193b:	89 fa                	mov    %edi,%edx
  80193d:	83 c4 1c             	add    $0x1c,%esp
  801940:	5b                   	pop    %ebx
  801941:	5e                   	pop    %esi
  801942:	5f                   	pop    %edi
  801943:	5d                   	pop    %ebp
  801944:	c3                   	ret    
  801945:	8d 76 00             	lea    0x0(%esi),%esi
  801948:	31 ff                	xor    %edi,%edi
  80194a:	31 c0                	xor    %eax,%eax
  80194c:	89 fa                	mov    %edi,%edx
  80194e:	83 c4 1c             	add    $0x1c,%esp
  801951:	5b                   	pop    %ebx
  801952:	5e                   	pop    %esi
  801953:	5f                   	pop    %edi
  801954:	5d                   	pop    %ebp
  801955:	c3                   	ret    
  801956:	66 90                	xchg   %ax,%ax
  801958:	89 d8                	mov    %ebx,%eax
  80195a:	f7 f7                	div    %edi
  80195c:	31 ff                	xor    %edi,%edi
  80195e:	89 fa                	mov    %edi,%edx
  801960:	83 c4 1c             	add    $0x1c,%esp
  801963:	5b                   	pop    %ebx
  801964:	5e                   	pop    %esi
  801965:	5f                   	pop    %edi
  801966:	5d                   	pop    %ebp
  801967:	c3                   	ret    
  801968:	bd 20 00 00 00       	mov    $0x20,%ebp
  80196d:	89 eb                	mov    %ebp,%ebx
  80196f:	29 fb                	sub    %edi,%ebx
  801971:	89 f9                	mov    %edi,%ecx
  801973:	d3 e6                	shl    %cl,%esi
  801975:	89 c5                	mov    %eax,%ebp
  801977:	88 d9                	mov    %bl,%cl
  801979:	d3 ed                	shr    %cl,%ebp
  80197b:	89 e9                	mov    %ebp,%ecx
  80197d:	09 f1                	or     %esi,%ecx
  80197f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801983:	89 f9                	mov    %edi,%ecx
  801985:	d3 e0                	shl    %cl,%eax
  801987:	89 c5                	mov    %eax,%ebp
  801989:	89 d6                	mov    %edx,%esi
  80198b:	88 d9                	mov    %bl,%cl
  80198d:	d3 ee                	shr    %cl,%esi
  80198f:	89 f9                	mov    %edi,%ecx
  801991:	d3 e2                	shl    %cl,%edx
  801993:	8b 44 24 08          	mov    0x8(%esp),%eax
  801997:	88 d9                	mov    %bl,%cl
  801999:	d3 e8                	shr    %cl,%eax
  80199b:	09 c2                	or     %eax,%edx
  80199d:	89 d0                	mov    %edx,%eax
  80199f:	89 f2                	mov    %esi,%edx
  8019a1:	f7 74 24 0c          	divl   0xc(%esp)
  8019a5:	89 d6                	mov    %edx,%esi
  8019a7:	89 c3                	mov    %eax,%ebx
  8019a9:	f7 e5                	mul    %ebp
  8019ab:	39 d6                	cmp    %edx,%esi
  8019ad:	72 19                	jb     8019c8 <__udivdi3+0xfc>
  8019af:	74 0b                	je     8019bc <__udivdi3+0xf0>
  8019b1:	89 d8                	mov    %ebx,%eax
  8019b3:	31 ff                	xor    %edi,%edi
  8019b5:	e9 58 ff ff ff       	jmp    801912 <__udivdi3+0x46>
  8019ba:	66 90                	xchg   %ax,%ax
  8019bc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8019c0:	89 f9                	mov    %edi,%ecx
  8019c2:	d3 e2                	shl    %cl,%edx
  8019c4:	39 c2                	cmp    %eax,%edx
  8019c6:	73 e9                	jae    8019b1 <__udivdi3+0xe5>
  8019c8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8019cb:	31 ff                	xor    %edi,%edi
  8019cd:	e9 40 ff ff ff       	jmp    801912 <__udivdi3+0x46>
  8019d2:	66 90                	xchg   %ax,%ax
  8019d4:	31 c0                	xor    %eax,%eax
  8019d6:	e9 37 ff ff ff       	jmp    801912 <__udivdi3+0x46>
  8019db:	90                   	nop

008019dc <__umoddi3>:
  8019dc:	55                   	push   %ebp
  8019dd:	57                   	push   %edi
  8019de:	56                   	push   %esi
  8019df:	53                   	push   %ebx
  8019e0:	83 ec 1c             	sub    $0x1c,%esp
  8019e3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8019e7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8019eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019ef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8019f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019fb:	89 f3                	mov    %esi,%ebx
  8019fd:	89 fa                	mov    %edi,%edx
  8019ff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a03:	89 34 24             	mov    %esi,(%esp)
  801a06:	85 c0                	test   %eax,%eax
  801a08:	75 1a                	jne    801a24 <__umoddi3+0x48>
  801a0a:	39 f7                	cmp    %esi,%edi
  801a0c:	0f 86 a2 00 00 00    	jbe    801ab4 <__umoddi3+0xd8>
  801a12:	89 c8                	mov    %ecx,%eax
  801a14:	89 f2                	mov    %esi,%edx
  801a16:	f7 f7                	div    %edi
  801a18:	89 d0                	mov    %edx,%eax
  801a1a:	31 d2                	xor    %edx,%edx
  801a1c:	83 c4 1c             	add    $0x1c,%esp
  801a1f:	5b                   	pop    %ebx
  801a20:	5e                   	pop    %esi
  801a21:	5f                   	pop    %edi
  801a22:	5d                   	pop    %ebp
  801a23:	c3                   	ret    
  801a24:	39 f0                	cmp    %esi,%eax
  801a26:	0f 87 ac 00 00 00    	ja     801ad8 <__umoddi3+0xfc>
  801a2c:	0f bd e8             	bsr    %eax,%ebp
  801a2f:	83 f5 1f             	xor    $0x1f,%ebp
  801a32:	0f 84 ac 00 00 00    	je     801ae4 <__umoddi3+0x108>
  801a38:	bf 20 00 00 00       	mov    $0x20,%edi
  801a3d:	29 ef                	sub    %ebp,%edi
  801a3f:	89 fe                	mov    %edi,%esi
  801a41:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a45:	89 e9                	mov    %ebp,%ecx
  801a47:	d3 e0                	shl    %cl,%eax
  801a49:	89 d7                	mov    %edx,%edi
  801a4b:	89 f1                	mov    %esi,%ecx
  801a4d:	d3 ef                	shr    %cl,%edi
  801a4f:	09 c7                	or     %eax,%edi
  801a51:	89 e9                	mov    %ebp,%ecx
  801a53:	d3 e2                	shl    %cl,%edx
  801a55:	89 14 24             	mov    %edx,(%esp)
  801a58:	89 d8                	mov    %ebx,%eax
  801a5a:	d3 e0                	shl    %cl,%eax
  801a5c:	89 c2                	mov    %eax,%edx
  801a5e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a62:	d3 e0                	shl    %cl,%eax
  801a64:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a68:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a6c:	89 f1                	mov    %esi,%ecx
  801a6e:	d3 e8                	shr    %cl,%eax
  801a70:	09 d0                	or     %edx,%eax
  801a72:	d3 eb                	shr    %cl,%ebx
  801a74:	89 da                	mov    %ebx,%edx
  801a76:	f7 f7                	div    %edi
  801a78:	89 d3                	mov    %edx,%ebx
  801a7a:	f7 24 24             	mull   (%esp)
  801a7d:	89 c6                	mov    %eax,%esi
  801a7f:	89 d1                	mov    %edx,%ecx
  801a81:	39 d3                	cmp    %edx,%ebx
  801a83:	0f 82 87 00 00 00    	jb     801b10 <__umoddi3+0x134>
  801a89:	0f 84 91 00 00 00    	je     801b20 <__umoddi3+0x144>
  801a8f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a93:	29 f2                	sub    %esi,%edx
  801a95:	19 cb                	sbb    %ecx,%ebx
  801a97:	89 d8                	mov    %ebx,%eax
  801a99:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a9d:	d3 e0                	shl    %cl,%eax
  801a9f:	89 e9                	mov    %ebp,%ecx
  801aa1:	d3 ea                	shr    %cl,%edx
  801aa3:	09 d0                	or     %edx,%eax
  801aa5:	89 e9                	mov    %ebp,%ecx
  801aa7:	d3 eb                	shr    %cl,%ebx
  801aa9:	89 da                	mov    %ebx,%edx
  801aab:	83 c4 1c             	add    $0x1c,%esp
  801aae:	5b                   	pop    %ebx
  801aaf:	5e                   	pop    %esi
  801ab0:	5f                   	pop    %edi
  801ab1:	5d                   	pop    %ebp
  801ab2:	c3                   	ret    
  801ab3:	90                   	nop
  801ab4:	89 fd                	mov    %edi,%ebp
  801ab6:	85 ff                	test   %edi,%edi
  801ab8:	75 0b                	jne    801ac5 <__umoddi3+0xe9>
  801aba:	b8 01 00 00 00       	mov    $0x1,%eax
  801abf:	31 d2                	xor    %edx,%edx
  801ac1:	f7 f7                	div    %edi
  801ac3:	89 c5                	mov    %eax,%ebp
  801ac5:	89 f0                	mov    %esi,%eax
  801ac7:	31 d2                	xor    %edx,%edx
  801ac9:	f7 f5                	div    %ebp
  801acb:	89 c8                	mov    %ecx,%eax
  801acd:	f7 f5                	div    %ebp
  801acf:	89 d0                	mov    %edx,%eax
  801ad1:	e9 44 ff ff ff       	jmp    801a1a <__umoddi3+0x3e>
  801ad6:	66 90                	xchg   %ax,%ax
  801ad8:	89 c8                	mov    %ecx,%eax
  801ada:	89 f2                	mov    %esi,%edx
  801adc:	83 c4 1c             	add    $0x1c,%esp
  801adf:	5b                   	pop    %ebx
  801ae0:	5e                   	pop    %esi
  801ae1:	5f                   	pop    %edi
  801ae2:	5d                   	pop    %ebp
  801ae3:	c3                   	ret    
  801ae4:	3b 04 24             	cmp    (%esp),%eax
  801ae7:	72 06                	jb     801aef <__umoddi3+0x113>
  801ae9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801aed:	77 0f                	ja     801afe <__umoddi3+0x122>
  801aef:	89 f2                	mov    %esi,%edx
  801af1:	29 f9                	sub    %edi,%ecx
  801af3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801af7:	89 14 24             	mov    %edx,(%esp)
  801afa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801afe:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b02:	8b 14 24             	mov    (%esp),%edx
  801b05:	83 c4 1c             	add    $0x1c,%esp
  801b08:	5b                   	pop    %ebx
  801b09:	5e                   	pop    %esi
  801b0a:	5f                   	pop    %edi
  801b0b:	5d                   	pop    %ebp
  801b0c:	c3                   	ret    
  801b0d:	8d 76 00             	lea    0x0(%esi),%esi
  801b10:	2b 04 24             	sub    (%esp),%eax
  801b13:	19 fa                	sbb    %edi,%edx
  801b15:	89 d1                	mov    %edx,%ecx
  801b17:	89 c6                	mov    %eax,%esi
  801b19:	e9 71 ff ff ff       	jmp    801a8f <__umoddi3+0xb3>
  801b1e:	66 90                	xchg   %ax,%ax
  801b20:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b24:	72 ea                	jb     801b10 <__umoddi3+0x134>
  801b26:	89 d9                	mov    %ebx,%ecx
  801b28:	e9 62 ff ff ff       	jmp    801a8f <__umoddi3+0xb3>
