
obj/user/tst_syscalls_2_slave3:     file format elf32-i386


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
  800031:	e8 36 00 00 00       	call   80006c <libmain>
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
	//[2] Invalid Range (Cross USER_LIMIT)
	sys_free_user_mem(USER_HEAP_MAX - PAGE_SIZE, PAGE_SIZE + 10);
  80003e:	83 ec 08             	sub    $0x8,%esp
  800041:	68 0a 10 00 00       	push   $0x100a
  800046:	68 00 f0 ff 9f       	push   $0x9ffff000
  80004b:	e8 a9 17 00 00       	call   8017f9 <sys_free_user_mem>
  800050:	83 c4 10             	add    $0x10,%esp
	inctst();
  800053:	e8 d7 15 00 00       	call   80162f <inctst>
	panic("tst system calls #2 failed: sys_free_user_mem is called with invalid params\nThe env must be killed and shouldn't return here.");
  800058:	83 ec 04             	sub    $0x4,%esp
  80005b:	68 20 1b 80 00       	push   $0x801b20
  800060:	6a 0a                	push   $0xa
  800062:	68 9e 1b 80 00       	push   $0x801b9e
  800067:	e8 45 01 00 00       	call   8001b1 <_panic>

0080006c <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80006c:	55                   	push   %ebp
  80006d:	89 e5                	mov    %esp,%ebp
  80006f:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800072:	e8 7a 14 00 00       	call   8014f1 <sys_getenvindex>
  800077:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80007a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80007d:	89 d0                	mov    %edx,%eax
  80007f:	c1 e0 02             	shl    $0x2,%eax
  800082:	01 d0                	add    %edx,%eax
  800084:	c1 e0 03             	shl    $0x3,%eax
  800087:	01 d0                	add    %edx,%eax
  800089:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800090:	01 d0                	add    %edx,%eax
  800092:	c1 e0 02             	shl    $0x2,%eax
  800095:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80009a:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80009f:	a1 08 30 80 00       	mov    0x803008,%eax
  8000a4:	8a 40 20             	mov    0x20(%eax),%al
  8000a7:	84 c0                	test   %al,%al
  8000a9:	74 0d                	je     8000b8 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  8000ab:	a1 08 30 80 00       	mov    0x803008,%eax
  8000b0:	83 c0 20             	add    $0x20,%eax
  8000b3:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000bc:	7e 0a                	jle    8000c8 <libmain+0x5c>
		binaryname = argv[0];
  8000be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000c1:	8b 00                	mov    (%eax),%eax
  8000c3:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000c8:	83 ec 08             	sub    $0x8,%esp
  8000cb:	ff 75 0c             	pushl  0xc(%ebp)
  8000ce:	ff 75 08             	pushl  0x8(%ebp)
  8000d1:	e8 62 ff ff ff       	call   800038 <_main>
  8000d6:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000d9:	a1 00 30 80 00       	mov    0x803000,%eax
  8000de:	85 c0                	test   %eax,%eax
  8000e0:	0f 84 9f 00 00 00    	je     800185 <libmain+0x119>
	{
		sys_lock_cons();
  8000e6:	e8 8a 11 00 00       	call   801275 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 d4 1b 80 00       	push   $0x801bd4
  8000f3:	e8 76 03 00 00       	call   80046e <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000fb:	a1 08 30 80 00       	mov    0x803008,%eax
  800100:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800106:	a1 08 30 80 00       	mov    0x803008,%eax
  80010b:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800111:	83 ec 04             	sub    $0x4,%esp
  800114:	52                   	push   %edx
  800115:	50                   	push   %eax
  800116:	68 fc 1b 80 00       	push   $0x801bfc
  80011b:	e8 4e 03 00 00       	call   80046e <cprintf>
  800120:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800123:	a1 08 30 80 00       	mov    0x803008,%eax
  800128:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80012e:	a1 08 30 80 00       	mov    0x803008,%eax
  800133:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800139:	a1 08 30 80 00       	mov    0x803008,%eax
  80013e:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800144:	51                   	push   %ecx
  800145:	52                   	push   %edx
  800146:	50                   	push   %eax
  800147:	68 24 1c 80 00       	push   $0x801c24
  80014c:	e8 1d 03 00 00       	call   80046e <cprintf>
  800151:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800154:	a1 08 30 80 00       	mov    0x803008,%eax
  800159:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80015f:	83 ec 08             	sub    $0x8,%esp
  800162:	50                   	push   %eax
  800163:	68 7c 1c 80 00       	push   $0x801c7c
  800168:	e8 01 03 00 00       	call   80046e <cprintf>
  80016d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800170:	83 ec 0c             	sub    $0xc,%esp
  800173:	68 d4 1b 80 00       	push   $0x801bd4
  800178:	e8 f1 02 00 00       	call   80046e <cprintf>
  80017d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800180:	e8 0a 11 00 00       	call   80128f <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800185:	e8 19 00 00 00       	call   8001a3 <exit>
}
  80018a:	90                   	nop
  80018b:	c9                   	leave  
  80018c:	c3                   	ret    

0080018d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80018d:	55                   	push   %ebp
  80018e:	89 e5                	mov    %esp,%ebp
  800190:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800193:	83 ec 0c             	sub    $0xc,%esp
  800196:	6a 00                	push   $0x0
  800198:	e8 20 13 00 00       	call   8014bd <sys_destroy_env>
  80019d:	83 c4 10             	add    $0x10,%esp
}
  8001a0:	90                   	nop
  8001a1:	c9                   	leave  
  8001a2:	c3                   	ret    

008001a3 <exit>:

void
exit(void)
{
  8001a3:	55                   	push   %ebp
  8001a4:	89 e5                	mov    %esp,%ebp
  8001a6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001a9:	e8 75 13 00 00       	call   801523 <sys_exit_env>
}
  8001ae:	90                   	nop
  8001af:	c9                   	leave  
  8001b0:	c3                   	ret    

008001b1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001b1:	55                   	push   %ebp
  8001b2:	89 e5                	mov    %esp,%ebp
  8001b4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001b7:	8d 45 10             	lea    0x10(%ebp),%eax
  8001ba:	83 c0 04             	add    $0x4,%eax
  8001bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001c0:	a1 28 30 80 00       	mov    0x803028,%eax
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	74 16                	je     8001df <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001c9:	a1 28 30 80 00       	mov    0x803028,%eax
  8001ce:	83 ec 08             	sub    $0x8,%esp
  8001d1:	50                   	push   %eax
  8001d2:	68 90 1c 80 00       	push   $0x801c90
  8001d7:	e8 92 02 00 00       	call   80046e <cprintf>
  8001dc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001df:	a1 04 30 80 00       	mov    0x803004,%eax
  8001e4:	ff 75 0c             	pushl  0xc(%ebp)
  8001e7:	ff 75 08             	pushl  0x8(%ebp)
  8001ea:	50                   	push   %eax
  8001eb:	68 95 1c 80 00       	push   $0x801c95
  8001f0:	e8 79 02 00 00       	call   80046e <cprintf>
  8001f5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8001fb:	83 ec 08             	sub    $0x8,%esp
  8001fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800201:	50                   	push   %eax
  800202:	e8 fc 01 00 00       	call   800403 <vcprintf>
  800207:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80020a:	83 ec 08             	sub    $0x8,%esp
  80020d:	6a 00                	push   $0x0
  80020f:	68 b1 1c 80 00       	push   $0x801cb1
  800214:	e8 ea 01 00 00       	call   800403 <vcprintf>
  800219:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80021c:	e8 82 ff ff ff       	call   8001a3 <exit>

	// should not return here
	while (1) ;
  800221:	eb fe                	jmp    800221 <_panic+0x70>

00800223 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
  800226:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800229:	a1 08 30 80 00       	mov    0x803008,%eax
  80022e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800234:	8b 45 0c             	mov    0xc(%ebp),%eax
  800237:	39 c2                	cmp    %eax,%edx
  800239:	74 14                	je     80024f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80023b:	83 ec 04             	sub    $0x4,%esp
  80023e:	68 b4 1c 80 00       	push   $0x801cb4
  800243:	6a 26                	push   $0x26
  800245:	68 00 1d 80 00       	push   $0x801d00
  80024a:	e8 62 ff ff ff       	call   8001b1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80024f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800256:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80025d:	e9 c5 00 00 00       	jmp    800327 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800262:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800265:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80026c:	8b 45 08             	mov    0x8(%ebp),%eax
  80026f:	01 d0                	add    %edx,%eax
  800271:	8b 00                	mov    (%eax),%eax
  800273:	85 c0                	test   %eax,%eax
  800275:	75 08                	jne    80027f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800277:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80027a:	e9 a5 00 00 00       	jmp    800324 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80027f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800286:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80028d:	eb 69                	jmp    8002f8 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80028f:	a1 08 30 80 00       	mov    0x803008,%eax
  800294:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80029a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80029d:	89 d0                	mov    %edx,%eax
  80029f:	01 c0                	add    %eax,%eax
  8002a1:	01 d0                	add    %edx,%eax
  8002a3:	c1 e0 03             	shl    $0x3,%eax
  8002a6:	01 c8                	add    %ecx,%eax
  8002a8:	8a 40 04             	mov    0x4(%eax),%al
  8002ab:	84 c0                	test   %al,%al
  8002ad:	75 46                	jne    8002f5 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002af:	a1 08 30 80 00       	mov    0x803008,%eax
  8002b4:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8002ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002bd:	89 d0                	mov    %edx,%eax
  8002bf:	01 c0                	add    %eax,%eax
  8002c1:	01 d0                	add    %edx,%eax
  8002c3:	c1 e0 03             	shl    $0x3,%eax
  8002c6:	01 c8                	add    %ecx,%eax
  8002c8:	8b 00                	mov    (%eax),%eax
  8002ca:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002d5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002da:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	01 c8                	add    %ecx,%eax
  8002e6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002e8:	39 c2                	cmp    %eax,%edx
  8002ea:	75 09                	jne    8002f5 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002ec:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002f3:	eb 15                	jmp    80030a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002f5:	ff 45 e8             	incl   -0x18(%ebp)
  8002f8:	a1 08 30 80 00       	mov    0x803008,%eax
  8002fd:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800303:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800306:	39 c2                	cmp    %eax,%edx
  800308:	77 85                	ja     80028f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80030a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80030e:	75 14                	jne    800324 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800310:	83 ec 04             	sub    $0x4,%esp
  800313:	68 0c 1d 80 00       	push   $0x801d0c
  800318:	6a 3a                	push   $0x3a
  80031a:	68 00 1d 80 00       	push   $0x801d00
  80031f:	e8 8d fe ff ff       	call   8001b1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800324:	ff 45 f0             	incl   -0x10(%ebp)
  800327:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80032a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80032d:	0f 8c 2f ff ff ff    	jl     800262 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800333:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80033a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800341:	eb 26                	jmp    800369 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800343:	a1 08 30 80 00       	mov    0x803008,%eax
  800348:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80034e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800351:	89 d0                	mov    %edx,%eax
  800353:	01 c0                	add    %eax,%eax
  800355:	01 d0                	add    %edx,%eax
  800357:	c1 e0 03             	shl    $0x3,%eax
  80035a:	01 c8                	add    %ecx,%eax
  80035c:	8a 40 04             	mov    0x4(%eax),%al
  80035f:	3c 01                	cmp    $0x1,%al
  800361:	75 03                	jne    800366 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800363:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800366:	ff 45 e0             	incl   -0x20(%ebp)
  800369:	a1 08 30 80 00       	mov    0x803008,%eax
  80036e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800374:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800377:	39 c2                	cmp    %eax,%edx
  800379:	77 c8                	ja     800343 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80037b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80037e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800381:	74 14                	je     800397 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800383:	83 ec 04             	sub    $0x4,%esp
  800386:	68 60 1d 80 00       	push   $0x801d60
  80038b:	6a 44                	push   $0x44
  80038d:	68 00 1d 80 00       	push   $0x801d00
  800392:	e8 1a fe ff ff       	call   8001b1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800397:	90                   	nop
  800398:	c9                   	leave  
  800399:	c3                   	ret    

0080039a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8003a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a3:	8b 00                	mov    (%eax),%eax
  8003a5:	8d 48 01             	lea    0x1(%eax),%ecx
  8003a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ab:	89 0a                	mov    %ecx,(%edx)
  8003ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b0:	88 d1                	mov    %dl,%cl
  8003b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bc:	8b 00                	mov    (%eax),%eax
  8003be:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003c3:	75 2c                	jne    8003f1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003c5:	a0 0c 30 80 00       	mov    0x80300c,%al
  8003ca:	0f b6 c0             	movzbl %al,%eax
  8003cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003d0:	8b 12                	mov    (%edx),%edx
  8003d2:	89 d1                	mov    %edx,%ecx
  8003d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003d7:	83 c2 08             	add    $0x8,%edx
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	50                   	push   %eax
  8003de:	51                   	push   %ecx
  8003df:	52                   	push   %edx
  8003e0:	e8 4e 0e 00 00       	call   801233 <sys_cputs>
  8003e5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f4:	8b 40 04             	mov    0x4(%eax),%eax
  8003f7:	8d 50 01             	lea    0x1(%eax),%edx
  8003fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003fd:	89 50 04             	mov    %edx,0x4(%eax)
}
  800400:	90                   	nop
  800401:	c9                   	leave  
  800402:	c3                   	ret    

00800403 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800403:	55                   	push   %ebp
  800404:	89 e5                	mov    %esp,%ebp
  800406:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80040c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800413:	00 00 00 
	b.cnt = 0;
  800416:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80041d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800420:	ff 75 0c             	pushl  0xc(%ebp)
  800423:	ff 75 08             	pushl  0x8(%ebp)
  800426:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80042c:	50                   	push   %eax
  80042d:	68 9a 03 80 00       	push   $0x80039a
  800432:	e8 11 02 00 00       	call   800648 <vprintfmt>
  800437:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80043a:	a0 0c 30 80 00       	mov    0x80300c,%al
  80043f:	0f b6 c0             	movzbl %al,%eax
  800442:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800448:	83 ec 04             	sub    $0x4,%esp
  80044b:	50                   	push   %eax
  80044c:	52                   	push   %edx
  80044d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800453:	83 c0 08             	add    $0x8,%eax
  800456:	50                   	push   %eax
  800457:	e8 d7 0d 00 00       	call   801233 <sys_cputs>
  80045c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80045f:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  800466:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80046c:	c9                   	leave  
  80046d:	c3                   	ret    

0080046e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800474:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  80047b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80047e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800481:	8b 45 08             	mov    0x8(%ebp),%eax
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	ff 75 f4             	pushl  -0xc(%ebp)
  80048a:	50                   	push   %eax
  80048b:	e8 73 ff ff ff       	call   800403 <vcprintf>
  800490:	83 c4 10             	add    $0x10,%esp
  800493:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800496:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800499:	c9                   	leave  
  80049a:	c3                   	ret    

0080049b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80049b:	55                   	push   %ebp
  80049c:	89 e5                	mov    %esp,%ebp
  80049e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8004a1:	e8 cf 0d 00 00       	call   801275 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8004a6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8004ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8004af:	83 ec 08             	sub    $0x8,%esp
  8004b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8004b5:	50                   	push   %eax
  8004b6:	e8 48 ff ff ff       	call   800403 <vcprintf>
  8004bb:	83 c4 10             	add    $0x10,%esp
  8004be:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004c1:	e8 c9 0d 00 00       	call   80128f <sys_unlock_cons>
	return cnt;
  8004c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004c9:	c9                   	leave  
  8004ca:	c3                   	ret    

008004cb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004cb:	55                   	push   %ebp
  8004cc:	89 e5                	mov    %esp,%ebp
  8004ce:	53                   	push   %ebx
  8004cf:	83 ec 14             	sub    $0x14,%esp
  8004d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004de:	8b 45 18             	mov    0x18(%ebp),%eax
  8004e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004e9:	77 55                	ja     800540 <printnum+0x75>
  8004eb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004ee:	72 05                	jb     8004f5 <printnum+0x2a>
  8004f0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004f3:	77 4b                	ja     800540 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004f5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004f8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004fb:	8b 45 18             	mov    0x18(%ebp),%eax
  8004fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800503:	52                   	push   %edx
  800504:	50                   	push   %eax
  800505:	ff 75 f4             	pushl  -0xc(%ebp)
  800508:	ff 75 f0             	pushl  -0x10(%ebp)
  80050b:	e8 98 13 00 00       	call   8018a8 <__udivdi3>
  800510:	83 c4 10             	add    $0x10,%esp
  800513:	83 ec 04             	sub    $0x4,%esp
  800516:	ff 75 20             	pushl  0x20(%ebp)
  800519:	53                   	push   %ebx
  80051a:	ff 75 18             	pushl  0x18(%ebp)
  80051d:	52                   	push   %edx
  80051e:	50                   	push   %eax
  80051f:	ff 75 0c             	pushl  0xc(%ebp)
  800522:	ff 75 08             	pushl  0x8(%ebp)
  800525:	e8 a1 ff ff ff       	call   8004cb <printnum>
  80052a:	83 c4 20             	add    $0x20,%esp
  80052d:	eb 1a                	jmp    800549 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	ff 75 0c             	pushl  0xc(%ebp)
  800535:	ff 75 20             	pushl  0x20(%ebp)
  800538:	8b 45 08             	mov    0x8(%ebp),%eax
  80053b:	ff d0                	call   *%eax
  80053d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800540:	ff 4d 1c             	decl   0x1c(%ebp)
  800543:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800547:	7f e6                	jg     80052f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800549:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80054c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800554:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800557:	53                   	push   %ebx
  800558:	51                   	push   %ecx
  800559:	52                   	push   %edx
  80055a:	50                   	push   %eax
  80055b:	e8 58 14 00 00       	call   8019b8 <__umoddi3>
  800560:	83 c4 10             	add    $0x10,%esp
  800563:	05 d4 1f 80 00       	add    $0x801fd4,%eax
  800568:	8a 00                	mov    (%eax),%al
  80056a:	0f be c0             	movsbl %al,%eax
  80056d:	83 ec 08             	sub    $0x8,%esp
  800570:	ff 75 0c             	pushl  0xc(%ebp)
  800573:	50                   	push   %eax
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	ff d0                	call   *%eax
  800579:	83 c4 10             	add    $0x10,%esp
}
  80057c:	90                   	nop
  80057d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800580:	c9                   	leave  
  800581:	c3                   	ret    

00800582 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800585:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800589:	7e 1c                	jle    8005a7 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80058b:	8b 45 08             	mov    0x8(%ebp),%eax
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	8d 50 08             	lea    0x8(%eax),%edx
  800593:	8b 45 08             	mov    0x8(%ebp),%eax
  800596:	89 10                	mov    %edx,(%eax)
  800598:	8b 45 08             	mov    0x8(%ebp),%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	83 e8 08             	sub    $0x8,%eax
  8005a0:	8b 50 04             	mov    0x4(%eax),%edx
  8005a3:	8b 00                	mov    (%eax),%eax
  8005a5:	eb 40                	jmp    8005e7 <getuint+0x65>
	else if (lflag)
  8005a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005ab:	74 1e                	je     8005cb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b0:	8b 00                	mov    (%eax),%eax
  8005b2:	8d 50 04             	lea    0x4(%eax),%edx
  8005b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b8:	89 10                	mov    %edx,(%eax)
  8005ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bd:	8b 00                	mov    (%eax),%eax
  8005bf:	83 e8 04             	sub    $0x4,%eax
  8005c2:	8b 00                	mov    (%eax),%eax
  8005c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c9:	eb 1c                	jmp    8005e7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ce:	8b 00                	mov    (%eax),%eax
  8005d0:	8d 50 04             	lea    0x4(%eax),%edx
  8005d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d6:	89 10                	mov    %edx,(%eax)
  8005d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005db:	8b 00                	mov    (%eax),%eax
  8005dd:	83 e8 04             	sub    $0x4,%eax
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005e7:	5d                   	pop    %ebp
  8005e8:	c3                   	ret    

008005e9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005e9:	55                   	push   %ebp
  8005ea:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005ec:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005f0:	7e 1c                	jle    80060e <getint+0x25>
		return va_arg(*ap, long long);
  8005f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f5:	8b 00                	mov    (%eax),%eax
  8005f7:	8d 50 08             	lea    0x8(%eax),%edx
  8005fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fd:	89 10                	mov    %edx,(%eax)
  8005ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800602:	8b 00                	mov    (%eax),%eax
  800604:	83 e8 08             	sub    $0x8,%eax
  800607:	8b 50 04             	mov    0x4(%eax),%edx
  80060a:	8b 00                	mov    (%eax),%eax
  80060c:	eb 38                	jmp    800646 <getint+0x5d>
	else if (lflag)
  80060e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800612:	74 1a                	je     80062e <getint+0x45>
		return va_arg(*ap, long);
  800614:	8b 45 08             	mov    0x8(%ebp),%eax
  800617:	8b 00                	mov    (%eax),%eax
  800619:	8d 50 04             	lea    0x4(%eax),%edx
  80061c:	8b 45 08             	mov    0x8(%ebp),%eax
  80061f:	89 10                	mov    %edx,(%eax)
  800621:	8b 45 08             	mov    0x8(%ebp),%eax
  800624:	8b 00                	mov    (%eax),%eax
  800626:	83 e8 04             	sub    $0x4,%eax
  800629:	8b 00                	mov    (%eax),%eax
  80062b:	99                   	cltd   
  80062c:	eb 18                	jmp    800646 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80062e:	8b 45 08             	mov    0x8(%ebp),%eax
  800631:	8b 00                	mov    (%eax),%eax
  800633:	8d 50 04             	lea    0x4(%eax),%edx
  800636:	8b 45 08             	mov    0x8(%ebp),%eax
  800639:	89 10                	mov    %edx,(%eax)
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	8b 00                	mov    (%eax),%eax
  800640:	83 e8 04             	sub    $0x4,%eax
  800643:	8b 00                	mov    (%eax),%eax
  800645:	99                   	cltd   
}
  800646:	5d                   	pop    %ebp
  800647:	c3                   	ret    

00800648 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800648:	55                   	push   %ebp
  800649:	89 e5                	mov    %esp,%ebp
  80064b:	56                   	push   %esi
  80064c:	53                   	push   %ebx
  80064d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800650:	eb 17                	jmp    800669 <vprintfmt+0x21>
			if (ch == '\0')
  800652:	85 db                	test   %ebx,%ebx
  800654:	0f 84 c1 03 00 00    	je     800a1b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	ff 75 0c             	pushl  0xc(%ebp)
  800660:	53                   	push   %ebx
  800661:	8b 45 08             	mov    0x8(%ebp),%eax
  800664:	ff d0                	call   *%eax
  800666:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800669:	8b 45 10             	mov    0x10(%ebp),%eax
  80066c:	8d 50 01             	lea    0x1(%eax),%edx
  80066f:	89 55 10             	mov    %edx,0x10(%ebp)
  800672:	8a 00                	mov    (%eax),%al
  800674:	0f b6 d8             	movzbl %al,%ebx
  800677:	83 fb 25             	cmp    $0x25,%ebx
  80067a:	75 d6                	jne    800652 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80067c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800680:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800687:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80068e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800695:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80069c:	8b 45 10             	mov    0x10(%ebp),%eax
  80069f:	8d 50 01             	lea    0x1(%eax),%edx
  8006a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8006a5:	8a 00                	mov    (%eax),%al
  8006a7:	0f b6 d8             	movzbl %al,%ebx
  8006aa:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006ad:	83 f8 5b             	cmp    $0x5b,%eax
  8006b0:	0f 87 3d 03 00 00    	ja     8009f3 <vprintfmt+0x3ab>
  8006b6:	8b 04 85 f8 1f 80 00 	mov    0x801ff8(,%eax,4),%eax
  8006bd:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006bf:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006c3:	eb d7                	jmp    80069c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006c5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006c9:	eb d1                	jmp    80069c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006cb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006d5:	89 d0                	mov    %edx,%eax
  8006d7:	c1 e0 02             	shl    $0x2,%eax
  8006da:	01 d0                	add    %edx,%eax
  8006dc:	01 c0                	add    %eax,%eax
  8006de:	01 d8                	add    %ebx,%eax
  8006e0:	83 e8 30             	sub    $0x30,%eax
  8006e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8006e9:	8a 00                	mov    (%eax),%al
  8006eb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006ee:	83 fb 2f             	cmp    $0x2f,%ebx
  8006f1:	7e 3e                	jle    800731 <vprintfmt+0xe9>
  8006f3:	83 fb 39             	cmp    $0x39,%ebx
  8006f6:	7f 39                	jg     800731 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006f8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006fb:	eb d5                	jmp    8006d2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	83 c0 04             	add    $0x4,%eax
  800703:	89 45 14             	mov    %eax,0x14(%ebp)
  800706:	8b 45 14             	mov    0x14(%ebp),%eax
  800709:	83 e8 04             	sub    $0x4,%eax
  80070c:	8b 00                	mov    (%eax),%eax
  80070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800711:	eb 1f                	jmp    800732 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800713:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800717:	79 83                	jns    80069c <vprintfmt+0x54>
				width = 0;
  800719:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800720:	e9 77 ff ff ff       	jmp    80069c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800725:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80072c:	e9 6b ff ff ff       	jmp    80069c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800731:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800732:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800736:	0f 89 60 ff ff ff    	jns    80069c <vprintfmt+0x54>
				width = precision, precision = -1;
  80073c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80073f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800742:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800749:	e9 4e ff ff ff       	jmp    80069c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80074e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800751:	e9 46 ff ff ff       	jmp    80069c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	83 c0 04             	add    $0x4,%eax
  80075c:	89 45 14             	mov    %eax,0x14(%ebp)
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	83 e8 04             	sub    $0x4,%eax
  800765:	8b 00                	mov    (%eax),%eax
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	ff 75 0c             	pushl  0xc(%ebp)
  80076d:	50                   	push   %eax
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	ff d0                	call   *%eax
  800773:	83 c4 10             	add    $0x10,%esp
			break;
  800776:	e9 9b 02 00 00       	jmp    800a16 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	83 c0 04             	add    $0x4,%eax
  800781:	89 45 14             	mov    %eax,0x14(%ebp)
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	83 e8 04             	sub    $0x4,%eax
  80078a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80078c:	85 db                	test   %ebx,%ebx
  80078e:	79 02                	jns    800792 <vprintfmt+0x14a>
				err = -err;
  800790:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800792:	83 fb 64             	cmp    $0x64,%ebx
  800795:	7f 0b                	jg     8007a2 <vprintfmt+0x15a>
  800797:	8b 34 9d 40 1e 80 00 	mov    0x801e40(,%ebx,4),%esi
  80079e:	85 f6                	test   %esi,%esi
  8007a0:	75 19                	jne    8007bb <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007a2:	53                   	push   %ebx
  8007a3:	68 e5 1f 80 00       	push   $0x801fe5
  8007a8:	ff 75 0c             	pushl  0xc(%ebp)
  8007ab:	ff 75 08             	pushl  0x8(%ebp)
  8007ae:	e8 70 02 00 00       	call   800a23 <printfmt>
  8007b3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007b6:	e9 5b 02 00 00       	jmp    800a16 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007bb:	56                   	push   %esi
  8007bc:	68 ee 1f 80 00       	push   $0x801fee
  8007c1:	ff 75 0c             	pushl  0xc(%ebp)
  8007c4:	ff 75 08             	pushl  0x8(%ebp)
  8007c7:	e8 57 02 00 00       	call   800a23 <printfmt>
  8007cc:	83 c4 10             	add    $0x10,%esp
			break;
  8007cf:	e9 42 02 00 00       	jmp    800a16 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d7:	83 c0 04             	add    $0x4,%eax
  8007da:	89 45 14             	mov    %eax,0x14(%ebp)
  8007dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e0:	83 e8 04             	sub    $0x4,%eax
  8007e3:	8b 30                	mov    (%eax),%esi
  8007e5:	85 f6                	test   %esi,%esi
  8007e7:	75 05                	jne    8007ee <vprintfmt+0x1a6>
				p = "(null)";
  8007e9:	be f1 1f 80 00       	mov    $0x801ff1,%esi
			if (width > 0 && padc != '-')
  8007ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f2:	7e 6d                	jle    800861 <vprintfmt+0x219>
  8007f4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007f8:	74 67                	je     800861 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	50                   	push   %eax
  800801:	56                   	push   %esi
  800802:	e8 1e 03 00 00       	call   800b25 <strnlen>
  800807:	83 c4 10             	add    $0x10,%esp
  80080a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80080d:	eb 16                	jmp    800825 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80080f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800813:	83 ec 08             	sub    $0x8,%esp
  800816:	ff 75 0c             	pushl  0xc(%ebp)
  800819:	50                   	push   %eax
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	ff d0                	call   *%eax
  80081f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800822:	ff 4d e4             	decl   -0x1c(%ebp)
  800825:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800829:	7f e4                	jg     80080f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80082b:	eb 34                	jmp    800861 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80082d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800831:	74 1c                	je     80084f <vprintfmt+0x207>
  800833:	83 fb 1f             	cmp    $0x1f,%ebx
  800836:	7e 05                	jle    80083d <vprintfmt+0x1f5>
  800838:	83 fb 7e             	cmp    $0x7e,%ebx
  80083b:	7e 12                	jle    80084f <vprintfmt+0x207>
					putch('?', putdat);
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	6a 3f                	push   $0x3f
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	ff d0                	call   *%eax
  80084a:	83 c4 10             	add    $0x10,%esp
  80084d:	eb 0f                	jmp    80085e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80084f:	83 ec 08             	sub    $0x8,%esp
  800852:	ff 75 0c             	pushl  0xc(%ebp)
  800855:	53                   	push   %ebx
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	ff d0                	call   *%eax
  80085b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80085e:	ff 4d e4             	decl   -0x1c(%ebp)
  800861:	89 f0                	mov    %esi,%eax
  800863:	8d 70 01             	lea    0x1(%eax),%esi
  800866:	8a 00                	mov    (%eax),%al
  800868:	0f be d8             	movsbl %al,%ebx
  80086b:	85 db                	test   %ebx,%ebx
  80086d:	74 24                	je     800893 <vprintfmt+0x24b>
  80086f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800873:	78 b8                	js     80082d <vprintfmt+0x1e5>
  800875:	ff 4d e0             	decl   -0x20(%ebp)
  800878:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80087c:	79 af                	jns    80082d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80087e:	eb 13                	jmp    800893 <vprintfmt+0x24b>
				putch(' ', putdat);
  800880:	83 ec 08             	sub    $0x8,%esp
  800883:	ff 75 0c             	pushl  0xc(%ebp)
  800886:	6a 20                	push   $0x20
  800888:	8b 45 08             	mov    0x8(%ebp),%eax
  80088b:	ff d0                	call   *%eax
  80088d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800890:	ff 4d e4             	decl   -0x1c(%ebp)
  800893:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800897:	7f e7                	jg     800880 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800899:	e9 78 01 00 00       	jmp    800a16 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80089e:	83 ec 08             	sub    $0x8,%esp
  8008a1:	ff 75 e8             	pushl  -0x18(%ebp)
  8008a4:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a7:	50                   	push   %eax
  8008a8:	e8 3c fd ff ff       	call   8005e9 <getint>
  8008ad:	83 c4 10             	add    $0x10,%esp
  8008b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008bc:	85 d2                	test   %edx,%edx
  8008be:	79 23                	jns    8008e3 <vprintfmt+0x29b>
				putch('-', putdat);
  8008c0:	83 ec 08             	sub    $0x8,%esp
  8008c3:	ff 75 0c             	pushl  0xc(%ebp)
  8008c6:	6a 2d                	push   $0x2d
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	ff d0                	call   *%eax
  8008cd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008d6:	f7 d8                	neg    %eax
  8008d8:	83 d2 00             	adc    $0x0,%edx
  8008db:	f7 da                	neg    %edx
  8008dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008e3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008ea:	e9 bc 00 00 00       	jmp    8009ab <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	ff 75 e8             	pushl  -0x18(%ebp)
  8008f5:	8d 45 14             	lea    0x14(%ebp),%eax
  8008f8:	50                   	push   %eax
  8008f9:	e8 84 fc ff ff       	call   800582 <getuint>
  8008fe:	83 c4 10             	add    $0x10,%esp
  800901:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800904:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800907:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80090e:	e9 98 00 00 00       	jmp    8009ab <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800913:	83 ec 08             	sub    $0x8,%esp
  800916:	ff 75 0c             	pushl  0xc(%ebp)
  800919:	6a 58                	push   $0x58
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	ff d0                	call   *%eax
  800920:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800923:	83 ec 08             	sub    $0x8,%esp
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	6a 58                	push   $0x58
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	ff d0                	call   *%eax
  800930:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800933:	83 ec 08             	sub    $0x8,%esp
  800936:	ff 75 0c             	pushl  0xc(%ebp)
  800939:	6a 58                	push   $0x58
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	ff d0                	call   *%eax
  800940:	83 c4 10             	add    $0x10,%esp
			break;
  800943:	e9 ce 00 00 00       	jmp    800a16 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800948:	83 ec 08             	sub    $0x8,%esp
  80094b:	ff 75 0c             	pushl  0xc(%ebp)
  80094e:	6a 30                	push   $0x30
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	ff d0                	call   *%eax
  800955:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800958:	83 ec 08             	sub    $0x8,%esp
  80095b:	ff 75 0c             	pushl  0xc(%ebp)
  80095e:	6a 78                	push   $0x78
  800960:	8b 45 08             	mov    0x8(%ebp),%eax
  800963:	ff d0                	call   *%eax
  800965:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800968:	8b 45 14             	mov    0x14(%ebp),%eax
  80096b:	83 c0 04             	add    $0x4,%eax
  80096e:	89 45 14             	mov    %eax,0x14(%ebp)
  800971:	8b 45 14             	mov    0x14(%ebp),%eax
  800974:	83 e8 04             	sub    $0x4,%eax
  800977:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800979:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800983:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80098a:	eb 1f                	jmp    8009ab <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80098c:	83 ec 08             	sub    $0x8,%esp
  80098f:	ff 75 e8             	pushl  -0x18(%ebp)
  800992:	8d 45 14             	lea    0x14(%ebp),%eax
  800995:	50                   	push   %eax
  800996:	e8 e7 fb ff ff       	call   800582 <getuint>
  80099b:	83 c4 10             	add    $0x10,%esp
  80099e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009a4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009ab:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009b2:	83 ec 04             	sub    $0x4,%esp
  8009b5:	52                   	push   %edx
  8009b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009b9:	50                   	push   %eax
  8009ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8009bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8009c0:	ff 75 0c             	pushl  0xc(%ebp)
  8009c3:	ff 75 08             	pushl  0x8(%ebp)
  8009c6:	e8 00 fb ff ff       	call   8004cb <printnum>
  8009cb:	83 c4 20             	add    $0x20,%esp
			break;
  8009ce:	eb 46                	jmp    800a16 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009d0:	83 ec 08             	sub    $0x8,%esp
  8009d3:	ff 75 0c             	pushl  0xc(%ebp)
  8009d6:	53                   	push   %ebx
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	ff d0                	call   *%eax
  8009dc:	83 c4 10             	add    $0x10,%esp
			break;
  8009df:	eb 35                	jmp    800a16 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009e1:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  8009e8:	eb 2c                	jmp    800a16 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009ea:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  8009f1:	eb 23                	jmp    800a16 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009f3:	83 ec 08             	sub    $0x8,%esp
  8009f6:	ff 75 0c             	pushl  0xc(%ebp)
  8009f9:	6a 25                	push   $0x25
  8009fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fe:	ff d0                	call   *%eax
  800a00:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a03:	ff 4d 10             	decl   0x10(%ebp)
  800a06:	eb 03                	jmp    800a0b <vprintfmt+0x3c3>
  800a08:	ff 4d 10             	decl   0x10(%ebp)
  800a0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0e:	48                   	dec    %eax
  800a0f:	8a 00                	mov    (%eax),%al
  800a11:	3c 25                	cmp    $0x25,%al
  800a13:	75 f3                	jne    800a08 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a15:	90                   	nop
		}
	}
  800a16:	e9 35 fc ff ff       	jmp    800650 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a1b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a1f:	5b                   	pop    %ebx
  800a20:	5e                   	pop    %esi
  800a21:	5d                   	pop    %ebp
  800a22:	c3                   	ret    

00800a23 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a23:	55                   	push   %ebp
  800a24:	89 e5                	mov    %esp,%ebp
  800a26:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a29:	8d 45 10             	lea    0x10(%ebp),%eax
  800a2c:	83 c0 04             	add    $0x4,%eax
  800a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a32:	8b 45 10             	mov    0x10(%ebp),%eax
  800a35:	ff 75 f4             	pushl  -0xc(%ebp)
  800a38:	50                   	push   %eax
  800a39:	ff 75 0c             	pushl  0xc(%ebp)
  800a3c:	ff 75 08             	pushl  0x8(%ebp)
  800a3f:	e8 04 fc ff ff       	call   800648 <vprintfmt>
  800a44:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a47:	90                   	nop
  800a48:	c9                   	leave  
  800a49:	c3                   	ret    

00800a4a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a50:	8b 40 08             	mov    0x8(%eax),%eax
  800a53:	8d 50 01             	lea    0x1(%eax),%edx
  800a56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a59:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5f:	8b 10                	mov    (%eax),%edx
  800a61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a64:	8b 40 04             	mov    0x4(%eax),%eax
  800a67:	39 c2                	cmp    %eax,%edx
  800a69:	73 12                	jae    800a7d <sprintputch+0x33>
		*b->buf++ = ch;
  800a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6e:	8b 00                	mov    (%eax),%eax
  800a70:	8d 48 01             	lea    0x1(%eax),%ecx
  800a73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a76:	89 0a                	mov    %ecx,(%edx)
  800a78:	8b 55 08             	mov    0x8(%ebp),%edx
  800a7b:	88 10                	mov    %dl,(%eax)
}
  800a7d:	90                   	nop
  800a7e:	5d                   	pop    %ebp
  800a7f:	c3                   	ret    

00800a80 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a92:	8b 45 08             	mov    0x8(%ebp),%eax
  800a95:	01 d0                	add    %edx,%eax
  800a97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800aa1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800aa5:	74 06                	je     800aad <vsnprintf+0x2d>
  800aa7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aab:	7f 07                	jg     800ab4 <vsnprintf+0x34>
		return -E_INVAL;
  800aad:	b8 03 00 00 00       	mov    $0x3,%eax
  800ab2:	eb 20                	jmp    800ad4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ab4:	ff 75 14             	pushl  0x14(%ebp)
  800ab7:	ff 75 10             	pushl  0x10(%ebp)
  800aba:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800abd:	50                   	push   %eax
  800abe:	68 4a 0a 80 00       	push   $0x800a4a
  800ac3:	e8 80 fb ff ff       	call   800648 <vprintfmt>
  800ac8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800acb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ace:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ad4:	c9                   	leave  
  800ad5:	c3                   	ret    

00800ad6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800adc:	8d 45 10             	lea    0x10(%ebp),%eax
  800adf:	83 c0 04             	add    $0x4,%eax
  800ae2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ae5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae8:	ff 75 f4             	pushl  -0xc(%ebp)
  800aeb:	50                   	push   %eax
  800aec:	ff 75 0c             	pushl  0xc(%ebp)
  800aef:	ff 75 08             	pushl  0x8(%ebp)
  800af2:	e8 89 ff ff ff       	call   800a80 <vsnprintf>
  800af7:	83 c4 10             	add    $0x10,%esp
  800afa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800afd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b00:	c9                   	leave  
  800b01:	c3                   	ret    

00800b02 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b0f:	eb 06                	jmp    800b17 <strlen+0x15>
		n++;
  800b11:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b14:	ff 45 08             	incl   0x8(%ebp)
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	8a 00                	mov    (%eax),%al
  800b1c:	84 c0                	test   %al,%al
  800b1e:	75 f1                	jne    800b11 <strlen+0xf>
		n++;
	return n;
  800b20:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b23:	c9                   	leave  
  800b24:	c3                   	ret    

00800b25 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b2b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b32:	eb 09                	jmp    800b3d <strnlen+0x18>
		n++;
  800b34:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b37:	ff 45 08             	incl   0x8(%ebp)
  800b3a:	ff 4d 0c             	decl   0xc(%ebp)
  800b3d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b41:	74 09                	je     800b4c <strnlen+0x27>
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	8a 00                	mov    (%eax),%al
  800b48:	84 c0                	test   %al,%al
  800b4a:	75 e8                	jne    800b34 <strnlen+0xf>
		n++;
	return n;
  800b4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b4f:	c9                   	leave  
  800b50:	c3                   	ret    

00800b51 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b5d:	90                   	nop
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8d 50 01             	lea    0x1(%eax),%edx
  800b64:	89 55 08             	mov    %edx,0x8(%ebp)
  800b67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b6d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b70:	8a 12                	mov    (%edx),%dl
  800b72:	88 10                	mov    %dl,(%eax)
  800b74:	8a 00                	mov    (%eax),%al
  800b76:	84 c0                	test   %al,%al
  800b78:	75 e4                	jne    800b5e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b7d:	c9                   	leave  
  800b7e:	c3                   	ret    

00800b7f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
  800b82:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b8b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b92:	eb 1f                	jmp    800bb3 <strncpy+0x34>
		*dst++ = *src;
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	8d 50 01             	lea    0x1(%eax),%edx
  800b9a:	89 55 08             	mov    %edx,0x8(%ebp)
  800b9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba0:	8a 12                	mov    (%edx),%dl
  800ba2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba7:	8a 00                	mov    (%eax),%al
  800ba9:	84 c0                	test   %al,%al
  800bab:	74 03                	je     800bb0 <strncpy+0x31>
			src++;
  800bad:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bb0:	ff 45 fc             	incl   -0x4(%ebp)
  800bb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bb6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bb9:	72 d9                	jb     800b94 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800bbb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bcc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bd0:	74 30                	je     800c02 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bd2:	eb 16                	jmp    800bea <strlcpy+0x2a>
			*dst++ = *src++;
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	8d 50 01             	lea    0x1(%eax),%edx
  800bda:	89 55 08             	mov    %edx,0x8(%ebp)
  800bdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800be3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800be6:	8a 12                	mov    (%edx),%dl
  800be8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bea:	ff 4d 10             	decl   0x10(%ebp)
  800bed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bf1:	74 09                	je     800bfc <strlcpy+0x3c>
  800bf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf6:	8a 00                	mov    (%eax),%al
  800bf8:	84 c0                	test   %al,%al
  800bfa:	75 d8                	jne    800bd4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c02:	8b 55 08             	mov    0x8(%ebp),%edx
  800c05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c08:	29 c2                	sub    %eax,%edx
  800c0a:	89 d0                	mov    %edx,%eax
}
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c11:	eb 06                	jmp    800c19 <strcmp+0xb>
		p++, q++;
  800c13:	ff 45 08             	incl   0x8(%ebp)
  800c16:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	8a 00                	mov    (%eax),%al
  800c1e:	84 c0                	test   %al,%al
  800c20:	74 0e                	je     800c30 <strcmp+0x22>
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	8a 10                	mov    (%eax),%dl
  800c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2a:	8a 00                	mov    (%eax),%al
  800c2c:	38 c2                	cmp    %al,%dl
  800c2e:	74 e3                	je     800c13 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	8a 00                	mov    (%eax),%al
  800c35:	0f b6 d0             	movzbl %al,%edx
  800c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3b:	8a 00                	mov    (%eax),%al
  800c3d:	0f b6 c0             	movzbl %al,%eax
  800c40:	29 c2                	sub    %eax,%edx
  800c42:	89 d0                	mov    %edx,%eax
}
  800c44:	5d                   	pop    %ebp
  800c45:	c3                   	ret    

00800c46 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c49:	eb 09                	jmp    800c54 <strncmp+0xe>
		n--, p++, q++;
  800c4b:	ff 4d 10             	decl   0x10(%ebp)
  800c4e:	ff 45 08             	incl   0x8(%ebp)
  800c51:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c54:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c58:	74 17                	je     800c71 <strncmp+0x2b>
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	8a 00                	mov    (%eax),%al
  800c5f:	84 c0                	test   %al,%al
  800c61:	74 0e                	je     800c71 <strncmp+0x2b>
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	8a 10                	mov    (%eax),%dl
  800c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	38 c2                	cmp    %al,%dl
  800c6f:	74 da                	je     800c4b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c75:	75 07                	jne    800c7e <strncmp+0x38>
		return 0;
  800c77:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7c:	eb 14                	jmp    800c92 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8a 00                	mov    (%eax),%al
  800c83:	0f b6 d0             	movzbl %al,%edx
  800c86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c89:	8a 00                	mov    (%eax),%al
  800c8b:	0f b6 c0             	movzbl %al,%eax
  800c8e:	29 c2                	sub    %eax,%edx
  800c90:	89 d0                	mov    %edx,%eax
}
  800c92:	5d                   	pop    %ebp
  800c93:	c3                   	ret    

00800c94 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	83 ec 04             	sub    $0x4,%esp
  800c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ca0:	eb 12                	jmp    800cb4 <strchr+0x20>
		if (*s == c)
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	8a 00                	mov    (%eax),%al
  800ca7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800caa:	75 05                	jne    800cb1 <strchr+0x1d>
			return (char *) s;
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	eb 11                	jmp    800cc2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cb1:	ff 45 08             	incl   0x8(%ebp)
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	8a 00                	mov    (%eax),%al
  800cb9:	84 c0                	test   %al,%al
  800cbb:	75 e5                	jne    800ca2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cc2:	c9                   	leave  
  800cc3:	c3                   	ret    

00800cc4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	83 ec 04             	sub    $0x4,%esp
  800cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cd0:	eb 0d                	jmp    800cdf <strfind+0x1b>
		if (*s == c)
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cda:	74 0e                	je     800cea <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cdc:	ff 45 08             	incl   0x8(%ebp)
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	8a 00                	mov    (%eax),%al
  800ce4:	84 c0                	test   %al,%al
  800ce6:	75 ea                	jne    800cd2 <strfind+0xe>
  800ce8:	eb 01                	jmp    800ceb <strfind+0x27>
		if (*s == c)
			break;
  800cea:	90                   	nop
	return (char *) s;
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cee:	c9                   	leave  
  800cef:	c3                   	ret    

00800cf0 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cfc:	8b 45 10             	mov    0x10(%ebp),%eax
  800cff:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d02:	eb 0e                	jmp    800d12 <memset+0x22>
		*p++ = c;
  800d04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d07:	8d 50 01             	lea    0x1(%eax),%edx
  800d0a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d10:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d12:	ff 4d f8             	decl   -0x8(%ebp)
  800d15:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d19:	79 e9                	jns    800d04 <memset+0x14>
		*p++ = c;

	return v;
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d1e:	c9                   	leave  
  800d1f:	c3                   	ret    

00800d20 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d32:	eb 16                	jmp    800d4a <memcpy+0x2a>
		*d++ = *s++;
  800d34:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d37:	8d 50 01             	lea    0x1(%eax),%edx
  800d3a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d3d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d40:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d43:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d46:	8a 12                	mov    (%edx),%dl
  800d48:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d50:	89 55 10             	mov    %edx,0x10(%ebp)
  800d53:	85 c0                	test   %eax,%eax
  800d55:	75 dd                	jne    800d34 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d5a:	c9                   	leave  
  800d5b:	c3                   	ret    

00800d5c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
  800d5f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d71:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d74:	73 50                	jae    800dc6 <memmove+0x6a>
  800d76:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d79:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7c:	01 d0                	add    %edx,%eax
  800d7e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d81:	76 43                	jbe    800dc6 <memmove+0x6a>
		s += n;
  800d83:	8b 45 10             	mov    0x10(%ebp),%eax
  800d86:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d89:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d8f:	eb 10                	jmp    800da1 <memmove+0x45>
			*--d = *--s;
  800d91:	ff 4d f8             	decl   -0x8(%ebp)
  800d94:	ff 4d fc             	decl   -0x4(%ebp)
  800d97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d9a:	8a 10                	mov    (%eax),%dl
  800d9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d9f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800da1:	8b 45 10             	mov    0x10(%ebp),%eax
  800da4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da7:	89 55 10             	mov    %edx,0x10(%ebp)
  800daa:	85 c0                	test   %eax,%eax
  800dac:	75 e3                	jne    800d91 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dae:	eb 23                	jmp    800dd3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800db0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db3:	8d 50 01             	lea    0x1(%eax),%edx
  800db6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800db9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dbc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dbf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dc2:	8a 12                	mov    (%edx),%dl
  800dc4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dc6:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dcc:	89 55 10             	mov    %edx,0x10(%ebp)
  800dcf:	85 c0                	test   %eax,%eax
  800dd1:	75 dd                	jne    800db0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd6:	c9                   	leave  
  800dd7:	c3                   	ret    

00800dd8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800de4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dea:	eb 2a                	jmp    800e16 <memcmp+0x3e>
		if (*s1 != *s2)
  800dec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800def:	8a 10                	mov    (%eax),%dl
  800df1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df4:	8a 00                	mov    (%eax),%al
  800df6:	38 c2                	cmp    %al,%dl
  800df8:	74 16                	je     800e10 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dfd:	8a 00                	mov    (%eax),%al
  800dff:	0f b6 d0             	movzbl %al,%edx
  800e02:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e05:	8a 00                	mov    (%eax),%al
  800e07:	0f b6 c0             	movzbl %al,%eax
  800e0a:	29 c2                	sub    %eax,%edx
  800e0c:	89 d0                	mov    %edx,%eax
  800e0e:	eb 18                	jmp    800e28 <memcmp+0x50>
		s1++, s2++;
  800e10:	ff 45 fc             	incl   -0x4(%ebp)
  800e13:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e16:	8b 45 10             	mov    0x10(%ebp),%eax
  800e19:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e1c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1f:	85 c0                	test   %eax,%eax
  800e21:	75 c9                	jne    800dec <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e28:	c9                   	leave  
  800e29:	c3                   	ret    

00800e2a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e30:	8b 55 08             	mov    0x8(%ebp),%edx
  800e33:	8b 45 10             	mov    0x10(%ebp),%eax
  800e36:	01 d0                	add    %edx,%eax
  800e38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e3b:	eb 15                	jmp    800e52 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8a 00                	mov    (%eax),%al
  800e42:	0f b6 d0             	movzbl %al,%edx
  800e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e48:	0f b6 c0             	movzbl %al,%eax
  800e4b:	39 c2                	cmp    %eax,%edx
  800e4d:	74 0d                	je     800e5c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e4f:	ff 45 08             	incl   0x8(%ebp)
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e58:	72 e3                	jb     800e3d <memfind+0x13>
  800e5a:	eb 01                	jmp    800e5d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e5c:	90                   	nop
	return (void *) s;
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e60:	c9                   	leave  
  800e61:	c3                   	ret    

00800e62 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e6f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e76:	eb 03                	jmp    800e7b <strtol+0x19>
		s++;
  800e78:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	8a 00                	mov    (%eax),%al
  800e80:	3c 20                	cmp    $0x20,%al
  800e82:	74 f4                	je     800e78 <strtol+0x16>
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8a 00                	mov    (%eax),%al
  800e89:	3c 09                	cmp    $0x9,%al
  800e8b:	74 eb                	je     800e78 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e90:	8a 00                	mov    (%eax),%al
  800e92:	3c 2b                	cmp    $0x2b,%al
  800e94:	75 05                	jne    800e9b <strtol+0x39>
		s++;
  800e96:	ff 45 08             	incl   0x8(%ebp)
  800e99:	eb 13                	jmp    800eae <strtol+0x4c>
	else if (*s == '-')
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	8a 00                	mov    (%eax),%al
  800ea0:	3c 2d                	cmp    $0x2d,%al
  800ea2:	75 0a                	jne    800eae <strtol+0x4c>
		s++, neg = 1;
  800ea4:	ff 45 08             	incl   0x8(%ebp)
  800ea7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb2:	74 06                	je     800eba <strtol+0x58>
  800eb4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800eb8:	75 20                	jne    800eda <strtol+0x78>
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	8a 00                	mov    (%eax),%al
  800ebf:	3c 30                	cmp    $0x30,%al
  800ec1:	75 17                	jne    800eda <strtol+0x78>
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	40                   	inc    %eax
  800ec7:	8a 00                	mov    (%eax),%al
  800ec9:	3c 78                	cmp    $0x78,%al
  800ecb:	75 0d                	jne    800eda <strtol+0x78>
		s += 2, base = 16;
  800ecd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ed1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ed8:	eb 28                	jmp    800f02 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800eda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ede:	75 15                	jne    800ef5 <strtol+0x93>
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	8a 00                	mov    (%eax),%al
  800ee5:	3c 30                	cmp    $0x30,%al
  800ee7:	75 0c                	jne    800ef5 <strtol+0x93>
		s++, base = 8;
  800ee9:	ff 45 08             	incl   0x8(%ebp)
  800eec:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ef3:	eb 0d                	jmp    800f02 <strtol+0xa0>
	else if (base == 0)
  800ef5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef9:	75 07                	jne    800f02 <strtol+0xa0>
		base = 10;
  800efb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	3c 2f                	cmp    $0x2f,%al
  800f09:	7e 19                	jle    800f24 <strtol+0xc2>
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	8a 00                	mov    (%eax),%al
  800f10:	3c 39                	cmp    $0x39,%al
  800f12:	7f 10                	jg     800f24 <strtol+0xc2>
			dig = *s - '0';
  800f14:	8b 45 08             	mov    0x8(%ebp),%eax
  800f17:	8a 00                	mov    (%eax),%al
  800f19:	0f be c0             	movsbl %al,%eax
  800f1c:	83 e8 30             	sub    $0x30,%eax
  800f1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f22:	eb 42                	jmp    800f66 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
  800f27:	8a 00                	mov    (%eax),%al
  800f29:	3c 60                	cmp    $0x60,%al
  800f2b:	7e 19                	jle    800f46 <strtol+0xe4>
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	8a 00                	mov    (%eax),%al
  800f32:	3c 7a                	cmp    $0x7a,%al
  800f34:	7f 10                	jg     800f46 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	8a 00                	mov    (%eax),%al
  800f3b:	0f be c0             	movsbl %al,%eax
  800f3e:	83 e8 57             	sub    $0x57,%eax
  800f41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f44:	eb 20                	jmp    800f66 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	3c 40                	cmp    $0x40,%al
  800f4d:	7e 39                	jle    800f88 <strtol+0x126>
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	8a 00                	mov    (%eax),%al
  800f54:	3c 5a                	cmp    $0x5a,%al
  800f56:	7f 30                	jg     800f88 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f58:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5b:	8a 00                	mov    (%eax),%al
  800f5d:	0f be c0             	movsbl %al,%eax
  800f60:	83 e8 37             	sub    $0x37,%eax
  800f63:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f69:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f6c:	7d 19                	jge    800f87 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f6e:	ff 45 08             	incl   0x8(%ebp)
  800f71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f74:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f78:	89 c2                	mov    %eax,%edx
  800f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f7d:	01 d0                	add    %edx,%eax
  800f7f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f82:	e9 7b ff ff ff       	jmp    800f02 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f87:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f8c:	74 08                	je     800f96 <strtol+0x134>
		*endptr = (char *) s;
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	8b 55 08             	mov    0x8(%ebp),%edx
  800f94:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f96:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f9a:	74 07                	je     800fa3 <strtol+0x141>
  800f9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9f:	f7 d8                	neg    %eax
  800fa1:	eb 03                	jmp    800fa6 <strtol+0x144>
  800fa3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fa6:	c9                   	leave  
  800fa7:	c3                   	ret    

00800fa8 <ltostr>:

void
ltostr(long value, char *str)
{
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
  800fab:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fb5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fbc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fc0:	79 13                	jns    800fd5 <ltostr+0x2d>
	{
		neg = 1;
  800fc2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fcf:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fd2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fdd:	99                   	cltd   
  800fde:	f7 f9                	idiv   %ecx
  800fe0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fe3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe6:	8d 50 01             	lea    0x1(%eax),%edx
  800fe9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fec:	89 c2                	mov    %eax,%edx
  800fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff1:	01 d0                	add    %edx,%eax
  800ff3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ff6:	83 c2 30             	add    $0x30,%edx
  800ff9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ffb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ffe:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801003:	f7 e9                	imul   %ecx
  801005:	c1 fa 02             	sar    $0x2,%edx
  801008:	89 c8                	mov    %ecx,%eax
  80100a:	c1 f8 1f             	sar    $0x1f,%eax
  80100d:	29 c2                	sub    %eax,%edx
  80100f:	89 d0                	mov    %edx,%eax
  801011:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801014:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801018:	75 bb                	jne    800fd5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80101a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801021:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801024:	48                   	dec    %eax
  801025:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801028:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80102c:	74 3d                	je     80106b <ltostr+0xc3>
		start = 1 ;
  80102e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801035:	eb 34                	jmp    80106b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801037:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103d:	01 d0                	add    %edx,%eax
  80103f:	8a 00                	mov    (%eax),%al
  801041:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801044:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801047:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104a:	01 c2                	add    %eax,%edx
  80104c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80104f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801052:	01 c8                	add    %ecx,%eax
  801054:	8a 00                	mov    (%eax),%al
  801056:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801058:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	01 c2                	add    %eax,%edx
  801060:	8a 45 eb             	mov    -0x15(%ebp),%al
  801063:	88 02                	mov    %al,(%edx)
		start++ ;
  801065:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801068:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80106b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801071:	7c c4                	jl     801037 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801073:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801076:	8b 45 0c             	mov    0xc(%ebp),%eax
  801079:	01 d0                	add    %edx,%eax
  80107b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80107e:	90                   	nop
  80107f:	c9                   	leave  
  801080:	c3                   	ret    

00801081 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801087:	ff 75 08             	pushl  0x8(%ebp)
  80108a:	e8 73 fa ff ff       	call   800b02 <strlen>
  80108f:	83 c4 04             	add    $0x4,%esp
  801092:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801095:	ff 75 0c             	pushl  0xc(%ebp)
  801098:	e8 65 fa ff ff       	call   800b02 <strlen>
  80109d:	83 c4 04             	add    $0x4,%esp
  8010a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010b1:	eb 17                	jmp    8010ca <strcconcat+0x49>
		final[s] = str1[s] ;
  8010b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b9:	01 c2                	add    %eax,%edx
  8010bb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	01 c8                	add    %ecx,%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010c7:	ff 45 fc             	incl   -0x4(%ebp)
  8010ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010d0:	7c e1                	jl     8010b3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010d9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010e0:	eb 1f                	jmp    801101 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e5:	8d 50 01             	lea    0x1(%eax),%edx
  8010e8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010eb:	89 c2                	mov    %eax,%edx
  8010ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f0:	01 c2                	add    %eax,%edx
  8010f2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f8:	01 c8                	add    %ecx,%eax
  8010fa:	8a 00                	mov    (%eax),%al
  8010fc:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010fe:	ff 45 f8             	incl   -0x8(%ebp)
  801101:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801104:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801107:	7c d9                	jl     8010e2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801109:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80110c:	8b 45 10             	mov    0x10(%ebp),%eax
  80110f:	01 d0                	add    %edx,%eax
  801111:	c6 00 00             	movb   $0x0,(%eax)
}
  801114:	90                   	nop
  801115:	c9                   	leave  
  801116:	c3                   	ret    

00801117 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80111a:	8b 45 14             	mov    0x14(%ebp),%eax
  80111d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801123:	8b 45 14             	mov    0x14(%ebp),%eax
  801126:	8b 00                	mov    (%eax),%eax
  801128:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80112f:	8b 45 10             	mov    0x10(%ebp),%eax
  801132:	01 d0                	add    %edx,%eax
  801134:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80113a:	eb 0c                	jmp    801148 <strsplit+0x31>
			*string++ = 0;
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8d 50 01             	lea    0x1(%eax),%edx
  801142:	89 55 08             	mov    %edx,0x8(%ebp)
  801145:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	84 c0                	test   %al,%al
  80114f:	74 18                	je     801169 <strsplit+0x52>
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	0f be c0             	movsbl %al,%eax
  801159:	50                   	push   %eax
  80115a:	ff 75 0c             	pushl  0xc(%ebp)
  80115d:	e8 32 fb ff ff       	call   800c94 <strchr>
  801162:	83 c4 08             	add    $0x8,%esp
  801165:	85 c0                	test   %eax,%eax
  801167:	75 d3                	jne    80113c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	8a 00                	mov    (%eax),%al
  80116e:	84 c0                	test   %al,%al
  801170:	74 5a                	je     8011cc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801172:	8b 45 14             	mov    0x14(%ebp),%eax
  801175:	8b 00                	mov    (%eax),%eax
  801177:	83 f8 0f             	cmp    $0xf,%eax
  80117a:	75 07                	jne    801183 <strsplit+0x6c>
		{
			return 0;
  80117c:	b8 00 00 00 00       	mov    $0x0,%eax
  801181:	eb 66                	jmp    8011e9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801183:	8b 45 14             	mov    0x14(%ebp),%eax
  801186:	8b 00                	mov    (%eax),%eax
  801188:	8d 48 01             	lea    0x1(%eax),%ecx
  80118b:	8b 55 14             	mov    0x14(%ebp),%edx
  80118e:	89 0a                	mov    %ecx,(%edx)
  801190:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801197:	8b 45 10             	mov    0x10(%ebp),%eax
  80119a:	01 c2                	add    %eax,%edx
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011a1:	eb 03                	jmp    8011a6 <strsplit+0x8f>
			string++;
  8011a3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	8a 00                	mov    (%eax),%al
  8011ab:	84 c0                	test   %al,%al
  8011ad:	74 8b                	je     80113a <strsplit+0x23>
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	8a 00                	mov    (%eax),%al
  8011b4:	0f be c0             	movsbl %al,%eax
  8011b7:	50                   	push   %eax
  8011b8:	ff 75 0c             	pushl  0xc(%ebp)
  8011bb:	e8 d4 fa ff ff       	call   800c94 <strchr>
  8011c0:	83 c4 08             	add    $0x8,%esp
  8011c3:	85 c0                	test   %eax,%eax
  8011c5:	74 dc                	je     8011a3 <strsplit+0x8c>
			string++;
	}
  8011c7:	e9 6e ff ff ff       	jmp    80113a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011cc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d0:	8b 00                	mov    (%eax),%eax
  8011d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dc:	01 d0                	add    %edx,%eax
  8011de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011e4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011e9:	c9                   	leave  
  8011ea:	c3                   	ret    

008011eb <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011eb:	55                   	push   %ebp
  8011ec:	89 e5                	mov    %esp,%ebp
  8011ee:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8011f1:	83 ec 04             	sub    $0x4,%esp
  8011f4:	68 68 21 80 00       	push   $0x802168
  8011f9:	68 3f 01 00 00       	push   $0x13f
  8011fe:	68 8a 21 80 00       	push   $0x80218a
  801203:	e8 a9 ef ff ff       	call   8001b1 <_panic>

00801208 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
  80120b:	57                   	push   %edi
  80120c:	56                   	push   %esi
  80120d:	53                   	push   %ebx
  80120e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8b 55 0c             	mov    0xc(%ebp),%edx
  801217:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80121a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80121d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801220:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801223:	cd 30                	int    $0x30
  801225:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801228:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80122b:	83 c4 10             	add    $0x10,%esp
  80122e:	5b                   	pop    %ebx
  80122f:	5e                   	pop    %esi
  801230:	5f                   	pop    %edi
  801231:	5d                   	pop    %ebp
  801232:	c3                   	ret    

00801233 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801233:	55                   	push   %ebp
  801234:	89 e5                	mov    %esp,%ebp
  801236:	83 ec 04             	sub    $0x4,%esp
  801239:	8b 45 10             	mov    0x10(%ebp),%eax
  80123c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  80123f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
  801246:	6a 00                	push   $0x0
  801248:	6a 00                	push   $0x0
  80124a:	52                   	push   %edx
  80124b:	ff 75 0c             	pushl  0xc(%ebp)
  80124e:	50                   	push   %eax
  80124f:	6a 00                	push   $0x0
  801251:	e8 b2 ff ff ff       	call   801208 <syscall>
  801256:	83 c4 18             	add    $0x18,%esp
}
  801259:	90                   	nop
  80125a:	c9                   	leave  
  80125b:	c3                   	ret    

0080125c <sys_cgetc>:

int sys_cgetc(void) {
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80125f:	6a 00                	push   $0x0
  801261:	6a 00                	push   $0x0
  801263:	6a 00                	push   $0x0
  801265:	6a 00                	push   $0x0
  801267:	6a 00                	push   $0x0
  801269:	6a 02                	push   $0x2
  80126b:	e8 98 ff ff ff       	call   801208 <syscall>
  801270:	83 c4 18             	add    $0x18,%esp
}
  801273:	c9                   	leave  
  801274:	c3                   	ret    

00801275 <sys_lock_cons>:

void sys_lock_cons(void) {
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801278:	6a 00                	push   $0x0
  80127a:	6a 00                	push   $0x0
  80127c:	6a 00                	push   $0x0
  80127e:	6a 00                	push   $0x0
  801280:	6a 00                	push   $0x0
  801282:	6a 03                	push   $0x3
  801284:	e8 7f ff ff ff       	call   801208 <syscall>
  801289:	83 c4 18             	add    $0x18,%esp
}
  80128c:	90                   	nop
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    

0080128f <sys_unlock_cons>:
void sys_unlock_cons(void) {
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801292:	6a 00                	push   $0x0
  801294:	6a 00                	push   $0x0
  801296:	6a 00                	push   $0x0
  801298:	6a 00                	push   $0x0
  80129a:	6a 00                	push   $0x0
  80129c:	6a 04                	push   $0x4
  80129e:	e8 65 ff ff ff       	call   801208 <syscall>
  8012a3:	83 c4 18             	add    $0x18,%esp
}
  8012a6:	90                   	nop
  8012a7:	c9                   	leave  
  8012a8:	c3                   	ret    

008012a9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  8012ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	6a 00                	push   $0x0
  8012b4:	6a 00                	push   $0x0
  8012b6:	6a 00                	push   $0x0
  8012b8:	52                   	push   %edx
  8012b9:	50                   	push   %eax
  8012ba:	6a 08                	push   $0x8
  8012bc:	e8 47 ff ff ff       	call   801208 <syscall>
  8012c1:	83 c4 18             	add    $0x18,%esp
}
  8012c4:	c9                   	leave  
  8012c5:	c3                   	ret    

008012c6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  8012c6:	55                   	push   %ebp
  8012c7:	89 e5                	mov    %esp,%ebp
  8012c9:	56                   	push   %esi
  8012ca:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  8012cb:	8b 75 18             	mov    0x18(%ebp),%esi
  8012ce:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012d1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012da:	56                   	push   %esi
  8012db:	53                   	push   %ebx
  8012dc:	51                   	push   %ecx
  8012dd:	52                   	push   %edx
  8012de:	50                   	push   %eax
  8012df:	6a 09                	push   $0x9
  8012e1:	e8 22 ff ff ff       	call   801208 <syscall>
  8012e6:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  8012e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012ec:	5b                   	pop    %ebx
  8012ed:	5e                   	pop    %esi
  8012ee:	5d                   	pop    %ebp
  8012ef:	c3                   	ret    

008012f0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f9:	6a 00                	push   $0x0
  8012fb:	6a 00                	push   $0x0
  8012fd:	6a 00                	push   $0x0
  8012ff:	52                   	push   %edx
  801300:	50                   	push   %eax
  801301:	6a 0a                	push   $0xa
  801303:	e8 00 ff ff ff       	call   801208 <syscall>
  801308:	83 c4 18             	add    $0x18,%esp
}
  80130b:	c9                   	leave  
  80130c:	c3                   	ret    

0080130d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801310:	6a 00                	push   $0x0
  801312:	6a 00                	push   $0x0
  801314:	6a 00                	push   $0x0
  801316:	ff 75 0c             	pushl  0xc(%ebp)
  801319:	ff 75 08             	pushl  0x8(%ebp)
  80131c:	6a 0b                	push   $0xb
  80131e:	e8 e5 fe ff ff       	call   801208 <syscall>
  801323:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801326:	c9                   	leave  
  801327:	c3                   	ret    

00801328 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80132b:	6a 00                	push   $0x0
  80132d:	6a 00                	push   $0x0
  80132f:	6a 00                	push   $0x0
  801331:	6a 00                	push   $0x0
  801333:	6a 00                	push   $0x0
  801335:	6a 0c                	push   $0xc
  801337:	e8 cc fe ff ff       	call   801208 <syscall>
  80133c:	83 c4 18             	add    $0x18,%esp
}
  80133f:	c9                   	leave  
  801340:	c3                   	ret    

00801341 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801344:	6a 00                	push   $0x0
  801346:	6a 00                	push   $0x0
  801348:	6a 00                	push   $0x0
  80134a:	6a 00                	push   $0x0
  80134c:	6a 00                	push   $0x0
  80134e:	6a 0d                	push   $0xd
  801350:	e8 b3 fe ff ff       	call   801208 <syscall>
  801355:	83 c4 18             	add    $0x18,%esp
}
  801358:	c9                   	leave  
  801359:	c3                   	ret    

0080135a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80135d:	6a 00                	push   $0x0
  80135f:	6a 00                	push   $0x0
  801361:	6a 00                	push   $0x0
  801363:	6a 00                	push   $0x0
  801365:	6a 00                	push   $0x0
  801367:	6a 0e                	push   $0xe
  801369:	e8 9a fe ff ff       	call   801208 <syscall>
  80136e:	83 c4 18             	add    $0x18,%esp
}
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801376:	6a 00                	push   $0x0
  801378:	6a 00                	push   $0x0
  80137a:	6a 00                	push   $0x0
  80137c:	6a 00                	push   $0x0
  80137e:	6a 00                	push   $0x0
  801380:	6a 0f                	push   $0xf
  801382:	e8 81 fe ff ff       	call   801208 <syscall>
  801387:	83 c4 18             	add    $0x18,%esp
}
  80138a:	c9                   	leave  
  80138b:	c3                   	ret    

0080138c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  80138f:	6a 00                	push   $0x0
  801391:	6a 00                	push   $0x0
  801393:	6a 00                	push   $0x0
  801395:	6a 00                	push   $0x0
  801397:	ff 75 08             	pushl  0x8(%ebp)
  80139a:	6a 10                	push   $0x10
  80139c:	e8 67 fe ff ff       	call   801208 <syscall>
  8013a1:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  8013a4:	c9                   	leave  
  8013a5:	c3                   	ret    

008013a6 <sys_scarce_memory>:

void sys_scarce_memory() {
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  8013a9:	6a 00                	push   $0x0
  8013ab:	6a 00                	push   $0x0
  8013ad:	6a 00                	push   $0x0
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 11                	push   $0x11
  8013b5:	e8 4e fe ff ff       	call   801208 <syscall>
  8013ba:	83 c4 18             	add    $0x18,%esp
}
  8013bd:	90                   	nop
  8013be:	c9                   	leave  
  8013bf:	c3                   	ret    

008013c0 <sys_cputc>:

void sys_cputc(const char c) {
  8013c0:	55                   	push   %ebp
  8013c1:	89 e5                	mov    %esp,%ebp
  8013c3:	83 ec 04             	sub    $0x4,%esp
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013cc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	50                   	push   %eax
  8013d9:	6a 01                	push   $0x1
  8013db:	e8 28 fe ff ff       	call   801208 <syscall>
  8013e0:	83 c4 18             	add    $0x18,%esp
}
  8013e3:	90                   	nop
  8013e4:	c9                   	leave  
  8013e5:	c3                   	ret    

008013e6 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  8013e6:	55                   	push   %ebp
  8013e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 14                	push   $0x14
  8013f5:	e8 0e fe ff ff       	call   801208 <syscall>
  8013fa:	83 c4 18             	add    $0x18,%esp
}
  8013fd:	90                   	nop
  8013fe:	c9                   	leave  
  8013ff:	c3                   	ret    

00801400 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
  801403:	83 ec 04             	sub    $0x4,%esp
  801406:	8b 45 10             	mov    0x10(%ebp),%eax
  801409:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  80140c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80140f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	6a 00                	push   $0x0
  801418:	51                   	push   %ecx
  801419:	52                   	push   %edx
  80141a:	ff 75 0c             	pushl  0xc(%ebp)
  80141d:	50                   	push   %eax
  80141e:	6a 15                	push   $0x15
  801420:	e8 e3 fd ff ff       	call   801208 <syscall>
  801425:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801428:	c9                   	leave  
  801429:	c3                   	ret    

0080142a <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  80142d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	6a 00                	push   $0x0
  801435:	6a 00                	push   $0x0
  801437:	6a 00                	push   $0x0
  801439:	52                   	push   %edx
  80143a:	50                   	push   %eax
  80143b:	6a 16                	push   $0x16
  80143d:	e8 c6 fd ff ff       	call   801208 <syscall>
  801442:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  80144a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80144d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	6a 00                	push   $0x0
  801455:	6a 00                	push   $0x0
  801457:	51                   	push   %ecx
  801458:	52                   	push   %edx
  801459:	50                   	push   %eax
  80145a:	6a 17                	push   $0x17
  80145c:	e8 a7 fd ff ff       	call   801208 <syscall>
  801461:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801464:	c9                   	leave  
  801465:	c3                   	ret    

00801466 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	52                   	push   %edx
  801476:	50                   	push   %eax
  801477:	6a 18                	push   $0x18
  801479:	e8 8a fd ff ff       	call   801208 <syscall>
  80147e:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	6a 00                	push   $0x0
  80148b:	ff 75 14             	pushl  0x14(%ebp)
  80148e:	ff 75 10             	pushl  0x10(%ebp)
  801491:	ff 75 0c             	pushl  0xc(%ebp)
  801494:	50                   	push   %eax
  801495:	6a 19                	push   $0x19
  801497:	e8 6c fd ff ff       	call   801208 <syscall>
  80149c:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  80149f:	c9                   	leave  
  8014a0:	c3                   	ret    

008014a1 <sys_run_env>:

void sys_run_env(int32 envId) {
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	50                   	push   %eax
  8014b0:	6a 1a                	push   $0x1a
  8014b2:	e8 51 fd ff ff       	call   801208 <syscall>
  8014b7:	83 c4 18             	add    $0x18,%esp
}
  8014ba:	90                   	nop
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    

008014bd <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	50                   	push   %eax
  8014cc:	6a 1b                	push   $0x1b
  8014ce:	e8 35 fd ff ff       	call   801208 <syscall>
  8014d3:	83 c4 18             	add    $0x18,%esp
}
  8014d6:	c9                   	leave  
  8014d7:	c3                   	ret    

008014d8 <sys_getenvid>:

int32 sys_getenvid(void) {
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 00                	push   $0x0
  8014e1:	6a 00                	push   $0x0
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 05                	push   $0x5
  8014e7:	e8 1c fd ff ff       	call   801208 <syscall>
  8014ec:	83 c4 18             	add    $0x18,%esp
}
  8014ef:	c9                   	leave  
  8014f0:	c3                   	ret    

008014f1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 06                	push   $0x6
  801500:	e8 03 fd ff ff       	call   801208 <syscall>
  801505:	83 c4 18             	add    $0x18,%esp
}
  801508:	c9                   	leave  
  801509:	c3                   	ret    

0080150a <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	6a 07                	push   $0x7
  801519:	e8 ea fc ff ff       	call   801208 <syscall>
  80151e:	83 c4 18             	add    $0x18,%esp
}
  801521:	c9                   	leave  
  801522:	c3                   	ret    

00801523 <sys_exit_env>:

void sys_exit_env(void) {
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 1c                	push   $0x1c
  801532:	e8 d1 fc ff ff       	call   801208 <syscall>
  801537:	83 c4 18             	add    $0x18,%esp
}
  80153a:	90                   	nop
  80153b:	c9                   	leave  
  80153c:	c3                   	ret    

0080153d <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
  801540:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801543:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801546:	8d 50 04             	lea    0x4(%eax),%edx
  801549:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	52                   	push   %edx
  801553:	50                   	push   %eax
  801554:	6a 1d                	push   $0x1d
  801556:	e8 ad fc ff ff       	call   801208 <syscall>
  80155b:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  80155e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801561:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801564:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801567:	89 01                	mov    %eax,(%ecx)
  801569:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80156c:	8b 45 08             	mov    0x8(%ebp),%eax
  80156f:	c9                   	leave  
  801570:	c2 04 00             	ret    $0x4

00801573 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	ff 75 10             	pushl  0x10(%ebp)
  80157d:	ff 75 0c             	pushl  0xc(%ebp)
  801580:	ff 75 08             	pushl  0x8(%ebp)
  801583:	6a 13                	push   $0x13
  801585:	e8 7e fc ff ff       	call   801208 <syscall>
  80158a:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  80158d:	90                   	nop
}
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    

00801590 <sys_rcr2>:
uint32 sys_rcr2() {
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 1e                	push   $0x1e
  80159f:	e8 64 fc ff ff       	call   801208 <syscall>
  8015a4:	83 c4 18             	add    $0x18,%esp
}
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
  8015ac:	83 ec 04             	sub    $0x4,%esp
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015b5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	50                   	push   %eax
  8015c2:	6a 1f                	push   $0x1f
  8015c4:	e8 3f fc ff ff       	call   801208 <syscall>
  8015c9:	83 c4 18             	add    $0x18,%esp
	return;
  8015cc:	90                   	nop
}
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    

008015cf <rsttst>:
void rsttst() {
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 21                	push   $0x21
  8015de:	e8 25 fc ff ff       	call   801208 <syscall>
  8015e3:	83 c4 18             	add    $0x18,%esp
	return;
  8015e6:	90                   	nop
}
  8015e7:	c9                   	leave  
  8015e8:	c3                   	ret    

008015e9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	83 ec 04             	sub    $0x4,%esp
  8015ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8015f2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015f5:	8b 55 18             	mov    0x18(%ebp),%edx
  8015f8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015fc:	52                   	push   %edx
  8015fd:	50                   	push   %eax
  8015fe:	ff 75 10             	pushl  0x10(%ebp)
  801601:	ff 75 0c             	pushl  0xc(%ebp)
  801604:	ff 75 08             	pushl  0x8(%ebp)
  801607:	6a 20                	push   $0x20
  801609:	e8 fa fb ff ff       	call   801208 <syscall>
  80160e:	83 c4 18             	add    $0x18,%esp
	return;
  801611:	90                   	nop
}
  801612:	c9                   	leave  
  801613:	c3                   	ret    

00801614 <chktst>:
void chktst(uint32 n) {
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	ff 75 08             	pushl  0x8(%ebp)
  801622:	6a 22                	push   $0x22
  801624:	e8 df fb ff ff       	call   801208 <syscall>
  801629:	83 c4 18             	add    $0x18,%esp
	return;
  80162c:	90                   	nop
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <inctst>:

void inctst() {
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 23                	push   $0x23
  80163e:	e8 c5 fb ff ff       	call   801208 <syscall>
  801643:	83 c4 18             	add    $0x18,%esp
	return;
  801646:	90                   	nop
}
  801647:	c9                   	leave  
  801648:	c3                   	ret    

00801649 <gettst>:
uint32 gettst() {
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 24                	push   $0x24
  801658:	e8 ab fb ff ff       	call   801208 <syscall>
  80165d:	83 c4 18             	add    $0x18,%esp
}
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 25                	push   $0x25
  801674:	e8 8f fb ff ff       	call   801208 <syscall>
  801679:	83 c4 18             	add    $0x18,%esp
  80167c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80167f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801683:	75 07                	jne    80168c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801685:	b8 01 00 00 00       	mov    $0x1,%eax
  80168a:	eb 05                	jmp    801691 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80168c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 25                	push   $0x25
  8016a5:	e8 5e fb ff ff       	call   801208 <syscall>
  8016aa:	83 c4 18             	add    $0x18,%esp
  8016ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016b0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016b4:	75 07                	jne    8016bd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8016bb:	eb 05                	jmp    8016c2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
  8016c7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 25                	push   $0x25
  8016d6:	e8 2d fb ff ff       	call   801208 <syscall>
  8016db:	83 c4 18             	add    $0x18,%esp
  8016de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016e1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016e5:	75 07                	jne    8016ee <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8016ec:	eb 05                	jmp    8016f3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f3:	c9                   	leave  
  8016f4:	c3                   	ret    

008016f5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 25                	push   $0x25
  801707:	e8 fc fa ff ff       	call   801208 <syscall>
  80170c:	83 c4 18             	add    $0x18,%esp
  80170f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801712:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801716:	75 07                	jne    80171f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801718:	b8 01 00 00 00       	mov    $0x1,%eax
  80171d:	eb 05                	jmp    801724 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80171f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	ff 75 08             	pushl  0x8(%ebp)
  801734:	6a 26                	push   $0x26
  801736:	e8 cd fa ff ff       	call   801208 <syscall>
  80173b:	83 c4 18             	add    $0x18,%esp
	return;
  80173e:	90                   	nop
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
  801744:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801745:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801748:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80174b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	6a 00                	push   $0x0
  801753:	53                   	push   %ebx
  801754:	51                   	push   %ecx
  801755:	52                   	push   %edx
  801756:	50                   	push   %eax
  801757:	6a 27                	push   $0x27
  801759:	e8 aa fa ff ff       	call   801208 <syscall>
  80175e:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801761:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801769:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176c:	8b 45 08             	mov    0x8(%ebp),%eax
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	52                   	push   %edx
  801776:	50                   	push   %eax
  801777:	6a 28                	push   $0x28
  801779:	e8 8a fa ff ff       	call   801208 <syscall>
  80177e:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801786:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801789:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	6a 00                	push   $0x0
  801791:	51                   	push   %ecx
  801792:	ff 75 10             	pushl  0x10(%ebp)
  801795:	52                   	push   %edx
  801796:	50                   	push   %eax
  801797:	6a 29                	push   $0x29
  801799:	e8 6a fa ff ff       	call   801208 <syscall>
  80179e:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	ff 75 10             	pushl  0x10(%ebp)
  8017ad:	ff 75 0c             	pushl  0xc(%ebp)
  8017b0:	ff 75 08             	pushl  0x8(%ebp)
  8017b3:	6a 12                	push   $0x12
  8017b5:	e8 4e fa ff ff       	call   801208 <syscall>
  8017ba:	83 c4 18             	add    $0x18,%esp
	return;
  8017bd:	90                   	nop
}
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  8017c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	52                   	push   %edx
  8017d0:	50                   	push   %eax
  8017d1:	6a 2a                	push   $0x2a
  8017d3:	e8 30 fa ff ff       	call   801208 <syscall>
  8017d8:	83 c4 18             	add    $0x18,%esp
	return;
  8017db:	90                   	nop
}
  8017dc:	c9                   	leave  
  8017dd:	c3                   	ret    

008017de <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8017e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	50                   	push   %eax
  8017ed:	6a 2b                	push   $0x2b
  8017ef:	e8 14 fa ff ff       	call   801208 <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
}
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    

008017f9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	ff 75 0c             	pushl  0xc(%ebp)
  801805:	ff 75 08             	pushl  0x8(%ebp)
  801808:	6a 2c                	push   $0x2c
  80180a:	e8 f9 f9 ff ff       	call   801208 <syscall>
  80180f:	83 c4 18             	add    $0x18,%esp
	return;
  801812:	90                   	nop
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	ff 75 0c             	pushl  0xc(%ebp)
  801821:	ff 75 08             	pushl  0x8(%ebp)
  801824:	6a 2d                	push   $0x2d
  801826:	e8 dd f9 ff ff       	call   801208 <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
	return;
  80182e:	90                   	nop
}
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801834:	8b 45 08             	mov    0x8(%ebp),%eax
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	50                   	push   %eax
  801840:	6a 2f                	push   $0x2f
  801842:	e8 c1 f9 ff ff       	call   801208 <syscall>
  801847:	83 c4 18             	add    $0x18,%esp
	return;
  80184a:	90                   	nop
}
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  801850:	8b 55 0c             	mov    0xc(%ebp),%edx
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	52                   	push   %edx
  80185d:	50                   	push   %eax
  80185e:	6a 30                	push   $0x30
  801860:	e8 a3 f9 ff ff       	call   801208 <syscall>
  801865:	83 c4 18             	add    $0x18,%esp
	return;
  801868:	90                   	nop
}
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  80186e:	8b 45 08             	mov    0x8(%ebp),%eax
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	50                   	push   %eax
  80187a:	6a 31                	push   $0x31
  80187c:	e8 87 f9 ff ff       	call   801208 <syscall>
  801881:	83 c4 18             	add    $0x18,%esp
	return;
  801884:	90                   	nop
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80188a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188d:	8b 45 08             	mov    0x8(%ebp),%eax
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	52                   	push   %edx
  801897:	50                   	push   %eax
  801898:	6a 2e                	push   $0x2e
  80189a:	e8 69 f9 ff ff       	call   801208 <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
    return;
  8018a2:	90                   	nop
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    
  8018a5:	66 90                	xchg   %ax,%ax
  8018a7:	90                   	nop

008018a8 <__udivdi3>:
  8018a8:	55                   	push   %ebp
  8018a9:	57                   	push   %edi
  8018aa:	56                   	push   %esi
  8018ab:	53                   	push   %ebx
  8018ac:	83 ec 1c             	sub    $0x1c,%esp
  8018af:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8018b3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8018b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018bb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018bf:	89 ca                	mov    %ecx,%edx
  8018c1:	89 f8                	mov    %edi,%eax
  8018c3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8018c7:	85 f6                	test   %esi,%esi
  8018c9:	75 2d                	jne    8018f8 <__udivdi3+0x50>
  8018cb:	39 cf                	cmp    %ecx,%edi
  8018cd:	77 65                	ja     801934 <__udivdi3+0x8c>
  8018cf:	89 fd                	mov    %edi,%ebp
  8018d1:	85 ff                	test   %edi,%edi
  8018d3:	75 0b                	jne    8018e0 <__udivdi3+0x38>
  8018d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8018da:	31 d2                	xor    %edx,%edx
  8018dc:	f7 f7                	div    %edi
  8018de:	89 c5                	mov    %eax,%ebp
  8018e0:	31 d2                	xor    %edx,%edx
  8018e2:	89 c8                	mov    %ecx,%eax
  8018e4:	f7 f5                	div    %ebp
  8018e6:	89 c1                	mov    %eax,%ecx
  8018e8:	89 d8                	mov    %ebx,%eax
  8018ea:	f7 f5                	div    %ebp
  8018ec:	89 cf                	mov    %ecx,%edi
  8018ee:	89 fa                	mov    %edi,%edx
  8018f0:	83 c4 1c             	add    $0x1c,%esp
  8018f3:	5b                   	pop    %ebx
  8018f4:	5e                   	pop    %esi
  8018f5:	5f                   	pop    %edi
  8018f6:	5d                   	pop    %ebp
  8018f7:	c3                   	ret    
  8018f8:	39 ce                	cmp    %ecx,%esi
  8018fa:	77 28                	ja     801924 <__udivdi3+0x7c>
  8018fc:	0f bd fe             	bsr    %esi,%edi
  8018ff:	83 f7 1f             	xor    $0x1f,%edi
  801902:	75 40                	jne    801944 <__udivdi3+0x9c>
  801904:	39 ce                	cmp    %ecx,%esi
  801906:	72 0a                	jb     801912 <__udivdi3+0x6a>
  801908:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80190c:	0f 87 9e 00 00 00    	ja     8019b0 <__udivdi3+0x108>
  801912:	b8 01 00 00 00       	mov    $0x1,%eax
  801917:	89 fa                	mov    %edi,%edx
  801919:	83 c4 1c             	add    $0x1c,%esp
  80191c:	5b                   	pop    %ebx
  80191d:	5e                   	pop    %esi
  80191e:	5f                   	pop    %edi
  80191f:	5d                   	pop    %ebp
  801920:	c3                   	ret    
  801921:	8d 76 00             	lea    0x0(%esi),%esi
  801924:	31 ff                	xor    %edi,%edi
  801926:	31 c0                	xor    %eax,%eax
  801928:	89 fa                	mov    %edi,%edx
  80192a:	83 c4 1c             	add    $0x1c,%esp
  80192d:	5b                   	pop    %ebx
  80192e:	5e                   	pop    %esi
  80192f:	5f                   	pop    %edi
  801930:	5d                   	pop    %ebp
  801931:	c3                   	ret    
  801932:	66 90                	xchg   %ax,%ax
  801934:	89 d8                	mov    %ebx,%eax
  801936:	f7 f7                	div    %edi
  801938:	31 ff                	xor    %edi,%edi
  80193a:	89 fa                	mov    %edi,%edx
  80193c:	83 c4 1c             	add    $0x1c,%esp
  80193f:	5b                   	pop    %ebx
  801940:	5e                   	pop    %esi
  801941:	5f                   	pop    %edi
  801942:	5d                   	pop    %ebp
  801943:	c3                   	ret    
  801944:	bd 20 00 00 00       	mov    $0x20,%ebp
  801949:	89 eb                	mov    %ebp,%ebx
  80194b:	29 fb                	sub    %edi,%ebx
  80194d:	89 f9                	mov    %edi,%ecx
  80194f:	d3 e6                	shl    %cl,%esi
  801951:	89 c5                	mov    %eax,%ebp
  801953:	88 d9                	mov    %bl,%cl
  801955:	d3 ed                	shr    %cl,%ebp
  801957:	89 e9                	mov    %ebp,%ecx
  801959:	09 f1                	or     %esi,%ecx
  80195b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80195f:	89 f9                	mov    %edi,%ecx
  801961:	d3 e0                	shl    %cl,%eax
  801963:	89 c5                	mov    %eax,%ebp
  801965:	89 d6                	mov    %edx,%esi
  801967:	88 d9                	mov    %bl,%cl
  801969:	d3 ee                	shr    %cl,%esi
  80196b:	89 f9                	mov    %edi,%ecx
  80196d:	d3 e2                	shl    %cl,%edx
  80196f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801973:	88 d9                	mov    %bl,%cl
  801975:	d3 e8                	shr    %cl,%eax
  801977:	09 c2                	or     %eax,%edx
  801979:	89 d0                	mov    %edx,%eax
  80197b:	89 f2                	mov    %esi,%edx
  80197d:	f7 74 24 0c          	divl   0xc(%esp)
  801981:	89 d6                	mov    %edx,%esi
  801983:	89 c3                	mov    %eax,%ebx
  801985:	f7 e5                	mul    %ebp
  801987:	39 d6                	cmp    %edx,%esi
  801989:	72 19                	jb     8019a4 <__udivdi3+0xfc>
  80198b:	74 0b                	je     801998 <__udivdi3+0xf0>
  80198d:	89 d8                	mov    %ebx,%eax
  80198f:	31 ff                	xor    %edi,%edi
  801991:	e9 58 ff ff ff       	jmp    8018ee <__udivdi3+0x46>
  801996:	66 90                	xchg   %ax,%ax
  801998:	8b 54 24 08          	mov    0x8(%esp),%edx
  80199c:	89 f9                	mov    %edi,%ecx
  80199e:	d3 e2                	shl    %cl,%edx
  8019a0:	39 c2                	cmp    %eax,%edx
  8019a2:	73 e9                	jae    80198d <__udivdi3+0xe5>
  8019a4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8019a7:	31 ff                	xor    %edi,%edi
  8019a9:	e9 40 ff ff ff       	jmp    8018ee <__udivdi3+0x46>
  8019ae:	66 90                	xchg   %ax,%ax
  8019b0:	31 c0                	xor    %eax,%eax
  8019b2:	e9 37 ff ff ff       	jmp    8018ee <__udivdi3+0x46>
  8019b7:	90                   	nop

008019b8 <__umoddi3>:
  8019b8:	55                   	push   %ebp
  8019b9:	57                   	push   %edi
  8019ba:	56                   	push   %esi
  8019bb:	53                   	push   %ebx
  8019bc:	83 ec 1c             	sub    $0x1c,%esp
  8019bf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8019c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8019c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8019cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019d7:	89 f3                	mov    %esi,%ebx
  8019d9:	89 fa                	mov    %edi,%edx
  8019db:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019df:	89 34 24             	mov    %esi,(%esp)
  8019e2:	85 c0                	test   %eax,%eax
  8019e4:	75 1a                	jne    801a00 <__umoddi3+0x48>
  8019e6:	39 f7                	cmp    %esi,%edi
  8019e8:	0f 86 a2 00 00 00    	jbe    801a90 <__umoddi3+0xd8>
  8019ee:	89 c8                	mov    %ecx,%eax
  8019f0:	89 f2                	mov    %esi,%edx
  8019f2:	f7 f7                	div    %edi
  8019f4:	89 d0                	mov    %edx,%eax
  8019f6:	31 d2                	xor    %edx,%edx
  8019f8:	83 c4 1c             	add    $0x1c,%esp
  8019fb:	5b                   	pop    %ebx
  8019fc:	5e                   	pop    %esi
  8019fd:	5f                   	pop    %edi
  8019fe:	5d                   	pop    %ebp
  8019ff:	c3                   	ret    
  801a00:	39 f0                	cmp    %esi,%eax
  801a02:	0f 87 ac 00 00 00    	ja     801ab4 <__umoddi3+0xfc>
  801a08:	0f bd e8             	bsr    %eax,%ebp
  801a0b:	83 f5 1f             	xor    $0x1f,%ebp
  801a0e:	0f 84 ac 00 00 00    	je     801ac0 <__umoddi3+0x108>
  801a14:	bf 20 00 00 00       	mov    $0x20,%edi
  801a19:	29 ef                	sub    %ebp,%edi
  801a1b:	89 fe                	mov    %edi,%esi
  801a1d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a21:	89 e9                	mov    %ebp,%ecx
  801a23:	d3 e0                	shl    %cl,%eax
  801a25:	89 d7                	mov    %edx,%edi
  801a27:	89 f1                	mov    %esi,%ecx
  801a29:	d3 ef                	shr    %cl,%edi
  801a2b:	09 c7                	or     %eax,%edi
  801a2d:	89 e9                	mov    %ebp,%ecx
  801a2f:	d3 e2                	shl    %cl,%edx
  801a31:	89 14 24             	mov    %edx,(%esp)
  801a34:	89 d8                	mov    %ebx,%eax
  801a36:	d3 e0                	shl    %cl,%eax
  801a38:	89 c2                	mov    %eax,%edx
  801a3a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a3e:	d3 e0                	shl    %cl,%eax
  801a40:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a44:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a48:	89 f1                	mov    %esi,%ecx
  801a4a:	d3 e8                	shr    %cl,%eax
  801a4c:	09 d0                	or     %edx,%eax
  801a4e:	d3 eb                	shr    %cl,%ebx
  801a50:	89 da                	mov    %ebx,%edx
  801a52:	f7 f7                	div    %edi
  801a54:	89 d3                	mov    %edx,%ebx
  801a56:	f7 24 24             	mull   (%esp)
  801a59:	89 c6                	mov    %eax,%esi
  801a5b:	89 d1                	mov    %edx,%ecx
  801a5d:	39 d3                	cmp    %edx,%ebx
  801a5f:	0f 82 87 00 00 00    	jb     801aec <__umoddi3+0x134>
  801a65:	0f 84 91 00 00 00    	je     801afc <__umoddi3+0x144>
  801a6b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a6f:	29 f2                	sub    %esi,%edx
  801a71:	19 cb                	sbb    %ecx,%ebx
  801a73:	89 d8                	mov    %ebx,%eax
  801a75:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a79:	d3 e0                	shl    %cl,%eax
  801a7b:	89 e9                	mov    %ebp,%ecx
  801a7d:	d3 ea                	shr    %cl,%edx
  801a7f:	09 d0                	or     %edx,%eax
  801a81:	89 e9                	mov    %ebp,%ecx
  801a83:	d3 eb                	shr    %cl,%ebx
  801a85:	89 da                	mov    %ebx,%edx
  801a87:	83 c4 1c             	add    $0x1c,%esp
  801a8a:	5b                   	pop    %ebx
  801a8b:	5e                   	pop    %esi
  801a8c:	5f                   	pop    %edi
  801a8d:	5d                   	pop    %ebp
  801a8e:	c3                   	ret    
  801a8f:	90                   	nop
  801a90:	89 fd                	mov    %edi,%ebp
  801a92:	85 ff                	test   %edi,%edi
  801a94:	75 0b                	jne    801aa1 <__umoddi3+0xe9>
  801a96:	b8 01 00 00 00       	mov    $0x1,%eax
  801a9b:	31 d2                	xor    %edx,%edx
  801a9d:	f7 f7                	div    %edi
  801a9f:	89 c5                	mov    %eax,%ebp
  801aa1:	89 f0                	mov    %esi,%eax
  801aa3:	31 d2                	xor    %edx,%edx
  801aa5:	f7 f5                	div    %ebp
  801aa7:	89 c8                	mov    %ecx,%eax
  801aa9:	f7 f5                	div    %ebp
  801aab:	89 d0                	mov    %edx,%eax
  801aad:	e9 44 ff ff ff       	jmp    8019f6 <__umoddi3+0x3e>
  801ab2:	66 90                	xchg   %ax,%ax
  801ab4:	89 c8                	mov    %ecx,%eax
  801ab6:	89 f2                	mov    %esi,%edx
  801ab8:	83 c4 1c             	add    $0x1c,%esp
  801abb:	5b                   	pop    %ebx
  801abc:	5e                   	pop    %esi
  801abd:	5f                   	pop    %edi
  801abe:	5d                   	pop    %ebp
  801abf:	c3                   	ret    
  801ac0:	3b 04 24             	cmp    (%esp),%eax
  801ac3:	72 06                	jb     801acb <__umoddi3+0x113>
  801ac5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ac9:	77 0f                	ja     801ada <__umoddi3+0x122>
  801acb:	89 f2                	mov    %esi,%edx
  801acd:	29 f9                	sub    %edi,%ecx
  801acf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ad3:	89 14 24             	mov    %edx,(%esp)
  801ad6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ada:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ade:	8b 14 24             	mov    (%esp),%edx
  801ae1:	83 c4 1c             	add    $0x1c,%esp
  801ae4:	5b                   	pop    %ebx
  801ae5:	5e                   	pop    %esi
  801ae6:	5f                   	pop    %edi
  801ae7:	5d                   	pop    %ebp
  801ae8:	c3                   	ret    
  801ae9:	8d 76 00             	lea    0x0(%esi),%esi
  801aec:	2b 04 24             	sub    (%esp),%eax
  801aef:	19 fa                	sbb    %edi,%edx
  801af1:	89 d1                	mov    %edx,%ecx
  801af3:	89 c6                	mov    %eax,%esi
  801af5:	e9 71 ff ff ff       	jmp    801a6b <__umoddi3+0xb3>
  801afa:	66 90                	xchg   %ax,%ax
  801afc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b00:	72 ea                	jb     801aec <__umoddi3+0x134>
  801b02:	89 d9                	mov    %ebx,%ecx
  801b04:	e9 62 ff ff ff       	jmp    801a6b <__umoddi3+0xb3>
