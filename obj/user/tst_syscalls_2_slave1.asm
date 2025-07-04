
obj/user/tst_syscalls_2_slave1:     file format elf32-i386


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
  800031:	e8 30 00 00 00       	call   800066 <libmain>
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
  80003b:	83 ec 08             	sub    $0x8,%esp
	//[1] NULL (0) address
	sys_allocate_user_mem(0,10);
  80003e:	83 ec 08             	sub    $0x8,%esp
  800041:	6a 0a                	push   $0xa
  800043:	6a 00                	push   $0x0
  800045:	e8 c5 17 00 00       	call   80180f <sys_allocate_user_mem>
  80004a:	83 c4 10             	add    $0x10,%esp
	inctst();
  80004d:	e8 d7 15 00 00       	call   801629 <inctst>
	panic("tst system calls #2 failed: sys_allocate_user_mem is called with invalid params\nThe env must be killed and shouldn't return here.");
  800052:	83 ec 04             	sub    $0x4,%esp
  800055:	68 20 1b 80 00       	push   $0x801b20
  80005a:	6a 0a                	push   $0xa
  80005c:	68 a2 1b 80 00       	push   $0x801ba2
  800061:	e8 45 01 00 00       	call   8001ab <_panic>

00800066 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800066:	55                   	push   %ebp
  800067:	89 e5                	mov    %esp,%ebp
  800069:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80006c:	e8 7a 14 00 00       	call   8014eb <sys_getenvindex>
  800071:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800074:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800077:	89 d0                	mov    %edx,%eax
  800079:	c1 e0 02             	shl    $0x2,%eax
  80007c:	01 d0                	add    %edx,%eax
  80007e:	c1 e0 03             	shl    $0x3,%eax
  800081:	01 d0                	add    %edx,%eax
  800083:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80008a:	01 d0                	add    %edx,%eax
  80008c:	c1 e0 02             	shl    $0x2,%eax
  80008f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800094:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800099:	a1 08 30 80 00       	mov    0x803008,%eax
  80009e:	8a 40 20             	mov    0x20(%eax),%al
  8000a1:	84 c0                	test   %al,%al
  8000a3:	74 0d                	je     8000b2 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  8000a5:	a1 08 30 80 00       	mov    0x803008,%eax
  8000aa:	83 c0 20             	add    $0x20,%eax
  8000ad:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b6:	7e 0a                	jle    8000c2 <libmain+0x5c>
		binaryname = argv[0];
  8000b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000bb:	8b 00                	mov    (%eax),%eax
  8000bd:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000c2:	83 ec 08             	sub    $0x8,%esp
  8000c5:	ff 75 0c             	pushl  0xc(%ebp)
  8000c8:	ff 75 08             	pushl  0x8(%ebp)
  8000cb:	e8 68 ff ff ff       	call   800038 <_main>
  8000d0:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000d3:	a1 00 30 80 00       	mov    0x803000,%eax
  8000d8:	85 c0                	test   %eax,%eax
  8000da:	0f 84 9f 00 00 00    	je     80017f <libmain+0x119>
	{
		sys_lock_cons();
  8000e0:	e8 8a 11 00 00       	call   80126f <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 d8 1b 80 00       	push   $0x801bd8
  8000ed:	e8 76 03 00 00       	call   800468 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000f5:	a1 08 30 80 00       	mov    0x803008,%eax
  8000fa:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800100:	a1 08 30 80 00       	mov    0x803008,%eax
  800105:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80010b:	83 ec 04             	sub    $0x4,%esp
  80010e:	52                   	push   %edx
  80010f:	50                   	push   %eax
  800110:	68 00 1c 80 00       	push   $0x801c00
  800115:	e8 4e 03 00 00       	call   800468 <cprintf>
  80011a:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80011d:	a1 08 30 80 00       	mov    0x803008,%eax
  800122:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800128:	a1 08 30 80 00       	mov    0x803008,%eax
  80012d:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800133:	a1 08 30 80 00       	mov    0x803008,%eax
  800138:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80013e:	51                   	push   %ecx
  80013f:	52                   	push   %edx
  800140:	50                   	push   %eax
  800141:	68 28 1c 80 00       	push   $0x801c28
  800146:	e8 1d 03 00 00       	call   800468 <cprintf>
  80014b:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80014e:	a1 08 30 80 00       	mov    0x803008,%eax
  800153:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800159:	83 ec 08             	sub    $0x8,%esp
  80015c:	50                   	push   %eax
  80015d:	68 80 1c 80 00       	push   $0x801c80
  800162:	e8 01 03 00 00       	call   800468 <cprintf>
  800167:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	68 d8 1b 80 00       	push   $0x801bd8
  800172:	e8 f1 02 00 00       	call   800468 <cprintf>
  800177:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80017a:	e8 0a 11 00 00       	call   801289 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80017f:	e8 19 00 00 00       	call   80019d <exit>
}
  800184:	90                   	nop
  800185:	c9                   	leave  
  800186:	c3                   	ret    

00800187 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800187:	55                   	push   %ebp
  800188:	89 e5                	mov    %esp,%ebp
  80018a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80018d:	83 ec 0c             	sub    $0xc,%esp
  800190:	6a 00                	push   $0x0
  800192:	e8 20 13 00 00       	call   8014b7 <sys_destroy_env>
  800197:	83 c4 10             	add    $0x10,%esp
}
  80019a:	90                   	nop
  80019b:	c9                   	leave  
  80019c:	c3                   	ret    

0080019d <exit>:

void
exit(void)
{
  80019d:	55                   	push   %ebp
  80019e:	89 e5                	mov    %esp,%ebp
  8001a0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001a3:	e8 75 13 00 00       	call   80151d <sys_exit_env>
}
  8001a8:	90                   	nop
  8001a9:	c9                   	leave  
  8001aa:	c3                   	ret    

008001ab <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001ab:	55                   	push   %ebp
  8001ac:	89 e5                	mov    %esp,%ebp
  8001ae:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001b1:	8d 45 10             	lea    0x10(%ebp),%eax
  8001b4:	83 c0 04             	add    $0x4,%eax
  8001b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001ba:	a1 28 30 80 00       	mov    0x803028,%eax
  8001bf:	85 c0                	test   %eax,%eax
  8001c1:	74 16                	je     8001d9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001c3:	a1 28 30 80 00       	mov    0x803028,%eax
  8001c8:	83 ec 08             	sub    $0x8,%esp
  8001cb:	50                   	push   %eax
  8001cc:	68 94 1c 80 00       	push   $0x801c94
  8001d1:	e8 92 02 00 00       	call   800468 <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001d9:	a1 04 30 80 00       	mov    0x803004,%eax
  8001de:	ff 75 0c             	pushl  0xc(%ebp)
  8001e1:	ff 75 08             	pushl  0x8(%ebp)
  8001e4:	50                   	push   %eax
  8001e5:	68 99 1c 80 00       	push   $0x801c99
  8001ea:	e8 79 02 00 00       	call   800468 <cprintf>
  8001ef:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f5:	83 ec 08             	sub    $0x8,%esp
  8001f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8001fb:	50                   	push   %eax
  8001fc:	e8 fc 01 00 00       	call   8003fd <vcprintf>
  800201:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800204:	83 ec 08             	sub    $0x8,%esp
  800207:	6a 00                	push   $0x0
  800209:	68 b5 1c 80 00       	push   $0x801cb5
  80020e:	e8 ea 01 00 00       	call   8003fd <vcprintf>
  800213:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800216:	e8 82 ff ff ff       	call   80019d <exit>

	// should not return here
	while (1) ;
  80021b:	eb fe                	jmp    80021b <_panic+0x70>

0080021d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80021d:	55                   	push   %ebp
  80021e:	89 e5                	mov    %esp,%ebp
  800220:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800223:	a1 08 30 80 00       	mov    0x803008,%eax
  800228:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80022e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800231:	39 c2                	cmp    %eax,%edx
  800233:	74 14                	je     800249 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800235:	83 ec 04             	sub    $0x4,%esp
  800238:	68 b8 1c 80 00       	push   $0x801cb8
  80023d:	6a 26                	push   $0x26
  80023f:	68 04 1d 80 00       	push   $0x801d04
  800244:	e8 62 ff ff ff       	call   8001ab <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800249:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800250:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800257:	e9 c5 00 00 00       	jmp    800321 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80025c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80025f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800266:	8b 45 08             	mov    0x8(%ebp),%eax
  800269:	01 d0                	add    %edx,%eax
  80026b:	8b 00                	mov    (%eax),%eax
  80026d:	85 c0                	test   %eax,%eax
  80026f:	75 08                	jne    800279 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800271:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800274:	e9 a5 00 00 00       	jmp    80031e <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800279:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800280:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800287:	eb 69                	jmp    8002f2 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800289:	a1 08 30 80 00       	mov    0x803008,%eax
  80028e:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800294:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800297:	89 d0                	mov    %edx,%eax
  800299:	01 c0                	add    %eax,%eax
  80029b:	01 d0                	add    %edx,%eax
  80029d:	c1 e0 03             	shl    $0x3,%eax
  8002a0:	01 c8                	add    %ecx,%eax
  8002a2:	8a 40 04             	mov    0x4(%eax),%al
  8002a5:	84 c0                	test   %al,%al
  8002a7:	75 46                	jne    8002ef <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002a9:	a1 08 30 80 00       	mov    0x803008,%eax
  8002ae:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8002b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002b7:	89 d0                	mov    %edx,%eax
  8002b9:	01 c0                	add    %eax,%eax
  8002bb:	01 d0                	add    %edx,%eax
  8002bd:	c1 e0 03             	shl    $0x3,%eax
  8002c0:	01 c8                	add    %ecx,%eax
  8002c2:	8b 00                	mov    (%eax),%eax
  8002c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002cf:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002db:	8b 45 08             	mov    0x8(%ebp),%eax
  8002de:	01 c8                	add    %ecx,%eax
  8002e0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002e2:	39 c2                	cmp    %eax,%edx
  8002e4:	75 09                	jne    8002ef <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002e6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002ed:	eb 15                	jmp    800304 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002ef:	ff 45 e8             	incl   -0x18(%ebp)
  8002f2:	a1 08 30 80 00       	mov    0x803008,%eax
  8002f7:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8002fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800300:	39 c2                	cmp    %eax,%edx
  800302:	77 85                	ja     800289 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800304:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800308:	75 14                	jne    80031e <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80030a:	83 ec 04             	sub    $0x4,%esp
  80030d:	68 10 1d 80 00       	push   $0x801d10
  800312:	6a 3a                	push   $0x3a
  800314:	68 04 1d 80 00       	push   $0x801d04
  800319:	e8 8d fe ff ff       	call   8001ab <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80031e:	ff 45 f0             	incl   -0x10(%ebp)
  800321:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800324:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800327:	0f 8c 2f ff ff ff    	jl     80025c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80032d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800334:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80033b:	eb 26                	jmp    800363 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80033d:	a1 08 30 80 00       	mov    0x803008,%eax
  800342:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800348:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80034b:	89 d0                	mov    %edx,%eax
  80034d:	01 c0                	add    %eax,%eax
  80034f:	01 d0                	add    %edx,%eax
  800351:	c1 e0 03             	shl    $0x3,%eax
  800354:	01 c8                	add    %ecx,%eax
  800356:	8a 40 04             	mov    0x4(%eax),%al
  800359:	3c 01                	cmp    $0x1,%al
  80035b:	75 03                	jne    800360 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80035d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800360:	ff 45 e0             	incl   -0x20(%ebp)
  800363:	a1 08 30 80 00       	mov    0x803008,%eax
  800368:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80036e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800371:	39 c2                	cmp    %eax,%edx
  800373:	77 c8                	ja     80033d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800378:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80037b:	74 14                	je     800391 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80037d:	83 ec 04             	sub    $0x4,%esp
  800380:	68 64 1d 80 00       	push   $0x801d64
  800385:	6a 44                	push   $0x44
  800387:	68 04 1d 80 00       	push   $0x801d04
  80038c:	e8 1a fe ff ff       	call   8001ab <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800391:	90                   	nop
  800392:	c9                   	leave  
  800393:	c3                   	ret    

00800394 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800394:	55                   	push   %ebp
  800395:	89 e5                	mov    %esp,%ebp
  800397:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80039a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80039d:	8b 00                	mov    (%eax),%eax
  80039f:	8d 48 01             	lea    0x1(%eax),%ecx
  8003a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a5:	89 0a                	mov    %ecx,(%edx)
  8003a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8003aa:	88 d1                	mov    %dl,%cl
  8003ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003af:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b6:	8b 00                	mov    (%eax),%eax
  8003b8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003bd:	75 2c                	jne    8003eb <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003bf:	a0 0c 30 80 00       	mov    0x80300c,%al
  8003c4:	0f b6 c0             	movzbl %al,%eax
  8003c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ca:	8b 12                	mov    (%edx),%edx
  8003cc:	89 d1                	mov    %edx,%ecx
  8003ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003d1:	83 c2 08             	add    $0x8,%edx
  8003d4:	83 ec 04             	sub    $0x4,%esp
  8003d7:	50                   	push   %eax
  8003d8:	51                   	push   %ecx
  8003d9:	52                   	push   %edx
  8003da:	e8 4e 0e 00 00       	call   80122d <sys_cputs>
  8003df:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ee:	8b 40 04             	mov    0x4(%eax),%eax
  8003f1:	8d 50 01             	lea    0x1(%eax),%edx
  8003f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003fa:	90                   	nop
  8003fb:	c9                   	leave  
  8003fc:	c3                   	ret    

008003fd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003fd:	55                   	push   %ebp
  8003fe:	89 e5                	mov    %esp,%ebp
  800400:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800406:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80040d:	00 00 00 
	b.cnt = 0;
  800410:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800417:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80041a:	ff 75 0c             	pushl  0xc(%ebp)
  80041d:	ff 75 08             	pushl  0x8(%ebp)
  800420:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800426:	50                   	push   %eax
  800427:	68 94 03 80 00       	push   $0x800394
  80042c:	e8 11 02 00 00       	call   800642 <vprintfmt>
  800431:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800434:	a0 0c 30 80 00       	mov    0x80300c,%al
  800439:	0f b6 c0             	movzbl %al,%eax
  80043c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800442:	83 ec 04             	sub    $0x4,%esp
  800445:	50                   	push   %eax
  800446:	52                   	push   %edx
  800447:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80044d:	83 c0 08             	add    $0x8,%eax
  800450:	50                   	push   %eax
  800451:	e8 d7 0d 00 00       	call   80122d <sys_cputs>
  800456:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800459:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  800460:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800466:	c9                   	leave  
  800467:	c3                   	ret    

00800468 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800468:	55                   	push   %ebp
  800469:	89 e5                	mov    %esp,%ebp
  80046b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80046e:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  800475:	8d 45 0c             	lea    0xc(%ebp),%eax
  800478:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	83 ec 08             	sub    $0x8,%esp
  800481:	ff 75 f4             	pushl  -0xc(%ebp)
  800484:	50                   	push   %eax
  800485:	e8 73 ff ff ff       	call   8003fd <vcprintf>
  80048a:	83 c4 10             	add    $0x10,%esp
  80048d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800490:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800493:	c9                   	leave  
  800494:	c3                   	ret    

00800495 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800495:	55                   	push   %ebp
  800496:	89 e5                	mov    %esp,%ebp
  800498:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80049b:	e8 cf 0d 00 00       	call   80126f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8004a0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	83 ec 08             	sub    $0x8,%esp
  8004ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8004af:	50                   	push   %eax
  8004b0:	e8 48 ff ff ff       	call   8003fd <vcprintf>
  8004b5:	83 c4 10             	add    $0x10,%esp
  8004b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004bb:	e8 c9 0d 00 00       	call   801289 <sys_unlock_cons>
	return cnt;
  8004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004c3:	c9                   	leave  
  8004c4:	c3                   	ret    

008004c5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004c5:	55                   	push   %ebp
  8004c6:	89 e5                	mov    %esp,%ebp
  8004c8:	53                   	push   %ebx
  8004c9:	83 ec 14             	sub    $0x14,%esp
  8004cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8004cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004d8:	8b 45 18             	mov    0x18(%ebp),%eax
  8004db:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004e3:	77 55                	ja     80053a <printnum+0x75>
  8004e5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004e8:	72 05                	jb     8004ef <printnum+0x2a>
  8004ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004ed:	77 4b                	ja     80053a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004ef:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004f2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8004f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8004fd:	52                   	push   %edx
  8004fe:	50                   	push   %eax
  8004ff:	ff 75 f4             	pushl  -0xc(%ebp)
  800502:	ff 75 f0             	pushl  -0x10(%ebp)
  800505:	e8 96 13 00 00       	call   8018a0 <__udivdi3>
  80050a:	83 c4 10             	add    $0x10,%esp
  80050d:	83 ec 04             	sub    $0x4,%esp
  800510:	ff 75 20             	pushl  0x20(%ebp)
  800513:	53                   	push   %ebx
  800514:	ff 75 18             	pushl  0x18(%ebp)
  800517:	52                   	push   %edx
  800518:	50                   	push   %eax
  800519:	ff 75 0c             	pushl  0xc(%ebp)
  80051c:	ff 75 08             	pushl  0x8(%ebp)
  80051f:	e8 a1 ff ff ff       	call   8004c5 <printnum>
  800524:	83 c4 20             	add    $0x20,%esp
  800527:	eb 1a                	jmp    800543 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800529:	83 ec 08             	sub    $0x8,%esp
  80052c:	ff 75 0c             	pushl  0xc(%ebp)
  80052f:	ff 75 20             	pushl  0x20(%ebp)
  800532:	8b 45 08             	mov    0x8(%ebp),%eax
  800535:	ff d0                	call   *%eax
  800537:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80053a:	ff 4d 1c             	decl   0x1c(%ebp)
  80053d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800541:	7f e6                	jg     800529 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800543:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800546:	bb 00 00 00 00       	mov    $0x0,%ebx
  80054b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800551:	53                   	push   %ebx
  800552:	51                   	push   %ecx
  800553:	52                   	push   %edx
  800554:	50                   	push   %eax
  800555:	e8 56 14 00 00       	call   8019b0 <__umoddi3>
  80055a:	83 c4 10             	add    $0x10,%esp
  80055d:	05 d4 1f 80 00       	add    $0x801fd4,%eax
  800562:	8a 00                	mov    (%eax),%al
  800564:	0f be c0             	movsbl %al,%eax
  800567:	83 ec 08             	sub    $0x8,%esp
  80056a:	ff 75 0c             	pushl  0xc(%ebp)
  80056d:	50                   	push   %eax
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	ff d0                	call   *%eax
  800573:	83 c4 10             	add    $0x10,%esp
}
  800576:	90                   	nop
  800577:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80057a:	c9                   	leave  
  80057b:	c3                   	ret    

0080057c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80057c:	55                   	push   %ebp
  80057d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80057f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800583:	7e 1c                	jle    8005a1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800585:	8b 45 08             	mov    0x8(%ebp),%eax
  800588:	8b 00                	mov    (%eax),%eax
  80058a:	8d 50 08             	lea    0x8(%eax),%edx
  80058d:	8b 45 08             	mov    0x8(%ebp),%eax
  800590:	89 10                	mov    %edx,(%eax)
  800592:	8b 45 08             	mov    0x8(%ebp),%eax
  800595:	8b 00                	mov    (%eax),%eax
  800597:	83 e8 08             	sub    $0x8,%eax
  80059a:	8b 50 04             	mov    0x4(%eax),%edx
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	eb 40                	jmp    8005e1 <getuint+0x65>
	else if (lflag)
  8005a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005a5:	74 1e                	je     8005c5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	8b 00                	mov    (%eax),%eax
  8005ac:	8d 50 04             	lea    0x4(%eax),%edx
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	89 10                	mov    %edx,(%eax)
  8005b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b7:	8b 00                	mov    (%eax),%eax
  8005b9:	83 e8 04             	sub    $0x4,%eax
  8005bc:	8b 00                	mov    (%eax),%eax
  8005be:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c3:	eb 1c                	jmp    8005e1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	8d 50 04             	lea    0x4(%eax),%edx
  8005cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d0:	89 10                	mov    %edx,(%eax)
  8005d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	83 e8 04             	sub    $0x4,%eax
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005e1:	5d                   	pop    %ebp
  8005e2:	c3                   	ret    

008005e3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005e3:	55                   	push   %ebp
  8005e4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005e6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005ea:	7e 1c                	jle    800608 <getint+0x25>
		return va_arg(*ap, long long);
  8005ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ef:	8b 00                	mov    (%eax),%eax
  8005f1:	8d 50 08             	lea    0x8(%eax),%edx
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	89 10                	mov    %edx,(%eax)
  8005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fc:	8b 00                	mov    (%eax),%eax
  8005fe:	83 e8 08             	sub    $0x8,%eax
  800601:	8b 50 04             	mov    0x4(%eax),%edx
  800604:	8b 00                	mov    (%eax),%eax
  800606:	eb 38                	jmp    800640 <getint+0x5d>
	else if (lflag)
  800608:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80060c:	74 1a                	je     800628 <getint+0x45>
		return va_arg(*ap, long);
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	8b 00                	mov    (%eax),%eax
  800613:	8d 50 04             	lea    0x4(%eax),%edx
  800616:	8b 45 08             	mov    0x8(%ebp),%eax
  800619:	89 10                	mov    %edx,(%eax)
  80061b:	8b 45 08             	mov    0x8(%ebp),%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	83 e8 04             	sub    $0x4,%eax
  800623:	8b 00                	mov    (%eax),%eax
  800625:	99                   	cltd   
  800626:	eb 18                	jmp    800640 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800628:	8b 45 08             	mov    0x8(%ebp),%eax
  80062b:	8b 00                	mov    (%eax),%eax
  80062d:	8d 50 04             	lea    0x4(%eax),%edx
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	89 10                	mov    %edx,(%eax)
  800635:	8b 45 08             	mov    0x8(%ebp),%eax
  800638:	8b 00                	mov    (%eax),%eax
  80063a:	83 e8 04             	sub    $0x4,%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	99                   	cltd   
}
  800640:	5d                   	pop    %ebp
  800641:	c3                   	ret    

00800642 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800642:	55                   	push   %ebp
  800643:	89 e5                	mov    %esp,%ebp
  800645:	56                   	push   %esi
  800646:	53                   	push   %ebx
  800647:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80064a:	eb 17                	jmp    800663 <vprintfmt+0x21>
			if (ch == '\0')
  80064c:	85 db                	test   %ebx,%ebx
  80064e:	0f 84 c1 03 00 00    	je     800a15 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	ff 75 0c             	pushl  0xc(%ebp)
  80065a:	53                   	push   %ebx
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	ff d0                	call   *%eax
  800660:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800663:	8b 45 10             	mov    0x10(%ebp),%eax
  800666:	8d 50 01             	lea    0x1(%eax),%edx
  800669:	89 55 10             	mov    %edx,0x10(%ebp)
  80066c:	8a 00                	mov    (%eax),%al
  80066e:	0f b6 d8             	movzbl %al,%ebx
  800671:	83 fb 25             	cmp    $0x25,%ebx
  800674:	75 d6                	jne    80064c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800676:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80067a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800681:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800688:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80068f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800696:	8b 45 10             	mov    0x10(%ebp),%eax
  800699:	8d 50 01             	lea    0x1(%eax),%edx
  80069c:	89 55 10             	mov    %edx,0x10(%ebp)
  80069f:	8a 00                	mov    (%eax),%al
  8006a1:	0f b6 d8             	movzbl %al,%ebx
  8006a4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006a7:	83 f8 5b             	cmp    $0x5b,%eax
  8006aa:	0f 87 3d 03 00 00    	ja     8009ed <vprintfmt+0x3ab>
  8006b0:	8b 04 85 f8 1f 80 00 	mov    0x801ff8(,%eax,4),%eax
  8006b7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006b9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006bd:	eb d7                	jmp    800696 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006bf:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006c3:	eb d1                	jmp    800696 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006c5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006cf:	89 d0                	mov    %edx,%eax
  8006d1:	c1 e0 02             	shl    $0x2,%eax
  8006d4:	01 d0                	add    %edx,%eax
  8006d6:	01 c0                	add    %eax,%eax
  8006d8:	01 d8                	add    %ebx,%eax
  8006da:	83 e8 30             	sub    $0x30,%eax
  8006dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8006e3:	8a 00                	mov    (%eax),%al
  8006e5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006e8:	83 fb 2f             	cmp    $0x2f,%ebx
  8006eb:	7e 3e                	jle    80072b <vprintfmt+0xe9>
  8006ed:	83 fb 39             	cmp    $0x39,%ebx
  8006f0:	7f 39                	jg     80072b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006f2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006f5:	eb d5                	jmp    8006cc <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fa:	83 c0 04             	add    $0x4,%eax
  8006fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	83 e8 04             	sub    $0x4,%eax
  800706:	8b 00                	mov    (%eax),%eax
  800708:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80070b:	eb 1f                	jmp    80072c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80070d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800711:	79 83                	jns    800696 <vprintfmt+0x54>
				width = 0;
  800713:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80071a:	e9 77 ff ff ff       	jmp    800696 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80071f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800726:	e9 6b ff ff ff       	jmp    800696 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80072b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80072c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800730:	0f 89 60 ff ff ff    	jns    800696 <vprintfmt+0x54>
				width = precision, precision = -1;
  800736:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800739:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80073c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800743:	e9 4e ff ff ff       	jmp    800696 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800748:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80074b:	e9 46 ff ff ff       	jmp    800696 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800750:	8b 45 14             	mov    0x14(%ebp),%eax
  800753:	83 c0 04             	add    $0x4,%eax
  800756:	89 45 14             	mov    %eax,0x14(%ebp)
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	83 e8 04             	sub    $0x4,%eax
  80075f:	8b 00                	mov    (%eax),%eax
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	ff 75 0c             	pushl  0xc(%ebp)
  800767:	50                   	push   %eax
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	ff d0                	call   *%eax
  80076d:	83 c4 10             	add    $0x10,%esp
			break;
  800770:	e9 9b 02 00 00       	jmp    800a10 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800775:	8b 45 14             	mov    0x14(%ebp),%eax
  800778:	83 c0 04             	add    $0x4,%eax
  80077b:	89 45 14             	mov    %eax,0x14(%ebp)
  80077e:	8b 45 14             	mov    0x14(%ebp),%eax
  800781:	83 e8 04             	sub    $0x4,%eax
  800784:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800786:	85 db                	test   %ebx,%ebx
  800788:	79 02                	jns    80078c <vprintfmt+0x14a>
				err = -err;
  80078a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80078c:	83 fb 64             	cmp    $0x64,%ebx
  80078f:	7f 0b                	jg     80079c <vprintfmt+0x15a>
  800791:	8b 34 9d 40 1e 80 00 	mov    0x801e40(,%ebx,4),%esi
  800798:	85 f6                	test   %esi,%esi
  80079a:	75 19                	jne    8007b5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80079c:	53                   	push   %ebx
  80079d:	68 e5 1f 80 00       	push   $0x801fe5
  8007a2:	ff 75 0c             	pushl  0xc(%ebp)
  8007a5:	ff 75 08             	pushl  0x8(%ebp)
  8007a8:	e8 70 02 00 00       	call   800a1d <printfmt>
  8007ad:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007b0:	e9 5b 02 00 00       	jmp    800a10 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007b5:	56                   	push   %esi
  8007b6:	68 ee 1f 80 00       	push   $0x801fee
  8007bb:	ff 75 0c             	pushl  0xc(%ebp)
  8007be:	ff 75 08             	pushl  0x8(%ebp)
  8007c1:	e8 57 02 00 00       	call   800a1d <printfmt>
  8007c6:	83 c4 10             	add    $0x10,%esp
			break;
  8007c9:	e9 42 02 00 00       	jmp    800a10 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	83 c0 04             	add    $0x4,%eax
  8007d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	83 e8 04             	sub    $0x4,%eax
  8007dd:	8b 30                	mov    (%eax),%esi
  8007df:	85 f6                	test   %esi,%esi
  8007e1:	75 05                	jne    8007e8 <vprintfmt+0x1a6>
				p = "(null)";
  8007e3:	be f1 1f 80 00       	mov    $0x801ff1,%esi
			if (width > 0 && padc != '-')
  8007e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ec:	7e 6d                	jle    80085b <vprintfmt+0x219>
  8007ee:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007f2:	74 67                	je     80085b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f7:	83 ec 08             	sub    $0x8,%esp
  8007fa:	50                   	push   %eax
  8007fb:	56                   	push   %esi
  8007fc:	e8 1e 03 00 00       	call   800b1f <strnlen>
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800807:	eb 16                	jmp    80081f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800809:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	50                   	push   %eax
  800814:	8b 45 08             	mov    0x8(%ebp),%eax
  800817:	ff d0                	call   *%eax
  800819:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80081c:	ff 4d e4             	decl   -0x1c(%ebp)
  80081f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800823:	7f e4                	jg     800809 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800825:	eb 34                	jmp    80085b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800827:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80082b:	74 1c                	je     800849 <vprintfmt+0x207>
  80082d:	83 fb 1f             	cmp    $0x1f,%ebx
  800830:	7e 05                	jle    800837 <vprintfmt+0x1f5>
  800832:	83 fb 7e             	cmp    $0x7e,%ebx
  800835:	7e 12                	jle    800849 <vprintfmt+0x207>
					putch('?', putdat);
  800837:	83 ec 08             	sub    $0x8,%esp
  80083a:	ff 75 0c             	pushl  0xc(%ebp)
  80083d:	6a 3f                	push   $0x3f
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	ff d0                	call   *%eax
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	eb 0f                	jmp    800858 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800849:	83 ec 08             	sub    $0x8,%esp
  80084c:	ff 75 0c             	pushl  0xc(%ebp)
  80084f:	53                   	push   %ebx
  800850:	8b 45 08             	mov    0x8(%ebp),%eax
  800853:	ff d0                	call   *%eax
  800855:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800858:	ff 4d e4             	decl   -0x1c(%ebp)
  80085b:	89 f0                	mov    %esi,%eax
  80085d:	8d 70 01             	lea    0x1(%eax),%esi
  800860:	8a 00                	mov    (%eax),%al
  800862:	0f be d8             	movsbl %al,%ebx
  800865:	85 db                	test   %ebx,%ebx
  800867:	74 24                	je     80088d <vprintfmt+0x24b>
  800869:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80086d:	78 b8                	js     800827 <vprintfmt+0x1e5>
  80086f:	ff 4d e0             	decl   -0x20(%ebp)
  800872:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800876:	79 af                	jns    800827 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800878:	eb 13                	jmp    80088d <vprintfmt+0x24b>
				putch(' ', putdat);
  80087a:	83 ec 08             	sub    $0x8,%esp
  80087d:	ff 75 0c             	pushl  0xc(%ebp)
  800880:	6a 20                	push   $0x20
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	ff d0                	call   *%eax
  800887:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80088a:	ff 4d e4             	decl   -0x1c(%ebp)
  80088d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800891:	7f e7                	jg     80087a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800893:	e9 78 01 00 00       	jmp    800a10 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800898:	83 ec 08             	sub    $0x8,%esp
  80089b:	ff 75 e8             	pushl  -0x18(%ebp)
  80089e:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a1:	50                   	push   %eax
  8008a2:	e8 3c fd ff ff       	call   8005e3 <getint>
  8008a7:	83 c4 10             	add    $0x10,%esp
  8008aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b6:	85 d2                	test   %edx,%edx
  8008b8:	79 23                	jns    8008dd <vprintfmt+0x29b>
				putch('-', putdat);
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	ff 75 0c             	pushl  0xc(%ebp)
  8008c0:	6a 2d                	push   $0x2d
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	ff d0                	call   *%eax
  8008c7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008d0:	f7 d8                	neg    %eax
  8008d2:	83 d2 00             	adc    $0x0,%edx
  8008d5:	f7 da                	neg    %edx
  8008d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008dd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008e4:	e9 bc 00 00 00       	jmp    8009a5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	ff 75 e8             	pushl  -0x18(%ebp)
  8008ef:	8d 45 14             	lea    0x14(%ebp),%eax
  8008f2:	50                   	push   %eax
  8008f3:	e8 84 fc ff ff       	call   80057c <getuint>
  8008f8:	83 c4 10             	add    $0x10,%esp
  8008fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800901:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800908:	e9 98 00 00 00       	jmp    8009a5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80090d:	83 ec 08             	sub    $0x8,%esp
  800910:	ff 75 0c             	pushl  0xc(%ebp)
  800913:	6a 58                	push   $0x58
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	ff d0                	call   *%eax
  80091a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80091d:	83 ec 08             	sub    $0x8,%esp
  800920:	ff 75 0c             	pushl  0xc(%ebp)
  800923:	6a 58                	push   $0x58
  800925:	8b 45 08             	mov    0x8(%ebp),%eax
  800928:	ff d0                	call   *%eax
  80092a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80092d:	83 ec 08             	sub    $0x8,%esp
  800930:	ff 75 0c             	pushl  0xc(%ebp)
  800933:	6a 58                	push   $0x58
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	ff d0                	call   *%eax
  80093a:	83 c4 10             	add    $0x10,%esp
			break;
  80093d:	e9 ce 00 00 00       	jmp    800a10 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800942:	83 ec 08             	sub    $0x8,%esp
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	6a 30                	push   $0x30
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	ff d0                	call   *%eax
  80094f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800952:	83 ec 08             	sub    $0x8,%esp
  800955:	ff 75 0c             	pushl  0xc(%ebp)
  800958:	6a 78                	push   $0x78
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	ff d0                	call   *%eax
  80095f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800962:	8b 45 14             	mov    0x14(%ebp),%eax
  800965:	83 c0 04             	add    $0x4,%eax
  800968:	89 45 14             	mov    %eax,0x14(%ebp)
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	83 e8 04             	sub    $0x4,%eax
  800971:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800973:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800976:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80097d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800984:	eb 1f                	jmp    8009a5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800986:	83 ec 08             	sub    $0x8,%esp
  800989:	ff 75 e8             	pushl  -0x18(%ebp)
  80098c:	8d 45 14             	lea    0x14(%ebp),%eax
  80098f:	50                   	push   %eax
  800990:	e8 e7 fb ff ff       	call   80057c <getuint>
  800995:	83 c4 10             	add    $0x10,%esp
  800998:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80099e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009a5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ac:	83 ec 04             	sub    $0x4,%esp
  8009af:	52                   	push   %edx
  8009b0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009b3:	50                   	push   %eax
  8009b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b7:	ff 75 f0             	pushl  -0x10(%ebp)
  8009ba:	ff 75 0c             	pushl  0xc(%ebp)
  8009bd:	ff 75 08             	pushl  0x8(%ebp)
  8009c0:	e8 00 fb ff ff       	call   8004c5 <printnum>
  8009c5:	83 c4 20             	add    $0x20,%esp
			break;
  8009c8:	eb 46                	jmp    800a10 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	53                   	push   %ebx
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	ff d0                	call   *%eax
  8009d6:	83 c4 10             	add    $0x10,%esp
			break;
  8009d9:	eb 35                	jmp    800a10 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009db:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  8009e2:	eb 2c                	jmp    800a10 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009e4:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  8009eb:	eb 23                	jmp    800a10 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009ed:	83 ec 08             	sub    $0x8,%esp
  8009f0:	ff 75 0c             	pushl  0xc(%ebp)
  8009f3:	6a 25                	push   $0x25
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	ff d0                	call   *%eax
  8009fa:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009fd:	ff 4d 10             	decl   0x10(%ebp)
  800a00:	eb 03                	jmp    800a05 <vprintfmt+0x3c3>
  800a02:	ff 4d 10             	decl   0x10(%ebp)
  800a05:	8b 45 10             	mov    0x10(%ebp),%eax
  800a08:	48                   	dec    %eax
  800a09:	8a 00                	mov    (%eax),%al
  800a0b:	3c 25                	cmp    $0x25,%al
  800a0d:	75 f3                	jne    800a02 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a0f:	90                   	nop
		}
	}
  800a10:	e9 35 fc ff ff       	jmp    80064a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a15:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a16:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a19:	5b                   	pop    %ebx
  800a1a:	5e                   	pop    %esi
  800a1b:	5d                   	pop    %ebp
  800a1c:	c3                   	ret    

00800a1d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a1d:	55                   	push   %ebp
  800a1e:	89 e5                	mov    %esp,%ebp
  800a20:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a23:	8d 45 10             	lea    0x10(%ebp),%eax
  800a26:	83 c0 04             	add    $0x4,%eax
  800a29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a32:	50                   	push   %eax
  800a33:	ff 75 0c             	pushl  0xc(%ebp)
  800a36:	ff 75 08             	pushl  0x8(%ebp)
  800a39:	e8 04 fc ff ff       	call   800642 <vprintfmt>
  800a3e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a41:	90                   	nop
  800a42:	c9                   	leave  
  800a43:	c3                   	ret    

00800a44 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4a:	8b 40 08             	mov    0x8(%eax),%eax
  800a4d:	8d 50 01             	lea    0x1(%eax),%edx
  800a50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a53:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a59:	8b 10                	mov    (%eax),%edx
  800a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5e:	8b 40 04             	mov    0x4(%eax),%eax
  800a61:	39 c2                	cmp    %eax,%edx
  800a63:	73 12                	jae    800a77 <sprintputch+0x33>
		*b->buf++ = ch;
  800a65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a68:	8b 00                	mov    (%eax),%eax
  800a6a:	8d 48 01             	lea    0x1(%eax),%ecx
  800a6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a70:	89 0a                	mov    %ecx,(%edx)
  800a72:	8b 55 08             	mov    0x8(%ebp),%edx
  800a75:	88 10                	mov    %dl,(%eax)
}
  800a77:	90                   	nop
  800a78:	5d                   	pop    %ebp
  800a79:	c3                   	ret    

00800a7a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a89:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	01 d0                	add    %edx,%eax
  800a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a9f:	74 06                	je     800aa7 <vsnprintf+0x2d>
  800aa1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aa5:	7f 07                	jg     800aae <vsnprintf+0x34>
		return -E_INVAL;
  800aa7:	b8 03 00 00 00       	mov    $0x3,%eax
  800aac:	eb 20                	jmp    800ace <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800aae:	ff 75 14             	pushl  0x14(%ebp)
  800ab1:	ff 75 10             	pushl  0x10(%ebp)
  800ab4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ab7:	50                   	push   %eax
  800ab8:	68 44 0a 80 00       	push   $0x800a44
  800abd:	e8 80 fb ff ff       	call   800642 <vprintfmt>
  800ac2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ac5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ace:	c9                   	leave  
  800acf:	c3                   	ret    

00800ad0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ad0:	55                   	push   %ebp
  800ad1:	89 e5                	mov    %esp,%ebp
  800ad3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ad6:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad9:	83 c0 04             	add    $0x4,%eax
  800adc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800adf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae5:	50                   	push   %eax
  800ae6:	ff 75 0c             	pushl  0xc(%ebp)
  800ae9:	ff 75 08             	pushl  0x8(%ebp)
  800aec:	e8 89 ff ff ff       	call   800a7a <vsnprintf>
  800af1:	83 c4 10             	add    $0x10,%esp
  800af4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800afa:	c9                   	leave  
  800afb:	c3                   	ret    

00800afc <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b09:	eb 06                	jmp    800b11 <strlen+0x15>
		n++;
  800b0b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b0e:	ff 45 08             	incl   0x8(%ebp)
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	8a 00                	mov    (%eax),%al
  800b16:	84 c0                	test   %al,%al
  800b18:	75 f1                	jne    800b0b <strlen+0xf>
		n++;
	return n;
  800b1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b1d:	c9                   	leave  
  800b1e:	c3                   	ret    

00800b1f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b2c:	eb 09                	jmp    800b37 <strnlen+0x18>
		n++;
  800b2e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b31:	ff 45 08             	incl   0x8(%ebp)
  800b34:	ff 4d 0c             	decl   0xc(%ebp)
  800b37:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b3b:	74 09                	je     800b46 <strnlen+0x27>
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	8a 00                	mov    (%eax),%al
  800b42:	84 c0                	test   %al,%al
  800b44:	75 e8                	jne    800b2e <strnlen+0xf>
		n++;
	return n;
  800b46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b49:	c9                   	leave  
  800b4a:	c3                   	ret    

00800b4b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b57:	90                   	nop
  800b58:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5b:	8d 50 01             	lea    0x1(%eax),%edx
  800b5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800b61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b64:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b67:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b6a:	8a 12                	mov    (%edx),%dl
  800b6c:	88 10                	mov    %dl,(%eax)
  800b6e:	8a 00                	mov    (%eax),%al
  800b70:	84 c0                	test   %al,%al
  800b72:	75 e4                	jne    800b58 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b77:	c9                   	leave  
  800b78:	c3                   	ret    

00800b79 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
  800b7c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b82:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b8c:	eb 1f                	jmp    800bad <strncpy+0x34>
		*dst++ = *src;
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	8d 50 01             	lea    0x1(%eax),%edx
  800b94:	89 55 08             	mov    %edx,0x8(%ebp)
  800b97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9a:	8a 12                	mov    (%edx),%dl
  800b9c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba1:	8a 00                	mov    (%eax),%al
  800ba3:	84 c0                	test   %al,%al
  800ba5:	74 03                	je     800baa <strncpy+0x31>
			src++;
  800ba7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800baa:	ff 45 fc             	incl   -0x4(%ebp)
  800bad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bb0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bb3:	72 d9                	jb     800b8e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800bb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bb8:	c9                   	leave  
  800bb9:	c3                   	ret    

00800bba <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bc6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bca:	74 30                	je     800bfc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bcc:	eb 16                	jmp    800be4 <strlcpy+0x2a>
			*dst++ = *src++;
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	8d 50 01             	lea    0x1(%eax),%edx
  800bd4:	89 55 08             	mov    %edx,0x8(%ebp)
  800bd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bda:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bdd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800be0:	8a 12                	mov    (%edx),%dl
  800be2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800be4:	ff 4d 10             	decl   0x10(%ebp)
  800be7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800beb:	74 09                	je     800bf6 <strlcpy+0x3c>
  800bed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf0:	8a 00                	mov    (%eax),%al
  800bf2:	84 c0                	test   %al,%al
  800bf4:	75 d8                	jne    800bce <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c02:	29 c2                	sub    %eax,%edx
  800c04:	89 d0                	mov    %edx,%eax
}
  800c06:	c9                   	leave  
  800c07:	c3                   	ret    

00800c08 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c08:	55                   	push   %ebp
  800c09:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c0b:	eb 06                	jmp    800c13 <strcmp+0xb>
		p++, q++;
  800c0d:	ff 45 08             	incl   0x8(%ebp)
  800c10:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	8a 00                	mov    (%eax),%al
  800c18:	84 c0                	test   %al,%al
  800c1a:	74 0e                	je     800c2a <strcmp+0x22>
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8a 10                	mov    (%eax),%dl
  800c21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c24:	8a 00                	mov    (%eax),%al
  800c26:	38 c2                	cmp    %al,%dl
  800c28:	74 e3                	je     800c0d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	8a 00                	mov    (%eax),%al
  800c2f:	0f b6 d0             	movzbl %al,%edx
  800c32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c35:	8a 00                	mov    (%eax),%al
  800c37:	0f b6 c0             	movzbl %al,%eax
  800c3a:	29 c2                	sub    %eax,%edx
  800c3c:	89 d0                	mov    %edx,%eax
}
  800c3e:	5d                   	pop    %ebp
  800c3f:	c3                   	ret    

00800c40 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c43:	eb 09                	jmp    800c4e <strncmp+0xe>
		n--, p++, q++;
  800c45:	ff 4d 10             	decl   0x10(%ebp)
  800c48:	ff 45 08             	incl   0x8(%ebp)
  800c4b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c52:	74 17                	je     800c6b <strncmp+0x2b>
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	8a 00                	mov    (%eax),%al
  800c59:	84 c0                	test   %al,%al
  800c5b:	74 0e                	je     800c6b <strncmp+0x2b>
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	8a 10                	mov    (%eax),%dl
  800c62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c65:	8a 00                	mov    (%eax),%al
  800c67:	38 c2                	cmp    %al,%dl
  800c69:	74 da                	je     800c45 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c6f:	75 07                	jne    800c78 <strncmp+0x38>
		return 0;
  800c71:	b8 00 00 00 00       	mov    $0x0,%eax
  800c76:	eb 14                	jmp    800c8c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c78:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7b:	8a 00                	mov    (%eax),%al
  800c7d:	0f b6 d0             	movzbl %al,%edx
  800c80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c83:	8a 00                	mov    (%eax),%al
  800c85:	0f b6 c0             	movzbl %al,%eax
  800c88:	29 c2                	sub    %eax,%edx
  800c8a:	89 d0                	mov    %edx,%eax
}
  800c8c:	5d                   	pop    %ebp
  800c8d:	c3                   	ret    

00800c8e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	83 ec 04             	sub    $0x4,%esp
  800c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c97:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c9a:	eb 12                	jmp    800cae <strchr+0x20>
		if (*s == c)
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	8a 00                	mov    (%eax),%al
  800ca1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ca4:	75 05                	jne    800cab <strchr+0x1d>
			return (char *) s;
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	eb 11                	jmp    800cbc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cab:	ff 45 08             	incl   0x8(%ebp)
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	8a 00                	mov    (%eax),%al
  800cb3:	84 c0                	test   %al,%al
  800cb5:	75 e5                	jne    800c9c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cbc:	c9                   	leave  
  800cbd:	c3                   	ret    

00800cbe <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	83 ec 04             	sub    $0x4,%esp
  800cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cca:	eb 0d                	jmp    800cd9 <strfind+0x1b>
		if (*s == c)
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cd4:	74 0e                	je     800ce4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cd6:	ff 45 08             	incl   0x8(%ebp)
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	84 c0                	test   %al,%al
  800ce0:	75 ea                	jne    800ccc <strfind+0xe>
  800ce2:	eb 01                	jmp    800ce5 <strfind+0x27>
		if (*s == c)
			break;
  800ce4:	90                   	nop
	return (char *) s;
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ce8:	c9                   	leave  
  800ce9:	c3                   	ret    

00800cea <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cf6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cfc:	eb 0e                	jmp    800d0c <memset+0x22>
		*p++ = c;
  800cfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d01:	8d 50 01             	lea    0x1(%eax),%edx
  800d04:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d07:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d0c:	ff 4d f8             	decl   -0x8(%ebp)
  800d0f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d13:	79 e9                	jns    800cfe <memset+0x14>
		*p++ = c;

	return v;
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d18:	c9                   	leave  
  800d19:	c3                   	ret    

00800d1a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d2c:	eb 16                	jmp    800d44 <memcpy+0x2a>
		*d++ = *s++;
  800d2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d31:	8d 50 01             	lea    0x1(%eax),%edx
  800d34:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d37:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d3a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d40:	8a 12                	mov    (%edx),%dl
  800d42:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d44:	8b 45 10             	mov    0x10(%ebp),%eax
  800d47:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d4a:	89 55 10             	mov    %edx,0x10(%ebp)
  800d4d:	85 c0                	test   %eax,%eax
  800d4f:	75 dd                	jne    800d2e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d54:	c9                   	leave  
  800d55:	c3                   	ret    

00800d56 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
  800d59:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d6e:	73 50                	jae    800dc0 <memmove+0x6a>
  800d70:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d73:	8b 45 10             	mov    0x10(%ebp),%eax
  800d76:	01 d0                	add    %edx,%eax
  800d78:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d7b:	76 43                	jbe    800dc0 <memmove+0x6a>
		s += n;
  800d7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d80:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d83:	8b 45 10             	mov    0x10(%ebp),%eax
  800d86:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d89:	eb 10                	jmp    800d9b <memmove+0x45>
			*--d = *--s;
  800d8b:	ff 4d f8             	decl   -0x8(%ebp)
  800d8e:	ff 4d fc             	decl   -0x4(%ebp)
  800d91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d94:	8a 10                	mov    (%eax),%dl
  800d96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d99:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da1:	89 55 10             	mov    %edx,0x10(%ebp)
  800da4:	85 c0                	test   %eax,%eax
  800da6:	75 e3                	jne    800d8b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800da8:	eb 23                	jmp    800dcd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800daa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dad:	8d 50 01             	lea    0x1(%eax),%edx
  800db0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800db3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800db6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dbc:	8a 12                	mov    (%edx),%dl
  800dbe:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc6:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc9:	85 c0                	test   %eax,%eax
  800dcb:	75 dd                	jne    800daa <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd0:	c9                   	leave  
  800dd1:	c3                   	ret    

00800dd2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800de4:	eb 2a                	jmp    800e10 <memcmp+0x3e>
		if (*s1 != *s2)
  800de6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de9:	8a 10                	mov    (%eax),%dl
  800deb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	38 c2                	cmp    %al,%dl
  800df2:	74 16                	je     800e0a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800df4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	0f b6 d0             	movzbl %al,%edx
  800dfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	0f b6 c0             	movzbl %al,%eax
  800e04:	29 c2                	sub    %eax,%edx
  800e06:	89 d0                	mov    %edx,%eax
  800e08:	eb 18                	jmp    800e22 <memcmp+0x50>
		s1++, s2++;
  800e0a:	ff 45 fc             	incl   -0x4(%ebp)
  800e0d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e10:	8b 45 10             	mov    0x10(%ebp),%eax
  800e13:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e16:	89 55 10             	mov    %edx,0x10(%ebp)
  800e19:	85 c0                	test   %eax,%eax
  800e1b:	75 c9                	jne    800de6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e22:	c9                   	leave  
  800e23:	c3                   	ret    

00800e24 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e30:	01 d0                	add    %edx,%eax
  800e32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e35:	eb 15                	jmp    800e4c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	8a 00                	mov    (%eax),%al
  800e3c:	0f b6 d0             	movzbl %al,%edx
  800e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e42:	0f b6 c0             	movzbl %al,%eax
  800e45:	39 c2                	cmp    %eax,%edx
  800e47:	74 0d                	je     800e56 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e49:	ff 45 08             	incl   0x8(%ebp)
  800e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e52:	72 e3                	jb     800e37 <memfind+0x13>
  800e54:	eb 01                	jmp    800e57 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e56:	90                   	nop
	return (void *) s;
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5a:	c9                   	leave  
  800e5b:	c3                   	ret    

00800e5c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
  800e5f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e69:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e70:	eb 03                	jmp    800e75 <strtol+0x19>
		s++;
  800e72:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	3c 20                	cmp    $0x20,%al
  800e7c:	74 f4                	je     800e72 <strtol+0x16>
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	8a 00                	mov    (%eax),%al
  800e83:	3c 09                	cmp    $0x9,%al
  800e85:	74 eb                	je     800e72 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	8a 00                	mov    (%eax),%al
  800e8c:	3c 2b                	cmp    $0x2b,%al
  800e8e:	75 05                	jne    800e95 <strtol+0x39>
		s++;
  800e90:	ff 45 08             	incl   0x8(%ebp)
  800e93:	eb 13                	jmp    800ea8 <strtol+0x4c>
	else if (*s == '-')
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	8a 00                	mov    (%eax),%al
  800e9a:	3c 2d                	cmp    $0x2d,%al
  800e9c:	75 0a                	jne    800ea8 <strtol+0x4c>
		s++, neg = 1;
  800e9e:	ff 45 08             	incl   0x8(%ebp)
  800ea1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ea8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eac:	74 06                	je     800eb4 <strtol+0x58>
  800eae:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800eb2:	75 20                	jne    800ed4 <strtol+0x78>
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	8a 00                	mov    (%eax),%al
  800eb9:	3c 30                	cmp    $0x30,%al
  800ebb:	75 17                	jne    800ed4 <strtol+0x78>
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	40                   	inc    %eax
  800ec1:	8a 00                	mov    (%eax),%al
  800ec3:	3c 78                	cmp    $0x78,%al
  800ec5:	75 0d                	jne    800ed4 <strtol+0x78>
		s += 2, base = 16;
  800ec7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ecb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ed2:	eb 28                	jmp    800efc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ed4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed8:	75 15                	jne    800eef <strtol+0x93>
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	8a 00                	mov    (%eax),%al
  800edf:	3c 30                	cmp    $0x30,%al
  800ee1:	75 0c                	jne    800eef <strtol+0x93>
		s++, base = 8;
  800ee3:	ff 45 08             	incl   0x8(%ebp)
  800ee6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800eed:	eb 0d                	jmp    800efc <strtol+0xa0>
	else if (base == 0)
  800eef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef3:	75 07                	jne    800efc <strtol+0xa0>
		base = 10;
  800ef5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	8a 00                	mov    (%eax),%al
  800f01:	3c 2f                	cmp    $0x2f,%al
  800f03:	7e 19                	jle    800f1e <strtol+0xc2>
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	3c 39                	cmp    $0x39,%al
  800f0c:	7f 10                	jg     800f1e <strtol+0xc2>
			dig = *s - '0';
  800f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f11:	8a 00                	mov    (%eax),%al
  800f13:	0f be c0             	movsbl %al,%eax
  800f16:	83 e8 30             	sub    $0x30,%eax
  800f19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f1c:	eb 42                	jmp    800f60 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	8a 00                	mov    (%eax),%al
  800f23:	3c 60                	cmp    $0x60,%al
  800f25:	7e 19                	jle    800f40 <strtol+0xe4>
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	3c 7a                	cmp    $0x7a,%al
  800f2e:	7f 10                	jg     800f40 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	8a 00                	mov    (%eax),%al
  800f35:	0f be c0             	movsbl %al,%eax
  800f38:	83 e8 57             	sub    $0x57,%eax
  800f3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f3e:	eb 20                	jmp    800f60 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	3c 40                	cmp    $0x40,%al
  800f47:	7e 39                	jle    800f82 <strtol+0x126>
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	3c 5a                	cmp    $0x5a,%al
  800f50:	7f 30                	jg     800f82 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8a 00                	mov    (%eax),%al
  800f57:	0f be c0             	movsbl %al,%eax
  800f5a:	83 e8 37             	sub    $0x37,%eax
  800f5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f63:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f66:	7d 19                	jge    800f81 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f68:	ff 45 08             	incl   0x8(%ebp)
  800f6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f72:	89 c2                	mov    %eax,%edx
  800f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f77:	01 d0                	add    %edx,%eax
  800f79:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f7c:	e9 7b ff ff ff       	jmp    800efc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f81:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f86:	74 08                	je     800f90 <strtol+0x134>
		*endptr = (char *) s;
  800f88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f90:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f94:	74 07                	je     800f9d <strtol+0x141>
  800f96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f99:	f7 d8                	neg    %eax
  800f9b:	eb 03                	jmp    800fa0 <strtol+0x144>
  800f9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fa0:	c9                   	leave  
  800fa1:	c3                   	ret    

00800fa2 <ltostr>:

void
ltostr(long value, char *str)
{
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fa8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800faf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fb6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fba:	79 13                	jns    800fcf <ltostr+0x2d>
	{
		neg = 1;
  800fbc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fc9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fcc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fd7:	99                   	cltd   
  800fd8:	f7 f9                	idiv   %ecx
  800fda:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fdd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe0:	8d 50 01             	lea    0x1(%eax),%edx
  800fe3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe6:	89 c2                	mov    %eax,%edx
  800fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800feb:	01 d0                	add    %edx,%eax
  800fed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ff0:	83 c2 30             	add    $0x30,%edx
  800ff3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ff5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ffd:	f7 e9                	imul   %ecx
  800fff:	c1 fa 02             	sar    $0x2,%edx
  801002:	89 c8                	mov    %ecx,%eax
  801004:	c1 f8 1f             	sar    $0x1f,%eax
  801007:	29 c2                	sub    %eax,%edx
  801009:	89 d0                	mov    %edx,%eax
  80100b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80100e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801012:	75 bb                	jne    800fcf <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801014:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80101b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101e:	48                   	dec    %eax
  80101f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801022:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801026:	74 3d                	je     801065 <ltostr+0xc3>
		start = 1 ;
  801028:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80102f:	eb 34                	jmp    801065 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801031:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801034:	8b 45 0c             	mov    0xc(%ebp),%eax
  801037:	01 d0                	add    %edx,%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80103e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801041:	8b 45 0c             	mov    0xc(%ebp),%eax
  801044:	01 c2                	add    %eax,%edx
  801046:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104c:	01 c8                	add    %ecx,%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801052:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801055:	8b 45 0c             	mov    0xc(%ebp),%eax
  801058:	01 c2                	add    %eax,%edx
  80105a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80105d:	88 02                	mov    %al,(%edx)
		start++ ;
  80105f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801062:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801065:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801068:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80106b:	7c c4                	jl     801031 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80106d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801070:	8b 45 0c             	mov    0xc(%ebp),%eax
  801073:	01 d0                	add    %edx,%eax
  801075:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801078:	90                   	nop
  801079:	c9                   	leave  
  80107a:	c3                   	ret    

0080107b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80107b:	55                   	push   %ebp
  80107c:	89 e5                	mov    %esp,%ebp
  80107e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801081:	ff 75 08             	pushl  0x8(%ebp)
  801084:	e8 73 fa ff ff       	call   800afc <strlen>
  801089:	83 c4 04             	add    $0x4,%esp
  80108c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80108f:	ff 75 0c             	pushl  0xc(%ebp)
  801092:	e8 65 fa ff ff       	call   800afc <strlen>
  801097:	83 c4 04             	add    $0x4,%esp
  80109a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80109d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010ab:	eb 17                	jmp    8010c4 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b3:	01 c2                	add    %eax,%edx
  8010b5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	01 c8                	add    %ecx,%eax
  8010bd:	8a 00                	mov    (%eax),%al
  8010bf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010c1:	ff 45 fc             	incl   -0x4(%ebp)
  8010c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010ca:	7c e1                	jl     8010ad <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010da:	eb 1f                	jmp    8010fb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010df:	8d 50 01             	lea    0x1(%eax),%edx
  8010e2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010e5:	89 c2                	mov    %eax,%edx
  8010e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ea:	01 c2                	add    %eax,%edx
  8010ec:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f2:	01 c8                	add    %ecx,%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010f8:	ff 45 f8             	incl   -0x8(%ebp)
  8010fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801101:	7c d9                	jl     8010dc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801103:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801106:	8b 45 10             	mov    0x10(%ebp),%eax
  801109:	01 d0                	add    %edx,%eax
  80110b:	c6 00 00             	movb   $0x0,(%eax)
}
  80110e:	90                   	nop
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801114:	8b 45 14             	mov    0x14(%ebp),%eax
  801117:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80111d:	8b 45 14             	mov    0x14(%ebp),%eax
  801120:	8b 00                	mov    (%eax),%eax
  801122:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801129:	8b 45 10             	mov    0x10(%ebp),%eax
  80112c:	01 d0                	add    %edx,%eax
  80112e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801134:	eb 0c                	jmp    801142 <strsplit+0x31>
			*string++ = 0;
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	8d 50 01             	lea    0x1(%eax),%edx
  80113c:	89 55 08             	mov    %edx,0x8(%ebp)
  80113f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801142:	8b 45 08             	mov    0x8(%ebp),%eax
  801145:	8a 00                	mov    (%eax),%al
  801147:	84 c0                	test   %al,%al
  801149:	74 18                	je     801163 <strsplit+0x52>
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	8a 00                	mov    (%eax),%al
  801150:	0f be c0             	movsbl %al,%eax
  801153:	50                   	push   %eax
  801154:	ff 75 0c             	pushl  0xc(%ebp)
  801157:	e8 32 fb ff ff       	call   800c8e <strchr>
  80115c:	83 c4 08             	add    $0x8,%esp
  80115f:	85 c0                	test   %eax,%eax
  801161:	75 d3                	jne    801136 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8a 00                	mov    (%eax),%al
  801168:	84 c0                	test   %al,%al
  80116a:	74 5a                	je     8011c6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80116c:	8b 45 14             	mov    0x14(%ebp),%eax
  80116f:	8b 00                	mov    (%eax),%eax
  801171:	83 f8 0f             	cmp    $0xf,%eax
  801174:	75 07                	jne    80117d <strsplit+0x6c>
		{
			return 0;
  801176:	b8 00 00 00 00       	mov    $0x0,%eax
  80117b:	eb 66                	jmp    8011e3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80117d:	8b 45 14             	mov    0x14(%ebp),%eax
  801180:	8b 00                	mov    (%eax),%eax
  801182:	8d 48 01             	lea    0x1(%eax),%ecx
  801185:	8b 55 14             	mov    0x14(%ebp),%edx
  801188:	89 0a                	mov    %ecx,(%edx)
  80118a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801191:	8b 45 10             	mov    0x10(%ebp),%eax
  801194:	01 c2                	add    %eax,%edx
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119b:	eb 03                	jmp    8011a0 <strsplit+0x8f>
			string++;
  80119d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	84 c0                	test   %al,%al
  8011a7:	74 8b                	je     801134 <strsplit+0x23>
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	0f be c0             	movsbl %al,%eax
  8011b1:	50                   	push   %eax
  8011b2:	ff 75 0c             	pushl  0xc(%ebp)
  8011b5:	e8 d4 fa ff ff       	call   800c8e <strchr>
  8011ba:	83 c4 08             	add    $0x8,%esp
  8011bd:	85 c0                	test   %eax,%eax
  8011bf:	74 dc                	je     80119d <strsplit+0x8c>
			string++;
	}
  8011c1:	e9 6e ff ff ff       	jmp    801134 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011c6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ca:	8b 00                	mov    (%eax),%eax
  8011cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d6:	01 d0                	add    %edx,%eax
  8011d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011de:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011e3:	c9                   	leave  
  8011e4:	c3                   	ret    

008011e5 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011e5:	55                   	push   %ebp
  8011e6:	89 e5                	mov    %esp,%ebp
  8011e8:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8011eb:	83 ec 04             	sub    $0x4,%esp
  8011ee:	68 68 21 80 00       	push   $0x802168
  8011f3:	68 3f 01 00 00       	push   $0x13f
  8011f8:	68 8a 21 80 00       	push   $0x80218a
  8011fd:	e8 a9 ef ff ff       	call   8001ab <_panic>

00801202 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801202:	55                   	push   %ebp
  801203:	89 e5                	mov    %esp,%ebp
  801205:	57                   	push   %edi
  801206:	56                   	push   %esi
  801207:	53                   	push   %ebx
  801208:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801211:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801214:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801217:	8b 7d 18             	mov    0x18(%ebp),%edi
  80121a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80121d:	cd 30                	int    $0x30
  80121f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801222:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801225:	83 c4 10             	add    $0x10,%esp
  801228:	5b                   	pop    %ebx
  801229:	5e                   	pop    %esi
  80122a:	5f                   	pop    %edi
  80122b:	5d                   	pop    %ebp
  80122c:	c3                   	ret    

0080122d <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  80122d:	55                   	push   %ebp
  80122e:	89 e5                	mov    %esp,%ebp
  801230:	83 ec 04             	sub    $0x4,%esp
  801233:	8b 45 10             	mov    0x10(%ebp),%eax
  801236:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801239:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
  801240:	6a 00                	push   $0x0
  801242:	6a 00                	push   $0x0
  801244:	52                   	push   %edx
  801245:	ff 75 0c             	pushl  0xc(%ebp)
  801248:	50                   	push   %eax
  801249:	6a 00                	push   $0x0
  80124b:	e8 b2 ff ff ff       	call   801202 <syscall>
  801250:	83 c4 18             	add    $0x18,%esp
}
  801253:	90                   	nop
  801254:	c9                   	leave  
  801255:	c3                   	ret    

00801256 <sys_cgetc>:

int sys_cgetc(void) {
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801259:	6a 00                	push   $0x0
  80125b:	6a 00                	push   $0x0
  80125d:	6a 00                	push   $0x0
  80125f:	6a 00                	push   $0x0
  801261:	6a 00                	push   $0x0
  801263:	6a 02                	push   $0x2
  801265:	e8 98 ff ff ff       	call   801202 <syscall>
  80126a:	83 c4 18             	add    $0x18,%esp
}
  80126d:	c9                   	leave  
  80126e:	c3                   	ret    

0080126f <sys_lock_cons>:

void sys_lock_cons(void) {
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801272:	6a 00                	push   $0x0
  801274:	6a 00                	push   $0x0
  801276:	6a 00                	push   $0x0
  801278:	6a 00                	push   $0x0
  80127a:	6a 00                	push   $0x0
  80127c:	6a 03                	push   $0x3
  80127e:	e8 7f ff ff ff       	call   801202 <syscall>
  801283:	83 c4 18             	add    $0x18,%esp
}
  801286:	90                   	nop
  801287:	c9                   	leave  
  801288:	c3                   	ret    

00801289 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801289:	55                   	push   %ebp
  80128a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80128c:	6a 00                	push   $0x0
  80128e:	6a 00                	push   $0x0
  801290:	6a 00                	push   $0x0
  801292:	6a 00                	push   $0x0
  801294:	6a 00                	push   $0x0
  801296:	6a 04                	push   $0x4
  801298:	e8 65 ff ff ff       	call   801202 <syscall>
  80129d:	83 c4 18             	add    $0x18,%esp
}
  8012a0:	90                   	nop
  8012a1:	c9                   	leave  
  8012a2:	c3                   	ret    

008012a3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  8012a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ac:	6a 00                	push   $0x0
  8012ae:	6a 00                	push   $0x0
  8012b0:	6a 00                	push   $0x0
  8012b2:	52                   	push   %edx
  8012b3:	50                   	push   %eax
  8012b4:	6a 08                	push   $0x8
  8012b6:	e8 47 ff ff ff       	call   801202 <syscall>
  8012bb:	83 c4 18             	add    $0x18,%esp
}
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    

008012c0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	56                   	push   %esi
  8012c4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  8012c5:	8b 75 18             	mov    0x18(%ebp),%esi
  8012c8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	56                   	push   %esi
  8012d5:	53                   	push   %ebx
  8012d6:	51                   	push   %ecx
  8012d7:	52                   	push   %edx
  8012d8:	50                   	push   %eax
  8012d9:	6a 09                	push   $0x9
  8012db:	e8 22 ff ff ff       	call   801202 <syscall>
  8012e0:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  8012e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e6:	5b                   	pop    %ebx
  8012e7:	5e                   	pop    %esi
  8012e8:	5d                   	pop    %ebp
  8012e9:	c3                   	ret    

008012ea <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f3:	6a 00                	push   $0x0
  8012f5:	6a 00                	push   $0x0
  8012f7:	6a 00                	push   $0x0
  8012f9:	52                   	push   %edx
  8012fa:	50                   	push   %eax
  8012fb:	6a 0a                	push   $0xa
  8012fd:	e8 00 ff ff ff       	call   801202 <syscall>
  801302:	83 c4 18             	add    $0x18,%esp
}
  801305:	c9                   	leave  
  801306:	c3                   	ret    

00801307 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  80130a:	6a 00                	push   $0x0
  80130c:	6a 00                	push   $0x0
  80130e:	6a 00                	push   $0x0
  801310:	ff 75 0c             	pushl  0xc(%ebp)
  801313:	ff 75 08             	pushl  0x8(%ebp)
  801316:	6a 0b                	push   $0xb
  801318:	e8 e5 fe ff ff       	call   801202 <syscall>
  80131d:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801320:	c9                   	leave  
  801321:	c3                   	ret    

00801322 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801322:	55                   	push   %ebp
  801323:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801325:	6a 00                	push   $0x0
  801327:	6a 00                	push   $0x0
  801329:	6a 00                	push   $0x0
  80132b:	6a 00                	push   $0x0
  80132d:	6a 00                	push   $0x0
  80132f:	6a 0c                	push   $0xc
  801331:	e8 cc fe ff ff       	call   801202 <syscall>
  801336:	83 c4 18             	add    $0x18,%esp
}
  801339:	c9                   	leave  
  80133a:	c3                   	ret    

0080133b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80133e:	6a 00                	push   $0x0
  801340:	6a 00                	push   $0x0
  801342:	6a 00                	push   $0x0
  801344:	6a 00                	push   $0x0
  801346:	6a 00                	push   $0x0
  801348:	6a 0d                	push   $0xd
  80134a:	e8 b3 fe ff ff       	call   801202 <syscall>
  80134f:	83 c4 18             	add    $0x18,%esp
}
  801352:	c9                   	leave  
  801353:	c3                   	ret    

00801354 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801357:	6a 00                	push   $0x0
  801359:	6a 00                	push   $0x0
  80135b:	6a 00                	push   $0x0
  80135d:	6a 00                	push   $0x0
  80135f:	6a 00                	push   $0x0
  801361:	6a 0e                	push   $0xe
  801363:	e8 9a fe ff ff       	call   801202 <syscall>
  801368:	83 c4 18             	add    $0x18,%esp
}
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801370:	6a 00                	push   $0x0
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	6a 00                	push   $0x0
  801378:	6a 00                	push   $0x0
  80137a:	6a 0f                	push   $0xf
  80137c:	e8 81 fe ff ff       	call   801202 <syscall>
  801381:	83 c4 18             	add    $0x18,%esp
}
  801384:	c9                   	leave  
  801385:	c3                   	ret    

00801386 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	ff 75 08             	pushl  0x8(%ebp)
  801394:	6a 10                	push   $0x10
  801396:	e8 67 fe ff ff       	call   801202 <syscall>
  80139b:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  80139e:	c9                   	leave  
  80139f:	c3                   	ret    

008013a0 <sys_scarce_memory>:

void sys_scarce_memory() {
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 00                	push   $0x0
  8013ab:	6a 00                	push   $0x0
  8013ad:	6a 11                	push   $0x11
  8013af:	e8 4e fe ff ff       	call   801202 <syscall>
  8013b4:	83 c4 18             	add    $0x18,%esp
}
  8013b7:	90                   	nop
  8013b8:	c9                   	leave  
  8013b9:	c3                   	ret    

008013ba <sys_cputc>:

void sys_cputc(const char c) {
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
  8013bd:	83 ec 04             	sub    $0x4,%esp
  8013c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013c6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 00                	push   $0x0
  8013d0:	6a 00                	push   $0x0
  8013d2:	50                   	push   %eax
  8013d3:	6a 01                	push   $0x1
  8013d5:	e8 28 fe ff ff       	call   801202 <syscall>
  8013da:	83 c4 18             	add    $0x18,%esp
}
  8013dd:	90                   	nop
  8013de:	c9                   	leave  
  8013df:	c3                   	ret    

008013e0 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 14                	push   $0x14
  8013ef:	e8 0e fe ff ff       	call   801202 <syscall>
  8013f4:	83 c4 18             	add    $0x18,%esp
}
  8013f7:	90                   	nop
  8013f8:	c9                   	leave  
  8013f9:	c3                   	ret    

008013fa <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
  8013fd:	83 ec 04             	sub    $0x4,%esp
  801400:	8b 45 10             	mov    0x10(%ebp),%eax
  801403:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801406:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801409:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80140d:	8b 45 08             	mov    0x8(%ebp),%eax
  801410:	6a 00                	push   $0x0
  801412:	51                   	push   %ecx
  801413:	52                   	push   %edx
  801414:	ff 75 0c             	pushl  0xc(%ebp)
  801417:	50                   	push   %eax
  801418:	6a 15                	push   $0x15
  80141a:	e8 e3 fd ff ff       	call   801202 <syscall>
  80141f:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801427:	8b 55 0c             	mov    0xc(%ebp),%edx
  80142a:	8b 45 08             	mov    0x8(%ebp),%eax
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	52                   	push   %edx
  801434:	50                   	push   %eax
  801435:	6a 16                	push   $0x16
  801437:	e8 c6 fd ff ff       	call   801202 <syscall>
  80143c:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  80143f:	c9                   	leave  
  801440:	c3                   	ret    

00801441 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801441:	55                   	push   %ebp
  801442:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801444:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801447:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	6a 00                	push   $0x0
  80144f:	6a 00                	push   $0x0
  801451:	51                   	push   %ecx
  801452:	52                   	push   %edx
  801453:	50                   	push   %eax
  801454:	6a 17                	push   $0x17
  801456:	e8 a7 fd ff ff       	call   801202 <syscall>
  80145b:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801463:	8b 55 0c             	mov    0xc(%ebp),%edx
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	6a 00                	push   $0x0
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	52                   	push   %edx
  801470:	50                   	push   %eax
  801471:	6a 18                	push   $0x18
  801473:	e8 8a fd ff ff       	call   801202 <syscall>
  801478:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  80147b:	c9                   	leave  
  80147c:	c3                   	ret    

0080147d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801480:	8b 45 08             	mov    0x8(%ebp),%eax
  801483:	6a 00                	push   $0x0
  801485:	ff 75 14             	pushl  0x14(%ebp)
  801488:	ff 75 10             	pushl  0x10(%ebp)
  80148b:	ff 75 0c             	pushl  0xc(%ebp)
  80148e:	50                   	push   %eax
  80148f:	6a 19                	push   $0x19
  801491:	e8 6c fd ff ff       	call   801202 <syscall>
  801496:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801499:	c9                   	leave  
  80149a:	c3                   	ret    

0080149b <sys_run_env>:

void sys_run_env(int32 envId) {
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  80149e:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	50                   	push   %eax
  8014aa:	6a 1a                	push   $0x1a
  8014ac:	e8 51 fd ff ff       	call   801202 <syscall>
  8014b1:	83 c4 18             	add    $0x18,%esp
}
  8014b4:	90                   	nop
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    

008014b7 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	50                   	push   %eax
  8014c6:	6a 1b                	push   $0x1b
  8014c8:	e8 35 fd ff ff       	call   801202 <syscall>
  8014cd:	83 c4 18             	add    $0x18,%esp
}
  8014d0:	c9                   	leave  
  8014d1:	c3                   	ret    

008014d2 <sys_getenvid>:

int32 sys_getenvid(void) {
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 05                	push   $0x5
  8014e1:	e8 1c fd ff ff       	call   801202 <syscall>
  8014e6:	83 c4 18             	add    $0x18,%esp
}
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    

008014eb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 06                	push   $0x6
  8014fa:	e8 03 fd ff ff       	call   801202 <syscall>
  8014ff:	83 c4 18             	add    $0x18,%esp
}
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 07                	push   $0x7
  801513:	e8 ea fc ff ff       	call   801202 <syscall>
  801518:	83 c4 18             	add    $0x18,%esp
}
  80151b:	c9                   	leave  
  80151c:	c3                   	ret    

0080151d <sys_exit_env>:

void sys_exit_env(void) {
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 1c                	push   $0x1c
  80152c:	e8 d1 fc ff ff       	call   801202 <syscall>
  801531:	83 c4 18             	add    $0x18,%esp
}
  801534:	90                   	nop
  801535:	c9                   	leave  
  801536:	c3                   	ret    

00801537 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  80153d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801540:	8d 50 04             	lea    0x4(%eax),%edx
  801543:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	52                   	push   %edx
  80154d:	50                   	push   %eax
  80154e:	6a 1d                	push   $0x1d
  801550:	e8 ad fc ff ff       	call   801202 <syscall>
  801555:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801558:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80155b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80155e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801561:	89 01                	mov    %eax,(%ecx)
  801563:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	c9                   	leave  
  80156a:	c2 04 00             	ret    $0x4

0080156d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801570:	6a 00                	push   $0x0
  801572:	6a 00                	push   $0x0
  801574:	ff 75 10             	pushl  0x10(%ebp)
  801577:	ff 75 0c             	pushl  0xc(%ebp)
  80157a:	ff 75 08             	pushl  0x8(%ebp)
  80157d:	6a 13                	push   $0x13
  80157f:	e8 7e fc ff ff       	call   801202 <syscall>
  801584:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801587:	90                   	nop
}
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <sys_rcr2>:
uint32 sys_rcr2() {
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 1e                	push   $0x1e
  801599:	e8 64 fc ff ff       	call   801202 <syscall>
  80159e:	83 c4 18             	add    $0x18,%esp
}
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	83 ec 04             	sub    $0x4,%esp
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015af:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	50                   	push   %eax
  8015bc:	6a 1f                	push   $0x1f
  8015be:	e8 3f fc ff ff       	call   801202 <syscall>
  8015c3:	83 c4 18             	add    $0x18,%esp
	return;
  8015c6:	90                   	nop
}
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <rsttst>:
void rsttst() {
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 21                	push   $0x21
  8015d8:	e8 25 fc ff ff       	call   801202 <syscall>
  8015dd:	83 c4 18             	add    $0x18,%esp
	return;
  8015e0:	90                   	nop
}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	83 ec 04             	sub    $0x4,%esp
  8015e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015ef:	8b 55 18             	mov    0x18(%ebp),%edx
  8015f2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015f6:	52                   	push   %edx
  8015f7:	50                   	push   %eax
  8015f8:	ff 75 10             	pushl  0x10(%ebp)
  8015fb:	ff 75 0c             	pushl  0xc(%ebp)
  8015fe:	ff 75 08             	pushl  0x8(%ebp)
  801601:	6a 20                	push   $0x20
  801603:	e8 fa fb ff ff       	call   801202 <syscall>
  801608:	83 c4 18             	add    $0x18,%esp
	return;
  80160b:	90                   	nop
}
  80160c:	c9                   	leave  
  80160d:	c3                   	ret    

0080160e <chktst>:
void chktst(uint32 n) {
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	ff 75 08             	pushl  0x8(%ebp)
  80161c:	6a 22                	push   $0x22
  80161e:	e8 df fb ff ff       	call   801202 <syscall>
  801623:	83 c4 18             	add    $0x18,%esp
	return;
  801626:	90                   	nop
}
  801627:	c9                   	leave  
  801628:	c3                   	ret    

00801629 <inctst>:

void inctst() {
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 23                	push   $0x23
  801638:	e8 c5 fb ff ff       	call   801202 <syscall>
  80163d:	83 c4 18             	add    $0x18,%esp
	return;
  801640:	90                   	nop
}
  801641:	c9                   	leave  
  801642:	c3                   	ret    

00801643 <gettst>:
uint32 gettst() {
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 24                	push   $0x24
  801652:	e8 ab fb ff ff       	call   801202 <syscall>
  801657:	83 c4 18             	add    $0x18,%esp
}
  80165a:	c9                   	leave  
  80165b:	c3                   	ret    

0080165c <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
  80165f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 25                	push   $0x25
  80166e:	e8 8f fb ff ff       	call   801202 <syscall>
  801673:	83 c4 18             	add    $0x18,%esp
  801676:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801679:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80167d:	75 07                	jne    801686 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80167f:	b8 01 00 00 00       	mov    $0x1,%eax
  801684:	eb 05                	jmp    80168b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801686:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 25                	push   $0x25
  80169f:	e8 5e fb ff ff       	call   801202 <syscall>
  8016a4:	83 c4 18             	add    $0x18,%esp
  8016a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016aa:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016ae:	75 07                	jne    8016b7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016b0:	b8 01 00 00 00       	mov    $0x1,%eax
  8016b5:	eb 05                	jmp    8016bc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    

008016be <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 25                	push   $0x25
  8016d0:	e8 2d fb ff ff       	call   801202 <syscall>
  8016d5:	83 c4 18             	add    $0x18,%esp
  8016d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016db:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016df:	75 07                	jne    8016e8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8016e6:	eb 05                	jmp    8016ed <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    

008016ef <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 25                	push   $0x25
  801701:	e8 fc fa ff ff       	call   801202 <syscall>
  801706:	83 c4 18             	add    $0x18,%esp
  801709:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80170c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801710:	75 07                	jne    801719 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801712:	b8 01 00 00 00       	mov    $0x1,%eax
  801717:	eb 05                	jmp    80171e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801719:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	ff 75 08             	pushl  0x8(%ebp)
  80172e:	6a 26                	push   $0x26
  801730:	e8 cd fa ff ff       	call   801202 <syscall>
  801735:	83 c4 18             	add    $0x18,%esp
	return;
  801738:	90                   	nop
}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  80173f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801742:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801745:	8b 55 0c             	mov    0xc(%ebp),%edx
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	6a 00                	push   $0x0
  80174d:	53                   	push   %ebx
  80174e:	51                   	push   %ecx
  80174f:	52                   	push   %edx
  801750:	50                   	push   %eax
  801751:	6a 27                	push   $0x27
  801753:	e8 aa fa ff ff       	call   801202 <syscall>
  801758:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  80175b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801763:	8b 55 0c             	mov    0xc(%ebp),%edx
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	52                   	push   %edx
  801770:	50                   	push   %eax
  801771:	6a 28                	push   $0x28
  801773:	e8 8a fa ff ff       	call   801202 <syscall>
  801778:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801780:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801783:	8b 55 0c             	mov    0xc(%ebp),%edx
  801786:	8b 45 08             	mov    0x8(%ebp),%eax
  801789:	6a 00                	push   $0x0
  80178b:	51                   	push   %ecx
  80178c:	ff 75 10             	pushl  0x10(%ebp)
  80178f:	52                   	push   %edx
  801790:	50                   	push   %eax
  801791:	6a 29                	push   $0x29
  801793:	e8 6a fa ff ff       	call   801202 <syscall>
  801798:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	ff 75 10             	pushl  0x10(%ebp)
  8017a7:	ff 75 0c             	pushl  0xc(%ebp)
  8017aa:	ff 75 08             	pushl  0x8(%ebp)
  8017ad:	6a 12                	push   $0x12
  8017af:	e8 4e fa ff ff       	call   801202 <syscall>
  8017b4:	83 c4 18             	add    $0x18,%esp
	return;
  8017b7:	90                   	nop
}
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  8017bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	52                   	push   %edx
  8017ca:	50                   	push   %eax
  8017cb:	6a 2a                	push   $0x2a
  8017cd:	e8 30 fa ff ff       	call   801202 <syscall>
  8017d2:	83 c4 18             	add    $0x18,%esp
	return;
  8017d5:	90                   	nop
}
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8017db:	8b 45 08             	mov    0x8(%ebp),%eax
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	50                   	push   %eax
  8017e7:	6a 2b                	push   $0x2b
  8017e9:	e8 14 fa ff ff       	call   801202 <syscall>
  8017ee:	83 c4 18             	add    $0x18,%esp
}
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	ff 75 0c             	pushl  0xc(%ebp)
  8017ff:	ff 75 08             	pushl  0x8(%ebp)
  801802:	6a 2c                	push   $0x2c
  801804:	e8 f9 f9 ff ff       	call   801202 <syscall>
  801809:	83 c4 18             	add    $0x18,%esp
	return;
  80180c:	90                   	nop
}
  80180d:	c9                   	leave  
  80180e:	c3                   	ret    

0080180f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	ff 75 0c             	pushl  0xc(%ebp)
  80181b:	ff 75 08             	pushl  0x8(%ebp)
  80181e:	6a 2d                	push   $0x2d
  801820:	e8 dd f9 ff ff       	call   801202 <syscall>
  801825:	83 c4 18             	add    $0x18,%esp
	return;
  801828:	90                   	nop
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	50                   	push   %eax
  80183a:	6a 2f                	push   $0x2f
  80183c:	e8 c1 f9 ff ff       	call   801202 <syscall>
  801841:	83 c4 18             	add    $0x18,%esp
	return;
  801844:	90                   	nop
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  80184a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	52                   	push   %edx
  801857:	50                   	push   %eax
  801858:	6a 30                	push   $0x30
  80185a:	e8 a3 f9 ff ff       	call   801202 <syscall>
  80185f:	83 c4 18             	add    $0x18,%esp
	return;
  801862:	90                   	nop
}
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	50                   	push   %eax
  801874:	6a 31                	push   $0x31
  801876:	e8 87 f9 ff ff       	call   801202 <syscall>
  80187b:	83 c4 18             	add    $0x18,%esp
	return;
  80187e:	90                   	nop
}
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801884:	8b 55 0c             	mov    0xc(%ebp),%edx
  801887:	8b 45 08             	mov    0x8(%ebp),%eax
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	52                   	push   %edx
  801891:	50                   	push   %eax
  801892:	6a 2e                	push   $0x2e
  801894:	e8 69 f9 ff ff       	call   801202 <syscall>
  801899:	83 c4 18             	add    $0x18,%esp
    return;
  80189c:	90                   	nop
}
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    
  80189f:	90                   	nop

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
