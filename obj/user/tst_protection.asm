
obj/user/tst_protection:     file format elf32-i386


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
  800031:	e8 bc 00 00 00       	call   8000f2 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp

	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003e:	a1 08 30 80 00       	mov    0x803008,%eax
  800043:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  800049:	a1 08 30 80 00       	mov    0x803008,%eax
  80004e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800054:	39 c2                	cmp    %eax,%edx
  800056:	72 14                	jb     80006c <_main+0x34>
			panic("Please increase the WS size");
  800058:	83 ec 04             	sub    $0x4,%esp
  80005b:	68 a0 1b 80 00       	push   $0x801ba0
  800060:	6a 12                	push   $0x12
  800062:	68 bc 1b 80 00       	push   $0x801bbc
  800067:	e8 cb 01 00 00       	call   800237 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	int numOfSlaves = 3;
  80006c:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
	rsttst();
  800073:	e8 dd 15 00 00       	call   801655 <rsttst>

	//[1] Run programs that allocate many shared variables
	for (int i = 0; i < numOfSlaves; ++i) {
  800078:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80007f:	eb 47                	jmp    8000c8 <_main+0x90>
		int32 envId = sys_create_env("protection_slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800081:	a1 08 30 80 00       	mov    0x803008,%eax
  800086:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  80008c:	a1 08 30 80 00       	mov    0x803008,%eax
  800091:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  800097:	89 c1                	mov    %eax,%ecx
  800099:	a1 08 30 80 00       	mov    0x803008,%eax
  80009e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000a4:	52                   	push   %edx
  8000a5:	51                   	push   %ecx
  8000a6:	50                   	push   %eax
  8000a7:	68 d2 1b 80 00       	push   $0x801bd2
  8000ac:	e8 58 14 00 00       	call   801509 <sys_create_env>
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		sys_run_env(envId);
  8000b7:	83 ec 0c             	sub    $0xc,%esp
  8000ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8000bd:	e8 65 14 00 00       	call   801527 <sys_run_env>
  8000c2:	83 c4 10             	add    $0x10,%esp

	int numOfSlaves = 3;
	rsttst();

	//[1] Run programs that allocate many shared variables
	for (int i = 0; i < numOfSlaves; ++i) {
  8000c5:	ff 45 f4             	incl   -0xc(%ebp)
  8000c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000ce:	7c b1                	jl     800081 <_main+0x49>
		int32 envId = sys_create_env("protection_slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
		sys_run_env(envId);
	}
	while (gettst() != numOfSlaves) ;
  8000d0:	90                   	nop
  8000d1:	e8 f9 15 00 00       	call   8016cf <gettst>
  8000d6:	89 c2                	mov    %eax,%edx
  8000d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000db:	39 c2                	cmp    %eax,%edx
  8000dd:	75 f2                	jne    8000d1 <_main+0x99>

	cprintf("%~\nCongratulations... test protection is run successfully\n");
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 e4 1b 80 00       	push   $0x801be4
  8000e7:	e8 08 04 00 00       	call   8004f4 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp

}
  8000ef:	90                   	nop
  8000f0:	c9                   	leave  
  8000f1:	c3                   	ret    

008000f2 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000f8:	e8 7a 14 00 00       	call   801577 <sys_getenvindex>
  8000fd:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800100:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800103:	89 d0                	mov    %edx,%eax
  800105:	c1 e0 02             	shl    $0x2,%eax
  800108:	01 d0                	add    %edx,%eax
  80010a:	c1 e0 03             	shl    $0x3,%eax
  80010d:	01 d0                	add    %edx,%eax
  80010f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800116:	01 d0                	add    %edx,%eax
  800118:	c1 e0 02             	shl    $0x2,%eax
  80011b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800120:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800125:	a1 08 30 80 00       	mov    0x803008,%eax
  80012a:	8a 40 20             	mov    0x20(%eax),%al
  80012d:	84 c0                	test   %al,%al
  80012f:	74 0d                	je     80013e <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800131:	a1 08 30 80 00       	mov    0x803008,%eax
  800136:	83 c0 20             	add    $0x20,%eax
  800139:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80013e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800142:	7e 0a                	jle    80014e <libmain+0x5c>
		binaryname = argv[0];
  800144:	8b 45 0c             	mov    0xc(%ebp),%eax
  800147:	8b 00                	mov    (%eax),%eax
  800149:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80014e:	83 ec 08             	sub    $0x8,%esp
  800151:	ff 75 0c             	pushl  0xc(%ebp)
  800154:	ff 75 08             	pushl  0x8(%ebp)
  800157:	e8 dc fe ff ff       	call   800038 <_main>
  80015c:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80015f:	a1 00 30 80 00       	mov    0x803000,%eax
  800164:	85 c0                	test   %eax,%eax
  800166:	0f 84 9f 00 00 00    	je     80020b <libmain+0x119>
	{
		sys_lock_cons();
  80016c:	e8 8a 11 00 00       	call   8012fb <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800171:	83 ec 0c             	sub    $0xc,%esp
  800174:	68 38 1c 80 00       	push   $0x801c38
  800179:	e8 76 03 00 00       	call   8004f4 <cprintf>
  80017e:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800181:	a1 08 30 80 00       	mov    0x803008,%eax
  800186:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80018c:	a1 08 30 80 00       	mov    0x803008,%eax
  800191:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800197:	83 ec 04             	sub    $0x4,%esp
  80019a:	52                   	push   %edx
  80019b:	50                   	push   %eax
  80019c:	68 60 1c 80 00       	push   $0x801c60
  8001a1:	e8 4e 03 00 00       	call   8004f4 <cprintf>
  8001a6:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001a9:	a1 08 30 80 00       	mov    0x803008,%eax
  8001ae:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8001b4:	a1 08 30 80 00       	mov    0x803008,%eax
  8001b9:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8001bf:	a1 08 30 80 00       	mov    0x803008,%eax
  8001c4:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8001ca:	51                   	push   %ecx
  8001cb:	52                   	push   %edx
  8001cc:	50                   	push   %eax
  8001cd:	68 88 1c 80 00       	push   $0x801c88
  8001d2:	e8 1d 03 00 00       	call   8004f4 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001da:	a1 08 30 80 00       	mov    0x803008,%eax
  8001df:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8001e5:	83 ec 08             	sub    $0x8,%esp
  8001e8:	50                   	push   %eax
  8001e9:	68 e0 1c 80 00       	push   $0x801ce0
  8001ee:	e8 01 03 00 00       	call   8004f4 <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001f6:	83 ec 0c             	sub    $0xc,%esp
  8001f9:	68 38 1c 80 00       	push   $0x801c38
  8001fe:	e8 f1 02 00 00       	call   8004f4 <cprintf>
  800203:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800206:	e8 0a 11 00 00       	call   801315 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80020b:	e8 19 00 00 00       	call   800229 <exit>
}
  800210:	90                   	nop
  800211:	c9                   	leave  
  800212:	c3                   	ret    

00800213 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800213:	55                   	push   %ebp
  800214:	89 e5                	mov    %esp,%ebp
  800216:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	6a 00                	push   $0x0
  80021e:	e8 20 13 00 00       	call   801543 <sys_destroy_env>
  800223:	83 c4 10             	add    $0x10,%esp
}
  800226:	90                   	nop
  800227:	c9                   	leave  
  800228:	c3                   	ret    

00800229 <exit>:

void
exit(void)
{
  800229:	55                   	push   %ebp
  80022a:	89 e5                	mov    %esp,%ebp
  80022c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80022f:	e8 75 13 00 00       	call   8015a9 <sys_exit_env>
}
  800234:	90                   	nop
  800235:	c9                   	leave  
  800236:	c3                   	ret    

00800237 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800237:	55                   	push   %ebp
  800238:	89 e5                	mov    %esp,%ebp
  80023a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80023d:	8d 45 10             	lea    0x10(%ebp),%eax
  800240:	83 c0 04             	add    $0x4,%eax
  800243:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800246:	a1 28 30 80 00       	mov    0x803028,%eax
  80024b:	85 c0                	test   %eax,%eax
  80024d:	74 16                	je     800265 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80024f:	a1 28 30 80 00       	mov    0x803028,%eax
  800254:	83 ec 08             	sub    $0x8,%esp
  800257:	50                   	push   %eax
  800258:	68 f4 1c 80 00       	push   $0x801cf4
  80025d:	e8 92 02 00 00       	call   8004f4 <cprintf>
  800262:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800265:	a1 04 30 80 00       	mov    0x803004,%eax
  80026a:	ff 75 0c             	pushl  0xc(%ebp)
  80026d:	ff 75 08             	pushl  0x8(%ebp)
  800270:	50                   	push   %eax
  800271:	68 f9 1c 80 00       	push   $0x801cf9
  800276:	e8 79 02 00 00       	call   8004f4 <cprintf>
  80027b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80027e:	8b 45 10             	mov    0x10(%ebp),%eax
  800281:	83 ec 08             	sub    $0x8,%esp
  800284:	ff 75 f4             	pushl  -0xc(%ebp)
  800287:	50                   	push   %eax
  800288:	e8 fc 01 00 00       	call   800489 <vcprintf>
  80028d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800290:	83 ec 08             	sub    $0x8,%esp
  800293:	6a 00                	push   $0x0
  800295:	68 15 1d 80 00       	push   $0x801d15
  80029a:	e8 ea 01 00 00       	call   800489 <vcprintf>
  80029f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002a2:	e8 82 ff ff ff       	call   800229 <exit>

	// should not return here
	while (1) ;
  8002a7:	eb fe                	jmp    8002a7 <_panic+0x70>

008002a9 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002af:	a1 08 30 80 00       	mov    0x803008,%eax
  8002b4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8002ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002bd:	39 c2                	cmp    %eax,%edx
  8002bf:	74 14                	je     8002d5 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002c1:	83 ec 04             	sub    $0x4,%esp
  8002c4:	68 18 1d 80 00       	push   $0x801d18
  8002c9:	6a 26                	push   $0x26
  8002cb:	68 64 1d 80 00       	push   $0x801d64
  8002d0:	e8 62 ff ff ff       	call   800237 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002e3:	e9 c5 00 00 00       	jmp    8003ad <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8002e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	01 d0                	add    %edx,%eax
  8002f7:	8b 00                	mov    (%eax),%eax
  8002f9:	85 c0                	test   %eax,%eax
  8002fb:	75 08                	jne    800305 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8002fd:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800300:	e9 a5 00 00 00       	jmp    8003aa <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800305:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80030c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800313:	eb 69                	jmp    80037e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800315:	a1 08 30 80 00       	mov    0x803008,%eax
  80031a:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800320:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800323:	89 d0                	mov    %edx,%eax
  800325:	01 c0                	add    %eax,%eax
  800327:	01 d0                	add    %edx,%eax
  800329:	c1 e0 03             	shl    $0x3,%eax
  80032c:	01 c8                	add    %ecx,%eax
  80032e:	8a 40 04             	mov    0x4(%eax),%al
  800331:	84 c0                	test   %al,%al
  800333:	75 46                	jne    80037b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800335:	a1 08 30 80 00       	mov    0x803008,%eax
  80033a:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800340:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800343:	89 d0                	mov    %edx,%eax
  800345:	01 c0                	add    %eax,%eax
  800347:	01 d0                	add    %edx,%eax
  800349:	c1 e0 03             	shl    $0x3,%eax
  80034c:	01 c8                	add    %ecx,%eax
  80034e:	8b 00                	mov    (%eax),%eax
  800350:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800353:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800356:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80035b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80035d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800360:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800367:	8b 45 08             	mov    0x8(%ebp),%eax
  80036a:	01 c8                	add    %ecx,%eax
  80036c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80036e:	39 c2                	cmp    %eax,%edx
  800370:	75 09                	jne    80037b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800372:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800379:	eb 15                	jmp    800390 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80037b:	ff 45 e8             	incl   -0x18(%ebp)
  80037e:	a1 08 30 80 00       	mov    0x803008,%eax
  800383:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800389:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80038c:	39 c2                	cmp    %eax,%edx
  80038e:	77 85                	ja     800315 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800390:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800394:	75 14                	jne    8003aa <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800396:	83 ec 04             	sub    $0x4,%esp
  800399:	68 70 1d 80 00       	push   $0x801d70
  80039e:	6a 3a                	push   $0x3a
  8003a0:	68 64 1d 80 00       	push   $0x801d64
  8003a5:	e8 8d fe ff ff       	call   800237 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003aa:	ff 45 f0             	incl   -0x10(%ebp)
  8003ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003b3:	0f 8c 2f ff ff ff    	jl     8002e8 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003b9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003c7:	eb 26                	jmp    8003ef <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003c9:	a1 08 30 80 00       	mov    0x803008,%eax
  8003ce:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8003d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003d7:	89 d0                	mov    %edx,%eax
  8003d9:	01 c0                	add    %eax,%eax
  8003db:	01 d0                	add    %edx,%eax
  8003dd:	c1 e0 03             	shl    $0x3,%eax
  8003e0:	01 c8                	add    %ecx,%eax
  8003e2:	8a 40 04             	mov    0x4(%eax),%al
  8003e5:	3c 01                	cmp    $0x1,%al
  8003e7:	75 03                	jne    8003ec <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8003e9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ec:	ff 45 e0             	incl   -0x20(%ebp)
  8003ef:	a1 08 30 80 00       	mov    0x803008,%eax
  8003f4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8003fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003fd:	39 c2                	cmp    %eax,%edx
  8003ff:	77 c8                	ja     8003c9 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800404:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800407:	74 14                	je     80041d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800409:	83 ec 04             	sub    $0x4,%esp
  80040c:	68 c4 1d 80 00       	push   $0x801dc4
  800411:	6a 44                	push   $0x44
  800413:	68 64 1d 80 00       	push   $0x801d64
  800418:	e8 1a fe ff ff       	call   800237 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80041d:	90                   	nop
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800426:	8b 45 0c             	mov    0xc(%ebp),%eax
  800429:	8b 00                	mov    (%eax),%eax
  80042b:	8d 48 01             	lea    0x1(%eax),%ecx
  80042e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800431:	89 0a                	mov    %ecx,(%edx)
  800433:	8b 55 08             	mov    0x8(%ebp),%edx
  800436:	88 d1                	mov    %dl,%cl
  800438:	8b 55 0c             	mov    0xc(%ebp),%edx
  80043b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80043f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800442:	8b 00                	mov    (%eax),%eax
  800444:	3d ff 00 00 00       	cmp    $0xff,%eax
  800449:	75 2c                	jne    800477 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80044b:	a0 0c 30 80 00       	mov    0x80300c,%al
  800450:	0f b6 c0             	movzbl %al,%eax
  800453:	8b 55 0c             	mov    0xc(%ebp),%edx
  800456:	8b 12                	mov    (%edx),%edx
  800458:	89 d1                	mov    %edx,%ecx
  80045a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80045d:	83 c2 08             	add    $0x8,%edx
  800460:	83 ec 04             	sub    $0x4,%esp
  800463:	50                   	push   %eax
  800464:	51                   	push   %ecx
  800465:	52                   	push   %edx
  800466:	e8 4e 0e 00 00       	call   8012b9 <sys_cputs>
  80046b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80046e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800471:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800477:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047a:	8b 40 04             	mov    0x4(%eax),%eax
  80047d:	8d 50 01             	lea    0x1(%eax),%edx
  800480:	8b 45 0c             	mov    0xc(%ebp),%eax
  800483:	89 50 04             	mov    %edx,0x4(%eax)
}
  800486:	90                   	nop
  800487:	c9                   	leave  
  800488:	c3                   	ret    

00800489 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800489:	55                   	push   %ebp
  80048a:	89 e5                	mov    %esp,%ebp
  80048c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800492:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800499:	00 00 00 
	b.cnt = 0;
  80049c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004a3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004a6:	ff 75 0c             	pushl  0xc(%ebp)
  8004a9:	ff 75 08             	pushl  0x8(%ebp)
  8004ac:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004b2:	50                   	push   %eax
  8004b3:	68 20 04 80 00       	push   $0x800420
  8004b8:	e8 11 02 00 00       	call   8006ce <vprintfmt>
  8004bd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004c0:	a0 0c 30 80 00       	mov    0x80300c,%al
  8004c5:	0f b6 c0             	movzbl %al,%eax
  8004c8:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004ce:	83 ec 04             	sub    $0x4,%esp
  8004d1:	50                   	push   %eax
  8004d2:	52                   	push   %edx
  8004d3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004d9:	83 c0 08             	add    $0x8,%eax
  8004dc:	50                   	push   %eax
  8004dd:	e8 d7 0d 00 00       	call   8012b9 <sys_cputs>
  8004e2:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004e5:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  8004ec:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004f2:	c9                   	leave  
  8004f3:	c3                   	ret    

008004f4 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8004f4:	55                   	push   %ebp
  8004f5:	89 e5                	mov    %esp,%ebp
  8004f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8004fa:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  800501:	8d 45 0c             	lea    0xc(%ebp),%eax
  800504:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800507:	8b 45 08             	mov    0x8(%ebp),%eax
  80050a:	83 ec 08             	sub    $0x8,%esp
  80050d:	ff 75 f4             	pushl  -0xc(%ebp)
  800510:	50                   	push   %eax
  800511:	e8 73 ff ff ff       	call   800489 <vcprintf>
  800516:	83 c4 10             	add    $0x10,%esp
  800519:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80051c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80051f:	c9                   	leave  
  800520:	c3                   	ret    

00800521 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800521:	55                   	push   %ebp
  800522:	89 e5                	mov    %esp,%ebp
  800524:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800527:	e8 cf 0d 00 00       	call   8012fb <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80052c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80052f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800532:	8b 45 08             	mov    0x8(%ebp),%eax
  800535:	83 ec 08             	sub    $0x8,%esp
  800538:	ff 75 f4             	pushl  -0xc(%ebp)
  80053b:	50                   	push   %eax
  80053c:	e8 48 ff ff ff       	call   800489 <vcprintf>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800547:	e8 c9 0d 00 00       	call   801315 <sys_unlock_cons>
	return cnt;
  80054c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80054f:	c9                   	leave  
  800550:	c3                   	ret    

00800551 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800551:	55                   	push   %ebp
  800552:	89 e5                	mov    %esp,%ebp
  800554:	53                   	push   %ebx
  800555:	83 ec 14             	sub    $0x14,%esp
  800558:	8b 45 10             	mov    0x10(%ebp),%eax
  80055b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80055e:	8b 45 14             	mov    0x14(%ebp),%eax
  800561:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800564:	8b 45 18             	mov    0x18(%ebp),%eax
  800567:	ba 00 00 00 00       	mov    $0x0,%edx
  80056c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80056f:	77 55                	ja     8005c6 <printnum+0x75>
  800571:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800574:	72 05                	jb     80057b <printnum+0x2a>
  800576:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800579:	77 4b                	ja     8005c6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80057b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80057e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800581:	8b 45 18             	mov    0x18(%ebp),%eax
  800584:	ba 00 00 00 00       	mov    $0x0,%edx
  800589:	52                   	push   %edx
  80058a:	50                   	push   %eax
  80058b:	ff 75 f4             	pushl  -0xc(%ebp)
  80058e:	ff 75 f0             	pushl  -0x10(%ebp)
  800591:	e8 96 13 00 00       	call   80192c <__udivdi3>
  800596:	83 c4 10             	add    $0x10,%esp
  800599:	83 ec 04             	sub    $0x4,%esp
  80059c:	ff 75 20             	pushl  0x20(%ebp)
  80059f:	53                   	push   %ebx
  8005a0:	ff 75 18             	pushl  0x18(%ebp)
  8005a3:	52                   	push   %edx
  8005a4:	50                   	push   %eax
  8005a5:	ff 75 0c             	pushl  0xc(%ebp)
  8005a8:	ff 75 08             	pushl  0x8(%ebp)
  8005ab:	e8 a1 ff ff ff       	call   800551 <printnum>
  8005b0:	83 c4 20             	add    $0x20,%esp
  8005b3:	eb 1a                	jmp    8005cf <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005b5:	83 ec 08             	sub    $0x8,%esp
  8005b8:	ff 75 0c             	pushl  0xc(%ebp)
  8005bb:	ff 75 20             	pushl  0x20(%ebp)
  8005be:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c1:	ff d0                	call   *%eax
  8005c3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005c6:	ff 4d 1c             	decl   0x1c(%ebp)
  8005c9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005cd:	7f e6                	jg     8005b5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005cf:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005d2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005dd:	53                   	push   %ebx
  8005de:	51                   	push   %ecx
  8005df:	52                   	push   %edx
  8005e0:	50                   	push   %eax
  8005e1:	e8 56 14 00 00       	call   801a3c <__umoddi3>
  8005e6:	83 c4 10             	add    $0x10,%esp
  8005e9:	05 34 20 80 00       	add    $0x802034,%eax
  8005ee:	8a 00                	mov    (%eax),%al
  8005f0:	0f be c0             	movsbl %al,%eax
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	50                   	push   %eax
  8005fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fd:	ff d0                	call   *%eax
  8005ff:	83 c4 10             	add    $0x10,%esp
}
  800602:	90                   	nop
  800603:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800606:	c9                   	leave  
  800607:	c3                   	ret    

00800608 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800608:	55                   	push   %ebp
  800609:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80060b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80060f:	7e 1c                	jle    80062d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800611:	8b 45 08             	mov    0x8(%ebp),%eax
  800614:	8b 00                	mov    (%eax),%eax
  800616:	8d 50 08             	lea    0x8(%eax),%edx
  800619:	8b 45 08             	mov    0x8(%ebp),%eax
  80061c:	89 10                	mov    %edx,(%eax)
  80061e:	8b 45 08             	mov    0x8(%ebp),%eax
  800621:	8b 00                	mov    (%eax),%eax
  800623:	83 e8 08             	sub    $0x8,%eax
  800626:	8b 50 04             	mov    0x4(%eax),%edx
  800629:	8b 00                	mov    (%eax),%eax
  80062b:	eb 40                	jmp    80066d <getuint+0x65>
	else if (lflag)
  80062d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800631:	74 1e                	je     800651 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800633:	8b 45 08             	mov    0x8(%ebp),%eax
  800636:	8b 00                	mov    (%eax),%eax
  800638:	8d 50 04             	lea    0x4(%eax),%edx
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	89 10                	mov    %edx,(%eax)
  800640:	8b 45 08             	mov    0x8(%ebp),%eax
  800643:	8b 00                	mov    (%eax),%eax
  800645:	83 e8 04             	sub    $0x4,%eax
  800648:	8b 00                	mov    (%eax),%eax
  80064a:	ba 00 00 00 00       	mov    $0x0,%edx
  80064f:	eb 1c                	jmp    80066d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800651:	8b 45 08             	mov    0x8(%ebp),%eax
  800654:	8b 00                	mov    (%eax),%eax
  800656:	8d 50 04             	lea    0x4(%eax),%edx
  800659:	8b 45 08             	mov    0x8(%ebp),%eax
  80065c:	89 10                	mov    %edx,(%eax)
  80065e:	8b 45 08             	mov    0x8(%ebp),%eax
  800661:	8b 00                	mov    (%eax),%eax
  800663:	83 e8 04             	sub    $0x4,%eax
  800666:	8b 00                	mov    (%eax),%eax
  800668:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80066d:	5d                   	pop    %ebp
  80066e:	c3                   	ret    

0080066f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80066f:	55                   	push   %ebp
  800670:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800672:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800676:	7e 1c                	jle    800694 <getint+0x25>
		return va_arg(*ap, long long);
  800678:	8b 45 08             	mov    0x8(%ebp),%eax
  80067b:	8b 00                	mov    (%eax),%eax
  80067d:	8d 50 08             	lea    0x8(%eax),%edx
  800680:	8b 45 08             	mov    0x8(%ebp),%eax
  800683:	89 10                	mov    %edx,(%eax)
  800685:	8b 45 08             	mov    0x8(%ebp),%eax
  800688:	8b 00                	mov    (%eax),%eax
  80068a:	83 e8 08             	sub    $0x8,%eax
  80068d:	8b 50 04             	mov    0x4(%eax),%edx
  800690:	8b 00                	mov    (%eax),%eax
  800692:	eb 38                	jmp    8006cc <getint+0x5d>
	else if (lflag)
  800694:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800698:	74 1a                	je     8006b4 <getint+0x45>
		return va_arg(*ap, long);
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	8d 50 04             	lea    0x4(%eax),%edx
  8006a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a5:	89 10                	mov    %edx,(%eax)
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	8b 00                	mov    (%eax),%eax
  8006ac:	83 e8 04             	sub    $0x4,%eax
  8006af:	8b 00                	mov    (%eax),%eax
  8006b1:	99                   	cltd   
  8006b2:	eb 18                	jmp    8006cc <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	8d 50 04             	lea    0x4(%eax),%edx
  8006bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bf:	89 10                	mov    %edx,(%eax)
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	83 e8 04             	sub    $0x4,%eax
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	99                   	cltd   
}
  8006cc:	5d                   	pop    %ebp
  8006cd:	c3                   	ret    

008006ce <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006ce:	55                   	push   %ebp
  8006cf:	89 e5                	mov    %esp,%ebp
  8006d1:	56                   	push   %esi
  8006d2:	53                   	push   %ebx
  8006d3:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006d6:	eb 17                	jmp    8006ef <vprintfmt+0x21>
			if (ch == '\0')
  8006d8:	85 db                	test   %ebx,%ebx
  8006da:	0f 84 c1 03 00 00    	je     800aa1 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8006e0:	83 ec 08             	sub    $0x8,%esp
  8006e3:	ff 75 0c             	pushl  0xc(%ebp)
  8006e6:	53                   	push   %ebx
  8006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ea:	ff d0                	call   *%eax
  8006ec:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8006f2:	8d 50 01             	lea    0x1(%eax),%edx
  8006f5:	89 55 10             	mov    %edx,0x10(%ebp)
  8006f8:	8a 00                	mov    (%eax),%al
  8006fa:	0f b6 d8             	movzbl %al,%ebx
  8006fd:	83 fb 25             	cmp    $0x25,%ebx
  800700:	75 d6                	jne    8006d8 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800702:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800706:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80070d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800714:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80071b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800722:	8b 45 10             	mov    0x10(%ebp),%eax
  800725:	8d 50 01             	lea    0x1(%eax),%edx
  800728:	89 55 10             	mov    %edx,0x10(%ebp)
  80072b:	8a 00                	mov    (%eax),%al
  80072d:	0f b6 d8             	movzbl %al,%ebx
  800730:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800733:	83 f8 5b             	cmp    $0x5b,%eax
  800736:	0f 87 3d 03 00 00    	ja     800a79 <vprintfmt+0x3ab>
  80073c:	8b 04 85 58 20 80 00 	mov    0x802058(,%eax,4),%eax
  800743:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800745:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800749:	eb d7                	jmp    800722 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80074b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80074f:	eb d1                	jmp    800722 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800751:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800758:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80075b:	89 d0                	mov    %edx,%eax
  80075d:	c1 e0 02             	shl    $0x2,%eax
  800760:	01 d0                	add    %edx,%eax
  800762:	01 c0                	add    %eax,%eax
  800764:	01 d8                	add    %ebx,%eax
  800766:	83 e8 30             	sub    $0x30,%eax
  800769:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80076c:	8b 45 10             	mov    0x10(%ebp),%eax
  80076f:	8a 00                	mov    (%eax),%al
  800771:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800774:	83 fb 2f             	cmp    $0x2f,%ebx
  800777:	7e 3e                	jle    8007b7 <vprintfmt+0xe9>
  800779:	83 fb 39             	cmp    $0x39,%ebx
  80077c:	7f 39                	jg     8007b7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80077e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800781:	eb d5                	jmp    800758 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800783:	8b 45 14             	mov    0x14(%ebp),%eax
  800786:	83 c0 04             	add    $0x4,%eax
  800789:	89 45 14             	mov    %eax,0x14(%ebp)
  80078c:	8b 45 14             	mov    0x14(%ebp),%eax
  80078f:	83 e8 04             	sub    $0x4,%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800797:	eb 1f                	jmp    8007b8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800799:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80079d:	79 83                	jns    800722 <vprintfmt+0x54>
				width = 0;
  80079f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007a6:	e9 77 ff ff ff       	jmp    800722 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007ab:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007b2:	e9 6b ff ff ff       	jmp    800722 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007b7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007b8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007bc:	0f 89 60 ff ff ff    	jns    800722 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007c8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007cf:	e9 4e ff ff ff       	jmp    800722 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007d4:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007d7:	e9 46 ff ff ff       	jmp    800722 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007df:	83 c0 04             	add    $0x4,%eax
  8007e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e8:	83 e8 04             	sub    $0x4,%eax
  8007eb:	8b 00                	mov    (%eax),%eax
  8007ed:	83 ec 08             	sub    $0x8,%esp
  8007f0:	ff 75 0c             	pushl  0xc(%ebp)
  8007f3:	50                   	push   %eax
  8007f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f7:	ff d0                	call   *%eax
  8007f9:	83 c4 10             	add    $0x10,%esp
			break;
  8007fc:	e9 9b 02 00 00       	jmp    800a9c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	83 c0 04             	add    $0x4,%eax
  800807:	89 45 14             	mov    %eax,0x14(%ebp)
  80080a:	8b 45 14             	mov    0x14(%ebp),%eax
  80080d:	83 e8 04             	sub    $0x4,%eax
  800810:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800812:	85 db                	test   %ebx,%ebx
  800814:	79 02                	jns    800818 <vprintfmt+0x14a>
				err = -err;
  800816:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800818:	83 fb 64             	cmp    $0x64,%ebx
  80081b:	7f 0b                	jg     800828 <vprintfmt+0x15a>
  80081d:	8b 34 9d a0 1e 80 00 	mov    0x801ea0(,%ebx,4),%esi
  800824:	85 f6                	test   %esi,%esi
  800826:	75 19                	jne    800841 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800828:	53                   	push   %ebx
  800829:	68 45 20 80 00       	push   $0x802045
  80082e:	ff 75 0c             	pushl  0xc(%ebp)
  800831:	ff 75 08             	pushl  0x8(%ebp)
  800834:	e8 70 02 00 00       	call   800aa9 <printfmt>
  800839:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80083c:	e9 5b 02 00 00       	jmp    800a9c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800841:	56                   	push   %esi
  800842:	68 4e 20 80 00       	push   $0x80204e
  800847:	ff 75 0c             	pushl  0xc(%ebp)
  80084a:	ff 75 08             	pushl  0x8(%ebp)
  80084d:	e8 57 02 00 00       	call   800aa9 <printfmt>
  800852:	83 c4 10             	add    $0x10,%esp
			break;
  800855:	e9 42 02 00 00       	jmp    800a9c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	83 c0 04             	add    $0x4,%eax
  800860:	89 45 14             	mov    %eax,0x14(%ebp)
  800863:	8b 45 14             	mov    0x14(%ebp),%eax
  800866:	83 e8 04             	sub    $0x4,%eax
  800869:	8b 30                	mov    (%eax),%esi
  80086b:	85 f6                	test   %esi,%esi
  80086d:	75 05                	jne    800874 <vprintfmt+0x1a6>
				p = "(null)";
  80086f:	be 51 20 80 00       	mov    $0x802051,%esi
			if (width > 0 && padc != '-')
  800874:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800878:	7e 6d                	jle    8008e7 <vprintfmt+0x219>
  80087a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80087e:	74 67                	je     8008e7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800880:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	50                   	push   %eax
  800887:	56                   	push   %esi
  800888:	e8 1e 03 00 00       	call   800bab <strnlen>
  80088d:	83 c4 10             	add    $0x10,%esp
  800890:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800893:	eb 16                	jmp    8008ab <vprintfmt+0x1dd>
					putch(padc, putdat);
  800895:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800899:	83 ec 08             	sub    $0x8,%esp
  80089c:	ff 75 0c             	pushl  0xc(%ebp)
  80089f:	50                   	push   %eax
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	ff d0                	call   *%eax
  8008a5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008a8:	ff 4d e4             	decl   -0x1c(%ebp)
  8008ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008af:	7f e4                	jg     800895 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008b1:	eb 34                	jmp    8008e7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008b3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008b7:	74 1c                	je     8008d5 <vprintfmt+0x207>
  8008b9:	83 fb 1f             	cmp    $0x1f,%ebx
  8008bc:	7e 05                	jle    8008c3 <vprintfmt+0x1f5>
  8008be:	83 fb 7e             	cmp    $0x7e,%ebx
  8008c1:	7e 12                	jle    8008d5 <vprintfmt+0x207>
					putch('?', putdat);
  8008c3:	83 ec 08             	sub    $0x8,%esp
  8008c6:	ff 75 0c             	pushl  0xc(%ebp)
  8008c9:	6a 3f                	push   $0x3f
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	ff d0                	call   *%eax
  8008d0:	83 c4 10             	add    $0x10,%esp
  8008d3:	eb 0f                	jmp    8008e4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008d5:	83 ec 08             	sub    $0x8,%esp
  8008d8:	ff 75 0c             	pushl  0xc(%ebp)
  8008db:	53                   	push   %ebx
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	ff d0                	call   *%eax
  8008e1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e4:	ff 4d e4             	decl   -0x1c(%ebp)
  8008e7:	89 f0                	mov    %esi,%eax
  8008e9:	8d 70 01             	lea    0x1(%eax),%esi
  8008ec:	8a 00                	mov    (%eax),%al
  8008ee:	0f be d8             	movsbl %al,%ebx
  8008f1:	85 db                	test   %ebx,%ebx
  8008f3:	74 24                	je     800919 <vprintfmt+0x24b>
  8008f5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008f9:	78 b8                	js     8008b3 <vprintfmt+0x1e5>
  8008fb:	ff 4d e0             	decl   -0x20(%ebp)
  8008fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800902:	79 af                	jns    8008b3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800904:	eb 13                	jmp    800919 <vprintfmt+0x24b>
				putch(' ', putdat);
  800906:	83 ec 08             	sub    $0x8,%esp
  800909:	ff 75 0c             	pushl  0xc(%ebp)
  80090c:	6a 20                	push   $0x20
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	ff d0                	call   *%eax
  800913:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800916:	ff 4d e4             	decl   -0x1c(%ebp)
  800919:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80091d:	7f e7                	jg     800906 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80091f:	e9 78 01 00 00       	jmp    800a9c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	ff 75 e8             	pushl  -0x18(%ebp)
  80092a:	8d 45 14             	lea    0x14(%ebp),%eax
  80092d:	50                   	push   %eax
  80092e:	e8 3c fd ff ff       	call   80066f <getint>
  800933:	83 c4 10             	add    $0x10,%esp
  800936:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800939:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80093c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80093f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800942:	85 d2                	test   %edx,%edx
  800944:	79 23                	jns    800969 <vprintfmt+0x29b>
				putch('-', putdat);
  800946:	83 ec 08             	sub    $0x8,%esp
  800949:	ff 75 0c             	pushl  0xc(%ebp)
  80094c:	6a 2d                	push   $0x2d
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	ff d0                	call   *%eax
  800953:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800956:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800959:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80095c:	f7 d8                	neg    %eax
  80095e:	83 d2 00             	adc    $0x0,%edx
  800961:	f7 da                	neg    %edx
  800963:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800966:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800969:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800970:	e9 bc 00 00 00       	jmp    800a31 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800975:	83 ec 08             	sub    $0x8,%esp
  800978:	ff 75 e8             	pushl  -0x18(%ebp)
  80097b:	8d 45 14             	lea    0x14(%ebp),%eax
  80097e:	50                   	push   %eax
  80097f:	e8 84 fc ff ff       	call   800608 <getuint>
  800984:	83 c4 10             	add    $0x10,%esp
  800987:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80098a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80098d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800994:	e9 98 00 00 00       	jmp    800a31 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800999:	83 ec 08             	sub    $0x8,%esp
  80099c:	ff 75 0c             	pushl  0xc(%ebp)
  80099f:	6a 58                	push   $0x58
  8009a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a4:	ff d0                	call   *%eax
  8009a6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009a9:	83 ec 08             	sub    $0x8,%esp
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	6a 58                	push   $0x58
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	ff d0                	call   *%eax
  8009b6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009b9:	83 ec 08             	sub    $0x8,%esp
  8009bc:	ff 75 0c             	pushl  0xc(%ebp)
  8009bf:	6a 58                	push   $0x58
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	ff d0                	call   *%eax
  8009c6:	83 c4 10             	add    $0x10,%esp
			break;
  8009c9:	e9 ce 00 00 00       	jmp    800a9c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8009ce:	83 ec 08             	sub    $0x8,%esp
  8009d1:	ff 75 0c             	pushl  0xc(%ebp)
  8009d4:	6a 30                	push   $0x30
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	ff d0                	call   *%eax
  8009db:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8009de:	83 ec 08             	sub    $0x8,%esp
  8009e1:	ff 75 0c             	pushl  0xc(%ebp)
  8009e4:	6a 78                	push   $0x78
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	ff d0                	call   *%eax
  8009eb:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8009ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f1:	83 c0 04             	add    $0x4,%eax
  8009f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fa:	83 e8 04             	sub    $0x4,%eax
  8009fd:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8009ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a09:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a10:	eb 1f                	jmp    800a31 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a12:	83 ec 08             	sub    $0x8,%esp
  800a15:	ff 75 e8             	pushl  -0x18(%ebp)
  800a18:	8d 45 14             	lea    0x14(%ebp),%eax
  800a1b:	50                   	push   %eax
  800a1c:	e8 e7 fb ff ff       	call   800608 <getuint>
  800a21:	83 c4 10             	add    $0x10,%esp
  800a24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a27:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a2a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a31:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a38:	83 ec 04             	sub    $0x4,%esp
  800a3b:	52                   	push   %edx
  800a3c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a3f:	50                   	push   %eax
  800a40:	ff 75 f4             	pushl  -0xc(%ebp)
  800a43:	ff 75 f0             	pushl  -0x10(%ebp)
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	ff 75 08             	pushl  0x8(%ebp)
  800a4c:	e8 00 fb ff ff       	call   800551 <printnum>
  800a51:	83 c4 20             	add    $0x20,%esp
			break;
  800a54:	eb 46                	jmp    800a9c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	ff 75 0c             	pushl  0xc(%ebp)
  800a5c:	53                   	push   %ebx
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	ff d0                	call   *%eax
  800a62:	83 c4 10             	add    $0x10,%esp
			break;
  800a65:	eb 35                	jmp    800a9c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a67:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  800a6e:	eb 2c                	jmp    800a9c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a70:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  800a77:	eb 23                	jmp    800a9c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a79:	83 ec 08             	sub    $0x8,%esp
  800a7c:	ff 75 0c             	pushl  0xc(%ebp)
  800a7f:	6a 25                	push   $0x25
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	ff d0                	call   *%eax
  800a86:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a89:	ff 4d 10             	decl   0x10(%ebp)
  800a8c:	eb 03                	jmp    800a91 <vprintfmt+0x3c3>
  800a8e:	ff 4d 10             	decl   0x10(%ebp)
  800a91:	8b 45 10             	mov    0x10(%ebp),%eax
  800a94:	48                   	dec    %eax
  800a95:	8a 00                	mov    (%eax),%al
  800a97:	3c 25                	cmp    $0x25,%al
  800a99:	75 f3                	jne    800a8e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a9b:	90                   	nop
		}
	}
  800a9c:	e9 35 fc ff ff       	jmp    8006d6 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800aa1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800aa2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aa5:	5b                   	pop    %ebx
  800aa6:	5e                   	pop    %esi
  800aa7:	5d                   	pop    %ebp
  800aa8:	c3                   	ret    

00800aa9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
  800aac:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800aaf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ab2:	83 c0 04             	add    $0x4,%eax
  800ab5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ab8:	8b 45 10             	mov    0x10(%ebp),%eax
  800abb:	ff 75 f4             	pushl  -0xc(%ebp)
  800abe:	50                   	push   %eax
  800abf:	ff 75 0c             	pushl  0xc(%ebp)
  800ac2:	ff 75 08             	pushl  0x8(%ebp)
  800ac5:	e8 04 fc ff ff       	call   8006ce <vprintfmt>
  800aca:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800acd:	90                   	nop
  800ace:	c9                   	leave  
  800acf:	c3                   	ret    

00800ad0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ad0:	55                   	push   %ebp
  800ad1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad6:	8b 40 08             	mov    0x8(%eax),%eax
  800ad9:	8d 50 01             	lea    0x1(%eax),%edx
  800adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adf:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ae2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae5:	8b 10                	mov    (%eax),%edx
  800ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aea:	8b 40 04             	mov    0x4(%eax),%eax
  800aed:	39 c2                	cmp    %eax,%edx
  800aef:	73 12                	jae    800b03 <sprintputch+0x33>
		*b->buf++ = ch;
  800af1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af4:	8b 00                	mov    (%eax),%eax
  800af6:	8d 48 01             	lea    0x1(%eax),%ecx
  800af9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afc:	89 0a                	mov    %ecx,(%edx)
  800afe:	8b 55 08             	mov    0x8(%ebp),%edx
  800b01:	88 10                	mov    %dl,(%eax)
}
  800b03:	90                   	nop
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b15:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	01 d0                	add    %edx,%eax
  800b1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b2b:	74 06                	je     800b33 <vsnprintf+0x2d>
  800b2d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b31:	7f 07                	jg     800b3a <vsnprintf+0x34>
		return -E_INVAL;
  800b33:	b8 03 00 00 00       	mov    $0x3,%eax
  800b38:	eb 20                	jmp    800b5a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b3a:	ff 75 14             	pushl  0x14(%ebp)
  800b3d:	ff 75 10             	pushl  0x10(%ebp)
  800b40:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b43:	50                   	push   %eax
  800b44:	68 d0 0a 80 00       	push   $0x800ad0
  800b49:	e8 80 fb ff ff       	call   8006ce <vprintfmt>
  800b4e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b54:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b5a:	c9                   	leave  
  800b5b:	c3                   	ret    

00800b5c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b62:	8d 45 10             	lea    0x10(%ebp),%eax
  800b65:	83 c0 04             	add    $0x4,%eax
  800b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b71:	50                   	push   %eax
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	ff 75 08             	pushl  0x8(%ebp)
  800b78:	e8 89 ff ff ff       	call   800b06 <vsnprintf>
  800b7d:	83 c4 10             	add    $0x10,%esp
  800b80:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b83:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b86:	c9                   	leave  
  800b87:	c3                   	ret    

00800b88 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b95:	eb 06                	jmp    800b9d <strlen+0x15>
		n++;
  800b97:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b9a:	ff 45 08             	incl   0x8(%ebp)
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	8a 00                	mov    (%eax),%al
  800ba2:	84 c0                	test   %al,%al
  800ba4:	75 f1                	jne    800b97 <strlen+0xf>
		n++;
	return n;
  800ba6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ba9:	c9                   	leave  
  800baa:	c3                   	ret    

00800bab <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb8:	eb 09                	jmp    800bc3 <strnlen+0x18>
		n++;
  800bba:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bbd:	ff 45 08             	incl   0x8(%ebp)
  800bc0:	ff 4d 0c             	decl   0xc(%ebp)
  800bc3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc7:	74 09                	je     800bd2 <strnlen+0x27>
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	8a 00                	mov    (%eax),%al
  800bce:	84 c0                	test   %al,%al
  800bd0:	75 e8                	jne    800bba <strnlen+0xf>
		n++;
	return n;
  800bd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd5:	c9                   	leave  
  800bd6:	c3                   	ret    

00800bd7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800be3:	90                   	nop
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	8d 50 01             	lea    0x1(%eax),%edx
  800bea:	89 55 08             	mov    %edx,0x8(%ebp)
  800bed:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bf3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bf6:	8a 12                	mov    (%edx),%dl
  800bf8:	88 10                	mov    %dl,(%eax)
  800bfa:	8a 00                	mov    (%eax),%al
  800bfc:	84 c0                	test   %al,%al
  800bfe:	75 e4                	jne    800be4 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c00:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c03:	c9                   	leave  
  800c04:	c3                   	ret    

00800c05 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c18:	eb 1f                	jmp    800c39 <strncpy+0x34>
		*dst++ = *src;
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	8d 50 01             	lea    0x1(%eax),%edx
  800c20:	89 55 08             	mov    %edx,0x8(%ebp)
  800c23:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c26:	8a 12                	mov    (%edx),%dl
  800c28:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	8a 00                	mov    (%eax),%al
  800c2f:	84 c0                	test   %al,%al
  800c31:	74 03                	je     800c36 <strncpy+0x31>
			src++;
  800c33:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c36:	ff 45 fc             	incl   -0x4(%ebp)
  800c39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c3c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c3f:	72 d9                	jb     800c1a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c41:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c44:	c9                   	leave  
  800c45:	c3                   	ret    

00800c46 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c52:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c56:	74 30                	je     800c88 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c58:	eb 16                	jmp    800c70 <strlcpy+0x2a>
			*dst++ = *src++;
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	8d 50 01             	lea    0x1(%eax),%edx
  800c60:	89 55 08             	mov    %edx,0x8(%ebp)
  800c63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c66:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c69:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c6c:	8a 12                	mov    (%edx),%dl
  800c6e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c70:	ff 4d 10             	decl   0x10(%ebp)
  800c73:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c77:	74 09                	je     800c82 <strlcpy+0x3c>
  800c79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7c:	8a 00                	mov    (%eax),%al
  800c7e:	84 c0                	test   %al,%al
  800c80:	75 d8                	jne    800c5a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c88:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c8e:	29 c2                	sub    %eax,%edx
  800c90:	89 d0                	mov    %edx,%eax
}
  800c92:	c9                   	leave  
  800c93:	c3                   	ret    

00800c94 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c97:	eb 06                	jmp    800c9f <strcmp+0xb>
		p++, q++;
  800c99:	ff 45 08             	incl   0x8(%ebp)
  800c9c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	8a 00                	mov    (%eax),%al
  800ca4:	84 c0                	test   %al,%al
  800ca6:	74 0e                	je     800cb6 <strcmp+0x22>
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8a 10                	mov    (%eax),%dl
  800cad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb0:	8a 00                	mov    (%eax),%al
  800cb2:	38 c2                	cmp    %al,%dl
  800cb4:	74 e3                	je     800c99 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	8a 00                	mov    (%eax),%al
  800cbb:	0f b6 d0             	movzbl %al,%edx
  800cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc1:	8a 00                	mov    (%eax),%al
  800cc3:	0f b6 c0             	movzbl %al,%eax
  800cc6:	29 c2                	sub    %eax,%edx
  800cc8:	89 d0                	mov    %edx,%eax
}
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ccf:	eb 09                	jmp    800cda <strncmp+0xe>
		n--, p++, q++;
  800cd1:	ff 4d 10             	decl   0x10(%ebp)
  800cd4:	ff 45 08             	incl   0x8(%ebp)
  800cd7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cde:	74 17                	je     800cf7 <strncmp+0x2b>
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	8a 00                	mov    (%eax),%al
  800ce5:	84 c0                	test   %al,%al
  800ce7:	74 0e                	je     800cf7 <strncmp+0x2b>
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	8a 10                	mov    (%eax),%dl
  800cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	38 c2                	cmp    %al,%dl
  800cf5:	74 da                	je     800cd1 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800cf7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cfb:	75 07                	jne    800d04 <strncmp+0x38>
		return 0;
  800cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  800d02:	eb 14                	jmp    800d18 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8a 00                	mov    (%eax),%al
  800d09:	0f b6 d0             	movzbl %al,%edx
  800d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0f:	8a 00                	mov    (%eax),%al
  800d11:	0f b6 c0             	movzbl %al,%eax
  800d14:	29 c2                	sub    %eax,%edx
  800d16:	89 d0                	mov    %edx,%eax
}
  800d18:	5d                   	pop    %ebp
  800d19:	c3                   	ret    

00800d1a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	83 ec 04             	sub    $0x4,%esp
  800d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d23:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d26:	eb 12                	jmp    800d3a <strchr+0x20>
		if (*s == c)
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	8a 00                	mov    (%eax),%al
  800d2d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d30:	75 05                	jne    800d37 <strchr+0x1d>
			return (char *) s;
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	eb 11                	jmp    800d48 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d37:	ff 45 08             	incl   0x8(%ebp)
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3d:	8a 00                	mov    (%eax),%al
  800d3f:	84 c0                	test   %al,%al
  800d41:	75 e5                	jne    800d28 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d48:	c9                   	leave  
  800d49:	c3                   	ret    

00800d4a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	83 ec 04             	sub    $0x4,%esp
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d56:	eb 0d                	jmp    800d65 <strfind+0x1b>
		if (*s == c)
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8a 00                	mov    (%eax),%al
  800d5d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d60:	74 0e                	je     800d70 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d62:	ff 45 08             	incl   0x8(%ebp)
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8a 00                	mov    (%eax),%al
  800d6a:	84 c0                	test   %al,%al
  800d6c:	75 ea                	jne    800d58 <strfind+0xe>
  800d6e:	eb 01                	jmp    800d71 <strfind+0x27>
		if (*s == c)
			break;
  800d70:	90                   	nop
	return (char *) s;
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d74:	c9                   	leave  
  800d75:	c3                   	ret    

00800d76 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
  800d79:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d82:	8b 45 10             	mov    0x10(%ebp),%eax
  800d85:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d88:	eb 0e                	jmp    800d98 <memset+0x22>
		*p++ = c;
  800d8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d8d:	8d 50 01             	lea    0x1(%eax),%edx
  800d90:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d96:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d98:	ff 4d f8             	decl   -0x8(%ebp)
  800d9b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d9f:	79 e9                	jns    800d8a <memset+0x14>
		*p++ = c;

	return v;
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da4:	c9                   	leave  
  800da5:	c3                   	ret    

00800da6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800db8:	eb 16                	jmp    800dd0 <memcpy+0x2a>
		*d++ = *s++;
  800dba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dbd:	8d 50 01             	lea    0x1(%eax),%edx
  800dc0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dc3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dc6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dc9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dcc:	8a 12                	mov    (%edx),%dl
  800dce:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd6:	89 55 10             	mov    %edx,0x10(%ebp)
  800dd9:	85 c0                	test   %eax,%eax
  800ddb:	75 dd                	jne    800dba <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de0:	c9                   	leave  
  800de1:	c3                   	ret    

00800de2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800de8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800deb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800df4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dfa:	73 50                	jae    800e4c <memmove+0x6a>
  800dfc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dff:	8b 45 10             	mov    0x10(%ebp),%eax
  800e02:	01 d0                	add    %edx,%eax
  800e04:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e07:	76 43                	jbe    800e4c <memmove+0x6a>
		s += n;
  800e09:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e12:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e15:	eb 10                	jmp    800e27 <memmove+0x45>
			*--d = *--s;
  800e17:	ff 4d f8             	decl   -0x8(%ebp)
  800e1a:	ff 4d fc             	decl   -0x4(%ebp)
  800e1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e20:	8a 10                	mov    (%eax),%dl
  800e22:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e25:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e27:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e2d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e30:	85 c0                	test   %eax,%eax
  800e32:	75 e3                	jne    800e17 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e34:	eb 23                	jmp    800e59 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e39:	8d 50 01             	lea    0x1(%eax),%edx
  800e3c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e42:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e45:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e48:	8a 12                	mov    (%edx),%dl
  800e4a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e52:	89 55 10             	mov    %edx,0x10(%ebp)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	75 dd                	jne    800e36 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5c:	c9                   	leave  
  800e5d:	c3                   	ret    

00800e5e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e70:	eb 2a                	jmp    800e9c <memcmp+0x3e>
		if (*s1 != *s2)
  800e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e75:	8a 10                	mov    (%eax),%dl
  800e77:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7a:	8a 00                	mov    (%eax),%al
  800e7c:	38 c2                	cmp    %al,%dl
  800e7e:	74 16                	je     800e96 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e83:	8a 00                	mov    (%eax),%al
  800e85:	0f b6 d0             	movzbl %al,%edx
  800e88:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e8b:	8a 00                	mov    (%eax),%al
  800e8d:	0f b6 c0             	movzbl %al,%eax
  800e90:	29 c2                	sub    %eax,%edx
  800e92:	89 d0                	mov    %edx,%eax
  800e94:	eb 18                	jmp    800eae <memcmp+0x50>
		s1++, s2++;
  800e96:	ff 45 fc             	incl   -0x4(%ebp)
  800e99:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea5:	85 c0                	test   %eax,%eax
  800ea7:	75 c9                	jne    800e72 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ea9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eae:	c9                   	leave  
  800eaf:	c3                   	ret    

00800eb0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800eb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebc:	01 d0                	add    %edx,%eax
  800ebe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ec1:	eb 15                	jmp    800ed8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8a 00                	mov    (%eax),%al
  800ec8:	0f b6 d0             	movzbl %al,%edx
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	0f b6 c0             	movzbl %al,%eax
  800ed1:	39 c2                	cmp    %eax,%edx
  800ed3:	74 0d                	je     800ee2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ed5:	ff 45 08             	incl   0x8(%ebp)
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ede:	72 e3                	jb     800ec3 <memfind+0x13>
  800ee0:	eb 01                	jmp    800ee3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ee2:	90                   	nop
	return (void *) s;
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee6:	c9                   	leave  
  800ee7:	c3                   	ret    

00800ee8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800eee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ef5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800efc:	eb 03                	jmp    800f01 <strtol+0x19>
		s++;
  800efe:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	8a 00                	mov    (%eax),%al
  800f06:	3c 20                	cmp    $0x20,%al
  800f08:	74 f4                	je     800efe <strtol+0x16>
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	3c 09                	cmp    $0x9,%al
  800f11:	74 eb                	je     800efe <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	3c 2b                	cmp    $0x2b,%al
  800f1a:	75 05                	jne    800f21 <strtol+0x39>
		s++;
  800f1c:	ff 45 08             	incl   0x8(%ebp)
  800f1f:	eb 13                	jmp    800f34 <strtol+0x4c>
	else if (*s == '-')
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	3c 2d                	cmp    $0x2d,%al
  800f28:	75 0a                	jne    800f34 <strtol+0x4c>
		s++, neg = 1;
  800f2a:	ff 45 08             	incl   0x8(%ebp)
  800f2d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f38:	74 06                	je     800f40 <strtol+0x58>
  800f3a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f3e:	75 20                	jne    800f60 <strtol+0x78>
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	3c 30                	cmp    $0x30,%al
  800f47:	75 17                	jne    800f60 <strtol+0x78>
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	40                   	inc    %eax
  800f4d:	8a 00                	mov    (%eax),%al
  800f4f:	3c 78                	cmp    $0x78,%al
  800f51:	75 0d                	jne    800f60 <strtol+0x78>
		s += 2, base = 16;
  800f53:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f57:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f5e:	eb 28                	jmp    800f88 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f64:	75 15                	jne    800f7b <strtol+0x93>
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	3c 30                	cmp    $0x30,%al
  800f6d:	75 0c                	jne    800f7b <strtol+0x93>
		s++, base = 8;
  800f6f:	ff 45 08             	incl   0x8(%ebp)
  800f72:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f79:	eb 0d                	jmp    800f88 <strtol+0xa0>
	else if (base == 0)
  800f7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7f:	75 07                	jne    800f88 <strtol+0xa0>
		base = 10;
  800f81:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	3c 2f                	cmp    $0x2f,%al
  800f8f:	7e 19                	jle    800faa <strtol+0xc2>
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	3c 39                	cmp    $0x39,%al
  800f98:	7f 10                	jg     800faa <strtol+0xc2>
			dig = *s - '0';
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	0f be c0             	movsbl %al,%eax
  800fa2:	83 e8 30             	sub    $0x30,%eax
  800fa5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fa8:	eb 42                	jmp    800fec <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 60                	cmp    $0x60,%al
  800fb1:	7e 19                	jle    800fcc <strtol+0xe4>
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	3c 7a                	cmp    $0x7a,%al
  800fba:	7f 10                	jg     800fcc <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	0f be c0             	movsbl %al,%eax
  800fc4:	83 e8 57             	sub    $0x57,%eax
  800fc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fca:	eb 20                	jmp    800fec <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	8a 00                	mov    (%eax),%al
  800fd1:	3c 40                	cmp    $0x40,%al
  800fd3:	7e 39                	jle    80100e <strtol+0x126>
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	3c 5a                	cmp    $0x5a,%al
  800fdc:	7f 30                	jg     80100e <strtol+0x126>
			dig = *s - 'A' + 10;
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	0f be c0             	movsbl %al,%eax
  800fe6:	83 e8 37             	sub    $0x37,%eax
  800fe9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fef:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ff2:	7d 19                	jge    80100d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ff4:	ff 45 08             	incl   0x8(%ebp)
  800ff7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffa:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ffe:	89 c2                	mov    %eax,%edx
  801000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801003:	01 d0                	add    %edx,%eax
  801005:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801008:	e9 7b ff ff ff       	jmp    800f88 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80100d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80100e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801012:	74 08                	je     80101c <strtol+0x134>
		*endptr = (char *) s;
  801014:	8b 45 0c             	mov    0xc(%ebp),%eax
  801017:	8b 55 08             	mov    0x8(%ebp),%edx
  80101a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80101c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801020:	74 07                	je     801029 <strtol+0x141>
  801022:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801025:	f7 d8                	neg    %eax
  801027:	eb 03                	jmp    80102c <strtol+0x144>
  801029:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80102c:	c9                   	leave  
  80102d:	c3                   	ret    

0080102e <ltostr>:

void
ltostr(long value, char *str)
{
  80102e:	55                   	push   %ebp
  80102f:	89 e5                	mov    %esp,%ebp
  801031:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801034:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80103b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801042:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801046:	79 13                	jns    80105b <ltostr+0x2d>
	{
		neg = 1;
  801048:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80104f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801052:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801055:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801058:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801063:	99                   	cltd   
  801064:	f7 f9                	idiv   %ecx
  801066:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801069:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106c:	8d 50 01             	lea    0x1(%eax),%edx
  80106f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801072:	89 c2                	mov    %eax,%edx
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	01 d0                	add    %edx,%eax
  801079:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80107c:	83 c2 30             	add    $0x30,%edx
  80107f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801081:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801084:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801089:	f7 e9                	imul   %ecx
  80108b:	c1 fa 02             	sar    $0x2,%edx
  80108e:	89 c8                	mov    %ecx,%eax
  801090:	c1 f8 1f             	sar    $0x1f,%eax
  801093:	29 c2                	sub    %eax,%edx
  801095:	89 d0                	mov    %edx,%eax
  801097:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80109a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80109e:	75 bb                	jne    80105b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010aa:	48                   	dec    %eax
  8010ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010b2:	74 3d                	je     8010f1 <ltostr+0xc3>
		start = 1 ;
  8010b4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010bb:	eb 34                	jmp    8010f1 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c3:	01 d0                	add    %edx,%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d0:	01 c2                	add    %eax,%edx
  8010d2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d8:	01 c8                	add    %ecx,%eax
  8010da:	8a 00                	mov    (%eax),%al
  8010dc:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e4:	01 c2                	add    %eax,%edx
  8010e6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010e9:	88 02                	mov    %al,(%edx)
		start++ ;
  8010eb:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010ee:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010f7:	7c c4                	jl     8010bd <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010f9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8010fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ff:	01 d0                	add    %edx,%eax
  801101:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801104:	90                   	nop
  801105:	c9                   	leave  
  801106:	c3                   	ret    

00801107 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80110d:	ff 75 08             	pushl  0x8(%ebp)
  801110:	e8 73 fa ff ff       	call   800b88 <strlen>
  801115:	83 c4 04             	add    $0x4,%esp
  801118:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80111b:	ff 75 0c             	pushl  0xc(%ebp)
  80111e:	e8 65 fa ff ff       	call   800b88 <strlen>
  801123:	83 c4 04             	add    $0x4,%esp
  801126:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801129:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801130:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801137:	eb 17                	jmp    801150 <strcconcat+0x49>
		final[s] = str1[s] ;
  801139:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80113c:	8b 45 10             	mov    0x10(%ebp),%eax
  80113f:	01 c2                	add    %eax,%edx
  801141:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	01 c8                	add    %ecx,%eax
  801149:	8a 00                	mov    (%eax),%al
  80114b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80114d:	ff 45 fc             	incl   -0x4(%ebp)
  801150:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801153:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801156:	7c e1                	jl     801139 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801158:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80115f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801166:	eb 1f                	jmp    801187 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801168:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116b:	8d 50 01             	lea    0x1(%eax),%edx
  80116e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801171:	89 c2                	mov    %eax,%edx
  801173:	8b 45 10             	mov    0x10(%ebp),%eax
  801176:	01 c2                	add    %eax,%edx
  801178:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80117b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117e:	01 c8                	add    %ecx,%eax
  801180:	8a 00                	mov    (%eax),%al
  801182:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801184:	ff 45 f8             	incl   -0x8(%ebp)
  801187:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80118d:	7c d9                	jl     801168 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80118f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801192:	8b 45 10             	mov    0x10(%ebp),%eax
  801195:	01 d0                	add    %edx,%eax
  801197:	c6 00 00             	movb   $0x0,(%eax)
}
  80119a:	90                   	nop
  80119b:	c9                   	leave  
  80119c:	c3                   	ret    

0080119d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ac:	8b 00                	mov    (%eax),%eax
  8011ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b8:	01 d0                	add    %edx,%eax
  8011ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011c0:	eb 0c                	jmp    8011ce <strsplit+0x31>
			*string++ = 0;
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	8d 50 01             	lea    0x1(%eax),%edx
  8011c8:	89 55 08             	mov    %edx,0x8(%ebp)
  8011cb:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	8a 00                	mov    (%eax),%al
  8011d3:	84 c0                	test   %al,%al
  8011d5:	74 18                	je     8011ef <strsplit+0x52>
  8011d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011da:	8a 00                	mov    (%eax),%al
  8011dc:	0f be c0             	movsbl %al,%eax
  8011df:	50                   	push   %eax
  8011e0:	ff 75 0c             	pushl  0xc(%ebp)
  8011e3:	e8 32 fb ff ff       	call   800d1a <strchr>
  8011e8:	83 c4 08             	add    $0x8,%esp
  8011eb:	85 c0                	test   %eax,%eax
  8011ed:	75 d3                	jne    8011c2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	8a 00                	mov    (%eax),%al
  8011f4:	84 c0                	test   %al,%al
  8011f6:	74 5a                	je     801252 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011fb:	8b 00                	mov    (%eax),%eax
  8011fd:	83 f8 0f             	cmp    $0xf,%eax
  801200:	75 07                	jne    801209 <strsplit+0x6c>
		{
			return 0;
  801202:	b8 00 00 00 00       	mov    $0x0,%eax
  801207:	eb 66                	jmp    80126f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801209:	8b 45 14             	mov    0x14(%ebp),%eax
  80120c:	8b 00                	mov    (%eax),%eax
  80120e:	8d 48 01             	lea    0x1(%eax),%ecx
  801211:	8b 55 14             	mov    0x14(%ebp),%edx
  801214:	89 0a                	mov    %ecx,(%edx)
  801216:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80121d:	8b 45 10             	mov    0x10(%ebp),%eax
  801220:	01 c2                	add    %eax,%edx
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
  801225:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801227:	eb 03                	jmp    80122c <strsplit+0x8f>
			string++;
  801229:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
  80122f:	8a 00                	mov    (%eax),%al
  801231:	84 c0                	test   %al,%al
  801233:	74 8b                	je     8011c0 <strsplit+0x23>
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	8a 00                	mov    (%eax),%al
  80123a:	0f be c0             	movsbl %al,%eax
  80123d:	50                   	push   %eax
  80123e:	ff 75 0c             	pushl  0xc(%ebp)
  801241:	e8 d4 fa ff ff       	call   800d1a <strchr>
  801246:	83 c4 08             	add    $0x8,%esp
  801249:	85 c0                	test   %eax,%eax
  80124b:	74 dc                	je     801229 <strsplit+0x8c>
			string++;
	}
  80124d:	e9 6e ff ff ff       	jmp    8011c0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801252:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801253:	8b 45 14             	mov    0x14(%ebp),%eax
  801256:	8b 00                	mov    (%eax),%eax
  801258:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80125f:	8b 45 10             	mov    0x10(%ebp),%eax
  801262:	01 d0                	add    %edx,%eax
  801264:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80126a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80126f:	c9                   	leave  
  801270:	c3                   	ret    

00801271 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801277:	83 ec 04             	sub    $0x4,%esp
  80127a:	68 c8 21 80 00       	push   $0x8021c8
  80127f:	68 3f 01 00 00       	push   $0x13f
  801284:	68 ea 21 80 00       	push   $0x8021ea
  801289:	e8 a9 ef ff ff       	call   800237 <_panic>

0080128e <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
  801291:	57                   	push   %edi
  801292:	56                   	push   %esi
  801293:	53                   	push   %ebx
  801294:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012a0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012a3:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012a6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012a9:	cd 30                	int    $0x30
  8012ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  8012ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012b1:	83 c4 10             	add    $0x10,%esp
  8012b4:	5b                   	pop    %ebx
  8012b5:	5e                   	pop    %esi
  8012b6:	5f                   	pop    %edi
  8012b7:	5d                   	pop    %ebp
  8012b8:	c3                   	ret    

008012b9 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
  8012bc:	83 ec 04             	sub    $0x4,%esp
  8012bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8012c5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cc:	6a 00                	push   $0x0
  8012ce:	6a 00                	push   $0x0
  8012d0:	52                   	push   %edx
  8012d1:	ff 75 0c             	pushl  0xc(%ebp)
  8012d4:	50                   	push   %eax
  8012d5:	6a 00                	push   $0x0
  8012d7:	e8 b2 ff ff ff       	call   80128e <syscall>
  8012dc:	83 c4 18             	add    $0x18,%esp
}
  8012df:	90                   	nop
  8012e0:	c9                   	leave  
  8012e1:	c3                   	ret    

008012e2 <sys_cgetc>:

int sys_cgetc(void) {
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012e5:	6a 00                	push   $0x0
  8012e7:	6a 00                	push   $0x0
  8012e9:	6a 00                	push   $0x0
  8012eb:	6a 00                	push   $0x0
  8012ed:	6a 00                	push   $0x0
  8012ef:	6a 02                	push   $0x2
  8012f1:	e8 98 ff ff ff       	call   80128e <syscall>
  8012f6:	83 c4 18             	add    $0x18,%esp
}
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <sys_lock_cons>:

void sys_lock_cons(void) {
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8012fe:	6a 00                	push   $0x0
  801300:	6a 00                	push   $0x0
  801302:	6a 00                	push   $0x0
  801304:	6a 00                	push   $0x0
  801306:	6a 00                	push   $0x0
  801308:	6a 03                	push   $0x3
  80130a:	e8 7f ff ff ff       	call   80128e <syscall>
  80130f:	83 c4 18             	add    $0x18,%esp
}
  801312:	90                   	nop
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801318:	6a 00                	push   $0x0
  80131a:	6a 00                	push   $0x0
  80131c:	6a 00                	push   $0x0
  80131e:	6a 00                	push   $0x0
  801320:	6a 00                	push   $0x0
  801322:	6a 04                	push   $0x4
  801324:	e8 65 ff ff ff       	call   80128e <syscall>
  801329:	83 c4 18             	add    $0x18,%esp
}
  80132c:	90                   	nop
  80132d:	c9                   	leave  
  80132e:	c3                   	ret    

0080132f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801332:	8b 55 0c             	mov    0xc(%ebp),%edx
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	6a 00                	push   $0x0
  80133a:	6a 00                	push   $0x0
  80133c:	6a 00                	push   $0x0
  80133e:	52                   	push   %edx
  80133f:	50                   	push   %eax
  801340:	6a 08                	push   $0x8
  801342:	e8 47 ff ff ff       	call   80128e <syscall>
  801347:	83 c4 18             	add    $0x18,%esp
}
  80134a:	c9                   	leave  
  80134b:	c3                   	ret    

0080134c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	56                   	push   %esi
  801350:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801351:	8b 75 18             	mov    0x18(%ebp),%esi
  801354:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801357:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80135a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135d:	8b 45 08             	mov    0x8(%ebp),%eax
  801360:	56                   	push   %esi
  801361:	53                   	push   %ebx
  801362:	51                   	push   %ecx
  801363:	52                   	push   %edx
  801364:	50                   	push   %eax
  801365:	6a 09                	push   $0x9
  801367:	e8 22 ff ff ff       	call   80128e <syscall>
  80136c:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  80136f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801372:	5b                   	pop    %ebx
  801373:	5e                   	pop    %esi
  801374:	5d                   	pop    %ebp
  801375:	c3                   	ret    

00801376 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801379:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	52                   	push   %edx
  801386:	50                   	push   %eax
  801387:	6a 0a                	push   $0xa
  801389:	e8 00 ff ff ff       	call   80128e <syscall>
  80138e:	83 c4 18             	add    $0x18,%esp
}
  801391:	c9                   	leave  
  801392:	c3                   	ret    

00801393 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801396:	6a 00                	push   $0x0
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	ff 75 0c             	pushl  0xc(%ebp)
  80139f:	ff 75 08             	pushl  0x8(%ebp)
  8013a2:	6a 0b                	push   $0xb
  8013a4:	e8 e5 fe ff ff       	call   80128e <syscall>
  8013a9:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  8013ac:	c9                   	leave  
  8013ad:	c3                   	ret    

008013ae <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 0c                	push   $0xc
  8013bd:	e8 cc fe ff ff       	call   80128e <syscall>
  8013c2:	83 c4 18             	add    $0x18,%esp
}
  8013c5:	c9                   	leave  
  8013c6:	c3                   	ret    

008013c7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 00                	push   $0x0
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 0d                	push   $0xd
  8013d6:	e8 b3 fe ff ff       	call   80128e <syscall>
  8013db:	83 c4 18             	add    $0x18,%esp
}
  8013de:	c9                   	leave  
  8013df:	c3                   	ret    

008013e0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 0e                	push   $0xe
  8013ef:	e8 9a fe ff ff       	call   80128e <syscall>
  8013f4:	83 c4 18             	add    $0x18,%esp
}
  8013f7:	c9                   	leave  
  8013f8:	c3                   	ret    

008013f9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	6a 00                	push   $0x0
  801404:	6a 00                	push   $0x0
  801406:	6a 0f                	push   $0xf
  801408:	e8 81 fe ff ff       	call   80128e <syscall>
  80140d:	83 c4 18             	add    $0x18,%esp
}
  801410:	c9                   	leave  
  801411:	c3                   	ret    

00801412 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801412:	55                   	push   %ebp
  801413:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	6a 00                	push   $0x0
  80141d:	ff 75 08             	pushl  0x8(%ebp)
  801420:	6a 10                	push   $0x10
  801422:	e8 67 fe ff ff       	call   80128e <syscall>
  801427:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  80142a:	c9                   	leave  
  80142b:	c3                   	ret    

0080142c <sys_scarce_memory>:

void sys_scarce_memory() {
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	6a 00                	push   $0x0
  801435:	6a 00                	push   $0x0
  801437:	6a 00                	push   $0x0
  801439:	6a 11                	push   $0x11
  80143b:	e8 4e fe ff ff       	call   80128e <syscall>
  801440:	83 c4 18             	add    $0x18,%esp
}
  801443:	90                   	nop
  801444:	c9                   	leave  
  801445:	c3                   	ret    

00801446 <sys_cputc>:

void sys_cputc(const char c) {
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
  801449:	83 ec 04             	sub    $0x4,%esp
  80144c:	8b 45 08             	mov    0x8(%ebp),%eax
  80144f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801452:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	50                   	push   %eax
  80145f:	6a 01                	push   $0x1
  801461:	e8 28 fe ff ff       	call   80128e <syscall>
  801466:	83 c4 18             	add    $0x18,%esp
}
  801469:	90                   	nop
  80146a:	c9                   	leave  
  80146b:	c3                   	ret    

0080146c <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	6a 00                	push   $0x0
  801479:	6a 14                	push   $0x14
  80147b:	e8 0e fe ff ff       	call   80128e <syscall>
  801480:	83 c4 18             	add    $0x18,%esp
}
  801483:	90                   	nop
  801484:	c9                   	leave  
  801485:	c3                   	ret    

00801486 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801486:	55                   	push   %ebp
  801487:	89 e5                	mov    %esp,%ebp
  801489:	83 ec 04             	sub    $0x4,%esp
  80148c:	8b 45 10             	mov    0x10(%ebp),%eax
  80148f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801492:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801495:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	6a 00                	push   $0x0
  80149e:	51                   	push   %ecx
  80149f:	52                   	push   %edx
  8014a0:	ff 75 0c             	pushl  0xc(%ebp)
  8014a3:	50                   	push   %eax
  8014a4:	6a 15                	push   $0x15
  8014a6:	e8 e3 fd ff ff       	call   80128e <syscall>
  8014ab:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  8014ae:	c9                   	leave  
  8014af:	c3                   	ret    

008014b0 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  8014b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	52                   	push   %edx
  8014c0:	50                   	push   %eax
  8014c1:	6a 16                	push   $0x16
  8014c3:	e8 c6 fd ff ff       	call   80128e <syscall>
  8014c8:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    

008014cd <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  8014d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	51                   	push   %ecx
  8014de:	52                   	push   %edx
  8014df:	50                   	push   %eax
  8014e0:	6a 17                	push   $0x17
  8014e2:	e8 a7 fd ff ff       	call   80128e <syscall>
  8014e7:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  8014ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	52                   	push   %edx
  8014fc:	50                   	push   %eax
  8014fd:	6a 18                	push   $0x18
  8014ff:	e8 8a fd ff ff       	call   80128e <syscall>
  801504:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	6a 00                	push   $0x0
  801511:	ff 75 14             	pushl  0x14(%ebp)
  801514:	ff 75 10             	pushl  0x10(%ebp)
  801517:	ff 75 0c             	pushl  0xc(%ebp)
  80151a:	50                   	push   %eax
  80151b:	6a 19                	push   $0x19
  80151d:	e8 6c fd ff ff       	call   80128e <syscall>
  801522:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <sys_run_env>:

void sys_run_env(int32 envId) {
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	50                   	push   %eax
  801536:	6a 1a                	push   $0x1a
  801538:	e8 51 fd ff ff       	call   80128e <syscall>
  80153d:	83 c4 18             	add    $0x18,%esp
}
  801540:	90                   	nop
  801541:	c9                   	leave  
  801542:	c3                   	ret    

00801543 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	50                   	push   %eax
  801552:	6a 1b                	push   $0x1b
  801554:	e8 35 fd ff ff       	call   80128e <syscall>
  801559:	83 c4 18             	add    $0x18,%esp
}
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    

0080155e <sys_getenvid>:

int32 sys_getenvid(void) {
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 05                	push   $0x5
  80156d:	e8 1c fd ff ff       	call   80128e <syscall>
  801572:	83 c4 18             	add    $0x18,%esp
}
  801575:	c9                   	leave  
  801576:	c3                   	ret    

00801577 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 06                	push   $0x6
  801586:	e8 03 fd ff ff       	call   80128e <syscall>
  80158b:	83 c4 18             	add    $0x18,%esp
}
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    

00801590 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 07                	push   $0x7
  80159f:	e8 ea fc ff ff       	call   80128e <syscall>
  8015a4:	83 c4 18             	add    $0x18,%esp
}
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <sys_exit_env>:

void sys_exit_env(void) {
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 1c                	push   $0x1c
  8015b8:	e8 d1 fc ff ff       	call   80128e <syscall>
  8015bd:	83 c4 18             	add    $0x18,%esp
}
  8015c0:	90                   	nop
  8015c1:	c9                   	leave  
  8015c2:	c3                   	ret    

008015c3 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
  8015c6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  8015c9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015cc:	8d 50 04             	lea    0x4(%eax),%edx
  8015cf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	52                   	push   %edx
  8015d9:	50                   	push   %eax
  8015da:	6a 1d                	push   $0x1d
  8015dc:	e8 ad fc ff ff       	call   80128e <syscall>
  8015e1:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  8015e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ed:	89 01                	mov    %eax,(%ecx)
  8015ef:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	c9                   	leave  
  8015f6:	c2 04 00             	ret    $0x4

008015f9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	ff 75 10             	pushl  0x10(%ebp)
  801603:	ff 75 0c             	pushl  0xc(%ebp)
  801606:	ff 75 08             	pushl  0x8(%ebp)
  801609:	6a 13                	push   $0x13
  80160b:	e8 7e fc ff ff       	call   80128e <syscall>
  801610:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801613:	90                   	nop
}
  801614:	c9                   	leave  
  801615:	c3                   	ret    

00801616 <sys_rcr2>:
uint32 sys_rcr2() {
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 1e                	push   $0x1e
  801625:	e8 64 fc ff ff       	call   80128e <syscall>
  80162a:	83 c4 18             	add    $0x18,%esp
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
  801632:	83 ec 04             	sub    $0x4,%esp
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80163b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	50                   	push   %eax
  801648:	6a 1f                	push   $0x1f
  80164a:	e8 3f fc ff ff       	call   80128e <syscall>
  80164f:	83 c4 18             	add    $0x18,%esp
	return;
  801652:	90                   	nop
}
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <rsttst>:
void rsttst() {
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 21                	push   $0x21
  801664:	e8 25 fc ff ff       	call   80128e <syscall>
  801669:	83 c4 18             	add    $0x18,%esp
	return;
  80166c:	90                   	nop
}
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	83 ec 04             	sub    $0x4,%esp
  801675:	8b 45 14             	mov    0x14(%ebp),%eax
  801678:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80167b:	8b 55 18             	mov    0x18(%ebp),%edx
  80167e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801682:	52                   	push   %edx
  801683:	50                   	push   %eax
  801684:	ff 75 10             	pushl  0x10(%ebp)
  801687:	ff 75 0c             	pushl  0xc(%ebp)
  80168a:	ff 75 08             	pushl  0x8(%ebp)
  80168d:	6a 20                	push   $0x20
  80168f:	e8 fa fb ff ff       	call   80128e <syscall>
  801694:	83 c4 18             	add    $0x18,%esp
	return;
  801697:	90                   	nop
}
  801698:	c9                   	leave  
  801699:	c3                   	ret    

0080169a <chktst>:
void chktst(uint32 n) {
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	ff 75 08             	pushl  0x8(%ebp)
  8016a8:	6a 22                	push   $0x22
  8016aa:	e8 df fb ff ff       	call   80128e <syscall>
  8016af:	83 c4 18             	add    $0x18,%esp
	return;
  8016b2:	90                   	nop
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <inctst>:

void inctst() {
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 23                	push   $0x23
  8016c4:	e8 c5 fb ff ff       	call   80128e <syscall>
  8016c9:	83 c4 18             	add    $0x18,%esp
	return;
  8016cc:	90                   	nop
}
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <gettst>:
uint32 gettst() {
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 24                	push   $0x24
  8016de:	e8 ab fb ff ff       	call   80128e <syscall>
  8016e3:	83 c4 18             	add    $0x18,%esp
}
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 25                	push   $0x25
  8016fa:	e8 8f fb ff ff       	call   80128e <syscall>
  8016ff:	83 c4 18             	add    $0x18,%esp
  801702:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801705:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801709:	75 07                	jne    801712 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80170b:	b8 01 00 00 00       	mov    $0x1,%eax
  801710:	eb 05                	jmp    801717 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801712:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801717:	c9                   	leave  
  801718:	c3                   	ret    

00801719 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 25                	push   $0x25
  80172b:	e8 5e fb ff ff       	call   80128e <syscall>
  801730:	83 c4 18             	add    $0x18,%esp
  801733:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801736:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80173a:	75 07                	jne    801743 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80173c:	b8 01 00 00 00       	mov    $0x1,%eax
  801741:	eb 05                	jmp    801748 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801743:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 25                	push   $0x25
  80175c:	e8 2d fb ff ff       	call   80128e <syscall>
  801761:	83 c4 18             	add    $0x18,%esp
  801764:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801767:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80176b:	75 07                	jne    801774 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80176d:	b8 01 00 00 00       	mov    $0x1,%eax
  801772:	eb 05                	jmp    801779 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801774:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 25                	push   $0x25
  80178d:	e8 fc fa ff ff       	call   80128e <syscall>
  801792:	83 c4 18             	add    $0x18,%esp
  801795:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801798:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80179c:	75 07                	jne    8017a5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80179e:	b8 01 00 00 00       	mov    $0x1,%eax
  8017a3:	eb 05                	jmp    8017aa <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	ff 75 08             	pushl  0x8(%ebp)
  8017ba:	6a 26                	push   $0x26
  8017bc:	e8 cd fa ff ff       	call   80128e <syscall>
  8017c1:	83 c4 18             	add    $0x18,%esp
	return;
  8017c4:	90                   	nop
}
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  8017cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	6a 00                	push   $0x0
  8017d9:	53                   	push   %ebx
  8017da:	51                   	push   %ecx
  8017db:	52                   	push   %edx
  8017dc:	50                   	push   %eax
  8017dd:	6a 27                	push   $0x27
  8017df:	e8 aa fa ff ff       	call   80128e <syscall>
  8017e4:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  8017e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  8017ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	52                   	push   %edx
  8017fc:	50                   	push   %eax
  8017fd:	6a 28                	push   $0x28
  8017ff:	e8 8a fa ff ff       	call   80128e <syscall>
  801804:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  80180c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80180f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	6a 00                	push   $0x0
  801817:	51                   	push   %ecx
  801818:	ff 75 10             	pushl  0x10(%ebp)
  80181b:	52                   	push   %edx
  80181c:	50                   	push   %eax
  80181d:	6a 29                	push   $0x29
  80181f:	e8 6a fa ff ff       	call   80128e <syscall>
  801824:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	ff 75 10             	pushl  0x10(%ebp)
  801833:	ff 75 0c             	pushl  0xc(%ebp)
  801836:	ff 75 08             	pushl  0x8(%ebp)
  801839:	6a 12                	push   $0x12
  80183b:	e8 4e fa ff ff       	call   80128e <syscall>
  801840:	83 c4 18             	add    $0x18,%esp
	return;
  801843:	90                   	nop
}
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801849:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184c:	8b 45 08             	mov    0x8(%ebp),%eax
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	52                   	push   %edx
  801856:	50                   	push   %eax
  801857:	6a 2a                	push   $0x2a
  801859:	e8 30 fa ff ff       	call   80128e <syscall>
  80185e:	83 c4 18             	add    $0x18,%esp
	return;
  801861:	90                   	nop
}
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801867:	8b 45 08             	mov    0x8(%ebp),%eax
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	50                   	push   %eax
  801873:	6a 2b                	push   $0x2b
  801875:	e8 14 fa ff ff       	call   80128e <syscall>
  80187a:	83 c4 18             	add    $0x18,%esp
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	ff 75 0c             	pushl  0xc(%ebp)
  80188b:	ff 75 08             	pushl  0x8(%ebp)
  80188e:	6a 2c                	push   $0x2c
  801890:	e8 f9 f9 ff ff       	call   80128e <syscall>
  801895:	83 c4 18             	add    $0x18,%esp
	return;
  801898:	90                   	nop
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	ff 75 0c             	pushl  0xc(%ebp)
  8018a7:	ff 75 08             	pushl  0x8(%ebp)
  8018aa:	6a 2d                	push   $0x2d
  8018ac:	e8 dd f9 ff ff       	call   80128e <syscall>
  8018b1:	83 c4 18             	add    $0x18,%esp
	return;
  8018b4:	90                   	nop
}
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  8018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	50                   	push   %eax
  8018c6:	6a 2f                	push   $0x2f
  8018c8:	e8 c1 f9 ff ff       	call   80128e <syscall>
  8018cd:	83 c4 18             	add    $0x18,%esp
	return;
  8018d0:	90                   	nop
}
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  8018d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	52                   	push   %edx
  8018e3:	50                   	push   %eax
  8018e4:	6a 30                	push   $0x30
  8018e6:	e8 a3 f9 ff ff       	call   80128e <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
	return;
  8018ee:	90                   	nop
}
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	50                   	push   %eax
  801900:	6a 31                	push   $0x31
  801902:	e8 87 f9 ff ff       	call   80128e <syscall>
  801907:	83 c4 18             	add    $0x18,%esp
	return;
  80190a:	90                   	nop
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801910:	8b 55 0c             	mov    0xc(%ebp),%edx
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	52                   	push   %edx
  80191d:	50                   	push   %eax
  80191e:	6a 2e                	push   $0x2e
  801920:	e8 69 f9 ff ff       	call   80128e <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
    return;
  801928:	90                   	nop
}
  801929:	c9                   	leave  
  80192a:	c3                   	ret    
  80192b:	90                   	nop

0080192c <__udivdi3>:
  80192c:	55                   	push   %ebp
  80192d:	57                   	push   %edi
  80192e:	56                   	push   %esi
  80192f:	53                   	push   %ebx
  801930:	83 ec 1c             	sub    $0x1c,%esp
  801933:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801937:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80193b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80193f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801943:	89 ca                	mov    %ecx,%edx
  801945:	89 f8                	mov    %edi,%eax
  801947:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80194b:	85 f6                	test   %esi,%esi
  80194d:	75 2d                	jne    80197c <__udivdi3+0x50>
  80194f:	39 cf                	cmp    %ecx,%edi
  801951:	77 65                	ja     8019b8 <__udivdi3+0x8c>
  801953:	89 fd                	mov    %edi,%ebp
  801955:	85 ff                	test   %edi,%edi
  801957:	75 0b                	jne    801964 <__udivdi3+0x38>
  801959:	b8 01 00 00 00       	mov    $0x1,%eax
  80195e:	31 d2                	xor    %edx,%edx
  801960:	f7 f7                	div    %edi
  801962:	89 c5                	mov    %eax,%ebp
  801964:	31 d2                	xor    %edx,%edx
  801966:	89 c8                	mov    %ecx,%eax
  801968:	f7 f5                	div    %ebp
  80196a:	89 c1                	mov    %eax,%ecx
  80196c:	89 d8                	mov    %ebx,%eax
  80196e:	f7 f5                	div    %ebp
  801970:	89 cf                	mov    %ecx,%edi
  801972:	89 fa                	mov    %edi,%edx
  801974:	83 c4 1c             	add    $0x1c,%esp
  801977:	5b                   	pop    %ebx
  801978:	5e                   	pop    %esi
  801979:	5f                   	pop    %edi
  80197a:	5d                   	pop    %ebp
  80197b:	c3                   	ret    
  80197c:	39 ce                	cmp    %ecx,%esi
  80197e:	77 28                	ja     8019a8 <__udivdi3+0x7c>
  801980:	0f bd fe             	bsr    %esi,%edi
  801983:	83 f7 1f             	xor    $0x1f,%edi
  801986:	75 40                	jne    8019c8 <__udivdi3+0x9c>
  801988:	39 ce                	cmp    %ecx,%esi
  80198a:	72 0a                	jb     801996 <__udivdi3+0x6a>
  80198c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801990:	0f 87 9e 00 00 00    	ja     801a34 <__udivdi3+0x108>
  801996:	b8 01 00 00 00       	mov    $0x1,%eax
  80199b:	89 fa                	mov    %edi,%edx
  80199d:	83 c4 1c             	add    $0x1c,%esp
  8019a0:	5b                   	pop    %ebx
  8019a1:	5e                   	pop    %esi
  8019a2:	5f                   	pop    %edi
  8019a3:	5d                   	pop    %ebp
  8019a4:	c3                   	ret    
  8019a5:	8d 76 00             	lea    0x0(%esi),%esi
  8019a8:	31 ff                	xor    %edi,%edi
  8019aa:	31 c0                	xor    %eax,%eax
  8019ac:	89 fa                	mov    %edi,%edx
  8019ae:	83 c4 1c             	add    $0x1c,%esp
  8019b1:	5b                   	pop    %ebx
  8019b2:	5e                   	pop    %esi
  8019b3:	5f                   	pop    %edi
  8019b4:	5d                   	pop    %ebp
  8019b5:	c3                   	ret    
  8019b6:	66 90                	xchg   %ax,%ax
  8019b8:	89 d8                	mov    %ebx,%eax
  8019ba:	f7 f7                	div    %edi
  8019bc:	31 ff                	xor    %edi,%edi
  8019be:	89 fa                	mov    %edi,%edx
  8019c0:	83 c4 1c             	add    $0x1c,%esp
  8019c3:	5b                   	pop    %ebx
  8019c4:	5e                   	pop    %esi
  8019c5:	5f                   	pop    %edi
  8019c6:	5d                   	pop    %ebp
  8019c7:	c3                   	ret    
  8019c8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8019cd:	89 eb                	mov    %ebp,%ebx
  8019cf:	29 fb                	sub    %edi,%ebx
  8019d1:	89 f9                	mov    %edi,%ecx
  8019d3:	d3 e6                	shl    %cl,%esi
  8019d5:	89 c5                	mov    %eax,%ebp
  8019d7:	88 d9                	mov    %bl,%cl
  8019d9:	d3 ed                	shr    %cl,%ebp
  8019db:	89 e9                	mov    %ebp,%ecx
  8019dd:	09 f1                	or     %esi,%ecx
  8019df:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8019e3:	89 f9                	mov    %edi,%ecx
  8019e5:	d3 e0                	shl    %cl,%eax
  8019e7:	89 c5                	mov    %eax,%ebp
  8019e9:	89 d6                	mov    %edx,%esi
  8019eb:	88 d9                	mov    %bl,%cl
  8019ed:	d3 ee                	shr    %cl,%esi
  8019ef:	89 f9                	mov    %edi,%ecx
  8019f1:	d3 e2                	shl    %cl,%edx
  8019f3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019f7:	88 d9                	mov    %bl,%cl
  8019f9:	d3 e8                	shr    %cl,%eax
  8019fb:	09 c2                	or     %eax,%edx
  8019fd:	89 d0                	mov    %edx,%eax
  8019ff:	89 f2                	mov    %esi,%edx
  801a01:	f7 74 24 0c          	divl   0xc(%esp)
  801a05:	89 d6                	mov    %edx,%esi
  801a07:	89 c3                	mov    %eax,%ebx
  801a09:	f7 e5                	mul    %ebp
  801a0b:	39 d6                	cmp    %edx,%esi
  801a0d:	72 19                	jb     801a28 <__udivdi3+0xfc>
  801a0f:	74 0b                	je     801a1c <__udivdi3+0xf0>
  801a11:	89 d8                	mov    %ebx,%eax
  801a13:	31 ff                	xor    %edi,%edi
  801a15:	e9 58 ff ff ff       	jmp    801972 <__udivdi3+0x46>
  801a1a:	66 90                	xchg   %ax,%ax
  801a1c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a20:	89 f9                	mov    %edi,%ecx
  801a22:	d3 e2                	shl    %cl,%edx
  801a24:	39 c2                	cmp    %eax,%edx
  801a26:	73 e9                	jae    801a11 <__udivdi3+0xe5>
  801a28:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a2b:	31 ff                	xor    %edi,%edi
  801a2d:	e9 40 ff ff ff       	jmp    801972 <__udivdi3+0x46>
  801a32:	66 90                	xchg   %ax,%ax
  801a34:	31 c0                	xor    %eax,%eax
  801a36:	e9 37 ff ff ff       	jmp    801972 <__udivdi3+0x46>
  801a3b:	90                   	nop

00801a3c <__umoddi3>:
  801a3c:	55                   	push   %ebp
  801a3d:	57                   	push   %edi
  801a3e:	56                   	push   %esi
  801a3f:	53                   	push   %ebx
  801a40:	83 ec 1c             	sub    $0x1c,%esp
  801a43:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a47:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a4b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a4f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a53:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a57:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a5b:	89 f3                	mov    %esi,%ebx
  801a5d:	89 fa                	mov    %edi,%edx
  801a5f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a63:	89 34 24             	mov    %esi,(%esp)
  801a66:	85 c0                	test   %eax,%eax
  801a68:	75 1a                	jne    801a84 <__umoddi3+0x48>
  801a6a:	39 f7                	cmp    %esi,%edi
  801a6c:	0f 86 a2 00 00 00    	jbe    801b14 <__umoddi3+0xd8>
  801a72:	89 c8                	mov    %ecx,%eax
  801a74:	89 f2                	mov    %esi,%edx
  801a76:	f7 f7                	div    %edi
  801a78:	89 d0                	mov    %edx,%eax
  801a7a:	31 d2                	xor    %edx,%edx
  801a7c:	83 c4 1c             	add    $0x1c,%esp
  801a7f:	5b                   	pop    %ebx
  801a80:	5e                   	pop    %esi
  801a81:	5f                   	pop    %edi
  801a82:	5d                   	pop    %ebp
  801a83:	c3                   	ret    
  801a84:	39 f0                	cmp    %esi,%eax
  801a86:	0f 87 ac 00 00 00    	ja     801b38 <__umoddi3+0xfc>
  801a8c:	0f bd e8             	bsr    %eax,%ebp
  801a8f:	83 f5 1f             	xor    $0x1f,%ebp
  801a92:	0f 84 ac 00 00 00    	je     801b44 <__umoddi3+0x108>
  801a98:	bf 20 00 00 00       	mov    $0x20,%edi
  801a9d:	29 ef                	sub    %ebp,%edi
  801a9f:	89 fe                	mov    %edi,%esi
  801aa1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801aa5:	89 e9                	mov    %ebp,%ecx
  801aa7:	d3 e0                	shl    %cl,%eax
  801aa9:	89 d7                	mov    %edx,%edi
  801aab:	89 f1                	mov    %esi,%ecx
  801aad:	d3 ef                	shr    %cl,%edi
  801aaf:	09 c7                	or     %eax,%edi
  801ab1:	89 e9                	mov    %ebp,%ecx
  801ab3:	d3 e2                	shl    %cl,%edx
  801ab5:	89 14 24             	mov    %edx,(%esp)
  801ab8:	89 d8                	mov    %ebx,%eax
  801aba:	d3 e0                	shl    %cl,%eax
  801abc:	89 c2                	mov    %eax,%edx
  801abe:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ac2:	d3 e0                	shl    %cl,%eax
  801ac4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801acc:	89 f1                	mov    %esi,%ecx
  801ace:	d3 e8                	shr    %cl,%eax
  801ad0:	09 d0                	or     %edx,%eax
  801ad2:	d3 eb                	shr    %cl,%ebx
  801ad4:	89 da                	mov    %ebx,%edx
  801ad6:	f7 f7                	div    %edi
  801ad8:	89 d3                	mov    %edx,%ebx
  801ada:	f7 24 24             	mull   (%esp)
  801add:	89 c6                	mov    %eax,%esi
  801adf:	89 d1                	mov    %edx,%ecx
  801ae1:	39 d3                	cmp    %edx,%ebx
  801ae3:	0f 82 87 00 00 00    	jb     801b70 <__umoddi3+0x134>
  801ae9:	0f 84 91 00 00 00    	je     801b80 <__umoddi3+0x144>
  801aef:	8b 54 24 04          	mov    0x4(%esp),%edx
  801af3:	29 f2                	sub    %esi,%edx
  801af5:	19 cb                	sbb    %ecx,%ebx
  801af7:	89 d8                	mov    %ebx,%eax
  801af9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801afd:	d3 e0                	shl    %cl,%eax
  801aff:	89 e9                	mov    %ebp,%ecx
  801b01:	d3 ea                	shr    %cl,%edx
  801b03:	09 d0                	or     %edx,%eax
  801b05:	89 e9                	mov    %ebp,%ecx
  801b07:	d3 eb                	shr    %cl,%ebx
  801b09:	89 da                	mov    %ebx,%edx
  801b0b:	83 c4 1c             	add    $0x1c,%esp
  801b0e:	5b                   	pop    %ebx
  801b0f:	5e                   	pop    %esi
  801b10:	5f                   	pop    %edi
  801b11:	5d                   	pop    %ebp
  801b12:	c3                   	ret    
  801b13:	90                   	nop
  801b14:	89 fd                	mov    %edi,%ebp
  801b16:	85 ff                	test   %edi,%edi
  801b18:	75 0b                	jne    801b25 <__umoddi3+0xe9>
  801b1a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b1f:	31 d2                	xor    %edx,%edx
  801b21:	f7 f7                	div    %edi
  801b23:	89 c5                	mov    %eax,%ebp
  801b25:	89 f0                	mov    %esi,%eax
  801b27:	31 d2                	xor    %edx,%edx
  801b29:	f7 f5                	div    %ebp
  801b2b:	89 c8                	mov    %ecx,%eax
  801b2d:	f7 f5                	div    %ebp
  801b2f:	89 d0                	mov    %edx,%eax
  801b31:	e9 44 ff ff ff       	jmp    801a7a <__umoddi3+0x3e>
  801b36:	66 90                	xchg   %ax,%ax
  801b38:	89 c8                	mov    %ecx,%eax
  801b3a:	89 f2                	mov    %esi,%edx
  801b3c:	83 c4 1c             	add    $0x1c,%esp
  801b3f:	5b                   	pop    %ebx
  801b40:	5e                   	pop    %esi
  801b41:	5f                   	pop    %edi
  801b42:	5d                   	pop    %ebp
  801b43:	c3                   	ret    
  801b44:	3b 04 24             	cmp    (%esp),%eax
  801b47:	72 06                	jb     801b4f <__umoddi3+0x113>
  801b49:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b4d:	77 0f                	ja     801b5e <__umoddi3+0x122>
  801b4f:	89 f2                	mov    %esi,%edx
  801b51:	29 f9                	sub    %edi,%ecx
  801b53:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b57:	89 14 24             	mov    %edx,(%esp)
  801b5a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b5e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b62:	8b 14 24             	mov    (%esp),%edx
  801b65:	83 c4 1c             	add    $0x1c,%esp
  801b68:	5b                   	pop    %ebx
  801b69:	5e                   	pop    %esi
  801b6a:	5f                   	pop    %edi
  801b6b:	5d                   	pop    %ebp
  801b6c:	c3                   	ret    
  801b6d:	8d 76 00             	lea    0x0(%esi),%esi
  801b70:	2b 04 24             	sub    (%esp),%eax
  801b73:	19 fa                	sbb    %edi,%edx
  801b75:	89 d1                	mov    %edx,%ecx
  801b77:	89 c6                	mov    %eax,%esi
  801b79:	e9 71 ff ff ff       	jmp    801aef <__umoddi3+0xb3>
  801b7e:	66 90                	xchg   %ax,%ax
  801b80:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b84:	72 ea                	jb     801b70 <__umoddi3+0x134>
  801b86:	89 d9                	mov    %ebx,%ecx
  801b88:	e9 62 ff ff ff       	jmp    801aef <__umoddi3+0xb3>
