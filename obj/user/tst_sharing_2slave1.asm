
obj/user/tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 7c 02 00 00       	call   8002b2 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program1: Read the 2 shared variables, edit the 3rd one, and exit
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp
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
  80005c:	68 c0 36 80 00       	push   $0x8036c0
  800061:	6a 0d                	push   $0xd
  800063:	68 dc 36 80 00       	push   $0x8036dc
  800068:	e8 8a 03 00 00       	call   8003f7 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006d:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)

	uint32 *x,*y,*z, *expectedVA;
	int freeFrames, diff, expected;
	int32 parentenvID = sys_getparentenvid();
  800074:	e8 a2 1d 00 00       	call   801e1b <sys_getparentenvid>
  800079:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80007c:	e8 05 1b 00 00       	call   801b86 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800081:	e8 b3 1b 00 00       	call   801c39 <sys_calculate_free_frames>
  800086:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	68 f7 36 80 00       	push   $0x8036f7
  800091:	ff 75 f0             	pushl  -0x10(%ebp)
  800094:	e8 1d 18 00 00       	call   8018b6 <sget>
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
  8000b6:	68 fc 36 80 00       	push   $0x8036fc
  8000bb:	6a 21                	push   $0x21
  8000bd:	68 dc 36 80 00       	push   $0x8036dc
  8000c2:	e8 30 03 00 00       	call   8003f7 <_panic>
		expected = 1 ; /*1table*/
  8000c7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000ce:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000d1:	e8 63 1b 00 00       	call   801c39 <sys_calculate_free_frames>
  8000d6:	29 c3                	sub    %eax,%ebx
  8000d8:	89 d8                	mov    %ebx,%eax
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000e0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000e3:	74 24                	je     800109 <_main+0xd1>
  8000e5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000e8:	e8 4c 1b 00 00       	call   801c39 <sys_calculate_free_frames>
  8000ed:	29 c3                	sub    %eax,%ebx
  8000ef:	89 d8                	mov    %ebx,%eax
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	50                   	push   %eax
  8000f8:	68 78 37 80 00       	push   $0x803778
  8000fd:	6a 24                	push   $0x24
  8000ff:	68 dc 36 80 00       	push   $0x8036dc
  800104:	e8 ee 02 00 00       	call   8003f7 <_panic>
	}
	sys_unlock_cons();
  800109:	e8 92 1a 00 00       	call   801ba0 <sys_unlock_cons>
	//sys_unlock_cons();

	//sys_lock_cons();
	sys_lock_cons();
  80010e:	e8 73 1a 00 00       	call   801b86 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800113:	e8 21 1b 00 00       	call   801c39 <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
		y = sget(parentenvID,"y");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 10 38 80 00       	push   $0x803810
  800123:	ff 75 f0             	pushl  -0x10(%ebp)
  800126:	e8 8b 17 00 00       	call   8018b6 <sget>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 1 * PAGE_SIZE);
  800131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800134:	05 00 10 00 00       	add    $0x1000,%eax
  800139:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (y != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, y);
  80013c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80013f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800142:	74 1a                	je     80015e <_main+0x126>
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	ff 75 d8             	pushl  -0x28(%ebp)
  80014a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80014d:	68 fc 36 80 00       	push   $0x8036fc
  800152:	6a 2f                	push   $0x2f
  800154:	68 dc 36 80 00       	push   $0x8036dc
  800159:	e8 99 02 00 00       	call   8003f7 <_panic>
		expected = 0 ;
  80015e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800165:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800168:	e8 cc 1a 00 00       	call   801c39 <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800177:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80017a:	74 24                	je     8001a0 <_main+0x168>
  80017c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80017f:	e8 b5 1a 00 00       	call   801c39 <sys_calculate_free_frames>
  800184:	29 c3                	sub    %eax,%ebx
  800186:	89 d8                	mov    %ebx,%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 e0             	pushl  -0x20(%ebp)
  80018e:	50                   	push   %eax
  80018f:	68 78 37 80 00       	push   $0x803778
  800194:	6a 32                	push   $0x32
  800196:	68 dc 36 80 00       	push   $0x8036dc
  80019b:	e8 57 02 00 00       	call   8003f7 <_panic>
	}
	sys_unlock_cons();
  8001a0:	e8 fb 19 00 00       	call   801ba0 <sys_unlock_cons>
	//sys_unlock_cons();

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  8001a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001a8:	8b 00                	mov    (%eax),%eax
  8001aa:	83 f8 14             	cmp    $0x14,%eax
  8001ad:	74 14                	je     8001c3 <_main+0x18b>
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	68 14 38 80 00       	push   $0x803814
  8001b7:	6a 37                	push   $0x37
  8001b9:	68 dc 36 80 00       	push   $0x8036dc
  8001be:	e8 34 02 00 00       	call   8003f7 <_panic>

	//sys_lock_cons();
	sys_lock_cons();
  8001c3:	e8 be 19 00 00       	call   801b86 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  8001c8:	e8 6c 1a 00 00       	call   801c39 <sys_calculate_free_frames>
  8001cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  8001d0:	83 ec 08             	sub    $0x8,%esp
  8001d3:	68 4b 38 80 00       	push   $0x80384b
  8001d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8001db:	e8 d6 16 00 00       	call   8018b6 <sget>
  8001e0:	83 c4 10             	add    $0x10,%esp
  8001e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 2 * PAGE_SIZE);
  8001e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001e9:	05 00 20 00 00       	add    $0x2000,%eax
  8001ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, x);
  8001f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001f4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001f7:	74 1a                	je     800213 <_main+0x1db>
  8001f9:	83 ec 0c             	sub    $0xc,%esp
  8001fc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800202:	68 fc 36 80 00       	push   $0x8036fc
  800207:	6a 3f                	push   $0x3f
  800209:	68 dc 36 80 00       	push   $0x8036dc
  80020e:	e8 e4 01 00 00       	call   8003f7 <_panic>
		expected = 0 ;
  800213:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80021a:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80021d:	e8 17 1a 00 00       	call   801c39 <sys_calculate_free_frames>
  800222:	29 c3                	sub    %eax,%ebx
  800224:	89 d8                	mov    %ebx,%eax
  800226:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800229:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80022c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80022f:	74 24                	je     800255 <_main+0x21d>
  800231:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800234:	e8 00 1a 00 00       	call   801c39 <sys_calculate_free_frames>
  800239:	29 c3                	sub    %eax,%ebx
  80023b:	89 d8                	mov    %ebx,%eax
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	ff 75 e0             	pushl  -0x20(%ebp)
  800243:	50                   	push   %eax
  800244:	68 78 37 80 00       	push   $0x803778
  800249:	6a 42                	push   $0x42
  80024b:	68 dc 36 80 00       	push   $0x8036dc
  800250:	e8 a2 01 00 00       	call   8003f7 <_panic>
	}
	sys_unlock_cons();
  800255:	e8 46 19 00 00       	call   801ba0 <sys_unlock_cons>
	//sys_unlock_cons();

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  80025a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80025d:	8b 00                	mov    (%eax),%eax
  80025f:	83 f8 0a             	cmp    $0xa,%eax
  800262:	74 14                	je     800278 <_main+0x240>
  800264:	83 ec 04             	sub    $0x4,%esp
  800267:	68 14 38 80 00       	push   $0x803814
  80026c:	6a 47                	push   $0x47
  80026e:	68 dc 36 80 00       	push   $0x8036dc
  800273:	e8 7f 01 00 00       	call   8003f7 <_panic>

	*z = *x + *y ;
  800278:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80027b:	8b 10                	mov    (%eax),%edx
  80027d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800280:	8b 00                	mov    (%eax),%eax
  800282:	01 c2                	add    %eax,%edx
  800284:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800287:	89 10                	mov    %edx,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  800289:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028c:	8b 00                	mov    (%eax),%eax
  80028e:	83 f8 1e             	cmp    $0x1e,%eax
  800291:	74 14                	je     8002a7 <_main+0x26f>
  800293:	83 ec 04             	sub    $0x4,%esp
  800296:	68 14 38 80 00       	push   $0x803814
  80029b:	6a 4a                	push   $0x4a
  80029d:	68 dc 36 80 00       	push   $0x8036dc
  8002a2:	e8 50 01 00 00       	call   8003f7 <_panic>

	//To indicate that it's completed successfully
	inctst();
  8002a7:	e8 94 1c 00 00       	call   801f40 <inctst>

	return;
  8002ac:	90                   	nop
}
  8002ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002b0:	c9                   	leave  
  8002b1:	c3                   	ret    

008002b2 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
  8002b5:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002b8:	e8 45 1b 00 00       	call   801e02 <sys_getenvindex>
  8002bd:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8002c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002c3:	89 d0                	mov    %edx,%eax
  8002c5:	c1 e0 02             	shl    $0x2,%eax
  8002c8:	01 d0                	add    %edx,%eax
  8002ca:	c1 e0 03             	shl    $0x3,%eax
  8002cd:	01 d0                	add    %edx,%eax
  8002cf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d6:	01 d0                	add    %edx,%eax
  8002d8:	c1 e0 02             	shl    $0x2,%eax
  8002db:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e0:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ea:	8a 40 20             	mov    0x20(%eax),%al
  8002ed:	84 c0                	test   %al,%al
  8002ef:	74 0d                	je     8002fe <libmain+0x4c>
		binaryname = myEnv->prog_name;
  8002f1:	a1 20 50 80 00       	mov    0x805020,%eax
  8002f6:	83 c0 20             	add    $0x20,%eax
  8002f9:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800302:	7e 0a                	jle    80030e <libmain+0x5c>
		binaryname = argv[0];
  800304:	8b 45 0c             	mov    0xc(%ebp),%eax
  800307:	8b 00                	mov    (%eax),%eax
  800309:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80030e:	83 ec 08             	sub    $0x8,%esp
  800311:	ff 75 0c             	pushl  0xc(%ebp)
  800314:	ff 75 08             	pushl  0x8(%ebp)
  800317:	e8 1c fd ff ff       	call   800038 <_main>
  80031c:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80031f:	a1 00 50 80 00       	mov    0x805000,%eax
  800324:	85 c0                	test   %eax,%eax
  800326:	0f 84 9f 00 00 00    	je     8003cb <libmain+0x119>
	{
		sys_lock_cons();
  80032c:	e8 55 18 00 00       	call   801b86 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800331:	83 ec 0c             	sub    $0xc,%esp
  800334:	68 68 38 80 00       	push   $0x803868
  800339:	e8 76 03 00 00       	call   8006b4 <cprintf>
  80033e:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800341:	a1 20 50 80 00       	mov    0x805020,%eax
  800346:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80034c:	a1 20 50 80 00       	mov    0x805020,%eax
  800351:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800357:	83 ec 04             	sub    $0x4,%esp
  80035a:	52                   	push   %edx
  80035b:	50                   	push   %eax
  80035c:	68 90 38 80 00       	push   $0x803890
  800361:	e8 4e 03 00 00       	call   8006b4 <cprintf>
  800366:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800369:	a1 20 50 80 00       	mov    0x805020,%eax
  80036e:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800374:	a1 20 50 80 00       	mov    0x805020,%eax
  800379:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80037f:	a1 20 50 80 00       	mov    0x805020,%eax
  800384:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80038a:	51                   	push   %ecx
  80038b:	52                   	push   %edx
  80038c:	50                   	push   %eax
  80038d:	68 b8 38 80 00       	push   $0x8038b8
  800392:	e8 1d 03 00 00       	call   8006b4 <cprintf>
  800397:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80039a:	a1 20 50 80 00       	mov    0x805020,%eax
  80039f:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8003a5:	83 ec 08             	sub    $0x8,%esp
  8003a8:	50                   	push   %eax
  8003a9:	68 10 39 80 00       	push   $0x803910
  8003ae:	e8 01 03 00 00       	call   8006b4 <cprintf>
  8003b3:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003b6:	83 ec 0c             	sub    $0xc,%esp
  8003b9:	68 68 38 80 00       	push   $0x803868
  8003be:	e8 f1 02 00 00       	call   8006b4 <cprintf>
  8003c3:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8003c6:	e8 d5 17 00 00       	call   801ba0 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8003cb:	e8 19 00 00 00       	call   8003e9 <exit>
}
  8003d0:	90                   	nop
  8003d1:	c9                   	leave  
  8003d2:	c3                   	ret    

008003d3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003d9:	83 ec 0c             	sub    $0xc,%esp
  8003dc:	6a 00                	push   $0x0
  8003de:	e8 eb 19 00 00       	call   801dce <sys_destroy_env>
  8003e3:	83 c4 10             	add    $0x10,%esp
}
  8003e6:	90                   	nop
  8003e7:	c9                   	leave  
  8003e8:	c3                   	ret    

008003e9 <exit>:

void
exit(void)
{
  8003e9:	55                   	push   %ebp
  8003ea:	89 e5                	mov    %esp,%ebp
  8003ec:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003ef:	e8 40 1a 00 00       	call   801e34 <sys_exit_env>
}
  8003f4:	90                   	nop
  8003f5:	c9                   	leave  
  8003f6:	c3                   	ret    

008003f7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003f7:	55                   	push   %ebp
  8003f8:	89 e5                	mov    %esp,%ebp
  8003fa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003fd:	8d 45 10             	lea    0x10(%ebp),%eax
  800400:	83 c0 04             	add    $0x4,%eax
  800403:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800406:	a1 60 50 98 00       	mov    0x985060,%eax
  80040b:	85 c0                	test   %eax,%eax
  80040d:	74 16                	je     800425 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80040f:	a1 60 50 98 00       	mov    0x985060,%eax
  800414:	83 ec 08             	sub    $0x8,%esp
  800417:	50                   	push   %eax
  800418:	68 24 39 80 00       	push   $0x803924
  80041d:	e8 92 02 00 00       	call   8006b4 <cprintf>
  800422:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800425:	a1 04 50 80 00       	mov    0x805004,%eax
  80042a:	ff 75 0c             	pushl  0xc(%ebp)
  80042d:	ff 75 08             	pushl  0x8(%ebp)
  800430:	50                   	push   %eax
  800431:	68 29 39 80 00       	push   $0x803929
  800436:	e8 79 02 00 00       	call   8006b4 <cprintf>
  80043b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80043e:	8b 45 10             	mov    0x10(%ebp),%eax
  800441:	83 ec 08             	sub    $0x8,%esp
  800444:	ff 75 f4             	pushl  -0xc(%ebp)
  800447:	50                   	push   %eax
  800448:	e8 fc 01 00 00       	call   800649 <vcprintf>
  80044d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800450:	83 ec 08             	sub    $0x8,%esp
  800453:	6a 00                	push   $0x0
  800455:	68 45 39 80 00       	push   $0x803945
  80045a:	e8 ea 01 00 00       	call   800649 <vcprintf>
  80045f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800462:	e8 82 ff ff ff       	call   8003e9 <exit>

	// should not return here
	while (1) ;
  800467:	eb fe                	jmp    800467 <_panic+0x70>

00800469 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800469:	55                   	push   %ebp
  80046a:	89 e5                	mov    %esp,%ebp
  80046c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80046f:	a1 20 50 80 00       	mov    0x805020,%eax
  800474:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80047a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047d:	39 c2                	cmp    %eax,%edx
  80047f:	74 14                	je     800495 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800481:	83 ec 04             	sub    $0x4,%esp
  800484:	68 48 39 80 00       	push   $0x803948
  800489:	6a 26                	push   $0x26
  80048b:	68 94 39 80 00       	push   $0x803994
  800490:	e8 62 ff ff ff       	call   8003f7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800495:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80049c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004a3:	e9 c5 00 00 00       	jmp    80056d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	01 d0                	add    %edx,%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	85 c0                	test   %eax,%eax
  8004bb:	75 08                	jne    8004c5 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004bd:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004c0:	e9 a5 00 00 00       	jmp    80056a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004cc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004d3:	eb 69                	jmp    80053e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004d5:	a1 20 50 80 00       	mov    0x805020,%eax
  8004da:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8004e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004e3:	89 d0                	mov    %edx,%eax
  8004e5:	01 c0                	add    %eax,%eax
  8004e7:	01 d0                	add    %edx,%eax
  8004e9:	c1 e0 03             	shl    $0x3,%eax
  8004ec:	01 c8                	add    %ecx,%eax
  8004ee:	8a 40 04             	mov    0x4(%eax),%al
  8004f1:	84 c0                	test   %al,%al
  8004f3:	75 46                	jne    80053b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004f5:	a1 20 50 80 00       	mov    0x805020,%eax
  8004fa:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800500:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800503:	89 d0                	mov    %edx,%eax
  800505:	01 c0                	add    %eax,%eax
  800507:	01 d0                	add    %edx,%eax
  800509:	c1 e0 03             	shl    $0x3,%eax
  80050c:	01 c8                	add    %ecx,%eax
  80050e:	8b 00                	mov    (%eax),%eax
  800510:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800513:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800516:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80051b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80051d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800520:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800527:	8b 45 08             	mov    0x8(%ebp),%eax
  80052a:	01 c8                	add    %ecx,%eax
  80052c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80052e:	39 c2                	cmp    %eax,%edx
  800530:	75 09                	jne    80053b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800532:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800539:	eb 15                	jmp    800550 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053b:	ff 45 e8             	incl   -0x18(%ebp)
  80053e:	a1 20 50 80 00       	mov    0x805020,%eax
  800543:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800549:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80054c:	39 c2                	cmp    %eax,%edx
  80054e:	77 85                	ja     8004d5 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800550:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800554:	75 14                	jne    80056a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800556:	83 ec 04             	sub    $0x4,%esp
  800559:	68 a0 39 80 00       	push   $0x8039a0
  80055e:	6a 3a                	push   $0x3a
  800560:	68 94 39 80 00       	push   $0x803994
  800565:	e8 8d fe ff ff       	call   8003f7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80056a:	ff 45 f0             	incl   -0x10(%ebp)
  80056d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800570:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800573:	0f 8c 2f ff ff ff    	jl     8004a8 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800579:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800580:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800587:	eb 26                	jmp    8005af <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800589:	a1 20 50 80 00       	mov    0x805020,%eax
  80058e:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800594:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800597:	89 d0                	mov    %edx,%eax
  800599:	01 c0                	add    %eax,%eax
  80059b:	01 d0                	add    %edx,%eax
  80059d:	c1 e0 03             	shl    $0x3,%eax
  8005a0:	01 c8                	add    %ecx,%eax
  8005a2:	8a 40 04             	mov    0x4(%eax),%al
  8005a5:	3c 01                	cmp    $0x1,%al
  8005a7:	75 03                	jne    8005ac <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005a9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ac:	ff 45 e0             	incl   -0x20(%ebp)
  8005af:	a1 20 50 80 00       	mov    0x805020,%eax
  8005b4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8005ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005bd:	39 c2                	cmp    %eax,%edx
  8005bf:	77 c8                	ja     800589 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005c4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005c7:	74 14                	je     8005dd <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005c9:	83 ec 04             	sub    $0x4,%esp
  8005cc:	68 f4 39 80 00       	push   $0x8039f4
  8005d1:	6a 44                	push   $0x44
  8005d3:	68 94 39 80 00       	push   $0x803994
  8005d8:	e8 1a fe ff ff       	call   8003f7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005dd:	90                   	nop
  8005de:	c9                   	leave  
  8005df:	c3                   	ret    

008005e0 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
  8005e3:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e9:	8b 00                	mov    (%eax),%eax
  8005eb:	8d 48 01             	lea    0x1(%eax),%ecx
  8005ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f1:	89 0a                	mov    %ecx,(%edx)
  8005f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8005f6:	88 d1                	mov    %dl,%cl
  8005f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005fb:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800602:	8b 00                	mov    (%eax),%eax
  800604:	3d ff 00 00 00       	cmp    $0xff,%eax
  800609:	75 2c                	jne    800637 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80060b:	a0 44 50 98 00       	mov    0x985044,%al
  800610:	0f b6 c0             	movzbl %al,%eax
  800613:	8b 55 0c             	mov    0xc(%ebp),%edx
  800616:	8b 12                	mov    (%edx),%edx
  800618:	89 d1                	mov    %edx,%ecx
  80061a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80061d:	83 c2 08             	add    $0x8,%edx
  800620:	83 ec 04             	sub    $0x4,%esp
  800623:	50                   	push   %eax
  800624:	51                   	push   %ecx
  800625:	52                   	push   %edx
  800626:	e8 19 15 00 00       	call   801b44 <sys_cputs>
  80062b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80062e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800631:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800637:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063a:	8b 40 04             	mov    0x4(%eax),%eax
  80063d:	8d 50 01             	lea    0x1(%eax),%edx
  800640:	8b 45 0c             	mov    0xc(%ebp),%eax
  800643:	89 50 04             	mov    %edx,0x4(%eax)
}
  800646:	90                   	nop
  800647:	c9                   	leave  
  800648:	c3                   	ret    

00800649 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800649:	55                   	push   %ebp
  80064a:	89 e5                	mov    %esp,%ebp
  80064c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800652:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800659:	00 00 00 
	b.cnt = 0;
  80065c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800663:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800666:	ff 75 0c             	pushl  0xc(%ebp)
  800669:	ff 75 08             	pushl  0x8(%ebp)
  80066c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800672:	50                   	push   %eax
  800673:	68 e0 05 80 00       	push   $0x8005e0
  800678:	e8 11 02 00 00       	call   80088e <vprintfmt>
  80067d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800680:	a0 44 50 98 00       	mov    0x985044,%al
  800685:	0f b6 c0             	movzbl %al,%eax
  800688:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80068e:	83 ec 04             	sub    $0x4,%esp
  800691:	50                   	push   %eax
  800692:	52                   	push   %edx
  800693:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800699:	83 c0 08             	add    $0x8,%eax
  80069c:	50                   	push   %eax
  80069d:	e8 a2 14 00 00       	call   801b44 <sys_cputs>
  8006a2:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006a5:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  8006ac:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006b2:	c9                   	leave  
  8006b3:	c3                   	ret    

008006b4 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006b4:	55                   	push   %ebp
  8006b5:	89 e5                	mov    %esp,%ebp
  8006b7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006ba:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  8006c1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	83 ec 08             	sub    $0x8,%esp
  8006cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8006d0:	50                   	push   %eax
  8006d1:	e8 73 ff ff ff       	call   800649 <vcprintf>
  8006d6:	83 c4 10             	add    $0x10,%esp
  8006d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006df:	c9                   	leave  
  8006e0:	c3                   	ret    

008006e1 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
  8006e4:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006e7:	e8 9a 14 00 00       	call   801b86 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006ec:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	83 ec 08             	sub    $0x8,%esp
  8006f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8006fb:	50                   	push   %eax
  8006fc:	e8 48 ff ff ff       	call   800649 <vcprintf>
  800701:	83 c4 10             	add    $0x10,%esp
  800704:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800707:	e8 94 14 00 00       	call   801ba0 <sys_unlock_cons>
	return cnt;
  80070c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80070f:	c9                   	leave  
  800710:	c3                   	ret    

00800711 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800711:	55                   	push   %ebp
  800712:	89 e5                	mov    %esp,%ebp
  800714:	53                   	push   %ebx
  800715:	83 ec 14             	sub    $0x14,%esp
  800718:	8b 45 10             	mov    0x10(%ebp),%eax
  80071b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800724:	8b 45 18             	mov    0x18(%ebp),%eax
  800727:	ba 00 00 00 00       	mov    $0x0,%edx
  80072c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80072f:	77 55                	ja     800786 <printnum+0x75>
  800731:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800734:	72 05                	jb     80073b <printnum+0x2a>
  800736:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800739:	77 4b                	ja     800786 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80073b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80073e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800741:	8b 45 18             	mov    0x18(%ebp),%eax
  800744:	ba 00 00 00 00       	mov    $0x0,%edx
  800749:	52                   	push   %edx
  80074a:	50                   	push   %eax
  80074b:	ff 75 f4             	pushl  -0xc(%ebp)
  80074e:	ff 75 f0             	pushl  -0x10(%ebp)
  800751:	e8 f2 2c 00 00       	call   803448 <__udivdi3>
  800756:	83 c4 10             	add    $0x10,%esp
  800759:	83 ec 04             	sub    $0x4,%esp
  80075c:	ff 75 20             	pushl  0x20(%ebp)
  80075f:	53                   	push   %ebx
  800760:	ff 75 18             	pushl  0x18(%ebp)
  800763:	52                   	push   %edx
  800764:	50                   	push   %eax
  800765:	ff 75 0c             	pushl  0xc(%ebp)
  800768:	ff 75 08             	pushl  0x8(%ebp)
  80076b:	e8 a1 ff ff ff       	call   800711 <printnum>
  800770:	83 c4 20             	add    $0x20,%esp
  800773:	eb 1a                	jmp    80078f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800775:	83 ec 08             	sub    $0x8,%esp
  800778:	ff 75 0c             	pushl  0xc(%ebp)
  80077b:	ff 75 20             	pushl  0x20(%ebp)
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	ff d0                	call   *%eax
  800783:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800786:	ff 4d 1c             	decl   0x1c(%ebp)
  800789:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80078d:	7f e6                	jg     800775 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80078f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800792:	bb 00 00 00 00       	mov    $0x0,%ebx
  800797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80079a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80079d:	53                   	push   %ebx
  80079e:	51                   	push   %ecx
  80079f:	52                   	push   %edx
  8007a0:	50                   	push   %eax
  8007a1:	e8 b2 2d 00 00       	call   803558 <__umoddi3>
  8007a6:	83 c4 10             	add    $0x10,%esp
  8007a9:	05 54 3c 80 00       	add    $0x803c54,%eax
  8007ae:	8a 00                	mov    (%eax),%al
  8007b0:	0f be c0             	movsbl %al,%eax
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	ff 75 0c             	pushl  0xc(%ebp)
  8007b9:	50                   	push   %eax
  8007ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bd:	ff d0                	call   *%eax
  8007bf:	83 c4 10             	add    $0x10,%esp
}
  8007c2:	90                   	nop
  8007c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c6:	c9                   	leave  
  8007c7:	c3                   	ret    

008007c8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007c8:	55                   	push   %ebp
  8007c9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007cb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007cf:	7e 1c                	jle    8007ed <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	8d 50 08             	lea    0x8(%eax),%edx
  8007d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dc:	89 10                	mov    %edx,(%eax)
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	83 e8 08             	sub    $0x8,%eax
  8007e6:	8b 50 04             	mov    0x4(%eax),%edx
  8007e9:	8b 00                	mov    (%eax),%eax
  8007eb:	eb 40                	jmp    80082d <getuint+0x65>
	else if (lflag)
  8007ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007f1:	74 1e                	je     800811 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f6:	8b 00                	mov    (%eax),%eax
  8007f8:	8d 50 04             	lea    0x4(%eax),%edx
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	89 10                	mov    %edx,(%eax)
  800800:	8b 45 08             	mov    0x8(%ebp),%eax
  800803:	8b 00                	mov    (%eax),%eax
  800805:	83 e8 04             	sub    $0x4,%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	ba 00 00 00 00       	mov    $0x0,%edx
  80080f:	eb 1c                	jmp    80082d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	8b 00                	mov    (%eax),%eax
  800816:	8d 50 04             	lea    0x4(%eax),%edx
  800819:	8b 45 08             	mov    0x8(%ebp),%eax
  80081c:	89 10                	mov    %edx,(%eax)
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	8b 00                	mov    (%eax),%eax
  800823:	83 e8 04             	sub    $0x4,%eax
  800826:	8b 00                	mov    (%eax),%eax
  800828:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80082d:	5d                   	pop    %ebp
  80082e:	c3                   	ret    

0080082f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80082f:	55                   	push   %ebp
  800830:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800832:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800836:	7e 1c                	jle    800854 <getint+0x25>
		return va_arg(*ap, long long);
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	8d 50 08             	lea    0x8(%eax),%edx
  800840:	8b 45 08             	mov    0x8(%ebp),%eax
  800843:	89 10                	mov    %edx,(%eax)
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	8b 00                	mov    (%eax),%eax
  80084a:	83 e8 08             	sub    $0x8,%eax
  80084d:	8b 50 04             	mov    0x4(%eax),%edx
  800850:	8b 00                	mov    (%eax),%eax
  800852:	eb 38                	jmp    80088c <getint+0x5d>
	else if (lflag)
  800854:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800858:	74 1a                	je     800874 <getint+0x45>
		return va_arg(*ap, long);
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	8d 50 04             	lea    0x4(%eax),%edx
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	89 10                	mov    %edx,(%eax)
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	83 e8 04             	sub    $0x4,%eax
  80086f:	8b 00                	mov    (%eax),%eax
  800871:	99                   	cltd   
  800872:	eb 18                	jmp    80088c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	8b 00                	mov    (%eax),%eax
  800879:	8d 50 04             	lea    0x4(%eax),%edx
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	89 10                	mov    %edx,(%eax)
  800881:	8b 45 08             	mov    0x8(%ebp),%eax
  800884:	8b 00                	mov    (%eax),%eax
  800886:	83 e8 04             	sub    $0x4,%eax
  800889:	8b 00                	mov    (%eax),%eax
  80088b:	99                   	cltd   
}
  80088c:	5d                   	pop    %ebp
  80088d:	c3                   	ret    

0080088e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80088e:	55                   	push   %ebp
  80088f:	89 e5                	mov    %esp,%ebp
  800891:	56                   	push   %esi
  800892:	53                   	push   %ebx
  800893:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800896:	eb 17                	jmp    8008af <vprintfmt+0x21>
			if (ch == '\0')
  800898:	85 db                	test   %ebx,%ebx
  80089a:	0f 84 c1 03 00 00    	je     800c61 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8008a0:	83 ec 08             	sub    $0x8,%esp
  8008a3:	ff 75 0c             	pushl  0xc(%ebp)
  8008a6:	53                   	push   %ebx
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	ff d0                	call   *%eax
  8008ac:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008af:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b2:	8d 50 01             	lea    0x1(%eax),%edx
  8008b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8008b8:	8a 00                	mov    (%eax),%al
  8008ba:	0f b6 d8             	movzbl %al,%ebx
  8008bd:	83 fb 25             	cmp    $0x25,%ebx
  8008c0:	75 d6                	jne    800898 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008c2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008c6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008cd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008d4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008db:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e5:	8d 50 01             	lea    0x1(%eax),%edx
  8008e8:	89 55 10             	mov    %edx,0x10(%ebp)
  8008eb:	8a 00                	mov    (%eax),%al
  8008ed:	0f b6 d8             	movzbl %al,%ebx
  8008f0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008f3:	83 f8 5b             	cmp    $0x5b,%eax
  8008f6:	0f 87 3d 03 00 00    	ja     800c39 <vprintfmt+0x3ab>
  8008fc:	8b 04 85 78 3c 80 00 	mov    0x803c78(,%eax,4),%eax
  800903:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800905:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800909:	eb d7                	jmp    8008e2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80090b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80090f:	eb d1                	jmp    8008e2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800911:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800918:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80091b:	89 d0                	mov    %edx,%eax
  80091d:	c1 e0 02             	shl    $0x2,%eax
  800920:	01 d0                	add    %edx,%eax
  800922:	01 c0                	add    %eax,%eax
  800924:	01 d8                	add    %ebx,%eax
  800926:	83 e8 30             	sub    $0x30,%eax
  800929:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80092c:	8b 45 10             	mov    0x10(%ebp),%eax
  80092f:	8a 00                	mov    (%eax),%al
  800931:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800934:	83 fb 2f             	cmp    $0x2f,%ebx
  800937:	7e 3e                	jle    800977 <vprintfmt+0xe9>
  800939:	83 fb 39             	cmp    $0x39,%ebx
  80093c:	7f 39                	jg     800977 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80093e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800941:	eb d5                	jmp    800918 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800943:	8b 45 14             	mov    0x14(%ebp),%eax
  800946:	83 c0 04             	add    $0x4,%eax
  800949:	89 45 14             	mov    %eax,0x14(%ebp)
  80094c:	8b 45 14             	mov    0x14(%ebp),%eax
  80094f:	83 e8 04             	sub    $0x4,%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800957:	eb 1f                	jmp    800978 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800959:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095d:	79 83                	jns    8008e2 <vprintfmt+0x54>
				width = 0;
  80095f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800966:	e9 77 ff ff ff       	jmp    8008e2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80096b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800972:	e9 6b ff ff ff       	jmp    8008e2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800977:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800978:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80097c:	0f 89 60 ff ff ff    	jns    8008e2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800982:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800985:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800988:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80098f:	e9 4e ff ff ff       	jmp    8008e2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800994:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800997:	e9 46 ff ff ff       	jmp    8008e2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80099c:	8b 45 14             	mov    0x14(%ebp),%eax
  80099f:	83 c0 04             	add    $0x4,%eax
  8009a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a8:	83 e8 04             	sub    $0x4,%eax
  8009ab:	8b 00                	mov    (%eax),%eax
  8009ad:	83 ec 08             	sub    $0x8,%esp
  8009b0:	ff 75 0c             	pushl  0xc(%ebp)
  8009b3:	50                   	push   %eax
  8009b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b7:	ff d0                	call   *%eax
  8009b9:	83 c4 10             	add    $0x10,%esp
			break;
  8009bc:	e9 9b 02 00 00       	jmp    800c5c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c4:	83 c0 04             	add    $0x4,%eax
  8009c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cd:	83 e8 04             	sub    $0x4,%eax
  8009d0:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009d2:	85 db                	test   %ebx,%ebx
  8009d4:	79 02                	jns    8009d8 <vprintfmt+0x14a>
				err = -err;
  8009d6:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009d8:	83 fb 64             	cmp    $0x64,%ebx
  8009db:	7f 0b                	jg     8009e8 <vprintfmt+0x15a>
  8009dd:	8b 34 9d c0 3a 80 00 	mov    0x803ac0(,%ebx,4),%esi
  8009e4:	85 f6                	test   %esi,%esi
  8009e6:	75 19                	jne    800a01 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e8:	53                   	push   %ebx
  8009e9:	68 65 3c 80 00       	push   $0x803c65
  8009ee:	ff 75 0c             	pushl  0xc(%ebp)
  8009f1:	ff 75 08             	pushl  0x8(%ebp)
  8009f4:	e8 70 02 00 00       	call   800c69 <printfmt>
  8009f9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009fc:	e9 5b 02 00 00       	jmp    800c5c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a01:	56                   	push   %esi
  800a02:	68 6e 3c 80 00       	push   $0x803c6e
  800a07:	ff 75 0c             	pushl  0xc(%ebp)
  800a0a:	ff 75 08             	pushl  0x8(%ebp)
  800a0d:	e8 57 02 00 00       	call   800c69 <printfmt>
  800a12:	83 c4 10             	add    $0x10,%esp
			break;
  800a15:	e9 42 02 00 00       	jmp    800c5c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1d:	83 c0 04             	add    $0x4,%eax
  800a20:	89 45 14             	mov    %eax,0x14(%ebp)
  800a23:	8b 45 14             	mov    0x14(%ebp),%eax
  800a26:	83 e8 04             	sub    $0x4,%eax
  800a29:	8b 30                	mov    (%eax),%esi
  800a2b:	85 f6                	test   %esi,%esi
  800a2d:	75 05                	jne    800a34 <vprintfmt+0x1a6>
				p = "(null)";
  800a2f:	be 71 3c 80 00       	mov    $0x803c71,%esi
			if (width > 0 && padc != '-')
  800a34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a38:	7e 6d                	jle    800aa7 <vprintfmt+0x219>
  800a3a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a3e:	74 67                	je     800aa7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	50                   	push   %eax
  800a47:	56                   	push   %esi
  800a48:	e8 1e 03 00 00       	call   800d6b <strnlen>
  800a4d:	83 c4 10             	add    $0x10,%esp
  800a50:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a53:	eb 16                	jmp    800a6b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a55:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a59:	83 ec 08             	sub    $0x8,%esp
  800a5c:	ff 75 0c             	pushl  0xc(%ebp)
  800a5f:	50                   	push   %eax
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	ff d0                	call   *%eax
  800a65:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a68:	ff 4d e4             	decl   -0x1c(%ebp)
  800a6b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6f:	7f e4                	jg     800a55 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a71:	eb 34                	jmp    800aa7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a73:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a77:	74 1c                	je     800a95 <vprintfmt+0x207>
  800a79:	83 fb 1f             	cmp    $0x1f,%ebx
  800a7c:	7e 05                	jle    800a83 <vprintfmt+0x1f5>
  800a7e:	83 fb 7e             	cmp    $0x7e,%ebx
  800a81:	7e 12                	jle    800a95 <vprintfmt+0x207>
					putch('?', putdat);
  800a83:	83 ec 08             	sub    $0x8,%esp
  800a86:	ff 75 0c             	pushl  0xc(%ebp)
  800a89:	6a 3f                	push   $0x3f
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	ff d0                	call   *%eax
  800a90:	83 c4 10             	add    $0x10,%esp
  800a93:	eb 0f                	jmp    800aa4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	53                   	push   %ebx
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aa4:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa7:	89 f0                	mov    %esi,%eax
  800aa9:	8d 70 01             	lea    0x1(%eax),%esi
  800aac:	8a 00                	mov    (%eax),%al
  800aae:	0f be d8             	movsbl %al,%ebx
  800ab1:	85 db                	test   %ebx,%ebx
  800ab3:	74 24                	je     800ad9 <vprintfmt+0x24b>
  800ab5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab9:	78 b8                	js     800a73 <vprintfmt+0x1e5>
  800abb:	ff 4d e0             	decl   -0x20(%ebp)
  800abe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ac2:	79 af                	jns    800a73 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac4:	eb 13                	jmp    800ad9 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ac6:	83 ec 08             	sub    $0x8,%esp
  800ac9:	ff 75 0c             	pushl  0xc(%ebp)
  800acc:	6a 20                	push   $0x20
  800ace:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad1:	ff d0                	call   *%eax
  800ad3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad6:	ff 4d e4             	decl   -0x1c(%ebp)
  800ad9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800add:	7f e7                	jg     800ac6 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800adf:	e9 78 01 00 00       	jmp    800c5c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 e8             	pushl  -0x18(%ebp)
  800aea:	8d 45 14             	lea    0x14(%ebp),%eax
  800aed:	50                   	push   %eax
  800aee:	e8 3c fd ff ff       	call   80082f <getint>
  800af3:	83 c4 10             	add    $0x10,%esp
  800af6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b02:	85 d2                	test   %edx,%edx
  800b04:	79 23                	jns    800b29 <vprintfmt+0x29b>
				putch('-', putdat);
  800b06:	83 ec 08             	sub    $0x8,%esp
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	6a 2d                	push   $0x2d
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	ff d0                	call   *%eax
  800b13:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b1c:	f7 d8                	neg    %eax
  800b1e:	83 d2 00             	adc    $0x0,%edx
  800b21:	f7 da                	neg    %edx
  800b23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b26:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b29:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b30:	e9 bc 00 00 00       	jmp    800bf1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b35:	83 ec 08             	sub    $0x8,%esp
  800b38:	ff 75 e8             	pushl  -0x18(%ebp)
  800b3b:	8d 45 14             	lea    0x14(%ebp),%eax
  800b3e:	50                   	push   %eax
  800b3f:	e8 84 fc ff ff       	call   8007c8 <getuint>
  800b44:	83 c4 10             	add    $0x10,%esp
  800b47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b4d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b54:	e9 98 00 00 00       	jmp    800bf1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b59:	83 ec 08             	sub    $0x8,%esp
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	6a 58                	push   $0x58
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	ff d0                	call   *%eax
  800b66:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b69:	83 ec 08             	sub    $0x8,%esp
  800b6c:	ff 75 0c             	pushl  0xc(%ebp)
  800b6f:	6a 58                	push   $0x58
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	ff d0                	call   *%eax
  800b76:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b79:	83 ec 08             	sub    $0x8,%esp
  800b7c:	ff 75 0c             	pushl  0xc(%ebp)
  800b7f:	6a 58                	push   $0x58
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	ff d0                	call   *%eax
  800b86:	83 c4 10             	add    $0x10,%esp
			break;
  800b89:	e9 ce 00 00 00       	jmp    800c5c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b8e:	83 ec 08             	sub    $0x8,%esp
  800b91:	ff 75 0c             	pushl  0xc(%ebp)
  800b94:	6a 30                	push   $0x30
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	ff d0                	call   *%eax
  800b9b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b9e:	83 ec 08             	sub    $0x8,%esp
  800ba1:	ff 75 0c             	pushl  0xc(%ebp)
  800ba4:	6a 78                	push   $0x78
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	ff d0                	call   *%eax
  800bab:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bae:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb1:	83 c0 04             	add    $0x4,%eax
  800bb4:	89 45 14             	mov    %eax,0x14(%ebp)
  800bb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bba:	83 e8 04             	sub    $0x4,%eax
  800bbd:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bc9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bd0:	eb 1f                	jmp    800bf1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bd2:	83 ec 08             	sub    $0x8,%esp
  800bd5:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd8:	8d 45 14             	lea    0x14(%ebp),%eax
  800bdb:	50                   	push   %eax
  800bdc:	e8 e7 fb ff ff       	call   8007c8 <getuint>
  800be1:	83 c4 10             	add    $0x10,%esp
  800be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bea:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bf1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bf8:	83 ec 04             	sub    $0x4,%esp
  800bfb:	52                   	push   %edx
  800bfc:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bff:	50                   	push   %eax
  800c00:	ff 75 f4             	pushl  -0xc(%ebp)
  800c03:	ff 75 f0             	pushl  -0x10(%ebp)
  800c06:	ff 75 0c             	pushl  0xc(%ebp)
  800c09:	ff 75 08             	pushl  0x8(%ebp)
  800c0c:	e8 00 fb ff ff       	call   800711 <printnum>
  800c11:	83 c4 20             	add    $0x20,%esp
			break;
  800c14:	eb 46                	jmp    800c5c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c16:	83 ec 08             	sub    $0x8,%esp
  800c19:	ff 75 0c             	pushl  0xc(%ebp)
  800c1c:	53                   	push   %ebx
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	ff d0                	call   *%eax
  800c22:	83 c4 10             	add    $0x10,%esp
			break;
  800c25:	eb 35                	jmp    800c5c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c27:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  800c2e:	eb 2c                	jmp    800c5c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c30:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  800c37:	eb 23                	jmp    800c5c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c39:	83 ec 08             	sub    $0x8,%esp
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	6a 25                	push   $0x25
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	ff d0                	call   *%eax
  800c46:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c49:	ff 4d 10             	decl   0x10(%ebp)
  800c4c:	eb 03                	jmp    800c51 <vprintfmt+0x3c3>
  800c4e:	ff 4d 10             	decl   0x10(%ebp)
  800c51:	8b 45 10             	mov    0x10(%ebp),%eax
  800c54:	48                   	dec    %eax
  800c55:	8a 00                	mov    (%eax),%al
  800c57:	3c 25                	cmp    $0x25,%al
  800c59:	75 f3                	jne    800c4e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c5b:	90                   	nop
		}
	}
  800c5c:	e9 35 fc ff ff       	jmp    800896 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c61:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c65:	5b                   	pop    %ebx
  800c66:	5e                   	pop    %esi
  800c67:	5d                   	pop    %ebp
  800c68:	c3                   	ret    

00800c69 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c6f:	8d 45 10             	lea    0x10(%ebp),%eax
  800c72:	83 c0 04             	add    $0x4,%eax
  800c75:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c78:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7b:	ff 75 f4             	pushl  -0xc(%ebp)
  800c7e:	50                   	push   %eax
  800c7f:	ff 75 0c             	pushl  0xc(%ebp)
  800c82:	ff 75 08             	pushl  0x8(%ebp)
  800c85:	e8 04 fc ff ff       	call   80088e <vprintfmt>
  800c8a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c8d:	90                   	nop
  800c8e:	c9                   	leave  
  800c8f:	c3                   	ret    

00800c90 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c96:	8b 40 08             	mov    0x8(%eax),%eax
  800c99:	8d 50 01             	lea    0x1(%eax),%edx
  800c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca5:	8b 10                	mov    (%eax),%edx
  800ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caa:	8b 40 04             	mov    0x4(%eax),%eax
  800cad:	39 c2                	cmp    %eax,%edx
  800caf:	73 12                	jae    800cc3 <sprintputch+0x33>
		*b->buf++ = ch;
  800cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb4:	8b 00                	mov    (%eax),%eax
  800cb6:	8d 48 01             	lea    0x1(%eax),%ecx
  800cb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbc:	89 0a                	mov    %ecx,(%edx)
  800cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc1:	88 10                	mov    %dl,(%eax)
}
  800cc3:	90                   	nop
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    

00800cc6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	01 d0                	add    %edx,%eax
  800cdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ce7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ceb:	74 06                	je     800cf3 <vsnprintf+0x2d>
  800ced:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf1:	7f 07                	jg     800cfa <vsnprintf+0x34>
		return -E_INVAL;
  800cf3:	b8 03 00 00 00       	mov    $0x3,%eax
  800cf8:	eb 20                	jmp    800d1a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cfa:	ff 75 14             	pushl  0x14(%ebp)
  800cfd:	ff 75 10             	pushl  0x10(%ebp)
  800d00:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d03:	50                   	push   %eax
  800d04:	68 90 0c 80 00       	push   $0x800c90
  800d09:	e8 80 fb ff ff       	call   80088e <vprintfmt>
  800d0e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d14:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d1a:	c9                   	leave  
  800d1b:	c3                   	ret    

00800d1c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d22:	8d 45 10             	lea    0x10(%ebp),%eax
  800d25:	83 c0 04             	add    $0x4,%eax
  800d28:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2e:	ff 75 f4             	pushl  -0xc(%ebp)
  800d31:	50                   	push   %eax
  800d32:	ff 75 0c             	pushl  0xc(%ebp)
  800d35:	ff 75 08             	pushl  0x8(%ebp)
  800d38:	e8 89 ff ff ff       	call   800cc6 <vsnprintf>
  800d3d:	83 c4 10             	add    $0x10,%esp
  800d40:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d46:	c9                   	leave  
  800d47:	c3                   	ret    

00800d48 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d55:	eb 06                	jmp    800d5d <strlen+0x15>
		n++;
  800d57:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d5a:	ff 45 08             	incl   0x8(%ebp)
  800d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d60:	8a 00                	mov    (%eax),%al
  800d62:	84 c0                	test   %al,%al
  800d64:	75 f1                	jne    800d57 <strlen+0xf>
		n++;
	return n;
  800d66:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d69:	c9                   	leave  
  800d6a:	c3                   	ret    

00800d6b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d78:	eb 09                	jmp    800d83 <strnlen+0x18>
		n++;
  800d7a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d7d:	ff 45 08             	incl   0x8(%ebp)
  800d80:	ff 4d 0c             	decl   0xc(%ebp)
  800d83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d87:	74 09                	je     800d92 <strnlen+0x27>
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	84 c0                	test   %al,%al
  800d90:	75 e8                	jne    800d7a <strnlen+0xf>
		n++;
	return n;
  800d92:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d95:	c9                   	leave  
  800d96:	c3                   	ret    

00800d97 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800da3:	90                   	nop
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	8d 50 01             	lea    0x1(%eax),%edx
  800daa:	89 55 08             	mov    %edx,0x8(%ebp)
  800dad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800db6:	8a 12                	mov    (%edx),%dl
  800db8:	88 10                	mov    %dl,(%eax)
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	84 c0                	test   %al,%al
  800dbe:	75 e4                	jne    800da4 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800dc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dd8:	eb 1f                	jmp    800df9 <strncpy+0x34>
		*dst++ = *src;
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8d 50 01             	lea    0x1(%eax),%edx
  800de0:	89 55 08             	mov    %edx,0x8(%ebp)
  800de3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de6:	8a 12                	mov    (%edx),%dl
  800de8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	84 c0                	test   %al,%al
  800df1:	74 03                	je     800df6 <strncpy+0x31>
			src++;
  800df3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800df6:	ff 45 fc             	incl   -0x4(%ebp)
  800df9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dfc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dff:	72 d9                	jb     800dda <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e01:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e04:	c9                   	leave  
  800e05:	c3                   	ret    

00800e06 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e16:	74 30                	je     800e48 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e18:	eb 16                	jmp    800e30 <strlcpy+0x2a>
			*dst++ = *src++;
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	8d 50 01             	lea    0x1(%eax),%edx
  800e20:	89 55 08             	mov    %edx,0x8(%ebp)
  800e23:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e26:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e29:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e2c:	8a 12                	mov    (%edx),%dl
  800e2e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e30:	ff 4d 10             	decl   0x10(%ebp)
  800e33:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e37:	74 09                	je     800e42 <strlcpy+0x3c>
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	84 c0                	test   %al,%al
  800e40:	75 d8                	jne    800e1a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e48:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4e:	29 c2                	sub    %eax,%edx
  800e50:	89 d0                	mov    %edx,%eax
}
  800e52:	c9                   	leave  
  800e53:	c3                   	ret    

00800e54 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e57:	eb 06                	jmp    800e5f <strcmp+0xb>
		p++, q++;
  800e59:	ff 45 08             	incl   0x8(%ebp)
  800e5c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	8a 00                	mov    (%eax),%al
  800e64:	84 c0                	test   %al,%al
  800e66:	74 0e                	je     800e76 <strcmp+0x22>
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8a 10                	mov    (%eax),%dl
  800e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e70:	8a 00                	mov    (%eax),%al
  800e72:	38 c2                	cmp    %al,%dl
  800e74:	74 e3                	je     800e59 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	8a 00                	mov    (%eax),%al
  800e7b:	0f b6 d0             	movzbl %al,%edx
  800e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e81:	8a 00                	mov    (%eax),%al
  800e83:	0f b6 c0             	movzbl %al,%eax
  800e86:	29 c2                	sub    %eax,%edx
  800e88:	89 d0                	mov    %edx,%eax
}
  800e8a:	5d                   	pop    %ebp
  800e8b:	c3                   	ret    

00800e8c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e8f:	eb 09                	jmp    800e9a <strncmp+0xe>
		n--, p++, q++;
  800e91:	ff 4d 10             	decl   0x10(%ebp)
  800e94:	ff 45 08             	incl   0x8(%ebp)
  800e97:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9e:	74 17                	je     800eb7 <strncmp+0x2b>
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	84 c0                	test   %al,%al
  800ea7:	74 0e                	je     800eb7 <strncmp+0x2b>
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8a 10                	mov    (%eax),%dl
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	38 c2                	cmp    %al,%dl
  800eb5:	74 da                	je     800e91 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800eb7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebb:	75 07                	jne    800ec4 <strncmp+0x38>
		return 0;
  800ebd:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec2:	eb 14                	jmp    800ed8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	8a 00                	mov    (%eax),%al
  800ec9:	0f b6 d0             	movzbl %al,%edx
  800ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	0f b6 c0             	movzbl %al,%eax
  800ed4:	29 c2                	sub    %eax,%edx
  800ed6:	89 d0                	mov    %edx,%eax
}
  800ed8:	5d                   	pop    %ebp
  800ed9:	c3                   	ret    

00800eda <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	83 ec 04             	sub    $0x4,%esp
  800ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ee6:	eb 12                	jmp    800efa <strchr+0x20>
		if (*s == c)
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ef0:	75 05                	jne    800ef7 <strchr+0x1d>
			return (char *) s;
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	eb 11                	jmp    800f08 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ef7:	ff 45 08             	incl   0x8(%ebp)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	84 c0                	test   %al,%al
  800f01:	75 e5                	jne    800ee8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f08:	c9                   	leave  
  800f09:	c3                   	ret    

00800f0a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	83 ec 04             	sub    $0x4,%esp
  800f10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f13:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f16:	eb 0d                	jmp    800f25 <strfind+0x1b>
		if (*s == c)
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	8a 00                	mov    (%eax),%al
  800f1d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f20:	74 0e                	je     800f30 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f22:	ff 45 08             	incl   0x8(%ebp)
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	84 c0                	test   %al,%al
  800f2c:	75 ea                	jne    800f18 <strfind+0xe>
  800f2e:	eb 01                	jmp    800f31 <strfind+0x27>
		if (*s == c)
			break;
  800f30:	90                   	nop
	return (char *) s;
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f34:	c9                   	leave  
  800f35:	c3                   	ret    

00800f36 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
  800f39:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f42:	8b 45 10             	mov    0x10(%ebp),%eax
  800f45:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f48:	eb 0e                	jmp    800f58 <memset+0x22>
		*p++ = c;
  800f4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4d:	8d 50 01             	lea    0x1(%eax),%edx
  800f50:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f56:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f58:	ff 4d f8             	decl   -0x8(%ebp)
  800f5b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f5f:	79 e9                	jns    800f4a <memset+0x14>
		*p++ = c;

	return v;
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f64:	c9                   	leave  
  800f65:	c3                   	ret    

00800f66 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f78:	eb 16                	jmp    800f90 <memcpy+0x2a>
		*d++ = *s++;
  800f7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7d:	8d 50 01             	lea    0x1(%eax),%edx
  800f80:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f83:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f86:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f89:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f8c:	8a 12                	mov    (%edx),%dl
  800f8e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f90:	8b 45 10             	mov    0x10(%ebp),%eax
  800f93:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f96:	89 55 10             	mov    %edx,0x10(%ebp)
  800f99:	85 c0                	test   %eax,%eax
  800f9b:	75 dd                	jne    800f7a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa0:	c9                   	leave  
  800fa1:	c3                   	ret    

00800fa2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fba:	73 50                	jae    80100c <memmove+0x6a>
  800fbc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	01 d0                	add    %edx,%eax
  800fc4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fc7:	76 43                	jbe    80100c <memmove+0x6a>
		s += n;
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fd5:	eb 10                	jmp    800fe7 <memmove+0x45>
			*--d = *--s;
  800fd7:	ff 4d f8             	decl   -0x8(%ebp)
  800fda:	ff 4d fc             	decl   -0x4(%ebp)
  800fdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe0:	8a 10                	mov    (%eax),%dl
  800fe2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fe7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fea:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fed:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff0:	85 c0                	test   %eax,%eax
  800ff2:	75 e3                	jne    800fd7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ff4:	eb 23                	jmp    801019 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ff6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff9:	8d 50 01             	lea    0x1(%eax),%edx
  800ffc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801002:	8d 4a 01             	lea    0x1(%edx),%ecx
  801005:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801008:	8a 12                	mov    (%edx),%dl
  80100a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80100c:	8b 45 10             	mov    0x10(%ebp),%eax
  80100f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801012:	89 55 10             	mov    %edx,0x10(%ebp)
  801015:	85 c0                	test   %eax,%eax
  801017:	75 dd                	jne    800ff6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101c:	c9                   	leave  
  80101d:	c3                   	ret    

0080101e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80102a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801030:	eb 2a                	jmp    80105c <memcmp+0x3e>
		if (*s1 != *s2)
  801032:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801035:	8a 10                	mov    (%eax),%dl
  801037:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	38 c2                	cmp    %al,%dl
  80103e:	74 16                	je     801056 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801040:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	0f b6 d0             	movzbl %al,%edx
  801048:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	0f b6 c0             	movzbl %al,%eax
  801050:	29 c2                	sub    %eax,%edx
  801052:	89 d0                	mov    %edx,%eax
  801054:	eb 18                	jmp    80106e <memcmp+0x50>
		s1++, s2++;
  801056:	ff 45 fc             	incl   -0x4(%ebp)
  801059:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80105c:	8b 45 10             	mov    0x10(%ebp),%eax
  80105f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801062:	89 55 10             	mov    %edx,0x10(%ebp)
  801065:	85 c0                	test   %eax,%eax
  801067:	75 c9                	jne    801032 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801069:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80106e:	c9                   	leave  
  80106f:	c3                   	ret    

00801070 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801076:	8b 55 08             	mov    0x8(%ebp),%edx
  801079:	8b 45 10             	mov    0x10(%ebp),%eax
  80107c:	01 d0                	add    %edx,%eax
  80107e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801081:	eb 15                	jmp    801098 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	0f b6 d0             	movzbl %al,%edx
  80108b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108e:	0f b6 c0             	movzbl %al,%eax
  801091:	39 c2                	cmp    %eax,%edx
  801093:	74 0d                	je     8010a2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801095:	ff 45 08             	incl   0x8(%ebp)
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80109e:	72 e3                	jb     801083 <memfind+0x13>
  8010a0:	eb 01                	jmp    8010a3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010a2:	90                   	nop
	return (void *) s;
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a6:	c9                   	leave  
  8010a7:	c3                   	ret    

008010a8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
  8010ab:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010bc:	eb 03                	jmp    8010c1 <strtol+0x19>
		s++;
  8010be:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	3c 20                	cmp    $0x20,%al
  8010c8:	74 f4                	je     8010be <strtol+0x16>
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	3c 09                	cmp    $0x9,%al
  8010d1:	74 eb                	je     8010be <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	3c 2b                	cmp    $0x2b,%al
  8010da:	75 05                	jne    8010e1 <strtol+0x39>
		s++;
  8010dc:	ff 45 08             	incl   0x8(%ebp)
  8010df:	eb 13                	jmp    8010f4 <strtol+0x4c>
	else if (*s == '-')
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	8a 00                	mov    (%eax),%al
  8010e6:	3c 2d                	cmp    $0x2d,%al
  8010e8:	75 0a                	jne    8010f4 <strtol+0x4c>
		s++, neg = 1;
  8010ea:	ff 45 08             	incl   0x8(%ebp)
  8010ed:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f8:	74 06                	je     801100 <strtol+0x58>
  8010fa:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010fe:	75 20                	jne    801120 <strtol+0x78>
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	3c 30                	cmp    $0x30,%al
  801107:	75 17                	jne    801120 <strtol+0x78>
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	40                   	inc    %eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	3c 78                	cmp    $0x78,%al
  801111:	75 0d                	jne    801120 <strtol+0x78>
		s += 2, base = 16;
  801113:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801117:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80111e:	eb 28                	jmp    801148 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801120:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801124:	75 15                	jne    80113b <strtol+0x93>
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	3c 30                	cmp    $0x30,%al
  80112d:	75 0c                	jne    80113b <strtol+0x93>
		s++, base = 8;
  80112f:	ff 45 08             	incl   0x8(%ebp)
  801132:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801139:	eb 0d                	jmp    801148 <strtol+0xa0>
	else if (base == 0)
  80113b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113f:	75 07                	jne    801148 <strtol+0xa0>
		base = 10;
  801141:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	3c 2f                	cmp    $0x2f,%al
  80114f:	7e 19                	jle    80116a <strtol+0xc2>
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	3c 39                	cmp    $0x39,%al
  801158:	7f 10                	jg     80116a <strtol+0xc2>
			dig = *s - '0';
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	0f be c0             	movsbl %al,%eax
  801162:	83 e8 30             	sub    $0x30,%eax
  801165:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801168:	eb 42                	jmp    8011ac <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	8a 00                	mov    (%eax),%al
  80116f:	3c 60                	cmp    $0x60,%al
  801171:	7e 19                	jle    80118c <strtol+0xe4>
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	3c 7a                	cmp    $0x7a,%al
  80117a:	7f 10                	jg     80118c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	8a 00                	mov    (%eax),%al
  801181:	0f be c0             	movsbl %al,%eax
  801184:	83 e8 57             	sub    $0x57,%eax
  801187:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80118a:	eb 20                	jmp    8011ac <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	3c 40                	cmp    $0x40,%al
  801193:	7e 39                	jle    8011ce <strtol+0x126>
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	3c 5a                	cmp    $0x5a,%al
  80119c:	7f 30                	jg     8011ce <strtol+0x126>
			dig = *s - 'A' + 10;
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	0f be c0             	movsbl %al,%eax
  8011a6:	83 e8 37             	sub    $0x37,%eax
  8011a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011af:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011b2:	7d 19                	jge    8011cd <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011b4:	ff 45 08             	incl   0x8(%ebp)
  8011b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ba:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011be:	89 c2                	mov    %eax,%edx
  8011c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c3:	01 d0                	add    %edx,%eax
  8011c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011c8:	e9 7b ff ff ff       	jmp    801148 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011cd:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011d2:	74 08                	je     8011dc <strtol+0x134>
		*endptr = (char *) s;
  8011d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011da:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011e0:	74 07                	je     8011e9 <strtol+0x141>
  8011e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e5:	f7 d8                	neg    %eax
  8011e7:	eb 03                	jmp    8011ec <strtol+0x144>
  8011e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ec:	c9                   	leave  
  8011ed:	c3                   	ret    

008011ee <ltostr>:

void
ltostr(long value, char *str)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801202:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801206:	79 13                	jns    80121b <ltostr+0x2d>
	{
		neg = 1;
  801208:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80120f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801212:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801215:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801218:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801223:	99                   	cltd   
  801224:	f7 f9                	idiv   %ecx
  801226:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801229:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80122c:	8d 50 01             	lea    0x1(%eax),%edx
  80122f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801232:	89 c2                	mov    %eax,%edx
  801234:	8b 45 0c             	mov    0xc(%ebp),%eax
  801237:	01 d0                	add    %edx,%eax
  801239:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80123c:	83 c2 30             	add    $0x30,%edx
  80123f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801241:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801244:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801249:	f7 e9                	imul   %ecx
  80124b:	c1 fa 02             	sar    $0x2,%edx
  80124e:	89 c8                	mov    %ecx,%eax
  801250:	c1 f8 1f             	sar    $0x1f,%eax
  801253:	29 c2                	sub    %eax,%edx
  801255:	89 d0                	mov    %edx,%eax
  801257:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80125a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80125e:	75 bb                	jne    80121b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801260:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801267:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126a:	48                   	dec    %eax
  80126b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80126e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801272:	74 3d                	je     8012b1 <ltostr+0xc3>
		start = 1 ;
  801274:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80127b:	eb 34                	jmp    8012b1 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80127d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801280:	8b 45 0c             	mov    0xc(%ebp),%eax
  801283:	01 d0                	add    %edx,%eax
  801285:	8a 00                	mov    (%eax),%al
  801287:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80128a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801290:	01 c2                	add    %eax,%edx
  801292:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801295:	8b 45 0c             	mov    0xc(%ebp),%eax
  801298:	01 c8                	add    %ecx,%eax
  80129a:	8a 00                	mov    (%eax),%al
  80129c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80129e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a4:	01 c2                	add    %eax,%edx
  8012a6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012a9:	88 02                	mov    %al,(%edx)
		start++ ;
  8012ab:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012ae:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b7:	7c c4                	jl     80127d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bf:	01 d0                	add    %edx,%eax
  8012c1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012c4:	90                   	nop
  8012c5:	c9                   	leave  
  8012c6:	c3                   	ret    

008012c7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
  8012ca:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012cd:	ff 75 08             	pushl  0x8(%ebp)
  8012d0:	e8 73 fa ff ff       	call   800d48 <strlen>
  8012d5:	83 c4 04             	add    $0x4,%esp
  8012d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012db:	ff 75 0c             	pushl  0xc(%ebp)
  8012de:	e8 65 fa ff ff       	call   800d48 <strlen>
  8012e3:	83 c4 04             	add    $0x4,%esp
  8012e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f7:	eb 17                	jmp    801310 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ff:	01 c2                	add    %eax,%edx
  801301:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	01 c8                	add    %ecx,%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80130d:	ff 45 fc             	incl   -0x4(%ebp)
  801310:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801313:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801316:	7c e1                	jl     8012f9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801318:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80131f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801326:	eb 1f                	jmp    801347 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801328:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132b:	8d 50 01             	lea    0x1(%eax),%edx
  80132e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801331:	89 c2                	mov    %eax,%edx
  801333:	8b 45 10             	mov    0x10(%ebp),%eax
  801336:	01 c2                	add    %eax,%edx
  801338:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80133b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133e:	01 c8                	add    %ecx,%eax
  801340:	8a 00                	mov    (%eax),%al
  801342:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801344:	ff 45 f8             	incl   -0x8(%ebp)
  801347:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134d:	7c d9                	jl     801328 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80134f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801352:	8b 45 10             	mov    0x10(%ebp),%eax
  801355:	01 d0                	add    %edx,%eax
  801357:	c6 00 00             	movb   $0x0,(%eax)
}
  80135a:	90                   	nop
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801360:	8b 45 14             	mov    0x14(%ebp),%eax
  801363:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801369:	8b 45 14             	mov    0x14(%ebp),%eax
  80136c:	8b 00                	mov    (%eax),%eax
  80136e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801375:	8b 45 10             	mov    0x10(%ebp),%eax
  801378:	01 d0                	add    %edx,%eax
  80137a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801380:	eb 0c                	jmp    80138e <strsplit+0x31>
			*string++ = 0;
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	8d 50 01             	lea    0x1(%eax),%edx
  801388:	89 55 08             	mov    %edx,0x8(%ebp)
  80138b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8a 00                	mov    (%eax),%al
  801393:	84 c0                	test   %al,%al
  801395:	74 18                	je     8013af <strsplit+0x52>
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	8a 00                	mov    (%eax),%al
  80139c:	0f be c0             	movsbl %al,%eax
  80139f:	50                   	push   %eax
  8013a0:	ff 75 0c             	pushl  0xc(%ebp)
  8013a3:	e8 32 fb ff ff       	call   800eda <strchr>
  8013a8:	83 c4 08             	add    $0x8,%esp
  8013ab:	85 c0                	test   %eax,%eax
  8013ad:	75 d3                	jne    801382 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b2:	8a 00                	mov    (%eax),%al
  8013b4:	84 c0                	test   %al,%al
  8013b6:	74 5a                	je     801412 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bb:	8b 00                	mov    (%eax),%eax
  8013bd:	83 f8 0f             	cmp    $0xf,%eax
  8013c0:	75 07                	jne    8013c9 <strsplit+0x6c>
		{
			return 0;
  8013c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c7:	eb 66                	jmp    80142f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013cc:	8b 00                	mov    (%eax),%eax
  8013ce:	8d 48 01             	lea    0x1(%eax),%ecx
  8013d1:	8b 55 14             	mov    0x14(%ebp),%edx
  8013d4:	89 0a                	mov    %ecx,(%edx)
  8013d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e0:	01 c2                	add    %eax,%edx
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e7:	eb 03                	jmp    8013ec <strsplit+0x8f>
			string++;
  8013e9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	8a 00                	mov    (%eax),%al
  8013f1:	84 c0                	test   %al,%al
  8013f3:	74 8b                	je     801380 <strsplit+0x23>
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	0f be c0             	movsbl %al,%eax
  8013fd:	50                   	push   %eax
  8013fe:	ff 75 0c             	pushl  0xc(%ebp)
  801401:	e8 d4 fa ff ff       	call   800eda <strchr>
  801406:	83 c4 08             	add    $0x8,%esp
  801409:	85 c0                	test   %eax,%eax
  80140b:	74 dc                	je     8013e9 <strsplit+0x8c>
			string++;
	}
  80140d:	e9 6e ff ff ff       	jmp    801380 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801412:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801413:	8b 45 14             	mov    0x14(%ebp),%eax
  801416:	8b 00                	mov    (%eax),%eax
  801418:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80141f:	8b 45 10             	mov    0x10(%ebp),%eax
  801422:	01 d0                	add    %edx,%eax
  801424:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80142a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
  801434:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801437:	83 ec 04             	sub    $0x4,%esp
  80143a:	68 e8 3d 80 00       	push   $0x803de8
  80143f:	68 3f 01 00 00       	push   $0x13f
  801444:	68 0a 3e 80 00       	push   $0x803e0a
  801449:	e8 a9 ef ff ff       	call   8003f7 <_panic>

0080144e <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801454:	83 ec 0c             	sub    $0xc,%esp
  801457:	ff 75 08             	pushl  0x8(%ebp)
  80145a:	e8 90 0c 00 00       	call   8020ef <sys_sbrk>
  80145f:	83 c4 10             	add    $0x10,%esp
}
  801462:	c9                   	leave  
  801463:	c3                   	ret    

00801464 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  80146a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80146e:	75 0a                	jne    80147a <malloc+0x16>
		return NULL;
  801470:	b8 00 00 00 00       	mov    $0x0,%eax
  801475:	e9 9e 01 00 00       	jmp    801618 <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  80147a:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801481:	77 2c                	ja     8014af <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801483:	e8 eb 0a 00 00       	call   801f73 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801488:	85 c0                	test   %eax,%eax
  80148a:	74 19                	je     8014a5 <malloc+0x41>

			void * block = alloc_block_FF(size);
  80148c:	83 ec 0c             	sub    $0xc,%esp
  80148f:	ff 75 08             	pushl  0x8(%ebp)
  801492:	e8 85 11 00 00       	call   80261c <alloc_block_FF>
  801497:	83 c4 10             	add    $0x10,%esp
  80149a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  80149d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014a0:	e9 73 01 00 00       	jmp    801618 <malloc+0x1b4>
		} else {
			return NULL;
  8014a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014aa:	e9 69 01 00 00       	jmp    801618 <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8014af:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8014b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014bc:	01 d0                	add    %edx,%eax
  8014be:	48                   	dec    %eax
  8014bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8014c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ca:	f7 75 e0             	divl   -0x20(%ebp)
  8014cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014d0:	29 d0                	sub    %edx,%eax
  8014d2:	c1 e8 0c             	shr    $0xc,%eax
  8014d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  8014d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8014df:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8014e6:	a1 20 50 80 00       	mov    0x805020,%eax
  8014eb:	8b 40 7c             	mov    0x7c(%eax),%eax
  8014ee:	05 00 10 00 00       	add    $0x1000,%eax
  8014f3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  8014f6:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8014fb:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8014fe:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801501:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801508:	8b 55 08             	mov    0x8(%ebp),%edx
  80150b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80150e:	01 d0                	add    %edx,%eax
  801510:	48                   	dec    %eax
  801511:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801514:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801517:	ba 00 00 00 00       	mov    $0x0,%edx
  80151c:	f7 75 cc             	divl   -0x34(%ebp)
  80151f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801522:	29 d0                	sub    %edx,%eax
  801524:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801527:	76 0a                	jbe    801533 <malloc+0xcf>
		return NULL;
  801529:	b8 00 00 00 00       	mov    $0x0,%eax
  80152e:	e9 e5 00 00 00       	jmp    801618 <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801533:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801536:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801539:	eb 48                	jmp    801583 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  80153b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80153e:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801541:	c1 e8 0c             	shr    $0xc,%eax
  801544:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801547:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80154a:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801551:	85 c0                	test   %eax,%eax
  801553:	75 11                	jne    801566 <malloc+0x102>
			freePagesCount++;
  801555:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801558:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80155c:	75 16                	jne    801574 <malloc+0x110>
				start = i;
  80155e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801561:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801564:	eb 0e                	jmp    801574 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801566:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80156d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801577:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80157a:	74 12                	je     80158e <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  80157c:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801583:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80158a:	76 af                	jbe    80153b <malloc+0xd7>
  80158c:	eb 01                	jmp    80158f <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  80158e:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  80158f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801593:	74 08                	je     80159d <malloc+0x139>
  801595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801598:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80159b:	74 07                	je     8015a4 <malloc+0x140>
		return NULL;
  80159d:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a2:	eb 74                	jmp    801618 <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8015a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a7:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8015aa:	c1 e8 0c             	shr    $0xc,%eax
  8015ad:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  8015b0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8015b3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8015b6:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  8015bd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8015c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8015c3:	eb 11                	jmp    8015d6 <malloc+0x172>
		markedPages[i] = 1;
  8015c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015c8:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  8015cf:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  8015d3:	ff 45 e8             	incl   -0x18(%ebp)
  8015d6:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8015d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015dc:	01 d0                	add    %edx,%eax
  8015de:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8015e1:	77 e2                	ja     8015c5 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  8015e3:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8015ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ed:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8015f0:	01 d0                	add    %edx,%eax
  8015f2:	48                   	dec    %eax
  8015f3:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8015f6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8015f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fe:	f7 75 bc             	divl   -0x44(%ebp)
  801601:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801604:	29 d0                	sub    %edx,%eax
  801606:	83 ec 08             	sub    $0x8,%esp
  801609:	50                   	push   %eax
  80160a:	ff 75 f0             	pushl  -0x10(%ebp)
  80160d:	e8 14 0b 00 00       	call   802126 <sys_allocate_user_mem>
  801612:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  801615:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  801618:	c9                   	leave  
  801619:	c3                   	ret    

0080161a <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
  80161d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801620:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801624:	0f 84 ee 00 00 00    	je     801718 <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  80162a:	a1 20 50 80 00       	mov    0x805020,%eax
  80162f:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801632:	3b 45 08             	cmp    0x8(%ebp),%eax
  801635:	77 09                	ja     801640 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801637:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  80163e:	76 14                	jbe    801654 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801640:	83 ec 04             	sub    $0x4,%esp
  801643:	68 18 3e 80 00       	push   $0x803e18
  801648:	6a 68                	push   $0x68
  80164a:	68 32 3e 80 00       	push   $0x803e32
  80164f:	e8 a3 ed ff ff       	call   8003f7 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  801654:	a1 20 50 80 00       	mov    0x805020,%eax
  801659:	8b 40 74             	mov    0x74(%eax),%eax
  80165c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80165f:	77 20                	ja     801681 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801661:	a1 20 50 80 00       	mov    0x805020,%eax
  801666:	8b 40 78             	mov    0x78(%eax),%eax
  801669:	3b 45 08             	cmp    0x8(%ebp),%eax
  80166c:	76 13                	jbe    801681 <free+0x67>
		free_block(virtual_address);
  80166e:	83 ec 0c             	sub    $0xc,%esp
  801671:	ff 75 08             	pushl  0x8(%ebp)
  801674:	e8 6c 16 00 00       	call   802ce5 <free_block>
  801679:	83 c4 10             	add    $0x10,%esp
		return;
  80167c:	e9 98 00 00 00       	jmp    801719 <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801681:	8b 55 08             	mov    0x8(%ebp),%edx
  801684:	a1 20 50 80 00       	mov    0x805020,%eax
  801689:	8b 40 7c             	mov    0x7c(%eax),%eax
  80168c:	29 c2                	sub    %eax,%edx
  80168e:	89 d0                	mov    %edx,%eax
  801690:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801695:	c1 e8 0c             	shr    $0xc,%eax
  801698:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  80169b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8016a2:	eb 16                	jmp    8016ba <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  8016a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016aa:	01 d0                	add    %edx,%eax
  8016ac:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  8016b3:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  8016b7:	ff 45 f4             	incl   -0xc(%ebp)
  8016ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016bd:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  8016c4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016c7:	7f db                	jg     8016a4 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  8016c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016cc:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  8016d3:	c1 e0 0c             	shl    $0xc,%eax
  8016d6:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016df:	eb 1a                	jmp    8016fb <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  8016e1:	83 ec 08             	sub    $0x8,%esp
  8016e4:	68 00 10 00 00       	push   $0x1000
  8016e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8016ec:	e8 19 0a 00 00       	call   80210a <sys_free_user_mem>
  8016f1:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  8016f4:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8016fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8016fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801701:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801703:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801706:	77 d9                	ja     8016e1 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801708:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80170b:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  801712:	00 00 00 00 
  801716:	eb 01                	jmp    801719 <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  801718:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  801719:	c9                   	leave  
  80171a:	c3                   	ret    

0080171b <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
  80171e:	83 ec 58             	sub    $0x58,%esp
  801721:	8b 45 10             	mov    0x10(%ebp),%eax
  801724:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801727:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80172b:	75 0a                	jne    801737 <smalloc+0x1c>
		return NULL;
  80172d:	b8 00 00 00 00       	mov    $0x0,%eax
  801732:	e9 7d 01 00 00       	jmp    8018b4 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801737:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  80173e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801741:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801744:	01 d0                	add    %edx,%eax
  801746:	48                   	dec    %eax
  801747:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80174a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80174d:	ba 00 00 00 00       	mov    $0x0,%edx
  801752:	f7 75 e4             	divl   -0x1c(%ebp)
  801755:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801758:	29 d0                	sub    %edx,%eax
  80175a:	c1 e8 0c             	shr    $0xc,%eax
  80175d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801760:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801767:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  80176e:	a1 20 50 80 00       	mov    0x805020,%eax
  801773:	8b 40 7c             	mov    0x7c(%eax),%eax
  801776:	05 00 10 00 00       	add    $0x1000,%eax
  80177b:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  80177e:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801783:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801786:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801789:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801790:	8b 55 0c             	mov    0xc(%ebp),%edx
  801793:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801796:	01 d0                	add    %edx,%eax
  801798:	48                   	dec    %eax
  801799:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80179c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80179f:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a4:	f7 75 d0             	divl   -0x30(%ebp)
  8017a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8017aa:	29 d0                	sub    %edx,%eax
  8017ac:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8017af:	76 0a                	jbe    8017bb <smalloc+0xa0>
		return NULL;
  8017b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b6:	e9 f9 00 00 00       	jmp    8018b4 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8017bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017c1:	eb 48                	jmp    80180b <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  8017c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c6:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8017c9:	c1 e8 0c             	shr    $0xc,%eax
  8017cc:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  8017cf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017d2:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8017d9:	85 c0                	test   %eax,%eax
  8017db:	75 11                	jne    8017ee <smalloc+0xd3>
			freePagesCount++;
  8017dd:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8017e0:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8017e4:	75 16                	jne    8017fc <smalloc+0xe1>
				start = s;
  8017e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017ec:	eb 0e                	jmp    8017fc <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  8017ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8017f5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  8017fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ff:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801802:	74 12                	je     801816 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801804:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  80180b:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801812:	76 af                	jbe    8017c3 <smalloc+0xa8>
  801814:	eb 01                	jmp    801817 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  801816:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  801817:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80181b:	74 08                	je     801825 <smalloc+0x10a>
  80181d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801820:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801823:	74 0a                	je     80182f <smalloc+0x114>
		return NULL;
  801825:	b8 00 00 00 00       	mov    $0x0,%eax
  80182a:	e9 85 00 00 00       	jmp    8018b4 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  80182f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801832:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801835:	c1 e8 0c             	shr    $0xc,%eax
  801838:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  80183b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80183e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801841:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801848:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80184b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80184e:	eb 11                	jmp    801861 <smalloc+0x146>
		markedPages[s] = 1;
  801850:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801853:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  80185a:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  80185e:	ff 45 e8             	incl   -0x18(%ebp)
  801861:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801864:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801867:	01 d0                	add    %edx,%eax
  801869:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80186c:	77 e2                	ja     801850 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  80186e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801871:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801875:	52                   	push   %edx
  801876:	50                   	push   %eax
  801877:	ff 75 0c             	pushl  0xc(%ebp)
  80187a:	ff 75 08             	pushl  0x8(%ebp)
  80187d:	e8 8f 04 00 00       	call   801d11 <sys_createSharedObject>
  801882:	83 c4 10             	add    $0x10,%esp
  801885:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  801888:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  80188c:	78 12                	js     8018a0 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  80188e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801891:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801894:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  80189b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189e:	eb 14                	jmp    8018b4 <smalloc+0x199>
	}
	free((void*) start);
  8018a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a3:	83 ec 0c             	sub    $0xc,%esp
  8018a6:	50                   	push   %eax
  8018a7:	e8 6e fd ff ff       	call   80161a <free>
  8018ac:	83 c4 10             	add    $0x10,%esp
	return NULL;
  8018af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  8018bc:	83 ec 08             	sub    $0x8,%esp
  8018bf:	ff 75 0c             	pushl  0xc(%ebp)
  8018c2:	ff 75 08             	pushl  0x8(%ebp)
  8018c5:	e8 71 04 00 00       	call   801d3b <sys_getSizeOfSharedObject>
  8018ca:	83 c4 10             	add    $0x10,%esp
  8018cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8018d0:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8018d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018dd:	01 d0                	add    %edx,%eax
  8018df:	48                   	dec    %eax
  8018e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8018e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018eb:	f7 75 e0             	divl   -0x20(%ebp)
  8018ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018f1:	29 d0                	sub    %edx,%eax
  8018f3:	c1 e8 0c             	shr    $0xc,%eax
  8018f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  8018f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801900:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  801907:	a1 20 50 80 00       	mov    0x805020,%eax
  80190c:	8b 40 7c             	mov    0x7c(%eax),%eax
  80190f:	05 00 10 00 00       	add    $0x1000,%eax
  801914:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  801917:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80191c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80191f:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801922:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801929:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80192c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80192f:	01 d0                	add    %edx,%eax
  801931:	48                   	dec    %eax
  801932:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801935:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801938:	ba 00 00 00 00       	mov    $0x0,%edx
  80193d:	f7 75 cc             	divl   -0x34(%ebp)
  801940:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801943:	29 d0                	sub    %edx,%eax
  801945:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801948:	76 0a                	jbe    801954 <sget+0x9e>
		return NULL;
  80194a:	b8 00 00 00 00       	mov    $0x0,%eax
  80194f:	e9 f7 00 00 00       	jmp    801a4b <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801954:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801957:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80195a:	eb 48                	jmp    8019a4 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  80195c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80195f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801962:	c1 e8 0c             	shr    $0xc,%eax
  801965:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  801968:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80196b:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801972:	85 c0                	test   %eax,%eax
  801974:	75 11                	jne    801987 <sget+0xd1>
			free_Pages_Count++;
  801976:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801979:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80197d:	75 16                	jne    801995 <sget+0xdf>
				start = s;
  80197f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801982:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801985:	eb 0e                	jmp    801995 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  801987:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80198e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  801995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801998:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80199b:	74 12                	je     8019af <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80199d:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8019a4:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8019ab:	76 af                	jbe    80195c <sget+0xa6>
  8019ad:	eb 01                	jmp    8019b0 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  8019af:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  8019b0:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8019b4:	74 08                	je     8019be <sget+0x108>
  8019b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b9:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8019bc:	74 0a                	je     8019c8 <sget+0x112>
		return NULL;
  8019be:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c3:	e9 83 00 00 00       	jmp    801a4b <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  8019c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019cb:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8019ce:	c1 e8 0c             	shr    $0xc,%eax
  8019d1:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  8019d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019d7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8019da:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  8019e1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8019e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8019e7:	eb 11                	jmp    8019fa <sget+0x144>
		markedPages[k] = 1;
  8019e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019ec:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  8019f3:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  8019f7:	ff 45 e8             	incl   -0x18(%ebp)
  8019fa:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8019fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a00:	01 d0                	add    %edx,%eax
  801a02:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a05:	77 e2                	ja     8019e9 <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  801a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a0a:	83 ec 04             	sub    $0x4,%esp
  801a0d:	50                   	push   %eax
  801a0e:	ff 75 0c             	pushl  0xc(%ebp)
  801a11:	ff 75 08             	pushl  0x8(%ebp)
  801a14:	e8 3f 03 00 00       	call   801d58 <sys_getSharedObject>
  801a19:	83 c4 10             	add    $0x10,%esp
  801a1c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  801a1f:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  801a23:	78 12                	js     801a37 <sget+0x181>
		shardIDs[startPage] = ss;
  801a25:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a28:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801a2b:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a35:	eb 14                	jmp    801a4b <sget+0x195>
	}
	free((void*) start);
  801a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3a:	83 ec 0c             	sub    $0xc,%esp
  801a3d:	50                   	push   %eax
  801a3e:	e8 d7 fb ff ff       	call   80161a <free>
  801a43:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801a46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
  801a50:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801a53:	8b 55 08             	mov    0x8(%ebp),%edx
  801a56:	a1 20 50 80 00       	mov    0x805020,%eax
  801a5b:	8b 40 7c             	mov    0x7c(%eax),%eax
  801a5e:	29 c2                	sub    %eax,%edx
  801a60:	89 d0                	mov    %edx,%eax
  801a62:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  801a67:	c1 e8 0c             	shr    $0xc,%eax
  801a6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  801a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a70:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  801a77:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  801a7a:	83 ec 08             	sub    $0x8,%esp
  801a7d:	ff 75 08             	pushl  0x8(%ebp)
  801a80:	ff 75 f0             	pushl  -0x10(%ebp)
  801a83:	e8 ef 02 00 00       	call   801d77 <sys_freeSharedObject>
  801a88:	83 c4 10             	add    $0x10,%esp
  801a8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  801a8e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a92:	75 0e                	jne    801aa2 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  801a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a97:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  801a9e:	ff ff ff ff 
	}

}
  801aa2:	90                   	nop
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
  801aa8:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801aab:	83 ec 04             	sub    $0x4,%esp
  801aae:	68 40 3e 80 00       	push   $0x803e40
  801ab3:	68 19 01 00 00       	push   $0x119
  801ab8:	68 32 3e 80 00       	push   $0x803e32
  801abd:	e8 35 e9 ff ff       	call   8003f7 <_panic>

00801ac2 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
  801ac5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ac8:	83 ec 04             	sub    $0x4,%esp
  801acb:	68 66 3e 80 00       	push   $0x803e66
  801ad0:	68 23 01 00 00       	push   $0x123
  801ad5:	68 32 3e 80 00       	push   $0x803e32
  801ada:	e8 18 e9 ff ff       	call   8003f7 <_panic>

00801adf <shrink>:

}
void shrink(uint32 newSize) {
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ae5:	83 ec 04             	sub    $0x4,%esp
  801ae8:	68 66 3e 80 00       	push   $0x803e66
  801aed:	68 27 01 00 00       	push   $0x127
  801af2:	68 32 3e 80 00       	push   $0x803e32
  801af7:	e8 fb e8 ff ff       	call   8003f7 <_panic>

00801afc <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
  801aff:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b02:	83 ec 04             	sub    $0x4,%esp
  801b05:	68 66 3e 80 00       	push   $0x803e66
  801b0a:	68 2b 01 00 00       	push   $0x12b
  801b0f:	68 32 3e 80 00       	push   $0x803e32
  801b14:	e8 de e8 ff ff       	call   8003f7 <_panic>

00801b19 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	57                   	push   %edi
  801b1d:	56                   	push   %esi
  801b1e:	53                   	push   %ebx
  801b1f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b22:	8b 45 08             	mov    0x8(%ebp),%eax
  801b25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b28:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b2b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b2e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b31:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b34:	cd 30                	int    $0x30
  801b36:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b3c:	83 c4 10             	add    $0x10,%esp
  801b3f:	5b                   	pop    %ebx
  801b40:	5e                   	pop    %esi
  801b41:	5f                   	pop    %edi
  801b42:	5d                   	pop    %ebp
  801b43:	c3                   	ret    

00801b44 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	83 ec 04             	sub    $0x4,%esp
  801b4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801b50:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	52                   	push   %edx
  801b5c:	ff 75 0c             	pushl  0xc(%ebp)
  801b5f:	50                   	push   %eax
  801b60:	6a 00                	push   $0x0
  801b62:	e8 b2 ff ff ff       	call   801b19 <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
}
  801b6a:	90                   	nop
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <sys_cgetc>:

int sys_cgetc(void) {
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 02                	push   $0x2
  801b7c:	e8 98 ff ff ff       	call   801b19 <syscall>
  801b81:	83 c4 18             	add    $0x18,%esp
}
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <sys_lock_cons>:

void sys_lock_cons(void) {
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 03                	push   $0x3
  801b95:	e8 7f ff ff ff       	call   801b19 <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
}
  801b9d:	90                   	nop
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 04                	push   $0x4
  801baf:	e8 65 ff ff ff       	call   801b19 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	90                   	nop
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801bbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	52                   	push   %edx
  801bca:	50                   	push   %eax
  801bcb:	6a 08                	push   $0x8
  801bcd:	e8 47 ff ff ff       	call   801b19 <syscall>
  801bd2:	83 c4 18             	add    $0x18,%esp
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
  801bda:	56                   	push   %esi
  801bdb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801bdc:	8b 75 18             	mov    0x18(%ebp),%esi
  801bdf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801be2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801be5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	56                   	push   %esi
  801bec:	53                   	push   %ebx
  801bed:	51                   	push   %ecx
  801bee:	52                   	push   %edx
  801bef:	50                   	push   %eax
  801bf0:	6a 09                	push   $0x9
  801bf2:	e8 22 ff ff ff       	call   801b19 <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801bfa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bfd:	5b                   	pop    %ebx
  801bfe:	5e                   	pop    %esi
  801bff:	5d                   	pop    %ebp
  801c00:	c3                   	ret    

00801c01 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c07:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	52                   	push   %edx
  801c11:	50                   	push   %eax
  801c12:	6a 0a                	push   $0xa
  801c14:	e8 00 ff ff ff       	call   801b19 <syscall>
  801c19:	83 c4 18             	add    $0x18,%esp
}
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	ff 75 0c             	pushl  0xc(%ebp)
  801c2a:	ff 75 08             	pushl  0x8(%ebp)
  801c2d:	6a 0b                	push   $0xb
  801c2f:	e8 e5 fe ff ff       	call   801b19 <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 0c                	push   $0xc
  801c48:	e8 cc fe ff ff       	call   801b19 <syscall>
  801c4d:	83 c4 18             	add    $0x18,%esp
}
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 0d                	push   $0xd
  801c61:	e8 b3 fe ff ff       	call   801b19 <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 0e                	push   $0xe
  801c7a:	e8 9a fe ff ff       	call   801b19 <syscall>
  801c7f:	83 c4 18             	add    $0x18,%esp
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 0f                	push   $0xf
  801c93:	e8 81 fe ff ff       	call   801b19 <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	ff 75 08             	pushl  0x8(%ebp)
  801cab:	6a 10                	push   $0x10
  801cad:	e8 67 fe ff ff       	call   801b19 <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <sys_scarce_memory>:

void sys_scarce_memory() {
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 11                	push   $0x11
  801cc6:	e8 4e fe ff ff       	call   801b19 <syscall>
  801ccb:	83 c4 18             	add    $0x18,%esp
}
  801cce:	90                   	nop
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <sys_cputc>:

void sys_cputc(const char c) {
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
  801cd4:	83 ec 04             	sub    $0x4,%esp
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cdd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	50                   	push   %eax
  801cea:	6a 01                	push   $0x1
  801cec:	e8 28 fe ff ff       	call   801b19 <syscall>
  801cf1:	83 c4 18             	add    $0x18,%esp
}
  801cf4:	90                   	nop
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 14                	push   $0x14
  801d06:	e8 0e fe ff ff       	call   801b19 <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
}
  801d0e:	90                   	nop
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	83 ec 04             	sub    $0x4,%esp
  801d17:	8b 45 10             	mov    0x10(%ebp),%eax
  801d1a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801d1d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d20:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d24:	8b 45 08             	mov    0x8(%ebp),%eax
  801d27:	6a 00                	push   $0x0
  801d29:	51                   	push   %ecx
  801d2a:	52                   	push   %edx
  801d2b:	ff 75 0c             	pushl  0xc(%ebp)
  801d2e:	50                   	push   %eax
  801d2f:	6a 15                	push   $0x15
  801d31:	e8 e3 fd ff ff       	call   801b19 <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801d3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	52                   	push   %edx
  801d4b:	50                   	push   %eax
  801d4c:	6a 16                	push   $0x16
  801d4e:	e8 c6 fd ff ff       	call   801b19 <syscall>
  801d53:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801d5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d61:	8b 45 08             	mov    0x8(%ebp),%eax
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	51                   	push   %ecx
  801d69:	52                   	push   %edx
  801d6a:	50                   	push   %eax
  801d6b:	6a 17                	push   $0x17
  801d6d:	e8 a7 fd ff ff       	call   801b19 <syscall>
  801d72:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801d7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	52                   	push   %edx
  801d87:	50                   	push   %eax
  801d88:	6a 18                	push   $0x18
  801d8a:	e8 8a fd ff ff       	call   801b19 <syscall>
  801d8f:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801d97:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9a:	6a 00                	push   $0x0
  801d9c:	ff 75 14             	pushl  0x14(%ebp)
  801d9f:	ff 75 10             	pushl  0x10(%ebp)
  801da2:	ff 75 0c             	pushl  0xc(%ebp)
  801da5:	50                   	push   %eax
  801da6:	6a 19                	push   $0x19
  801da8:	e8 6c fd ff ff       	call   801b19 <syscall>
  801dad:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <sys_run_env>:

void sys_run_env(int32 envId) {
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801db5:	8b 45 08             	mov    0x8(%ebp),%eax
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	50                   	push   %eax
  801dc1:	6a 1a                	push   $0x1a
  801dc3:	e8 51 fd ff ff       	call   801b19 <syscall>
  801dc8:	83 c4 18             	add    $0x18,%esp
}
  801dcb:	90                   	nop
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	50                   	push   %eax
  801ddd:	6a 1b                	push   $0x1b
  801ddf:	e8 35 fd ff ff       	call   801b19 <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <sys_getenvid>:

int32 sys_getenvid(void) {
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 05                	push   $0x5
  801df8:	e8 1c fd ff ff       	call   801b19 <syscall>
  801dfd:	83 c4 18             	add    $0x18,%esp
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 06                	push   $0x6
  801e11:	e8 03 fd ff ff       	call   801b19 <syscall>
  801e16:	83 c4 18             	add    $0x18,%esp
}
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 07                	push   $0x7
  801e2a:	e8 ea fc ff ff       	call   801b19 <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
}
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <sys_exit_env>:

void sys_exit_env(void) {
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 1c                	push   $0x1c
  801e43:	e8 d1 fc ff ff       	call   801b19 <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
}
  801e4b:	90                   	nop
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    

00801e4e <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801e54:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e57:	8d 50 04             	lea    0x4(%eax),%edx
  801e5a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	52                   	push   %edx
  801e64:	50                   	push   %eax
  801e65:	6a 1d                	push   $0x1d
  801e67:	e8 ad fc ff ff       	call   801b19 <syscall>
  801e6c:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801e6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e72:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e75:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e78:	89 01                	mov    %eax,(%ecx)
  801e7a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e80:	c9                   	leave  
  801e81:	c2 04 00             	ret    $0x4

00801e84 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	ff 75 10             	pushl  0x10(%ebp)
  801e8e:	ff 75 0c             	pushl  0xc(%ebp)
  801e91:	ff 75 08             	pushl  0x8(%ebp)
  801e94:	6a 13                	push   $0x13
  801e96:	e8 7e fc ff ff       	call   801b19 <syscall>
  801e9b:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801e9e:	90                   	nop
}
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <sys_rcr2>:
uint32 sys_rcr2() {
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 1e                	push   $0x1e
  801eb0:	e8 64 fc ff ff       	call   801b19 <syscall>
  801eb5:	83 c4 18             	add    $0x18,%esp
}
  801eb8:	c9                   	leave  
  801eb9:	c3                   	ret    

00801eba <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	83 ec 04             	sub    $0x4,%esp
  801ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ec6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	50                   	push   %eax
  801ed3:	6a 1f                	push   $0x1f
  801ed5:	e8 3f fc ff ff       	call   801b19 <syscall>
  801eda:	83 c4 18             	add    $0x18,%esp
	return;
  801edd:	90                   	nop
}
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <rsttst>:
void rsttst() {
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 21                	push   $0x21
  801eef:	e8 25 fc ff ff       	call   801b19 <syscall>
  801ef4:	83 c4 18             	add    $0x18,%esp
	return;
  801ef7:	90                   	nop
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
  801efd:	83 ec 04             	sub    $0x4,%esp
  801f00:	8b 45 14             	mov    0x14(%ebp),%eax
  801f03:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f06:	8b 55 18             	mov    0x18(%ebp),%edx
  801f09:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f0d:	52                   	push   %edx
  801f0e:	50                   	push   %eax
  801f0f:	ff 75 10             	pushl  0x10(%ebp)
  801f12:	ff 75 0c             	pushl  0xc(%ebp)
  801f15:	ff 75 08             	pushl  0x8(%ebp)
  801f18:	6a 20                	push   $0x20
  801f1a:	e8 fa fb ff ff       	call   801b19 <syscall>
  801f1f:	83 c4 18             	add    $0x18,%esp
	return;
  801f22:	90                   	nop
}
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <chktst>:
void chktst(uint32 n) {
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	ff 75 08             	pushl  0x8(%ebp)
  801f33:	6a 22                	push   $0x22
  801f35:	e8 df fb ff ff       	call   801b19 <syscall>
  801f3a:	83 c4 18             	add    $0x18,%esp
	return;
  801f3d:	90                   	nop
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <inctst>:

void inctst() {
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 23                	push   $0x23
  801f4f:	e8 c5 fb ff ff       	call   801b19 <syscall>
  801f54:	83 c4 18             	add    $0x18,%esp
	return;
  801f57:	90                   	nop
}
  801f58:	c9                   	leave  
  801f59:	c3                   	ret    

00801f5a <gettst>:
uint32 gettst() {
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 24                	push   $0x24
  801f69:	e8 ab fb ff ff       	call   801b19 <syscall>
  801f6e:	83 c4 18             	add    $0x18,%esp
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 25                	push   $0x25
  801f85:	e8 8f fb ff ff       	call   801b19 <syscall>
  801f8a:	83 c4 18             	add    $0x18,%esp
  801f8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f90:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f94:	75 07                	jne    801f9d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f96:	b8 01 00 00 00       	mov    $0x1,%eax
  801f9b:	eb 05                	jmp    801fa2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
  801fa7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 25                	push   $0x25
  801fb6:	e8 5e fb ff ff       	call   801b19 <syscall>
  801fbb:	83 c4 18             	add    $0x18,%esp
  801fbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fc1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fc5:	75 07                	jne    801fce <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fc7:	b8 01 00 00 00       	mov    $0x1,%eax
  801fcc:	eb 05                	jmp    801fd3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
  801fd8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 25                	push   $0x25
  801fe7:	e8 2d fb ff ff       	call   801b19 <syscall>
  801fec:	83 c4 18             	add    $0x18,%esp
  801fef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ff2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ff6:	75 07                	jne    801fff <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ff8:	b8 01 00 00 00       	mov    $0x1,%eax
  801ffd:	eb 05                	jmp    802004 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802004:	c9                   	leave  
  802005:	c3                   	ret    

00802006 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
  802009:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 25                	push   $0x25
  802018:	e8 fc fa ff ff       	call   801b19 <syscall>
  80201d:	83 c4 18             	add    $0x18,%esp
  802020:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802023:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802027:	75 07                	jne    802030 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802029:	b8 01 00 00 00       	mov    $0x1,%eax
  80202e:	eb 05                	jmp    802035 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802030:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	ff 75 08             	pushl  0x8(%ebp)
  802045:	6a 26                	push   $0x26
  802047:	e8 cd fa ff ff       	call   801b19 <syscall>
  80204c:	83 c4 18             	add    $0x18,%esp
	return;
  80204f:	90                   	nop
}
  802050:	c9                   	leave  
  802051:	c3                   	ret    

00802052 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  802052:	55                   	push   %ebp
  802053:	89 e5                	mov    %esp,%ebp
  802055:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  802056:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802059:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80205c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205f:	8b 45 08             	mov    0x8(%ebp),%eax
  802062:	6a 00                	push   $0x0
  802064:	53                   	push   %ebx
  802065:	51                   	push   %ecx
  802066:	52                   	push   %edx
  802067:	50                   	push   %eax
  802068:	6a 27                	push   $0x27
  80206a:	e8 aa fa ff ff       	call   801b19 <syscall>
  80206f:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  802072:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  80207a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207d:	8b 45 08             	mov    0x8(%ebp),%eax
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	52                   	push   %edx
  802087:	50                   	push   %eax
  802088:	6a 28                	push   $0x28
  80208a:	e8 8a fa ff ff       	call   801b19 <syscall>
  80208f:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  802097:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80209a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	6a 00                	push   $0x0
  8020a2:	51                   	push   %ecx
  8020a3:	ff 75 10             	pushl  0x10(%ebp)
  8020a6:	52                   	push   %edx
  8020a7:	50                   	push   %eax
  8020a8:	6a 29                	push   $0x29
  8020aa:	e8 6a fa ff ff       	call   801b19 <syscall>
  8020af:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	ff 75 10             	pushl  0x10(%ebp)
  8020be:	ff 75 0c             	pushl  0xc(%ebp)
  8020c1:	ff 75 08             	pushl  0x8(%ebp)
  8020c4:	6a 12                	push   $0x12
  8020c6:	e8 4e fa ff ff       	call   801b19 <syscall>
  8020cb:	83 c4 18             	add    $0x18,%esp
	return;
  8020ce:	90                   	nop
}
  8020cf:	c9                   	leave  
  8020d0:	c3                   	ret    

008020d1 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  8020d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	52                   	push   %edx
  8020e1:	50                   	push   %eax
  8020e2:	6a 2a                	push   $0x2a
  8020e4:	e8 30 fa ff ff       	call   801b19 <syscall>
  8020e9:	83 c4 18             	add    $0x18,%esp
	return;
  8020ec:	90                   	nop
}
  8020ed:	c9                   	leave  
  8020ee:	c3                   	ret    

008020ef <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8020f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	50                   	push   %eax
  8020fe:	6a 2b                	push   $0x2b
  802100:	e8 14 fa ff ff       	call   801b19 <syscall>
  802105:	83 c4 18             	add    $0x18,%esp
}
  802108:	c9                   	leave  
  802109:	c3                   	ret    

0080210a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	ff 75 0c             	pushl  0xc(%ebp)
  802116:	ff 75 08             	pushl  0x8(%ebp)
  802119:	6a 2c                	push   $0x2c
  80211b:	e8 f9 f9 ff ff       	call   801b19 <syscall>
  802120:	83 c4 18             	add    $0x18,%esp
	return;
  802123:	90                   	nop
}
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	ff 75 0c             	pushl  0xc(%ebp)
  802132:	ff 75 08             	pushl  0x8(%ebp)
  802135:	6a 2d                	push   $0x2d
  802137:	e8 dd f9 ff ff       	call   801b19 <syscall>
  80213c:	83 c4 18             	add    $0x18,%esp
	return;
  80213f:	90                   	nop
}
  802140:	c9                   	leave  
  802141:	c3                   	ret    

00802142 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  802142:	55                   	push   %ebp
  802143:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	50                   	push   %eax
  802151:	6a 2f                	push   $0x2f
  802153:	e8 c1 f9 ff ff       	call   801b19 <syscall>
  802158:	83 c4 18             	add    $0x18,%esp
	return;
  80215b:	90                   	nop
}
  80215c:	c9                   	leave  
  80215d:	c3                   	ret    

0080215e <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  802161:	8b 55 0c             	mov    0xc(%ebp),%edx
  802164:	8b 45 08             	mov    0x8(%ebp),%eax
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	52                   	push   %edx
  80216e:	50                   	push   %eax
  80216f:	6a 30                	push   $0x30
  802171:	e8 a3 f9 ff ff       	call   801b19 <syscall>
  802176:	83 c4 18             	add    $0x18,%esp
	return;
  802179:	90                   	nop
}
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  80217f:	8b 45 08             	mov    0x8(%ebp),%eax
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	50                   	push   %eax
  80218b:	6a 31                	push   $0x31
  80218d:	e8 87 f9 ff ff       	call   801b19 <syscall>
  802192:	83 c4 18             	add    $0x18,%esp
	return;
  802195:	90                   	nop
}
  802196:	c9                   	leave  
  802197:	c3                   	ret    

00802198 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80219b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	52                   	push   %edx
  8021a8:	50                   	push   %eax
  8021a9:	6a 2e                	push   $0x2e
  8021ab:	e8 69 f9 ff ff       	call   801b19 <syscall>
  8021b0:	83 c4 18             	add    $0x18,%esp
    return;
  8021b3:	90                   	nop
}
  8021b4:	c9                   	leave  
  8021b5:	c3                   	ret    

008021b6 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
  8021b9:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8021bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bf:	83 e8 04             	sub    $0x4,%eax
  8021c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8021c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c8:	8b 00                	mov    (%eax),%eax
  8021ca:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8021cd:	c9                   	leave  
  8021ce:	c3                   	ret    

008021cf <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
  8021d2:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	83 e8 04             	sub    $0x4,%eax
  8021db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8021de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e1:	8b 00                	mov    (%eax),%eax
  8021e3:	83 e0 01             	and    $0x1,%eax
  8021e6:	85 c0                	test   %eax,%eax
  8021e8:	0f 94 c0             	sete   %al
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8021f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8021fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fd:	83 f8 02             	cmp    $0x2,%eax
  802200:	74 2b                	je     80222d <alloc_block+0x40>
  802202:	83 f8 02             	cmp    $0x2,%eax
  802205:	7f 07                	jg     80220e <alloc_block+0x21>
  802207:	83 f8 01             	cmp    $0x1,%eax
  80220a:	74 0e                	je     80221a <alloc_block+0x2d>
  80220c:	eb 58                	jmp    802266 <alloc_block+0x79>
  80220e:	83 f8 03             	cmp    $0x3,%eax
  802211:	74 2d                	je     802240 <alloc_block+0x53>
  802213:	83 f8 04             	cmp    $0x4,%eax
  802216:	74 3b                	je     802253 <alloc_block+0x66>
  802218:	eb 4c                	jmp    802266 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80221a:	83 ec 0c             	sub    $0xc,%esp
  80221d:	ff 75 08             	pushl  0x8(%ebp)
  802220:	e8 f7 03 00 00       	call   80261c <alloc_block_FF>
  802225:	83 c4 10             	add    $0x10,%esp
  802228:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80222b:	eb 4a                	jmp    802277 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80222d:	83 ec 0c             	sub    $0xc,%esp
  802230:	ff 75 08             	pushl  0x8(%ebp)
  802233:	e8 f0 11 00 00       	call   803428 <alloc_block_NF>
  802238:	83 c4 10             	add    $0x10,%esp
  80223b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80223e:	eb 37                	jmp    802277 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802240:	83 ec 0c             	sub    $0xc,%esp
  802243:	ff 75 08             	pushl  0x8(%ebp)
  802246:	e8 08 08 00 00       	call   802a53 <alloc_block_BF>
  80224b:	83 c4 10             	add    $0x10,%esp
  80224e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802251:	eb 24                	jmp    802277 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802253:	83 ec 0c             	sub    $0xc,%esp
  802256:	ff 75 08             	pushl  0x8(%ebp)
  802259:	e8 ad 11 00 00       	call   80340b <alloc_block_WF>
  80225e:	83 c4 10             	add    $0x10,%esp
  802261:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802264:	eb 11                	jmp    802277 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802266:	83 ec 0c             	sub    $0xc,%esp
  802269:	68 78 3e 80 00       	push   $0x803e78
  80226e:	e8 41 e4 ff ff       	call   8006b4 <cprintf>
  802273:	83 c4 10             	add    $0x10,%esp
		break;
  802276:	90                   	nop
	}
	return va;
  802277:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80227a:	c9                   	leave  
  80227b:	c3                   	ret    

0080227c <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80227c:	55                   	push   %ebp
  80227d:	89 e5                	mov    %esp,%ebp
  80227f:	53                   	push   %ebx
  802280:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802283:	83 ec 0c             	sub    $0xc,%esp
  802286:	68 98 3e 80 00       	push   $0x803e98
  80228b:	e8 24 e4 ff ff       	call   8006b4 <cprintf>
  802290:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802293:	83 ec 0c             	sub    $0xc,%esp
  802296:	68 c3 3e 80 00       	push   $0x803ec3
  80229b:	e8 14 e4 ff ff       	call   8006b4 <cprintf>
  8022a0:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022a9:	eb 37                	jmp    8022e2 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8022ab:	83 ec 0c             	sub    $0xc,%esp
  8022ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8022b1:	e8 19 ff ff ff       	call   8021cf <is_free_block>
  8022b6:	83 c4 10             	add    $0x10,%esp
  8022b9:	0f be d8             	movsbl %al,%ebx
  8022bc:	83 ec 0c             	sub    $0xc,%esp
  8022bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8022c2:	e8 ef fe ff ff       	call   8021b6 <get_block_size>
  8022c7:	83 c4 10             	add    $0x10,%esp
  8022ca:	83 ec 04             	sub    $0x4,%esp
  8022cd:	53                   	push   %ebx
  8022ce:	50                   	push   %eax
  8022cf:	68 db 3e 80 00       	push   $0x803edb
  8022d4:	e8 db e3 ff ff       	call   8006b4 <cprintf>
  8022d9:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8022dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8022df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e6:	74 07                	je     8022ef <print_blocks_list+0x73>
  8022e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022eb:	8b 00                	mov    (%eax),%eax
  8022ed:	eb 05                	jmp    8022f4 <print_blocks_list+0x78>
  8022ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f4:	89 45 10             	mov    %eax,0x10(%ebp)
  8022f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8022fa:	85 c0                	test   %eax,%eax
  8022fc:	75 ad                	jne    8022ab <print_blocks_list+0x2f>
  8022fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802302:	75 a7                	jne    8022ab <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802304:	83 ec 0c             	sub    $0xc,%esp
  802307:	68 98 3e 80 00       	push   $0x803e98
  80230c:	e8 a3 e3 ff ff       	call   8006b4 <cprintf>
  802311:	83 c4 10             	add    $0x10,%esp

}
  802314:	90                   	nop
  802315:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802318:	c9                   	leave  
  802319:	c3                   	ret    

0080231a <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80231a:	55                   	push   %ebp
  80231b:	89 e5                	mov    %esp,%ebp
  80231d:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802320:	8b 45 0c             	mov    0xc(%ebp),%eax
  802323:	83 e0 01             	and    $0x1,%eax
  802326:	85 c0                	test   %eax,%eax
  802328:	74 03                	je     80232d <initialize_dynamic_allocator+0x13>
  80232a:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  80232d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802331:	0f 84 f8 00 00 00    	je     80242f <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  802337:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  80233e:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  802341:	a1 40 50 98 00       	mov    0x985040,%eax
  802346:	85 c0                	test   %eax,%eax
  802348:	0f 84 e2 00 00 00    	je     802430 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802357:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  80235d:	8b 55 08             	mov    0x8(%ebp),%edx
  802360:	8b 45 0c             	mov    0xc(%ebp),%eax
  802363:	01 d0                	add    %edx,%eax
  802365:	83 e8 04             	sub    $0x4,%eax
  802368:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  80236b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	83 c0 08             	add    $0x8,%eax
  80237a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  80237d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802380:	83 e8 08             	sub    $0x8,%eax
  802383:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  802386:	83 ec 04             	sub    $0x4,%esp
  802389:	6a 00                	push   $0x0
  80238b:	ff 75 e8             	pushl  -0x18(%ebp)
  80238e:	ff 75 ec             	pushl  -0x14(%ebp)
  802391:	e8 9c 00 00 00       	call   802432 <set_block_data>
  802396:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  802399:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  8023a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  8023ac:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  8023b3:	00 00 00 
  8023b6:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  8023bd:	00 00 00 
  8023c0:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  8023c7:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  8023ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023ce:	75 17                	jne    8023e7 <initialize_dynamic_allocator+0xcd>
  8023d0:	83 ec 04             	sub    $0x4,%esp
  8023d3:	68 f4 3e 80 00       	push   $0x803ef4
  8023d8:	68 80 00 00 00       	push   $0x80
  8023dd:	68 17 3f 80 00       	push   $0x803f17
  8023e2:	e8 10 e0 ff ff       	call   8003f7 <_panic>
  8023e7:	8b 15 48 50 98 00    	mov    0x985048,%edx
  8023ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f0:	89 10                	mov    %edx,(%eax)
  8023f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f5:	8b 00                	mov    (%eax),%eax
  8023f7:	85 c0                	test   %eax,%eax
  8023f9:	74 0d                	je     802408 <initialize_dynamic_allocator+0xee>
  8023fb:	a1 48 50 98 00       	mov    0x985048,%eax
  802400:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802403:	89 50 04             	mov    %edx,0x4(%eax)
  802406:	eb 08                	jmp    802410 <initialize_dynamic_allocator+0xf6>
  802408:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80240b:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802410:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802413:	a3 48 50 98 00       	mov    %eax,0x985048
  802418:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802422:	a1 54 50 98 00       	mov    0x985054,%eax
  802427:	40                   	inc    %eax
  802428:	a3 54 50 98 00       	mov    %eax,0x985054
  80242d:	eb 01                	jmp    802430 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  80242f:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  802430:	c9                   	leave  
  802431:	c3                   	ret    

00802432 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802432:	55                   	push   %ebp
  802433:	89 e5                	mov    %esp,%ebp
  802435:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  802438:	8b 45 0c             	mov    0xc(%ebp),%eax
  80243b:	83 e0 01             	and    $0x1,%eax
  80243e:	85 c0                	test   %eax,%eax
  802440:	74 03                	je     802445 <set_block_data+0x13>
	{
		totalSize++;
  802442:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  802445:	8b 45 08             	mov    0x8(%ebp),%eax
  802448:	83 e8 04             	sub    $0x4,%eax
  80244b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  80244e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802451:	83 e0 fe             	and    $0xfffffffe,%eax
  802454:	89 c2                	mov    %eax,%edx
  802456:	8b 45 10             	mov    0x10(%ebp),%eax
  802459:	83 e0 01             	and    $0x1,%eax
  80245c:	09 c2                	or     %eax,%edx
  80245e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802461:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  802463:	8b 45 0c             	mov    0xc(%ebp),%eax
  802466:	8d 50 f8             	lea    -0x8(%eax),%edx
  802469:	8b 45 08             	mov    0x8(%ebp),%eax
  80246c:	01 d0                	add    %edx,%eax
  80246e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  802471:	8b 45 0c             	mov    0xc(%ebp),%eax
  802474:	83 e0 fe             	and    $0xfffffffe,%eax
  802477:	89 c2                	mov    %eax,%edx
  802479:	8b 45 10             	mov    0x10(%ebp),%eax
  80247c:	83 e0 01             	and    $0x1,%eax
  80247f:	09 c2                	or     %eax,%edx
  802481:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802484:	89 10                	mov    %edx,(%eax)
}
  802486:	90                   	nop
  802487:	c9                   	leave  
  802488:	c3                   	ret    

00802489 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  802489:	55                   	push   %ebp
  80248a:	89 e5                	mov    %esp,%ebp
  80248c:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  80248f:	a1 48 50 98 00       	mov    0x985048,%eax
  802494:	85 c0                	test   %eax,%eax
  802496:	75 68                	jne    802500 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  802498:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80249c:	75 17                	jne    8024b5 <insert_sorted_in_freeList+0x2c>
  80249e:	83 ec 04             	sub    $0x4,%esp
  8024a1:	68 f4 3e 80 00       	push   $0x803ef4
  8024a6:	68 9d 00 00 00       	push   $0x9d
  8024ab:	68 17 3f 80 00       	push   $0x803f17
  8024b0:	e8 42 df ff ff       	call   8003f7 <_panic>
  8024b5:	8b 15 48 50 98 00    	mov    0x985048,%edx
  8024bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024be:	89 10                	mov    %edx,(%eax)
  8024c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c3:	8b 00                	mov    (%eax),%eax
  8024c5:	85 c0                	test   %eax,%eax
  8024c7:	74 0d                	je     8024d6 <insert_sorted_in_freeList+0x4d>
  8024c9:	a1 48 50 98 00       	mov    0x985048,%eax
  8024ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8024d1:	89 50 04             	mov    %edx,0x4(%eax)
  8024d4:	eb 08                	jmp    8024de <insert_sorted_in_freeList+0x55>
  8024d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d9:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8024de:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e1:	a3 48 50 98 00       	mov    %eax,0x985048
  8024e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f0:	a1 54 50 98 00       	mov    0x985054,%eax
  8024f5:	40                   	inc    %eax
  8024f6:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  8024fb:	e9 1a 01 00 00       	jmp    80261a <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802500:	a1 48 50 98 00       	mov    0x985048,%eax
  802505:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802508:	eb 7f                	jmp    802589 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802510:	76 6f                	jbe    802581 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  802512:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802516:	74 06                	je     80251e <insert_sorted_in_freeList+0x95>
  802518:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80251c:	75 17                	jne    802535 <insert_sorted_in_freeList+0xac>
  80251e:	83 ec 04             	sub    $0x4,%esp
  802521:	68 30 3f 80 00       	push   $0x803f30
  802526:	68 a6 00 00 00       	push   $0xa6
  80252b:	68 17 3f 80 00       	push   $0x803f17
  802530:	e8 c2 de ff ff       	call   8003f7 <_panic>
  802535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802538:	8b 50 04             	mov    0x4(%eax),%edx
  80253b:	8b 45 08             	mov    0x8(%ebp),%eax
  80253e:	89 50 04             	mov    %edx,0x4(%eax)
  802541:	8b 45 08             	mov    0x8(%ebp),%eax
  802544:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802547:	89 10                	mov    %edx,(%eax)
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	8b 40 04             	mov    0x4(%eax),%eax
  80254f:	85 c0                	test   %eax,%eax
  802551:	74 0d                	je     802560 <insert_sorted_in_freeList+0xd7>
  802553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802556:	8b 40 04             	mov    0x4(%eax),%eax
  802559:	8b 55 08             	mov    0x8(%ebp),%edx
  80255c:	89 10                	mov    %edx,(%eax)
  80255e:	eb 08                	jmp    802568 <insert_sorted_in_freeList+0xdf>
  802560:	8b 45 08             	mov    0x8(%ebp),%eax
  802563:	a3 48 50 98 00       	mov    %eax,0x985048
  802568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256b:	8b 55 08             	mov    0x8(%ebp),%edx
  80256e:	89 50 04             	mov    %edx,0x4(%eax)
  802571:	a1 54 50 98 00       	mov    0x985054,%eax
  802576:	40                   	inc    %eax
  802577:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  80257c:	e9 99 00 00 00       	jmp    80261a <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802581:	a1 50 50 98 00       	mov    0x985050,%eax
  802586:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802589:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258d:	74 07                	je     802596 <insert_sorted_in_freeList+0x10d>
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	8b 00                	mov    (%eax),%eax
  802594:	eb 05                	jmp    80259b <insert_sorted_in_freeList+0x112>
  802596:	b8 00 00 00 00       	mov    $0x0,%eax
  80259b:	a3 50 50 98 00       	mov    %eax,0x985050
  8025a0:	a1 50 50 98 00       	mov    0x985050,%eax
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	0f 85 5d ff ff ff    	jne    80250a <insert_sorted_in_freeList+0x81>
  8025ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b1:	0f 85 53 ff ff ff    	jne    80250a <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  8025b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025bb:	75 17                	jne    8025d4 <insert_sorted_in_freeList+0x14b>
  8025bd:	83 ec 04             	sub    $0x4,%esp
  8025c0:	68 68 3f 80 00       	push   $0x803f68
  8025c5:	68 ab 00 00 00       	push   $0xab
  8025ca:	68 17 3f 80 00       	push   $0x803f17
  8025cf:	e8 23 de ff ff       	call   8003f7 <_panic>
  8025d4:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  8025da:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dd:	89 50 04             	mov    %edx,0x4(%eax)
  8025e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e3:	8b 40 04             	mov    0x4(%eax),%eax
  8025e6:	85 c0                	test   %eax,%eax
  8025e8:	74 0c                	je     8025f6 <insert_sorted_in_freeList+0x16d>
  8025ea:	a1 4c 50 98 00       	mov    0x98504c,%eax
  8025ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8025f2:	89 10                	mov    %edx,(%eax)
  8025f4:	eb 08                	jmp    8025fe <insert_sorted_in_freeList+0x175>
  8025f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f9:	a3 48 50 98 00       	mov    %eax,0x985048
  8025fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802601:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802606:	8b 45 08             	mov    0x8(%ebp),%eax
  802609:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80260f:	a1 54 50 98 00       	mov    0x985054,%eax
  802614:	40                   	inc    %eax
  802615:	a3 54 50 98 00       	mov    %eax,0x985054
}
  80261a:	c9                   	leave  
  80261b:	c3                   	ret    

0080261c <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  80261c:	55                   	push   %ebp
  80261d:	89 e5                	mov    %esp,%ebp
  80261f:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802622:	8b 45 08             	mov    0x8(%ebp),%eax
  802625:	83 e0 01             	and    $0x1,%eax
  802628:	85 c0                	test   %eax,%eax
  80262a:	74 03                	je     80262f <alloc_block_FF+0x13>
  80262c:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80262f:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802633:	77 07                	ja     80263c <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802635:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80263c:	a1 40 50 98 00       	mov    0x985040,%eax
  802641:	85 c0                	test   %eax,%eax
  802643:	75 63                	jne    8026a8 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802645:	8b 45 08             	mov    0x8(%ebp),%eax
  802648:	83 c0 10             	add    $0x10,%eax
  80264b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80264e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802655:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802658:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80265b:	01 d0                	add    %edx,%eax
  80265d:	48                   	dec    %eax
  80265e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802661:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802664:	ba 00 00 00 00       	mov    $0x0,%edx
  802669:	f7 75 ec             	divl   -0x14(%ebp)
  80266c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80266f:	29 d0                	sub    %edx,%eax
  802671:	c1 e8 0c             	shr    $0xc,%eax
  802674:	83 ec 0c             	sub    $0xc,%esp
  802677:	50                   	push   %eax
  802678:	e8 d1 ed ff ff       	call   80144e <sbrk>
  80267d:	83 c4 10             	add    $0x10,%esp
  802680:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802683:	83 ec 0c             	sub    $0xc,%esp
  802686:	6a 00                	push   $0x0
  802688:	e8 c1 ed ff ff       	call   80144e <sbrk>
  80268d:	83 c4 10             	add    $0x10,%esp
  802690:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802693:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802696:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802699:	83 ec 08             	sub    $0x8,%esp
  80269c:	50                   	push   %eax
  80269d:	ff 75 e4             	pushl  -0x1c(%ebp)
  8026a0:	e8 75 fc ff ff       	call   80231a <initialize_dynamic_allocator>
  8026a5:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  8026a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026ac:	75 0a                	jne    8026b8 <alloc_block_FF+0x9c>
	{
		return NULL;
  8026ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b3:	e9 99 03 00 00       	jmp    802a51 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  8026b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bb:	83 c0 08             	add    $0x8,%eax
  8026be:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8026c1:	a1 48 50 98 00       	mov    0x985048,%eax
  8026c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c9:	e9 03 02 00 00       	jmp    8028d1 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  8026ce:	83 ec 0c             	sub    $0xc,%esp
  8026d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8026d4:	e8 dd fa ff ff       	call   8021b6 <get_block_size>
  8026d9:	83 c4 10             	add    $0x10,%esp
  8026dc:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  8026df:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8026e2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8026e5:	0f 82 de 01 00 00    	jb     8028c9 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  8026eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026ee:	83 c0 10             	add    $0x10,%eax
  8026f1:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  8026f4:	0f 87 32 01 00 00    	ja     80282c <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  8026fa:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8026fd:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802700:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802703:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802706:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802709:	01 d0                	add    %edx,%eax
  80270b:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  80270e:	83 ec 04             	sub    $0x4,%esp
  802711:	6a 00                	push   $0x0
  802713:	ff 75 98             	pushl  -0x68(%ebp)
  802716:	ff 75 94             	pushl  -0x6c(%ebp)
  802719:	e8 14 fd ff ff       	call   802432 <set_block_data>
  80271e:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802721:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802725:	74 06                	je     80272d <alloc_block_FF+0x111>
  802727:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  80272b:	75 17                	jne    802744 <alloc_block_FF+0x128>
  80272d:	83 ec 04             	sub    $0x4,%esp
  802730:	68 8c 3f 80 00       	push   $0x803f8c
  802735:	68 de 00 00 00       	push   $0xde
  80273a:	68 17 3f 80 00       	push   $0x803f17
  80273f:	e8 b3 dc ff ff       	call   8003f7 <_panic>
  802744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802747:	8b 10                	mov    (%eax),%edx
  802749:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80274c:	89 10                	mov    %edx,(%eax)
  80274e:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802751:	8b 00                	mov    (%eax),%eax
  802753:	85 c0                	test   %eax,%eax
  802755:	74 0b                	je     802762 <alloc_block_FF+0x146>
  802757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275a:	8b 00                	mov    (%eax),%eax
  80275c:	8b 55 94             	mov    -0x6c(%ebp),%edx
  80275f:	89 50 04             	mov    %edx,0x4(%eax)
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802768:	89 10                	mov    %edx,(%eax)
  80276a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80276d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802770:	89 50 04             	mov    %edx,0x4(%eax)
  802773:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802776:	8b 00                	mov    (%eax),%eax
  802778:	85 c0                	test   %eax,%eax
  80277a:	75 08                	jne    802784 <alloc_block_FF+0x168>
  80277c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80277f:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802784:	a1 54 50 98 00       	mov    0x985054,%eax
  802789:	40                   	inc    %eax
  80278a:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  80278f:	83 ec 04             	sub    $0x4,%esp
  802792:	6a 01                	push   $0x1
  802794:	ff 75 dc             	pushl  -0x24(%ebp)
  802797:	ff 75 f4             	pushl  -0xc(%ebp)
  80279a:	e8 93 fc ff ff       	call   802432 <set_block_data>
  80279f:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  8027a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a6:	75 17                	jne    8027bf <alloc_block_FF+0x1a3>
  8027a8:	83 ec 04             	sub    $0x4,%esp
  8027ab:	68 c0 3f 80 00       	push   $0x803fc0
  8027b0:	68 e3 00 00 00       	push   $0xe3
  8027b5:	68 17 3f 80 00       	push   $0x803f17
  8027ba:	e8 38 dc ff ff       	call   8003f7 <_panic>
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	8b 00                	mov    (%eax),%eax
  8027c4:	85 c0                	test   %eax,%eax
  8027c6:	74 10                	je     8027d8 <alloc_block_FF+0x1bc>
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	8b 00                	mov    (%eax),%eax
  8027cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d0:	8b 52 04             	mov    0x4(%edx),%edx
  8027d3:	89 50 04             	mov    %edx,0x4(%eax)
  8027d6:	eb 0b                	jmp    8027e3 <alloc_block_FF+0x1c7>
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	8b 40 04             	mov    0x4(%eax),%eax
  8027de:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	8b 40 04             	mov    0x4(%eax),%eax
  8027e9:	85 c0                	test   %eax,%eax
  8027eb:	74 0f                	je     8027fc <alloc_block_FF+0x1e0>
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	8b 40 04             	mov    0x4(%eax),%eax
  8027f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f6:	8b 12                	mov    (%edx),%edx
  8027f8:	89 10                	mov    %edx,(%eax)
  8027fa:	eb 0a                	jmp    802806 <alloc_block_FF+0x1ea>
  8027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ff:	8b 00                	mov    (%eax),%eax
  802801:	a3 48 50 98 00       	mov    %eax,0x985048
  802806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802809:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802819:	a1 54 50 98 00       	mov    0x985054,%eax
  80281e:	48                   	dec    %eax
  80281f:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802827:	e9 25 02 00 00       	jmp    802a51 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  80282c:	83 ec 04             	sub    $0x4,%esp
  80282f:	6a 01                	push   $0x1
  802831:	ff 75 9c             	pushl  -0x64(%ebp)
  802834:	ff 75 f4             	pushl  -0xc(%ebp)
  802837:	e8 f6 fb ff ff       	call   802432 <set_block_data>
  80283c:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  80283f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802843:	75 17                	jne    80285c <alloc_block_FF+0x240>
  802845:	83 ec 04             	sub    $0x4,%esp
  802848:	68 c0 3f 80 00       	push   $0x803fc0
  80284d:	68 eb 00 00 00       	push   $0xeb
  802852:	68 17 3f 80 00       	push   $0x803f17
  802857:	e8 9b db ff ff       	call   8003f7 <_panic>
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	8b 00                	mov    (%eax),%eax
  802861:	85 c0                	test   %eax,%eax
  802863:	74 10                	je     802875 <alloc_block_FF+0x259>
  802865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802868:	8b 00                	mov    (%eax),%eax
  80286a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80286d:	8b 52 04             	mov    0x4(%edx),%edx
  802870:	89 50 04             	mov    %edx,0x4(%eax)
  802873:	eb 0b                	jmp    802880 <alloc_block_FF+0x264>
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	8b 40 04             	mov    0x4(%eax),%eax
  80287b:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	8b 40 04             	mov    0x4(%eax),%eax
  802886:	85 c0                	test   %eax,%eax
  802888:	74 0f                	je     802899 <alloc_block_FF+0x27d>
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	8b 40 04             	mov    0x4(%eax),%eax
  802890:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802893:	8b 12                	mov    (%edx),%edx
  802895:	89 10                	mov    %edx,(%eax)
  802897:	eb 0a                	jmp    8028a3 <alloc_block_FF+0x287>
  802899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289c:	8b 00                	mov    (%eax),%eax
  80289e:	a3 48 50 98 00       	mov    %eax,0x985048
  8028a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b6:	a1 54 50 98 00       	mov    0x985054,%eax
  8028bb:	48                   	dec    %eax
  8028bc:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  8028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c4:	e9 88 01 00 00       	jmp    802a51 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8028c9:	a1 50 50 98 00       	mov    0x985050,%eax
  8028ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d5:	74 07                	je     8028de <alloc_block_FF+0x2c2>
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	8b 00                	mov    (%eax),%eax
  8028dc:	eb 05                	jmp    8028e3 <alloc_block_FF+0x2c7>
  8028de:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e3:	a3 50 50 98 00       	mov    %eax,0x985050
  8028e8:	a1 50 50 98 00       	mov    0x985050,%eax
  8028ed:	85 c0                	test   %eax,%eax
  8028ef:	0f 85 d9 fd ff ff    	jne    8026ce <alloc_block_FF+0xb2>
  8028f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f9:	0f 85 cf fd ff ff    	jne    8026ce <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  8028ff:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802906:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802909:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80290c:	01 d0                	add    %edx,%eax
  80290e:	48                   	dec    %eax
  80290f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802912:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802915:	ba 00 00 00 00       	mov    $0x0,%edx
  80291a:	f7 75 d8             	divl   -0x28(%ebp)
  80291d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802920:	29 d0                	sub    %edx,%eax
  802922:	c1 e8 0c             	shr    $0xc,%eax
  802925:	83 ec 0c             	sub    $0xc,%esp
  802928:	50                   	push   %eax
  802929:	e8 20 eb ff ff       	call   80144e <sbrk>
  80292e:	83 c4 10             	add    $0x10,%esp
  802931:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802934:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802938:	75 0a                	jne    802944 <alloc_block_FF+0x328>
		return NULL;
  80293a:	b8 00 00 00 00       	mov    $0x0,%eax
  80293f:	e9 0d 01 00 00       	jmp    802a51 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  802944:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802947:	83 e8 04             	sub    $0x4,%eax
  80294a:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  80294d:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  802954:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802957:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80295a:	01 d0                	add    %edx,%eax
  80295c:	48                   	dec    %eax
  80295d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802960:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802963:	ba 00 00 00 00       	mov    $0x0,%edx
  802968:	f7 75 c8             	divl   -0x38(%ebp)
  80296b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80296e:	29 d0                	sub    %edx,%eax
  802970:	c1 e8 02             	shr    $0x2,%eax
  802973:	c1 e0 02             	shl    $0x2,%eax
  802976:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  802979:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80297c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  802982:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802985:	83 e8 08             	sub    $0x8,%eax
  802988:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  80298b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80298e:	8b 00                	mov    (%eax),%eax
  802990:	83 e0 fe             	and    $0xfffffffe,%eax
  802993:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  802996:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802999:	f7 d8                	neg    %eax
  80299b:	89 c2                	mov    %eax,%edx
  80299d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029a0:	01 d0                	add    %edx,%eax
  8029a2:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  8029a5:	83 ec 0c             	sub    $0xc,%esp
  8029a8:	ff 75 b8             	pushl  -0x48(%ebp)
  8029ab:	e8 1f f8 ff ff       	call   8021cf <is_free_block>
  8029b0:	83 c4 10             	add    $0x10,%esp
  8029b3:	0f be c0             	movsbl %al,%eax
  8029b6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  8029b9:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8029bd:	74 42                	je     802a01 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  8029bf:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8029c6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029c9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029cc:	01 d0                	add    %edx,%eax
  8029ce:	48                   	dec    %eax
  8029cf:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8029d2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8029d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8029da:	f7 75 b0             	divl   -0x50(%ebp)
  8029dd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8029e0:	29 d0                	sub    %edx,%eax
  8029e2:	89 c2                	mov    %eax,%edx
  8029e4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8029e7:	01 d0                	add    %edx,%eax
  8029e9:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  8029ec:	83 ec 04             	sub    $0x4,%esp
  8029ef:	6a 00                	push   $0x0
  8029f1:	ff 75 a8             	pushl  -0x58(%ebp)
  8029f4:	ff 75 b8             	pushl  -0x48(%ebp)
  8029f7:	e8 36 fa ff ff       	call   802432 <set_block_data>
  8029fc:	83 c4 10             	add    $0x10,%esp
  8029ff:	eb 42                	jmp    802a43 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802a01:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  802a08:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a0b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a0e:	01 d0                	add    %edx,%eax
  802a10:	48                   	dec    %eax
  802a11:	89 45 a0             	mov    %eax,-0x60(%ebp)
  802a14:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802a17:	ba 00 00 00 00       	mov    $0x0,%edx
  802a1c:	f7 75 a4             	divl   -0x5c(%ebp)
  802a1f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802a22:	29 d0                	sub    %edx,%eax
  802a24:	83 ec 04             	sub    $0x4,%esp
  802a27:	6a 00                	push   $0x0
  802a29:	50                   	push   %eax
  802a2a:	ff 75 d0             	pushl  -0x30(%ebp)
  802a2d:	e8 00 fa ff ff       	call   802432 <set_block_data>
  802a32:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802a35:	83 ec 0c             	sub    $0xc,%esp
  802a38:	ff 75 d0             	pushl  -0x30(%ebp)
  802a3b:	e8 49 fa ff ff       	call   802489 <insert_sorted_in_freeList>
  802a40:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802a43:	83 ec 0c             	sub    $0xc,%esp
  802a46:	ff 75 08             	pushl  0x8(%ebp)
  802a49:	e8 ce fb ff ff       	call   80261c <alloc_block_FF>
  802a4e:	83 c4 10             	add    $0x10,%esp
}
  802a51:	c9                   	leave  
  802a52:	c3                   	ret    

00802a53 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802a53:	55                   	push   %ebp
  802a54:	89 e5                	mov    %esp,%ebp
  802a56:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  802a59:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a5d:	75 0a                	jne    802a69 <alloc_block_BF+0x16>
	{
		return NULL;
  802a5f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a64:	e9 7a 02 00 00       	jmp    802ce3 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802a69:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6c:	83 c0 08             	add    $0x8,%eax
  802a6f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802a72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  802a79:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802a80:	a1 48 50 98 00       	mov    0x985048,%eax
  802a85:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a88:	eb 32                	jmp    802abc <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  802a8a:	ff 75 ec             	pushl  -0x14(%ebp)
  802a8d:	e8 24 f7 ff ff       	call   8021b6 <get_block_size>
  802a92:	83 c4 04             	add    $0x4,%esp
  802a95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  802a98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a9b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a9e:	72 14                	jb     802ab4 <alloc_block_BF+0x61>
  802aa0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aa3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802aa6:	73 0c                	jae    802ab4 <alloc_block_BF+0x61>
		{
			minBlk = block;
  802aa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  802aae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ab1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802ab4:	a1 50 50 98 00       	mov    0x985050,%eax
  802ab9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802abc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ac0:	74 07                	je     802ac9 <alloc_block_BF+0x76>
  802ac2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac5:	8b 00                	mov    (%eax),%eax
  802ac7:	eb 05                	jmp    802ace <alloc_block_BF+0x7b>
  802ac9:	b8 00 00 00 00       	mov    $0x0,%eax
  802ace:	a3 50 50 98 00       	mov    %eax,0x985050
  802ad3:	a1 50 50 98 00       	mov    0x985050,%eax
  802ad8:	85 c0                	test   %eax,%eax
  802ada:	75 ae                	jne    802a8a <alloc_block_BF+0x37>
  802adc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ae0:	75 a8                	jne    802a8a <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802ae2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae6:	75 22                	jne    802b0a <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802ae8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aeb:	83 ec 0c             	sub    $0xc,%esp
  802aee:	50                   	push   %eax
  802aef:	e8 5a e9 ff ff       	call   80144e <sbrk>
  802af4:	83 c4 10             	add    $0x10,%esp
  802af7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  802afa:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802afe:	75 0a                	jne    802b0a <alloc_block_BF+0xb7>
			return NULL;
  802b00:	b8 00 00 00 00       	mov    $0x0,%eax
  802b05:	e9 d9 01 00 00       	jmp    802ce3 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  802b0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0d:	83 c0 10             	add    $0x10,%eax
  802b10:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b13:	0f 87 32 01 00 00    	ja     802c4b <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  802b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802b1f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802b22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b28:	01 d0                	add    %edx,%eax
  802b2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  802b2d:	83 ec 04             	sub    $0x4,%esp
  802b30:	6a 00                	push   $0x0
  802b32:	ff 75 dc             	pushl  -0x24(%ebp)
  802b35:	ff 75 d8             	pushl  -0x28(%ebp)
  802b38:	e8 f5 f8 ff ff       	call   802432 <set_block_data>
  802b3d:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802b40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b44:	74 06                	je     802b4c <alloc_block_BF+0xf9>
  802b46:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802b4a:	75 17                	jne    802b63 <alloc_block_BF+0x110>
  802b4c:	83 ec 04             	sub    $0x4,%esp
  802b4f:	68 8c 3f 80 00       	push   $0x803f8c
  802b54:	68 49 01 00 00       	push   $0x149
  802b59:	68 17 3f 80 00       	push   $0x803f17
  802b5e:	e8 94 d8 ff ff       	call   8003f7 <_panic>
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	8b 10                	mov    (%eax),%edx
  802b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b6b:	89 10                	mov    %edx,(%eax)
  802b6d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b70:	8b 00                	mov    (%eax),%eax
  802b72:	85 c0                	test   %eax,%eax
  802b74:	74 0b                	je     802b81 <alloc_block_BF+0x12e>
  802b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b79:	8b 00                	mov    (%eax),%eax
  802b7b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b7e:	89 50 04             	mov    %edx,0x4(%eax)
  802b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b84:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b87:	89 10                	mov    %edx,(%eax)
  802b89:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b8f:	89 50 04             	mov    %edx,0x4(%eax)
  802b92:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b95:	8b 00                	mov    (%eax),%eax
  802b97:	85 c0                	test   %eax,%eax
  802b99:	75 08                	jne    802ba3 <alloc_block_BF+0x150>
  802b9b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b9e:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802ba3:	a1 54 50 98 00       	mov    0x985054,%eax
  802ba8:	40                   	inc    %eax
  802ba9:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802bae:	83 ec 04             	sub    $0x4,%esp
  802bb1:	6a 01                	push   $0x1
  802bb3:	ff 75 e8             	pushl  -0x18(%ebp)
  802bb6:	ff 75 f4             	pushl  -0xc(%ebp)
  802bb9:	e8 74 f8 ff ff       	call   802432 <set_block_data>
  802bbe:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802bc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc5:	75 17                	jne    802bde <alloc_block_BF+0x18b>
  802bc7:	83 ec 04             	sub    $0x4,%esp
  802bca:	68 c0 3f 80 00       	push   $0x803fc0
  802bcf:	68 4e 01 00 00       	push   $0x14e
  802bd4:	68 17 3f 80 00       	push   $0x803f17
  802bd9:	e8 19 d8 ff ff       	call   8003f7 <_panic>
  802bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be1:	8b 00                	mov    (%eax),%eax
  802be3:	85 c0                	test   %eax,%eax
  802be5:	74 10                	je     802bf7 <alloc_block_BF+0x1a4>
  802be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bea:	8b 00                	mov    (%eax),%eax
  802bec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bef:	8b 52 04             	mov    0x4(%edx),%edx
  802bf2:	89 50 04             	mov    %edx,0x4(%eax)
  802bf5:	eb 0b                	jmp    802c02 <alloc_block_BF+0x1af>
  802bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfa:	8b 40 04             	mov    0x4(%eax),%eax
  802bfd:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c05:	8b 40 04             	mov    0x4(%eax),%eax
  802c08:	85 c0                	test   %eax,%eax
  802c0a:	74 0f                	je     802c1b <alloc_block_BF+0x1c8>
  802c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0f:	8b 40 04             	mov    0x4(%eax),%eax
  802c12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c15:	8b 12                	mov    (%edx),%edx
  802c17:	89 10                	mov    %edx,(%eax)
  802c19:	eb 0a                	jmp    802c25 <alloc_block_BF+0x1d2>
  802c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1e:	8b 00                	mov    (%eax),%eax
  802c20:	a3 48 50 98 00       	mov    %eax,0x985048
  802c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c28:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c38:	a1 54 50 98 00       	mov    0x985054,%eax
  802c3d:	48                   	dec    %eax
  802c3e:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c46:	e9 98 00 00 00       	jmp    802ce3 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  802c4b:	83 ec 04             	sub    $0x4,%esp
  802c4e:	6a 01                	push   $0x1
  802c50:	ff 75 f0             	pushl  -0x10(%ebp)
  802c53:	ff 75 f4             	pushl  -0xc(%ebp)
  802c56:	e8 d7 f7 ff ff       	call   802432 <set_block_data>
  802c5b:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802c5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c62:	75 17                	jne    802c7b <alloc_block_BF+0x228>
  802c64:	83 ec 04             	sub    $0x4,%esp
  802c67:	68 c0 3f 80 00       	push   $0x803fc0
  802c6c:	68 56 01 00 00       	push   $0x156
  802c71:	68 17 3f 80 00       	push   $0x803f17
  802c76:	e8 7c d7 ff ff       	call   8003f7 <_panic>
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	8b 00                	mov    (%eax),%eax
  802c80:	85 c0                	test   %eax,%eax
  802c82:	74 10                	je     802c94 <alloc_block_BF+0x241>
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	8b 00                	mov    (%eax),%eax
  802c89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8c:	8b 52 04             	mov    0x4(%edx),%edx
  802c8f:	89 50 04             	mov    %edx,0x4(%eax)
  802c92:	eb 0b                	jmp    802c9f <alloc_block_BF+0x24c>
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	8b 40 04             	mov    0x4(%eax),%eax
  802c9a:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	8b 40 04             	mov    0x4(%eax),%eax
  802ca5:	85 c0                	test   %eax,%eax
  802ca7:	74 0f                	je     802cb8 <alloc_block_BF+0x265>
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	8b 40 04             	mov    0x4(%eax),%eax
  802caf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb2:	8b 12                	mov    (%edx),%edx
  802cb4:	89 10                	mov    %edx,(%eax)
  802cb6:	eb 0a                	jmp    802cc2 <alloc_block_BF+0x26f>
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	8b 00                	mov    (%eax),%eax
  802cbd:	a3 48 50 98 00       	mov    %eax,0x985048
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd5:	a1 54 50 98 00       	mov    0x985054,%eax
  802cda:	48                   	dec    %eax
  802cdb:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802ce3:	c9                   	leave  
  802ce4:	c3                   	ret    

00802ce5 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802ce5:	55                   	push   %ebp
  802ce6:	89 e5                	mov    %esp,%ebp
  802ce8:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802ceb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cef:	0f 84 6a 02 00 00    	je     802f5f <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  802cf5:	ff 75 08             	pushl  0x8(%ebp)
  802cf8:	e8 b9 f4 ff ff       	call   8021b6 <get_block_size>
  802cfd:	83 c4 04             	add    $0x4,%esp
  802d00:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  802d03:	8b 45 08             	mov    0x8(%ebp),%eax
  802d06:	83 e8 08             	sub    $0x8,%eax
  802d09:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  802d0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0f:	8b 00                	mov    (%eax),%eax
  802d11:	83 e0 fe             	and    $0xfffffffe,%eax
  802d14:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  802d17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1a:	f7 d8                	neg    %eax
  802d1c:	89 c2                	mov    %eax,%edx
  802d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d21:	01 d0                	add    %edx,%eax
  802d23:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802d26:	ff 75 e8             	pushl  -0x18(%ebp)
  802d29:	e8 a1 f4 ff ff       	call   8021cf <is_free_block>
  802d2e:	83 c4 04             	add    $0x4,%esp
  802d31:	0f be c0             	movsbl %al,%eax
  802d34:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802d37:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3d:	01 d0                	add    %edx,%eax
  802d3f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802d42:	ff 75 e0             	pushl  -0x20(%ebp)
  802d45:	e8 85 f4 ff ff       	call   8021cf <is_free_block>
  802d4a:	83 c4 04             	add    $0x4,%esp
  802d4d:	0f be c0             	movsbl %al,%eax
  802d50:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802d53:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802d57:	75 34                	jne    802d8d <free_block+0xa8>
  802d59:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d5d:	75 2e                	jne    802d8d <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802d5f:	ff 75 e8             	pushl  -0x18(%ebp)
  802d62:	e8 4f f4 ff ff       	call   8021b6 <get_block_size>
  802d67:	83 c4 04             	add    $0x4,%esp
  802d6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802d6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d70:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d73:	01 d0                	add    %edx,%eax
  802d75:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802d78:	6a 00                	push   $0x0
  802d7a:	ff 75 d4             	pushl  -0x2c(%ebp)
  802d7d:	ff 75 e8             	pushl  -0x18(%ebp)
  802d80:	e8 ad f6 ff ff       	call   802432 <set_block_data>
  802d85:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802d88:	e9 d3 01 00 00       	jmp    802f60 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802d8d:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802d91:	0f 85 c8 00 00 00    	jne    802e5f <free_block+0x17a>
  802d97:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d9b:	0f 85 be 00 00 00    	jne    802e5f <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802da1:	ff 75 e0             	pushl  -0x20(%ebp)
  802da4:	e8 0d f4 ff ff       	call   8021b6 <get_block_size>
  802da9:	83 c4 04             	add    $0x4,%esp
  802dac:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802daf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802db5:	01 d0                	add    %edx,%eax
  802db7:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802dba:	6a 00                	push   $0x0
  802dbc:	ff 75 cc             	pushl  -0x34(%ebp)
  802dbf:	ff 75 08             	pushl  0x8(%ebp)
  802dc2:	e8 6b f6 ff ff       	call   802432 <set_block_data>
  802dc7:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802dca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802dce:	75 17                	jne    802de7 <free_block+0x102>
  802dd0:	83 ec 04             	sub    $0x4,%esp
  802dd3:	68 c0 3f 80 00       	push   $0x803fc0
  802dd8:	68 87 01 00 00       	push   $0x187
  802ddd:	68 17 3f 80 00       	push   $0x803f17
  802de2:	e8 10 d6 ff ff       	call   8003f7 <_panic>
  802de7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dea:	8b 00                	mov    (%eax),%eax
  802dec:	85 c0                	test   %eax,%eax
  802dee:	74 10                	je     802e00 <free_block+0x11b>
  802df0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802df3:	8b 00                	mov    (%eax),%eax
  802df5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802df8:	8b 52 04             	mov    0x4(%edx),%edx
  802dfb:	89 50 04             	mov    %edx,0x4(%eax)
  802dfe:	eb 0b                	jmp    802e0b <free_block+0x126>
  802e00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e03:	8b 40 04             	mov    0x4(%eax),%eax
  802e06:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802e0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e0e:	8b 40 04             	mov    0x4(%eax),%eax
  802e11:	85 c0                	test   %eax,%eax
  802e13:	74 0f                	je     802e24 <free_block+0x13f>
  802e15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e18:	8b 40 04             	mov    0x4(%eax),%eax
  802e1b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e1e:	8b 12                	mov    (%edx),%edx
  802e20:	89 10                	mov    %edx,(%eax)
  802e22:	eb 0a                	jmp    802e2e <free_block+0x149>
  802e24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e27:	8b 00                	mov    (%eax),%eax
  802e29:	a3 48 50 98 00       	mov    %eax,0x985048
  802e2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e41:	a1 54 50 98 00       	mov    0x985054,%eax
  802e46:	48                   	dec    %eax
  802e47:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802e4c:	83 ec 0c             	sub    $0xc,%esp
  802e4f:	ff 75 08             	pushl  0x8(%ebp)
  802e52:	e8 32 f6 ff ff       	call   802489 <insert_sorted_in_freeList>
  802e57:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802e5a:	e9 01 01 00 00       	jmp    802f60 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  802e5f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802e63:	0f 85 d3 00 00 00    	jne    802f3c <free_block+0x257>
  802e69:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802e6d:	0f 85 c9 00 00 00    	jne    802f3c <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  802e73:	83 ec 0c             	sub    $0xc,%esp
  802e76:	ff 75 e8             	pushl  -0x18(%ebp)
  802e79:	e8 38 f3 ff ff       	call   8021b6 <get_block_size>
  802e7e:	83 c4 10             	add    $0x10,%esp
  802e81:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  802e84:	83 ec 0c             	sub    $0xc,%esp
  802e87:	ff 75 e0             	pushl  -0x20(%ebp)
  802e8a:	e8 27 f3 ff ff       	call   8021b6 <get_block_size>
  802e8f:	83 c4 10             	add    $0x10,%esp
  802e92:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  802e95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e98:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802e9b:	01 c2                	add    %eax,%edx
  802e9d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ea0:	01 d0                	add    %edx,%eax
  802ea2:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  802ea5:	83 ec 04             	sub    $0x4,%esp
  802ea8:	6a 00                	push   $0x0
  802eaa:	ff 75 c0             	pushl  -0x40(%ebp)
  802ead:	ff 75 e8             	pushl  -0x18(%ebp)
  802eb0:	e8 7d f5 ff ff       	call   802432 <set_block_data>
  802eb5:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  802eb8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ebc:	75 17                	jne    802ed5 <free_block+0x1f0>
  802ebe:	83 ec 04             	sub    $0x4,%esp
  802ec1:	68 c0 3f 80 00       	push   $0x803fc0
  802ec6:	68 94 01 00 00       	push   $0x194
  802ecb:	68 17 3f 80 00       	push   $0x803f17
  802ed0:	e8 22 d5 ff ff       	call   8003f7 <_panic>
  802ed5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed8:	8b 00                	mov    (%eax),%eax
  802eda:	85 c0                	test   %eax,%eax
  802edc:	74 10                	je     802eee <free_block+0x209>
  802ede:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ee1:	8b 00                	mov    (%eax),%eax
  802ee3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ee6:	8b 52 04             	mov    0x4(%edx),%edx
  802ee9:	89 50 04             	mov    %edx,0x4(%eax)
  802eec:	eb 0b                	jmp    802ef9 <free_block+0x214>
  802eee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ef1:	8b 40 04             	mov    0x4(%eax),%eax
  802ef4:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802ef9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802efc:	8b 40 04             	mov    0x4(%eax),%eax
  802eff:	85 c0                	test   %eax,%eax
  802f01:	74 0f                	je     802f12 <free_block+0x22d>
  802f03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f06:	8b 40 04             	mov    0x4(%eax),%eax
  802f09:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f0c:	8b 12                	mov    (%edx),%edx
  802f0e:	89 10                	mov    %edx,(%eax)
  802f10:	eb 0a                	jmp    802f1c <free_block+0x237>
  802f12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f15:	8b 00                	mov    (%eax),%eax
  802f17:	a3 48 50 98 00       	mov    %eax,0x985048
  802f1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f2f:	a1 54 50 98 00       	mov    0x985054,%eax
  802f34:	48                   	dec    %eax
  802f35:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  802f3a:	eb 24                	jmp    802f60 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  802f3c:	83 ec 04             	sub    $0x4,%esp
  802f3f:	6a 00                	push   $0x0
  802f41:	ff 75 f4             	pushl  -0xc(%ebp)
  802f44:	ff 75 08             	pushl  0x8(%ebp)
  802f47:	e8 e6 f4 ff ff       	call   802432 <set_block_data>
  802f4c:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802f4f:	83 ec 0c             	sub    $0xc,%esp
  802f52:	ff 75 08             	pushl  0x8(%ebp)
  802f55:	e8 2f f5 ff ff       	call   802489 <insert_sorted_in_freeList>
  802f5a:	83 c4 10             	add    $0x10,%esp
  802f5d:	eb 01                	jmp    802f60 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  802f5f:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  802f60:	c9                   	leave  
  802f61:	c3                   	ret    

00802f62 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802f62:	55                   	push   %ebp
  802f63:	89 e5                	mov    %esp,%ebp
  802f65:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  802f68:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f6c:	75 10                	jne    802f7e <realloc_block_FF+0x1c>
  802f6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f72:	75 0a                	jne    802f7e <realloc_block_FF+0x1c>
	{
		return NULL;
  802f74:	b8 00 00 00 00       	mov    $0x0,%eax
  802f79:	e9 8b 04 00 00       	jmp    803409 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  802f7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f82:	75 18                	jne    802f9c <realloc_block_FF+0x3a>
	{
		free_block(va);
  802f84:	83 ec 0c             	sub    $0xc,%esp
  802f87:	ff 75 08             	pushl  0x8(%ebp)
  802f8a:	e8 56 fd ff ff       	call   802ce5 <free_block>
  802f8f:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802f92:	b8 00 00 00 00       	mov    $0x0,%eax
  802f97:	e9 6d 04 00 00       	jmp    803409 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  802f9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fa0:	75 13                	jne    802fb5 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  802fa2:	83 ec 0c             	sub    $0xc,%esp
  802fa5:	ff 75 0c             	pushl  0xc(%ebp)
  802fa8:	e8 6f f6 ff ff       	call   80261c <alloc_block_FF>
  802fad:	83 c4 10             	add    $0x10,%esp
  802fb0:	e9 54 04 00 00       	jmp    803409 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  802fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb8:	83 e0 01             	and    $0x1,%eax
  802fbb:	85 c0                	test   %eax,%eax
  802fbd:	74 03                	je     802fc2 <realloc_block_FF+0x60>
	{
		new_size++;
  802fbf:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  802fc2:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802fc6:	77 07                	ja     802fcf <realloc_block_FF+0x6d>
	{
		new_size = 8;
  802fc8:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  802fcf:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  802fd3:	83 ec 0c             	sub    $0xc,%esp
  802fd6:	ff 75 08             	pushl  0x8(%ebp)
  802fd9:	e8 d8 f1 ff ff       	call   8021b6 <get_block_size>
  802fde:	83 c4 10             	add    $0x10,%esp
  802fe1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  802fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802fea:	75 08                	jne    802ff4 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  802fec:	8b 45 08             	mov    0x8(%ebp),%eax
  802fef:	e9 15 04 00 00       	jmp    803409 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  802ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffa:	01 d0                	add    %edx,%eax
  802ffc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802fff:	83 ec 0c             	sub    $0xc,%esp
  803002:	ff 75 f0             	pushl  -0x10(%ebp)
  803005:	e8 c5 f1 ff ff       	call   8021cf <is_free_block>
  80300a:	83 c4 10             	add    $0x10,%esp
  80300d:	0f be c0             	movsbl %al,%eax
  803010:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  803013:	83 ec 0c             	sub    $0xc,%esp
  803016:	ff 75 f0             	pushl  -0x10(%ebp)
  803019:	e8 98 f1 ff ff       	call   8021b6 <get_block_size>
  80301e:	83 c4 10             	add    $0x10,%esp
  803021:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  803024:	8b 45 0c             	mov    0xc(%ebp),%eax
  803027:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80302a:	0f 86 a7 02 00 00    	jbe    8032d7 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  803030:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803034:	0f 84 86 02 00 00    	je     8032c0 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  80303a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80303d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803040:	01 d0                	add    %edx,%eax
  803042:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803045:	0f 85 b2 00 00 00    	jne    8030fd <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  80304b:	83 ec 0c             	sub    $0xc,%esp
  80304e:	ff 75 08             	pushl  0x8(%ebp)
  803051:	e8 79 f1 ff ff       	call   8021cf <is_free_block>
  803056:	83 c4 10             	add    $0x10,%esp
  803059:	84 c0                	test   %al,%al
  80305b:	0f 94 c0             	sete   %al
  80305e:	0f b6 c0             	movzbl %al,%eax
  803061:	83 ec 04             	sub    $0x4,%esp
  803064:	50                   	push   %eax
  803065:	ff 75 0c             	pushl  0xc(%ebp)
  803068:	ff 75 08             	pushl  0x8(%ebp)
  80306b:	e8 c2 f3 ff ff       	call   802432 <set_block_data>
  803070:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  803073:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803077:	75 17                	jne    803090 <realloc_block_FF+0x12e>
  803079:	83 ec 04             	sub    $0x4,%esp
  80307c:	68 c0 3f 80 00       	push   $0x803fc0
  803081:	68 db 01 00 00       	push   $0x1db
  803086:	68 17 3f 80 00       	push   $0x803f17
  80308b:	e8 67 d3 ff ff       	call   8003f7 <_panic>
  803090:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803093:	8b 00                	mov    (%eax),%eax
  803095:	85 c0                	test   %eax,%eax
  803097:	74 10                	je     8030a9 <realloc_block_FF+0x147>
  803099:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309c:	8b 00                	mov    (%eax),%eax
  80309e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030a1:	8b 52 04             	mov    0x4(%edx),%edx
  8030a4:	89 50 04             	mov    %edx,0x4(%eax)
  8030a7:	eb 0b                	jmp    8030b4 <realloc_block_FF+0x152>
  8030a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ac:	8b 40 04             	mov    0x4(%eax),%eax
  8030af:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8030b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b7:	8b 40 04             	mov    0x4(%eax),%eax
  8030ba:	85 c0                	test   %eax,%eax
  8030bc:	74 0f                	je     8030cd <realloc_block_FF+0x16b>
  8030be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c1:	8b 40 04             	mov    0x4(%eax),%eax
  8030c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030c7:	8b 12                	mov    (%edx),%edx
  8030c9:	89 10                	mov    %edx,(%eax)
  8030cb:	eb 0a                	jmp    8030d7 <realloc_block_FF+0x175>
  8030cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d0:	8b 00                	mov    (%eax),%eax
  8030d2:	a3 48 50 98 00       	mov    %eax,0x985048
  8030d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ea:	a1 54 50 98 00       	mov    0x985054,%eax
  8030ef:	48                   	dec    %eax
  8030f0:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  8030f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f8:	e9 0c 03 00 00       	jmp    803409 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  8030fd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803100:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803103:	01 d0                	add    %edx,%eax
  803105:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803108:	0f 86 b2 01 00 00    	jbe    8032c0 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  80310e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803111:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803114:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  803117:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80311d:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  803120:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  803124:	0f 87 b8 00 00 00    	ja     8031e2 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  80312a:	83 ec 0c             	sub    $0xc,%esp
  80312d:	ff 75 08             	pushl  0x8(%ebp)
  803130:	e8 9a f0 ff ff       	call   8021cf <is_free_block>
  803135:	83 c4 10             	add    $0x10,%esp
  803138:	84 c0                	test   %al,%al
  80313a:	0f 94 c0             	sete   %al
  80313d:	0f b6 c0             	movzbl %al,%eax
  803140:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803143:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803146:	01 ca                	add    %ecx,%edx
  803148:	83 ec 04             	sub    $0x4,%esp
  80314b:	50                   	push   %eax
  80314c:	52                   	push   %edx
  80314d:	ff 75 08             	pushl  0x8(%ebp)
  803150:	e8 dd f2 ff ff       	call   802432 <set_block_data>
  803155:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803158:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80315c:	75 17                	jne    803175 <realloc_block_FF+0x213>
  80315e:	83 ec 04             	sub    $0x4,%esp
  803161:	68 c0 3f 80 00       	push   $0x803fc0
  803166:	68 e8 01 00 00       	push   $0x1e8
  80316b:	68 17 3f 80 00       	push   $0x803f17
  803170:	e8 82 d2 ff ff       	call   8003f7 <_panic>
  803175:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803178:	8b 00                	mov    (%eax),%eax
  80317a:	85 c0                	test   %eax,%eax
  80317c:	74 10                	je     80318e <realloc_block_FF+0x22c>
  80317e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803181:	8b 00                	mov    (%eax),%eax
  803183:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803186:	8b 52 04             	mov    0x4(%edx),%edx
  803189:	89 50 04             	mov    %edx,0x4(%eax)
  80318c:	eb 0b                	jmp    803199 <realloc_block_FF+0x237>
  80318e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803191:	8b 40 04             	mov    0x4(%eax),%eax
  803194:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319c:	8b 40 04             	mov    0x4(%eax),%eax
  80319f:	85 c0                	test   %eax,%eax
  8031a1:	74 0f                	je     8031b2 <realloc_block_FF+0x250>
  8031a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a6:	8b 40 04             	mov    0x4(%eax),%eax
  8031a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031ac:	8b 12                	mov    (%edx),%edx
  8031ae:	89 10                	mov    %edx,(%eax)
  8031b0:	eb 0a                	jmp    8031bc <realloc_block_FF+0x25a>
  8031b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b5:	8b 00                	mov    (%eax),%eax
  8031b7:	a3 48 50 98 00       	mov    %eax,0x985048
  8031bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031cf:	a1 54 50 98 00       	mov    0x985054,%eax
  8031d4:	48                   	dec    %eax
  8031d5:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  8031da:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dd:	e9 27 02 00 00       	jmp    803409 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8031e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031e6:	75 17                	jne    8031ff <realloc_block_FF+0x29d>
  8031e8:	83 ec 04             	sub    $0x4,%esp
  8031eb:	68 c0 3f 80 00       	push   $0x803fc0
  8031f0:	68 ed 01 00 00       	push   $0x1ed
  8031f5:	68 17 3f 80 00       	push   $0x803f17
  8031fa:	e8 f8 d1 ff ff       	call   8003f7 <_panic>
  8031ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803202:	8b 00                	mov    (%eax),%eax
  803204:	85 c0                	test   %eax,%eax
  803206:	74 10                	je     803218 <realloc_block_FF+0x2b6>
  803208:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320b:	8b 00                	mov    (%eax),%eax
  80320d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803210:	8b 52 04             	mov    0x4(%edx),%edx
  803213:	89 50 04             	mov    %edx,0x4(%eax)
  803216:	eb 0b                	jmp    803223 <realloc_block_FF+0x2c1>
  803218:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321b:	8b 40 04             	mov    0x4(%eax),%eax
  80321e:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803223:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803226:	8b 40 04             	mov    0x4(%eax),%eax
  803229:	85 c0                	test   %eax,%eax
  80322b:	74 0f                	je     80323c <realloc_block_FF+0x2da>
  80322d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803230:	8b 40 04             	mov    0x4(%eax),%eax
  803233:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803236:	8b 12                	mov    (%edx),%edx
  803238:	89 10                	mov    %edx,(%eax)
  80323a:	eb 0a                	jmp    803246 <realloc_block_FF+0x2e4>
  80323c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323f:	8b 00                	mov    (%eax),%eax
  803241:	a3 48 50 98 00       	mov    %eax,0x985048
  803246:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803249:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80324f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803252:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803259:	a1 54 50 98 00       	mov    0x985054,%eax
  80325e:	48                   	dec    %eax
  80325f:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  803264:	8b 55 08             	mov    0x8(%ebp),%edx
  803267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80326a:	01 d0                	add    %edx,%eax
  80326c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  80326f:	83 ec 04             	sub    $0x4,%esp
  803272:	6a 00                	push   $0x0
  803274:	ff 75 e0             	pushl  -0x20(%ebp)
  803277:	ff 75 f0             	pushl  -0x10(%ebp)
  80327a:	e8 b3 f1 ff ff       	call   802432 <set_block_data>
  80327f:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  803282:	83 ec 0c             	sub    $0xc,%esp
  803285:	ff 75 08             	pushl  0x8(%ebp)
  803288:	e8 42 ef ff ff       	call   8021cf <is_free_block>
  80328d:	83 c4 10             	add    $0x10,%esp
  803290:	84 c0                	test   %al,%al
  803292:	0f 94 c0             	sete   %al
  803295:	0f b6 c0             	movzbl %al,%eax
  803298:	83 ec 04             	sub    $0x4,%esp
  80329b:	50                   	push   %eax
  80329c:	ff 75 0c             	pushl  0xc(%ebp)
  80329f:	ff 75 08             	pushl  0x8(%ebp)
  8032a2:	e8 8b f1 ff ff       	call   802432 <set_block_data>
  8032a7:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  8032aa:	83 ec 0c             	sub    $0xc,%esp
  8032ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8032b0:	e8 d4 f1 ff ff       	call   802489 <insert_sorted_in_freeList>
  8032b5:	83 c4 10             	add    $0x10,%esp
					return va;
  8032b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bb:	e9 49 01 00 00       	jmp    803409 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  8032c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c3:	83 e8 08             	sub    $0x8,%eax
  8032c6:	83 ec 0c             	sub    $0xc,%esp
  8032c9:	50                   	push   %eax
  8032ca:	e8 4d f3 ff ff       	call   80261c <alloc_block_FF>
  8032cf:	83 c4 10             	add    $0x10,%esp
  8032d2:	e9 32 01 00 00       	jmp    803409 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  8032d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032da:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8032dd:	0f 83 21 01 00 00    	jae    803404 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  8032e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e6:	2b 45 0c             	sub    0xc(%ebp),%eax
  8032e9:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  8032ec:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  8032f0:	77 0e                	ja     803300 <realloc_block_FF+0x39e>
  8032f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032f6:	75 08                	jne    803300 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  8032f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fb:	e9 09 01 00 00       	jmp    803409 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  803300:	8b 45 08             	mov    0x8(%ebp),%eax
  803303:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  803306:	83 ec 0c             	sub    $0xc,%esp
  803309:	ff 75 08             	pushl  0x8(%ebp)
  80330c:	e8 be ee ff ff       	call   8021cf <is_free_block>
  803311:	83 c4 10             	add    $0x10,%esp
  803314:	84 c0                	test   %al,%al
  803316:	0f 94 c0             	sete   %al
  803319:	0f b6 c0             	movzbl %al,%eax
  80331c:	83 ec 04             	sub    $0x4,%esp
  80331f:	50                   	push   %eax
  803320:	ff 75 0c             	pushl  0xc(%ebp)
  803323:	ff 75 d8             	pushl  -0x28(%ebp)
  803326:	e8 07 f1 ff ff       	call   802432 <set_block_data>
  80332b:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  80332e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803331:	8b 45 0c             	mov    0xc(%ebp),%eax
  803334:	01 d0                	add    %edx,%eax
  803336:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  803339:	83 ec 04             	sub    $0x4,%esp
  80333c:	6a 00                	push   $0x0
  80333e:	ff 75 dc             	pushl  -0x24(%ebp)
  803341:	ff 75 d4             	pushl  -0x2c(%ebp)
  803344:	e8 e9 f0 ff ff       	call   802432 <set_block_data>
  803349:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  80334c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803350:	0f 84 9b 00 00 00    	je     8033f1 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  803356:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803359:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335c:	01 d0                	add    %edx,%eax
  80335e:	83 ec 04             	sub    $0x4,%esp
  803361:	6a 00                	push   $0x0
  803363:	50                   	push   %eax
  803364:	ff 75 d4             	pushl  -0x2c(%ebp)
  803367:	e8 c6 f0 ff ff       	call   802432 <set_block_data>
  80336c:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  80336f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803373:	75 17                	jne    80338c <realloc_block_FF+0x42a>
  803375:	83 ec 04             	sub    $0x4,%esp
  803378:	68 c0 3f 80 00       	push   $0x803fc0
  80337d:	68 10 02 00 00       	push   $0x210
  803382:	68 17 3f 80 00       	push   $0x803f17
  803387:	e8 6b d0 ff ff       	call   8003f7 <_panic>
  80338c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80338f:	8b 00                	mov    (%eax),%eax
  803391:	85 c0                	test   %eax,%eax
  803393:	74 10                	je     8033a5 <realloc_block_FF+0x443>
  803395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803398:	8b 00                	mov    (%eax),%eax
  80339a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80339d:	8b 52 04             	mov    0x4(%edx),%edx
  8033a0:	89 50 04             	mov    %edx,0x4(%eax)
  8033a3:	eb 0b                	jmp    8033b0 <realloc_block_FF+0x44e>
  8033a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a8:	8b 40 04             	mov    0x4(%eax),%eax
  8033ab:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8033b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b3:	8b 40 04             	mov    0x4(%eax),%eax
  8033b6:	85 c0                	test   %eax,%eax
  8033b8:	74 0f                	je     8033c9 <realloc_block_FF+0x467>
  8033ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bd:	8b 40 04             	mov    0x4(%eax),%eax
  8033c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033c3:	8b 12                	mov    (%edx),%edx
  8033c5:	89 10                	mov    %edx,(%eax)
  8033c7:	eb 0a                	jmp    8033d3 <realloc_block_FF+0x471>
  8033c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033cc:	8b 00                	mov    (%eax),%eax
  8033ce:	a3 48 50 98 00       	mov    %eax,0x985048
  8033d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e6:	a1 54 50 98 00       	mov    0x985054,%eax
  8033eb:	48                   	dec    %eax
  8033ec:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  8033f1:	83 ec 0c             	sub    $0xc,%esp
  8033f4:	ff 75 d4             	pushl  -0x2c(%ebp)
  8033f7:	e8 8d f0 ff ff       	call   802489 <insert_sorted_in_freeList>
  8033fc:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  8033ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803402:	eb 05                	jmp    803409 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  803404:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803409:	c9                   	leave  
  80340a:	c3                   	ret    

0080340b <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80340b:	55                   	push   %ebp
  80340c:	89 e5                	mov    %esp,%ebp
  80340e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803411:	83 ec 04             	sub    $0x4,%esp
  803414:	68 e0 3f 80 00       	push   $0x803fe0
  803419:	68 20 02 00 00       	push   $0x220
  80341e:	68 17 3f 80 00       	push   $0x803f17
  803423:	e8 cf cf ff ff       	call   8003f7 <_panic>

00803428 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803428:	55                   	push   %ebp
  803429:	89 e5                	mov    %esp,%ebp
  80342b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80342e:	83 ec 04             	sub    $0x4,%esp
  803431:	68 08 40 80 00       	push   $0x804008
  803436:	68 28 02 00 00       	push   $0x228
  80343b:	68 17 3f 80 00       	push   $0x803f17
  803440:	e8 b2 cf ff ff       	call   8003f7 <_panic>
  803445:	66 90                	xchg   %ax,%ax
  803447:	90                   	nop

00803448 <__udivdi3>:
  803448:	55                   	push   %ebp
  803449:	57                   	push   %edi
  80344a:	56                   	push   %esi
  80344b:	53                   	push   %ebx
  80344c:	83 ec 1c             	sub    $0x1c,%esp
  80344f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803453:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803457:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80345b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80345f:	89 ca                	mov    %ecx,%edx
  803461:	89 f8                	mov    %edi,%eax
  803463:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803467:	85 f6                	test   %esi,%esi
  803469:	75 2d                	jne    803498 <__udivdi3+0x50>
  80346b:	39 cf                	cmp    %ecx,%edi
  80346d:	77 65                	ja     8034d4 <__udivdi3+0x8c>
  80346f:	89 fd                	mov    %edi,%ebp
  803471:	85 ff                	test   %edi,%edi
  803473:	75 0b                	jne    803480 <__udivdi3+0x38>
  803475:	b8 01 00 00 00       	mov    $0x1,%eax
  80347a:	31 d2                	xor    %edx,%edx
  80347c:	f7 f7                	div    %edi
  80347e:	89 c5                	mov    %eax,%ebp
  803480:	31 d2                	xor    %edx,%edx
  803482:	89 c8                	mov    %ecx,%eax
  803484:	f7 f5                	div    %ebp
  803486:	89 c1                	mov    %eax,%ecx
  803488:	89 d8                	mov    %ebx,%eax
  80348a:	f7 f5                	div    %ebp
  80348c:	89 cf                	mov    %ecx,%edi
  80348e:	89 fa                	mov    %edi,%edx
  803490:	83 c4 1c             	add    $0x1c,%esp
  803493:	5b                   	pop    %ebx
  803494:	5e                   	pop    %esi
  803495:	5f                   	pop    %edi
  803496:	5d                   	pop    %ebp
  803497:	c3                   	ret    
  803498:	39 ce                	cmp    %ecx,%esi
  80349a:	77 28                	ja     8034c4 <__udivdi3+0x7c>
  80349c:	0f bd fe             	bsr    %esi,%edi
  80349f:	83 f7 1f             	xor    $0x1f,%edi
  8034a2:	75 40                	jne    8034e4 <__udivdi3+0x9c>
  8034a4:	39 ce                	cmp    %ecx,%esi
  8034a6:	72 0a                	jb     8034b2 <__udivdi3+0x6a>
  8034a8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034ac:	0f 87 9e 00 00 00    	ja     803550 <__udivdi3+0x108>
  8034b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8034b7:	89 fa                	mov    %edi,%edx
  8034b9:	83 c4 1c             	add    $0x1c,%esp
  8034bc:	5b                   	pop    %ebx
  8034bd:	5e                   	pop    %esi
  8034be:	5f                   	pop    %edi
  8034bf:	5d                   	pop    %ebp
  8034c0:	c3                   	ret    
  8034c1:	8d 76 00             	lea    0x0(%esi),%esi
  8034c4:	31 ff                	xor    %edi,%edi
  8034c6:	31 c0                	xor    %eax,%eax
  8034c8:	89 fa                	mov    %edi,%edx
  8034ca:	83 c4 1c             	add    $0x1c,%esp
  8034cd:	5b                   	pop    %ebx
  8034ce:	5e                   	pop    %esi
  8034cf:	5f                   	pop    %edi
  8034d0:	5d                   	pop    %ebp
  8034d1:	c3                   	ret    
  8034d2:	66 90                	xchg   %ax,%ax
  8034d4:	89 d8                	mov    %ebx,%eax
  8034d6:	f7 f7                	div    %edi
  8034d8:	31 ff                	xor    %edi,%edi
  8034da:	89 fa                	mov    %edi,%edx
  8034dc:	83 c4 1c             	add    $0x1c,%esp
  8034df:	5b                   	pop    %ebx
  8034e0:	5e                   	pop    %esi
  8034e1:	5f                   	pop    %edi
  8034e2:	5d                   	pop    %ebp
  8034e3:	c3                   	ret    
  8034e4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034e9:	89 eb                	mov    %ebp,%ebx
  8034eb:	29 fb                	sub    %edi,%ebx
  8034ed:	89 f9                	mov    %edi,%ecx
  8034ef:	d3 e6                	shl    %cl,%esi
  8034f1:	89 c5                	mov    %eax,%ebp
  8034f3:	88 d9                	mov    %bl,%cl
  8034f5:	d3 ed                	shr    %cl,%ebp
  8034f7:	89 e9                	mov    %ebp,%ecx
  8034f9:	09 f1                	or     %esi,%ecx
  8034fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034ff:	89 f9                	mov    %edi,%ecx
  803501:	d3 e0                	shl    %cl,%eax
  803503:	89 c5                	mov    %eax,%ebp
  803505:	89 d6                	mov    %edx,%esi
  803507:	88 d9                	mov    %bl,%cl
  803509:	d3 ee                	shr    %cl,%esi
  80350b:	89 f9                	mov    %edi,%ecx
  80350d:	d3 e2                	shl    %cl,%edx
  80350f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803513:	88 d9                	mov    %bl,%cl
  803515:	d3 e8                	shr    %cl,%eax
  803517:	09 c2                	or     %eax,%edx
  803519:	89 d0                	mov    %edx,%eax
  80351b:	89 f2                	mov    %esi,%edx
  80351d:	f7 74 24 0c          	divl   0xc(%esp)
  803521:	89 d6                	mov    %edx,%esi
  803523:	89 c3                	mov    %eax,%ebx
  803525:	f7 e5                	mul    %ebp
  803527:	39 d6                	cmp    %edx,%esi
  803529:	72 19                	jb     803544 <__udivdi3+0xfc>
  80352b:	74 0b                	je     803538 <__udivdi3+0xf0>
  80352d:	89 d8                	mov    %ebx,%eax
  80352f:	31 ff                	xor    %edi,%edi
  803531:	e9 58 ff ff ff       	jmp    80348e <__udivdi3+0x46>
  803536:	66 90                	xchg   %ax,%ax
  803538:	8b 54 24 08          	mov    0x8(%esp),%edx
  80353c:	89 f9                	mov    %edi,%ecx
  80353e:	d3 e2                	shl    %cl,%edx
  803540:	39 c2                	cmp    %eax,%edx
  803542:	73 e9                	jae    80352d <__udivdi3+0xe5>
  803544:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803547:	31 ff                	xor    %edi,%edi
  803549:	e9 40 ff ff ff       	jmp    80348e <__udivdi3+0x46>
  80354e:	66 90                	xchg   %ax,%ax
  803550:	31 c0                	xor    %eax,%eax
  803552:	e9 37 ff ff ff       	jmp    80348e <__udivdi3+0x46>
  803557:	90                   	nop

00803558 <__umoddi3>:
  803558:	55                   	push   %ebp
  803559:	57                   	push   %edi
  80355a:	56                   	push   %esi
  80355b:	53                   	push   %ebx
  80355c:	83 ec 1c             	sub    $0x1c,%esp
  80355f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803563:	8b 74 24 34          	mov    0x34(%esp),%esi
  803567:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80356b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80356f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803573:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803577:	89 f3                	mov    %esi,%ebx
  803579:	89 fa                	mov    %edi,%edx
  80357b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80357f:	89 34 24             	mov    %esi,(%esp)
  803582:	85 c0                	test   %eax,%eax
  803584:	75 1a                	jne    8035a0 <__umoddi3+0x48>
  803586:	39 f7                	cmp    %esi,%edi
  803588:	0f 86 a2 00 00 00    	jbe    803630 <__umoddi3+0xd8>
  80358e:	89 c8                	mov    %ecx,%eax
  803590:	89 f2                	mov    %esi,%edx
  803592:	f7 f7                	div    %edi
  803594:	89 d0                	mov    %edx,%eax
  803596:	31 d2                	xor    %edx,%edx
  803598:	83 c4 1c             	add    $0x1c,%esp
  80359b:	5b                   	pop    %ebx
  80359c:	5e                   	pop    %esi
  80359d:	5f                   	pop    %edi
  80359e:	5d                   	pop    %ebp
  80359f:	c3                   	ret    
  8035a0:	39 f0                	cmp    %esi,%eax
  8035a2:	0f 87 ac 00 00 00    	ja     803654 <__umoddi3+0xfc>
  8035a8:	0f bd e8             	bsr    %eax,%ebp
  8035ab:	83 f5 1f             	xor    $0x1f,%ebp
  8035ae:	0f 84 ac 00 00 00    	je     803660 <__umoddi3+0x108>
  8035b4:	bf 20 00 00 00       	mov    $0x20,%edi
  8035b9:	29 ef                	sub    %ebp,%edi
  8035bb:	89 fe                	mov    %edi,%esi
  8035bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035c1:	89 e9                	mov    %ebp,%ecx
  8035c3:	d3 e0                	shl    %cl,%eax
  8035c5:	89 d7                	mov    %edx,%edi
  8035c7:	89 f1                	mov    %esi,%ecx
  8035c9:	d3 ef                	shr    %cl,%edi
  8035cb:	09 c7                	or     %eax,%edi
  8035cd:	89 e9                	mov    %ebp,%ecx
  8035cf:	d3 e2                	shl    %cl,%edx
  8035d1:	89 14 24             	mov    %edx,(%esp)
  8035d4:	89 d8                	mov    %ebx,%eax
  8035d6:	d3 e0                	shl    %cl,%eax
  8035d8:	89 c2                	mov    %eax,%edx
  8035da:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035de:	d3 e0                	shl    %cl,%eax
  8035e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035e4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035e8:	89 f1                	mov    %esi,%ecx
  8035ea:	d3 e8                	shr    %cl,%eax
  8035ec:	09 d0                	or     %edx,%eax
  8035ee:	d3 eb                	shr    %cl,%ebx
  8035f0:	89 da                	mov    %ebx,%edx
  8035f2:	f7 f7                	div    %edi
  8035f4:	89 d3                	mov    %edx,%ebx
  8035f6:	f7 24 24             	mull   (%esp)
  8035f9:	89 c6                	mov    %eax,%esi
  8035fb:	89 d1                	mov    %edx,%ecx
  8035fd:	39 d3                	cmp    %edx,%ebx
  8035ff:	0f 82 87 00 00 00    	jb     80368c <__umoddi3+0x134>
  803605:	0f 84 91 00 00 00    	je     80369c <__umoddi3+0x144>
  80360b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80360f:	29 f2                	sub    %esi,%edx
  803611:	19 cb                	sbb    %ecx,%ebx
  803613:	89 d8                	mov    %ebx,%eax
  803615:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803619:	d3 e0                	shl    %cl,%eax
  80361b:	89 e9                	mov    %ebp,%ecx
  80361d:	d3 ea                	shr    %cl,%edx
  80361f:	09 d0                	or     %edx,%eax
  803621:	89 e9                	mov    %ebp,%ecx
  803623:	d3 eb                	shr    %cl,%ebx
  803625:	89 da                	mov    %ebx,%edx
  803627:	83 c4 1c             	add    $0x1c,%esp
  80362a:	5b                   	pop    %ebx
  80362b:	5e                   	pop    %esi
  80362c:	5f                   	pop    %edi
  80362d:	5d                   	pop    %ebp
  80362e:	c3                   	ret    
  80362f:	90                   	nop
  803630:	89 fd                	mov    %edi,%ebp
  803632:	85 ff                	test   %edi,%edi
  803634:	75 0b                	jne    803641 <__umoddi3+0xe9>
  803636:	b8 01 00 00 00       	mov    $0x1,%eax
  80363b:	31 d2                	xor    %edx,%edx
  80363d:	f7 f7                	div    %edi
  80363f:	89 c5                	mov    %eax,%ebp
  803641:	89 f0                	mov    %esi,%eax
  803643:	31 d2                	xor    %edx,%edx
  803645:	f7 f5                	div    %ebp
  803647:	89 c8                	mov    %ecx,%eax
  803649:	f7 f5                	div    %ebp
  80364b:	89 d0                	mov    %edx,%eax
  80364d:	e9 44 ff ff ff       	jmp    803596 <__umoddi3+0x3e>
  803652:	66 90                	xchg   %ax,%ax
  803654:	89 c8                	mov    %ecx,%eax
  803656:	89 f2                	mov    %esi,%edx
  803658:	83 c4 1c             	add    $0x1c,%esp
  80365b:	5b                   	pop    %ebx
  80365c:	5e                   	pop    %esi
  80365d:	5f                   	pop    %edi
  80365e:	5d                   	pop    %ebp
  80365f:	c3                   	ret    
  803660:	3b 04 24             	cmp    (%esp),%eax
  803663:	72 06                	jb     80366b <__umoddi3+0x113>
  803665:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803669:	77 0f                	ja     80367a <__umoddi3+0x122>
  80366b:	89 f2                	mov    %esi,%edx
  80366d:	29 f9                	sub    %edi,%ecx
  80366f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803673:	89 14 24             	mov    %edx,(%esp)
  803676:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80367a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80367e:	8b 14 24             	mov    (%esp),%edx
  803681:	83 c4 1c             	add    $0x1c,%esp
  803684:	5b                   	pop    %ebx
  803685:	5e                   	pop    %esi
  803686:	5f                   	pop    %edi
  803687:	5d                   	pop    %ebp
  803688:	c3                   	ret    
  803689:	8d 76 00             	lea    0x0(%esi),%esi
  80368c:	2b 04 24             	sub    (%esp),%eax
  80368f:	19 fa                	sbb    %edi,%edx
  803691:	89 d1                	mov    %edx,%ecx
  803693:	89 c6                	mov    %eax,%esi
  803695:	e9 71 ff ff ff       	jmp    80360b <__umoddi3+0xb3>
  80369a:	66 90                	xchg   %ax,%ax
  80369c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036a0:	72 ea                	jb     80368c <__umoddi3+0x134>
  8036a2:	89 d9                	mov    %ebx,%ecx
  8036a4:	e9 62 ff ff ff       	jmp    80360b <__umoddi3+0xb3>
