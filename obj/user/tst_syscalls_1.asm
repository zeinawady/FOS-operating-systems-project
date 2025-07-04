
obj/user/tst_syscalls_1:     file format elf32-i386


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
  800031:	e8 90 00 00 00       	call   8000c6 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the correct implementation of system calls
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	rsttst();
  80003e:	e8 e6 15 00 00       	call   801629 <rsttst>
	void * ret = sys_sbrk(10);
  800043:	83 ec 0c             	sub    $0xc,%esp
  800046:	6a 0a                	push   $0xa
  800048:	e8 eb 17 00 00       	call   801838 <sys_sbrk>
  80004d:	83 c4 10             	add    $0x10,%esp
  800050:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (ret != (void*)-1)
  800053:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  800057:	74 14                	je     80006d <_main+0x35>
		panic("tst system calls #1 failed: sys_sbrk is not handled correctly");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 80 1b 80 00       	push   $0x801b80
  800061:	6a 0a                	push   $0xa
  800063:	68 be 1b 80 00       	push   $0x801bbe
  800068:	e8 9e 01 00 00       	call   80020b <_panic>
	sys_allocate_user_mem(USER_HEAP_START,10);
  80006d:	83 ec 08             	sub    $0x8,%esp
  800070:	6a 0a                	push   $0xa
  800072:	68 00 00 00 80       	push   $0x80000000
  800077:	e8 f3 17 00 00       	call   80186f <sys_allocate_user_mem>
  80007c:	83 c4 10             	add    $0x10,%esp
	sys_free_user_mem(USER_HEAP_START + PAGE_SIZE, 10);
  80007f:	83 ec 08             	sub    $0x8,%esp
  800082:	6a 0a                	push   $0xa
  800084:	68 00 10 00 80       	push   $0x80001000
  800089:	e8 c5 17 00 00       	call   801853 <sys_free_user_mem>
  80008e:	83 c4 10             	add    $0x10,%esp
	int ret2 = gettst();
  800091:	e8 0d 16 00 00       	call   8016a3 <gettst>
  800096:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret2 != 2)
  800099:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  80009d:	74 14                	je     8000b3 <_main+0x7b>
		panic("tst system calls #1 failed: sys_allocate_user_mem and/or sys_free_user_mem are not handled correctly");
  80009f:	83 ec 04             	sub    $0x4,%esp
  8000a2:	68 d4 1b 80 00       	push   $0x801bd4
  8000a7:	6a 0f                	push   $0xf
  8000a9:	68 be 1b 80 00       	push   $0x801bbe
  8000ae:	e8 58 01 00 00       	call   80020b <_panic>
	cprintf("Congratulations... tst system calls #1 completed successfully");
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	68 3c 1c 80 00       	push   $0x801c3c
  8000bb:	e8 08 04 00 00       	call   8004c8 <cprintf>
  8000c0:	83 c4 10             	add    $0x10,%esp
}
  8000c3:	90                   	nop
  8000c4:	c9                   	leave  
  8000c5:	c3                   	ret    

008000c6 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000c6:	55                   	push   %ebp
  8000c7:	89 e5                	mov    %esp,%ebp
  8000c9:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000cc:	e8 7a 14 00 00       	call   80154b <sys_getenvindex>
  8000d1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000d7:	89 d0                	mov    %edx,%eax
  8000d9:	c1 e0 02             	shl    $0x2,%eax
  8000dc:	01 d0                	add    %edx,%eax
  8000de:	c1 e0 03             	shl    $0x3,%eax
  8000e1:	01 d0                	add    %edx,%eax
  8000e3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8000ea:	01 d0                	add    %edx,%eax
  8000ec:	c1 e0 02             	shl    $0x2,%eax
  8000ef:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000f4:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000f9:	a1 08 30 80 00       	mov    0x803008,%eax
  8000fe:	8a 40 20             	mov    0x20(%eax),%al
  800101:	84 c0                	test   %al,%al
  800103:	74 0d                	je     800112 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800105:	a1 08 30 80 00       	mov    0x803008,%eax
  80010a:	83 c0 20             	add    $0x20,%eax
  80010d:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800112:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800116:	7e 0a                	jle    800122 <libmain+0x5c>
		binaryname = argv[0];
  800118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80011b:	8b 00                	mov    (%eax),%eax
  80011d:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800122:	83 ec 08             	sub    $0x8,%esp
  800125:	ff 75 0c             	pushl  0xc(%ebp)
  800128:	ff 75 08             	pushl  0x8(%ebp)
  80012b:	e8 08 ff ff ff       	call   800038 <_main>
  800130:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800133:	a1 00 30 80 00       	mov    0x803000,%eax
  800138:	85 c0                	test   %eax,%eax
  80013a:	0f 84 9f 00 00 00    	je     8001df <libmain+0x119>
	{
		sys_lock_cons();
  800140:	e8 8a 11 00 00       	call   8012cf <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	68 94 1c 80 00       	push   $0x801c94
  80014d:	e8 76 03 00 00       	call   8004c8 <cprintf>
  800152:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800155:	a1 08 30 80 00       	mov    0x803008,%eax
  80015a:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800160:	a1 08 30 80 00       	mov    0x803008,%eax
  800165:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	52                   	push   %edx
  80016f:	50                   	push   %eax
  800170:	68 bc 1c 80 00       	push   $0x801cbc
  800175:	e8 4e 03 00 00       	call   8004c8 <cprintf>
  80017a:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80017d:	a1 08 30 80 00       	mov    0x803008,%eax
  800182:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800188:	a1 08 30 80 00       	mov    0x803008,%eax
  80018d:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800193:	a1 08 30 80 00       	mov    0x803008,%eax
  800198:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80019e:	51                   	push   %ecx
  80019f:	52                   	push   %edx
  8001a0:	50                   	push   %eax
  8001a1:	68 e4 1c 80 00       	push   $0x801ce4
  8001a6:	e8 1d 03 00 00       	call   8004c8 <cprintf>
  8001ab:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001ae:	a1 08 30 80 00       	mov    0x803008,%eax
  8001b3:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8001b9:	83 ec 08             	sub    $0x8,%esp
  8001bc:	50                   	push   %eax
  8001bd:	68 3c 1d 80 00       	push   $0x801d3c
  8001c2:	e8 01 03 00 00       	call   8004c8 <cprintf>
  8001c7:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 94 1c 80 00       	push   $0x801c94
  8001d2:	e8 f1 02 00 00       	call   8004c8 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001da:	e8 0a 11 00 00       	call   8012e9 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001df:	e8 19 00 00 00       	call   8001fd <exit>
}
  8001e4:	90                   	nop
  8001e5:	c9                   	leave  
  8001e6:	c3                   	ret    

008001e7 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001e7:	55                   	push   %ebp
  8001e8:	89 e5                	mov    %esp,%ebp
  8001ea:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001ed:	83 ec 0c             	sub    $0xc,%esp
  8001f0:	6a 00                	push   $0x0
  8001f2:	e8 20 13 00 00       	call   801517 <sys_destroy_env>
  8001f7:	83 c4 10             	add    $0x10,%esp
}
  8001fa:	90                   	nop
  8001fb:	c9                   	leave  
  8001fc:	c3                   	ret    

008001fd <exit>:

void
exit(void)
{
  8001fd:	55                   	push   %ebp
  8001fe:	89 e5                	mov    %esp,%ebp
  800200:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800203:	e8 75 13 00 00       	call   80157d <sys_exit_env>
}
  800208:	90                   	nop
  800209:	c9                   	leave  
  80020a:	c3                   	ret    

0080020b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80020b:	55                   	push   %ebp
  80020c:	89 e5                	mov    %esp,%ebp
  80020e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800211:	8d 45 10             	lea    0x10(%ebp),%eax
  800214:	83 c0 04             	add    $0x4,%eax
  800217:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80021a:	a1 28 30 80 00       	mov    0x803028,%eax
  80021f:	85 c0                	test   %eax,%eax
  800221:	74 16                	je     800239 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800223:	a1 28 30 80 00       	mov    0x803028,%eax
  800228:	83 ec 08             	sub    $0x8,%esp
  80022b:	50                   	push   %eax
  80022c:	68 50 1d 80 00       	push   $0x801d50
  800231:	e8 92 02 00 00       	call   8004c8 <cprintf>
  800236:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800239:	a1 04 30 80 00       	mov    0x803004,%eax
  80023e:	ff 75 0c             	pushl  0xc(%ebp)
  800241:	ff 75 08             	pushl  0x8(%ebp)
  800244:	50                   	push   %eax
  800245:	68 55 1d 80 00       	push   $0x801d55
  80024a:	e8 79 02 00 00       	call   8004c8 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800252:	8b 45 10             	mov    0x10(%ebp),%eax
  800255:	83 ec 08             	sub    $0x8,%esp
  800258:	ff 75 f4             	pushl  -0xc(%ebp)
  80025b:	50                   	push   %eax
  80025c:	e8 fc 01 00 00       	call   80045d <vcprintf>
  800261:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	6a 00                	push   $0x0
  800269:	68 71 1d 80 00       	push   $0x801d71
  80026e:	e8 ea 01 00 00       	call   80045d <vcprintf>
  800273:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800276:	e8 82 ff ff ff       	call   8001fd <exit>

	// should not return here
	while (1) ;
  80027b:	eb fe                	jmp    80027b <_panic+0x70>

0080027d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800283:	a1 08 30 80 00       	mov    0x803008,%eax
  800288:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80028e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800291:	39 c2                	cmp    %eax,%edx
  800293:	74 14                	je     8002a9 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800295:	83 ec 04             	sub    $0x4,%esp
  800298:	68 74 1d 80 00       	push   $0x801d74
  80029d:	6a 26                	push   $0x26
  80029f:	68 c0 1d 80 00       	push   $0x801dc0
  8002a4:	e8 62 ff ff ff       	call   80020b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002b7:	e9 c5 00 00 00       	jmp    800381 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8002bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c9:	01 d0                	add    %edx,%eax
  8002cb:	8b 00                	mov    (%eax),%eax
  8002cd:	85 c0                	test   %eax,%eax
  8002cf:	75 08                	jne    8002d9 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8002d1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8002d4:	e9 a5 00 00 00       	jmp    80037e <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8002d9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002e0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002e7:	eb 69                	jmp    800352 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8002e9:	a1 08 30 80 00       	mov    0x803008,%eax
  8002ee:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8002f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002f7:	89 d0                	mov    %edx,%eax
  8002f9:	01 c0                	add    %eax,%eax
  8002fb:	01 d0                	add    %edx,%eax
  8002fd:	c1 e0 03             	shl    $0x3,%eax
  800300:	01 c8                	add    %ecx,%eax
  800302:	8a 40 04             	mov    0x4(%eax),%al
  800305:	84 c0                	test   %al,%al
  800307:	75 46                	jne    80034f <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800309:	a1 08 30 80 00       	mov    0x803008,%eax
  80030e:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800314:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800317:	89 d0                	mov    %edx,%eax
  800319:	01 c0                	add    %eax,%eax
  80031b:	01 d0                	add    %edx,%eax
  80031d:	c1 e0 03             	shl    $0x3,%eax
  800320:	01 c8                	add    %ecx,%eax
  800322:	8b 00                	mov    (%eax),%eax
  800324:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800327:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80032a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80032f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800331:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800334:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80033b:	8b 45 08             	mov    0x8(%ebp),%eax
  80033e:	01 c8                	add    %ecx,%eax
  800340:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800342:	39 c2                	cmp    %eax,%edx
  800344:	75 09                	jne    80034f <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800346:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80034d:	eb 15                	jmp    800364 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80034f:	ff 45 e8             	incl   -0x18(%ebp)
  800352:	a1 08 30 80 00       	mov    0x803008,%eax
  800357:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80035d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800360:	39 c2                	cmp    %eax,%edx
  800362:	77 85                	ja     8002e9 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800364:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800368:	75 14                	jne    80037e <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80036a:	83 ec 04             	sub    $0x4,%esp
  80036d:	68 cc 1d 80 00       	push   $0x801dcc
  800372:	6a 3a                	push   $0x3a
  800374:	68 c0 1d 80 00       	push   $0x801dc0
  800379:	e8 8d fe ff ff       	call   80020b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80037e:	ff 45 f0             	incl   -0x10(%ebp)
  800381:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800384:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800387:	0f 8c 2f ff ff ff    	jl     8002bc <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80038d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800394:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80039b:	eb 26                	jmp    8003c3 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80039d:	a1 08 30 80 00       	mov    0x803008,%eax
  8003a2:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8003a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ab:	89 d0                	mov    %edx,%eax
  8003ad:	01 c0                	add    %eax,%eax
  8003af:	01 d0                	add    %edx,%eax
  8003b1:	c1 e0 03             	shl    $0x3,%eax
  8003b4:	01 c8                	add    %ecx,%eax
  8003b6:	8a 40 04             	mov    0x4(%eax),%al
  8003b9:	3c 01                	cmp    $0x1,%al
  8003bb:	75 03                	jne    8003c0 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8003bd:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c0:	ff 45 e0             	incl   -0x20(%ebp)
  8003c3:	a1 08 30 80 00       	mov    0x803008,%eax
  8003c8:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8003ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d1:	39 c2                	cmp    %eax,%edx
  8003d3:	77 c8                	ja     80039d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8003d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003d8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003db:	74 14                	je     8003f1 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8003dd:	83 ec 04             	sub    $0x4,%esp
  8003e0:	68 20 1e 80 00       	push   $0x801e20
  8003e5:	6a 44                	push   $0x44
  8003e7:	68 c0 1d 80 00       	push   $0x801dc0
  8003ec:	e8 1a fe ff ff       	call   80020b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8003f1:	90                   	nop
  8003f2:	c9                   	leave  
  8003f3:	c3                   	ret    

008003f4 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
  8003f7:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8003fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	8d 48 01             	lea    0x1(%eax),%ecx
  800402:	8b 55 0c             	mov    0xc(%ebp),%edx
  800405:	89 0a                	mov    %ecx,(%edx)
  800407:	8b 55 08             	mov    0x8(%ebp),%edx
  80040a:	88 d1                	mov    %dl,%cl
  80040c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80040f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800413:	8b 45 0c             	mov    0xc(%ebp),%eax
  800416:	8b 00                	mov    (%eax),%eax
  800418:	3d ff 00 00 00       	cmp    $0xff,%eax
  80041d:	75 2c                	jne    80044b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80041f:	a0 0c 30 80 00       	mov    0x80300c,%al
  800424:	0f b6 c0             	movzbl %al,%eax
  800427:	8b 55 0c             	mov    0xc(%ebp),%edx
  80042a:	8b 12                	mov    (%edx),%edx
  80042c:	89 d1                	mov    %edx,%ecx
  80042e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800431:	83 c2 08             	add    $0x8,%edx
  800434:	83 ec 04             	sub    $0x4,%esp
  800437:	50                   	push   %eax
  800438:	51                   	push   %ecx
  800439:	52                   	push   %edx
  80043a:	e8 4e 0e 00 00       	call   80128d <sys_cputs>
  80043f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800442:	8b 45 0c             	mov    0xc(%ebp),%eax
  800445:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80044b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044e:	8b 40 04             	mov    0x4(%eax),%eax
  800451:	8d 50 01             	lea    0x1(%eax),%edx
  800454:	8b 45 0c             	mov    0xc(%ebp),%eax
  800457:	89 50 04             	mov    %edx,0x4(%eax)
}
  80045a:	90                   	nop
  80045b:	c9                   	leave  
  80045c:	c3                   	ret    

0080045d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80045d:	55                   	push   %ebp
  80045e:	89 e5                	mov    %esp,%ebp
  800460:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800466:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80046d:	00 00 00 
	b.cnt = 0;
  800470:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800477:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80047a:	ff 75 0c             	pushl  0xc(%ebp)
  80047d:	ff 75 08             	pushl  0x8(%ebp)
  800480:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800486:	50                   	push   %eax
  800487:	68 f4 03 80 00       	push   $0x8003f4
  80048c:	e8 11 02 00 00       	call   8006a2 <vprintfmt>
  800491:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800494:	a0 0c 30 80 00       	mov    0x80300c,%al
  800499:	0f b6 c0             	movzbl %al,%eax
  80049c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004a2:	83 ec 04             	sub    $0x4,%esp
  8004a5:	50                   	push   %eax
  8004a6:	52                   	push   %edx
  8004a7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004ad:	83 c0 08             	add    $0x8,%eax
  8004b0:	50                   	push   %eax
  8004b1:	e8 d7 0d 00 00       	call   80128d <sys_cputs>
  8004b6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004b9:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  8004c0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004c6:	c9                   	leave  
  8004c7:	c3                   	ret    

008004c8 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8004ce:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  8004d5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004db:	8b 45 08             	mov    0x8(%ebp),%eax
  8004de:	83 ec 08             	sub    $0x8,%esp
  8004e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e4:	50                   	push   %eax
  8004e5:	e8 73 ff ff ff       	call   80045d <vcprintf>
  8004ea:	83 c4 10             	add    $0x10,%esp
  8004ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8004f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004f3:	c9                   	leave  
  8004f4:	c3                   	ret    

008004f5 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8004f5:	55                   	push   %ebp
  8004f6:	89 e5                	mov    %esp,%ebp
  8004f8:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8004fb:	e8 cf 0d 00 00       	call   8012cf <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800500:	8d 45 0c             	lea    0xc(%ebp),%eax
  800503:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800506:	8b 45 08             	mov    0x8(%ebp),%eax
  800509:	83 ec 08             	sub    $0x8,%esp
  80050c:	ff 75 f4             	pushl  -0xc(%ebp)
  80050f:	50                   	push   %eax
  800510:	e8 48 ff ff ff       	call   80045d <vcprintf>
  800515:	83 c4 10             	add    $0x10,%esp
  800518:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80051b:	e8 c9 0d 00 00       	call   8012e9 <sys_unlock_cons>
	return cnt;
  800520:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800523:	c9                   	leave  
  800524:	c3                   	ret    

00800525 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800525:	55                   	push   %ebp
  800526:	89 e5                	mov    %esp,%ebp
  800528:	53                   	push   %ebx
  800529:	83 ec 14             	sub    $0x14,%esp
  80052c:	8b 45 10             	mov    0x10(%ebp),%eax
  80052f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800532:	8b 45 14             	mov    0x14(%ebp),%eax
  800535:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800538:	8b 45 18             	mov    0x18(%ebp),%eax
  80053b:	ba 00 00 00 00       	mov    $0x0,%edx
  800540:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800543:	77 55                	ja     80059a <printnum+0x75>
  800545:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800548:	72 05                	jb     80054f <printnum+0x2a>
  80054a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80054d:	77 4b                	ja     80059a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80054f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800552:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800555:	8b 45 18             	mov    0x18(%ebp),%eax
  800558:	ba 00 00 00 00       	mov    $0x0,%edx
  80055d:	52                   	push   %edx
  80055e:	50                   	push   %eax
  80055f:	ff 75 f4             	pushl  -0xc(%ebp)
  800562:	ff 75 f0             	pushl  -0x10(%ebp)
  800565:	e8 96 13 00 00       	call   801900 <__udivdi3>
  80056a:	83 c4 10             	add    $0x10,%esp
  80056d:	83 ec 04             	sub    $0x4,%esp
  800570:	ff 75 20             	pushl  0x20(%ebp)
  800573:	53                   	push   %ebx
  800574:	ff 75 18             	pushl  0x18(%ebp)
  800577:	52                   	push   %edx
  800578:	50                   	push   %eax
  800579:	ff 75 0c             	pushl  0xc(%ebp)
  80057c:	ff 75 08             	pushl  0x8(%ebp)
  80057f:	e8 a1 ff ff ff       	call   800525 <printnum>
  800584:	83 c4 20             	add    $0x20,%esp
  800587:	eb 1a                	jmp    8005a3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800589:	83 ec 08             	sub    $0x8,%esp
  80058c:	ff 75 0c             	pushl  0xc(%ebp)
  80058f:	ff 75 20             	pushl  0x20(%ebp)
  800592:	8b 45 08             	mov    0x8(%ebp),%eax
  800595:	ff d0                	call   *%eax
  800597:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80059a:	ff 4d 1c             	decl   0x1c(%ebp)
  80059d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005a1:	7f e6                	jg     800589 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005a3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005b1:	53                   	push   %ebx
  8005b2:	51                   	push   %ecx
  8005b3:	52                   	push   %edx
  8005b4:	50                   	push   %eax
  8005b5:	e8 56 14 00 00       	call   801a10 <__umoddi3>
  8005ba:	83 c4 10             	add    $0x10,%esp
  8005bd:	05 94 20 80 00       	add    $0x802094,%eax
  8005c2:	8a 00                	mov    (%eax),%al
  8005c4:	0f be c0             	movsbl %al,%eax
  8005c7:	83 ec 08             	sub    $0x8,%esp
  8005ca:	ff 75 0c             	pushl  0xc(%ebp)
  8005cd:	50                   	push   %eax
  8005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d1:	ff d0                	call   *%eax
  8005d3:	83 c4 10             	add    $0x10,%esp
}
  8005d6:	90                   	nop
  8005d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005da:	c9                   	leave  
  8005db:	c3                   	ret    

008005dc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005dc:	55                   	push   %ebp
  8005dd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005df:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005e3:	7e 1c                	jle    800601 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8005e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	8d 50 08             	lea    0x8(%eax),%edx
  8005ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f0:	89 10                	mov    %edx,(%eax)
  8005f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f5:	8b 00                	mov    (%eax),%eax
  8005f7:	83 e8 08             	sub    $0x8,%eax
  8005fa:	8b 50 04             	mov    0x4(%eax),%edx
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	eb 40                	jmp    800641 <getuint+0x65>
	else if (lflag)
  800601:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800605:	74 1e                	je     800625 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800607:	8b 45 08             	mov    0x8(%ebp),%eax
  80060a:	8b 00                	mov    (%eax),%eax
  80060c:	8d 50 04             	lea    0x4(%eax),%edx
  80060f:	8b 45 08             	mov    0x8(%ebp),%eax
  800612:	89 10                	mov    %edx,(%eax)
  800614:	8b 45 08             	mov    0x8(%ebp),%eax
  800617:	8b 00                	mov    (%eax),%eax
  800619:	83 e8 04             	sub    $0x4,%eax
  80061c:	8b 00                	mov    (%eax),%eax
  80061e:	ba 00 00 00 00       	mov    $0x0,%edx
  800623:	eb 1c                	jmp    800641 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800625:	8b 45 08             	mov    0x8(%ebp),%eax
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	8d 50 04             	lea    0x4(%eax),%edx
  80062d:	8b 45 08             	mov    0x8(%ebp),%eax
  800630:	89 10                	mov    %edx,(%eax)
  800632:	8b 45 08             	mov    0x8(%ebp),%eax
  800635:	8b 00                	mov    (%eax),%eax
  800637:	83 e8 04             	sub    $0x4,%eax
  80063a:	8b 00                	mov    (%eax),%eax
  80063c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800641:	5d                   	pop    %ebp
  800642:	c3                   	ret    

00800643 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800643:	55                   	push   %ebp
  800644:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800646:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80064a:	7e 1c                	jle    800668 <getint+0x25>
		return va_arg(*ap, long long);
  80064c:	8b 45 08             	mov    0x8(%ebp),%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	8d 50 08             	lea    0x8(%eax),%edx
  800654:	8b 45 08             	mov    0x8(%ebp),%eax
  800657:	89 10                	mov    %edx,(%eax)
  800659:	8b 45 08             	mov    0x8(%ebp),%eax
  80065c:	8b 00                	mov    (%eax),%eax
  80065e:	83 e8 08             	sub    $0x8,%eax
  800661:	8b 50 04             	mov    0x4(%eax),%edx
  800664:	8b 00                	mov    (%eax),%eax
  800666:	eb 38                	jmp    8006a0 <getint+0x5d>
	else if (lflag)
  800668:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80066c:	74 1a                	je     800688 <getint+0x45>
		return va_arg(*ap, long);
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	8b 00                	mov    (%eax),%eax
  800673:	8d 50 04             	lea    0x4(%eax),%edx
  800676:	8b 45 08             	mov    0x8(%ebp),%eax
  800679:	89 10                	mov    %edx,(%eax)
  80067b:	8b 45 08             	mov    0x8(%ebp),%eax
  80067e:	8b 00                	mov    (%eax),%eax
  800680:	83 e8 04             	sub    $0x4,%eax
  800683:	8b 00                	mov    (%eax),%eax
  800685:	99                   	cltd   
  800686:	eb 18                	jmp    8006a0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	8d 50 04             	lea    0x4(%eax),%edx
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	89 10                	mov    %edx,(%eax)
  800695:	8b 45 08             	mov    0x8(%ebp),%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	83 e8 04             	sub    $0x4,%eax
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	99                   	cltd   
}
  8006a0:	5d                   	pop    %ebp
  8006a1:	c3                   	ret    

008006a2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006a2:	55                   	push   %ebp
  8006a3:	89 e5                	mov    %esp,%ebp
  8006a5:	56                   	push   %esi
  8006a6:	53                   	push   %ebx
  8006a7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006aa:	eb 17                	jmp    8006c3 <vprintfmt+0x21>
			if (ch == '\0')
  8006ac:	85 db                	test   %ebx,%ebx
  8006ae:	0f 84 c1 03 00 00    	je     800a75 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	ff 75 0c             	pushl  0xc(%ebp)
  8006ba:	53                   	push   %ebx
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	ff d0                	call   *%eax
  8006c0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8006c6:	8d 50 01             	lea    0x1(%eax),%edx
  8006c9:	89 55 10             	mov    %edx,0x10(%ebp)
  8006cc:	8a 00                	mov    (%eax),%al
  8006ce:	0f b6 d8             	movzbl %al,%ebx
  8006d1:	83 fb 25             	cmp    $0x25,%ebx
  8006d4:	75 d6                	jne    8006ac <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006d6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8006da:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8006e1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006e8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8006ef:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8006f9:	8d 50 01             	lea    0x1(%eax),%edx
  8006fc:	89 55 10             	mov    %edx,0x10(%ebp)
  8006ff:	8a 00                	mov    (%eax),%al
  800701:	0f b6 d8             	movzbl %al,%ebx
  800704:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800707:	83 f8 5b             	cmp    $0x5b,%eax
  80070a:	0f 87 3d 03 00 00    	ja     800a4d <vprintfmt+0x3ab>
  800710:	8b 04 85 b8 20 80 00 	mov    0x8020b8(,%eax,4),%eax
  800717:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800719:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80071d:	eb d7                	jmp    8006f6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80071f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800723:	eb d1                	jmp    8006f6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800725:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80072c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80072f:	89 d0                	mov    %edx,%eax
  800731:	c1 e0 02             	shl    $0x2,%eax
  800734:	01 d0                	add    %edx,%eax
  800736:	01 c0                	add    %eax,%eax
  800738:	01 d8                	add    %ebx,%eax
  80073a:	83 e8 30             	sub    $0x30,%eax
  80073d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800740:	8b 45 10             	mov    0x10(%ebp),%eax
  800743:	8a 00                	mov    (%eax),%al
  800745:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800748:	83 fb 2f             	cmp    $0x2f,%ebx
  80074b:	7e 3e                	jle    80078b <vprintfmt+0xe9>
  80074d:	83 fb 39             	cmp    $0x39,%ebx
  800750:	7f 39                	jg     80078b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800752:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800755:	eb d5                	jmp    80072c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800757:	8b 45 14             	mov    0x14(%ebp),%eax
  80075a:	83 c0 04             	add    $0x4,%eax
  80075d:	89 45 14             	mov    %eax,0x14(%ebp)
  800760:	8b 45 14             	mov    0x14(%ebp),%eax
  800763:	83 e8 04             	sub    $0x4,%eax
  800766:	8b 00                	mov    (%eax),%eax
  800768:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80076b:	eb 1f                	jmp    80078c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80076d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800771:	79 83                	jns    8006f6 <vprintfmt+0x54>
				width = 0;
  800773:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80077a:	e9 77 ff ff ff       	jmp    8006f6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80077f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800786:	e9 6b ff ff ff       	jmp    8006f6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80078b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80078c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800790:	0f 89 60 ff ff ff    	jns    8006f6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800796:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800799:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80079c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007a3:	e9 4e ff ff ff       	jmp    8006f6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007a8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007ab:	e9 46 ff ff ff       	jmp    8006f6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b3:	83 c0 04             	add    $0x4,%eax
  8007b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bc:	83 e8 04             	sub    $0x4,%eax
  8007bf:	8b 00                	mov    (%eax),%eax
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	50                   	push   %eax
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	ff d0                	call   *%eax
  8007cd:	83 c4 10             	add    $0x10,%esp
			break;
  8007d0:	e9 9b 02 00 00       	jmp    800a70 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	83 c0 04             	add    $0x4,%eax
  8007db:	89 45 14             	mov    %eax,0x14(%ebp)
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	83 e8 04             	sub    $0x4,%eax
  8007e4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8007e6:	85 db                	test   %ebx,%ebx
  8007e8:	79 02                	jns    8007ec <vprintfmt+0x14a>
				err = -err;
  8007ea:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007ec:	83 fb 64             	cmp    $0x64,%ebx
  8007ef:	7f 0b                	jg     8007fc <vprintfmt+0x15a>
  8007f1:	8b 34 9d 00 1f 80 00 	mov    0x801f00(,%ebx,4),%esi
  8007f8:	85 f6                	test   %esi,%esi
  8007fa:	75 19                	jne    800815 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007fc:	53                   	push   %ebx
  8007fd:	68 a5 20 80 00       	push   $0x8020a5
  800802:	ff 75 0c             	pushl  0xc(%ebp)
  800805:	ff 75 08             	pushl  0x8(%ebp)
  800808:	e8 70 02 00 00       	call   800a7d <printfmt>
  80080d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800810:	e9 5b 02 00 00       	jmp    800a70 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800815:	56                   	push   %esi
  800816:	68 ae 20 80 00       	push   $0x8020ae
  80081b:	ff 75 0c             	pushl  0xc(%ebp)
  80081e:	ff 75 08             	pushl  0x8(%ebp)
  800821:	e8 57 02 00 00       	call   800a7d <printfmt>
  800826:	83 c4 10             	add    $0x10,%esp
			break;
  800829:	e9 42 02 00 00       	jmp    800a70 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80082e:	8b 45 14             	mov    0x14(%ebp),%eax
  800831:	83 c0 04             	add    $0x4,%eax
  800834:	89 45 14             	mov    %eax,0x14(%ebp)
  800837:	8b 45 14             	mov    0x14(%ebp),%eax
  80083a:	83 e8 04             	sub    $0x4,%eax
  80083d:	8b 30                	mov    (%eax),%esi
  80083f:	85 f6                	test   %esi,%esi
  800841:	75 05                	jne    800848 <vprintfmt+0x1a6>
				p = "(null)";
  800843:	be b1 20 80 00       	mov    $0x8020b1,%esi
			if (width > 0 && padc != '-')
  800848:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084c:	7e 6d                	jle    8008bb <vprintfmt+0x219>
  80084e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800852:	74 67                	je     8008bb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800854:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800857:	83 ec 08             	sub    $0x8,%esp
  80085a:	50                   	push   %eax
  80085b:	56                   	push   %esi
  80085c:	e8 1e 03 00 00       	call   800b7f <strnlen>
  800861:	83 c4 10             	add    $0x10,%esp
  800864:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800867:	eb 16                	jmp    80087f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800869:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80086d:	83 ec 08             	sub    $0x8,%esp
  800870:	ff 75 0c             	pushl  0xc(%ebp)
  800873:	50                   	push   %eax
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	ff d0                	call   *%eax
  800879:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80087c:	ff 4d e4             	decl   -0x1c(%ebp)
  80087f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800883:	7f e4                	jg     800869 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800885:	eb 34                	jmp    8008bb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800887:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80088b:	74 1c                	je     8008a9 <vprintfmt+0x207>
  80088d:	83 fb 1f             	cmp    $0x1f,%ebx
  800890:	7e 05                	jle    800897 <vprintfmt+0x1f5>
  800892:	83 fb 7e             	cmp    $0x7e,%ebx
  800895:	7e 12                	jle    8008a9 <vprintfmt+0x207>
					putch('?', putdat);
  800897:	83 ec 08             	sub    $0x8,%esp
  80089a:	ff 75 0c             	pushl  0xc(%ebp)
  80089d:	6a 3f                	push   $0x3f
  80089f:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a2:	ff d0                	call   *%eax
  8008a4:	83 c4 10             	add    $0x10,%esp
  8008a7:	eb 0f                	jmp    8008b8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008a9:	83 ec 08             	sub    $0x8,%esp
  8008ac:	ff 75 0c             	pushl  0xc(%ebp)
  8008af:	53                   	push   %ebx
  8008b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b3:	ff d0                	call   *%eax
  8008b5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008b8:	ff 4d e4             	decl   -0x1c(%ebp)
  8008bb:	89 f0                	mov    %esi,%eax
  8008bd:	8d 70 01             	lea    0x1(%eax),%esi
  8008c0:	8a 00                	mov    (%eax),%al
  8008c2:	0f be d8             	movsbl %al,%ebx
  8008c5:	85 db                	test   %ebx,%ebx
  8008c7:	74 24                	je     8008ed <vprintfmt+0x24b>
  8008c9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008cd:	78 b8                	js     800887 <vprintfmt+0x1e5>
  8008cf:	ff 4d e0             	decl   -0x20(%ebp)
  8008d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008d6:	79 af                	jns    800887 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008d8:	eb 13                	jmp    8008ed <vprintfmt+0x24b>
				putch(' ', putdat);
  8008da:	83 ec 08             	sub    $0x8,%esp
  8008dd:	ff 75 0c             	pushl  0xc(%ebp)
  8008e0:	6a 20                	push   $0x20
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	ff d0                	call   *%eax
  8008e7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008ea:	ff 4d e4             	decl   -0x1c(%ebp)
  8008ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f1:	7f e7                	jg     8008da <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8008f3:	e9 78 01 00 00       	jmp    800a70 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008f8:	83 ec 08             	sub    $0x8,%esp
  8008fb:	ff 75 e8             	pushl  -0x18(%ebp)
  8008fe:	8d 45 14             	lea    0x14(%ebp),%eax
  800901:	50                   	push   %eax
  800902:	e8 3c fd ff ff       	call   800643 <getint>
  800907:	83 c4 10             	add    $0x10,%esp
  80090a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80090d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800910:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800913:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800916:	85 d2                	test   %edx,%edx
  800918:	79 23                	jns    80093d <vprintfmt+0x29b>
				putch('-', putdat);
  80091a:	83 ec 08             	sub    $0x8,%esp
  80091d:	ff 75 0c             	pushl  0xc(%ebp)
  800920:	6a 2d                	push   $0x2d
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	ff d0                	call   *%eax
  800927:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80092a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80092d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800930:	f7 d8                	neg    %eax
  800932:	83 d2 00             	adc    $0x0,%edx
  800935:	f7 da                	neg    %edx
  800937:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80093a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80093d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800944:	e9 bc 00 00 00       	jmp    800a05 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800949:	83 ec 08             	sub    $0x8,%esp
  80094c:	ff 75 e8             	pushl  -0x18(%ebp)
  80094f:	8d 45 14             	lea    0x14(%ebp),%eax
  800952:	50                   	push   %eax
  800953:	e8 84 fc ff ff       	call   8005dc <getuint>
  800958:	83 c4 10             	add    $0x10,%esp
  80095b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800961:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800968:	e9 98 00 00 00       	jmp    800a05 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80096d:	83 ec 08             	sub    $0x8,%esp
  800970:	ff 75 0c             	pushl  0xc(%ebp)
  800973:	6a 58                	push   $0x58
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	ff d0                	call   *%eax
  80097a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	ff 75 0c             	pushl  0xc(%ebp)
  800983:	6a 58                	push   $0x58
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	ff d0                	call   *%eax
  80098a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80098d:	83 ec 08             	sub    $0x8,%esp
  800990:	ff 75 0c             	pushl  0xc(%ebp)
  800993:	6a 58                	push   $0x58
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	ff d0                	call   *%eax
  80099a:	83 c4 10             	add    $0x10,%esp
			break;
  80099d:	e9 ce 00 00 00       	jmp    800a70 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8009a2:	83 ec 08             	sub    $0x8,%esp
  8009a5:	ff 75 0c             	pushl  0xc(%ebp)
  8009a8:	6a 30                	push   $0x30
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	ff d0                	call   *%eax
  8009af:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8009b2:	83 ec 08             	sub    $0x8,%esp
  8009b5:	ff 75 0c             	pushl  0xc(%ebp)
  8009b8:	6a 78                	push   $0x78
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	ff d0                	call   *%eax
  8009bf:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8009c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c5:	83 c0 04             	add    $0x4,%eax
  8009c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8009cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ce:	83 e8 04             	sub    $0x4,%eax
  8009d1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8009d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8009dd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8009e4:	eb 1f                	jmp    800a05 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8009e6:	83 ec 08             	sub    $0x8,%esp
  8009e9:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ec:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ef:	50                   	push   %eax
  8009f0:	e8 e7 fb ff ff       	call   8005dc <getuint>
  8009f5:	83 c4 10             	add    $0x10,%esp
  8009f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009fb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009fe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a05:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a0c:	83 ec 04             	sub    $0x4,%esp
  800a0f:	52                   	push   %edx
  800a10:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a13:	50                   	push   %eax
  800a14:	ff 75 f4             	pushl  -0xc(%ebp)
  800a17:	ff 75 f0             	pushl  -0x10(%ebp)
  800a1a:	ff 75 0c             	pushl  0xc(%ebp)
  800a1d:	ff 75 08             	pushl  0x8(%ebp)
  800a20:	e8 00 fb ff ff       	call   800525 <printnum>
  800a25:	83 c4 20             	add    $0x20,%esp
			break;
  800a28:	eb 46                	jmp    800a70 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a2a:	83 ec 08             	sub    $0x8,%esp
  800a2d:	ff 75 0c             	pushl  0xc(%ebp)
  800a30:	53                   	push   %ebx
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	ff d0                	call   *%eax
  800a36:	83 c4 10             	add    $0x10,%esp
			break;
  800a39:	eb 35                	jmp    800a70 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a3b:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  800a42:	eb 2c                	jmp    800a70 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a44:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  800a4b:	eb 23                	jmp    800a70 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a4d:	83 ec 08             	sub    $0x8,%esp
  800a50:	ff 75 0c             	pushl  0xc(%ebp)
  800a53:	6a 25                	push   $0x25
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	ff d0                	call   *%eax
  800a5a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a5d:	ff 4d 10             	decl   0x10(%ebp)
  800a60:	eb 03                	jmp    800a65 <vprintfmt+0x3c3>
  800a62:	ff 4d 10             	decl   0x10(%ebp)
  800a65:	8b 45 10             	mov    0x10(%ebp),%eax
  800a68:	48                   	dec    %eax
  800a69:	8a 00                	mov    (%eax),%al
  800a6b:	3c 25                	cmp    $0x25,%al
  800a6d:	75 f3                	jne    800a62 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a6f:	90                   	nop
		}
	}
  800a70:	e9 35 fc ff ff       	jmp    8006aa <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a75:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a79:	5b                   	pop    %ebx
  800a7a:	5e                   	pop    %esi
  800a7b:	5d                   	pop    %ebp
  800a7c:	c3                   	ret    

00800a7d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a7d:	55                   	push   %ebp
  800a7e:	89 e5                	mov    %esp,%ebp
  800a80:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a83:	8d 45 10             	lea    0x10(%ebp),%eax
  800a86:	83 c0 04             	add    $0x4,%eax
  800a89:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a92:	50                   	push   %eax
  800a93:	ff 75 0c             	pushl  0xc(%ebp)
  800a96:	ff 75 08             	pushl  0x8(%ebp)
  800a99:	e8 04 fc ff ff       	call   8006a2 <vprintfmt>
  800a9e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800aa1:	90                   	nop
  800aa2:	c9                   	leave  
  800aa3:	c3                   	ret    

00800aa4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800aa4:	55                   	push   %ebp
  800aa5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aaa:	8b 40 08             	mov    0x8(%eax),%eax
  800aad:	8d 50 01             	lea    0x1(%eax),%edx
  800ab0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab9:	8b 10                	mov    (%eax),%edx
  800abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abe:	8b 40 04             	mov    0x4(%eax),%eax
  800ac1:	39 c2                	cmp    %eax,%edx
  800ac3:	73 12                	jae    800ad7 <sprintputch+0x33>
		*b->buf++ = ch;
  800ac5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac8:	8b 00                	mov    (%eax),%eax
  800aca:	8d 48 01             	lea    0x1(%eax),%ecx
  800acd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad0:	89 0a                	mov    %ecx,(%edx)
  800ad2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ad5:	88 10                	mov    %dl,(%eax)
}
  800ad7:	90                   	nop
  800ad8:	5d                   	pop    %ebp
  800ad9:	c3                   	ret    

00800ada <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	01 d0                	add    %edx,%eax
  800af1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800afb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800aff:	74 06                	je     800b07 <vsnprintf+0x2d>
  800b01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b05:	7f 07                	jg     800b0e <vsnprintf+0x34>
		return -E_INVAL;
  800b07:	b8 03 00 00 00       	mov    $0x3,%eax
  800b0c:	eb 20                	jmp    800b2e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b0e:	ff 75 14             	pushl  0x14(%ebp)
  800b11:	ff 75 10             	pushl  0x10(%ebp)
  800b14:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b17:	50                   	push   %eax
  800b18:	68 a4 0a 80 00       	push   $0x800aa4
  800b1d:	e8 80 fb ff ff       	call   8006a2 <vprintfmt>
  800b22:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b28:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b2e:	c9                   	leave  
  800b2f:	c3                   	ret    

00800b30 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
  800b33:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b36:	8d 45 10             	lea    0x10(%ebp),%eax
  800b39:	83 c0 04             	add    $0x4,%eax
  800b3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b42:	ff 75 f4             	pushl  -0xc(%ebp)
  800b45:	50                   	push   %eax
  800b46:	ff 75 0c             	pushl  0xc(%ebp)
  800b49:	ff 75 08             	pushl  0x8(%ebp)
  800b4c:	e8 89 ff ff ff       	call   800ada <vsnprintf>
  800b51:	83 c4 10             	add    $0x10,%esp
  800b54:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b5a:	c9                   	leave  
  800b5b:	c3                   	ret    

00800b5c <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b69:	eb 06                	jmp    800b71 <strlen+0x15>
		n++;
  800b6b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b6e:	ff 45 08             	incl   0x8(%ebp)
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	8a 00                	mov    (%eax),%al
  800b76:	84 c0                	test   %al,%al
  800b78:	75 f1                	jne    800b6b <strlen+0xf>
		n++;
	return n;
  800b7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b7d:	c9                   	leave  
  800b7e:	c3                   	ret    

00800b7f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
  800b82:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b8c:	eb 09                	jmp    800b97 <strnlen+0x18>
		n++;
  800b8e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b91:	ff 45 08             	incl   0x8(%ebp)
  800b94:	ff 4d 0c             	decl   0xc(%ebp)
  800b97:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9b:	74 09                	je     800ba6 <strnlen+0x27>
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	8a 00                	mov    (%eax),%al
  800ba2:	84 c0                	test   %al,%al
  800ba4:	75 e8                	jne    800b8e <strnlen+0xf>
		n++;
	return n;
  800ba6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ba9:	c9                   	leave  
  800baa:	c3                   	ret    

00800bab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bb7:	90                   	nop
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	8d 50 01             	lea    0x1(%eax),%edx
  800bbe:	89 55 08             	mov    %edx,0x8(%ebp)
  800bc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bc7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bca:	8a 12                	mov    (%edx),%dl
  800bcc:	88 10                	mov    %dl,(%eax)
  800bce:	8a 00                	mov    (%eax),%al
  800bd0:	84 c0                	test   %al,%al
  800bd2:	75 e4                	jne    800bb8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800bd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd7:	c9                   	leave  
  800bd8:	c3                   	ret    

00800bd9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800bd9:	55                   	push   %ebp
  800bda:	89 e5                	mov    %esp,%ebp
  800bdc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800be2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800be5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bec:	eb 1f                	jmp    800c0d <strncpy+0x34>
		*dst++ = *src;
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	8d 50 01             	lea    0x1(%eax),%edx
  800bf4:	89 55 08             	mov    %edx,0x8(%ebp)
  800bf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bfa:	8a 12                	mov    (%edx),%dl
  800bfc:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	8a 00                	mov    (%eax),%al
  800c03:	84 c0                	test   %al,%al
  800c05:	74 03                	je     800c0a <strncpy+0x31>
			src++;
  800c07:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c0a:	ff 45 fc             	incl   -0x4(%ebp)
  800c0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c10:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c13:	72 d9                	jb     800bee <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c15:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c18:	c9                   	leave  
  800c19:	c3                   	ret    

00800c1a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c2a:	74 30                	je     800c5c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c2c:	eb 16                	jmp    800c44 <strlcpy+0x2a>
			*dst++ = *src++;
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	8d 50 01             	lea    0x1(%eax),%edx
  800c34:	89 55 08             	mov    %edx,0x8(%ebp)
  800c37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c3d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c40:	8a 12                	mov    (%edx),%dl
  800c42:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c44:	ff 4d 10             	decl   0x10(%ebp)
  800c47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c4b:	74 09                	je     800c56 <strlcpy+0x3c>
  800c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c50:	8a 00                	mov    (%eax),%al
  800c52:	84 c0                	test   %al,%al
  800c54:	75 d8                	jne    800c2e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c62:	29 c2                	sub    %eax,%edx
  800c64:	89 d0                	mov    %edx,%eax
}
  800c66:	c9                   	leave  
  800c67:	c3                   	ret    

00800c68 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c6b:	eb 06                	jmp    800c73 <strcmp+0xb>
		p++, q++;
  800c6d:	ff 45 08             	incl   0x8(%ebp)
  800c70:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	8a 00                	mov    (%eax),%al
  800c78:	84 c0                	test   %al,%al
  800c7a:	74 0e                	je     800c8a <strcmp+0x22>
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	8a 10                	mov    (%eax),%dl
  800c81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c84:	8a 00                	mov    (%eax),%al
  800c86:	38 c2                	cmp    %al,%dl
  800c88:	74 e3                	je     800c6d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	8a 00                	mov    (%eax),%al
  800c8f:	0f b6 d0             	movzbl %al,%edx
  800c92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c95:	8a 00                	mov    (%eax),%al
  800c97:	0f b6 c0             	movzbl %al,%eax
  800c9a:	29 c2                	sub    %eax,%edx
  800c9c:	89 d0                	mov    %edx,%eax
}
  800c9e:	5d                   	pop    %ebp
  800c9f:	c3                   	ret    

00800ca0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ca3:	eb 09                	jmp    800cae <strncmp+0xe>
		n--, p++, q++;
  800ca5:	ff 4d 10             	decl   0x10(%ebp)
  800ca8:	ff 45 08             	incl   0x8(%ebp)
  800cab:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb2:	74 17                	je     800ccb <strncmp+0x2b>
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	8a 00                	mov    (%eax),%al
  800cb9:	84 c0                	test   %al,%al
  800cbb:	74 0e                	je     800ccb <strncmp+0x2b>
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	8a 10                	mov    (%eax),%dl
  800cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc5:	8a 00                	mov    (%eax),%al
  800cc7:	38 c2                	cmp    %al,%dl
  800cc9:	74 da                	je     800ca5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ccb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ccf:	75 07                	jne    800cd8 <strncmp+0x38>
		return 0;
  800cd1:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd6:	eb 14                	jmp    800cec <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8a 00                	mov    (%eax),%al
  800cdd:	0f b6 d0             	movzbl %al,%edx
  800ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce3:	8a 00                	mov    (%eax),%al
  800ce5:	0f b6 c0             	movzbl %al,%eax
  800ce8:	29 c2                	sub    %eax,%edx
  800cea:	89 d0                	mov    %edx,%eax
}
  800cec:	5d                   	pop    %ebp
  800ced:	c3                   	ret    

00800cee <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	83 ec 04             	sub    $0x4,%esp
  800cf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cfa:	eb 12                	jmp    800d0e <strchr+0x20>
		if (*s == c)
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	8a 00                	mov    (%eax),%al
  800d01:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d04:	75 05                	jne    800d0b <strchr+0x1d>
			return (char *) s;
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	eb 11                	jmp    800d1c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d0b:	ff 45 08             	incl   0x8(%ebp)
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	8a 00                	mov    (%eax),%al
  800d13:	84 c0                	test   %al,%al
  800d15:	75 e5                	jne    800cfc <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d1c:	c9                   	leave  
  800d1d:	c3                   	ret    

00800d1e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	83 ec 04             	sub    $0x4,%esp
  800d24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d27:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d2a:	eb 0d                	jmp    800d39 <strfind+0x1b>
		if (*s == c)
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d34:	74 0e                	je     800d44 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d36:	ff 45 08             	incl   0x8(%ebp)
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	84 c0                	test   %al,%al
  800d40:	75 ea                	jne    800d2c <strfind+0xe>
  800d42:	eb 01                	jmp    800d45 <strfind+0x27>
		if (*s == c)
			break;
  800d44:	90                   	nop
	return (char *) s;
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d48:	c9                   	leave  
  800d49:	c3                   	ret    

00800d4a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d56:	8b 45 10             	mov    0x10(%ebp),%eax
  800d59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d5c:	eb 0e                	jmp    800d6c <memset+0x22>
		*p++ = c;
  800d5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d61:	8d 50 01             	lea    0x1(%eax),%edx
  800d64:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d6c:	ff 4d f8             	decl   -0x8(%ebp)
  800d6f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d73:	79 e9                	jns    800d5e <memset+0x14>
		*p++ = c;

	return v;
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d78:	c9                   	leave  
  800d79:	c3                   	ret    

00800d7a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d8c:	eb 16                	jmp    800da4 <memcpy+0x2a>
		*d++ = *s++;
  800d8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d91:	8d 50 01             	lea    0x1(%eax),%edx
  800d94:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d9d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800da0:	8a 12                	mov    (%edx),%dl
  800da2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800da4:	8b 45 10             	mov    0x10(%ebp),%eax
  800da7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800daa:	89 55 10             	mov    %edx,0x10(%ebp)
  800dad:	85 c0                	test   %eax,%eax
  800daf:	75 dd                	jne    800d8e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db4:	c9                   	leave  
  800db5:	c3                   	ret    

00800db6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dce:	73 50                	jae    800e20 <memmove+0x6a>
  800dd0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dd3:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd6:	01 d0                	add    %edx,%eax
  800dd8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ddb:	76 43                	jbe    800e20 <memmove+0x6a>
		s += n;
  800ddd:	8b 45 10             	mov    0x10(%ebp),%eax
  800de0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800de3:	8b 45 10             	mov    0x10(%ebp),%eax
  800de6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800de9:	eb 10                	jmp    800dfb <memmove+0x45>
			*--d = *--s;
  800deb:	ff 4d f8             	decl   -0x8(%ebp)
  800dee:	ff 4d fc             	decl   -0x4(%ebp)
  800df1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df4:	8a 10                	mov    (%eax),%dl
  800df6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800dfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e01:	89 55 10             	mov    %edx,0x10(%ebp)
  800e04:	85 c0                	test   %eax,%eax
  800e06:	75 e3                	jne    800deb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e08:	eb 23                	jmp    800e2d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e0d:	8d 50 01             	lea    0x1(%eax),%edx
  800e10:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e16:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e19:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e1c:	8a 12                	mov    (%edx),%dl
  800e1e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e20:	8b 45 10             	mov    0x10(%ebp),%eax
  800e23:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e26:	89 55 10             	mov    %edx,0x10(%ebp)
  800e29:	85 c0                	test   %eax,%eax
  800e2b:	75 dd                	jne    800e0a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e30:	c9                   	leave  
  800e31:	c3                   	ret    

00800e32 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
  800e35:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e41:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e44:	eb 2a                	jmp    800e70 <memcmp+0x3e>
		if (*s1 != *s2)
  800e46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e49:	8a 10                	mov    (%eax),%dl
  800e4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	38 c2                	cmp    %al,%dl
  800e52:	74 16                	je     800e6a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	0f b6 d0             	movzbl %al,%edx
  800e5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5f:	8a 00                	mov    (%eax),%al
  800e61:	0f b6 c0             	movzbl %al,%eax
  800e64:	29 c2                	sub    %eax,%edx
  800e66:	89 d0                	mov    %edx,%eax
  800e68:	eb 18                	jmp    800e82 <memcmp+0x50>
		s1++, s2++;
  800e6a:	ff 45 fc             	incl   -0x4(%ebp)
  800e6d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e70:	8b 45 10             	mov    0x10(%ebp),%eax
  800e73:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e76:	89 55 10             	mov    %edx,0x10(%ebp)
  800e79:	85 c0                	test   %eax,%eax
  800e7b:	75 c9                	jne    800e46 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e82:	c9                   	leave  
  800e83:	c3                   	ret    

00800e84 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e84:	55                   	push   %ebp
  800e85:	89 e5                	mov    %esp,%ebp
  800e87:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e90:	01 d0                	add    %edx,%eax
  800e92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e95:	eb 15                	jmp    800eac <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	8a 00                	mov    (%eax),%al
  800e9c:	0f b6 d0             	movzbl %al,%edx
  800e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea2:	0f b6 c0             	movzbl %al,%eax
  800ea5:	39 c2                	cmp    %eax,%edx
  800ea7:	74 0d                	je     800eb6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ea9:	ff 45 08             	incl   0x8(%ebp)
  800eac:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800eb2:	72 e3                	jb     800e97 <memfind+0x13>
  800eb4:	eb 01                	jmp    800eb7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800eb6:	90                   	nop
	return (void *) s;
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eba:	c9                   	leave  
  800ebb:	c3                   	ret    

00800ebc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ec2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ec9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ed0:	eb 03                	jmp    800ed5 <strtol+0x19>
		s++;
  800ed2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	8a 00                	mov    (%eax),%al
  800eda:	3c 20                	cmp    $0x20,%al
  800edc:	74 f4                	je     800ed2 <strtol+0x16>
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8a 00                	mov    (%eax),%al
  800ee3:	3c 09                	cmp    $0x9,%al
  800ee5:	74 eb                	je     800ed2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	8a 00                	mov    (%eax),%al
  800eec:	3c 2b                	cmp    $0x2b,%al
  800eee:	75 05                	jne    800ef5 <strtol+0x39>
		s++;
  800ef0:	ff 45 08             	incl   0x8(%ebp)
  800ef3:	eb 13                	jmp    800f08 <strtol+0x4c>
	else if (*s == '-')
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	8a 00                	mov    (%eax),%al
  800efa:	3c 2d                	cmp    $0x2d,%al
  800efc:	75 0a                	jne    800f08 <strtol+0x4c>
		s++, neg = 1;
  800efe:	ff 45 08             	incl   0x8(%ebp)
  800f01:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f08:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0c:	74 06                	je     800f14 <strtol+0x58>
  800f0e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f12:	75 20                	jne    800f34 <strtol+0x78>
  800f14:	8b 45 08             	mov    0x8(%ebp),%eax
  800f17:	8a 00                	mov    (%eax),%al
  800f19:	3c 30                	cmp    $0x30,%al
  800f1b:	75 17                	jne    800f34 <strtol+0x78>
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	40                   	inc    %eax
  800f21:	8a 00                	mov    (%eax),%al
  800f23:	3c 78                	cmp    $0x78,%al
  800f25:	75 0d                	jne    800f34 <strtol+0x78>
		s += 2, base = 16;
  800f27:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f2b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f32:	eb 28                	jmp    800f5c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f38:	75 15                	jne    800f4f <strtol+0x93>
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	3c 30                	cmp    $0x30,%al
  800f41:	75 0c                	jne    800f4f <strtol+0x93>
		s++, base = 8;
  800f43:	ff 45 08             	incl   0x8(%ebp)
  800f46:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f4d:	eb 0d                	jmp    800f5c <strtol+0xa0>
	else if (base == 0)
  800f4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f53:	75 07                	jne    800f5c <strtol+0xa0>
		base = 10;
  800f55:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	8a 00                	mov    (%eax),%al
  800f61:	3c 2f                	cmp    $0x2f,%al
  800f63:	7e 19                	jle    800f7e <strtol+0xc2>
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	3c 39                	cmp    $0x39,%al
  800f6c:	7f 10                	jg     800f7e <strtol+0xc2>
			dig = *s - '0';
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	0f be c0             	movsbl %al,%eax
  800f76:	83 e8 30             	sub    $0x30,%eax
  800f79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f7c:	eb 42                	jmp    800fc0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	3c 60                	cmp    $0x60,%al
  800f85:	7e 19                	jle    800fa0 <strtol+0xe4>
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	8a 00                	mov    (%eax),%al
  800f8c:	3c 7a                	cmp    $0x7a,%al
  800f8e:	7f 10                	jg     800fa0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	0f be c0             	movsbl %al,%eax
  800f98:	83 e8 57             	sub    $0x57,%eax
  800f9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f9e:	eb 20                	jmp    800fc0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	3c 40                	cmp    $0x40,%al
  800fa7:	7e 39                	jle    800fe2 <strtol+0x126>
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	3c 5a                	cmp    $0x5a,%al
  800fb0:	7f 30                	jg     800fe2 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	8a 00                	mov    (%eax),%al
  800fb7:	0f be c0             	movsbl %al,%eax
  800fba:	83 e8 37             	sub    $0x37,%eax
  800fbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fc3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fc6:	7d 19                	jge    800fe1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fc8:	ff 45 08             	incl   0x8(%ebp)
  800fcb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fce:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fd2:	89 c2                	mov    %eax,%edx
  800fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd7:	01 d0                	add    %edx,%eax
  800fd9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800fdc:	e9 7b ff ff ff       	jmp    800f5c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800fe1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800fe2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fe6:	74 08                	je     800ff0 <strtol+0x134>
		*endptr = (char *) s;
  800fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800feb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fee:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800ff0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ff4:	74 07                	je     800ffd <strtol+0x141>
  800ff6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff9:	f7 d8                	neg    %eax
  800ffb:	eb 03                	jmp    801000 <strtol+0x144>
  800ffd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801000:	c9                   	leave  
  801001:	c3                   	ret    

00801002 <ltostr>:

void
ltostr(long value, char *str)
{
  801002:	55                   	push   %ebp
  801003:	89 e5                	mov    %esp,%ebp
  801005:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801008:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80100f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801016:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80101a:	79 13                	jns    80102f <ltostr+0x2d>
	{
		neg = 1;
  80101c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801023:	8b 45 0c             	mov    0xc(%ebp),%eax
  801026:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801029:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80102c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801037:	99                   	cltd   
  801038:	f7 f9                	idiv   %ecx
  80103a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80103d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801040:	8d 50 01             	lea    0x1(%eax),%edx
  801043:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801046:	89 c2                	mov    %eax,%edx
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	01 d0                	add    %edx,%eax
  80104d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801050:	83 c2 30             	add    $0x30,%edx
  801053:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801055:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801058:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80105d:	f7 e9                	imul   %ecx
  80105f:	c1 fa 02             	sar    $0x2,%edx
  801062:	89 c8                	mov    %ecx,%eax
  801064:	c1 f8 1f             	sar    $0x1f,%eax
  801067:	29 c2                	sub    %eax,%edx
  801069:	89 d0                	mov    %edx,%eax
  80106b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80106e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801072:	75 bb                	jne    80102f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801074:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80107b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107e:	48                   	dec    %eax
  80107f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801082:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801086:	74 3d                	je     8010c5 <ltostr+0xc3>
		start = 1 ;
  801088:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80108f:	eb 34                	jmp    8010c5 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801091:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801094:	8b 45 0c             	mov    0xc(%ebp),%eax
  801097:	01 d0                	add    %edx,%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80109e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a4:	01 c2                	add    %eax,%edx
  8010a6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ac:	01 c8                	add    %ecx,%eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b8:	01 c2                	add    %eax,%edx
  8010ba:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010bd:	88 02                	mov    %al,(%edx)
		start++ ;
  8010bf:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010c2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010cb:	7c c4                	jl     801091 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010cd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8010d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d3:	01 d0                	add    %edx,%eax
  8010d5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8010d8:	90                   	nop
  8010d9:	c9                   	leave  
  8010da:	c3                   	ret    

008010db <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8010e1:	ff 75 08             	pushl  0x8(%ebp)
  8010e4:	e8 73 fa ff ff       	call   800b5c <strlen>
  8010e9:	83 c4 04             	add    $0x4,%esp
  8010ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8010ef:	ff 75 0c             	pushl  0xc(%ebp)
  8010f2:	e8 65 fa ff ff       	call   800b5c <strlen>
  8010f7:	83 c4 04             	add    $0x4,%esp
  8010fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801104:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80110b:	eb 17                	jmp    801124 <strcconcat+0x49>
		final[s] = str1[s] ;
  80110d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801110:	8b 45 10             	mov    0x10(%ebp),%eax
  801113:	01 c2                	add    %eax,%edx
  801115:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	01 c8                	add    %ecx,%eax
  80111d:	8a 00                	mov    (%eax),%al
  80111f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801121:	ff 45 fc             	incl   -0x4(%ebp)
  801124:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801127:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80112a:	7c e1                	jl     80110d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80112c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801133:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80113a:	eb 1f                	jmp    80115b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80113c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80113f:	8d 50 01             	lea    0x1(%eax),%edx
  801142:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801145:	89 c2                	mov    %eax,%edx
  801147:	8b 45 10             	mov    0x10(%ebp),%eax
  80114a:	01 c2                	add    %eax,%edx
  80114c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	01 c8                	add    %ecx,%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801158:	ff 45 f8             	incl   -0x8(%ebp)
  80115b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801161:	7c d9                	jl     80113c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801163:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801166:	8b 45 10             	mov    0x10(%ebp),%eax
  801169:	01 d0                	add    %edx,%eax
  80116b:	c6 00 00             	movb   $0x0,(%eax)
}
  80116e:	90                   	nop
  80116f:	c9                   	leave  
  801170:	c3                   	ret    

00801171 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801174:	8b 45 14             	mov    0x14(%ebp),%eax
  801177:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80117d:	8b 45 14             	mov    0x14(%ebp),%eax
  801180:	8b 00                	mov    (%eax),%eax
  801182:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801189:	8b 45 10             	mov    0x10(%ebp),%eax
  80118c:	01 d0                	add    %edx,%eax
  80118e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801194:	eb 0c                	jmp    8011a2 <strsplit+0x31>
			*string++ = 0;
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	8d 50 01             	lea    0x1(%eax),%edx
  80119c:	89 55 08             	mov    %edx,0x8(%ebp)
  80119f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a5:	8a 00                	mov    (%eax),%al
  8011a7:	84 c0                	test   %al,%al
  8011a9:	74 18                	je     8011c3 <strsplit+0x52>
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	8a 00                	mov    (%eax),%al
  8011b0:	0f be c0             	movsbl %al,%eax
  8011b3:	50                   	push   %eax
  8011b4:	ff 75 0c             	pushl  0xc(%ebp)
  8011b7:	e8 32 fb ff ff       	call   800cee <strchr>
  8011bc:	83 c4 08             	add    $0x8,%esp
  8011bf:	85 c0                	test   %eax,%eax
  8011c1:	75 d3                	jne    801196 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	8a 00                	mov    (%eax),%al
  8011c8:	84 c0                	test   %al,%al
  8011ca:	74 5a                	je     801226 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cf:	8b 00                	mov    (%eax),%eax
  8011d1:	83 f8 0f             	cmp    $0xf,%eax
  8011d4:	75 07                	jne    8011dd <strsplit+0x6c>
		{
			return 0;
  8011d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8011db:	eb 66                	jmp    801243 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8011dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e0:	8b 00                	mov    (%eax),%eax
  8011e2:	8d 48 01             	lea    0x1(%eax),%ecx
  8011e5:	8b 55 14             	mov    0x14(%ebp),%edx
  8011e8:	89 0a                	mov    %ecx,(%edx)
  8011ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f4:	01 c2                	add    %eax,%edx
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011fb:	eb 03                	jmp    801200 <strsplit+0x8f>
			string++;
  8011fd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	8a 00                	mov    (%eax),%al
  801205:	84 c0                	test   %al,%al
  801207:	74 8b                	je     801194 <strsplit+0x23>
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	0f be c0             	movsbl %al,%eax
  801211:	50                   	push   %eax
  801212:	ff 75 0c             	pushl  0xc(%ebp)
  801215:	e8 d4 fa ff ff       	call   800cee <strchr>
  80121a:	83 c4 08             	add    $0x8,%esp
  80121d:	85 c0                	test   %eax,%eax
  80121f:	74 dc                	je     8011fd <strsplit+0x8c>
			string++;
	}
  801221:	e9 6e ff ff ff       	jmp    801194 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801226:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801227:	8b 45 14             	mov    0x14(%ebp),%eax
  80122a:	8b 00                	mov    (%eax),%eax
  80122c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801233:	8b 45 10             	mov    0x10(%ebp),%eax
  801236:	01 d0                	add    %edx,%eax
  801238:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80123e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801243:	c9                   	leave  
  801244:	c3                   	ret    

00801245 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
  801248:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80124b:	83 ec 04             	sub    $0x4,%esp
  80124e:	68 28 22 80 00       	push   $0x802228
  801253:	68 3f 01 00 00       	push   $0x13f
  801258:	68 4a 22 80 00       	push   $0x80224a
  80125d:	e8 a9 ef ff ff       	call   80020b <_panic>

00801262 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	57                   	push   %edi
  801266:	56                   	push   %esi
  801267:	53                   	push   %ebx
  801268:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801271:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801274:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801277:	8b 7d 18             	mov    0x18(%ebp),%edi
  80127a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80127d:	cd 30                	int    $0x30
  80127f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801282:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801285:	83 c4 10             	add    $0x10,%esp
  801288:	5b                   	pop    %ebx
  801289:	5e                   	pop    %esi
  80128a:	5f                   	pop    %edi
  80128b:	5d                   	pop    %ebp
  80128c:	c3                   	ret    

0080128d <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  80128d:	55                   	push   %ebp
  80128e:	89 e5                	mov    %esp,%ebp
  801290:	83 ec 04             	sub    $0x4,%esp
  801293:	8b 45 10             	mov    0x10(%ebp),%eax
  801296:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801299:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	6a 00                	push   $0x0
  8012a2:	6a 00                	push   $0x0
  8012a4:	52                   	push   %edx
  8012a5:	ff 75 0c             	pushl  0xc(%ebp)
  8012a8:	50                   	push   %eax
  8012a9:	6a 00                	push   $0x0
  8012ab:	e8 b2 ff ff ff       	call   801262 <syscall>
  8012b0:	83 c4 18             	add    $0x18,%esp
}
  8012b3:	90                   	nop
  8012b4:	c9                   	leave  
  8012b5:	c3                   	ret    

008012b6 <sys_cgetc>:

int sys_cgetc(void) {
  8012b6:	55                   	push   %ebp
  8012b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012b9:	6a 00                	push   $0x0
  8012bb:	6a 00                	push   $0x0
  8012bd:	6a 00                	push   $0x0
  8012bf:	6a 00                	push   $0x0
  8012c1:	6a 00                	push   $0x0
  8012c3:	6a 02                	push   $0x2
  8012c5:	e8 98 ff ff ff       	call   801262 <syscall>
  8012ca:	83 c4 18             	add    $0x18,%esp
}
  8012cd:	c9                   	leave  
  8012ce:	c3                   	ret    

008012cf <sys_lock_cons>:

void sys_lock_cons(void) {
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8012d2:	6a 00                	push   $0x0
  8012d4:	6a 00                	push   $0x0
  8012d6:	6a 00                	push   $0x0
  8012d8:	6a 00                	push   $0x0
  8012da:	6a 00                	push   $0x0
  8012dc:	6a 03                	push   $0x3
  8012de:	e8 7f ff ff ff       	call   801262 <syscall>
  8012e3:	83 c4 18             	add    $0x18,%esp
}
  8012e6:	90                   	nop
  8012e7:	c9                   	leave  
  8012e8:	c3                   	ret    

008012e9 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8012ec:	6a 00                	push   $0x0
  8012ee:	6a 00                	push   $0x0
  8012f0:	6a 00                	push   $0x0
  8012f2:	6a 00                	push   $0x0
  8012f4:	6a 00                	push   $0x0
  8012f6:	6a 04                	push   $0x4
  8012f8:	e8 65 ff ff ff       	call   801262 <syscall>
  8012fd:	83 c4 18             	add    $0x18,%esp
}
  801300:	90                   	nop
  801301:	c9                   	leave  
  801302:	c3                   	ret    

00801303 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801306:	8b 55 0c             	mov    0xc(%ebp),%edx
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	6a 00                	push   $0x0
  80130e:	6a 00                	push   $0x0
  801310:	6a 00                	push   $0x0
  801312:	52                   	push   %edx
  801313:	50                   	push   %eax
  801314:	6a 08                	push   $0x8
  801316:	e8 47 ff ff ff       	call   801262 <syscall>
  80131b:	83 c4 18             	add    $0x18,%esp
}
  80131e:	c9                   	leave  
  80131f:	c3                   	ret    

00801320 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
  801323:	56                   	push   %esi
  801324:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801325:	8b 75 18             	mov    0x18(%ebp),%esi
  801328:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80132b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80132e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	56                   	push   %esi
  801335:	53                   	push   %ebx
  801336:	51                   	push   %ecx
  801337:	52                   	push   %edx
  801338:	50                   	push   %eax
  801339:	6a 09                	push   $0x9
  80133b:	e8 22 ff ff ff       	call   801262 <syscall>
  801340:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801343:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801346:	5b                   	pop    %ebx
  801347:	5e                   	pop    %esi
  801348:	5d                   	pop    %ebp
  801349:	c3                   	ret    

0080134a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80134d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	52                   	push   %edx
  80135a:	50                   	push   %eax
  80135b:	6a 0a                	push   $0xa
  80135d:	e8 00 ff ff ff       	call   801262 <syscall>
  801362:	83 c4 18             	add    $0x18,%esp
}
  801365:	c9                   	leave  
  801366:	c3                   	ret    

00801367 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  80136a:	6a 00                	push   $0x0
  80136c:	6a 00                	push   $0x0
  80136e:	6a 00                	push   $0x0
  801370:	ff 75 0c             	pushl  0xc(%ebp)
  801373:	ff 75 08             	pushl  0x8(%ebp)
  801376:	6a 0b                	push   $0xb
  801378:	e8 e5 fe ff ff       	call   801262 <syscall>
  80137d:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801380:	c9                   	leave  
  801381:	c3                   	ret    

00801382 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 0c                	push   $0xc
  801391:	e8 cc fe ff ff       	call   801262 <syscall>
  801396:	83 c4 18             	add    $0x18,%esp
}
  801399:	c9                   	leave  
  80139a:	c3                   	ret    

0080139b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 0d                	push   $0xd
  8013aa:	e8 b3 fe ff ff       	call   801262 <syscall>
  8013af:	83 c4 18             	add    $0x18,%esp
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 0e                	push   $0xe
  8013c3:	e8 9a fe ff ff       	call   801262 <syscall>
  8013c8:	83 c4 18             	add    $0x18,%esp
}
  8013cb:	c9                   	leave  
  8013cc:	c3                   	ret    

008013cd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 0f                	push   $0xf
  8013dc:	e8 81 fe ff ff       	call   801262 <syscall>
  8013e1:	83 c4 18             	add    $0x18,%esp
}
  8013e4:	c9                   	leave  
  8013e5:	c3                   	ret    

008013e6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  8013e6:	55                   	push   %ebp
  8013e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 00                	push   $0x0
  8013f1:	ff 75 08             	pushl  0x8(%ebp)
  8013f4:	6a 10                	push   $0x10
  8013f6:	e8 67 fe ff ff       	call   801262 <syscall>
  8013fb:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  8013fe:	c9                   	leave  
  8013ff:	c3                   	ret    

00801400 <sys_scarce_memory>:

void sys_scarce_memory() {
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801403:	6a 00                	push   $0x0
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	6a 00                	push   $0x0
  80140d:	6a 11                	push   $0x11
  80140f:	e8 4e fe ff ff       	call   801262 <syscall>
  801414:	83 c4 18             	add    $0x18,%esp
}
  801417:	90                   	nop
  801418:	c9                   	leave  
  801419:	c3                   	ret    

0080141a <sys_cputc>:

void sys_cputc(const char c) {
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	83 ec 04             	sub    $0x4,%esp
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801426:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	50                   	push   %eax
  801433:	6a 01                	push   $0x1
  801435:	e8 28 fe ff ff       	call   801262 <syscall>
  80143a:	83 c4 18             	add    $0x18,%esp
}
  80143d:	90                   	nop
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 00                	push   $0x0
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	6a 14                	push   $0x14
  80144f:	e8 0e fe ff ff       	call   801262 <syscall>
  801454:	83 c4 18             	add    $0x18,%esp
}
  801457:	90                   	nop
  801458:	c9                   	leave  
  801459:	c3                   	ret    

0080145a <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
  80145d:	83 ec 04             	sub    $0x4,%esp
  801460:	8b 45 10             	mov    0x10(%ebp),%eax
  801463:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801466:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801469:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	6a 00                	push   $0x0
  801472:	51                   	push   %ecx
  801473:	52                   	push   %edx
  801474:	ff 75 0c             	pushl  0xc(%ebp)
  801477:	50                   	push   %eax
  801478:	6a 15                	push   $0x15
  80147a:	e8 e3 fd ff ff       	call   801262 <syscall>
  80147f:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801482:	c9                   	leave  
  801483:	c3                   	ret    

00801484 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801487:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148a:	8b 45 08             	mov    0x8(%ebp),%eax
  80148d:	6a 00                	push   $0x0
  80148f:	6a 00                	push   $0x0
  801491:	6a 00                	push   $0x0
  801493:	52                   	push   %edx
  801494:	50                   	push   %eax
  801495:	6a 16                	push   $0x16
  801497:	e8 c6 fd ff ff       	call   801262 <syscall>
  80149c:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  80149f:	c9                   	leave  
  8014a0:	c3                   	ret    

008014a1 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  8014a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	51                   	push   %ecx
  8014b2:	52                   	push   %edx
  8014b3:	50                   	push   %eax
  8014b4:	6a 17                	push   $0x17
  8014b6:	e8 a7 fd ff ff       	call   801262 <syscall>
  8014bb:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  8014be:	c9                   	leave  
  8014bf:	c3                   	ret    

008014c0 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  8014c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 00                	push   $0x0
  8014cf:	52                   	push   %edx
  8014d0:	50                   	push   %eax
  8014d1:	6a 18                	push   $0x18
  8014d3:	e8 8a fd ff ff       	call   801262 <syscall>
  8014d8:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    

008014dd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	6a 00                	push   $0x0
  8014e5:	ff 75 14             	pushl  0x14(%ebp)
  8014e8:	ff 75 10             	pushl  0x10(%ebp)
  8014eb:	ff 75 0c             	pushl  0xc(%ebp)
  8014ee:	50                   	push   %eax
  8014ef:	6a 19                	push   $0x19
  8014f1:	e8 6c fd ff ff       	call   801262 <syscall>
  8014f6:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <sys_run_env>:

void sys_run_env(int32 envId) {
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	50                   	push   %eax
  80150a:	6a 1a                	push   $0x1a
  80150c:	e8 51 fd ff ff       	call   801262 <syscall>
  801511:	83 c4 18             	add    $0x18,%esp
}
  801514:	90                   	nop
  801515:	c9                   	leave  
  801516:	c3                   	ret    

00801517 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	6a 00                	push   $0x0
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	50                   	push   %eax
  801526:	6a 1b                	push   $0x1b
  801528:	e8 35 fd ff ff       	call   801262 <syscall>
  80152d:	83 c4 18             	add    $0x18,%esp
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <sys_getenvid>:

int32 sys_getenvid(void) {
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 05                	push   $0x5
  801541:	e8 1c fd ff ff       	call   801262 <syscall>
  801546:	83 c4 18             	add    $0x18,%esp
}
  801549:	c9                   	leave  
  80154a:	c3                   	ret    

0080154b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	6a 06                	push   $0x6
  80155a:	e8 03 fd ff ff       	call   801262 <syscall>
  80155f:	83 c4 18             	add    $0x18,%esp
}
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 07                	push   $0x7
  801573:	e8 ea fc ff ff       	call   801262 <syscall>
  801578:	83 c4 18             	add    $0x18,%esp
}
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <sys_exit_env>:

void sys_exit_env(void) {
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 1c                	push   $0x1c
  80158c:	e8 d1 fc ff ff       	call   801262 <syscall>
  801591:	83 c4 18             	add    $0x18,%esp
}
  801594:	90                   	nop
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  80159d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015a0:	8d 50 04             	lea    0x4(%eax),%edx
  8015a3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	52                   	push   %edx
  8015ad:	50                   	push   %eax
  8015ae:	6a 1d                	push   $0x1d
  8015b0:	e8 ad fc ff ff       	call   801262 <syscall>
  8015b5:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  8015b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c1:	89 01                	mov    %eax,(%ecx)
  8015c3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8015c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c9:	c9                   	leave  
  8015ca:	c2 04 00             	ret    $0x4

008015cd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	ff 75 10             	pushl  0x10(%ebp)
  8015d7:	ff 75 0c             	pushl  0xc(%ebp)
  8015da:	ff 75 08             	pushl  0x8(%ebp)
  8015dd:	6a 13                	push   $0x13
  8015df:	e8 7e fc ff ff       	call   801262 <syscall>
  8015e4:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  8015e7:	90                   	nop
}
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <sys_rcr2>:
uint32 sys_rcr2() {
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 1e                	push   $0x1e
  8015f9:	e8 64 fc ff ff       	call   801262 <syscall>
  8015fe:	83 c4 18             	add    $0x18,%esp
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	83 ec 04             	sub    $0x4,%esp
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
  80160c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80160f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	50                   	push   %eax
  80161c:	6a 1f                	push   $0x1f
  80161e:	e8 3f fc ff ff       	call   801262 <syscall>
  801623:	83 c4 18             	add    $0x18,%esp
	return;
  801626:	90                   	nop
}
  801627:	c9                   	leave  
  801628:	c3                   	ret    

00801629 <rsttst>:
void rsttst() {
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 21                	push   $0x21
  801638:	e8 25 fc ff ff       	call   801262 <syscall>
  80163d:	83 c4 18             	add    $0x18,%esp
	return;
  801640:	90                   	nop
}
  801641:	c9                   	leave  
  801642:	c3                   	ret    

00801643 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
  801646:	83 ec 04             	sub    $0x4,%esp
  801649:	8b 45 14             	mov    0x14(%ebp),%eax
  80164c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80164f:	8b 55 18             	mov    0x18(%ebp),%edx
  801652:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801656:	52                   	push   %edx
  801657:	50                   	push   %eax
  801658:	ff 75 10             	pushl  0x10(%ebp)
  80165b:	ff 75 0c             	pushl  0xc(%ebp)
  80165e:	ff 75 08             	pushl  0x8(%ebp)
  801661:	6a 20                	push   $0x20
  801663:	e8 fa fb ff ff       	call   801262 <syscall>
  801668:	83 c4 18             	add    $0x18,%esp
	return;
  80166b:	90                   	nop
}
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    

0080166e <chktst>:
void chktst(uint32 n) {
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	ff 75 08             	pushl  0x8(%ebp)
  80167c:	6a 22                	push   $0x22
  80167e:	e8 df fb ff ff       	call   801262 <syscall>
  801683:	83 c4 18             	add    $0x18,%esp
	return;
  801686:	90                   	nop
}
  801687:	c9                   	leave  
  801688:	c3                   	ret    

00801689 <inctst>:

void inctst() {
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 23                	push   $0x23
  801698:	e8 c5 fb ff ff       	call   801262 <syscall>
  80169d:	83 c4 18             	add    $0x18,%esp
	return;
  8016a0:	90                   	nop
}
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <gettst>:
uint32 gettst() {
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 24                	push   $0x24
  8016b2:	e8 ab fb ff ff       	call   801262 <syscall>
  8016b7:	83 c4 18             	add    $0x18,%esp
}
  8016ba:	c9                   	leave  
  8016bb:	c3                   	ret    

008016bc <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
  8016bf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 25                	push   $0x25
  8016ce:	e8 8f fb ff ff       	call   801262 <syscall>
  8016d3:	83 c4 18             	add    $0x18,%esp
  8016d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8016d9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8016dd:	75 07                	jne    8016e6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8016df:	b8 01 00 00 00       	mov    $0x1,%eax
  8016e4:	eb 05                	jmp    8016eb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8016e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 25                	push   $0x25
  8016ff:	e8 5e fb ff ff       	call   801262 <syscall>
  801704:	83 c4 18             	add    $0x18,%esp
  801707:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80170a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80170e:	75 07                	jne    801717 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801710:	b8 01 00 00 00       	mov    $0x1,%eax
  801715:	eb 05                	jmp    80171c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801717:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
  801721:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 25                	push   $0x25
  801730:	e8 2d fb ff ff       	call   801262 <syscall>
  801735:	83 c4 18             	add    $0x18,%esp
  801738:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80173b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80173f:	75 07                	jne    801748 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801741:	b8 01 00 00 00       	mov    $0x1,%eax
  801746:	eb 05                	jmp    80174d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801748:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174d:	c9                   	leave  
  80174e:	c3                   	ret    

0080174f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 25                	push   $0x25
  801761:	e8 fc fa ff ff       	call   801262 <syscall>
  801766:	83 c4 18             	add    $0x18,%esp
  801769:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80176c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801770:	75 07                	jne    801779 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801772:	b8 01 00 00 00       	mov    $0x1,%eax
  801777:	eb 05                	jmp    80177e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801779:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	ff 75 08             	pushl  0x8(%ebp)
  80178e:	6a 26                	push   $0x26
  801790:	e8 cd fa ff ff       	call   801262 <syscall>
  801795:	83 c4 18             	add    $0x18,%esp
	return;
  801798:	90                   	nop
}
  801799:	c9                   	leave  
  80179a:	c3                   	ret    

0080179b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
  80179e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  80179f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ab:	6a 00                	push   $0x0
  8017ad:	53                   	push   %ebx
  8017ae:	51                   	push   %ecx
  8017af:	52                   	push   %edx
  8017b0:	50                   	push   %eax
  8017b1:	6a 27                	push   $0x27
  8017b3:	e8 aa fa ff ff       	call   801262 <syscall>
  8017b8:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  8017bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  8017c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	52                   	push   %edx
  8017d0:	50                   	push   %eax
  8017d1:	6a 28                	push   $0x28
  8017d3:	e8 8a fa ff ff       	call   801262 <syscall>
  8017d8:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  8017e0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e9:	6a 00                	push   $0x0
  8017eb:	51                   	push   %ecx
  8017ec:	ff 75 10             	pushl  0x10(%ebp)
  8017ef:	52                   	push   %edx
  8017f0:	50                   	push   %eax
  8017f1:	6a 29                	push   $0x29
  8017f3:	e8 6a fa ff ff       	call   801262 <syscall>
  8017f8:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	ff 75 10             	pushl  0x10(%ebp)
  801807:	ff 75 0c             	pushl  0xc(%ebp)
  80180a:	ff 75 08             	pushl  0x8(%ebp)
  80180d:	6a 12                	push   $0x12
  80180f:	e8 4e fa ff ff       	call   801262 <syscall>
  801814:	83 c4 18             	add    $0x18,%esp
	return;
  801817:	90                   	nop
}
  801818:	c9                   	leave  
  801819:	c3                   	ret    

0080181a <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  80181d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	52                   	push   %edx
  80182a:	50                   	push   %eax
  80182b:	6a 2a                	push   $0x2a
  80182d:	e8 30 fa ff ff       	call   801262 <syscall>
  801832:	83 c4 18             	add    $0x18,%esp
	return;
  801835:	90                   	nop
}
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	50                   	push   %eax
  801847:	6a 2b                	push   $0x2b
  801849:	e8 14 fa ff ff       	call   801262 <syscall>
  80184e:	83 c4 18             	add    $0x18,%esp
}
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	ff 75 0c             	pushl  0xc(%ebp)
  80185f:	ff 75 08             	pushl  0x8(%ebp)
  801862:	6a 2c                	push   $0x2c
  801864:	e8 f9 f9 ff ff       	call   801262 <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
	return;
  80186c:	90                   	nop
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	ff 75 0c             	pushl  0xc(%ebp)
  80187b:	ff 75 08             	pushl  0x8(%ebp)
  80187e:	6a 2d                	push   $0x2d
  801880:	e8 dd f9 ff ff       	call   801262 <syscall>
  801885:	83 c4 18             	add    $0x18,%esp
	return;
  801888:	90                   	nop
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	50                   	push   %eax
  80189a:	6a 2f                	push   $0x2f
  80189c:	e8 c1 f9 ff ff       	call   801262 <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
	return;
  8018a4:	90                   	nop
}
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  8018aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	52                   	push   %edx
  8018b7:	50                   	push   %eax
  8018b8:	6a 30                	push   $0x30
  8018ba:	e8 a3 f9 ff ff       	call   801262 <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
	return;
  8018c2:	90                   	nop
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	50                   	push   %eax
  8018d4:	6a 31                	push   $0x31
  8018d6:	e8 87 f9 ff ff       	call   801262 <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
	return;
  8018de:	90                   	nop
}
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    

008018e1 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8018e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	52                   	push   %edx
  8018f1:	50                   	push   %eax
  8018f2:	6a 2e                	push   $0x2e
  8018f4:	e8 69 f9 ff ff       	call   801262 <syscall>
  8018f9:	83 c4 18             	add    $0x18,%esp
    return;
  8018fc:	90                   	nop
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    
  8018ff:	90                   	nop

00801900 <__udivdi3>:
  801900:	55                   	push   %ebp
  801901:	57                   	push   %edi
  801902:	56                   	push   %esi
  801903:	53                   	push   %ebx
  801904:	83 ec 1c             	sub    $0x1c,%esp
  801907:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80190b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80190f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801913:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801917:	89 ca                	mov    %ecx,%edx
  801919:	89 f8                	mov    %edi,%eax
  80191b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80191f:	85 f6                	test   %esi,%esi
  801921:	75 2d                	jne    801950 <__udivdi3+0x50>
  801923:	39 cf                	cmp    %ecx,%edi
  801925:	77 65                	ja     80198c <__udivdi3+0x8c>
  801927:	89 fd                	mov    %edi,%ebp
  801929:	85 ff                	test   %edi,%edi
  80192b:	75 0b                	jne    801938 <__udivdi3+0x38>
  80192d:	b8 01 00 00 00       	mov    $0x1,%eax
  801932:	31 d2                	xor    %edx,%edx
  801934:	f7 f7                	div    %edi
  801936:	89 c5                	mov    %eax,%ebp
  801938:	31 d2                	xor    %edx,%edx
  80193a:	89 c8                	mov    %ecx,%eax
  80193c:	f7 f5                	div    %ebp
  80193e:	89 c1                	mov    %eax,%ecx
  801940:	89 d8                	mov    %ebx,%eax
  801942:	f7 f5                	div    %ebp
  801944:	89 cf                	mov    %ecx,%edi
  801946:	89 fa                	mov    %edi,%edx
  801948:	83 c4 1c             	add    $0x1c,%esp
  80194b:	5b                   	pop    %ebx
  80194c:	5e                   	pop    %esi
  80194d:	5f                   	pop    %edi
  80194e:	5d                   	pop    %ebp
  80194f:	c3                   	ret    
  801950:	39 ce                	cmp    %ecx,%esi
  801952:	77 28                	ja     80197c <__udivdi3+0x7c>
  801954:	0f bd fe             	bsr    %esi,%edi
  801957:	83 f7 1f             	xor    $0x1f,%edi
  80195a:	75 40                	jne    80199c <__udivdi3+0x9c>
  80195c:	39 ce                	cmp    %ecx,%esi
  80195e:	72 0a                	jb     80196a <__udivdi3+0x6a>
  801960:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801964:	0f 87 9e 00 00 00    	ja     801a08 <__udivdi3+0x108>
  80196a:	b8 01 00 00 00       	mov    $0x1,%eax
  80196f:	89 fa                	mov    %edi,%edx
  801971:	83 c4 1c             	add    $0x1c,%esp
  801974:	5b                   	pop    %ebx
  801975:	5e                   	pop    %esi
  801976:	5f                   	pop    %edi
  801977:	5d                   	pop    %ebp
  801978:	c3                   	ret    
  801979:	8d 76 00             	lea    0x0(%esi),%esi
  80197c:	31 ff                	xor    %edi,%edi
  80197e:	31 c0                	xor    %eax,%eax
  801980:	89 fa                	mov    %edi,%edx
  801982:	83 c4 1c             	add    $0x1c,%esp
  801985:	5b                   	pop    %ebx
  801986:	5e                   	pop    %esi
  801987:	5f                   	pop    %edi
  801988:	5d                   	pop    %ebp
  801989:	c3                   	ret    
  80198a:	66 90                	xchg   %ax,%ax
  80198c:	89 d8                	mov    %ebx,%eax
  80198e:	f7 f7                	div    %edi
  801990:	31 ff                	xor    %edi,%edi
  801992:	89 fa                	mov    %edi,%edx
  801994:	83 c4 1c             	add    $0x1c,%esp
  801997:	5b                   	pop    %ebx
  801998:	5e                   	pop    %esi
  801999:	5f                   	pop    %edi
  80199a:	5d                   	pop    %ebp
  80199b:	c3                   	ret    
  80199c:	bd 20 00 00 00       	mov    $0x20,%ebp
  8019a1:	89 eb                	mov    %ebp,%ebx
  8019a3:	29 fb                	sub    %edi,%ebx
  8019a5:	89 f9                	mov    %edi,%ecx
  8019a7:	d3 e6                	shl    %cl,%esi
  8019a9:	89 c5                	mov    %eax,%ebp
  8019ab:	88 d9                	mov    %bl,%cl
  8019ad:	d3 ed                	shr    %cl,%ebp
  8019af:	89 e9                	mov    %ebp,%ecx
  8019b1:	09 f1                	or     %esi,%ecx
  8019b3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8019b7:	89 f9                	mov    %edi,%ecx
  8019b9:	d3 e0                	shl    %cl,%eax
  8019bb:	89 c5                	mov    %eax,%ebp
  8019bd:	89 d6                	mov    %edx,%esi
  8019bf:	88 d9                	mov    %bl,%cl
  8019c1:	d3 ee                	shr    %cl,%esi
  8019c3:	89 f9                	mov    %edi,%ecx
  8019c5:	d3 e2                	shl    %cl,%edx
  8019c7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019cb:	88 d9                	mov    %bl,%cl
  8019cd:	d3 e8                	shr    %cl,%eax
  8019cf:	09 c2                	or     %eax,%edx
  8019d1:	89 d0                	mov    %edx,%eax
  8019d3:	89 f2                	mov    %esi,%edx
  8019d5:	f7 74 24 0c          	divl   0xc(%esp)
  8019d9:	89 d6                	mov    %edx,%esi
  8019db:	89 c3                	mov    %eax,%ebx
  8019dd:	f7 e5                	mul    %ebp
  8019df:	39 d6                	cmp    %edx,%esi
  8019e1:	72 19                	jb     8019fc <__udivdi3+0xfc>
  8019e3:	74 0b                	je     8019f0 <__udivdi3+0xf0>
  8019e5:	89 d8                	mov    %ebx,%eax
  8019e7:	31 ff                	xor    %edi,%edi
  8019e9:	e9 58 ff ff ff       	jmp    801946 <__udivdi3+0x46>
  8019ee:	66 90                	xchg   %ax,%ax
  8019f0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8019f4:	89 f9                	mov    %edi,%ecx
  8019f6:	d3 e2                	shl    %cl,%edx
  8019f8:	39 c2                	cmp    %eax,%edx
  8019fa:	73 e9                	jae    8019e5 <__udivdi3+0xe5>
  8019fc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8019ff:	31 ff                	xor    %edi,%edi
  801a01:	e9 40 ff ff ff       	jmp    801946 <__udivdi3+0x46>
  801a06:	66 90                	xchg   %ax,%ax
  801a08:	31 c0                	xor    %eax,%eax
  801a0a:	e9 37 ff ff ff       	jmp    801946 <__udivdi3+0x46>
  801a0f:	90                   	nop

00801a10 <__umoddi3>:
  801a10:	55                   	push   %ebp
  801a11:	57                   	push   %edi
  801a12:	56                   	push   %esi
  801a13:	53                   	push   %ebx
  801a14:	83 ec 1c             	sub    $0x1c,%esp
  801a17:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a1b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a23:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a2b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a2f:	89 f3                	mov    %esi,%ebx
  801a31:	89 fa                	mov    %edi,%edx
  801a33:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a37:	89 34 24             	mov    %esi,(%esp)
  801a3a:	85 c0                	test   %eax,%eax
  801a3c:	75 1a                	jne    801a58 <__umoddi3+0x48>
  801a3e:	39 f7                	cmp    %esi,%edi
  801a40:	0f 86 a2 00 00 00    	jbe    801ae8 <__umoddi3+0xd8>
  801a46:	89 c8                	mov    %ecx,%eax
  801a48:	89 f2                	mov    %esi,%edx
  801a4a:	f7 f7                	div    %edi
  801a4c:	89 d0                	mov    %edx,%eax
  801a4e:	31 d2                	xor    %edx,%edx
  801a50:	83 c4 1c             	add    $0x1c,%esp
  801a53:	5b                   	pop    %ebx
  801a54:	5e                   	pop    %esi
  801a55:	5f                   	pop    %edi
  801a56:	5d                   	pop    %ebp
  801a57:	c3                   	ret    
  801a58:	39 f0                	cmp    %esi,%eax
  801a5a:	0f 87 ac 00 00 00    	ja     801b0c <__umoddi3+0xfc>
  801a60:	0f bd e8             	bsr    %eax,%ebp
  801a63:	83 f5 1f             	xor    $0x1f,%ebp
  801a66:	0f 84 ac 00 00 00    	je     801b18 <__umoddi3+0x108>
  801a6c:	bf 20 00 00 00       	mov    $0x20,%edi
  801a71:	29 ef                	sub    %ebp,%edi
  801a73:	89 fe                	mov    %edi,%esi
  801a75:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a79:	89 e9                	mov    %ebp,%ecx
  801a7b:	d3 e0                	shl    %cl,%eax
  801a7d:	89 d7                	mov    %edx,%edi
  801a7f:	89 f1                	mov    %esi,%ecx
  801a81:	d3 ef                	shr    %cl,%edi
  801a83:	09 c7                	or     %eax,%edi
  801a85:	89 e9                	mov    %ebp,%ecx
  801a87:	d3 e2                	shl    %cl,%edx
  801a89:	89 14 24             	mov    %edx,(%esp)
  801a8c:	89 d8                	mov    %ebx,%eax
  801a8e:	d3 e0                	shl    %cl,%eax
  801a90:	89 c2                	mov    %eax,%edx
  801a92:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a96:	d3 e0                	shl    %cl,%eax
  801a98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a9c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801aa0:	89 f1                	mov    %esi,%ecx
  801aa2:	d3 e8                	shr    %cl,%eax
  801aa4:	09 d0                	or     %edx,%eax
  801aa6:	d3 eb                	shr    %cl,%ebx
  801aa8:	89 da                	mov    %ebx,%edx
  801aaa:	f7 f7                	div    %edi
  801aac:	89 d3                	mov    %edx,%ebx
  801aae:	f7 24 24             	mull   (%esp)
  801ab1:	89 c6                	mov    %eax,%esi
  801ab3:	89 d1                	mov    %edx,%ecx
  801ab5:	39 d3                	cmp    %edx,%ebx
  801ab7:	0f 82 87 00 00 00    	jb     801b44 <__umoddi3+0x134>
  801abd:	0f 84 91 00 00 00    	je     801b54 <__umoddi3+0x144>
  801ac3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ac7:	29 f2                	sub    %esi,%edx
  801ac9:	19 cb                	sbb    %ecx,%ebx
  801acb:	89 d8                	mov    %ebx,%eax
  801acd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ad1:	d3 e0                	shl    %cl,%eax
  801ad3:	89 e9                	mov    %ebp,%ecx
  801ad5:	d3 ea                	shr    %cl,%edx
  801ad7:	09 d0                	or     %edx,%eax
  801ad9:	89 e9                	mov    %ebp,%ecx
  801adb:	d3 eb                	shr    %cl,%ebx
  801add:	89 da                	mov    %ebx,%edx
  801adf:	83 c4 1c             	add    $0x1c,%esp
  801ae2:	5b                   	pop    %ebx
  801ae3:	5e                   	pop    %esi
  801ae4:	5f                   	pop    %edi
  801ae5:	5d                   	pop    %ebp
  801ae6:	c3                   	ret    
  801ae7:	90                   	nop
  801ae8:	89 fd                	mov    %edi,%ebp
  801aea:	85 ff                	test   %edi,%edi
  801aec:	75 0b                	jne    801af9 <__umoddi3+0xe9>
  801aee:	b8 01 00 00 00       	mov    $0x1,%eax
  801af3:	31 d2                	xor    %edx,%edx
  801af5:	f7 f7                	div    %edi
  801af7:	89 c5                	mov    %eax,%ebp
  801af9:	89 f0                	mov    %esi,%eax
  801afb:	31 d2                	xor    %edx,%edx
  801afd:	f7 f5                	div    %ebp
  801aff:	89 c8                	mov    %ecx,%eax
  801b01:	f7 f5                	div    %ebp
  801b03:	89 d0                	mov    %edx,%eax
  801b05:	e9 44 ff ff ff       	jmp    801a4e <__umoddi3+0x3e>
  801b0a:	66 90                	xchg   %ax,%ax
  801b0c:	89 c8                	mov    %ecx,%eax
  801b0e:	89 f2                	mov    %esi,%edx
  801b10:	83 c4 1c             	add    $0x1c,%esp
  801b13:	5b                   	pop    %ebx
  801b14:	5e                   	pop    %esi
  801b15:	5f                   	pop    %edi
  801b16:	5d                   	pop    %ebp
  801b17:	c3                   	ret    
  801b18:	3b 04 24             	cmp    (%esp),%eax
  801b1b:	72 06                	jb     801b23 <__umoddi3+0x113>
  801b1d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b21:	77 0f                	ja     801b32 <__umoddi3+0x122>
  801b23:	89 f2                	mov    %esi,%edx
  801b25:	29 f9                	sub    %edi,%ecx
  801b27:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b2b:	89 14 24             	mov    %edx,(%esp)
  801b2e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b32:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b36:	8b 14 24             	mov    (%esp),%edx
  801b39:	83 c4 1c             	add    $0x1c,%esp
  801b3c:	5b                   	pop    %ebx
  801b3d:	5e                   	pop    %esi
  801b3e:	5f                   	pop    %edi
  801b3f:	5d                   	pop    %ebp
  801b40:	c3                   	ret    
  801b41:	8d 76 00             	lea    0x0(%esi),%esi
  801b44:	2b 04 24             	sub    (%esp),%eax
  801b47:	19 fa                	sbb    %edi,%edx
  801b49:	89 d1                	mov    %edx,%ecx
  801b4b:	89 c6                	mov    %eax,%esi
  801b4d:	e9 71 ff ff ff       	jmp    801ac3 <__umoddi3+0xb3>
  801b52:	66 90                	xchg   %ax,%ax
  801b54:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b58:	72 ea                	jb     801b44 <__umoddi3+0x134>
  801b5a:	89 d9                	mov    %ebx,%ecx
  801b5c:	e9 62 ff ff ff       	jmp    801ac3 <__umoddi3+0xb3>
