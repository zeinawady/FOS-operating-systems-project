
obj/user/tst_syscalls_2_slave2:     file format elf32-i386


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
  800031:	e8 33 00 00 00       	call   800069 <libmain>
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
	//[2] Invalid Range (outside User Heap)
	sys_allocate_user_mem(USER_HEAP_MAX, 10);
  80003e:	83 ec 08             	sub    $0x8,%esp
  800041:	6a 0a                	push   $0xa
  800043:	68 00 00 00 a0       	push   $0xa0000000
  800048:	e8 c5 17 00 00       	call   801812 <sys_allocate_user_mem>
  80004d:	83 c4 10             	add    $0x10,%esp
	inctst();
  800050:	e8 d7 15 00 00       	call   80162c <inctst>
	panic("tst system calls #2 failed: sys_allocate_user_mem is called with invalid params\nThe env must be killed and shouldn't return here.");
  800055:	83 ec 04             	sub    $0x4,%esp
  800058:	68 20 1b 80 00       	push   $0x801b20
  80005d:	6a 0a                	push   $0xa
  80005f:	68 a2 1b 80 00       	push   $0x801ba2
  800064:	e8 45 01 00 00       	call   8001ae <_panic>

00800069 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800069:	55                   	push   %ebp
  80006a:	89 e5                	mov    %esp,%ebp
  80006c:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80006f:	e8 7a 14 00 00       	call   8014ee <sys_getenvindex>
  800074:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800077:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80007a:	89 d0                	mov    %edx,%eax
  80007c:	c1 e0 02             	shl    $0x2,%eax
  80007f:	01 d0                	add    %edx,%eax
  800081:	c1 e0 03             	shl    $0x3,%eax
  800084:	01 d0                	add    %edx,%eax
  800086:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80008d:	01 d0                	add    %edx,%eax
  80008f:	c1 e0 02             	shl    $0x2,%eax
  800092:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800097:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80009c:	a1 08 30 80 00       	mov    0x803008,%eax
  8000a1:	8a 40 20             	mov    0x20(%eax),%al
  8000a4:	84 c0                	test   %al,%al
  8000a6:	74 0d                	je     8000b5 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  8000a8:	a1 08 30 80 00       	mov    0x803008,%eax
  8000ad:	83 c0 20             	add    $0x20,%eax
  8000b0:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b9:	7e 0a                	jle    8000c5 <libmain+0x5c>
		binaryname = argv[0];
  8000bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000be:	8b 00                	mov    (%eax),%eax
  8000c0:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000c5:	83 ec 08             	sub    $0x8,%esp
  8000c8:	ff 75 0c             	pushl  0xc(%ebp)
  8000cb:	ff 75 08             	pushl  0x8(%ebp)
  8000ce:	e8 65 ff ff ff       	call   800038 <_main>
  8000d3:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000d6:	a1 00 30 80 00       	mov    0x803000,%eax
  8000db:	85 c0                	test   %eax,%eax
  8000dd:	0f 84 9f 00 00 00    	je     800182 <libmain+0x119>
	{
		sys_lock_cons();
  8000e3:	e8 8a 11 00 00       	call   801272 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 d8 1b 80 00       	push   $0x801bd8
  8000f0:	e8 76 03 00 00       	call   80046b <cprintf>
  8000f5:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000f8:	a1 08 30 80 00       	mov    0x803008,%eax
  8000fd:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800103:	a1 08 30 80 00       	mov    0x803008,%eax
  800108:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80010e:	83 ec 04             	sub    $0x4,%esp
  800111:	52                   	push   %edx
  800112:	50                   	push   %eax
  800113:	68 00 1c 80 00       	push   $0x801c00
  800118:	e8 4e 03 00 00       	call   80046b <cprintf>
  80011d:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800120:	a1 08 30 80 00       	mov    0x803008,%eax
  800125:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80012b:	a1 08 30 80 00       	mov    0x803008,%eax
  800130:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800136:	a1 08 30 80 00       	mov    0x803008,%eax
  80013b:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800141:	51                   	push   %ecx
  800142:	52                   	push   %edx
  800143:	50                   	push   %eax
  800144:	68 28 1c 80 00       	push   $0x801c28
  800149:	e8 1d 03 00 00       	call   80046b <cprintf>
  80014e:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800151:	a1 08 30 80 00       	mov    0x803008,%eax
  800156:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80015c:	83 ec 08             	sub    $0x8,%esp
  80015f:	50                   	push   %eax
  800160:	68 80 1c 80 00       	push   $0x801c80
  800165:	e8 01 03 00 00       	call   80046b <cprintf>
  80016a:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80016d:	83 ec 0c             	sub    $0xc,%esp
  800170:	68 d8 1b 80 00       	push   $0x801bd8
  800175:	e8 f1 02 00 00       	call   80046b <cprintf>
  80017a:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80017d:	e8 0a 11 00 00       	call   80128c <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800182:	e8 19 00 00 00       	call   8001a0 <exit>
}
  800187:	90                   	nop
  800188:	c9                   	leave  
  800189:	c3                   	ret    

0080018a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80018a:	55                   	push   %ebp
  80018b:	89 e5                	mov    %esp,%ebp
  80018d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	6a 00                	push   $0x0
  800195:	e8 20 13 00 00       	call   8014ba <sys_destroy_env>
  80019a:	83 c4 10             	add    $0x10,%esp
}
  80019d:	90                   	nop
  80019e:	c9                   	leave  
  80019f:	c3                   	ret    

008001a0 <exit>:

void
exit(void)
{
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001a6:	e8 75 13 00 00       	call   801520 <sys_exit_env>
}
  8001ab:	90                   	nop
  8001ac:	c9                   	leave  
  8001ad:	c3                   	ret    

008001ae <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001ae:	55                   	push   %ebp
  8001af:	89 e5                	mov    %esp,%ebp
  8001b1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001b4:	8d 45 10             	lea    0x10(%ebp),%eax
  8001b7:	83 c0 04             	add    $0x4,%eax
  8001ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001bd:	a1 28 30 80 00       	mov    0x803028,%eax
  8001c2:	85 c0                	test   %eax,%eax
  8001c4:	74 16                	je     8001dc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001c6:	a1 28 30 80 00       	mov    0x803028,%eax
  8001cb:	83 ec 08             	sub    $0x8,%esp
  8001ce:	50                   	push   %eax
  8001cf:	68 94 1c 80 00       	push   $0x801c94
  8001d4:	e8 92 02 00 00       	call   80046b <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001dc:	a1 04 30 80 00       	mov    0x803004,%eax
  8001e1:	ff 75 0c             	pushl  0xc(%ebp)
  8001e4:	ff 75 08             	pushl  0x8(%ebp)
  8001e7:	50                   	push   %eax
  8001e8:	68 99 1c 80 00       	push   $0x801c99
  8001ed:	e8 79 02 00 00       	call   80046b <cprintf>
  8001f2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f8:	83 ec 08             	sub    $0x8,%esp
  8001fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8001fe:	50                   	push   %eax
  8001ff:	e8 fc 01 00 00       	call   800400 <vcprintf>
  800204:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800207:	83 ec 08             	sub    $0x8,%esp
  80020a:	6a 00                	push   $0x0
  80020c:	68 b5 1c 80 00       	push   $0x801cb5
  800211:	e8 ea 01 00 00       	call   800400 <vcprintf>
  800216:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800219:	e8 82 ff ff ff       	call   8001a0 <exit>

	// should not return here
	while (1) ;
  80021e:	eb fe                	jmp    80021e <_panic+0x70>

00800220 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800226:	a1 08 30 80 00       	mov    0x803008,%eax
  80022b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800231:	8b 45 0c             	mov    0xc(%ebp),%eax
  800234:	39 c2                	cmp    %eax,%edx
  800236:	74 14                	je     80024c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800238:	83 ec 04             	sub    $0x4,%esp
  80023b:	68 b8 1c 80 00       	push   $0x801cb8
  800240:	6a 26                	push   $0x26
  800242:	68 04 1d 80 00       	push   $0x801d04
  800247:	e8 62 ff ff ff       	call   8001ae <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80024c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800253:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80025a:	e9 c5 00 00 00       	jmp    800324 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80025f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800262:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800269:	8b 45 08             	mov    0x8(%ebp),%eax
  80026c:	01 d0                	add    %edx,%eax
  80026e:	8b 00                	mov    (%eax),%eax
  800270:	85 c0                	test   %eax,%eax
  800272:	75 08                	jne    80027c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800274:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800277:	e9 a5 00 00 00       	jmp    800321 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80027c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800283:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80028a:	eb 69                	jmp    8002f5 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80028c:	a1 08 30 80 00       	mov    0x803008,%eax
  800291:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800297:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80029a:	89 d0                	mov    %edx,%eax
  80029c:	01 c0                	add    %eax,%eax
  80029e:	01 d0                	add    %edx,%eax
  8002a0:	c1 e0 03             	shl    $0x3,%eax
  8002a3:	01 c8                	add    %ecx,%eax
  8002a5:	8a 40 04             	mov    0x4(%eax),%al
  8002a8:	84 c0                	test   %al,%al
  8002aa:	75 46                	jne    8002f2 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002ac:	a1 08 30 80 00       	mov    0x803008,%eax
  8002b1:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8002b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002ba:	89 d0                	mov    %edx,%eax
  8002bc:	01 c0                	add    %eax,%eax
  8002be:	01 d0                	add    %edx,%eax
  8002c0:	c1 e0 03             	shl    $0x3,%eax
  8002c3:	01 c8                	add    %ecx,%eax
  8002c5:	8b 00                	mov    (%eax),%eax
  8002c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002d2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002de:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e1:	01 c8                	add    %ecx,%eax
  8002e3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002e5:	39 c2                	cmp    %eax,%edx
  8002e7:	75 09                	jne    8002f2 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002e9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002f0:	eb 15                	jmp    800307 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002f2:	ff 45 e8             	incl   -0x18(%ebp)
  8002f5:	a1 08 30 80 00       	mov    0x803008,%eax
  8002fa:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800300:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800303:	39 c2                	cmp    %eax,%edx
  800305:	77 85                	ja     80028c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800307:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80030b:	75 14                	jne    800321 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	68 10 1d 80 00       	push   $0x801d10
  800315:	6a 3a                	push   $0x3a
  800317:	68 04 1d 80 00       	push   $0x801d04
  80031c:	e8 8d fe ff ff       	call   8001ae <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800321:	ff 45 f0             	incl   -0x10(%ebp)
  800324:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800327:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80032a:	0f 8c 2f ff ff ff    	jl     80025f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800330:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800337:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80033e:	eb 26                	jmp    800366 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800340:	a1 08 30 80 00       	mov    0x803008,%eax
  800345:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80034b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80034e:	89 d0                	mov    %edx,%eax
  800350:	01 c0                	add    %eax,%eax
  800352:	01 d0                	add    %edx,%eax
  800354:	c1 e0 03             	shl    $0x3,%eax
  800357:	01 c8                	add    %ecx,%eax
  800359:	8a 40 04             	mov    0x4(%eax),%al
  80035c:	3c 01                	cmp    $0x1,%al
  80035e:	75 03                	jne    800363 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800360:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800363:	ff 45 e0             	incl   -0x20(%ebp)
  800366:	a1 08 30 80 00       	mov    0x803008,%eax
  80036b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800371:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800374:	39 c2                	cmp    %eax,%edx
  800376:	77 c8                	ja     800340 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80037b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80037e:	74 14                	je     800394 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800380:	83 ec 04             	sub    $0x4,%esp
  800383:	68 64 1d 80 00       	push   $0x801d64
  800388:	6a 44                	push   $0x44
  80038a:	68 04 1d 80 00       	push   $0x801d04
  80038f:	e8 1a fe ff ff       	call   8001ae <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800394:	90                   	nop
  800395:	c9                   	leave  
  800396:	c3                   	ret    

00800397 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800397:	55                   	push   %ebp
  800398:	89 e5                	mov    %esp,%ebp
  80039a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80039d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a0:	8b 00                	mov    (%eax),%eax
  8003a2:	8d 48 01             	lea    0x1(%eax),%ecx
  8003a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a8:	89 0a                	mov    %ecx,(%edx)
  8003aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ad:	88 d1                	mov    %dl,%cl
  8003af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b9:	8b 00                	mov    (%eax),%eax
  8003bb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003c0:	75 2c                	jne    8003ee <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003c2:	a0 0c 30 80 00       	mov    0x80300c,%al
  8003c7:	0f b6 c0             	movzbl %al,%eax
  8003ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003cd:	8b 12                	mov    (%edx),%edx
  8003cf:	89 d1                	mov    %edx,%ecx
  8003d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003d4:	83 c2 08             	add    $0x8,%edx
  8003d7:	83 ec 04             	sub    $0x4,%esp
  8003da:	50                   	push   %eax
  8003db:	51                   	push   %ecx
  8003dc:	52                   	push   %edx
  8003dd:	e8 4e 0e 00 00       	call   801230 <sys_cputs>
  8003e2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f1:	8b 40 04             	mov    0x4(%eax),%eax
  8003f4:	8d 50 01             	lea    0x1(%eax),%edx
  8003f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003fa:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003fd:	90                   	nop
  8003fe:	c9                   	leave  
  8003ff:	c3                   	ret    

00800400 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800400:	55                   	push   %ebp
  800401:	89 e5                	mov    %esp,%ebp
  800403:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800409:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800410:	00 00 00 
	b.cnt = 0;
  800413:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80041a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80041d:	ff 75 0c             	pushl  0xc(%ebp)
  800420:	ff 75 08             	pushl  0x8(%ebp)
  800423:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800429:	50                   	push   %eax
  80042a:	68 97 03 80 00       	push   $0x800397
  80042f:	e8 11 02 00 00       	call   800645 <vprintfmt>
  800434:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800437:	a0 0c 30 80 00       	mov    0x80300c,%al
  80043c:	0f b6 c0             	movzbl %al,%eax
  80043f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800445:	83 ec 04             	sub    $0x4,%esp
  800448:	50                   	push   %eax
  800449:	52                   	push   %edx
  80044a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800450:	83 c0 08             	add    $0x8,%eax
  800453:	50                   	push   %eax
  800454:	e8 d7 0d 00 00       	call   801230 <sys_cputs>
  800459:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80045c:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  800463:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800469:	c9                   	leave  
  80046a:	c3                   	ret    

0080046b <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80046b:	55                   	push   %ebp
  80046c:	89 e5                	mov    %esp,%ebp
  80046e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800471:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  800478:	8d 45 0c             	lea    0xc(%ebp),%eax
  80047b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80047e:	8b 45 08             	mov    0x8(%ebp),%eax
  800481:	83 ec 08             	sub    $0x8,%esp
  800484:	ff 75 f4             	pushl  -0xc(%ebp)
  800487:	50                   	push   %eax
  800488:	e8 73 ff ff ff       	call   800400 <vcprintf>
  80048d:	83 c4 10             	add    $0x10,%esp
  800490:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800493:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800496:	c9                   	leave  
  800497:	c3                   	ret    

00800498 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800498:	55                   	push   %ebp
  800499:	89 e5                	mov    %esp,%ebp
  80049b:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80049e:	e8 cf 0d 00 00       	call   801272 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8004a3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8004a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ac:	83 ec 08             	sub    $0x8,%esp
  8004af:	ff 75 f4             	pushl  -0xc(%ebp)
  8004b2:	50                   	push   %eax
  8004b3:	e8 48 ff ff ff       	call   800400 <vcprintf>
  8004b8:	83 c4 10             	add    $0x10,%esp
  8004bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004be:	e8 c9 0d 00 00       	call   80128c <sys_unlock_cons>
	return cnt;
  8004c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004c6:	c9                   	leave  
  8004c7:	c3                   	ret    

008004c8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	53                   	push   %ebx
  8004cc:	83 ec 14             	sub    $0x14,%esp
  8004cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004db:	8b 45 18             	mov    0x18(%ebp),%eax
  8004de:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004e6:	77 55                	ja     80053d <printnum+0x75>
  8004e8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004eb:	72 05                	jb     8004f2 <printnum+0x2a>
  8004ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004f0:	77 4b                	ja     80053d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004f2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004f5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004f8:	8b 45 18             	mov    0x18(%ebp),%eax
  8004fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800500:	52                   	push   %edx
  800501:	50                   	push   %eax
  800502:	ff 75 f4             	pushl  -0xc(%ebp)
  800505:	ff 75 f0             	pushl  -0x10(%ebp)
  800508:	e8 97 13 00 00       	call   8018a4 <__udivdi3>
  80050d:	83 c4 10             	add    $0x10,%esp
  800510:	83 ec 04             	sub    $0x4,%esp
  800513:	ff 75 20             	pushl  0x20(%ebp)
  800516:	53                   	push   %ebx
  800517:	ff 75 18             	pushl  0x18(%ebp)
  80051a:	52                   	push   %edx
  80051b:	50                   	push   %eax
  80051c:	ff 75 0c             	pushl  0xc(%ebp)
  80051f:	ff 75 08             	pushl  0x8(%ebp)
  800522:	e8 a1 ff ff ff       	call   8004c8 <printnum>
  800527:	83 c4 20             	add    $0x20,%esp
  80052a:	eb 1a                	jmp    800546 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80052c:	83 ec 08             	sub    $0x8,%esp
  80052f:	ff 75 0c             	pushl  0xc(%ebp)
  800532:	ff 75 20             	pushl  0x20(%ebp)
  800535:	8b 45 08             	mov    0x8(%ebp),%eax
  800538:	ff d0                	call   *%eax
  80053a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80053d:	ff 4d 1c             	decl   0x1c(%ebp)
  800540:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800544:	7f e6                	jg     80052c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800546:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800549:	bb 00 00 00 00       	mov    $0x0,%ebx
  80054e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800551:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800554:	53                   	push   %ebx
  800555:	51                   	push   %ecx
  800556:	52                   	push   %edx
  800557:	50                   	push   %eax
  800558:	e8 57 14 00 00       	call   8019b4 <__umoddi3>
  80055d:	83 c4 10             	add    $0x10,%esp
  800560:	05 d4 1f 80 00       	add    $0x801fd4,%eax
  800565:	8a 00                	mov    (%eax),%al
  800567:	0f be c0             	movsbl %al,%eax
  80056a:	83 ec 08             	sub    $0x8,%esp
  80056d:	ff 75 0c             	pushl  0xc(%ebp)
  800570:	50                   	push   %eax
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	ff d0                	call   *%eax
  800576:	83 c4 10             	add    $0x10,%esp
}
  800579:	90                   	nop
  80057a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80057d:	c9                   	leave  
  80057e:	c3                   	ret    

0080057f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80057f:	55                   	push   %ebp
  800580:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800582:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800586:	7e 1c                	jle    8005a4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	8b 00                	mov    (%eax),%eax
  80058d:	8d 50 08             	lea    0x8(%eax),%edx
  800590:	8b 45 08             	mov    0x8(%ebp),%eax
  800593:	89 10                	mov    %edx,(%eax)
  800595:	8b 45 08             	mov    0x8(%ebp),%eax
  800598:	8b 00                	mov    (%eax),%eax
  80059a:	83 e8 08             	sub    $0x8,%eax
  80059d:	8b 50 04             	mov    0x4(%eax),%edx
  8005a0:	8b 00                	mov    (%eax),%eax
  8005a2:	eb 40                	jmp    8005e4 <getuint+0x65>
	else if (lflag)
  8005a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005a8:	74 1e                	je     8005c8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	8b 00                	mov    (%eax),%eax
  8005af:	8d 50 04             	lea    0x4(%eax),%edx
  8005b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b5:	89 10                	mov    %edx,(%eax)
  8005b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	83 e8 04             	sub    $0x4,%eax
  8005bf:	8b 00                	mov    (%eax),%eax
  8005c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c6:	eb 1c                	jmp    8005e4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	8b 00                	mov    (%eax),%eax
  8005cd:	8d 50 04             	lea    0x4(%eax),%edx
  8005d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d3:	89 10                	mov    %edx,(%eax)
  8005d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d8:	8b 00                	mov    (%eax),%eax
  8005da:	83 e8 04             	sub    $0x4,%eax
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005e4:	5d                   	pop    %ebp
  8005e5:	c3                   	ret    

008005e6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005e6:	55                   	push   %ebp
  8005e7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005e9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005ed:	7e 1c                	jle    80060b <getint+0x25>
		return va_arg(*ap, long long);
  8005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f2:	8b 00                	mov    (%eax),%eax
  8005f4:	8d 50 08             	lea    0x8(%eax),%edx
  8005f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fa:	89 10                	mov    %edx,(%eax)
  8005fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ff:	8b 00                	mov    (%eax),%eax
  800601:	83 e8 08             	sub    $0x8,%eax
  800604:	8b 50 04             	mov    0x4(%eax),%edx
  800607:	8b 00                	mov    (%eax),%eax
  800609:	eb 38                	jmp    800643 <getint+0x5d>
	else if (lflag)
  80060b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80060f:	74 1a                	je     80062b <getint+0x45>
		return va_arg(*ap, long);
  800611:	8b 45 08             	mov    0x8(%ebp),%eax
  800614:	8b 00                	mov    (%eax),%eax
  800616:	8d 50 04             	lea    0x4(%eax),%edx
  800619:	8b 45 08             	mov    0x8(%ebp),%eax
  80061c:	89 10                	mov    %edx,(%eax)
  80061e:	8b 45 08             	mov    0x8(%ebp),%eax
  800621:	8b 00                	mov    (%eax),%eax
  800623:	83 e8 04             	sub    $0x4,%eax
  800626:	8b 00                	mov    (%eax),%eax
  800628:	99                   	cltd   
  800629:	eb 18                	jmp    800643 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	8b 00                	mov    (%eax),%eax
  800630:	8d 50 04             	lea    0x4(%eax),%edx
  800633:	8b 45 08             	mov    0x8(%ebp),%eax
  800636:	89 10                	mov    %edx,(%eax)
  800638:	8b 45 08             	mov    0x8(%ebp),%eax
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	83 e8 04             	sub    $0x4,%eax
  800640:	8b 00                	mov    (%eax),%eax
  800642:	99                   	cltd   
}
  800643:	5d                   	pop    %ebp
  800644:	c3                   	ret    

00800645 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800645:	55                   	push   %ebp
  800646:	89 e5                	mov    %esp,%ebp
  800648:	56                   	push   %esi
  800649:	53                   	push   %ebx
  80064a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80064d:	eb 17                	jmp    800666 <vprintfmt+0x21>
			if (ch == '\0')
  80064f:	85 db                	test   %ebx,%ebx
  800651:	0f 84 c1 03 00 00    	je     800a18 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800657:	83 ec 08             	sub    $0x8,%esp
  80065a:	ff 75 0c             	pushl  0xc(%ebp)
  80065d:	53                   	push   %ebx
  80065e:	8b 45 08             	mov    0x8(%ebp),%eax
  800661:	ff d0                	call   *%eax
  800663:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800666:	8b 45 10             	mov    0x10(%ebp),%eax
  800669:	8d 50 01             	lea    0x1(%eax),%edx
  80066c:	89 55 10             	mov    %edx,0x10(%ebp)
  80066f:	8a 00                	mov    (%eax),%al
  800671:	0f b6 d8             	movzbl %al,%ebx
  800674:	83 fb 25             	cmp    $0x25,%ebx
  800677:	75 d6                	jne    80064f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800679:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80067d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800684:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80068b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800692:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800699:	8b 45 10             	mov    0x10(%ebp),%eax
  80069c:	8d 50 01             	lea    0x1(%eax),%edx
  80069f:	89 55 10             	mov    %edx,0x10(%ebp)
  8006a2:	8a 00                	mov    (%eax),%al
  8006a4:	0f b6 d8             	movzbl %al,%ebx
  8006a7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006aa:	83 f8 5b             	cmp    $0x5b,%eax
  8006ad:	0f 87 3d 03 00 00    	ja     8009f0 <vprintfmt+0x3ab>
  8006b3:	8b 04 85 f8 1f 80 00 	mov    0x801ff8(,%eax,4),%eax
  8006ba:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006bc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006c0:	eb d7                	jmp    800699 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006c2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006c6:	eb d1                	jmp    800699 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006c8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006d2:	89 d0                	mov    %edx,%eax
  8006d4:	c1 e0 02             	shl    $0x2,%eax
  8006d7:	01 d0                	add    %edx,%eax
  8006d9:	01 c0                	add    %eax,%eax
  8006db:	01 d8                	add    %ebx,%eax
  8006dd:	83 e8 30             	sub    $0x30,%eax
  8006e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8006e6:	8a 00                	mov    (%eax),%al
  8006e8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006eb:	83 fb 2f             	cmp    $0x2f,%ebx
  8006ee:	7e 3e                	jle    80072e <vprintfmt+0xe9>
  8006f0:	83 fb 39             	cmp    $0x39,%ebx
  8006f3:	7f 39                	jg     80072e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006f5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006f8:	eb d5                	jmp    8006cf <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fd:	83 c0 04             	add    $0x4,%eax
  800700:	89 45 14             	mov    %eax,0x14(%ebp)
  800703:	8b 45 14             	mov    0x14(%ebp),%eax
  800706:	83 e8 04             	sub    $0x4,%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80070e:	eb 1f                	jmp    80072f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800710:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800714:	79 83                	jns    800699 <vprintfmt+0x54>
				width = 0;
  800716:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80071d:	e9 77 ff ff ff       	jmp    800699 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800722:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800729:	e9 6b ff ff ff       	jmp    800699 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80072e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80072f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800733:	0f 89 60 ff ff ff    	jns    800699 <vprintfmt+0x54>
				width = precision, precision = -1;
  800739:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80073c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80073f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800746:	e9 4e ff ff ff       	jmp    800699 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80074b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80074e:	e9 46 ff ff ff       	jmp    800699 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	83 c0 04             	add    $0x4,%eax
  800759:	89 45 14             	mov    %eax,0x14(%ebp)
  80075c:	8b 45 14             	mov    0x14(%ebp),%eax
  80075f:	83 e8 04             	sub    $0x4,%eax
  800762:	8b 00                	mov    (%eax),%eax
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	ff 75 0c             	pushl  0xc(%ebp)
  80076a:	50                   	push   %eax
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	ff d0                	call   *%eax
  800770:	83 c4 10             	add    $0x10,%esp
			break;
  800773:	e9 9b 02 00 00       	jmp    800a13 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800778:	8b 45 14             	mov    0x14(%ebp),%eax
  80077b:	83 c0 04             	add    $0x4,%eax
  80077e:	89 45 14             	mov    %eax,0x14(%ebp)
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	83 e8 04             	sub    $0x4,%eax
  800787:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800789:	85 db                	test   %ebx,%ebx
  80078b:	79 02                	jns    80078f <vprintfmt+0x14a>
				err = -err;
  80078d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80078f:	83 fb 64             	cmp    $0x64,%ebx
  800792:	7f 0b                	jg     80079f <vprintfmt+0x15a>
  800794:	8b 34 9d 40 1e 80 00 	mov    0x801e40(,%ebx,4),%esi
  80079b:	85 f6                	test   %esi,%esi
  80079d:	75 19                	jne    8007b8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80079f:	53                   	push   %ebx
  8007a0:	68 e5 1f 80 00       	push   $0x801fe5
  8007a5:	ff 75 0c             	pushl  0xc(%ebp)
  8007a8:	ff 75 08             	pushl  0x8(%ebp)
  8007ab:	e8 70 02 00 00       	call   800a20 <printfmt>
  8007b0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007b3:	e9 5b 02 00 00       	jmp    800a13 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007b8:	56                   	push   %esi
  8007b9:	68 ee 1f 80 00       	push   $0x801fee
  8007be:	ff 75 0c             	pushl  0xc(%ebp)
  8007c1:	ff 75 08             	pushl  0x8(%ebp)
  8007c4:	e8 57 02 00 00       	call   800a20 <printfmt>
  8007c9:	83 c4 10             	add    $0x10,%esp
			break;
  8007cc:	e9 42 02 00 00       	jmp    800a13 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d4:	83 c0 04             	add    $0x4,%eax
  8007d7:	89 45 14             	mov    %eax,0x14(%ebp)
  8007da:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dd:	83 e8 04             	sub    $0x4,%eax
  8007e0:	8b 30                	mov    (%eax),%esi
  8007e2:	85 f6                	test   %esi,%esi
  8007e4:	75 05                	jne    8007eb <vprintfmt+0x1a6>
				p = "(null)";
  8007e6:	be f1 1f 80 00       	mov    $0x801ff1,%esi
			if (width > 0 && padc != '-')
  8007eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ef:	7e 6d                	jle    80085e <vprintfmt+0x219>
  8007f1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007f5:	74 67                	je     80085e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007fa:	83 ec 08             	sub    $0x8,%esp
  8007fd:	50                   	push   %eax
  8007fe:	56                   	push   %esi
  8007ff:	e8 1e 03 00 00       	call   800b22 <strnlen>
  800804:	83 c4 10             	add    $0x10,%esp
  800807:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80080a:	eb 16                	jmp    800822 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80080c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800810:	83 ec 08             	sub    $0x8,%esp
  800813:	ff 75 0c             	pushl  0xc(%ebp)
  800816:	50                   	push   %eax
  800817:	8b 45 08             	mov    0x8(%ebp),%eax
  80081a:	ff d0                	call   *%eax
  80081c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80081f:	ff 4d e4             	decl   -0x1c(%ebp)
  800822:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800826:	7f e4                	jg     80080c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800828:	eb 34                	jmp    80085e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80082a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80082e:	74 1c                	je     80084c <vprintfmt+0x207>
  800830:	83 fb 1f             	cmp    $0x1f,%ebx
  800833:	7e 05                	jle    80083a <vprintfmt+0x1f5>
  800835:	83 fb 7e             	cmp    $0x7e,%ebx
  800838:	7e 12                	jle    80084c <vprintfmt+0x207>
					putch('?', putdat);
  80083a:	83 ec 08             	sub    $0x8,%esp
  80083d:	ff 75 0c             	pushl  0xc(%ebp)
  800840:	6a 3f                	push   $0x3f
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	ff d0                	call   *%eax
  800847:	83 c4 10             	add    $0x10,%esp
  80084a:	eb 0f                	jmp    80085b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	ff 75 0c             	pushl  0xc(%ebp)
  800852:	53                   	push   %ebx
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	ff d0                	call   *%eax
  800858:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80085b:	ff 4d e4             	decl   -0x1c(%ebp)
  80085e:	89 f0                	mov    %esi,%eax
  800860:	8d 70 01             	lea    0x1(%eax),%esi
  800863:	8a 00                	mov    (%eax),%al
  800865:	0f be d8             	movsbl %al,%ebx
  800868:	85 db                	test   %ebx,%ebx
  80086a:	74 24                	je     800890 <vprintfmt+0x24b>
  80086c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800870:	78 b8                	js     80082a <vprintfmt+0x1e5>
  800872:	ff 4d e0             	decl   -0x20(%ebp)
  800875:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800879:	79 af                	jns    80082a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80087b:	eb 13                	jmp    800890 <vprintfmt+0x24b>
				putch(' ', putdat);
  80087d:	83 ec 08             	sub    $0x8,%esp
  800880:	ff 75 0c             	pushl  0xc(%ebp)
  800883:	6a 20                	push   $0x20
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	ff d0                	call   *%eax
  80088a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80088d:	ff 4d e4             	decl   -0x1c(%ebp)
  800890:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800894:	7f e7                	jg     80087d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800896:	e9 78 01 00 00       	jmp    800a13 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80089b:	83 ec 08             	sub    $0x8,%esp
  80089e:	ff 75 e8             	pushl  -0x18(%ebp)
  8008a1:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a4:	50                   	push   %eax
  8008a5:	e8 3c fd ff ff       	call   8005e6 <getint>
  8008aa:	83 c4 10             	add    $0x10,%esp
  8008ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b9:	85 d2                	test   %edx,%edx
  8008bb:	79 23                	jns    8008e0 <vprintfmt+0x29b>
				putch('-', putdat);
  8008bd:	83 ec 08             	sub    $0x8,%esp
  8008c0:	ff 75 0c             	pushl  0xc(%ebp)
  8008c3:	6a 2d                	push   $0x2d
  8008c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c8:	ff d0                	call   *%eax
  8008ca:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008d3:	f7 d8                	neg    %eax
  8008d5:	83 d2 00             	adc    $0x0,%edx
  8008d8:	f7 da                	neg    %edx
  8008da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008e0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008e7:	e9 bc 00 00 00       	jmp    8009a8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008ec:	83 ec 08             	sub    $0x8,%esp
  8008ef:	ff 75 e8             	pushl  -0x18(%ebp)
  8008f2:	8d 45 14             	lea    0x14(%ebp),%eax
  8008f5:	50                   	push   %eax
  8008f6:	e8 84 fc ff ff       	call   80057f <getuint>
  8008fb:	83 c4 10             	add    $0x10,%esp
  8008fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800901:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800904:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80090b:	e9 98 00 00 00       	jmp    8009a8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800910:	83 ec 08             	sub    $0x8,%esp
  800913:	ff 75 0c             	pushl  0xc(%ebp)
  800916:	6a 58                	push   $0x58
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	ff d0                	call   *%eax
  80091d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800920:	83 ec 08             	sub    $0x8,%esp
  800923:	ff 75 0c             	pushl  0xc(%ebp)
  800926:	6a 58                	push   $0x58
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	ff d0                	call   *%eax
  80092d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800930:	83 ec 08             	sub    $0x8,%esp
  800933:	ff 75 0c             	pushl  0xc(%ebp)
  800936:	6a 58                	push   $0x58
  800938:	8b 45 08             	mov    0x8(%ebp),%eax
  80093b:	ff d0                	call   *%eax
  80093d:	83 c4 10             	add    $0x10,%esp
			break;
  800940:	e9 ce 00 00 00       	jmp    800a13 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	ff 75 0c             	pushl  0xc(%ebp)
  80094b:	6a 30                	push   $0x30
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	ff d0                	call   *%eax
  800952:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800955:	83 ec 08             	sub    $0x8,%esp
  800958:	ff 75 0c             	pushl  0xc(%ebp)
  80095b:	6a 78                	push   $0x78
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	ff d0                	call   *%eax
  800962:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800965:	8b 45 14             	mov    0x14(%ebp),%eax
  800968:	83 c0 04             	add    $0x4,%eax
  80096b:	89 45 14             	mov    %eax,0x14(%ebp)
  80096e:	8b 45 14             	mov    0x14(%ebp),%eax
  800971:	83 e8 04             	sub    $0x4,%eax
  800974:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800976:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800979:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800980:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800987:	eb 1f                	jmp    8009a8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800989:	83 ec 08             	sub    $0x8,%esp
  80098c:	ff 75 e8             	pushl  -0x18(%ebp)
  80098f:	8d 45 14             	lea    0x14(%ebp),%eax
  800992:	50                   	push   %eax
  800993:	e8 e7 fb ff ff       	call   80057f <getuint>
  800998:	83 c4 10             	add    $0x10,%esp
  80099b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009a1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009a8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009af:	83 ec 04             	sub    $0x4,%esp
  8009b2:	52                   	push   %edx
  8009b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009b6:	50                   	push   %eax
  8009b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8009bd:	ff 75 0c             	pushl  0xc(%ebp)
  8009c0:	ff 75 08             	pushl  0x8(%ebp)
  8009c3:	e8 00 fb ff ff       	call   8004c8 <printnum>
  8009c8:	83 c4 20             	add    $0x20,%esp
			break;
  8009cb:	eb 46                	jmp    800a13 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	ff 75 0c             	pushl  0xc(%ebp)
  8009d3:	53                   	push   %ebx
  8009d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d7:	ff d0                	call   *%eax
  8009d9:	83 c4 10             	add    $0x10,%esp
			break;
  8009dc:	eb 35                	jmp    800a13 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009de:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  8009e5:	eb 2c                	jmp    800a13 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009e7:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  8009ee:	eb 23                	jmp    800a13 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 0c             	pushl  0xc(%ebp)
  8009f6:	6a 25                	push   $0x25
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	ff d0                	call   *%eax
  8009fd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a00:	ff 4d 10             	decl   0x10(%ebp)
  800a03:	eb 03                	jmp    800a08 <vprintfmt+0x3c3>
  800a05:	ff 4d 10             	decl   0x10(%ebp)
  800a08:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0b:	48                   	dec    %eax
  800a0c:	8a 00                	mov    (%eax),%al
  800a0e:	3c 25                	cmp    $0x25,%al
  800a10:	75 f3                	jne    800a05 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a12:	90                   	nop
		}
	}
  800a13:	e9 35 fc ff ff       	jmp    80064d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a18:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a19:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a1c:	5b                   	pop    %ebx
  800a1d:	5e                   	pop    %esi
  800a1e:	5d                   	pop    %ebp
  800a1f:	c3                   	ret    

00800a20 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a26:	8d 45 10             	lea    0x10(%ebp),%eax
  800a29:	83 c0 04             	add    $0x4,%eax
  800a2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800a32:	ff 75 f4             	pushl  -0xc(%ebp)
  800a35:	50                   	push   %eax
  800a36:	ff 75 0c             	pushl  0xc(%ebp)
  800a39:	ff 75 08             	pushl  0x8(%ebp)
  800a3c:	e8 04 fc ff ff       	call   800645 <vprintfmt>
  800a41:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a44:	90                   	nop
  800a45:	c9                   	leave  
  800a46:	c3                   	ret    

00800a47 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4d:	8b 40 08             	mov    0x8(%eax),%eax
  800a50:	8d 50 01             	lea    0x1(%eax),%edx
  800a53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a56:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5c:	8b 10                	mov    (%eax),%edx
  800a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a61:	8b 40 04             	mov    0x4(%eax),%eax
  800a64:	39 c2                	cmp    %eax,%edx
  800a66:	73 12                	jae    800a7a <sprintputch+0x33>
		*b->buf++ = ch;
  800a68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6b:	8b 00                	mov    (%eax),%eax
  800a6d:	8d 48 01             	lea    0x1(%eax),%ecx
  800a70:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a73:	89 0a                	mov    %ecx,(%edx)
  800a75:	8b 55 08             	mov    0x8(%ebp),%edx
  800a78:	88 10                	mov    %dl,(%eax)
}
  800a7a:	90                   	nop
  800a7b:	5d                   	pop    %ebp
  800a7c:	c3                   	ret    

00800a7d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a7d:	55                   	push   %ebp
  800a7e:	89 e5                	mov    %esp,%ebp
  800a80:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	01 d0                	add    %edx,%eax
  800a94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800aa2:	74 06                	je     800aaa <vsnprintf+0x2d>
  800aa4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aa8:	7f 07                	jg     800ab1 <vsnprintf+0x34>
		return -E_INVAL;
  800aaa:	b8 03 00 00 00       	mov    $0x3,%eax
  800aaf:	eb 20                	jmp    800ad1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ab1:	ff 75 14             	pushl  0x14(%ebp)
  800ab4:	ff 75 10             	pushl  0x10(%ebp)
  800ab7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aba:	50                   	push   %eax
  800abb:	68 47 0a 80 00       	push   $0x800a47
  800ac0:	e8 80 fb ff ff       	call   800645 <vprintfmt>
  800ac5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ac8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800acb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ad1:	c9                   	leave  
  800ad2:	c3                   	ret    

00800ad3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ad9:	8d 45 10             	lea    0x10(%ebp),%eax
  800adc:	83 c0 04             	add    $0x4,%eax
  800adf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ae2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	ff 75 0c             	pushl  0xc(%ebp)
  800aec:	ff 75 08             	pushl  0x8(%ebp)
  800aef:	e8 89 ff ff ff       	call   800a7d <vsnprintf>
  800af4:	83 c4 10             	add    $0x10,%esp
  800af7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800afd:	c9                   	leave  
  800afe:	c3                   	ret    

00800aff <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b0c:	eb 06                	jmp    800b14 <strlen+0x15>
		n++;
  800b0e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b11:	ff 45 08             	incl   0x8(%ebp)
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8a 00                	mov    (%eax),%al
  800b19:	84 c0                	test   %al,%al
  800b1b:	75 f1                	jne    800b0e <strlen+0xf>
		n++;
	return n;
  800b1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b20:	c9                   	leave  
  800b21:	c3                   	ret    

00800b22 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b2f:	eb 09                	jmp    800b3a <strnlen+0x18>
		n++;
  800b31:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b34:	ff 45 08             	incl   0x8(%ebp)
  800b37:	ff 4d 0c             	decl   0xc(%ebp)
  800b3a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b3e:	74 09                	je     800b49 <strnlen+0x27>
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	8a 00                	mov    (%eax),%al
  800b45:	84 c0                	test   %al,%al
  800b47:	75 e8                	jne    800b31 <strnlen+0xf>
		n++;
	return n;
  800b49:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b4c:	c9                   	leave  
  800b4d:	c3                   	ret    

00800b4e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b5a:	90                   	nop
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	8d 50 01             	lea    0x1(%eax),%edx
  800b61:	89 55 08             	mov    %edx,0x8(%ebp)
  800b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b67:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b6a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b6d:	8a 12                	mov    (%edx),%dl
  800b6f:	88 10                	mov    %dl,(%eax)
  800b71:	8a 00                	mov    (%eax),%al
  800b73:	84 c0                	test   %al,%al
  800b75:	75 e4                	jne    800b5b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b77:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b7a:	c9                   	leave  
  800b7b:	c3                   	ret    

00800b7c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b8f:	eb 1f                	jmp    800bb0 <strncpy+0x34>
		*dst++ = *src;
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8d 50 01             	lea    0x1(%eax),%edx
  800b97:	89 55 08             	mov    %edx,0x8(%ebp)
  800b9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9d:	8a 12                	mov    (%edx),%dl
  800b9f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	8a 00                	mov    (%eax),%al
  800ba6:	84 c0                	test   %al,%al
  800ba8:	74 03                	je     800bad <strncpy+0x31>
			src++;
  800baa:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bad:	ff 45 fc             	incl   -0x4(%ebp)
  800bb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bb3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bb6:	72 d9                	jb     800b91 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800bb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bbb:	c9                   	leave  
  800bbc:	c3                   	ret    

00800bbd <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bc9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bcd:	74 30                	je     800bff <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bcf:	eb 16                	jmp    800be7 <strlcpy+0x2a>
			*dst++ = *src++;
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	8d 50 01             	lea    0x1(%eax),%edx
  800bd7:	89 55 08             	mov    %edx,0x8(%ebp)
  800bda:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bdd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800be0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800be3:	8a 12                	mov    (%edx),%dl
  800be5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800be7:	ff 4d 10             	decl   0x10(%ebp)
  800bea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bee:	74 09                	je     800bf9 <strlcpy+0x3c>
  800bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf3:	8a 00                	mov    (%eax),%al
  800bf5:	84 c0                	test   %al,%al
  800bf7:	75 d8                	jne    800bd1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bff:	8b 55 08             	mov    0x8(%ebp),%edx
  800c02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c05:	29 c2                	sub    %eax,%edx
  800c07:	89 d0                	mov    %edx,%eax
}
  800c09:	c9                   	leave  
  800c0a:	c3                   	ret    

00800c0b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c0e:	eb 06                	jmp    800c16 <strcmp+0xb>
		p++, q++;
  800c10:	ff 45 08             	incl   0x8(%ebp)
  800c13:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	8a 00                	mov    (%eax),%al
  800c1b:	84 c0                	test   %al,%al
  800c1d:	74 0e                	je     800c2d <strcmp+0x22>
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	8a 10                	mov    (%eax),%dl
  800c24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c27:	8a 00                	mov    (%eax),%al
  800c29:	38 c2                	cmp    %al,%dl
  800c2b:	74 e3                	je     800c10 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	8a 00                	mov    (%eax),%al
  800c32:	0f b6 d0             	movzbl %al,%edx
  800c35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	0f b6 c0             	movzbl %al,%eax
  800c3d:	29 c2                	sub    %eax,%edx
  800c3f:	89 d0                	mov    %edx,%eax
}
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    

00800c43 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c46:	eb 09                	jmp    800c51 <strncmp+0xe>
		n--, p++, q++;
  800c48:	ff 4d 10             	decl   0x10(%ebp)
  800c4b:	ff 45 08             	incl   0x8(%ebp)
  800c4e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c55:	74 17                	je     800c6e <strncmp+0x2b>
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	84 c0                	test   %al,%al
  800c5e:	74 0e                	je     800c6e <strncmp+0x2b>
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8a 10                	mov    (%eax),%dl
  800c65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c68:	8a 00                	mov    (%eax),%al
  800c6a:	38 c2                	cmp    %al,%dl
  800c6c:	74 da                	je     800c48 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c72:	75 07                	jne    800c7b <strncmp+0x38>
		return 0;
  800c74:	b8 00 00 00 00       	mov    $0x0,%eax
  800c79:	eb 14                	jmp    800c8f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8a 00                	mov    (%eax),%al
  800c80:	0f b6 d0             	movzbl %al,%edx
  800c83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c86:	8a 00                	mov    (%eax),%al
  800c88:	0f b6 c0             	movzbl %al,%eax
  800c8b:	29 c2                	sub    %eax,%edx
  800c8d:	89 d0                	mov    %edx,%eax
}
  800c8f:	5d                   	pop    %ebp
  800c90:	c3                   	ret    

00800c91 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	83 ec 04             	sub    $0x4,%esp
  800c97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c9d:	eb 12                	jmp    800cb1 <strchr+0x20>
		if (*s == c)
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	8a 00                	mov    (%eax),%al
  800ca4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ca7:	75 05                	jne    800cae <strchr+0x1d>
			return (char *) s;
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	eb 11                	jmp    800cbf <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cae:	ff 45 08             	incl   0x8(%ebp)
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8a 00                	mov    (%eax),%al
  800cb6:	84 c0                	test   %al,%al
  800cb8:	75 e5                	jne    800c9f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cbf:	c9                   	leave  
  800cc0:	c3                   	ret    

00800cc1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	83 ec 04             	sub    $0x4,%esp
  800cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cca:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ccd:	eb 0d                	jmp    800cdc <strfind+0x1b>
		if (*s == c)
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cd7:	74 0e                	je     800ce7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cd9:	ff 45 08             	incl   0x8(%ebp)
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdf:	8a 00                	mov    (%eax),%al
  800ce1:	84 c0                	test   %al,%al
  800ce3:	75 ea                	jne    800ccf <strfind+0xe>
  800ce5:	eb 01                	jmp    800ce8 <strfind+0x27>
		if (*s == c)
			break;
  800ce7:	90                   	nop
	return (char *) s;
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ceb:	c9                   	leave  
  800cec:	c3                   	ret    

00800ced <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ced:	55                   	push   %ebp
  800cee:	89 e5                	mov    %esp,%ebp
  800cf0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cf9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cff:	eb 0e                	jmp    800d0f <memset+0x22>
		*p++ = c;
  800d01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d04:	8d 50 01             	lea    0x1(%eax),%edx
  800d07:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d0f:	ff 4d f8             	decl   -0x8(%ebp)
  800d12:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d16:	79 e9                	jns    800d01 <memset+0x14>
		*p++ = c;

	return v;
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d1b:	c9                   	leave  
  800d1c:	c3                   	ret    

00800d1d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d2f:	eb 16                	jmp    800d47 <memcpy+0x2a>
		*d++ = *s++;
  800d31:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d34:	8d 50 01             	lea    0x1(%eax),%edx
  800d37:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d3d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d40:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d43:	8a 12                	mov    (%edx),%dl
  800d45:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d47:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d4d:	89 55 10             	mov    %edx,0x10(%ebp)
  800d50:	85 c0                	test   %eax,%eax
  800d52:	75 dd                	jne    800d31 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d57:	c9                   	leave  
  800d58:	c3                   	ret    

00800d59 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d71:	73 50                	jae    800dc3 <memmove+0x6a>
  800d73:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d76:	8b 45 10             	mov    0x10(%ebp),%eax
  800d79:	01 d0                	add    %edx,%eax
  800d7b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d7e:	76 43                	jbe    800dc3 <memmove+0x6a>
		s += n;
  800d80:	8b 45 10             	mov    0x10(%ebp),%eax
  800d83:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d86:	8b 45 10             	mov    0x10(%ebp),%eax
  800d89:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d8c:	eb 10                	jmp    800d9e <memmove+0x45>
			*--d = *--s;
  800d8e:	ff 4d f8             	decl   -0x8(%ebp)
  800d91:	ff 4d fc             	decl   -0x4(%ebp)
  800d94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d97:	8a 10                	mov    (%eax),%dl
  800d99:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d9c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800da1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da4:	89 55 10             	mov    %edx,0x10(%ebp)
  800da7:	85 c0                	test   %eax,%eax
  800da9:	75 e3                	jne    800d8e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dab:	eb 23                	jmp    800dd0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800dad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db0:	8d 50 01             	lea    0x1(%eax),%edx
  800db3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800db6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800db9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dbc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dbf:	8a 12                	mov    (%edx),%dl
  800dc1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc9:	89 55 10             	mov    %edx,0x10(%ebp)
  800dcc:	85 c0                	test   %eax,%eax
  800dce:	75 dd                	jne    800dad <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd3:	c9                   	leave  
  800dd4:	c3                   	ret    

00800dd5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
  800dd8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800de1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800de7:	eb 2a                	jmp    800e13 <memcmp+0x3e>
		if (*s1 != *s2)
  800de9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dec:	8a 10                	mov    (%eax),%dl
  800dee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df1:	8a 00                	mov    (%eax),%al
  800df3:	38 c2                	cmp    %al,%dl
  800df5:	74 16                	je     800e0d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800df7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dfa:	8a 00                	mov    (%eax),%al
  800dfc:	0f b6 d0             	movzbl %al,%edx
  800dff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e02:	8a 00                	mov    (%eax),%al
  800e04:	0f b6 c0             	movzbl %al,%eax
  800e07:	29 c2                	sub    %eax,%edx
  800e09:	89 d0                	mov    %edx,%eax
  800e0b:	eb 18                	jmp    800e25 <memcmp+0x50>
		s1++, s2++;
  800e0d:	ff 45 fc             	incl   -0x4(%ebp)
  800e10:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e13:	8b 45 10             	mov    0x10(%ebp),%eax
  800e16:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e19:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1c:	85 c0                	test   %eax,%eax
  800e1e:	75 c9                	jne    800de9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e25:	c9                   	leave  
  800e26:	c3                   	ret    

00800e27 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e30:	8b 45 10             	mov    0x10(%ebp),%eax
  800e33:	01 d0                	add    %edx,%eax
  800e35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e38:	eb 15                	jmp    800e4f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	8a 00                	mov    (%eax),%al
  800e3f:	0f b6 d0             	movzbl %al,%edx
  800e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e45:	0f b6 c0             	movzbl %al,%eax
  800e48:	39 c2                	cmp    %eax,%edx
  800e4a:	74 0d                	je     800e59 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e4c:	ff 45 08             	incl   0x8(%ebp)
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e55:	72 e3                	jb     800e3a <memfind+0x13>
  800e57:	eb 01                	jmp    800e5a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e59:	90                   	nop
	return (void *) s;
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5d:	c9                   	leave  
  800e5e:	c3                   	ret    

00800e5f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e6c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e73:	eb 03                	jmp    800e78 <strtol+0x19>
		s++;
  800e75:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	3c 20                	cmp    $0x20,%al
  800e7f:	74 f4                	je     800e75 <strtol+0x16>
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	3c 09                	cmp    $0x9,%al
  800e88:	74 eb                	je     800e75 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	3c 2b                	cmp    $0x2b,%al
  800e91:	75 05                	jne    800e98 <strtol+0x39>
		s++;
  800e93:	ff 45 08             	incl   0x8(%ebp)
  800e96:	eb 13                	jmp    800eab <strtol+0x4c>
	else if (*s == '-')
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	8a 00                	mov    (%eax),%al
  800e9d:	3c 2d                	cmp    $0x2d,%al
  800e9f:	75 0a                	jne    800eab <strtol+0x4c>
		s++, neg = 1;
  800ea1:	ff 45 08             	incl   0x8(%ebp)
  800ea4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eaf:	74 06                	je     800eb7 <strtol+0x58>
  800eb1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800eb5:	75 20                	jne    800ed7 <strtol+0x78>
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	8a 00                	mov    (%eax),%al
  800ebc:	3c 30                	cmp    $0x30,%al
  800ebe:	75 17                	jne    800ed7 <strtol+0x78>
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	40                   	inc    %eax
  800ec4:	8a 00                	mov    (%eax),%al
  800ec6:	3c 78                	cmp    $0x78,%al
  800ec8:	75 0d                	jne    800ed7 <strtol+0x78>
		s += 2, base = 16;
  800eca:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ece:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ed5:	eb 28                	jmp    800eff <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ed7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800edb:	75 15                	jne    800ef2 <strtol+0x93>
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	8a 00                	mov    (%eax),%al
  800ee2:	3c 30                	cmp    $0x30,%al
  800ee4:	75 0c                	jne    800ef2 <strtol+0x93>
		s++, base = 8;
  800ee6:	ff 45 08             	incl   0x8(%ebp)
  800ee9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ef0:	eb 0d                	jmp    800eff <strtol+0xa0>
	else if (base == 0)
  800ef2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef6:	75 07                	jne    800eff <strtol+0xa0>
		base = 10;
  800ef8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	3c 2f                	cmp    $0x2f,%al
  800f06:	7e 19                	jle    800f21 <strtol+0xc2>
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	3c 39                	cmp    $0x39,%al
  800f0f:	7f 10                	jg     800f21 <strtol+0xc2>
			dig = *s - '0';
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	0f be c0             	movsbl %al,%eax
  800f19:	83 e8 30             	sub    $0x30,%eax
  800f1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f1f:	eb 42                	jmp    800f63 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	3c 60                	cmp    $0x60,%al
  800f28:	7e 19                	jle    800f43 <strtol+0xe4>
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	3c 7a                	cmp    $0x7a,%al
  800f31:	7f 10                	jg     800f43 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	8a 00                	mov    (%eax),%al
  800f38:	0f be c0             	movsbl %al,%eax
  800f3b:	83 e8 57             	sub    $0x57,%eax
  800f3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f41:	eb 20                	jmp    800f63 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	3c 40                	cmp    $0x40,%al
  800f4a:	7e 39                	jle    800f85 <strtol+0x126>
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	8a 00                	mov    (%eax),%al
  800f51:	3c 5a                	cmp    $0x5a,%al
  800f53:	7f 30                	jg     800f85 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	0f be c0             	movsbl %al,%eax
  800f5d:	83 e8 37             	sub    $0x37,%eax
  800f60:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f66:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f69:	7d 19                	jge    800f84 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f6b:	ff 45 08             	incl   0x8(%ebp)
  800f6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f71:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f75:	89 c2                	mov    %eax,%edx
  800f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f7a:	01 d0                	add    %edx,%eax
  800f7c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f7f:	e9 7b ff ff ff       	jmp    800eff <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f84:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f89:	74 08                	je     800f93 <strtol+0x134>
		*endptr = (char *) s;
  800f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f91:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f93:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f97:	74 07                	je     800fa0 <strtol+0x141>
  800f99:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9c:	f7 d8                	neg    %eax
  800f9e:	eb 03                	jmp    800fa3 <strtol+0x144>
  800fa0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fa3:	c9                   	leave  
  800fa4:	c3                   	ret    

00800fa5 <ltostr>:

void
ltostr(long value, char *str)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fb2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fb9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fbd:	79 13                	jns    800fd2 <ltostr+0x2d>
	{
		neg = 1;
  800fbf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fcc:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fcf:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fda:	99                   	cltd   
  800fdb:	f7 f9                	idiv   %ecx
  800fdd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fe0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe3:	8d 50 01             	lea    0x1(%eax),%edx
  800fe6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe9:	89 c2                	mov    %eax,%edx
  800feb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fee:	01 d0                	add    %edx,%eax
  800ff0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ff3:	83 c2 30             	add    $0x30,%edx
  800ff6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ff8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ffb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801000:	f7 e9                	imul   %ecx
  801002:	c1 fa 02             	sar    $0x2,%edx
  801005:	89 c8                	mov    %ecx,%eax
  801007:	c1 f8 1f             	sar    $0x1f,%eax
  80100a:	29 c2                	sub    %eax,%edx
  80100c:	89 d0                	mov    %edx,%eax
  80100e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801011:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801015:	75 bb                	jne    800fd2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801017:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80101e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801021:	48                   	dec    %eax
  801022:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801025:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801029:	74 3d                	je     801068 <ltostr+0xc3>
		start = 1 ;
  80102b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801032:	eb 34                	jmp    801068 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801034:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801037:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103a:	01 d0                	add    %edx,%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801041:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801044:	8b 45 0c             	mov    0xc(%ebp),%eax
  801047:	01 c2                	add    %eax,%edx
  801049:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	01 c8                	add    %ecx,%eax
  801051:	8a 00                	mov    (%eax),%al
  801053:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801055:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801058:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105b:	01 c2                	add    %eax,%edx
  80105d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801060:	88 02                	mov    %al,(%edx)
		start++ ;
  801062:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801065:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80106e:	7c c4                	jl     801034 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801070:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801073:	8b 45 0c             	mov    0xc(%ebp),%eax
  801076:	01 d0                	add    %edx,%eax
  801078:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80107b:	90                   	nop
  80107c:	c9                   	leave  
  80107d:	c3                   	ret    

0080107e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801084:	ff 75 08             	pushl  0x8(%ebp)
  801087:	e8 73 fa ff ff       	call   800aff <strlen>
  80108c:	83 c4 04             	add    $0x4,%esp
  80108f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801092:	ff 75 0c             	pushl  0xc(%ebp)
  801095:	e8 65 fa ff ff       	call   800aff <strlen>
  80109a:	83 c4 04             	add    $0x4,%esp
  80109d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010ae:	eb 17                	jmp    8010c7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b6:	01 c2                	add    %eax,%edx
  8010b8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	01 c8                	add    %ecx,%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010c4:	ff 45 fc             	incl   -0x4(%ebp)
  8010c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010cd:	7c e1                	jl     8010b0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010d6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010dd:	eb 1f                	jmp    8010fe <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e2:	8d 50 01             	lea    0x1(%eax),%edx
  8010e5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010e8:	89 c2                	mov    %eax,%edx
  8010ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ed:	01 c2                	add    %eax,%edx
  8010ef:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f5:	01 c8                	add    %ecx,%eax
  8010f7:	8a 00                	mov    (%eax),%al
  8010f9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010fb:	ff 45 f8             	incl   -0x8(%ebp)
  8010fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801101:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801104:	7c d9                	jl     8010df <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801106:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801109:	8b 45 10             	mov    0x10(%ebp),%eax
  80110c:	01 d0                	add    %edx,%eax
  80110e:	c6 00 00             	movb   $0x0,(%eax)
}
  801111:	90                   	nop
  801112:	c9                   	leave  
  801113:	c3                   	ret    

00801114 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801117:	8b 45 14             	mov    0x14(%ebp),%eax
  80111a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801120:	8b 45 14             	mov    0x14(%ebp),%eax
  801123:	8b 00                	mov    (%eax),%eax
  801125:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80112c:	8b 45 10             	mov    0x10(%ebp),%eax
  80112f:	01 d0                	add    %edx,%eax
  801131:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801137:	eb 0c                	jmp    801145 <strsplit+0x31>
			*string++ = 0;
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8d 50 01             	lea    0x1(%eax),%edx
  80113f:	89 55 08             	mov    %edx,0x8(%ebp)
  801142:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	84 c0                	test   %al,%al
  80114c:	74 18                	je     801166 <strsplit+0x52>
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	8a 00                	mov    (%eax),%al
  801153:	0f be c0             	movsbl %al,%eax
  801156:	50                   	push   %eax
  801157:	ff 75 0c             	pushl  0xc(%ebp)
  80115a:	e8 32 fb ff ff       	call   800c91 <strchr>
  80115f:	83 c4 08             	add    $0x8,%esp
  801162:	85 c0                	test   %eax,%eax
  801164:	75 d3                	jne    801139 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8a 00                	mov    (%eax),%al
  80116b:	84 c0                	test   %al,%al
  80116d:	74 5a                	je     8011c9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80116f:	8b 45 14             	mov    0x14(%ebp),%eax
  801172:	8b 00                	mov    (%eax),%eax
  801174:	83 f8 0f             	cmp    $0xf,%eax
  801177:	75 07                	jne    801180 <strsplit+0x6c>
		{
			return 0;
  801179:	b8 00 00 00 00       	mov    $0x0,%eax
  80117e:	eb 66                	jmp    8011e6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801180:	8b 45 14             	mov    0x14(%ebp),%eax
  801183:	8b 00                	mov    (%eax),%eax
  801185:	8d 48 01             	lea    0x1(%eax),%ecx
  801188:	8b 55 14             	mov    0x14(%ebp),%edx
  80118b:	89 0a                	mov    %ecx,(%edx)
  80118d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801194:	8b 45 10             	mov    0x10(%ebp),%eax
  801197:	01 c2                	add    %eax,%edx
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
  80119c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119e:	eb 03                	jmp    8011a3 <strsplit+0x8f>
			string++;
  8011a0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	8a 00                	mov    (%eax),%al
  8011a8:	84 c0                	test   %al,%al
  8011aa:	74 8b                	je     801137 <strsplit+0x23>
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	0f be c0             	movsbl %al,%eax
  8011b4:	50                   	push   %eax
  8011b5:	ff 75 0c             	pushl  0xc(%ebp)
  8011b8:	e8 d4 fa ff ff       	call   800c91 <strchr>
  8011bd:	83 c4 08             	add    $0x8,%esp
  8011c0:	85 c0                	test   %eax,%eax
  8011c2:	74 dc                	je     8011a0 <strsplit+0x8c>
			string++;
	}
  8011c4:	e9 6e ff ff ff       	jmp    801137 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011c9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cd:	8b 00                	mov    (%eax),%eax
  8011cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d9:	01 d0                	add    %edx,%eax
  8011db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011e1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011e6:	c9                   	leave  
  8011e7:	c3                   	ret    

008011e8 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
  8011eb:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8011ee:	83 ec 04             	sub    $0x4,%esp
  8011f1:	68 68 21 80 00       	push   $0x802168
  8011f6:	68 3f 01 00 00       	push   $0x13f
  8011fb:	68 8a 21 80 00       	push   $0x80218a
  801200:	e8 a9 ef ff ff       	call   8001ae <_panic>

00801205 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	57                   	push   %edi
  801209:	56                   	push   %esi
  80120a:	53                   	push   %ebx
  80120b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	8b 55 0c             	mov    0xc(%ebp),%edx
  801214:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801217:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80121a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80121d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801220:	cd 30                	int    $0x30
  801222:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801225:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801228:	83 c4 10             	add    $0x10,%esp
  80122b:	5b                   	pop    %ebx
  80122c:	5e                   	pop    %esi
  80122d:	5f                   	pop    %edi
  80122e:	5d                   	pop    %ebp
  80122f:	c3                   	ret    

00801230 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	83 ec 04             	sub    $0x4,%esp
  801236:	8b 45 10             	mov    0x10(%ebp),%eax
  801239:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  80123c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	6a 00                	push   $0x0
  801245:	6a 00                	push   $0x0
  801247:	52                   	push   %edx
  801248:	ff 75 0c             	pushl  0xc(%ebp)
  80124b:	50                   	push   %eax
  80124c:	6a 00                	push   $0x0
  80124e:	e8 b2 ff ff ff       	call   801205 <syscall>
  801253:	83 c4 18             	add    $0x18,%esp
}
  801256:	90                   	nop
  801257:	c9                   	leave  
  801258:	c3                   	ret    

00801259 <sys_cgetc>:

int sys_cgetc(void) {
  801259:	55                   	push   %ebp
  80125a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80125c:	6a 00                	push   $0x0
  80125e:	6a 00                	push   $0x0
  801260:	6a 00                	push   $0x0
  801262:	6a 00                	push   $0x0
  801264:	6a 00                	push   $0x0
  801266:	6a 02                	push   $0x2
  801268:	e8 98 ff ff ff       	call   801205 <syscall>
  80126d:	83 c4 18             	add    $0x18,%esp
}
  801270:	c9                   	leave  
  801271:	c3                   	ret    

00801272 <sys_lock_cons>:

void sys_lock_cons(void) {
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801275:	6a 00                	push   $0x0
  801277:	6a 00                	push   $0x0
  801279:	6a 00                	push   $0x0
  80127b:	6a 00                	push   $0x0
  80127d:	6a 00                	push   $0x0
  80127f:	6a 03                	push   $0x3
  801281:	e8 7f ff ff ff       	call   801205 <syscall>
  801286:	83 c4 18             	add    $0x18,%esp
}
  801289:	90                   	nop
  80128a:	c9                   	leave  
  80128b:	c3                   	ret    

0080128c <sys_unlock_cons>:
void sys_unlock_cons(void) {
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80128f:	6a 00                	push   $0x0
  801291:	6a 00                	push   $0x0
  801293:	6a 00                	push   $0x0
  801295:	6a 00                	push   $0x0
  801297:	6a 00                	push   $0x0
  801299:	6a 04                	push   $0x4
  80129b:	e8 65 ff ff ff       	call   801205 <syscall>
  8012a0:	83 c4 18             	add    $0x18,%esp
}
  8012a3:	90                   	nop
  8012a4:	c9                   	leave  
  8012a5:	c3                   	ret    

008012a6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  8012a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	6a 00                	push   $0x0
  8012b1:	6a 00                	push   $0x0
  8012b3:	6a 00                	push   $0x0
  8012b5:	52                   	push   %edx
  8012b6:	50                   	push   %eax
  8012b7:	6a 08                	push   $0x8
  8012b9:	e8 47 ff ff ff       	call   801205 <syscall>
  8012be:	83 c4 18             	add    $0x18,%esp
}
  8012c1:	c9                   	leave  
  8012c2:	c3                   	ret    

008012c3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
  8012c6:	56                   	push   %esi
  8012c7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  8012c8:	8b 75 18             	mov    0x18(%ebp),%esi
  8012cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	56                   	push   %esi
  8012d8:	53                   	push   %ebx
  8012d9:	51                   	push   %ecx
  8012da:	52                   	push   %edx
  8012db:	50                   	push   %eax
  8012dc:	6a 09                	push   $0x9
  8012de:	e8 22 ff ff ff       	call   801205 <syscall>
  8012e3:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  8012e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e9:	5b                   	pop    %ebx
  8012ea:	5e                   	pop    %esi
  8012eb:	5d                   	pop    %ebp
  8012ec:	c3                   	ret    

008012ed <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	6a 00                	push   $0x0
  8012f8:	6a 00                	push   $0x0
  8012fa:	6a 00                	push   $0x0
  8012fc:	52                   	push   %edx
  8012fd:	50                   	push   %eax
  8012fe:	6a 0a                	push   $0xa
  801300:	e8 00 ff ff ff       	call   801205 <syscall>
  801305:	83 c4 18             	add    $0x18,%esp
}
  801308:	c9                   	leave  
  801309:	c3                   	ret    

0080130a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  80130a:	55                   	push   %ebp
  80130b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  80130d:	6a 00                	push   $0x0
  80130f:	6a 00                	push   $0x0
  801311:	6a 00                	push   $0x0
  801313:	ff 75 0c             	pushl  0xc(%ebp)
  801316:	ff 75 08             	pushl  0x8(%ebp)
  801319:	6a 0b                	push   $0xb
  80131b:	e8 e5 fe ff ff       	call   801205 <syscall>
  801320:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801323:	c9                   	leave  
  801324:	c3                   	ret    

00801325 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801328:	6a 00                	push   $0x0
  80132a:	6a 00                	push   $0x0
  80132c:	6a 00                	push   $0x0
  80132e:	6a 00                	push   $0x0
  801330:	6a 00                	push   $0x0
  801332:	6a 0c                	push   $0xc
  801334:	e8 cc fe ff ff       	call   801205 <syscall>
  801339:	83 c4 18             	add    $0x18,%esp
}
  80133c:	c9                   	leave  
  80133d:	c3                   	ret    

0080133e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801341:	6a 00                	push   $0x0
  801343:	6a 00                	push   $0x0
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	6a 0d                	push   $0xd
  80134d:	e8 b3 fe ff ff       	call   801205 <syscall>
  801352:	83 c4 18             	add    $0x18,%esp
}
  801355:	c9                   	leave  
  801356:	c3                   	ret    

00801357 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80135a:	6a 00                	push   $0x0
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	6a 00                	push   $0x0
  801364:	6a 0e                	push   $0xe
  801366:	e8 9a fe ff ff       	call   801205 <syscall>
  80136b:	83 c4 18             	add    $0x18,%esp
}
  80136e:	c9                   	leave  
  80136f:	c3                   	ret    

00801370 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801373:	6a 00                	push   $0x0
  801375:	6a 00                	push   $0x0
  801377:	6a 00                	push   $0x0
  801379:	6a 00                	push   $0x0
  80137b:	6a 00                	push   $0x0
  80137d:	6a 0f                	push   $0xf
  80137f:	e8 81 fe ff ff       	call   801205 <syscall>
  801384:	83 c4 18             	add    $0x18,%esp
}
  801387:	c9                   	leave  
  801388:	c3                   	ret    

00801389 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	6a 00                	push   $0x0
  801392:	6a 00                	push   $0x0
  801394:	ff 75 08             	pushl  0x8(%ebp)
  801397:	6a 10                	push   $0x10
  801399:	e8 67 fe ff ff       	call   801205 <syscall>
  80139e:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  8013a1:	c9                   	leave  
  8013a2:	c3                   	ret    

008013a3 <sys_scarce_memory>:

void sys_scarce_memory() {
  8013a3:	55                   	push   %ebp
  8013a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 11                	push   $0x11
  8013b2:	e8 4e fe ff ff       	call   801205 <syscall>
  8013b7:	83 c4 18             	add    $0x18,%esp
}
  8013ba:	90                   	nop
  8013bb:	c9                   	leave  
  8013bc:	c3                   	ret    

008013bd <sys_cputc>:

void sys_cputc(const char c) {
  8013bd:	55                   	push   %ebp
  8013be:	89 e5                	mov    %esp,%ebp
  8013c0:	83 ec 04             	sub    $0x4,%esp
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013c9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 00                	push   $0x0
  8013d1:	6a 00                	push   $0x0
  8013d3:	6a 00                	push   $0x0
  8013d5:	50                   	push   %eax
  8013d6:	6a 01                	push   $0x1
  8013d8:	e8 28 fe ff ff       	call   801205 <syscall>
  8013dd:	83 c4 18             	add    $0x18,%esp
}
  8013e0:	90                   	nop
  8013e1:	c9                   	leave  
  8013e2:	c3                   	ret    

008013e3 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 00                	push   $0x0
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 14                	push   $0x14
  8013f2:	e8 0e fe ff ff       	call   801205 <syscall>
  8013f7:	83 c4 18             	add    $0x18,%esp
}
  8013fa:	90                   	nop
  8013fb:	c9                   	leave  
  8013fc:	c3                   	ret    

008013fd <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	83 ec 04             	sub    $0x4,%esp
  801403:	8b 45 10             	mov    0x10(%ebp),%eax
  801406:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801409:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80140c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801410:	8b 45 08             	mov    0x8(%ebp),%eax
  801413:	6a 00                	push   $0x0
  801415:	51                   	push   %ecx
  801416:	52                   	push   %edx
  801417:	ff 75 0c             	pushl  0xc(%ebp)
  80141a:	50                   	push   %eax
  80141b:	6a 15                	push   $0x15
  80141d:	e8 e3 fd ff ff       	call   801205 <syscall>
  801422:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801425:	c9                   	leave  
  801426:	c3                   	ret    

00801427 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  80142a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	52                   	push   %edx
  801437:	50                   	push   %eax
  801438:	6a 16                	push   $0x16
  80143a:	e8 c6 fd ff ff       	call   801205 <syscall>
  80143f:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801442:	c9                   	leave  
  801443:	c3                   	ret    

00801444 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801447:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80144a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	51                   	push   %ecx
  801455:	52                   	push   %edx
  801456:	50                   	push   %eax
  801457:	6a 17                	push   $0x17
  801459:	e8 a7 fd ff ff       	call   801205 <syscall>
  80145e:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801466:	8b 55 0c             	mov    0xc(%ebp),%edx
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	6a 00                	push   $0x0
  801472:	52                   	push   %edx
  801473:	50                   	push   %eax
  801474:	6a 18                	push   $0x18
  801476:	e8 8a fd ff ff       	call   801205 <syscall>
  80147b:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801483:	8b 45 08             	mov    0x8(%ebp),%eax
  801486:	6a 00                	push   $0x0
  801488:	ff 75 14             	pushl  0x14(%ebp)
  80148b:	ff 75 10             	pushl  0x10(%ebp)
  80148e:	ff 75 0c             	pushl  0xc(%ebp)
  801491:	50                   	push   %eax
  801492:	6a 19                	push   $0x19
  801494:	e8 6c fd ff ff       	call   801205 <syscall>
  801499:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  80149c:	c9                   	leave  
  80149d:	c3                   	ret    

0080149e <sys_run_env>:

void sys_run_env(int32 envId) {
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 00                	push   $0x0
  8014ac:	50                   	push   %eax
  8014ad:	6a 1a                	push   $0x1a
  8014af:	e8 51 fd ff ff       	call   801205 <syscall>
  8014b4:	83 c4 18             	add    $0x18,%esp
}
  8014b7:	90                   	nop
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	50                   	push   %eax
  8014c9:	6a 1b                	push   $0x1b
  8014cb:	e8 35 fd ff ff       	call   801205 <syscall>
  8014d0:	83 c4 18             	add    $0x18,%esp
}
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <sys_getenvid>:

int32 sys_getenvid(void) {
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 05                	push   $0x5
  8014e4:	e8 1c fd ff ff       	call   801205 <syscall>
  8014e9:	83 c4 18             	add    $0x18,%esp
}
  8014ec:	c9                   	leave  
  8014ed:	c3                   	ret    

008014ee <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 06                	push   $0x6
  8014fd:	e8 03 fd ff ff       	call   801205 <syscall>
  801502:	83 c4 18             	add    $0x18,%esp
}
  801505:	c9                   	leave  
  801506:	c3                   	ret    

00801507 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 07                	push   $0x7
  801516:	e8 ea fc ff ff       	call   801205 <syscall>
  80151b:	83 c4 18             	add    $0x18,%esp
}
  80151e:	c9                   	leave  
  80151f:	c3                   	ret    

00801520 <sys_exit_env>:

void sys_exit_env(void) {
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 1c                	push   $0x1c
  80152f:	e8 d1 fc ff ff       	call   801205 <syscall>
  801534:	83 c4 18             	add    $0x18,%esp
}
  801537:	90                   	nop
  801538:	c9                   	leave  
  801539:	c3                   	ret    

0080153a <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801540:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801543:	8d 50 04             	lea    0x4(%eax),%edx
  801546:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	52                   	push   %edx
  801550:	50                   	push   %eax
  801551:	6a 1d                	push   $0x1d
  801553:	e8 ad fc ff ff       	call   801205 <syscall>
  801558:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  80155b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80155e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801561:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801564:	89 01                	mov    %eax,(%ecx)
  801566:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801569:	8b 45 08             	mov    0x8(%ebp),%eax
  80156c:	c9                   	leave  
  80156d:	c2 04 00             	ret    $0x4

00801570 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	ff 75 10             	pushl  0x10(%ebp)
  80157a:	ff 75 0c             	pushl  0xc(%ebp)
  80157d:	ff 75 08             	pushl  0x8(%ebp)
  801580:	6a 13                	push   $0x13
  801582:	e8 7e fc ff ff       	call   801205 <syscall>
  801587:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  80158a:	90                   	nop
}
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <sys_rcr2>:
uint32 sys_rcr2() {
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 1e                	push   $0x1e
  80159c:	e8 64 fc ff ff       	call   801205 <syscall>
  8015a1:	83 c4 18             	add    $0x18,%esp
}
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	83 ec 04             	sub    $0x4,%esp
  8015ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8015af:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015b2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	50                   	push   %eax
  8015bf:	6a 1f                	push   $0x1f
  8015c1:	e8 3f fc ff ff       	call   801205 <syscall>
  8015c6:	83 c4 18             	add    $0x18,%esp
	return;
  8015c9:	90                   	nop
}
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    

008015cc <rsttst>:
void rsttst() {
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 21                	push   $0x21
  8015db:	e8 25 fc ff ff       	call   801205 <syscall>
  8015e0:	83 c4 18             	add    $0x18,%esp
	return;
  8015e3:	90                   	nop
}
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
  8015e9:	83 ec 04             	sub    $0x4,%esp
  8015ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015f2:	8b 55 18             	mov    0x18(%ebp),%edx
  8015f5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015f9:	52                   	push   %edx
  8015fa:	50                   	push   %eax
  8015fb:	ff 75 10             	pushl  0x10(%ebp)
  8015fe:	ff 75 0c             	pushl  0xc(%ebp)
  801601:	ff 75 08             	pushl  0x8(%ebp)
  801604:	6a 20                	push   $0x20
  801606:	e8 fa fb ff ff       	call   801205 <syscall>
  80160b:	83 c4 18             	add    $0x18,%esp
	return;
  80160e:	90                   	nop
}
  80160f:	c9                   	leave  
  801610:	c3                   	ret    

00801611 <chktst>:
void chktst(uint32 n) {
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	ff 75 08             	pushl  0x8(%ebp)
  80161f:	6a 22                	push   $0x22
  801621:	e8 df fb ff ff       	call   801205 <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
	return;
  801629:	90                   	nop
}
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <inctst>:

void inctst() {
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 23                	push   $0x23
  80163b:	e8 c5 fb ff ff       	call   801205 <syscall>
  801640:	83 c4 18             	add    $0x18,%esp
	return;
  801643:	90                   	nop
}
  801644:	c9                   	leave  
  801645:	c3                   	ret    

00801646 <gettst>:
uint32 gettst() {
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 24                	push   $0x24
  801655:	e8 ab fb ff ff       	call   801205 <syscall>
  80165a:	83 c4 18             	add    $0x18,%esp
}
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 25                	push   $0x25
  801671:	e8 8f fb ff ff       	call   801205 <syscall>
  801676:	83 c4 18             	add    $0x18,%esp
  801679:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80167c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801680:	75 07                	jne    801689 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801682:	b8 01 00 00 00       	mov    $0x1,%eax
  801687:	eb 05                	jmp    80168e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801689:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 25                	push   $0x25
  8016a2:	e8 5e fb ff ff       	call   801205 <syscall>
  8016a7:	83 c4 18             	add    $0x18,%esp
  8016aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016ad:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016b1:	75 07                	jne    8016ba <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8016b8:	eb 05                	jmp    8016bf <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 25                	push   $0x25
  8016d3:	e8 2d fb ff ff       	call   801205 <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
  8016db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016de:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016e2:	75 07                	jne    8016eb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8016e9:	eb 05                	jmp    8016f0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
  8016f5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 25                	push   $0x25
  801704:	e8 fc fa ff ff       	call   801205 <syscall>
  801709:	83 c4 18             	add    $0x18,%esp
  80170c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80170f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801713:	75 07                	jne    80171c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801715:	b8 01 00 00 00       	mov    $0x1,%eax
  80171a:	eb 05                	jmp    801721 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80171c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801721:	c9                   	leave  
  801722:	c3                   	ret    

00801723 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	ff 75 08             	pushl  0x8(%ebp)
  801731:	6a 26                	push   $0x26
  801733:	e8 cd fa ff ff       	call   801205 <syscall>
  801738:	83 c4 18             	add    $0x18,%esp
	return;
  80173b:	90                   	nop
}
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801742:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801745:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801748:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	6a 00                	push   $0x0
  801750:	53                   	push   %ebx
  801751:	51                   	push   %ecx
  801752:	52                   	push   %edx
  801753:	50                   	push   %eax
  801754:	6a 27                	push   $0x27
  801756:	e8 aa fa ff ff       	call   801205 <syscall>
  80175b:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  80175e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801761:	c9                   	leave  
  801762:	c3                   	ret    

00801763 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801766:	8b 55 0c             	mov    0xc(%ebp),%edx
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	52                   	push   %edx
  801773:	50                   	push   %eax
  801774:	6a 28                	push   $0x28
  801776:	e8 8a fa ff ff       	call   801205 <syscall>
  80177b:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801783:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801786:	8b 55 0c             	mov    0xc(%ebp),%edx
  801789:	8b 45 08             	mov    0x8(%ebp),%eax
  80178c:	6a 00                	push   $0x0
  80178e:	51                   	push   %ecx
  80178f:	ff 75 10             	pushl  0x10(%ebp)
  801792:	52                   	push   %edx
  801793:	50                   	push   %eax
  801794:	6a 29                	push   $0x29
  801796:	e8 6a fa ff ff       	call   801205 <syscall>
  80179b:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  80179e:	c9                   	leave  
  80179f:	c3                   	ret    

008017a0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	ff 75 10             	pushl  0x10(%ebp)
  8017aa:	ff 75 0c             	pushl  0xc(%ebp)
  8017ad:	ff 75 08             	pushl  0x8(%ebp)
  8017b0:	6a 12                	push   $0x12
  8017b2:	e8 4e fa ff ff       	call   801205 <syscall>
  8017b7:	83 c4 18             	add    $0x18,%esp
	return;
  8017ba:	90                   	nop
}
  8017bb:	c9                   	leave  
  8017bc:	c3                   	ret    

008017bd <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  8017c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	52                   	push   %edx
  8017cd:	50                   	push   %eax
  8017ce:	6a 2a                	push   $0x2a
  8017d0:	e8 30 fa ff ff       	call   801205 <syscall>
  8017d5:	83 c4 18             	add    $0x18,%esp
	return;
  8017d8:	90                   	nop
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	50                   	push   %eax
  8017ea:	6a 2b                	push   $0x2b
  8017ec:	e8 14 fa ff ff       	call   801205 <syscall>
  8017f1:	83 c4 18             	add    $0x18,%esp
}
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	ff 75 0c             	pushl  0xc(%ebp)
  801802:	ff 75 08             	pushl  0x8(%ebp)
  801805:	6a 2c                	push   $0x2c
  801807:	e8 f9 f9 ff ff       	call   801205 <syscall>
  80180c:	83 c4 18             	add    $0x18,%esp
	return;
  80180f:	90                   	nop
}
  801810:	c9                   	leave  
  801811:	c3                   	ret    

00801812 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	ff 75 0c             	pushl  0xc(%ebp)
  80181e:	ff 75 08             	pushl  0x8(%ebp)
  801821:	6a 2d                	push   $0x2d
  801823:	e8 dd f9 ff ff       	call   801205 <syscall>
  801828:	83 c4 18             	add    $0x18,%esp
	return;
  80182b:	90                   	nop
}
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801831:	8b 45 08             	mov    0x8(%ebp),%eax
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	50                   	push   %eax
  80183d:	6a 2f                	push   $0x2f
  80183f:	e8 c1 f9 ff ff       	call   801205 <syscall>
  801844:	83 c4 18             	add    $0x18,%esp
	return;
  801847:	90                   	nop
}
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  80184d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	52                   	push   %edx
  80185a:	50                   	push   %eax
  80185b:	6a 30                	push   $0x30
  80185d:	e8 a3 f9 ff ff       	call   801205 <syscall>
  801862:	83 c4 18             	add    $0x18,%esp
	return;
  801865:	90                   	nop
}
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  80186b:	8b 45 08             	mov    0x8(%ebp),%eax
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	50                   	push   %eax
  801877:	6a 31                	push   $0x31
  801879:	e8 87 f9 ff ff       	call   801205 <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
	return;
  801881:	90                   	nop
}
  801882:	c9                   	leave  
  801883:	c3                   	ret    

00801884 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801887:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	52                   	push   %edx
  801894:	50                   	push   %eax
  801895:	6a 2e                	push   $0x2e
  801897:	e8 69 f9 ff ff       	call   801205 <syscall>
  80189c:	83 c4 18             	add    $0x18,%esp
    return;
  80189f:	90                   	nop
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    
  8018a2:	66 90                	xchg   %ax,%ax

008018a4 <__udivdi3>:
  8018a4:	55                   	push   %ebp
  8018a5:	57                   	push   %edi
  8018a6:	56                   	push   %esi
  8018a7:	53                   	push   %ebx
  8018a8:	83 ec 1c             	sub    $0x1c,%esp
  8018ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8018af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8018b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018bb:	89 ca                	mov    %ecx,%edx
  8018bd:	89 f8                	mov    %edi,%eax
  8018bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8018c3:	85 f6                	test   %esi,%esi
  8018c5:	75 2d                	jne    8018f4 <__udivdi3+0x50>
  8018c7:	39 cf                	cmp    %ecx,%edi
  8018c9:	77 65                	ja     801930 <__udivdi3+0x8c>
  8018cb:	89 fd                	mov    %edi,%ebp
  8018cd:	85 ff                	test   %edi,%edi
  8018cf:	75 0b                	jne    8018dc <__udivdi3+0x38>
  8018d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8018d6:	31 d2                	xor    %edx,%edx
  8018d8:	f7 f7                	div    %edi
  8018da:	89 c5                	mov    %eax,%ebp
  8018dc:	31 d2                	xor    %edx,%edx
  8018de:	89 c8                	mov    %ecx,%eax
  8018e0:	f7 f5                	div    %ebp
  8018e2:	89 c1                	mov    %eax,%ecx
  8018e4:	89 d8                	mov    %ebx,%eax
  8018e6:	f7 f5                	div    %ebp
  8018e8:	89 cf                	mov    %ecx,%edi
  8018ea:	89 fa                	mov    %edi,%edx
  8018ec:	83 c4 1c             	add    $0x1c,%esp
  8018ef:	5b                   	pop    %ebx
  8018f0:	5e                   	pop    %esi
  8018f1:	5f                   	pop    %edi
  8018f2:	5d                   	pop    %ebp
  8018f3:	c3                   	ret    
  8018f4:	39 ce                	cmp    %ecx,%esi
  8018f6:	77 28                	ja     801920 <__udivdi3+0x7c>
  8018f8:	0f bd fe             	bsr    %esi,%edi
  8018fb:	83 f7 1f             	xor    $0x1f,%edi
  8018fe:	75 40                	jne    801940 <__udivdi3+0x9c>
  801900:	39 ce                	cmp    %ecx,%esi
  801902:	72 0a                	jb     80190e <__udivdi3+0x6a>
  801904:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801908:	0f 87 9e 00 00 00    	ja     8019ac <__udivdi3+0x108>
  80190e:	b8 01 00 00 00       	mov    $0x1,%eax
  801913:	89 fa                	mov    %edi,%edx
  801915:	83 c4 1c             	add    $0x1c,%esp
  801918:	5b                   	pop    %ebx
  801919:	5e                   	pop    %esi
  80191a:	5f                   	pop    %edi
  80191b:	5d                   	pop    %ebp
  80191c:	c3                   	ret    
  80191d:	8d 76 00             	lea    0x0(%esi),%esi
  801920:	31 ff                	xor    %edi,%edi
  801922:	31 c0                	xor    %eax,%eax
  801924:	89 fa                	mov    %edi,%edx
  801926:	83 c4 1c             	add    $0x1c,%esp
  801929:	5b                   	pop    %ebx
  80192a:	5e                   	pop    %esi
  80192b:	5f                   	pop    %edi
  80192c:	5d                   	pop    %ebp
  80192d:	c3                   	ret    
  80192e:	66 90                	xchg   %ax,%ax
  801930:	89 d8                	mov    %ebx,%eax
  801932:	f7 f7                	div    %edi
  801934:	31 ff                	xor    %edi,%edi
  801936:	89 fa                	mov    %edi,%edx
  801938:	83 c4 1c             	add    $0x1c,%esp
  80193b:	5b                   	pop    %ebx
  80193c:	5e                   	pop    %esi
  80193d:	5f                   	pop    %edi
  80193e:	5d                   	pop    %ebp
  80193f:	c3                   	ret    
  801940:	bd 20 00 00 00       	mov    $0x20,%ebp
  801945:	89 eb                	mov    %ebp,%ebx
  801947:	29 fb                	sub    %edi,%ebx
  801949:	89 f9                	mov    %edi,%ecx
  80194b:	d3 e6                	shl    %cl,%esi
  80194d:	89 c5                	mov    %eax,%ebp
  80194f:	88 d9                	mov    %bl,%cl
  801951:	d3 ed                	shr    %cl,%ebp
  801953:	89 e9                	mov    %ebp,%ecx
  801955:	09 f1                	or     %esi,%ecx
  801957:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80195b:	89 f9                	mov    %edi,%ecx
  80195d:	d3 e0                	shl    %cl,%eax
  80195f:	89 c5                	mov    %eax,%ebp
  801961:	89 d6                	mov    %edx,%esi
  801963:	88 d9                	mov    %bl,%cl
  801965:	d3 ee                	shr    %cl,%esi
  801967:	89 f9                	mov    %edi,%ecx
  801969:	d3 e2                	shl    %cl,%edx
  80196b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80196f:	88 d9                	mov    %bl,%cl
  801971:	d3 e8                	shr    %cl,%eax
  801973:	09 c2                	or     %eax,%edx
  801975:	89 d0                	mov    %edx,%eax
  801977:	89 f2                	mov    %esi,%edx
  801979:	f7 74 24 0c          	divl   0xc(%esp)
  80197d:	89 d6                	mov    %edx,%esi
  80197f:	89 c3                	mov    %eax,%ebx
  801981:	f7 e5                	mul    %ebp
  801983:	39 d6                	cmp    %edx,%esi
  801985:	72 19                	jb     8019a0 <__udivdi3+0xfc>
  801987:	74 0b                	je     801994 <__udivdi3+0xf0>
  801989:	89 d8                	mov    %ebx,%eax
  80198b:	31 ff                	xor    %edi,%edi
  80198d:	e9 58 ff ff ff       	jmp    8018ea <__udivdi3+0x46>
  801992:	66 90                	xchg   %ax,%ax
  801994:	8b 54 24 08          	mov    0x8(%esp),%edx
  801998:	89 f9                	mov    %edi,%ecx
  80199a:	d3 e2                	shl    %cl,%edx
  80199c:	39 c2                	cmp    %eax,%edx
  80199e:	73 e9                	jae    801989 <__udivdi3+0xe5>
  8019a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8019a3:	31 ff                	xor    %edi,%edi
  8019a5:	e9 40 ff ff ff       	jmp    8018ea <__udivdi3+0x46>
  8019aa:	66 90                	xchg   %ax,%ax
  8019ac:	31 c0                	xor    %eax,%eax
  8019ae:	e9 37 ff ff ff       	jmp    8018ea <__udivdi3+0x46>
  8019b3:	90                   	nop

008019b4 <__umoddi3>:
  8019b4:	55                   	push   %ebp
  8019b5:	57                   	push   %edi
  8019b6:	56                   	push   %esi
  8019b7:	53                   	push   %ebx
  8019b8:	83 ec 1c             	sub    $0x1c,%esp
  8019bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8019bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8019c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8019cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019d3:	89 f3                	mov    %esi,%ebx
  8019d5:	89 fa                	mov    %edi,%edx
  8019d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019db:	89 34 24             	mov    %esi,(%esp)
  8019de:	85 c0                	test   %eax,%eax
  8019e0:	75 1a                	jne    8019fc <__umoddi3+0x48>
  8019e2:	39 f7                	cmp    %esi,%edi
  8019e4:	0f 86 a2 00 00 00    	jbe    801a8c <__umoddi3+0xd8>
  8019ea:	89 c8                	mov    %ecx,%eax
  8019ec:	89 f2                	mov    %esi,%edx
  8019ee:	f7 f7                	div    %edi
  8019f0:	89 d0                	mov    %edx,%eax
  8019f2:	31 d2                	xor    %edx,%edx
  8019f4:	83 c4 1c             	add    $0x1c,%esp
  8019f7:	5b                   	pop    %ebx
  8019f8:	5e                   	pop    %esi
  8019f9:	5f                   	pop    %edi
  8019fa:	5d                   	pop    %ebp
  8019fb:	c3                   	ret    
  8019fc:	39 f0                	cmp    %esi,%eax
  8019fe:	0f 87 ac 00 00 00    	ja     801ab0 <__umoddi3+0xfc>
  801a04:	0f bd e8             	bsr    %eax,%ebp
  801a07:	83 f5 1f             	xor    $0x1f,%ebp
  801a0a:	0f 84 ac 00 00 00    	je     801abc <__umoddi3+0x108>
  801a10:	bf 20 00 00 00       	mov    $0x20,%edi
  801a15:	29 ef                	sub    %ebp,%edi
  801a17:	89 fe                	mov    %edi,%esi
  801a19:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a1d:	89 e9                	mov    %ebp,%ecx
  801a1f:	d3 e0                	shl    %cl,%eax
  801a21:	89 d7                	mov    %edx,%edi
  801a23:	89 f1                	mov    %esi,%ecx
  801a25:	d3 ef                	shr    %cl,%edi
  801a27:	09 c7                	or     %eax,%edi
  801a29:	89 e9                	mov    %ebp,%ecx
  801a2b:	d3 e2                	shl    %cl,%edx
  801a2d:	89 14 24             	mov    %edx,(%esp)
  801a30:	89 d8                	mov    %ebx,%eax
  801a32:	d3 e0                	shl    %cl,%eax
  801a34:	89 c2                	mov    %eax,%edx
  801a36:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a3a:	d3 e0                	shl    %cl,%eax
  801a3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a40:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a44:	89 f1                	mov    %esi,%ecx
  801a46:	d3 e8                	shr    %cl,%eax
  801a48:	09 d0                	or     %edx,%eax
  801a4a:	d3 eb                	shr    %cl,%ebx
  801a4c:	89 da                	mov    %ebx,%edx
  801a4e:	f7 f7                	div    %edi
  801a50:	89 d3                	mov    %edx,%ebx
  801a52:	f7 24 24             	mull   (%esp)
  801a55:	89 c6                	mov    %eax,%esi
  801a57:	89 d1                	mov    %edx,%ecx
  801a59:	39 d3                	cmp    %edx,%ebx
  801a5b:	0f 82 87 00 00 00    	jb     801ae8 <__umoddi3+0x134>
  801a61:	0f 84 91 00 00 00    	je     801af8 <__umoddi3+0x144>
  801a67:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a6b:	29 f2                	sub    %esi,%edx
  801a6d:	19 cb                	sbb    %ecx,%ebx
  801a6f:	89 d8                	mov    %ebx,%eax
  801a71:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a75:	d3 e0                	shl    %cl,%eax
  801a77:	89 e9                	mov    %ebp,%ecx
  801a79:	d3 ea                	shr    %cl,%edx
  801a7b:	09 d0                	or     %edx,%eax
  801a7d:	89 e9                	mov    %ebp,%ecx
  801a7f:	d3 eb                	shr    %cl,%ebx
  801a81:	89 da                	mov    %ebx,%edx
  801a83:	83 c4 1c             	add    $0x1c,%esp
  801a86:	5b                   	pop    %ebx
  801a87:	5e                   	pop    %esi
  801a88:	5f                   	pop    %edi
  801a89:	5d                   	pop    %ebp
  801a8a:	c3                   	ret    
  801a8b:	90                   	nop
  801a8c:	89 fd                	mov    %edi,%ebp
  801a8e:	85 ff                	test   %edi,%edi
  801a90:	75 0b                	jne    801a9d <__umoddi3+0xe9>
  801a92:	b8 01 00 00 00       	mov    $0x1,%eax
  801a97:	31 d2                	xor    %edx,%edx
  801a99:	f7 f7                	div    %edi
  801a9b:	89 c5                	mov    %eax,%ebp
  801a9d:	89 f0                	mov    %esi,%eax
  801a9f:	31 d2                	xor    %edx,%edx
  801aa1:	f7 f5                	div    %ebp
  801aa3:	89 c8                	mov    %ecx,%eax
  801aa5:	f7 f5                	div    %ebp
  801aa7:	89 d0                	mov    %edx,%eax
  801aa9:	e9 44 ff ff ff       	jmp    8019f2 <__umoddi3+0x3e>
  801aae:	66 90                	xchg   %ax,%ax
  801ab0:	89 c8                	mov    %ecx,%eax
  801ab2:	89 f2                	mov    %esi,%edx
  801ab4:	83 c4 1c             	add    $0x1c,%esp
  801ab7:	5b                   	pop    %ebx
  801ab8:	5e                   	pop    %esi
  801ab9:	5f                   	pop    %edi
  801aba:	5d                   	pop    %ebp
  801abb:	c3                   	ret    
  801abc:	3b 04 24             	cmp    (%esp),%eax
  801abf:	72 06                	jb     801ac7 <__umoddi3+0x113>
  801ac1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ac5:	77 0f                	ja     801ad6 <__umoddi3+0x122>
  801ac7:	89 f2                	mov    %esi,%edx
  801ac9:	29 f9                	sub    %edi,%ecx
  801acb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801acf:	89 14 24             	mov    %edx,(%esp)
  801ad2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ad6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ada:	8b 14 24             	mov    (%esp),%edx
  801add:	83 c4 1c             	add    $0x1c,%esp
  801ae0:	5b                   	pop    %ebx
  801ae1:	5e                   	pop    %esi
  801ae2:	5f                   	pop    %edi
  801ae3:	5d                   	pop    %ebp
  801ae4:	c3                   	ret    
  801ae5:	8d 76 00             	lea    0x0(%esi),%esi
  801ae8:	2b 04 24             	sub    (%esp),%eax
  801aeb:	19 fa                	sbb    %edi,%edx
  801aed:	89 d1                	mov    %edx,%ecx
  801aef:	89 c6                	mov    %eax,%esi
  801af1:	e9 71 ff ff ff       	jmp    801a67 <__umoddi3+0xb3>
  801af6:	66 90                	xchg   %ax,%ax
  801af8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801afc:	72 ea                	jb     801ae8 <__umoddi3+0x134>
  801afe:	89 d9                	mov    %ebx,%ecx
  801b00:	e9 62 ff ff ff       	jmp    801a67 <__umoddi3+0xb3>
