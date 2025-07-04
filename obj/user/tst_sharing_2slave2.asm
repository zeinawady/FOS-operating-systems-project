
obj/user/tst_sharing_2slave2:     file format elf32-i386


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
  800031:	e8 23 02 00 00       	call   800259 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program2: Get 2 shared variables, edit the writable one, and attempt to edit the readOnly one
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003f:	a1 20 50 80 00       	mov    0x805020,%eax
  800044:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  80004a:	a1 20 50 80 00       	mov    0x805020,%eax
  80004f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800055:	39 c2                	cmp    %eax,%edx
  800057:	72 14                	jb     80006d <_main+0x35>
			panic("Please increase the WS size");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 60 36 80 00       	push   $0x803660
  800061:	6a 0d                	push   $0xd
  800063:	68 7c 36 80 00       	push   $0x80367c
  800068:	e8 31 03 00 00       	call   80039e <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006d:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int32 parentenvID = sys_getparentenvid();
  800074:	e8 49 1d 00 00       	call   801dc2 <sys_getparentenvid>
  800079:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int freeFrames, diff, expected;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80007c:	e8 ac 1a 00 00       	call   801b2d <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800081:	e8 5a 1b 00 00       	call   801be0 <sys_calculate_free_frames>
  800086:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	68 97 36 80 00       	push   $0x803697
  800091:	ff 75 f0             	pushl  -0x10(%ebp)
  800094:	e8 c4 17 00 00       	call   80185d <sget>
  800099:	83 c4 10             	add    $0x10,%esp
  80009c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 0 * PAGE_SIZE);
  80009f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (z != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, z);
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000ab:	74 1a                	je     8000c7 <_main+0x8f>
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000b6:	68 9c 36 80 00       	push   $0x80369c
  8000bb:	6a 23                	push   $0x23
  8000bd:	68 7c 36 80 00       	push   $0x80367c
  8000c2:	e8 d7 02 00 00       	call   80039e <_panic>
		expected = 1 ; /*1table*/
  8000c7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000ce:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000d1:	e8 0a 1b 00 00       	call   801be0 <sys_calculate_free_frames>
  8000d6:	29 c3                	sub    %eax,%ebx
  8000d8:	89 d8                	mov    %ebx,%eax
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000e0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000e3:	74 24                	je     800109 <_main+0xd1>
  8000e5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000e8:	e8 f3 1a 00 00       	call   801be0 <sys_calculate_free_frames>
  8000ed:	29 c3                	sub    %eax,%ebx
  8000ef:	89 d8                	mov    %ebx,%eax
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	50                   	push   %eax
  8000f8:	68 18 37 80 00       	push   $0x803718
  8000fd:	6a 26                	push   $0x26
  8000ff:	68 7c 36 80 00       	push   $0x80367c
  800104:	e8 95 02 00 00       	call   80039e <_panic>
	}
	sys_unlock_cons();
  800109:	e8 39 1a 00 00       	call   801b47 <sys_unlock_cons>
	//sys_unlock_cons();

	//sys_lock_cons();
	sys_lock_cons();
  80010e:	e8 1a 1a 00 00       	call   801b2d <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800113:	e8 c8 1a 00 00       	call   801be0 <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 b0 37 80 00       	push   $0x8037b0
  800123:	ff 75 f0             	pushl  -0x10(%ebp)
  800126:	e8 32 17 00 00       	call   80185d <sget>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 1 * PAGE_SIZE);
  800131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800134:	05 00 10 00 00       	add    $0x1000,%eax
  800139:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, x);
  80013c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80013f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800142:	74 1a                	je     80015e <_main+0x126>
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	ff 75 d8             	pushl  -0x28(%ebp)
  80014a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80014d:	68 9c 36 80 00       	push   $0x80369c
  800152:	6a 31                	push   $0x31
  800154:	68 7c 36 80 00       	push   $0x80367c
  800159:	e8 40 02 00 00       	call   80039e <_panic>
		expected = 0;
  80015e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800165:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800168:	e8 73 1a 00 00       	call   801be0 <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800177:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80017a:	74 24                	je     8001a0 <_main+0x168>
  80017c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80017f:	e8 5c 1a 00 00       	call   801be0 <sys_calculate_free_frames>
  800184:	29 c3                	sub    %eax,%ebx
  800186:	89 d8                	mov    %ebx,%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 e0             	pushl  -0x20(%ebp)
  80018e:	50                   	push   %eax
  80018f:	68 18 37 80 00       	push   $0x803718
  800194:	6a 34                	push   $0x34
  800196:	68 7c 36 80 00       	push   $0x80367c
  80019b:	e8 fe 01 00 00       	call   80039e <_panic>
	}
	sys_unlock_cons();
  8001a0:	e8 a2 19 00 00       	call   801b47 <sys_unlock_cons>
	//sys_unlock_cons();

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001a8:	8b 00                	mov    (%eax),%eax
  8001aa:	83 f8 0a             	cmp    $0xa,%eax
  8001ad:	74 14                	je     8001c3 <_main+0x18b>
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	68 b4 37 80 00       	push   $0x8037b4
  8001b7:	6a 39                	push   $0x39
  8001b9:	68 7c 36 80 00       	push   $0x80367c
  8001be:	e8 db 01 00 00       	call   80039e <_panic>

	//Edit the writable object
	*z = 50;
  8001c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001c6:	c7 00 32 00 00 00    	movl   $0x32,(%eax)
	if (*z != 50) panic("Get(): Shared Variable is not created or got correctly") ;
  8001cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001cf:	8b 00                	mov    (%eax),%eax
  8001d1:	83 f8 32             	cmp    $0x32,%eax
  8001d4:	74 14                	je     8001ea <_main+0x1b2>
  8001d6:	83 ec 04             	sub    $0x4,%esp
  8001d9:	68 b4 37 80 00       	push   $0x8037b4
  8001de:	6a 3d                	push   $0x3d
  8001e0:	68 7c 36 80 00       	push   $0x80367c
  8001e5:	e8 b4 01 00 00       	call   80039e <_panic>

	inctst();
  8001ea:	e8 f8 1c 00 00       	call   801ee7 <inctst>

	//sync with master
	while (gettst() != 5) ;
  8001ef:	90                   	nop
  8001f0:	e8 0c 1d 00 00       	call   801f01 <gettst>
  8001f5:	83 f8 05             	cmp    $0x5,%eax
  8001f8:	75 f6                	jne    8001f0 <_main+0x1b8>

	//Attempt to edit the ReadOnly object, it should panic
	sys_bypassPageFault(6);
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	6a 06                	push   $0x6
  8001ff:	e8 5d 1c 00 00       	call   801e61 <sys_bypassPageFault>
  800204:	83 c4 10             	add    $0x10,%esp
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  800207:	83 ec 08             	sub    $0x8,%esp
  80020a:	ff 75 d8             	pushl  -0x28(%ebp)
  80020d:	68 ec 37 80 00       	push   $0x8037ec
  800212:	e8 44 04 00 00       	call   80065b <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  80021a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80021d:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	sys_bypassPageFault(0);
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	6a 00                	push   $0x0
  800228:	e8 34 1c 00 00       	call   801e61 <sys_bypassPageFault>
  80022d:	83 c4 10             	add    $0x10,%esp

	inctst();
  800230:	e8 b2 1c 00 00       	call   801ee7 <inctst>
	if (*x == 100)
  800235:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800238:	8b 00                	mov    (%eax),%eax
  80023a:	83 f8 64             	cmp    $0x64,%eax
  80023d:	75 14                	jne    800253 <_main+0x21b>
		panic("Test FAILED! it should not edit the variable x since it's a read-only!") ;
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 1c 38 80 00       	push   $0x80381c
  800247:	6a 4d                	push   $0x4d
  800249:	68 7c 36 80 00       	push   $0x80367c
  80024e:	e8 4b 01 00 00       	call   80039e <_panic>
	return;
  800253:	90                   	nop
}
  800254:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800257:	c9                   	leave  
  800258:	c3                   	ret    

00800259 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80025f:	e8 45 1b 00 00       	call   801da9 <sys_getenvindex>
  800264:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800267:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80026a:	89 d0                	mov    %edx,%eax
  80026c:	c1 e0 02             	shl    $0x2,%eax
  80026f:	01 d0                	add    %edx,%eax
  800271:	c1 e0 03             	shl    $0x3,%eax
  800274:	01 d0                	add    %edx,%eax
  800276:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80027d:	01 d0                	add    %edx,%eax
  80027f:	c1 e0 02             	shl    $0x2,%eax
  800282:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800287:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80028c:	a1 20 50 80 00       	mov    0x805020,%eax
  800291:	8a 40 20             	mov    0x20(%eax),%al
  800294:	84 c0                	test   %al,%al
  800296:	74 0d                	je     8002a5 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800298:	a1 20 50 80 00       	mov    0x805020,%eax
  80029d:	83 c0 20             	add    $0x20,%eax
  8002a0:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002a9:	7e 0a                	jle    8002b5 <libmain+0x5c>
		binaryname = argv[0];
  8002ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ae:	8b 00                	mov    (%eax),%eax
  8002b0:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8002b5:	83 ec 08             	sub    $0x8,%esp
  8002b8:	ff 75 0c             	pushl  0xc(%ebp)
  8002bb:	ff 75 08             	pushl  0x8(%ebp)
  8002be:	e8 75 fd ff ff       	call   800038 <_main>
  8002c3:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002c6:	a1 00 50 80 00       	mov    0x805000,%eax
  8002cb:	85 c0                	test   %eax,%eax
  8002cd:	0f 84 9f 00 00 00    	je     800372 <libmain+0x119>
	{
		sys_lock_cons();
  8002d3:	e8 55 18 00 00       	call   801b2d <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8002d8:	83 ec 0c             	sub    $0xc,%esp
  8002db:	68 7c 38 80 00       	push   $0x80387c
  8002e0:	e8 76 03 00 00       	call   80065b <cprintf>
  8002e5:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002e8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ed:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8002f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8002f8:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	52                   	push   %edx
  800302:	50                   	push   %eax
  800303:	68 a4 38 80 00       	push   $0x8038a4
  800308:	e8 4e 03 00 00       	call   80065b <cprintf>
  80030d:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800310:	a1 20 50 80 00       	mov    0x805020,%eax
  800315:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80031b:	a1 20 50 80 00       	mov    0x805020,%eax
  800320:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800326:	a1 20 50 80 00       	mov    0x805020,%eax
  80032b:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800331:	51                   	push   %ecx
  800332:	52                   	push   %edx
  800333:	50                   	push   %eax
  800334:	68 cc 38 80 00       	push   $0x8038cc
  800339:	e8 1d 03 00 00       	call   80065b <cprintf>
  80033e:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800341:	a1 20 50 80 00       	mov    0x805020,%eax
  800346:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80034c:	83 ec 08             	sub    $0x8,%esp
  80034f:	50                   	push   %eax
  800350:	68 24 39 80 00       	push   $0x803924
  800355:	e8 01 03 00 00       	call   80065b <cprintf>
  80035a:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80035d:	83 ec 0c             	sub    $0xc,%esp
  800360:	68 7c 38 80 00       	push   $0x80387c
  800365:	e8 f1 02 00 00       	call   80065b <cprintf>
  80036a:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80036d:	e8 d5 17 00 00       	call   801b47 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800372:	e8 19 00 00 00       	call   800390 <exit>
}
  800377:	90                   	nop
  800378:	c9                   	leave  
  800379:	c3                   	ret    

0080037a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80037a:	55                   	push   %ebp
  80037b:	89 e5                	mov    %esp,%ebp
  80037d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800380:	83 ec 0c             	sub    $0xc,%esp
  800383:	6a 00                	push   $0x0
  800385:	e8 eb 19 00 00       	call   801d75 <sys_destroy_env>
  80038a:	83 c4 10             	add    $0x10,%esp
}
  80038d:	90                   	nop
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <exit>:

void
exit(void)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800396:	e8 40 1a 00 00       	call   801ddb <sys_exit_env>
}
  80039b:	90                   	nop
  80039c:	c9                   	leave  
  80039d:	c3                   	ret    

0080039e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80039e:	55                   	push   %ebp
  80039f:	89 e5                	mov    %esp,%ebp
  8003a1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003a4:	8d 45 10             	lea    0x10(%ebp),%eax
  8003a7:	83 c0 04             	add    $0x4,%eax
  8003aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003ad:	a1 60 50 98 00       	mov    0x985060,%eax
  8003b2:	85 c0                	test   %eax,%eax
  8003b4:	74 16                	je     8003cc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003b6:	a1 60 50 98 00       	mov    0x985060,%eax
  8003bb:	83 ec 08             	sub    $0x8,%esp
  8003be:	50                   	push   %eax
  8003bf:	68 38 39 80 00       	push   $0x803938
  8003c4:	e8 92 02 00 00       	call   80065b <cprintf>
  8003c9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003cc:	a1 04 50 80 00       	mov    0x805004,%eax
  8003d1:	ff 75 0c             	pushl  0xc(%ebp)
  8003d4:	ff 75 08             	pushl  0x8(%ebp)
  8003d7:	50                   	push   %eax
  8003d8:	68 3d 39 80 00       	push   $0x80393d
  8003dd:	e8 79 02 00 00       	call   80065b <cprintf>
  8003e2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e8:	83 ec 08             	sub    $0x8,%esp
  8003eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ee:	50                   	push   %eax
  8003ef:	e8 fc 01 00 00       	call   8005f0 <vcprintf>
  8003f4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003f7:	83 ec 08             	sub    $0x8,%esp
  8003fa:	6a 00                	push   $0x0
  8003fc:	68 59 39 80 00       	push   $0x803959
  800401:	e8 ea 01 00 00       	call   8005f0 <vcprintf>
  800406:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800409:	e8 82 ff ff ff       	call   800390 <exit>

	// should not return here
	while (1) ;
  80040e:	eb fe                	jmp    80040e <_panic+0x70>

00800410 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800410:	55                   	push   %ebp
  800411:	89 e5                	mov    %esp,%ebp
  800413:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800416:	a1 20 50 80 00       	mov    0x805020,%eax
  80041b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800421:	8b 45 0c             	mov    0xc(%ebp),%eax
  800424:	39 c2                	cmp    %eax,%edx
  800426:	74 14                	je     80043c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800428:	83 ec 04             	sub    $0x4,%esp
  80042b:	68 5c 39 80 00       	push   $0x80395c
  800430:	6a 26                	push   $0x26
  800432:	68 a8 39 80 00       	push   $0x8039a8
  800437:	e8 62 ff ff ff       	call   80039e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80043c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800443:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80044a:	e9 c5 00 00 00       	jmp    800514 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80044f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800452:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800459:	8b 45 08             	mov    0x8(%ebp),%eax
  80045c:	01 d0                	add    %edx,%eax
  80045e:	8b 00                	mov    (%eax),%eax
  800460:	85 c0                	test   %eax,%eax
  800462:	75 08                	jne    80046c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800464:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800467:	e9 a5 00 00 00       	jmp    800511 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80046c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800473:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80047a:	eb 69                	jmp    8004e5 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80047c:	a1 20 50 80 00       	mov    0x805020,%eax
  800481:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800487:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80048a:	89 d0                	mov    %edx,%eax
  80048c:	01 c0                	add    %eax,%eax
  80048e:	01 d0                	add    %edx,%eax
  800490:	c1 e0 03             	shl    $0x3,%eax
  800493:	01 c8                	add    %ecx,%eax
  800495:	8a 40 04             	mov    0x4(%eax),%al
  800498:	84 c0                	test   %al,%al
  80049a:	75 46                	jne    8004e2 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80049c:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a1:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8004a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004aa:	89 d0                	mov    %edx,%eax
  8004ac:	01 c0                	add    %eax,%eax
  8004ae:	01 d0                	add    %edx,%eax
  8004b0:	c1 e0 03             	shl    $0x3,%eax
  8004b3:	01 c8                	add    %ecx,%eax
  8004b5:	8b 00                	mov    (%eax),%eax
  8004b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004c2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d1:	01 c8                	add    %ecx,%eax
  8004d3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004d5:	39 c2                	cmp    %eax,%edx
  8004d7:	75 09                	jne    8004e2 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8004d9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004e0:	eb 15                	jmp    8004f7 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004e2:	ff 45 e8             	incl   -0x18(%ebp)
  8004e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8004ea:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8004f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004f3:	39 c2                	cmp    %eax,%edx
  8004f5:	77 85                	ja     80047c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004fb:	75 14                	jne    800511 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8004fd:	83 ec 04             	sub    $0x4,%esp
  800500:	68 b4 39 80 00       	push   $0x8039b4
  800505:	6a 3a                	push   $0x3a
  800507:	68 a8 39 80 00       	push   $0x8039a8
  80050c:	e8 8d fe ff ff       	call   80039e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800511:	ff 45 f0             	incl   -0x10(%ebp)
  800514:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800517:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80051a:	0f 8c 2f ff ff ff    	jl     80044f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800520:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800527:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80052e:	eb 26                	jmp    800556 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800530:	a1 20 50 80 00       	mov    0x805020,%eax
  800535:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80053b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80053e:	89 d0                	mov    %edx,%eax
  800540:	01 c0                	add    %eax,%eax
  800542:	01 d0                	add    %edx,%eax
  800544:	c1 e0 03             	shl    $0x3,%eax
  800547:	01 c8                	add    %ecx,%eax
  800549:	8a 40 04             	mov    0x4(%eax),%al
  80054c:	3c 01                	cmp    $0x1,%al
  80054e:	75 03                	jne    800553 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800550:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800553:	ff 45 e0             	incl   -0x20(%ebp)
  800556:	a1 20 50 80 00       	mov    0x805020,%eax
  80055b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800561:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800564:	39 c2                	cmp    %eax,%edx
  800566:	77 c8                	ja     800530 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80056b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80056e:	74 14                	je     800584 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800570:	83 ec 04             	sub    $0x4,%esp
  800573:	68 08 3a 80 00       	push   $0x803a08
  800578:	6a 44                	push   $0x44
  80057a:	68 a8 39 80 00       	push   $0x8039a8
  80057f:	e8 1a fe ff ff       	call   80039e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800584:	90                   	nop
  800585:	c9                   	leave  
  800586:	c3                   	ret    

00800587 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800587:	55                   	push   %ebp
  800588:	89 e5                	mov    %esp,%ebp
  80058a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80058d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800590:	8b 00                	mov    (%eax),%eax
  800592:	8d 48 01             	lea    0x1(%eax),%ecx
  800595:	8b 55 0c             	mov    0xc(%ebp),%edx
  800598:	89 0a                	mov    %ecx,(%edx)
  80059a:	8b 55 08             	mov    0x8(%ebp),%edx
  80059d:	88 d1                	mov    %dl,%cl
  80059f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005b0:	75 2c                	jne    8005de <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005b2:	a0 44 50 98 00       	mov    0x985044,%al
  8005b7:	0f b6 c0             	movzbl %al,%eax
  8005ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005bd:	8b 12                	mov    (%edx),%edx
  8005bf:	89 d1                	mov    %edx,%ecx
  8005c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005c4:	83 c2 08             	add    $0x8,%edx
  8005c7:	83 ec 04             	sub    $0x4,%esp
  8005ca:	50                   	push   %eax
  8005cb:	51                   	push   %ecx
  8005cc:	52                   	push   %edx
  8005cd:	e8 19 15 00 00       	call   801aeb <sys_cputs>
  8005d2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e1:	8b 40 04             	mov    0x4(%eax),%eax
  8005e4:	8d 50 01             	lea    0x1(%eax),%edx
  8005e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ea:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005ed:	90                   	nop
  8005ee:	c9                   	leave  
  8005ef:	c3                   	ret    

008005f0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005f0:	55                   	push   %ebp
  8005f1:	89 e5                	mov    %esp,%ebp
  8005f3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005f9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800600:	00 00 00 
	b.cnt = 0;
  800603:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80060a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80060d:	ff 75 0c             	pushl  0xc(%ebp)
  800610:	ff 75 08             	pushl  0x8(%ebp)
  800613:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800619:	50                   	push   %eax
  80061a:	68 87 05 80 00       	push   $0x800587
  80061f:	e8 11 02 00 00       	call   800835 <vprintfmt>
  800624:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800627:	a0 44 50 98 00       	mov    0x985044,%al
  80062c:	0f b6 c0             	movzbl %al,%eax
  80062f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800635:	83 ec 04             	sub    $0x4,%esp
  800638:	50                   	push   %eax
  800639:	52                   	push   %edx
  80063a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800640:	83 c0 08             	add    $0x8,%eax
  800643:	50                   	push   %eax
  800644:	e8 a2 14 00 00       	call   801aeb <sys_cputs>
  800649:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80064c:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  800653:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800659:	c9                   	leave  
  80065a:	c3                   	ret    

0080065b <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80065b:	55                   	push   %ebp
  80065c:	89 e5                	mov    %esp,%ebp
  80065e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800661:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  800668:	8d 45 0c             	lea    0xc(%ebp),%eax
  80066b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	83 ec 08             	sub    $0x8,%esp
  800674:	ff 75 f4             	pushl  -0xc(%ebp)
  800677:	50                   	push   %eax
  800678:	e8 73 ff ff ff       	call   8005f0 <vcprintf>
  80067d:	83 c4 10             	add    $0x10,%esp
  800680:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800683:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800686:	c9                   	leave  
  800687:	c3                   	ret    

00800688 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800688:	55                   	push   %ebp
  800689:	89 e5                	mov    %esp,%ebp
  80068b:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80068e:	e8 9a 14 00 00       	call   801b2d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800693:	8d 45 0c             	lea    0xc(%ebp),%eax
  800696:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800699:	8b 45 08             	mov    0x8(%ebp),%eax
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	ff 75 f4             	pushl  -0xc(%ebp)
  8006a2:	50                   	push   %eax
  8006a3:	e8 48 ff ff ff       	call   8005f0 <vcprintf>
  8006a8:	83 c4 10             	add    $0x10,%esp
  8006ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8006ae:	e8 94 14 00 00       	call   801b47 <sys_unlock_cons>
	return cnt;
  8006b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006b6:	c9                   	leave  
  8006b7:	c3                   	ret    

008006b8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006b8:	55                   	push   %ebp
  8006b9:	89 e5                	mov    %esp,%ebp
  8006bb:	53                   	push   %ebx
  8006bc:	83 ec 14             	sub    $0x14,%esp
  8006bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8006c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006cb:	8b 45 18             	mov    0x18(%ebp),%eax
  8006ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006d6:	77 55                	ja     80072d <printnum+0x75>
  8006d8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006db:	72 05                	jb     8006e2 <printnum+0x2a>
  8006dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006e0:	77 4b                	ja     80072d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006e2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006e5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006e8:	8b 45 18             	mov    0x18(%ebp),%eax
  8006eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f0:	52                   	push   %edx
  8006f1:	50                   	push   %eax
  8006f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8006f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8006f8:	e8 ef 2c 00 00       	call   8033ec <__udivdi3>
  8006fd:	83 c4 10             	add    $0x10,%esp
  800700:	83 ec 04             	sub    $0x4,%esp
  800703:	ff 75 20             	pushl  0x20(%ebp)
  800706:	53                   	push   %ebx
  800707:	ff 75 18             	pushl  0x18(%ebp)
  80070a:	52                   	push   %edx
  80070b:	50                   	push   %eax
  80070c:	ff 75 0c             	pushl  0xc(%ebp)
  80070f:	ff 75 08             	pushl  0x8(%ebp)
  800712:	e8 a1 ff ff ff       	call   8006b8 <printnum>
  800717:	83 c4 20             	add    $0x20,%esp
  80071a:	eb 1a                	jmp    800736 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80071c:	83 ec 08             	sub    $0x8,%esp
  80071f:	ff 75 0c             	pushl  0xc(%ebp)
  800722:	ff 75 20             	pushl  0x20(%ebp)
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	ff d0                	call   *%eax
  80072a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80072d:	ff 4d 1c             	decl   0x1c(%ebp)
  800730:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800734:	7f e6                	jg     80071c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800736:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800739:	bb 00 00 00 00       	mov    $0x0,%ebx
  80073e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800741:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800744:	53                   	push   %ebx
  800745:	51                   	push   %ecx
  800746:	52                   	push   %edx
  800747:	50                   	push   %eax
  800748:	e8 af 2d 00 00       	call   8034fc <__umoddi3>
  80074d:	83 c4 10             	add    $0x10,%esp
  800750:	05 74 3c 80 00       	add    $0x803c74,%eax
  800755:	8a 00                	mov    (%eax),%al
  800757:	0f be c0             	movsbl %al,%eax
  80075a:	83 ec 08             	sub    $0x8,%esp
  80075d:	ff 75 0c             	pushl  0xc(%ebp)
  800760:	50                   	push   %eax
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	ff d0                	call   *%eax
  800766:	83 c4 10             	add    $0x10,%esp
}
  800769:	90                   	nop
  80076a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80076d:	c9                   	leave  
  80076e:	c3                   	ret    

0080076f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80076f:	55                   	push   %ebp
  800770:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800772:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800776:	7e 1c                	jle    800794 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	8b 00                	mov    (%eax),%eax
  80077d:	8d 50 08             	lea    0x8(%eax),%edx
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	89 10                	mov    %edx,(%eax)
  800785:	8b 45 08             	mov    0x8(%ebp),%eax
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	83 e8 08             	sub    $0x8,%eax
  80078d:	8b 50 04             	mov    0x4(%eax),%edx
  800790:	8b 00                	mov    (%eax),%eax
  800792:	eb 40                	jmp    8007d4 <getuint+0x65>
	else if (lflag)
  800794:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800798:	74 1e                	je     8007b8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	8b 00                	mov    (%eax),%eax
  80079f:	8d 50 04             	lea    0x4(%eax),%edx
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	89 10                	mov    %edx,(%eax)
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	83 e8 04             	sub    $0x4,%eax
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b6:	eb 1c                	jmp    8007d4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bb:	8b 00                	mov    (%eax),%eax
  8007bd:	8d 50 04             	lea    0x4(%eax),%edx
  8007c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c3:	89 10                	mov    %edx,(%eax)
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	83 e8 04             	sub    $0x4,%eax
  8007cd:	8b 00                	mov    (%eax),%eax
  8007cf:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007d4:	5d                   	pop    %ebp
  8007d5:	c3                   	ret    

008007d6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007d6:	55                   	push   %ebp
  8007d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007d9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007dd:	7e 1c                	jle    8007fb <getint+0x25>
		return va_arg(*ap, long long);
  8007df:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e2:	8b 00                	mov    (%eax),%eax
  8007e4:	8d 50 08             	lea    0x8(%eax),%edx
  8007e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ea:	89 10                	mov    %edx,(%eax)
  8007ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ef:	8b 00                	mov    (%eax),%eax
  8007f1:	83 e8 08             	sub    $0x8,%eax
  8007f4:	8b 50 04             	mov    0x4(%eax),%edx
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	eb 38                	jmp    800833 <getint+0x5d>
	else if (lflag)
  8007fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007ff:	74 1a                	je     80081b <getint+0x45>
		return va_arg(*ap, long);
  800801:	8b 45 08             	mov    0x8(%ebp),%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	8d 50 04             	lea    0x4(%eax),%edx
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	89 10                	mov    %edx,(%eax)
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	8b 00                	mov    (%eax),%eax
  800813:	83 e8 04             	sub    $0x4,%eax
  800816:	8b 00                	mov    (%eax),%eax
  800818:	99                   	cltd   
  800819:	eb 18                	jmp    800833 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80081b:	8b 45 08             	mov    0x8(%ebp),%eax
  80081e:	8b 00                	mov    (%eax),%eax
  800820:	8d 50 04             	lea    0x4(%eax),%edx
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	89 10                	mov    %edx,(%eax)
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	8b 00                	mov    (%eax),%eax
  80082d:	83 e8 04             	sub    $0x4,%eax
  800830:	8b 00                	mov    (%eax),%eax
  800832:	99                   	cltd   
}
  800833:	5d                   	pop    %ebp
  800834:	c3                   	ret    

00800835 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800835:	55                   	push   %ebp
  800836:	89 e5                	mov    %esp,%ebp
  800838:	56                   	push   %esi
  800839:	53                   	push   %ebx
  80083a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80083d:	eb 17                	jmp    800856 <vprintfmt+0x21>
			if (ch == '\0')
  80083f:	85 db                	test   %ebx,%ebx
  800841:	0f 84 c1 03 00 00    	je     800c08 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800847:	83 ec 08             	sub    $0x8,%esp
  80084a:	ff 75 0c             	pushl  0xc(%ebp)
  80084d:	53                   	push   %ebx
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	ff d0                	call   *%eax
  800853:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800856:	8b 45 10             	mov    0x10(%ebp),%eax
  800859:	8d 50 01             	lea    0x1(%eax),%edx
  80085c:	89 55 10             	mov    %edx,0x10(%ebp)
  80085f:	8a 00                	mov    (%eax),%al
  800861:	0f b6 d8             	movzbl %al,%ebx
  800864:	83 fb 25             	cmp    $0x25,%ebx
  800867:	75 d6                	jne    80083f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800869:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80086d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800874:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80087b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800882:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800889:	8b 45 10             	mov    0x10(%ebp),%eax
  80088c:	8d 50 01             	lea    0x1(%eax),%edx
  80088f:	89 55 10             	mov    %edx,0x10(%ebp)
  800892:	8a 00                	mov    (%eax),%al
  800894:	0f b6 d8             	movzbl %al,%ebx
  800897:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80089a:	83 f8 5b             	cmp    $0x5b,%eax
  80089d:	0f 87 3d 03 00 00    	ja     800be0 <vprintfmt+0x3ab>
  8008a3:	8b 04 85 98 3c 80 00 	mov    0x803c98(,%eax,4),%eax
  8008aa:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008ac:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008b0:	eb d7                	jmp    800889 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008b2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008b6:	eb d1                	jmp    800889 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008c2:	89 d0                	mov    %edx,%eax
  8008c4:	c1 e0 02             	shl    $0x2,%eax
  8008c7:	01 d0                	add    %edx,%eax
  8008c9:	01 c0                	add    %eax,%eax
  8008cb:	01 d8                	add    %ebx,%eax
  8008cd:	83 e8 30             	sub    $0x30,%eax
  8008d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d6:	8a 00                	mov    (%eax),%al
  8008d8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008db:	83 fb 2f             	cmp    $0x2f,%ebx
  8008de:	7e 3e                	jle    80091e <vprintfmt+0xe9>
  8008e0:	83 fb 39             	cmp    $0x39,%ebx
  8008e3:	7f 39                	jg     80091e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008e5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008e8:	eb d5                	jmp    8008bf <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ed:	83 c0 04             	add    $0x4,%eax
  8008f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f6:	83 e8 04             	sub    $0x4,%eax
  8008f9:	8b 00                	mov    (%eax),%eax
  8008fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008fe:	eb 1f                	jmp    80091f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800900:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800904:	79 83                	jns    800889 <vprintfmt+0x54>
				width = 0;
  800906:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80090d:	e9 77 ff ff ff       	jmp    800889 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800912:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800919:	e9 6b ff ff ff       	jmp    800889 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80091e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80091f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800923:	0f 89 60 ff ff ff    	jns    800889 <vprintfmt+0x54>
				width = precision, precision = -1;
  800929:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80092f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800936:	e9 4e ff ff ff       	jmp    800889 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80093b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80093e:	e9 46 ff ff ff       	jmp    800889 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800943:	8b 45 14             	mov    0x14(%ebp),%eax
  800946:	83 c0 04             	add    $0x4,%eax
  800949:	89 45 14             	mov    %eax,0x14(%ebp)
  80094c:	8b 45 14             	mov    0x14(%ebp),%eax
  80094f:	83 e8 04             	sub    $0x4,%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	83 ec 08             	sub    $0x8,%esp
  800957:	ff 75 0c             	pushl  0xc(%ebp)
  80095a:	50                   	push   %eax
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	ff d0                	call   *%eax
  800960:	83 c4 10             	add    $0x10,%esp
			break;
  800963:	e9 9b 02 00 00       	jmp    800c03 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800968:	8b 45 14             	mov    0x14(%ebp),%eax
  80096b:	83 c0 04             	add    $0x4,%eax
  80096e:	89 45 14             	mov    %eax,0x14(%ebp)
  800971:	8b 45 14             	mov    0x14(%ebp),%eax
  800974:	83 e8 04             	sub    $0x4,%eax
  800977:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800979:	85 db                	test   %ebx,%ebx
  80097b:	79 02                	jns    80097f <vprintfmt+0x14a>
				err = -err;
  80097d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80097f:	83 fb 64             	cmp    $0x64,%ebx
  800982:	7f 0b                	jg     80098f <vprintfmt+0x15a>
  800984:	8b 34 9d e0 3a 80 00 	mov    0x803ae0(,%ebx,4),%esi
  80098b:	85 f6                	test   %esi,%esi
  80098d:	75 19                	jne    8009a8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80098f:	53                   	push   %ebx
  800990:	68 85 3c 80 00       	push   $0x803c85
  800995:	ff 75 0c             	pushl  0xc(%ebp)
  800998:	ff 75 08             	pushl  0x8(%ebp)
  80099b:	e8 70 02 00 00       	call   800c10 <printfmt>
  8009a0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009a3:	e9 5b 02 00 00       	jmp    800c03 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009a8:	56                   	push   %esi
  8009a9:	68 8e 3c 80 00       	push   $0x803c8e
  8009ae:	ff 75 0c             	pushl  0xc(%ebp)
  8009b1:	ff 75 08             	pushl  0x8(%ebp)
  8009b4:	e8 57 02 00 00       	call   800c10 <printfmt>
  8009b9:	83 c4 10             	add    $0x10,%esp
			break;
  8009bc:	e9 42 02 00 00       	jmp    800c03 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c4:	83 c0 04             	add    $0x4,%eax
  8009c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cd:	83 e8 04             	sub    $0x4,%eax
  8009d0:	8b 30                	mov    (%eax),%esi
  8009d2:	85 f6                	test   %esi,%esi
  8009d4:	75 05                	jne    8009db <vprintfmt+0x1a6>
				p = "(null)";
  8009d6:	be 91 3c 80 00       	mov    $0x803c91,%esi
			if (width > 0 && padc != '-')
  8009db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009df:	7e 6d                	jle    800a4e <vprintfmt+0x219>
  8009e1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009e5:	74 67                	je     800a4e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	50                   	push   %eax
  8009ee:	56                   	push   %esi
  8009ef:	e8 1e 03 00 00       	call   800d12 <strnlen>
  8009f4:	83 c4 10             	add    $0x10,%esp
  8009f7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009fa:	eb 16                	jmp    800a12 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009fc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a00:	83 ec 08             	sub    $0x8,%esp
  800a03:	ff 75 0c             	pushl  0xc(%ebp)
  800a06:	50                   	push   %eax
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	ff d0                	call   *%eax
  800a0c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a0f:	ff 4d e4             	decl   -0x1c(%ebp)
  800a12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a16:	7f e4                	jg     8009fc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a18:	eb 34                	jmp    800a4e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a1a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a1e:	74 1c                	je     800a3c <vprintfmt+0x207>
  800a20:	83 fb 1f             	cmp    $0x1f,%ebx
  800a23:	7e 05                	jle    800a2a <vprintfmt+0x1f5>
  800a25:	83 fb 7e             	cmp    $0x7e,%ebx
  800a28:	7e 12                	jle    800a3c <vprintfmt+0x207>
					putch('?', putdat);
  800a2a:	83 ec 08             	sub    $0x8,%esp
  800a2d:	ff 75 0c             	pushl  0xc(%ebp)
  800a30:	6a 3f                	push   $0x3f
  800a32:	8b 45 08             	mov    0x8(%ebp),%eax
  800a35:	ff d0                	call   *%eax
  800a37:	83 c4 10             	add    $0x10,%esp
  800a3a:	eb 0f                	jmp    800a4b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a3c:	83 ec 08             	sub    $0x8,%esp
  800a3f:	ff 75 0c             	pushl  0xc(%ebp)
  800a42:	53                   	push   %ebx
  800a43:	8b 45 08             	mov    0x8(%ebp),%eax
  800a46:	ff d0                	call   *%eax
  800a48:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a4b:	ff 4d e4             	decl   -0x1c(%ebp)
  800a4e:	89 f0                	mov    %esi,%eax
  800a50:	8d 70 01             	lea    0x1(%eax),%esi
  800a53:	8a 00                	mov    (%eax),%al
  800a55:	0f be d8             	movsbl %al,%ebx
  800a58:	85 db                	test   %ebx,%ebx
  800a5a:	74 24                	je     800a80 <vprintfmt+0x24b>
  800a5c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a60:	78 b8                	js     800a1a <vprintfmt+0x1e5>
  800a62:	ff 4d e0             	decl   -0x20(%ebp)
  800a65:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a69:	79 af                	jns    800a1a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a6b:	eb 13                	jmp    800a80 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a6d:	83 ec 08             	sub    $0x8,%esp
  800a70:	ff 75 0c             	pushl  0xc(%ebp)
  800a73:	6a 20                	push   $0x20
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	ff d0                	call   *%eax
  800a7a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a7d:	ff 4d e4             	decl   -0x1c(%ebp)
  800a80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a84:	7f e7                	jg     800a6d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a86:	e9 78 01 00 00       	jmp    800c03 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a8b:	83 ec 08             	sub    $0x8,%esp
  800a8e:	ff 75 e8             	pushl  -0x18(%ebp)
  800a91:	8d 45 14             	lea    0x14(%ebp),%eax
  800a94:	50                   	push   %eax
  800a95:	e8 3c fd ff ff       	call   8007d6 <getint>
  800a9a:	83 c4 10             	add    $0x10,%esp
  800a9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aa9:	85 d2                	test   %edx,%edx
  800aab:	79 23                	jns    800ad0 <vprintfmt+0x29b>
				putch('-', putdat);
  800aad:	83 ec 08             	sub    $0x8,%esp
  800ab0:	ff 75 0c             	pushl  0xc(%ebp)
  800ab3:	6a 2d                	push   $0x2d
  800ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab8:	ff d0                	call   *%eax
  800aba:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ac3:	f7 d8                	neg    %eax
  800ac5:	83 d2 00             	adc    $0x0,%edx
  800ac8:	f7 da                	neg    %edx
  800aca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800acd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ad0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ad7:	e9 bc 00 00 00       	jmp    800b98 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800adc:	83 ec 08             	sub    $0x8,%esp
  800adf:	ff 75 e8             	pushl  -0x18(%ebp)
  800ae2:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae5:	50                   	push   %eax
  800ae6:	e8 84 fc ff ff       	call   80076f <getuint>
  800aeb:	83 c4 10             	add    $0x10,%esp
  800aee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800af4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800afb:	e9 98 00 00 00       	jmp    800b98 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b00:	83 ec 08             	sub    $0x8,%esp
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	6a 58                	push   $0x58
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	ff d0                	call   *%eax
  800b0d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 0c             	pushl  0xc(%ebp)
  800b16:	6a 58                	push   $0x58
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	ff d0                	call   *%eax
  800b1d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b20:	83 ec 08             	sub    $0x8,%esp
  800b23:	ff 75 0c             	pushl  0xc(%ebp)
  800b26:	6a 58                	push   $0x58
  800b28:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2b:	ff d0                	call   *%eax
  800b2d:	83 c4 10             	add    $0x10,%esp
			break;
  800b30:	e9 ce 00 00 00       	jmp    800c03 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b35:	83 ec 08             	sub    $0x8,%esp
  800b38:	ff 75 0c             	pushl  0xc(%ebp)
  800b3b:	6a 30                	push   $0x30
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	ff d0                	call   *%eax
  800b42:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b45:	83 ec 08             	sub    $0x8,%esp
  800b48:	ff 75 0c             	pushl  0xc(%ebp)
  800b4b:	6a 78                	push   $0x78
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	ff d0                	call   *%eax
  800b52:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b55:	8b 45 14             	mov    0x14(%ebp),%eax
  800b58:	83 c0 04             	add    $0x4,%eax
  800b5b:	89 45 14             	mov    %eax,0x14(%ebp)
  800b5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b61:	83 e8 04             	sub    $0x4,%eax
  800b64:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b70:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b77:	eb 1f                	jmp    800b98 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b79:	83 ec 08             	sub    $0x8,%esp
  800b7c:	ff 75 e8             	pushl  -0x18(%ebp)
  800b7f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b82:	50                   	push   %eax
  800b83:	e8 e7 fb ff ff       	call   80076f <getuint>
  800b88:	83 c4 10             	add    $0x10,%esp
  800b8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b91:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b98:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b9f:	83 ec 04             	sub    $0x4,%esp
  800ba2:	52                   	push   %edx
  800ba3:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ba6:	50                   	push   %eax
  800ba7:	ff 75 f4             	pushl  -0xc(%ebp)
  800baa:	ff 75 f0             	pushl  -0x10(%ebp)
  800bad:	ff 75 0c             	pushl  0xc(%ebp)
  800bb0:	ff 75 08             	pushl  0x8(%ebp)
  800bb3:	e8 00 fb ff ff       	call   8006b8 <printnum>
  800bb8:	83 c4 20             	add    $0x20,%esp
			break;
  800bbb:	eb 46                	jmp    800c03 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bbd:	83 ec 08             	sub    $0x8,%esp
  800bc0:	ff 75 0c             	pushl  0xc(%ebp)
  800bc3:	53                   	push   %ebx
  800bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc7:	ff d0                	call   *%eax
  800bc9:	83 c4 10             	add    $0x10,%esp
			break;
  800bcc:	eb 35                	jmp    800c03 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800bce:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  800bd5:	eb 2c                	jmp    800c03 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800bd7:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  800bde:	eb 23                	jmp    800c03 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800be0:	83 ec 08             	sub    $0x8,%esp
  800be3:	ff 75 0c             	pushl  0xc(%ebp)
  800be6:	6a 25                	push   $0x25
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	ff d0                	call   *%eax
  800bed:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bf0:	ff 4d 10             	decl   0x10(%ebp)
  800bf3:	eb 03                	jmp    800bf8 <vprintfmt+0x3c3>
  800bf5:	ff 4d 10             	decl   0x10(%ebp)
  800bf8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfb:	48                   	dec    %eax
  800bfc:	8a 00                	mov    (%eax),%al
  800bfe:	3c 25                	cmp    $0x25,%al
  800c00:	75 f3                	jne    800bf5 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c02:	90                   	nop
		}
	}
  800c03:	e9 35 fc ff ff       	jmp    80083d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c08:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c0c:	5b                   	pop    %ebx
  800c0d:	5e                   	pop    %esi
  800c0e:	5d                   	pop    %ebp
  800c0f:	c3                   	ret    

00800c10 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c16:	8d 45 10             	lea    0x10(%ebp),%eax
  800c19:	83 c0 04             	add    $0x4,%eax
  800c1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c22:	ff 75 f4             	pushl  -0xc(%ebp)
  800c25:	50                   	push   %eax
  800c26:	ff 75 0c             	pushl  0xc(%ebp)
  800c29:	ff 75 08             	pushl  0x8(%ebp)
  800c2c:	e8 04 fc ff ff       	call   800835 <vprintfmt>
  800c31:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c34:	90                   	nop
  800c35:	c9                   	leave  
  800c36:	c3                   	ret    

00800c37 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3d:	8b 40 08             	mov    0x8(%eax),%eax
  800c40:	8d 50 01             	lea    0x1(%eax),%edx
  800c43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c46:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4c:	8b 10                	mov    (%eax),%edx
  800c4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c51:	8b 40 04             	mov    0x4(%eax),%eax
  800c54:	39 c2                	cmp    %eax,%edx
  800c56:	73 12                	jae    800c6a <sprintputch+0x33>
		*b->buf++ = ch;
  800c58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5b:	8b 00                	mov    (%eax),%eax
  800c5d:	8d 48 01             	lea    0x1(%eax),%ecx
  800c60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c63:	89 0a                	mov    %ecx,(%edx)
  800c65:	8b 55 08             	mov    0x8(%ebp),%edx
  800c68:	88 10                	mov    %dl,(%eax)
}
  800c6a:	90                   	nop
  800c6b:	5d                   	pop    %ebp
  800c6c:	c3                   	ret    

00800c6d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	01 d0                	add    %edx,%eax
  800c84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c8e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c92:	74 06                	je     800c9a <vsnprintf+0x2d>
  800c94:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c98:	7f 07                	jg     800ca1 <vsnprintf+0x34>
		return -E_INVAL;
  800c9a:	b8 03 00 00 00       	mov    $0x3,%eax
  800c9f:	eb 20                	jmp    800cc1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ca1:	ff 75 14             	pushl  0x14(%ebp)
  800ca4:	ff 75 10             	pushl  0x10(%ebp)
  800ca7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800caa:	50                   	push   %eax
  800cab:	68 37 0c 80 00       	push   $0x800c37
  800cb0:	e8 80 fb ff ff       	call   800835 <vprintfmt>
  800cb5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cbb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cc1:	c9                   	leave  
  800cc2:	c3                   	ret    

00800cc3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cc9:	8d 45 10             	lea    0x10(%ebp),%eax
  800ccc:	83 c0 04             	add    $0x4,%eax
  800ccf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd5:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd8:	50                   	push   %eax
  800cd9:	ff 75 0c             	pushl  0xc(%ebp)
  800cdc:	ff 75 08             	pushl  0x8(%ebp)
  800cdf:	e8 89 ff ff ff       	call   800c6d <vsnprintf>
  800ce4:	83 c4 10             	add    $0x10,%esp
  800ce7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ced:	c9                   	leave  
  800cee:	c3                   	ret    

00800cef <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cf5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cfc:	eb 06                	jmp    800d04 <strlen+0x15>
		n++;
  800cfe:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d01:	ff 45 08             	incl   0x8(%ebp)
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8a 00                	mov    (%eax),%al
  800d09:	84 c0                	test   %al,%al
  800d0b:	75 f1                	jne    800cfe <strlen+0xf>
		n++;
	return n;
  800d0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d10:	c9                   	leave  
  800d11:	c3                   	ret    

00800d12 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d1f:	eb 09                	jmp    800d2a <strnlen+0x18>
		n++;
  800d21:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d24:	ff 45 08             	incl   0x8(%ebp)
  800d27:	ff 4d 0c             	decl   0xc(%ebp)
  800d2a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d2e:	74 09                	je     800d39 <strnlen+0x27>
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	8a 00                	mov    (%eax),%al
  800d35:	84 c0                	test   %al,%al
  800d37:	75 e8                	jne    800d21 <strnlen+0xf>
		n++;
	return n;
  800d39:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d3c:	c9                   	leave  
  800d3d:	c3                   	ret    

00800d3e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d3e:	55                   	push   %ebp
  800d3f:	89 e5                	mov    %esp,%ebp
  800d41:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d4a:	90                   	nop
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8d 50 01             	lea    0x1(%eax),%edx
  800d51:	89 55 08             	mov    %edx,0x8(%ebp)
  800d54:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d57:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d5a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d5d:	8a 12                	mov    (%edx),%dl
  800d5f:	88 10                	mov    %dl,(%eax)
  800d61:	8a 00                	mov    (%eax),%al
  800d63:	84 c0                	test   %al,%al
  800d65:	75 e4                	jne    800d4b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d67:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d6a:	c9                   	leave  
  800d6b:	c3                   	ret    

00800d6c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d7f:	eb 1f                	jmp    800da0 <strncpy+0x34>
		*dst++ = *src;
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	8d 50 01             	lea    0x1(%eax),%edx
  800d87:	89 55 08             	mov    %edx,0x8(%ebp)
  800d8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d8d:	8a 12                	mov    (%edx),%dl
  800d8f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	8a 00                	mov    (%eax),%al
  800d96:	84 c0                	test   %al,%al
  800d98:	74 03                	je     800d9d <strncpy+0x31>
			src++;
  800d9a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d9d:	ff 45 fc             	incl   -0x4(%ebp)
  800da0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800da6:	72 d9                	jb     800d81 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800da8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dab:	c9                   	leave  
  800dac:	c3                   	ret    

00800dad <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800db9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbd:	74 30                	je     800def <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dbf:	eb 16                	jmp    800dd7 <strlcpy+0x2a>
			*dst++ = *src++;
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	8d 50 01             	lea    0x1(%eax),%edx
  800dc7:	89 55 08             	mov    %edx,0x8(%ebp)
  800dca:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dcd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dd0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dd3:	8a 12                	mov    (%edx),%dl
  800dd5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dd7:	ff 4d 10             	decl   0x10(%ebp)
  800dda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dde:	74 09                	je     800de9 <strlcpy+0x3c>
  800de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	84 c0                	test   %al,%al
  800de7:	75 d8                	jne    800dc1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800def:	8b 55 08             	mov    0x8(%ebp),%edx
  800df2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df5:	29 c2                	sub    %eax,%edx
  800df7:	89 d0                	mov    %edx,%eax
}
  800df9:	c9                   	leave  
  800dfa:	c3                   	ret    

00800dfb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dfe:	eb 06                	jmp    800e06 <strcmp+0xb>
		p++, q++;
  800e00:	ff 45 08             	incl   0x8(%ebp)
  800e03:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	84 c0                	test   %al,%al
  800e0d:	74 0e                	je     800e1d <strcmp+0x22>
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8a 10                	mov    (%eax),%dl
  800e14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e17:	8a 00                	mov    (%eax),%al
  800e19:	38 c2                	cmp    %al,%dl
  800e1b:	74 e3                	je     800e00 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	8a 00                	mov    (%eax),%al
  800e22:	0f b6 d0             	movzbl %al,%edx
  800e25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e28:	8a 00                	mov    (%eax),%al
  800e2a:	0f b6 c0             	movzbl %al,%eax
  800e2d:	29 c2                	sub    %eax,%edx
  800e2f:	89 d0                	mov    %edx,%eax
}
  800e31:	5d                   	pop    %ebp
  800e32:	c3                   	ret    

00800e33 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e36:	eb 09                	jmp    800e41 <strncmp+0xe>
		n--, p++, q++;
  800e38:	ff 4d 10             	decl   0x10(%ebp)
  800e3b:	ff 45 08             	incl   0x8(%ebp)
  800e3e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e45:	74 17                	je     800e5e <strncmp+0x2b>
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	8a 00                	mov    (%eax),%al
  800e4c:	84 c0                	test   %al,%al
  800e4e:	74 0e                	je     800e5e <strncmp+0x2b>
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	8a 10                	mov    (%eax),%dl
  800e55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	38 c2                	cmp    %al,%dl
  800e5c:	74 da                	je     800e38 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e62:	75 07                	jne    800e6b <strncmp+0x38>
		return 0;
  800e64:	b8 00 00 00 00       	mov    $0x0,%eax
  800e69:	eb 14                	jmp    800e7f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6e:	8a 00                	mov    (%eax),%al
  800e70:	0f b6 d0             	movzbl %al,%edx
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	8a 00                	mov    (%eax),%al
  800e78:	0f b6 c0             	movzbl %al,%eax
  800e7b:	29 c2                	sub    %eax,%edx
  800e7d:	89 d0                	mov    %edx,%eax
}
  800e7f:	5d                   	pop    %ebp
  800e80:	c3                   	ret    

00800e81 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
  800e84:	83 ec 04             	sub    $0x4,%esp
  800e87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e8d:	eb 12                	jmp    800ea1 <strchr+0x20>
		if (*s == c)
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	8a 00                	mov    (%eax),%al
  800e94:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e97:	75 05                	jne    800e9e <strchr+0x1d>
			return (char *) s;
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	eb 11                	jmp    800eaf <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e9e:	ff 45 08             	incl   0x8(%ebp)
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	8a 00                	mov    (%eax),%al
  800ea6:	84 c0                	test   %al,%al
  800ea8:	75 e5                	jne    800e8f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800eaa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eaf:	c9                   	leave  
  800eb0:	c3                   	ret    

00800eb1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800eb1:	55                   	push   %ebp
  800eb2:	89 e5                	mov    %esp,%ebp
  800eb4:	83 ec 04             	sub    $0x4,%esp
  800eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eba:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ebd:	eb 0d                	jmp    800ecc <strfind+0x1b>
		if (*s == c)
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	8a 00                	mov    (%eax),%al
  800ec4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ec7:	74 0e                	je     800ed7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ec9:	ff 45 08             	incl   0x8(%ebp)
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	84 c0                	test   %al,%al
  800ed3:	75 ea                	jne    800ebf <strfind+0xe>
  800ed5:	eb 01                	jmp    800ed8 <strfind+0x27>
		if (*s == c)
			break;
  800ed7:	90                   	nop
	return (char *) s;
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800edb:	c9                   	leave  
  800edc:	c3                   	ret    

00800edd <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ee9:	8b 45 10             	mov    0x10(%ebp),%eax
  800eec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800eef:	eb 0e                	jmp    800eff <memset+0x22>
		*p++ = c;
  800ef1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef4:	8d 50 01             	lea    0x1(%eax),%edx
  800ef7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800efa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800efd:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800eff:	ff 4d f8             	decl   -0x8(%ebp)
  800f02:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f06:	79 e9                	jns    800ef1 <memset+0x14>
		*p++ = c;

	return v;
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0b:	c9                   	leave  
  800f0c:	c3                   	ret    

00800f0d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f19:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f1f:	eb 16                	jmp    800f37 <memcpy+0x2a>
		*d++ = *s++;
  800f21:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f24:	8d 50 01             	lea    0x1(%eax),%edx
  800f27:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f2a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f2d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f30:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f33:	8a 12                	mov    (%edx),%dl
  800f35:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f37:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f3d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f40:	85 c0                	test   %eax,%eax
  800f42:	75 dd                	jne    800f21 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f47:	c9                   	leave  
  800f48:	c3                   	ret    

00800f49 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f49:	55                   	push   %ebp
  800f4a:	89 e5                	mov    %esp,%ebp
  800f4c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f61:	73 50                	jae    800fb3 <memmove+0x6a>
  800f63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f66:	8b 45 10             	mov    0x10(%ebp),%eax
  800f69:	01 d0                	add    %edx,%eax
  800f6b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f6e:	76 43                	jbe    800fb3 <memmove+0x6a>
		s += n;
  800f70:	8b 45 10             	mov    0x10(%ebp),%eax
  800f73:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f76:	8b 45 10             	mov    0x10(%ebp),%eax
  800f79:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f7c:	eb 10                	jmp    800f8e <memmove+0x45>
			*--d = *--s;
  800f7e:	ff 4d f8             	decl   -0x8(%ebp)
  800f81:	ff 4d fc             	decl   -0x4(%ebp)
  800f84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f87:	8a 10                	mov    (%eax),%dl
  800f89:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f8c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f91:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f94:	89 55 10             	mov    %edx,0x10(%ebp)
  800f97:	85 c0                	test   %eax,%eax
  800f99:	75 e3                	jne    800f7e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f9b:	eb 23                	jmp    800fc0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa0:	8d 50 01             	lea    0x1(%eax),%edx
  800fa3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fa6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fac:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800faf:	8a 12                	mov    (%edx),%dl
  800fb1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb9:	89 55 10             	mov    %edx,0x10(%ebp)
  800fbc:	85 c0                	test   %eax,%eax
  800fbe:	75 dd                	jne    800f9d <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc3:	c9                   	leave  
  800fc4:	c3                   	ret    

00800fc5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fd7:	eb 2a                	jmp    801003 <memcmp+0x3e>
		if (*s1 != *s2)
  800fd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fdc:	8a 10                	mov    (%eax),%dl
  800fde:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	38 c2                	cmp    %al,%dl
  800fe5:	74 16                	je     800ffd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fe7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	0f b6 d0             	movzbl %al,%edx
  800fef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	0f b6 c0             	movzbl %al,%eax
  800ff7:	29 c2                	sub    %eax,%edx
  800ff9:	89 d0                	mov    %edx,%eax
  800ffb:	eb 18                	jmp    801015 <memcmp+0x50>
		s1++, s2++;
  800ffd:	ff 45 fc             	incl   -0x4(%ebp)
  801000:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801003:	8b 45 10             	mov    0x10(%ebp),%eax
  801006:	8d 50 ff             	lea    -0x1(%eax),%edx
  801009:	89 55 10             	mov    %edx,0x10(%ebp)
  80100c:	85 c0                	test   %eax,%eax
  80100e:	75 c9                	jne    800fd9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801010:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801015:	c9                   	leave  
  801016:	c3                   	ret    

00801017 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80101d:	8b 55 08             	mov    0x8(%ebp),%edx
  801020:	8b 45 10             	mov    0x10(%ebp),%eax
  801023:	01 d0                	add    %edx,%eax
  801025:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801028:	eb 15                	jmp    80103f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	0f b6 d0             	movzbl %al,%edx
  801032:	8b 45 0c             	mov    0xc(%ebp),%eax
  801035:	0f b6 c0             	movzbl %al,%eax
  801038:	39 c2                	cmp    %eax,%edx
  80103a:	74 0d                	je     801049 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80103c:	ff 45 08             	incl   0x8(%ebp)
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801045:	72 e3                	jb     80102a <memfind+0x13>
  801047:	eb 01                	jmp    80104a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801049:	90                   	nop
	return (void *) s;
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80104d:	c9                   	leave  
  80104e:	c3                   	ret    

0080104f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801055:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80105c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801063:	eb 03                	jmp    801068 <strtol+0x19>
		s++;
  801065:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
  80106b:	8a 00                	mov    (%eax),%al
  80106d:	3c 20                	cmp    $0x20,%al
  80106f:	74 f4                	je     801065 <strtol+0x16>
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	8a 00                	mov    (%eax),%al
  801076:	3c 09                	cmp    $0x9,%al
  801078:	74 eb                	je     801065 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	8a 00                	mov    (%eax),%al
  80107f:	3c 2b                	cmp    $0x2b,%al
  801081:	75 05                	jne    801088 <strtol+0x39>
		s++;
  801083:	ff 45 08             	incl   0x8(%ebp)
  801086:	eb 13                	jmp    80109b <strtol+0x4c>
	else if (*s == '-')
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	8a 00                	mov    (%eax),%al
  80108d:	3c 2d                	cmp    $0x2d,%al
  80108f:	75 0a                	jne    80109b <strtol+0x4c>
		s++, neg = 1;
  801091:	ff 45 08             	incl   0x8(%ebp)
  801094:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80109b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80109f:	74 06                	je     8010a7 <strtol+0x58>
  8010a1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010a5:	75 20                	jne    8010c7 <strtol+0x78>
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	8a 00                	mov    (%eax),%al
  8010ac:	3c 30                	cmp    $0x30,%al
  8010ae:	75 17                	jne    8010c7 <strtol+0x78>
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	40                   	inc    %eax
  8010b4:	8a 00                	mov    (%eax),%al
  8010b6:	3c 78                	cmp    $0x78,%al
  8010b8:	75 0d                	jne    8010c7 <strtol+0x78>
		s += 2, base = 16;
  8010ba:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010be:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010c5:	eb 28                	jmp    8010ef <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010cb:	75 15                	jne    8010e2 <strtol+0x93>
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	8a 00                	mov    (%eax),%al
  8010d2:	3c 30                	cmp    $0x30,%al
  8010d4:	75 0c                	jne    8010e2 <strtol+0x93>
		s++, base = 8;
  8010d6:	ff 45 08             	incl   0x8(%ebp)
  8010d9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010e0:	eb 0d                	jmp    8010ef <strtol+0xa0>
	else if (base == 0)
  8010e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e6:	75 07                	jne    8010ef <strtol+0xa0>
		base = 10;
  8010e8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	8a 00                	mov    (%eax),%al
  8010f4:	3c 2f                	cmp    $0x2f,%al
  8010f6:	7e 19                	jle    801111 <strtol+0xc2>
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	8a 00                	mov    (%eax),%al
  8010fd:	3c 39                	cmp    $0x39,%al
  8010ff:	7f 10                	jg     801111 <strtol+0xc2>
			dig = *s - '0';
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	8a 00                	mov    (%eax),%al
  801106:	0f be c0             	movsbl %al,%eax
  801109:	83 e8 30             	sub    $0x30,%eax
  80110c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80110f:	eb 42                	jmp    801153 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	8a 00                	mov    (%eax),%al
  801116:	3c 60                	cmp    $0x60,%al
  801118:	7e 19                	jle    801133 <strtol+0xe4>
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
  80111d:	8a 00                	mov    (%eax),%al
  80111f:	3c 7a                	cmp    $0x7a,%al
  801121:	7f 10                	jg     801133 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	8a 00                	mov    (%eax),%al
  801128:	0f be c0             	movsbl %al,%eax
  80112b:	83 e8 57             	sub    $0x57,%eax
  80112e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801131:	eb 20                	jmp    801153 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 40                	cmp    $0x40,%al
  80113a:	7e 39                	jle    801175 <strtol+0x126>
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	3c 5a                	cmp    $0x5a,%al
  801143:	7f 30                	jg     801175 <strtol+0x126>
			dig = *s - 'A' + 10;
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	0f be c0             	movsbl %al,%eax
  80114d:	83 e8 37             	sub    $0x37,%eax
  801150:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801156:	3b 45 10             	cmp    0x10(%ebp),%eax
  801159:	7d 19                	jge    801174 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80115b:	ff 45 08             	incl   0x8(%ebp)
  80115e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801161:	0f af 45 10          	imul   0x10(%ebp),%eax
  801165:	89 c2                	mov    %eax,%edx
  801167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80116a:	01 d0                	add    %edx,%eax
  80116c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80116f:	e9 7b ff ff ff       	jmp    8010ef <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801174:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801175:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801179:	74 08                	je     801183 <strtol+0x134>
		*endptr = (char *) s;
  80117b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117e:	8b 55 08             	mov    0x8(%ebp),%edx
  801181:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801183:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801187:	74 07                	je     801190 <strtol+0x141>
  801189:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118c:	f7 d8                	neg    %eax
  80118e:	eb 03                	jmp    801193 <strtol+0x144>
  801190:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801193:	c9                   	leave  
  801194:	c3                   	ret    

00801195 <ltostr>:

void
ltostr(long value, char *str)
{
  801195:	55                   	push   %ebp
  801196:	89 e5                	mov    %esp,%ebp
  801198:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80119b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011a2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011ad:	79 13                	jns    8011c2 <ltostr+0x2d>
	{
		neg = 1;
  8011af:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011bc:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011bf:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011ca:	99                   	cltd   
  8011cb:	f7 f9                	idiv   %ecx
  8011cd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d3:	8d 50 01             	lea    0x1(%eax),%edx
  8011d6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011d9:	89 c2                	mov    %eax,%edx
  8011db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011de:	01 d0                	add    %edx,%eax
  8011e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011e3:	83 c2 30             	add    $0x30,%edx
  8011e6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011eb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011f0:	f7 e9                	imul   %ecx
  8011f2:	c1 fa 02             	sar    $0x2,%edx
  8011f5:	89 c8                	mov    %ecx,%eax
  8011f7:	c1 f8 1f             	sar    $0x1f,%eax
  8011fa:	29 c2                	sub    %eax,%edx
  8011fc:	89 d0                	mov    %edx,%eax
  8011fe:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801201:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801205:	75 bb                	jne    8011c2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801207:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80120e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801211:	48                   	dec    %eax
  801212:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801215:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801219:	74 3d                	je     801258 <ltostr+0xc3>
		start = 1 ;
  80121b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801222:	eb 34                	jmp    801258 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801224:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122a:	01 d0                	add    %edx,%eax
  80122c:	8a 00                	mov    (%eax),%al
  80122e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801231:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801234:	8b 45 0c             	mov    0xc(%ebp),%eax
  801237:	01 c2                	add    %eax,%edx
  801239:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80123c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123f:	01 c8                	add    %ecx,%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801245:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124b:	01 c2                	add    %eax,%edx
  80124d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801250:	88 02                	mov    %al,(%edx)
		start++ ;
  801252:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801255:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80125e:	7c c4                	jl     801224 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801260:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801263:	8b 45 0c             	mov    0xc(%ebp),%eax
  801266:	01 d0                	add    %edx,%eax
  801268:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80126b:	90                   	nop
  80126c:	c9                   	leave  
  80126d:	c3                   	ret    

0080126e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
  801271:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801274:	ff 75 08             	pushl  0x8(%ebp)
  801277:	e8 73 fa ff ff       	call   800cef <strlen>
  80127c:	83 c4 04             	add    $0x4,%esp
  80127f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801282:	ff 75 0c             	pushl  0xc(%ebp)
  801285:	e8 65 fa ff ff       	call   800cef <strlen>
  80128a:	83 c4 04             	add    $0x4,%esp
  80128d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801290:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801297:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80129e:	eb 17                	jmp    8012b7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a6:	01 c2                	add    %eax,%edx
  8012a8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	01 c8                	add    %ecx,%eax
  8012b0:	8a 00                	mov    (%eax),%al
  8012b2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012b4:	ff 45 fc             	incl   -0x4(%ebp)
  8012b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ba:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012bd:	7c e1                	jl     8012a0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012cd:	eb 1f                	jmp    8012ee <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d2:	8d 50 01             	lea    0x1(%eax),%edx
  8012d5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012d8:	89 c2                	mov    %eax,%edx
  8012da:	8b 45 10             	mov    0x10(%ebp),%eax
  8012dd:	01 c2                	add    %eax,%edx
  8012df:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e5:	01 c8                	add    %ecx,%eax
  8012e7:	8a 00                	mov    (%eax),%al
  8012e9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012eb:	ff 45 f8             	incl   -0x8(%ebp)
  8012ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012f4:	7c d9                	jl     8012cf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fc:	01 d0                	add    %edx,%eax
  8012fe:	c6 00 00             	movb   $0x0,(%eax)
}
  801301:	90                   	nop
  801302:	c9                   	leave  
  801303:	c3                   	ret    

00801304 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801304:	55                   	push   %ebp
  801305:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801307:	8b 45 14             	mov    0x14(%ebp),%eax
  80130a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801310:	8b 45 14             	mov    0x14(%ebp),%eax
  801313:	8b 00                	mov    (%eax),%eax
  801315:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80131c:	8b 45 10             	mov    0x10(%ebp),%eax
  80131f:	01 d0                	add    %edx,%eax
  801321:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801327:	eb 0c                	jmp    801335 <strsplit+0x31>
			*string++ = 0;
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8d 50 01             	lea    0x1(%eax),%edx
  80132f:	89 55 08             	mov    %edx,0x8(%ebp)
  801332:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	8a 00                	mov    (%eax),%al
  80133a:	84 c0                	test   %al,%al
  80133c:	74 18                	je     801356 <strsplit+0x52>
  80133e:	8b 45 08             	mov    0x8(%ebp),%eax
  801341:	8a 00                	mov    (%eax),%al
  801343:	0f be c0             	movsbl %al,%eax
  801346:	50                   	push   %eax
  801347:	ff 75 0c             	pushl  0xc(%ebp)
  80134a:	e8 32 fb ff ff       	call   800e81 <strchr>
  80134f:	83 c4 08             	add    $0x8,%esp
  801352:	85 c0                	test   %eax,%eax
  801354:	75 d3                	jne    801329 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801356:	8b 45 08             	mov    0x8(%ebp),%eax
  801359:	8a 00                	mov    (%eax),%al
  80135b:	84 c0                	test   %al,%al
  80135d:	74 5a                	je     8013b9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80135f:	8b 45 14             	mov    0x14(%ebp),%eax
  801362:	8b 00                	mov    (%eax),%eax
  801364:	83 f8 0f             	cmp    $0xf,%eax
  801367:	75 07                	jne    801370 <strsplit+0x6c>
		{
			return 0;
  801369:	b8 00 00 00 00       	mov    $0x0,%eax
  80136e:	eb 66                	jmp    8013d6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801370:	8b 45 14             	mov    0x14(%ebp),%eax
  801373:	8b 00                	mov    (%eax),%eax
  801375:	8d 48 01             	lea    0x1(%eax),%ecx
  801378:	8b 55 14             	mov    0x14(%ebp),%edx
  80137b:	89 0a                	mov    %ecx,(%edx)
  80137d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801384:	8b 45 10             	mov    0x10(%ebp),%eax
  801387:	01 c2                	add    %eax,%edx
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80138e:	eb 03                	jmp    801393 <strsplit+0x8f>
			string++;
  801390:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	8a 00                	mov    (%eax),%al
  801398:	84 c0                	test   %al,%al
  80139a:	74 8b                	je     801327 <strsplit+0x23>
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	8a 00                	mov    (%eax),%al
  8013a1:	0f be c0             	movsbl %al,%eax
  8013a4:	50                   	push   %eax
  8013a5:	ff 75 0c             	pushl  0xc(%ebp)
  8013a8:	e8 d4 fa ff ff       	call   800e81 <strchr>
  8013ad:	83 c4 08             	add    $0x8,%esp
  8013b0:	85 c0                	test   %eax,%eax
  8013b2:	74 dc                	je     801390 <strsplit+0x8c>
			string++;
	}
  8013b4:	e9 6e ff ff ff       	jmp    801327 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013b9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bd:	8b 00                	mov    (%eax),%eax
  8013bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c9:	01 d0                	add    %edx,%eax
  8013cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013d1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013d6:	c9                   	leave  
  8013d7:	c3                   	ret    

008013d8 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
  8013db:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8013de:	83 ec 04             	sub    $0x4,%esp
  8013e1:	68 08 3e 80 00       	push   $0x803e08
  8013e6:	68 3f 01 00 00       	push   $0x13f
  8013eb:	68 2a 3e 80 00       	push   $0x803e2a
  8013f0:	e8 a9 ef ff ff       	call   80039e <_panic>

008013f5 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
  8013f8:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8013fb:	83 ec 0c             	sub    $0xc,%esp
  8013fe:	ff 75 08             	pushl  0x8(%ebp)
  801401:	e8 90 0c 00 00       	call   802096 <sys_sbrk>
  801406:	83 c4 10             	add    $0x10,%esp
}
  801409:	c9                   	leave  
  80140a:	c3                   	ret    

0080140b <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
  80140e:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801411:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801415:	75 0a                	jne    801421 <malloc+0x16>
		return NULL;
  801417:	b8 00 00 00 00       	mov    $0x0,%eax
  80141c:	e9 9e 01 00 00       	jmp    8015bf <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801421:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801428:	77 2c                	ja     801456 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  80142a:	e8 eb 0a 00 00       	call   801f1a <sys_isUHeapPlacementStrategyFIRSTFIT>
  80142f:	85 c0                	test   %eax,%eax
  801431:	74 19                	je     80144c <malloc+0x41>

			void * block = alloc_block_FF(size);
  801433:	83 ec 0c             	sub    $0xc,%esp
  801436:	ff 75 08             	pushl  0x8(%ebp)
  801439:	e8 85 11 00 00       	call   8025c3 <alloc_block_FF>
  80143e:	83 c4 10             	add    $0x10,%esp
  801441:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  801444:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801447:	e9 73 01 00 00       	jmp    8015bf <malloc+0x1b4>
		} else {
			return NULL;
  80144c:	b8 00 00 00 00       	mov    $0x0,%eax
  801451:	e9 69 01 00 00       	jmp    8015bf <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801456:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80145d:	8b 55 08             	mov    0x8(%ebp),%edx
  801460:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801463:	01 d0                	add    %edx,%eax
  801465:	48                   	dec    %eax
  801466:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801469:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80146c:	ba 00 00 00 00       	mov    $0x0,%edx
  801471:	f7 75 e0             	divl   -0x20(%ebp)
  801474:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801477:	29 d0                	sub    %edx,%eax
  801479:	c1 e8 0c             	shr    $0xc,%eax
  80147c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  80147f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801486:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  80148d:	a1 20 50 80 00       	mov    0x805020,%eax
  801492:	8b 40 7c             	mov    0x7c(%eax),%eax
  801495:	05 00 10 00 00       	add    $0x1000,%eax
  80149a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  80149d:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8014a2:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8014a5:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  8014a8:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8014af:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8014b5:	01 d0                	add    %edx,%eax
  8014b7:	48                   	dec    %eax
  8014b8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8014bb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8014be:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c3:	f7 75 cc             	divl   -0x34(%ebp)
  8014c6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8014c9:	29 d0                	sub    %edx,%eax
  8014cb:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8014ce:	76 0a                	jbe    8014da <malloc+0xcf>
		return NULL;
  8014d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d5:	e9 e5 00 00 00       	jmp    8015bf <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  8014da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8014dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014e0:	eb 48                	jmp    80152a <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  8014e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014e5:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8014e8:	c1 e8 0c             	shr    $0xc,%eax
  8014eb:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  8014ee:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8014f1:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8014f8:	85 c0                	test   %eax,%eax
  8014fa:	75 11                	jne    80150d <malloc+0x102>
			freePagesCount++;
  8014fc:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8014ff:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801503:	75 16                	jne    80151b <malloc+0x110>
				start = i;
  801505:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801508:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80150b:	eb 0e                	jmp    80151b <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  80150d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801514:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  80151b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80151e:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801521:	74 12                	je     801535 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801523:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  80152a:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801531:	76 af                	jbe    8014e2 <malloc+0xd7>
  801533:	eb 01                	jmp    801536 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  801535:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  801536:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80153a:	74 08                	je     801544 <malloc+0x139>
  80153c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153f:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801542:	74 07                	je     80154b <malloc+0x140>
		return NULL;
  801544:	b8 00 00 00 00       	mov    $0x0,%eax
  801549:	eb 74                	jmp    8015bf <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  80154b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154e:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801551:	c1 e8 0c             	shr    $0xc,%eax
  801554:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801557:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80155a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80155d:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801564:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801567:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80156a:	eb 11                	jmp    80157d <malloc+0x172>
		markedPages[i] = 1;
  80156c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80156f:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801576:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  80157a:	ff 45 e8             	incl   -0x18(%ebp)
  80157d:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801580:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801583:	01 d0                	add    %edx,%eax
  801585:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801588:	77 e2                	ja     80156c <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  80158a:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801591:	8b 55 08             	mov    0x8(%ebp),%edx
  801594:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801597:	01 d0                	add    %edx,%eax
  801599:	48                   	dec    %eax
  80159a:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80159d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8015a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a5:	f7 75 bc             	divl   -0x44(%ebp)
  8015a8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8015ab:	29 d0                	sub    %edx,%eax
  8015ad:	83 ec 08             	sub    $0x8,%esp
  8015b0:	50                   	push   %eax
  8015b1:	ff 75 f0             	pushl  -0x10(%ebp)
  8015b4:	e8 14 0b 00 00       	call   8020cd <sys_allocate_user_mem>
  8015b9:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  8015bc:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    

008015c1 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  8015c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015cb:	0f 84 ee 00 00 00    	je     8016bf <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  8015d1:	a1 20 50 80 00       	mov    0x805020,%eax
  8015d6:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  8015d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8015dc:	77 09                	ja     8015e7 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  8015de:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  8015e5:	76 14                	jbe    8015fb <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  8015e7:	83 ec 04             	sub    $0x4,%esp
  8015ea:	68 38 3e 80 00       	push   $0x803e38
  8015ef:	6a 68                	push   $0x68
  8015f1:	68 52 3e 80 00       	push   $0x803e52
  8015f6:	e8 a3 ed ff ff       	call   80039e <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  8015fb:	a1 20 50 80 00       	mov    0x805020,%eax
  801600:	8b 40 74             	mov    0x74(%eax),%eax
  801603:	3b 45 08             	cmp    0x8(%ebp),%eax
  801606:	77 20                	ja     801628 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801608:	a1 20 50 80 00       	mov    0x805020,%eax
  80160d:	8b 40 78             	mov    0x78(%eax),%eax
  801610:	3b 45 08             	cmp    0x8(%ebp),%eax
  801613:	76 13                	jbe    801628 <free+0x67>
		free_block(virtual_address);
  801615:	83 ec 0c             	sub    $0xc,%esp
  801618:	ff 75 08             	pushl  0x8(%ebp)
  80161b:	e8 6c 16 00 00       	call   802c8c <free_block>
  801620:	83 c4 10             	add    $0x10,%esp
		return;
  801623:	e9 98 00 00 00       	jmp    8016c0 <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801628:	8b 55 08             	mov    0x8(%ebp),%edx
  80162b:	a1 20 50 80 00       	mov    0x805020,%eax
  801630:	8b 40 7c             	mov    0x7c(%eax),%eax
  801633:	29 c2                	sub    %eax,%edx
  801635:	89 d0                	mov    %edx,%eax
  801637:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  80163c:	c1 e8 0c             	shr    $0xc,%eax
  80163f:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801642:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801649:	eb 16                	jmp    801661 <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  80164b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80164e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801651:	01 d0                	add    %edx,%eax
  801653:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  80165a:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  80165e:	ff 45 f4             	incl   -0xc(%ebp)
  801661:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801664:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  80166b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80166e:	7f db                	jg     80164b <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  801670:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801673:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  80167a:	c1 e0 0c             	shl    $0xc,%eax
  80167d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801686:	eb 1a                	jmp    8016a2 <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801688:	83 ec 08             	sub    $0x8,%esp
  80168b:	68 00 10 00 00       	push   $0x1000
  801690:	ff 75 f0             	pushl  -0x10(%ebp)
  801693:	e8 19 0a 00 00       	call   8020b1 <sys_free_user_mem>
  801698:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  80169b:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8016a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016a8:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  8016aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016ad:	77 d9                	ja     801688 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  8016af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b2:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  8016b9:	00 00 00 00 
  8016bd:	eb 01                	jmp    8016c0 <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  8016bf:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  8016c0:	c9                   	leave  
  8016c1:	c3                   	ret    

008016c2 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
  8016c5:	83 ec 58             	sub    $0x58,%esp
  8016c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016cb:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8016ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016d2:	75 0a                	jne    8016de <smalloc+0x1c>
		return NULL;
  8016d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d9:	e9 7d 01 00 00       	jmp    80185b <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8016de:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8016e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016eb:	01 d0                	add    %edx,%eax
  8016ed:	48                   	dec    %eax
  8016ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8016f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f9:	f7 75 e4             	divl   -0x1c(%ebp)
  8016fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016ff:	29 d0                	sub    %edx,%eax
  801701:	c1 e8 0c             	shr    $0xc,%eax
  801704:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801707:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  80170e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801715:	a1 20 50 80 00       	mov    0x805020,%eax
  80171a:	8b 40 7c             	mov    0x7c(%eax),%eax
  80171d:	05 00 10 00 00       	add    $0x1000,%eax
  801722:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801725:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80172a:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80172d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801730:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801737:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80173d:	01 d0                	add    %edx,%eax
  80173f:	48                   	dec    %eax
  801740:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801743:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801746:	ba 00 00 00 00       	mov    $0x0,%edx
  80174b:	f7 75 d0             	divl   -0x30(%ebp)
  80174e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801751:	29 d0                	sub    %edx,%eax
  801753:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801756:	76 0a                	jbe    801762 <smalloc+0xa0>
		return NULL;
  801758:	b8 00 00 00 00       	mov    $0x0,%eax
  80175d:	e9 f9 00 00 00       	jmp    80185b <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801762:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801765:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801768:	eb 48                	jmp    8017b2 <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  80176a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80176d:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801770:	c1 e8 0c             	shr    $0xc,%eax
  801773:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801776:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801779:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801780:	85 c0                	test   %eax,%eax
  801782:	75 11                	jne    801795 <smalloc+0xd3>
			freePagesCount++;
  801784:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801787:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80178b:	75 16                	jne    8017a3 <smalloc+0xe1>
				start = s;
  80178d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801790:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801793:	eb 0e                	jmp    8017a3 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  801795:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80179c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  8017a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8017a9:	74 12                	je     8017bd <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8017ab:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8017b2:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8017b9:	76 af                	jbe    80176a <smalloc+0xa8>
  8017bb:	eb 01                	jmp    8017be <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  8017bd:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  8017be:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8017c2:	74 08                	je     8017cc <smalloc+0x10a>
  8017c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8017ca:	74 0a                	je     8017d6 <smalloc+0x114>
		return NULL;
  8017cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d1:	e9 85 00 00 00       	jmp    80185b <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8017d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d9:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8017dc:	c1 e8 0c             	shr    $0xc,%eax
  8017df:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  8017e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8017e5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8017e8:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8017ef:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8017f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8017f5:	eb 11                	jmp    801808 <smalloc+0x146>
		markedPages[s] = 1;
  8017f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017fa:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801801:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801805:	ff 45 e8             	incl   -0x18(%ebp)
  801808:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80180b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80180e:	01 d0                	add    %edx,%eax
  801810:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801813:	77 e2                	ja     8017f7 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  801815:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801818:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  80181c:	52                   	push   %edx
  80181d:	50                   	push   %eax
  80181e:	ff 75 0c             	pushl  0xc(%ebp)
  801821:	ff 75 08             	pushl  0x8(%ebp)
  801824:	e8 8f 04 00 00       	call   801cb8 <sys_createSharedObject>
  801829:	83 c4 10             	add    $0x10,%esp
  80182c:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  80182f:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  801833:	78 12                	js     801847 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  801835:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801838:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80183b:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801842:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801845:	eb 14                	jmp    80185b <smalloc+0x199>
	}
	free((void*) start);
  801847:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184a:	83 ec 0c             	sub    $0xc,%esp
  80184d:	50                   	push   %eax
  80184e:	e8 6e fd ff ff       	call   8015c1 <free>
  801853:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801856:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  801863:	83 ec 08             	sub    $0x8,%esp
  801866:	ff 75 0c             	pushl  0xc(%ebp)
  801869:	ff 75 08             	pushl  0x8(%ebp)
  80186c:	e8 71 04 00 00       	call   801ce2 <sys_getSizeOfSharedObject>
  801871:	83 c4 10             	add    $0x10,%esp
  801874:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801877:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80187e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801881:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801884:	01 d0                	add    %edx,%eax
  801886:	48                   	dec    %eax
  801887:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80188a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80188d:	ba 00 00 00 00       	mov    $0x0,%edx
  801892:	f7 75 e0             	divl   -0x20(%ebp)
  801895:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801898:	29 d0                	sub    %edx,%eax
  80189a:	c1 e8 0c             	shr    $0xc,%eax
  80189d:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  8018a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8018a7:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  8018ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8018b3:	8b 40 7c             	mov    0x7c(%eax),%eax
  8018b6:	05 00 10 00 00       	add    $0x1000,%eax
  8018bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  8018be:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8018c3:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8018c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  8018c9:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8018d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018d3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018d6:	01 d0                	add    %edx,%eax
  8018d8:	48                   	dec    %eax
  8018d9:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8018dc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018df:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e4:	f7 75 cc             	divl   -0x34(%ebp)
  8018e7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018ea:	29 d0                	sub    %edx,%eax
  8018ec:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8018ef:	76 0a                	jbe    8018fb <sget+0x9e>
		return NULL;
  8018f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f6:	e9 f7 00 00 00       	jmp    8019f2 <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8018fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801901:	eb 48                	jmp    80194b <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  801903:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801906:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801909:	c1 e8 0c             	shr    $0xc,%eax
  80190c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  80190f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801912:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801919:	85 c0                	test   %eax,%eax
  80191b:	75 11                	jne    80192e <sget+0xd1>
			free_Pages_Count++;
  80191d:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801920:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801924:	75 16                	jne    80193c <sget+0xdf>
				start = s;
  801926:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801929:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80192c:	eb 0e                	jmp    80193c <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  80192e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801935:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  80193c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80193f:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801942:	74 12                	je     801956 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801944:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  80194b:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801952:	76 af                	jbe    801903 <sget+0xa6>
  801954:	eb 01                	jmp    801957 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  801956:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  801957:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80195b:	74 08                	je     801965 <sget+0x108>
  80195d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801960:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801963:	74 0a                	je     80196f <sget+0x112>
		return NULL;
  801965:	b8 00 00 00 00       	mov    $0x0,%eax
  80196a:	e9 83 00 00 00       	jmp    8019f2 <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  80196f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801972:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801975:	c1 e8 0c             	shr    $0xc,%eax
  801978:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  80197b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80197e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801981:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801988:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80198b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80198e:	eb 11                	jmp    8019a1 <sget+0x144>
		markedPages[k] = 1;
  801990:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801993:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  80199a:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  80199e:	ff 45 e8             	incl   -0x18(%ebp)
  8019a1:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8019a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019a7:	01 d0                	add    %edx,%eax
  8019a9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8019ac:	77 e2                	ja     801990 <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  8019ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b1:	83 ec 04             	sub    $0x4,%esp
  8019b4:	50                   	push   %eax
  8019b5:	ff 75 0c             	pushl  0xc(%ebp)
  8019b8:	ff 75 08             	pushl  0x8(%ebp)
  8019bb:	e8 3f 03 00 00       	call   801cff <sys_getSharedObject>
  8019c0:	83 c4 10             	add    $0x10,%esp
  8019c3:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  8019c6:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  8019ca:	78 12                	js     8019de <sget+0x181>
		shardIDs[startPage] = ss;
  8019cc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8019cf:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8019d2:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  8019d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019dc:	eb 14                	jmp    8019f2 <sget+0x195>
	}
	free((void*) start);
  8019de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e1:	83 ec 0c             	sub    $0xc,%esp
  8019e4:	50                   	push   %eax
  8019e5:	e8 d7 fb ff ff       	call   8015c1 <free>
  8019ea:	83 c4 10             	add    $0x10,%esp
	return NULL;
  8019ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
  8019f7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8019fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8019fd:	a1 20 50 80 00       	mov    0x805020,%eax
  801a02:	8b 40 7c             	mov    0x7c(%eax),%eax
  801a05:	29 c2                	sub    %eax,%edx
  801a07:	89 d0                	mov    %edx,%eax
  801a09:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  801a0e:	c1 e8 0c             	shr    $0xc,%eax
  801a11:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  801a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a17:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  801a1e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  801a21:	83 ec 08             	sub    $0x8,%esp
  801a24:	ff 75 08             	pushl  0x8(%ebp)
  801a27:	ff 75 f0             	pushl  -0x10(%ebp)
  801a2a:	e8 ef 02 00 00       	call   801d1e <sys_freeSharedObject>
  801a2f:	83 c4 10             	add    $0x10,%esp
  801a32:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  801a35:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a39:	75 0e                	jne    801a49 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  801a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3e:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  801a45:	ff ff ff ff 
	}

}
  801a49:	90                   	nop
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a52:	83 ec 04             	sub    $0x4,%esp
  801a55:	68 60 3e 80 00       	push   $0x803e60
  801a5a:	68 19 01 00 00       	push   $0x119
  801a5f:	68 52 3e 80 00       	push   $0x803e52
  801a64:	e8 35 e9 ff ff       	call   80039e <_panic>

00801a69 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a6f:	83 ec 04             	sub    $0x4,%esp
  801a72:	68 86 3e 80 00       	push   $0x803e86
  801a77:	68 23 01 00 00       	push   $0x123
  801a7c:	68 52 3e 80 00       	push   $0x803e52
  801a81:	e8 18 e9 ff ff       	call   80039e <_panic>

00801a86 <shrink>:

}
void shrink(uint32 newSize) {
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a8c:	83 ec 04             	sub    $0x4,%esp
  801a8f:	68 86 3e 80 00       	push   $0x803e86
  801a94:	68 27 01 00 00       	push   $0x127
  801a99:	68 52 3e 80 00       	push   $0x803e52
  801a9e:	e8 fb e8 ff ff       	call   80039e <_panic>

00801aa3 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aa9:	83 ec 04             	sub    $0x4,%esp
  801aac:	68 86 3e 80 00       	push   $0x803e86
  801ab1:	68 2b 01 00 00       	push   $0x12b
  801ab6:	68 52 3e 80 00       	push   $0x803e52
  801abb:	e8 de e8 ff ff       	call   80039e <_panic>

00801ac0 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	57                   	push   %edi
  801ac4:	56                   	push   %esi
  801ac5:	53                   	push   %ebx
  801ac6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ad2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ad5:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ad8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801adb:	cd 30                	int    $0x30
  801add:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ae3:	83 c4 10             	add    $0x10,%esp
  801ae6:	5b                   	pop    %ebx
  801ae7:	5e                   	pop    %esi
  801ae8:	5f                   	pop    %edi
  801ae9:	5d                   	pop    %ebp
  801aea:	c3                   	ret    

00801aeb <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	83 ec 04             	sub    $0x4,%esp
  801af1:	8b 45 10             	mov    0x10(%ebp),%eax
  801af4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801af7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	52                   	push   %edx
  801b03:	ff 75 0c             	pushl  0xc(%ebp)
  801b06:	50                   	push   %eax
  801b07:	6a 00                	push   $0x0
  801b09:	e8 b2 ff ff ff       	call   801ac0 <syscall>
  801b0e:	83 c4 18             	add    $0x18,%esp
}
  801b11:	90                   	nop
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_cgetc>:

int sys_cgetc(void) {
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 02                	push   $0x2
  801b23:	e8 98 ff ff ff       	call   801ac0 <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
}
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <sys_lock_cons>:

void sys_lock_cons(void) {
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 03                	push   $0x3
  801b3c:	e8 7f ff ff ff       	call   801ac0 <syscall>
  801b41:	83 c4 18             	add    $0x18,%esp
}
  801b44:	90                   	nop
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    

00801b47 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 04                	push   $0x4
  801b56:	e8 65 ff ff ff       	call   801ac0 <syscall>
  801b5b:	83 c4 18             	add    $0x18,%esp
}
  801b5e:	90                   	nop
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	52                   	push   %edx
  801b71:	50                   	push   %eax
  801b72:	6a 08                	push   $0x8
  801b74:	e8 47 ff ff ff       	call   801ac0 <syscall>
  801b79:	83 c4 18             	add    $0x18,%esp
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	56                   	push   %esi
  801b82:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801b83:	8b 75 18             	mov    0x18(%ebp),%esi
  801b86:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b89:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	56                   	push   %esi
  801b93:	53                   	push   %ebx
  801b94:	51                   	push   %ecx
  801b95:	52                   	push   %edx
  801b96:	50                   	push   %eax
  801b97:	6a 09                	push   $0x9
  801b99:	e8 22 ff ff ff       	call   801ac0 <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801ba1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba4:	5b                   	pop    %ebx
  801ba5:	5e                   	pop    %esi
  801ba6:	5d                   	pop    %ebp
  801ba7:	c3                   	ret    

00801ba8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	52                   	push   %edx
  801bb8:	50                   	push   %eax
  801bb9:	6a 0a                	push   $0xa
  801bbb:	e8 00 ff ff ff       	call   801ac0 <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	ff 75 0c             	pushl  0xc(%ebp)
  801bd1:	ff 75 08             	pushl  0x8(%ebp)
  801bd4:	6a 0b                	push   $0xb
  801bd6:	e8 e5 fe ff ff       	call   801ac0 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 0c                	push   $0xc
  801bef:	e8 cc fe ff ff       	call   801ac0 <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 0d                	push   $0xd
  801c08:	e8 b3 fe ff ff       	call   801ac0 <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 0e                	push   $0xe
  801c21:	e8 9a fe ff ff       	call   801ac0 <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 0f                	push   $0xf
  801c3a:	e8 81 fe ff ff       	call   801ac0 <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	ff 75 08             	pushl  0x8(%ebp)
  801c52:	6a 10                	push   $0x10
  801c54:	e8 67 fe ff ff       	call   801ac0 <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <sys_scarce_memory>:

void sys_scarce_memory() {
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 11                	push   $0x11
  801c6d:	e8 4e fe ff ff       	call   801ac0 <syscall>
  801c72:	83 c4 18             	add    $0x18,%esp
}
  801c75:	90                   	nop
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_cputc>:

void sys_cputc(const char c) {
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
  801c7b:	83 ec 04             	sub    $0x4,%esp
  801c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c81:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c84:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	50                   	push   %eax
  801c91:	6a 01                	push   $0x1
  801c93:	e8 28 fe ff ff       	call   801ac0 <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
}
  801c9b:	90                   	nop
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 14                	push   $0x14
  801cad:	e8 0e fe ff ff       	call   801ac0 <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
}
  801cb5:	90                   	nop
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	83 ec 04             	sub    $0x4,%esp
  801cbe:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801cc4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cc7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	6a 00                	push   $0x0
  801cd0:	51                   	push   %ecx
  801cd1:	52                   	push   %edx
  801cd2:	ff 75 0c             	pushl  0xc(%ebp)
  801cd5:	50                   	push   %eax
  801cd6:	6a 15                	push   $0x15
  801cd8:	e8 e3 fd ff ff       	call   801ac0 <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801ce5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	52                   	push   %edx
  801cf2:	50                   	push   %eax
  801cf3:	6a 16                	push   $0x16
  801cf5:	e8 c6 fd ff ff       	call   801ac0 <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801d02:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d08:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	51                   	push   %ecx
  801d10:	52                   	push   %edx
  801d11:	50                   	push   %eax
  801d12:	6a 17                	push   $0x17
  801d14:	e8 a7 fd ff ff       	call   801ac0 <syscall>
  801d19:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    

00801d1e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801d21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d24:	8b 45 08             	mov    0x8(%ebp),%eax
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	52                   	push   %edx
  801d2e:	50                   	push   %eax
  801d2f:	6a 18                	push   $0x18
  801d31:	e8 8a fd ff ff       	call   801ac0 <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d41:	6a 00                	push   $0x0
  801d43:	ff 75 14             	pushl  0x14(%ebp)
  801d46:	ff 75 10             	pushl  0x10(%ebp)
  801d49:	ff 75 0c             	pushl  0xc(%ebp)
  801d4c:	50                   	push   %eax
  801d4d:	6a 19                	push   $0x19
  801d4f:	e8 6c fd ff ff       	call   801ac0 <syscall>
  801d54:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <sys_run_env>:

void sys_run_env(int32 envId) {
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	50                   	push   %eax
  801d68:	6a 1a                	push   $0x1a
  801d6a:	e8 51 fd ff ff       	call   801ac0 <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
}
  801d72:	90                   	nop
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d78:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	50                   	push   %eax
  801d84:	6a 1b                	push   $0x1b
  801d86:	e8 35 fd ff ff       	call   801ac0 <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <sys_getenvid>:

int32 sys_getenvid(void) {
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 05                	push   $0x5
  801d9f:	e8 1c fd ff ff       	call   801ac0 <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 06                	push   $0x6
  801db8:	e8 03 fd ff ff       	call   801ac0 <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 07                	push   $0x7
  801dd1:	e8 ea fc ff ff       	call   801ac0 <syscall>
  801dd6:	83 c4 18             	add    $0x18,%esp
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <sys_exit_env>:

void sys_exit_env(void) {
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 1c                	push   $0x1c
  801dea:	e8 d1 fc ff ff       	call   801ac0 <syscall>
  801def:	83 c4 18             	add    $0x18,%esp
}
  801df2:	90                   	nop
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801dfb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dfe:	8d 50 04             	lea    0x4(%eax),%edx
  801e01:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	52                   	push   %edx
  801e0b:	50                   	push   %eax
  801e0c:	6a 1d                	push   $0x1d
  801e0e:	e8 ad fc ff ff       	call   801ac0 <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801e16:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e1c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e1f:	89 01                	mov    %eax,(%ecx)
  801e21:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	c9                   	leave  
  801e28:	c2 04 00             	ret    $0x4

00801e2b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	ff 75 10             	pushl  0x10(%ebp)
  801e35:	ff 75 0c             	pushl  0xc(%ebp)
  801e38:	ff 75 08             	pushl  0x8(%ebp)
  801e3b:	6a 13                	push   $0x13
  801e3d:	e8 7e fc ff ff       	call   801ac0 <syscall>
  801e42:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801e45:	90                   	nop
}
  801e46:	c9                   	leave  
  801e47:	c3                   	ret    

00801e48 <sys_rcr2>:
uint32 sys_rcr2() {
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 1e                	push   $0x1e
  801e57:	e8 64 fc ff ff       	call   801ac0 <syscall>
  801e5c:	83 c4 18             	add    $0x18,%esp
}
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    

00801e61 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
  801e64:	83 ec 04             	sub    $0x4,%esp
  801e67:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e6d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	50                   	push   %eax
  801e7a:	6a 1f                	push   $0x1f
  801e7c:	e8 3f fc ff ff       	call   801ac0 <syscall>
  801e81:	83 c4 18             	add    $0x18,%esp
	return;
  801e84:	90                   	nop
}
  801e85:	c9                   	leave  
  801e86:	c3                   	ret    

00801e87 <rsttst>:
void rsttst() {
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 21                	push   $0x21
  801e96:	e8 25 fc ff ff       	call   801ac0 <syscall>
  801e9b:	83 c4 18             	add    $0x18,%esp
	return;
  801e9e:	90                   	nop
}
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
  801ea4:	83 ec 04             	sub    $0x4,%esp
  801ea7:	8b 45 14             	mov    0x14(%ebp),%eax
  801eaa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ead:	8b 55 18             	mov    0x18(%ebp),%edx
  801eb0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801eb4:	52                   	push   %edx
  801eb5:	50                   	push   %eax
  801eb6:	ff 75 10             	pushl  0x10(%ebp)
  801eb9:	ff 75 0c             	pushl  0xc(%ebp)
  801ebc:	ff 75 08             	pushl  0x8(%ebp)
  801ebf:	6a 20                	push   $0x20
  801ec1:	e8 fa fb ff ff       	call   801ac0 <syscall>
  801ec6:	83 c4 18             	add    $0x18,%esp
	return;
  801ec9:	90                   	nop
}
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <chktst>:
void chktst(uint32 n) {
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	ff 75 08             	pushl  0x8(%ebp)
  801eda:	6a 22                	push   $0x22
  801edc:	e8 df fb ff ff       	call   801ac0 <syscall>
  801ee1:	83 c4 18             	add    $0x18,%esp
	return;
  801ee4:	90                   	nop
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <inctst>:

void inctst() {
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 23                	push   $0x23
  801ef6:	e8 c5 fb ff ff       	call   801ac0 <syscall>
  801efb:	83 c4 18             	add    $0x18,%esp
	return;
  801efe:	90                   	nop
}
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <gettst>:
uint32 gettst() {
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 24                	push   $0x24
  801f10:	e8 ab fb ff ff       	call   801ac0 <syscall>
  801f15:	83 c4 18             	add    $0x18,%esp
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 25                	push   $0x25
  801f2c:	e8 8f fb ff ff       	call   801ac0 <syscall>
  801f31:	83 c4 18             	add    $0x18,%esp
  801f34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f37:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f3b:	75 07                	jne    801f44 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f42:	eb 05                	jmp    801f49 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f49:	c9                   	leave  
  801f4a:	c3                   	ret    

00801f4b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
  801f4e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 25                	push   $0x25
  801f5d:	e8 5e fb ff ff       	call   801ac0 <syscall>
  801f62:	83 c4 18             	add    $0x18,%esp
  801f65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f68:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f6c:	75 07                	jne    801f75 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f73:	eb 05                	jmp    801f7a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
  801f7f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 25                	push   $0x25
  801f8e:	e8 2d fb ff ff       	call   801ac0 <syscall>
  801f93:	83 c4 18             	add    $0x18,%esp
  801f96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f99:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f9d:	75 07                	jne    801fa6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f9f:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa4:	eb 05                	jmp    801fab <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
  801fb0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 25                	push   $0x25
  801fbf:	e8 fc fa ff ff       	call   801ac0 <syscall>
  801fc4:	83 c4 18             	add    $0x18,%esp
  801fc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fca:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fce:	75 07                	jne    801fd7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fd0:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd5:	eb 05                	jmp    801fdc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fdc:	c9                   	leave  
  801fdd:	c3                   	ret    

00801fde <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	ff 75 08             	pushl  0x8(%ebp)
  801fec:	6a 26                	push   $0x26
  801fee:	e8 cd fa ff ff       	call   801ac0 <syscall>
  801ff3:	83 c4 18             	add    $0x18,%esp
	return;
  801ff6:	90                   	nop
}
  801ff7:	c9                   	leave  
  801ff8:	c3                   	ret    

00801ff9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801ffd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802000:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802003:	8b 55 0c             	mov    0xc(%ebp),%edx
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	6a 00                	push   $0x0
  80200b:	53                   	push   %ebx
  80200c:	51                   	push   %ecx
  80200d:	52                   	push   %edx
  80200e:	50                   	push   %eax
  80200f:	6a 27                	push   $0x27
  802011:	e8 aa fa ff ff       	call   801ac0 <syscall>
  802016:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  802019:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  802021:	8b 55 0c             	mov    0xc(%ebp),%edx
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	52                   	push   %edx
  80202e:	50                   	push   %eax
  80202f:	6a 28                	push   $0x28
  802031:	e8 8a fa ff ff       	call   801ac0 <syscall>
  802036:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  802039:	c9                   	leave  
  80203a:	c3                   	ret    

0080203b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  80203e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802041:	8b 55 0c             	mov    0xc(%ebp),%edx
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	6a 00                	push   $0x0
  802049:	51                   	push   %ecx
  80204a:	ff 75 10             	pushl  0x10(%ebp)
  80204d:	52                   	push   %edx
  80204e:	50                   	push   %eax
  80204f:	6a 29                	push   $0x29
  802051:	e8 6a fa ff ff       	call   801ac0 <syscall>
  802056:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	ff 75 10             	pushl  0x10(%ebp)
  802065:	ff 75 0c             	pushl  0xc(%ebp)
  802068:	ff 75 08             	pushl  0x8(%ebp)
  80206b:	6a 12                	push   $0x12
  80206d:	e8 4e fa ff ff       	call   801ac0 <syscall>
  802072:	83 c4 18             	add    $0x18,%esp
	return;
  802075:	90                   	nop
}
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  80207b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	52                   	push   %edx
  802088:	50                   	push   %eax
  802089:	6a 2a                	push   $0x2a
  80208b:	e8 30 fa ff ff       	call   801ac0 <syscall>
  802090:	83 c4 18             	add    $0x18,%esp
	return;
  802093:	90                   	nop
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  802099:	8b 45 08             	mov    0x8(%ebp),%eax
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	50                   	push   %eax
  8020a5:	6a 2b                	push   $0x2b
  8020a7:	e8 14 fa ff ff       	call   801ac0 <syscall>
  8020ac:	83 c4 18             	add    $0x18,%esp
}
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	ff 75 0c             	pushl  0xc(%ebp)
  8020bd:	ff 75 08             	pushl  0x8(%ebp)
  8020c0:	6a 2c                	push   $0x2c
  8020c2:	e8 f9 f9 ff ff       	call   801ac0 <syscall>
  8020c7:	83 c4 18             	add    $0x18,%esp
	return;
  8020ca:	90                   	nop
}
  8020cb:	c9                   	leave  
  8020cc:	c3                   	ret    

008020cd <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	ff 75 0c             	pushl  0xc(%ebp)
  8020d9:	ff 75 08             	pushl  0x8(%ebp)
  8020dc:	6a 2d                	push   $0x2d
  8020de:	e8 dd f9 ff ff       	call   801ac0 <syscall>
  8020e3:	83 c4 18             	add    $0x18,%esp
	return;
  8020e6:	90                   	nop
}
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	50                   	push   %eax
  8020f8:	6a 2f                	push   $0x2f
  8020fa:	e8 c1 f9 ff ff       	call   801ac0 <syscall>
  8020ff:	83 c4 18             	add    $0x18,%esp
	return;
  802102:	90                   	nop
}
  802103:	c9                   	leave  
  802104:	c3                   	ret    

00802105 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  802108:	8b 55 0c             	mov    0xc(%ebp),%edx
  80210b:	8b 45 08             	mov    0x8(%ebp),%eax
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	52                   	push   %edx
  802115:	50                   	push   %eax
  802116:	6a 30                	push   $0x30
  802118:	e8 a3 f9 ff ff       	call   801ac0 <syscall>
  80211d:	83 c4 18             	add    $0x18,%esp
	return;
  802120:	90                   	nop
}
  802121:	c9                   	leave  
  802122:	c3                   	ret    

00802123 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  802126:	8b 45 08             	mov    0x8(%ebp),%eax
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	50                   	push   %eax
  802132:	6a 31                	push   $0x31
  802134:	e8 87 f9 ff ff       	call   801ac0 <syscall>
  802139:	83 c4 18             	add    $0x18,%esp
	return;
  80213c:	90                   	nop
}
  80213d:	c9                   	leave  
  80213e:	c3                   	ret    

0080213f <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802142:	8b 55 0c             	mov    0xc(%ebp),%edx
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	52                   	push   %edx
  80214f:	50                   	push   %eax
  802150:	6a 2e                	push   $0x2e
  802152:	e8 69 f9 ff ff       	call   801ac0 <syscall>
  802157:	83 c4 18             	add    $0x18,%esp
    return;
  80215a:	90                   	nop
}
  80215b:	c9                   	leave  
  80215c:	c3                   	ret    

0080215d <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
  802160:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	83 e8 04             	sub    $0x4,%eax
  802169:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80216c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80216f:	8b 00                	mov    (%eax),%eax
  802171:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
  802179:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	83 e8 04             	sub    $0x4,%eax
  802182:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802185:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802188:	8b 00                	mov    (%eax),%eax
  80218a:	83 e0 01             	and    $0x1,%eax
  80218d:	85 c0                	test   %eax,%eax
  80218f:	0f 94 c0             	sete   %al
}
  802192:	c9                   	leave  
  802193:	c3                   	ret    

00802194 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
  802197:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80219a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8021a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a4:	83 f8 02             	cmp    $0x2,%eax
  8021a7:	74 2b                	je     8021d4 <alloc_block+0x40>
  8021a9:	83 f8 02             	cmp    $0x2,%eax
  8021ac:	7f 07                	jg     8021b5 <alloc_block+0x21>
  8021ae:	83 f8 01             	cmp    $0x1,%eax
  8021b1:	74 0e                	je     8021c1 <alloc_block+0x2d>
  8021b3:	eb 58                	jmp    80220d <alloc_block+0x79>
  8021b5:	83 f8 03             	cmp    $0x3,%eax
  8021b8:	74 2d                	je     8021e7 <alloc_block+0x53>
  8021ba:	83 f8 04             	cmp    $0x4,%eax
  8021bd:	74 3b                	je     8021fa <alloc_block+0x66>
  8021bf:	eb 4c                	jmp    80220d <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8021c1:	83 ec 0c             	sub    $0xc,%esp
  8021c4:	ff 75 08             	pushl  0x8(%ebp)
  8021c7:	e8 f7 03 00 00       	call   8025c3 <alloc_block_FF>
  8021cc:	83 c4 10             	add    $0x10,%esp
  8021cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021d2:	eb 4a                	jmp    80221e <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8021d4:	83 ec 0c             	sub    $0xc,%esp
  8021d7:	ff 75 08             	pushl  0x8(%ebp)
  8021da:	e8 f0 11 00 00       	call   8033cf <alloc_block_NF>
  8021df:	83 c4 10             	add    $0x10,%esp
  8021e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021e5:	eb 37                	jmp    80221e <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8021e7:	83 ec 0c             	sub    $0xc,%esp
  8021ea:	ff 75 08             	pushl  0x8(%ebp)
  8021ed:	e8 08 08 00 00       	call   8029fa <alloc_block_BF>
  8021f2:	83 c4 10             	add    $0x10,%esp
  8021f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021f8:	eb 24                	jmp    80221e <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8021fa:	83 ec 0c             	sub    $0xc,%esp
  8021fd:	ff 75 08             	pushl  0x8(%ebp)
  802200:	e8 ad 11 00 00       	call   8033b2 <alloc_block_WF>
  802205:	83 c4 10             	add    $0x10,%esp
  802208:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80220b:	eb 11                	jmp    80221e <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80220d:	83 ec 0c             	sub    $0xc,%esp
  802210:	68 98 3e 80 00       	push   $0x803e98
  802215:	e8 41 e4 ff ff       	call   80065b <cprintf>
  80221a:	83 c4 10             	add    $0x10,%esp
		break;
  80221d:	90                   	nop
	}
	return va;
  80221e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802221:	c9                   	leave  
  802222:	c3                   	ret    

00802223 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
  802226:	53                   	push   %ebx
  802227:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80222a:	83 ec 0c             	sub    $0xc,%esp
  80222d:	68 b8 3e 80 00       	push   $0x803eb8
  802232:	e8 24 e4 ff ff       	call   80065b <cprintf>
  802237:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80223a:	83 ec 0c             	sub    $0xc,%esp
  80223d:	68 e3 3e 80 00       	push   $0x803ee3
  802242:	e8 14 e4 ff ff       	call   80065b <cprintf>
  802247:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802250:	eb 37                	jmp    802289 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802252:	83 ec 0c             	sub    $0xc,%esp
  802255:	ff 75 f4             	pushl  -0xc(%ebp)
  802258:	e8 19 ff ff ff       	call   802176 <is_free_block>
  80225d:	83 c4 10             	add    $0x10,%esp
  802260:	0f be d8             	movsbl %al,%ebx
  802263:	83 ec 0c             	sub    $0xc,%esp
  802266:	ff 75 f4             	pushl  -0xc(%ebp)
  802269:	e8 ef fe ff ff       	call   80215d <get_block_size>
  80226e:	83 c4 10             	add    $0x10,%esp
  802271:	83 ec 04             	sub    $0x4,%esp
  802274:	53                   	push   %ebx
  802275:	50                   	push   %eax
  802276:	68 fb 3e 80 00       	push   $0x803efb
  80227b:	e8 db e3 ff ff       	call   80065b <cprintf>
  802280:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802283:	8b 45 10             	mov    0x10(%ebp),%eax
  802286:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802289:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80228d:	74 07                	je     802296 <print_blocks_list+0x73>
  80228f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802292:	8b 00                	mov    (%eax),%eax
  802294:	eb 05                	jmp    80229b <print_blocks_list+0x78>
  802296:	b8 00 00 00 00       	mov    $0x0,%eax
  80229b:	89 45 10             	mov    %eax,0x10(%ebp)
  80229e:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a1:	85 c0                	test   %eax,%eax
  8022a3:	75 ad                	jne    802252 <print_blocks_list+0x2f>
  8022a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a9:	75 a7                	jne    802252 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8022ab:	83 ec 0c             	sub    $0xc,%esp
  8022ae:	68 b8 3e 80 00       	push   $0x803eb8
  8022b3:	e8 a3 e3 ff ff       	call   80065b <cprintf>
  8022b8:	83 c4 10             	add    $0x10,%esp

}
  8022bb:	90                   	nop
  8022bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022bf:	c9                   	leave  
  8022c0:	c3                   	ret    

008022c1 <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
  8022c4:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8022c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ca:	83 e0 01             	and    $0x1,%eax
  8022cd:	85 c0                	test   %eax,%eax
  8022cf:	74 03                	je     8022d4 <initialize_dynamic_allocator+0x13>
  8022d1:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  8022d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022d8:	0f 84 f8 00 00 00    	je     8023d6 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  8022de:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  8022e5:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  8022e8:	a1 40 50 98 00       	mov    0x985040,%eax
  8022ed:	85 c0                	test   %eax,%eax
  8022ef:	0f 84 e2 00 00 00    	je     8023d7 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8022fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fe:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  802304:	8b 55 08             	mov    0x8(%ebp),%edx
  802307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80230a:	01 d0                	add    %edx,%eax
  80230c:	83 e8 04             	sub    $0x4,%eax
  80230f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802312:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802315:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	83 c0 08             	add    $0x8,%eax
  802321:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  802324:	8b 45 0c             	mov    0xc(%ebp),%eax
  802327:	83 e8 08             	sub    $0x8,%eax
  80232a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  80232d:	83 ec 04             	sub    $0x4,%esp
  802330:	6a 00                	push   $0x0
  802332:	ff 75 e8             	pushl  -0x18(%ebp)
  802335:	ff 75 ec             	pushl  -0x14(%ebp)
  802338:	e8 9c 00 00 00       	call   8023d9 <set_block_data>
  80233d:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  802340:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802343:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802349:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80234c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  802353:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  80235a:	00 00 00 
  80235d:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  802364:	00 00 00 
  802367:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  80236e:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  802371:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802375:	75 17                	jne    80238e <initialize_dynamic_allocator+0xcd>
  802377:	83 ec 04             	sub    $0x4,%esp
  80237a:	68 14 3f 80 00       	push   $0x803f14
  80237f:	68 80 00 00 00       	push   $0x80
  802384:	68 37 3f 80 00       	push   $0x803f37
  802389:	e8 10 e0 ff ff       	call   80039e <_panic>
  80238e:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802394:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802397:	89 10                	mov    %edx,(%eax)
  802399:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239c:	8b 00                	mov    (%eax),%eax
  80239e:	85 c0                	test   %eax,%eax
  8023a0:	74 0d                	je     8023af <initialize_dynamic_allocator+0xee>
  8023a2:	a1 48 50 98 00       	mov    0x985048,%eax
  8023a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023aa:	89 50 04             	mov    %edx,0x4(%eax)
  8023ad:	eb 08                	jmp    8023b7 <initialize_dynamic_allocator+0xf6>
  8023af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b2:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8023b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ba:	a3 48 50 98 00       	mov    %eax,0x985048
  8023bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023c9:	a1 54 50 98 00       	mov    0x985054,%eax
  8023ce:	40                   	inc    %eax
  8023cf:	a3 54 50 98 00       	mov    %eax,0x985054
  8023d4:	eb 01                	jmp    8023d7 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  8023d6:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  8023d7:	c9                   	leave  
  8023d8:	c3                   	ret    

008023d9 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
  8023dc:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  8023df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e2:	83 e0 01             	and    $0x1,%eax
  8023e5:	85 c0                	test   %eax,%eax
  8023e7:	74 03                	je     8023ec <set_block_data+0x13>
	{
		totalSize++;
  8023e9:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  8023ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ef:	83 e8 04             	sub    $0x4,%eax
  8023f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  8023f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f8:	83 e0 fe             	and    $0xfffffffe,%eax
  8023fb:	89 c2                	mov    %eax,%edx
  8023fd:	8b 45 10             	mov    0x10(%ebp),%eax
  802400:	83 e0 01             	and    $0x1,%eax
  802403:	09 c2                	or     %eax,%edx
  802405:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802408:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  80240a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80240d:	8d 50 f8             	lea    -0x8(%eax),%edx
  802410:	8b 45 08             	mov    0x8(%ebp),%eax
  802413:	01 d0                	add    %edx,%eax
  802415:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  802418:	8b 45 0c             	mov    0xc(%ebp),%eax
  80241b:	83 e0 fe             	and    $0xfffffffe,%eax
  80241e:	89 c2                	mov    %eax,%edx
  802420:	8b 45 10             	mov    0x10(%ebp),%eax
  802423:	83 e0 01             	and    $0x1,%eax
  802426:	09 c2                	or     %eax,%edx
  802428:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80242b:	89 10                	mov    %edx,(%eax)
}
  80242d:	90                   	nop
  80242e:	c9                   	leave  
  80242f:	c3                   	ret    

00802430 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  802430:	55                   	push   %ebp
  802431:	89 e5                	mov    %esp,%ebp
  802433:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  802436:	a1 48 50 98 00       	mov    0x985048,%eax
  80243b:	85 c0                	test   %eax,%eax
  80243d:	75 68                	jne    8024a7 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  80243f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802443:	75 17                	jne    80245c <insert_sorted_in_freeList+0x2c>
  802445:	83 ec 04             	sub    $0x4,%esp
  802448:	68 14 3f 80 00       	push   $0x803f14
  80244d:	68 9d 00 00 00       	push   $0x9d
  802452:	68 37 3f 80 00       	push   $0x803f37
  802457:	e8 42 df ff ff       	call   80039e <_panic>
  80245c:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802462:	8b 45 08             	mov    0x8(%ebp),%eax
  802465:	89 10                	mov    %edx,(%eax)
  802467:	8b 45 08             	mov    0x8(%ebp),%eax
  80246a:	8b 00                	mov    (%eax),%eax
  80246c:	85 c0                	test   %eax,%eax
  80246e:	74 0d                	je     80247d <insert_sorted_in_freeList+0x4d>
  802470:	a1 48 50 98 00       	mov    0x985048,%eax
  802475:	8b 55 08             	mov    0x8(%ebp),%edx
  802478:	89 50 04             	mov    %edx,0x4(%eax)
  80247b:	eb 08                	jmp    802485 <insert_sorted_in_freeList+0x55>
  80247d:	8b 45 08             	mov    0x8(%ebp),%eax
  802480:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802485:	8b 45 08             	mov    0x8(%ebp),%eax
  802488:	a3 48 50 98 00       	mov    %eax,0x985048
  80248d:	8b 45 08             	mov    0x8(%ebp),%eax
  802490:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802497:	a1 54 50 98 00       	mov    0x985054,%eax
  80249c:	40                   	inc    %eax
  80249d:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  8024a2:	e9 1a 01 00 00       	jmp    8025c1 <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8024a7:	a1 48 50 98 00       	mov    0x985048,%eax
  8024ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024af:	eb 7f                	jmp    802530 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024b7:	76 6f                	jbe    802528 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  8024b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024bd:	74 06                	je     8024c5 <insert_sorted_in_freeList+0x95>
  8024bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024c3:	75 17                	jne    8024dc <insert_sorted_in_freeList+0xac>
  8024c5:	83 ec 04             	sub    $0x4,%esp
  8024c8:	68 50 3f 80 00       	push   $0x803f50
  8024cd:	68 a6 00 00 00       	push   $0xa6
  8024d2:	68 37 3f 80 00       	push   $0x803f37
  8024d7:	e8 c2 de ff ff       	call   80039e <_panic>
  8024dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024df:	8b 50 04             	mov    0x4(%eax),%edx
  8024e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e5:	89 50 04             	mov    %edx,0x4(%eax)
  8024e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ee:	89 10                	mov    %edx,(%eax)
  8024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f3:	8b 40 04             	mov    0x4(%eax),%eax
  8024f6:	85 c0                	test   %eax,%eax
  8024f8:	74 0d                	je     802507 <insert_sorted_in_freeList+0xd7>
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	8b 40 04             	mov    0x4(%eax),%eax
  802500:	8b 55 08             	mov    0x8(%ebp),%edx
  802503:	89 10                	mov    %edx,(%eax)
  802505:	eb 08                	jmp    80250f <insert_sorted_in_freeList+0xdf>
  802507:	8b 45 08             	mov    0x8(%ebp),%eax
  80250a:	a3 48 50 98 00       	mov    %eax,0x985048
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	8b 55 08             	mov    0x8(%ebp),%edx
  802515:	89 50 04             	mov    %edx,0x4(%eax)
  802518:	a1 54 50 98 00       	mov    0x985054,%eax
  80251d:	40                   	inc    %eax
  80251e:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  802523:	e9 99 00 00 00       	jmp    8025c1 <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802528:	a1 50 50 98 00       	mov    0x985050,%eax
  80252d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802530:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802534:	74 07                	je     80253d <insert_sorted_in_freeList+0x10d>
  802536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802539:	8b 00                	mov    (%eax),%eax
  80253b:	eb 05                	jmp    802542 <insert_sorted_in_freeList+0x112>
  80253d:	b8 00 00 00 00       	mov    $0x0,%eax
  802542:	a3 50 50 98 00       	mov    %eax,0x985050
  802547:	a1 50 50 98 00       	mov    0x985050,%eax
  80254c:	85 c0                	test   %eax,%eax
  80254e:	0f 85 5d ff ff ff    	jne    8024b1 <insert_sorted_in_freeList+0x81>
  802554:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802558:	0f 85 53 ff ff ff    	jne    8024b1 <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  80255e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802562:	75 17                	jne    80257b <insert_sorted_in_freeList+0x14b>
  802564:	83 ec 04             	sub    $0x4,%esp
  802567:	68 88 3f 80 00       	push   $0x803f88
  80256c:	68 ab 00 00 00       	push   $0xab
  802571:	68 37 3f 80 00       	push   $0x803f37
  802576:	e8 23 de ff ff       	call   80039e <_panic>
  80257b:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  802581:	8b 45 08             	mov    0x8(%ebp),%eax
  802584:	89 50 04             	mov    %edx,0x4(%eax)
  802587:	8b 45 08             	mov    0x8(%ebp),%eax
  80258a:	8b 40 04             	mov    0x4(%eax),%eax
  80258d:	85 c0                	test   %eax,%eax
  80258f:	74 0c                	je     80259d <insert_sorted_in_freeList+0x16d>
  802591:	a1 4c 50 98 00       	mov    0x98504c,%eax
  802596:	8b 55 08             	mov    0x8(%ebp),%edx
  802599:	89 10                	mov    %edx,(%eax)
  80259b:	eb 08                	jmp    8025a5 <insert_sorted_in_freeList+0x175>
  80259d:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a0:	a3 48 50 98 00       	mov    %eax,0x985048
  8025a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a8:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8025ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b6:	a1 54 50 98 00       	mov    0x985054,%eax
  8025bb:	40                   	inc    %eax
  8025bc:	a3 54 50 98 00       	mov    %eax,0x985054
}
  8025c1:	c9                   	leave  
  8025c2:	c3                   	ret    

008025c3 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8025c3:	55                   	push   %ebp
  8025c4:	89 e5                	mov    %esp,%ebp
  8025c6:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8025c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cc:	83 e0 01             	and    $0x1,%eax
  8025cf:	85 c0                	test   %eax,%eax
  8025d1:	74 03                	je     8025d6 <alloc_block_FF+0x13>
  8025d3:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8025d6:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8025da:	77 07                	ja     8025e3 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8025dc:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8025e3:	a1 40 50 98 00       	mov    0x985040,%eax
  8025e8:	85 c0                	test   %eax,%eax
  8025ea:	75 63                	jne    80264f <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8025ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ef:	83 c0 10             	add    $0x10,%eax
  8025f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8025f5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8025fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802602:	01 d0                	add    %edx,%eax
  802604:	48                   	dec    %eax
  802605:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802608:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80260b:	ba 00 00 00 00       	mov    $0x0,%edx
  802610:	f7 75 ec             	divl   -0x14(%ebp)
  802613:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802616:	29 d0                	sub    %edx,%eax
  802618:	c1 e8 0c             	shr    $0xc,%eax
  80261b:	83 ec 0c             	sub    $0xc,%esp
  80261e:	50                   	push   %eax
  80261f:	e8 d1 ed ff ff       	call   8013f5 <sbrk>
  802624:	83 c4 10             	add    $0x10,%esp
  802627:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80262a:	83 ec 0c             	sub    $0xc,%esp
  80262d:	6a 00                	push   $0x0
  80262f:	e8 c1 ed ff ff       	call   8013f5 <sbrk>
  802634:	83 c4 10             	add    $0x10,%esp
  802637:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80263a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80263d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802640:	83 ec 08             	sub    $0x8,%esp
  802643:	50                   	push   %eax
  802644:	ff 75 e4             	pushl  -0x1c(%ebp)
  802647:	e8 75 fc ff ff       	call   8022c1 <initialize_dynamic_allocator>
  80264c:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  80264f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802653:	75 0a                	jne    80265f <alloc_block_FF+0x9c>
	{
		return NULL;
  802655:	b8 00 00 00 00       	mov    $0x0,%eax
  80265a:	e9 99 03 00 00       	jmp    8029f8 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  80265f:	8b 45 08             	mov    0x8(%ebp),%eax
  802662:	83 c0 08             	add    $0x8,%eax
  802665:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802668:	a1 48 50 98 00       	mov    0x985048,%eax
  80266d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802670:	e9 03 02 00 00       	jmp    802878 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802675:	83 ec 0c             	sub    $0xc,%esp
  802678:	ff 75 f4             	pushl  -0xc(%ebp)
  80267b:	e8 dd fa ff ff       	call   80215d <get_block_size>
  802680:	83 c4 10             	add    $0x10,%esp
  802683:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802686:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802689:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80268c:	0f 82 de 01 00 00    	jb     802870 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  802692:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802695:	83 c0 10             	add    $0x10,%eax
  802698:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  80269b:	0f 87 32 01 00 00    	ja     8027d3 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  8026a1:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8026a4:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8026a7:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  8026aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026b0:	01 d0                	add    %edx,%eax
  8026b2:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  8026b5:	83 ec 04             	sub    $0x4,%esp
  8026b8:	6a 00                	push   $0x0
  8026ba:	ff 75 98             	pushl  -0x68(%ebp)
  8026bd:	ff 75 94             	pushl  -0x6c(%ebp)
  8026c0:	e8 14 fd ff ff       	call   8023d9 <set_block_data>
  8026c5:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  8026c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026cc:	74 06                	je     8026d4 <alloc_block_FF+0x111>
  8026ce:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  8026d2:	75 17                	jne    8026eb <alloc_block_FF+0x128>
  8026d4:	83 ec 04             	sub    $0x4,%esp
  8026d7:	68 ac 3f 80 00       	push   $0x803fac
  8026dc:	68 de 00 00 00       	push   $0xde
  8026e1:	68 37 3f 80 00       	push   $0x803f37
  8026e6:	e8 b3 dc ff ff       	call   80039e <_panic>
  8026eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ee:	8b 10                	mov    (%eax),%edx
  8026f0:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8026f3:	89 10                	mov    %edx,(%eax)
  8026f5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8026f8:	8b 00                	mov    (%eax),%eax
  8026fa:	85 c0                	test   %eax,%eax
  8026fc:	74 0b                	je     802709 <alloc_block_FF+0x146>
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 00                	mov    (%eax),%eax
  802703:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802706:	89 50 04             	mov    %edx,0x4(%eax)
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	8b 55 94             	mov    -0x6c(%ebp),%edx
  80270f:	89 10                	mov    %edx,(%eax)
  802711:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802714:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802717:	89 50 04             	mov    %edx,0x4(%eax)
  80271a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80271d:	8b 00                	mov    (%eax),%eax
  80271f:	85 c0                	test   %eax,%eax
  802721:	75 08                	jne    80272b <alloc_block_FF+0x168>
  802723:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802726:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80272b:	a1 54 50 98 00       	mov    0x985054,%eax
  802730:	40                   	inc    %eax
  802731:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802736:	83 ec 04             	sub    $0x4,%esp
  802739:	6a 01                	push   $0x1
  80273b:	ff 75 dc             	pushl  -0x24(%ebp)
  80273e:	ff 75 f4             	pushl  -0xc(%ebp)
  802741:	e8 93 fc ff ff       	call   8023d9 <set_block_data>
  802746:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802749:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274d:	75 17                	jne    802766 <alloc_block_FF+0x1a3>
  80274f:	83 ec 04             	sub    $0x4,%esp
  802752:	68 e0 3f 80 00       	push   $0x803fe0
  802757:	68 e3 00 00 00       	push   $0xe3
  80275c:	68 37 3f 80 00       	push   $0x803f37
  802761:	e8 38 dc ff ff       	call   80039e <_panic>
  802766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802769:	8b 00                	mov    (%eax),%eax
  80276b:	85 c0                	test   %eax,%eax
  80276d:	74 10                	je     80277f <alloc_block_FF+0x1bc>
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	8b 00                	mov    (%eax),%eax
  802774:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802777:	8b 52 04             	mov    0x4(%edx),%edx
  80277a:	89 50 04             	mov    %edx,0x4(%eax)
  80277d:	eb 0b                	jmp    80278a <alloc_block_FF+0x1c7>
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	8b 40 04             	mov    0x4(%eax),%eax
  802785:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278d:	8b 40 04             	mov    0x4(%eax),%eax
  802790:	85 c0                	test   %eax,%eax
  802792:	74 0f                	je     8027a3 <alloc_block_FF+0x1e0>
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	8b 40 04             	mov    0x4(%eax),%eax
  80279a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80279d:	8b 12                	mov    (%edx),%edx
  80279f:	89 10                	mov    %edx,(%eax)
  8027a1:	eb 0a                	jmp    8027ad <alloc_block_FF+0x1ea>
  8027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a6:	8b 00                	mov    (%eax),%eax
  8027a8:	a3 48 50 98 00       	mov    %eax,0x985048
  8027ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c0:	a1 54 50 98 00       	mov    0x985054,%eax
  8027c5:	48                   	dec    %eax
  8027c6:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  8027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ce:	e9 25 02 00 00       	jmp    8029f8 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  8027d3:	83 ec 04             	sub    $0x4,%esp
  8027d6:	6a 01                	push   $0x1
  8027d8:	ff 75 9c             	pushl  -0x64(%ebp)
  8027db:	ff 75 f4             	pushl  -0xc(%ebp)
  8027de:	e8 f6 fb ff ff       	call   8023d9 <set_block_data>
  8027e3:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  8027e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ea:	75 17                	jne    802803 <alloc_block_FF+0x240>
  8027ec:	83 ec 04             	sub    $0x4,%esp
  8027ef:	68 e0 3f 80 00       	push   $0x803fe0
  8027f4:	68 eb 00 00 00       	push   $0xeb
  8027f9:	68 37 3f 80 00       	push   $0x803f37
  8027fe:	e8 9b db ff ff       	call   80039e <_panic>
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	8b 00                	mov    (%eax),%eax
  802808:	85 c0                	test   %eax,%eax
  80280a:	74 10                	je     80281c <alloc_block_FF+0x259>
  80280c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280f:	8b 00                	mov    (%eax),%eax
  802811:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802814:	8b 52 04             	mov    0x4(%edx),%edx
  802817:	89 50 04             	mov    %edx,0x4(%eax)
  80281a:	eb 0b                	jmp    802827 <alloc_block_FF+0x264>
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	8b 40 04             	mov    0x4(%eax),%eax
  802822:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282a:	8b 40 04             	mov    0x4(%eax),%eax
  80282d:	85 c0                	test   %eax,%eax
  80282f:	74 0f                	je     802840 <alloc_block_FF+0x27d>
  802831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802834:	8b 40 04             	mov    0x4(%eax),%eax
  802837:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80283a:	8b 12                	mov    (%edx),%edx
  80283c:	89 10                	mov    %edx,(%eax)
  80283e:	eb 0a                	jmp    80284a <alloc_block_FF+0x287>
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	8b 00                	mov    (%eax),%eax
  802845:	a3 48 50 98 00       	mov    %eax,0x985048
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802856:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80285d:	a1 54 50 98 00       	mov    0x985054,%eax
  802862:	48                   	dec    %eax
  802863:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	e9 88 01 00 00       	jmp    8029f8 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802870:	a1 50 50 98 00       	mov    0x985050,%eax
  802875:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802878:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287c:	74 07                	je     802885 <alloc_block_FF+0x2c2>
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802881:	8b 00                	mov    (%eax),%eax
  802883:	eb 05                	jmp    80288a <alloc_block_FF+0x2c7>
  802885:	b8 00 00 00 00       	mov    $0x0,%eax
  80288a:	a3 50 50 98 00       	mov    %eax,0x985050
  80288f:	a1 50 50 98 00       	mov    0x985050,%eax
  802894:	85 c0                	test   %eax,%eax
  802896:	0f 85 d9 fd ff ff    	jne    802675 <alloc_block_FF+0xb2>
  80289c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a0:	0f 85 cf fd ff ff    	jne    802675 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  8028a6:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8028ad:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8028b3:	01 d0                	add    %edx,%eax
  8028b5:	48                   	dec    %eax
  8028b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8028b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8028c1:	f7 75 d8             	divl   -0x28(%ebp)
  8028c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028c7:	29 d0                	sub    %edx,%eax
  8028c9:	c1 e8 0c             	shr    $0xc,%eax
  8028cc:	83 ec 0c             	sub    $0xc,%esp
  8028cf:	50                   	push   %eax
  8028d0:	e8 20 eb ff ff       	call   8013f5 <sbrk>
  8028d5:	83 c4 10             	add    $0x10,%esp
  8028d8:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  8028db:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8028df:	75 0a                	jne    8028eb <alloc_block_FF+0x328>
		return NULL;
  8028e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e6:	e9 0d 01 00 00       	jmp    8029f8 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  8028eb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028ee:	83 e8 04             	sub    $0x4,%eax
  8028f1:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  8028f4:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  8028fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802901:	01 d0                	add    %edx,%eax
  802903:	48                   	dec    %eax
  802904:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802907:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80290a:	ba 00 00 00 00       	mov    $0x0,%edx
  80290f:	f7 75 c8             	divl   -0x38(%ebp)
  802912:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802915:	29 d0                	sub    %edx,%eax
  802917:	c1 e8 02             	shr    $0x2,%eax
  80291a:	c1 e0 02             	shl    $0x2,%eax
  80291d:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  802920:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802923:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  802929:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80292c:	83 e8 08             	sub    $0x8,%eax
  80292f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  802932:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802935:	8b 00                	mov    (%eax),%eax
  802937:	83 e0 fe             	and    $0xfffffffe,%eax
  80293a:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  80293d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802940:	f7 d8                	neg    %eax
  802942:	89 c2                	mov    %eax,%edx
  802944:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802947:	01 d0                	add    %edx,%eax
  802949:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  80294c:	83 ec 0c             	sub    $0xc,%esp
  80294f:	ff 75 b8             	pushl  -0x48(%ebp)
  802952:	e8 1f f8 ff ff       	call   802176 <is_free_block>
  802957:	83 c4 10             	add    $0x10,%esp
  80295a:	0f be c0             	movsbl %al,%eax
  80295d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  802960:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802964:	74 42                	je     8029a8 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  802966:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80296d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802970:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802973:	01 d0                	add    %edx,%eax
  802975:	48                   	dec    %eax
  802976:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802979:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80297c:	ba 00 00 00 00       	mov    $0x0,%edx
  802981:	f7 75 b0             	divl   -0x50(%ebp)
  802984:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802987:	29 d0                	sub    %edx,%eax
  802989:	89 c2                	mov    %eax,%edx
  80298b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80298e:	01 d0                	add    %edx,%eax
  802990:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  802993:	83 ec 04             	sub    $0x4,%esp
  802996:	6a 00                	push   $0x0
  802998:	ff 75 a8             	pushl  -0x58(%ebp)
  80299b:	ff 75 b8             	pushl  -0x48(%ebp)
  80299e:	e8 36 fa ff ff       	call   8023d9 <set_block_data>
  8029a3:	83 c4 10             	add    $0x10,%esp
  8029a6:	eb 42                	jmp    8029ea <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  8029a8:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  8029af:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029b2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029b5:	01 d0                	add    %edx,%eax
  8029b7:	48                   	dec    %eax
  8029b8:	89 45 a0             	mov    %eax,-0x60(%ebp)
  8029bb:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8029be:	ba 00 00 00 00       	mov    $0x0,%edx
  8029c3:	f7 75 a4             	divl   -0x5c(%ebp)
  8029c6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8029c9:	29 d0                	sub    %edx,%eax
  8029cb:	83 ec 04             	sub    $0x4,%esp
  8029ce:	6a 00                	push   $0x0
  8029d0:	50                   	push   %eax
  8029d1:	ff 75 d0             	pushl  -0x30(%ebp)
  8029d4:	e8 00 fa ff ff       	call   8023d9 <set_block_data>
  8029d9:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  8029dc:	83 ec 0c             	sub    $0xc,%esp
  8029df:	ff 75 d0             	pushl  -0x30(%ebp)
  8029e2:	e8 49 fa ff ff       	call   802430 <insert_sorted_in_freeList>
  8029e7:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  8029ea:	83 ec 0c             	sub    $0xc,%esp
  8029ed:	ff 75 08             	pushl  0x8(%ebp)
  8029f0:	e8 ce fb ff ff       	call   8025c3 <alloc_block_FF>
  8029f5:	83 c4 10             	add    $0x10,%esp
}
  8029f8:	c9                   	leave  
  8029f9:	c3                   	ret    

008029fa <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8029fa:	55                   	push   %ebp
  8029fb:	89 e5                	mov    %esp,%ebp
  8029fd:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  802a00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a04:	75 0a                	jne    802a10 <alloc_block_BF+0x16>
	{
		return NULL;
  802a06:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0b:	e9 7a 02 00 00       	jmp    802c8a <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802a10:	8b 45 08             	mov    0x8(%ebp),%eax
  802a13:	83 c0 08             	add    $0x8,%eax
  802a16:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802a19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  802a20:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802a27:	a1 48 50 98 00       	mov    0x985048,%eax
  802a2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a2f:	eb 32                	jmp    802a63 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  802a31:	ff 75 ec             	pushl  -0x14(%ebp)
  802a34:	e8 24 f7 ff ff       	call   80215d <get_block_size>
  802a39:	83 c4 04             	add    $0x4,%esp
  802a3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  802a3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a42:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a45:	72 14                	jb     802a5b <alloc_block_BF+0x61>
  802a47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a4a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a4d:	73 0c                	jae    802a5b <alloc_block_BF+0x61>
		{
			minBlk = block;
  802a4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  802a55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802a5b:	a1 50 50 98 00       	mov    0x985050,%eax
  802a60:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a63:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a67:	74 07                	je     802a70 <alloc_block_BF+0x76>
  802a69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6c:	8b 00                	mov    (%eax),%eax
  802a6e:	eb 05                	jmp    802a75 <alloc_block_BF+0x7b>
  802a70:	b8 00 00 00 00       	mov    $0x0,%eax
  802a75:	a3 50 50 98 00       	mov    %eax,0x985050
  802a7a:	a1 50 50 98 00       	mov    0x985050,%eax
  802a7f:	85 c0                	test   %eax,%eax
  802a81:	75 ae                	jne    802a31 <alloc_block_BF+0x37>
  802a83:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a87:	75 a8                	jne    802a31 <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802a89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8d:	75 22                	jne    802ab1 <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802a8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a92:	83 ec 0c             	sub    $0xc,%esp
  802a95:	50                   	push   %eax
  802a96:	e8 5a e9 ff ff       	call   8013f5 <sbrk>
  802a9b:	83 c4 10             	add    $0x10,%esp
  802a9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  802aa1:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802aa5:	75 0a                	jne    802ab1 <alloc_block_BF+0xb7>
			return NULL;
  802aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  802aac:	e9 d9 01 00 00       	jmp    802c8a <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  802ab1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab4:	83 c0 10             	add    $0x10,%eax
  802ab7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802aba:	0f 87 32 01 00 00    	ja     802bf2 <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  802ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac3:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802ac6:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802ac9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802acc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802acf:	01 d0                	add    %edx,%eax
  802ad1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  802ad4:	83 ec 04             	sub    $0x4,%esp
  802ad7:	6a 00                	push   $0x0
  802ad9:	ff 75 dc             	pushl  -0x24(%ebp)
  802adc:	ff 75 d8             	pushl  -0x28(%ebp)
  802adf:	e8 f5 f8 ff ff       	call   8023d9 <set_block_data>
  802ae4:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802ae7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aeb:	74 06                	je     802af3 <alloc_block_BF+0xf9>
  802aed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802af1:	75 17                	jne    802b0a <alloc_block_BF+0x110>
  802af3:	83 ec 04             	sub    $0x4,%esp
  802af6:	68 ac 3f 80 00       	push   $0x803fac
  802afb:	68 49 01 00 00       	push   $0x149
  802b00:	68 37 3f 80 00       	push   $0x803f37
  802b05:	e8 94 d8 ff ff       	call   80039e <_panic>
  802b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0d:	8b 10                	mov    (%eax),%edx
  802b0f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b12:	89 10                	mov    %edx,(%eax)
  802b14:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b17:	8b 00                	mov    (%eax),%eax
  802b19:	85 c0                	test   %eax,%eax
  802b1b:	74 0b                	je     802b28 <alloc_block_BF+0x12e>
  802b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b20:	8b 00                	mov    (%eax),%eax
  802b22:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b25:	89 50 04             	mov    %edx,0x4(%eax)
  802b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b2e:	89 10                	mov    %edx,(%eax)
  802b30:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b36:	89 50 04             	mov    %edx,0x4(%eax)
  802b39:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b3c:	8b 00                	mov    (%eax),%eax
  802b3e:	85 c0                	test   %eax,%eax
  802b40:	75 08                	jne    802b4a <alloc_block_BF+0x150>
  802b42:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b45:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802b4a:	a1 54 50 98 00       	mov    0x985054,%eax
  802b4f:	40                   	inc    %eax
  802b50:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802b55:	83 ec 04             	sub    $0x4,%esp
  802b58:	6a 01                	push   $0x1
  802b5a:	ff 75 e8             	pushl  -0x18(%ebp)
  802b5d:	ff 75 f4             	pushl  -0xc(%ebp)
  802b60:	e8 74 f8 ff ff       	call   8023d9 <set_block_data>
  802b65:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802b68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b6c:	75 17                	jne    802b85 <alloc_block_BF+0x18b>
  802b6e:	83 ec 04             	sub    $0x4,%esp
  802b71:	68 e0 3f 80 00       	push   $0x803fe0
  802b76:	68 4e 01 00 00       	push   $0x14e
  802b7b:	68 37 3f 80 00       	push   $0x803f37
  802b80:	e8 19 d8 ff ff       	call   80039e <_panic>
  802b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b88:	8b 00                	mov    (%eax),%eax
  802b8a:	85 c0                	test   %eax,%eax
  802b8c:	74 10                	je     802b9e <alloc_block_BF+0x1a4>
  802b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b91:	8b 00                	mov    (%eax),%eax
  802b93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b96:	8b 52 04             	mov    0x4(%edx),%edx
  802b99:	89 50 04             	mov    %edx,0x4(%eax)
  802b9c:	eb 0b                	jmp    802ba9 <alloc_block_BF+0x1af>
  802b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba1:	8b 40 04             	mov    0x4(%eax),%eax
  802ba4:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bac:	8b 40 04             	mov    0x4(%eax),%eax
  802baf:	85 c0                	test   %eax,%eax
  802bb1:	74 0f                	je     802bc2 <alloc_block_BF+0x1c8>
  802bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb6:	8b 40 04             	mov    0x4(%eax),%eax
  802bb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bbc:	8b 12                	mov    (%edx),%edx
  802bbe:	89 10                	mov    %edx,(%eax)
  802bc0:	eb 0a                	jmp    802bcc <alloc_block_BF+0x1d2>
  802bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc5:	8b 00                	mov    (%eax),%eax
  802bc7:	a3 48 50 98 00       	mov    %eax,0x985048
  802bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bdf:	a1 54 50 98 00       	mov    0x985054,%eax
  802be4:	48                   	dec    %eax
  802be5:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bed:	e9 98 00 00 00       	jmp    802c8a <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  802bf2:	83 ec 04             	sub    $0x4,%esp
  802bf5:	6a 01                	push   $0x1
  802bf7:	ff 75 f0             	pushl  -0x10(%ebp)
  802bfa:	ff 75 f4             	pushl  -0xc(%ebp)
  802bfd:	e8 d7 f7 ff ff       	call   8023d9 <set_block_data>
  802c02:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802c05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c09:	75 17                	jne    802c22 <alloc_block_BF+0x228>
  802c0b:	83 ec 04             	sub    $0x4,%esp
  802c0e:	68 e0 3f 80 00       	push   $0x803fe0
  802c13:	68 56 01 00 00       	push   $0x156
  802c18:	68 37 3f 80 00       	push   $0x803f37
  802c1d:	e8 7c d7 ff ff       	call   80039e <_panic>
  802c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c25:	8b 00                	mov    (%eax),%eax
  802c27:	85 c0                	test   %eax,%eax
  802c29:	74 10                	je     802c3b <alloc_block_BF+0x241>
  802c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2e:	8b 00                	mov    (%eax),%eax
  802c30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c33:	8b 52 04             	mov    0x4(%edx),%edx
  802c36:	89 50 04             	mov    %edx,0x4(%eax)
  802c39:	eb 0b                	jmp    802c46 <alloc_block_BF+0x24c>
  802c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3e:	8b 40 04             	mov    0x4(%eax),%eax
  802c41:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c49:	8b 40 04             	mov    0x4(%eax),%eax
  802c4c:	85 c0                	test   %eax,%eax
  802c4e:	74 0f                	je     802c5f <alloc_block_BF+0x265>
  802c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c53:	8b 40 04             	mov    0x4(%eax),%eax
  802c56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c59:	8b 12                	mov    (%edx),%edx
  802c5b:	89 10                	mov    %edx,(%eax)
  802c5d:	eb 0a                	jmp    802c69 <alloc_block_BF+0x26f>
  802c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c62:	8b 00                	mov    (%eax),%eax
  802c64:	a3 48 50 98 00       	mov    %eax,0x985048
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7c:	a1 54 50 98 00       	mov    0x985054,%eax
  802c81:	48                   	dec    %eax
  802c82:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802c8a:	c9                   	leave  
  802c8b:	c3                   	ret    

00802c8c <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802c8c:	55                   	push   %ebp
  802c8d:	89 e5                	mov    %esp,%ebp
  802c8f:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802c92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c96:	0f 84 6a 02 00 00    	je     802f06 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  802c9c:	ff 75 08             	pushl  0x8(%ebp)
  802c9f:	e8 b9 f4 ff ff       	call   80215d <get_block_size>
  802ca4:	83 c4 04             	add    $0x4,%esp
  802ca7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  802caa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cad:	83 e8 08             	sub    $0x8,%eax
  802cb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  802cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb6:	8b 00                	mov    (%eax),%eax
  802cb8:	83 e0 fe             	and    $0xfffffffe,%eax
  802cbb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  802cbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc1:	f7 d8                	neg    %eax
  802cc3:	89 c2                	mov    %eax,%edx
  802cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc8:	01 d0                	add    %edx,%eax
  802cca:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802ccd:	ff 75 e8             	pushl  -0x18(%ebp)
  802cd0:	e8 a1 f4 ff ff       	call   802176 <is_free_block>
  802cd5:	83 c4 04             	add    $0x4,%esp
  802cd8:	0f be c0             	movsbl %al,%eax
  802cdb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802cde:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	01 d0                	add    %edx,%eax
  802ce6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802ce9:	ff 75 e0             	pushl  -0x20(%ebp)
  802cec:	e8 85 f4 ff ff       	call   802176 <is_free_block>
  802cf1:	83 c4 04             	add    $0x4,%esp
  802cf4:	0f be c0             	movsbl %al,%eax
  802cf7:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802cfa:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802cfe:	75 34                	jne    802d34 <free_block+0xa8>
  802d00:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d04:	75 2e                	jne    802d34 <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802d06:	ff 75 e8             	pushl  -0x18(%ebp)
  802d09:	e8 4f f4 ff ff       	call   80215d <get_block_size>
  802d0e:	83 c4 04             	add    $0x4,%esp
  802d11:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802d14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d17:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d1a:	01 d0                	add    %edx,%eax
  802d1c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802d1f:	6a 00                	push   $0x0
  802d21:	ff 75 d4             	pushl  -0x2c(%ebp)
  802d24:	ff 75 e8             	pushl  -0x18(%ebp)
  802d27:	e8 ad f6 ff ff       	call   8023d9 <set_block_data>
  802d2c:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802d2f:	e9 d3 01 00 00       	jmp    802f07 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802d34:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802d38:	0f 85 c8 00 00 00    	jne    802e06 <free_block+0x17a>
  802d3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d42:	0f 85 be 00 00 00    	jne    802e06 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802d48:	ff 75 e0             	pushl  -0x20(%ebp)
  802d4b:	e8 0d f4 ff ff       	call   80215d <get_block_size>
  802d50:	83 c4 04             	add    $0x4,%esp
  802d53:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802d56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d59:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d5c:	01 d0                	add    %edx,%eax
  802d5e:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802d61:	6a 00                	push   $0x0
  802d63:	ff 75 cc             	pushl  -0x34(%ebp)
  802d66:	ff 75 08             	pushl  0x8(%ebp)
  802d69:	e8 6b f6 ff ff       	call   8023d9 <set_block_data>
  802d6e:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802d71:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d75:	75 17                	jne    802d8e <free_block+0x102>
  802d77:	83 ec 04             	sub    $0x4,%esp
  802d7a:	68 e0 3f 80 00       	push   $0x803fe0
  802d7f:	68 87 01 00 00       	push   $0x187
  802d84:	68 37 3f 80 00       	push   $0x803f37
  802d89:	e8 10 d6 ff ff       	call   80039e <_panic>
  802d8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d91:	8b 00                	mov    (%eax),%eax
  802d93:	85 c0                	test   %eax,%eax
  802d95:	74 10                	je     802da7 <free_block+0x11b>
  802d97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d9a:	8b 00                	mov    (%eax),%eax
  802d9c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d9f:	8b 52 04             	mov    0x4(%edx),%edx
  802da2:	89 50 04             	mov    %edx,0x4(%eax)
  802da5:	eb 0b                	jmp    802db2 <free_block+0x126>
  802da7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802daa:	8b 40 04             	mov    0x4(%eax),%eax
  802dad:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802db2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802db5:	8b 40 04             	mov    0x4(%eax),%eax
  802db8:	85 c0                	test   %eax,%eax
  802dba:	74 0f                	je     802dcb <free_block+0x13f>
  802dbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dbf:	8b 40 04             	mov    0x4(%eax),%eax
  802dc2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dc5:	8b 12                	mov    (%edx),%edx
  802dc7:	89 10                	mov    %edx,(%eax)
  802dc9:	eb 0a                	jmp    802dd5 <free_block+0x149>
  802dcb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dce:	8b 00                	mov    (%eax),%eax
  802dd0:	a3 48 50 98 00       	mov    %eax,0x985048
  802dd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dde:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802de1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de8:	a1 54 50 98 00       	mov    0x985054,%eax
  802ded:	48                   	dec    %eax
  802dee:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802df3:	83 ec 0c             	sub    $0xc,%esp
  802df6:	ff 75 08             	pushl  0x8(%ebp)
  802df9:	e8 32 f6 ff ff       	call   802430 <insert_sorted_in_freeList>
  802dfe:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802e01:	e9 01 01 00 00       	jmp    802f07 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  802e06:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802e0a:	0f 85 d3 00 00 00    	jne    802ee3 <free_block+0x257>
  802e10:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802e14:	0f 85 c9 00 00 00    	jne    802ee3 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  802e1a:	83 ec 0c             	sub    $0xc,%esp
  802e1d:	ff 75 e8             	pushl  -0x18(%ebp)
  802e20:	e8 38 f3 ff ff       	call   80215d <get_block_size>
  802e25:	83 c4 10             	add    $0x10,%esp
  802e28:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  802e2b:	83 ec 0c             	sub    $0xc,%esp
  802e2e:	ff 75 e0             	pushl  -0x20(%ebp)
  802e31:	e8 27 f3 ff ff       	call   80215d <get_block_size>
  802e36:	83 c4 10             	add    $0x10,%esp
  802e39:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  802e3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e3f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802e42:	01 c2                	add    %eax,%edx
  802e44:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e47:	01 d0                	add    %edx,%eax
  802e49:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  802e4c:	83 ec 04             	sub    $0x4,%esp
  802e4f:	6a 00                	push   $0x0
  802e51:	ff 75 c0             	pushl  -0x40(%ebp)
  802e54:	ff 75 e8             	pushl  -0x18(%ebp)
  802e57:	e8 7d f5 ff ff       	call   8023d9 <set_block_data>
  802e5c:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  802e5f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e63:	75 17                	jne    802e7c <free_block+0x1f0>
  802e65:	83 ec 04             	sub    $0x4,%esp
  802e68:	68 e0 3f 80 00       	push   $0x803fe0
  802e6d:	68 94 01 00 00       	push   $0x194
  802e72:	68 37 3f 80 00       	push   $0x803f37
  802e77:	e8 22 d5 ff ff       	call   80039e <_panic>
  802e7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e7f:	8b 00                	mov    (%eax),%eax
  802e81:	85 c0                	test   %eax,%eax
  802e83:	74 10                	je     802e95 <free_block+0x209>
  802e85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e88:	8b 00                	mov    (%eax),%eax
  802e8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e8d:	8b 52 04             	mov    0x4(%edx),%edx
  802e90:	89 50 04             	mov    %edx,0x4(%eax)
  802e93:	eb 0b                	jmp    802ea0 <free_block+0x214>
  802e95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e98:	8b 40 04             	mov    0x4(%eax),%eax
  802e9b:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802ea0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ea3:	8b 40 04             	mov    0x4(%eax),%eax
  802ea6:	85 c0                	test   %eax,%eax
  802ea8:	74 0f                	je     802eb9 <free_block+0x22d>
  802eaa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ead:	8b 40 04             	mov    0x4(%eax),%eax
  802eb0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802eb3:	8b 12                	mov    (%edx),%edx
  802eb5:	89 10                	mov    %edx,(%eax)
  802eb7:	eb 0a                	jmp    802ec3 <free_block+0x237>
  802eb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ebc:	8b 00                	mov    (%eax),%eax
  802ebe:	a3 48 50 98 00       	mov    %eax,0x985048
  802ec3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ec6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ecc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ecf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed6:	a1 54 50 98 00       	mov    0x985054,%eax
  802edb:	48                   	dec    %eax
  802edc:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  802ee1:	eb 24                	jmp    802f07 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  802ee3:	83 ec 04             	sub    $0x4,%esp
  802ee6:	6a 00                	push   $0x0
  802ee8:	ff 75 f4             	pushl  -0xc(%ebp)
  802eeb:	ff 75 08             	pushl  0x8(%ebp)
  802eee:	e8 e6 f4 ff ff       	call   8023d9 <set_block_data>
  802ef3:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802ef6:	83 ec 0c             	sub    $0xc,%esp
  802ef9:	ff 75 08             	pushl  0x8(%ebp)
  802efc:	e8 2f f5 ff ff       	call   802430 <insert_sorted_in_freeList>
  802f01:	83 c4 10             	add    $0x10,%esp
  802f04:	eb 01                	jmp    802f07 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  802f06:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  802f07:	c9                   	leave  
  802f08:	c3                   	ret    

00802f09 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802f09:	55                   	push   %ebp
  802f0a:	89 e5                	mov    %esp,%ebp
  802f0c:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  802f0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f13:	75 10                	jne    802f25 <realloc_block_FF+0x1c>
  802f15:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f19:	75 0a                	jne    802f25 <realloc_block_FF+0x1c>
	{
		return NULL;
  802f1b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f20:	e9 8b 04 00 00       	jmp    8033b0 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  802f25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f29:	75 18                	jne    802f43 <realloc_block_FF+0x3a>
	{
		free_block(va);
  802f2b:	83 ec 0c             	sub    $0xc,%esp
  802f2e:	ff 75 08             	pushl  0x8(%ebp)
  802f31:	e8 56 fd ff ff       	call   802c8c <free_block>
  802f36:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802f39:	b8 00 00 00 00       	mov    $0x0,%eax
  802f3e:	e9 6d 04 00 00       	jmp    8033b0 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  802f43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f47:	75 13                	jne    802f5c <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  802f49:	83 ec 0c             	sub    $0xc,%esp
  802f4c:	ff 75 0c             	pushl  0xc(%ebp)
  802f4f:	e8 6f f6 ff ff       	call   8025c3 <alloc_block_FF>
  802f54:	83 c4 10             	add    $0x10,%esp
  802f57:	e9 54 04 00 00       	jmp    8033b0 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  802f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f5f:	83 e0 01             	and    $0x1,%eax
  802f62:	85 c0                	test   %eax,%eax
  802f64:	74 03                	je     802f69 <realloc_block_FF+0x60>
	{
		new_size++;
  802f66:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  802f69:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802f6d:	77 07                	ja     802f76 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  802f6f:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  802f76:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  802f7a:	83 ec 0c             	sub    $0xc,%esp
  802f7d:	ff 75 08             	pushl  0x8(%ebp)
  802f80:	e8 d8 f1 ff ff       	call   80215d <get_block_size>
  802f85:	83 c4 10             	add    $0x10,%esp
  802f88:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  802f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f91:	75 08                	jne    802f9b <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  802f93:	8b 45 08             	mov    0x8(%ebp),%eax
  802f96:	e9 15 04 00 00       	jmp    8033b0 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  802f9b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa1:	01 d0                	add    %edx,%eax
  802fa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802fa6:	83 ec 0c             	sub    $0xc,%esp
  802fa9:	ff 75 f0             	pushl  -0x10(%ebp)
  802fac:	e8 c5 f1 ff ff       	call   802176 <is_free_block>
  802fb1:	83 c4 10             	add    $0x10,%esp
  802fb4:	0f be c0             	movsbl %al,%eax
  802fb7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  802fba:	83 ec 0c             	sub    $0xc,%esp
  802fbd:	ff 75 f0             	pushl  -0x10(%ebp)
  802fc0:	e8 98 f1 ff ff       	call   80215d <get_block_size>
  802fc5:	83 c4 10             	add    $0x10,%esp
  802fc8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  802fcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fce:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802fd1:	0f 86 a7 02 00 00    	jbe    80327e <realloc_block_FF+0x375>
	{
		if(isNextFree)
  802fd7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fdb:	0f 84 86 02 00 00    	je     803267 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  802fe1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe7:	01 d0                	add    %edx,%eax
  802fe9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802fec:	0f 85 b2 00 00 00    	jne    8030a4 <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  802ff2:	83 ec 0c             	sub    $0xc,%esp
  802ff5:	ff 75 08             	pushl  0x8(%ebp)
  802ff8:	e8 79 f1 ff ff       	call   802176 <is_free_block>
  802ffd:	83 c4 10             	add    $0x10,%esp
  803000:	84 c0                	test   %al,%al
  803002:	0f 94 c0             	sete   %al
  803005:	0f b6 c0             	movzbl %al,%eax
  803008:	83 ec 04             	sub    $0x4,%esp
  80300b:	50                   	push   %eax
  80300c:	ff 75 0c             	pushl  0xc(%ebp)
  80300f:	ff 75 08             	pushl  0x8(%ebp)
  803012:	e8 c2 f3 ff ff       	call   8023d9 <set_block_data>
  803017:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  80301a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80301e:	75 17                	jne    803037 <realloc_block_FF+0x12e>
  803020:	83 ec 04             	sub    $0x4,%esp
  803023:	68 e0 3f 80 00       	push   $0x803fe0
  803028:	68 db 01 00 00       	push   $0x1db
  80302d:	68 37 3f 80 00       	push   $0x803f37
  803032:	e8 67 d3 ff ff       	call   80039e <_panic>
  803037:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303a:	8b 00                	mov    (%eax),%eax
  80303c:	85 c0                	test   %eax,%eax
  80303e:	74 10                	je     803050 <realloc_block_FF+0x147>
  803040:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803043:	8b 00                	mov    (%eax),%eax
  803045:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803048:	8b 52 04             	mov    0x4(%edx),%edx
  80304b:	89 50 04             	mov    %edx,0x4(%eax)
  80304e:	eb 0b                	jmp    80305b <realloc_block_FF+0x152>
  803050:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803053:	8b 40 04             	mov    0x4(%eax),%eax
  803056:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80305b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305e:	8b 40 04             	mov    0x4(%eax),%eax
  803061:	85 c0                	test   %eax,%eax
  803063:	74 0f                	je     803074 <realloc_block_FF+0x16b>
  803065:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803068:	8b 40 04             	mov    0x4(%eax),%eax
  80306b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80306e:	8b 12                	mov    (%edx),%edx
  803070:	89 10                	mov    %edx,(%eax)
  803072:	eb 0a                	jmp    80307e <realloc_block_FF+0x175>
  803074:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803077:	8b 00                	mov    (%eax),%eax
  803079:	a3 48 50 98 00       	mov    %eax,0x985048
  80307e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803081:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803087:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80308a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803091:	a1 54 50 98 00       	mov    0x985054,%eax
  803096:	48                   	dec    %eax
  803097:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  80309c:	8b 45 08             	mov    0x8(%ebp),%eax
  80309f:	e9 0c 03 00 00       	jmp    8033b0 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  8030a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030aa:	01 d0                	add    %edx,%eax
  8030ac:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8030af:	0f 86 b2 01 00 00    	jbe    803267 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  8030b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030b8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8030bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  8030be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8030c4:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  8030c7:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  8030cb:	0f 87 b8 00 00 00    	ja     803189 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  8030d1:	83 ec 0c             	sub    $0xc,%esp
  8030d4:	ff 75 08             	pushl  0x8(%ebp)
  8030d7:	e8 9a f0 ff ff       	call   802176 <is_free_block>
  8030dc:	83 c4 10             	add    $0x10,%esp
  8030df:	84 c0                	test   %al,%al
  8030e1:	0f 94 c0             	sete   %al
  8030e4:	0f b6 c0             	movzbl %al,%eax
  8030e7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8030ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030ed:	01 ca                	add    %ecx,%edx
  8030ef:	83 ec 04             	sub    $0x4,%esp
  8030f2:	50                   	push   %eax
  8030f3:	52                   	push   %edx
  8030f4:	ff 75 08             	pushl  0x8(%ebp)
  8030f7:	e8 dd f2 ff ff       	call   8023d9 <set_block_data>
  8030fc:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8030ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803103:	75 17                	jne    80311c <realloc_block_FF+0x213>
  803105:	83 ec 04             	sub    $0x4,%esp
  803108:	68 e0 3f 80 00       	push   $0x803fe0
  80310d:	68 e8 01 00 00       	push   $0x1e8
  803112:	68 37 3f 80 00       	push   $0x803f37
  803117:	e8 82 d2 ff ff       	call   80039e <_panic>
  80311c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311f:	8b 00                	mov    (%eax),%eax
  803121:	85 c0                	test   %eax,%eax
  803123:	74 10                	je     803135 <realloc_block_FF+0x22c>
  803125:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803128:	8b 00                	mov    (%eax),%eax
  80312a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80312d:	8b 52 04             	mov    0x4(%edx),%edx
  803130:	89 50 04             	mov    %edx,0x4(%eax)
  803133:	eb 0b                	jmp    803140 <realloc_block_FF+0x237>
  803135:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803138:	8b 40 04             	mov    0x4(%eax),%eax
  80313b:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803140:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803143:	8b 40 04             	mov    0x4(%eax),%eax
  803146:	85 c0                	test   %eax,%eax
  803148:	74 0f                	je     803159 <realloc_block_FF+0x250>
  80314a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314d:	8b 40 04             	mov    0x4(%eax),%eax
  803150:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803153:	8b 12                	mov    (%edx),%edx
  803155:	89 10                	mov    %edx,(%eax)
  803157:	eb 0a                	jmp    803163 <realloc_block_FF+0x25a>
  803159:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315c:	8b 00                	mov    (%eax),%eax
  80315e:	a3 48 50 98 00       	mov    %eax,0x985048
  803163:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803166:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80316c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803176:	a1 54 50 98 00       	mov    0x985054,%eax
  80317b:	48                   	dec    %eax
  80317c:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  803181:	8b 45 08             	mov    0x8(%ebp),%eax
  803184:	e9 27 02 00 00       	jmp    8033b0 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803189:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80318d:	75 17                	jne    8031a6 <realloc_block_FF+0x29d>
  80318f:	83 ec 04             	sub    $0x4,%esp
  803192:	68 e0 3f 80 00       	push   $0x803fe0
  803197:	68 ed 01 00 00       	push   $0x1ed
  80319c:	68 37 3f 80 00       	push   $0x803f37
  8031a1:	e8 f8 d1 ff ff       	call   80039e <_panic>
  8031a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a9:	8b 00                	mov    (%eax),%eax
  8031ab:	85 c0                	test   %eax,%eax
  8031ad:	74 10                	je     8031bf <realloc_block_FF+0x2b6>
  8031af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b2:	8b 00                	mov    (%eax),%eax
  8031b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031b7:	8b 52 04             	mov    0x4(%edx),%edx
  8031ba:	89 50 04             	mov    %edx,0x4(%eax)
  8031bd:	eb 0b                	jmp    8031ca <realloc_block_FF+0x2c1>
  8031bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c2:	8b 40 04             	mov    0x4(%eax),%eax
  8031c5:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8031ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031cd:	8b 40 04             	mov    0x4(%eax),%eax
  8031d0:	85 c0                	test   %eax,%eax
  8031d2:	74 0f                	je     8031e3 <realloc_block_FF+0x2da>
  8031d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d7:	8b 40 04             	mov    0x4(%eax),%eax
  8031da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031dd:	8b 12                	mov    (%edx),%edx
  8031df:	89 10                	mov    %edx,(%eax)
  8031e1:	eb 0a                	jmp    8031ed <realloc_block_FF+0x2e4>
  8031e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e6:	8b 00                	mov    (%eax),%eax
  8031e8:	a3 48 50 98 00       	mov    %eax,0x985048
  8031ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803200:	a1 54 50 98 00       	mov    0x985054,%eax
  803205:	48                   	dec    %eax
  803206:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  80320b:	8b 55 08             	mov    0x8(%ebp),%edx
  80320e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803211:	01 d0                	add    %edx,%eax
  803213:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  803216:	83 ec 04             	sub    $0x4,%esp
  803219:	6a 00                	push   $0x0
  80321b:	ff 75 e0             	pushl  -0x20(%ebp)
  80321e:	ff 75 f0             	pushl  -0x10(%ebp)
  803221:	e8 b3 f1 ff ff       	call   8023d9 <set_block_data>
  803226:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  803229:	83 ec 0c             	sub    $0xc,%esp
  80322c:	ff 75 08             	pushl  0x8(%ebp)
  80322f:	e8 42 ef ff ff       	call   802176 <is_free_block>
  803234:	83 c4 10             	add    $0x10,%esp
  803237:	84 c0                	test   %al,%al
  803239:	0f 94 c0             	sete   %al
  80323c:	0f b6 c0             	movzbl %al,%eax
  80323f:	83 ec 04             	sub    $0x4,%esp
  803242:	50                   	push   %eax
  803243:	ff 75 0c             	pushl  0xc(%ebp)
  803246:	ff 75 08             	pushl  0x8(%ebp)
  803249:	e8 8b f1 ff ff       	call   8023d9 <set_block_data>
  80324e:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  803251:	83 ec 0c             	sub    $0xc,%esp
  803254:	ff 75 f0             	pushl  -0x10(%ebp)
  803257:	e8 d4 f1 ff ff       	call   802430 <insert_sorted_in_freeList>
  80325c:	83 c4 10             	add    $0x10,%esp
					return va;
  80325f:	8b 45 08             	mov    0x8(%ebp),%eax
  803262:	e9 49 01 00 00       	jmp    8033b0 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80326a:	83 e8 08             	sub    $0x8,%eax
  80326d:	83 ec 0c             	sub    $0xc,%esp
  803270:	50                   	push   %eax
  803271:	e8 4d f3 ff ff       	call   8025c3 <alloc_block_FF>
  803276:	83 c4 10             	add    $0x10,%esp
  803279:	e9 32 01 00 00       	jmp    8033b0 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  80327e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803281:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803284:	0f 83 21 01 00 00    	jae    8033ab <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  80328a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328d:	2b 45 0c             	sub    0xc(%ebp),%eax
  803290:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  803293:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  803297:	77 0e                	ja     8032a7 <realloc_block_FF+0x39e>
  803299:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80329d:	75 08                	jne    8032a7 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  80329f:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a2:	e9 09 01 00 00       	jmp    8033b0 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  8032a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  8032ad:	83 ec 0c             	sub    $0xc,%esp
  8032b0:	ff 75 08             	pushl  0x8(%ebp)
  8032b3:	e8 be ee ff ff       	call   802176 <is_free_block>
  8032b8:	83 c4 10             	add    $0x10,%esp
  8032bb:	84 c0                	test   %al,%al
  8032bd:	0f 94 c0             	sete   %al
  8032c0:	0f b6 c0             	movzbl %al,%eax
  8032c3:	83 ec 04             	sub    $0x4,%esp
  8032c6:	50                   	push   %eax
  8032c7:	ff 75 0c             	pushl  0xc(%ebp)
  8032ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8032cd:	e8 07 f1 ff ff       	call   8023d9 <set_block_data>
  8032d2:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  8032d5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8032d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032db:	01 d0                	add    %edx,%eax
  8032dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  8032e0:	83 ec 04             	sub    $0x4,%esp
  8032e3:	6a 00                	push   $0x0
  8032e5:	ff 75 dc             	pushl  -0x24(%ebp)
  8032e8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8032eb:	e8 e9 f0 ff ff       	call   8023d9 <set_block_data>
  8032f0:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  8032f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032f7:	0f 84 9b 00 00 00    	je     803398 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  8032fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803300:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803303:	01 d0                	add    %edx,%eax
  803305:	83 ec 04             	sub    $0x4,%esp
  803308:	6a 00                	push   $0x0
  80330a:	50                   	push   %eax
  80330b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80330e:	e8 c6 f0 ff ff       	call   8023d9 <set_block_data>
  803313:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  803316:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80331a:	75 17                	jne    803333 <realloc_block_FF+0x42a>
  80331c:	83 ec 04             	sub    $0x4,%esp
  80331f:	68 e0 3f 80 00       	push   $0x803fe0
  803324:	68 10 02 00 00       	push   $0x210
  803329:	68 37 3f 80 00       	push   $0x803f37
  80332e:	e8 6b d0 ff ff       	call   80039e <_panic>
  803333:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803336:	8b 00                	mov    (%eax),%eax
  803338:	85 c0                	test   %eax,%eax
  80333a:	74 10                	je     80334c <realloc_block_FF+0x443>
  80333c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80333f:	8b 00                	mov    (%eax),%eax
  803341:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803344:	8b 52 04             	mov    0x4(%edx),%edx
  803347:	89 50 04             	mov    %edx,0x4(%eax)
  80334a:	eb 0b                	jmp    803357 <realloc_block_FF+0x44e>
  80334c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334f:	8b 40 04             	mov    0x4(%eax),%eax
  803352:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335a:	8b 40 04             	mov    0x4(%eax),%eax
  80335d:	85 c0                	test   %eax,%eax
  80335f:	74 0f                	je     803370 <realloc_block_FF+0x467>
  803361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803364:	8b 40 04             	mov    0x4(%eax),%eax
  803367:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80336a:	8b 12                	mov    (%edx),%edx
  80336c:	89 10                	mov    %edx,(%eax)
  80336e:	eb 0a                	jmp    80337a <realloc_block_FF+0x471>
  803370:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803373:	8b 00                	mov    (%eax),%eax
  803375:	a3 48 50 98 00       	mov    %eax,0x985048
  80337a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803386:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80338d:	a1 54 50 98 00       	mov    0x985054,%eax
  803392:	48                   	dec    %eax
  803393:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  803398:	83 ec 0c             	sub    $0xc,%esp
  80339b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80339e:	e8 8d f0 ff ff       	call   802430 <insert_sorted_in_freeList>
  8033a3:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  8033a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033a9:	eb 05                	jmp    8033b0 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  8033ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033b0:	c9                   	leave  
  8033b1:	c3                   	ret    

008033b2 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8033b2:	55                   	push   %ebp
  8033b3:	89 e5                	mov    %esp,%ebp
  8033b5:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8033b8:	83 ec 04             	sub    $0x4,%esp
  8033bb:	68 00 40 80 00       	push   $0x804000
  8033c0:	68 20 02 00 00       	push   $0x220
  8033c5:	68 37 3f 80 00       	push   $0x803f37
  8033ca:	e8 cf cf ff ff       	call   80039e <_panic>

008033cf <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8033cf:	55                   	push   %ebp
  8033d0:	89 e5                	mov    %esp,%ebp
  8033d2:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8033d5:	83 ec 04             	sub    $0x4,%esp
  8033d8:	68 28 40 80 00       	push   $0x804028
  8033dd:	68 28 02 00 00       	push   $0x228
  8033e2:	68 37 3f 80 00       	push   $0x803f37
  8033e7:	e8 b2 cf ff ff       	call   80039e <_panic>

008033ec <__udivdi3>:
  8033ec:	55                   	push   %ebp
  8033ed:	57                   	push   %edi
  8033ee:	56                   	push   %esi
  8033ef:	53                   	push   %ebx
  8033f0:	83 ec 1c             	sub    $0x1c,%esp
  8033f3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033f7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033ff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803403:	89 ca                	mov    %ecx,%edx
  803405:	89 f8                	mov    %edi,%eax
  803407:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80340b:	85 f6                	test   %esi,%esi
  80340d:	75 2d                	jne    80343c <__udivdi3+0x50>
  80340f:	39 cf                	cmp    %ecx,%edi
  803411:	77 65                	ja     803478 <__udivdi3+0x8c>
  803413:	89 fd                	mov    %edi,%ebp
  803415:	85 ff                	test   %edi,%edi
  803417:	75 0b                	jne    803424 <__udivdi3+0x38>
  803419:	b8 01 00 00 00       	mov    $0x1,%eax
  80341e:	31 d2                	xor    %edx,%edx
  803420:	f7 f7                	div    %edi
  803422:	89 c5                	mov    %eax,%ebp
  803424:	31 d2                	xor    %edx,%edx
  803426:	89 c8                	mov    %ecx,%eax
  803428:	f7 f5                	div    %ebp
  80342a:	89 c1                	mov    %eax,%ecx
  80342c:	89 d8                	mov    %ebx,%eax
  80342e:	f7 f5                	div    %ebp
  803430:	89 cf                	mov    %ecx,%edi
  803432:	89 fa                	mov    %edi,%edx
  803434:	83 c4 1c             	add    $0x1c,%esp
  803437:	5b                   	pop    %ebx
  803438:	5e                   	pop    %esi
  803439:	5f                   	pop    %edi
  80343a:	5d                   	pop    %ebp
  80343b:	c3                   	ret    
  80343c:	39 ce                	cmp    %ecx,%esi
  80343e:	77 28                	ja     803468 <__udivdi3+0x7c>
  803440:	0f bd fe             	bsr    %esi,%edi
  803443:	83 f7 1f             	xor    $0x1f,%edi
  803446:	75 40                	jne    803488 <__udivdi3+0x9c>
  803448:	39 ce                	cmp    %ecx,%esi
  80344a:	72 0a                	jb     803456 <__udivdi3+0x6a>
  80344c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803450:	0f 87 9e 00 00 00    	ja     8034f4 <__udivdi3+0x108>
  803456:	b8 01 00 00 00       	mov    $0x1,%eax
  80345b:	89 fa                	mov    %edi,%edx
  80345d:	83 c4 1c             	add    $0x1c,%esp
  803460:	5b                   	pop    %ebx
  803461:	5e                   	pop    %esi
  803462:	5f                   	pop    %edi
  803463:	5d                   	pop    %ebp
  803464:	c3                   	ret    
  803465:	8d 76 00             	lea    0x0(%esi),%esi
  803468:	31 ff                	xor    %edi,%edi
  80346a:	31 c0                	xor    %eax,%eax
  80346c:	89 fa                	mov    %edi,%edx
  80346e:	83 c4 1c             	add    $0x1c,%esp
  803471:	5b                   	pop    %ebx
  803472:	5e                   	pop    %esi
  803473:	5f                   	pop    %edi
  803474:	5d                   	pop    %ebp
  803475:	c3                   	ret    
  803476:	66 90                	xchg   %ax,%ax
  803478:	89 d8                	mov    %ebx,%eax
  80347a:	f7 f7                	div    %edi
  80347c:	31 ff                	xor    %edi,%edi
  80347e:	89 fa                	mov    %edi,%edx
  803480:	83 c4 1c             	add    $0x1c,%esp
  803483:	5b                   	pop    %ebx
  803484:	5e                   	pop    %esi
  803485:	5f                   	pop    %edi
  803486:	5d                   	pop    %ebp
  803487:	c3                   	ret    
  803488:	bd 20 00 00 00       	mov    $0x20,%ebp
  80348d:	89 eb                	mov    %ebp,%ebx
  80348f:	29 fb                	sub    %edi,%ebx
  803491:	89 f9                	mov    %edi,%ecx
  803493:	d3 e6                	shl    %cl,%esi
  803495:	89 c5                	mov    %eax,%ebp
  803497:	88 d9                	mov    %bl,%cl
  803499:	d3 ed                	shr    %cl,%ebp
  80349b:	89 e9                	mov    %ebp,%ecx
  80349d:	09 f1                	or     %esi,%ecx
  80349f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034a3:	89 f9                	mov    %edi,%ecx
  8034a5:	d3 e0                	shl    %cl,%eax
  8034a7:	89 c5                	mov    %eax,%ebp
  8034a9:	89 d6                	mov    %edx,%esi
  8034ab:	88 d9                	mov    %bl,%cl
  8034ad:	d3 ee                	shr    %cl,%esi
  8034af:	89 f9                	mov    %edi,%ecx
  8034b1:	d3 e2                	shl    %cl,%edx
  8034b3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034b7:	88 d9                	mov    %bl,%cl
  8034b9:	d3 e8                	shr    %cl,%eax
  8034bb:	09 c2                	or     %eax,%edx
  8034bd:	89 d0                	mov    %edx,%eax
  8034bf:	89 f2                	mov    %esi,%edx
  8034c1:	f7 74 24 0c          	divl   0xc(%esp)
  8034c5:	89 d6                	mov    %edx,%esi
  8034c7:	89 c3                	mov    %eax,%ebx
  8034c9:	f7 e5                	mul    %ebp
  8034cb:	39 d6                	cmp    %edx,%esi
  8034cd:	72 19                	jb     8034e8 <__udivdi3+0xfc>
  8034cf:	74 0b                	je     8034dc <__udivdi3+0xf0>
  8034d1:	89 d8                	mov    %ebx,%eax
  8034d3:	31 ff                	xor    %edi,%edi
  8034d5:	e9 58 ff ff ff       	jmp    803432 <__udivdi3+0x46>
  8034da:	66 90                	xchg   %ax,%ax
  8034dc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034e0:	89 f9                	mov    %edi,%ecx
  8034e2:	d3 e2                	shl    %cl,%edx
  8034e4:	39 c2                	cmp    %eax,%edx
  8034e6:	73 e9                	jae    8034d1 <__udivdi3+0xe5>
  8034e8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034eb:	31 ff                	xor    %edi,%edi
  8034ed:	e9 40 ff ff ff       	jmp    803432 <__udivdi3+0x46>
  8034f2:	66 90                	xchg   %ax,%ax
  8034f4:	31 c0                	xor    %eax,%eax
  8034f6:	e9 37 ff ff ff       	jmp    803432 <__udivdi3+0x46>
  8034fb:	90                   	nop

008034fc <__umoddi3>:
  8034fc:	55                   	push   %ebp
  8034fd:	57                   	push   %edi
  8034fe:	56                   	push   %esi
  8034ff:	53                   	push   %ebx
  803500:	83 ec 1c             	sub    $0x1c,%esp
  803503:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803507:	8b 74 24 34          	mov    0x34(%esp),%esi
  80350b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80350f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803513:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803517:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80351b:	89 f3                	mov    %esi,%ebx
  80351d:	89 fa                	mov    %edi,%edx
  80351f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803523:	89 34 24             	mov    %esi,(%esp)
  803526:	85 c0                	test   %eax,%eax
  803528:	75 1a                	jne    803544 <__umoddi3+0x48>
  80352a:	39 f7                	cmp    %esi,%edi
  80352c:	0f 86 a2 00 00 00    	jbe    8035d4 <__umoddi3+0xd8>
  803532:	89 c8                	mov    %ecx,%eax
  803534:	89 f2                	mov    %esi,%edx
  803536:	f7 f7                	div    %edi
  803538:	89 d0                	mov    %edx,%eax
  80353a:	31 d2                	xor    %edx,%edx
  80353c:	83 c4 1c             	add    $0x1c,%esp
  80353f:	5b                   	pop    %ebx
  803540:	5e                   	pop    %esi
  803541:	5f                   	pop    %edi
  803542:	5d                   	pop    %ebp
  803543:	c3                   	ret    
  803544:	39 f0                	cmp    %esi,%eax
  803546:	0f 87 ac 00 00 00    	ja     8035f8 <__umoddi3+0xfc>
  80354c:	0f bd e8             	bsr    %eax,%ebp
  80354f:	83 f5 1f             	xor    $0x1f,%ebp
  803552:	0f 84 ac 00 00 00    	je     803604 <__umoddi3+0x108>
  803558:	bf 20 00 00 00       	mov    $0x20,%edi
  80355d:	29 ef                	sub    %ebp,%edi
  80355f:	89 fe                	mov    %edi,%esi
  803561:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803565:	89 e9                	mov    %ebp,%ecx
  803567:	d3 e0                	shl    %cl,%eax
  803569:	89 d7                	mov    %edx,%edi
  80356b:	89 f1                	mov    %esi,%ecx
  80356d:	d3 ef                	shr    %cl,%edi
  80356f:	09 c7                	or     %eax,%edi
  803571:	89 e9                	mov    %ebp,%ecx
  803573:	d3 e2                	shl    %cl,%edx
  803575:	89 14 24             	mov    %edx,(%esp)
  803578:	89 d8                	mov    %ebx,%eax
  80357a:	d3 e0                	shl    %cl,%eax
  80357c:	89 c2                	mov    %eax,%edx
  80357e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803582:	d3 e0                	shl    %cl,%eax
  803584:	89 44 24 04          	mov    %eax,0x4(%esp)
  803588:	8b 44 24 08          	mov    0x8(%esp),%eax
  80358c:	89 f1                	mov    %esi,%ecx
  80358e:	d3 e8                	shr    %cl,%eax
  803590:	09 d0                	or     %edx,%eax
  803592:	d3 eb                	shr    %cl,%ebx
  803594:	89 da                	mov    %ebx,%edx
  803596:	f7 f7                	div    %edi
  803598:	89 d3                	mov    %edx,%ebx
  80359a:	f7 24 24             	mull   (%esp)
  80359d:	89 c6                	mov    %eax,%esi
  80359f:	89 d1                	mov    %edx,%ecx
  8035a1:	39 d3                	cmp    %edx,%ebx
  8035a3:	0f 82 87 00 00 00    	jb     803630 <__umoddi3+0x134>
  8035a9:	0f 84 91 00 00 00    	je     803640 <__umoddi3+0x144>
  8035af:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035b3:	29 f2                	sub    %esi,%edx
  8035b5:	19 cb                	sbb    %ecx,%ebx
  8035b7:	89 d8                	mov    %ebx,%eax
  8035b9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035bd:	d3 e0                	shl    %cl,%eax
  8035bf:	89 e9                	mov    %ebp,%ecx
  8035c1:	d3 ea                	shr    %cl,%edx
  8035c3:	09 d0                	or     %edx,%eax
  8035c5:	89 e9                	mov    %ebp,%ecx
  8035c7:	d3 eb                	shr    %cl,%ebx
  8035c9:	89 da                	mov    %ebx,%edx
  8035cb:	83 c4 1c             	add    $0x1c,%esp
  8035ce:	5b                   	pop    %ebx
  8035cf:	5e                   	pop    %esi
  8035d0:	5f                   	pop    %edi
  8035d1:	5d                   	pop    %ebp
  8035d2:	c3                   	ret    
  8035d3:	90                   	nop
  8035d4:	89 fd                	mov    %edi,%ebp
  8035d6:	85 ff                	test   %edi,%edi
  8035d8:	75 0b                	jne    8035e5 <__umoddi3+0xe9>
  8035da:	b8 01 00 00 00       	mov    $0x1,%eax
  8035df:	31 d2                	xor    %edx,%edx
  8035e1:	f7 f7                	div    %edi
  8035e3:	89 c5                	mov    %eax,%ebp
  8035e5:	89 f0                	mov    %esi,%eax
  8035e7:	31 d2                	xor    %edx,%edx
  8035e9:	f7 f5                	div    %ebp
  8035eb:	89 c8                	mov    %ecx,%eax
  8035ed:	f7 f5                	div    %ebp
  8035ef:	89 d0                	mov    %edx,%eax
  8035f1:	e9 44 ff ff ff       	jmp    80353a <__umoddi3+0x3e>
  8035f6:	66 90                	xchg   %ax,%ax
  8035f8:	89 c8                	mov    %ecx,%eax
  8035fa:	89 f2                	mov    %esi,%edx
  8035fc:	83 c4 1c             	add    $0x1c,%esp
  8035ff:	5b                   	pop    %ebx
  803600:	5e                   	pop    %esi
  803601:	5f                   	pop    %edi
  803602:	5d                   	pop    %ebp
  803603:	c3                   	ret    
  803604:	3b 04 24             	cmp    (%esp),%eax
  803607:	72 06                	jb     80360f <__umoddi3+0x113>
  803609:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80360d:	77 0f                	ja     80361e <__umoddi3+0x122>
  80360f:	89 f2                	mov    %esi,%edx
  803611:	29 f9                	sub    %edi,%ecx
  803613:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803617:	89 14 24             	mov    %edx,(%esp)
  80361a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80361e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803622:	8b 14 24             	mov    (%esp),%edx
  803625:	83 c4 1c             	add    $0x1c,%esp
  803628:	5b                   	pop    %ebx
  803629:	5e                   	pop    %esi
  80362a:	5f                   	pop    %edi
  80362b:	5d                   	pop    %ebp
  80362c:	c3                   	ret    
  80362d:	8d 76 00             	lea    0x0(%esi),%esi
  803630:	2b 04 24             	sub    (%esp),%eax
  803633:	19 fa                	sbb    %edi,%edx
  803635:	89 d1                	mov    %edx,%ecx
  803637:	89 c6                	mov    %eax,%esi
  803639:	e9 71 ff ff ff       	jmp    8035af <__umoddi3+0xb3>
  80363e:	66 90                	xchg   %ax,%ax
  803640:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803644:	72 ea                	jb     803630 <__umoddi3+0x134>
  803646:	89 d9                	mov    %ebx,%ecx
  803648:	e9 62 ff ff ff       	jmp    8035af <__umoddi3+0xb3>
