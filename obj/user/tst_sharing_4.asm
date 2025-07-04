
obj/user/tst_sharing_4:     file format elf32-i386


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
  800031:	e8 89 06 00 00       	call   8006bf <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 64             	sub    $0x64,%esp

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
  80005c:	68 c0 3a 80 00       	push   $0x803ac0
  800061:	6a 13                	push   $0x13
  800063:	68 dc 3a 80 00       	push   $0x803adc
  800068:	e8 97 07 00 00       	call   800804 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	int eval = 0;
  80006d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  800074:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80007b:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	cprintf("************************************************\n");
  800082:	83 ec 0c             	sub    $0xc,%esp
  800085:	68 f4 3a 80 00       	push   $0x803af4
  80008a:	e8 32 0a 00 00       	call   800ac1 <cprintf>
  80008f:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800092:	83 ec 0c             	sub    $0xc,%esp
  800095:	68 28 3b 80 00       	push   $0x803b28
  80009a:	e8 22 0a 00 00       	call   800ac1 <cprintf>
  80009f:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 84 3b 80 00       	push   $0x803b84
  8000aa:	e8 12 0a 00 00       	call   800ac1 <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000b2:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  8000b9:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	int envID = sys_getenvid();
  8000c0:	e8 31 21 00 00       	call   8021f6 <sys_getenvid>
  8000c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cprintf("STEP A: checking free of a shared object ... [25%]\n");
  8000c8:	83 ec 0c             	sub    $0xc,%esp
  8000cb:	68 b8 3b 80 00       	push   $0x803bb8
  8000d0:	e8 ec 09 00 00       	call   800ac1 <cprintf>
  8000d5:	83 c4 10             	add    $0x10,%esp
	{
		freeFrames = sys_calculate_free_frames() ;
  8000d8:	e8 69 1f 00 00       	call   802046 <sys_calculate_free_frames>
  8000dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000e0:	83 ec 04             	sub    $0x4,%esp
  8000e3:	6a 01                	push   $0x1
  8000e5:	68 00 10 00 00       	push   $0x1000
  8000ea:	68 ec 3b 80 00       	push   $0x803bec
  8000ef:	e8 34 1a 00 00       	call   801b28 <smalloc>
  8000f4:	83 c4 10             	add    $0x10,%esp
  8000f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (x != (uint32*)pagealloc_start)
  8000fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000fd:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  800100:	74 17                	je     800119 <_main+0xe1>
		{is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800102:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	68 f0 3b 80 00       	push   $0x803bf0
  800111:	e8 ab 09 00 00       	call   800ac1 <cprintf>
  800116:	83 c4 10             	add    $0x10,%esp
		expected = 1+1 ; /*1page +1table*/
  800119:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)

		/*extra 1 page & 1 table for kernel sbrk (at max) due to sharedObject & frameStorage*/
		/*extra 1 page & 1 table for user sbrk (at max) if creating special DS to manage USER PAGE ALLOC */
		int upperLimit = expected +1+1 +1+1 ;
  800120:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800123:	83 c0 04             	add    $0x4,%eax
  800126:	89 45 d0             	mov    %eax,-0x30(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800129:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80012c:	e8 15 1f 00 00       	call   802046 <sys_calculate_free_frames>
  800131:	29 c3                	sub    %eax,%ebx
  800133:	89 d8                	mov    %ebx,%eax
  800135:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (diff < expected || diff > upperLimit)
  800138:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80013b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80013e:	7c 08                	jl     800148 <_main+0x110>
  800140:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800143:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800146:	7e 27                	jle    80016f <_main+0x137>
			{is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800148:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80014f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800152:	e8 ef 1e 00 00       	call   802046 <sys_calculate_free_frames>
  800157:	29 c3                	sub    %eax,%ebx
  800159:	89 d8                	mov    %ebx,%eax
  80015b:	83 ec 04             	sub    $0x4,%esp
  80015e:	ff 75 d4             	pushl  -0x2c(%ebp)
  800161:	50                   	push   %eax
  800162:	68 5c 3c 80 00       	push   $0x803c5c
  800167:	e8 55 09 00 00       	call   800ac1 <cprintf>
  80016c:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  80016f:	83 ec 0c             	sub    $0xc,%esp
  800172:	ff 75 d8             	pushl  -0x28(%ebp)
  800175:	e8 e0 1c 00 00       	call   801e5a <sfree>
  80017a:	83 c4 10             	add    $0x10,%esp

		int diff2 = (freeFrames - sys_calculate_free_frames());
  80017d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800180:	e8 c1 1e 00 00       	call   802046 <sys_calculate_free_frames>
  800185:	29 c3                	sub    %eax,%ebx
  800187:	89 d8                	mov    %ebx,%eax
  800189:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (diff2 !=  (diff - expected))
  80018c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80018f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800192:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800195:	74 27                	je     8001be <_main+0x186>
		{is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800197:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80019e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001a1:	e8 a0 1e 00 00       	call   802046 <sys_calculate_free_frames>
  8001a6:	29 c3                	sub    %eax,%ebx
  8001a8:	89 d8                	mov    %ebx,%eax
  8001aa:	83 ec 04             	sub    $0x4,%esp
  8001ad:	50                   	push   %eax
  8001ae:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001b1:	68 f4 3c 80 00       	push   $0x803cf4
  8001b6:	e8 06 09 00 00       	call   800ac1 <cprintf>
  8001bb:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("Step A completed!!\n\n\n");
  8001be:	83 ec 0c             	sub    $0xc,%esp
  8001c1:	68 3f 3d 80 00       	push   $0x803d3f
  8001c6:	e8 f6 08 00 00       	call   800ac1 <cprintf>
  8001cb:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  8001ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8001d2:	74 04                	je     8001d8 <_main+0x1a0>
  8001d4:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  8001d8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("STEP B: checking free of 2 shared objects ... [25%]\n");
  8001df:	83 ec 0c             	sub    $0xc,%esp
  8001e2:	68 58 3d 80 00       	push   $0x803d58
  8001e7:	e8 d5 08 00 00       	call   800ac1 <cprintf>
  8001ec:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		freeFrames = sys_calculate_free_frames() ;
  8001ef:	e8 52 1e 00 00       	call   802046 <sys_calculate_free_frames>
  8001f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001f7:	83 ec 04             	sub    $0x4,%esp
  8001fa:	6a 01                	push   $0x1
  8001fc:	68 00 10 00 00       	push   $0x1000
  800201:	68 8d 3d 80 00       	push   $0x803d8d
  800206:	e8 1d 19 00 00       	call   801b28 <smalloc>
  80020b:	83 c4 10             	add    $0x10,%esp
  80020e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800211:	83 ec 04             	sub    $0x4,%esp
  800214:	6a 01                	push   $0x1
  800216:	68 00 10 00 00       	push   $0x1000
  80021b:	68 ec 3b 80 00       	push   $0x803bec
  800220:	e8 03 19 00 00       	call   801b28 <smalloc>
  800225:	83 c4 10             	add    $0x10,%esp
  800228:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if(x == NULL)
  80022b:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  80022f:	75 17                	jne    800248 <_main+0x210>
		{is_correct = 0; cprintf("Wrong free: make sure that you free the shared object by calling free_share_object()");}
  800231:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800238:	83 ec 0c             	sub    $0xc,%esp
  80023b:	68 90 3d 80 00       	push   $0x803d90
  800240:	e8 7c 08 00 00       	call   800ac1 <cprintf>
  800245:	83 c4 10             	add    $0x10,%esp

		expected = 2+1 ; /*2pages +1table*/
  800248:	c7 45 d4 03 00 00 00 	movl   $0x3,-0x2c(%ebp)
		/*extra 1 page for kernel sbrk (at max) due to sharedObject & frameStorage of the 2nd object "x"*/
		/*if creating special DS to manage USER PAGE ALLOC, the prev. created page from STEP A is sufficient */
		int upperLimit = expected +1 ;
  80024f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800252:	40                   	inc    %eax
  800253:	89 45 bc             	mov    %eax,-0x44(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800256:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800259:	e8 e8 1d 00 00       	call   802046 <sys_calculate_free_frames>
  80025e:	29 c3                	sub    %eax,%ebx
  800260:	89 d8                	mov    %ebx,%eax
  800262:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (diff < expected || diff > upperLimit)
  800265:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800268:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80026b:	7c 08                	jl     800275 <_main+0x23d>
  80026d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800270:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  800273:	7e 17                	jle    80028c <_main+0x254>
			{is_correct = 0; cprintf("Wrong previous free: make sure that you correctly free shared object before (Step A)");}
  800275:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	68 e8 3d 80 00       	push   $0x803de8
  800284:	e8 38 08 00 00       	call   800ac1 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp

		sfree(z);
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	ff 75 c4             	pushl  -0x3c(%ebp)
  800292:	e8 c3 1b 00 00       	call   801e5a <sfree>
  800297:	83 c4 10             	add    $0x10,%esp

		int diff2 = (freeFrames - sys_calculate_free_frames());
  80029a:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80029d:	e8 a4 1d 00 00       	call   802046 <sys_calculate_free_frames>
  8002a2:	29 c3                	sub    %eax,%ebx
  8002a4:	89 d8                	mov    %ebx,%eax
  8002a6:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if (diff2 != (diff - 1 /*1 page*/))
  8002a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002ac:	48                   	dec    %eax
  8002ad:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8002b0:	74 27                	je     8002d9 <_main+0x2a1>
		{is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8002b2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002b9:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002bc:	e8 85 1d 00 00       	call   802046 <sys_calculate_free_frames>
  8002c1:	29 c3                	sub    %eax,%ebx
  8002c3:	89 d8                	mov    %ebx,%eax
  8002c5:	83 ec 04             	sub    $0x4,%esp
  8002c8:	50                   	push   %eax
  8002c9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002cc:	68 f4 3c 80 00       	push   $0x803cf4
  8002d1:	e8 eb 07 00 00       	call   800ac1 <cprintf>
  8002d6:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8002d9:	83 ec 0c             	sub    $0xc,%esp
  8002dc:	ff 75 c0             	pushl  -0x40(%ebp)
  8002df:	e8 76 1b 00 00       	call   801e5a <sfree>
  8002e4:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  8002e7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		int diff3 = (freeFrames - sys_calculate_free_frames());
  8002ee:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002f1:	e8 50 1d 00 00       	call   802046 <sys_calculate_free_frames>
  8002f6:	29 c3                	sub    %eax,%ebx
  8002f8:	89 d8                	mov    %ebx,%eax
  8002fa:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if (diff3 != (diff2 - (1+1) /*1 page + 1 table*/))
  8002fd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800300:	83 e8 02             	sub    $0x2,%eax
  800303:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  800306:	74 27                	je     80032f <_main+0x2f7>
		{is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800308:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80030f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800312:	e8 2f 1d 00 00       	call   802046 <sys_calculate_free_frames>
  800317:	29 c3                	sub    %eax,%ebx
  800319:	89 d8                	mov    %ebx,%eax
  80031b:	83 ec 04             	sub    $0x4,%esp
  80031e:	50                   	push   %eax
  80031f:	ff 75 d4             	pushl  -0x2c(%ebp)
  800322:	68 f4 3c 80 00       	push   $0x803cf4
  800327:	e8 95 07 00 00       	call   800ac1 <cprintf>
  80032c:	83 c4 10             	add    $0x10,%esp

	}
	cprintf("Step B completed!!\n\n\n");
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	68 3d 3e 80 00       	push   $0x803e3d
  800337:	e8 85 07 00 00       	call   800ac1 <cprintf>
  80033c:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  80033f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800343:	74 04                	je     800349 <_main+0x311>
  800345:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  800349:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("STEP C: checking range of loop during free... [50%]\n");
  800350:	83 ec 0c             	sub    $0xc,%esp
  800353:	68 54 3e 80 00       	push   $0x803e54
  800358:	e8 64 07 00 00       	call   800ac1 <cprintf>
  80035d:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  800360:	e8 e1 1c 00 00       	call   802046 <sys_calculate_free_frames>
  800365:	89 45 b0             	mov    %eax,-0x50(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  800368:	83 ec 04             	sub    $0x4,%esp
  80036b:	6a 01                	push   $0x1
  80036d:	68 01 30 00 00       	push   $0x3001
  800372:	68 89 3e 80 00       	push   $0x803e89
  800377:	e8 ac 17 00 00       	call   801b28 <smalloc>
  80037c:	83 c4 10             	add    $0x10,%esp
  80037f:	89 45 ac             	mov    %eax,-0x54(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  800382:	83 ec 04             	sub    $0x4,%esp
  800385:	6a 01                	push   $0x1
  800387:	68 00 10 00 00       	push   $0x1000
  80038c:	68 8b 3e 80 00       	push   $0x803e8b
  800391:	e8 92 17 00 00       	call   801b28 <smalloc>
  800396:	83 c4 10             	add    $0x10,%esp
  800399:	89 45 a8             	mov    %eax,-0x58(%ebp)
		expected = 5+1 ; /*5pages +1table*/
  80039c:	c7 45 d4 06 00 00 00 	movl   $0x6,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8003a3:	8b 5d b0             	mov    -0x50(%ebp),%ebx
  8003a6:	e8 9b 1c 00 00       	call   802046 <sys_calculate_free_frames>
  8003ab:	29 c3                	sub    %eax,%ebx
  8003ad:	89 d8                	mov    %ebx,%eax
  8003af:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (diff != expected)
  8003b2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003b5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8003b8:	74 27                	je     8003e1 <_main+0x3a9>
			{is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8003ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003c1:	8b 5d b0             	mov    -0x50(%ebp),%ebx
  8003c4:	e8 7d 1c 00 00       	call   802046 <sys_calculate_free_frames>
  8003c9:	29 c3                	sub    %eax,%ebx
  8003cb:	89 d8                	mov    %ebx,%eax
  8003cd:	83 ec 04             	sub    $0x4,%esp
  8003d0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003d3:	50                   	push   %eax
  8003d4:	68 5c 3c 80 00       	push   $0x803c5c
  8003d9:	e8 e3 06 00 00       	call   800ac1 <cprintf>
  8003de:	83 c4 10             	add    $0x10,%esp

		sfree(w);
  8003e1:	83 ec 0c             	sub    $0xc,%esp
  8003e4:	ff 75 ac             	pushl  -0x54(%ebp)
  8003e7:	e8 6e 1a 00 00       	call   801e5a <sfree>
  8003ec:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  8003ef:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8003f6:	8b 5d b0             	mov    -0x50(%ebp),%ebx
  8003f9:	e8 48 1c 00 00       	call   802046 <sys_calculate_free_frames>
  8003fe:	29 c3                	sub    %eax,%ebx
  800400:	89 d8                	mov    %ebx,%eax
  800402:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800405:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800408:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80040b:	74 27                	je     800434 <_main+0x3fc>
  80040d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800414:	8b 5d b0             	mov    -0x50(%ebp),%ebx
  800417:	e8 2a 1c 00 00       	call   802046 <sys_calculate_free_frames>
  80041c:	29 c3                	sub    %eax,%ebx
  80041e:	89 d8                	mov    %ebx,%eax
  800420:	83 ec 04             	sub    $0x4,%esp
  800423:	50                   	push   %eax
  800424:	ff 75 d4             	pushl  -0x2c(%ebp)
  800427:	68 f4 3c 80 00       	push   $0x803cf4
  80042c:	e8 90 06 00 00       	call   800ac1 <cprintf>
  800431:	83 c4 10             	add    $0x10,%esp

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  800434:	83 ec 04             	sub    $0x4,%esp
  800437:	6a 01                	push   $0x1
  800439:	68 ff 1f 00 00       	push   $0x1fff
  80043e:	68 8d 3e 80 00       	push   $0x803e8d
  800443:	e8 e0 16 00 00       	call   801b28 <smalloc>
  800448:	83 c4 10             	add    $0x10,%esp
  80044b:	89 45 a4             	mov    %eax,-0x5c(%ebp)

		expected = 3+1 ; /*3pages +1table*/
  80044e:	c7 45 d4 04 00 00 00 	movl   $0x4,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800455:	8b 5d b0             	mov    -0x50(%ebp),%ebx
  800458:	e8 e9 1b 00 00       	call   802046 <sys_calculate_free_frames>
  80045d:	29 c3                	sub    %eax,%ebx
  80045f:	89 d8                	mov    %ebx,%eax
  800461:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (diff != expected /*Exact! since it's not expected that to invloke sbrk due to the prev. sfree*/)
  800464:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800467:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80046a:	74 27                	je     800493 <_main+0x45b>
			{is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  80046c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800473:	8b 5d b0             	mov    -0x50(%ebp),%ebx
  800476:	e8 cb 1b 00 00       	call   802046 <sys_calculate_free_frames>
  80047b:	29 c3                	sub    %eax,%ebx
  80047d:	89 d8                	mov    %ebx,%eax
  80047f:	83 ec 04             	sub    $0x4,%esp
  800482:	ff 75 d4             	pushl  -0x2c(%ebp)
  800485:	50                   	push   %eax
  800486:	68 5c 3c 80 00       	push   $0x803c5c
  80048b:	e8 31 06 00 00       	call   800ac1 <cprintf>
  800490:	83 c4 10             	add    $0x10,%esp

		sfree(o);
  800493:	83 ec 0c             	sub    $0xc,%esp
  800496:	ff 75 a4             	pushl  -0x5c(%ebp)
  800499:	e8 bc 19 00 00       	call   801e5a <sfree>
  80049e:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  8004a1:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8004a8:	8b 5d b0             	mov    -0x50(%ebp),%ebx
  8004ab:	e8 96 1b 00 00       	call   802046 <sys_calculate_free_frames>
  8004b0:	29 c3                	sub    %eax,%ebx
  8004b2:	89 d8                	mov    %ebx,%eax
  8004b4:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8004b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004ba:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8004bd:	74 27                	je     8004e6 <_main+0x4ae>
  8004bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004c6:	8b 5d b0             	mov    -0x50(%ebp),%ebx
  8004c9:	e8 78 1b 00 00       	call   802046 <sys_calculate_free_frames>
  8004ce:	29 c3                	sub    %eax,%ebx
  8004d0:	89 d8                	mov    %ebx,%eax
  8004d2:	83 ec 04             	sub    $0x4,%esp
  8004d5:	50                   	push   %eax
  8004d6:	ff 75 d4             	pushl  -0x2c(%ebp)
  8004d9:	68 f4 3c 80 00       	push   $0x803cf4
  8004de:	e8 de 05 00 00       	call   800ac1 <cprintf>
  8004e3:	83 c4 10             	add    $0x10,%esp

		sfree(u);
  8004e6:	83 ec 0c             	sub    $0xc,%esp
  8004e9:	ff 75 a8             	pushl  -0x58(%ebp)
  8004ec:	e8 69 19 00 00       	call   801e5a <sfree>
  8004f1:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  8004f4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8004fb:	8b 5d b0             	mov    -0x50(%ebp),%ebx
  8004fe:	e8 43 1b 00 00       	call   802046 <sys_calculate_free_frames>
  800503:	29 c3                	sub    %eax,%ebx
  800505:	89 d8                	mov    %ebx,%eax
  800507:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  80050a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80050d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800510:	74 27                	je     800539 <_main+0x501>
  800512:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800519:	8b 5d b0             	mov    -0x50(%ebp),%ebx
  80051c:	e8 25 1b 00 00       	call   802046 <sys_calculate_free_frames>
  800521:	29 c3                	sub    %eax,%ebx
  800523:	89 d8                	mov    %ebx,%eax
  800525:	83 ec 04             	sub    $0x4,%esp
  800528:	50                   	push   %eax
  800529:	ff 75 d4             	pushl  -0x2c(%ebp)
  80052c:	68 f4 3c 80 00       	push   $0x803cf4
  800531:	e8 8b 05 00 00       	call   800ac1 <cprintf>
  800536:	83 c4 10             	add    $0x10,%esp

		if (is_correct)	eval+=25;
  800539:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80053d:	74 04                	je     800543 <_main+0x50b>
  80053f:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
		is_correct = 1;
  800543:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  80054a:	e8 f7 1a 00 00       	call   802046 <sys_calculate_free_frames>
  80054f:	89 45 b0             	mov    %eax,-0x50(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  800552:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800555:	89 c2                	mov    %eax,%edx
  800557:	01 d2                	add    %edx,%edx
  800559:	01 d0                	add    %edx,%eax
  80055b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80055e:	83 ec 04             	sub    $0x4,%esp
  800561:	6a 01                	push   $0x1
  800563:	50                   	push   %eax
  800564:	68 89 3e 80 00       	push   $0x803e89
  800569:	e8 ba 15 00 00       	call   801b28 <smalloc>
  80056e:	83 c4 10             	add    $0x10,%esp
  800571:	89 45 ac             	mov    %eax,-0x54(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  800574:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800577:	89 d0                	mov    %edx,%eax
  800579:	01 c0                	add    %eax,%eax
  80057b:	01 d0                	add    %edx,%eax
  80057d:	01 c0                	add    %eax,%eax
  80057f:	01 d0                	add    %edx,%eax
  800581:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800584:	83 ec 04             	sub    $0x4,%esp
  800587:	6a 01                	push   $0x1
  800589:	50                   	push   %eax
  80058a:	68 8b 3e 80 00       	push   $0x803e8b
  80058f:	e8 94 15 00 00       	call   801b28 <smalloc>
  800594:	83 c4 10             	add    $0x10,%esp
  800597:	89 45 a8             	mov    %eax,-0x58(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  80059a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80059d:	01 c0                	add    %eax,%eax
  80059f:	89 c2                	mov    %eax,%edx
  8005a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005a4:	01 d0                	add    %edx,%eax
  8005a6:	83 ec 04             	sub    $0x4,%esp
  8005a9:	6a 01                	push   $0x1
  8005ab:	50                   	push   %eax
  8005ac:	68 8d 3e 80 00       	push   $0x803e8d
  8005b1:	e8 72 15 00 00       	call   801b28 <smalloc>
  8005b6:	83 c4 10             	add    $0x10,%esp
  8005b9:	89 45 a4             	mov    %eax,-0x5c(%ebp)

		expected = 3073+4+4 ; /*3073pages +4tables +4pages for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  8005bc:	c7 45 d4 09 0c 00 00 	movl   $0xc09,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8005c3:	8b 5d b0             	mov    -0x50(%ebp),%ebx
  8005c6:	e8 7b 1a 00 00       	call   802046 <sys_calculate_free_frames>
  8005cb:	29 c3                	sub    %eax,%ebx
  8005cd:	89 d8                	mov    %ebx,%eax
  8005cf:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/)
  8005d2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005d5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8005d8:	7c 0b                	jl     8005e5 <_main+0x5ad>
  8005da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005dd:	83 c0 02             	add    $0x2,%eax
  8005e0:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8005e3:	7d 27                	jge    80060c <_main+0x5d4>
			{is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8005e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005ec:	8b 5d b0             	mov    -0x50(%ebp),%ebx
  8005ef:	e8 52 1a 00 00       	call   802046 <sys_calculate_free_frames>
  8005f4:	29 c3                	sub    %eax,%ebx
  8005f6:	89 d8                	mov    %ebx,%eax
  8005f8:	83 ec 04             	sub    $0x4,%esp
  8005fb:	ff 75 d4             	pushl  -0x2c(%ebp)
  8005fe:	50                   	push   %eax
  8005ff:	68 5c 3c 80 00       	push   $0x803c5c
  800604:	e8 b8 04 00 00       	call   800ac1 <cprintf>
  800609:	83 c4 10             	add    $0x10,%esp

		freeFrames = sys_calculate_free_frames() ;
  80060c:	e8 35 1a 00 00       	call   802046 <sys_calculate_free_frames>
  800611:	89 45 b0             	mov    %eax,-0x50(%ebp)

		sfree(o);
  800614:	83 ec 0c             	sub    $0xc,%esp
  800617:	ff 75 a4             	pushl  -0x5c(%ebp)
  80061a:	e8 3b 18 00 00       	call   801e5a <sfree>
  80061f:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) {is_correct = 0; cprintf("Wrong free: check your logic");

		sfree(w);
  800622:	83 ec 0c             	sub    $0xc,%esp
  800625:	ff 75 ac             	pushl  -0x54(%ebp)
  800628:	e8 2d 18 00 00       	call   801e5a <sfree>
  80062d:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) {is_correct = 0; cprintf("Wrong free: check your logic");

		sfree(u);
  800630:	83 ec 0c             	sub    $0xc,%esp
  800633:	ff 75 a8             	pushl  -0x58(%ebp)
  800636:	e8 1f 18 00 00       	call   801e5a <sfree>
  80063b:	83 c4 10             	add    $0x10,%esp

		expected = 3073+4+4;
  80063e:	c7 45 d4 09 0c 00 00 	movl   $0xc09,-0x2c(%ebp)
		diff = (sys_calculate_free_frames() - freeFrames);
  800645:	e8 fc 19 00 00       	call   802046 <sys_calculate_free_frames>
  80064a:	89 c2                	mov    %eax,%edx
  80064c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80064f:	29 c2                	sub    %eax,%edx
  800651:	89 d0                	mov    %edx,%eax
  800653:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800656:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800659:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80065c:	74 27                	je     800685 <_main+0x64d>
  80065e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800665:	8b 5d b0             	mov    -0x50(%ebp),%ebx
  800668:	e8 d9 19 00 00       	call   802046 <sys_calculate_free_frames>
  80066d:	29 c3                	sub    %eax,%ebx
  80066f:	89 d8                	mov    %ebx,%eax
  800671:	83 ec 04             	sub    $0x4,%esp
  800674:	50                   	push   %eax
  800675:	ff 75 d4             	pushl  -0x2c(%ebp)
  800678:	68 f4 3c 80 00       	push   $0x803cf4
  80067d:	e8 3f 04 00 00       	call   800ac1 <cprintf>
  800682:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("Step C completed!!\n\n\n");
  800685:	83 ec 0c             	sub    $0xc,%esp
  800688:	68 8f 3e 80 00       	push   $0x803e8f
  80068d:	e8 2f 04 00 00       	call   800ac1 <cprintf>
  800692:	83 c4 10             	add    $0x10,%esp
	if (is_correct)	eval+=25;
  800695:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800699:	74 04                	je     80069f <_main+0x667>
  80069b:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  80069f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("\n%~Test of freeSharedObjects [4] completed. Eval = %d%%\n\n", eval);
  8006a6:	83 ec 08             	sub    $0x8,%esp
  8006a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ac:	68 a8 3e 80 00       	push   $0x803ea8
  8006b1:	e8 0b 04 00 00       	call   800ac1 <cprintf>
  8006b6:	83 c4 10             	add    $0x10,%esp

	return;
  8006b9:	90                   	nop
}
  8006ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006bd:	c9                   	leave  
  8006be:	c3                   	ret    

008006bf <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
  8006c2:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8006c5:	e8 45 1b 00 00       	call   80220f <sys_getenvindex>
  8006ca:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8006cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d0:	89 d0                	mov    %edx,%eax
  8006d2:	c1 e0 02             	shl    $0x2,%eax
  8006d5:	01 d0                	add    %edx,%eax
  8006d7:	c1 e0 03             	shl    $0x3,%eax
  8006da:	01 d0                	add    %edx,%eax
  8006dc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	c1 e0 02             	shl    $0x2,%eax
  8006e8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006ed:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8006f7:	8a 40 20             	mov    0x20(%eax),%al
  8006fa:	84 c0                	test   %al,%al
  8006fc:	74 0d                	je     80070b <libmain+0x4c>
		binaryname = myEnv->prog_name;
  8006fe:	a1 20 50 80 00       	mov    0x805020,%eax
  800703:	83 c0 20             	add    $0x20,%eax
  800706:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80070b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80070f:	7e 0a                	jle    80071b <libmain+0x5c>
		binaryname = argv[0];
  800711:	8b 45 0c             	mov    0xc(%ebp),%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80071b:	83 ec 08             	sub    $0x8,%esp
  80071e:	ff 75 0c             	pushl  0xc(%ebp)
  800721:	ff 75 08             	pushl  0x8(%ebp)
  800724:	e8 0f f9 ff ff       	call   800038 <_main>
  800729:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80072c:	a1 00 50 80 00       	mov    0x805000,%eax
  800731:	85 c0                	test   %eax,%eax
  800733:	0f 84 9f 00 00 00    	je     8007d8 <libmain+0x119>
	{
		sys_lock_cons();
  800739:	e8 55 18 00 00       	call   801f93 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80073e:	83 ec 0c             	sub    $0xc,%esp
  800741:	68 fc 3e 80 00       	push   $0x803efc
  800746:	e8 76 03 00 00       	call   800ac1 <cprintf>
  80074b:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80074e:	a1 20 50 80 00       	mov    0x805020,%eax
  800753:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800759:	a1 20 50 80 00       	mov    0x805020,%eax
  80075e:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800764:	83 ec 04             	sub    $0x4,%esp
  800767:	52                   	push   %edx
  800768:	50                   	push   %eax
  800769:	68 24 3f 80 00       	push   $0x803f24
  80076e:	e8 4e 03 00 00       	call   800ac1 <cprintf>
  800773:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800776:	a1 20 50 80 00       	mov    0x805020,%eax
  80077b:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800781:	a1 20 50 80 00       	mov    0x805020,%eax
  800786:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80078c:	a1 20 50 80 00       	mov    0x805020,%eax
  800791:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800797:	51                   	push   %ecx
  800798:	52                   	push   %edx
  800799:	50                   	push   %eax
  80079a:	68 4c 3f 80 00       	push   $0x803f4c
  80079f:	e8 1d 03 00 00       	call   800ac1 <cprintf>
  8007a4:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007a7:	a1 20 50 80 00       	mov    0x805020,%eax
  8007ac:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	50                   	push   %eax
  8007b6:	68 a4 3f 80 00       	push   $0x803fa4
  8007bb:	e8 01 03 00 00       	call   800ac1 <cprintf>
  8007c0:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8007c3:	83 ec 0c             	sub    $0xc,%esp
  8007c6:	68 fc 3e 80 00       	push   $0x803efc
  8007cb:	e8 f1 02 00 00       	call   800ac1 <cprintf>
  8007d0:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8007d3:	e8 d5 17 00 00       	call   801fad <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8007d8:	e8 19 00 00 00       	call   8007f6 <exit>
}
  8007dd:	90                   	nop
  8007de:	c9                   	leave  
  8007df:	c3                   	ret    

008007e0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8007e0:	55                   	push   %ebp
  8007e1:	89 e5                	mov    %esp,%ebp
  8007e3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8007e6:	83 ec 0c             	sub    $0xc,%esp
  8007e9:	6a 00                	push   $0x0
  8007eb:	e8 eb 19 00 00       	call   8021db <sys_destroy_env>
  8007f0:	83 c4 10             	add    $0x10,%esp
}
  8007f3:	90                   	nop
  8007f4:	c9                   	leave  
  8007f5:	c3                   	ret    

008007f6 <exit>:

void
exit(void)
{
  8007f6:	55                   	push   %ebp
  8007f7:	89 e5                	mov    %esp,%ebp
  8007f9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007fc:	e8 40 1a 00 00       	call   802241 <sys_exit_env>
}
  800801:	90                   	nop
  800802:	c9                   	leave  
  800803:	c3                   	ret    

00800804 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800804:	55                   	push   %ebp
  800805:	89 e5                	mov    %esp,%ebp
  800807:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80080a:	8d 45 10             	lea    0x10(%ebp),%eax
  80080d:	83 c0 04             	add    $0x4,%eax
  800810:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800813:	a1 60 50 98 00       	mov    0x985060,%eax
  800818:	85 c0                	test   %eax,%eax
  80081a:	74 16                	je     800832 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80081c:	a1 60 50 98 00       	mov    0x985060,%eax
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	50                   	push   %eax
  800825:	68 b8 3f 80 00       	push   $0x803fb8
  80082a:	e8 92 02 00 00       	call   800ac1 <cprintf>
  80082f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800832:	a1 04 50 80 00       	mov    0x805004,%eax
  800837:	ff 75 0c             	pushl  0xc(%ebp)
  80083a:	ff 75 08             	pushl  0x8(%ebp)
  80083d:	50                   	push   %eax
  80083e:	68 bd 3f 80 00       	push   $0x803fbd
  800843:	e8 79 02 00 00       	call   800ac1 <cprintf>
  800848:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80084b:	8b 45 10             	mov    0x10(%ebp),%eax
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	ff 75 f4             	pushl  -0xc(%ebp)
  800854:	50                   	push   %eax
  800855:	e8 fc 01 00 00       	call   800a56 <vcprintf>
  80085a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	6a 00                	push   $0x0
  800862:	68 d9 3f 80 00       	push   $0x803fd9
  800867:	e8 ea 01 00 00       	call   800a56 <vcprintf>
  80086c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80086f:	e8 82 ff ff ff       	call   8007f6 <exit>

	// should not return here
	while (1) ;
  800874:	eb fe                	jmp    800874 <_panic+0x70>

00800876 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800876:	55                   	push   %ebp
  800877:	89 e5                	mov    %esp,%ebp
  800879:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80087c:	a1 20 50 80 00       	mov    0x805020,%eax
  800881:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800887:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088a:	39 c2                	cmp    %eax,%edx
  80088c:	74 14                	je     8008a2 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80088e:	83 ec 04             	sub    $0x4,%esp
  800891:	68 dc 3f 80 00       	push   $0x803fdc
  800896:	6a 26                	push   $0x26
  800898:	68 28 40 80 00       	push   $0x804028
  80089d:	e8 62 ff ff ff       	call   800804 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8008a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8008a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008b0:	e9 c5 00 00 00       	jmp    80097a <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8008b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	01 d0                	add    %edx,%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	85 c0                	test   %eax,%eax
  8008c8:	75 08                	jne    8008d2 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8008ca:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8008cd:	e9 a5 00 00 00       	jmp    800977 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8008d2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8008e0:	eb 69                	jmp    80094b <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8008e2:	a1 20 50 80 00       	mov    0x805020,%eax
  8008e7:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8008ed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008f0:	89 d0                	mov    %edx,%eax
  8008f2:	01 c0                	add    %eax,%eax
  8008f4:	01 d0                	add    %edx,%eax
  8008f6:	c1 e0 03             	shl    $0x3,%eax
  8008f9:	01 c8                	add    %ecx,%eax
  8008fb:	8a 40 04             	mov    0x4(%eax),%al
  8008fe:	84 c0                	test   %al,%al
  800900:	75 46                	jne    800948 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800902:	a1 20 50 80 00       	mov    0x805020,%eax
  800907:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80090d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800910:	89 d0                	mov    %edx,%eax
  800912:	01 c0                	add    %eax,%eax
  800914:	01 d0                	add    %edx,%eax
  800916:	c1 e0 03             	shl    $0x3,%eax
  800919:	01 c8                	add    %ecx,%eax
  80091b:	8b 00                	mov    (%eax),%eax
  80091d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800920:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800923:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800928:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80092a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80092d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	01 c8                	add    %ecx,%eax
  800939:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80093b:	39 c2                	cmp    %eax,%edx
  80093d:	75 09                	jne    800948 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80093f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800946:	eb 15                	jmp    80095d <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800948:	ff 45 e8             	incl   -0x18(%ebp)
  80094b:	a1 20 50 80 00       	mov    0x805020,%eax
  800950:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800956:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800959:	39 c2                	cmp    %eax,%edx
  80095b:	77 85                	ja     8008e2 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80095d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800961:	75 14                	jne    800977 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800963:	83 ec 04             	sub    $0x4,%esp
  800966:	68 34 40 80 00       	push   $0x804034
  80096b:	6a 3a                	push   $0x3a
  80096d:	68 28 40 80 00       	push   $0x804028
  800972:	e8 8d fe ff ff       	call   800804 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800977:	ff 45 f0             	incl   -0x10(%ebp)
  80097a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80097d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800980:	0f 8c 2f ff ff ff    	jl     8008b5 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800986:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80098d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800994:	eb 26                	jmp    8009bc <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800996:	a1 20 50 80 00       	mov    0x805020,%eax
  80099b:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8009a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a4:	89 d0                	mov    %edx,%eax
  8009a6:	01 c0                	add    %eax,%eax
  8009a8:	01 d0                	add    %edx,%eax
  8009aa:	c1 e0 03             	shl    $0x3,%eax
  8009ad:	01 c8                	add    %ecx,%eax
  8009af:	8a 40 04             	mov    0x4(%eax),%al
  8009b2:	3c 01                	cmp    $0x1,%al
  8009b4:	75 03                	jne    8009b9 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8009b6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009b9:	ff 45 e0             	incl   -0x20(%ebp)
  8009bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8009c1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8009c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ca:	39 c2                	cmp    %eax,%edx
  8009cc:	77 c8                	ja     800996 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8009ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009d1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8009d4:	74 14                	je     8009ea <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8009d6:	83 ec 04             	sub    $0x4,%esp
  8009d9:	68 88 40 80 00       	push   $0x804088
  8009de:	6a 44                	push   $0x44
  8009e0:	68 28 40 80 00       	push   $0x804028
  8009e5:	e8 1a fe ff ff       	call   800804 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8009ea:	90                   	nop
  8009eb:	c9                   	leave  
  8009ec:	c3                   	ret    

008009ed <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8009f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f6:	8b 00                	mov    (%eax),%eax
  8009f8:	8d 48 01             	lea    0x1(%eax),%ecx
  8009fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009fe:	89 0a                	mov    %ecx,(%edx)
  800a00:	8b 55 08             	mov    0x8(%ebp),%edx
  800a03:	88 d1                	mov    %dl,%cl
  800a05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a08:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0f:	8b 00                	mov    (%eax),%eax
  800a11:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a16:	75 2c                	jne    800a44 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800a18:	a0 44 50 98 00       	mov    0x985044,%al
  800a1d:	0f b6 c0             	movzbl %al,%eax
  800a20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a23:	8b 12                	mov    (%edx),%edx
  800a25:	89 d1                	mov    %edx,%ecx
  800a27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2a:	83 c2 08             	add    $0x8,%edx
  800a2d:	83 ec 04             	sub    $0x4,%esp
  800a30:	50                   	push   %eax
  800a31:	51                   	push   %ecx
  800a32:	52                   	push   %edx
  800a33:	e8 19 15 00 00       	call   801f51 <sys_cputs>
  800a38:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a47:	8b 40 04             	mov    0x4(%eax),%eax
  800a4a:	8d 50 01             	lea    0x1(%eax),%edx
  800a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a50:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a53:	90                   	nop
  800a54:	c9                   	leave  
  800a55:	c3                   	ret    

00800a56 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a5f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a66:	00 00 00 
	b.cnt = 0;
  800a69:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a70:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a73:	ff 75 0c             	pushl  0xc(%ebp)
  800a76:	ff 75 08             	pushl  0x8(%ebp)
  800a79:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a7f:	50                   	push   %eax
  800a80:	68 ed 09 80 00       	push   $0x8009ed
  800a85:	e8 11 02 00 00       	call   800c9b <vprintfmt>
  800a8a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a8d:	a0 44 50 98 00       	mov    0x985044,%al
  800a92:	0f b6 c0             	movzbl %al,%eax
  800a95:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a9b:	83 ec 04             	sub    $0x4,%esp
  800a9e:	50                   	push   %eax
  800a9f:	52                   	push   %edx
  800aa0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800aa6:	83 c0 08             	add    $0x8,%eax
  800aa9:	50                   	push   %eax
  800aaa:	e8 a2 14 00 00       	call   801f51 <sys_cputs>
  800aaf:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ab2:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  800ab9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800abf:	c9                   	leave  
  800ac0:	c3                   	ret    

00800ac1 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800ac1:	55                   	push   %ebp
  800ac2:	89 e5                	mov    %esp,%ebp
  800ac4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ac7:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  800ace:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ad1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	ff 75 f4             	pushl  -0xc(%ebp)
  800add:	50                   	push   %eax
  800ade:	e8 73 ff ff ff       	call   800a56 <vcprintf>
  800ae3:	83 c4 10             	add    $0x10,%esp
  800ae6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aec:	c9                   	leave  
  800aed:	c3                   	ret    

00800aee <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800af4:	e8 9a 14 00 00       	call   801f93 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800af9:	8d 45 0c             	lea    0xc(%ebp),%eax
  800afc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	83 ec 08             	sub    $0x8,%esp
  800b05:	ff 75 f4             	pushl  -0xc(%ebp)
  800b08:	50                   	push   %eax
  800b09:	e8 48 ff ff ff       	call   800a56 <vcprintf>
  800b0e:	83 c4 10             	add    $0x10,%esp
  800b11:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b14:	e8 94 14 00 00       	call   801fad <sys_unlock_cons>
	return cnt;
  800b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b1c:	c9                   	leave  
  800b1d:	c3                   	ret    

00800b1e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	53                   	push   %ebx
  800b22:	83 ec 14             	sub    $0x14,%esp
  800b25:	8b 45 10             	mov    0x10(%ebp),%eax
  800b28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b31:	8b 45 18             	mov    0x18(%ebp),%eax
  800b34:	ba 00 00 00 00       	mov    $0x0,%edx
  800b39:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b3c:	77 55                	ja     800b93 <printnum+0x75>
  800b3e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b41:	72 05                	jb     800b48 <printnum+0x2a>
  800b43:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b46:	77 4b                	ja     800b93 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b48:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b4b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b4e:	8b 45 18             	mov    0x18(%ebp),%eax
  800b51:	ba 00 00 00 00       	mov    $0x0,%edx
  800b56:	52                   	push   %edx
  800b57:	50                   	push   %eax
  800b58:	ff 75 f4             	pushl  -0xc(%ebp)
  800b5b:	ff 75 f0             	pushl  -0x10(%ebp)
  800b5e:	e8 f1 2c 00 00       	call   803854 <__udivdi3>
  800b63:	83 c4 10             	add    $0x10,%esp
  800b66:	83 ec 04             	sub    $0x4,%esp
  800b69:	ff 75 20             	pushl  0x20(%ebp)
  800b6c:	53                   	push   %ebx
  800b6d:	ff 75 18             	pushl  0x18(%ebp)
  800b70:	52                   	push   %edx
  800b71:	50                   	push   %eax
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	ff 75 08             	pushl  0x8(%ebp)
  800b78:	e8 a1 ff ff ff       	call   800b1e <printnum>
  800b7d:	83 c4 20             	add    $0x20,%esp
  800b80:	eb 1a                	jmp    800b9c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b82:	83 ec 08             	sub    $0x8,%esp
  800b85:	ff 75 0c             	pushl  0xc(%ebp)
  800b88:	ff 75 20             	pushl  0x20(%ebp)
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	ff d0                	call   *%eax
  800b90:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b93:	ff 4d 1c             	decl   0x1c(%ebp)
  800b96:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b9a:	7f e6                	jg     800b82 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b9c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800baa:	53                   	push   %ebx
  800bab:	51                   	push   %ecx
  800bac:	52                   	push   %edx
  800bad:	50                   	push   %eax
  800bae:	e8 b1 2d 00 00       	call   803964 <__umoddi3>
  800bb3:	83 c4 10             	add    $0x10,%esp
  800bb6:	05 f4 42 80 00       	add    $0x8042f4,%eax
  800bbb:	8a 00                	mov    (%eax),%al
  800bbd:	0f be c0             	movsbl %al,%eax
  800bc0:	83 ec 08             	sub    $0x8,%esp
  800bc3:	ff 75 0c             	pushl  0xc(%ebp)
  800bc6:	50                   	push   %eax
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	ff d0                	call   *%eax
  800bcc:	83 c4 10             	add    $0x10,%esp
}
  800bcf:	90                   	nop
  800bd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bd3:	c9                   	leave  
  800bd4:	c3                   	ret    

00800bd5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bd8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bdc:	7e 1c                	jle    800bfa <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	8b 00                	mov    (%eax),%eax
  800be3:	8d 50 08             	lea    0x8(%eax),%edx
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	89 10                	mov    %edx,(%eax)
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	8b 00                	mov    (%eax),%eax
  800bf0:	83 e8 08             	sub    $0x8,%eax
  800bf3:	8b 50 04             	mov    0x4(%eax),%edx
  800bf6:	8b 00                	mov    (%eax),%eax
  800bf8:	eb 40                	jmp    800c3a <getuint+0x65>
	else if (lflag)
  800bfa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bfe:	74 1e                	je     800c1e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	8b 00                	mov    (%eax),%eax
  800c05:	8d 50 04             	lea    0x4(%eax),%edx
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	89 10                	mov    %edx,(%eax)
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	8b 00                	mov    (%eax),%eax
  800c12:	83 e8 04             	sub    $0x4,%eax
  800c15:	8b 00                	mov    (%eax),%eax
  800c17:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1c:	eb 1c                	jmp    800c3a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	8b 00                	mov    (%eax),%eax
  800c23:	8d 50 04             	lea    0x4(%eax),%edx
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	89 10                	mov    %edx,(%eax)
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	8b 00                	mov    (%eax),%eax
  800c30:	83 e8 04             	sub    $0x4,%eax
  800c33:	8b 00                	mov    (%eax),%eax
  800c35:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    

00800c3c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c3f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c43:	7e 1c                	jle    800c61 <getint+0x25>
		return va_arg(*ap, long long);
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	8b 00                	mov    (%eax),%eax
  800c4a:	8d 50 08             	lea    0x8(%eax),%edx
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c50:	89 10                	mov    %edx,(%eax)
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	8b 00                	mov    (%eax),%eax
  800c57:	83 e8 08             	sub    $0x8,%eax
  800c5a:	8b 50 04             	mov    0x4(%eax),%edx
  800c5d:	8b 00                	mov    (%eax),%eax
  800c5f:	eb 38                	jmp    800c99 <getint+0x5d>
	else if (lflag)
  800c61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c65:	74 1a                	je     800c81 <getint+0x45>
		return va_arg(*ap, long);
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	8b 00                	mov    (%eax),%eax
  800c6c:	8d 50 04             	lea    0x4(%eax),%edx
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	89 10                	mov    %edx,(%eax)
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	8b 00                	mov    (%eax),%eax
  800c79:	83 e8 04             	sub    $0x4,%eax
  800c7c:	8b 00                	mov    (%eax),%eax
  800c7e:	99                   	cltd   
  800c7f:	eb 18                	jmp    800c99 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c81:	8b 45 08             	mov    0x8(%ebp),%eax
  800c84:	8b 00                	mov    (%eax),%eax
  800c86:	8d 50 04             	lea    0x4(%eax),%edx
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	89 10                	mov    %edx,(%eax)
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8b 00                	mov    (%eax),%eax
  800c93:	83 e8 04             	sub    $0x4,%eax
  800c96:	8b 00                	mov    (%eax),%eax
  800c98:	99                   	cltd   
}
  800c99:	5d                   	pop    %ebp
  800c9a:	c3                   	ret    

00800c9b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	56                   	push   %esi
  800c9f:	53                   	push   %ebx
  800ca0:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ca3:	eb 17                	jmp    800cbc <vprintfmt+0x21>
			if (ch == '\0')
  800ca5:	85 db                	test   %ebx,%ebx
  800ca7:	0f 84 c1 03 00 00    	je     80106e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800cad:	83 ec 08             	sub    $0x8,%esp
  800cb0:	ff 75 0c             	pushl  0xc(%ebp)
  800cb3:	53                   	push   %ebx
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	ff d0                	call   *%eax
  800cb9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cbc:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbf:	8d 50 01             	lea    0x1(%eax),%edx
  800cc2:	89 55 10             	mov    %edx,0x10(%ebp)
  800cc5:	8a 00                	mov    (%eax),%al
  800cc7:	0f b6 d8             	movzbl %al,%ebx
  800cca:	83 fb 25             	cmp    $0x25,%ebx
  800ccd:	75 d6                	jne    800ca5 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ccf:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800cd3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800cda:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800ce1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800ce8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cef:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf2:	8d 50 01             	lea    0x1(%eax),%edx
  800cf5:	89 55 10             	mov    %edx,0x10(%ebp)
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	0f b6 d8             	movzbl %al,%ebx
  800cfd:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d00:	83 f8 5b             	cmp    $0x5b,%eax
  800d03:	0f 87 3d 03 00 00    	ja     801046 <vprintfmt+0x3ab>
  800d09:	8b 04 85 18 43 80 00 	mov    0x804318(,%eax,4),%eax
  800d10:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d12:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d16:	eb d7                	jmp    800cef <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d18:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d1c:	eb d1                	jmp    800cef <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d1e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d25:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d28:	89 d0                	mov    %edx,%eax
  800d2a:	c1 e0 02             	shl    $0x2,%eax
  800d2d:	01 d0                	add    %edx,%eax
  800d2f:	01 c0                	add    %eax,%eax
  800d31:	01 d8                	add    %ebx,%eax
  800d33:	83 e8 30             	sub    $0x30,%eax
  800d36:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d39:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d41:	83 fb 2f             	cmp    $0x2f,%ebx
  800d44:	7e 3e                	jle    800d84 <vprintfmt+0xe9>
  800d46:	83 fb 39             	cmp    $0x39,%ebx
  800d49:	7f 39                	jg     800d84 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d4b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d4e:	eb d5                	jmp    800d25 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d50:	8b 45 14             	mov    0x14(%ebp),%eax
  800d53:	83 c0 04             	add    $0x4,%eax
  800d56:	89 45 14             	mov    %eax,0x14(%ebp)
  800d59:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5c:	83 e8 04             	sub    $0x4,%eax
  800d5f:	8b 00                	mov    (%eax),%eax
  800d61:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d64:	eb 1f                	jmp    800d85 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d66:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d6a:	79 83                	jns    800cef <vprintfmt+0x54>
				width = 0;
  800d6c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d73:	e9 77 ff ff ff       	jmp    800cef <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d78:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d7f:	e9 6b ff ff ff       	jmp    800cef <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d84:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d85:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d89:	0f 89 60 ff ff ff    	jns    800cef <vprintfmt+0x54>
				width = precision, precision = -1;
  800d8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d95:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d9c:	e9 4e ff ff ff       	jmp    800cef <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800da1:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800da4:	e9 46 ff ff ff       	jmp    800cef <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800da9:	8b 45 14             	mov    0x14(%ebp),%eax
  800dac:	83 c0 04             	add    $0x4,%eax
  800daf:	89 45 14             	mov    %eax,0x14(%ebp)
  800db2:	8b 45 14             	mov    0x14(%ebp),%eax
  800db5:	83 e8 04             	sub    $0x4,%eax
  800db8:	8b 00                	mov    (%eax),%eax
  800dba:	83 ec 08             	sub    $0x8,%esp
  800dbd:	ff 75 0c             	pushl  0xc(%ebp)
  800dc0:	50                   	push   %eax
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	ff d0                	call   *%eax
  800dc6:	83 c4 10             	add    $0x10,%esp
			break;
  800dc9:	e9 9b 02 00 00       	jmp    801069 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800dce:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd1:	83 c0 04             	add    $0x4,%eax
  800dd4:	89 45 14             	mov    %eax,0x14(%ebp)
  800dd7:	8b 45 14             	mov    0x14(%ebp),%eax
  800dda:	83 e8 04             	sub    $0x4,%eax
  800ddd:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ddf:	85 db                	test   %ebx,%ebx
  800de1:	79 02                	jns    800de5 <vprintfmt+0x14a>
				err = -err;
  800de3:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800de5:	83 fb 64             	cmp    $0x64,%ebx
  800de8:	7f 0b                	jg     800df5 <vprintfmt+0x15a>
  800dea:	8b 34 9d 60 41 80 00 	mov    0x804160(,%ebx,4),%esi
  800df1:	85 f6                	test   %esi,%esi
  800df3:	75 19                	jne    800e0e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800df5:	53                   	push   %ebx
  800df6:	68 05 43 80 00       	push   $0x804305
  800dfb:	ff 75 0c             	pushl  0xc(%ebp)
  800dfe:	ff 75 08             	pushl  0x8(%ebp)
  800e01:	e8 70 02 00 00       	call   801076 <printfmt>
  800e06:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e09:	e9 5b 02 00 00       	jmp    801069 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e0e:	56                   	push   %esi
  800e0f:	68 0e 43 80 00       	push   $0x80430e
  800e14:	ff 75 0c             	pushl  0xc(%ebp)
  800e17:	ff 75 08             	pushl  0x8(%ebp)
  800e1a:	e8 57 02 00 00       	call   801076 <printfmt>
  800e1f:	83 c4 10             	add    $0x10,%esp
			break;
  800e22:	e9 42 02 00 00       	jmp    801069 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e27:	8b 45 14             	mov    0x14(%ebp),%eax
  800e2a:	83 c0 04             	add    $0x4,%eax
  800e2d:	89 45 14             	mov    %eax,0x14(%ebp)
  800e30:	8b 45 14             	mov    0x14(%ebp),%eax
  800e33:	83 e8 04             	sub    $0x4,%eax
  800e36:	8b 30                	mov    (%eax),%esi
  800e38:	85 f6                	test   %esi,%esi
  800e3a:	75 05                	jne    800e41 <vprintfmt+0x1a6>
				p = "(null)";
  800e3c:	be 11 43 80 00       	mov    $0x804311,%esi
			if (width > 0 && padc != '-')
  800e41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e45:	7e 6d                	jle    800eb4 <vprintfmt+0x219>
  800e47:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e4b:	74 67                	je     800eb4 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e50:	83 ec 08             	sub    $0x8,%esp
  800e53:	50                   	push   %eax
  800e54:	56                   	push   %esi
  800e55:	e8 1e 03 00 00       	call   801178 <strnlen>
  800e5a:	83 c4 10             	add    $0x10,%esp
  800e5d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e60:	eb 16                	jmp    800e78 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e62:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e66:	83 ec 08             	sub    $0x8,%esp
  800e69:	ff 75 0c             	pushl  0xc(%ebp)
  800e6c:	50                   	push   %eax
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	ff d0                	call   *%eax
  800e72:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e75:	ff 4d e4             	decl   -0x1c(%ebp)
  800e78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e7c:	7f e4                	jg     800e62 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e7e:	eb 34                	jmp    800eb4 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e80:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e84:	74 1c                	je     800ea2 <vprintfmt+0x207>
  800e86:	83 fb 1f             	cmp    $0x1f,%ebx
  800e89:	7e 05                	jle    800e90 <vprintfmt+0x1f5>
  800e8b:	83 fb 7e             	cmp    $0x7e,%ebx
  800e8e:	7e 12                	jle    800ea2 <vprintfmt+0x207>
					putch('?', putdat);
  800e90:	83 ec 08             	sub    $0x8,%esp
  800e93:	ff 75 0c             	pushl  0xc(%ebp)
  800e96:	6a 3f                	push   $0x3f
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	ff d0                	call   *%eax
  800e9d:	83 c4 10             	add    $0x10,%esp
  800ea0:	eb 0f                	jmp    800eb1 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ea2:	83 ec 08             	sub    $0x8,%esp
  800ea5:	ff 75 0c             	pushl  0xc(%ebp)
  800ea8:	53                   	push   %ebx
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	ff d0                	call   *%eax
  800eae:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eb1:	ff 4d e4             	decl   -0x1c(%ebp)
  800eb4:	89 f0                	mov    %esi,%eax
  800eb6:	8d 70 01             	lea    0x1(%eax),%esi
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	0f be d8             	movsbl %al,%ebx
  800ebe:	85 db                	test   %ebx,%ebx
  800ec0:	74 24                	je     800ee6 <vprintfmt+0x24b>
  800ec2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ec6:	78 b8                	js     800e80 <vprintfmt+0x1e5>
  800ec8:	ff 4d e0             	decl   -0x20(%ebp)
  800ecb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ecf:	79 af                	jns    800e80 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ed1:	eb 13                	jmp    800ee6 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ed3:	83 ec 08             	sub    $0x8,%esp
  800ed6:	ff 75 0c             	pushl  0xc(%ebp)
  800ed9:	6a 20                	push   $0x20
  800edb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ede:	ff d0                	call   *%eax
  800ee0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ee3:	ff 4d e4             	decl   -0x1c(%ebp)
  800ee6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eea:	7f e7                	jg     800ed3 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800eec:	e9 78 01 00 00       	jmp    801069 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ef1:	83 ec 08             	sub    $0x8,%esp
  800ef4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ef7:	8d 45 14             	lea    0x14(%ebp),%eax
  800efa:	50                   	push   %eax
  800efb:	e8 3c fd ff ff       	call   800c3c <getint>
  800f00:	83 c4 10             	add    $0x10,%esp
  800f03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f06:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f0f:	85 d2                	test   %edx,%edx
  800f11:	79 23                	jns    800f36 <vprintfmt+0x29b>
				putch('-', putdat);
  800f13:	83 ec 08             	sub    $0x8,%esp
  800f16:	ff 75 0c             	pushl  0xc(%ebp)
  800f19:	6a 2d                	push   $0x2d
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	ff d0                	call   *%eax
  800f20:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f29:	f7 d8                	neg    %eax
  800f2b:	83 d2 00             	adc    $0x0,%edx
  800f2e:	f7 da                	neg    %edx
  800f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f36:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f3d:	e9 bc 00 00 00       	jmp    800ffe <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f42:	83 ec 08             	sub    $0x8,%esp
  800f45:	ff 75 e8             	pushl  -0x18(%ebp)
  800f48:	8d 45 14             	lea    0x14(%ebp),%eax
  800f4b:	50                   	push   %eax
  800f4c:	e8 84 fc ff ff       	call   800bd5 <getuint>
  800f51:	83 c4 10             	add    $0x10,%esp
  800f54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f57:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f5a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f61:	e9 98 00 00 00       	jmp    800ffe <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f66:	83 ec 08             	sub    $0x8,%esp
  800f69:	ff 75 0c             	pushl  0xc(%ebp)
  800f6c:	6a 58                	push   $0x58
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	ff d0                	call   *%eax
  800f73:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f76:	83 ec 08             	sub    $0x8,%esp
  800f79:	ff 75 0c             	pushl  0xc(%ebp)
  800f7c:	6a 58                	push   $0x58
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	ff d0                	call   *%eax
  800f83:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f86:	83 ec 08             	sub    $0x8,%esp
  800f89:	ff 75 0c             	pushl  0xc(%ebp)
  800f8c:	6a 58                	push   $0x58
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	ff d0                	call   *%eax
  800f93:	83 c4 10             	add    $0x10,%esp
			break;
  800f96:	e9 ce 00 00 00       	jmp    801069 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f9b:	83 ec 08             	sub    $0x8,%esp
  800f9e:	ff 75 0c             	pushl  0xc(%ebp)
  800fa1:	6a 30                	push   $0x30
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	ff d0                	call   *%eax
  800fa8:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fab:	83 ec 08             	sub    $0x8,%esp
  800fae:	ff 75 0c             	pushl  0xc(%ebp)
  800fb1:	6a 78                	push   $0x78
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	ff d0                	call   *%eax
  800fb8:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800fbb:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbe:	83 c0 04             	add    $0x4,%eax
  800fc1:	89 45 14             	mov    %eax,0x14(%ebp)
  800fc4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc7:	83 e8 04             	sub    $0x4,%eax
  800fca:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fcf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fd6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800fdd:	eb 1f                	jmp    800ffe <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fdf:	83 ec 08             	sub    $0x8,%esp
  800fe2:	ff 75 e8             	pushl  -0x18(%ebp)
  800fe5:	8d 45 14             	lea    0x14(%ebp),%eax
  800fe8:	50                   	push   %eax
  800fe9:	e8 e7 fb ff ff       	call   800bd5 <getuint>
  800fee:	83 c4 10             	add    $0x10,%esp
  800ff1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ff4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ff7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ffe:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801002:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801005:	83 ec 04             	sub    $0x4,%esp
  801008:	52                   	push   %edx
  801009:	ff 75 e4             	pushl  -0x1c(%ebp)
  80100c:	50                   	push   %eax
  80100d:	ff 75 f4             	pushl  -0xc(%ebp)
  801010:	ff 75 f0             	pushl  -0x10(%ebp)
  801013:	ff 75 0c             	pushl  0xc(%ebp)
  801016:	ff 75 08             	pushl  0x8(%ebp)
  801019:	e8 00 fb ff ff       	call   800b1e <printnum>
  80101e:	83 c4 20             	add    $0x20,%esp
			break;
  801021:	eb 46                	jmp    801069 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801023:	83 ec 08             	sub    $0x8,%esp
  801026:	ff 75 0c             	pushl  0xc(%ebp)
  801029:	53                   	push   %ebx
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	ff d0                	call   *%eax
  80102f:	83 c4 10             	add    $0x10,%esp
			break;
  801032:	eb 35                	jmp    801069 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801034:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  80103b:	eb 2c                	jmp    801069 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80103d:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  801044:	eb 23                	jmp    801069 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801046:	83 ec 08             	sub    $0x8,%esp
  801049:	ff 75 0c             	pushl  0xc(%ebp)
  80104c:	6a 25                	push   $0x25
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
  801051:	ff d0                	call   *%eax
  801053:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801056:	ff 4d 10             	decl   0x10(%ebp)
  801059:	eb 03                	jmp    80105e <vprintfmt+0x3c3>
  80105b:	ff 4d 10             	decl   0x10(%ebp)
  80105e:	8b 45 10             	mov    0x10(%ebp),%eax
  801061:	48                   	dec    %eax
  801062:	8a 00                	mov    (%eax),%al
  801064:	3c 25                	cmp    $0x25,%al
  801066:	75 f3                	jne    80105b <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801068:	90                   	nop
		}
	}
  801069:	e9 35 fc ff ff       	jmp    800ca3 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80106e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80106f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801072:	5b                   	pop    %ebx
  801073:	5e                   	pop    %esi
  801074:	5d                   	pop    %ebp
  801075:	c3                   	ret    

00801076 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80107c:	8d 45 10             	lea    0x10(%ebp),%eax
  80107f:	83 c0 04             	add    $0x4,%eax
  801082:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801085:	8b 45 10             	mov    0x10(%ebp),%eax
  801088:	ff 75 f4             	pushl  -0xc(%ebp)
  80108b:	50                   	push   %eax
  80108c:	ff 75 0c             	pushl  0xc(%ebp)
  80108f:	ff 75 08             	pushl  0x8(%ebp)
  801092:	e8 04 fc ff ff       	call   800c9b <vprintfmt>
  801097:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80109a:	90                   	nop
  80109b:	c9                   	leave  
  80109c:	c3                   	ret    

0080109d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a3:	8b 40 08             	mov    0x8(%eax),%eax
  8010a6:	8d 50 01             	lea    0x1(%eax),%edx
  8010a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ac:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b2:	8b 10                	mov    (%eax),%edx
  8010b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b7:	8b 40 04             	mov    0x4(%eax),%eax
  8010ba:	39 c2                	cmp    %eax,%edx
  8010bc:	73 12                	jae    8010d0 <sprintputch+0x33>
		*b->buf++ = ch;
  8010be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c1:	8b 00                	mov    (%eax),%eax
  8010c3:	8d 48 01             	lea    0x1(%eax),%ecx
  8010c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c9:	89 0a                	mov    %ecx,(%edx)
  8010cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ce:	88 10                	mov    %dl,(%eax)
}
  8010d0:	90                   	nop
  8010d1:	5d                   	pop    %ebp
  8010d2:	c3                   	ret    

008010d3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	01 d0                	add    %edx,%eax
  8010ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010f8:	74 06                	je     801100 <vsnprintf+0x2d>
  8010fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010fe:	7f 07                	jg     801107 <vsnprintf+0x34>
		return -E_INVAL;
  801100:	b8 03 00 00 00       	mov    $0x3,%eax
  801105:	eb 20                	jmp    801127 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801107:	ff 75 14             	pushl  0x14(%ebp)
  80110a:	ff 75 10             	pushl  0x10(%ebp)
  80110d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801110:	50                   	push   %eax
  801111:	68 9d 10 80 00       	push   $0x80109d
  801116:	e8 80 fb ff ff       	call   800c9b <vprintfmt>
  80111b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80111e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801121:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801124:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801127:	c9                   	leave  
  801128:	c3                   	ret    

00801129 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801129:	55                   	push   %ebp
  80112a:	89 e5                	mov    %esp,%ebp
  80112c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80112f:	8d 45 10             	lea    0x10(%ebp),%eax
  801132:	83 c0 04             	add    $0x4,%eax
  801135:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801138:	8b 45 10             	mov    0x10(%ebp),%eax
  80113b:	ff 75 f4             	pushl  -0xc(%ebp)
  80113e:	50                   	push   %eax
  80113f:	ff 75 0c             	pushl  0xc(%ebp)
  801142:	ff 75 08             	pushl  0x8(%ebp)
  801145:	e8 89 ff ff ff       	call   8010d3 <vsnprintf>
  80114a:	83 c4 10             	add    $0x10,%esp
  80114d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801150:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801153:	c9                   	leave  
  801154:	c3                   	ret    

00801155 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801155:	55                   	push   %ebp
  801156:	89 e5                	mov    %esp,%ebp
  801158:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80115b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801162:	eb 06                	jmp    80116a <strlen+0x15>
		n++;
  801164:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801167:	ff 45 08             	incl   0x8(%ebp)
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	8a 00                	mov    (%eax),%al
  80116f:	84 c0                	test   %al,%al
  801171:	75 f1                	jne    801164 <strlen+0xf>
		n++;
	return n;
  801173:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801176:	c9                   	leave  
  801177:	c3                   	ret    

00801178 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80117e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801185:	eb 09                	jmp    801190 <strnlen+0x18>
		n++;
  801187:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80118a:	ff 45 08             	incl   0x8(%ebp)
  80118d:	ff 4d 0c             	decl   0xc(%ebp)
  801190:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801194:	74 09                	je     80119f <strnlen+0x27>
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	84 c0                	test   %al,%al
  80119d:	75 e8                	jne    801187 <strnlen+0xf>
		n++;
	return n;
  80119f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011a2:	c9                   	leave  
  8011a3:	c3                   	ret    

008011a4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
  8011a7:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8011b0:	90                   	nop
  8011b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b4:	8d 50 01             	lea    0x1(%eax),%edx
  8011b7:	89 55 08             	mov    %edx,0x8(%ebp)
  8011ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011bd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011c0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011c3:	8a 12                	mov    (%edx),%dl
  8011c5:	88 10                	mov    %dl,(%eax)
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	84 c0                	test   %al,%al
  8011cb:	75 e4                	jne    8011b1 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8011cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011d0:	c9                   	leave  
  8011d1:	c3                   	ret    

008011d2 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8011d2:	55                   	push   %ebp
  8011d3:	89 e5                	mov    %esp,%ebp
  8011d5:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8011de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011e5:	eb 1f                	jmp    801206 <strncpy+0x34>
		*dst++ = *src;
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8d 50 01             	lea    0x1(%eax),%edx
  8011ed:	89 55 08             	mov    %edx,0x8(%ebp)
  8011f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f3:	8a 12                	mov    (%edx),%dl
  8011f5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fa:	8a 00                	mov    (%eax),%al
  8011fc:	84 c0                	test   %al,%al
  8011fe:	74 03                	je     801203 <strncpy+0x31>
			src++;
  801200:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801203:	ff 45 fc             	incl   -0x4(%ebp)
  801206:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801209:	3b 45 10             	cmp    0x10(%ebp),%eax
  80120c:	72 d9                	jb     8011e7 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80120e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801211:	c9                   	leave  
  801212:	c3                   	ret    

00801213 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801213:	55                   	push   %ebp
  801214:	89 e5                	mov    %esp,%ebp
  801216:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80121f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801223:	74 30                	je     801255 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801225:	eb 16                	jmp    80123d <strlcpy+0x2a>
			*dst++ = *src++;
  801227:	8b 45 08             	mov    0x8(%ebp),%eax
  80122a:	8d 50 01             	lea    0x1(%eax),%edx
  80122d:	89 55 08             	mov    %edx,0x8(%ebp)
  801230:	8b 55 0c             	mov    0xc(%ebp),%edx
  801233:	8d 4a 01             	lea    0x1(%edx),%ecx
  801236:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801239:	8a 12                	mov    (%edx),%dl
  80123b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80123d:	ff 4d 10             	decl   0x10(%ebp)
  801240:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801244:	74 09                	je     80124f <strlcpy+0x3c>
  801246:	8b 45 0c             	mov    0xc(%ebp),%eax
  801249:	8a 00                	mov    (%eax),%al
  80124b:	84 c0                	test   %al,%al
  80124d:	75 d8                	jne    801227 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801255:	8b 55 08             	mov    0x8(%ebp),%edx
  801258:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80125b:	29 c2                	sub    %eax,%edx
  80125d:	89 d0                	mov    %edx,%eax
}
  80125f:	c9                   	leave  
  801260:	c3                   	ret    

00801261 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801261:	55                   	push   %ebp
  801262:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801264:	eb 06                	jmp    80126c <strcmp+0xb>
		p++, q++;
  801266:	ff 45 08             	incl   0x8(%ebp)
  801269:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	84 c0                	test   %al,%al
  801273:	74 0e                	je     801283 <strcmp+0x22>
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 10                	mov    (%eax),%dl
  80127a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127d:	8a 00                	mov    (%eax),%al
  80127f:	38 c2                	cmp    %al,%dl
  801281:	74 e3                	je     801266 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	0f b6 d0             	movzbl %al,%edx
  80128b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128e:	8a 00                	mov    (%eax),%al
  801290:	0f b6 c0             	movzbl %al,%eax
  801293:	29 c2                	sub    %eax,%edx
  801295:	89 d0                	mov    %edx,%eax
}
  801297:	5d                   	pop    %ebp
  801298:	c3                   	ret    

00801299 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80129c:	eb 09                	jmp    8012a7 <strncmp+0xe>
		n--, p++, q++;
  80129e:	ff 4d 10             	decl   0x10(%ebp)
  8012a1:	ff 45 08             	incl   0x8(%ebp)
  8012a4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8012a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ab:	74 17                	je     8012c4 <strncmp+0x2b>
  8012ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b0:	8a 00                	mov    (%eax),%al
  8012b2:	84 c0                	test   %al,%al
  8012b4:	74 0e                	je     8012c4 <strncmp+0x2b>
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	8a 10                	mov    (%eax),%dl
  8012bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012be:	8a 00                	mov    (%eax),%al
  8012c0:	38 c2                	cmp    %al,%dl
  8012c2:	74 da                	je     80129e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8012c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c8:	75 07                	jne    8012d1 <strncmp+0x38>
		return 0;
  8012ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8012cf:	eb 14                	jmp    8012e5 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	0f b6 d0             	movzbl %al,%edx
  8012d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	0f b6 c0             	movzbl %al,%eax
  8012e1:	29 c2                	sub    %eax,%edx
  8012e3:	89 d0                	mov    %edx,%eax
}
  8012e5:	5d                   	pop    %ebp
  8012e6:	c3                   	ret    

008012e7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	83 ec 04             	sub    $0x4,%esp
  8012ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012f3:	eb 12                	jmp    801307 <strchr+0x20>
		if (*s == c)
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	8a 00                	mov    (%eax),%al
  8012fa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012fd:	75 05                	jne    801304 <strchr+0x1d>
			return (char *) s;
  8012ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801302:	eb 11                	jmp    801315 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801304:	ff 45 08             	incl   0x8(%ebp)
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	84 c0                	test   %al,%al
  80130e:	75 e5                	jne    8012f5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801310:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801315:	c9                   	leave  
  801316:	c3                   	ret    

00801317 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
  80131a:	83 ec 04             	sub    $0x4,%esp
  80131d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801320:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801323:	eb 0d                	jmp    801332 <strfind+0x1b>
		if (*s == c)
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
  801328:	8a 00                	mov    (%eax),%al
  80132a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80132d:	74 0e                	je     80133d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80132f:	ff 45 08             	incl   0x8(%ebp)
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	8a 00                	mov    (%eax),%al
  801337:	84 c0                	test   %al,%al
  801339:	75 ea                	jne    801325 <strfind+0xe>
  80133b:	eb 01                	jmp    80133e <strfind+0x27>
		if (*s == c)
			break;
  80133d:	90                   	nop
	return (char *) s;
  80133e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801341:	c9                   	leave  
  801342:	c3                   	ret    

00801343 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
  801346:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80134f:	8b 45 10             	mov    0x10(%ebp),%eax
  801352:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801355:	eb 0e                	jmp    801365 <memset+0x22>
		*p++ = c;
  801357:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80135a:	8d 50 01             	lea    0x1(%eax),%edx
  80135d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801360:	8b 55 0c             	mov    0xc(%ebp),%edx
  801363:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801365:	ff 4d f8             	decl   -0x8(%ebp)
  801368:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80136c:	79 e9                	jns    801357 <memset+0x14>
		*p++ = c;

	return v;
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801379:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801385:	eb 16                	jmp    80139d <memcpy+0x2a>
		*d++ = *s++;
  801387:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138a:	8d 50 01             	lea    0x1(%eax),%edx
  80138d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801390:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801393:	8d 4a 01             	lea    0x1(%edx),%ecx
  801396:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801399:	8a 12                	mov    (%edx),%dl
  80139b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80139d:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013a3:	89 55 10             	mov    %edx,0x10(%ebp)
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	75 dd                	jne    801387 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013ad:	c9                   	leave  
  8013ae:	c3                   	ret    

008013af <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8013af:	55                   	push   %ebp
  8013b0:	89 e5                	mov    %esp,%ebp
  8013b2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8013b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8013c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013c7:	73 50                	jae    801419 <memmove+0x6a>
  8013c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cf:	01 d0                	add    %edx,%eax
  8013d1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013d4:	76 43                	jbe    801419 <memmove+0x6a>
		s += n;
  8013d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d9:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8013dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8013df:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8013e2:	eb 10                	jmp    8013f4 <memmove+0x45>
			*--d = *--s;
  8013e4:	ff 4d f8             	decl   -0x8(%ebp)
  8013e7:	ff 4d fc             	decl   -0x4(%ebp)
  8013ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ed:	8a 10                	mov    (%eax),%dl
  8013ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8013f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013fa:	89 55 10             	mov    %edx,0x10(%ebp)
  8013fd:	85 c0                	test   %eax,%eax
  8013ff:	75 e3                	jne    8013e4 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801401:	eb 23                	jmp    801426 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801403:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801406:	8d 50 01             	lea    0x1(%eax),%edx
  801409:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80140c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80140f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801412:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801415:	8a 12                	mov    (%edx),%dl
  801417:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801419:	8b 45 10             	mov    0x10(%ebp),%eax
  80141c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80141f:	89 55 10             	mov    %edx,0x10(%ebp)
  801422:	85 c0                	test   %eax,%eax
  801424:	75 dd                	jne    801403 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801426:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801429:	c9                   	leave  
  80142a:	c3                   	ret    

0080142b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
  80142e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801437:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80143d:	eb 2a                	jmp    801469 <memcmp+0x3e>
		if (*s1 != *s2)
  80143f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801442:	8a 10                	mov    (%eax),%dl
  801444:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801447:	8a 00                	mov    (%eax),%al
  801449:	38 c2                	cmp    %al,%dl
  80144b:	74 16                	je     801463 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80144d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801450:	8a 00                	mov    (%eax),%al
  801452:	0f b6 d0             	movzbl %al,%edx
  801455:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801458:	8a 00                	mov    (%eax),%al
  80145a:	0f b6 c0             	movzbl %al,%eax
  80145d:	29 c2                	sub    %eax,%edx
  80145f:	89 d0                	mov    %edx,%eax
  801461:	eb 18                	jmp    80147b <memcmp+0x50>
		s1++, s2++;
  801463:	ff 45 fc             	incl   -0x4(%ebp)
  801466:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801469:	8b 45 10             	mov    0x10(%ebp),%eax
  80146c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80146f:	89 55 10             	mov    %edx,0x10(%ebp)
  801472:	85 c0                	test   %eax,%eax
  801474:	75 c9                	jne    80143f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801476:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147b:	c9                   	leave  
  80147c:	c3                   	ret    

0080147d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
  801480:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801483:	8b 55 08             	mov    0x8(%ebp),%edx
  801486:	8b 45 10             	mov    0x10(%ebp),%eax
  801489:	01 d0                	add    %edx,%eax
  80148b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80148e:	eb 15                	jmp    8014a5 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	8a 00                	mov    (%eax),%al
  801495:	0f b6 d0             	movzbl %al,%edx
  801498:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149b:	0f b6 c0             	movzbl %al,%eax
  80149e:	39 c2                	cmp    %eax,%edx
  8014a0:	74 0d                	je     8014af <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8014a2:	ff 45 08             	incl   0x8(%ebp)
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014ab:	72 e3                	jb     801490 <memfind+0x13>
  8014ad:	eb 01                	jmp    8014b0 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8014af:	90                   	nop
	return (void *) s;
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    

008014b5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8014bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8014c2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014c9:	eb 03                	jmp    8014ce <strtol+0x19>
		s++;
  8014cb:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	8a 00                	mov    (%eax),%al
  8014d3:	3c 20                	cmp    $0x20,%al
  8014d5:	74 f4                	je     8014cb <strtol+0x16>
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	8a 00                	mov    (%eax),%al
  8014dc:	3c 09                	cmp    $0x9,%al
  8014de:	74 eb                	je     8014cb <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	8a 00                	mov    (%eax),%al
  8014e5:	3c 2b                	cmp    $0x2b,%al
  8014e7:	75 05                	jne    8014ee <strtol+0x39>
		s++;
  8014e9:	ff 45 08             	incl   0x8(%ebp)
  8014ec:	eb 13                	jmp    801501 <strtol+0x4c>
	else if (*s == '-')
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	8a 00                	mov    (%eax),%al
  8014f3:	3c 2d                	cmp    $0x2d,%al
  8014f5:	75 0a                	jne    801501 <strtol+0x4c>
		s++, neg = 1;
  8014f7:	ff 45 08             	incl   0x8(%ebp)
  8014fa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801501:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801505:	74 06                	je     80150d <strtol+0x58>
  801507:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80150b:	75 20                	jne    80152d <strtol+0x78>
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	8a 00                	mov    (%eax),%al
  801512:	3c 30                	cmp    $0x30,%al
  801514:	75 17                	jne    80152d <strtol+0x78>
  801516:	8b 45 08             	mov    0x8(%ebp),%eax
  801519:	40                   	inc    %eax
  80151a:	8a 00                	mov    (%eax),%al
  80151c:	3c 78                	cmp    $0x78,%al
  80151e:	75 0d                	jne    80152d <strtol+0x78>
		s += 2, base = 16;
  801520:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801524:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80152b:	eb 28                	jmp    801555 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80152d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801531:	75 15                	jne    801548 <strtol+0x93>
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	8a 00                	mov    (%eax),%al
  801538:	3c 30                	cmp    $0x30,%al
  80153a:	75 0c                	jne    801548 <strtol+0x93>
		s++, base = 8;
  80153c:	ff 45 08             	incl   0x8(%ebp)
  80153f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801546:	eb 0d                	jmp    801555 <strtol+0xa0>
	else if (base == 0)
  801548:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80154c:	75 07                	jne    801555 <strtol+0xa0>
		base = 10;
  80154e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801555:	8b 45 08             	mov    0x8(%ebp),%eax
  801558:	8a 00                	mov    (%eax),%al
  80155a:	3c 2f                	cmp    $0x2f,%al
  80155c:	7e 19                	jle    801577 <strtol+0xc2>
  80155e:	8b 45 08             	mov    0x8(%ebp),%eax
  801561:	8a 00                	mov    (%eax),%al
  801563:	3c 39                	cmp    $0x39,%al
  801565:	7f 10                	jg     801577 <strtol+0xc2>
			dig = *s - '0';
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	8a 00                	mov    (%eax),%al
  80156c:	0f be c0             	movsbl %al,%eax
  80156f:	83 e8 30             	sub    $0x30,%eax
  801572:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801575:	eb 42                	jmp    8015b9 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	8a 00                	mov    (%eax),%al
  80157c:	3c 60                	cmp    $0x60,%al
  80157e:	7e 19                	jle    801599 <strtol+0xe4>
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	8a 00                	mov    (%eax),%al
  801585:	3c 7a                	cmp    $0x7a,%al
  801587:	7f 10                	jg     801599 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
  80158c:	8a 00                	mov    (%eax),%al
  80158e:	0f be c0             	movsbl %al,%eax
  801591:	83 e8 57             	sub    $0x57,%eax
  801594:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801597:	eb 20                	jmp    8015b9 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	8a 00                	mov    (%eax),%al
  80159e:	3c 40                	cmp    $0x40,%al
  8015a0:	7e 39                	jle    8015db <strtol+0x126>
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	8a 00                	mov    (%eax),%al
  8015a7:	3c 5a                	cmp    $0x5a,%al
  8015a9:	7f 30                	jg     8015db <strtol+0x126>
			dig = *s - 'A' + 10;
  8015ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ae:	8a 00                	mov    (%eax),%al
  8015b0:	0f be c0             	movsbl %al,%eax
  8015b3:	83 e8 37             	sub    $0x37,%eax
  8015b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8015b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8015bf:	7d 19                	jge    8015da <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8015c1:	ff 45 08             	incl   0x8(%ebp)
  8015c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015c7:	0f af 45 10          	imul   0x10(%ebp),%eax
  8015cb:	89 c2                	mov    %eax,%edx
  8015cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d0:	01 d0                	add    %edx,%eax
  8015d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8015d5:	e9 7b ff ff ff       	jmp    801555 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015da:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8015db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015df:	74 08                	je     8015e9 <strtol+0x134>
		*endptr = (char *) s;
  8015e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8015e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015ed:	74 07                	je     8015f6 <strtol+0x141>
  8015ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015f2:	f7 d8                	neg    %eax
  8015f4:	eb 03                	jmp    8015f9 <strtol+0x144>
  8015f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    

008015fb <ltostr>:

void
ltostr(long value, char *str)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801601:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801608:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80160f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801613:	79 13                	jns    801628 <ltostr+0x2d>
	{
		neg = 1;
  801615:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80161c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801622:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801625:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801630:	99                   	cltd   
  801631:	f7 f9                	idiv   %ecx
  801633:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801636:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801639:	8d 50 01             	lea    0x1(%eax),%edx
  80163c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80163f:	89 c2                	mov    %eax,%edx
  801641:	8b 45 0c             	mov    0xc(%ebp),%eax
  801644:	01 d0                	add    %edx,%eax
  801646:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801649:	83 c2 30             	add    $0x30,%edx
  80164c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80164e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801651:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801656:	f7 e9                	imul   %ecx
  801658:	c1 fa 02             	sar    $0x2,%edx
  80165b:	89 c8                	mov    %ecx,%eax
  80165d:	c1 f8 1f             	sar    $0x1f,%eax
  801660:	29 c2                	sub    %eax,%edx
  801662:	89 d0                	mov    %edx,%eax
  801664:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801667:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80166b:	75 bb                	jne    801628 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80166d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801674:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801677:	48                   	dec    %eax
  801678:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80167b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80167f:	74 3d                	je     8016be <ltostr+0xc3>
		start = 1 ;
  801681:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801688:	eb 34                	jmp    8016be <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80168a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80168d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801690:	01 d0                	add    %edx,%eax
  801692:	8a 00                	mov    (%eax),%al
  801694:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801697:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80169a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80169d:	01 c2                	add    %eax,%edx
  80169f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8016a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a5:	01 c8                	add    %ecx,%eax
  8016a7:	8a 00                	mov    (%eax),%al
  8016a9:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8016ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b1:	01 c2                	add    %eax,%edx
  8016b3:	8a 45 eb             	mov    -0x15(%ebp),%al
  8016b6:	88 02                	mov    %al,(%edx)
		start++ ;
  8016b8:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8016bb:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8016be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016c4:	7c c4                	jl     80168a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8016c6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8016c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cc:	01 d0                	add    %edx,%eax
  8016ce:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8016d1:	90                   	nop
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
  8016d7:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8016da:	ff 75 08             	pushl  0x8(%ebp)
  8016dd:	e8 73 fa ff ff       	call   801155 <strlen>
  8016e2:	83 c4 04             	add    $0x4,%esp
  8016e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8016e8:	ff 75 0c             	pushl  0xc(%ebp)
  8016eb:	e8 65 fa ff ff       	call   801155 <strlen>
  8016f0:	83 c4 04             	add    $0x4,%esp
  8016f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801704:	eb 17                	jmp    80171d <strcconcat+0x49>
		final[s] = str1[s] ;
  801706:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801709:	8b 45 10             	mov    0x10(%ebp),%eax
  80170c:	01 c2                	add    %eax,%edx
  80170e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	01 c8                	add    %ecx,%eax
  801716:	8a 00                	mov    (%eax),%al
  801718:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80171a:	ff 45 fc             	incl   -0x4(%ebp)
  80171d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801720:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801723:	7c e1                	jl     801706 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801725:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80172c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801733:	eb 1f                	jmp    801754 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801735:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801738:	8d 50 01             	lea    0x1(%eax),%edx
  80173b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80173e:	89 c2                	mov    %eax,%edx
  801740:	8b 45 10             	mov    0x10(%ebp),%eax
  801743:	01 c2                	add    %eax,%edx
  801745:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801748:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174b:	01 c8                	add    %ecx,%eax
  80174d:	8a 00                	mov    (%eax),%al
  80174f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801751:	ff 45 f8             	incl   -0x8(%ebp)
  801754:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801757:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80175a:	7c d9                	jl     801735 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80175c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80175f:	8b 45 10             	mov    0x10(%ebp),%eax
  801762:	01 d0                	add    %edx,%eax
  801764:	c6 00 00             	movb   $0x0,(%eax)
}
  801767:	90                   	nop
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80176d:	8b 45 14             	mov    0x14(%ebp),%eax
  801770:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801776:	8b 45 14             	mov    0x14(%ebp),%eax
  801779:	8b 00                	mov    (%eax),%eax
  80177b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801782:	8b 45 10             	mov    0x10(%ebp),%eax
  801785:	01 d0                	add    %edx,%eax
  801787:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80178d:	eb 0c                	jmp    80179b <strsplit+0x31>
			*string++ = 0;
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	8d 50 01             	lea    0x1(%eax),%edx
  801795:	89 55 08             	mov    %edx,0x8(%ebp)
  801798:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	8a 00                	mov    (%eax),%al
  8017a0:	84 c0                	test   %al,%al
  8017a2:	74 18                	je     8017bc <strsplit+0x52>
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	8a 00                	mov    (%eax),%al
  8017a9:	0f be c0             	movsbl %al,%eax
  8017ac:	50                   	push   %eax
  8017ad:	ff 75 0c             	pushl  0xc(%ebp)
  8017b0:	e8 32 fb ff ff       	call   8012e7 <strchr>
  8017b5:	83 c4 08             	add    $0x8,%esp
  8017b8:	85 c0                	test   %eax,%eax
  8017ba:	75 d3                	jne    80178f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8017bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bf:	8a 00                	mov    (%eax),%al
  8017c1:	84 c0                	test   %al,%al
  8017c3:	74 5a                	je     80181f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8017c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c8:	8b 00                	mov    (%eax),%eax
  8017ca:	83 f8 0f             	cmp    $0xf,%eax
  8017cd:	75 07                	jne    8017d6 <strsplit+0x6c>
		{
			return 0;
  8017cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d4:	eb 66                	jmp    80183c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8017d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8017d9:	8b 00                	mov    (%eax),%eax
  8017db:	8d 48 01             	lea    0x1(%eax),%ecx
  8017de:	8b 55 14             	mov    0x14(%ebp),%edx
  8017e1:	89 0a                	mov    %ecx,(%edx)
  8017e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ed:	01 c2                	add    %eax,%edx
  8017ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017f4:	eb 03                	jmp    8017f9 <strsplit+0x8f>
			string++;
  8017f6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fc:	8a 00                	mov    (%eax),%al
  8017fe:	84 c0                	test   %al,%al
  801800:	74 8b                	je     80178d <strsplit+0x23>
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	8a 00                	mov    (%eax),%al
  801807:	0f be c0             	movsbl %al,%eax
  80180a:	50                   	push   %eax
  80180b:	ff 75 0c             	pushl  0xc(%ebp)
  80180e:	e8 d4 fa ff ff       	call   8012e7 <strchr>
  801813:	83 c4 08             	add    $0x8,%esp
  801816:	85 c0                	test   %eax,%eax
  801818:	74 dc                	je     8017f6 <strsplit+0x8c>
			string++;
	}
  80181a:	e9 6e ff ff ff       	jmp    80178d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80181f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801820:	8b 45 14             	mov    0x14(%ebp),%eax
  801823:	8b 00                	mov    (%eax),%eax
  801825:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80182c:	8b 45 10             	mov    0x10(%ebp),%eax
  80182f:	01 d0                	add    %edx,%eax
  801831:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801837:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801844:	83 ec 04             	sub    $0x4,%esp
  801847:	68 88 44 80 00       	push   $0x804488
  80184c:	68 3f 01 00 00       	push   $0x13f
  801851:	68 aa 44 80 00       	push   $0x8044aa
  801856:	e8 a9 ef ff ff       	call   800804 <_panic>

0080185b <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801861:	83 ec 0c             	sub    $0xc,%esp
  801864:	ff 75 08             	pushl  0x8(%ebp)
  801867:	e8 90 0c 00 00       	call   8024fc <sys_sbrk>
  80186c:	83 c4 10             	add    $0x10,%esp
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801877:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80187b:	75 0a                	jne    801887 <malloc+0x16>
		return NULL;
  80187d:	b8 00 00 00 00       	mov    $0x0,%eax
  801882:	e9 9e 01 00 00       	jmp    801a25 <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801887:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80188e:	77 2c                	ja     8018bc <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801890:	e8 eb 0a 00 00       	call   802380 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801895:	85 c0                	test   %eax,%eax
  801897:	74 19                	je     8018b2 <malloc+0x41>

			void * block = alloc_block_FF(size);
  801899:	83 ec 0c             	sub    $0xc,%esp
  80189c:	ff 75 08             	pushl  0x8(%ebp)
  80189f:	e8 85 11 00 00       	call   802a29 <alloc_block_FF>
  8018a4:	83 c4 10             	add    $0x10,%esp
  8018a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  8018aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018ad:	e9 73 01 00 00       	jmp    801a25 <malloc+0x1b4>
		} else {
			return NULL;
  8018b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b7:	e9 69 01 00 00       	jmp    801a25 <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8018bc:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8018c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8018c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018c9:	01 d0                	add    %edx,%eax
  8018cb:	48                   	dec    %eax
  8018cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8018cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d7:	f7 75 e0             	divl   -0x20(%ebp)
  8018da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018dd:	29 d0                	sub    %edx,%eax
  8018df:	c1 e8 0c             	shr    $0xc,%eax
  8018e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  8018e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8018ec:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8018f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8018f8:	8b 40 7c             	mov    0x7c(%eax),%eax
  8018fb:	05 00 10 00 00       	add    $0x1000,%eax
  801900:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801903:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801908:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80190b:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  80190e:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801915:	8b 55 08             	mov    0x8(%ebp),%edx
  801918:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80191b:	01 d0                	add    %edx,%eax
  80191d:	48                   	dec    %eax
  80191e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801921:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801924:	ba 00 00 00 00       	mov    $0x0,%edx
  801929:	f7 75 cc             	divl   -0x34(%ebp)
  80192c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80192f:	29 d0                	sub    %edx,%eax
  801931:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801934:	76 0a                	jbe    801940 <malloc+0xcf>
		return NULL;
  801936:	b8 00 00 00 00       	mov    $0x0,%eax
  80193b:	e9 e5 00 00 00       	jmp    801a25 <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801940:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801943:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801946:	eb 48                	jmp    801990 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  801948:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80194b:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80194e:	c1 e8 0c             	shr    $0xc,%eax
  801951:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801954:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801957:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  80195e:	85 c0                	test   %eax,%eax
  801960:	75 11                	jne    801973 <malloc+0x102>
			freePagesCount++;
  801962:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801965:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801969:	75 16                	jne    801981 <malloc+0x110>
				start = i;
  80196b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80196e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801971:	eb 0e                	jmp    801981 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801973:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80197a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801984:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801987:	74 12                	je     80199b <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801989:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801990:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801997:	76 af                	jbe    801948 <malloc+0xd7>
  801999:	eb 01                	jmp    80199c <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  80199b:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  80199c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8019a0:	74 08                	je     8019aa <malloc+0x139>
  8019a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a5:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8019a8:	74 07                	je     8019b1 <malloc+0x140>
		return NULL;
  8019aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8019af:	eb 74                	jmp    801a25 <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8019b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b4:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8019b7:	c1 e8 0c             	shr    $0xc,%eax
  8019ba:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  8019bd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019c0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8019c3:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  8019ca:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8019cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8019d0:	eb 11                	jmp    8019e3 <malloc+0x172>
		markedPages[i] = 1;
  8019d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019d5:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  8019dc:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  8019e0:	ff 45 e8             	incl   -0x18(%ebp)
  8019e3:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8019e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019e9:	01 d0                	add    %edx,%eax
  8019eb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8019ee:	77 e2                	ja     8019d2 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  8019f0:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8019f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8019fa:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8019fd:	01 d0                	add    %edx,%eax
  8019ff:	48                   	dec    %eax
  801a00:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801a03:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801a06:	ba 00 00 00 00       	mov    $0x0,%edx
  801a0b:	f7 75 bc             	divl   -0x44(%ebp)
  801a0e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801a11:	29 d0                	sub    %edx,%eax
  801a13:	83 ec 08             	sub    $0x8,%esp
  801a16:	50                   	push   %eax
  801a17:	ff 75 f0             	pushl  -0x10(%ebp)
  801a1a:	e8 14 0b 00 00       	call   802533 <sys_allocate_user_mem>
  801a1f:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  801a22:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
  801a2a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801a2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a31:	0f 84 ee 00 00 00    	je     801b25 <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801a37:	a1 20 50 80 00       	mov    0x805020,%eax
  801a3c:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801a3f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a42:	77 09                	ja     801a4d <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801a44:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801a4b:	76 14                	jbe    801a61 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801a4d:	83 ec 04             	sub    $0x4,%esp
  801a50:	68 b8 44 80 00       	push   $0x8044b8
  801a55:	6a 68                	push   $0x68
  801a57:	68 d2 44 80 00       	push   $0x8044d2
  801a5c:	e8 a3 ed ff ff       	call   800804 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  801a61:	a1 20 50 80 00       	mov    0x805020,%eax
  801a66:	8b 40 74             	mov    0x74(%eax),%eax
  801a69:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a6c:	77 20                	ja     801a8e <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801a6e:	a1 20 50 80 00       	mov    0x805020,%eax
  801a73:	8b 40 78             	mov    0x78(%eax),%eax
  801a76:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a79:	76 13                	jbe    801a8e <free+0x67>
		free_block(virtual_address);
  801a7b:	83 ec 0c             	sub    $0xc,%esp
  801a7e:	ff 75 08             	pushl  0x8(%ebp)
  801a81:	e8 6c 16 00 00       	call   8030f2 <free_block>
  801a86:	83 c4 10             	add    $0x10,%esp
		return;
  801a89:	e9 98 00 00 00       	jmp    801b26 <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801a8e:	8b 55 08             	mov    0x8(%ebp),%edx
  801a91:	a1 20 50 80 00       	mov    0x805020,%eax
  801a96:	8b 40 7c             	mov    0x7c(%eax),%eax
  801a99:	29 c2                	sub    %eax,%edx
  801a9b:	89 d0                	mov    %edx,%eax
  801a9d:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801aa2:	c1 e8 0c             	shr    $0xc,%eax
  801aa5:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801aa8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801aaf:	eb 16                	jmp    801ac7 <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801ab1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ab4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ab7:	01 d0                	add    %edx,%eax
  801ab9:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  801ac0:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801ac4:	ff 45 f4             	incl   -0xc(%ebp)
  801ac7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aca:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801ad1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801ad4:	7f db                	jg     801ab1 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  801ad6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ad9:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801ae0:	c1 e0 0c             	shl    $0xc,%eax
  801ae3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801aec:	eb 1a                	jmp    801b08 <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801aee:	83 ec 08             	sub    $0x8,%esp
  801af1:	68 00 10 00 00       	push   $0x1000
  801af6:	ff 75 f0             	pushl  -0x10(%ebp)
  801af9:	e8 19 0a 00 00       	call   802517 <sys_free_user_mem>
  801afe:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801b01:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801b08:	8b 55 08             	mov    0x8(%ebp),%edx
  801b0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b0e:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801b10:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b13:	77 d9                	ja     801aee <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801b15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b18:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  801b1f:	00 00 00 00 
  801b23:	eb 01                	jmp    801b26 <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  801b25:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
  801b2b:	83 ec 58             	sub    $0x58,%esp
  801b2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b31:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801b34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b38:	75 0a                	jne    801b44 <smalloc+0x1c>
		return NULL;
  801b3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3f:	e9 7d 01 00 00       	jmp    801cc1 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801b44:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801b4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b51:	01 d0                	add    %edx,%eax
  801b53:	48                   	dec    %eax
  801b54:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801b57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b5a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5f:	f7 75 e4             	divl   -0x1c(%ebp)
  801b62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b65:	29 d0                	sub    %edx,%eax
  801b67:	c1 e8 0c             	shr    $0xc,%eax
  801b6a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801b6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801b74:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801b7b:	a1 20 50 80 00       	mov    0x805020,%eax
  801b80:	8b 40 7c             	mov    0x7c(%eax),%eax
  801b83:	05 00 10 00 00       	add    $0x1000,%eax
  801b88:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801b8b:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801b90:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801b93:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801b96:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801b9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ba3:	01 d0                	add    %edx,%eax
  801ba5:	48                   	dec    %eax
  801ba6:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801ba9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801bac:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb1:	f7 75 d0             	divl   -0x30(%ebp)
  801bb4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801bb7:	29 d0                	sub    %edx,%eax
  801bb9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801bbc:	76 0a                	jbe    801bc8 <smalloc+0xa0>
		return NULL;
  801bbe:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc3:	e9 f9 00 00 00       	jmp    801cc1 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801bc8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bcb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bce:	eb 48                	jmp    801c18 <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bd3:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801bd6:	c1 e8 0c             	shr    $0xc,%eax
  801bd9:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801bdc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801bdf:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801be6:	85 c0                	test   %eax,%eax
  801be8:	75 11                	jne    801bfb <smalloc+0xd3>
			freePagesCount++;
  801bea:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801bed:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801bf1:	75 16                	jne    801c09 <smalloc+0xe1>
				start = s;
  801bf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801bf9:	eb 0e                	jmp    801c09 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  801bfb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801c02:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  801c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801c0f:	74 12                	je     801c23 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801c11:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801c18:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801c1f:	76 af                	jbe    801bd0 <smalloc+0xa8>
  801c21:	eb 01                	jmp    801c24 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  801c23:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  801c24:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801c28:	74 08                	je     801c32 <smalloc+0x10a>
  801c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801c30:	74 0a                	je     801c3c <smalloc+0x114>
		return NULL;
  801c32:	b8 00 00 00 00       	mov    $0x0,%eax
  801c37:	e9 85 00 00 00       	jmp    801cc1 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c3f:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801c42:	c1 e8 0c             	shr    $0xc,%eax
  801c45:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  801c48:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801c4b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801c4e:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801c55:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801c58:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801c5b:	eb 11                	jmp    801c6e <smalloc+0x146>
		markedPages[s] = 1;
  801c5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c60:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801c67:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801c6b:	ff 45 e8             	incl   -0x18(%ebp)
  801c6e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801c71:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c74:	01 d0                	add    %edx,%eax
  801c76:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801c79:	77 e2                	ja     801c5d <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  801c7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c7e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801c82:	52                   	push   %edx
  801c83:	50                   	push   %eax
  801c84:	ff 75 0c             	pushl  0xc(%ebp)
  801c87:	ff 75 08             	pushl  0x8(%ebp)
  801c8a:	e8 8f 04 00 00       	call   80211e <sys_createSharedObject>
  801c8f:	83 c4 10             	add    $0x10,%esp
  801c92:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  801c95:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  801c99:	78 12                	js     801cad <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  801c9b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801c9e:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801ca1:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801ca8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cab:	eb 14                	jmp    801cc1 <smalloc+0x199>
	}
	free((void*) start);
  801cad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb0:	83 ec 0c             	sub    $0xc,%esp
  801cb3:	50                   	push   %eax
  801cb4:	e8 6e fd ff ff       	call   801a27 <free>
  801cb9:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801cbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  801cc9:	83 ec 08             	sub    $0x8,%esp
  801ccc:	ff 75 0c             	pushl  0xc(%ebp)
  801ccf:	ff 75 08             	pushl  0x8(%ebp)
  801cd2:	e8 71 04 00 00       	call   802148 <sys_getSizeOfSharedObject>
  801cd7:	83 c4 10             	add    $0x10,%esp
  801cda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801cdd:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801ce4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ce7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cea:	01 d0                	add    %edx,%eax
  801cec:	48                   	dec    %eax
  801ced:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801cf0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cf3:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf8:	f7 75 e0             	divl   -0x20(%ebp)
  801cfb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cfe:	29 d0                	sub    %edx,%eax
  801d00:	c1 e8 0c             	shr    $0xc,%eax
  801d03:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  801d06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801d0d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  801d14:	a1 20 50 80 00       	mov    0x805020,%eax
  801d19:	8b 40 7c             	mov    0x7c(%eax),%eax
  801d1c:	05 00 10 00 00       	add    $0x1000,%eax
  801d21:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  801d24:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801d29:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801d2c:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801d2f:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801d36:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d39:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801d3c:	01 d0                	add    %edx,%eax
  801d3e:	48                   	dec    %eax
  801d3f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801d42:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d45:	ba 00 00 00 00       	mov    $0x0,%edx
  801d4a:	f7 75 cc             	divl   -0x34(%ebp)
  801d4d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d50:	29 d0                	sub    %edx,%eax
  801d52:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801d55:	76 0a                	jbe    801d61 <sget+0x9e>
		return NULL;
  801d57:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5c:	e9 f7 00 00 00       	jmp    801e58 <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801d61:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d67:	eb 48                	jmp    801db1 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  801d69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d6c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801d6f:	c1 e8 0c             	shr    $0xc,%eax
  801d72:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  801d75:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801d78:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801d7f:	85 c0                	test   %eax,%eax
  801d81:	75 11                	jne    801d94 <sget+0xd1>
			free_Pages_Count++;
  801d83:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801d86:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801d8a:	75 16                	jne    801da2 <sget+0xdf>
				start = s;
  801d8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d92:	eb 0e                	jmp    801da2 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  801d94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801d9b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  801da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da5:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801da8:	74 12                	je     801dbc <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801daa:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801db1:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801db8:	76 af                	jbe    801d69 <sget+0xa6>
  801dba:	eb 01                	jmp    801dbd <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  801dbc:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  801dbd:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801dc1:	74 08                	je     801dcb <sget+0x108>
  801dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc6:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801dc9:	74 0a                	je     801dd5 <sget+0x112>
		return NULL;
  801dcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd0:	e9 83 00 00 00       	jmp    801e58 <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  801dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd8:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801ddb:	c1 e8 0c             	shr    $0xc,%eax
  801dde:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  801de1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801de4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801de7:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801dee:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801df1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801df4:	eb 11                	jmp    801e07 <sget+0x144>
		markedPages[k] = 1;
  801df6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801df9:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801e00:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801e04:	ff 45 e8             	incl   -0x18(%ebp)
  801e07:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801e0a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e0d:	01 d0                	add    %edx,%eax
  801e0f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801e12:	77 e2                	ja     801df6 <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  801e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e17:	83 ec 04             	sub    $0x4,%esp
  801e1a:	50                   	push   %eax
  801e1b:	ff 75 0c             	pushl  0xc(%ebp)
  801e1e:	ff 75 08             	pushl  0x8(%ebp)
  801e21:	e8 3f 03 00 00       	call   802165 <sys_getSharedObject>
  801e26:	83 c4 10             	add    $0x10,%esp
  801e29:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  801e2c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  801e30:	78 12                	js     801e44 <sget+0x181>
		shardIDs[startPage] = ss;
  801e32:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e35:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801e38:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e42:	eb 14                	jmp    801e58 <sget+0x195>
	}
	free((void*) start);
  801e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e47:	83 ec 0c             	sub    $0xc,%esp
  801e4a:	50                   	push   %eax
  801e4b:	e8 d7 fb ff ff       	call   801a27 <free>
  801e50:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801e53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
  801e5d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801e60:	8b 55 08             	mov    0x8(%ebp),%edx
  801e63:	a1 20 50 80 00       	mov    0x805020,%eax
  801e68:	8b 40 7c             	mov    0x7c(%eax),%eax
  801e6b:	29 c2                	sub    %eax,%edx
  801e6d:	89 d0                	mov    %edx,%eax
  801e6f:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  801e74:	c1 e8 0c             	shr    $0xc,%eax
  801e77:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  801e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7d:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  801e84:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  801e87:	83 ec 08             	sub    $0x8,%esp
  801e8a:	ff 75 08             	pushl  0x8(%ebp)
  801e8d:	ff 75 f0             	pushl  -0x10(%ebp)
  801e90:	e8 ef 02 00 00       	call   802184 <sys_freeSharedObject>
  801e95:	83 c4 10             	add    $0x10,%esp
  801e98:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  801e9b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e9f:	75 0e                	jne    801eaf <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  801ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea4:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  801eab:	ff ff ff ff 
	}

}
  801eaf:	90                   	nop
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801eb8:	83 ec 04             	sub    $0x4,%esp
  801ebb:	68 e0 44 80 00       	push   $0x8044e0
  801ec0:	68 19 01 00 00       	push   $0x119
  801ec5:	68 d2 44 80 00       	push   $0x8044d2
  801eca:	e8 35 e9 ff ff       	call   800804 <_panic>

00801ecf <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ed5:	83 ec 04             	sub    $0x4,%esp
  801ed8:	68 06 45 80 00       	push   $0x804506
  801edd:	68 23 01 00 00       	push   $0x123
  801ee2:	68 d2 44 80 00       	push   $0x8044d2
  801ee7:	e8 18 e9 ff ff       	call   800804 <_panic>

00801eec <shrink>:

}
void shrink(uint32 newSize) {
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ef2:	83 ec 04             	sub    $0x4,%esp
  801ef5:	68 06 45 80 00       	push   $0x804506
  801efa:	68 27 01 00 00       	push   $0x127
  801eff:	68 d2 44 80 00       	push   $0x8044d2
  801f04:	e8 fb e8 ff ff       	call   800804 <_panic>

00801f09 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
  801f0c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f0f:	83 ec 04             	sub    $0x4,%esp
  801f12:	68 06 45 80 00       	push   $0x804506
  801f17:	68 2b 01 00 00       	push   $0x12b
  801f1c:	68 d2 44 80 00       	push   $0x8044d2
  801f21:	e8 de e8 ff ff       	call   800804 <_panic>

00801f26 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	57                   	push   %edi
  801f2a:	56                   	push   %esi
  801f2b:	53                   	push   %ebx
  801f2c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f35:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f38:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f3b:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f3e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f41:	cd 30                	int    $0x30
  801f43:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801f46:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f49:	83 c4 10             	add    $0x10,%esp
  801f4c:	5b                   	pop    %ebx
  801f4d:	5e                   	pop    %esi
  801f4e:	5f                   	pop    %edi
  801f4f:	5d                   	pop    %ebp
  801f50:	c3                   	ret    

00801f51 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
  801f54:	83 ec 04             	sub    $0x4,%esp
  801f57:	8b 45 10             	mov    0x10(%ebp),%eax
  801f5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801f5d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f61:	8b 45 08             	mov    0x8(%ebp),%eax
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	52                   	push   %edx
  801f69:	ff 75 0c             	pushl  0xc(%ebp)
  801f6c:	50                   	push   %eax
  801f6d:	6a 00                	push   $0x0
  801f6f:	e8 b2 ff ff ff       	call   801f26 <syscall>
  801f74:	83 c4 18             	add    $0x18,%esp
}
  801f77:	90                   	nop
  801f78:	c9                   	leave  
  801f79:	c3                   	ret    

00801f7a <sys_cgetc>:

int sys_cgetc(void) {
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 02                	push   $0x2
  801f89:	e8 98 ff ff ff       	call   801f26 <syscall>
  801f8e:	83 c4 18             	add    $0x18,%esp
}
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <sys_lock_cons>:

void sys_lock_cons(void) {
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 03                	push   $0x3
  801fa2:	e8 7f ff ff ff       	call   801f26 <syscall>
  801fa7:	83 c4 18             	add    $0x18,%esp
}
  801faa:	90                   	nop
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 04                	push   $0x4
  801fbc:	e8 65 ff ff ff       	call   801f26 <syscall>
  801fc1:	83 c4 18             	add    $0x18,%esp
}
  801fc4:	90                   	nop
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801fca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	52                   	push   %edx
  801fd7:	50                   	push   %eax
  801fd8:	6a 08                	push   $0x8
  801fda:	e8 47 ff ff ff       	call   801f26 <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	56                   	push   %esi
  801fe8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801fe9:	8b 75 18             	mov    0x18(%ebp),%esi
  801fec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ff2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff8:	56                   	push   %esi
  801ff9:	53                   	push   %ebx
  801ffa:	51                   	push   %ecx
  801ffb:	52                   	push   %edx
  801ffc:	50                   	push   %eax
  801ffd:	6a 09                	push   $0x9
  801fff:	e8 22 ff ff ff       	call   801f26 <syscall>
  802004:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  802007:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80200a:	5b                   	pop    %ebx
  80200b:	5e                   	pop    %esi
  80200c:	5d                   	pop    %ebp
  80200d:	c3                   	ret    

0080200e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802011:	8b 55 0c             	mov    0xc(%ebp),%edx
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	52                   	push   %edx
  80201e:	50                   	push   %eax
  80201f:	6a 0a                	push   $0xa
  802021:	e8 00 ff ff ff       	call   801f26 <syscall>
  802026:	83 c4 18             	add    $0x18,%esp
}
  802029:	c9                   	leave  
  80202a:	c3                   	ret    

0080202b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	ff 75 0c             	pushl  0xc(%ebp)
  802037:	ff 75 08             	pushl  0x8(%ebp)
  80203a:	6a 0b                	push   $0xb
  80203c:	e8 e5 fe ff ff       	call   801f26 <syscall>
  802041:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 0c                	push   $0xc
  802055:	e8 cc fe ff ff       	call   801f26 <syscall>
  80205a:	83 c4 18             	add    $0x18,%esp
}
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 0d                	push   $0xd
  80206e:	e8 b3 fe ff ff       	call   801f26 <syscall>
  802073:	83 c4 18             	add    $0x18,%esp
}
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 0e                	push   $0xe
  802087:	e8 9a fe ff ff       	call   801f26 <syscall>
  80208c:	83 c4 18             	add    $0x18,%esp
}
  80208f:	c9                   	leave  
  802090:	c3                   	ret    

00802091 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  802091:	55                   	push   %ebp
  802092:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 0f                	push   $0xf
  8020a0:	e8 81 fe ff ff       	call   801f26 <syscall>
  8020a5:	83 c4 18             	add    $0x18,%esp
}
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	ff 75 08             	pushl  0x8(%ebp)
  8020b8:	6a 10                	push   $0x10
  8020ba:	e8 67 fe ff ff       	call   801f26 <syscall>
  8020bf:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  8020c2:	c9                   	leave  
  8020c3:	c3                   	ret    

008020c4 <sys_scarce_memory>:

void sys_scarce_memory() {
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 11                	push   $0x11
  8020d3:	e8 4e fe ff ff       	call   801f26 <syscall>
  8020d8:	83 c4 18             	add    $0x18,%esp
}
  8020db:	90                   	nop
  8020dc:	c9                   	leave  
  8020dd:	c3                   	ret    

008020de <sys_cputc>:

void sys_cputc(const char c) {
  8020de:	55                   	push   %ebp
  8020df:	89 e5                	mov    %esp,%ebp
  8020e1:	83 ec 04             	sub    $0x4,%esp
  8020e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020ea:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	50                   	push   %eax
  8020f7:	6a 01                	push   $0x1
  8020f9:	e8 28 fe ff ff       	call   801f26 <syscall>
  8020fe:	83 c4 18             	add    $0x18,%esp
}
  802101:	90                   	nop
  802102:	c9                   	leave  
  802103:	c3                   	ret    

00802104 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 14                	push   $0x14
  802113:	e8 0e fe ff ff       	call   801f26 <syscall>
  802118:	83 c4 18             	add    $0x18,%esp
}
  80211b:	90                   	nop
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	83 ec 04             	sub    $0x4,%esp
  802124:	8b 45 10             	mov    0x10(%ebp),%eax
  802127:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  80212a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80212d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802131:	8b 45 08             	mov    0x8(%ebp),%eax
  802134:	6a 00                	push   $0x0
  802136:	51                   	push   %ecx
  802137:	52                   	push   %edx
  802138:	ff 75 0c             	pushl  0xc(%ebp)
  80213b:	50                   	push   %eax
  80213c:	6a 15                	push   $0x15
  80213e:	e8 e3 fd ff ff       	call   801f26 <syscall>
  802143:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  802146:	c9                   	leave  
  802147:	c3                   	ret    

00802148 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  80214b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	52                   	push   %edx
  802158:	50                   	push   %eax
  802159:	6a 16                	push   $0x16
  80215b:	e8 c6 fd ff ff       	call   801f26 <syscall>
  802160:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  802163:	c9                   	leave  
  802164:	c3                   	ret    

00802165 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  802168:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80216b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216e:	8b 45 08             	mov    0x8(%ebp),%eax
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	51                   	push   %ecx
  802176:	52                   	push   %edx
  802177:	50                   	push   %eax
  802178:	6a 17                	push   $0x17
  80217a:	e8 a7 fd ff ff       	call   801f26 <syscall>
  80217f:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  802187:	8b 55 0c             	mov    0xc(%ebp),%edx
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	52                   	push   %edx
  802194:	50                   	push   %eax
  802195:	6a 18                	push   $0x18
  802197:	e8 8a fd ff ff       	call   801f26 <syscall>
  80219c:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  8021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a7:	6a 00                	push   $0x0
  8021a9:	ff 75 14             	pushl  0x14(%ebp)
  8021ac:	ff 75 10             	pushl  0x10(%ebp)
  8021af:	ff 75 0c             	pushl  0xc(%ebp)
  8021b2:	50                   	push   %eax
  8021b3:	6a 19                	push   $0x19
  8021b5:	e8 6c fd ff ff       	call   801f26 <syscall>
  8021ba:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    

008021bf <sys_run_env>:

void sys_run_env(int32 envId) {
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  8021c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	50                   	push   %eax
  8021ce:	6a 1a                	push   $0x1a
  8021d0:	e8 51 fd ff ff       	call   801f26 <syscall>
  8021d5:	83 c4 18             	add    $0x18,%esp
}
  8021d8:	90                   	nop
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    

008021db <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	50                   	push   %eax
  8021ea:	6a 1b                	push   $0x1b
  8021ec:	e8 35 fd ff ff       	call   801f26 <syscall>
  8021f1:	83 c4 18             	add    $0x18,%esp
}
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <sys_getenvid>:

int32 sys_getenvid(void) {
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 05                	push   $0x5
  802205:	e8 1c fd ff ff       	call   801f26 <syscall>
  80220a:	83 c4 18             	add    $0x18,%esp
}
  80220d:	c9                   	leave  
  80220e:	c3                   	ret    

0080220f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 06                	push   $0x6
  80221e:	e8 03 fd ff ff       	call   801f26 <syscall>
  802223:	83 c4 18             	add    $0x18,%esp
}
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 07                	push   $0x7
  802237:	e8 ea fc ff ff       	call   801f26 <syscall>
  80223c:	83 c4 18             	add    $0x18,%esp
}
  80223f:	c9                   	leave  
  802240:	c3                   	ret    

00802241 <sys_exit_env>:

void sys_exit_env(void) {
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 1c                	push   $0x1c
  802250:	e8 d1 fc ff ff       	call   801f26 <syscall>
  802255:	83 c4 18             	add    $0x18,%esp
}
  802258:	90                   	nop
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  802261:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802264:	8d 50 04             	lea    0x4(%eax),%edx
  802267:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	52                   	push   %edx
  802271:	50                   	push   %eax
  802272:	6a 1d                	push   $0x1d
  802274:	e8 ad fc ff ff       	call   801f26 <syscall>
  802279:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  80227c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80227f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802282:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802285:	89 01                	mov    %eax,(%ecx)
  802287:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80228a:	8b 45 08             	mov    0x8(%ebp),%eax
  80228d:	c9                   	leave  
  80228e:	c2 04 00             	ret    $0x4

00802291 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	ff 75 10             	pushl  0x10(%ebp)
  80229b:	ff 75 0c             	pushl  0xc(%ebp)
  80229e:	ff 75 08             	pushl  0x8(%ebp)
  8022a1:	6a 13                	push   $0x13
  8022a3:	e8 7e fc ff ff       	call   801f26 <syscall>
  8022a8:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  8022ab:	90                   	nop
}
  8022ac:	c9                   	leave  
  8022ad:	c3                   	ret    

008022ae <sys_rcr2>:
uint32 sys_rcr2() {
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 1e                	push   $0x1e
  8022bd:	e8 64 fc ff ff       	call   801f26 <syscall>
  8022c2:	83 c4 18             	add    $0x18,%esp
}
  8022c5:	c9                   	leave  
  8022c6:	c3                   	ret    

008022c7 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
  8022ca:	83 ec 04             	sub    $0x4,%esp
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8022d3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	50                   	push   %eax
  8022e0:	6a 1f                	push   $0x1f
  8022e2:	e8 3f fc ff ff       	call   801f26 <syscall>
  8022e7:	83 c4 18             	add    $0x18,%esp
	return;
  8022ea:	90                   	nop
}
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    

008022ed <rsttst>:
void rsttst() {
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 21                	push   $0x21
  8022fc:	e8 25 fc ff ff       	call   801f26 <syscall>
  802301:	83 c4 18             	add    $0x18,%esp
	return;
  802304:	90                   	nop
}
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
  80230a:	83 ec 04             	sub    $0x4,%esp
  80230d:	8b 45 14             	mov    0x14(%ebp),%eax
  802310:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802313:	8b 55 18             	mov    0x18(%ebp),%edx
  802316:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80231a:	52                   	push   %edx
  80231b:	50                   	push   %eax
  80231c:	ff 75 10             	pushl  0x10(%ebp)
  80231f:	ff 75 0c             	pushl  0xc(%ebp)
  802322:	ff 75 08             	pushl  0x8(%ebp)
  802325:	6a 20                	push   $0x20
  802327:	e8 fa fb ff ff       	call   801f26 <syscall>
  80232c:	83 c4 18             	add    $0x18,%esp
	return;
  80232f:	90                   	nop
}
  802330:	c9                   	leave  
  802331:	c3                   	ret    

00802332 <chktst>:
void chktst(uint32 n) {
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802335:	6a 00                	push   $0x0
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	ff 75 08             	pushl  0x8(%ebp)
  802340:	6a 22                	push   $0x22
  802342:	e8 df fb ff ff       	call   801f26 <syscall>
  802347:	83 c4 18             	add    $0x18,%esp
	return;
  80234a:	90                   	nop
}
  80234b:	c9                   	leave  
  80234c:	c3                   	ret    

0080234d <inctst>:

void inctst() {
  80234d:	55                   	push   %ebp
  80234e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802350:	6a 00                	push   $0x0
  802352:	6a 00                	push   $0x0
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	6a 23                	push   $0x23
  80235c:	e8 c5 fb ff ff       	call   801f26 <syscall>
  802361:	83 c4 18             	add    $0x18,%esp
	return;
  802364:	90                   	nop
}
  802365:	c9                   	leave  
  802366:	c3                   	ret    

00802367 <gettst>:
uint32 gettst() {
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 24                	push   $0x24
  802376:	e8 ab fb ff ff       	call   801f26 <syscall>
  80237b:	83 c4 18             	add    $0x18,%esp
}
  80237e:	c9                   	leave  
  80237f:	c3                   	ret    

00802380 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
  802383:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	6a 00                	push   $0x0
  80238e:	6a 00                	push   $0x0
  802390:	6a 25                	push   $0x25
  802392:	e8 8f fb ff ff       	call   801f26 <syscall>
  802397:	83 c4 18             	add    $0x18,%esp
  80239a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80239d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023a1:	75 07                	jne    8023aa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a8:	eb 05                	jmp    8023af <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023af:	c9                   	leave  
  8023b0:	c3                   	ret    

008023b1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  8023b1:	55                   	push   %ebp
  8023b2:	89 e5                	mov    %esp,%ebp
  8023b4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 25                	push   $0x25
  8023c3:	e8 5e fb ff ff       	call   801f26 <syscall>
  8023c8:	83 c4 18             	add    $0x18,%esp
  8023cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8023ce:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8023d2:	75 07                	jne    8023db <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8023d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d9:	eb 05                	jmp    8023e0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8023db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023e0:	c9                   	leave  
  8023e1:	c3                   	ret    

008023e2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
  8023e5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 25                	push   $0x25
  8023f4:	e8 2d fb ff ff       	call   801f26 <syscall>
  8023f9:	83 c4 18             	add    $0x18,%esp
  8023fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8023ff:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802403:	75 07                	jne    80240c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802405:	b8 01 00 00 00       	mov    $0x1,%eax
  80240a:	eb 05                	jmp    802411 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80240c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802411:	c9                   	leave  
  802412:	c3                   	ret    

00802413 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  802413:	55                   	push   %ebp
  802414:	89 e5                	mov    %esp,%ebp
  802416:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	6a 25                	push   $0x25
  802425:	e8 fc fa ff ff       	call   801f26 <syscall>
  80242a:	83 c4 18             	add    $0x18,%esp
  80242d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802430:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802434:	75 07                	jne    80243d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802436:	b8 01 00 00 00       	mov    $0x1,%eax
  80243b:	eb 05                	jmp    802442 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80243d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802442:	c9                   	leave  
  802443:	c3                   	ret    

00802444 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  802444:	55                   	push   %ebp
  802445:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	ff 75 08             	pushl  0x8(%ebp)
  802452:	6a 26                	push   $0x26
  802454:	e8 cd fa ff ff       	call   801f26 <syscall>
  802459:	83 c4 18             	add    $0x18,%esp
	return;
  80245c:	90                   	nop
}
  80245d:	c9                   	leave  
  80245e:	c3                   	ret    

0080245f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  80245f:	55                   	push   %ebp
  802460:	89 e5                	mov    %esp,%ebp
  802462:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  802463:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802466:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80246c:	8b 45 08             	mov    0x8(%ebp),%eax
  80246f:	6a 00                	push   $0x0
  802471:	53                   	push   %ebx
  802472:	51                   	push   %ecx
  802473:	52                   	push   %edx
  802474:	50                   	push   %eax
  802475:	6a 27                	push   $0x27
  802477:	e8 aa fa ff ff       	call   801f26 <syscall>
  80247c:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  80247f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802482:	c9                   	leave  
  802483:	c3                   	ret    

00802484 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  802484:	55                   	push   %ebp
  802485:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  802487:	8b 55 0c             	mov    0xc(%ebp),%edx
  80248a:	8b 45 08             	mov    0x8(%ebp),%eax
  80248d:	6a 00                	push   $0x0
  80248f:	6a 00                	push   $0x0
  802491:	6a 00                	push   $0x0
  802493:	52                   	push   %edx
  802494:	50                   	push   %eax
  802495:	6a 28                	push   $0x28
  802497:	e8 8a fa ff ff       	call   801f26 <syscall>
  80249c:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  80249f:	c9                   	leave  
  8024a0:	c3                   	ret    

008024a1 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  8024a1:	55                   	push   %ebp
  8024a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  8024a4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ad:	6a 00                	push   $0x0
  8024af:	51                   	push   %ecx
  8024b0:	ff 75 10             	pushl  0x10(%ebp)
  8024b3:	52                   	push   %edx
  8024b4:	50                   	push   %eax
  8024b5:	6a 29                	push   $0x29
  8024b7:	e8 6a fa ff ff       	call   801f26 <syscall>
  8024bc:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  8024bf:	c9                   	leave  
  8024c0:	c3                   	ret    

008024c1 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  8024c1:	55                   	push   %ebp
  8024c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	ff 75 10             	pushl  0x10(%ebp)
  8024cb:	ff 75 0c             	pushl  0xc(%ebp)
  8024ce:	ff 75 08             	pushl  0x8(%ebp)
  8024d1:	6a 12                	push   $0x12
  8024d3:	e8 4e fa ff ff       	call   801f26 <syscall>
  8024d8:	83 c4 18             	add    $0x18,%esp
	return;
  8024db:	90                   	nop
}
  8024dc:	c9                   	leave  
  8024dd:	c3                   	ret    

008024de <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  8024de:	55                   	push   %ebp
  8024df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  8024e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 00                	push   $0x0
  8024eb:	6a 00                	push   $0x0
  8024ed:	52                   	push   %edx
  8024ee:	50                   	push   %eax
  8024ef:	6a 2a                	push   $0x2a
  8024f1:	e8 30 fa ff ff       	call   801f26 <syscall>
  8024f6:	83 c4 18             	add    $0x18,%esp
	return;
  8024f9:	90                   	nop
}
  8024fa:	c9                   	leave  
  8024fb:	c3                   	ret    

008024fc <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8024fc:	55                   	push   %ebp
  8024fd:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8024ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	6a 00                	push   $0x0
  802508:	6a 00                	push   $0x0
  80250a:	50                   	push   %eax
  80250b:	6a 2b                	push   $0x2b
  80250d:	e8 14 fa ff ff       	call   801f26 <syscall>
  802512:	83 c4 18             	add    $0x18,%esp
}
  802515:	c9                   	leave  
  802516:	c3                   	ret    

00802517 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  802517:	55                   	push   %ebp
  802518:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80251a:	6a 00                	push   $0x0
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	ff 75 0c             	pushl  0xc(%ebp)
  802523:	ff 75 08             	pushl  0x8(%ebp)
  802526:	6a 2c                	push   $0x2c
  802528:	e8 f9 f9 ff ff       	call   801f26 <syscall>
  80252d:	83 c4 18             	add    $0x18,%esp
	return;
  802530:	90                   	nop
}
  802531:	c9                   	leave  
  802532:	c3                   	ret    

00802533 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  802533:	55                   	push   %ebp
  802534:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 00                	push   $0x0
  80253c:	ff 75 0c             	pushl  0xc(%ebp)
  80253f:	ff 75 08             	pushl  0x8(%ebp)
  802542:	6a 2d                	push   $0x2d
  802544:	e8 dd f9 ff ff       	call   801f26 <syscall>
  802549:	83 c4 18             	add    $0x18,%esp
	return;
  80254c:	90                   	nop
}
  80254d:	c9                   	leave  
  80254e:	c3                   	ret    

0080254f <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  80254f:	55                   	push   %ebp
  802550:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  802552:	8b 45 08             	mov    0x8(%ebp),%eax
  802555:	6a 00                	push   $0x0
  802557:	6a 00                	push   $0x0
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	50                   	push   %eax
  80255e:	6a 2f                	push   $0x2f
  802560:	e8 c1 f9 ff ff       	call   801f26 <syscall>
  802565:	83 c4 18             	add    $0x18,%esp
	return;
  802568:	90                   	nop
}
  802569:	c9                   	leave  
  80256a:	c3                   	ret    

0080256b <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  80256b:	55                   	push   %ebp
  80256c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  80256e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802571:	8b 45 08             	mov    0x8(%ebp),%eax
  802574:	6a 00                	push   $0x0
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	52                   	push   %edx
  80257b:	50                   	push   %eax
  80257c:	6a 30                	push   $0x30
  80257e:	e8 a3 f9 ff ff       	call   801f26 <syscall>
  802583:	83 c4 18             	add    $0x18,%esp
	return;
  802586:	90                   	nop
}
  802587:	c9                   	leave  
  802588:	c3                   	ret    

00802589 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  802589:	55                   	push   %ebp
  80258a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  80258c:	8b 45 08             	mov    0x8(%ebp),%eax
  80258f:	6a 00                	push   $0x0
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	50                   	push   %eax
  802598:	6a 31                	push   $0x31
  80259a:	e8 87 f9 ff ff       	call   801f26 <syscall>
  80259f:	83 c4 18             	add    $0x18,%esp
	return;
  8025a2:	90                   	nop
}
  8025a3:	c9                   	leave  
  8025a4:	c3                   	ret    

008025a5 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  8025a5:	55                   	push   %ebp
  8025a6:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8025a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	52                   	push   %edx
  8025b5:	50                   	push   %eax
  8025b6:	6a 2e                	push   $0x2e
  8025b8:	e8 69 f9 ff ff       	call   801f26 <syscall>
  8025bd:	83 c4 18             	add    $0x18,%esp
    return;
  8025c0:	90                   	nop
}
  8025c1:	c9                   	leave  
  8025c2:	c3                   	ret    

008025c3 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8025c3:	55                   	push   %ebp
  8025c4:	89 e5                	mov    %esp,%ebp
  8025c6:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8025c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cc:	83 e8 04             	sub    $0x4,%eax
  8025cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8025d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025d5:	8b 00                	mov    (%eax),%eax
  8025d7:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8025da:	c9                   	leave  
  8025db:	c3                   	ret    

008025dc <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
  8025df:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8025e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e5:	83 e8 04             	sub    $0x4,%eax
  8025e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8025eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025ee:	8b 00                	mov    (%eax),%eax
  8025f0:	83 e0 01             	and    $0x1,%eax
  8025f3:	85 c0                	test   %eax,%eax
  8025f5:	0f 94 c0             	sete   %al
}
  8025f8:	c9                   	leave  
  8025f9:	c3                   	ret    

008025fa <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8025fa:	55                   	push   %ebp
  8025fb:	89 e5                	mov    %esp,%ebp
  8025fd:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802600:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802607:	8b 45 0c             	mov    0xc(%ebp),%eax
  80260a:	83 f8 02             	cmp    $0x2,%eax
  80260d:	74 2b                	je     80263a <alloc_block+0x40>
  80260f:	83 f8 02             	cmp    $0x2,%eax
  802612:	7f 07                	jg     80261b <alloc_block+0x21>
  802614:	83 f8 01             	cmp    $0x1,%eax
  802617:	74 0e                	je     802627 <alloc_block+0x2d>
  802619:	eb 58                	jmp    802673 <alloc_block+0x79>
  80261b:	83 f8 03             	cmp    $0x3,%eax
  80261e:	74 2d                	je     80264d <alloc_block+0x53>
  802620:	83 f8 04             	cmp    $0x4,%eax
  802623:	74 3b                	je     802660 <alloc_block+0x66>
  802625:	eb 4c                	jmp    802673 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802627:	83 ec 0c             	sub    $0xc,%esp
  80262a:	ff 75 08             	pushl  0x8(%ebp)
  80262d:	e8 f7 03 00 00       	call   802a29 <alloc_block_FF>
  802632:	83 c4 10             	add    $0x10,%esp
  802635:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802638:	eb 4a                	jmp    802684 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80263a:	83 ec 0c             	sub    $0xc,%esp
  80263d:	ff 75 08             	pushl  0x8(%ebp)
  802640:	e8 f0 11 00 00       	call   803835 <alloc_block_NF>
  802645:	83 c4 10             	add    $0x10,%esp
  802648:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80264b:	eb 37                	jmp    802684 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80264d:	83 ec 0c             	sub    $0xc,%esp
  802650:	ff 75 08             	pushl  0x8(%ebp)
  802653:	e8 08 08 00 00       	call   802e60 <alloc_block_BF>
  802658:	83 c4 10             	add    $0x10,%esp
  80265b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80265e:	eb 24                	jmp    802684 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802660:	83 ec 0c             	sub    $0xc,%esp
  802663:	ff 75 08             	pushl  0x8(%ebp)
  802666:	e8 ad 11 00 00       	call   803818 <alloc_block_WF>
  80266b:	83 c4 10             	add    $0x10,%esp
  80266e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802671:	eb 11                	jmp    802684 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802673:	83 ec 0c             	sub    $0xc,%esp
  802676:	68 18 45 80 00       	push   $0x804518
  80267b:	e8 41 e4 ff ff       	call   800ac1 <cprintf>
  802680:	83 c4 10             	add    $0x10,%esp
		break;
  802683:	90                   	nop
	}
	return va;
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802687:	c9                   	leave  
  802688:	c3                   	ret    

00802689 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802689:	55                   	push   %ebp
  80268a:	89 e5                	mov    %esp,%ebp
  80268c:	53                   	push   %ebx
  80268d:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802690:	83 ec 0c             	sub    $0xc,%esp
  802693:	68 38 45 80 00       	push   $0x804538
  802698:	e8 24 e4 ff ff       	call   800ac1 <cprintf>
  80269d:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8026a0:	83 ec 0c             	sub    $0xc,%esp
  8026a3:	68 63 45 80 00       	push   $0x804563
  8026a8:	e8 14 e4 ff ff       	call   800ac1 <cprintf>
  8026ad:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8026b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b6:	eb 37                	jmp    8026ef <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8026b8:	83 ec 0c             	sub    $0xc,%esp
  8026bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8026be:	e8 19 ff ff ff       	call   8025dc <is_free_block>
  8026c3:	83 c4 10             	add    $0x10,%esp
  8026c6:	0f be d8             	movsbl %al,%ebx
  8026c9:	83 ec 0c             	sub    $0xc,%esp
  8026cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8026cf:	e8 ef fe ff ff       	call   8025c3 <get_block_size>
  8026d4:	83 c4 10             	add    $0x10,%esp
  8026d7:	83 ec 04             	sub    $0x4,%esp
  8026da:	53                   	push   %ebx
  8026db:	50                   	push   %eax
  8026dc:	68 7b 45 80 00       	push   $0x80457b
  8026e1:	e8 db e3 ff ff       	call   800ac1 <cprintf>
  8026e6:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8026e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8026ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f3:	74 07                	je     8026fc <print_blocks_list+0x73>
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	8b 00                	mov    (%eax),%eax
  8026fa:	eb 05                	jmp    802701 <print_blocks_list+0x78>
  8026fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802701:	89 45 10             	mov    %eax,0x10(%ebp)
  802704:	8b 45 10             	mov    0x10(%ebp),%eax
  802707:	85 c0                	test   %eax,%eax
  802709:	75 ad                	jne    8026b8 <print_blocks_list+0x2f>
  80270b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270f:	75 a7                	jne    8026b8 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802711:	83 ec 0c             	sub    $0xc,%esp
  802714:	68 38 45 80 00       	push   $0x804538
  802719:	e8 a3 e3 ff ff       	call   800ac1 <cprintf>
  80271e:	83 c4 10             	add    $0x10,%esp

}
  802721:	90                   	nop
  802722:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802725:	c9                   	leave  
  802726:	c3                   	ret    

00802727 <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802727:	55                   	push   %ebp
  802728:	89 e5                	mov    %esp,%ebp
  80272a:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80272d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802730:	83 e0 01             	and    $0x1,%eax
  802733:	85 c0                	test   %eax,%eax
  802735:	74 03                	je     80273a <initialize_dynamic_allocator+0x13>
  802737:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  80273a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80273e:	0f 84 f8 00 00 00    	je     80283c <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  802744:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  80274b:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  80274e:	a1 40 50 98 00       	mov    0x985040,%eax
  802753:	85 c0                	test   %eax,%eax
  802755:	0f 84 e2 00 00 00    	je     80283d <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  80275b:	8b 45 08             	mov    0x8(%ebp),%eax
  80275e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  80276a:	8b 55 08             	mov    0x8(%ebp),%edx
  80276d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802770:	01 d0                	add    %edx,%eax
  802772:	83 e8 04             	sub    $0x4,%eax
  802775:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802778:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  802781:	8b 45 08             	mov    0x8(%ebp),%eax
  802784:	83 c0 08             	add    $0x8,%eax
  802787:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  80278a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80278d:	83 e8 08             	sub    $0x8,%eax
  802790:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  802793:	83 ec 04             	sub    $0x4,%esp
  802796:	6a 00                	push   $0x0
  802798:	ff 75 e8             	pushl  -0x18(%ebp)
  80279b:	ff 75 ec             	pushl  -0x14(%ebp)
  80279e:	e8 9c 00 00 00       	call   80283f <set_block_data>
  8027a3:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  8027a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  8027af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  8027b9:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  8027c0:	00 00 00 
  8027c3:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  8027ca:	00 00 00 
  8027cd:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  8027d4:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  8027d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027db:	75 17                	jne    8027f4 <initialize_dynamic_allocator+0xcd>
  8027dd:	83 ec 04             	sub    $0x4,%esp
  8027e0:	68 94 45 80 00       	push   $0x804594
  8027e5:	68 80 00 00 00       	push   $0x80
  8027ea:	68 b7 45 80 00       	push   $0x8045b7
  8027ef:	e8 10 e0 ff ff       	call   800804 <_panic>
  8027f4:	8b 15 48 50 98 00    	mov    0x985048,%edx
  8027fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fd:	89 10                	mov    %edx,(%eax)
  8027ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802802:	8b 00                	mov    (%eax),%eax
  802804:	85 c0                	test   %eax,%eax
  802806:	74 0d                	je     802815 <initialize_dynamic_allocator+0xee>
  802808:	a1 48 50 98 00       	mov    0x985048,%eax
  80280d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802810:	89 50 04             	mov    %edx,0x4(%eax)
  802813:	eb 08                	jmp    80281d <initialize_dynamic_allocator+0xf6>
  802815:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802818:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80281d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802820:	a3 48 50 98 00       	mov    %eax,0x985048
  802825:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802828:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80282f:	a1 54 50 98 00       	mov    0x985054,%eax
  802834:	40                   	inc    %eax
  802835:	a3 54 50 98 00       	mov    %eax,0x985054
  80283a:	eb 01                	jmp    80283d <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  80283c:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  80283d:	c9                   	leave  
  80283e:	c3                   	ret    

0080283f <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80283f:	55                   	push   %ebp
  802840:	89 e5                	mov    %esp,%ebp
  802842:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  802845:	8b 45 0c             	mov    0xc(%ebp),%eax
  802848:	83 e0 01             	and    $0x1,%eax
  80284b:	85 c0                	test   %eax,%eax
  80284d:	74 03                	je     802852 <set_block_data+0x13>
	{
		totalSize++;
  80284f:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  802852:	8b 45 08             	mov    0x8(%ebp),%eax
  802855:	83 e8 04             	sub    $0x4,%eax
  802858:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  80285b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80285e:	83 e0 fe             	and    $0xfffffffe,%eax
  802861:	89 c2                	mov    %eax,%edx
  802863:	8b 45 10             	mov    0x10(%ebp),%eax
  802866:	83 e0 01             	and    $0x1,%eax
  802869:	09 c2                	or     %eax,%edx
  80286b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80286e:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  802870:	8b 45 0c             	mov    0xc(%ebp),%eax
  802873:	8d 50 f8             	lea    -0x8(%eax),%edx
  802876:	8b 45 08             	mov    0x8(%ebp),%eax
  802879:	01 d0                	add    %edx,%eax
  80287b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  80287e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802881:	83 e0 fe             	and    $0xfffffffe,%eax
  802884:	89 c2                	mov    %eax,%edx
  802886:	8b 45 10             	mov    0x10(%ebp),%eax
  802889:	83 e0 01             	and    $0x1,%eax
  80288c:	09 c2                	or     %eax,%edx
  80288e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802891:	89 10                	mov    %edx,(%eax)
}
  802893:	90                   	nop
  802894:	c9                   	leave  
  802895:	c3                   	ret    

00802896 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  802896:	55                   	push   %ebp
  802897:	89 e5                	mov    %esp,%ebp
  802899:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  80289c:	a1 48 50 98 00       	mov    0x985048,%eax
  8028a1:	85 c0                	test   %eax,%eax
  8028a3:	75 68                	jne    80290d <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  8028a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028a9:	75 17                	jne    8028c2 <insert_sorted_in_freeList+0x2c>
  8028ab:	83 ec 04             	sub    $0x4,%esp
  8028ae:	68 94 45 80 00       	push   $0x804594
  8028b3:	68 9d 00 00 00       	push   $0x9d
  8028b8:	68 b7 45 80 00       	push   $0x8045b7
  8028bd:	e8 42 df ff ff       	call   800804 <_panic>
  8028c2:	8b 15 48 50 98 00    	mov    0x985048,%edx
  8028c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cb:	89 10                	mov    %edx,(%eax)
  8028cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d0:	8b 00                	mov    (%eax),%eax
  8028d2:	85 c0                	test   %eax,%eax
  8028d4:	74 0d                	je     8028e3 <insert_sorted_in_freeList+0x4d>
  8028d6:	a1 48 50 98 00       	mov    0x985048,%eax
  8028db:	8b 55 08             	mov    0x8(%ebp),%edx
  8028de:	89 50 04             	mov    %edx,0x4(%eax)
  8028e1:	eb 08                	jmp    8028eb <insert_sorted_in_freeList+0x55>
  8028e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e6:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8028eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ee:	a3 48 50 98 00       	mov    %eax,0x985048
  8028f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028fd:	a1 54 50 98 00       	mov    0x985054,%eax
  802902:	40                   	inc    %eax
  802903:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  802908:	e9 1a 01 00 00       	jmp    802a27 <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  80290d:	a1 48 50 98 00       	mov    0x985048,%eax
  802912:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802915:	eb 7f                	jmp    802996 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  802917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80291d:	76 6f                	jbe    80298e <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  80291f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802923:	74 06                	je     80292b <insert_sorted_in_freeList+0x95>
  802925:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802929:	75 17                	jne    802942 <insert_sorted_in_freeList+0xac>
  80292b:	83 ec 04             	sub    $0x4,%esp
  80292e:	68 d0 45 80 00       	push   $0x8045d0
  802933:	68 a6 00 00 00       	push   $0xa6
  802938:	68 b7 45 80 00       	push   $0x8045b7
  80293d:	e8 c2 de ff ff       	call   800804 <_panic>
  802942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802945:	8b 50 04             	mov    0x4(%eax),%edx
  802948:	8b 45 08             	mov    0x8(%ebp),%eax
  80294b:	89 50 04             	mov    %edx,0x4(%eax)
  80294e:	8b 45 08             	mov    0x8(%ebp),%eax
  802951:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802954:	89 10                	mov    %edx,(%eax)
  802956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802959:	8b 40 04             	mov    0x4(%eax),%eax
  80295c:	85 c0                	test   %eax,%eax
  80295e:	74 0d                	je     80296d <insert_sorted_in_freeList+0xd7>
  802960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802963:	8b 40 04             	mov    0x4(%eax),%eax
  802966:	8b 55 08             	mov    0x8(%ebp),%edx
  802969:	89 10                	mov    %edx,(%eax)
  80296b:	eb 08                	jmp    802975 <insert_sorted_in_freeList+0xdf>
  80296d:	8b 45 08             	mov    0x8(%ebp),%eax
  802970:	a3 48 50 98 00       	mov    %eax,0x985048
  802975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802978:	8b 55 08             	mov    0x8(%ebp),%edx
  80297b:	89 50 04             	mov    %edx,0x4(%eax)
  80297e:	a1 54 50 98 00       	mov    0x985054,%eax
  802983:	40                   	inc    %eax
  802984:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  802989:	e9 99 00 00 00       	jmp    802a27 <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  80298e:	a1 50 50 98 00       	mov    0x985050,%eax
  802993:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802996:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299a:	74 07                	je     8029a3 <insert_sorted_in_freeList+0x10d>
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	8b 00                	mov    (%eax),%eax
  8029a1:	eb 05                	jmp    8029a8 <insert_sorted_in_freeList+0x112>
  8029a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a8:	a3 50 50 98 00       	mov    %eax,0x985050
  8029ad:	a1 50 50 98 00       	mov    0x985050,%eax
  8029b2:	85 c0                	test   %eax,%eax
  8029b4:	0f 85 5d ff ff ff    	jne    802917 <insert_sorted_in_freeList+0x81>
  8029ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029be:	0f 85 53 ff ff ff    	jne    802917 <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  8029c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029c8:	75 17                	jne    8029e1 <insert_sorted_in_freeList+0x14b>
  8029ca:	83 ec 04             	sub    $0x4,%esp
  8029cd:	68 08 46 80 00       	push   $0x804608
  8029d2:	68 ab 00 00 00       	push   $0xab
  8029d7:	68 b7 45 80 00       	push   $0x8045b7
  8029dc:	e8 23 de ff ff       	call   800804 <_panic>
  8029e1:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  8029e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ea:	89 50 04             	mov    %edx,0x4(%eax)
  8029ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f0:	8b 40 04             	mov    0x4(%eax),%eax
  8029f3:	85 c0                	test   %eax,%eax
  8029f5:	74 0c                	je     802a03 <insert_sorted_in_freeList+0x16d>
  8029f7:	a1 4c 50 98 00       	mov    0x98504c,%eax
  8029fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ff:	89 10                	mov    %edx,(%eax)
  802a01:	eb 08                	jmp    802a0b <insert_sorted_in_freeList+0x175>
  802a03:	8b 45 08             	mov    0x8(%ebp),%eax
  802a06:	a3 48 50 98 00       	mov    %eax,0x985048
  802a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0e:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802a13:	8b 45 08             	mov    0x8(%ebp),%eax
  802a16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a1c:	a1 54 50 98 00       	mov    0x985054,%eax
  802a21:	40                   	inc    %eax
  802a22:	a3 54 50 98 00       	mov    %eax,0x985054
}
  802a27:	c9                   	leave  
  802a28:	c3                   	ret    

00802a29 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802a29:	55                   	push   %ebp
  802a2a:	89 e5                	mov    %esp,%ebp
  802a2c:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a32:	83 e0 01             	and    $0x1,%eax
  802a35:	85 c0                	test   %eax,%eax
  802a37:	74 03                	je     802a3c <alloc_block_FF+0x13>
  802a39:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802a3c:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802a40:	77 07                	ja     802a49 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802a42:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802a49:	a1 40 50 98 00       	mov    0x985040,%eax
  802a4e:	85 c0                	test   %eax,%eax
  802a50:	75 63                	jne    802ab5 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802a52:	8b 45 08             	mov    0x8(%ebp),%eax
  802a55:	83 c0 10             	add    $0x10,%eax
  802a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802a5b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802a62:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a68:	01 d0                	add    %edx,%eax
  802a6a:	48                   	dec    %eax
  802a6b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802a6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a71:	ba 00 00 00 00       	mov    $0x0,%edx
  802a76:	f7 75 ec             	divl   -0x14(%ebp)
  802a79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a7c:	29 d0                	sub    %edx,%eax
  802a7e:	c1 e8 0c             	shr    $0xc,%eax
  802a81:	83 ec 0c             	sub    $0xc,%esp
  802a84:	50                   	push   %eax
  802a85:	e8 d1 ed ff ff       	call   80185b <sbrk>
  802a8a:	83 c4 10             	add    $0x10,%esp
  802a8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802a90:	83 ec 0c             	sub    $0xc,%esp
  802a93:	6a 00                	push   $0x0
  802a95:	e8 c1 ed ff ff       	call   80185b <sbrk>
  802a9a:	83 c4 10             	add    $0x10,%esp
  802a9d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802aa0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802aa6:	83 ec 08             	sub    $0x8,%esp
  802aa9:	50                   	push   %eax
  802aaa:	ff 75 e4             	pushl  -0x1c(%ebp)
  802aad:	e8 75 fc ff ff       	call   802727 <initialize_dynamic_allocator>
  802ab2:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  802ab5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ab9:	75 0a                	jne    802ac5 <alloc_block_FF+0x9c>
	{
		return NULL;
  802abb:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac0:	e9 99 03 00 00       	jmp    802e5e <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac8:	83 c0 08             	add    $0x8,%eax
  802acb:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802ace:	a1 48 50 98 00       	mov    0x985048,%eax
  802ad3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ad6:	e9 03 02 00 00       	jmp    802cde <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802adb:	83 ec 0c             	sub    $0xc,%esp
  802ade:	ff 75 f4             	pushl  -0xc(%ebp)
  802ae1:	e8 dd fa ff ff       	call   8025c3 <get_block_size>
  802ae6:	83 c4 10             	add    $0x10,%esp
  802ae9:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802aec:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802aef:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802af2:	0f 82 de 01 00 00    	jb     802cd6 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  802af8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802afb:	83 c0 10             	add    $0x10,%eax
  802afe:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802b01:	0f 87 32 01 00 00    	ja     802c39 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  802b07:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802b0a:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802b0d:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802b10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b13:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b16:	01 d0                	add    %edx,%eax
  802b18:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  802b1b:	83 ec 04             	sub    $0x4,%esp
  802b1e:	6a 00                	push   $0x0
  802b20:	ff 75 98             	pushl  -0x68(%ebp)
  802b23:	ff 75 94             	pushl  -0x6c(%ebp)
  802b26:	e8 14 fd ff ff       	call   80283f <set_block_data>
  802b2b:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802b2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b32:	74 06                	je     802b3a <alloc_block_FF+0x111>
  802b34:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  802b38:	75 17                	jne    802b51 <alloc_block_FF+0x128>
  802b3a:	83 ec 04             	sub    $0x4,%esp
  802b3d:	68 2c 46 80 00       	push   $0x80462c
  802b42:	68 de 00 00 00       	push   $0xde
  802b47:	68 b7 45 80 00       	push   $0x8045b7
  802b4c:	e8 b3 dc ff ff       	call   800804 <_panic>
  802b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b54:	8b 10                	mov    (%eax),%edx
  802b56:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802b59:	89 10                	mov    %edx,(%eax)
  802b5b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802b5e:	8b 00                	mov    (%eax),%eax
  802b60:	85 c0                	test   %eax,%eax
  802b62:	74 0b                	je     802b6f <alloc_block_FF+0x146>
  802b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b67:	8b 00                	mov    (%eax),%eax
  802b69:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802b6c:	89 50 04             	mov    %edx,0x4(%eax)
  802b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b72:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802b75:	89 10                	mov    %edx,(%eax)
  802b77:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802b7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b7d:	89 50 04             	mov    %edx,0x4(%eax)
  802b80:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802b83:	8b 00                	mov    (%eax),%eax
  802b85:	85 c0                	test   %eax,%eax
  802b87:	75 08                	jne    802b91 <alloc_block_FF+0x168>
  802b89:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802b8c:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802b91:	a1 54 50 98 00       	mov    0x985054,%eax
  802b96:	40                   	inc    %eax
  802b97:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802b9c:	83 ec 04             	sub    $0x4,%esp
  802b9f:	6a 01                	push   $0x1
  802ba1:	ff 75 dc             	pushl  -0x24(%ebp)
  802ba4:	ff 75 f4             	pushl  -0xc(%ebp)
  802ba7:	e8 93 fc ff ff       	call   80283f <set_block_data>
  802bac:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802baf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb3:	75 17                	jne    802bcc <alloc_block_FF+0x1a3>
  802bb5:	83 ec 04             	sub    $0x4,%esp
  802bb8:	68 60 46 80 00       	push   $0x804660
  802bbd:	68 e3 00 00 00       	push   $0xe3
  802bc2:	68 b7 45 80 00       	push   $0x8045b7
  802bc7:	e8 38 dc ff ff       	call   800804 <_panic>
  802bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcf:	8b 00                	mov    (%eax),%eax
  802bd1:	85 c0                	test   %eax,%eax
  802bd3:	74 10                	je     802be5 <alloc_block_FF+0x1bc>
  802bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd8:	8b 00                	mov    (%eax),%eax
  802bda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bdd:	8b 52 04             	mov    0x4(%edx),%edx
  802be0:	89 50 04             	mov    %edx,0x4(%eax)
  802be3:	eb 0b                	jmp    802bf0 <alloc_block_FF+0x1c7>
  802be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be8:	8b 40 04             	mov    0x4(%eax),%eax
  802beb:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf3:	8b 40 04             	mov    0x4(%eax),%eax
  802bf6:	85 c0                	test   %eax,%eax
  802bf8:	74 0f                	je     802c09 <alloc_block_FF+0x1e0>
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	8b 40 04             	mov    0x4(%eax),%eax
  802c00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c03:	8b 12                	mov    (%edx),%edx
  802c05:	89 10                	mov    %edx,(%eax)
  802c07:	eb 0a                	jmp    802c13 <alloc_block_FF+0x1ea>
  802c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0c:	8b 00                	mov    (%eax),%eax
  802c0e:	a3 48 50 98 00       	mov    %eax,0x985048
  802c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c26:	a1 54 50 98 00       	mov    0x985054,%eax
  802c2b:	48                   	dec    %eax
  802c2c:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c34:	e9 25 02 00 00       	jmp    802e5e <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  802c39:	83 ec 04             	sub    $0x4,%esp
  802c3c:	6a 01                	push   $0x1
  802c3e:	ff 75 9c             	pushl  -0x64(%ebp)
  802c41:	ff 75 f4             	pushl  -0xc(%ebp)
  802c44:	e8 f6 fb ff ff       	call   80283f <set_block_data>
  802c49:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802c4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c50:	75 17                	jne    802c69 <alloc_block_FF+0x240>
  802c52:	83 ec 04             	sub    $0x4,%esp
  802c55:	68 60 46 80 00       	push   $0x804660
  802c5a:	68 eb 00 00 00       	push   $0xeb
  802c5f:	68 b7 45 80 00       	push   $0x8045b7
  802c64:	e8 9b db ff ff       	call   800804 <_panic>
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	8b 00                	mov    (%eax),%eax
  802c6e:	85 c0                	test   %eax,%eax
  802c70:	74 10                	je     802c82 <alloc_block_FF+0x259>
  802c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c75:	8b 00                	mov    (%eax),%eax
  802c77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c7a:	8b 52 04             	mov    0x4(%edx),%edx
  802c7d:	89 50 04             	mov    %edx,0x4(%eax)
  802c80:	eb 0b                	jmp    802c8d <alloc_block_FF+0x264>
  802c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c85:	8b 40 04             	mov    0x4(%eax),%eax
  802c88:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c90:	8b 40 04             	mov    0x4(%eax),%eax
  802c93:	85 c0                	test   %eax,%eax
  802c95:	74 0f                	je     802ca6 <alloc_block_FF+0x27d>
  802c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9a:	8b 40 04             	mov    0x4(%eax),%eax
  802c9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca0:	8b 12                	mov    (%edx),%edx
  802ca2:	89 10                	mov    %edx,(%eax)
  802ca4:	eb 0a                	jmp    802cb0 <alloc_block_FF+0x287>
  802ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca9:	8b 00                	mov    (%eax),%eax
  802cab:	a3 48 50 98 00       	mov    %eax,0x985048
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc3:	a1 54 50 98 00       	mov    0x985054,%eax
  802cc8:	48                   	dec    %eax
  802cc9:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd1:	e9 88 01 00 00       	jmp    802e5e <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802cd6:	a1 50 50 98 00       	mov    0x985050,%eax
  802cdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce2:	74 07                	je     802ceb <alloc_block_FF+0x2c2>
  802ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce7:	8b 00                	mov    (%eax),%eax
  802ce9:	eb 05                	jmp    802cf0 <alloc_block_FF+0x2c7>
  802ceb:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf0:	a3 50 50 98 00       	mov    %eax,0x985050
  802cf5:	a1 50 50 98 00       	mov    0x985050,%eax
  802cfa:	85 c0                	test   %eax,%eax
  802cfc:	0f 85 d9 fd ff ff    	jne    802adb <alloc_block_FF+0xb2>
  802d02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d06:	0f 85 cf fd ff ff    	jne    802adb <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  802d0c:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802d13:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d16:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d19:	01 d0                	add    %edx,%eax
  802d1b:	48                   	dec    %eax
  802d1c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802d1f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d22:	ba 00 00 00 00       	mov    $0x0,%edx
  802d27:	f7 75 d8             	divl   -0x28(%ebp)
  802d2a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d2d:	29 d0                	sub    %edx,%eax
  802d2f:	c1 e8 0c             	shr    $0xc,%eax
  802d32:	83 ec 0c             	sub    $0xc,%esp
  802d35:	50                   	push   %eax
  802d36:	e8 20 eb ff ff       	call   80185b <sbrk>
  802d3b:	83 c4 10             	add    $0x10,%esp
  802d3e:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802d41:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802d45:	75 0a                	jne    802d51 <alloc_block_FF+0x328>
		return NULL;
  802d47:	b8 00 00 00 00       	mov    $0x0,%eax
  802d4c:	e9 0d 01 00 00       	jmp    802e5e <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  802d51:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d54:	83 e8 04             	sub    $0x4,%eax
  802d57:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  802d5a:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  802d61:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d64:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d67:	01 d0                	add    %edx,%eax
  802d69:	48                   	dec    %eax
  802d6a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802d6d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d70:	ba 00 00 00 00       	mov    $0x0,%edx
  802d75:	f7 75 c8             	divl   -0x38(%ebp)
  802d78:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d7b:	29 d0                	sub    %edx,%eax
  802d7d:	c1 e8 02             	shr    $0x2,%eax
  802d80:	c1 e0 02             	shl    $0x2,%eax
  802d83:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  802d86:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d89:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  802d8f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d92:	83 e8 08             	sub    $0x8,%eax
  802d95:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  802d98:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d9b:	8b 00                	mov    (%eax),%eax
  802d9d:	83 e0 fe             	and    $0xfffffffe,%eax
  802da0:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  802da3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802da6:	f7 d8                	neg    %eax
  802da8:	89 c2                	mov    %eax,%edx
  802daa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dad:	01 d0                	add    %edx,%eax
  802daf:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  802db2:	83 ec 0c             	sub    $0xc,%esp
  802db5:	ff 75 b8             	pushl  -0x48(%ebp)
  802db8:	e8 1f f8 ff ff       	call   8025dc <is_free_block>
  802dbd:	83 c4 10             	add    $0x10,%esp
  802dc0:	0f be c0             	movsbl %al,%eax
  802dc3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  802dc6:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802dca:	74 42                	je     802e0e <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  802dcc:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802dd3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dd6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dd9:	01 d0                	add    %edx,%eax
  802ddb:	48                   	dec    %eax
  802ddc:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802ddf:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802de2:	ba 00 00 00 00       	mov    $0x0,%edx
  802de7:	f7 75 b0             	divl   -0x50(%ebp)
  802dea:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ded:	29 d0                	sub    %edx,%eax
  802def:	89 c2                	mov    %eax,%edx
  802df1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802df4:	01 d0                	add    %edx,%eax
  802df6:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  802df9:	83 ec 04             	sub    $0x4,%esp
  802dfc:	6a 00                	push   $0x0
  802dfe:	ff 75 a8             	pushl  -0x58(%ebp)
  802e01:	ff 75 b8             	pushl  -0x48(%ebp)
  802e04:	e8 36 fa ff ff       	call   80283f <set_block_data>
  802e09:	83 c4 10             	add    $0x10,%esp
  802e0c:	eb 42                	jmp    802e50 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802e0e:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  802e15:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e18:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802e1b:	01 d0                	add    %edx,%eax
  802e1d:	48                   	dec    %eax
  802e1e:	89 45 a0             	mov    %eax,-0x60(%ebp)
  802e21:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802e24:	ba 00 00 00 00       	mov    $0x0,%edx
  802e29:	f7 75 a4             	divl   -0x5c(%ebp)
  802e2c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802e2f:	29 d0                	sub    %edx,%eax
  802e31:	83 ec 04             	sub    $0x4,%esp
  802e34:	6a 00                	push   $0x0
  802e36:	50                   	push   %eax
  802e37:	ff 75 d0             	pushl  -0x30(%ebp)
  802e3a:	e8 00 fa ff ff       	call   80283f <set_block_data>
  802e3f:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802e42:	83 ec 0c             	sub    $0xc,%esp
  802e45:	ff 75 d0             	pushl  -0x30(%ebp)
  802e48:	e8 49 fa ff ff       	call   802896 <insert_sorted_in_freeList>
  802e4d:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802e50:	83 ec 0c             	sub    $0xc,%esp
  802e53:	ff 75 08             	pushl  0x8(%ebp)
  802e56:	e8 ce fb ff ff       	call   802a29 <alloc_block_FF>
  802e5b:	83 c4 10             	add    $0x10,%esp
}
  802e5e:	c9                   	leave  
  802e5f:	c3                   	ret    

00802e60 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802e60:	55                   	push   %ebp
  802e61:	89 e5                	mov    %esp,%ebp
  802e63:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  802e66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e6a:	75 0a                	jne    802e76 <alloc_block_BF+0x16>
	{
		return NULL;
  802e6c:	b8 00 00 00 00       	mov    $0x0,%eax
  802e71:	e9 7a 02 00 00       	jmp    8030f0 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802e76:	8b 45 08             	mov    0x8(%ebp),%eax
  802e79:	83 c0 08             	add    $0x8,%eax
  802e7c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802e7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  802e86:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802e8d:	a1 48 50 98 00       	mov    0x985048,%eax
  802e92:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802e95:	eb 32                	jmp    802ec9 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  802e97:	ff 75 ec             	pushl  -0x14(%ebp)
  802e9a:	e8 24 f7 ff ff       	call   8025c3 <get_block_size>
  802e9f:	83 c4 04             	add    $0x4,%esp
  802ea2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  802ea5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ea8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802eab:	72 14                	jb     802ec1 <alloc_block_BF+0x61>
  802ead:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eb0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802eb3:	73 0c                	jae    802ec1 <alloc_block_BF+0x61>
		{
			minBlk = block;
  802eb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  802ebb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ebe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802ec1:	a1 50 50 98 00       	mov    0x985050,%eax
  802ec6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802ec9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ecd:	74 07                	je     802ed6 <alloc_block_BF+0x76>
  802ecf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed2:	8b 00                	mov    (%eax),%eax
  802ed4:	eb 05                	jmp    802edb <alloc_block_BF+0x7b>
  802ed6:	b8 00 00 00 00       	mov    $0x0,%eax
  802edb:	a3 50 50 98 00       	mov    %eax,0x985050
  802ee0:	a1 50 50 98 00       	mov    0x985050,%eax
  802ee5:	85 c0                	test   %eax,%eax
  802ee7:	75 ae                	jne    802e97 <alloc_block_BF+0x37>
  802ee9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802eed:	75 a8                	jne    802e97 <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802eef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ef3:	75 22                	jne    802f17 <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802ef5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef8:	83 ec 0c             	sub    $0xc,%esp
  802efb:	50                   	push   %eax
  802efc:	e8 5a e9 ff ff       	call   80185b <sbrk>
  802f01:	83 c4 10             	add    $0x10,%esp
  802f04:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  802f07:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802f0b:	75 0a                	jne    802f17 <alloc_block_BF+0xb7>
			return NULL;
  802f0d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f12:	e9 d9 01 00 00       	jmp    8030f0 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  802f17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1a:	83 c0 10             	add    $0x10,%eax
  802f1d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f20:	0f 87 32 01 00 00    	ja     803058 <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  802f26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f29:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802f2c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802f2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f35:	01 d0                	add    %edx,%eax
  802f37:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  802f3a:	83 ec 04             	sub    $0x4,%esp
  802f3d:	6a 00                	push   $0x0
  802f3f:	ff 75 dc             	pushl  -0x24(%ebp)
  802f42:	ff 75 d8             	pushl  -0x28(%ebp)
  802f45:	e8 f5 f8 ff ff       	call   80283f <set_block_data>
  802f4a:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802f4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f51:	74 06                	je     802f59 <alloc_block_BF+0xf9>
  802f53:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802f57:	75 17                	jne    802f70 <alloc_block_BF+0x110>
  802f59:	83 ec 04             	sub    $0x4,%esp
  802f5c:	68 2c 46 80 00       	push   $0x80462c
  802f61:	68 49 01 00 00       	push   $0x149
  802f66:	68 b7 45 80 00       	push   $0x8045b7
  802f6b:	e8 94 d8 ff ff       	call   800804 <_panic>
  802f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f73:	8b 10                	mov    (%eax),%edx
  802f75:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f78:	89 10                	mov    %edx,(%eax)
  802f7a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f7d:	8b 00                	mov    (%eax),%eax
  802f7f:	85 c0                	test   %eax,%eax
  802f81:	74 0b                	je     802f8e <alloc_block_BF+0x12e>
  802f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f86:	8b 00                	mov    (%eax),%eax
  802f88:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802f8b:	89 50 04             	mov    %edx,0x4(%eax)
  802f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f91:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802f94:	89 10                	mov    %edx,(%eax)
  802f96:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f9c:	89 50 04             	mov    %edx,0x4(%eax)
  802f9f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802fa2:	8b 00                	mov    (%eax),%eax
  802fa4:	85 c0                	test   %eax,%eax
  802fa6:	75 08                	jne    802fb0 <alloc_block_BF+0x150>
  802fa8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802fab:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802fb0:	a1 54 50 98 00       	mov    0x985054,%eax
  802fb5:	40                   	inc    %eax
  802fb6:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802fbb:	83 ec 04             	sub    $0x4,%esp
  802fbe:	6a 01                	push   $0x1
  802fc0:	ff 75 e8             	pushl  -0x18(%ebp)
  802fc3:	ff 75 f4             	pushl  -0xc(%ebp)
  802fc6:	e8 74 f8 ff ff       	call   80283f <set_block_data>
  802fcb:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802fce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd2:	75 17                	jne    802feb <alloc_block_BF+0x18b>
  802fd4:	83 ec 04             	sub    $0x4,%esp
  802fd7:	68 60 46 80 00       	push   $0x804660
  802fdc:	68 4e 01 00 00       	push   $0x14e
  802fe1:	68 b7 45 80 00       	push   $0x8045b7
  802fe6:	e8 19 d8 ff ff       	call   800804 <_panic>
  802feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fee:	8b 00                	mov    (%eax),%eax
  802ff0:	85 c0                	test   %eax,%eax
  802ff2:	74 10                	je     803004 <alloc_block_BF+0x1a4>
  802ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff7:	8b 00                	mov    (%eax),%eax
  802ff9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ffc:	8b 52 04             	mov    0x4(%edx),%edx
  802fff:	89 50 04             	mov    %edx,0x4(%eax)
  803002:	eb 0b                	jmp    80300f <alloc_block_BF+0x1af>
  803004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803007:	8b 40 04             	mov    0x4(%eax),%eax
  80300a:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80300f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803012:	8b 40 04             	mov    0x4(%eax),%eax
  803015:	85 c0                	test   %eax,%eax
  803017:	74 0f                	je     803028 <alloc_block_BF+0x1c8>
  803019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301c:	8b 40 04             	mov    0x4(%eax),%eax
  80301f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803022:	8b 12                	mov    (%edx),%edx
  803024:	89 10                	mov    %edx,(%eax)
  803026:	eb 0a                	jmp    803032 <alloc_block_BF+0x1d2>
  803028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302b:	8b 00                	mov    (%eax),%eax
  80302d:	a3 48 50 98 00       	mov    %eax,0x985048
  803032:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803035:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80303b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803045:	a1 54 50 98 00       	mov    0x985054,%eax
  80304a:	48                   	dec    %eax
  80304b:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  803050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803053:	e9 98 00 00 00       	jmp    8030f0 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  803058:	83 ec 04             	sub    $0x4,%esp
  80305b:	6a 01                	push   $0x1
  80305d:	ff 75 f0             	pushl  -0x10(%ebp)
  803060:	ff 75 f4             	pushl  -0xc(%ebp)
  803063:	e8 d7 f7 ff ff       	call   80283f <set_block_data>
  803068:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  80306b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80306f:	75 17                	jne    803088 <alloc_block_BF+0x228>
  803071:	83 ec 04             	sub    $0x4,%esp
  803074:	68 60 46 80 00       	push   $0x804660
  803079:	68 56 01 00 00       	push   $0x156
  80307e:	68 b7 45 80 00       	push   $0x8045b7
  803083:	e8 7c d7 ff ff       	call   800804 <_panic>
  803088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308b:	8b 00                	mov    (%eax),%eax
  80308d:	85 c0                	test   %eax,%eax
  80308f:	74 10                	je     8030a1 <alloc_block_BF+0x241>
  803091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803094:	8b 00                	mov    (%eax),%eax
  803096:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803099:	8b 52 04             	mov    0x4(%edx),%edx
  80309c:	89 50 04             	mov    %edx,0x4(%eax)
  80309f:	eb 0b                	jmp    8030ac <alloc_block_BF+0x24c>
  8030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a4:	8b 40 04             	mov    0x4(%eax),%eax
  8030a7:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8030ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030af:	8b 40 04             	mov    0x4(%eax),%eax
  8030b2:	85 c0                	test   %eax,%eax
  8030b4:	74 0f                	je     8030c5 <alloc_block_BF+0x265>
  8030b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b9:	8b 40 04             	mov    0x4(%eax),%eax
  8030bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030bf:	8b 12                	mov    (%edx),%edx
  8030c1:	89 10                	mov    %edx,(%eax)
  8030c3:	eb 0a                	jmp    8030cf <alloc_block_BF+0x26f>
  8030c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c8:	8b 00                	mov    (%eax),%eax
  8030ca:	a3 48 50 98 00       	mov    %eax,0x985048
  8030cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e2:	a1 54 50 98 00       	mov    0x985054,%eax
  8030e7:	48                   	dec    %eax
  8030e8:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  8030ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  8030f0:	c9                   	leave  
  8030f1:	c3                   	ret    

008030f2 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8030f2:	55                   	push   %ebp
  8030f3:	89 e5                	mov    %esp,%ebp
  8030f5:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  8030f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030fc:	0f 84 6a 02 00 00    	je     80336c <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  803102:	ff 75 08             	pushl  0x8(%ebp)
  803105:	e8 b9 f4 ff ff       	call   8025c3 <get_block_size>
  80310a:	83 c4 04             	add    $0x4,%esp
  80310d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  803110:	8b 45 08             	mov    0x8(%ebp),%eax
  803113:	83 e8 08             	sub    $0x8,%eax
  803116:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  803119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311c:	8b 00                	mov    (%eax),%eax
  80311e:	83 e0 fe             	and    $0xfffffffe,%eax
  803121:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  803124:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803127:	f7 d8                	neg    %eax
  803129:	89 c2                	mov    %eax,%edx
  80312b:	8b 45 08             	mov    0x8(%ebp),%eax
  80312e:	01 d0                	add    %edx,%eax
  803130:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  803133:	ff 75 e8             	pushl  -0x18(%ebp)
  803136:	e8 a1 f4 ff ff       	call   8025dc <is_free_block>
  80313b:	83 c4 04             	add    $0x4,%esp
  80313e:	0f be c0             	movsbl %al,%eax
  803141:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  803144:	8b 55 08             	mov    0x8(%ebp),%edx
  803147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314a:	01 d0                	add    %edx,%eax
  80314c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  80314f:	ff 75 e0             	pushl  -0x20(%ebp)
  803152:	e8 85 f4 ff ff       	call   8025dc <is_free_block>
  803157:	83 c4 04             	add    $0x4,%esp
  80315a:	0f be c0             	movsbl %al,%eax
  80315d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  803160:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  803164:	75 34                	jne    80319a <free_block+0xa8>
  803166:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80316a:	75 2e                	jne    80319a <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  80316c:	ff 75 e8             	pushl  -0x18(%ebp)
  80316f:	e8 4f f4 ff ff       	call   8025c3 <get_block_size>
  803174:	83 c4 04             	add    $0x4,%esp
  803177:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  80317a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80317d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803180:	01 d0                	add    %edx,%eax
  803182:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  803185:	6a 00                	push   $0x0
  803187:	ff 75 d4             	pushl  -0x2c(%ebp)
  80318a:	ff 75 e8             	pushl  -0x18(%ebp)
  80318d:	e8 ad f6 ff ff       	call   80283f <set_block_data>
  803192:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  803195:	e9 d3 01 00 00       	jmp    80336d <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  80319a:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  80319e:	0f 85 c8 00 00 00    	jne    80326c <free_block+0x17a>
  8031a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031a8:	0f 85 be 00 00 00    	jne    80326c <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  8031ae:	ff 75 e0             	pushl  -0x20(%ebp)
  8031b1:	e8 0d f4 ff ff       	call   8025c3 <get_block_size>
  8031b6:	83 c4 04             	add    $0x4,%esp
  8031b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  8031bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031c2:	01 d0                	add    %edx,%eax
  8031c4:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  8031c7:	6a 00                	push   $0x0
  8031c9:	ff 75 cc             	pushl  -0x34(%ebp)
  8031cc:	ff 75 08             	pushl  0x8(%ebp)
  8031cf:	e8 6b f6 ff ff       	call   80283f <set_block_data>
  8031d4:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  8031d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8031db:	75 17                	jne    8031f4 <free_block+0x102>
  8031dd:	83 ec 04             	sub    $0x4,%esp
  8031e0:	68 60 46 80 00       	push   $0x804660
  8031e5:	68 87 01 00 00       	push   $0x187
  8031ea:	68 b7 45 80 00       	push   $0x8045b7
  8031ef:	e8 10 d6 ff ff       	call   800804 <_panic>
  8031f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f7:	8b 00                	mov    (%eax),%eax
  8031f9:	85 c0                	test   %eax,%eax
  8031fb:	74 10                	je     80320d <free_block+0x11b>
  8031fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803200:	8b 00                	mov    (%eax),%eax
  803202:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803205:	8b 52 04             	mov    0x4(%edx),%edx
  803208:	89 50 04             	mov    %edx,0x4(%eax)
  80320b:	eb 0b                	jmp    803218 <free_block+0x126>
  80320d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803210:	8b 40 04             	mov    0x4(%eax),%eax
  803213:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803218:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80321b:	8b 40 04             	mov    0x4(%eax),%eax
  80321e:	85 c0                	test   %eax,%eax
  803220:	74 0f                	je     803231 <free_block+0x13f>
  803222:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803225:	8b 40 04             	mov    0x4(%eax),%eax
  803228:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80322b:	8b 12                	mov    (%edx),%edx
  80322d:	89 10                	mov    %edx,(%eax)
  80322f:	eb 0a                	jmp    80323b <free_block+0x149>
  803231:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803234:	8b 00                	mov    (%eax),%eax
  803236:	a3 48 50 98 00       	mov    %eax,0x985048
  80323b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80323e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803244:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803247:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80324e:	a1 54 50 98 00       	mov    0x985054,%eax
  803253:	48                   	dec    %eax
  803254:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  803259:	83 ec 0c             	sub    $0xc,%esp
  80325c:	ff 75 08             	pushl  0x8(%ebp)
  80325f:	e8 32 f6 ff ff       	call   802896 <insert_sorted_in_freeList>
  803264:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  803267:	e9 01 01 00 00       	jmp    80336d <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  80326c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  803270:	0f 85 d3 00 00 00    	jne    803349 <free_block+0x257>
  803276:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  80327a:	0f 85 c9 00 00 00    	jne    803349 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  803280:	83 ec 0c             	sub    $0xc,%esp
  803283:	ff 75 e8             	pushl  -0x18(%ebp)
  803286:	e8 38 f3 ff ff       	call   8025c3 <get_block_size>
  80328b:	83 c4 10             	add    $0x10,%esp
  80328e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  803291:	83 ec 0c             	sub    $0xc,%esp
  803294:	ff 75 e0             	pushl  -0x20(%ebp)
  803297:	e8 27 f3 ff ff       	call   8025c3 <get_block_size>
  80329c:	83 c4 10             	add    $0x10,%esp
  80329f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  8032a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032a5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032a8:	01 c2                	add    %eax,%edx
  8032aa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8032ad:	01 d0                	add    %edx,%eax
  8032af:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  8032b2:	83 ec 04             	sub    $0x4,%esp
  8032b5:	6a 00                	push   $0x0
  8032b7:	ff 75 c0             	pushl  -0x40(%ebp)
  8032ba:	ff 75 e8             	pushl  -0x18(%ebp)
  8032bd:	e8 7d f5 ff ff       	call   80283f <set_block_data>
  8032c2:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  8032c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8032c9:	75 17                	jne    8032e2 <free_block+0x1f0>
  8032cb:	83 ec 04             	sub    $0x4,%esp
  8032ce:	68 60 46 80 00       	push   $0x804660
  8032d3:	68 94 01 00 00       	push   $0x194
  8032d8:	68 b7 45 80 00       	push   $0x8045b7
  8032dd:	e8 22 d5 ff ff       	call   800804 <_panic>
  8032e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032e5:	8b 00                	mov    (%eax),%eax
  8032e7:	85 c0                	test   %eax,%eax
  8032e9:	74 10                	je     8032fb <free_block+0x209>
  8032eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032ee:	8b 00                	mov    (%eax),%eax
  8032f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032f3:	8b 52 04             	mov    0x4(%edx),%edx
  8032f6:	89 50 04             	mov    %edx,0x4(%eax)
  8032f9:	eb 0b                	jmp    803306 <free_block+0x214>
  8032fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032fe:	8b 40 04             	mov    0x4(%eax),%eax
  803301:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803306:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803309:	8b 40 04             	mov    0x4(%eax),%eax
  80330c:	85 c0                	test   %eax,%eax
  80330e:	74 0f                	je     80331f <free_block+0x22d>
  803310:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803313:	8b 40 04             	mov    0x4(%eax),%eax
  803316:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803319:	8b 12                	mov    (%edx),%edx
  80331b:	89 10                	mov    %edx,(%eax)
  80331d:	eb 0a                	jmp    803329 <free_block+0x237>
  80331f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803322:	8b 00                	mov    (%eax),%eax
  803324:	a3 48 50 98 00       	mov    %eax,0x985048
  803329:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80332c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803332:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803335:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80333c:	a1 54 50 98 00       	mov    0x985054,%eax
  803341:	48                   	dec    %eax
  803342:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  803347:	eb 24                	jmp    80336d <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  803349:	83 ec 04             	sub    $0x4,%esp
  80334c:	6a 00                	push   $0x0
  80334e:	ff 75 f4             	pushl  -0xc(%ebp)
  803351:	ff 75 08             	pushl  0x8(%ebp)
  803354:	e8 e6 f4 ff ff       	call   80283f <set_block_data>
  803359:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  80335c:	83 ec 0c             	sub    $0xc,%esp
  80335f:	ff 75 08             	pushl  0x8(%ebp)
  803362:	e8 2f f5 ff ff       	call   802896 <insert_sorted_in_freeList>
  803367:	83 c4 10             	add    $0x10,%esp
  80336a:	eb 01                	jmp    80336d <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  80336c:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  80336d:	c9                   	leave  
  80336e:	c3                   	ret    

0080336f <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  80336f:	55                   	push   %ebp
  803370:	89 e5                	mov    %esp,%ebp
  803372:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  803375:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803379:	75 10                	jne    80338b <realloc_block_FF+0x1c>
  80337b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80337f:	75 0a                	jne    80338b <realloc_block_FF+0x1c>
	{
		return NULL;
  803381:	b8 00 00 00 00       	mov    $0x0,%eax
  803386:	e9 8b 04 00 00       	jmp    803816 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  80338b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80338f:	75 18                	jne    8033a9 <realloc_block_FF+0x3a>
	{
		free_block(va);
  803391:	83 ec 0c             	sub    $0xc,%esp
  803394:	ff 75 08             	pushl  0x8(%ebp)
  803397:	e8 56 fd ff ff       	call   8030f2 <free_block>
  80339c:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80339f:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a4:	e9 6d 04 00 00       	jmp    803816 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  8033a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033ad:	75 13                	jne    8033c2 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  8033af:	83 ec 0c             	sub    $0xc,%esp
  8033b2:	ff 75 0c             	pushl  0xc(%ebp)
  8033b5:	e8 6f f6 ff ff       	call   802a29 <alloc_block_FF>
  8033ba:	83 c4 10             	add    $0x10,%esp
  8033bd:	e9 54 04 00 00       	jmp    803816 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  8033c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c5:	83 e0 01             	and    $0x1,%eax
  8033c8:	85 c0                	test   %eax,%eax
  8033ca:	74 03                	je     8033cf <realloc_block_FF+0x60>
	{
		new_size++;
  8033cc:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  8033cf:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8033d3:	77 07                	ja     8033dc <realloc_block_FF+0x6d>
	{
		new_size = 8;
  8033d5:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  8033dc:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  8033e0:	83 ec 0c             	sub    $0xc,%esp
  8033e3:	ff 75 08             	pushl  0x8(%ebp)
  8033e6:	e8 d8 f1 ff ff       	call   8025c3 <get_block_size>
  8033eb:	83 c4 10             	add    $0x10,%esp
  8033ee:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  8033f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8033f7:	75 08                	jne    803401 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  8033f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fc:	e9 15 04 00 00       	jmp    803816 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  803401:	8b 55 08             	mov    0x8(%ebp),%edx
  803404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803407:	01 d0                	add    %edx,%eax
  803409:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  80340c:	83 ec 0c             	sub    $0xc,%esp
  80340f:	ff 75 f0             	pushl  -0x10(%ebp)
  803412:	e8 c5 f1 ff ff       	call   8025dc <is_free_block>
  803417:	83 c4 10             	add    $0x10,%esp
  80341a:	0f be c0             	movsbl %al,%eax
  80341d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  803420:	83 ec 0c             	sub    $0xc,%esp
  803423:	ff 75 f0             	pushl  -0x10(%ebp)
  803426:	e8 98 f1 ff ff       	call   8025c3 <get_block_size>
  80342b:	83 c4 10             	add    $0x10,%esp
  80342e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  803431:	8b 45 0c             	mov    0xc(%ebp),%eax
  803434:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803437:	0f 86 a7 02 00 00    	jbe    8036e4 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  80343d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803441:	0f 84 86 02 00 00    	je     8036cd <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  803447:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80344a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344d:	01 d0                	add    %edx,%eax
  80344f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803452:	0f 85 b2 00 00 00    	jne    80350a <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  803458:	83 ec 0c             	sub    $0xc,%esp
  80345b:	ff 75 08             	pushl  0x8(%ebp)
  80345e:	e8 79 f1 ff ff       	call   8025dc <is_free_block>
  803463:	83 c4 10             	add    $0x10,%esp
  803466:	84 c0                	test   %al,%al
  803468:	0f 94 c0             	sete   %al
  80346b:	0f b6 c0             	movzbl %al,%eax
  80346e:	83 ec 04             	sub    $0x4,%esp
  803471:	50                   	push   %eax
  803472:	ff 75 0c             	pushl  0xc(%ebp)
  803475:	ff 75 08             	pushl  0x8(%ebp)
  803478:	e8 c2 f3 ff ff       	call   80283f <set_block_data>
  80347d:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  803480:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803484:	75 17                	jne    80349d <realloc_block_FF+0x12e>
  803486:	83 ec 04             	sub    $0x4,%esp
  803489:	68 60 46 80 00       	push   $0x804660
  80348e:	68 db 01 00 00       	push   $0x1db
  803493:	68 b7 45 80 00       	push   $0x8045b7
  803498:	e8 67 d3 ff ff       	call   800804 <_panic>
  80349d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a0:	8b 00                	mov    (%eax),%eax
  8034a2:	85 c0                	test   %eax,%eax
  8034a4:	74 10                	je     8034b6 <realloc_block_FF+0x147>
  8034a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a9:	8b 00                	mov    (%eax),%eax
  8034ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034ae:	8b 52 04             	mov    0x4(%edx),%edx
  8034b1:	89 50 04             	mov    %edx,0x4(%eax)
  8034b4:	eb 0b                	jmp    8034c1 <realloc_block_FF+0x152>
  8034b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b9:	8b 40 04             	mov    0x4(%eax),%eax
  8034bc:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8034c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c4:	8b 40 04             	mov    0x4(%eax),%eax
  8034c7:	85 c0                	test   %eax,%eax
  8034c9:	74 0f                	je     8034da <realloc_block_FF+0x16b>
  8034cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ce:	8b 40 04             	mov    0x4(%eax),%eax
  8034d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034d4:	8b 12                	mov    (%edx),%edx
  8034d6:	89 10                	mov    %edx,(%eax)
  8034d8:	eb 0a                	jmp    8034e4 <realloc_block_FF+0x175>
  8034da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034dd:	8b 00                	mov    (%eax),%eax
  8034df:	a3 48 50 98 00       	mov    %eax,0x985048
  8034e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034f7:	a1 54 50 98 00       	mov    0x985054,%eax
  8034fc:	48                   	dec    %eax
  8034fd:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  803502:	8b 45 08             	mov    0x8(%ebp),%eax
  803505:	e9 0c 03 00 00       	jmp    803816 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  80350a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80350d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803510:	01 d0                	add    %edx,%eax
  803512:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803515:	0f 86 b2 01 00 00    	jbe    8036cd <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  80351b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80351e:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803521:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  803524:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803527:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80352a:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  80352d:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  803531:	0f 87 b8 00 00 00    	ja     8035ef <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  803537:	83 ec 0c             	sub    $0xc,%esp
  80353a:	ff 75 08             	pushl  0x8(%ebp)
  80353d:	e8 9a f0 ff ff       	call   8025dc <is_free_block>
  803542:	83 c4 10             	add    $0x10,%esp
  803545:	84 c0                	test   %al,%al
  803547:	0f 94 c0             	sete   %al
  80354a:	0f b6 c0             	movzbl %al,%eax
  80354d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803550:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803553:	01 ca                	add    %ecx,%edx
  803555:	83 ec 04             	sub    $0x4,%esp
  803558:	50                   	push   %eax
  803559:	52                   	push   %edx
  80355a:	ff 75 08             	pushl  0x8(%ebp)
  80355d:	e8 dd f2 ff ff       	call   80283f <set_block_data>
  803562:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803565:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803569:	75 17                	jne    803582 <realloc_block_FF+0x213>
  80356b:	83 ec 04             	sub    $0x4,%esp
  80356e:	68 60 46 80 00       	push   $0x804660
  803573:	68 e8 01 00 00       	push   $0x1e8
  803578:	68 b7 45 80 00       	push   $0x8045b7
  80357d:	e8 82 d2 ff ff       	call   800804 <_panic>
  803582:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803585:	8b 00                	mov    (%eax),%eax
  803587:	85 c0                	test   %eax,%eax
  803589:	74 10                	je     80359b <realloc_block_FF+0x22c>
  80358b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80358e:	8b 00                	mov    (%eax),%eax
  803590:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803593:	8b 52 04             	mov    0x4(%edx),%edx
  803596:	89 50 04             	mov    %edx,0x4(%eax)
  803599:	eb 0b                	jmp    8035a6 <realloc_block_FF+0x237>
  80359b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80359e:	8b 40 04             	mov    0x4(%eax),%eax
  8035a1:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8035a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a9:	8b 40 04             	mov    0x4(%eax),%eax
  8035ac:	85 c0                	test   %eax,%eax
  8035ae:	74 0f                	je     8035bf <realloc_block_FF+0x250>
  8035b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035b3:	8b 40 04             	mov    0x4(%eax),%eax
  8035b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035b9:	8b 12                	mov    (%edx),%edx
  8035bb:	89 10                	mov    %edx,(%eax)
  8035bd:	eb 0a                	jmp    8035c9 <realloc_block_FF+0x25a>
  8035bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c2:	8b 00                	mov    (%eax),%eax
  8035c4:	a3 48 50 98 00       	mov    %eax,0x985048
  8035c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035dc:	a1 54 50 98 00       	mov    0x985054,%eax
  8035e1:	48                   	dec    %eax
  8035e2:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  8035e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ea:	e9 27 02 00 00       	jmp    803816 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8035ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035f3:	75 17                	jne    80360c <realloc_block_FF+0x29d>
  8035f5:	83 ec 04             	sub    $0x4,%esp
  8035f8:	68 60 46 80 00       	push   $0x804660
  8035fd:	68 ed 01 00 00       	push   $0x1ed
  803602:	68 b7 45 80 00       	push   $0x8045b7
  803607:	e8 f8 d1 ff ff       	call   800804 <_panic>
  80360c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80360f:	8b 00                	mov    (%eax),%eax
  803611:	85 c0                	test   %eax,%eax
  803613:	74 10                	je     803625 <realloc_block_FF+0x2b6>
  803615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803618:	8b 00                	mov    (%eax),%eax
  80361a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80361d:	8b 52 04             	mov    0x4(%edx),%edx
  803620:	89 50 04             	mov    %edx,0x4(%eax)
  803623:	eb 0b                	jmp    803630 <realloc_block_FF+0x2c1>
  803625:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803628:	8b 40 04             	mov    0x4(%eax),%eax
  80362b:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803630:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803633:	8b 40 04             	mov    0x4(%eax),%eax
  803636:	85 c0                	test   %eax,%eax
  803638:	74 0f                	je     803649 <realloc_block_FF+0x2da>
  80363a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80363d:	8b 40 04             	mov    0x4(%eax),%eax
  803640:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803643:	8b 12                	mov    (%edx),%edx
  803645:	89 10                	mov    %edx,(%eax)
  803647:	eb 0a                	jmp    803653 <realloc_block_FF+0x2e4>
  803649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80364c:	8b 00                	mov    (%eax),%eax
  80364e:	a3 48 50 98 00       	mov    %eax,0x985048
  803653:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803656:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80365c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80365f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803666:	a1 54 50 98 00       	mov    0x985054,%eax
  80366b:	48                   	dec    %eax
  80366c:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  803671:	8b 55 08             	mov    0x8(%ebp),%edx
  803674:	8b 45 0c             	mov    0xc(%ebp),%eax
  803677:	01 d0                	add    %edx,%eax
  803679:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  80367c:	83 ec 04             	sub    $0x4,%esp
  80367f:	6a 00                	push   $0x0
  803681:	ff 75 e0             	pushl  -0x20(%ebp)
  803684:	ff 75 f0             	pushl  -0x10(%ebp)
  803687:	e8 b3 f1 ff ff       	call   80283f <set_block_data>
  80368c:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  80368f:	83 ec 0c             	sub    $0xc,%esp
  803692:	ff 75 08             	pushl  0x8(%ebp)
  803695:	e8 42 ef ff ff       	call   8025dc <is_free_block>
  80369a:	83 c4 10             	add    $0x10,%esp
  80369d:	84 c0                	test   %al,%al
  80369f:	0f 94 c0             	sete   %al
  8036a2:	0f b6 c0             	movzbl %al,%eax
  8036a5:	83 ec 04             	sub    $0x4,%esp
  8036a8:	50                   	push   %eax
  8036a9:	ff 75 0c             	pushl  0xc(%ebp)
  8036ac:	ff 75 08             	pushl  0x8(%ebp)
  8036af:	e8 8b f1 ff ff       	call   80283f <set_block_data>
  8036b4:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  8036b7:	83 ec 0c             	sub    $0xc,%esp
  8036ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8036bd:	e8 d4 f1 ff ff       	call   802896 <insert_sorted_in_freeList>
  8036c2:	83 c4 10             	add    $0x10,%esp
					return va;
  8036c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c8:	e9 49 01 00 00       	jmp    803816 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  8036cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036d0:	83 e8 08             	sub    $0x8,%eax
  8036d3:	83 ec 0c             	sub    $0xc,%esp
  8036d6:	50                   	push   %eax
  8036d7:	e8 4d f3 ff ff       	call   802a29 <alloc_block_FF>
  8036dc:	83 c4 10             	add    $0x10,%esp
  8036df:	e9 32 01 00 00       	jmp    803816 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  8036e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036e7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8036ea:	0f 83 21 01 00 00    	jae    803811 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  8036f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f3:	2b 45 0c             	sub    0xc(%ebp),%eax
  8036f6:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  8036f9:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  8036fd:	77 0e                	ja     80370d <realloc_block_FF+0x39e>
  8036ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803703:	75 08                	jne    80370d <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  803705:	8b 45 08             	mov    0x8(%ebp),%eax
  803708:	e9 09 01 00 00       	jmp    803816 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  80370d:	8b 45 08             	mov    0x8(%ebp),%eax
  803710:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  803713:	83 ec 0c             	sub    $0xc,%esp
  803716:	ff 75 08             	pushl  0x8(%ebp)
  803719:	e8 be ee ff ff       	call   8025dc <is_free_block>
  80371e:	83 c4 10             	add    $0x10,%esp
  803721:	84 c0                	test   %al,%al
  803723:	0f 94 c0             	sete   %al
  803726:	0f b6 c0             	movzbl %al,%eax
  803729:	83 ec 04             	sub    $0x4,%esp
  80372c:	50                   	push   %eax
  80372d:	ff 75 0c             	pushl  0xc(%ebp)
  803730:	ff 75 d8             	pushl  -0x28(%ebp)
  803733:	e8 07 f1 ff ff       	call   80283f <set_block_data>
  803738:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  80373b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80373e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803741:	01 d0                	add    %edx,%eax
  803743:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  803746:	83 ec 04             	sub    $0x4,%esp
  803749:	6a 00                	push   $0x0
  80374b:	ff 75 dc             	pushl  -0x24(%ebp)
  80374e:	ff 75 d4             	pushl  -0x2c(%ebp)
  803751:	e8 e9 f0 ff ff       	call   80283f <set_block_data>
  803756:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  803759:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80375d:	0f 84 9b 00 00 00    	je     8037fe <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  803763:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803766:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803769:	01 d0                	add    %edx,%eax
  80376b:	83 ec 04             	sub    $0x4,%esp
  80376e:	6a 00                	push   $0x0
  803770:	50                   	push   %eax
  803771:	ff 75 d4             	pushl  -0x2c(%ebp)
  803774:	e8 c6 f0 ff ff       	call   80283f <set_block_data>
  803779:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  80377c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803780:	75 17                	jne    803799 <realloc_block_FF+0x42a>
  803782:	83 ec 04             	sub    $0x4,%esp
  803785:	68 60 46 80 00       	push   $0x804660
  80378a:	68 10 02 00 00       	push   $0x210
  80378f:	68 b7 45 80 00       	push   $0x8045b7
  803794:	e8 6b d0 ff ff       	call   800804 <_panic>
  803799:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80379c:	8b 00                	mov    (%eax),%eax
  80379e:	85 c0                	test   %eax,%eax
  8037a0:	74 10                	je     8037b2 <realloc_block_FF+0x443>
  8037a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037a5:	8b 00                	mov    (%eax),%eax
  8037a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037aa:	8b 52 04             	mov    0x4(%edx),%edx
  8037ad:	89 50 04             	mov    %edx,0x4(%eax)
  8037b0:	eb 0b                	jmp    8037bd <realloc_block_FF+0x44e>
  8037b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037b5:	8b 40 04             	mov    0x4(%eax),%eax
  8037b8:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8037bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037c0:	8b 40 04             	mov    0x4(%eax),%eax
  8037c3:	85 c0                	test   %eax,%eax
  8037c5:	74 0f                	je     8037d6 <realloc_block_FF+0x467>
  8037c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ca:	8b 40 04             	mov    0x4(%eax),%eax
  8037cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037d0:	8b 12                	mov    (%edx),%edx
  8037d2:	89 10                	mov    %edx,(%eax)
  8037d4:	eb 0a                	jmp    8037e0 <realloc_block_FF+0x471>
  8037d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037d9:	8b 00                	mov    (%eax),%eax
  8037db:	a3 48 50 98 00       	mov    %eax,0x985048
  8037e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037f3:	a1 54 50 98 00       	mov    0x985054,%eax
  8037f8:	48                   	dec    %eax
  8037f9:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  8037fe:	83 ec 0c             	sub    $0xc,%esp
  803801:	ff 75 d4             	pushl  -0x2c(%ebp)
  803804:	e8 8d f0 ff ff       	call   802896 <insert_sorted_in_freeList>
  803809:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  80380c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80380f:	eb 05                	jmp    803816 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  803811:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803816:	c9                   	leave  
  803817:	c3                   	ret    

00803818 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803818:	55                   	push   %ebp
  803819:	89 e5                	mov    %esp,%ebp
  80381b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80381e:	83 ec 04             	sub    $0x4,%esp
  803821:	68 80 46 80 00       	push   $0x804680
  803826:	68 20 02 00 00       	push   $0x220
  80382b:	68 b7 45 80 00       	push   $0x8045b7
  803830:	e8 cf cf ff ff       	call   800804 <_panic>

00803835 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803835:	55                   	push   %ebp
  803836:	89 e5                	mov    %esp,%ebp
  803838:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80383b:	83 ec 04             	sub    $0x4,%esp
  80383e:	68 a8 46 80 00       	push   $0x8046a8
  803843:	68 28 02 00 00       	push   $0x228
  803848:	68 b7 45 80 00       	push   $0x8045b7
  80384d:	e8 b2 cf ff ff       	call   800804 <_panic>
  803852:	66 90                	xchg   %ax,%ax

00803854 <__udivdi3>:
  803854:	55                   	push   %ebp
  803855:	57                   	push   %edi
  803856:	56                   	push   %esi
  803857:	53                   	push   %ebx
  803858:	83 ec 1c             	sub    $0x1c,%esp
  80385b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80385f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803863:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803867:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80386b:	89 ca                	mov    %ecx,%edx
  80386d:	89 f8                	mov    %edi,%eax
  80386f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803873:	85 f6                	test   %esi,%esi
  803875:	75 2d                	jne    8038a4 <__udivdi3+0x50>
  803877:	39 cf                	cmp    %ecx,%edi
  803879:	77 65                	ja     8038e0 <__udivdi3+0x8c>
  80387b:	89 fd                	mov    %edi,%ebp
  80387d:	85 ff                	test   %edi,%edi
  80387f:	75 0b                	jne    80388c <__udivdi3+0x38>
  803881:	b8 01 00 00 00       	mov    $0x1,%eax
  803886:	31 d2                	xor    %edx,%edx
  803888:	f7 f7                	div    %edi
  80388a:	89 c5                	mov    %eax,%ebp
  80388c:	31 d2                	xor    %edx,%edx
  80388e:	89 c8                	mov    %ecx,%eax
  803890:	f7 f5                	div    %ebp
  803892:	89 c1                	mov    %eax,%ecx
  803894:	89 d8                	mov    %ebx,%eax
  803896:	f7 f5                	div    %ebp
  803898:	89 cf                	mov    %ecx,%edi
  80389a:	89 fa                	mov    %edi,%edx
  80389c:	83 c4 1c             	add    $0x1c,%esp
  80389f:	5b                   	pop    %ebx
  8038a0:	5e                   	pop    %esi
  8038a1:	5f                   	pop    %edi
  8038a2:	5d                   	pop    %ebp
  8038a3:	c3                   	ret    
  8038a4:	39 ce                	cmp    %ecx,%esi
  8038a6:	77 28                	ja     8038d0 <__udivdi3+0x7c>
  8038a8:	0f bd fe             	bsr    %esi,%edi
  8038ab:	83 f7 1f             	xor    $0x1f,%edi
  8038ae:	75 40                	jne    8038f0 <__udivdi3+0x9c>
  8038b0:	39 ce                	cmp    %ecx,%esi
  8038b2:	72 0a                	jb     8038be <__udivdi3+0x6a>
  8038b4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038b8:	0f 87 9e 00 00 00    	ja     80395c <__udivdi3+0x108>
  8038be:	b8 01 00 00 00       	mov    $0x1,%eax
  8038c3:	89 fa                	mov    %edi,%edx
  8038c5:	83 c4 1c             	add    $0x1c,%esp
  8038c8:	5b                   	pop    %ebx
  8038c9:	5e                   	pop    %esi
  8038ca:	5f                   	pop    %edi
  8038cb:	5d                   	pop    %ebp
  8038cc:	c3                   	ret    
  8038cd:	8d 76 00             	lea    0x0(%esi),%esi
  8038d0:	31 ff                	xor    %edi,%edi
  8038d2:	31 c0                	xor    %eax,%eax
  8038d4:	89 fa                	mov    %edi,%edx
  8038d6:	83 c4 1c             	add    $0x1c,%esp
  8038d9:	5b                   	pop    %ebx
  8038da:	5e                   	pop    %esi
  8038db:	5f                   	pop    %edi
  8038dc:	5d                   	pop    %ebp
  8038dd:	c3                   	ret    
  8038de:	66 90                	xchg   %ax,%ax
  8038e0:	89 d8                	mov    %ebx,%eax
  8038e2:	f7 f7                	div    %edi
  8038e4:	31 ff                	xor    %edi,%edi
  8038e6:	89 fa                	mov    %edi,%edx
  8038e8:	83 c4 1c             	add    $0x1c,%esp
  8038eb:	5b                   	pop    %ebx
  8038ec:	5e                   	pop    %esi
  8038ed:	5f                   	pop    %edi
  8038ee:	5d                   	pop    %ebp
  8038ef:	c3                   	ret    
  8038f0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8038f5:	89 eb                	mov    %ebp,%ebx
  8038f7:	29 fb                	sub    %edi,%ebx
  8038f9:	89 f9                	mov    %edi,%ecx
  8038fb:	d3 e6                	shl    %cl,%esi
  8038fd:	89 c5                	mov    %eax,%ebp
  8038ff:	88 d9                	mov    %bl,%cl
  803901:	d3 ed                	shr    %cl,%ebp
  803903:	89 e9                	mov    %ebp,%ecx
  803905:	09 f1                	or     %esi,%ecx
  803907:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80390b:	89 f9                	mov    %edi,%ecx
  80390d:	d3 e0                	shl    %cl,%eax
  80390f:	89 c5                	mov    %eax,%ebp
  803911:	89 d6                	mov    %edx,%esi
  803913:	88 d9                	mov    %bl,%cl
  803915:	d3 ee                	shr    %cl,%esi
  803917:	89 f9                	mov    %edi,%ecx
  803919:	d3 e2                	shl    %cl,%edx
  80391b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80391f:	88 d9                	mov    %bl,%cl
  803921:	d3 e8                	shr    %cl,%eax
  803923:	09 c2                	or     %eax,%edx
  803925:	89 d0                	mov    %edx,%eax
  803927:	89 f2                	mov    %esi,%edx
  803929:	f7 74 24 0c          	divl   0xc(%esp)
  80392d:	89 d6                	mov    %edx,%esi
  80392f:	89 c3                	mov    %eax,%ebx
  803931:	f7 e5                	mul    %ebp
  803933:	39 d6                	cmp    %edx,%esi
  803935:	72 19                	jb     803950 <__udivdi3+0xfc>
  803937:	74 0b                	je     803944 <__udivdi3+0xf0>
  803939:	89 d8                	mov    %ebx,%eax
  80393b:	31 ff                	xor    %edi,%edi
  80393d:	e9 58 ff ff ff       	jmp    80389a <__udivdi3+0x46>
  803942:	66 90                	xchg   %ax,%ax
  803944:	8b 54 24 08          	mov    0x8(%esp),%edx
  803948:	89 f9                	mov    %edi,%ecx
  80394a:	d3 e2                	shl    %cl,%edx
  80394c:	39 c2                	cmp    %eax,%edx
  80394e:	73 e9                	jae    803939 <__udivdi3+0xe5>
  803950:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803953:	31 ff                	xor    %edi,%edi
  803955:	e9 40 ff ff ff       	jmp    80389a <__udivdi3+0x46>
  80395a:	66 90                	xchg   %ax,%ax
  80395c:	31 c0                	xor    %eax,%eax
  80395e:	e9 37 ff ff ff       	jmp    80389a <__udivdi3+0x46>
  803963:	90                   	nop

00803964 <__umoddi3>:
  803964:	55                   	push   %ebp
  803965:	57                   	push   %edi
  803966:	56                   	push   %esi
  803967:	53                   	push   %ebx
  803968:	83 ec 1c             	sub    $0x1c,%esp
  80396b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80396f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803973:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803977:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80397b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80397f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803983:	89 f3                	mov    %esi,%ebx
  803985:	89 fa                	mov    %edi,%edx
  803987:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80398b:	89 34 24             	mov    %esi,(%esp)
  80398e:	85 c0                	test   %eax,%eax
  803990:	75 1a                	jne    8039ac <__umoddi3+0x48>
  803992:	39 f7                	cmp    %esi,%edi
  803994:	0f 86 a2 00 00 00    	jbe    803a3c <__umoddi3+0xd8>
  80399a:	89 c8                	mov    %ecx,%eax
  80399c:	89 f2                	mov    %esi,%edx
  80399e:	f7 f7                	div    %edi
  8039a0:	89 d0                	mov    %edx,%eax
  8039a2:	31 d2                	xor    %edx,%edx
  8039a4:	83 c4 1c             	add    $0x1c,%esp
  8039a7:	5b                   	pop    %ebx
  8039a8:	5e                   	pop    %esi
  8039a9:	5f                   	pop    %edi
  8039aa:	5d                   	pop    %ebp
  8039ab:	c3                   	ret    
  8039ac:	39 f0                	cmp    %esi,%eax
  8039ae:	0f 87 ac 00 00 00    	ja     803a60 <__umoddi3+0xfc>
  8039b4:	0f bd e8             	bsr    %eax,%ebp
  8039b7:	83 f5 1f             	xor    $0x1f,%ebp
  8039ba:	0f 84 ac 00 00 00    	je     803a6c <__umoddi3+0x108>
  8039c0:	bf 20 00 00 00       	mov    $0x20,%edi
  8039c5:	29 ef                	sub    %ebp,%edi
  8039c7:	89 fe                	mov    %edi,%esi
  8039c9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039cd:	89 e9                	mov    %ebp,%ecx
  8039cf:	d3 e0                	shl    %cl,%eax
  8039d1:	89 d7                	mov    %edx,%edi
  8039d3:	89 f1                	mov    %esi,%ecx
  8039d5:	d3 ef                	shr    %cl,%edi
  8039d7:	09 c7                	or     %eax,%edi
  8039d9:	89 e9                	mov    %ebp,%ecx
  8039db:	d3 e2                	shl    %cl,%edx
  8039dd:	89 14 24             	mov    %edx,(%esp)
  8039e0:	89 d8                	mov    %ebx,%eax
  8039e2:	d3 e0                	shl    %cl,%eax
  8039e4:	89 c2                	mov    %eax,%edx
  8039e6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039ea:	d3 e0                	shl    %cl,%eax
  8039ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039f0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039f4:	89 f1                	mov    %esi,%ecx
  8039f6:	d3 e8                	shr    %cl,%eax
  8039f8:	09 d0                	or     %edx,%eax
  8039fa:	d3 eb                	shr    %cl,%ebx
  8039fc:	89 da                	mov    %ebx,%edx
  8039fe:	f7 f7                	div    %edi
  803a00:	89 d3                	mov    %edx,%ebx
  803a02:	f7 24 24             	mull   (%esp)
  803a05:	89 c6                	mov    %eax,%esi
  803a07:	89 d1                	mov    %edx,%ecx
  803a09:	39 d3                	cmp    %edx,%ebx
  803a0b:	0f 82 87 00 00 00    	jb     803a98 <__umoddi3+0x134>
  803a11:	0f 84 91 00 00 00    	je     803aa8 <__umoddi3+0x144>
  803a17:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a1b:	29 f2                	sub    %esi,%edx
  803a1d:	19 cb                	sbb    %ecx,%ebx
  803a1f:	89 d8                	mov    %ebx,%eax
  803a21:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a25:	d3 e0                	shl    %cl,%eax
  803a27:	89 e9                	mov    %ebp,%ecx
  803a29:	d3 ea                	shr    %cl,%edx
  803a2b:	09 d0                	or     %edx,%eax
  803a2d:	89 e9                	mov    %ebp,%ecx
  803a2f:	d3 eb                	shr    %cl,%ebx
  803a31:	89 da                	mov    %ebx,%edx
  803a33:	83 c4 1c             	add    $0x1c,%esp
  803a36:	5b                   	pop    %ebx
  803a37:	5e                   	pop    %esi
  803a38:	5f                   	pop    %edi
  803a39:	5d                   	pop    %ebp
  803a3a:	c3                   	ret    
  803a3b:	90                   	nop
  803a3c:	89 fd                	mov    %edi,%ebp
  803a3e:	85 ff                	test   %edi,%edi
  803a40:	75 0b                	jne    803a4d <__umoddi3+0xe9>
  803a42:	b8 01 00 00 00       	mov    $0x1,%eax
  803a47:	31 d2                	xor    %edx,%edx
  803a49:	f7 f7                	div    %edi
  803a4b:	89 c5                	mov    %eax,%ebp
  803a4d:	89 f0                	mov    %esi,%eax
  803a4f:	31 d2                	xor    %edx,%edx
  803a51:	f7 f5                	div    %ebp
  803a53:	89 c8                	mov    %ecx,%eax
  803a55:	f7 f5                	div    %ebp
  803a57:	89 d0                	mov    %edx,%eax
  803a59:	e9 44 ff ff ff       	jmp    8039a2 <__umoddi3+0x3e>
  803a5e:	66 90                	xchg   %ax,%ax
  803a60:	89 c8                	mov    %ecx,%eax
  803a62:	89 f2                	mov    %esi,%edx
  803a64:	83 c4 1c             	add    $0x1c,%esp
  803a67:	5b                   	pop    %ebx
  803a68:	5e                   	pop    %esi
  803a69:	5f                   	pop    %edi
  803a6a:	5d                   	pop    %ebp
  803a6b:	c3                   	ret    
  803a6c:	3b 04 24             	cmp    (%esp),%eax
  803a6f:	72 06                	jb     803a77 <__umoddi3+0x113>
  803a71:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a75:	77 0f                	ja     803a86 <__umoddi3+0x122>
  803a77:	89 f2                	mov    %esi,%edx
  803a79:	29 f9                	sub    %edi,%ecx
  803a7b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a7f:	89 14 24             	mov    %edx,(%esp)
  803a82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a86:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a8a:	8b 14 24             	mov    (%esp),%edx
  803a8d:	83 c4 1c             	add    $0x1c,%esp
  803a90:	5b                   	pop    %ebx
  803a91:	5e                   	pop    %esi
  803a92:	5f                   	pop    %edi
  803a93:	5d                   	pop    %ebp
  803a94:	c3                   	ret    
  803a95:	8d 76 00             	lea    0x0(%esi),%esi
  803a98:	2b 04 24             	sub    (%esp),%eax
  803a9b:	19 fa                	sbb    %edi,%edx
  803a9d:	89 d1                	mov    %edx,%ecx
  803a9f:	89 c6                	mov    %eax,%esi
  803aa1:	e9 71 ff ff ff       	jmp    803a17 <__umoddi3+0xb3>
  803aa6:	66 90                	xchg   %ax,%ax
  803aa8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803aac:	72 ea                	jb     803a98 <__umoddi3+0x134>
  803aae:	89 d9                	mov    %ebx,%ecx
  803ab0:	e9 62 ff ff ff       	jmp    803a17 <__umoddi3+0xb3>
