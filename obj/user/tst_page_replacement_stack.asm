
obj/user/tst_page_replacement_stack:     file format elf32-i386


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
  800031:	e8 f9 00 00 00       	call   80012f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 14 a0 00 00    	sub    $0xa014,%esp
	int8 arr[PAGE_SIZE*10];

	uint32 kilo = 1024;
  800042:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)

//	cprintf("envID = %d\n",envID);

	int freePages = sys_calculate_free_frames();
  800049:	e8 9d 13 00 00       	call   8013eb <sys_calculate_free_frames>
  80004e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  800051:	e8 e0 13 00 00       	call   801436 <sys_pf_calculate_allocated_pages>
  800056:	89 45 e8             	mov    %eax,-0x18(%ebp)

	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800059:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800060:	eb 15                	jmp    800077 <_main+0x3f>
		arr[i] = -1 ;
  800062:	8d 95 e8 5f ff ff    	lea    -0xa018(%ebp),%edx
  800068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	c6 00 ff             	movb   $0xff,(%eax)

	int freePages = sys_calculate_free_frames();
	int usedDiskPages = sys_pf_calculate_allocated_pages();

	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800070:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  800077:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  80007e:	7e e2                	jle    800062 <_main+0x2a>
		arr[i] = -1 ;


	cprintf("checking REPLACEMENT fault handling of STACK pages... \n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 e0 1b 80 00       	push   $0x801be0
  800088:	e8 a4 04 00 00       	call   800531 <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800090:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800097:	eb 2c                	jmp    8000c5 <_main+0x8d>
			if( arr[i] != -1) panic("modified stack page(s) not restored correctly");
  800099:	8d 95 e8 5f ff ff    	lea    -0xa018(%ebp),%edx
  80009f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a2:	01 d0                	add    %edx,%eax
  8000a4:	8a 00                	mov    (%eax),%al
  8000a6:	3c ff                	cmp    $0xff,%al
  8000a8:	74 14                	je     8000be <_main+0x86>
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	68 18 1c 80 00       	push   $0x801c18
  8000b2:	6a 1a                	push   $0x1a
  8000b4:	68 48 1c 80 00       	push   $0x801c48
  8000b9:	e8 b6 01 00 00       	call   800274 <_panic>
		arr[i] = -1 ;


	cprintf("checking REPLACEMENT fault handling of STACK pages... \n");
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000be:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  8000c5:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  8000cc:	7e cb                	jle    800099 <_main+0x61>
			if( arr[i] != -1) panic("modified stack page(s) not restored correctly");

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  10) panic("Unexpected extra/less pages have been added to page file");
  8000ce:	e8 63 13 00 00       	call   801436 <sys_pf_calculate_allocated_pages>
  8000d3:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000d6:	83 f8 0a             	cmp    $0xa,%eax
  8000d9:	74 14                	je     8000ef <_main+0xb7>
  8000db:	83 ec 04             	sub    $0x4,%esp
  8000de:	68 6c 1c 80 00       	push   $0x801c6c
  8000e3:	6a 1c                	push   $0x1c
  8000e5:	68 48 1c 80 00       	push   $0x801c48
  8000ea:	e8 85 01 00 00       	call   800274 <_panic>

		if( (freePages - (sys_calculate_free_frames() + sys_calculate_modified_frames())) != 0 ) panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
  8000ef:	e8 f7 12 00 00       	call   8013eb <sys_calculate_free_frames>
  8000f4:	89 c3                	mov    %eax,%ebx
  8000f6:	e8 09 13 00 00       	call   801404 <sys_calculate_modified_frames>
  8000fb:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8000fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800101:	39 c2                	cmp    %eax,%edx
  800103:	74 14                	je     800119 <_main+0xe1>
  800105:	83 ec 04             	sub    $0x4,%esp
  800108:	68 a8 1c 80 00       	push   $0x801ca8
  80010d:	6a 1e                	push   $0x1e
  80010f:	68 48 1c 80 00       	push   $0x801c48
  800114:	e8 5b 01 00 00       	call   800274 <_panic>
	}//consider tables of PF, disk pages

	cprintf("Congratulations: stack pages created, modified and read is completed successfully\n\n");
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	68 0c 1d 80 00       	push   $0x801d0c
  800121:	e8 0b 04 00 00       	call   800531 <cprintf>
  800126:	83 c4 10             	add    $0x10,%esp


	return;
  800129:	90                   	nop
}
  80012a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80012d:	c9                   	leave  
  80012e:	c3                   	ret    

0080012f <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800135:	e8 7a 14 00 00       	call   8015b4 <sys_getenvindex>
  80013a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80013d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800140:	89 d0                	mov    %edx,%eax
  800142:	c1 e0 02             	shl    $0x2,%eax
  800145:	01 d0                	add    %edx,%eax
  800147:	c1 e0 03             	shl    $0x3,%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800153:	01 d0                	add    %edx,%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80015d:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800162:	a1 08 30 80 00       	mov    0x803008,%eax
  800167:	8a 40 20             	mov    0x20(%eax),%al
  80016a:	84 c0                	test   %al,%al
  80016c:	74 0d                	je     80017b <libmain+0x4c>
		binaryname = myEnv->prog_name;
  80016e:	a1 08 30 80 00       	mov    0x803008,%eax
  800173:	83 c0 20             	add    $0x20,%eax
  800176:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80017b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80017f:	7e 0a                	jle    80018b <libmain+0x5c>
		binaryname = argv[0];
  800181:	8b 45 0c             	mov    0xc(%ebp),%eax
  800184:	8b 00                	mov    (%eax),%eax
  800186:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80018b:	83 ec 08             	sub    $0x8,%esp
  80018e:	ff 75 0c             	pushl  0xc(%ebp)
  800191:	ff 75 08             	pushl  0x8(%ebp)
  800194:	e8 9f fe ff ff       	call   800038 <_main>
  800199:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80019c:	a1 00 30 80 00       	mov    0x803000,%eax
  8001a1:	85 c0                	test   %eax,%eax
  8001a3:	0f 84 9f 00 00 00    	je     800248 <libmain+0x119>
	{
		sys_lock_cons();
  8001a9:	e8 8a 11 00 00       	call   801338 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	68 78 1d 80 00       	push   $0x801d78
  8001b6:	e8 76 03 00 00       	call   800531 <cprintf>
  8001bb:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001be:	a1 08 30 80 00       	mov    0x803008,%eax
  8001c3:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001c9:	a1 08 30 80 00       	mov    0x803008,%eax
  8001ce:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8001d4:	83 ec 04             	sub    $0x4,%esp
  8001d7:	52                   	push   %edx
  8001d8:	50                   	push   %eax
  8001d9:	68 a0 1d 80 00       	push   $0x801da0
  8001de:	e8 4e 03 00 00       	call   800531 <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e6:	a1 08 30 80 00       	mov    0x803008,%eax
  8001eb:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8001f1:	a1 08 30 80 00       	mov    0x803008,%eax
  8001f6:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8001fc:	a1 08 30 80 00       	mov    0x803008,%eax
  800201:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800207:	51                   	push   %ecx
  800208:	52                   	push   %edx
  800209:	50                   	push   %eax
  80020a:	68 c8 1d 80 00       	push   $0x801dc8
  80020f:	e8 1d 03 00 00       	call   800531 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800217:	a1 08 30 80 00       	mov    0x803008,%eax
  80021c:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	50                   	push   %eax
  800226:	68 20 1e 80 00       	push   $0x801e20
  80022b:	e8 01 03 00 00       	call   800531 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800233:	83 ec 0c             	sub    $0xc,%esp
  800236:	68 78 1d 80 00       	push   $0x801d78
  80023b:	e8 f1 02 00 00       	call   800531 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800243:	e8 0a 11 00 00       	call   801352 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800248:	e8 19 00 00 00       	call   800266 <exit>
}
  80024d:	90                   	nop
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	6a 00                	push   $0x0
  80025b:	e8 20 13 00 00       	call   801580 <sys_destroy_env>
  800260:	83 c4 10             	add    $0x10,%esp
}
  800263:	90                   	nop
  800264:	c9                   	leave  
  800265:	c3                   	ret    

00800266 <exit>:

void
exit(void)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80026c:	e8 75 13 00 00       	call   8015e6 <sys_exit_env>
}
  800271:	90                   	nop
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80027a:	8d 45 10             	lea    0x10(%ebp),%eax
  80027d:	83 c0 04             	add    $0x4,%eax
  800280:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800283:	a1 28 30 80 00       	mov    0x803028,%eax
  800288:	85 c0                	test   %eax,%eax
  80028a:	74 16                	je     8002a2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80028c:	a1 28 30 80 00       	mov    0x803028,%eax
  800291:	83 ec 08             	sub    $0x8,%esp
  800294:	50                   	push   %eax
  800295:	68 34 1e 80 00       	push   $0x801e34
  80029a:	e8 92 02 00 00       	call   800531 <cprintf>
  80029f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002a2:	a1 04 30 80 00       	mov    0x803004,%eax
  8002a7:	ff 75 0c             	pushl  0xc(%ebp)
  8002aa:	ff 75 08             	pushl  0x8(%ebp)
  8002ad:	50                   	push   %eax
  8002ae:	68 39 1e 80 00       	push   $0x801e39
  8002b3:	e8 79 02 00 00       	call   800531 <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8002be:	83 ec 08             	sub    $0x8,%esp
  8002c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8002c4:	50                   	push   %eax
  8002c5:	e8 fc 01 00 00       	call   8004c6 <vcprintf>
  8002ca:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002cd:	83 ec 08             	sub    $0x8,%esp
  8002d0:	6a 00                	push   $0x0
  8002d2:	68 55 1e 80 00       	push   $0x801e55
  8002d7:	e8 ea 01 00 00       	call   8004c6 <vcprintf>
  8002dc:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002df:	e8 82 ff ff ff       	call   800266 <exit>

	// should not return here
	while (1) ;
  8002e4:	eb fe                	jmp    8002e4 <_panic+0x70>

008002e6 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002ec:	a1 08 30 80 00       	mov    0x803008,%eax
  8002f1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8002f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fa:	39 c2                	cmp    %eax,%edx
  8002fc:	74 14                	je     800312 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 58 1e 80 00       	push   $0x801e58
  800306:	6a 26                	push   $0x26
  800308:	68 a4 1e 80 00       	push   $0x801ea4
  80030d:	e8 62 ff ff ff       	call   800274 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800312:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800319:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800320:	e9 c5 00 00 00       	jmp    8003ea <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800328:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032f:	8b 45 08             	mov    0x8(%ebp),%eax
  800332:	01 d0                	add    %edx,%eax
  800334:	8b 00                	mov    (%eax),%eax
  800336:	85 c0                	test   %eax,%eax
  800338:	75 08                	jne    800342 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80033a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80033d:	e9 a5 00 00 00       	jmp    8003e7 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800342:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800349:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800350:	eb 69                	jmp    8003bb <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800352:	a1 08 30 80 00       	mov    0x803008,%eax
  800357:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80035d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800360:	89 d0                	mov    %edx,%eax
  800362:	01 c0                	add    %eax,%eax
  800364:	01 d0                	add    %edx,%eax
  800366:	c1 e0 03             	shl    $0x3,%eax
  800369:	01 c8                	add    %ecx,%eax
  80036b:	8a 40 04             	mov    0x4(%eax),%al
  80036e:	84 c0                	test   %al,%al
  800370:	75 46                	jne    8003b8 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800372:	a1 08 30 80 00       	mov    0x803008,%eax
  800377:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80037d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800380:	89 d0                	mov    %edx,%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	c1 e0 03             	shl    $0x3,%eax
  800389:	01 c8                	add    %ecx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800390:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800398:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80039a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	01 c8                	add    %ecx,%eax
  8003a9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ab:	39 c2                	cmp    %eax,%edx
  8003ad:	75 09                	jne    8003b8 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003af:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003b6:	eb 15                	jmp    8003cd <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b8:	ff 45 e8             	incl   -0x18(%ebp)
  8003bb:	a1 08 30 80 00       	mov    0x803008,%eax
  8003c0:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8003c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003c9:	39 c2                	cmp    %eax,%edx
  8003cb:	77 85                	ja     800352 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003d1:	75 14                	jne    8003e7 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003d3:	83 ec 04             	sub    $0x4,%esp
  8003d6:	68 b0 1e 80 00       	push   $0x801eb0
  8003db:	6a 3a                	push   $0x3a
  8003dd:	68 a4 1e 80 00       	push   $0x801ea4
  8003e2:	e8 8d fe ff ff       	call   800274 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003e7:	ff 45 f0             	incl   -0x10(%ebp)
  8003ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ed:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f0:	0f 8c 2f ff ff ff    	jl     800325 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003f6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800404:	eb 26                	jmp    80042c <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800406:	a1 08 30 80 00       	mov    0x803008,%eax
  80040b:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800411:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800414:	89 d0                	mov    %edx,%eax
  800416:	01 c0                	add    %eax,%eax
  800418:	01 d0                	add    %edx,%eax
  80041a:	c1 e0 03             	shl    $0x3,%eax
  80041d:	01 c8                	add    %ecx,%eax
  80041f:	8a 40 04             	mov    0x4(%eax),%al
  800422:	3c 01                	cmp    $0x1,%al
  800424:	75 03                	jne    800429 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800426:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800429:	ff 45 e0             	incl   -0x20(%ebp)
  80042c:	a1 08 30 80 00       	mov    0x803008,%eax
  800431:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800437:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043a:	39 c2                	cmp    %eax,%edx
  80043c:	77 c8                	ja     800406 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80043e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800441:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800444:	74 14                	je     80045a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800446:	83 ec 04             	sub    $0x4,%esp
  800449:	68 04 1f 80 00       	push   $0x801f04
  80044e:	6a 44                	push   $0x44
  800450:	68 a4 1e 80 00       	push   $0x801ea4
  800455:	e8 1a fe ff ff       	call   800274 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80045a:	90                   	nop
  80045b:	c9                   	leave  
  80045c:	c3                   	ret    

0080045d <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80045d:	55                   	push   %ebp
  80045e:	89 e5                	mov    %esp,%ebp
  800460:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800463:	8b 45 0c             	mov    0xc(%ebp),%eax
  800466:	8b 00                	mov    (%eax),%eax
  800468:	8d 48 01             	lea    0x1(%eax),%ecx
  80046b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046e:	89 0a                	mov    %ecx,(%edx)
  800470:	8b 55 08             	mov    0x8(%ebp),%edx
  800473:	88 d1                	mov    %dl,%cl
  800475:	8b 55 0c             	mov    0xc(%ebp),%edx
  800478:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80047c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047f:	8b 00                	mov    (%eax),%eax
  800481:	3d ff 00 00 00       	cmp    $0xff,%eax
  800486:	75 2c                	jne    8004b4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800488:	a0 0c 30 80 00       	mov    0x80300c,%al
  80048d:	0f b6 c0             	movzbl %al,%eax
  800490:	8b 55 0c             	mov    0xc(%ebp),%edx
  800493:	8b 12                	mov    (%edx),%edx
  800495:	89 d1                	mov    %edx,%ecx
  800497:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049a:	83 c2 08             	add    $0x8,%edx
  80049d:	83 ec 04             	sub    $0x4,%esp
  8004a0:	50                   	push   %eax
  8004a1:	51                   	push   %ecx
  8004a2:	52                   	push   %edx
  8004a3:	e8 4e 0e 00 00       	call   8012f6 <sys_cputs>
  8004a8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b7:	8b 40 04             	mov    0x4(%eax),%eax
  8004ba:	8d 50 01             	lea    0x1(%eax),%edx
  8004bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c0:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004c3:	90                   	nop
  8004c4:	c9                   	leave  
  8004c5:	c3                   	ret    

008004c6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004c6:	55                   	push   %ebp
  8004c7:	89 e5                	mov    %esp,%ebp
  8004c9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004cf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d6:	00 00 00 
	b.cnt = 0;
  8004d9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e0:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004e3:	ff 75 0c             	pushl  0xc(%ebp)
  8004e6:	ff 75 08             	pushl  0x8(%ebp)
  8004e9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004ef:	50                   	push   %eax
  8004f0:	68 5d 04 80 00       	push   $0x80045d
  8004f5:	e8 11 02 00 00       	call   80070b <vprintfmt>
  8004fa:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004fd:	a0 0c 30 80 00       	mov    0x80300c,%al
  800502:	0f b6 c0             	movzbl %al,%eax
  800505:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80050b:	83 ec 04             	sub    $0x4,%esp
  80050e:	50                   	push   %eax
  80050f:	52                   	push   %edx
  800510:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800516:	83 c0 08             	add    $0x8,%eax
  800519:	50                   	push   %eax
  80051a:	e8 d7 0d 00 00       	call   8012f6 <sys_cputs>
  80051f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800522:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  800529:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80052f:	c9                   	leave  
  800530:	c3                   	ret    

00800531 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800531:	55                   	push   %ebp
  800532:	89 e5                	mov    %esp,%ebp
  800534:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800537:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  80053e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800541:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	83 ec 08             	sub    $0x8,%esp
  80054a:	ff 75 f4             	pushl  -0xc(%ebp)
  80054d:	50                   	push   %eax
  80054e:	e8 73 ff ff ff       	call   8004c6 <vcprintf>
  800553:	83 c4 10             	add    $0x10,%esp
  800556:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800559:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    

0080055e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800564:	e8 cf 0d 00 00       	call   801338 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800569:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80056f:	8b 45 08             	mov    0x8(%ebp),%eax
  800572:	83 ec 08             	sub    $0x8,%esp
  800575:	ff 75 f4             	pushl  -0xc(%ebp)
  800578:	50                   	push   %eax
  800579:	e8 48 ff ff ff       	call   8004c6 <vcprintf>
  80057e:	83 c4 10             	add    $0x10,%esp
  800581:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800584:	e8 c9 0d 00 00       	call   801352 <sys_unlock_cons>
	return cnt;
  800589:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80058c:	c9                   	leave  
  80058d:	c3                   	ret    

0080058e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80058e:	55                   	push   %ebp
  80058f:	89 e5                	mov    %esp,%ebp
  800591:	53                   	push   %ebx
  800592:	83 ec 14             	sub    $0x14,%esp
  800595:	8b 45 10             	mov    0x10(%ebp),%eax
  800598:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80059b:	8b 45 14             	mov    0x14(%ebp),%eax
  80059e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ac:	77 55                	ja     800603 <printnum+0x75>
  8005ae:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b1:	72 05                	jb     8005b8 <printnum+0x2a>
  8005b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b6:	77 4b                	ja     800603 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005bb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005be:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c6:	52                   	push   %edx
  8005c7:	50                   	push   %eax
  8005c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cb:	ff 75 f0             	pushl  -0x10(%ebp)
  8005ce:	e8 95 13 00 00       	call   801968 <__udivdi3>
  8005d3:	83 c4 10             	add    $0x10,%esp
  8005d6:	83 ec 04             	sub    $0x4,%esp
  8005d9:	ff 75 20             	pushl  0x20(%ebp)
  8005dc:	53                   	push   %ebx
  8005dd:	ff 75 18             	pushl  0x18(%ebp)
  8005e0:	52                   	push   %edx
  8005e1:	50                   	push   %eax
  8005e2:	ff 75 0c             	pushl  0xc(%ebp)
  8005e5:	ff 75 08             	pushl  0x8(%ebp)
  8005e8:	e8 a1 ff ff ff       	call   80058e <printnum>
  8005ed:	83 c4 20             	add    $0x20,%esp
  8005f0:	eb 1a                	jmp    80060c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f2:	83 ec 08             	sub    $0x8,%esp
  8005f5:	ff 75 0c             	pushl  0xc(%ebp)
  8005f8:	ff 75 20             	pushl  0x20(%ebp)
  8005fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fe:	ff d0                	call   *%eax
  800600:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800603:	ff 4d 1c             	decl   0x1c(%ebp)
  800606:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80060a:	7f e6                	jg     8005f2 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80060c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80060f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800617:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061a:	53                   	push   %ebx
  80061b:	51                   	push   %ecx
  80061c:	52                   	push   %edx
  80061d:	50                   	push   %eax
  80061e:	e8 55 14 00 00       	call   801a78 <__umoddi3>
  800623:	83 c4 10             	add    $0x10,%esp
  800626:	05 74 21 80 00       	add    $0x802174,%eax
  80062b:	8a 00                	mov    (%eax),%al
  80062d:	0f be c0             	movsbl %al,%eax
  800630:	83 ec 08             	sub    $0x8,%esp
  800633:	ff 75 0c             	pushl  0xc(%ebp)
  800636:	50                   	push   %eax
  800637:	8b 45 08             	mov    0x8(%ebp),%eax
  80063a:	ff d0                	call   *%eax
  80063c:	83 c4 10             	add    $0x10,%esp
}
  80063f:	90                   	nop
  800640:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800643:	c9                   	leave  
  800644:	c3                   	ret    

00800645 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800645:	55                   	push   %ebp
  800646:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800648:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80064c:	7e 1c                	jle    80066a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	8b 00                	mov    (%eax),%eax
  800653:	8d 50 08             	lea    0x8(%eax),%edx
  800656:	8b 45 08             	mov    0x8(%ebp),%eax
  800659:	89 10                	mov    %edx,(%eax)
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	83 e8 08             	sub    $0x8,%eax
  800663:	8b 50 04             	mov    0x4(%eax),%edx
  800666:	8b 00                	mov    (%eax),%eax
  800668:	eb 40                	jmp    8006aa <getuint+0x65>
	else if (lflag)
  80066a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80066e:	74 1e                	je     80068e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	8d 50 04             	lea    0x4(%eax),%edx
  800678:	8b 45 08             	mov    0x8(%ebp),%eax
  80067b:	89 10                	mov    %edx,(%eax)
  80067d:	8b 45 08             	mov    0x8(%ebp),%eax
  800680:	8b 00                	mov    (%eax),%eax
  800682:	83 e8 04             	sub    $0x4,%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	ba 00 00 00 00       	mov    $0x0,%edx
  80068c:	eb 1c                	jmp    8006aa <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	8b 00                	mov    (%eax),%eax
  800693:	8d 50 04             	lea    0x4(%eax),%edx
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	89 10                	mov    %edx,(%eax)
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	83 e8 04             	sub    $0x4,%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006aa:	5d                   	pop    %ebp
  8006ab:	c3                   	ret    

008006ac <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ac:	55                   	push   %ebp
  8006ad:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006af:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b3:	7e 1c                	jle    8006d1 <getint+0x25>
		return va_arg(*ap, long long);
  8006b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	8d 50 08             	lea    0x8(%eax),%edx
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	89 10                	mov    %edx,(%eax)
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	83 e8 08             	sub    $0x8,%eax
  8006ca:	8b 50 04             	mov    0x4(%eax),%edx
  8006cd:	8b 00                	mov    (%eax),%eax
  8006cf:	eb 38                	jmp    800709 <getint+0x5d>
	else if (lflag)
  8006d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006d5:	74 1a                	je     8006f1 <getint+0x45>
		return va_arg(*ap, long);
  8006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	8d 50 04             	lea    0x4(%eax),%edx
  8006df:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e2:	89 10                	mov    %edx,(%eax)
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	8b 00                	mov    (%eax),%eax
  8006e9:	83 e8 04             	sub    $0x4,%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	99                   	cltd   
  8006ef:	eb 18                	jmp    800709 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	8d 50 04             	lea    0x4(%eax),%edx
  8006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fc:	89 10                	mov    %edx,(%eax)
  8006fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800701:	8b 00                	mov    (%eax),%eax
  800703:	83 e8 04             	sub    $0x4,%eax
  800706:	8b 00                	mov    (%eax),%eax
  800708:	99                   	cltd   
}
  800709:	5d                   	pop    %ebp
  80070a:	c3                   	ret    

0080070b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80070b:	55                   	push   %ebp
  80070c:	89 e5                	mov    %esp,%ebp
  80070e:	56                   	push   %esi
  80070f:	53                   	push   %ebx
  800710:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800713:	eb 17                	jmp    80072c <vprintfmt+0x21>
			if (ch == '\0')
  800715:	85 db                	test   %ebx,%ebx
  800717:	0f 84 c1 03 00 00    	je     800ade <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	ff 75 0c             	pushl  0xc(%ebp)
  800723:	53                   	push   %ebx
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	ff d0                	call   *%eax
  800729:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072c:	8b 45 10             	mov    0x10(%ebp),%eax
  80072f:	8d 50 01             	lea    0x1(%eax),%edx
  800732:	89 55 10             	mov    %edx,0x10(%ebp)
  800735:	8a 00                	mov    (%eax),%al
  800737:	0f b6 d8             	movzbl %al,%ebx
  80073a:	83 fb 25             	cmp    $0x25,%ebx
  80073d:	75 d6                	jne    800715 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80073f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800743:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80074a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800751:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800758:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80075f:	8b 45 10             	mov    0x10(%ebp),%eax
  800762:	8d 50 01             	lea    0x1(%eax),%edx
  800765:	89 55 10             	mov    %edx,0x10(%ebp)
  800768:	8a 00                	mov    (%eax),%al
  80076a:	0f b6 d8             	movzbl %al,%ebx
  80076d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800770:	83 f8 5b             	cmp    $0x5b,%eax
  800773:	0f 87 3d 03 00 00    	ja     800ab6 <vprintfmt+0x3ab>
  800779:	8b 04 85 98 21 80 00 	mov    0x802198(,%eax,4),%eax
  800780:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800782:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800786:	eb d7                	jmp    80075f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800788:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80078c:	eb d1                	jmp    80075f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80078e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800795:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800798:	89 d0                	mov    %edx,%eax
  80079a:	c1 e0 02             	shl    $0x2,%eax
  80079d:	01 d0                	add    %edx,%eax
  80079f:	01 c0                	add    %eax,%eax
  8007a1:	01 d8                	add    %ebx,%eax
  8007a3:	83 e8 30             	sub    $0x30,%eax
  8007a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ac:	8a 00                	mov    (%eax),%al
  8007ae:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007b1:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b4:	7e 3e                	jle    8007f4 <vprintfmt+0xe9>
  8007b6:	83 fb 39             	cmp    $0x39,%ebx
  8007b9:	7f 39                	jg     8007f4 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007bb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007be:	eb d5                	jmp    800795 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	83 c0 04             	add    $0x4,%eax
  8007c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	83 e8 04             	sub    $0x4,%eax
  8007cf:	8b 00                	mov    (%eax),%eax
  8007d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d4:	eb 1f                	jmp    8007f5 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007da:	79 83                	jns    80075f <vprintfmt+0x54>
				width = 0;
  8007dc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007e3:	e9 77 ff ff ff       	jmp    80075f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007e8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007ef:	e9 6b ff ff ff       	jmp    80075f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f4:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f9:	0f 89 60 ff ff ff    	jns    80075f <vprintfmt+0x54>
				width = precision, precision = -1;
  8007ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800802:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800805:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80080c:	e9 4e ff ff ff       	jmp    80075f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800811:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800814:	e9 46 ff ff ff       	jmp    80075f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800819:	8b 45 14             	mov    0x14(%ebp),%eax
  80081c:	83 c0 04             	add    $0x4,%eax
  80081f:	89 45 14             	mov    %eax,0x14(%ebp)
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	83 e8 04             	sub    $0x4,%eax
  800828:	8b 00                	mov    (%eax),%eax
  80082a:	83 ec 08             	sub    $0x8,%esp
  80082d:	ff 75 0c             	pushl  0xc(%ebp)
  800830:	50                   	push   %eax
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	ff d0                	call   *%eax
  800836:	83 c4 10             	add    $0x10,%esp
			break;
  800839:	e9 9b 02 00 00       	jmp    800ad9 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80083e:	8b 45 14             	mov    0x14(%ebp),%eax
  800841:	83 c0 04             	add    $0x4,%eax
  800844:	89 45 14             	mov    %eax,0x14(%ebp)
  800847:	8b 45 14             	mov    0x14(%ebp),%eax
  80084a:	83 e8 04             	sub    $0x4,%eax
  80084d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80084f:	85 db                	test   %ebx,%ebx
  800851:	79 02                	jns    800855 <vprintfmt+0x14a>
				err = -err;
  800853:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800855:	83 fb 64             	cmp    $0x64,%ebx
  800858:	7f 0b                	jg     800865 <vprintfmt+0x15a>
  80085a:	8b 34 9d e0 1f 80 00 	mov    0x801fe0(,%ebx,4),%esi
  800861:	85 f6                	test   %esi,%esi
  800863:	75 19                	jne    80087e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800865:	53                   	push   %ebx
  800866:	68 85 21 80 00       	push   $0x802185
  80086b:	ff 75 0c             	pushl  0xc(%ebp)
  80086e:	ff 75 08             	pushl  0x8(%ebp)
  800871:	e8 70 02 00 00       	call   800ae6 <printfmt>
  800876:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800879:	e9 5b 02 00 00       	jmp    800ad9 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80087e:	56                   	push   %esi
  80087f:	68 8e 21 80 00       	push   $0x80218e
  800884:	ff 75 0c             	pushl  0xc(%ebp)
  800887:	ff 75 08             	pushl  0x8(%ebp)
  80088a:	e8 57 02 00 00       	call   800ae6 <printfmt>
  80088f:	83 c4 10             	add    $0x10,%esp
			break;
  800892:	e9 42 02 00 00       	jmp    800ad9 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	83 c0 04             	add    $0x4,%eax
  80089d:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a3:	83 e8 04             	sub    $0x4,%eax
  8008a6:	8b 30                	mov    (%eax),%esi
  8008a8:	85 f6                	test   %esi,%esi
  8008aa:	75 05                	jne    8008b1 <vprintfmt+0x1a6>
				p = "(null)";
  8008ac:	be 91 21 80 00       	mov    $0x802191,%esi
			if (width > 0 && padc != '-')
  8008b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b5:	7e 6d                	jle    800924 <vprintfmt+0x219>
  8008b7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008bb:	74 67                	je     800924 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c0:	83 ec 08             	sub    $0x8,%esp
  8008c3:	50                   	push   %eax
  8008c4:	56                   	push   %esi
  8008c5:	e8 1e 03 00 00       	call   800be8 <strnlen>
  8008ca:	83 c4 10             	add    $0x10,%esp
  8008cd:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d0:	eb 16                	jmp    8008e8 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008d2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d6:	83 ec 08             	sub    $0x8,%esp
  8008d9:	ff 75 0c             	pushl  0xc(%ebp)
  8008dc:	50                   	push   %eax
  8008dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e0:	ff d0                	call   *%eax
  8008e2:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e5:	ff 4d e4             	decl   -0x1c(%ebp)
  8008e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ec:	7f e4                	jg     8008d2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ee:	eb 34                	jmp    800924 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f4:	74 1c                	je     800912 <vprintfmt+0x207>
  8008f6:	83 fb 1f             	cmp    $0x1f,%ebx
  8008f9:	7e 05                	jle    800900 <vprintfmt+0x1f5>
  8008fb:	83 fb 7e             	cmp    $0x7e,%ebx
  8008fe:	7e 12                	jle    800912 <vprintfmt+0x207>
					putch('?', putdat);
  800900:	83 ec 08             	sub    $0x8,%esp
  800903:	ff 75 0c             	pushl  0xc(%ebp)
  800906:	6a 3f                	push   $0x3f
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	ff d0                	call   *%eax
  80090d:	83 c4 10             	add    $0x10,%esp
  800910:	eb 0f                	jmp    800921 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800912:	83 ec 08             	sub    $0x8,%esp
  800915:	ff 75 0c             	pushl  0xc(%ebp)
  800918:	53                   	push   %ebx
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	ff d0                	call   *%eax
  80091e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800921:	ff 4d e4             	decl   -0x1c(%ebp)
  800924:	89 f0                	mov    %esi,%eax
  800926:	8d 70 01             	lea    0x1(%eax),%esi
  800929:	8a 00                	mov    (%eax),%al
  80092b:	0f be d8             	movsbl %al,%ebx
  80092e:	85 db                	test   %ebx,%ebx
  800930:	74 24                	je     800956 <vprintfmt+0x24b>
  800932:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800936:	78 b8                	js     8008f0 <vprintfmt+0x1e5>
  800938:	ff 4d e0             	decl   -0x20(%ebp)
  80093b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80093f:	79 af                	jns    8008f0 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800941:	eb 13                	jmp    800956 <vprintfmt+0x24b>
				putch(' ', putdat);
  800943:	83 ec 08             	sub    $0x8,%esp
  800946:	ff 75 0c             	pushl  0xc(%ebp)
  800949:	6a 20                	push   $0x20
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	ff d0                	call   *%eax
  800950:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800953:	ff 4d e4             	decl   -0x1c(%ebp)
  800956:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095a:	7f e7                	jg     800943 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80095c:	e9 78 01 00 00       	jmp    800ad9 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800961:	83 ec 08             	sub    $0x8,%esp
  800964:	ff 75 e8             	pushl  -0x18(%ebp)
  800967:	8d 45 14             	lea    0x14(%ebp),%eax
  80096a:	50                   	push   %eax
  80096b:	e8 3c fd ff ff       	call   8006ac <getint>
  800970:	83 c4 10             	add    $0x10,%esp
  800973:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800976:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800979:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80097c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80097f:	85 d2                	test   %edx,%edx
  800981:	79 23                	jns    8009a6 <vprintfmt+0x29b>
				putch('-', putdat);
  800983:	83 ec 08             	sub    $0x8,%esp
  800986:	ff 75 0c             	pushl  0xc(%ebp)
  800989:	6a 2d                	push   $0x2d
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	ff d0                	call   *%eax
  800990:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800993:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800996:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800999:	f7 d8                	neg    %eax
  80099b:	83 d2 00             	adc    $0x0,%edx
  80099e:	f7 da                	neg    %edx
  8009a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ad:	e9 bc 00 00 00       	jmp    800a6e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b2:	83 ec 08             	sub    $0x8,%esp
  8009b5:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bb:	50                   	push   %eax
  8009bc:	e8 84 fc ff ff       	call   800645 <getuint>
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009ca:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d1:	e9 98 00 00 00       	jmp    800a6e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 0c             	pushl  0xc(%ebp)
  8009dc:	6a 58                	push   $0x58
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	ff d0                	call   *%eax
  8009e3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e6:	83 ec 08             	sub    $0x8,%esp
  8009e9:	ff 75 0c             	pushl  0xc(%ebp)
  8009ec:	6a 58                	push   $0x58
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	ff d0                	call   *%eax
  8009f3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f6:	83 ec 08             	sub    $0x8,%esp
  8009f9:	ff 75 0c             	pushl  0xc(%ebp)
  8009fc:	6a 58                	push   $0x58
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	ff d0                	call   *%eax
  800a03:	83 c4 10             	add    $0x10,%esp
			break;
  800a06:	e9 ce 00 00 00       	jmp    800ad9 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a0b:	83 ec 08             	sub    $0x8,%esp
  800a0e:	ff 75 0c             	pushl  0xc(%ebp)
  800a11:	6a 30                	push   $0x30
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	ff d0                	call   *%eax
  800a18:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 0c             	pushl  0xc(%ebp)
  800a21:	6a 78                	push   $0x78
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	ff d0                	call   *%eax
  800a28:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2e:	83 c0 04             	add    $0x4,%eax
  800a31:	89 45 14             	mov    %eax,0x14(%ebp)
  800a34:	8b 45 14             	mov    0x14(%ebp),%eax
  800a37:	83 e8 04             	sub    $0x4,%eax
  800a3a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a46:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a4d:	eb 1f                	jmp    800a6e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a4f:	83 ec 08             	sub    $0x8,%esp
  800a52:	ff 75 e8             	pushl  -0x18(%ebp)
  800a55:	8d 45 14             	lea    0x14(%ebp),%eax
  800a58:	50                   	push   %eax
  800a59:	e8 e7 fb ff ff       	call   800645 <getuint>
  800a5e:	83 c4 10             	add    $0x10,%esp
  800a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a64:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a67:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a6e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a75:	83 ec 04             	sub    $0x4,%esp
  800a78:	52                   	push   %edx
  800a79:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a7c:	50                   	push   %eax
  800a7d:	ff 75 f4             	pushl  -0xc(%ebp)
  800a80:	ff 75 f0             	pushl  -0x10(%ebp)
  800a83:	ff 75 0c             	pushl  0xc(%ebp)
  800a86:	ff 75 08             	pushl  0x8(%ebp)
  800a89:	e8 00 fb ff ff       	call   80058e <printnum>
  800a8e:	83 c4 20             	add    $0x20,%esp
			break;
  800a91:	eb 46                	jmp    800ad9 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a93:	83 ec 08             	sub    $0x8,%esp
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	53                   	push   %ebx
  800a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9d:	ff d0                	call   *%eax
  800a9f:	83 c4 10             	add    $0x10,%esp
			break;
  800aa2:	eb 35                	jmp    800ad9 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800aa4:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  800aab:	eb 2c                	jmp    800ad9 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800aad:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  800ab4:	eb 23                	jmp    800ad9 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ab6:	83 ec 08             	sub    $0x8,%esp
  800ab9:	ff 75 0c             	pushl  0xc(%ebp)
  800abc:	6a 25                	push   $0x25
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	ff d0                	call   *%eax
  800ac3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ac6:	ff 4d 10             	decl   0x10(%ebp)
  800ac9:	eb 03                	jmp    800ace <vprintfmt+0x3c3>
  800acb:	ff 4d 10             	decl   0x10(%ebp)
  800ace:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad1:	48                   	dec    %eax
  800ad2:	8a 00                	mov    (%eax),%al
  800ad4:	3c 25                	cmp    $0x25,%al
  800ad6:	75 f3                	jne    800acb <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ad8:	90                   	nop
		}
	}
  800ad9:	e9 35 fc ff ff       	jmp    800713 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ade:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800adf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ae2:	5b                   	pop    %ebx
  800ae3:	5e                   	pop    %esi
  800ae4:	5d                   	pop    %ebp
  800ae5:	c3                   	ret    

00800ae6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800aec:	8d 45 10             	lea    0x10(%ebp),%eax
  800aef:	83 c0 04             	add    $0x4,%eax
  800af2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800af5:	8b 45 10             	mov    0x10(%ebp),%eax
  800af8:	ff 75 f4             	pushl  -0xc(%ebp)
  800afb:	50                   	push   %eax
  800afc:	ff 75 0c             	pushl  0xc(%ebp)
  800aff:	ff 75 08             	pushl  0x8(%ebp)
  800b02:	e8 04 fc ff ff       	call   80070b <vprintfmt>
  800b07:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b0a:	90                   	nop
  800b0b:	c9                   	leave  
  800b0c:	c3                   	ret    

00800b0d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b13:	8b 40 08             	mov    0x8(%eax),%eax
  800b16:	8d 50 01             	lea    0x1(%eax),%edx
  800b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b22:	8b 10                	mov    (%eax),%edx
  800b24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b27:	8b 40 04             	mov    0x4(%eax),%eax
  800b2a:	39 c2                	cmp    %eax,%edx
  800b2c:	73 12                	jae    800b40 <sprintputch+0x33>
		*b->buf++ = ch;
  800b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b31:	8b 00                	mov    (%eax),%eax
  800b33:	8d 48 01             	lea    0x1(%eax),%ecx
  800b36:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b39:	89 0a                	mov    %ecx,(%edx)
  800b3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3e:	88 10                	mov    %dl,(%eax)
}
  800b40:	90                   	nop
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    

00800b43 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b52:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	01 d0                	add    %edx,%eax
  800b5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b68:	74 06                	je     800b70 <vsnprintf+0x2d>
  800b6a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6e:	7f 07                	jg     800b77 <vsnprintf+0x34>
		return -E_INVAL;
  800b70:	b8 03 00 00 00       	mov    $0x3,%eax
  800b75:	eb 20                	jmp    800b97 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b77:	ff 75 14             	pushl  0x14(%ebp)
  800b7a:	ff 75 10             	pushl  0x10(%ebp)
  800b7d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b80:	50                   	push   %eax
  800b81:	68 0d 0b 80 00       	push   $0x800b0d
  800b86:	e8 80 fb ff ff       	call   80070b <vprintfmt>
  800b8b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b91:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b97:	c9                   	leave  
  800b98:	c3                   	ret    

00800b99 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
  800b9c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b9f:	8d 45 10             	lea    0x10(%ebp),%eax
  800ba2:	83 c0 04             	add    $0x4,%eax
  800ba5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ba8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bab:	ff 75 f4             	pushl  -0xc(%ebp)
  800bae:	50                   	push   %eax
  800baf:	ff 75 0c             	pushl  0xc(%ebp)
  800bb2:	ff 75 08             	pushl  0x8(%ebp)
  800bb5:	e8 89 ff ff ff       	call   800b43 <vsnprintf>
  800bba:	83 c4 10             	add    $0x10,%esp
  800bbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bc3:	c9                   	leave  
  800bc4:	c3                   	ret    

00800bc5 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bcb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd2:	eb 06                	jmp    800bda <strlen+0x15>
		n++;
  800bd4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd7:	ff 45 08             	incl   0x8(%ebp)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8a 00                	mov    (%eax),%al
  800bdf:	84 c0                	test   %al,%al
  800be1:	75 f1                	jne    800bd4 <strlen+0xf>
		n++;
	return n;
  800be3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf5:	eb 09                	jmp    800c00 <strnlen+0x18>
		n++;
  800bf7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bfa:	ff 45 08             	incl   0x8(%ebp)
  800bfd:	ff 4d 0c             	decl   0xc(%ebp)
  800c00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c04:	74 09                	je     800c0f <strnlen+0x27>
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	8a 00                	mov    (%eax),%al
  800c0b:	84 c0                	test   %al,%al
  800c0d:	75 e8                	jne    800bf7 <strnlen+0xf>
		n++;
	return n;
  800c0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c12:	c9                   	leave  
  800c13:	c3                   	ret    

00800c14 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c20:	90                   	nop
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	8d 50 01             	lea    0x1(%eax),%edx
  800c27:	89 55 08             	mov    %edx,0x8(%ebp)
  800c2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c30:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c33:	8a 12                	mov    (%edx),%dl
  800c35:	88 10                	mov    %dl,(%eax)
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	75 e4                	jne    800c21 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c55:	eb 1f                	jmp    800c76 <strncpy+0x34>
		*dst++ = *src;
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	8d 50 01             	lea    0x1(%eax),%edx
  800c5d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c63:	8a 12                	mov    (%edx),%dl
  800c65:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6a:	8a 00                	mov    (%eax),%al
  800c6c:	84 c0                	test   %al,%al
  800c6e:	74 03                	je     800c73 <strncpy+0x31>
			src++;
  800c70:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c73:	ff 45 fc             	incl   -0x4(%ebp)
  800c76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c79:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c7c:	72 d9                	jb     800c57 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c93:	74 30                	je     800cc5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c95:	eb 16                	jmp    800cad <strlcpy+0x2a>
			*dst++ = *src++;
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	8d 50 01             	lea    0x1(%eax),%edx
  800c9d:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ca6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ca9:	8a 12                	mov    (%edx),%dl
  800cab:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cad:	ff 4d 10             	decl   0x10(%ebp)
  800cb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb4:	74 09                	je     800cbf <strlcpy+0x3c>
  800cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb9:	8a 00                	mov    (%eax),%al
  800cbb:	84 c0                	test   %al,%al
  800cbd:	75 d8                	jne    800c97 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ccb:	29 c2                	sub    %eax,%edx
  800ccd:	89 d0                	mov    %edx,%eax
}
  800ccf:	c9                   	leave  
  800cd0:	c3                   	ret    

00800cd1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cd4:	eb 06                	jmp    800cdc <strcmp+0xb>
		p++, q++;
  800cd6:	ff 45 08             	incl   0x8(%ebp)
  800cd9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdf:	8a 00                	mov    (%eax),%al
  800ce1:	84 c0                	test   %al,%al
  800ce3:	74 0e                	je     800cf3 <strcmp+0x22>
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8a 10                	mov    (%eax),%dl
  800cea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ced:	8a 00                	mov    (%eax),%al
  800cef:	38 c2                	cmp    %al,%dl
  800cf1:	74 e3                	je     800cd6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	8a 00                	mov    (%eax),%al
  800cf8:	0f b6 d0             	movzbl %al,%edx
  800cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfe:	8a 00                	mov    (%eax),%al
  800d00:	0f b6 c0             	movzbl %al,%eax
  800d03:	29 c2                	sub    %eax,%edx
  800d05:	89 d0                	mov    %edx,%eax
}
  800d07:	5d                   	pop    %ebp
  800d08:	c3                   	ret    

00800d09 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d0c:	eb 09                	jmp    800d17 <strncmp+0xe>
		n--, p++, q++;
  800d0e:	ff 4d 10             	decl   0x10(%ebp)
  800d11:	ff 45 08             	incl   0x8(%ebp)
  800d14:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1b:	74 17                	je     800d34 <strncmp+0x2b>
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8a 00                	mov    (%eax),%al
  800d22:	84 c0                	test   %al,%al
  800d24:	74 0e                	je     800d34 <strncmp+0x2b>
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	8a 10                	mov    (%eax),%dl
  800d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	38 c2                	cmp    %al,%dl
  800d32:	74 da                	je     800d0e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d38:	75 07                	jne    800d41 <strncmp+0x38>
		return 0;
  800d3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3f:	eb 14                	jmp    800d55 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	8a 00                	mov    (%eax),%al
  800d46:	0f b6 d0             	movzbl %al,%edx
  800d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4c:	8a 00                	mov    (%eax),%al
  800d4e:	0f b6 c0             	movzbl %al,%eax
  800d51:	29 c2                	sub    %eax,%edx
  800d53:	89 d0                	mov    %edx,%eax
}
  800d55:	5d                   	pop    %ebp
  800d56:	c3                   	ret    

00800d57 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	83 ec 04             	sub    $0x4,%esp
  800d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d60:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d63:	eb 12                	jmp    800d77 <strchr+0x20>
		if (*s == c)
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8a 00                	mov    (%eax),%al
  800d6a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d6d:	75 05                	jne    800d74 <strchr+0x1d>
			return (char *) s;
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	eb 11                	jmp    800d85 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d74:	ff 45 08             	incl   0x8(%ebp)
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	84 c0                	test   %al,%al
  800d7e:	75 e5                	jne    800d65 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d85:	c9                   	leave  
  800d86:	c3                   	ret    

00800d87 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	83 ec 04             	sub    $0x4,%esp
  800d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d90:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d93:	eb 0d                	jmp    800da2 <strfind+0x1b>
		if (*s == c)
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9d:	74 0e                	je     800dad <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d9f:	ff 45 08             	incl   0x8(%ebp)
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	8a 00                	mov    (%eax),%al
  800da7:	84 c0                	test   %al,%al
  800da9:	75 ea                	jne    800d95 <strfind+0xe>
  800dab:	eb 01                	jmp    800dae <strfind+0x27>
		if (*s == c)
			break;
  800dad:	90                   	nop
	return (char *) s;
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db1:	c9                   	leave  
  800db2:	c3                   	ret    

00800db3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dc5:	eb 0e                	jmp    800dd5 <memset+0x22>
		*p++ = c;
  800dc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dca:	8d 50 01             	lea    0x1(%eax),%edx
  800dcd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dd5:	ff 4d f8             	decl   -0x8(%ebp)
  800dd8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ddc:	79 e9                	jns    800dc7 <memset+0x14>
		*p++ = c;

	return v;
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de1:	c9                   	leave  
  800de2:	c3                   	ret    

00800de3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800df5:	eb 16                	jmp    800e0d <memcpy+0x2a>
		*d++ = *s++;
  800df7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dfa:	8d 50 01             	lea    0x1(%eax),%edx
  800dfd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e00:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e03:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e06:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e09:	8a 12                	mov    (%edx),%dl
  800e0b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e10:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e13:	89 55 10             	mov    %edx,0x10(%ebp)
  800e16:	85 c0                	test   %eax,%eax
  800e18:	75 dd                	jne    800df7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e1d:	c9                   	leave  
  800e1e:	c3                   	ret    

00800e1f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e34:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e37:	73 50                	jae    800e89 <memmove+0x6a>
  800e39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3f:	01 d0                	add    %edx,%eax
  800e41:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e44:	76 43                	jbe    800e89 <memmove+0x6a>
		s += n;
  800e46:	8b 45 10             	mov    0x10(%ebp),%eax
  800e49:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e52:	eb 10                	jmp    800e64 <memmove+0x45>
			*--d = *--s;
  800e54:	ff 4d f8             	decl   -0x8(%ebp)
  800e57:	ff 4d fc             	decl   -0x4(%ebp)
  800e5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5d:	8a 10                	mov    (%eax),%dl
  800e5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e62:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e64:	8b 45 10             	mov    0x10(%ebp),%eax
  800e67:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6d:	85 c0                	test   %eax,%eax
  800e6f:	75 e3                	jne    800e54 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e71:	eb 23                	jmp    800e96 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e73:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e76:	8d 50 01             	lea    0x1(%eax),%edx
  800e79:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e7c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e7f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e82:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e85:	8a 12                	mov    (%edx),%dl
  800e87:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e89:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e8f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e92:	85 c0                	test   %eax,%eax
  800e94:	75 dd                	jne    800e73 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e99:	c9                   	leave  
  800e9a:	c3                   	ret    

00800e9b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaa:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ead:	eb 2a                	jmp    800ed9 <memcmp+0x3e>
		if (*s1 != *s2)
  800eaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb2:	8a 10                	mov    (%eax),%dl
  800eb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb7:	8a 00                	mov    (%eax),%al
  800eb9:	38 c2                	cmp    %al,%dl
  800ebb:	74 16                	je     800ed3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	0f b6 d0             	movzbl %al,%edx
  800ec5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec8:	8a 00                	mov    (%eax),%al
  800eca:	0f b6 c0             	movzbl %al,%eax
  800ecd:	29 c2                	sub    %eax,%edx
  800ecf:	89 d0                	mov    %edx,%eax
  800ed1:	eb 18                	jmp    800eeb <memcmp+0x50>
		s1++, s2++;
  800ed3:	ff 45 fc             	incl   -0x4(%ebp)
  800ed6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ed9:	8b 45 10             	mov    0x10(%ebp),%eax
  800edc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800edf:	89 55 10             	mov    %edx,0x10(%ebp)
  800ee2:	85 c0                	test   %eax,%eax
  800ee4:	75 c9                	jne    800eaf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ee6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eeb:	c9                   	leave  
  800eec:	c3                   	ret    

00800eed <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ef3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef9:	01 d0                	add    %edx,%eax
  800efb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800efe:	eb 15                	jmp    800f15 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	8a 00                	mov    (%eax),%al
  800f05:	0f b6 d0             	movzbl %al,%edx
  800f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0b:	0f b6 c0             	movzbl %al,%eax
  800f0e:	39 c2                	cmp    %eax,%edx
  800f10:	74 0d                	je     800f1f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f12:	ff 45 08             	incl   0x8(%ebp)
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f1b:	72 e3                	jb     800f00 <memfind+0x13>
  800f1d:	eb 01                	jmp    800f20 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f1f:	90                   	nop
	return (void *) s;
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f23:	c9                   	leave  
  800f24:	c3                   	ret    

00800f25 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f2b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f32:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f39:	eb 03                	jmp    800f3e <strtol+0x19>
		s++;
  800f3b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	8a 00                	mov    (%eax),%al
  800f43:	3c 20                	cmp    $0x20,%al
  800f45:	74 f4                	je     800f3b <strtol+0x16>
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	8a 00                	mov    (%eax),%al
  800f4c:	3c 09                	cmp    $0x9,%al
  800f4e:	74 eb                	je     800f3b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	3c 2b                	cmp    $0x2b,%al
  800f57:	75 05                	jne    800f5e <strtol+0x39>
		s++;
  800f59:	ff 45 08             	incl   0x8(%ebp)
  800f5c:	eb 13                	jmp    800f71 <strtol+0x4c>
	else if (*s == '-')
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	3c 2d                	cmp    $0x2d,%al
  800f65:	75 0a                	jne    800f71 <strtol+0x4c>
		s++, neg = 1;
  800f67:	ff 45 08             	incl   0x8(%ebp)
  800f6a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f75:	74 06                	je     800f7d <strtol+0x58>
  800f77:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f7b:	75 20                	jne    800f9d <strtol+0x78>
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	3c 30                	cmp    $0x30,%al
  800f84:	75 17                	jne    800f9d <strtol+0x78>
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	40                   	inc    %eax
  800f8a:	8a 00                	mov    (%eax),%al
  800f8c:	3c 78                	cmp    $0x78,%al
  800f8e:	75 0d                	jne    800f9d <strtol+0x78>
		s += 2, base = 16;
  800f90:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f94:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f9b:	eb 28                	jmp    800fc5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa1:	75 15                	jne    800fb8 <strtol+0x93>
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	3c 30                	cmp    $0x30,%al
  800faa:	75 0c                	jne    800fb8 <strtol+0x93>
		s++, base = 8;
  800fac:	ff 45 08             	incl   0x8(%ebp)
  800faf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fb6:	eb 0d                	jmp    800fc5 <strtol+0xa0>
	else if (base == 0)
  800fb8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fbc:	75 07                	jne    800fc5 <strtol+0xa0>
		base = 10;
  800fbe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	8a 00                	mov    (%eax),%al
  800fca:	3c 2f                	cmp    $0x2f,%al
  800fcc:	7e 19                	jle    800fe7 <strtol+0xc2>
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	3c 39                	cmp    $0x39,%al
  800fd5:	7f 10                	jg     800fe7 <strtol+0xc2>
			dig = *s - '0';
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	0f be c0             	movsbl %al,%eax
  800fdf:	83 e8 30             	sub    $0x30,%eax
  800fe2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe5:	eb 42                	jmp    801029 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	3c 60                	cmp    $0x60,%al
  800fee:	7e 19                	jle    801009 <strtol+0xe4>
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	8a 00                	mov    (%eax),%al
  800ff5:	3c 7a                	cmp    $0x7a,%al
  800ff7:	7f 10                	jg     801009 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	0f be c0             	movsbl %al,%eax
  801001:	83 e8 57             	sub    $0x57,%eax
  801004:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801007:	eb 20                	jmp    801029 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	8a 00                	mov    (%eax),%al
  80100e:	3c 40                	cmp    $0x40,%al
  801010:	7e 39                	jle    80104b <strtol+0x126>
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	8a 00                	mov    (%eax),%al
  801017:	3c 5a                	cmp    $0x5a,%al
  801019:	7f 30                	jg     80104b <strtol+0x126>
			dig = *s - 'A' + 10;
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	8a 00                	mov    (%eax),%al
  801020:	0f be c0             	movsbl %al,%eax
  801023:	83 e8 37             	sub    $0x37,%eax
  801026:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80102f:	7d 19                	jge    80104a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801031:	ff 45 08             	incl   0x8(%ebp)
  801034:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801037:	0f af 45 10          	imul   0x10(%ebp),%eax
  80103b:	89 c2                	mov    %eax,%edx
  80103d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801040:	01 d0                	add    %edx,%eax
  801042:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801045:	e9 7b ff ff ff       	jmp    800fc5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80104a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80104b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80104f:	74 08                	je     801059 <strtol+0x134>
		*endptr = (char *) s;
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	8b 55 08             	mov    0x8(%ebp),%edx
  801057:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801059:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80105d:	74 07                	je     801066 <strtol+0x141>
  80105f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801062:	f7 d8                	neg    %eax
  801064:	eb 03                	jmp    801069 <strtol+0x144>
  801066:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801069:	c9                   	leave  
  80106a:	c3                   	ret    

0080106b <ltostr>:

void
ltostr(long value, char *str)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801071:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801078:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80107f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801083:	79 13                	jns    801098 <ltostr+0x2d>
	{
		neg = 1;
  801085:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80108c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801092:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801095:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010a0:	99                   	cltd   
  8010a1:	f7 f9                	idiv   %ecx
  8010a3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a9:	8d 50 01             	lea    0x1(%eax),%edx
  8010ac:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010af:	89 c2                	mov    %eax,%edx
  8010b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b4:	01 d0                	add    %edx,%eax
  8010b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010b9:	83 c2 30             	add    $0x30,%edx
  8010bc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c6:	f7 e9                	imul   %ecx
  8010c8:	c1 fa 02             	sar    $0x2,%edx
  8010cb:	89 c8                	mov    %ecx,%eax
  8010cd:	c1 f8 1f             	sar    $0x1f,%eax
  8010d0:	29 c2                	sub    %eax,%edx
  8010d2:	89 d0                	mov    %edx,%eax
  8010d4:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010db:	75 bb                	jne    801098 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e7:	48                   	dec    %eax
  8010e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010ef:	74 3d                	je     80112e <ltostr+0xc3>
		start = 1 ;
  8010f1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010f8:	eb 34                	jmp    80112e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801100:	01 d0                	add    %edx,%eax
  801102:	8a 00                	mov    (%eax),%al
  801104:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801107:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110d:	01 c2                	add    %eax,%edx
  80110f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	01 c8                	add    %ecx,%eax
  801117:	8a 00                	mov    (%eax),%al
  801119:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80111b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80111e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801121:	01 c2                	add    %eax,%edx
  801123:	8a 45 eb             	mov    -0x15(%ebp),%al
  801126:	88 02                	mov    %al,(%edx)
		start++ ;
  801128:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80112b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80112e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801131:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801134:	7c c4                	jl     8010fa <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801136:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801139:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113c:	01 d0                	add    %edx,%eax
  80113e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801141:	90                   	nop
  801142:	c9                   	leave  
  801143:	c3                   	ret    

00801144 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801144:	55                   	push   %ebp
  801145:	89 e5                	mov    %esp,%ebp
  801147:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80114a:	ff 75 08             	pushl  0x8(%ebp)
  80114d:	e8 73 fa ff ff       	call   800bc5 <strlen>
  801152:	83 c4 04             	add    $0x4,%esp
  801155:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801158:	ff 75 0c             	pushl  0xc(%ebp)
  80115b:	e8 65 fa ff ff       	call   800bc5 <strlen>
  801160:	83 c4 04             	add    $0x4,%esp
  801163:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801166:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80116d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801174:	eb 17                	jmp    80118d <strcconcat+0x49>
		final[s] = str1[s] ;
  801176:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801179:	8b 45 10             	mov    0x10(%ebp),%eax
  80117c:	01 c2                	add    %eax,%edx
  80117e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	01 c8                	add    %ecx,%eax
  801186:	8a 00                	mov    (%eax),%al
  801188:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80118a:	ff 45 fc             	incl   -0x4(%ebp)
  80118d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801190:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801193:	7c e1                	jl     801176 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801195:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80119c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011a3:	eb 1f                	jmp    8011c4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a8:	8d 50 01             	lea    0x1(%eax),%edx
  8011ab:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011ae:	89 c2                	mov    %eax,%edx
  8011b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b3:	01 c2                	add    %eax,%edx
  8011b5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bb:	01 c8                	add    %ecx,%eax
  8011bd:	8a 00                	mov    (%eax),%al
  8011bf:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011c1:	ff 45 f8             	incl   -0x8(%ebp)
  8011c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ca:	7c d9                	jl     8011a5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d2:	01 d0                	add    %edx,%eax
  8011d4:	c6 00 00             	movb   $0x0,(%eax)
}
  8011d7:	90                   	nop
  8011d8:	c9                   	leave  
  8011d9:	c3                   	ret    

008011da <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e9:	8b 00                	mov    (%eax),%eax
  8011eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f5:	01 d0                	add    %edx,%eax
  8011f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011fd:	eb 0c                	jmp    80120b <strsplit+0x31>
			*string++ = 0;
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8d 50 01             	lea    0x1(%eax),%edx
  801205:	89 55 08             	mov    %edx,0x8(%ebp)
  801208:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8a 00                	mov    (%eax),%al
  801210:	84 c0                	test   %al,%al
  801212:	74 18                	je     80122c <strsplit+0x52>
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	8a 00                	mov    (%eax),%al
  801219:	0f be c0             	movsbl %al,%eax
  80121c:	50                   	push   %eax
  80121d:	ff 75 0c             	pushl  0xc(%ebp)
  801220:	e8 32 fb ff ff       	call   800d57 <strchr>
  801225:	83 c4 08             	add    $0x8,%esp
  801228:	85 c0                	test   %eax,%eax
  80122a:	75 d3                	jne    8011ff <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
  80122f:	8a 00                	mov    (%eax),%al
  801231:	84 c0                	test   %al,%al
  801233:	74 5a                	je     80128f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801235:	8b 45 14             	mov    0x14(%ebp),%eax
  801238:	8b 00                	mov    (%eax),%eax
  80123a:	83 f8 0f             	cmp    $0xf,%eax
  80123d:	75 07                	jne    801246 <strsplit+0x6c>
		{
			return 0;
  80123f:	b8 00 00 00 00       	mov    $0x0,%eax
  801244:	eb 66                	jmp    8012ac <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801246:	8b 45 14             	mov    0x14(%ebp),%eax
  801249:	8b 00                	mov    (%eax),%eax
  80124b:	8d 48 01             	lea    0x1(%eax),%ecx
  80124e:	8b 55 14             	mov    0x14(%ebp),%edx
  801251:	89 0a                	mov    %ecx,(%edx)
  801253:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80125a:	8b 45 10             	mov    0x10(%ebp),%eax
  80125d:	01 c2                	add    %eax,%edx
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801264:	eb 03                	jmp    801269 <strsplit+0x8f>
			string++;
  801266:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	8a 00                	mov    (%eax),%al
  80126e:	84 c0                	test   %al,%al
  801270:	74 8b                	je     8011fd <strsplit+0x23>
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	0f be c0             	movsbl %al,%eax
  80127a:	50                   	push   %eax
  80127b:	ff 75 0c             	pushl  0xc(%ebp)
  80127e:	e8 d4 fa ff ff       	call   800d57 <strchr>
  801283:	83 c4 08             	add    $0x8,%esp
  801286:	85 c0                	test   %eax,%eax
  801288:	74 dc                	je     801266 <strsplit+0x8c>
			string++;
	}
  80128a:	e9 6e ff ff ff       	jmp    8011fd <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80128f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801290:	8b 45 14             	mov    0x14(%ebp),%eax
  801293:	8b 00                	mov    (%eax),%eax
  801295:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	01 d0                	add    %edx,%eax
  8012a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012a7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    

008012ae <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8012b4:	83 ec 04             	sub    $0x4,%esp
  8012b7:	68 08 23 80 00       	push   $0x802308
  8012bc:	68 3f 01 00 00       	push   $0x13f
  8012c1:	68 2a 23 80 00       	push   $0x80232a
  8012c6:	e8 a9 ef ff ff       	call   800274 <_panic>

008012cb <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8012cb:	55                   	push   %ebp
  8012cc:	89 e5                	mov    %esp,%ebp
  8012ce:	57                   	push   %edi
  8012cf:	56                   	push   %esi
  8012d0:	53                   	push   %ebx
  8012d1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012e0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012e3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012e6:	cd 30                	int    $0x30
  8012e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  8012eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012ee:	83 c4 10             	add    $0x10,%esp
  8012f1:	5b                   	pop    %ebx
  8012f2:	5e                   	pop    %esi
  8012f3:	5f                   	pop    %edi
  8012f4:	5d                   	pop    %ebp
  8012f5:	c3                   	ret    

008012f6 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8012f6:	55                   	push   %ebp
  8012f7:	89 e5                	mov    %esp,%ebp
  8012f9:	83 ec 04             	sub    $0x4,%esp
  8012fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801302:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	6a 00                	push   $0x0
  80130b:	6a 00                	push   $0x0
  80130d:	52                   	push   %edx
  80130e:	ff 75 0c             	pushl  0xc(%ebp)
  801311:	50                   	push   %eax
  801312:	6a 00                	push   $0x0
  801314:	e8 b2 ff ff ff       	call   8012cb <syscall>
  801319:	83 c4 18             	add    $0x18,%esp
}
  80131c:	90                   	nop
  80131d:	c9                   	leave  
  80131e:	c3                   	ret    

0080131f <sys_cgetc>:

int sys_cgetc(void) {
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801322:	6a 00                	push   $0x0
  801324:	6a 00                	push   $0x0
  801326:	6a 00                	push   $0x0
  801328:	6a 00                	push   $0x0
  80132a:	6a 00                	push   $0x0
  80132c:	6a 02                	push   $0x2
  80132e:	e8 98 ff ff ff       	call   8012cb <syscall>
  801333:	83 c4 18             	add    $0x18,%esp
}
  801336:	c9                   	leave  
  801337:	c3                   	ret    

00801338 <sys_lock_cons>:

void sys_lock_cons(void) {
  801338:	55                   	push   %ebp
  801339:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	6a 00                	push   $0x0
  801345:	6a 03                	push   $0x3
  801347:	e8 7f ff ff ff       	call   8012cb <syscall>
  80134c:	83 c4 18             	add    $0x18,%esp
}
  80134f:	90                   	nop
  801350:	c9                   	leave  
  801351:	c3                   	ret    

00801352 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801352:	55                   	push   %ebp
  801353:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	6a 00                	push   $0x0
  80135b:	6a 00                	push   $0x0
  80135d:	6a 00                	push   $0x0
  80135f:	6a 04                	push   $0x4
  801361:	e8 65 ff ff ff       	call   8012cb <syscall>
  801366:	83 c4 18             	add    $0x18,%esp
}
  801369:	90                   	nop
  80136a:	c9                   	leave  
  80136b:	c3                   	ret    

0080136c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  80136f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	6a 00                	push   $0x0
  801377:	6a 00                	push   $0x0
  801379:	6a 00                	push   $0x0
  80137b:	52                   	push   %edx
  80137c:	50                   	push   %eax
  80137d:	6a 08                	push   $0x8
  80137f:	e8 47 ff ff ff       	call   8012cb <syscall>
  801384:	83 c4 18             	add    $0x18,%esp
}
  801387:	c9                   	leave  
  801388:	c3                   	ret    

00801389 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	56                   	push   %esi
  80138d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  80138e:	8b 75 18             	mov    0x18(%ebp),%esi
  801391:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801394:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801397:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	56                   	push   %esi
  80139e:	53                   	push   %ebx
  80139f:	51                   	push   %ecx
  8013a0:	52                   	push   %edx
  8013a1:	50                   	push   %eax
  8013a2:	6a 09                	push   $0x9
  8013a4:	e8 22 ff ff ff       	call   8012cb <syscall>
  8013a9:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  8013ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013af:	5b                   	pop    %ebx
  8013b0:	5e                   	pop    %esi
  8013b1:	5d                   	pop    %ebp
  8013b2:	c3                   	ret    

008013b3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  8013b3:	55                   	push   %ebp
  8013b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	6a 00                	push   $0x0
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 00                	push   $0x0
  8013c2:	52                   	push   %edx
  8013c3:	50                   	push   %eax
  8013c4:	6a 0a                	push   $0xa
  8013c6:	e8 00 ff ff ff       	call   8012cb <syscall>
  8013cb:	83 c4 18             	add    $0x18,%esp
}
  8013ce:	c9                   	leave  
  8013cf:	c3                   	ret    

008013d0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	ff 75 0c             	pushl  0xc(%ebp)
  8013dc:	ff 75 08             	pushl  0x8(%ebp)
  8013df:	6a 0b                	push   $0xb
  8013e1:	e8 e5 fe ff ff       	call   8012cb <syscall>
  8013e6:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 0c                	push   $0xc
  8013fa:	e8 cc fe ff ff       	call   8012cb <syscall>
  8013ff:	83 c4 18             	add    $0x18,%esp
}
  801402:	c9                   	leave  
  801403:	c3                   	ret    

00801404 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	6a 00                	push   $0x0
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	6a 0d                	push   $0xd
  801413:	e8 b3 fe ff ff       	call   8012cb <syscall>
  801418:	83 c4 18             	add    $0x18,%esp
}
  80141b:	c9                   	leave  
  80141c:	c3                   	ret    

0080141d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 0e                	push   $0xe
  80142c:	e8 9a fe ff ff       	call   8012cb <syscall>
  801431:	83 c4 18             	add    $0x18,%esp
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 0f                	push   $0xf
  801445:	e8 81 fe ff ff       	call   8012cb <syscall>
  80144a:	83 c4 18             	add    $0x18,%esp
}
  80144d:	c9                   	leave  
  80144e:	c3                   	ret    

0080144f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	ff 75 08             	pushl  0x8(%ebp)
  80145d:	6a 10                	push   $0x10
  80145f:	e8 67 fe ff ff       	call   8012cb <syscall>
  801464:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <sys_scarce_memory>:

void sys_scarce_memory() {
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	6a 11                	push   $0x11
  801478:	e8 4e fe ff ff       	call   8012cb <syscall>
  80147d:	83 c4 18             	add    $0x18,%esp
}
  801480:	90                   	nop
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <sys_cputc>:

void sys_cputc(const char c) {
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 04             	sub    $0x4,%esp
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80148f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801493:	6a 00                	push   $0x0
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	50                   	push   %eax
  80149c:	6a 01                	push   $0x1
  80149e:	e8 28 fe ff ff       	call   8012cb <syscall>
  8014a3:	83 c4 18             	add    $0x18,%esp
}
  8014a6:	90                   	nop
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    

008014a9 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  8014ac:	6a 00                	push   $0x0
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 14                	push   $0x14
  8014b8:	e8 0e fe ff ff       	call   8012cb <syscall>
  8014bd:	83 c4 18             	add    $0x18,%esp
}
  8014c0:	90                   	nop
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

008014c3 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	83 ec 04             	sub    $0x4,%esp
  8014c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  8014cf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014d2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	6a 00                	push   $0x0
  8014db:	51                   	push   %ecx
  8014dc:	52                   	push   %edx
  8014dd:	ff 75 0c             	pushl  0xc(%ebp)
  8014e0:	50                   	push   %eax
  8014e1:	6a 15                	push   $0x15
  8014e3:	e8 e3 fd ff ff       	call   8012cb <syscall>
  8014e8:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  8014eb:	c9                   	leave  
  8014ec:	c3                   	ret    

008014ed <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  8014f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	52                   	push   %edx
  8014fd:	50                   	push   %eax
  8014fe:	6a 16                	push   $0x16
  801500:	e8 c6 fd ff ff       	call   8012cb <syscall>
  801505:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801508:	c9                   	leave  
  801509:	c3                   	ret    

0080150a <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  80150d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801510:	8b 55 0c             	mov    0xc(%ebp),%edx
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	51                   	push   %ecx
  80151b:	52                   	push   %edx
  80151c:	50                   	push   %eax
  80151d:	6a 17                	push   $0x17
  80151f:	e8 a7 fd ff ff       	call   8012cb <syscall>
  801524:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801527:	c9                   	leave  
  801528:	c3                   	ret    

00801529 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  80152c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	6a 00                	push   $0x0
  801534:	6a 00                	push   $0x0
  801536:	6a 00                	push   $0x0
  801538:	52                   	push   %edx
  801539:	50                   	push   %eax
  80153a:	6a 18                	push   $0x18
  80153c:	e8 8a fd ff ff       	call   8012cb <syscall>
  801541:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801544:	c9                   	leave  
  801545:	c3                   	ret    

00801546 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801549:	8b 45 08             	mov    0x8(%ebp),%eax
  80154c:	6a 00                	push   $0x0
  80154e:	ff 75 14             	pushl  0x14(%ebp)
  801551:	ff 75 10             	pushl  0x10(%ebp)
  801554:	ff 75 0c             	pushl  0xc(%ebp)
  801557:	50                   	push   %eax
  801558:	6a 19                	push   $0x19
  80155a:	e8 6c fd ff ff       	call   8012cb <syscall>
  80155f:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <sys_run_env>:

void sys_run_env(int32 envId) {
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	50                   	push   %eax
  801573:	6a 1a                	push   $0x1a
  801575:	e8 51 fd ff ff       	call   8012cb <syscall>
  80157a:	83 c4 18             	add    $0x18,%esp
}
  80157d:	90                   	nop
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    

00801580 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	50                   	push   %eax
  80158f:	6a 1b                	push   $0x1b
  801591:	e8 35 fd ff ff       	call   8012cb <syscall>
  801596:	83 c4 18             	add    $0x18,%esp
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <sys_getenvid>:

int32 sys_getenvid(void) {
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 05                	push   $0x5
  8015aa:	e8 1c fd ff ff       	call   8012cb <syscall>
  8015af:	83 c4 18             	add    $0x18,%esp
}
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 06                	push   $0x6
  8015c3:	e8 03 fd ff ff       	call   8012cb <syscall>
  8015c8:	83 c4 18             	add    $0x18,%esp
}
  8015cb:	c9                   	leave  
  8015cc:	c3                   	ret    

008015cd <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 07                	push   $0x7
  8015dc:	e8 ea fc ff ff       	call   8012cb <syscall>
  8015e1:	83 c4 18             	add    $0x18,%esp
}
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <sys_exit_env>:

void sys_exit_env(void) {
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 1c                	push   $0x1c
  8015f5:	e8 d1 fc ff ff       	call   8012cb <syscall>
  8015fa:	83 c4 18             	add    $0x18,%esp
}
  8015fd:	90                   	nop
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801606:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801609:	8d 50 04             	lea    0x4(%eax),%edx
  80160c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	52                   	push   %edx
  801616:	50                   	push   %eax
  801617:	6a 1d                	push   $0x1d
  801619:	e8 ad fc ff ff       	call   8012cb <syscall>
  80161e:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801621:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801624:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801627:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80162a:	89 01                	mov    %eax,(%ecx)
  80162c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	c9                   	leave  
  801633:	c2 04 00             	ret    $0x4

00801636 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	ff 75 10             	pushl  0x10(%ebp)
  801640:	ff 75 0c             	pushl  0xc(%ebp)
  801643:	ff 75 08             	pushl  0x8(%ebp)
  801646:	6a 13                	push   $0x13
  801648:	e8 7e fc ff ff       	call   8012cb <syscall>
  80164d:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801650:	90                   	nop
}
  801651:	c9                   	leave  
  801652:	c3                   	ret    

00801653 <sys_rcr2>:
uint32 sys_rcr2() {
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 1e                	push   $0x1e
  801662:	e8 64 fc ff ff       	call   8012cb <syscall>
  801667:	83 c4 18             	add    $0x18,%esp
}
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    

0080166c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	83 ec 04             	sub    $0x4,%esp
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801678:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	50                   	push   %eax
  801685:	6a 1f                	push   $0x1f
  801687:	e8 3f fc ff ff       	call   8012cb <syscall>
  80168c:	83 c4 18             	add    $0x18,%esp
	return;
  80168f:	90                   	nop
}
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <rsttst>:
void rsttst() {
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 21                	push   $0x21
  8016a1:	e8 25 fc ff ff       	call   8012cb <syscall>
  8016a6:	83 c4 18             	add    $0x18,%esp
	return;
  8016a9:	90                   	nop
}
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	83 ec 04             	sub    $0x4,%esp
  8016b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8016b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016b8:	8b 55 18             	mov    0x18(%ebp),%edx
  8016bb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016bf:	52                   	push   %edx
  8016c0:	50                   	push   %eax
  8016c1:	ff 75 10             	pushl  0x10(%ebp)
  8016c4:	ff 75 0c             	pushl  0xc(%ebp)
  8016c7:	ff 75 08             	pushl  0x8(%ebp)
  8016ca:	6a 20                	push   $0x20
  8016cc:	e8 fa fb ff ff       	call   8012cb <syscall>
  8016d1:	83 c4 18             	add    $0x18,%esp
	return;
  8016d4:	90                   	nop
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <chktst>:
void chktst(uint32 n) {
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	ff 75 08             	pushl  0x8(%ebp)
  8016e5:	6a 22                	push   $0x22
  8016e7:	e8 df fb ff ff       	call   8012cb <syscall>
  8016ec:	83 c4 18             	add    $0x18,%esp
	return;
  8016ef:	90                   	nop
}
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <inctst>:

void inctst() {
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 23                	push   $0x23
  801701:	e8 c5 fb ff ff       	call   8012cb <syscall>
  801706:	83 c4 18             	add    $0x18,%esp
	return;
  801709:	90                   	nop
}
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

0080170c <gettst>:
uint32 gettst() {
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 24                	push   $0x24
  80171b:	e8 ab fb ff ff       	call   8012cb <syscall>
  801720:	83 c4 18             	add    $0x18,%esp
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 25                	push   $0x25
  801737:	e8 8f fb ff ff       	call   8012cb <syscall>
  80173c:	83 c4 18             	add    $0x18,%esp
  80173f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801742:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801746:	75 07                	jne    80174f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801748:	b8 01 00 00 00       	mov    $0x1,%eax
  80174d:	eb 05                	jmp    801754 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80174f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 25                	push   $0x25
  801768:	e8 5e fb ff ff       	call   8012cb <syscall>
  80176d:	83 c4 18             	add    $0x18,%esp
  801770:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801773:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801777:	75 07                	jne    801780 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801779:	b8 01 00 00 00       	mov    $0x1,%eax
  80177e:	eb 05                	jmp    801785 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801780:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
  80178a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 25                	push   $0x25
  801799:	e8 2d fb ff ff       	call   8012cb <syscall>
  80179e:	83 c4 18             	add    $0x18,%esp
  8017a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017a4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017a8:	75 07                	jne    8017b1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8017af:	eb 05                	jmp    8017b6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
  8017bb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 25                	push   $0x25
  8017ca:	e8 fc fa ff ff       	call   8012cb <syscall>
  8017cf:	83 c4 18             	add    $0x18,%esp
  8017d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017d5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017d9:	75 07                	jne    8017e2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017db:	b8 01 00 00 00       	mov    $0x1,%eax
  8017e0:	eb 05                	jmp    8017e7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	ff 75 08             	pushl  0x8(%ebp)
  8017f7:	6a 26                	push   $0x26
  8017f9:	e8 cd fa ff ff       	call   8012cb <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
	return;
  801801:	90                   	nop
}
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801808:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80180b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80180e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
  801814:	6a 00                	push   $0x0
  801816:	53                   	push   %ebx
  801817:	51                   	push   %ecx
  801818:	52                   	push   %edx
  801819:	50                   	push   %eax
  80181a:	6a 27                	push   $0x27
  80181c:	e8 aa fa ff ff       	call   8012cb <syscall>
  801821:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801824:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  80182c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	52                   	push   %edx
  801839:	50                   	push   %eax
  80183a:	6a 28                	push   $0x28
  80183c:	e8 8a fa ff ff       	call   8012cb <syscall>
  801841:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801849:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80184c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184f:	8b 45 08             	mov    0x8(%ebp),%eax
  801852:	6a 00                	push   $0x0
  801854:	51                   	push   %ecx
  801855:	ff 75 10             	pushl  0x10(%ebp)
  801858:	52                   	push   %edx
  801859:	50                   	push   %eax
  80185a:	6a 29                	push   $0x29
  80185c:	e8 6a fa ff ff       	call   8012cb <syscall>
  801861:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	ff 75 10             	pushl  0x10(%ebp)
  801870:	ff 75 0c             	pushl  0xc(%ebp)
  801873:	ff 75 08             	pushl  0x8(%ebp)
  801876:	6a 12                	push   $0x12
  801878:	e8 4e fa ff ff       	call   8012cb <syscall>
  80187d:	83 c4 18             	add    $0x18,%esp
	return;
  801880:	90                   	nop
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801886:	8b 55 0c             	mov    0xc(%ebp),%edx
  801889:	8b 45 08             	mov    0x8(%ebp),%eax
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	52                   	push   %edx
  801893:	50                   	push   %eax
  801894:	6a 2a                	push   $0x2a
  801896:	e8 30 fa ff ff       	call   8012cb <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
	return;
  80189e:	90                   	nop
}
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8018a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	50                   	push   %eax
  8018b0:	6a 2b                	push   $0x2b
  8018b2:	e8 14 fa ff ff       	call   8012cb <syscall>
  8018b7:	83 c4 18             	add    $0x18,%esp
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	ff 75 0c             	pushl  0xc(%ebp)
  8018c8:	ff 75 08             	pushl  0x8(%ebp)
  8018cb:	6a 2c                	push   $0x2c
  8018cd:	e8 f9 f9 ff ff       	call   8012cb <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
	return;
  8018d5:	90                   	nop
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	ff 75 0c             	pushl  0xc(%ebp)
  8018e4:	ff 75 08             	pushl  0x8(%ebp)
  8018e7:	6a 2d                	push   $0x2d
  8018e9:	e8 dd f9 ff ff       	call   8012cb <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
	return;
  8018f1:	90                   	nop
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	50                   	push   %eax
  801903:	6a 2f                	push   $0x2f
  801905:	e8 c1 f9 ff ff       	call   8012cb <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
	return;
  80190d:	90                   	nop
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  801913:	8b 55 0c             	mov    0xc(%ebp),%edx
  801916:	8b 45 08             	mov    0x8(%ebp),%eax
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	52                   	push   %edx
  801920:	50                   	push   %eax
  801921:	6a 30                	push   $0x30
  801923:	e8 a3 f9 ff ff       	call   8012cb <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
	return;
  80192b:	90                   	nop
}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  801931:	8b 45 08             	mov    0x8(%ebp),%eax
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	50                   	push   %eax
  80193d:	6a 31                	push   $0x31
  80193f:	e8 87 f9 ff ff       	call   8012cb <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
	return;
  801947:	90                   	nop
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80194d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	52                   	push   %edx
  80195a:	50                   	push   %eax
  80195b:	6a 2e                	push   $0x2e
  80195d:	e8 69 f9 ff ff       	call   8012cb <syscall>
  801962:	83 c4 18             	add    $0x18,%esp
    return;
  801965:	90                   	nop
}
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <__udivdi3>:
  801968:	55                   	push   %ebp
  801969:	57                   	push   %edi
  80196a:	56                   	push   %esi
  80196b:	53                   	push   %ebx
  80196c:	83 ec 1c             	sub    $0x1c,%esp
  80196f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801973:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801977:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80197b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80197f:	89 ca                	mov    %ecx,%edx
  801981:	89 f8                	mov    %edi,%eax
  801983:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801987:	85 f6                	test   %esi,%esi
  801989:	75 2d                	jne    8019b8 <__udivdi3+0x50>
  80198b:	39 cf                	cmp    %ecx,%edi
  80198d:	77 65                	ja     8019f4 <__udivdi3+0x8c>
  80198f:	89 fd                	mov    %edi,%ebp
  801991:	85 ff                	test   %edi,%edi
  801993:	75 0b                	jne    8019a0 <__udivdi3+0x38>
  801995:	b8 01 00 00 00       	mov    $0x1,%eax
  80199a:	31 d2                	xor    %edx,%edx
  80199c:	f7 f7                	div    %edi
  80199e:	89 c5                	mov    %eax,%ebp
  8019a0:	31 d2                	xor    %edx,%edx
  8019a2:	89 c8                	mov    %ecx,%eax
  8019a4:	f7 f5                	div    %ebp
  8019a6:	89 c1                	mov    %eax,%ecx
  8019a8:	89 d8                	mov    %ebx,%eax
  8019aa:	f7 f5                	div    %ebp
  8019ac:	89 cf                	mov    %ecx,%edi
  8019ae:	89 fa                	mov    %edi,%edx
  8019b0:	83 c4 1c             	add    $0x1c,%esp
  8019b3:	5b                   	pop    %ebx
  8019b4:	5e                   	pop    %esi
  8019b5:	5f                   	pop    %edi
  8019b6:	5d                   	pop    %ebp
  8019b7:	c3                   	ret    
  8019b8:	39 ce                	cmp    %ecx,%esi
  8019ba:	77 28                	ja     8019e4 <__udivdi3+0x7c>
  8019bc:	0f bd fe             	bsr    %esi,%edi
  8019bf:	83 f7 1f             	xor    $0x1f,%edi
  8019c2:	75 40                	jne    801a04 <__udivdi3+0x9c>
  8019c4:	39 ce                	cmp    %ecx,%esi
  8019c6:	72 0a                	jb     8019d2 <__udivdi3+0x6a>
  8019c8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019cc:	0f 87 9e 00 00 00    	ja     801a70 <__udivdi3+0x108>
  8019d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8019d7:	89 fa                	mov    %edi,%edx
  8019d9:	83 c4 1c             	add    $0x1c,%esp
  8019dc:	5b                   	pop    %ebx
  8019dd:	5e                   	pop    %esi
  8019de:	5f                   	pop    %edi
  8019df:	5d                   	pop    %ebp
  8019e0:	c3                   	ret    
  8019e1:	8d 76 00             	lea    0x0(%esi),%esi
  8019e4:	31 ff                	xor    %edi,%edi
  8019e6:	31 c0                	xor    %eax,%eax
  8019e8:	89 fa                	mov    %edi,%edx
  8019ea:	83 c4 1c             	add    $0x1c,%esp
  8019ed:	5b                   	pop    %ebx
  8019ee:	5e                   	pop    %esi
  8019ef:	5f                   	pop    %edi
  8019f0:	5d                   	pop    %ebp
  8019f1:	c3                   	ret    
  8019f2:	66 90                	xchg   %ax,%ax
  8019f4:	89 d8                	mov    %ebx,%eax
  8019f6:	f7 f7                	div    %edi
  8019f8:	31 ff                	xor    %edi,%edi
  8019fa:	89 fa                	mov    %edi,%edx
  8019fc:	83 c4 1c             	add    $0x1c,%esp
  8019ff:	5b                   	pop    %ebx
  801a00:	5e                   	pop    %esi
  801a01:	5f                   	pop    %edi
  801a02:	5d                   	pop    %ebp
  801a03:	c3                   	ret    
  801a04:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a09:	89 eb                	mov    %ebp,%ebx
  801a0b:	29 fb                	sub    %edi,%ebx
  801a0d:	89 f9                	mov    %edi,%ecx
  801a0f:	d3 e6                	shl    %cl,%esi
  801a11:	89 c5                	mov    %eax,%ebp
  801a13:	88 d9                	mov    %bl,%cl
  801a15:	d3 ed                	shr    %cl,%ebp
  801a17:	89 e9                	mov    %ebp,%ecx
  801a19:	09 f1                	or     %esi,%ecx
  801a1b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a1f:	89 f9                	mov    %edi,%ecx
  801a21:	d3 e0                	shl    %cl,%eax
  801a23:	89 c5                	mov    %eax,%ebp
  801a25:	89 d6                	mov    %edx,%esi
  801a27:	88 d9                	mov    %bl,%cl
  801a29:	d3 ee                	shr    %cl,%esi
  801a2b:	89 f9                	mov    %edi,%ecx
  801a2d:	d3 e2                	shl    %cl,%edx
  801a2f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a33:	88 d9                	mov    %bl,%cl
  801a35:	d3 e8                	shr    %cl,%eax
  801a37:	09 c2                	or     %eax,%edx
  801a39:	89 d0                	mov    %edx,%eax
  801a3b:	89 f2                	mov    %esi,%edx
  801a3d:	f7 74 24 0c          	divl   0xc(%esp)
  801a41:	89 d6                	mov    %edx,%esi
  801a43:	89 c3                	mov    %eax,%ebx
  801a45:	f7 e5                	mul    %ebp
  801a47:	39 d6                	cmp    %edx,%esi
  801a49:	72 19                	jb     801a64 <__udivdi3+0xfc>
  801a4b:	74 0b                	je     801a58 <__udivdi3+0xf0>
  801a4d:	89 d8                	mov    %ebx,%eax
  801a4f:	31 ff                	xor    %edi,%edi
  801a51:	e9 58 ff ff ff       	jmp    8019ae <__udivdi3+0x46>
  801a56:	66 90                	xchg   %ax,%ax
  801a58:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a5c:	89 f9                	mov    %edi,%ecx
  801a5e:	d3 e2                	shl    %cl,%edx
  801a60:	39 c2                	cmp    %eax,%edx
  801a62:	73 e9                	jae    801a4d <__udivdi3+0xe5>
  801a64:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a67:	31 ff                	xor    %edi,%edi
  801a69:	e9 40 ff ff ff       	jmp    8019ae <__udivdi3+0x46>
  801a6e:	66 90                	xchg   %ax,%ax
  801a70:	31 c0                	xor    %eax,%eax
  801a72:	e9 37 ff ff ff       	jmp    8019ae <__udivdi3+0x46>
  801a77:	90                   	nop

00801a78 <__umoddi3>:
  801a78:	55                   	push   %ebp
  801a79:	57                   	push   %edi
  801a7a:	56                   	push   %esi
  801a7b:	53                   	push   %ebx
  801a7c:	83 ec 1c             	sub    $0x1c,%esp
  801a7f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a83:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a93:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a97:	89 f3                	mov    %esi,%ebx
  801a99:	89 fa                	mov    %edi,%edx
  801a9b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a9f:	89 34 24             	mov    %esi,(%esp)
  801aa2:	85 c0                	test   %eax,%eax
  801aa4:	75 1a                	jne    801ac0 <__umoddi3+0x48>
  801aa6:	39 f7                	cmp    %esi,%edi
  801aa8:	0f 86 a2 00 00 00    	jbe    801b50 <__umoddi3+0xd8>
  801aae:	89 c8                	mov    %ecx,%eax
  801ab0:	89 f2                	mov    %esi,%edx
  801ab2:	f7 f7                	div    %edi
  801ab4:	89 d0                	mov    %edx,%eax
  801ab6:	31 d2                	xor    %edx,%edx
  801ab8:	83 c4 1c             	add    $0x1c,%esp
  801abb:	5b                   	pop    %ebx
  801abc:	5e                   	pop    %esi
  801abd:	5f                   	pop    %edi
  801abe:	5d                   	pop    %ebp
  801abf:	c3                   	ret    
  801ac0:	39 f0                	cmp    %esi,%eax
  801ac2:	0f 87 ac 00 00 00    	ja     801b74 <__umoddi3+0xfc>
  801ac8:	0f bd e8             	bsr    %eax,%ebp
  801acb:	83 f5 1f             	xor    $0x1f,%ebp
  801ace:	0f 84 ac 00 00 00    	je     801b80 <__umoddi3+0x108>
  801ad4:	bf 20 00 00 00       	mov    $0x20,%edi
  801ad9:	29 ef                	sub    %ebp,%edi
  801adb:	89 fe                	mov    %edi,%esi
  801add:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ae1:	89 e9                	mov    %ebp,%ecx
  801ae3:	d3 e0                	shl    %cl,%eax
  801ae5:	89 d7                	mov    %edx,%edi
  801ae7:	89 f1                	mov    %esi,%ecx
  801ae9:	d3 ef                	shr    %cl,%edi
  801aeb:	09 c7                	or     %eax,%edi
  801aed:	89 e9                	mov    %ebp,%ecx
  801aef:	d3 e2                	shl    %cl,%edx
  801af1:	89 14 24             	mov    %edx,(%esp)
  801af4:	89 d8                	mov    %ebx,%eax
  801af6:	d3 e0                	shl    %cl,%eax
  801af8:	89 c2                	mov    %eax,%edx
  801afa:	8b 44 24 08          	mov    0x8(%esp),%eax
  801afe:	d3 e0                	shl    %cl,%eax
  801b00:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b04:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b08:	89 f1                	mov    %esi,%ecx
  801b0a:	d3 e8                	shr    %cl,%eax
  801b0c:	09 d0                	or     %edx,%eax
  801b0e:	d3 eb                	shr    %cl,%ebx
  801b10:	89 da                	mov    %ebx,%edx
  801b12:	f7 f7                	div    %edi
  801b14:	89 d3                	mov    %edx,%ebx
  801b16:	f7 24 24             	mull   (%esp)
  801b19:	89 c6                	mov    %eax,%esi
  801b1b:	89 d1                	mov    %edx,%ecx
  801b1d:	39 d3                	cmp    %edx,%ebx
  801b1f:	0f 82 87 00 00 00    	jb     801bac <__umoddi3+0x134>
  801b25:	0f 84 91 00 00 00    	je     801bbc <__umoddi3+0x144>
  801b2b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b2f:	29 f2                	sub    %esi,%edx
  801b31:	19 cb                	sbb    %ecx,%ebx
  801b33:	89 d8                	mov    %ebx,%eax
  801b35:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b39:	d3 e0                	shl    %cl,%eax
  801b3b:	89 e9                	mov    %ebp,%ecx
  801b3d:	d3 ea                	shr    %cl,%edx
  801b3f:	09 d0                	or     %edx,%eax
  801b41:	89 e9                	mov    %ebp,%ecx
  801b43:	d3 eb                	shr    %cl,%ebx
  801b45:	89 da                	mov    %ebx,%edx
  801b47:	83 c4 1c             	add    $0x1c,%esp
  801b4a:	5b                   	pop    %ebx
  801b4b:	5e                   	pop    %esi
  801b4c:	5f                   	pop    %edi
  801b4d:	5d                   	pop    %ebp
  801b4e:	c3                   	ret    
  801b4f:	90                   	nop
  801b50:	89 fd                	mov    %edi,%ebp
  801b52:	85 ff                	test   %edi,%edi
  801b54:	75 0b                	jne    801b61 <__umoddi3+0xe9>
  801b56:	b8 01 00 00 00       	mov    $0x1,%eax
  801b5b:	31 d2                	xor    %edx,%edx
  801b5d:	f7 f7                	div    %edi
  801b5f:	89 c5                	mov    %eax,%ebp
  801b61:	89 f0                	mov    %esi,%eax
  801b63:	31 d2                	xor    %edx,%edx
  801b65:	f7 f5                	div    %ebp
  801b67:	89 c8                	mov    %ecx,%eax
  801b69:	f7 f5                	div    %ebp
  801b6b:	89 d0                	mov    %edx,%eax
  801b6d:	e9 44 ff ff ff       	jmp    801ab6 <__umoddi3+0x3e>
  801b72:	66 90                	xchg   %ax,%ax
  801b74:	89 c8                	mov    %ecx,%eax
  801b76:	89 f2                	mov    %esi,%edx
  801b78:	83 c4 1c             	add    $0x1c,%esp
  801b7b:	5b                   	pop    %ebx
  801b7c:	5e                   	pop    %esi
  801b7d:	5f                   	pop    %edi
  801b7e:	5d                   	pop    %ebp
  801b7f:	c3                   	ret    
  801b80:	3b 04 24             	cmp    (%esp),%eax
  801b83:	72 06                	jb     801b8b <__umoddi3+0x113>
  801b85:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b89:	77 0f                	ja     801b9a <__umoddi3+0x122>
  801b8b:	89 f2                	mov    %esi,%edx
  801b8d:	29 f9                	sub    %edi,%ecx
  801b8f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b93:	89 14 24             	mov    %edx,(%esp)
  801b96:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b9a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b9e:	8b 14 24             	mov    (%esp),%edx
  801ba1:	83 c4 1c             	add    $0x1c,%esp
  801ba4:	5b                   	pop    %ebx
  801ba5:	5e                   	pop    %esi
  801ba6:	5f                   	pop    %edi
  801ba7:	5d                   	pop    %ebp
  801ba8:	c3                   	ret    
  801ba9:	8d 76 00             	lea    0x0(%esi),%esi
  801bac:	2b 04 24             	sub    (%esp),%eax
  801baf:	19 fa                	sbb    %edi,%edx
  801bb1:	89 d1                	mov    %edx,%ecx
  801bb3:	89 c6                	mov    %eax,%esi
  801bb5:	e9 71 ff ff ff       	jmp    801b2b <__umoddi3+0xb3>
  801bba:	66 90                	xchg   %ax,%ax
  801bbc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bc0:	72 ea                	jb     801bac <__umoddi3+0x134>
  801bc2:	89 d9                	mov    %ebx,%ecx
  801bc4:	e9 62 ff ff ff       	jmp    801b2b <__umoddi3+0xb3>
