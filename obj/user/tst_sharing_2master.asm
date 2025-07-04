
obj/user/tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 1d 04 00 00       	call   800453 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the shared variables, initialize them and run slaves
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
  80005c:	68 60 38 80 00       	push   $0x803860
  800061:	6a 14                	push   $0x14
  800063:	68 7c 38 80 00       	push   $0x80387c
  800068:	e8 2b 05 00 00       	call   800598 <_panic>
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
	int diff, expected;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  800082:	e8 53 1d 00 00       	call   801dda <sys_calculate_free_frames>
  800087:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = smalloc("x", 4, 0);
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	6a 00                	push   $0x0
  80008f:	6a 04                	push   $0x4
  800091:	68 97 38 80 00       	push   $0x803897
  800096:	e8 21 18 00 00       	call   8018bc <smalloc>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (x != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8000a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8000a7:	74 17                	je     8000c0 <_main+0x88>
  8000a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000b0:	83 ec 0c             	sub    $0xc,%esp
  8000b3:	68 9c 38 80 00       	push   $0x80389c
  8000b8:	e8 98 07 00 00       	call   800855 <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp
	expected = 1+1 ; /*1page +1table*/
  8000c0:	c7 45 e0 02 00 00 00 	movl   $0x2,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8000c7:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000ca:	e8 0b 1d 00 00       	call   801dda <sys_calculate_free_frames>
  8000cf:	29 c3                	sub    %eax,%ebx
  8000d1:	89 d8                	mov    %ebx,%eax
  8000d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8000d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000d9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000dc:	7c 0b                	jl     8000e9 <_main+0xb1>
  8000de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000e1:	83 c0 02             	add    $0x2,%eax
  8000e4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8000e7:	7d 27                	jge    800110 <_main+0xd8>
  8000e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000f0:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f3:	e8 e2 1c 00 00       	call   801dda <sys_calculate_free_frames>
  8000f8:	29 c3                	sub    %eax,%ebx
  8000fa:	89 d8                	mov    %ebx,%eax
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	ff 75 e0             	pushl  -0x20(%ebp)
  800102:	50                   	push   %eax
  800103:	68 00 39 80 00       	push   $0x803900
  800108:	e8 48 07 00 00       	call   800855 <cprintf>
  80010d:	83 c4 10             	add    $0x10,%esp

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  800110:	e8 c5 1c 00 00       	call   801dda <sys_calculate_free_frames>
  800115:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = smalloc("y", 4, 0);
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	6a 00                	push   $0x0
  80011d:	6a 04                	push   $0x4
  80011f:	68 98 39 80 00       	push   $0x803998
  800124:	e8 93 17 00 00       	call   8018bc <smalloc>
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (y != (uint32*)(pagealloc_start + 1 * PAGE_SIZE)) {is_correct = 0; cprintf("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  80012f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800132:	05 00 10 00 00       	add    $0x1000,%eax
  800137:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80013a:	74 17                	je     800153 <_main+0x11b>
  80013c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	68 9c 38 80 00       	push   $0x80389c
  80014b:	e8 05 07 00 00       	call   800855 <cprintf>
  800150:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  800153:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  80015a:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  80015d:	e8 78 1c 00 00       	call   801dda <sys_calculate_free_frames>
  800162:	29 c3                	sub    %eax,%ebx
  800164:	89 d8                	mov    %ebx,%eax
  800166:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800169:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80016c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80016f:	7c 0b                	jl     80017c <_main+0x144>
  800171:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800174:	83 c0 02             	add    $0x2,%eax
  800177:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80017a:	7d 27                	jge    8001a3 <_main+0x16b>
  80017c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800183:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800186:	e8 4f 1c 00 00       	call   801dda <sys_calculate_free_frames>
  80018b:	29 c3                	sub    %eax,%ebx
  80018d:	89 d8                	mov    %ebx,%eax
  80018f:	83 ec 04             	sub    $0x4,%esp
  800192:	ff 75 e0             	pushl  -0x20(%ebp)
  800195:	50                   	push   %eax
  800196:	68 00 39 80 00       	push   $0x803900
  80019b:	e8 b5 06 00 00       	call   800855 <cprintf>
  8001a0:	83 c4 10             	add    $0x10,%esp

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  8001a3:	e8 32 1c 00 00       	call   801dda <sys_calculate_free_frames>
  8001a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = smalloc("z", 4, 1);
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	6a 01                	push   $0x1
  8001b0:	6a 04                	push   $0x4
  8001b2:	68 9a 39 80 00       	push   $0x80399a
  8001b7:	e8 00 17 00 00       	call   8018bc <smalloc>
  8001bc:	83 c4 10             	add    $0x10,%esp
  8001bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (z != (uint32*)(pagealloc_start + 2 * PAGE_SIZE)) {is_correct = 0; cprintf("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8001c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001c5:	05 00 20 00 00       	add    $0x2000,%eax
  8001ca:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8001cd:	74 17                	je     8001e6 <_main+0x1ae>
  8001cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	68 9c 38 80 00       	push   $0x80389c
  8001de:	e8 72 06 00 00       	call   800855 <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  8001e6:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8001ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001f0:	e8 e5 1b 00 00       	call   801dda <sys_calculate_free_frames>
  8001f5:	29 c3                	sub    %eax,%ebx
  8001f7:	89 d8                	mov    %ebx,%eax
  8001f9:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8001fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ff:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800202:	7c 0b                	jl     80020f <_main+0x1d7>
  800204:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800207:	83 c0 02             	add    $0x2,%eax
  80020a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80020d:	7d 27                	jge    800236 <_main+0x1fe>
  80020f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800216:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800219:	e8 bc 1b 00 00       	call   801dda <sys_calculate_free_frames>
  80021e:	29 c3                	sub    %eax,%ebx
  800220:	89 d8                	mov    %ebx,%eax
  800222:	83 ec 04             	sub    $0x4,%esp
  800225:	ff 75 e0             	pushl  -0x20(%ebp)
  800228:	50                   	push   %eax
  800229:	68 00 39 80 00       	push   $0x803900
  80022e:	e8 22 06 00 00       	call   800855 <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  800236:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80023a:	74 04                	je     800240 <_main+0x208>
  80023c:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  800240:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	*x = 10 ;
  800247:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80024a:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  800250:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800253:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800259:	a1 20 50 80 00       	mov    0x805020,%eax
  80025e:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  800264:	a1 20 50 80 00       	mov    0x805020,%eax
  800269:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  80026f:	89 c1                	mov    %eax,%ecx
  800271:	a1 20 50 80 00       	mov    0x805020,%eax
  800276:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80027c:	52                   	push   %edx
  80027d:	51                   	push   %ecx
  80027e:	50                   	push   %eax
  80027f:	68 9c 39 80 00       	push   $0x80399c
  800284:	e8 ac 1c 00 00       	call   801f35 <sys_create_env>
  800289:	83 c4 10             	add    $0x10,%esp
  80028c:	89 45 d0             	mov    %eax,-0x30(%ebp)
	id2 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80028f:	a1 20 50 80 00       	mov    0x805020,%eax
  800294:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  80029a:	a1 20 50 80 00       	mov    0x805020,%eax
  80029f:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  8002a5:	89 c1                	mov    %eax,%ecx
  8002a7:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ac:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8002b2:	52                   	push   %edx
  8002b3:	51                   	push   %ecx
  8002b4:	50                   	push   %eax
  8002b5:	68 9c 39 80 00       	push   $0x80399c
  8002ba:	e8 76 1c 00 00       	call   801f35 <sys_create_env>
  8002bf:	83 c4 10             	add    $0x10,%esp
  8002c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
	id3 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8002c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ca:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  8002d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8002d5:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  8002db:	89 c1                	mov    %eax,%ecx
  8002dd:	a1 20 50 80 00       	mov    0x805020,%eax
  8002e2:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8002e8:	52                   	push   %edx
  8002e9:	51                   	push   %ecx
  8002ea:	50                   	push   %eax
  8002eb:	68 9c 39 80 00       	push   $0x80399c
  8002f0:	e8 40 1c 00 00       	call   801f35 <sys_create_env>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	89 45 c8             	mov    %eax,-0x38(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  8002fb:	e8 81 1d 00 00       	call   802081 <rsttst>

	sys_run_env(id1);
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	ff 75 d0             	pushl  -0x30(%ebp)
  800306:	e8 48 1c 00 00       	call   801f53 <sys_run_env>
  80030b:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80030e:	83 ec 0c             	sub    $0xc,%esp
  800311:	ff 75 cc             	pushl  -0x34(%ebp)
  800314:	e8 3a 1c 00 00       	call   801f53 <sys_run_env>
  800319:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80031c:	83 ec 0c             	sub    $0xc,%esp
  80031f:	ff 75 c8             	pushl  -0x38(%ebp)
  800322:	e8 2c 1c 00 00       	call   801f53 <sys_run_env>
  800327:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	while (gettst()!=3) ;// panic("test failed");
  80032a:	90                   	nop
  80032b:	e8 cb 1d 00 00       	call   8020fb <gettst>
  800330:	83 f8 03             	cmp    $0x3,%eax
  800333:	75 f6                	jne    80032b <_main+0x2f3>


	if (*z != 30)
  800335:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800338:	8b 00                	mov    (%eax),%eax
  80033a:	83 f8 1e             	cmp    $0x1e,%eax
  80033d:	74 17                	je     800356 <_main+0x31e>
	{is_correct = 0; cprintf("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");}
  80033f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800346:	83 ec 0c             	sub    $0xc,%esp
  800349:	68 a8 39 80 00       	push   $0x8039a8
  80034e:	e8 02 05 00 00       	call   800855 <cprintf>
  800353:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  800356:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80035a:	74 04                	je     800360 <_main+0x328>
  80035c:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  800360:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	atomic_cprintf("%@Now, attempting to write a ReadOnly variable\n\n\n");
  800367:	83 ec 0c             	sub    $0xc,%esp
  80036a:	68 f4 39 80 00       	push   $0x8039f4
  80036f:	e8 0e 05 00 00       	call   800882 <atomic_cprintf>
  800374:	83 c4 10             	add    $0x10,%esp

	id1 = sys_create_env("shr2Slave2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800377:	a1 20 50 80 00       	mov    0x805020,%eax
  80037c:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  800382:	a1 20 50 80 00       	mov    0x805020,%eax
  800387:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  80038d:	89 c1                	mov    %eax,%ecx
  80038f:	a1 20 50 80 00       	mov    0x805020,%eax
  800394:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80039a:	52                   	push   %edx
  80039b:	51                   	push   %ecx
  80039c:	50                   	push   %eax
  80039d:	68 26 3a 80 00       	push   $0x803a26
  8003a2:	e8 8e 1b 00 00       	call   801f35 <sys_create_env>
  8003a7:	83 c4 10             	add    $0x10,%esp
  8003aa:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  8003ad:	83 ec 0c             	sub    $0xc,%esp
  8003b0:	ff 75 d0             	pushl  -0x30(%ebp)
  8003b3:	e8 9b 1b 00 00       	call   801f53 <sys_run_env>
  8003b8:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environment edits the z variable
	while (gettst() != 4) ;
  8003bb:	90                   	nop
  8003bc:	e8 3a 1d 00 00       	call   8020fb <gettst>
  8003c1:	83 f8 04             	cmp    $0x4,%eax
  8003c4:	75 f6                	jne    8003bc <_main+0x384>

	if (*z != 50)
  8003c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c9:	8b 00                	mov    (%eax),%eax
  8003cb:	83 f8 32             	cmp    $0x32,%eax
  8003ce:	74 17                	je     8003e7 <_main+0x3af>
	{is_correct = 0; cprintf("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");}
  8003d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d7:	83 ec 0c             	sub    $0xc,%esp
  8003da:	68 a8 39 80 00       	push   $0x8039a8
  8003df:	e8 71 04 00 00       	call   800855 <cprintf>
  8003e4:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  8003e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8003eb:	74 04                	je     8003f1 <_main+0x3b9>
  8003ed:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  8003f1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//Signal slave2
	inctst();
  8003f8:	e8 e4 1c 00 00       	call   8020e1 <inctst>

	//to ensure that the slave environment attempt to edit the x variable
	while (gettst()!=6) ;// panic("test failed");
  8003fd:	90                   	nop
  8003fe:	e8 f8 1c 00 00       	call   8020fb <gettst>
  800403:	83 f8 06             	cmp    $0x6,%eax
  800406:	75 f6                	jne    8003fe <_main+0x3c6>

	if (*x != 10)
  800408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80040b:	8b 00                	mov    (%eax),%eax
  80040d:	83 f8 0a             	cmp    $0xa,%eax
  800410:	74 17                	je     800429 <_main+0x3f1>
	{is_correct = 0; cprintf("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");}
  800412:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800419:	83 ec 0c             	sub    $0xc,%esp
  80041c:	68 a8 39 80 00       	push   $0x8039a8
  800421:	e8 2f 04 00 00       	call   800855 <cprintf>
  800426:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  800429:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80042d:	74 04                	je     800433 <_main+0x3fb>
  80042f:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  800433:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("\n%~Test of Shared Variables [Create & Get] completed. Eval = %d%%\n\n", eval);
  80043a:	83 ec 08             	sub    $0x8,%esp
  80043d:	ff 75 f4             	pushl  -0xc(%ebp)
  800440:	68 34 3a 80 00       	push   $0x803a34
  800445:	e8 0b 04 00 00       	call   800855 <cprintf>
  80044a:	83 c4 10             	add    $0x10,%esp
	return;
  80044d:	90                   	nop
}
  80044e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800451:	c9                   	leave  
  800452:	c3                   	ret    

00800453 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800453:	55                   	push   %ebp
  800454:	89 e5                	mov    %esp,%ebp
  800456:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800459:	e8 45 1b 00 00       	call   801fa3 <sys_getenvindex>
  80045e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800461:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800464:	89 d0                	mov    %edx,%eax
  800466:	c1 e0 02             	shl    $0x2,%eax
  800469:	01 d0                	add    %edx,%eax
  80046b:	c1 e0 03             	shl    $0x3,%eax
  80046e:	01 d0                	add    %edx,%eax
  800470:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800477:	01 d0                	add    %edx,%eax
  800479:	c1 e0 02             	shl    $0x2,%eax
  80047c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800481:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800486:	a1 20 50 80 00       	mov    0x805020,%eax
  80048b:	8a 40 20             	mov    0x20(%eax),%al
  80048e:	84 c0                	test   %al,%al
  800490:	74 0d                	je     80049f <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800492:	a1 20 50 80 00       	mov    0x805020,%eax
  800497:	83 c0 20             	add    $0x20,%eax
  80049a:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80049f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004a3:	7e 0a                	jle    8004af <libmain+0x5c>
		binaryname = argv[0];
  8004a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8004af:	83 ec 08             	sub    $0x8,%esp
  8004b2:	ff 75 0c             	pushl  0xc(%ebp)
  8004b5:	ff 75 08             	pushl  0x8(%ebp)
  8004b8:	e8 7b fb ff ff       	call   800038 <_main>
  8004bd:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8004c0:	a1 00 50 80 00       	mov    0x805000,%eax
  8004c5:	85 c0                	test   %eax,%eax
  8004c7:	0f 84 9f 00 00 00    	je     80056c <libmain+0x119>
	{
		sys_lock_cons();
  8004cd:	e8 55 18 00 00       	call   801d27 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8004d2:	83 ec 0c             	sub    $0xc,%esp
  8004d5:	68 90 3a 80 00       	push   $0x803a90
  8004da:	e8 76 03 00 00       	call   800855 <cprintf>
  8004df:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004e2:	a1 20 50 80 00       	mov    0x805020,%eax
  8004e7:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8004ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f2:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8004f8:	83 ec 04             	sub    $0x4,%esp
  8004fb:	52                   	push   %edx
  8004fc:	50                   	push   %eax
  8004fd:	68 b8 3a 80 00       	push   $0x803ab8
  800502:	e8 4e 03 00 00       	call   800855 <cprintf>
  800507:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80050a:	a1 20 50 80 00       	mov    0x805020,%eax
  80050f:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800515:	a1 20 50 80 00       	mov    0x805020,%eax
  80051a:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800520:	a1 20 50 80 00       	mov    0x805020,%eax
  800525:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80052b:	51                   	push   %ecx
  80052c:	52                   	push   %edx
  80052d:	50                   	push   %eax
  80052e:	68 e0 3a 80 00       	push   $0x803ae0
  800533:	e8 1d 03 00 00       	call   800855 <cprintf>
  800538:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80053b:	a1 20 50 80 00       	mov    0x805020,%eax
  800540:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800546:	83 ec 08             	sub    $0x8,%esp
  800549:	50                   	push   %eax
  80054a:	68 38 3b 80 00       	push   $0x803b38
  80054f:	e8 01 03 00 00       	call   800855 <cprintf>
  800554:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800557:	83 ec 0c             	sub    $0xc,%esp
  80055a:	68 90 3a 80 00       	push   $0x803a90
  80055f:	e8 f1 02 00 00       	call   800855 <cprintf>
  800564:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800567:	e8 d5 17 00 00       	call   801d41 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80056c:	e8 19 00 00 00       	call   80058a <exit>
}
  800571:	90                   	nop
  800572:	c9                   	leave  
  800573:	c3                   	ret    

00800574 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800574:	55                   	push   %ebp
  800575:	89 e5                	mov    %esp,%ebp
  800577:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80057a:	83 ec 0c             	sub    $0xc,%esp
  80057d:	6a 00                	push   $0x0
  80057f:	e8 eb 19 00 00       	call   801f6f <sys_destroy_env>
  800584:	83 c4 10             	add    $0x10,%esp
}
  800587:	90                   	nop
  800588:	c9                   	leave  
  800589:	c3                   	ret    

0080058a <exit>:

void
exit(void)
{
  80058a:	55                   	push   %ebp
  80058b:	89 e5                	mov    %esp,%ebp
  80058d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800590:	e8 40 1a 00 00       	call   801fd5 <sys_exit_env>
}
  800595:	90                   	nop
  800596:	c9                   	leave  
  800597:	c3                   	ret    

00800598 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800598:	55                   	push   %ebp
  800599:	89 e5                	mov    %esp,%ebp
  80059b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80059e:	8d 45 10             	lea    0x10(%ebp),%eax
  8005a1:	83 c0 04             	add    $0x4,%eax
  8005a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8005a7:	a1 60 50 98 00       	mov    0x985060,%eax
  8005ac:	85 c0                	test   %eax,%eax
  8005ae:	74 16                	je     8005c6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005b0:	a1 60 50 98 00       	mov    0x985060,%eax
  8005b5:	83 ec 08             	sub    $0x8,%esp
  8005b8:	50                   	push   %eax
  8005b9:	68 4c 3b 80 00       	push   $0x803b4c
  8005be:	e8 92 02 00 00       	call   800855 <cprintf>
  8005c3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005c6:	a1 04 50 80 00       	mov    0x805004,%eax
  8005cb:	ff 75 0c             	pushl  0xc(%ebp)
  8005ce:	ff 75 08             	pushl  0x8(%ebp)
  8005d1:	50                   	push   %eax
  8005d2:	68 51 3b 80 00       	push   $0x803b51
  8005d7:	e8 79 02 00 00       	call   800855 <cprintf>
  8005dc:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005df:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e2:	83 ec 08             	sub    $0x8,%esp
  8005e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e8:	50                   	push   %eax
  8005e9:	e8 fc 01 00 00       	call   8007ea <vcprintf>
  8005ee:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005f1:	83 ec 08             	sub    $0x8,%esp
  8005f4:	6a 00                	push   $0x0
  8005f6:	68 6d 3b 80 00       	push   $0x803b6d
  8005fb:	e8 ea 01 00 00       	call   8007ea <vcprintf>
  800600:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800603:	e8 82 ff ff ff       	call   80058a <exit>

	// should not return here
	while (1) ;
  800608:	eb fe                	jmp    800608 <_panic+0x70>

0080060a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80060a:	55                   	push   %ebp
  80060b:	89 e5                	mov    %esp,%ebp
  80060d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800610:	a1 20 50 80 00       	mov    0x805020,%eax
  800615:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80061b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061e:	39 c2                	cmp    %eax,%edx
  800620:	74 14                	je     800636 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800622:	83 ec 04             	sub    $0x4,%esp
  800625:	68 70 3b 80 00       	push   $0x803b70
  80062a:	6a 26                	push   $0x26
  80062c:	68 bc 3b 80 00       	push   $0x803bbc
  800631:	e8 62 ff ff ff       	call   800598 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800636:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80063d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800644:	e9 c5 00 00 00       	jmp    80070e <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800653:	8b 45 08             	mov    0x8(%ebp),%eax
  800656:	01 d0                	add    %edx,%eax
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	85 c0                	test   %eax,%eax
  80065c:	75 08                	jne    800666 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80065e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800661:	e9 a5 00 00 00       	jmp    80070b <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800666:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80066d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800674:	eb 69                	jmp    8006df <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800676:	a1 20 50 80 00       	mov    0x805020,%eax
  80067b:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800681:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800684:	89 d0                	mov    %edx,%eax
  800686:	01 c0                	add    %eax,%eax
  800688:	01 d0                	add    %edx,%eax
  80068a:	c1 e0 03             	shl    $0x3,%eax
  80068d:	01 c8                	add    %ecx,%eax
  80068f:	8a 40 04             	mov    0x4(%eax),%al
  800692:	84 c0                	test   %al,%al
  800694:	75 46                	jne    8006dc <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800696:	a1 20 50 80 00       	mov    0x805020,%eax
  80069b:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8006a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006a4:	89 d0                	mov    %edx,%eax
  8006a6:	01 c0                	add    %eax,%eax
  8006a8:	01 d0                	add    %edx,%eax
  8006aa:	c1 e0 03             	shl    $0x3,%eax
  8006ad:	01 c8                	add    %ecx,%eax
  8006af:	8b 00                	mov    (%eax),%eax
  8006b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006bc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8006be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	01 c8                	add    %ecx,%eax
  8006cd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006cf:	39 c2                	cmp    %eax,%edx
  8006d1:	75 09                	jne    8006dc <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8006d3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006da:	eb 15                	jmp    8006f1 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006dc:	ff 45 e8             	incl   -0x18(%ebp)
  8006df:	a1 20 50 80 00       	mov    0x805020,%eax
  8006e4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8006ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006ed:	39 c2                	cmp    %eax,%edx
  8006ef:	77 85                	ja     800676 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8006f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006f5:	75 14                	jne    80070b <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8006f7:	83 ec 04             	sub    $0x4,%esp
  8006fa:	68 c8 3b 80 00       	push   $0x803bc8
  8006ff:	6a 3a                	push   $0x3a
  800701:	68 bc 3b 80 00       	push   $0x803bbc
  800706:	e8 8d fe ff ff       	call   800598 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80070b:	ff 45 f0             	incl   -0x10(%ebp)
  80070e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800711:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800714:	0f 8c 2f ff ff ff    	jl     800649 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80071a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800721:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800728:	eb 26                	jmp    800750 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80072a:	a1 20 50 80 00       	mov    0x805020,%eax
  80072f:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800735:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800738:	89 d0                	mov    %edx,%eax
  80073a:	01 c0                	add    %eax,%eax
  80073c:	01 d0                	add    %edx,%eax
  80073e:	c1 e0 03             	shl    $0x3,%eax
  800741:	01 c8                	add    %ecx,%eax
  800743:	8a 40 04             	mov    0x4(%eax),%al
  800746:	3c 01                	cmp    $0x1,%al
  800748:	75 03                	jne    80074d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80074a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80074d:	ff 45 e0             	incl   -0x20(%ebp)
  800750:	a1 20 50 80 00       	mov    0x805020,%eax
  800755:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80075b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80075e:	39 c2                	cmp    %eax,%edx
  800760:	77 c8                	ja     80072a <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800765:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800768:	74 14                	je     80077e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80076a:	83 ec 04             	sub    $0x4,%esp
  80076d:	68 1c 3c 80 00       	push   $0x803c1c
  800772:	6a 44                	push   $0x44
  800774:	68 bc 3b 80 00       	push   $0x803bbc
  800779:	e8 1a fe ff ff       	call   800598 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80077e:	90                   	nop
  80077f:	c9                   	leave  
  800780:	c3                   	ret    

00800781 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800781:	55                   	push   %ebp
  800782:	89 e5                	mov    %esp,%ebp
  800784:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800787:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078a:	8b 00                	mov    (%eax),%eax
  80078c:	8d 48 01             	lea    0x1(%eax),%ecx
  80078f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800792:	89 0a                	mov    %ecx,(%edx)
  800794:	8b 55 08             	mov    0x8(%ebp),%edx
  800797:	88 d1                	mov    %dl,%cl
  800799:	8b 55 0c             	mov    0xc(%ebp),%edx
  80079c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8007a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a3:	8b 00                	mov    (%eax),%eax
  8007a5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007aa:	75 2c                	jne    8007d8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8007ac:	a0 44 50 98 00       	mov    0x985044,%al
  8007b1:	0f b6 c0             	movzbl %al,%eax
  8007b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007b7:	8b 12                	mov    (%edx),%edx
  8007b9:	89 d1                	mov    %edx,%ecx
  8007bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007be:	83 c2 08             	add    $0x8,%edx
  8007c1:	83 ec 04             	sub    $0x4,%esp
  8007c4:	50                   	push   %eax
  8007c5:	51                   	push   %ecx
  8007c6:	52                   	push   %edx
  8007c7:	e8 19 15 00 00       	call   801ce5 <sys_cputs>
  8007cc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007db:	8b 40 04             	mov    0x4(%eax),%eax
  8007de:	8d 50 01             	lea    0x1(%eax),%edx
  8007e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007e7:	90                   	nop
  8007e8:	c9                   	leave  
  8007e9:	c3                   	ret    

008007ea <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007ea:	55                   	push   %ebp
  8007eb:	89 e5                	mov    %esp,%ebp
  8007ed:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007f3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007fa:	00 00 00 
	b.cnt = 0;
  8007fd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800804:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800807:	ff 75 0c             	pushl  0xc(%ebp)
  80080a:	ff 75 08             	pushl  0x8(%ebp)
  80080d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800813:	50                   	push   %eax
  800814:	68 81 07 80 00       	push   $0x800781
  800819:	e8 11 02 00 00       	call   800a2f <vprintfmt>
  80081e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800821:	a0 44 50 98 00       	mov    0x985044,%al
  800826:	0f b6 c0             	movzbl %al,%eax
  800829:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	50                   	push   %eax
  800833:	52                   	push   %edx
  800834:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80083a:	83 c0 08             	add    $0x8,%eax
  80083d:	50                   	push   %eax
  80083e:	e8 a2 14 00 00       	call   801ce5 <sys_cputs>
  800843:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800846:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  80084d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800853:	c9                   	leave  
  800854:	c3                   	ret    

00800855 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800855:	55                   	push   %ebp
  800856:	89 e5                	mov    %esp,%ebp
  800858:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80085b:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  800862:	8d 45 0c             	lea    0xc(%ebp),%eax
  800865:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	83 ec 08             	sub    $0x8,%esp
  80086e:	ff 75 f4             	pushl  -0xc(%ebp)
  800871:	50                   	push   %eax
  800872:	e8 73 ff ff ff       	call   8007ea <vcprintf>
  800877:	83 c4 10             	add    $0x10,%esp
  80087a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80087d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800880:	c9                   	leave  
  800881:	c3                   	ret    

00800882 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800888:	e8 9a 14 00 00       	call   801d27 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80088d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800890:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800893:	8b 45 08             	mov    0x8(%ebp),%eax
  800896:	83 ec 08             	sub    $0x8,%esp
  800899:	ff 75 f4             	pushl  -0xc(%ebp)
  80089c:	50                   	push   %eax
  80089d:	e8 48 ff ff ff       	call   8007ea <vcprintf>
  8008a2:	83 c4 10             	add    $0x10,%esp
  8008a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8008a8:	e8 94 14 00 00       	call   801d41 <sys_unlock_cons>
	return cnt;
  8008ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008b0:	c9                   	leave  
  8008b1:	c3                   	ret    

008008b2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008b2:	55                   	push   %ebp
  8008b3:	89 e5                	mov    %esp,%ebp
  8008b5:	53                   	push   %ebx
  8008b6:	83 ec 14             	sub    $0x14,%esp
  8008b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008c5:	8b 45 18             	mov    0x18(%ebp),%eax
  8008c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008cd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008d0:	77 55                	ja     800927 <printnum+0x75>
  8008d2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008d5:	72 05                	jb     8008dc <printnum+0x2a>
  8008d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008da:	77 4b                	ja     800927 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008dc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008df:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008e2:	8b 45 18             	mov    0x18(%ebp),%eax
  8008e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ea:	52                   	push   %edx
  8008eb:	50                   	push   %eax
  8008ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8008f2:	e8 f1 2c 00 00       	call   8035e8 <__udivdi3>
  8008f7:	83 c4 10             	add    $0x10,%esp
  8008fa:	83 ec 04             	sub    $0x4,%esp
  8008fd:	ff 75 20             	pushl  0x20(%ebp)
  800900:	53                   	push   %ebx
  800901:	ff 75 18             	pushl  0x18(%ebp)
  800904:	52                   	push   %edx
  800905:	50                   	push   %eax
  800906:	ff 75 0c             	pushl  0xc(%ebp)
  800909:	ff 75 08             	pushl  0x8(%ebp)
  80090c:	e8 a1 ff ff ff       	call   8008b2 <printnum>
  800911:	83 c4 20             	add    $0x20,%esp
  800914:	eb 1a                	jmp    800930 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800916:	83 ec 08             	sub    $0x8,%esp
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	ff 75 20             	pushl  0x20(%ebp)
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax
  800922:	ff d0                	call   *%eax
  800924:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800927:	ff 4d 1c             	decl   0x1c(%ebp)
  80092a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80092e:	7f e6                	jg     800916 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800930:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800933:	bb 00 00 00 00       	mov    $0x0,%ebx
  800938:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80093b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80093e:	53                   	push   %ebx
  80093f:	51                   	push   %ecx
  800940:	52                   	push   %edx
  800941:	50                   	push   %eax
  800942:	e8 b1 2d 00 00       	call   8036f8 <__umoddi3>
  800947:	83 c4 10             	add    $0x10,%esp
  80094a:	05 94 3e 80 00       	add    $0x803e94,%eax
  80094f:	8a 00                	mov    (%eax),%al
  800951:	0f be c0             	movsbl %al,%eax
  800954:	83 ec 08             	sub    $0x8,%esp
  800957:	ff 75 0c             	pushl  0xc(%ebp)
  80095a:	50                   	push   %eax
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	ff d0                	call   *%eax
  800960:	83 c4 10             	add    $0x10,%esp
}
  800963:	90                   	nop
  800964:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800967:	c9                   	leave  
  800968:	c3                   	ret    

00800969 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80096c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800970:	7e 1c                	jle    80098e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
  800975:	8b 00                	mov    (%eax),%eax
  800977:	8d 50 08             	lea    0x8(%eax),%edx
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	89 10                	mov    %edx,(%eax)
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	8b 00                	mov    (%eax),%eax
  800984:	83 e8 08             	sub    $0x8,%eax
  800987:	8b 50 04             	mov    0x4(%eax),%edx
  80098a:	8b 00                	mov    (%eax),%eax
  80098c:	eb 40                	jmp    8009ce <getuint+0x65>
	else if (lflag)
  80098e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800992:	74 1e                	je     8009b2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	8b 00                	mov    (%eax),%eax
  800999:	8d 50 04             	lea    0x4(%eax),%edx
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	89 10                	mov    %edx,(%eax)
  8009a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a4:	8b 00                	mov    (%eax),%eax
  8009a6:	83 e8 04             	sub    $0x4,%eax
  8009a9:	8b 00                	mov    (%eax),%eax
  8009ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b0:	eb 1c                	jmp    8009ce <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	8b 00                	mov    (%eax),%eax
  8009b7:	8d 50 04             	lea    0x4(%eax),%edx
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	89 10                	mov    %edx,(%eax)
  8009bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c2:	8b 00                	mov    (%eax),%eax
  8009c4:	83 e8 04             	sub    $0x4,%eax
  8009c7:	8b 00                	mov    (%eax),%eax
  8009c9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009ce:	5d                   	pop    %ebp
  8009cf:	c3                   	ret    

008009d0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009d3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009d7:	7e 1c                	jle    8009f5 <getint+0x25>
		return va_arg(*ap, long long);
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	8b 00                	mov    (%eax),%eax
  8009de:	8d 50 08             	lea    0x8(%eax),%edx
  8009e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e4:	89 10                	mov    %edx,(%eax)
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	8b 00                	mov    (%eax),%eax
  8009eb:	83 e8 08             	sub    $0x8,%eax
  8009ee:	8b 50 04             	mov    0x4(%eax),%edx
  8009f1:	8b 00                	mov    (%eax),%eax
  8009f3:	eb 38                	jmp    800a2d <getint+0x5d>
	else if (lflag)
  8009f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009f9:	74 1a                	je     800a15 <getint+0x45>
		return va_arg(*ap, long);
  8009fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fe:	8b 00                	mov    (%eax),%eax
  800a00:	8d 50 04             	lea    0x4(%eax),%edx
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	89 10                	mov    %edx,(%eax)
  800a08:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0b:	8b 00                	mov    (%eax),%eax
  800a0d:	83 e8 04             	sub    $0x4,%eax
  800a10:	8b 00                	mov    (%eax),%eax
  800a12:	99                   	cltd   
  800a13:	eb 18                	jmp    800a2d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	8b 00                	mov    (%eax),%eax
  800a1a:	8d 50 04             	lea    0x4(%eax),%edx
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	89 10                	mov    %edx,(%eax)
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	8b 00                	mov    (%eax),%eax
  800a27:	83 e8 04             	sub    $0x4,%eax
  800a2a:	8b 00                	mov    (%eax),%eax
  800a2c:	99                   	cltd   
}
  800a2d:	5d                   	pop    %ebp
  800a2e:	c3                   	ret    

00800a2f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	56                   	push   %esi
  800a33:	53                   	push   %ebx
  800a34:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a37:	eb 17                	jmp    800a50 <vprintfmt+0x21>
			if (ch == '\0')
  800a39:	85 db                	test   %ebx,%ebx
  800a3b:	0f 84 c1 03 00 00    	je     800e02 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800a41:	83 ec 08             	sub    $0x8,%esp
  800a44:	ff 75 0c             	pushl  0xc(%ebp)
  800a47:	53                   	push   %ebx
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	ff d0                	call   *%eax
  800a4d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a50:	8b 45 10             	mov    0x10(%ebp),%eax
  800a53:	8d 50 01             	lea    0x1(%eax),%edx
  800a56:	89 55 10             	mov    %edx,0x10(%ebp)
  800a59:	8a 00                	mov    (%eax),%al
  800a5b:	0f b6 d8             	movzbl %al,%ebx
  800a5e:	83 fb 25             	cmp    $0x25,%ebx
  800a61:	75 d6                	jne    800a39 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a63:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a67:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a6e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a75:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a7c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a83:	8b 45 10             	mov    0x10(%ebp),%eax
  800a86:	8d 50 01             	lea    0x1(%eax),%edx
  800a89:	89 55 10             	mov    %edx,0x10(%ebp)
  800a8c:	8a 00                	mov    (%eax),%al
  800a8e:	0f b6 d8             	movzbl %al,%ebx
  800a91:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a94:	83 f8 5b             	cmp    $0x5b,%eax
  800a97:	0f 87 3d 03 00 00    	ja     800dda <vprintfmt+0x3ab>
  800a9d:	8b 04 85 b8 3e 80 00 	mov    0x803eb8(,%eax,4),%eax
  800aa4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800aa6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800aaa:	eb d7                	jmp    800a83 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800aac:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ab0:	eb d1                	jmp    800a83 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ab2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ab9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800abc:	89 d0                	mov    %edx,%eax
  800abe:	c1 e0 02             	shl    $0x2,%eax
  800ac1:	01 d0                	add    %edx,%eax
  800ac3:	01 c0                	add    %eax,%eax
  800ac5:	01 d8                	add    %ebx,%eax
  800ac7:	83 e8 30             	sub    $0x30,%eax
  800aca:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800acd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad0:	8a 00                	mov    (%eax),%al
  800ad2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ad5:	83 fb 2f             	cmp    $0x2f,%ebx
  800ad8:	7e 3e                	jle    800b18 <vprintfmt+0xe9>
  800ada:	83 fb 39             	cmp    $0x39,%ebx
  800add:	7f 39                	jg     800b18 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800adf:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ae2:	eb d5                	jmp    800ab9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ae4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae7:	83 c0 04             	add    $0x4,%eax
  800aea:	89 45 14             	mov    %eax,0x14(%ebp)
  800aed:	8b 45 14             	mov    0x14(%ebp),%eax
  800af0:	83 e8 04             	sub    $0x4,%eax
  800af3:	8b 00                	mov    (%eax),%eax
  800af5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800af8:	eb 1f                	jmp    800b19 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800afa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800afe:	79 83                	jns    800a83 <vprintfmt+0x54>
				width = 0;
  800b00:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b07:	e9 77 ff ff ff       	jmp    800a83 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b0c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b13:	e9 6b ff ff ff       	jmp    800a83 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b18:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b19:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b1d:	0f 89 60 ff ff ff    	jns    800a83 <vprintfmt+0x54>
				width = precision, precision = -1;
  800b23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b29:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b30:	e9 4e ff ff ff       	jmp    800a83 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b35:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b38:	e9 46 ff ff ff       	jmp    800a83 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b40:	83 c0 04             	add    $0x4,%eax
  800b43:	89 45 14             	mov    %eax,0x14(%ebp)
  800b46:	8b 45 14             	mov    0x14(%ebp),%eax
  800b49:	83 e8 04             	sub    $0x4,%eax
  800b4c:	8b 00                	mov    (%eax),%eax
  800b4e:	83 ec 08             	sub    $0x8,%esp
  800b51:	ff 75 0c             	pushl  0xc(%ebp)
  800b54:	50                   	push   %eax
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	ff d0                	call   *%eax
  800b5a:	83 c4 10             	add    $0x10,%esp
			break;
  800b5d:	e9 9b 02 00 00       	jmp    800dfd <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b62:	8b 45 14             	mov    0x14(%ebp),%eax
  800b65:	83 c0 04             	add    $0x4,%eax
  800b68:	89 45 14             	mov    %eax,0x14(%ebp)
  800b6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6e:	83 e8 04             	sub    $0x4,%eax
  800b71:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b73:	85 db                	test   %ebx,%ebx
  800b75:	79 02                	jns    800b79 <vprintfmt+0x14a>
				err = -err;
  800b77:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b79:	83 fb 64             	cmp    $0x64,%ebx
  800b7c:	7f 0b                	jg     800b89 <vprintfmt+0x15a>
  800b7e:	8b 34 9d 00 3d 80 00 	mov    0x803d00(,%ebx,4),%esi
  800b85:	85 f6                	test   %esi,%esi
  800b87:	75 19                	jne    800ba2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b89:	53                   	push   %ebx
  800b8a:	68 a5 3e 80 00       	push   $0x803ea5
  800b8f:	ff 75 0c             	pushl  0xc(%ebp)
  800b92:	ff 75 08             	pushl  0x8(%ebp)
  800b95:	e8 70 02 00 00       	call   800e0a <printfmt>
  800b9a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b9d:	e9 5b 02 00 00       	jmp    800dfd <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ba2:	56                   	push   %esi
  800ba3:	68 ae 3e 80 00       	push   $0x803eae
  800ba8:	ff 75 0c             	pushl  0xc(%ebp)
  800bab:	ff 75 08             	pushl  0x8(%ebp)
  800bae:	e8 57 02 00 00       	call   800e0a <printfmt>
  800bb3:	83 c4 10             	add    $0x10,%esp
			break;
  800bb6:	e9 42 02 00 00       	jmp    800dfd <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800bbb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbe:	83 c0 04             	add    $0x4,%eax
  800bc1:	89 45 14             	mov    %eax,0x14(%ebp)
  800bc4:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc7:	83 e8 04             	sub    $0x4,%eax
  800bca:	8b 30                	mov    (%eax),%esi
  800bcc:	85 f6                	test   %esi,%esi
  800bce:	75 05                	jne    800bd5 <vprintfmt+0x1a6>
				p = "(null)";
  800bd0:	be b1 3e 80 00       	mov    $0x803eb1,%esi
			if (width > 0 && padc != '-')
  800bd5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bd9:	7e 6d                	jle    800c48 <vprintfmt+0x219>
  800bdb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bdf:	74 67                	je     800c48 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800be1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800be4:	83 ec 08             	sub    $0x8,%esp
  800be7:	50                   	push   %eax
  800be8:	56                   	push   %esi
  800be9:	e8 1e 03 00 00       	call   800f0c <strnlen>
  800bee:	83 c4 10             	add    $0x10,%esp
  800bf1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800bf4:	eb 16                	jmp    800c0c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800bf6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800bfa:	83 ec 08             	sub    $0x8,%esp
  800bfd:	ff 75 0c             	pushl  0xc(%ebp)
  800c00:	50                   	push   %eax
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	ff d0                	call   *%eax
  800c06:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c09:	ff 4d e4             	decl   -0x1c(%ebp)
  800c0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c10:	7f e4                	jg     800bf6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c12:	eb 34                	jmp    800c48 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c14:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c18:	74 1c                	je     800c36 <vprintfmt+0x207>
  800c1a:	83 fb 1f             	cmp    $0x1f,%ebx
  800c1d:	7e 05                	jle    800c24 <vprintfmt+0x1f5>
  800c1f:	83 fb 7e             	cmp    $0x7e,%ebx
  800c22:	7e 12                	jle    800c36 <vprintfmt+0x207>
					putch('?', putdat);
  800c24:	83 ec 08             	sub    $0x8,%esp
  800c27:	ff 75 0c             	pushl  0xc(%ebp)
  800c2a:	6a 3f                	push   $0x3f
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	ff d0                	call   *%eax
  800c31:	83 c4 10             	add    $0x10,%esp
  800c34:	eb 0f                	jmp    800c45 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c36:	83 ec 08             	sub    $0x8,%esp
  800c39:	ff 75 0c             	pushl  0xc(%ebp)
  800c3c:	53                   	push   %ebx
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	ff d0                	call   *%eax
  800c42:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c45:	ff 4d e4             	decl   -0x1c(%ebp)
  800c48:	89 f0                	mov    %esi,%eax
  800c4a:	8d 70 01             	lea    0x1(%eax),%esi
  800c4d:	8a 00                	mov    (%eax),%al
  800c4f:	0f be d8             	movsbl %al,%ebx
  800c52:	85 db                	test   %ebx,%ebx
  800c54:	74 24                	je     800c7a <vprintfmt+0x24b>
  800c56:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c5a:	78 b8                	js     800c14 <vprintfmt+0x1e5>
  800c5c:	ff 4d e0             	decl   -0x20(%ebp)
  800c5f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c63:	79 af                	jns    800c14 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c65:	eb 13                	jmp    800c7a <vprintfmt+0x24b>
				putch(' ', putdat);
  800c67:	83 ec 08             	sub    $0x8,%esp
  800c6a:	ff 75 0c             	pushl  0xc(%ebp)
  800c6d:	6a 20                	push   $0x20
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	ff d0                	call   *%eax
  800c74:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c77:	ff 4d e4             	decl   -0x1c(%ebp)
  800c7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c7e:	7f e7                	jg     800c67 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c80:	e9 78 01 00 00       	jmp    800dfd <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c85:	83 ec 08             	sub    $0x8,%esp
  800c88:	ff 75 e8             	pushl  -0x18(%ebp)
  800c8b:	8d 45 14             	lea    0x14(%ebp),%eax
  800c8e:	50                   	push   %eax
  800c8f:	e8 3c fd ff ff       	call   8009d0 <getint>
  800c94:	83 c4 10             	add    $0x10,%esp
  800c97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ca0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ca3:	85 d2                	test   %edx,%edx
  800ca5:	79 23                	jns    800cca <vprintfmt+0x29b>
				putch('-', putdat);
  800ca7:	83 ec 08             	sub    $0x8,%esp
  800caa:	ff 75 0c             	pushl  0xc(%ebp)
  800cad:	6a 2d                	push   $0x2d
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	ff d0                	call   *%eax
  800cb4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cbd:	f7 d8                	neg    %eax
  800cbf:	83 d2 00             	adc    $0x0,%edx
  800cc2:	f7 da                	neg    %edx
  800cc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800cca:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cd1:	e9 bc 00 00 00       	jmp    800d92 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800cd6:	83 ec 08             	sub    $0x8,%esp
  800cd9:	ff 75 e8             	pushl  -0x18(%ebp)
  800cdc:	8d 45 14             	lea    0x14(%ebp),%eax
  800cdf:	50                   	push   %eax
  800ce0:	e8 84 fc ff ff       	call   800969 <getuint>
  800ce5:	83 c4 10             	add    $0x10,%esp
  800ce8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ceb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800cee:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cf5:	e9 98 00 00 00       	jmp    800d92 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800cfa:	83 ec 08             	sub    $0x8,%esp
  800cfd:	ff 75 0c             	pushl  0xc(%ebp)
  800d00:	6a 58                	push   $0x58
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	ff d0                	call   *%eax
  800d07:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d0a:	83 ec 08             	sub    $0x8,%esp
  800d0d:	ff 75 0c             	pushl  0xc(%ebp)
  800d10:	6a 58                	push   $0x58
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	ff d0                	call   *%eax
  800d17:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d1a:	83 ec 08             	sub    $0x8,%esp
  800d1d:	ff 75 0c             	pushl  0xc(%ebp)
  800d20:	6a 58                	push   $0x58
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	ff d0                	call   *%eax
  800d27:	83 c4 10             	add    $0x10,%esp
			break;
  800d2a:	e9 ce 00 00 00       	jmp    800dfd <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800d2f:	83 ec 08             	sub    $0x8,%esp
  800d32:	ff 75 0c             	pushl  0xc(%ebp)
  800d35:	6a 30                	push   $0x30
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	ff d0                	call   *%eax
  800d3c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d3f:	83 ec 08             	sub    $0x8,%esp
  800d42:	ff 75 0c             	pushl  0xc(%ebp)
  800d45:	6a 78                	push   $0x78
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	ff d0                	call   *%eax
  800d4c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d52:	83 c0 04             	add    $0x4,%eax
  800d55:	89 45 14             	mov    %eax,0x14(%ebp)
  800d58:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5b:	83 e8 04             	sub    $0x4,%eax
  800d5e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d6a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d71:	eb 1f                	jmp    800d92 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d73:	83 ec 08             	sub    $0x8,%esp
  800d76:	ff 75 e8             	pushl  -0x18(%ebp)
  800d79:	8d 45 14             	lea    0x14(%ebp),%eax
  800d7c:	50                   	push   %eax
  800d7d:	e8 e7 fb ff ff       	call   800969 <getuint>
  800d82:	83 c4 10             	add    $0x10,%esp
  800d85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d88:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d8b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d92:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d99:	83 ec 04             	sub    $0x4,%esp
  800d9c:	52                   	push   %edx
  800d9d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800da0:	50                   	push   %eax
  800da1:	ff 75 f4             	pushl  -0xc(%ebp)
  800da4:	ff 75 f0             	pushl  -0x10(%ebp)
  800da7:	ff 75 0c             	pushl  0xc(%ebp)
  800daa:	ff 75 08             	pushl  0x8(%ebp)
  800dad:	e8 00 fb ff ff       	call   8008b2 <printnum>
  800db2:	83 c4 20             	add    $0x20,%esp
			break;
  800db5:	eb 46                	jmp    800dfd <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800db7:	83 ec 08             	sub    $0x8,%esp
  800dba:	ff 75 0c             	pushl  0xc(%ebp)
  800dbd:	53                   	push   %ebx
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	ff d0                	call   *%eax
  800dc3:	83 c4 10             	add    $0x10,%esp
			break;
  800dc6:	eb 35                	jmp    800dfd <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800dc8:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  800dcf:	eb 2c                	jmp    800dfd <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800dd1:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  800dd8:	eb 23                	jmp    800dfd <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dda:	83 ec 08             	sub    $0x8,%esp
  800ddd:	ff 75 0c             	pushl  0xc(%ebp)
  800de0:	6a 25                	push   $0x25
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	ff d0                	call   *%eax
  800de7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dea:	ff 4d 10             	decl   0x10(%ebp)
  800ded:	eb 03                	jmp    800df2 <vprintfmt+0x3c3>
  800def:	ff 4d 10             	decl   0x10(%ebp)
  800df2:	8b 45 10             	mov    0x10(%ebp),%eax
  800df5:	48                   	dec    %eax
  800df6:	8a 00                	mov    (%eax),%al
  800df8:	3c 25                	cmp    $0x25,%al
  800dfa:	75 f3                	jne    800def <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800dfc:	90                   	nop
		}
	}
  800dfd:	e9 35 fc ff ff       	jmp    800a37 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800e02:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800e03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e06:	5b                   	pop    %ebx
  800e07:	5e                   	pop    %esi
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    

00800e0a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e10:	8d 45 10             	lea    0x10(%ebp),%eax
  800e13:	83 c0 04             	add    $0x4,%eax
  800e16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e19:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800e1f:	50                   	push   %eax
  800e20:	ff 75 0c             	pushl  0xc(%ebp)
  800e23:	ff 75 08             	pushl  0x8(%ebp)
  800e26:	e8 04 fc ff ff       	call   800a2f <vprintfmt>
  800e2b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e2e:	90                   	nop
  800e2f:	c9                   	leave  
  800e30:	c3                   	ret    

00800e31 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e37:	8b 40 08             	mov    0x8(%eax),%eax
  800e3a:	8d 50 01             	lea    0x1(%eax),%edx
  800e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e40:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	8b 10                	mov    (%eax),%edx
  800e48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4b:	8b 40 04             	mov    0x4(%eax),%eax
  800e4e:	39 c2                	cmp    %eax,%edx
  800e50:	73 12                	jae    800e64 <sprintputch+0x33>
		*b->buf++ = ch;
  800e52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e55:	8b 00                	mov    (%eax),%eax
  800e57:	8d 48 01             	lea    0x1(%eax),%ecx
  800e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5d:	89 0a                	mov    %ecx,(%edx)
  800e5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e62:	88 10                	mov    %dl,(%eax)
}
  800e64:	90                   	nop
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    

00800e67 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e79:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7c:	01 d0                	add    %edx,%eax
  800e7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e8c:	74 06                	je     800e94 <vsnprintf+0x2d>
  800e8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e92:	7f 07                	jg     800e9b <vsnprintf+0x34>
		return -E_INVAL;
  800e94:	b8 03 00 00 00       	mov    $0x3,%eax
  800e99:	eb 20                	jmp    800ebb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e9b:	ff 75 14             	pushl  0x14(%ebp)
  800e9e:	ff 75 10             	pushl  0x10(%ebp)
  800ea1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ea4:	50                   	push   %eax
  800ea5:	68 31 0e 80 00       	push   $0x800e31
  800eaa:	e8 80 fb ff ff       	call   800a2f <vprintfmt>
  800eaf:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800eb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eb5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ebb:	c9                   	leave  
  800ebc:	c3                   	ret    

00800ebd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ebd:	55                   	push   %ebp
  800ebe:	89 e5                	mov    %esp,%ebp
  800ec0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ec3:	8d 45 10             	lea    0x10(%ebp),%eax
  800ec6:	83 c0 04             	add    $0x4,%eax
  800ec9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ed2:	50                   	push   %eax
  800ed3:	ff 75 0c             	pushl  0xc(%ebp)
  800ed6:	ff 75 08             	pushl  0x8(%ebp)
  800ed9:	e8 89 ff ff ff       	call   800e67 <vsnprintf>
  800ede:	83 c4 10             	add    $0x10,%esp
  800ee1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ee7:	c9                   	leave  
  800ee8:	c3                   	ret    

00800ee9 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
  800eec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800eef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ef6:	eb 06                	jmp    800efe <strlen+0x15>
		n++;
  800ef8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800efb:	ff 45 08             	incl   0x8(%ebp)
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	84 c0                	test   %al,%al
  800f05:	75 f1                	jne    800ef8 <strlen+0xf>
		n++;
	return n;
  800f07:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f0a:	c9                   	leave  
  800f0b:	c3                   	ret    

00800f0c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f19:	eb 09                	jmp    800f24 <strnlen+0x18>
		n++;
  800f1b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f1e:	ff 45 08             	incl   0x8(%ebp)
  800f21:	ff 4d 0c             	decl   0xc(%ebp)
  800f24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f28:	74 09                	je     800f33 <strnlen+0x27>
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	84 c0                	test   %al,%al
  800f31:	75 e8                	jne    800f1b <strnlen+0xf>
		n++;
	return n;
  800f33:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f36:	c9                   	leave  
  800f37:	c3                   	ret    

00800f38 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f44:	90                   	nop
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	8d 50 01             	lea    0x1(%eax),%edx
  800f4b:	89 55 08             	mov    %edx,0x8(%ebp)
  800f4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f51:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f54:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f57:	8a 12                	mov    (%edx),%dl
  800f59:	88 10                	mov    %dl,(%eax)
  800f5b:	8a 00                	mov    (%eax),%al
  800f5d:	84 c0                	test   %al,%al
  800f5f:	75 e4                	jne    800f45 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f61:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f64:	c9                   	leave  
  800f65:	c3                   	ret    

00800f66 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f72:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f79:	eb 1f                	jmp    800f9a <strncpy+0x34>
		*dst++ = *src;
  800f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7e:	8d 50 01             	lea    0x1(%eax),%edx
  800f81:	89 55 08             	mov    %edx,0x8(%ebp)
  800f84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f87:	8a 12                	mov    (%edx),%dl
  800f89:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8e:	8a 00                	mov    (%eax),%al
  800f90:	84 c0                	test   %al,%al
  800f92:	74 03                	je     800f97 <strncpy+0x31>
			src++;
  800f94:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f97:	ff 45 fc             	incl   -0x4(%ebp)
  800f9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fa0:	72 d9                	jb     800f7b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fa2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fa5:	c9                   	leave  
  800fa6:	c3                   	ret    

00800fa7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
  800faa:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800fb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb7:	74 30                	je     800fe9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800fb9:	eb 16                	jmp    800fd1 <strlcpy+0x2a>
			*dst++ = *src++;
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	8d 50 01             	lea    0x1(%eax),%edx
  800fc1:	89 55 08             	mov    %edx,0x8(%ebp)
  800fc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fca:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fcd:	8a 12                	mov    (%edx),%dl
  800fcf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fd1:	ff 4d 10             	decl   0x10(%ebp)
  800fd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd8:	74 09                	je     800fe3 <strlcpy+0x3c>
  800fda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	84 c0                	test   %al,%al
  800fe1:	75 d8                	jne    800fbb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fe9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fef:	29 c2                	sub    %eax,%edx
  800ff1:	89 d0                	mov    %edx,%eax
}
  800ff3:	c9                   	leave  
  800ff4:	c3                   	ret    

00800ff5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ff5:	55                   	push   %ebp
  800ff6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ff8:	eb 06                	jmp    801000 <strcmp+0xb>
		p++, q++;
  800ffa:	ff 45 08             	incl   0x8(%ebp)
  800ffd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	8a 00                	mov    (%eax),%al
  801005:	84 c0                	test   %al,%al
  801007:	74 0e                	je     801017 <strcmp+0x22>
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	8a 10                	mov    (%eax),%dl
  80100e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	38 c2                	cmp    %al,%dl
  801015:	74 e3                	je     800ffa <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	8a 00                	mov    (%eax),%al
  80101c:	0f b6 d0             	movzbl %al,%edx
  80101f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801022:	8a 00                	mov    (%eax),%al
  801024:	0f b6 c0             	movzbl %al,%eax
  801027:	29 c2                	sub    %eax,%edx
  801029:	89 d0                	mov    %edx,%eax
}
  80102b:	5d                   	pop    %ebp
  80102c:	c3                   	ret    

0080102d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801030:	eb 09                	jmp    80103b <strncmp+0xe>
		n--, p++, q++;
  801032:	ff 4d 10             	decl   0x10(%ebp)
  801035:	ff 45 08             	incl   0x8(%ebp)
  801038:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80103b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80103f:	74 17                	je     801058 <strncmp+0x2b>
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	8a 00                	mov    (%eax),%al
  801046:	84 c0                	test   %al,%al
  801048:	74 0e                	je     801058 <strncmp+0x2b>
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	8a 10                	mov    (%eax),%dl
  80104f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801052:	8a 00                	mov    (%eax),%al
  801054:	38 c2                	cmp    %al,%dl
  801056:	74 da                	je     801032 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801058:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80105c:	75 07                	jne    801065 <strncmp+0x38>
		return 0;
  80105e:	b8 00 00 00 00       	mov    $0x0,%eax
  801063:	eb 14                	jmp    801079 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	0f b6 d0             	movzbl %al,%edx
  80106d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	0f b6 c0             	movzbl %al,%eax
  801075:	29 c2                	sub    %eax,%edx
  801077:	89 d0                	mov    %edx,%eax
}
  801079:	5d                   	pop    %ebp
  80107a:	c3                   	ret    

0080107b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80107b:	55                   	push   %ebp
  80107c:	89 e5                	mov    %esp,%ebp
  80107e:	83 ec 04             	sub    $0x4,%esp
  801081:	8b 45 0c             	mov    0xc(%ebp),%eax
  801084:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801087:	eb 12                	jmp    80109b <strchr+0x20>
		if (*s == c)
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	8a 00                	mov    (%eax),%al
  80108e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801091:	75 05                	jne    801098 <strchr+0x1d>
			return (char *) s;
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	eb 11                	jmp    8010a9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801098:	ff 45 08             	incl   0x8(%ebp)
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	8a 00                	mov    (%eax),%al
  8010a0:	84 c0                	test   %al,%al
  8010a2:	75 e5                	jne    801089 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8010a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a9:	c9                   	leave  
  8010aa:	c3                   	ret    

008010ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	83 ec 04             	sub    $0x4,%esp
  8010b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010b7:	eb 0d                	jmp    8010c6 <strfind+0x1b>
		if (*s == c)
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	8a 00                	mov    (%eax),%al
  8010be:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010c1:	74 0e                	je     8010d1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010c3:	ff 45 08             	incl   0x8(%ebp)
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	84 c0                	test   %al,%al
  8010cd:	75 ea                	jne    8010b9 <strfind+0xe>
  8010cf:	eb 01                	jmp    8010d2 <strfind+0x27>
		if (*s == c)
			break;
  8010d1:	90                   	nop
	return (char *) s;
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d5:	c9                   	leave  
  8010d6:	c3                   	ret    

008010d7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
  8010da:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8010dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8010e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010e9:	eb 0e                	jmp    8010f9 <memset+0x22>
		*p++ = c;
  8010eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ee:	8d 50 01             	lea    0x1(%eax),%edx
  8010f1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f7:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010f9:	ff 4d f8             	decl   -0x8(%ebp)
  8010fc:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801100:	79 e9                	jns    8010eb <memset+0x14>
		*p++ = c;

	return v;
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801105:	c9                   	leave  
  801106:	c3                   	ret    

00801107 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80110d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801110:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801119:	eb 16                	jmp    801131 <memcpy+0x2a>
		*d++ = *s++;
  80111b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111e:	8d 50 01             	lea    0x1(%eax),%edx
  801121:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801124:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801127:	8d 4a 01             	lea    0x1(%edx),%ecx
  80112a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80112d:	8a 12                	mov    (%edx),%dl
  80112f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801131:	8b 45 10             	mov    0x10(%ebp),%eax
  801134:	8d 50 ff             	lea    -0x1(%eax),%edx
  801137:	89 55 10             	mov    %edx,0x10(%ebp)
  80113a:	85 c0                	test   %eax,%eax
  80113c:	75 dd                	jne    80111b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801141:	c9                   	leave  
  801142:	c3                   	ret    

00801143 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801143:	55                   	push   %ebp
  801144:	89 e5                	mov    %esp,%ebp
  801146:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801149:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801155:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801158:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80115b:	73 50                	jae    8011ad <memmove+0x6a>
  80115d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801160:	8b 45 10             	mov    0x10(%ebp),%eax
  801163:	01 d0                	add    %edx,%eax
  801165:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801168:	76 43                	jbe    8011ad <memmove+0x6a>
		s += n;
  80116a:	8b 45 10             	mov    0x10(%ebp),%eax
  80116d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801170:	8b 45 10             	mov    0x10(%ebp),%eax
  801173:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801176:	eb 10                	jmp    801188 <memmove+0x45>
			*--d = *--s;
  801178:	ff 4d f8             	decl   -0x8(%ebp)
  80117b:	ff 4d fc             	decl   -0x4(%ebp)
  80117e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801181:	8a 10                	mov    (%eax),%dl
  801183:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801186:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801188:	8b 45 10             	mov    0x10(%ebp),%eax
  80118b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80118e:	89 55 10             	mov    %edx,0x10(%ebp)
  801191:	85 c0                	test   %eax,%eax
  801193:	75 e3                	jne    801178 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801195:	eb 23                	jmp    8011ba <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801197:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119a:	8d 50 01             	lea    0x1(%eax),%edx
  80119d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011a6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011a9:	8a 12                	mov    (%edx),%dl
  8011ab:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	75 dd                	jne    801197 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011bd:	c9                   	leave  
  8011be:	c3                   	ret    

008011bf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
  8011c2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ce:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011d1:	eb 2a                	jmp    8011fd <memcmp+0x3e>
		if (*s1 != *s2)
  8011d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d6:	8a 10                	mov    (%eax),%dl
  8011d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	38 c2                	cmp    %al,%dl
  8011df:	74 16                	je     8011f7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	0f b6 d0             	movzbl %al,%edx
  8011e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	0f b6 c0             	movzbl %al,%eax
  8011f1:	29 c2                	sub    %eax,%edx
  8011f3:	89 d0                	mov    %edx,%eax
  8011f5:	eb 18                	jmp    80120f <memcmp+0x50>
		s1++, s2++;
  8011f7:	ff 45 fc             	incl   -0x4(%ebp)
  8011fa:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801200:	8d 50 ff             	lea    -0x1(%eax),%edx
  801203:	89 55 10             	mov    %edx,0x10(%ebp)
  801206:	85 c0                	test   %eax,%eax
  801208:	75 c9                	jne    8011d3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80120a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120f:	c9                   	leave  
  801210:	c3                   	ret    

00801211 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801217:	8b 55 08             	mov    0x8(%ebp),%edx
  80121a:	8b 45 10             	mov    0x10(%ebp),%eax
  80121d:	01 d0                	add    %edx,%eax
  80121f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801222:	eb 15                	jmp    801239 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	0f b6 d0             	movzbl %al,%edx
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	0f b6 c0             	movzbl %al,%eax
  801232:	39 c2                	cmp    %eax,%edx
  801234:	74 0d                	je     801243 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801236:	ff 45 08             	incl   0x8(%ebp)
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80123f:	72 e3                	jb     801224 <memfind+0x13>
  801241:	eb 01                	jmp    801244 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801243:	90                   	nop
	return (void *) s;
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801247:	c9                   	leave  
  801248:	c3                   	ret    

00801249 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80124f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801256:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80125d:	eb 03                	jmp    801262 <strtol+0x19>
		s++;
  80125f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	8a 00                	mov    (%eax),%al
  801267:	3c 20                	cmp    $0x20,%al
  801269:	74 f4                	je     80125f <strtol+0x16>
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	8a 00                	mov    (%eax),%al
  801270:	3c 09                	cmp    $0x9,%al
  801272:	74 eb                	je     80125f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	8a 00                	mov    (%eax),%al
  801279:	3c 2b                	cmp    $0x2b,%al
  80127b:	75 05                	jne    801282 <strtol+0x39>
		s++;
  80127d:	ff 45 08             	incl   0x8(%ebp)
  801280:	eb 13                	jmp    801295 <strtol+0x4c>
	else if (*s == '-')
  801282:	8b 45 08             	mov    0x8(%ebp),%eax
  801285:	8a 00                	mov    (%eax),%al
  801287:	3c 2d                	cmp    $0x2d,%al
  801289:	75 0a                	jne    801295 <strtol+0x4c>
		s++, neg = 1;
  80128b:	ff 45 08             	incl   0x8(%ebp)
  80128e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801295:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801299:	74 06                	je     8012a1 <strtol+0x58>
  80129b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80129f:	75 20                	jne    8012c1 <strtol+0x78>
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	3c 30                	cmp    $0x30,%al
  8012a8:	75 17                	jne    8012c1 <strtol+0x78>
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	40                   	inc    %eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	3c 78                	cmp    $0x78,%al
  8012b2:	75 0d                	jne    8012c1 <strtol+0x78>
		s += 2, base = 16;
  8012b4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012b8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012bf:	eb 28                	jmp    8012e9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c5:	75 15                	jne    8012dc <strtol+0x93>
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	8a 00                	mov    (%eax),%al
  8012cc:	3c 30                	cmp    $0x30,%al
  8012ce:	75 0c                	jne    8012dc <strtol+0x93>
		s++, base = 8;
  8012d0:	ff 45 08             	incl   0x8(%ebp)
  8012d3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012da:	eb 0d                	jmp    8012e9 <strtol+0xa0>
	else if (base == 0)
  8012dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012e0:	75 07                	jne    8012e9 <strtol+0xa0>
		base = 10;
  8012e2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ec:	8a 00                	mov    (%eax),%al
  8012ee:	3c 2f                	cmp    $0x2f,%al
  8012f0:	7e 19                	jle    80130b <strtol+0xc2>
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	8a 00                	mov    (%eax),%al
  8012f7:	3c 39                	cmp    $0x39,%al
  8012f9:	7f 10                	jg     80130b <strtol+0xc2>
			dig = *s - '0';
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8a 00                	mov    (%eax),%al
  801300:	0f be c0             	movsbl %al,%eax
  801303:	83 e8 30             	sub    $0x30,%eax
  801306:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801309:	eb 42                	jmp    80134d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
  80130e:	8a 00                	mov    (%eax),%al
  801310:	3c 60                	cmp    $0x60,%al
  801312:	7e 19                	jle    80132d <strtol+0xe4>
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	8a 00                	mov    (%eax),%al
  801319:	3c 7a                	cmp    $0x7a,%al
  80131b:	7f 10                	jg     80132d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80131d:	8b 45 08             	mov    0x8(%ebp),%eax
  801320:	8a 00                	mov    (%eax),%al
  801322:	0f be c0             	movsbl %al,%eax
  801325:	83 e8 57             	sub    $0x57,%eax
  801328:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80132b:	eb 20                	jmp    80134d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80132d:	8b 45 08             	mov    0x8(%ebp),%eax
  801330:	8a 00                	mov    (%eax),%al
  801332:	3c 40                	cmp    $0x40,%al
  801334:	7e 39                	jle    80136f <strtol+0x126>
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	8a 00                	mov    (%eax),%al
  80133b:	3c 5a                	cmp    $0x5a,%al
  80133d:	7f 30                	jg     80136f <strtol+0x126>
			dig = *s - 'A' + 10;
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	8a 00                	mov    (%eax),%al
  801344:	0f be c0             	movsbl %al,%eax
  801347:	83 e8 37             	sub    $0x37,%eax
  80134a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80134d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801350:	3b 45 10             	cmp    0x10(%ebp),%eax
  801353:	7d 19                	jge    80136e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801355:	ff 45 08             	incl   0x8(%ebp)
  801358:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80135f:	89 c2                	mov    %eax,%edx
  801361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801364:	01 d0                	add    %edx,%eax
  801366:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801369:	e9 7b ff ff ff       	jmp    8012e9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80136e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80136f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801373:	74 08                	je     80137d <strtol+0x134>
		*endptr = (char *) s;
  801375:	8b 45 0c             	mov    0xc(%ebp),%eax
  801378:	8b 55 08             	mov    0x8(%ebp),%edx
  80137b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80137d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801381:	74 07                	je     80138a <strtol+0x141>
  801383:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801386:	f7 d8                	neg    %eax
  801388:	eb 03                	jmp    80138d <strtol+0x144>
  80138a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    

0080138f <ltostr>:

void
ltostr(long value, char *str)
{
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
  801392:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801395:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80139c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013a7:	79 13                	jns    8013bc <ltostr+0x2d>
	{
		neg = 1;
  8013a9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013b6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013b9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bf:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013c4:	99                   	cltd   
  8013c5:	f7 f9                	idiv   %ecx
  8013c7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013cd:	8d 50 01             	lea    0x1(%eax),%edx
  8013d0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013d3:	89 c2                	mov    %eax,%edx
  8013d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d8:	01 d0                	add    %edx,%eax
  8013da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013dd:	83 c2 30             	add    $0x30,%edx
  8013e0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013e5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013ea:	f7 e9                	imul   %ecx
  8013ec:	c1 fa 02             	sar    $0x2,%edx
  8013ef:	89 c8                	mov    %ecx,%eax
  8013f1:	c1 f8 1f             	sar    $0x1f,%eax
  8013f4:	29 c2                	sub    %eax,%edx
  8013f6:	89 d0                	mov    %edx,%eax
  8013f8:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013ff:	75 bb                	jne    8013bc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801401:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801408:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80140b:	48                   	dec    %eax
  80140c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80140f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801413:	74 3d                	je     801452 <ltostr+0xc3>
		start = 1 ;
  801415:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80141c:	eb 34                	jmp    801452 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80141e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801421:	8b 45 0c             	mov    0xc(%ebp),%eax
  801424:	01 d0                	add    %edx,%eax
  801426:	8a 00                	mov    (%eax),%al
  801428:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80142b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801431:	01 c2                	add    %eax,%edx
  801433:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801436:	8b 45 0c             	mov    0xc(%ebp),%eax
  801439:	01 c8                	add    %ecx,%eax
  80143b:	8a 00                	mov    (%eax),%al
  80143d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80143f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801442:	8b 45 0c             	mov    0xc(%ebp),%eax
  801445:	01 c2                	add    %eax,%edx
  801447:	8a 45 eb             	mov    -0x15(%ebp),%al
  80144a:	88 02                	mov    %al,(%edx)
		start++ ;
  80144c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80144f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801455:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801458:	7c c4                	jl     80141e <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80145a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80145d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801460:	01 d0                	add    %edx,%eax
  801462:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801465:	90                   	nop
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80146e:	ff 75 08             	pushl  0x8(%ebp)
  801471:	e8 73 fa ff ff       	call   800ee9 <strlen>
  801476:	83 c4 04             	add    $0x4,%esp
  801479:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80147c:	ff 75 0c             	pushl  0xc(%ebp)
  80147f:	e8 65 fa ff ff       	call   800ee9 <strlen>
  801484:	83 c4 04             	add    $0x4,%esp
  801487:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80148a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801491:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801498:	eb 17                	jmp    8014b1 <strcconcat+0x49>
		final[s] = str1[s] ;
  80149a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80149d:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a0:	01 c2                	add    %eax,%edx
  8014a2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	01 c8                	add    %ecx,%eax
  8014aa:	8a 00                	mov    (%eax),%al
  8014ac:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014ae:	ff 45 fc             	incl   -0x4(%ebp)
  8014b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014b7:	7c e1                	jl     80149a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014b9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014c7:	eb 1f                	jmp    8014e8 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014cc:	8d 50 01             	lea    0x1(%eax),%edx
  8014cf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014d2:	89 c2                	mov    %eax,%edx
  8014d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d7:	01 c2                	add    %eax,%edx
  8014d9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014df:	01 c8                	add    %ecx,%eax
  8014e1:	8a 00                	mov    (%eax),%al
  8014e3:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014e5:	ff 45 f8             	incl   -0x8(%ebp)
  8014e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014ee:	7c d9                	jl     8014c9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f6:	01 d0                	add    %edx,%eax
  8014f8:	c6 00 00             	movb   $0x0,(%eax)
}
  8014fb:	90                   	nop
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801501:	8b 45 14             	mov    0x14(%ebp),%eax
  801504:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80150a:	8b 45 14             	mov    0x14(%ebp),%eax
  80150d:	8b 00                	mov    (%eax),%eax
  80150f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801516:	8b 45 10             	mov    0x10(%ebp),%eax
  801519:	01 d0                	add    %edx,%eax
  80151b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801521:	eb 0c                	jmp    80152f <strsplit+0x31>
			*string++ = 0;
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	8d 50 01             	lea    0x1(%eax),%edx
  801529:	89 55 08             	mov    %edx,0x8(%ebp)
  80152c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	8a 00                	mov    (%eax),%al
  801534:	84 c0                	test   %al,%al
  801536:	74 18                	je     801550 <strsplit+0x52>
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	8a 00                	mov    (%eax),%al
  80153d:	0f be c0             	movsbl %al,%eax
  801540:	50                   	push   %eax
  801541:	ff 75 0c             	pushl  0xc(%ebp)
  801544:	e8 32 fb ff ff       	call   80107b <strchr>
  801549:	83 c4 08             	add    $0x8,%esp
  80154c:	85 c0                	test   %eax,%eax
  80154e:	75 d3                	jne    801523 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801550:	8b 45 08             	mov    0x8(%ebp),%eax
  801553:	8a 00                	mov    (%eax),%al
  801555:	84 c0                	test   %al,%al
  801557:	74 5a                	je     8015b3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801559:	8b 45 14             	mov    0x14(%ebp),%eax
  80155c:	8b 00                	mov    (%eax),%eax
  80155e:	83 f8 0f             	cmp    $0xf,%eax
  801561:	75 07                	jne    80156a <strsplit+0x6c>
		{
			return 0;
  801563:	b8 00 00 00 00       	mov    $0x0,%eax
  801568:	eb 66                	jmp    8015d0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80156a:	8b 45 14             	mov    0x14(%ebp),%eax
  80156d:	8b 00                	mov    (%eax),%eax
  80156f:	8d 48 01             	lea    0x1(%eax),%ecx
  801572:	8b 55 14             	mov    0x14(%ebp),%edx
  801575:	89 0a                	mov    %ecx,(%edx)
  801577:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80157e:	8b 45 10             	mov    0x10(%ebp),%eax
  801581:	01 c2                	add    %eax,%edx
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801588:	eb 03                	jmp    80158d <strsplit+0x8f>
			string++;
  80158a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
  801590:	8a 00                	mov    (%eax),%al
  801592:	84 c0                	test   %al,%al
  801594:	74 8b                	je     801521 <strsplit+0x23>
  801596:	8b 45 08             	mov    0x8(%ebp),%eax
  801599:	8a 00                	mov    (%eax),%al
  80159b:	0f be c0             	movsbl %al,%eax
  80159e:	50                   	push   %eax
  80159f:	ff 75 0c             	pushl  0xc(%ebp)
  8015a2:	e8 d4 fa ff ff       	call   80107b <strchr>
  8015a7:	83 c4 08             	add    $0x8,%esp
  8015aa:	85 c0                	test   %eax,%eax
  8015ac:	74 dc                	je     80158a <strsplit+0x8c>
			string++;
	}
  8015ae:	e9 6e ff ff ff       	jmp    801521 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015b3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b7:	8b 00                	mov    (%eax),%eax
  8015b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c3:	01 d0                	add    %edx,%eax
  8015c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015cb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015d0:	c9                   	leave  
  8015d1:	c3                   	ret    

008015d2 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
  8015d5:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8015d8:	83 ec 04             	sub    $0x4,%esp
  8015db:	68 28 40 80 00       	push   $0x804028
  8015e0:	68 3f 01 00 00       	push   $0x13f
  8015e5:	68 4a 40 80 00       	push   $0x80404a
  8015ea:	e8 a9 ef ff ff       	call   800598 <_panic>

008015ef <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
  8015f2:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8015f5:	83 ec 0c             	sub    $0xc,%esp
  8015f8:	ff 75 08             	pushl  0x8(%ebp)
  8015fb:	e8 90 0c 00 00       	call   802290 <sys_sbrk>
  801600:	83 c4 10             	add    $0x10,%esp
}
  801603:	c9                   	leave  
  801604:	c3                   	ret    

00801605 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
  801608:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  80160b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80160f:	75 0a                	jne    80161b <malloc+0x16>
		return NULL;
  801611:	b8 00 00 00 00       	mov    $0x0,%eax
  801616:	e9 9e 01 00 00       	jmp    8017b9 <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  80161b:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801622:	77 2c                	ja     801650 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801624:	e8 eb 0a 00 00       	call   802114 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801629:	85 c0                	test   %eax,%eax
  80162b:	74 19                	je     801646 <malloc+0x41>

			void * block = alloc_block_FF(size);
  80162d:	83 ec 0c             	sub    $0xc,%esp
  801630:	ff 75 08             	pushl  0x8(%ebp)
  801633:	e8 85 11 00 00       	call   8027bd <alloc_block_FF>
  801638:	83 c4 10             	add    $0x10,%esp
  80163b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  80163e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801641:	e9 73 01 00 00       	jmp    8017b9 <malloc+0x1b4>
		} else {
			return NULL;
  801646:	b8 00 00 00 00       	mov    $0x0,%eax
  80164b:	e9 69 01 00 00       	jmp    8017b9 <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801650:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801657:	8b 55 08             	mov    0x8(%ebp),%edx
  80165a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80165d:	01 d0                	add    %edx,%eax
  80165f:	48                   	dec    %eax
  801660:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801663:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801666:	ba 00 00 00 00       	mov    $0x0,%edx
  80166b:	f7 75 e0             	divl   -0x20(%ebp)
  80166e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801671:	29 d0                	sub    %edx,%eax
  801673:	c1 e8 0c             	shr    $0xc,%eax
  801676:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  801679:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801680:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801687:	a1 20 50 80 00       	mov    0x805020,%eax
  80168c:	8b 40 7c             	mov    0x7c(%eax),%eax
  80168f:	05 00 10 00 00       	add    $0x1000,%eax
  801694:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801697:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80169c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80169f:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  8016a2:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8016a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8016af:	01 d0                	add    %edx,%eax
  8016b1:	48                   	dec    %eax
  8016b2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8016b5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8016b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016bd:	f7 75 cc             	divl   -0x34(%ebp)
  8016c0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8016c3:	29 d0                	sub    %edx,%eax
  8016c5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8016c8:	76 0a                	jbe    8016d4 <malloc+0xcf>
		return NULL;
  8016ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8016cf:	e9 e5 00 00 00       	jmp    8017b9 <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  8016d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016da:	eb 48                	jmp    801724 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  8016dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016df:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8016e2:	c1 e8 0c             	shr    $0xc,%eax
  8016e5:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  8016e8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8016eb:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8016f2:	85 c0                	test   %eax,%eax
  8016f4:	75 11                	jne    801707 <malloc+0x102>
			freePagesCount++;
  8016f6:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8016f9:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8016fd:	75 16                	jne    801715 <malloc+0x110>
				start = i;
  8016ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801702:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801705:	eb 0e                	jmp    801715 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801707:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80170e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801718:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80171b:	74 12                	je     80172f <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  80171d:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801724:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80172b:	76 af                	jbe    8016dc <malloc+0xd7>
  80172d:	eb 01                	jmp    801730 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  80172f:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  801730:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801734:	74 08                	je     80173e <malloc+0x139>
  801736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801739:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80173c:	74 07                	je     801745 <malloc+0x140>
		return NULL;
  80173e:	b8 00 00 00 00       	mov    $0x0,%eax
  801743:	eb 74                	jmp    8017b9 <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801748:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80174b:	c1 e8 0c             	shr    $0xc,%eax
  80174e:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801751:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801754:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801757:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  80175e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801761:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801764:	eb 11                	jmp    801777 <malloc+0x172>
		markedPages[i] = 1;
  801766:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801769:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801770:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801774:	ff 45 e8             	incl   -0x18(%ebp)
  801777:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80177a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80177d:	01 d0                	add    %edx,%eax
  80177f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801782:	77 e2                	ja     801766 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801784:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80178b:	8b 55 08             	mov    0x8(%ebp),%edx
  80178e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801791:	01 d0                	add    %edx,%eax
  801793:	48                   	dec    %eax
  801794:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801797:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80179a:	ba 00 00 00 00       	mov    $0x0,%edx
  80179f:	f7 75 bc             	divl   -0x44(%ebp)
  8017a2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8017a5:	29 d0                	sub    %edx,%eax
  8017a7:	83 ec 08             	sub    $0x8,%esp
  8017aa:	50                   	push   %eax
  8017ab:	ff 75 f0             	pushl  -0x10(%ebp)
  8017ae:	e8 14 0b 00 00       	call   8022c7 <sys_allocate_user_mem>
  8017b3:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  8017b6:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    

008017bb <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
  8017be:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  8017c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017c5:	0f 84 ee 00 00 00    	je     8018b9 <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  8017cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8017d0:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  8017d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8017d6:	77 09                	ja     8017e1 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  8017d8:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  8017df:	76 14                	jbe    8017f5 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  8017e1:	83 ec 04             	sub    $0x4,%esp
  8017e4:	68 58 40 80 00       	push   $0x804058
  8017e9:	6a 68                	push   $0x68
  8017eb:	68 72 40 80 00       	push   $0x804072
  8017f0:	e8 a3 ed ff ff       	call   800598 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  8017f5:	a1 20 50 80 00       	mov    0x805020,%eax
  8017fa:	8b 40 74             	mov    0x74(%eax),%eax
  8017fd:	3b 45 08             	cmp    0x8(%ebp),%eax
  801800:	77 20                	ja     801822 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801802:	a1 20 50 80 00       	mov    0x805020,%eax
  801807:	8b 40 78             	mov    0x78(%eax),%eax
  80180a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80180d:	76 13                	jbe    801822 <free+0x67>
		free_block(virtual_address);
  80180f:	83 ec 0c             	sub    $0xc,%esp
  801812:	ff 75 08             	pushl  0x8(%ebp)
  801815:	e8 6c 16 00 00       	call   802e86 <free_block>
  80181a:	83 c4 10             	add    $0x10,%esp
		return;
  80181d:	e9 98 00 00 00       	jmp    8018ba <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801822:	8b 55 08             	mov    0x8(%ebp),%edx
  801825:	a1 20 50 80 00       	mov    0x805020,%eax
  80182a:	8b 40 7c             	mov    0x7c(%eax),%eax
  80182d:	29 c2                	sub    %eax,%edx
  80182f:	89 d0                	mov    %edx,%eax
  801831:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801836:	c1 e8 0c             	shr    $0xc,%eax
  801839:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  80183c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801843:	eb 16                	jmp    80185b <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801845:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801848:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80184b:	01 d0                	add    %edx,%eax
  80184d:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  801854:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801858:	ff 45 f4             	incl   -0xc(%ebp)
  80185b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80185e:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801865:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801868:	7f db                	jg     801845 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  80186a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80186d:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801874:	c1 e0 0c             	shl    $0xc,%eax
  801877:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
  80187d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801880:	eb 1a                	jmp    80189c <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801882:	83 ec 08             	sub    $0x8,%esp
  801885:	68 00 10 00 00       	push   $0x1000
  80188a:	ff 75 f0             	pushl  -0x10(%ebp)
  80188d:	e8 19 0a 00 00       	call   8022ab <sys_free_user_mem>
  801892:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801895:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  80189c:	8b 55 08             	mov    0x8(%ebp),%edx
  80189f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018a2:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  8018a4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018a7:	77 d9                	ja     801882 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  8018a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ac:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  8018b3:	00 00 00 00 
  8018b7:	eb 01                	jmp    8018ba <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  8018b9:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	83 ec 58             	sub    $0x58,%esp
  8018c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c5:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8018c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018cc:	75 0a                	jne    8018d8 <smalloc+0x1c>
		return NULL;
  8018ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d3:	e9 7d 01 00 00       	jmp    801a55 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8018d8:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8018df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018e5:	01 d0                	add    %edx,%eax
  8018e7:	48                   	dec    %eax
  8018e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8018eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f3:	f7 75 e4             	divl   -0x1c(%ebp)
  8018f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018f9:	29 d0                	sub    %edx,%eax
  8018fb:	c1 e8 0c             	shr    $0xc,%eax
  8018fe:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801901:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801908:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  80190f:	a1 20 50 80 00       	mov    0x805020,%eax
  801914:	8b 40 7c             	mov    0x7c(%eax),%eax
  801917:	05 00 10 00 00       	add    $0x1000,%eax
  80191c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  80191f:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801924:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801927:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  80192a:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801931:	8b 55 0c             	mov    0xc(%ebp),%edx
  801934:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801937:	01 d0                	add    %edx,%eax
  801939:	48                   	dec    %eax
  80193a:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80193d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801940:	ba 00 00 00 00       	mov    $0x0,%edx
  801945:	f7 75 d0             	divl   -0x30(%ebp)
  801948:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80194b:	29 d0                	sub    %edx,%eax
  80194d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801950:	76 0a                	jbe    80195c <smalloc+0xa0>
		return NULL;
  801952:	b8 00 00 00 00       	mov    $0x0,%eax
  801957:	e9 f9 00 00 00       	jmp    801a55 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80195c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80195f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801962:	eb 48                	jmp    8019ac <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801964:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801967:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80196a:	c1 e8 0c             	shr    $0xc,%eax
  80196d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801970:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801973:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  80197a:	85 c0                	test   %eax,%eax
  80197c:	75 11                	jne    80198f <smalloc+0xd3>
			freePagesCount++;
  80197e:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801981:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801985:	75 16                	jne    80199d <smalloc+0xe1>
				start = s;
  801987:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80198a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80198d:	eb 0e                	jmp    80199d <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  80198f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801996:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  80199d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8019a3:	74 12                	je     8019b7 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8019a5:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8019ac:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8019b3:	76 af                	jbe    801964 <smalloc+0xa8>
  8019b5:	eb 01                	jmp    8019b8 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  8019b7:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  8019b8:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8019bc:	74 08                	je     8019c6 <smalloc+0x10a>
  8019be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8019c4:	74 0a                	je     8019d0 <smalloc+0x114>
		return NULL;
  8019c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019cb:	e9 85 00 00 00       	jmp    801a55 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8019d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d3:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8019d6:	c1 e8 0c             	shr    $0xc,%eax
  8019d9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  8019dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8019df:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8019e2:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8019e9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8019ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8019ef:	eb 11                	jmp    801a02 <smalloc+0x146>
		markedPages[s] = 1;
  8019f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019f4:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  8019fb:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8019ff:	ff 45 e8             	incl   -0x18(%ebp)
  801a02:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801a05:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a08:	01 d0                	add    %edx,%eax
  801a0a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a0d:	77 e2                	ja     8019f1 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  801a0f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a12:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801a16:	52                   	push   %edx
  801a17:	50                   	push   %eax
  801a18:	ff 75 0c             	pushl  0xc(%ebp)
  801a1b:	ff 75 08             	pushl  0x8(%ebp)
  801a1e:	e8 8f 04 00 00       	call   801eb2 <sys_createSharedObject>
  801a23:	83 c4 10             	add    $0x10,%esp
  801a26:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  801a29:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  801a2d:	78 12                	js     801a41 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  801a2f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801a32:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801a35:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3f:	eb 14                	jmp    801a55 <smalloc+0x199>
	}
	free((void*) start);
  801a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a44:	83 ec 0c             	sub    $0xc,%esp
  801a47:	50                   	push   %eax
  801a48:	e8 6e fd ff ff       	call   8017bb <free>
  801a4d:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801a50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  801a5d:	83 ec 08             	sub    $0x8,%esp
  801a60:	ff 75 0c             	pushl  0xc(%ebp)
  801a63:	ff 75 08             	pushl  0x8(%ebp)
  801a66:	e8 71 04 00 00       	call   801edc <sys_getSizeOfSharedObject>
  801a6b:	83 c4 10             	add    $0x10,%esp
  801a6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801a71:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801a78:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a7e:	01 d0                	add    %edx,%eax
  801a80:	48                   	dec    %eax
  801a81:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a84:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a87:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8c:	f7 75 e0             	divl   -0x20(%ebp)
  801a8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a92:	29 d0                	sub    %edx,%eax
  801a94:	c1 e8 0c             	shr    $0xc,%eax
  801a97:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  801a9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801aa1:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  801aa8:	a1 20 50 80 00       	mov    0x805020,%eax
  801aad:	8b 40 7c             	mov    0x7c(%eax),%eax
  801ab0:	05 00 10 00 00       	add    $0x1000,%eax
  801ab5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  801ab8:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801abd:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801ac0:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801ac3:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801aca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801acd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801ad0:	01 d0                	add    %edx,%eax
  801ad2:	48                   	dec    %eax
  801ad3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801ad6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ad9:	ba 00 00 00 00       	mov    $0x0,%edx
  801ade:	f7 75 cc             	divl   -0x34(%ebp)
  801ae1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ae4:	29 d0                	sub    %edx,%eax
  801ae6:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801ae9:	76 0a                	jbe    801af5 <sget+0x9e>
		return NULL;
  801aeb:	b8 00 00 00 00       	mov    $0x0,%eax
  801af0:	e9 f7 00 00 00       	jmp    801bec <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801af5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801af8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801afb:	eb 48                	jmp    801b45 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  801afd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b00:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801b03:	c1 e8 0c             	shr    $0xc,%eax
  801b06:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  801b09:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801b0c:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801b13:	85 c0                	test   %eax,%eax
  801b15:	75 11                	jne    801b28 <sget+0xd1>
			free_Pages_Count++;
  801b17:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801b1a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801b1e:	75 16                	jne    801b36 <sget+0xdf>
				start = s;
  801b20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b26:	eb 0e                	jmp    801b36 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  801b28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801b2f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  801b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b39:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801b3c:	74 12                	je     801b50 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801b3e:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801b45:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801b4c:	76 af                	jbe    801afd <sget+0xa6>
  801b4e:	eb 01                	jmp    801b51 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  801b50:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  801b51:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801b55:	74 08                	je     801b5f <sget+0x108>
  801b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801b5d:	74 0a                	je     801b69 <sget+0x112>
		return NULL;
  801b5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b64:	e9 83 00 00 00       	jmp    801bec <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  801b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b6c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801b6f:	c1 e8 0c             	shr    $0xc,%eax
  801b72:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  801b75:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b78:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b7b:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801b82:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b85:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b88:	eb 11                	jmp    801b9b <sget+0x144>
		markedPages[k] = 1;
  801b8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b8d:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801b94:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801b98:	ff 45 e8             	incl   -0x18(%ebp)
  801b9b:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801b9e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ba1:	01 d0                	add    %edx,%eax
  801ba3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801ba6:	77 e2                	ja     801b8a <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  801ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bab:	83 ec 04             	sub    $0x4,%esp
  801bae:	50                   	push   %eax
  801baf:	ff 75 0c             	pushl  0xc(%ebp)
  801bb2:	ff 75 08             	pushl  0x8(%ebp)
  801bb5:	e8 3f 03 00 00       	call   801ef9 <sys_getSharedObject>
  801bba:	83 c4 10             	add    $0x10,%esp
  801bbd:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  801bc0:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  801bc4:	78 12                	js     801bd8 <sget+0x181>
		shardIDs[startPage] = ss;
  801bc6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801bc9:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801bcc:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd6:	eb 14                	jmp    801bec <sget+0x195>
	}
	free((void*) start);
  801bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bdb:	83 ec 0c             	sub    $0xc,%esp
  801bde:	50                   	push   %eax
  801bdf:	e8 d7 fb ff ff       	call   8017bb <free>
  801be4:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801be7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
  801bf1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801bf4:	8b 55 08             	mov    0x8(%ebp),%edx
  801bf7:	a1 20 50 80 00       	mov    0x805020,%eax
  801bfc:	8b 40 7c             	mov    0x7c(%eax),%eax
  801bff:	29 c2                	sub    %eax,%edx
  801c01:	89 d0                	mov    %edx,%eax
  801c03:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  801c08:	c1 e8 0c             	shr    $0xc,%eax
  801c0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  801c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c11:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  801c18:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  801c1b:	83 ec 08             	sub    $0x8,%esp
  801c1e:	ff 75 08             	pushl  0x8(%ebp)
  801c21:	ff 75 f0             	pushl  -0x10(%ebp)
  801c24:	e8 ef 02 00 00       	call   801f18 <sys_freeSharedObject>
  801c29:	83 c4 10             	add    $0x10,%esp
  801c2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  801c2f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c33:	75 0e                	jne    801c43 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  801c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c38:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  801c3f:	ff ff ff ff 
	}

}
  801c43:	90                   	nop
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c4c:	83 ec 04             	sub    $0x4,%esp
  801c4f:	68 80 40 80 00       	push   $0x804080
  801c54:	68 19 01 00 00       	push   $0x119
  801c59:	68 72 40 80 00       	push   $0x804072
  801c5e:	e8 35 e9 ff ff       	call   800598 <_panic>

00801c63 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c69:	83 ec 04             	sub    $0x4,%esp
  801c6c:	68 a6 40 80 00       	push   $0x8040a6
  801c71:	68 23 01 00 00       	push   $0x123
  801c76:	68 72 40 80 00       	push   $0x804072
  801c7b:	e8 18 e9 ff ff       	call   800598 <_panic>

00801c80 <shrink>:

}
void shrink(uint32 newSize) {
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c86:	83 ec 04             	sub    $0x4,%esp
  801c89:	68 a6 40 80 00       	push   $0x8040a6
  801c8e:	68 27 01 00 00       	push   $0x127
  801c93:	68 72 40 80 00       	push   $0x804072
  801c98:	e8 fb e8 ff ff       	call   800598 <_panic>

00801c9d <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
  801ca0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ca3:	83 ec 04             	sub    $0x4,%esp
  801ca6:	68 a6 40 80 00       	push   $0x8040a6
  801cab:	68 2b 01 00 00       	push   $0x12b
  801cb0:	68 72 40 80 00       	push   $0x804072
  801cb5:	e8 de e8 ff ff       	call   800598 <_panic>

00801cba <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	57                   	push   %edi
  801cbe:	56                   	push   %esi
  801cbf:	53                   	push   %ebx
  801cc0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ccc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ccf:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cd2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cd5:	cd 30                	int    $0x30
  801cd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cdd:	83 c4 10             	add    $0x10,%esp
  801ce0:	5b                   	pop    %ebx
  801ce1:	5e                   	pop    %esi
  801ce2:	5f                   	pop    %edi
  801ce3:	5d                   	pop    %ebp
  801ce4:	c3                   	ret    

00801ce5 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	83 ec 04             	sub    $0x4,%esp
  801ceb:	8b 45 10             	mov    0x10(%ebp),%eax
  801cee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801cf1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	52                   	push   %edx
  801cfd:	ff 75 0c             	pushl  0xc(%ebp)
  801d00:	50                   	push   %eax
  801d01:	6a 00                	push   $0x0
  801d03:	e8 b2 ff ff ff       	call   801cba <syscall>
  801d08:	83 c4 18             	add    $0x18,%esp
}
  801d0b:	90                   	nop
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_cgetc>:

int sys_cgetc(void) {
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 02                	push   $0x2
  801d1d:	e8 98 ff ff ff       	call   801cba <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
}
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <sys_lock_cons>:

void sys_lock_cons(void) {
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 03                	push   $0x3
  801d36:	e8 7f ff ff ff       	call   801cba <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
}
  801d3e:	90                   	nop
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 04                	push   $0x4
  801d50:	e8 65 ff ff ff       	call   801cba <syscall>
  801d55:	83 c4 18             	add    $0x18,%esp
}
  801d58:	90                   	nop
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801d5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d61:	8b 45 08             	mov    0x8(%ebp),%eax
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	52                   	push   %edx
  801d6b:	50                   	push   %eax
  801d6c:	6a 08                	push   $0x8
  801d6e:	e8 47 ff ff ff       	call   801cba <syscall>
  801d73:	83 c4 18             	add    $0x18,%esp
}
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
  801d7b:	56                   	push   %esi
  801d7c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801d7d:	8b 75 18             	mov    0x18(%ebp),%esi
  801d80:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d83:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d89:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8c:	56                   	push   %esi
  801d8d:	53                   	push   %ebx
  801d8e:	51                   	push   %ecx
  801d8f:	52                   	push   %edx
  801d90:	50                   	push   %eax
  801d91:	6a 09                	push   $0x9
  801d93:	e8 22 ff ff ff       	call   801cba <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801d9b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d9e:	5b                   	pop    %ebx
  801d9f:	5e                   	pop    %esi
  801da0:	5d                   	pop    %ebp
  801da1:	c3                   	ret    

00801da2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801da5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	52                   	push   %edx
  801db2:	50                   	push   %eax
  801db3:	6a 0a                	push   $0xa
  801db5:	e8 00 ff ff ff       	call   801cba <syscall>
  801dba:	83 c4 18             	add    $0x18,%esp
}
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	ff 75 0c             	pushl  0xc(%ebp)
  801dcb:	ff 75 08             	pushl  0x8(%ebp)
  801dce:	6a 0b                	push   $0xb
  801dd0:	e8 e5 fe ff ff       	call   801cba <syscall>
  801dd5:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 0c                	push   $0xc
  801de9:	e8 cc fe ff ff       	call   801cba <syscall>
  801dee:	83 c4 18             	add    $0x18,%esp
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 0d                	push   $0xd
  801e02:	e8 b3 fe ff ff       	call   801cba <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 0e                	push   $0xe
  801e1b:	e8 9a fe ff ff       	call   801cba <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 0f                	push   $0xf
  801e34:	e8 81 fe ff ff       	call   801cba <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
}
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	ff 75 08             	pushl  0x8(%ebp)
  801e4c:	6a 10                	push   $0x10
  801e4e:	e8 67 fe ff ff       	call   801cba <syscall>
  801e53:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <sys_scarce_memory>:

void sys_scarce_memory() {
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 11                	push   $0x11
  801e67:	e8 4e fe ff ff       	call   801cba <syscall>
  801e6c:	83 c4 18             	add    $0x18,%esp
}
  801e6f:	90                   	nop
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <sys_cputc>:

void sys_cputc(const char c) {
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	83 ec 04             	sub    $0x4,%esp
  801e78:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e7e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	50                   	push   %eax
  801e8b:	6a 01                	push   $0x1
  801e8d:	e8 28 fe ff ff       	call   801cba <syscall>
  801e92:	83 c4 18             	add    $0x18,%esp
}
  801e95:	90                   	nop
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 14                	push   $0x14
  801ea7:	e8 0e fe ff ff       	call   801cba <syscall>
  801eac:	83 c4 18             	add    $0x18,%esp
}
  801eaf:	90                   	nop
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	83 ec 04             	sub    $0x4,%esp
  801eb8:	8b 45 10             	mov    0x10(%ebp),%eax
  801ebb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801ebe:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ec1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec8:	6a 00                	push   $0x0
  801eca:	51                   	push   %ecx
  801ecb:	52                   	push   %edx
  801ecc:	ff 75 0c             	pushl  0xc(%ebp)
  801ecf:	50                   	push   %eax
  801ed0:	6a 15                	push   $0x15
  801ed2:	e8 e3 fd ff ff       	call   801cba <syscall>
  801ed7:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801edf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	52                   	push   %edx
  801eec:	50                   	push   %eax
  801eed:	6a 16                	push   $0x16
  801eef:	e8 c6 fd ff ff       	call   801cba <syscall>
  801ef4:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801efc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f02:	8b 45 08             	mov    0x8(%ebp),%eax
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	51                   	push   %ecx
  801f0a:	52                   	push   %edx
  801f0b:	50                   	push   %eax
  801f0c:	6a 17                	push   $0x17
  801f0e:	e8 a7 fd ff ff       	call   801cba <syscall>
  801f13:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801f1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	52                   	push   %edx
  801f28:	50                   	push   %eax
  801f29:	6a 18                	push   $0x18
  801f2b:	e8 8a fd ff ff       	call   801cba <syscall>
  801f30:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801f38:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3b:	6a 00                	push   $0x0
  801f3d:	ff 75 14             	pushl  0x14(%ebp)
  801f40:	ff 75 10             	pushl  0x10(%ebp)
  801f43:	ff 75 0c             	pushl  0xc(%ebp)
  801f46:	50                   	push   %eax
  801f47:	6a 19                	push   $0x19
  801f49:	e8 6c fd ff ff       	call   801cba <syscall>
  801f4e:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    

00801f53 <sys_run_env>:

void sys_run_env(int32 envId) {
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801f56:	8b 45 08             	mov    0x8(%ebp),%eax
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	50                   	push   %eax
  801f62:	6a 1a                	push   $0x1a
  801f64:	e8 51 fd ff ff       	call   801cba <syscall>
  801f69:	83 c4 18             	add    $0x18,%esp
}
  801f6c:	90                   	nop
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f72:	8b 45 08             	mov    0x8(%ebp),%eax
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	50                   	push   %eax
  801f7e:	6a 1b                	push   $0x1b
  801f80:	e8 35 fd ff ff       	call   801cba <syscall>
  801f85:	83 c4 18             	add    $0x18,%esp
}
  801f88:	c9                   	leave  
  801f89:	c3                   	ret    

00801f8a <sys_getenvid>:

int32 sys_getenvid(void) {
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 05                	push   $0x5
  801f99:	e8 1c fd ff ff       	call   801cba <syscall>
  801f9e:	83 c4 18             	add    $0x18,%esp
}
  801fa1:	c9                   	leave  
  801fa2:	c3                   	ret    

00801fa3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 06                	push   $0x6
  801fb2:	e8 03 fd ff ff       	call   801cba <syscall>
  801fb7:	83 c4 18             	add    $0x18,%esp
}
  801fba:	c9                   	leave  
  801fbb:	c3                   	ret    

00801fbc <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 07                	push   $0x7
  801fcb:	e8 ea fc ff ff       	call   801cba <syscall>
  801fd0:	83 c4 18             	add    $0x18,%esp
}
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <sys_exit_env>:

void sys_exit_env(void) {
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 1c                	push   $0x1c
  801fe4:	e8 d1 fc ff ff       	call   801cba <syscall>
  801fe9:	83 c4 18             	add    $0x18,%esp
}
  801fec:	90                   	nop
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801ff5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ff8:	8d 50 04             	lea    0x4(%eax),%edx
  801ffb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	52                   	push   %edx
  802005:	50                   	push   %eax
  802006:	6a 1d                	push   $0x1d
  802008:	e8 ad fc ff ff       	call   801cba <syscall>
  80200d:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  802010:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802013:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802016:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802019:	89 01                	mov    %eax,(%ecx)
  80201b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80201e:	8b 45 08             	mov    0x8(%ebp),%eax
  802021:	c9                   	leave  
  802022:	c2 04 00             	ret    $0x4

00802025 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	ff 75 10             	pushl  0x10(%ebp)
  80202f:	ff 75 0c             	pushl  0xc(%ebp)
  802032:	ff 75 08             	pushl  0x8(%ebp)
  802035:	6a 13                	push   $0x13
  802037:	e8 7e fc ff ff       	call   801cba <syscall>
  80203c:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  80203f:	90                   	nop
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <sys_rcr2>:
uint32 sys_rcr2() {
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 1e                	push   $0x1e
  802051:	e8 64 fc ff ff       	call   801cba <syscall>
  802056:	83 c4 18             	add    $0x18,%esp
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
  80205e:	83 ec 04             	sub    $0x4,%esp
  802061:	8b 45 08             	mov    0x8(%ebp),%eax
  802064:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802067:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	50                   	push   %eax
  802074:	6a 1f                	push   $0x1f
  802076:	e8 3f fc ff ff       	call   801cba <syscall>
  80207b:	83 c4 18             	add    $0x18,%esp
	return;
  80207e:	90                   	nop
}
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <rsttst>:
void rsttst() {
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 21                	push   $0x21
  802090:	e8 25 fc ff ff       	call   801cba <syscall>
  802095:	83 c4 18             	add    $0x18,%esp
	return;
  802098:	90                   	nop
}
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
  80209e:	83 ec 04             	sub    $0x4,%esp
  8020a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8020a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020a7:	8b 55 18             	mov    0x18(%ebp),%edx
  8020aa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020ae:	52                   	push   %edx
  8020af:	50                   	push   %eax
  8020b0:	ff 75 10             	pushl  0x10(%ebp)
  8020b3:	ff 75 0c             	pushl  0xc(%ebp)
  8020b6:	ff 75 08             	pushl  0x8(%ebp)
  8020b9:	6a 20                	push   $0x20
  8020bb:	e8 fa fb ff ff       	call   801cba <syscall>
  8020c0:	83 c4 18             	add    $0x18,%esp
	return;
  8020c3:	90                   	nop
}
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <chktst>:
void chktst(uint32 n) {
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	ff 75 08             	pushl  0x8(%ebp)
  8020d4:	6a 22                	push   $0x22
  8020d6:	e8 df fb ff ff       	call   801cba <syscall>
  8020db:	83 c4 18             	add    $0x18,%esp
	return;
  8020de:	90                   	nop
}
  8020df:	c9                   	leave  
  8020e0:	c3                   	ret    

008020e1 <inctst>:

void inctst() {
  8020e1:	55                   	push   %ebp
  8020e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 23                	push   $0x23
  8020f0:	e8 c5 fb ff ff       	call   801cba <syscall>
  8020f5:	83 c4 18             	add    $0x18,%esp
	return;
  8020f8:	90                   	nop
}
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <gettst>:
uint32 gettst() {
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 24                	push   $0x24
  80210a:	e8 ab fb ff ff       	call   801cba <syscall>
  80210f:	83 c4 18             	add    $0x18,%esp
}
  802112:	c9                   	leave  
  802113:	c3                   	ret    

00802114 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
  802117:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 25                	push   $0x25
  802126:	e8 8f fb ff ff       	call   801cba <syscall>
  80212b:	83 c4 18             	add    $0x18,%esp
  80212e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802131:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802135:	75 07                	jne    80213e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802137:	b8 01 00 00 00       	mov    $0x1,%eax
  80213c:	eb 05                	jmp    802143 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80213e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802143:	c9                   	leave  
  802144:	c3                   	ret    

00802145 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
  802148:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 25                	push   $0x25
  802157:	e8 5e fb ff ff       	call   801cba <syscall>
  80215c:	83 c4 18             	add    $0x18,%esp
  80215f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802162:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802166:	75 07                	jne    80216f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802168:	b8 01 00 00 00       	mov    $0x1,%eax
  80216d:	eb 05                	jmp    802174 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80216f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
  802179:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 25                	push   $0x25
  802188:	e8 2d fb ff ff       	call   801cba <syscall>
  80218d:	83 c4 18             	add    $0x18,%esp
  802190:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802193:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802197:	75 07                	jne    8021a0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802199:	b8 01 00 00 00       	mov    $0x1,%eax
  80219e:	eb 05                	jmp    8021a5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8021a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
  8021aa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 25                	push   $0x25
  8021b9:	e8 fc fa ff ff       	call   801cba <syscall>
  8021be:	83 c4 18             	add    $0x18,%esp
  8021c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8021c4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8021c8:	75 07                	jne    8021d1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8021ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8021cf:	eb 05                	jmp    8021d6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8021d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	ff 75 08             	pushl  0x8(%ebp)
  8021e6:	6a 26                	push   $0x26
  8021e8:	e8 cd fa ff ff       	call   801cba <syscall>
  8021ed:	83 c4 18             	add    $0x18,%esp
	return;
  8021f0:	90                   	nop
}
  8021f1:	c9                   	leave  
  8021f2:	c3                   	ret    

008021f3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
  8021f6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  8021f7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	6a 00                	push   $0x0
  802205:	53                   	push   %ebx
  802206:	51                   	push   %ecx
  802207:	52                   	push   %edx
  802208:	50                   	push   %eax
  802209:	6a 27                	push   $0x27
  80220b:	e8 aa fa ff ff       	call   801cba <syscall>
  802210:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  802213:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  80221b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	52                   	push   %edx
  802228:	50                   	push   %eax
  802229:	6a 28                	push   $0x28
  80222b:	e8 8a fa ff ff       	call   801cba <syscall>
  802230:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  802233:	c9                   	leave  
  802234:	c3                   	ret    

00802235 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  802238:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80223b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80223e:	8b 45 08             	mov    0x8(%ebp),%eax
  802241:	6a 00                	push   $0x0
  802243:	51                   	push   %ecx
  802244:	ff 75 10             	pushl  0x10(%ebp)
  802247:	52                   	push   %edx
  802248:	50                   	push   %eax
  802249:	6a 29                	push   $0x29
  80224b:	e8 6a fa ff ff       	call   801cba <syscall>
  802250:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  802253:	c9                   	leave  
  802254:	c3                   	ret    

00802255 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	ff 75 10             	pushl  0x10(%ebp)
  80225f:	ff 75 0c             	pushl  0xc(%ebp)
  802262:	ff 75 08             	pushl  0x8(%ebp)
  802265:	6a 12                	push   $0x12
  802267:	e8 4e fa ff ff       	call   801cba <syscall>
  80226c:	83 c4 18             	add    $0x18,%esp
	return;
  80226f:	90                   	nop
}
  802270:	c9                   	leave  
  802271:	c3                   	ret    

00802272 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  802275:	8b 55 0c             	mov    0xc(%ebp),%edx
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	52                   	push   %edx
  802282:	50                   	push   %eax
  802283:	6a 2a                	push   $0x2a
  802285:	e8 30 fa ff ff       	call   801cba <syscall>
  80228a:	83 c4 18             	add    $0x18,%esp
	return;
  80228d:	90                   	nop
}
  80228e:	c9                   	leave  
  80228f:	c3                   	ret    

00802290 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	50                   	push   %eax
  80229f:	6a 2b                	push   $0x2b
  8022a1:	e8 14 fa ff ff       	call   801cba <syscall>
  8022a6:	83 c4 18             	add    $0x18,%esp
}
  8022a9:	c9                   	leave  
  8022aa:	c3                   	ret    

008022ab <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	ff 75 0c             	pushl  0xc(%ebp)
  8022b7:	ff 75 08             	pushl  0x8(%ebp)
  8022ba:	6a 2c                	push   $0x2c
  8022bc:	e8 f9 f9 ff ff       	call   801cba <syscall>
  8022c1:	83 c4 18             	add    $0x18,%esp
	return;
  8022c4:	90                   	nop
}
  8022c5:	c9                   	leave  
  8022c6:	c3                   	ret    

008022c7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	ff 75 0c             	pushl  0xc(%ebp)
  8022d3:	ff 75 08             	pushl  0x8(%ebp)
  8022d6:	6a 2d                	push   $0x2d
  8022d8:	e8 dd f9 ff ff       	call   801cba <syscall>
  8022dd:	83 c4 18             	add    $0x18,%esp
	return;
  8022e0:	90                   	nop
}
  8022e1:	c9                   	leave  
  8022e2:	c3                   	ret    

008022e3 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  8022e3:	55                   	push   %ebp
  8022e4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  8022e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	50                   	push   %eax
  8022f2:	6a 2f                	push   $0x2f
  8022f4:	e8 c1 f9 ff ff       	call   801cba <syscall>
  8022f9:	83 c4 18             	add    $0x18,%esp
	return;
  8022fc:	90                   	nop
}
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  802302:	8b 55 0c             	mov    0xc(%ebp),%edx
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	52                   	push   %edx
  80230f:	50                   	push   %eax
  802310:	6a 30                	push   $0x30
  802312:	e8 a3 f9 ff ff       	call   801cba <syscall>
  802317:	83 c4 18             	add    $0x18,%esp
	return;
  80231a:	90                   	nop
}
  80231b:	c9                   	leave  
  80231c:	c3                   	ret    

0080231d <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  802320:	8b 45 08             	mov    0x8(%ebp),%eax
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	50                   	push   %eax
  80232c:	6a 31                	push   $0x31
  80232e:	e8 87 f9 ff ff       	call   801cba <syscall>
  802333:	83 c4 18             	add    $0x18,%esp
	return;
  802336:	90                   	nop
}
  802337:	c9                   	leave  
  802338:	c3                   	ret    

00802339 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  802339:	55                   	push   %ebp
  80233a:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80233c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233f:	8b 45 08             	mov    0x8(%ebp),%eax
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	52                   	push   %edx
  802349:	50                   	push   %eax
  80234a:	6a 2e                	push   $0x2e
  80234c:	e8 69 f9 ff ff       	call   801cba <syscall>
  802351:	83 c4 18             	add    $0x18,%esp
    return;
  802354:	90                   	nop
}
  802355:	c9                   	leave  
  802356:	c3                   	ret    

00802357 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
  80235a:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80235d:	8b 45 08             	mov    0x8(%ebp),%eax
  802360:	83 e8 04             	sub    $0x4,%eax
  802363:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802369:	8b 00                	mov    (%eax),%eax
  80236b:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80236e:	c9                   	leave  
  80236f:	c3                   	ret    

00802370 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
  802373:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802376:	8b 45 08             	mov    0x8(%ebp),%eax
  802379:	83 e8 04             	sub    $0x4,%eax
  80237c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80237f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802382:	8b 00                	mov    (%eax),%eax
  802384:	83 e0 01             	and    $0x1,%eax
  802387:	85 c0                	test   %eax,%eax
  802389:	0f 94 c0             	sete   %al
}
  80238c:	c9                   	leave  
  80238d:	c3                   	ret    

0080238e <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80238e:	55                   	push   %ebp
  80238f:	89 e5                	mov    %esp,%ebp
  802391:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802394:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80239b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80239e:	83 f8 02             	cmp    $0x2,%eax
  8023a1:	74 2b                	je     8023ce <alloc_block+0x40>
  8023a3:	83 f8 02             	cmp    $0x2,%eax
  8023a6:	7f 07                	jg     8023af <alloc_block+0x21>
  8023a8:	83 f8 01             	cmp    $0x1,%eax
  8023ab:	74 0e                	je     8023bb <alloc_block+0x2d>
  8023ad:	eb 58                	jmp    802407 <alloc_block+0x79>
  8023af:	83 f8 03             	cmp    $0x3,%eax
  8023b2:	74 2d                	je     8023e1 <alloc_block+0x53>
  8023b4:	83 f8 04             	cmp    $0x4,%eax
  8023b7:	74 3b                	je     8023f4 <alloc_block+0x66>
  8023b9:	eb 4c                	jmp    802407 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8023bb:	83 ec 0c             	sub    $0xc,%esp
  8023be:	ff 75 08             	pushl  0x8(%ebp)
  8023c1:	e8 f7 03 00 00       	call   8027bd <alloc_block_FF>
  8023c6:	83 c4 10             	add    $0x10,%esp
  8023c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023cc:	eb 4a                	jmp    802418 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8023ce:	83 ec 0c             	sub    $0xc,%esp
  8023d1:	ff 75 08             	pushl  0x8(%ebp)
  8023d4:	e8 f0 11 00 00       	call   8035c9 <alloc_block_NF>
  8023d9:	83 c4 10             	add    $0x10,%esp
  8023dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023df:	eb 37                	jmp    802418 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8023e1:	83 ec 0c             	sub    $0xc,%esp
  8023e4:	ff 75 08             	pushl  0x8(%ebp)
  8023e7:	e8 08 08 00 00       	call   802bf4 <alloc_block_BF>
  8023ec:	83 c4 10             	add    $0x10,%esp
  8023ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023f2:	eb 24                	jmp    802418 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8023f4:	83 ec 0c             	sub    $0xc,%esp
  8023f7:	ff 75 08             	pushl  0x8(%ebp)
  8023fa:	e8 ad 11 00 00       	call   8035ac <alloc_block_WF>
  8023ff:	83 c4 10             	add    $0x10,%esp
  802402:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802405:	eb 11                	jmp    802418 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802407:	83 ec 0c             	sub    $0xc,%esp
  80240a:	68 b8 40 80 00       	push   $0x8040b8
  80240f:	e8 41 e4 ff ff       	call   800855 <cprintf>
  802414:	83 c4 10             	add    $0x10,%esp
		break;
  802417:	90                   	nop
	}
	return va;
  802418:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80241b:	c9                   	leave  
  80241c:	c3                   	ret    

0080241d <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80241d:	55                   	push   %ebp
  80241e:	89 e5                	mov    %esp,%ebp
  802420:	53                   	push   %ebx
  802421:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802424:	83 ec 0c             	sub    $0xc,%esp
  802427:	68 d8 40 80 00       	push   $0x8040d8
  80242c:	e8 24 e4 ff ff       	call   800855 <cprintf>
  802431:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802434:	83 ec 0c             	sub    $0xc,%esp
  802437:	68 03 41 80 00       	push   $0x804103
  80243c:	e8 14 e4 ff ff       	call   800855 <cprintf>
  802441:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802444:	8b 45 08             	mov    0x8(%ebp),%eax
  802447:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80244a:	eb 37                	jmp    802483 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80244c:	83 ec 0c             	sub    $0xc,%esp
  80244f:	ff 75 f4             	pushl  -0xc(%ebp)
  802452:	e8 19 ff ff ff       	call   802370 <is_free_block>
  802457:	83 c4 10             	add    $0x10,%esp
  80245a:	0f be d8             	movsbl %al,%ebx
  80245d:	83 ec 0c             	sub    $0xc,%esp
  802460:	ff 75 f4             	pushl  -0xc(%ebp)
  802463:	e8 ef fe ff ff       	call   802357 <get_block_size>
  802468:	83 c4 10             	add    $0x10,%esp
  80246b:	83 ec 04             	sub    $0x4,%esp
  80246e:	53                   	push   %ebx
  80246f:	50                   	push   %eax
  802470:	68 1b 41 80 00       	push   $0x80411b
  802475:	e8 db e3 ff ff       	call   800855 <cprintf>
  80247a:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80247d:	8b 45 10             	mov    0x10(%ebp),%eax
  802480:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802483:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802487:	74 07                	je     802490 <print_blocks_list+0x73>
  802489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248c:	8b 00                	mov    (%eax),%eax
  80248e:	eb 05                	jmp    802495 <print_blocks_list+0x78>
  802490:	b8 00 00 00 00       	mov    $0x0,%eax
  802495:	89 45 10             	mov    %eax,0x10(%ebp)
  802498:	8b 45 10             	mov    0x10(%ebp),%eax
  80249b:	85 c0                	test   %eax,%eax
  80249d:	75 ad                	jne    80244c <print_blocks_list+0x2f>
  80249f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a3:	75 a7                	jne    80244c <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8024a5:	83 ec 0c             	sub    $0xc,%esp
  8024a8:	68 d8 40 80 00       	push   $0x8040d8
  8024ad:	e8 a3 e3 ff ff       	call   800855 <cprintf>
  8024b2:	83 c4 10             	add    $0x10,%esp

}
  8024b5:	90                   	nop
  8024b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024b9:	c9                   	leave  
  8024ba:	c3                   	ret    

008024bb <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8024bb:	55                   	push   %ebp
  8024bc:	89 e5                	mov    %esp,%ebp
  8024be:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8024c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c4:	83 e0 01             	and    $0x1,%eax
  8024c7:	85 c0                	test   %eax,%eax
  8024c9:	74 03                	je     8024ce <initialize_dynamic_allocator+0x13>
  8024cb:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  8024ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8024d2:	0f 84 f8 00 00 00    	je     8025d0 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  8024d8:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  8024df:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  8024e2:	a1 40 50 98 00       	mov    0x985040,%eax
  8024e7:	85 c0                	test   %eax,%eax
  8024e9:	0f 84 e2 00 00 00    	je     8025d1 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  8024ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8024f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  8024fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802501:	8b 45 0c             	mov    0xc(%ebp),%eax
  802504:	01 d0                	add    %edx,%eax
  802506:	83 e8 04             	sub    $0x4,%eax
  802509:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  80250c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  802515:	8b 45 08             	mov    0x8(%ebp),%eax
  802518:	83 c0 08             	add    $0x8,%eax
  80251b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  80251e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802521:	83 e8 08             	sub    $0x8,%eax
  802524:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  802527:	83 ec 04             	sub    $0x4,%esp
  80252a:	6a 00                	push   $0x0
  80252c:	ff 75 e8             	pushl  -0x18(%ebp)
  80252f:	ff 75 ec             	pushl  -0x14(%ebp)
  802532:	e8 9c 00 00 00       	call   8025d3 <set_block_data>
  802537:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  80253a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802543:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802546:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  80254d:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  802554:	00 00 00 
  802557:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  80255e:	00 00 00 
  802561:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  802568:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  80256b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80256f:	75 17                	jne    802588 <initialize_dynamic_allocator+0xcd>
  802571:	83 ec 04             	sub    $0x4,%esp
  802574:	68 34 41 80 00       	push   $0x804134
  802579:	68 80 00 00 00       	push   $0x80
  80257e:	68 57 41 80 00       	push   $0x804157
  802583:	e8 10 e0 ff ff       	call   800598 <_panic>
  802588:	8b 15 48 50 98 00    	mov    0x985048,%edx
  80258e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802591:	89 10                	mov    %edx,(%eax)
  802593:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802596:	8b 00                	mov    (%eax),%eax
  802598:	85 c0                	test   %eax,%eax
  80259a:	74 0d                	je     8025a9 <initialize_dynamic_allocator+0xee>
  80259c:	a1 48 50 98 00       	mov    0x985048,%eax
  8025a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025a4:	89 50 04             	mov    %edx,0x4(%eax)
  8025a7:	eb 08                	jmp    8025b1 <initialize_dynamic_allocator+0xf6>
  8025a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ac:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8025b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b4:	a3 48 50 98 00       	mov    %eax,0x985048
  8025b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c3:	a1 54 50 98 00       	mov    0x985054,%eax
  8025c8:	40                   	inc    %eax
  8025c9:	a3 54 50 98 00       	mov    %eax,0x985054
  8025ce:	eb 01                	jmp    8025d1 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  8025d0:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  8025d1:	c9                   	leave  
  8025d2:	c3                   	ret    

008025d3 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8025d3:	55                   	push   %ebp
  8025d4:	89 e5                	mov    %esp,%ebp
  8025d6:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  8025d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025dc:	83 e0 01             	and    $0x1,%eax
  8025df:	85 c0                	test   %eax,%eax
  8025e1:	74 03                	je     8025e6 <set_block_data+0x13>
	{
		totalSize++;
  8025e3:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  8025e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e9:	83 e8 04             	sub    $0x4,%eax
  8025ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  8025ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025f2:	83 e0 fe             	and    $0xfffffffe,%eax
  8025f5:	89 c2                	mov    %eax,%edx
  8025f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8025fa:	83 e0 01             	and    $0x1,%eax
  8025fd:	09 c2                	or     %eax,%edx
  8025ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802602:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  802604:	8b 45 0c             	mov    0xc(%ebp),%eax
  802607:	8d 50 f8             	lea    -0x8(%eax),%edx
  80260a:	8b 45 08             	mov    0x8(%ebp),%eax
  80260d:	01 d0                	add    %edx,%eax
  80260f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  802612:	8b 45 0c             	mov    0xc(%ebp),%eax
  802615:	83 e0 fe             	and    $0xfffffffe,%eax
  802618:	89 c2                	mov    %eax,%edx
  80261a:	8b 45 10             	mov    0x10(%ebp),%eax
  80261d:	83 e0 01             	and    $0x1,%eax
  802620:	09 c2                	or     %eax,%edx
  802622:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802625:	89 10                	mov    %edx,(%eax)
}
  802627:	90                   	nop
  802628:	c9                   	leave  
  802629:	c3                   	ret    

0080262a <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  80262a:	55                   	push   %ebp
  80262b:	89 e5                	mov    %esp,%ebp
  80262d:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  802630:	a1 48 50 98 00       	mov    0x985048,%eax
  802635:	85 c0                	test   %eax,%eax
  802637:	75 68                	jne    8026a1 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  802639:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80263d:	75 17                	jne    802656 <insert_sorted_in_freeList+0x2c>
  80263f:	83 ec 04             	sub    $0x4,%esp
  802642:	68 34 41 80 00       	push   $0x804134
  802647:	68 9d 00 00 00       	push   $0x9d
  80264c:	68 57 41 80 00       	push   $0x804157
  802651:	e8 42 df ff ff       	call   800598 <_panic>
  802656:	8b 15 48 50 98 00    	mov    0x985048,%edx
  80265c:	8b 45 08             	mov    0x8(%ebp),%eax
  80265f:	89 10                	mov    %edx,(%eax)
  802661:	8b 45 08             	mov    0x8(%ebp),%eax
  802664:	8b 00                	mov    (%eax),%eax
  802666:	85 c0                	test   %eax,%eax
  802668:	74 0d                	je     802677 <insert_sorted_in_freeList+0x4d>
  80266a:	a1 48 50 98 00       	mov    0x985048,%eax
  80266f:	8b 55 08             	mov    0x8(%ebp),%edx
  802672:	89 50 04             	mov    %edx,0x4(%eax)
  802675:	eb 08                	jmp    80267f <insert_sorted_in_freeList+0x55>
  802677:	8b 45 08             	mov    0x8(%ebp),%eax
  80267a:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80267f:	8b 45 08             	mov    0x8(%ebp),%eax
  802682:	a3 48 50 98 00       	mov    %eax,0x985048
  802687:	8b 45 08             	mov    0x8(%ebp),%eax
  80268a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802691:	a1 54 50 98 00       	mov    0x985054,%eax
  802696:	40                   	inc    %eax
  802697:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  80269c:	e9 1a 01 00 00       	jmp    8027bb <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8026a1:	a1 48 50 98 00       	mov    0x985048,%eax
  8026a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a9:	eb 7f                	jmp    80272a <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026b1:	76 6f                	jbe    802722 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  8026b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b7:	74 06                	je     8026bf <insert_sorted_in_freeList+0x95>
  8026b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026bd:	75 17                	jne    8026d6 <insert_sorted_in_freeList+0xac>
  8026bf:	83 ec 04             	sub    $0x4,%esp
  8026c2:	68 70 41 80 00       	push   $0x804170
  8026c7:	68 a6 00 00 00       	push   $0xa6
  8026cc:	68 57 41 80 00       	push   $0x804157
  8026d1:	e8 c2 de ff ff       	call   800598 <_panic>
  8026d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d9:	8b 50 04             	mov    0x4(%eax),%edx
  8026dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026df:	89 50 04             	mov    %edx,0x4(%eax)
  8026e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e8:	89 10                	mov    %edx,(%eax)
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	8b 40 04             	mov    0x4(%eax),%eax
  8026f0:	85 c0                	test   %eax,%eax
  8026f2:	74 0d                	je     802701 <insert_sorted_in_freeList+0xd7>
  8026f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f7:	8b 40 04             	mov    0x4(%eax),%eax
  8026fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8026fd:	89 10                	mov    %edx,(%eax)
  8026ff:	eb 08                	jmp    802709 <insert_sorted_in_freeList+0xdf>
  802701:	8b 45 08             	mov    0x8(%ebp),%eax
  802704:	a3 48 50 98 00       	mov    %eax,0x985048
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	8b 55 08             	mov    0x8(%ebp),%edx
  80270f:	89 50 04             	mov    %edx,0x4(%eax)
  802712:	a1 54 50 98 00       	mov    0x985054,%eax
  802717:	40                   	inc    %eax
  802718:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  80271d:	e9 99 00 00 00       	jmp    8027bb <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802722:	a1 50 50 98 00       	mov    0x985050,%eax
  802727:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80272a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80272e:	74 07                	je     802737 <insert_sorted_in_freeList+0x10d>
  802730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802733:	8b 00                	mov    (%eax),%eax
  802735:	eb 05                	jmp    80273c <insert_sorted_in_freeList+0x112>
  802737:	b8 00 00 00 00       	mov    $0x0,%eax
  80273c:	a3 50 50 98 00       	mov    %eax,0x985050
  802741:	a1 50 50 98 00       	mov    0x985050,%eax
  802746:	85 c0                	test   %eax,%eax
  802748:	0f 85 5d ff ff ff    	jne    8026ab <insert_sorted_in_freeList+0x81>
  80274e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802752:	0f 85 53 ff ff ff    	jne    8026ab <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  802758:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80275c:	75 17                	jne    802775 <insert_sorted_in_freeList+0x14b>
  80275e:	83 ec 04             	sub    $0x4,%esp
  802761:	68 a8 41 80 00       	push   $0x8041a8
  802766:	68 ab 00 00 00       	push   $0xab
  80276b:	68 57 41 80 00       	push   $0x804157
  802770:	e8 23 de ff ff       	call   800598 <_panic>
  802775:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  80277b:	8b 45 08             	mov    0x8(%ebp),%eax
  80277e:	89 50 04             	mov    %edx,0x4(%eax)
  802781:	8b 45 08             	mov    0x8(%ebp),%eax
  802784:	8b 40 04             	mov    0x4(%eax),%eax
  802787:	85 c0                	test   %eax,%eax
  802789:	74 0c                	je     802797 <insert_sorted_in_freeList+0x16d>
  80278b:	a1 4c 50 98 00       	mov    0x98504c,%eax
  802790:	8b 55 08             	mov    0x8(%ebp),%edx
  802793:	89 10                	mov    %edx,(%eax)
  802795:	eb 08                	jmp    80279f <insert_sorted_in_freeList+0x175>
  802797:	8b 45 08             	mov    0x8(%ebp),%eax
  80279a:	a3 48 50 98 00       	mov    %eax,0x985048
  80279f:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a2:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8027a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b0:	a1 54 50 98 00       	mov    0x985054,%eax
  8027b5:	40                   	inc    %eax
  8027b6:	a3 54 50 98 00       	mov    %eax,0x985054
}
  8027bb:	c9                   	leave  
  8027bc:	c3                   	ret    

008027bd <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8027bd:	55                   	push   %ebp
  8027be:	89 e5                	mov    %esp,%ebp
  8027c0:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c6:	83 e0 01             	and    $0x1,%eax
  8027c9:	85 c0                	test   %eax,%eax
  8027cb:	74 03                	je     8027d0 <alloc_block_FF+0x13>
  8027cd:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8027d0:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8027d4:	77 07                	ja     8027dd <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027d6:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027dd:	a1 40 50 98 00       	mov    0x985040,%eax
  8027e2:	85 c0                	test   %eax,%eax
  8027e4:	75 63                	jne    802849 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e9:	83 c0 10             	add    $0x10,%eax
  8027ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027ef:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8027f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fc:	01 d0                	add    %edx,%eax
  8027fe:	48                   	dec    %eax
  8027ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802802:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802805:	ba 00 00 00 00       	mov    $0x0,%edx
  80280a:	f7 75 ec             	divl   -0x14(%ebp)
  80280d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802810:	29 d0                	sub    %edx,%eax
  802812:	c1 e8 0c             	shr    $0xc,%eax
  802815:	83 ec 0c             	sub    $0xc,%esp
  802818:	50                   	push   %eax
  802819:	e8 d1 ed ff ff       	call   8015ef <sbrk>
  80281e:	83 c4 10             	add    $0x10,%esp
  802821:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802824:	83 ec 0c             	sub    $0xc,%esp
  802827:	6a 00                	push   $0x0
  802829:	e8 c1 ed ff ff       	call   8015ef <sbrk>
  80282e:	83 c4 10             	add    $0x10,%esp
  802831:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802834:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802837:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80283a:	83 ec 08             	sub    $0x8,%esp
  80283d:	50                   	push   %eax
  80283e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802841:	e8 75 fc ff ff       	call   8024bb <initialize_dynamic_allocator>
  802846:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  802849:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80284d:	75 0a                	jne    802859 <alloc_block_FF+0x9c>
	{
		return NULL;
  80284f:	b8 00 00 00 00       	mov    $0x0,%eax
  802854:	e9 99 03 00 00       	jmp    802bf2 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802859:	8b 45 08             	mov    0x8(%ebp),%eax
  80285c:	83 c0 08             	add    $0x8,%eax
  80285f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802862:	a1 48 50 98 00       	mov    0x985048,%eax
  802867:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80286a:	e9 03 02 00 00       	jmp    802a72 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  80286f:	83 ec 0c             	sub    $0xc,%esp
  802872:	ff 75 f4             	pushl  -0xc(%ebp)
  802875:	e8 dd fa ff ff       	call   802357 <get_block_size>
  80287a:	83 c4 10             	add    $0x10,%esp
  80287d:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802880:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802883:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802886:	0f 82 de 01 00 00    	jb     802a6a <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  80288c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80288f:	83 c0 10             	add    $0x10,%eax
  802892:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802895:	0f 87 32 01 00 00    	ja     8029cd <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  80289b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80289e:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8028a1:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  8028a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028aa:	01 d0                	add    %edx,%eax
  8028ac:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  8028af:	83 ec 04             	sub    $0x4,%esp
  8028b2:	6a 00                	push   $0x0
  8028b4:	ff 75 98             	pushl  -0x68(%ebp)
  8028b7:	ff 75 94             	pushl  -0x6c(%ebp)
  8028ba:	e8 14 fd ff ff       	call   8025d3 <set_block_data>
  8028bf:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  8028c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c6:	74 06                	je     8028ce <alloc_block_FF+0x111>
  8028c8:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  8028cc:	75 17                	jne    8028e5 <alloc_block_FF+0x128>
  8028ce:	83 ec 04             	sub    $0x4,%esp
  8028d1:	68 cc 41 80 00       	push   $0x8041cc
  8028d6:	68 de 00 00 00       	push   $0xde
  8028db:	68 57 41 80 00       	push   $0x804157
  8028e0:	e8 b3 dc ff ff       	call   800598 <_panic>
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	8b 10                	mov    (%eax),%edx
  8028ea:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8028ed:	89 10                	mov    %edx,(%eax)
  8028ef:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8028f2:	8b 00                	mov    (%eax),%eax
  8028f4:	85 c0                	test   %eax,%eax
  8028f6:	74 0b                	je     802903 <alloc_block_FF+0x146>
  8028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fb:	8b 00                	mov    (%eax),%eax
  8028fd:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802900:	89 50 04             	mov    %edx,0x4(%eax)
  802903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802906:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802909:	89 10                	mov    %edx,(%eax)
  80290b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80290e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802911:	89 50 04             	mov    %edx,0x4(%eax)
  802914:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802917:	8b 00                	mov    (%eax),%eax
  802919:	85 c0                	test   %eax,%eax
  80291b:	75 08                	jne    802925 <alloc_block_FF+0x168>
  80291d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802920:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802925:	a1 54 50 98 00       	mov    0x985054,%eax
  80292a:	40                   	inc    %eax
  80292b:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802930:	83 ec 04             	sub    $0x4,%esp
  802933:	6a 01                	push   $0x1
  802935:	ff 75 dc             	pushl  -0x24(%ebp)
  802938:	ff 75 f4             	pushl  -0xc(%ebp)
  80293b:	e8 93 fc ff ff       	call   8025d3 <set_block_data>
  802940:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802943:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802947:	75 17                	jne    802960 <alloc_block_FF+0x1a3>
  802949:	83 ec 04             	sub    $0x4,%esp
  80294c:	68 00 42 80 00       	push   $0x804200
  802951:	68 e3 00 00 00       	push   $0xe3
  802956:	68 57 41 80 00       	push   $0x804157
  80295b:	e8 38 dc ff ff       	call   800598 <_panic>
  802960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802963:	8b 00                	mov    (%eax),%eax
  802965:	85 c0                	test   %eax,%eax
  802967:	74 10                	je     802979 <alloc_block_FF+0x1bc>
  802969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296c:	8b 00                	mov    (%eax),%eax
  80296e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802971:	8b 52 04             	mov    0x4(%edx),%edx
  802974:	89 50 04             	mov    %edx,0x4(%eax)
  802977:	eb 0b                	jmp    802984 <alloc_block_FF+0x1c7>
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	8b 40 04             	mov    0x4(%eax),%eax
  80297f:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	8b 40 04             	mov    0x4(%eax),%eax
  80298a:	85 c0                	test   %eax,%eax
  80298c:	74 0f                	je     80299d <alloc_block_FF+0x1e0>
  80298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802991:	8b 40 04             	mov    0x4(%eax),%eax
  802994:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802997:	8b 12                	mov    (%edx),%edx
  802999:	89 10                	mov    %edx,(%eax)
  80299b:	eb 0a                	jmp    8029a7 <alloc_block_FF+0x1ea>
  80299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a0:	8b 00                	mov    (%eax),%eax
  8029a2:	a3 48 50 98 00       	mov    %eax,0x985048
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ba:	a1 54 50 98 00       	mov    0x985054,%eax
  8029bf:	48                   	dec    %eax
  8029c0:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	e9 25 02 00 00       	jmp    802bf2 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  8029cd:	83 ec 04             	sub    $0x4,%esp
  8029d0:	6a 01                	push   $0x1
  8029d2:	ff 75 9c             	pushl  -0x64(%ebp)
  8029d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8029d8:	e8 f6 fb ff ff       	call   8025d3 <set_block_data>
  8029dd:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  8029e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e4:	75 17                	jne    8029fd <alloc_block_FF+0x240>
  8029e6:	83 ec 04             	sub    $0x4,%esp
  8029e9:	68 00 42 80 00       	push   $0x804200
  8029ee:	68 eb 00 00 00       	push   $0xeb
  8029f3:	68 57 41 80 00       	push   $0x804157
  8029f8:	e8 9b db ff ff       	call   800598 <_panic>
  8029fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a00:	8b 00                	mov    (%eax),%eax
  802a02:	85 c0                	test   %eax,%eax
  802a04:	74 10                	je     802a16 <alloc_block_FF+0x259>
  802a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a09:	8b 00                	mov    (%eax),%eax
  802a0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a0e:	8b 52 04             	mov    0x4(%edx),%edx
  802a11:	89 50 04             	mov    %edx,0x4(%eax)
  802a14:	eb 0b                	jmp    802a21 <alloc_block_FF+0x264>
  802a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a19:	8b 40 04             	mov    0x4(%eax),%eax
  802a1c:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	8b 40 04             	mov    0x4(%eax),%eax
  802a27:	85 c0                	test   %eax,%eax
  802a29:	74 0f                	je     802a3a <alloc_block_FF+0x27d>
  802a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2e:	8b 40 04             	mov    0x4(%eax),%eax
  802a31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a34:	8b 12                	mov    (%edx),%edx
  802a36:	89 10                	mov    %edx,(%eax)
  802a38:	eb 0a                	jmp    802a44 <alloc_block_FF+0x287>
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	8b 00                	mov    (%eax),%eax
  802a3f:	a3 48 50 98 00       	mov    %eax,0x985048
  802a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a57:	a1 54 50 98 00       	mov    0x985054,%eax
  802a5c:	48                   	dec    %eax
  802a5d:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a65:	e9 88 01 00 00       	jmp    802bf2 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802a6a:	a1 50 50 98 00       	mov    0x985050,%eax
  802a6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a76:	74 07                	je     802a7f <alloc_block_FF+0x2c2>
  802a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7b:	8b 00                	mov    (%eax),%eax
  802a7d:	eb 05                	jmp    802a84 <alloc_block_FF+0x2c7>
  802a7f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a84:	a3 50 50 98 00       	mov    %eax,0x985050
  802a89:	a1 50 50 98 00       	mov    0x985050,%eax
  802a8e:	85 c0                	test   %eax,%eax
  802a90:	0f 85 d9 fd ff ff    	jne    80286f <alloc_block_FF+0xb2>
  802a96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9a:	0f 85 cf fd ff ff    	jne    80286f <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  802aa0:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802aa7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802aaa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802aad:	01 d0                	add    %edx,%eax
  802aaf:	48                   	dec    %eax
  802ab0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802ab3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ab6:	ba 00 00 00 00       	mov    $0x0,%edx
  802abb:	f7 75 d8             	divl   -0x28(%ebp)
  802abe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ac1:	29 d0                	sub    %edx,%eax
  802ac3:	c1 e8 0c             	shr    $0xc,%eax
  802ac6:	83 ec 0c             	sub    $0xc,%esp
  802ac9:	50                   	push   %eax
  802aca:	e8 20 eb ff ff       	call   8015ef <sbrk>
  802acf:	83 c4 10             	add    $0x10,%esp
  802ad2:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802ad5:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802ad9:	75 0a                	jne    802ae5 <alloc_block_FF+0x328>
		return NULL;
  802adb:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae0:	e9 0d 01 00 00       	jmp    802bf2 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  802ae5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ae8:	83 e8 04             	sub    $0x4,%eax
  802aeb:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  802aee:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  802af5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802af8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802afb:	01 d0                	add    %edx,%eax
  802afd:	48                   	dec    %eax
  802afe:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802b01:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b04:	ba 00 00 00 00       	mov    $0x0,%edx
  802b09:	f7 75 c8             	divl   -0x38(%ebp)
  802b0c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b0f:	29 d0                	sub    %edx,%eax
  802b11:	c1 e8 02             	shr    $0x2,%eax
  802b14:	c1 e0 02             	shl    $0x2,%eax
  802b17:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  802b1a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b1d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  802b23:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b26:	83 e8 08             	sub    $0x8,%eax
  802b29:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  802b2c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b2f:	8b 00                	mov    (%eax),%eax
  802b31:	83 e0 fe             	and    $0xfffffffe,%eax
  802b34:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  802b37:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b3a:	f7 d8                	neg    %eax
  802b3c:	89 c2                	mov    %eax,%edx
  802b3e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b41:	01 d0                	add    %edx,%eax
  802b43:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  802b46:	83 ec 0c             	sub    $0xc,%esp
  802b49:	ff 75 b8             	pushl  -0x48(%ebp)
  802b4c:	e8 1f f8 ff ff       	call   802370 <is_free_block>
  802b51:	83 c4 10             	add    $0x10,%esp
  802b54:	0f be c0             	movsbl %al,%eax
  802b57:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  802b5a:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802b5e:	74 42                	je     802ba2 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  802b60:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802b67:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b6a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b6d:	01 d0                	add    %edx,%eax
  802b6f:	48                   	dec    %eax
  802b70:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802b73:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b76:	ba 00 00 00 00       	mov    $0x0,%edx
  802b7b:	f7 75 b0             	divl   -0x50(%ebp)
  802b7e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b81:	29 d0                	sub    %edx,%eax
  802b83:	89 c2                	mov    %eax,%edx
  802b85:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b88:	01 d0                	add    %edx,%eax
  802b8a:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  802b8d:	83 ec 04             	sub    $0x4,%esp
  802b90:	6a 00                	push   $0x0
  802b92:	ff 75 a8             	pushl  -0x58(%ebp)
  802b95:	ff 75 b8             	pushl  -0x48(%ebp)
  802b98:	e8 36 fa ff ff       	call   8025d3 <set_block_data>
  802b9d:	83 c4 10             	add    $0x10,%esp
  802ba0:	eb 42                	jmp    802be4 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802ba2:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  802ba9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802bac:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802baf:	01 d0                	add    %edx,%eax
  802bb1:	48                   	dec    %eax
  802bb2:	89 45 a0             	mov    %eax,-0x60(%ebp)
  802bb5:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802bb8:	ba 00 00 00 00       	mov    $0x0,%edx
  802bbd:	f7 75 a4             	divl   -0x5c(%ebp)
  802bc0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802bc3:	29 d0                	sub    %edx,%eax
  802bc5:	83 ec 04             	sub    $0x4,%esp
  802bc8:	6a 00                	push   $0x0
  802bca:	50                   	push   %eax
  802bcb:	ff 75 d0             	pushl  -0x30(%ebp)
  802bce:	e8 00 fa ff ff       	call   8025d3 <set_block_data>
  802bd3:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802bd6:	83 ec 0c             	sub    $0xc,%esp
  802bd9:	ff 75 d0             	pushl  -0x30(%ebp)
  802bdc:	e8 49 fa ff ff       	call   80262a <insert_sorted_in_freeList>
  802be1:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802be4:	83 ec 0c             	sub    $0xc,%esp
  802be7:	ff 75 08             	pushl  0x8(%ebp)
  802bea:	e8 ce fb ff ff       	call   8027bd <alloc_block_FF>
  802bef:	83 c4 10             	add    $0x10,%esp
}
  802bf2:	c9                   	leave  
  802bf3:	c3                   	ret    

00802bf4 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802bf4:	55                   	push   %ebp
  802bf5:	89 e5                	mov    %esp,%ebp
  802bf7:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  802bfa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bfe:	75 0a                	jne    802c0a <alloc_block_BF+0x16>
	{
		return NULL;
  802c00:	b8 00 00 00 00       	mov    $0x0,%eax
  802c05:	e9 7a 02 00 00       	jmp    802e84 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0d:	83 c0 08             	add    $0x8,%eax
  802c10:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802c13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  802c1a:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802c21:	a1 48 50 98 00       	mov    0x985048,%eax
  802c26:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802c29:	eb 32                	jmp    802c5d <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  802c2b:	ff 75 ec             	pushl  -0x14(%ebp)
  802c2e:	e8 24 f7 ff ff       	call   802357 <get_block_size>
  802c33:	83 c4 04             	add    $0x4,%esp
  802c36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  802c39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c3c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802c3f:	72 14                	jb     802c55 <alloc_block_BF+0x61>
  802c41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c44:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c47:	73 0c                	jae    802c55 <alloc_block_BF+0x61>
		{
			minBlk = block;
  802c49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  802c4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c52:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802c55:	a1 50 50 98 00       	mov    0x985050,%eax
  802c5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802c5d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c61:	74 07                	je     802c6a <alloc_block_BF+0x76>
  802c63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c66:	8b 00                	mov    (%eax),%eax
  802c68:	eb 05                	jmp    802c6f <alloc_block_BF+0x7b>
  802c6a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c6f:	a3 50 50 98 00       	mov    %eax,0x985050
  802c74:	a1 50 50 98 00       	mov    0x985050,%eax
  802c79:	85 c0                	test   %eax,%eax
  802c7b:	75 ae                	jne    802c2b <alloc_block_BF+0x37>
  802c7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c81:	75 a8                	jne    802c2b <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802c83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c87:	75 22                	jne    802cab <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802c89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c8c:	83 ec 0c             	sub    $0xc,%esp
  802c8f:	50                   	push   %eax
  802c90:	e8 5a e9 ff ff       	call   8015ef <sbrk>
  802c95:	83 c4 10             	add    $0x10,%esp
  802c98:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  802c9b:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802c9f:	75 0a                	jne    802cab <alloc_block_BF+0xb7>
			return NULL;
  802ca1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca6:	e9 d9 01 00 00       	jmp    802e84 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  802cab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cae:	83 c0 10             	add    $0x10,%eax
  802cb1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802cb4:	0f 87 32 01 00 00    	ja     802dec <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  802cba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbd:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802cc0:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802cc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cc9:	01 d0                	add    %edx,%eax
  802ccb:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  802cce:	83 ec 04             	sub    $0x4,%esp
  802cd1:	6a 00                	push   $0x0
  802cd3:	ff 75 dc             	pushl  -0x24(%ebp)
  802cd6:	ff 75 d8             	pushl  -0x28(%ebp)
  802cd9:	e8 f5 f8 ff ff       	call   8025d3 <set_block_data>
  802cde:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802ce1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce5:	74 06                	je     802ced <alloc_block_BF+0xf9>
  802ce7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802ceb:	75 17                	jne    802d04 <alloc_block_BF+0x110>
  802ced:	83 ec 04             	sub    $0x4,%esp
  802cf0:	68 cc 41 80 00       	push   $0x8041cc
  802cf5:	68 49 01 00 00       	push   $0x149
  802cfa:	68 57 41 80 00       	push   $0x804157
  802cff:	e8 94 d8 ff ff       	call   800598 <_panic>
  802d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d07:	8b 10                	mov    (%eax),%edx
  802d09:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d0c:	89 10                	mov    %edx,(%eax)
  802d0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d11:	8b 00                	mov    (%eax),%eax
  802d13:	85 c0                	test   %eax,%eax
  802d15:	74 0b                	je     802d22 <alloc_block_BF+0x12e>
  802d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1a:	8b 00                	mov    (%eax),%eax
  802d1c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802d1f:	89 50 04             	mov    %edx,0x4(%eax)
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802d28:	89 10                	mov    %edx,(%eax)
  802d2a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d30:	89 50 04             	mov    %edx,0x4(%eax)
  802d33:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d36:	8b 00                	mov    (%eax),%eax
  802d38:	85 c0                	test   %eax,%eax
  802d3a:	75 08                	jne    802d44 <alloc_block_BF+0x150>
  802d3c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d3f:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802d44:	a1 54 50 98 00       	mov    0x985054,%eax
  802d49:	40                   	inc    %eax
  802d4a:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802d4f:	83 ec 04             	sub    $0x4,%esp
  802d52:	6a 01                	push   $0x1
  802d54:	ff 75 e8             	pushl  -0x18(%ebp)
  802d57:	ff 75 f4             	pushl  -0xc(%ebp)
  802d5a:	e8 74 f8 ff ff       	call   8025d3 <set_block_data>
  802d5f:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802d62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d66:	75 17                	jne    802d7f <alloc_block_BF+0x18b>
  802d68:	83 ec 04             	sub    $0x4,%esp
  802d6b:	68 00 42 80 00       	push   $0x804200
  802d70:	68 4e 01 00 00       	push   $0x14e
  802d75:	68 57 41 80 00       	push   $0x804157
  802d7a:	e8 19 d8 ff ff       	call   800598 <_panic>
  802d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d82:	8b 00                	mov    (%eax),%eax
  802d84:	85 c0                	test   %eax,%eax
  802d86:	74 10                	je     802d98 <alloc_block_BF+0x1a4>
  802d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8b:	8b 00                	mov    (%eax),%eax
  802d8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d90:	8b 52 04             	mov    0x4(%edx),%edx
  802d93:	89 50 04             	mov    %edx,0x4(%eax)
  802d96:	eb 0b                	jmp    802da3 <alloc_block_BF+0x1af>
  802d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9b:	8b 40 04             	mov    0x4(%eax),%eax
  802d9e:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da6:	8b 40 04             	mov    0x4(%eax),%eax
  802da9:	85 c0                	test   %eax,%eax
  802dab:	74 0f                	je     802dbc <alloc_block_BF+0x1c8>
  802dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db0:	8b 40 04             	mov    0x4(%eax),%eax
  802db3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db6:	8b 12                	mov    (%edx),%edx
  802db8:	89 10                	mov    %edx,(%eax)
  802dba:	eb 0a                	jmp    802dc6 <alloc_block_BF+0x1d2>
  802dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbf:	8b 00                	mov    (%eax),%eax
  802dc1:	a3 48 50 98 00       	mov    %eax,0x985048
  802dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd9:	a1 54 50 98 00       	mov    0x985054,%eax
  802dde:	48                   	dec    %eax
  802ddf:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de7:	e9 98 00 00 00       	jmp    802e84 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  802dec:	83 ec 04             	sub    $0x4,%esp
  802def:	6a 01                	push   $0x1
  802df1:	ff 75 f0             	pushl  -0x10(%ebp)
  802df4:	ff 75 f4             	pushl  -0xc(%ebp)
  802df7:	e8 d7 f7 ff ff       	call   8025d3 <set_block_data>
  802dfc:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802dff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e03:	75 17                	jne    802e1c <alloc_block_BF+0x228>
  802e05:	83 ec 04             	sub    $0x4,%esp
  802e08:	68 00 42 80 00       	push   $0x804200
  802e0d:	68 56 01 00 00       	push   $0x156
  802e12:	68 57 41 80 00       	push   $0x804157
  802e17:	e8 7c d7 ff ff       	call   800598 <_panic>
  802e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1f:	8b 00                	mov    (%eax),%eax
  802e21:	85 c0                	test   %eax,%eax
  802e23:	74 10                	je     802e35 <alloc_block_BF+0x241>
  802e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e28:	8b 00                	mov    (%eax),%eax
  802e2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e2d:	8b 52 04             	mov    0x4(%edx),%edx
  802e30:	89 50 04             	mov    %edx,0x4(%eax)
  802e33:	eb 0b                	jmp    802e40 <alloc_block_BF+0x24c>
  802e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e38:	8b 40 04             	mov    0x4(%eax),%eax
  802e3b:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e43:	8b 40 04             	mov    0x4(%eax),%eax
  802e46:	85 c0                	test   %eax,%eax
  802e48:	74 0f                	je     802e59 <alloc_block_BF+0x265>
  802e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4d:	8b 40 04             	mov    0x4(%eax),%eax
  802e50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e53:	8b 12                	mov    (%edx),%edx
  802e55:	89 10                	mov    %edx,(%eax)
  802e57:	eb 0a                	jmp    802e63 <alloc_block_BF+0x26f>
  802e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5c:	8b 00                	mov    (%eax),%eax
  802e5e:	a3 48 50 98 00       	mov    %eax,0x985048
  802e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e76:	a1 54 50 98 00       	mov    0x985054,%eax
  802e7b:	48                   	dec    %eax
  802e7c:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802e84:	c9                   	leave  
  802e85:	c3                   	ret    

00802e86 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802e86:	55                   	push   %ebp
  802e87:	89 e5                	mov    %esp,%ebp
  802e89:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802e8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e90:	0f 84 6a 02 00 00    	je     803100 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  802e96:	ff 75 08             	pushl  0x8(%ebp)
  802e99:	e8 b9 f4 ff ff       	call   802357 <get_block_size>
  802e9e:	83 c4 04             	add    $0x4,%esp
  802ea1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  802ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea7:	83 e8 08             	sub    $0x8,%eax
  802eaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  802ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb0:	8b 00                	mov    (%eax),%eax
  802eb2:	83 e0 fe             	and    $0xfffffffe,%eax
  802eb5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  802eb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ebb:	f7 d8                	neg    %eax
  802ebd:	89 c2                	mov    %eax,%edx
  802ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec2:	01 d0                	add    %edx,%eax
  802ec4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802ec7:	ff 75 e8             	pushl  -0x18(%ebp)
  802eca:	e8 a1 f4 ff ff       	call   802370 <is_free_block>
  802ecf:	83 c4 04             	add    $0x4,%esp
  802ed2:	0f be c0             	movsbl %al,%eax
  802ed5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802ed8:	8b 55 08             	mov    0x8(%ebp),%edx
  802edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ede:	01 d0                	add    %edx,%eax
  802ee0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802ee3:	ff 75 e0             	pushl  -0x20(%ebp)
  802ee6:	e8 85 f4 ff ff       	call   802370 <is_free_block>
  802eeb:	83 c4 04             	add    $0x4,%esp
  802eee:	0f be c0             	movsbl %al,%eax
  802ef1:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802ef4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802ef8:	75 34                	jne    802f2e <free_block+0xa8>
  802efa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802efe:	75 2e                	jne    802f2e <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802f00:	ff 75 e8             	pushl  -0x18(%ebp)
  802f03:	e8 4f f4 ff ff       	call   802357 <get_block_size>
  802f08:	83 c4 04             	add    $0x4,%esp
  802f0b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802f0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f11:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f14:	01 d0                	add    %edx,%eax
  802f16:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802f19:	6a 00                	push   $0x0
  802f1b:	ff 75 d4             	pushl  -0x2c(%ebp)
  802f1e:	ff 75 e8             	pushl  -0x18(%ebp)
  802f21:	e8 ad f6 ff ff       	call   8025d3 <set_block_data>
  802f26:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802f29:	e9 d3 01 00 00       	jmp    803101 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802f2e:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802f32:	0f 85 c8 00 00 00    	jne    803000 <free_block+0x17a>
  802f38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f3c:	0f 85 be 00 00 00    	jne    803000 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802f42:	ff 75 e0             	pushl  -0x20(%ebp)
  802f45:	e8 0d f4 ff ff       	call   802357 <get_block_size>
  802f4a:	83 c4 04             	add    $0x4,%esp
  802f4d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802f50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f53:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f56:	01 d0                	add    %edx,%eax
  802f58:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802f5b:	6a 00                	push   $0x0
  802f5d:	ff 75 cc             	pushl  -0x34(%ebp)
  802f60:	ff 75 08             	pushl  0x8(%ebp)
  802f63:	e8 6b f6 ff ff       	call   8025d3 <set_block_data>
  802f68:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802f6b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f6f:	75 17                	jne    802f88 <free_block+0x102>
  802f71:	83 ec 04             	sub    $0x4,%esp
  802f74:	68 00 42 80 00       	push   $0x804200
  802f79:	68 87 01 00 00       	push   $0x187
  802f7e:	68 57 41 80 00       	push   $0x804157
  802f83:	e8 10 d6 ff ff       	call   800598 <_panic>
  802f88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f8b:	8b 00                	mov    (%eax),%eax
  802f8d:	85 c0                	test   %eax,%eax
  802f8f:	74 10                	je     802fa1 <free_block+0x11b>
  802f91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f94:	8b 00                	mov    (%eax),%eax
  802f96:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f99:	8b 52 04             	mov    0x4(%edx),%edx
  802f9c:	89 50 04             	mov    %edx,0x4(%eax)
  802f9f:	eb 0b                	jmp    802fac <free_block+0x126>
  802fa1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fa4:	8b 40 04             	mov    0x4(%eax),%eax
  802fa7:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802fac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802faf:	8b 40 04             	mov    0x4(%eax),%eax
  802fb2:	85 c0                	test   %eax,%eax
  802fb4:	74 0f                	je     802fc5 <free_block+0x13f>
  802fb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fb9:	8b 40 04             	mov    0x4(%eax),%eax
  802fbc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fbf:	8b 12                	mov    (%edx),%edx
  802fc1:	89 10                	mov    %edx,(%eax)
  802fc3:	eb 0a                	jmp    802fcf <free_block+0x149>
  802fc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fc8:	8b 00                	mov    (%eax),%eax
  802fca:	a3 48 50 98 00       	mov    %eax,0x985048
  802fcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fd2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fdb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe2:	a1 54 50 98 00       	mov    0x985054,%eax
  802fe7:	48                   	dec    %eax
  802fe8:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802fed:	83 ec 0c             	sub    $0xc,%esp
  802ff0:	ff 75 08             	pushl  0x8(%ebp)
  802ff3:	e8 32 f6 ff ff       	call   80262a <insert_sorted_in_freeList>
  802ff8:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802ffb:	e9 01 01 00 00       	jmp    803101 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  803000:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  803004:	0f 85 d3 00 00 00    	jne    8030dd <free_block+0x257>
  80300a:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  80300e:	0f 85 c9 00 00 00    	jne    8030dd <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  803014:	83 ec 0c             	sub    $0xc,%esp
  803017:	ff 75 e8             	pushl  -0x18(%ebp)
  80301a:	e8 38 f3 ff ff       	call   802357 <get_block_size>
  80301f:	83 c4 10             	add    $0x10,%esp
  803022:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  803025:	83 ec 0c             	sub    $0xc,%esp
  803028:	ff 75 e0             	pushl  -0x20(%ebp)
  80302b:	e8 27 f3 ff ff       	call   802357 <get_block_size>
  803030:	83 c4 10             	add    $0x10,%esp
  803033:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  803036:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803039:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80303c:	01 c2                	add    %eax,%edx
  80303e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803041:	01 d0                	add    %edx,%eax
  803043:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  803046:	83 ec 04             	sub    $0x4,%esp
  803049:	6a 00                	push   $0x0
  80304b:	ff 75 c0             	pushl  -0x40(%ebp)
  80304e:	ff 75 e8             	pushl  -0x18(%ebp)
  803051:	e8 7d f5 ff ff       	call   8025d3 <set_block_data>
  803056:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  803059:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80305d:	75 17                	jne    803076 <free_block+0x1f0>
  80305f:	83 ec 04             	sub    $0x4,%esp
  803062:	68 00 42 80 00       	push   $0x804200
  803067:	68 94 01 00 00       	push   $0x194
  80306c:	68 57 41 80 00       	push   $0x804157
  803071:	e8 22 d5 ff ff       	call   800598 <_panic>
  803076:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803079:	8b 00                	mov    (%eax),%eax
  80307b:	85 c0                	test   %eax,%eax
  80307d:	74 10                	je     80308f <free_block+0x209>
  80307f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803082:	8b 00                	mov    (%eax),%eax
  803084:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803087:	8b 52 04             	mov    0x4(%edx),%edx
  80308a:	89 50 04             	mov    %edx,0x4(%eax)
  80308d:	eb 0b                	jmp    80309a <free_block+0x214>
  80308f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803092:	8b 40 04             	mov    0x4(%eax),%eax
  803095:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80309a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80309d:	8b 40 04             	mov    0x4(%eax),%eax
  8030a0:	85 c0                	test   %eax,%eax
  8030a2:	74 0f                	je     8030b3 <free_block+0x22d>
  8030a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030a7:	8b 40 04             	mov    0x4(%eax),%eax
  8030aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030ad:	8b 12                	mov    (%edx),%edx
  8030af:	89 10                	mov    %edx,(%eax)
  8030b1:	eb 0a                	jmp    8030bd <free_block+0x237>
  8030b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030b6:	8b 00                	mov    (%eax),%eax
  8030b8:	a3 48 50 98 00       	mov    %eax,0x985048
  8030bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030d0:	a1 54 50 98 00       	mov    0x985054,%eax
  8030d5:	48                   	dec    %eax
  8030d6:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  8030db:	eb 24                	jmp    803101 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  8030dd:	83 ec 04             	sub    $0x4,%esp
  8030e0:	6a 00                	push   $0x0
  8030e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8030e5:	ff 75 08             	pushl  0x8(%ebp)
  8030e8:	e8 e6 f4 ff ff       	call   8025d3 <set_block_data>
  8030ed:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  8030f0:	83 ec 0c             	sub    $0xc,%esp
  8030f3:	ff 75 08             	pushl  0x8(%ebp)
  8030f6:	e8 2f f5 ff ff       	call   80262a <insert_sorted_in_freeList>
  8030fb:	83 c4 10             	add    $0x10,%esp
  8030fe:	eb 01                	jmp    803101 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  803100:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  803101:	c9                   	leave  
  803102:	c3                   	ret    

00803103 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  803103:	55                   	push   %ebp
  803104:	89 e5                	mov    %esp,%ebp
  803106:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  803109:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80310d:	75 10                	jne    80311f <realloc_block_FF+0x1c>
  80310f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803113:	75 0a                	jne    80311f <realloc_block_FF+0x1c>
	{
		return NULL;
  803115:	b8 00 00 00 00       	mov    $0x0,%eax
  80311a:	e9 8b 04 00 00       	jmp    8035aa <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  80311f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803123:	75 18                	jne    80313d <realloc_block_FF+0x3a>
	{
		free_block(va);
  803125:	83 ec 0c             	sub    $0xc,%esp
  803128:	ff 75 08             	pushl  0x8(%ebp)
  80312b:	e8 56 fd ff ff       	call   802e86 <free_block>
  803130:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803133:	b8 00 00 00 00       	mov    $0x0,%eax
  803138:	e9 6d 04 00 00       	jmp    8035aa <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  80313d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803141:	75 13                	jne    803156 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  803143:	83 ec 0c             	sub    $0xc,%esp
  803146:	ff 75 0c             	pushl  0xc(%ebp)
  803149:	e8 6f f6 ff ff       	call   8027bd <alloc_block_FF>
  80314e:	83 c4 10             	add    $0x10,%esp
  803151:	e9 54 04 00 00       	jmp    8035aa <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  803156:	8b 45 0c             	mov    0xc(%ebp),%eax
  803159:	83 e0 01             	and    $0x1,%eax
  80315c:	85 c0                	test   %eax,%eax
  80315e:	74 03                	je     803163 <realloc_block_FF+0x60>
	{
		new_size++;
  803160:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  803163:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803167:	77 07                	ja     803170 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  803169:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  803170:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  803174:	83 ec 0c             	sub    $0xc,%esp
  803177:	ff 75 08             	pushl  0x8(%ebp)
  80317a:	e8 d8 f1 ff ff       	call   802357 <get_block_size>
  80317f:	83 c4 10             	add    $0x10,%esp
  803182:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  803185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803188:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80318b:	75 08                	jne    803195 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  80318d:	8b 45 08             	mov    0x8(%ebp),%eax
  803190:	e9 15 04 00 00       	jmp    8035aa <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  803195:	8b 55 08             	mov    0x8(%ebp),%edx
  803198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319b:	01 d0                	add    %edx,%eax
  80319d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  8031a0:	83 ec 0c             	sub    $0xc,%esp
  8031a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8031a6:	e8 c5 f1 ff ff       	call   802370 <is_free_block>
  8031ab:	83 c4 10             	add    $0x10,%esp
  8031ae:	0f be c0             	movsbl %al,%eax
  8031b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  8031b4:	83 ec 0c             	sub    $0xc,%esp
  8031b7:	ff 75 f0             	pushl  -0x10(%ebp)
  8031ba:	e8 98 f1 ff ff       	call   802357 <get_block_size>
  8031bf:	83 c4 10             	add    $0x10,%esp
  8031c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  8031c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031c8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8031cb:	0f 86 a7 02 00 00    	jbe    803478 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  8031d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031d5:	0f 84 86 02 00 00    	je     803461 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  8031db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e1:	01 d0                	add    %edx,%eax
  8031e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8031e6:	0f 85 b2 00 00 00    	jne    80329e <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  8031ec:	83 ec 0c             	sub    $0xc,%esp
  8031ef:	ff 75 08             	pushl  0x8(%ebp)
  8031f2:	e8 79 f1 ff ff       	call   802370 <is_free_block>
  8031f7:	83 c4 10             	add    $0x10,%esp
  8031fa:	84 c0                	test   %al,%al
  8031fc:	0f 94 c0             	sete   %al
  8031ff:	0f b6 c0             	movzbl %al,%eax
  803202:	83 ec 04             	sub    $0x4,%esp
  803205:	50                   	push   %eax
  803206:	ff 75 0c             	pushl  0xc(%ebp)
  803209:	ff 75 08             	pushl  0x8(%ebp)
  80320c:	e8 c2 f3 ff ff       	call   8025d3 <set_block_data>
  803211:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  803214:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803218:	75 17                	jne    803231 <realloc_block_FF+0x12e>
  80321a:	83 ec 04             	sub    $0x4,%esp
  80321d:	68 00 42 80 00       	push   $0x804200
  803222:	68 db 01 00 00       	push   $0x1db
  803227:	68 57 41 80 00       	push   $0x804157
  80322c:	e8 67 d3 ff ff       	call   800598 <_panic>
  803231:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803234:	8b 00                	mov    (%eax),%eax
  803236:	85 c0                	test   %eax,%eax
  803238:	74 10                	je     80324a <realloc_block_FF+0x147>
  80323a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323d:	8b 00                	mov    (%eax),%eax
  80323f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803242:	8b 52 04             	mov    0x4(%edx),%edx
  803245:	89 50 04             	mov    %edx,0x4(%eax)
  803248:	eb 0b                	jmp    803255 <realloc_block_FF+0x152>
  80324a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324d:	8b 40 04             	mov    0x4(%eax),%eax
  803250:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803255:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803258:	8b 40 04             	mov    0x4(%eax),%eax
  80325b:	85 c0                	test   %eax,%eax
  80325d:	74 0f                	je     80326e <realloc_block_FF+0x16b>
  80325f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803262:	8b 40 04             	mov    0x4(%eax),%eax
  803265:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803268:	8b 12                	mov    (%edx),%edx
  80326a:	89 10                	mov    %edx,(%eax)
  80326c:	eb 0a                	jmp    803278 <realloc_block_FF+0x175>
  80326e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803271:	8b 00                	mov    (%eax),%eax
  803273:	a3 48 50 98 00       	mov    %eax,0x985048
  803278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803281:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803284:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80328b:	a1 54 50 98 00       	mov    0x985054,%eax
  803290:	48                   	dec    %eax
  803291:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  803296:	8b 45 08             	mov    0x8(%ebp),%eax
  803299:	e9 0c 03 00 00       	jmp    8035aa <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  80329e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a4:	01 d0                	add    %edx,%eax
  8032a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8032a9:	0f 86 b2 01 00 00    	jbe    803461 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  8032af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032b2:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8032b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  8032b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bb:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8032be:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  8032c1:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  8032c5:	0f 87 b8 00 00 00    	ja     803383 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  8032cb:	83 ec 0c             	sub    $0xc,%esp
  8032ce:	ff 75 08             	pushl  0x8(%ebp)
  8032d1:	e8 9a f0 ff ff       	call   802370 <is_free_block>
  8032d6:	83 c4 10             	add    $0x10,%esp
  8032d9:	84 c0                	test   %al,%al
  8032db:	0f 94 c0             	sete   %al
  8032de:	0f b6 c0             	movzbl %al,%eax
  8032e1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8032e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032e7:	01 ca                	add    %ecx,%edx
  8032e9:	83 ec 04             	sub    $0x4,%esp
  8032ec:	50                   	push   %eax
  8032ed:	52                   	push   %edx
  8032ee:	ff 75 08             	pushl  0x8(%ebp)
  8032f1:	e8 dd f2 ff ff       	call   8025d3 <set_block_data>
  8032f6:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8032f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032fd:	75 17                	jne    803316 <realloc_block_FF+0x213>
  8032ff:	83 ec 04             	sub    $0x4,%esp
  803302:	68 00 42 80 00       	push   $0x804200
  803307:	68 e8 01 00 00       	push   $0x1e8
  80330c:	68 57 41 80 00       	push   $0x804157
  803311:	e8 82 d2 ff ff       	call   800598 <_panic>
  803316:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803319:	8b 00                	mov    (%eax),%eax
  80331b:	85 c0                	test   %eax,%eax
  80331d:	74 10                	je     80332f <realloc_block_FF+0x22c>
  80331f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803322:	8b 00                	mov    (%eax),%eax
  803324:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803327:	8b 52 04             	mov    0x4(%edx),%edx
  80332a:	89 50 04             	mov    %edx,0x4(%eax)
  80332d:	eb 0b                	jmp    80333a <realloc_block_FF+0x237>
  80332f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803332:	8b 40 04             	mov    0x4(%eax),%eax
  803335:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80333a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80333d:	8b 40 04             	mov    0x4(%eax),%eax
  803340:	85 c0                	test   %eax,%eax
  803342:	74 0f                	je     803353 <realloc_block_FF+0x250>
  803344:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803347:	8b 40 04             	mov    0x4(%eax),%eax
  80334a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80334d:	8b 12                	mov    (%edx),%edx
  80334f:	89 10                	mov    %edx,(%eax)
  803351:	eb 0a                	jmp    80335d <realloc_block_FF+0x25a>
  803353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803356:	8b 00                	mov    (%eax),%eax
  803358:	a3 48 50 98 00       	mov    %eax,0x985048
  80335d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803360:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803366:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803369:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803370:	a1 54 50 98 00       	mov    0x985054,%eax
  803375:	48                   	dec    %eax
  803376:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  80337b:	8b 45 08             	mov    0x8(%ebp),%eax
  80337e:	e9 27 02 00 00       	jmp    8035aa <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803383:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803387:	75 17                	jne    8033a0 <realloc_block_FF+0x29d>
  803389:	83 ec 04             	sub    $0x4,%esp
  80338c:	68 00 42 80 00       	push   $0x804200
  803391:	68 ed 01 00 00       	push   $0x1ed
  803396:	68 57 41 80 00       	push   $0x804157
  80339b:	e8 f8 d1 ff ff       	call   800598 <_panic>
  8033a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a3:	8b 00                	mov    (%eax),%eax
  8033a5:	85 c0                	test   %eax,%eax
  8033a7:	74 10                	je     8033b9 <realloc_block_FF+0x2b6>
  8033a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ac:	8b 00                	mov    (%eax),%eax
  8033ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033b1:	8b 52 04             	mov    0x4(%edx),%edx
  8033b4:	89 50 04             	mov    %edx,0x4(%eax)
  8033b7:	eb 0b                	jmp    8033c4 <realloc_block_FF+0x2c1>
  8033b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bc:	8b 40 04             	mov    0x4(%eax),%eax
  8033bf:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8033c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c7:	8b 40 04             	mov    0x4(%eax),%eax
  8033ca:	85 c0                	test   %eax,%eax
  8033cc:	74 0f                	je     8033dd <realloc_block_FF+0x2da>
  8033ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d1:	8b 40 04             	mov    0x4(%eax),%eax
  8033d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033d7:	8b 12                	mov    (%edx),%edx
  8033d9:	89 10                	mov    %edx,(%eax)
  8033db:	eb 0a                	jmp    8033e7 <realloc_block_FF+0x2e4>
  8033dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e0:	8b 00                	mov    (%eax),%eax
  8033e2:	a3 48 50 98 00       	mov    %eax,0x985048
  8033e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033fa:	a1 54 50 98 00       	mov    0x985054,%eax
  8033ff:	48                   	dec    %eax
  803400:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  803405:	8b 55 08             	mov    0x8(%ebp),%edx
  803408:	8b 45 0c             	mov    0xc(%ebp),%eax
  80340b:	01 d0                	add    %edx,%eax
  80340d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  803410:	83 ec 04             	sub    $0x4,%esp
  803413:	6a 00                	push   $0x0
  803415:	ff 75 e0             	pushl  -0x20(%ebp)
  803418:	ff 75 f0             	pushl  -0x10(%ebp)
  80341b:	e8 b3 f1 ff ff       	call   8025d3 <set_block_data>
  803420:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  803423:	83 ec 0c             	sub    $0xc,%esp
  803426:	ff 75 08             	pushl  0x8(%ebp)
  803429:	e8 42 ef ff ff       	call   802370 <is_free_block>
  80342e:	83 c4 10             	add    $0x10,%esp
  803431:	84 c0                	test   %al,%al
  803433:	0f 94 c0             	sete   %al
  803436:	0f b6 c0             	movzbl %al,%eax
  803439:	83 ec 04             	sub    $0x4,%esp
  80343c:	50                   	push   %eax
  80343d:	ff 75 0c             	pushl  0xc(%ebp)
  803440:	ff 75 08             	pushl  0x8(%ebp)
  803443:	e8 8b f1 ff ff       	call   8025d3 <set_block_data>
  803448:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  80344b:	83 ec 0c             	sub    $0xc,%esp
  80344e:	ff 75 f0             	pushl  -0x10(%ebp)
  803451:	e8 d4 f1 ff ff       	call   80262a <insert_sorted_in_freeList>
  803456:	83 c4 10             	add    $0x10,%esp
					return va;
  803459:	8b 45 08             	mov    0x8(%ebp),%eax
  80345c:	e9 49 01 00 00       	jmp    8035aa <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803461:	8b 45 0c             	mov    0xc(%ebp),%eax
  803464:	83 e8 08             	sub    $0x8,%eax
  803467:	83 ec 0c             	sub    $0xc,%esp
  80346a:	50                   	push   %eax
  80346b:	e8 4d f3 ff ff       	call   8027bd <alloc_block_FF>
  803470:	83 c4 10             	add    $0x10,%esp
  803473:	e9 32 01 00 00       	jmp    8035aa <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  803478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80347b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80347e:	0f 83 21 01 00 00    	jae    8035a5 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  803484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803487:	2b 45 0c             	sub    0xc(%ebp),%eax
  80348a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  80348d:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  803491:	77 0e                	ja     8034a1 <realloc_block_FF+0x39e>
  803493:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803497:	75 08                	jne    8034a1 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  803499:	8b 45 08             	mov    0x8(%ebp),%eax
  80349c:	e9 09 01 00 00       	jmp    8035aa <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  8034a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  8034a7:	83 ec 0c             	sub    $0xc,%esp
  8034aa:	ff 75 08             	pushl  0x8(%ebp)
  8034ad:	e8 be ee ff ff       	call   802370 <is_free_block>
  8034b2:	83 c4 10             	add    $0x10,%esp
  8034b5:	84 c0                	test   %al,%al
  8034b7:	0f 94 c0             	sete   %al
  8034ba:	0f b6 c0             	movzbl %al,%eax
  8034bd:	83 ec 04             	sub    $0x4,%esp
  8034c0:	50                   	push   %eax
  8034c1:	ff 75 0c             	pushl  0xc(%ebp)
  8034c4:	ff 75 d8             	pushl  -0x28(%ebp)
  8034c7:	e8 07 f1 ff ff       	call   8025d3 <set_block_data>
  8034cc:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  8034cf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8034d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034d5:	01 d0                	add    %edx,%eax
  8034d7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  8034da:	83 ec 04             	sub    $0x4,%esp
  8034dd:	6a 00                	push   $0x0
  8034df:	ff 75 dc             	pushl  -0x24(%ebp)
  8034e2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8034e5:	e8 e9 f0 ff ff       	call   8025d3 <set_block_data>
  8034ea:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  8034ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034f1:	0f 84 9b 00 00 00    	je     803592 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  8034f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034fd:	01 d0                	add    %edx,%eax
  8034ff:	83 ec 04             	sub    $0x4,%esp
  803502:	6a 00                	push   $0x0
  803504:	50                   	push   %eax
  803505:	ff 75 d4             	pushl  -0x2c(%ebp)
  803508:	e8 c6 f0 ff ff       	call   8025d3 <set_block_data>
  80350d:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  803510:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803514:	75 17                	jne    80352d <realloc_block_FF+0x42a>
  803516:	83 ec 04             	sub    $0x4,%esp
  803519:	68 00 42 80 00       	push   $0x804200
  80351e:	68 10 02 00 00       	push   $0x210
  803523:	68 57 41 80 00       	push   $0x804157
  803528:	e8 6b d0 ff ff       	call   800598 <_panic>
  80352d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803530:	8b 00                	mov    (%eax),%eax
  803532:	85 c0                	test   %eax,%eax
  803534:	74 10                	je     803546 <realloc_block_FF+0x443>
  803536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803539:	8b 00                	mov    (%eax),%eax
  80353b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80353e:	8b 52 04             	mov    0x4(%edx),%edx
  803541:	89 50 04             	mov    %edx,0x4(%eax)
  803544:	eb 0b                	jmp    803551 <realloc_block_FF+0x44e>
  803546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803549:	8b 40 04             	mov    0x4(%eax),%eax
  80354c:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803554:	8b 40 04             	mov    0x4(%eax),%eax
  803557:	85 c0                	test   %eax,%eax
  803559:	74 0f                	je     80356a <realloc_block_FF+0x467>
  80355b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80355e:	8b 40 04             	mov    0x4(%eax),%eax
  803561:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803564:	8b 12                	mov    (%edx),%edx
  803566:	89 10                	mov    %edx,(%eax)
  803568:	eb 0a                	jmp    803574 <realloc_block_FF+0x471>
  80356a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80356d:	8b 00                	mov    (%eax),%eax
  80356f:	a3 48 50 98 00       	mov    %eax,0x985048
  803574:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803577:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80357d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803580:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803587:	a1 54 50 98 00       	mov    0x985054,%eax
  80358c:	48                   	dec    %eax
  80358d:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  803592:	83 ec 0c             	sub    $0xc,%esp
  803595:	ff 75 d4             	pushl  -0x2c(%ebp)
  803598:	e8 8d f0 ff ff       	call   80262a <insert_sorted_in_freeList>
  80359d:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  8035a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035a3:	eb 05                	jmp    8035aa <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  8035a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035aa:	c9                   	leave  
  8035ab:	c3                   	ret    

008035ac <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8035ac:	55                   	push   %ebp
  8035ad:	89 e5                	mov    %esp,%ebp
  8035af:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8035b2:	83 ec 04             	sub    $0x4,%esp
  8035b5:	68 20 42 80 00       	push   $0x804220
  8035ba:	68 20 02 00 00       	push   $0x220
  8035bf:	68 57 41 80 00       	push   $0x804157
  8035c4:	e8 cf cf ff ff       	call   800598 <_panic>

008035c9 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8035c9:	55                   	push   %ebp
  8035ca:	89 e5                	mov    %esp,%ebp
  8035cc:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8035cf:	83 ec 04             	sub    $0x4,%esp
  8035d2:	68 48 42 80 00       	push   $0x804248
  8035d7:	68 28 02 00 00       	push   $0x228
  8035dc:	68 57 41 80 00       	push   $0x804157
  8035e1:	e8 b2 cf ff ff       	call   800598 <_panic>
  8035e6:	66 90                	xchg   %ax,%ax

008035e8 <__udivdi3>:
  8035e8:	55                   	push   %ebp
  8035e9:	57                   	push   %edi
  8035ea:	56                   	push   %esi
  8035eb:	53                   	push   %ebx
  8035ec:	83 ec 1c             	sub    $0x1c,%esp
  8035ef:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8035f3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8035f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035ff:	89 ca                	mov    %ecx,%edx
  803601:	89 f8                	mov    %edi,%eax
  803603:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803607:	85 f6                	test   %esi,%esi
  803609:	75 2d                	jne    803638 <__udivdi3+0x50>
  80360b:	39 cf                	cmp    %ecx,%edi
  80360d:	77 65                	ja     803674 <__udivdi3+0x8c>
  80360f:	89 fd                	mov    %edi,%ebp
  803611:	85 ff                	test   %edi,%edi
  803613:	75 0b                	jne    803620 <__udivdi3+0x38>
  803615:	b8 01 00 00 00       	mov    $0x1,%eax
  80361a:	31 d2                	xor    %edx,%edx
  80361c:	f7 f7                	div    %edi
  80361e:	89 c5                	mov    %eax,%ebp
  803620:	31 d2                	xor    %edx,%edx
  803622:	89 c8                	mov    %ecx,%eax
  803624:	f7 f5                	div    %ebp
  803626:	89 c1                	mov    %eax,%ecx
  803628:	89 d8                	mov    %ebx,%eax
  80362a:	f7 f5                	div    %ebp
  80362c:	89 cf                	mov    %ecx,%edi
  80362e:	89 fa                	mov    %edi,%edx
  803630:	83 c4 1c             	add    $0x1c,%esp
  803633:	5b                   	pop    %ebx
  803634:	5e                   	pop    %esi
  803635:	5f                   	pop    %edi
  803636:	5d                   	pop    %ebp
  803637:	c3                   	ret    
  803638:	39 ce                	cmp    %ecx,%esi
  80363a:	77 28                	ja     803664 <__udivdi3+0x7c>
  80363c:	0f bd fe             	bsr    %esi,%edi
  80363f:	83 f7 1f             	xor    $0x1f,%edi
  803642:	75 40                	jne    803684 <__udivdi3+0x9c>
  803644:	39 ce                	cmp    %ecx,%esi
  803646:	72 0a                	jb     803652 <__udivdi3+0x6a>
  803648:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80364c:	0f 87 9e 00 00 00    	ja     8036f0 <__udivdi3+0x108>
  803652:	b8 01 00 00 00       	mov    $0x1,%eax
  803657:	89 fa                	mov    %edi,%edx
  803659:	83 c4 1c             	add    $0x1c,%esp
  80365c:	5b                   	pop    %ebx
  80365d:	5e                   	pop    %esi
  80365e:	5f                   	pop    %edi
  80365f:	5d                   	pop    %ebp
  803660:	c3                   	ret    
  803661:	8d 76 00             	lea    0x0(%esi),%esi
  803664:	31 ff                	xor    %edi,%edi
  803666:	31 c0                	xor    %eax,%eax
  803668:	89 fa                	mov    %edi,%edx
  80366a:	83 c4 1c             	add    $0x1c,%esp
  80366d:	5b                   	pop    %ebx
  80366e:	5e                   	pop    %esi
  80366f:	5f                   	pop    %edi
  803670:	5d                   	pop    %ebp
  803671:	c3                   	ret    
  803672:	66 90                	xchg   %ax,%ax
  803674:	89 d8                	mov    %ebx,%eax
  803676:	f7 f7                	div    %edi
  803678:	31 ff                	xor    %edi,%edi
  80367a:	89 fa                	mov    %edi,%edx
  80367c:	83 c4 1c             	add    $0x1c,%esp
  80367f:	5b                   	pop    %ebx
  803680:	5e                   	pop    %esi
  803681:	5f                   	pop    %edi
  803682:	5d                   	pop    %ebp
  803683:	c3                   	ret    
  803684:	bd 20 00 00 00       	mov    $0x20,%ebp
  803689:	89 eb                	mov    %ebp,%ebx
  80368b:	29 fb                	sub    %edi,%ebx
  80368d:	89 f9                	mov    %edi,%ecx
  80368f:	d3 e6                	shl    %cl,%esi
  803691:	89 c5                	mov    %eax,%ebp
  803693:	88 d9                	mov    %bl,%cl
  803695:	d3 ed                	shr    %cl,%ebp
  803697:	89 e9                	mov    %ebp,%ecx
  803699:	09 f1                	or     %esi,%ecx
  80369b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80369f:	89 f9                	mov    %edi,%ecx
  8036a1:	d3 e0                	shl    %cl,%eax
  8036a3:	89 c5                	mov    %eax,%ebp
  8036a5:	89 d6                	mov    %edx,%esi
  8036a7:	88 d9                	mov    %bl,%cl
  8036a9:	d3 ee                	shr    %cl,%esi
  8036ab:	89 f9                	mov    %edi,%ecx
  8036ad:	d3 e2                	shl    %cl,%edx
  8036af:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036b3:	88 d9                	mov    %bl,%cl
  8036b5:	d3 e8                	shr    %cl,%eax
  8036b7:	09 c2                	or     %eax,%edx
  8036b9:	89 d0                	mov    %edx,%eax
  8036bb:	89 f2                	mov    %esi,%edx
  8036bd:	f7 74 24 0c          	divl   0xc(%esp)
  8036c1:	89 d6                	mov    %edx,%esi
  8036c3:	89 c3                	mov    %eax,%ebx
  8036c5:	f7 e5                	mul    %ebp
  8036c7:	39 d6                	cmp    %edx,%esi
  8036c9:	72 19                	jb     8036e4 <__udivdi3+0xfc>
  8036cb:	74 0b                	je     8036d8 <__udivdi3+0xf0>
  8036cd:	89 d8                	mov    %ebx,%eax
  8036cf:	31 ff                	xor    %edi,%edi
  8036d1:	e9 58 ff ff ff       	jmp    80362e <__udivdi3+0x46>
  8036d6:	66 90                	xchg   %ax,%ax
  8036d8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8036dc:	89 f9                	mov    %edi,%ecx
  8036de:	d3 e2                	shl    %cl,%edx
  8036e0:	39 c2                	cmp    %eax,%edx
  8036e2:	73 e9                	jae    8036cd <__udivdi3+0xe5>
  8036e4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8036e7:	31 ff                	xor    %edi,%edi
  8036e9:	e9 40 ff ff ff       	jmp    80362e <__udivdi3+0x46>
  8036ee:	66 90                	xchg   %ax,%ax
  8036f0:	31 c0                	xor    %eax,%eax
  8036f2:	e9 37 ff ff ff       	jmp    80362e <__udivdi3+0x46>
  8036f7:	90                   	nop

008036f8 <__umoddi3>:
  8036f8:	55                   	push   %ebp
  8036f9:	57                   	push   %edi
  8036fa:	56                   	push   %esi
  8036fb:	53                   	push   %ebx
  8036fc:	83 ec 1c             	sub    $0x1c,%esp
  8036ff:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803703:	8b 74 24 34          	mov    0x34(%esp),%esi
  803707:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80370b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80370f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803713:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803717:	89 f3                	mov    %esi,%ebx
  803719:	89 fa                	mov    %edi,%edx
  80371b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80371f:	89 34 24             	mov    %esi,(%esp)
  803722:	85 c0                	test   %eax,%eax
  803724:	75 1a                	jne    803740 <__umoddi3+0x48>
  803726:	39 f7                	cmp    %esi,%edi
  803728:	0f 86 a2 00 00 00    	jbe    8037d0 <__umoddi3+0xd8>
  80372e:	89 c8                	mov    %ecx,%eax
  803730:	89 f2                	mov    %esi,%edx
  803732:	f7 f7                	div    %edi
  803734:	89 d0                	mov    %edx,%eax
  803736:	31 d2                	xor    %edx,%edx
  803738:	83 c4 1c             	add    $0x1c,%esp
  80373b:	5b                   	pop    %ebx
  80373c:	5e                   	pop    %esi
  80373d:	5f                   	pop    %edi
  80373e:	5d                   	pop    %ebp
  80373f:	c3                   	ret    
  803740:	39 f0                	cmp    %esi,%eax
  803742:	0f 87 ac 00 00 00    	ja     8037f4 <__umoddi3+0xfc>
  803748:	0f bd e8             	bsr    %eax,%ebp
  80374b:	83 f5 1f             	xor    $0x1f,%ebp
  80374e:	0f 84 ac 00 00 00    	je     803800 <__umoddi3+0x108>
  803754:	bf 20 00 00 00       	mov    $0x20,%edi
  803759:	29 ef                	sub    %ebp,%edi
  80375b:	89 fe                	mov    %edi,%esi
  80375d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803761:	89 e9                	mov    %ebp,%ecx
  803763:	d3 e0                	shl    %cl,%eax
  803765:	89 d7                	mov    %edx,%edi
  803767:	89 f1                	mov    %esi,%ecx
  803769:	d3 ef                	shr    %cl,%edi
  80376b:	09 c7                	or     %eax,%edi
  80376d:	89 e9                	mov    %ebp,%ecx
  80376f:	d3 e2                	shl    %cl,%edx
  803771:	89 14 24             	mov    %edx,(%esp)
  803774:	89 d8                	mov    %ebx,%eax
  803776:	d3 e0                	shl    %cl,%eax
  803778:	89 c2                	mov    %eax,%edx
  80377a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80377e:	d3 e0                	shl    %cl,%eax
  803780:	89 44 24 04          	mov    %eax,0x4(%esp)
  803784:	8b 44 24 08          	mov    0x8(%esp),%eax
  803788:	89 f1                	mov    %esi,%ecx
  80378a:	d3 e8                	shr    %cl,%eax
  80378c:	09 d0                	or     %edx,%eax
  80378e:	d3 eb                	shr    %cl,%ebx
  803790:	89 da                	mov    %ebx,%edx
  803792:	f7 f7                	div    %edi
  803794:	89 d3                	mov    %edx,%ebx
  803796:	f7 24 24             	mull   (%esp)
  803799:	89 c6                	mov    %eax,%esi
  80379b:	89 d1                	mov    %edx,%ecx
  80379d:	39 d3                	cmp    %edx,%ebx
  80379f:	0f 82 87 00 00 00    	jb     80382c <__umoddi3+0x134>
  8037a5:	0f 84 91 00 00 00    	je     80383c <__umoddi3+0x144>
  8037ab:	8b 54 24 04          	mov    0x4(%esp),%edx
  8037af:	29 f2                	sub    %esi,%edx
  8037b1:	19 cb                	sbb    %ecx,%ebx
  8037b3:	89 d8                	mov    %ebx,%eax
  8037b5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8037b9:	d3 e0                	shl    %cl,%eax
  8037bb:	89 e9                	mov    %ebp,%ecx
  8037bd:	d3 ea                	shr    %cl,%edx
  8037bf:	09 d0                	or     %edx,%eax
  8037c1:	89 e9                	mov    %ebp,%ecx
  8037c3:	d3 eb                	shr    %cl,%ebx
  8037c5:	89 da                	mov    %ebx,%edx
  8037c7:	83 c4 1c             	add    $0x1c,%esp
  8037ca:	5b                   	pop    %ebx
  8037cb:	5e                   	pop    %esi
  8037cc:	5f                   	pop    %edi
  8037cd:	5d                   	pop    %ebp
  8037ce:	c3                   	ret    
  8037cf:	90                   	nop
  8037d0:	89 fd                	mov    %edi,%ebp
  8037d2:	85 ff                	test   %edi,%edi
  8037d4:	75 0b                	jne    8037e1 <__umoddi3+0xe9>
  8037d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8037db:	31 d2                	xor    %edx,%edx
  8037dd:	f7 f7                	div    %edi
  8037df:	89 c5                	mov    %eax,%ebp
  8037e1:	89 f0                	mov    %esi,%eax
  8037e3:	31 d2                	xor    %edx,%edx
  8037e5:	f7 f5                	div    %ebp
  8037e7:	89 c8                	mov    %ecx,%eax
  8037e9:	f7 f5                	div    %ebp
  8037eb:	89 d0                	mov    %edx,%eax
  8037ed:	e9 44 ff ff ff       	jmp    803736 <__umoddi3+0x3e>
  8037f2:	66 90                	xchg   %ax,%ax
  8037f4:	89 c8                	mov    %ecx,%eax
  8037f6:	89 f2                	mov    %esi,%edx
  8037f8:	83 c4 1c             	add    $0x1c,%esp
  8037fb:	5b                   	pop    %ebx
  8037fc:	5e                   	pop    %esi
  8037fd:	5f                   	pop    %edi
  8037fe:	5d                   	pop    %ebp
  8037ff:	c3                   	ret    
  803800:	3b 04 24             	cmp    (%esp),%eax
  803803:	72 06                	jb     80380b <__umoddi3+0x113>
  803805:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803809:	77 0f                	ja     80381a <__umoddi3+0x122>
  80380b:	89 f2                	mov    %esi,%edx
  80380d:	29 f9                	sub    %edi,%ecx
  80380f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803813:	89 14 24             	mov    %edx,(%esp)
  803816:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80381a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80381e:	8b 14 24             	mov    (%esp),%edx
  803821:	83 c4 1c             	add    $0x1c,%esp
  803824:	5b                   	pop    %ebx
  803825:	5e                   	pop    %esi
  803826:	5f                   	pop    %edi
  803827:	5d                   	pop    %ebp
  803828:	c3                   	ret    
  803829:	8d 76 00             	lea    0x0(%esi),%esi
  80382c:	2b 04 24             	sub    (%esp),%eax
  80382f:	19 fa                	sbb    %edi,%edx
  803831:	89 d1                	mov    %edx,%ecx
  803833:	89 c6                	mov    %eax,%esi
  803835:	e9 71 ff ff ff       	jmp    8037ab <__umoddi3+0xb3>
  80383a:	66 90                	xchg   %ax,%ax
  80383c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803840:	72 ea                	jb     80382c <__umoddi3+0x134>
  803842:	89 d9                	mov    %ebx,%ecx
  803844:	e9 62 ff ff ff       	jmp    8037ab <__umoddi3+0xb3>
