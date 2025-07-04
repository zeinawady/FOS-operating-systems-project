
obj/user/tst_sharing_1:     file format elf32-i386


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
  800031:	e8 d7 03 00 00       	call   80040d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the creation of shared variables (create_shared_memory)
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
  80005c:	68 20 38 80 00       	push   $0x803820
  800061:	6a 13                	push   $0x13
  800063:	68 3c 38 80 00       	push   $0x80383c
  800068:	e8 e5 04 00 00       	call   800552 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	int eval = 0;
  80006d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  800074:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	uint32 *x, *y, *z ;
	uint32 expected ;
	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80007b:	c7 45 e8 00 10 00 82 	movl   $0x82001000,-0x18(%ebp)

	cprintf("STEP A: checking the creation of shared variables... [60%]\n");
  800082:	83 ec 0c             	sub    $0xc,%esp
  800085:	68 54 38 80 00       	push   $0x803854
  80008a:	e8 80 07 00 00       	call   80080f <cprintf>
  80008f:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800092:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800099:	e8 f6 1c 00 00       	call   801d94 <sys_calculate_free_frames>
  80009e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000a1:	83 ec 04             	sub    $0x4,%esp
  8000a4:	6a 01                	push   $0x1
  8000a6:	68 00 10 00 00       	push   $0x1000
  8000ab:	68 90 38 80 00       	push   $0x803890
  8000b0:	e8 c1 17 00 00       	call   801876 <smalloc>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8000bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000be:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8000c1:	74 17                	je     8000da <_main+0xa2>
  8000c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 94 38 80 00       	push   $0x803894
  8000d2:	e8 38 07 00 00       	call   80080f <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp
		expected = 1+1 ; /*1page +1table*/
  8000da:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  8000e1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000e4:	e8 ab 1c 00 00       	call   801d94 <sys_calculate_free_frames>
  8000e9:	29 c3                	sub    %eax,%ebx
  8000eb:	89 d8                	mov    %ebx,%eax
  8000ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8000f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000f3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8000f6:	72 0d                	jb     800105 <_main+0xcd>
  8000f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000fb:	8d 50 02             	lea    0x2(%eax),%edx
  8000fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800101:	39 c2                	cmp    %eax,%edx
  800103:	73 27                	jae    80012c <_main+0xf4>
  800105:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80010c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80010f:	e8 80 1c 00 00       	call   801d94 <sys_calculate_free_frames>
  800114:	29 c3                	sub    %eax,%ebx
  800116:	89 d8                	mov    %ebx,%eax
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	ff 75 dc             	pushl  -0x24(%ebp)
  80011e:	50                   	push   %eax
  80011f:	68 00 39 80 00       	push   $0x803900
  800124:	e8 e6 06 00 00       	call   80080f <cprintf>
  800129:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80012c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800130:	74 04                	je     800136 <_main+0xfe>
  800132:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  800136:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80013d:	e8 52 1c 00 00       	call   801d94 <sys_calculate_free_frames>
  800142:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	6a 01                	push   $0x1
  80014a:	68 04 10 00 00       	push   $0x1004
  80014f:	68 98 39 80 00       	push   $0x803998
  800154:	e8 1d 17 00 00       	call   801876 <smalloc>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (z != (uint32*)(pagealloc_start + 1 * PAGE_SIZE)) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  80015f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800162:	05 00 10 00 00       	add    $0x1000,%eax
  800167:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80016a:	74 17                	je     800183 <_main+0x14b>
  80016c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	68 94 38 80 00       	push   $0x803894
  80017b:	e8 8f 06 00 00       	call   80080f <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp
		expected = 2 ; /*2pages*/
  800183:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80018a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80018d:	e8 02 1c 00 00       	call   801d94 <sys_calculate_free_frames>
  800192:	29 c3                	sub    %eax,%ebx
  800194:	89 d8                	mov    %ebx,%eax
  800196:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800199:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80019c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80019f:	72 0d                	jb     8001ae <_main+0x176>
  8001a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001a4:	8d 50 02             	lea    0x2(%eax),%edx
  8001a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001aa:	39 c2                	cmp    %eax,%edx
  8001ac:	73 27                	jae    8001d5 <_main+0x19d>
  8001ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001b8:	e8 d7 1b 00 00       	call   801d94 <sys_calculate_free_frames>
  8001bd:	29 c3                	sub    %eax,%ebx
  8001bf:	89 d8                	mov    %ebx,%eax
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	ff 75 dc             	pushl  -0x24(%ebp)
  8001c7:	50                   	push   %eax
  8001c8:	68 00 39 80 00       	push   $0x803900
  8001cd:	e8 3d 06 00 00       	call   80080f <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  8001d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8001d9:	74 04                	je     8001df <_main+0x1a7>
  8001db:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  8001df:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  8001e6:	e8 a9 1b 00 00       	call   801d94 <sys_calculate_free_frames>
  8001eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		y = smalloc("y", 4, 1);
  8001ee:	83 ec 04             	sub    $0x4,%esp
  8001f1:	6a 01                	push   $0x1
  8001f3:	6a 04                	push   $0x4
  8001f5:	68 9a 39 80 00       	push   $0x80399a
  8001fa:	e8 77 16 00 00       	call   801876 <smalloc>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (y != (uint32*)(pagealloc_start + 3 * PAGE_SIZE)) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800205:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800208:	05 00 30 00 00       	add    $0x3000,%eax
  80020d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800210:	74 17                	je     800229 <_main+0x1f1>
  800212:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	68 94 38 80 00       	push   $0x803894
  800221:	e8 e9 05 00 00       	call   80080f <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		expected = 1 ; /*1page*/
  800229:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800230:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800233:	e8 5c 1b 00 00       	call   801d94 <sys_calculate_free_frames>
  800238:	29 c3                	sub    %eax,%ebx
  80023a:	89 d8                	mov    %ebx,%eax
  80023c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  80023f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800242:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800245:	72 0d                	jb     800254 <_main+0x21c>
  800247:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80024a:	8d 50 02             	lea    0x2(%eax),%edx
  80024d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800250:	39 c2                	cmp    %eax,%edx
  800252:	73 27                	jae    80027b <_main+0x243>
  800254:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80025b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80025e:	e8 31 1b 00 00       	call   801d94 <sys_calculate_free_frames>
  800263:	29 c3                	sub    %eax,%ebx
  800265:	89 d8                	mov    %ebx,%eax
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	ff 75 dc             	pushl  -0x24(%ebp)
  80026d:	50                   	push   %eax
  80026e:	68 00 39 80 00       	push   $0x803900
  800273:	e8 97 05 00 00       	call   80080f <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80027b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80027f:	74 04                	je     800285 <_main+0x24d>
  800281:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  800285:	83 ec 0c             	sub    $0xc,%esp
  800288:	68 9c 39 80 00       	push   $0x80399c
  80028d:	e8 7d 05 00 00       	call   80080f <cprintf>
  800292:	83 c4 10             	add    $0x10,%esp

	is_correct = 1;
  800295:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf("STEP B: checking reading & writing... [40%]\n");
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	68 c4 39 80 00       	push   $0x8039c4
  8002a4:	e8 66 05 00 00       	call   80080f <cprintf>
  8002a9:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  8002ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  8002b3:	eb 2d                	jmp    8002e2 <_main+0x2aa>
		{
			x[i] = -1;
  8002b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002c2:	01 d0                	add    %edx,%eax
  8002c4:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  8002ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002d7:	01 d0                	add    %edx,%eax
  8002d9:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

	is_correct = 1;
	cprintf("STEP B: checking reading & writing... [40%]\n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  8002df:	ff 45 ec             	incl   -0x14(%ebp)
  8002e2:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  8002e9:	7e ca                	jle    8002b5 <_main+0x27d>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  8002eb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  8002f2:	eb 18                	jmp    80030c <_main+0x2d4>
		{
			z[i] = -1;
  8002f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800301:	01 d0                	add    %edx,%eax
  800303:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  800309:	ff 45 ec             	incl   -0x14(%ebp)
  80030c:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  800313:	7e df                	jle    8002f4 <_main+0x2bc>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  800315:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800318:	8b 00                	mov    (%eax),%eax
  80031a:	83 f8 ff             	cmp    $0xffffffff,%eax
  80031d:	74 17                	je     800336 <_main+0x2fe>
  80031f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800326:	83 ec 0c             	sub    $0xc,%esp
  800329:	68 f4 39 80 00       	push   $0x8039f4
  80032e:	e8 dc 04 00 00       	call   80080f <cprintf>
  800333:	83 c4 10             	add    $0x10,%esp
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  800336:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800339:	05 fc 0f 00 00       	add    $0xffc,%eax
  80033e:	8b 00                	mov    (%eax),%eax
  800340:	83 f8 ff             	cmp    $0xffffffff,%eax
  800343:	74 17                	je     80035c <_main+0x324>
  800345:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80034c:	83 ec 0c             	sub    $0xc,%esp
  80034f:	68 f4 39 80 00       	push   $0x8039f4
  800354:	e8 b6 04 00 00       	call   80080f <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp

		if( y[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  80035c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80035f:	8b 00                	mov    (%eax),%eax
  800361:	83 f8 ff             	cmp    $0xffffffff,%eax
  800364:	74 17                	je     80037d <_main+0x345>
  800366:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 f4 39 80 00       	push   $0x8039f4
  800375:	e8 95 04 00 00       	call   80080f <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  80037d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800380:	05 fc 0f 00 00       	add    $0xffc,%eax
  800385:	8b 00                	mov    (%eax),%eax
  800387:	83 f8 ff             	cmp    $0xffffffff,%eax
  80038a:	74 17                	je     8003a3 <_main+0x36b>
  80038c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800393:	83 ec 0c             	sub    $0xc,%esp
  800396:	68 f4 39 80 00       	push   $0x8039f4
  80039b:	e8 6f 04 00 00       	call   80080f <cprintf>
  8003a0:	83 c4 10             	add    $0x10,%esp

		if( z[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  8003a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	83 f8 ff             	cmp    $0xffffffff,%eax
  8003ab:	74 17                	je     8003c4 <_main+0x38c>
  8003ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003b4:	83 ec 0c             	sub    $0xc,%esp
  8003b7:	68 f4 39 80 00       	push   $0x8039f4
  8003bc:	e8 4e 04 00 00       	call   80080f <cprintf>
  8003c1:	83 c4 10             	add    $0x10,%esp
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  8003c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c7:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  8003cc:	8b 00                	mov    (%eax),%eax
  8003ce:	83 f8 ff             	cmp    $0xffffffff,%eax
  8003d1:	74 17                	je     8003ea <_main+0x3b2>
  8003d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003da:	83 ec 0c             	sub    $0xc,%esp
  8003dd:	68 f4 39 80 00       	push   $0x8039f4
  8003e2:	e8 28 04 00 00       	call   80080f <cprintf>
  8003e7:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)
  8003ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8003ee:	74 04                	je     8003f4 <_main+0x3bc>
		eval += 40 ;
  8003f0:	83 45 f4 28          	addl   $0x28,-0xc(%ebp)
	cprintf("\n%~Test of Shared Variables [Create] [1] completed. Eval = %d%%\n\n", eval);
  8003f4:	83 ec 08             	sub    $0x8,%esp
  8003f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8003fa:	68 20 3a 80 00       	push   $0x803a20
  8003ff:	e8 0b 04 00 00       	call   80080f <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp

	return;
  800407:	90                   	nop
}
  800408:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80040b:	c9                   	leave  
  80040c:	c3                   	ret    

0080040d <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80040d:	55                   	push   %ebp
  80040e:	89 e5                	mov    %esp,%ebp
  800410:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800413:	e8 45 1b 00 00       	call   801f5d <sys_getenvindex>
  800418:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80041b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80041e:	89 d0                	mov    %edx,%eax
  800420:	c1 e0 02             	shl    $0x2,%eax
  800423:	01 d0                	add    %edx,%eax
  800425:	c1 e0 03             	shl    $0x3,%eax
  800428:	01 d0                	add    %edx,%eax
  80042a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800431:	01 d0                	add    %edx,%eax
  800433:	c1 e0 02             	shl    $0x2,%eax
  800436:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80043b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800440:	a1 20 50 80 00       	mov    0x805020,%eax
  800445:	8a 40 20             	mov    0x20(%eax),%al
  800448:	84 c0                	test   %al,%al
  80044a:	74 0d                	je     800459 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  80044c:	a1 20 50 80 00       	mov    0x805020,%eax
  800451:	83 c0 20             	add    $0x20,%eax
  800454:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800459:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80045d:	7e 0a                	jle    800469 <libmain+0x5c>
		binaryname = argv[0];
  80045f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800469:	83 ec 08             	sub    $0x8,%esp
  80046c:	ff 75 0c             	pushl  0xc(%ebp)
  80046f:	ff 75 08             	pushl  0x8(%ebp)
  800472:	e8 c1 fb ff ff       	call   800038 <_main>
  800477:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80047a:	a1 00 50 80 00       	mov    0x805000,%eax
  80047f:	85 c0                	test   %eax,%eax
  800481:	0f 84 9f 00 00 00    	je     800526 <libmain+0x119>
	{
		sys_lock_cons();
  800487:	e8 55 18 00 00       	call   801ce1 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80048c:	83 ec 0c             	sub    $0xc,%esp
  80048f:	68 7c 3a 80 00       	push   $0x803a7c
  800494:	e8 76 03 00 00       	call   80080f <cprintf>
  800499:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80049c:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a1:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8004a7:	a1 20 50 80 00       	mov    0x805020,%eax
  8004ac:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8004b2:	83 ec 04             	sub    $0x4,%esp
  8004b5:	52                   	push   %edx
  8004b6:	50                   	push   %eax
  8004b7:	68 a4 3a 80 00       	push   $0x803aa4
  8004bc:	e8 4e 03 00 00       	call   80080f <cprintf>
  8004c1:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004c4:	a1 20 50 80 00       	mov    0x805020,%eax
  8004c9:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8004cf:	a1 20 50 80 00       	mov    0x805020,%eax
  8004d4:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8004da:	a1 20 50 80 00       	mov    0x805020,%eax
  8004df:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8004e5:	51                   	push   %ecx
  8004e6:	52                   	push   %edx
  8004e7:	50                   	push   %eax
  8004e8:	68 cc 3a 80 00       	push   $0x803acc
  8004ed:	e8 1d 03 00 00       	call   80080f <cprintf>
  8004f2:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004f5:	a1 20 50 80 00       	mov    0x805020,%eax
  8004fa:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	50                   	push   %eax
  800504:	68 24 3b 80 00       	push   $0x803b24
  800509:	e8 01 03 00 00       	call   80080f <cprintf>
  80050e:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800511:	83 ec 0c             	sub    $0xc,%esp
  800514:	68 7c 3a 80 00       	push   $0x803a7c
  800519:	e8 f1 02 00 00       	call   80080f <cprintf>
  80051e:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800521:	e8 d5 17 00 00       	call   801cfb <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800526:	e8 19 00 00 00       	call   800544 <exit>
}
  80052b:	90                   	nop
  80052c:	c9                   	leave  
  80052d:	c3                   	ret    

0080052e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80052e:	55                   	push   %ebp
  80052f:	89 e5                	mov    %esp,%ebp
  800531:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800534:	83 ec 0c             	sub    $0xc,%esp
  800537:	6a 00                	push   $0x0
  800539:	e8 eb 19 00 00       	call   801f29 <sys_destroy_env>
  80053e:	83 c4 10             	add    $0x10,%esp
}
  800541:	90                   	nop
  800542:	c9                   	leave  
  800543:	c3                   	ret    

00800544 <exit>:

void
exit(void)
{
  800544:	55                   	push   %ebp
  800545:	89 e5                	mov    %esp,%ebp
  800547:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80054a:	e8 40 1a 00 00       	call   801f8f <sys_exit_env>
}
  80054f:	90                   	nop
  800550:	c9                   	leave  
  800551:	c3                   	ret    

00800552 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800552:	55                   	push   %ebp
  800553:	89 e5                	mov    %esp,%ebp
  800555:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800558:	8d 45 10             	lea    0x10(%ebp),%eax
  80055b:	83 c0 04             	add    $0x4,%eax
  80055e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800561:	a1 60 50 98 00       	mov    0x985060,%eax
  800566:	85 c0                	test   %eax,%eax
  800568:	74 16                	je     800580 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80056a:	a1 60 50 98 00       	mov    0x985060,%eax
  80056f:	83 ec 08             	sub    $0x8,%esp
  800572:	50                   	push   %eax
  800573:	68 38 3b 80 00       	push   $0x803b38
  800578:	e8 92 02 00 00       	call   80080f <cprintf>
  80057d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800580:	a1 04 50 80 00       	mov    0x805004,%eax
  800585:	ff 75 0c             	pushl  0xc(%ebp)
  800588:	ff 75 08             	pushl  0x8(%ebp)
  80058b:	50                   	push   %eax
  80058c:	68 3d 3b 80 00       	push   $0x803b3d
  800591:	e8 79 02 00 00       	call   80080f <cprintf>
  800596:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800599:	8b 45 10             	mov    0x10(%ebp),%eax
  80059c:	83 ec 08             	sub    $0x8,%esp
  80059f:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a2:	50                   	push   %eax
  8005a3:	e8 fc 01 00 00       	call   8007a4 <vcprintf>
  8005a8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005ab:	83 ec 08             	sub    $0x8,%esp
  8005ae:	6a 00                	push   $0x0
  8005b0:	68 59 3b 80 00       	push   $0x803b59
  8005b5:	e8 ea 01 00 00       	call   8007a4 <vcprintf>
  8005ba:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005bd:	e8 82 ff ff ff       	call   800544 <exit>

	// should not return here
	while (1) ;
  8005c2:	eb fe                	jmp    8005c2 <_panic+0x70>

008005c4 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005c4:	55                   	push   %ebp
  8005c5:	89 e5                	mov    %esp,%ebp
  8005c7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8005cf:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8005d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d8:	39 c2                	cmp    %eax,%edx
  8005da:	74 14                	je     8005f0 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005dc:	83 ec 04             	sub    $0x4,%esp
  8005df:	68 5c 3b 80 00       	push   $0x803b5c
  8005e4:	6a 26                	push   $0x26
  8005e6:	68 a8 3b 80 00       	push   $0x803ba8
  8005eb:	e8 62 ff ff ff       	call   800552 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005fe:	e9 c5 00 00 00       	jmp    8006c8 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800603:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800606:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80060d:	8b 45 08             	mov    0x8(%ebp),%eax
  800610:	01 d0                	add    %edx,%eax
  800612:	8b 00                	mov    (%eax),%eax
  800614:	85 c0                	test   %eax,%eax
  800616:	75 08                	jne    800620 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800618:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80061b:	e9 a5 00 00 00       	jmp    8006c5 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800620:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800627:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80062e:	eb 69                	jmp    800699 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800630:	a1 20 50 80 00       	mov    0x805020,%eax
  800635:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80063b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80063e:	89 d0                	mov    %edx,%eax
  800640:	01 c0                	add    %eax,%eax
  800642:	01 d0                	add    %edx,%eax
  800644:	c1 e0 03             	shl    $0x3,%eax
  800647:	01 c8                	add    %ecx,%eax
  800649:	8a 40 04             	mov    0x4(%eax),%al
  80064c:	84 c0                	test   %al,%al
  80064e:	75 46                	jne    800696 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800650:	a1 20 50 80 00       	mov    0x805020,%eax
  800655:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80065b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80065e:	89 d0                	mov    %edx,%eax
  800660:	01 c0                	add    %eax,%eax
  800662:	01 d0                	add    %edx,%eax
  800664:	c1 e0 03             	shl    $0x3,%eax
  800667:	01 c8                	add    %ecx,%eax
  800669:	8b 00                	mov    (%eax),%eax
  80066b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80066e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800671:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800676:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800678:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80067b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	01 c8                	add    %ecx,%eax
  800687:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800689:	39 c2                	cmp    %eax,%edx
  80068b:	75 09                	jne    800696 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80068d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800694:	eb 15                	jmp    8006ab <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800696:	ff 45 e8             	incl   -0x18(%ebp)
  800699:	a1 20 50 80 00       	mov    0x805020,%eax
  80069e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8006a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006a7:	39 c2                	cmp    %eax,%edx
  8006a9:	77 85                	ja     800630 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8006ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006af:	75 14                	jne    8006c5 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8006b1:	83 ec 04             	sub    $0x4,%esp
  8006b4:	68 b4 3b 80 00       	push   $0x803bb4
  8006b9:	6a 3a                	push   $0x3a
  8006bb:	68 a8 3b 80 00       	push   $0x803ba8
  8006c0:	e8 8d fe ff ff       	call   800552 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006c5:	ff 45 f0             	incl   -0x10(%ebp)
  8006c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006ce:	0f 8c 2f ff ff ff    	jl     800603 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006d4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006db:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006e2:	eb 26                	jmp    80070a <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006e4:	a1 20 50 80 00       	mov    0x805020,%eax
  8006e9:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8006ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006f2:	89 d0                	mov    %edx,%eax
  8006f4:	01 c0                	add    %eax,%eax
  8006f6:	01 d0                	add    %edx,%eax
  8006f8:	c1 e0 03             	shl    $0x3,%eax
  8006fb:	01 c8                	add    %ecx,%eax
  8006fd:	8a 40 04             	mov    0x4(%eax),%al
  800700:	3c 01                	cmp    $0x1,%al
  800702:	75 03                	jne    800707 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800704:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800707:	ff 45 e0             	incl   -0x20(%ebp)
  80070a:	a1 20 50 80 00       	mov    0x805020,%eax
  80070f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800715:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800718:	39 c2                	cmp    %eax,%edx
  80071a:	77 c8                	ja     8006e4 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80071c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80071f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800722:	74 14                	je     800738 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800724:	83 ec 04             	sub    $0x4,%esp
  800727:	68 08 3c 80 00       	push   $0x803c08
  80072c:	6a 44                	push   $0x44
  80072e:	68 a8 3b 80 00       	push   $0x803ba8
  800733:	e8 1a fe ff ff       	call   800552 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800738:	90                   	nop
  800739:	c9                   	leave  
  80073a:	c3                   	ret    

0080073b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80073b:	55                   	push   %ebp
  80073c:	89 e5                	mov    %esp,%ebp
  80073e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800741:	8b 45 0c             	mov    0xc(%ebp),%eax
  800744:	8b 00                	mov    (%eax),%eax
  800746:	8d 48 01             	lea    0x1(%eax),%ecx
  800749:	8b 55 0c             	mov    0xc(%ebp),%edx
  80074c:	89 0a                	mov    %ecx,(%edx)
  80074e:	8b 55 08             	mov    0x8(%ebp),%edx
  800751:	88 d1                	mov    %dl,%cl
  800753:	8b 55 0c             	mov    0xc(%ebp),%edx
  800756:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80075a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80075d:	8b 00                	mov    (%eax),%eax
  80075f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800764:	75 2c                	jne    800792 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800766:	a0 44 50 98 00       	mov    0x985044,%al
  80076b:	0f b6 c0             	movzbl %al,%eax
  80076e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800771:	8b 12                	mov    (%edx),%edx
  800773:	89 d1                	mov    %edx,%ecx
  800775:	8b 55 0c             	mov    0xc(%ebp),%edx
  800778:	83 c2 08             	add    $0x8,%edx
  80077b:	83 ec 04             	sub    $0x4,%esp
  80077e:	50                   	push   %eax
  80077f:	51                   	push   %ecx
  800780:	52                   	push   %edx
  800781:	e8 19 15 00 00       	call   801c9f <sys_cputs>
  800786:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800789:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800792:	8b 45 0c             	mov    0xc(%ebp),%eax
  800795:	8b 40 04             	mov    0x4(%eax),%eax
  800798:	8d 50 01             	lea    0x1(%eax),%edx
  80079b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079e:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007a1:	90                   	nop
  8007a2:	c9                   	leave  
  8007a3:	c3                   	ret    

008007a4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007a4:	55                   	push   %ebp
  8007a5:	89 e5                	mov    %esp,%ebp
  8007a7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007ad:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007b4:	00 00 00 
	b.cnt = 0;
  8007b7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007be:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007c1:	ff 75 0c             	pushl  0xc(%ebp)
  8007c4:	ff 75 08             	pushl  0x8(%ebp)
  8007c7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007cd:	50                   	push   %eax
  8007ce:	68 3b 07 80 00       	push   $0x80073b
  8007d3:	e8 11 02 00 00       	call   8009e9 <vprintfmt>
  8007d8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007db:	a0 44 50 98 00       	mov    0x985044,%al
  8007e0:	0f b6 c0             	movzbl %al,%eax
  8007e3:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007e9:	83 ec 04             	sub    $0x4,%esp
  8007ec:	50                   	push   %eax
  8007ed:	52                   	push   %edx
  8007ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007f4:	83 c0 08             	add    $0x8,%eax
  8007f7:	50                   	push   %eax
  8007f8:	e8 a2 14 00 00       	call   801c9f <sys_cputs>
  8007fd:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800800:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  800807:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80080d:	c9                   	leave  
  80080e:	c3                   	ret    

0080080f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80080f:	55                   	push   %ebp
  800810:	89 e5                	mov    %esp,%ebp
  800812:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800815:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  80081c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80081f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800822:	8b 45 08             	mov    0x8(%ebp),%eax
  800825:	83 ec 08             	sub    $0x8,%esp
  800828:	ff 75 f4             	pushl  -0xc(%ebp)
  80082b:	50                   	push   %eax
  80082c:	e8 73 ff ff ff       	call   8007a4 <vcprintf>
  800831:	83 c4 10             	add    $0x10,%esp
  800834:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800837:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80083a:	c9                   	leave  
  80083b:	c3                   	ret    

0080083c <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80083c:	55                   	push   %ebp
  80083d:	89 e5                	mov    %esp,%ebp
  80083f:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800842:	e8 9a 14 00 00       	call   801ce1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800847:	8d 45 0c             	lea    0xc(%ebp),%eax
  80084a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80084d:	8b 45 08             	mov    0x8(%ebp),%eax
  800850:	83 ec 08             	sub    $0x8,%esp
  800853:	ff 75 f4             	pushl  -0xc(%ebp)
  800856:	50                   	push   %eax
  800857:	e8 48 ff ff ff       	call   8007a4 <vcprintf>
  80085c:	83 c4 10             	add    $0x10,%esp
  80085f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800862:	e8 94 14 00 00       	call   801cfb <sys_unlock_cons>
	return cnt;
  800867:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80086a:	c9                   	leave  
  80086b:	c3                   	ret    

0080086c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80086c:	55                   	push   %ebp
  80086d:	89 e5                	mov    %esp,%ebp
  80086f:	53                   	push   %ebx
  800870:	83 ec 14             	sub    $0x14,%esp
  800873:	8b 45 10             	mov    0x10(%ebp),%eax
  800876:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800879:	8b 45 14             	mov    0x14(%ebp),%eax
  80087c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80087f:	8b 45 18             	mov    0x18(%ebp),%eax
  800882:	ba 00 00 00 00       	mov    $0x0,%edx
  800887:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80088a:	77 55                	ja     8008e1 <printnum+0x75>
  80088c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80088f:	72 05                	jb     800896 <printnum+0x2a>
  800891:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800894:	77 4b                	ja     8008e1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800896:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800899:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80089c:	8b 45 18             	mov    0x18(%ebp),%eax
  80089f:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a4:	52                   	push   %edx
  8008a5:	50                   	push   %eax
  8008a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8008ac:	e8 ef 2c 00 00       	call   8035a0 <__udivdi3>
  8008b1:	83 c4 10             	add    $0x10,%esp
  8008b4:	83 ec 04             	sub    $0x4,%esp
  8008b7:	ff 75 20             	pushl  0x20(%ebp)
  8008ba:	53                   	push   %ebx
  8008bb:	ff 75 18             	pushl  0x18(%ebp)
  8008be:	52                   	push   %edx
  8008bf:	50                   	push   %eax
  8008c0:	ff 75 0c             	pushl  0xc(%ebp)
  8008c3:	ff 75 08             	pushl  0x8(%ebp)
  8008c6:	e8 a1 ff ff ff       	call   80086c <printnum>
  8008cb:	83 c4 20             	add    $0x20,%esp
  8008ce:	eb 1a                	jmp    8008ea <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008d0:	83 ec 08             	sub    $0x8,%esp
  8008d3:	ff 75 0c             	pushl  0xc(%ebp)
  8008d6:	ff 75 20             	pushl  0x20(%ebp)
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	ff d0                	call   *%eax
  8008de:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008e1:	ff 4d 1c             	decl   0x1c(%ebp)
  8008e4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008e8:	7f e6                	jg     8008d0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008ea:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008f8:	53                   	push   %ebx
  8008f9:	51                   	push   %ecx
  8008fa:	52                   	push   %edx
  8008fb:	50                   	push   %eax
  8008fc:	e8 af 2d 00 00       	call   8036b0 <__umoddi3>
  800901:	83 c4 10             	add    $0x10,%esp
  800904:	05 74 3e 80 00       	add    $0x803e74,%eax
  800909:	8a 00                	mov    (%eax),%al
  80090b:	0f be c0             	movsbl %al,%eax
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	ff 75 0c             	pushl  0xc(%ebp)
  800914:	50                   	push   %eax
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	ff d0                	call   *%eax
  80091a:	83 c4 10             	add    $0x10,%esp
}
  80091d:	90                   	nop
  80091e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800921:	c9                   	leave  
  800922:	c3                   	ret    

00800923 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800926:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80092a:	7e 1c                	jle    800948 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	8b 00                	mov    (%eax),%eax
  800931:	8d 50 08             	lea    0x8(%eax),%edx
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	89 10                	mov    %edx,(%eax)
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	8b 00                	mov    (%eax),%eax
  80093e:	83 e8 08             	sub    $0x8,%eax
  800941:	8b 50 04             	mov    0x4(%eax),%edx
  800944:	8b 00                	mov    (%eax),%eax
  800946:	eb 40                	jmp    800988 <getuint+0x65>
	else if (lflag)
  800948:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80094c:	74 1e                	je     80096c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	8b 00                	mov    (%eax),%eax
  800953:	8d 50 04             	lea    0x4(%eax),%edx
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	89 10                	mov    %edx,(%eax)
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	8b 00                	mov    (%eax),%eax
  800960:	83 e8 04             	sub    $0x4,%eax
  800963:	8b 00                	mov    (%eax),%eax
  800965:	ba 00 00 00 00       	mov    $0x0,%edx
  80096a:	eb 1c                	jmp    800988 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	8b 00                	mov    (%eax),%eax
  800971:	8d 50 04             	lea    0x4(%eax),%edx
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	89 10                	mov    %edx,(%eax)
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	8b 00                	mov    (%eax),%eax
  80097e:	83 e8 04             	sub    $0x4,%eax
  800981:	8b 00                	mov    (%eax),%eax
  800983:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80098d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800991:	7e 1c                	jle    8009af <getint+0x25>
		return va_arg(*ap, long long);
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	8b 00                	mov    (%eax),%eax
  800998:	8d 50 08             	lea    0x8(%eax),%edx
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	89 10                	mov    %edx,(%eax)
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	8b 00                	mov    (%eax),%eax
  8009a5:	83 e8 08             	sub    $0x8,%eax
  8009a8:	8b 50 04             	mov    0x4(%eax),%edx
  8009ab:	8b 00                	mov    (%eax),%eax
  8009ad:	eb 38                	jmp    8009e7 <getint+0x5d>
	else if (lflag)
  8009af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009b3:	74 1a                	je     8009cf <getint+0x45>
		return va_arg(*ap, long);
  8009b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b8:	8b 00                	mov    (%eax),%eax
  8009ba:	8d 50 04             	lea    0x4(%eax),%edx
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	89 10                	mov    %edx,(%eax)
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	8b 00                	mov    (%eax),%eax
  8009c7:	83 e8 04             	sub    $0x4,%eax
  8009ca:	8b 00                	mov    (%eax),%eax
  8009cc:	99                   	cltd   
  8009cd:	eb 18                	jmp    8009e7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d2:	8b 00                	mov    (%eax),%eax
  8009d4:	8d 50 04             	lea    0x4(%eax),%edx
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	89 10                	mov    %edx,(%eax)
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	8b 00                	mov    (%eax),%eax
  8009e1:	83 e8 04             	sub    $0x4,%eax
  8009e4:	8b 00                	mov    (%eax),%eax
  8009e6:	99                   	cltd   
}
  8009e7:	5d                   	pop    %ebp
  8009e8:	c3                   	ret    

008009e9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009e9:	55                   	push   %ebp
  8009ea:	89 e5                	mov    %esp,%ebp
  8009ec:	56                   	push   %esi
  8009ed:	53                   	push   %ebx
  8009ee:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009f1:	eb 17                	jmp    800a0a <vprintfmt+0x21>
			if (ch == '\0')
  8009f3:	85 db                	test   %ebx,%ebx
  8009f5:	0f 84 c1 03 00 00    	je     800dbc <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 0c             	pushl  0xc(%ebp)
  800a01:	53                   	push   %ebx
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	ff d0                	call   *%eax
  800a07:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0d:	8d 50 01             	lea    0x1(%eax),%edx
  800a10:	89 55 10             	mov    %edx,0x10(%ebp)
  800a13:	8a 00                	mov    (%eax),%al
  800a15:	0f b6 d8             	movzbl %al,%ebx
  800a18:	83 fb 25             	cmp    $0x25,%ebx
  800a1b:	75 d6                	jne    8009f3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a1d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a21:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a28:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a2f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a36:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a40:	8d 50 01             	lea    0x1(%eax),%edx
  800a43:	89 55 10             	mov    %edx,0x10(%ebp)
  800a46:	8a 00                	mov    (%eax),%al
  800a48:	0f b6 d8             	movzbl %al,%ebx
  800a4b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a4e:	83 f8 5b             	cmp    $0x5b,%eax
  800a51:	0f 87 3d 03 00 00    	ja     800d94 <vprintfmt+0x3ab>
  800a57:	8b 04 85 98 3e 80 00 	mov    0x803e98(,%eax,4),%eax
  800a5e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a60:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a64:	eb d7                	jmp    800a3d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a66:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a6a:	eb d1                	jmp    800a3d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a6c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a73:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a76:	89 d0                	mov    %edx,%eax
  800a78:	c1 e0 02             	shl    $0x2,%eax
  800a7b:	01 d0                	add    %edx,%eax
  800a7d:	01 c0                	add    %eax,%eax
  800a7f:	01 d8                	add    %ebx,%eax
  800a81:	83 e8 30             	sub    $0x30,%eax
  800a84:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a87:	8b 45 10             	mov    0x10(%ebp),%eax
  800a8a:	8a 00                	mov    (%eax),%al
  800a8c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a8f:	83 fb 2f             	cmp    $0x2f,%ebx
  800a92:	7e 3e                	jle    800ad2 <vprintfmt+0xe9>
  800a94:	83 fb 39             	cmp    $0x39,%ebx
  800a97:	7f 39                	jg     800ad2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a99:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a9c:	eb d5                	jmp    800a73 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa1:	83 c0 04             	add    $0x4,%eax
  800aa4:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaa:	83 e8 04             	sub    $0x4,%eax
  800aad:	8b 00                	mov    (%eax),%eax
  800aaf:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ab2:	eb 1f                	jmp    800ad3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ab4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ab8:	79 83                	jns    800a3d <vprintfmt+0x54>
				width = 0;
  800aba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ac1:	e9 77 ff ff ff       	jmp    800a3d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ac6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800acd:	e9 6b ff ff ff       	jmp    800a3d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ad2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ad3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad7:	0f 89 60 ff ff ff    	jns    800a3d <vprintfmt+0x54>
				width = precision, precision = -1;
  800add:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ae0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ae3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800aea:	e9 4e ff ff ff       	jmp    800a3d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800aef:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800af2:	e9 46 ff ff ff       	jmp    800a3d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800af7:	8b 45 14             	mov    0x14(%ebp),%eax
  800afa:	83 c0 04             	add    $0x4,%eax
  800afd:	89 45 14             	mov    %eax,0x14(%ebp)
  800b00:	8b 45 14             	mov    0x14(%ebp),%eax
  800b03:	83 e8 04             	sub    $0x4,%eax
  800b06:	8b 00                	mov    (%eax),%eax
  800b08:	83 ec 08             	sub    $0x8,%esp
  800b0b:	ff 75 0c             	pushl  0xc(%ebp)
  800b0e:	50                   	push   %eax
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	ff d0                	call   *%eax
  800b14:	83 c4 10             	add    $0x10,%esp
			break;
  800b17:	e9 9b 02 00 00       	jmp    800db7 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1f:	83 c0 04             	add    $0x4,%eax
  800b22:	89 45 14             	mov    %eax,0x14(%ebp)
  800b25:	8b 45 14             	mov    0x14(%ebp),%eax
  800b28:	83 e8 04             	sub    $0x4,%eax
  800b2b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b2d:	85 db                	test   %ebx,%ebx
  800b2f:	79 02                	jns    800b33 <vprintfmt+0x14a>
				err = -err;
  800b31:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b33:	83 fb 64             	cmp    $0x64,%ebx
  800b36:	7f 0b                	jg     800b43 <vprintfmt+0x15a>
  800b38:	8b 34 9d e0 3c 80 00 	mov    0x803ce0(,%ebx,4),%esi
  800b3f:	85 f6                	test   %esi,%esi
  800b41:	75 19                	jne    800b5c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b43:	53                   	push   %ebx
  800b44:	68 85 3e 80 00       	push   $0x803e85
  800b49:	ff 75 0c             	pushl  0xc(%ebp)
  800b4c:	ff 75 08             	pushl  0x8(%ebp)
  800b4f:	e8 70 02 00 00       	call   800dc4 <printfmt>
  800b54:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b57:	e9 5b 02 00 00       	jmp    800db7 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b5c:	56                   	push   %esi
  800b5d:	68 8e 3e 80 00       	push   $0x803e8e
  800b62:	ff 75 0c             	pushl  0xc(%ebp)
  800b65:	ff 75 08             	pushl  0x8(%ebp)
  800b68:	e8 57 02 00 00       	call   800dc4 <printfmt>
  800b6d:	83 c4 10             	add    $0x10,%esp
			break;
  800b70:	e9 42 02 00 00       	jmp    800db7 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b75:	8b 45 14             	mov    0x14(%ebp),%eax
  800b78:	83 c0 04             	add    $0x4,%eax
  800b7b:	89 45 14             	mov    %eax,0x14(%ebp)
  800b7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b81:	83 e8 04             	sub    $0x4,%eax
  800b84:	8b 30                	mov    (%eax),%esi
  800b86:	85 f6                	test   %esi,%esi
  800b88:	75 05                	jne    800b8f <vprintfmt+0x1a6>
				p = "(null)";
  800b8a:	be 91 3e 80 00       	mov    $0x803e91,%esi
			if (width > 0 && padc != '-')
  800b8f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b93:	7e 6d                	jle    800c02 <vprintfmt+0x219>
  800b95:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b99:	74 67                	je     800c02 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b9e:	83 ec 08             	sub    $0x8,%esp
  800ba1:	50                   	push   %eax
  800ba2:	56                   	push   %esi
  800ba3:	e8 1e 03 00 00       	call   800ec6 <strnlen>
  800ba8:	83 c4 10             	add    $0x10,%esp
  800bab:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800bae:	eb 16                	jmp    800bc6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800bb0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800bb4:	83 ec 08             	sub    $0x8,%esp
  800bb7:	ff 75 0c             	pushl  0xc(%ebp)
  800bba:	50                   	push   %eax
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	ff d0                	call   *%eax
  800bc0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bc3:	ff 4d e4             	decl   -0x1c(%ebp)
  800bc6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bca:	7f e4                	jg     800bb0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bcc:	eb 34                	jmp    800c02 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bce:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bd2:	74 1c                	je     800bf0 <vprintfmt+0x207>
  800bd4:	83 fb 1f             	cmp    $0x1f,%ebx
  800bd7:	7e 05                	jle    800bde <vprintfmt+0x1f5>
  800bd9:	83 fb 7e             	cmp    $0x7e,%ebx
  800bdc:	7e 12                	jle    800bf0 <vprintfmt+0x207>
					putch('?', putdat);
  800bde:	83 ec 08             	sub    $0x8,%esp
  800be1:	ff 75 0c             	pushl  0xc(%ebp)
  800be4:	6a 3f                	push   $0x3f
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	ff d0                	call   *%eax
  800beb:	83 c4 10             	add    $0x10,%esp
  800bee:	eb 0f                	jmp    800bff <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bf0:	83 ec 08             	sub    $0x8,%esp
  800bf3:	ff 75 0c             	pushl  0xc(%ebp)
  800bf6:	53                   	push   %ebx
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	ff d0                	call   *%eax
  800bfc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bff:	ff 4d e4             	decl   -0x1c(%ebp)
  800c02:	89 f0                	mov    %esi,%eax
  800c04:	8d 70 01             	lea    0x1(%eax),%esi
  800c07:	8a 00                	mov    (%eax),%al
  800c09:	0f be d8             	movsbl %al,%ebx
  800c0c:	85 db                	test   %ebx,%ebx
  800c0e:	74 24                	je     800c34 <vprintfmt+0x24b>
  800c10:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c14:	78 b8                	js     800bce <vprintfmt+0x1e5>
  800c16:	ff 4d e0             	decl   -0x20(%ebp)
  800c19:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c1d:	79 af                	jns    800bce <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c1f:	eb 13                	jmp    800c34 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c21:	83 ec 08             	sub    $0x8,%esp
  800c24:	ff 75 0c             	pushl  0xc(%ebp)
  800c27:	6a 20                	push   $0x20
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	ff d0                	call   *%eax
  800c2e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c31:	ff 4d e4             	decl   -0x1c(%ebp)
  800c34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c38:	7f e7                	jg     800c21 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c3a:	e9 78 01 00 00       	jmp    800db7 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	ff 75 e8             	pushl  -0x18(%ebp)
  800c45:	8d 45 14             	lea    0x14(%ebp),%eax
  800c48:	50                   	push   %eax
  800c49:	e8 3c fd ff ff       	call   80098a <getint>
  800c4e:	83 c4 10             	add    $0x10,%esp
  800c51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c54:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c5d:	85 d2                	test   %edx,%edx
  800c5f:	79 23                	jns    800c84 <vprintfmt+0x29b>
				putch('-', putdat);
  800c61:	83 ec 08             	sub    $0x8,%esp
  800c64:	ff 75 0c             	pushl  0xc(%ebp)
  800c67:	6a 2d                	push   $0x2d
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	ff d0                	call   *%eax
  800c6e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c77:	f7 d8                	neg    %eax
  800c79:	83 d2 00             	adc    $0x0,%edx
  800c7c:	f7 da                	neg    %edx
  800c7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c81:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c84:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c8b:	e9 bc 00 00 00       	jmp    800d4c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c90:	83 ec 08             	sub    $0x8,%esp
  800c93:	ff 75 e8             	pushl  -0x18(%ebp)
  800c96:	8d 45 14             	lea    0x14(%ebp),%eax
  800c99:	50                   	push   %eax
  800c9a:	e8 84 fc ff ff       	call   800923 <getuint>
  800c9f:	83 c4 10             	add    $0x10,%esp
  800ca2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ca8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800caf:	e9 98 00 00 00       	jmp    800d4c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800cb4:	83 ec 08             	sub    $0x8,%esp
  800cb7:	ff 75 0c             	pushl  0xc(%ebp)
  800cba:	6a 58                	push   $0x58
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	ff d0                	call   *%eax
  800cc1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cc4:	83 ec 08             	sub    $0x8,%esp
  800cc7:	ff 75 0c             	pushl  0xc(%ebp)
  800cca:	6a 58                	push   $0x58
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	ff d0                	call   *%eax
  800cd1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cd4:	83 ec 08             	sub    $0x8,%esp
  800cd7:	ff 75 0c             	pushl  0xc(%ebp)
  800cda:	6a 58                	push   $0x58
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdf:	ff d0                	call   *%eax
  800ce1:	83 c4 10             	add    $0x10,%esp
			break;
  800ce4:	e9 ce 00 00 00       	jmp    800db7 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ce9:	83 ec 08             	sub    $0x8,%esp
  800cec:	ff 75 0c             	pushl  0xc(%ebp)
  800cef:	6a 30                	push   $0x30
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	ff d0                	call   *%eax
  800cf6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cf9:	83 ec 08             	sub    $0x8,%esp
  800cfc:	ff 75 0c             	pushl  0xc(%ebp)
  800cff:	6a 78                	push   $0x78
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	ff d0                	call   *%eax
  800d06:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d09:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0c:	83 c0 04             	add    $0x4,%eax
  800d0f:	89 45 14             	mov    %eax,0x14(%ebp)
  800d12:	8b 45 14             	mov    0x14(%ebp),%eax
  800d15:	83 e8 04             	sub    $0x4,%eax
  800d18:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d24:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d2b:	eb 1f                	jmp    800d4c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d2d:	83 ec 08             	sub    $0x8,%esp
  800d30:	ff 75 e8             	pushl  -0x18(%ebp)
  800d33:	8d 45 14             	lea    0x14(%ebp),%eax
  800d36:	50                   	push   %eax
  800d37:	e8 e7 fb ff ff       	call   800923 <getuint>
  800d3c:	83 c4 10             	add    $0x10,%esp
  800d3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d42:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d45:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d4c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d53:	83 ec 04             	sub    $0x4,%esp
  800d56:	52                   	push   %edx
  800d57:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d5a:	50                   	push   %eax
  800d5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d5e:	ff 75 f0             	pushl  -0x10(%ebp)
  800d61:	ff 75 0c             	pushl  0xc(%ebp)
  800d64:	ff 75 08             	pushl  0x8(%ebp)
  800d67:	e8 00 fb ff ff       	call   80086c <printnum>
  800d6c:	83 c4 20             	add    $0x20,%esp
			break;
  800d6f:	eb 46                	jmp    800db7 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d71:	83 ec 08             	sub    $0x8,%esp
  800d74:	ff 75 0c             	pushl  0xc(%ebp)
  800d77:	53                   	push   %ebx
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	ff d0                	call   *%eax
  800d7d:	83 c4 10             	add    $0x10,%esp
			break;
  800d80:	eb 35                	jmp    800db7 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d82:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  800d89:	eb 2c                	jmp    800db7 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d8b:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  800d92:	eb 23                	jmp    800db7 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d94:	83 ec 08             	sub    $0x8,%esp
  800d97:	ff 75 0c             	pushl  0xc(%ebp)
  800d9a:	6a 25                	push   $0x25
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	ff d0                	call   *%eax
  800da1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800da4:	ff 4d 10             	decl   0x10(%ebp)
  800da7:	eb 03                	jmp    800dac <vprintfmt+0x3c3>
  800da9:	ff 4d 10             	decl   0x10(%ebp)
  800dac:	8b 45 10             	mov    0x10(%ebp),%eax
  800daf:	48                   	dec    %eax
  800db0:	8a 00                	mov    (%eax),%al
  800db2:	3c 25                	cmp    $0x25,%al
  800db4:	75 f3                	jne    800da9 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800db6:	90                   	nop
		}
	}
  800db7:	e9 35 fc ff ff       	jmp    8009f1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800dbc:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800dbd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dc0:	5b                   	pop    %ebx
  800dc1:	5e                   	pop    %esi
  800dc2:	5d                   	pop    %ebp
  800dc3:	c3                   	ret    

00800dc4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800dca:	8d 45 10             	lea    0x10(%ebp),%eax
  800dcd:	83 c0 04             	add    $0x4,%eax
  800dd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800dd3:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd6:	ff 75 f4             	pushl  -0xc(%ebp)
  800dd9:	50                   	push   %eax
  800dda:	ff 75 0c             	pushl  0xc(%ebp)
  800ddd:	ff 75 08             	pushl  0x8(%ebp)
  800de0:	e8 04 fc ff ff       	call   8009e9 <vprintfmt>
  800de5:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800de8:	90                   	nop
  800de9:	c9                   	leave  
  800dea:	c3                   	ret    

00800deb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800dee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df1:	8b 40 08             	mov    0x8(%eax),%eax
  800df4:	8d 50 01             	lea    0x1(%eax),%edx
  800df7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfa:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e00:	8b 10                	mov    (%eax),%edx
  800e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e05:	8b 40 04             	mov    0x4(%eax),%eax
  800e08:	39 c2                	cmp    %eax,%edx
  800e0a:	73 12                	jae    800e1e <sprintputch+0x33>
		*b->buf++ = ch;
  800e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0f:	8b 00                	mov    (%eax),%eax
  800e11:	8d 48 01             	lea    0x1(%eax),%ecx
  800e14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e17:	89 0a                	mov    %ecx,(%edx)
  800e19:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1c:	88 10                	mov    %dl,(%eax)
}
  800e1e:	90                   	nop
  800e1f:	5d                   	pop    %ebp
  800e20:	c3                   	ret    

00800e21 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e30:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	01 d0                	add    %edx,%eax
  800e38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e42:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e46:	74 06                	je     800e4e <vsnprintf+0x2d>
  800e48:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e4c:	7f 07                	jg     800e55 <vsnprintf+0x34>
		return -E_INVAL;
  800e4e:	b8 03 00 00 00       	mov    $0x3,%eax
  800e53:	eb 20                	jmp    800e75 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e55:	ff 75 14             	pushl  0x14(%ebp)
  800e58:	ff 75 10             	pushl  0x10(%ebp)
  800e5b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e5e:	50                   	push   %eax
  800e5f:	68 eb 0d 80 00       	push   $0x800deb
  800e64:	e8 80 fb ff ff       	call   8009e9 <vprintfmt>
  800e69:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e6f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e7d:	8d 45 10             	lea    0x10(%ebp),%eax
  800e80:	83 c0 04             	add    $0x4,%eax
  800e83:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e86:	8b 45 10             	mov    0x10(%ebp),%eax
  800e89:	ff 75 f4             	pushl  -0xc(%ebp)
  800e8c:	50                   	push   %eax
  800e8d:	ff 75 0c             	pushl  0xc(%ebp)
  800e90:	ff 75 08             	pushl  0x8(%ebp)
  800e93:	e8 89 ff ff ff       	call   800e21 <vsnprintf>
  800e98:	83 c4 10             	add    $0x10,%esp
  800e9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ea1:	c9                   	leave  
  800ea2:	c3                   	ret    

00800ea3 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ea9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb0:	eb 06                	jmp    800eb8 <strlen+0x15>
		n++;
  800eb2:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800eb5:	ff 45 08             	incl   0x8(%ebp)
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	84 c0                	test   %al,%al
  800ebf:	75 f1                	jne    800eb2 <strlen+0xf>
		n++;
	return n;
  800ec1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ec4:	c9                   	leave  
  800ec5:	c3                   	ret    

00800ec6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
  800ec9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ecc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ed3:	eb 09                	jmp    800ede <strnlen+0x18>
		n++;
  800ed5:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ed8:	ff 45 08             	incl   0x8(%ebp)
  800edb:	ff 4d 0c             	decl   0xc(%ebp)
  800ede:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ee2:	74 09                	je     800eed <strnlen+0x27>
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	84 c0                	test   %al,%al
  800eeb:	75 e8                	jne    800ed5 <strnlen+0xf>
		n++;
	return n;
  800eed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ef0:	c9                   	leave  
  800ef1:	c3                   	ret    

00800ef2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800efe:	90                   	nop
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	8d 50 01             	lea    0x1(%eax),%edx
  800f05:	89 55 08             	mov    %edx,0x8(%ebp)
  800f08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f0b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f0e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f11:	8a 12                	mov    (%edx),%dl
  800f13:	88 10                	mov    %dl,(%eax)
  800f15:	8a 00                	mov    (%eax),%al
  800f17:	84 c0                	test   %al,%al
  800f19:	75 e4                	jne    800eff <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    

00800f20 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f33:	eb 1f                	jmp    800f54 <strncpy+0x34>
		*dst++ = *src;
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8d 50 01             	lea    0x1(%eax),%edx
  800f3b:	89 55 08             	mov    %edx,0x8(%ebp)
  800f3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f41:	8a 12                	mov    (%edx),%dl
  800f43:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f48:	8a 00                	mov    (%eax),%al
  800f4a:	84 c0                	test   %al,%al
  800f4c:	74 03                	je     800f51 <strncpy+0x31>
			src++;
  800f4e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f51:	ff 45 fc             	incl   -0x4(%ebp)
  800f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f57:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f5a:	72 d9                	jb     800f35 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f5f:	c9                   	leave  
  800f60:	c3                   	ret    

00800f61 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f6d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f71:	74 30                	je     800fa3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f73:	eb 16                	jmp    800f8b <strlcpy+0x2a>
			*dst++ = *src++;
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	8d 50 01             	lea    0x1(%eax),%edx
  800f7b:	89 55 08             	mov    %edx,0x8(%ebp)
  800f7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f81:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f84:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f87:	8a 12                	mov    (%edx),%dl
  800f89:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f8b:	ff 4d 10             	decl   0x10(%ebp)
  800f8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f92:	74 09                	je     800f9d <strlcpy+0x3c>
  800f94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	84 c0                	test   %al,%al
  800f9b:	75 d8                	jne    800f75 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fa3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa9:	29 c2                	sub    %eax,%edx
  800fab:	89 d0                	mov    %edx,%eax
}
  800fad:	c9                   	leave  
  800fae:	c3                   	ret    

00800faf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800fb2:	eb 06                	jmp    800fba <strcmp+0xb>
		p++, q++;
  800fb4:	ff 45 08             	incl   0x8(%ebp)
  800fb7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	84 c0                	test   %al,%al
  800fc1:	74 0e                	je     800fd1 <strcmp+0x22>
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	8a 10                	mov    (%eax),%dl
  800fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	38 c2                	cmp    %al,%dl
  800fcf:	74 e3                	je     800fb4 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	0f b6 d0             	movzbl %al,%edx
  800fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdc:	8a 00                	mov    (%eax),%al
  800fde:	0f b6 c0             	movzbl %al,%eax
  800fe1:	29 c2                	sub    %eax,%edx
  800fe3:	89 d0                	mov    %edx,%eax
}
  800fe5:	5d                   	pop    %ebp
  800fe6:	c3                   	ret    

00800fe7 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fe7:	55                   	push   %ebp
  800fe8:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fea:	eb 09                	jmp    800ff5 <strncmp+0xe>
		n--, p++, q++;
  800fec:	ff 4d 10             	decl   0x10(%ebp)
  800fef:	ff 45 08             	incl   0x8(%ebp)
  800ff2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ff5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff9:	74 17                	je     801012 <strncmp+0x2b>
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	8a 00                	mov    (%eax),%al
  801000:	84 c0                	test   %al,%al
  801002:	74 0e                	je     801012 <strncmp+0x2b>
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 10                	mov    (%eax),%dl
  801009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100c:	8a 00                	mov    (%eax),%al
  80100e:	38 c2                	cmp    %al,%dl
  801010:	74 da                	je     800fec <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801012:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801016:	75 07                	jne    80101f <strncmp+0x38>
		return 0;
  801018:	b8 00 00 00 00       	mov    $0x0,%eax
  80101d:	eb 14                	jmp    801033 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	8a 00                	mov    (%eax),%al
  801024:	0f b6 d0             	movzbl %al,%edx
  801027:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102a:	8a 00                	mov    (%eax),%al
  80102c:	0f b6 c0             	movzbl %al,%eax
  80102f:	29 c2                	sub    %eax,%edx
  801031:	89 d0                	mov    %edx,%eax
}
  801033:	5d                   	pop    %ebp
  801034:	c3                   	ret    

00801035 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801035:	55                   	push   %ebp
  801036:	89 e5                	mov    %esp,%ebp
  801038:	83 ec 04             	sub    $0x4,%esp
  80103b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801041:	eb 12                	jmp    801055 <strchr+0x20>
		if (*s == c)
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	8a 00                	mov    (%eax),%al
  801048:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80104b:	75 05                	jne    801052 <strchr+0x1d>
			return (char *) s;
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
  801050:	eb 11                	jmp    801063 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801052:	ff 45 08             	incl   0x8(%ebp)
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	8a 00                	mov    (%eax),%al
  80105a:	84 c0                	test   %al,%al
  80105c:	75 e5                	jne    801043 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80105e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801063:	c9                   	leave  
  801064:	c3                   	ret    

00801065 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801065:	55                   	push   %ebp
  801066:	89 e5                	mov    %esp,%ebp
  801068:	83 ec 04             	sub    $0x4,%esp
  80106b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801071:	eb 0d                	jmp    801080 <strfind+0x1b>
		if (*s == c)
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	8a 00                	mov    (%eax),%al
  801078:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80107b:	74 0e                	je     80108b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80107d:	ff 45 08             	incl   0x8(%ebp)
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	8a 00                	mov    (%eax),%al
  801085:	84 c0                	test   %al,%al
  801087:	75 ea                	jne    801073 <strfind+0xe>
  801089:	eb 01                	jmp    80108c <strfind+0x27>
		if (*s == c)
			break;
  80108b:	90                   	nop
	return (char *) s;
  80108c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80108f:	c9                   	leave  
  801090:	c3                   	ret    

00801091 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801091:	55                   	push   %ebp
  801092:	89 e5                	mov    %esp,%ebp
  801094:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80109d:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010a3:	eb 0e                	jmp    8010b3 <memset+0x22>
		*p++ = c;
  8010a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a8:	8d 50 01             	lea    0x1(%eax),%edx
  8010ab:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b1:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010b3:	ff 4d f8             	decl   -0x8(%ebp)
  8010b6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010ba:	79 e9                	jns    8010a5 <memset+0x14>
		*p++ = c;

	return v;
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010bf:	c9                   	leave  
  8010c0:	c3                   	ret    

008010c1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
  8010c4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010d3:	eb 16                	jmp    8010eb <memcpy+0x2a>
		*d++ = *s++;
  8010d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d8:	8d 50 01             	lea    0x1(%eax),%edx
  8010db:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010e1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010e4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010e7:	8a 12                	mov    (%edx),%dl
  8010e9:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ee:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f1:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f4:	85 c0                	test   %eax,%eax
  8010f6:	75 dd                	jne    8010d5 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010fb:	c9                   	leave  
  8010fc:	c3                   	ret    

008010fd <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
  801100:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801103:	8b 45 0c             	mov    0xc(%ebp),%eax
  801106:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80110f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801112:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801115:	73 50                	jae    801167 <memmove+0x6a>
  801117:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80111a:	8b 45 10             	mov    0x10(%ebp),%eax
  80111d:	01 d0                	add    %edx,%eax
  80111f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801122:	76 43                	jbe    801167 <memmove+0x6a>
		s += n;
  801124:	8b 45 10             	mov    0x10(%ebp),%eax
  801127:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80112a:	8b 45 10             	mov    0x10(%ebp),%eax
  80112d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801130:	eb 10                	jmp    801142 <memmove+0x45>
			*--d = *--s;
  801132:	ff 4d f8             	decl   -0x8(%ebp)
  801135:	ff 4d fc             	decl   -0x4(%ebp)
  801138:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80113b:	8a 10                	mov    (%eax),%dl
  80113d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801140:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801142:	8b 45 10             	mov    0x10(%ebp),%eax
  801145:	8d 50 ff             	lea    -0x1(%eax),%edx
  801148:	89 55 10             	mov    %edx,0x10(%ebp)
  80114b:	85 c0                	test   %eax,%eax
  80114d:	75 e3                	jne    801132 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80114f:	eb 23                	jmp    801174 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801151:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801154:	8d 50 01             	lea    0x1(%eax),%edx
  801157:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80115a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801160:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801163:	8a 12                	mov    (%edx),%dl
  801165:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801167:	8b 45 10             	mov    0x10(%ebp),%eax
  80116a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80116d:	89 55 10             	mov    %edx,0x10(%ebp)
  801170:	85 c0                	test   %eax,%eax
  801172:	75 dd                	jne    801151 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801177:	c9                   	leave  
  801178:	c3                   	ret    

00801179 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
  80117c:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801185:	8b 45 0c             	mov    0xc(%ebp),%eax
  801188:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80118b:	eb 2a                	jmp    8011b7 <memcmp+0x3e>
		if (*s1 != *s2)
  80118d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801190:	8a 10                	mov    (%eax),%dl
  801192:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801195:	8a 00                	mov    (%eax),%al
  801197:	38 c2                	cmp    %al,%dl
  801199:	74 16                	je     8011b1 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80119b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	0f b6 d0             	movzbl %al,%edx
  8011a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a6:	8a 00                	mov    (%eax),%al
  8011a8:	0f b6 c0             	movzbl %al,%eax
  8011ab:	29 c2                	sub    %eax,%edx
  8011ad:	89 d0                	mov    %edx,%eax
  8011af:	eb 18                	jmp    8011c9 <memcmp+0x50>
		s1++, s2++;
  8011b1:	ff 45 fc             	incl   -0x4(%ebp)
  8011b4:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ba:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011bd:	89 55 10             	mov    %edx,0x10(%ebp)
  8011c0:	85 c0                	test   %eax,%eax
  8011c2:	75 c9                	jne    80118d <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c9:	c9                   	leave  
  8011ca:	c3                   	ret    

008011cb <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
  8011ce:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d7:	01 d0                	add    %edx,%eax
  8011d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011dc:	eb 15                	jmp    8011f3 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011de:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e1:	8a 00                	mov    (%eax),%al
  8011e3:	0f b6 d0             	movzbl %al,%edx
  8011e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e9:	0f b6 c0             	movzbl %al,%eax
  8011ec:	39 c2                	cmp    %eax,%edx
  8011ee:	74 0d                	je     8011fd <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011f0:	ff 45 08             	incl   0x8(%ebp)
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011f9:	72 e3                	jb     8011de <memfind+0x13>
  8011fb:	eb 01                	jmp    8011fe <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011fd:	90                   	nop
	return (void *) s;
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801201:	c9                   	leave  
  801202:	c3                   	ret    

00801203 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
  801206:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801209:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801210:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801217:	eb 03                	jmp    80121c <strtol+0x19>
		s++;
  801219:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	3c 20                	cmp    $0x20,%al
  801223:	74 f4                	je     801219 <strtol+0x16>
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	3c 09                	cmp    $0x9,%al
  80122c:	74 eb                	je     801219 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	3c 2b                	cmp    $0x2b,%al
  801235:	75 05                	jne    80123c <strtol+0x39>
		s++;
  801237:	ff 45 08             	incl   0x8(%ebp)
  80123a:	eb 13                	jmp    80124f <strtol+0x4c>
	else if (*s == '-')
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	8a 00                	mov    (%eax),%al
  801241:	3c 2d                	cmp    $0x2d,%al
  801243:	75 0a                	jne    80124f <strtol+0x4c>
		s++, neg = 1;
  801245:	ff 45 08             	incl   0x8(%ebp)
  801248:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80124f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801253:	74 06                	je     80125b <strtol+0x58>
  801255:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801259:	75 20                	jne    80127b <strtol+0x78>
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
  80125e:	8a 00                	mov    (%eax),%al
  801260:	3c 30                	cmp    $0x30,%al
  801262:	75 17                	jne    80127b <strtol+0x78>
  801264:	8b 45 08             	mov    0x8(%ebp),%eax
  801267:	40                   	inc    %eax
  801268:	8a 00                	mov    (%eax),%al
  80126a:	3c 78                	cmp    $0x78,%al
  80126c:	75 0d                	jne    80127b <strtol+0x78>
		s += 2, base = 16;
  80126e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801272:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801279:	eb 28                	jmp    8012a3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80127b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80127f:	75 15                	jne    801296 <strtol+0x93>
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	3c 30                	cmp    $0x30,%al
  801288:	75 0c                	jne    801296 <strtol+0x93>
		s++, base = 8;
  80128a:	ff 45 08             	incl   0x8(%ebp)
  80128d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801294:	eb 0d                	jmp    8012a3 <strtol+0xa0>
	else if (base == 0)
  801296:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80129a:	75 07                	jne    8012a3 <strtol+0xa0>
		base = 10;
  80129c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	3c 2f                	cmp    $0x2f,%al
  8012aa:	7e 19                	jle    8012c5 <strtol+0xc2>
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	8a 00                	mov    (%eax),%al
  8012b1:	3c 39                	cmp    $0x39,%al
  8012b3:	7f 10                	jg     8012c5 <strtol+0xc2>
			dig = *s - '0';
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8a 00                	mov    (%eax),%al
  8012ba:	0f be c0             	movsbl %al,%eax
  8012bd:	83 e8 30             	sub    $0x30,%eax
  8012c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012c3:	eb 42                	jmp    801307 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	8a 00                	mov    (%eax),%al
  8012ca:	3c 60                	cmp    $0x60,%al
  8012cc:	7e 19                	jle    8012e7 <strtol+0xe4>
  8012ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d1:	8a 00                	mov    (%eax),%al
  8012d3:	3c 7a                	cmp    $0x7a,%al
  8012d5:	7f 10                	jg     8012e7 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012da:	8a 00                	mov    (%eax),%al
  8012dc:	0f be c0             	movsbl %al,%eax
  8012df:	83 e8 57             	sub    $0x57,%eax
  8012e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012e5:	eb 20                	jmp    801307 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	8a 00                	mov    (%eax),%al
  8012ec:	3c 40                	cmp    $0x40,%al
  8012ee:	7e 39                	jle    801329 <strtol+0x126>
  8012f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f3:	8a 00                	mov    (%eax),%al
  8012f5:	3c 5a                	cmp    $0x5a,%al
  8012f7:	7f 30                	jg     801329 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fc:	8a 00                	mov    (%eax),%al
  8012fe:	0f be c0             	movsbl %al,%eax
  801301:	83 e8 37             	sub    $0x37,%eax
  801304:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80130a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80130d:	7d 19                	jge    801328 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80130f:	ff 45 08             	incl   0x8(%ebp)
  801312:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801315:	0f af 45 10          	imul   0x10(%ebp),%eax
  801319:	89 c2                	mov    %eax,%edx
  80131b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80131e:	01 d0                	add    %edx,%eax
  801320:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801323:	e9 7b ff ff ff       	jmp    8012a3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801328:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801329:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80132d:	74 08                	je     801337 <strtol+0x134>
		*endptr = (char *) s;
  80132f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801332:	8b 55 08             	mov    0x8(%ebp),%edx
  801335:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801337:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80133b:	74 07                	je     801344 <strtol+0x141>
  80133d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801340:	f7 d8                	neg    %eax
  801342:	eb 03                	jmp    801347 <strtol+0x144>
  801344:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801347:	c9                   	leave  
  801348:	c3                   	ret    

00801349 <ltostr>:

void
ltostr(long value, char *str)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80134f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801356:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80135d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801361:	79 13                	jns    801376 <ltostr+0x2d>
	{
		neg = 1;
  801363:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80136a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801370:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801373:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801376:	8b 45 08             	mov    0x8(%ebp),%eax
  801379:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80137e:	99                   	cltd   
  80137f:	f7 f9                	idiv   %ecx
  801381:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801384:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801387:	8d 50 01             	lea    0x1(%eax),%edx
  80138a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80138d:	89 c2                	mov    %eax,%edx
  80138f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801392:	01 d0                	add    %edx,%eax
  801394:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801397:	83 c2 30             	add    $0x30,%edx
  80139a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80139c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80139f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013a4:	f7 e9                	imul   %ecx
  8013a6:	c1 fa 02             	sar    $0x2,%edx
  8013a9:	89 c8                	mov    %ecx,%eax
  8013ab:	c1 f8 1f             	sar    $0x1f,%eax
  8013ae:	29 c2                	sub    %eax,%edx
  8013b0:	89 d0                	mov    %edx,%eax
  8013b2:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013b9:	75 bb                	jne    801376 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c5:	48                   	dec    %eax
  8013c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013cd:	74 3d                	je     80140c <ltostr+0xc3>
		start = 1 ;
  8013cf:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013d6:	eb 34                	jmp    80140c <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013de:	01 d0                	add    %edx,%eax
  8013e0:	8a 00                	mov    (%eax),%al
  8013e2:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013eb:	01 c2                	add    %eax,%edx
  8013ed:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f3:	01 c8                	add    %ecx,%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ff:	01 c2                	add    %eax,%edx
  801401:	8a 45 eb             	mov    -0x15(%ebp),%al
  801404:	88 02                	mov    %al,(%edx)
		start++ ;
  801406:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801409:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80140c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80140f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801412:	7c c4                	jl     8013d8 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801414:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801417:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141a:	01 d0                	add    %edx,%eax
  80141c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80141f:	90                   	nop
  801420:	c9                   	leave  
  801421:	c3                   	ret    

00801422 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
  801425:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801428:	ff 75 08             	pushl  0x8(%ebp)
  80142b:	e8 73 fa ff ff       	call   800ea3 <strlen>
  801430:	83 c4 04             	add    $0x4,%esp
  801433:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801436:	ff 75 0c             	pushl  0xc(%ebp)
  801439:	e8 65 fa ff ff       	call   800ea3 <strlen>
  80143e:	83 c4 04             	add    $0x4,%esp
  801441:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801444:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80144b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801452:	eb 17                	jmp    80146b <strcconcat+0x49>
		final[s] = str1[s] ;
  801454:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801457:	8b 45 10             	mov    0x10(%ebp),%eax
  80145a:	01 c2                	add    %eax,%edx
  80145c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80145f:	8b 45 08             	mov    0x8(%ebp),%eax
  801462:	01 c8                	add    %ecx,%eax
  801464:	8a 00                	mov    (%eax),%al
  801466:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801468:	ff 45 fc             	incl   -0x4(%ebp)
  80146b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80146e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801471:	7c e1                	jl     801454 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801473:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80147a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801481:	eb 1f                	jmp    8014a2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801483:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801486:	8d 50 01             	lea    0x1(%eax),%edx
  801489:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80148c:	89 c2                	mov    %eax,%edx
  80148e:	8b 45 10             	mov    0x10(%ebp),%eax
  801491:	01 c2                	add    %eax,%edx
  801493:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801496:	8b 45 0c             	mov    0xc(%ebp),%eax
  801499:	01 c8                	add    %ecx,%eax
  80149b:	8a 00                	mov    (%eax),%al
  80149d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80149f:	ff 45 f8             	incl   -0x8(%ebp)
  8014a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014a8:	7c d9                	jl     801483 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b0:	01 d0                	add    %edx,%eax
  8014b2:	c6 00 00             	movb   $0x0,(%eax)
}
  8014b5:	90                   	nop
  8014b6:	c9                   	leave  
  8014b7:	c3                   	ret    

008014b8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8014be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c7:	8b 00                	mov    (%eax),%eax
  8014c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d3:	01 d0                	add    %edx,%eax
  8014d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014db:	eb 0c                	jmp    8014e9 <strsplit+0x31>
			*string++ = 0;
  8014dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e0:	8d 50 01             	lea    0x1(%eax),%edx
  8014e3:	89 55 08             	mov    %edx,0x8(%ebp)
  8014e6:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ec:	8a 00                	mov    (%eax),%al
  8014ee:	84 c0                	test   %al,%al
  8014f0:	74 18                	je     80150a <strsplit+0x52>
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	8a 00                	mov    (%eax),%al
  8014f7:	0f be c0             	movsbl %al,%eax
  8014fa:	50                   	push   %eax
  8014fb:	ff 75 0c             	pushl  0xc(%ebp)
  8014fe:	e8 32 fb ff ff       	call   801035 <strchr>
  801503:	83 c4 08             	add    $0x8,%esp
  801506:	85 c0                	test   %eax,%eax
  801508:	75 d3                	jne    8014dd <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	8a 00                	mov    (%eax),%al
  80150f:	84 c0                	test   %al,%al
  801511:	74 5a                	je     80156d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801513:	8b 45 14             	mov    0x14(%ebp),%eax
  801516:	8b 00                	mov    (%eax),%eax
  801518:	83 f8 0f             	cmp    $0xf,%eax
  80151b:	75 07                	jne    801524 <strsplit+0x6c>
		{
			return 0;
  80151d:	b8 00 00 00 00       	mov    $0x0,%eax
  801522:	eb 66                	jmp    80158a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801524:	8b 45 14             	mov    0x14(%ebp),%eax
  801527:	8b 00                	mov    (%eax),%eax
  801529:	8d 48 01             	lea    0x1(%eax),%ecx
  80152c:	8b 55 14             	mov    0x14(%ebp),%edx
  80152f:	89 0a                	mov    %ecx,(%edx)
  801531:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801538:	8b 45 10             	mov    0x10(%ebp),%eax
  80153b:	01 c2                	add    %eax,%edx
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801542:	eb 03                	jmp    801547 <strsplit+0x8f>
			string++;
  801544:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801547:	8b 45 08             	mov    0x8(%ebp),%eax
  80154a:	8a 00                	mov    (%eax),%al
  80154c:	84 c0                	test   %al,%al
  80154e:	74 8b                	je     8014db <strsplit+0x23>
  801550:	8b 45 08             	mov    0x8(%ebp),%eax
  801553:	8a 00                	mov    (%eax),%al
  801555:	0f be c0             	movsbl %al,%eax
  801558:	50                   	push   %eax
  801559:	ff 75 0c             	pushl  0xc(%ebp)
  80155c:	e8 d4 fa ff ff       	call   801035 <strchr>
  801561:	83 c4 08             	add    $0x8,%esp
  801564:	85 c0                	test   %eax,%eax
  801566:	74 dc                	je     801544 <strsplit+0x8c>
			string++;
	}
  801568:	e9 6e ff ff ff       	jmp    8014db <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80156d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80156e:	8b 45 14             	mov    0x14(%ebp),%eax
  801571:	8b 00                	mov    (%eax),%eax
  801573:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80157a:	8b 45 10             	mov    0x10(%ebp),%eax
  80157d:	01 d0                	add    %edx,%eax
  80157f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801585:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80158a:	c9                   	leave  
  80158b:	c3                   	ret    

0080158c <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
  80158f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801592:	83 ec 04             	sub    $0x4,%esp
  801595:	68 08 40 80 00       	push   $0x804008
  80159a:	68 3f 01 00 00       	push   $0x13f
  80159f:	68 2a 40 80 00       	push   $0x80402a
  8015a4:	e8 a9 ef ff ff       	call   800552 <_panic>

008015a9 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
  8015ac:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8015af:	83 ec 0c             	sub    $0xc,%esp
  8015b2:	ff 75 08             	pushl  0x8(%ebp)
  8015b5:	e8 90 0c 00 00       	call   80224a <sys_sbrk>
  8015ba:	83 c4 10             	add    $0x10,%esp
}
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    

008015bf <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
  8015c2:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8015c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015c9:	75 0a                	jne    8015d5 <malloc+0x16>
		return NULL;
  8015cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d0:	e9 9e 01 00 00       	jmp    801773 <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  8015d5:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8015dc:	77 2c                	ja     80160a <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  8015de:	e8 eb 0a 00 00       	call   8020ce <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015e3:	85 c0                	test   %eax,%eax
  8015e5:	74 19                	je     801600 <malloc+0x41>

			void * block = alloc_block_FF(size);
  8015e7:	83 ec 0c             	sub    $0xc,%esp
  8015ea:	ff 75 08             	pushl  0x8(%ebp)
  8015ed:	e8 85 11 00 00       	call   802777 <alloc_block_FF>
  8015f2:	83 c4 10             	add    $0x10,%esp
  8015f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  8015f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015fb:	e9 73 01 00 00       	jmp    801773 <malloc+0x1b4>
		} else {
			return NULL;
  801600:	b8 00 00 00 00       	mov    $0x0,%eax
  801605:	e9 69 01 00 00       	jmp    801773 <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  80160a:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801611:	8b 55 08             	mov    0x8(%ebp),%edx
  801614:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801617:	01 d0                	add    %edx,%eax
  801619:	48                   	dec    %eax
  80161a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80161d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801620:	ba 00 00 00 00       	mov    $0x0,%edx
  801625:	f7 75 e0             	divl   -0x20(%ebp)
  801628:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80162b:	29 d0                	sub    %edx,%eax
  80162d:	c1 e8 0c             	shr    $0xc,%eax
  801630:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  801633:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  80163a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801641:	a1 20 50 80 00       	mov    0x805020,%eax
  801646:	8b 40 7c             	mov    0x7c(%eax),%eax
  801649:	05 00 10 00 00       	add    $0x1000,%eax
  80164e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801651:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801656:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801659:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  80165c:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801663:	8b 55 08             	mov    0x8(%ebp),%edx
  801666:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801669:	01 d0                	add    %edx,%eax
  80166b:	48                   	dec    %eax
  80166c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80166f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801672:	ba 00 00 00 00       	mov    $0x0,%edx
  801677:	f7 75 cc             	divl   -0x34(%ebp)
  80167a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80167d:	29 d0                	sub    %edx,%eax
  80167f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801682:	76 0a                	jbe    80168e <malloc+0xcf>
		return NULL;
  801684:	b8 00 00 00 00       	mov    $0x0,%eax
  801689:	e9 e5 00 00 00       	jmp    801773 <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  80168e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801691:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801694:	eb 48                	jmp    8016de <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  801696:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801699:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80169c:	c1 e8 0c             	shr    $0xc,%eax
  80169f:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  8016a2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8016a5:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8016ac:	85 c0                	test   %eax,%eax
  8016ae:	75 11                	jne    8016c1 <malloc+0x102>
			freePagesCount++;
  8016b0:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8016b3:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8016b7:	75 16                	jne    8016cf <malloc+0x110>
				start = i;
  8016b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016bf:	eb 0e                	jmp    8016cf <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  8016c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8016c8:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  8016cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d2:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8016d5:	74 12                	je     8016e9 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  8016d7:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8016de:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8016e5:	76 af                	jbe    801696 <malloc+0xd7>
  8016e7:	eb 01                	jmp    8016ea <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  8016e9:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  8016ea:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8016ee:	74 08                	je     8016f8 <malloc+0x139>
  8016f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f3:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8016f6:	74 07                	je     8016ff <malloc+0x140>
		return NULL;
  8016f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fd:	eb 74                	jmp    801773 <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8016ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801702:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801705:	c1 e8 0c             	shr    $0xc,%eax
  801708:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  80170b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80170e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801711:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801718:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80171b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80171e:	eb 11                	jmp    801731 <malloc+0x172>
		markedPages[i] = 1;
  801720:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801723:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  80172a:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  80172e:	ff 45 e8             	incl   -0x18(%ebp)
  801731:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801734:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801737:	01 d0                	add    %edx,%eax
  801739:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80173c:	77 e2                	ja     801720 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  80173e:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801745:	8b 55 08             	mov    0x8(%ebp),%edx
  801748:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80174b:	01 d0                	add    %edx,%eax
  80174d:	48                   	dec    %eax
  80174e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801751:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801754:	ba 00 00 00 00       	mov    $0x0,%edx
  801759:	f7 75 bc             	divl   -0x44(%ebp)
  80175c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80175f:	29 d0                	sub    %edx,%eax
  801761:	83 ec 08             	sub    $0x8,%esp
  801764:	50                   	push   %eax
  801765:	ff 75 f0             	pushl  -0x10(%ebp)
  801768:	e8 14 0b 00 00       	call   802281 <sys_allocate_user_mem>
  80176d:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  801770:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  80177b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80177f:	0f 84 ee 00 00 00    	je     801873 <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801785:	a1 20 50 80 00       	mov    0x805020,%eax
  80178a:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  80178d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801790:	77 09                	ja     80179b <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801792:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801799:	76 14                	jbe    8017af <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  80179b:	83 ec 04             	sub    $0x4,%esp
  80179e:	68 38 40 80 00       	push   $0x804038
  8017a3:	6a 68                	push   $0x68
  8017a5:	68 52 40 80 00       	push   $0x804052
  8017aa:	e8 a3 ed ff ff       	call   800552 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  8017af:	a1 20 50 80 00       	mov    0x805020,%eax
  8017b4:	8b 40 74             	mov    0x74(%eax),%eax
  8017b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8017ba:	77 20                	ja     8017dc <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  8017bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8017c1:	8b 40 78             	mov    0x78(%eax),%eax
  8017c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8017c7:	76 13                	jbe    8017dc <free+0x67>
		free_block(virtual_address);
  8017c9:	83 ec 0c             	sub    $0xc,%esp
  8017cc:	ff 75 08             	pushl  0x8(%ebp)
  8017cf:	e8 6c 16 00 00       	call   802e40 <free_block>
  8017d4:	83 c4 10             	add    $0x10,%esp
		return;
  8017d7:	e9 98 00 00 00       	jmp    801874 <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8017dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8017df:	a1 20 50 80 00       	mov    0x805020,%eax
  8017e4:	8b 40 7c             	mov    0x7c(%eax),%eax
  8017e7:	29 c2                	sub    %eax,%edx
  8017e9:	89 d0                	mov    %edx,%eax
  8017eb:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  8017f0:	c1 e8 0c             	shr    $0xc,%eax
  8017f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  8017f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8017fd:	eb 16                	jmp    801815 <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  8017ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801802:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801805:	01 d0                	add    %edx,%eax
  801807:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  80180e:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801812:	ff 45 f4             	incl   -0xc(%ebp)
  801815:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801818:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  80181f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801822:	7f db                	jg     8017ff <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  801824:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801827:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  80182e:	c1 e0 0c             	shl    $0xc,%eax
  801831:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  801834:	8b 45 08             	mov    0x8(%ebp),%eax
  801837:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80183a:	eb 1a                	jmp    801856 <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  80183c:	83 ec 08             	sub    $0x8,%esp
  80183f:	68 00 10 00 00       	push   $0x1000
  801844:	ff 75 f0             	pushl  -0x10(%ebp)
  801847:	e8 19 0a 00 00       	call   802265 <sys_free_user_mem>
  80184c:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  80184f:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801856:	8b 55 08             	mov    0x8(%ebp),%edx
  801859:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80185c:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  80185e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801861:	77 d9                	ja     80183c <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801863:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801866:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  80186d:	00 00 00 00 
  801871:	eb 01                	jmp    801874 <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  801873:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	83 ec 58             	sub    $0x58,%esp
  80187c:	8b 45 10             	mov    0x10(%ebp),%eax
  80187f:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801882:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801886:	75 0a                	jne    801892 <smalloc+0x1c>
		return NULL;
  801888:	b8 00 00 00 00       	mov    $0x0,%eax
  80188d:	e9 7d 01 00 00       	jmp    801a0f <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801892:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801899:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80189f:	01 d0                	add    %edx,%eax
  8018a1:	48                   	dec    %eax
  8018a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8018a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ad:	f7 75 e4             	divl   -0x1c(%ebp)
  8018b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018b3:	29 d0                	sub    %edx,%eax
  8018b5:	c1 e8 0c             	shr    $0xc,%eax
  8018b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  8018bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8018c2:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8018c9:	a1 20 50 80 00       	mov    0x805020,%eax
  8018ce:	8b 40 7c             	mov    0x7c(%eax),%eax
  8018d1:	05 00 10 00 00       	add    $0x1000,%eax
  8018d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  8018d9:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8018de:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8018e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  8018e4:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8018eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8018f1:	01 d0                	add    %edx,%eax
  8018f3:	48                   	dec    %eax
  8018f4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8018f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ff:	f7 75 d0             	divl   -0x30(%ebp)
  801902:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801905:	29 d0                	sub    %edx,%eax
  801907:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80190a:	76 0a                	jbe    801916 <smalloc+0xa0>
		return NULL;
  80190c:	b8 00 00 00 00       	mov    $0x0,%eax
  801911:	e9 f9 00 00 00       	jmp    801a0f <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801916:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801919:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80191c:	eb 48                	jmp    801966 <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  80191e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801921:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801924:	c1 e8 0c             	shr    $0xc,%eax
  801927:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  80192a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80192d:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801934:	85 c0                	test   %eax,%eax
  801936:	75 11                	jne    801949 <smalloc+0xd3>
			freePagesCount++;
  801938:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  80193b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80193f:	75 16                	jne    801957 <smalloc+0xe1>
				start = s;
  801941:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801944:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801947:	eb 0e                	jmp    801957 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  801949:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801950:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  801957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80195d:	74 12                	je     801971 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80195f:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801966:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80196d:	76 af                	jbe    80191e <smalloc+0xa8>
  80196f:	eb 01                	jmp    801972 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  801971:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  801972:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801976:	74 08                	je     801980 <smalloc+0x10a>
  801978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80197e:	74 0a                	je     80198a <smalloc+0x114>
		return NULL;
  801980:	b8 00 00 00 00       	mov    $0x0,%eax
  801985:	e9 85 00 00 00       	jmp    801a0f <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  80198a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80198d:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801990:	c1 e8 0c             	shr    $0xc,%eax
  801993:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  801996:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801999:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80199c:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8019a3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8019a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8019a9:	eb 11                	jmp    8019bc <smalloc+0x146>
		markedPages[s] = 1;
  8019ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019ae:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  8019b5:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8019b9:	ff 45 e8             	incl   -0x18(%ebp)
  8019bc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8019bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019c2:	01 d0                	add    %edx,%eax
  8019c4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8019c7:	77 e2                	ja     8019ab <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  8019c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019cc:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  8019d0:	52                   	push   %edx
  8019d1:	50                   	push   %eax
  8019d2:	ff 75 0c             	pushl  0xc(%ebp)
  8019d5:	ff 75 08             	pushl  0x8(%ebp)
  8019d8:	e8 8f 04 00 00       	call   801e6c <sys_createSharedObject>
  8019dd:	83 c4 10             	add    $0x10,%esp
  8019e0:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  8019e3:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  8019e7:	78 12                	js     8019fb <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  8019e9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8019ec:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8019ef:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  8019f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f9:	eb 14                	jmp    801a0f <smalloc+0x199>
	}
	free((void*) start);
  8019fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fe:	83 ec 0c             	sub    $0xc,%esp
  801a01:	50                   	push   %eax
  801a02:	e8 6e fd ff ff       	call   801775 <free>
  801a07:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801a0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  801a17:	83 ec 08             	sub    $0x8,%esp
  801a1a:	ff 75 0c             	pushl  0xc(%ebp)
  801a1d:	ff 75 08             	pushl  0x8(%ebp)
  801a20:	e8 71 04 00 00       	call   801e96 <sys_getSizeOfSharedObject>
  801a25:	83 c4 10             	add    $0x10,%esp
  801a28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801a2b:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801a32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a38:	01 d0                	add    %edx,%eax
  801a3a:	48                   	dec    %eax
  801a3b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a3e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a41:	ba 00 00 00 00       	mov    $0x0,%edx
  801a46:	f7 75 e0             	divl   -0x20(%ebp)
  801a49:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a4c:	29 d0                	sub    %edx,%eax
  801a4e:	c1 e8 0c             	shr    $0xc,%eax
  801a51:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  801a54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801a5b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  801a62:	a1 20 50 80 00       	mov    0x805020,%eax
  801a67:	8b 40 7c             	mov    0x7c(%eax),%eax
  801a6a:	05 00 10 00 00       	add    $0x1000,%eax
  801a6f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  801a72:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801a77:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801a7a:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801a7d:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801a84:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a87:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801a8a:	01 d0                	add    %edx,%eax
  801a8c:	48                   	dec    %eax
  801a8d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801a90:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a93:	ba 00 00 00 00       	mov    $0x0,%edx
  801a98:	f7 75 cc             	divl   -0x34(%ebp)
  801a9b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a9e:	29 d0                	sub    %edx,%eax
  801aa0:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801aa3:	76 0a                	jbe    801aaf <sget+0x9e>
		return NULL;
  801aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  801aaa:	e9 f7 00 00 00       	jmp    801ba6 <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801aaf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ab2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ab5:	eb 48                	jmp    801aff <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  801ab7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aba:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801abd:	c1 e8 0c             	shr    $0xc,%eax
  801ac0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  801ac3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801ac6:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801acd:	85 c0                	test   %eax,%eax
  801acf:	75 11                	jne    801ae2 <sget+0xd1>
			free_Pages_Count++;
  801ad1:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801ad4:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801ad8:	75 16                	jne    801af0 <sget+0xdf>
				start = s;
  801ada:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801add:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ae0:	eb 0e                	jmp    801af0 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  801ae2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801ae9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  801af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af3:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801af6:	74 12                	je     801b0a <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801af8:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801aff:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801b06:	76 af                	jbe    801ab7 <sget+0xa6>
  801b08:	eb 01                	jmp    801b0b <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  801b0a:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  801b0b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801b0f:	74 08                	je     801b19 <sget+0x108>
  801b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b14:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801b17:	74 0a                	je     801b23 <sget+0x112>
		return NULL;
  801b19:	b8 00 00 00 00       	mov    $0x0,%eax
  801b1e:	e9 83 00 00 00       	jmp    801ba6 <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  801b23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b26:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801b29:	c1 e8 0c             	shr    $0xc,%eax
  801b2c:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  801b2f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b32:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b35:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801b3c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b3f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b42:	eb 11                	jmp    801b55 <sget+0x144>
		markedPages[k] = 1;
  801b44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b47:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801b4e:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801b52:	ff 45 e8             	incl   -0x18(%ebp)
  801b55:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801b58:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b5b:	01 d0                	add    %edx,%eax
  801b5d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801b60:	77 e2                	ja     801b44 <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  801b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b65:	83 ec 04             	sub    $0x4,%esp
  801b68:	50                   	push   %eax
  801b69:	ff 75 0c             	pushl  0xc(%ebp)
  801b6c:	ff 75 08             	pushl  0x8(%ebp)
  801b6f:	e8 3f 03 00 00       	call   801eb3 <sys_getSharedObject>
  801b74:	83 c4 10             	add    $0x10,%esp
  801b77:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  801b7a:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  801b7e:	78 12                	js     801b92 <sget+0x181>
		shardIDs[startPage] = ss;
  801b80:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b83:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801b86:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801b8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b90:	eb 14                	jmp    801ba6 <sget+0x195>
	}
	free((void*) start);
  801b92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b95:	83 ec 0c             	sub    $0xc,%esp
  801b98:	50                   	push   %eax
  801b99:	e8 d7 fb ff ff       	call   801775 <free>
  801b9e:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801ba1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
  801bab:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801bae:	8b 55 08             	mov    0x8(%ebp),%edx
  801bb1:	a1 20 50 80 00       	mov    0x805020,%eax
  801bb6:	8b 40 7c             	mov    0x7c(%eax),%eax
  801bb9:	29 c2                	sub    %eax,%edx
  801bbb:	89 d0                	mov    %edx,%eax
  801bbd:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  801bc2:	c1 e8 0c             	shr    $0xc,%eax
  801bc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  801bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bcb:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  801bd2:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  801bd5:	83 ec 08             	sub    $0x8,%esp
  801bd8:	ff 75 08             	pushl  0x8(%ebp)
  801bdb:	ff 75 f0             	pushl  -0x10(%ebp)
  801bde:	e8 ef 02 00 00       	call   801ed2 <sys_freeSharedObject>
  801be3:	83 c4 10             	add    $0x10,%esp
  801be6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  801be9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bed:	75 0e                	jne    801bfd <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  801bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf2:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  801bf9:	ff ff ff ff 
	}

}
  801bfd:	90                   	nop
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c06:	83 ec 04             	sub    $0x4,%esp
  801c09:	68 60 40 80 00       	push   $0x804060
  801c0e:	68 19 01 00 00       	push   $0x119
  801c13:	68 52 40 80 00       	push   $0x804052
  801c18:	e8 35 e9 ff ff       	call   800552 <_panic>

00801c1d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c23:	83 ec 04             	sub    $0x4,%esp
  801c26:	68 86 40 80 00       	push   $0x804086
  801c2b:	68 23 01 00 00       	push   $0x123
  801c30:	68 52 40 80 00       	push   $0x804052
  801c35:	e8 18 e9 ff ff       	call   800552 <_panic>

00801c3a <shrink>:

}
void shrink(uint32 newSize) {
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
  801c3d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c40:	83 ec 04             	sub    $0x4,%esp
  801c43:	68 86 40 80 00       	push   $0x804086
  801c48:	68 27 01 00 00       	push   $0x127
  801c4d:	68 52 40 80 00       	push   $0x804052
  801c52:	e8 fb e8 ff ff       	call   800552 <_panic>

00801c57 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
  801c5a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c5d:	83 ec 04             	sub    $0x4,%esp
  801c60:	68 86 40 80 00       	push   $0x804086
  801c65:	68 2b 01 00 00       	push   $0x12b
  801c6a:	68 52 40 80 00       	push   $0x804052
  801c6f:	e8 de e8 ff ff       	call   800552 <_panic>

00801c74 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
  801c77:	57                   	push   %edi
  801c78:	56                   	push   %esi
  801c79:	53                   	push   %ebx
  801c7a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c83:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c86:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c89:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c8c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c8f:	cd 30                	int    $0x30
  801c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c97:	83 c4 10             	add    $0x10,%esp
  801c9a:	5b                   	pop    %ebx
  801c9b:	5e                   	pop    %esi
  801c9c:	5f                   	pop    %edi
  801c9d:	5d                   	pop    %ebp
  801c9e:	c3                   	ret    

00801c9f <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 04             	sub    $0x4,%esp
  801ca5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801cab:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	52                   	push   %edx
  801cb7:	ff 75 0c             	pushl  0xc(%ebp)
  801cba:	50                   	push   %eax
  801cbb:	6a 00                	push   $0x0
  801cbd:	e8 b2 ff ff ff       	call   801c74 <syscall>
  801cc2:	83 c4 18             	add    $0x18,%esp
}
  801cc5:	90                   	nop
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <sys_cgetc>:

int sys_cgetc(void) {
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 02                	push   $0x2
  801cd7:	e8 98 ff ff ff       	call   801c74 <syscall>
  801cdc:	83 c4 18             	add    $0x18,%esp
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <sys_lock_cons>:

void sys_lock_cons(void) {
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 03                	push   $0x3
  801cf0:	e8 7f ff ff ff       	call   801c74 <syscall>
  801cf5:	83 c4 18             	add    $0x18,%esp
}
  801cf8:	90                   	nop
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 04                	push   $0x4
  801d0a:	e8 65 ff ff ff       	call   801c74 <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
}
  801d12:	90                   	nop
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801d18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	52                   	push   %edx
  801d25:	50                   	push   %eax
  801d26:	6a 08                	push   $0x8
  801d28:	e8 47 ff ff ff       	call   801c74 <syscall>
  801d2d:	83 c4 18             	add    $0x18,%esp
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	56                   	push   %esi
  801d36:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801d37:	8b 75 18             	mov    0x18(%ebp),%esi
  801d3a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d43:	8b 45 08             	mov    0x8(%ebp),%eax
  801d46:	56                   	push   %esi
  801d47:	53                   	push   %ebx
  801d48:	51                   	push   %ecx
  801d49:	52                   	push   %edx
  801d4a:	50                   	push   %eax
  801d4b:	6a 09                	push   $0x9
  801d4d:	e8 22 ff ff ff       	call   801c74 <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801d55:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d58:	5b                   	pop    %ebx
  801d59:	5e                   	pop    %esi
  801d5a:	5d                   	pop    %ebp
  801d5b:	c3                   	ret    

00801d5c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d62:	8b 45 08             	mov    0x8(%ebp),%eax
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	52                   	push   %edx
  801d6c:	50                   	push   %eax
  801d6d:	6a 0a                	push   $0xa
  801d6f:	e8 00 ff ff ff       	call   801c74 <syscall>
  801d74:	83 c4 18             	add    $0x18,%esp
}
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	ff 75 0c             	pushl  0xc(%ebp)
  801d85:	ff 75 08             	pushl  0x8(%ebp)
  801d88:	6a 0b                	push   $0xb
  801d8a:	e8 e5 fe ff ff       	call   801c74 <syscall>
  801d8f:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 0c                	push   $0xc
  801da3:	e8 cc fe ff ff       	call   801c74 <syscall>
  801da8:	83 c4 18             	add    $0x18,%esp
}
  801dab:	c9                   	leave  
  801dac:	c3                   	ret    

00801dad <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 0d                	push   $0xd
  801dbc:	e8 b3 fe ff ff       	call   801c74 <syscall>
  801dc1:	83 c4 18             	add    $0x18,%esp
}
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    

00801dc6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 0e                	push   $0xe
  801dd5:	e8 9a fe ff ff       	call   801c74 <syscall>
  801dda:	83 c4 18             	add    $0x18,%esp
}
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 0f                	push   $0xf
  801dee:	e8 81 fe ff ff       	call   801c74 <syscall>
  801df3:	83 c4 18             	add    $0x18,%esp
}
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    

00801df8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	ff 75 08             	pushl  0x8(%ebp)
  801e06:	6a 10                	push   $0x10
  801e08:	e8 67 fe ff ff       	call   801c74 <syscall>
  801e0d:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801e10:	c9                   	leave  
  801e11:	c3                   	ret    

00801e12 <sys_scarce_memory>:

void sys_scarce_memory() {
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 11                	push   $0x11
  801e21:	e8 4e fe ff ff       	call   801c74 <syscall>
  801e26:	83 c4 18             	add    $0x18,%esp
}
  801e29:	90                   	nop
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <sys_cputc>:

void sys_cputc(const char c) {
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	83 ec 04             	sub    $0x4,%esp
  801e32:	8b 45 08             	mov    0x8(%ebp),%eax
  801e35:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e38:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	50                   	push   %eax
  801e45:	6a 01                	push   $0x1
  801e47:	e8 28 fe ff ff       	call   801c74 <syscall>
  801e4c:	83 c4 18             	add    $0x18,%esp
}
  801e4f:	90                   	nop
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 14                	push   $0x14
  801e61:	e8 0e fe ff ff       	call   801c74 <syscall>
  801e66:	83 c4 18             	add    $0x18,%esp
}
  801e69:	90                   	nop
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	83 ec 04             	sub    $0x4,%esp
  801e72:	8b 45 10             	mov    0x10(%ebp),%eax
  801e75:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801e78:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e7b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	6a 00                	push   $0x0
  801e84:	51                   	push   %ecx
  801e85:	52                   	push   %edx
  801e86:	ff 75 0c             	pushl  0xc(%ebp)
  801e89:	50                   	push   %eax
  801e8a:	6a 15                	push   $0x15
  801e8c:	e8 e3 fd ff ff       	call   801c74 <syscall>
  801e91:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801e99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	52                   	push   %edx
  801ea6:	50                   	push   %eax
  801ea7:	6a 16                	push   $0x16
  801ea9:	e8 c6 fd ff ff       	call   801c74 <syscall>
  801eae:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801eb6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	51                   	push   %ecx
  801ec4:	52                   	push   %edx
  801ec5:	50                   	push   %eax
  801ec6:	6a 17                	push   $0x17
  801ec8:	e8 a7 fd ff ff       	call   801c74 <syscall>
  801ecd:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801ed5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	52                   	push   %edx
  801ee2:	50                   	push   %eax
  801ee3:	6a 18                	push   $0x18
  801ee5:	e8 8a fd ff ff       	call   801c74 <syscall>
  801eea:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef5:	6a 00                	push   $0x0
  801ef7:	ff 75 14             	pushl  0x14(%ebp)
  801efa:	ff 75 10             	pushl  0x10(%ebp)
  801efd:	ff 75 0c             	pushl  0xc(%ebp)
  801f00:	50                   	push   %eax
  801f01:	6a 19                	push   $0x19
  801f03:	e8 6c fd ff ff       	call   801c74 <syscall>
  801f08:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <sys_run_env>:

void sys_run_env(int32 envId) {
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	50                   	push   %eax
  801f1c:	6a 1a                	push   $0x1a
  801f1e:	e8 51 fd ff ff       	call   801c74 <syscall>
  801f23:	83 c4 18             	add    $0x18,%esp
}
  801f26:	90                   	nop
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	50                   	push   %eax
  801f38:	6a 1b                	push   $0x1b
  801f3a:	e8 35 fd ff ff       	call   801c74 <syscall>
  801f3f:	83 c4 18             	add    $0x18,%esp
}
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <sys_getenvid>:

int32 sys_getenvid(void) {
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 05                	push   $0x5
  801f53:	e8 1c fd ff ff       	call   801c74 <syscall>
  801f58:	83 c4 18             	add    $0x18,%esp
}
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 06                	push   $0x6
  801f6c:	e8 03 fd ff ff       	call   801c74 <syscall>
  801f71:	83 c4 18             	add    $0x18,%esp
}
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 07                	push   $0x7
  801f85:	e8 ea fc ff ff       	call   801c74 <syscall>
  801f8a:	83 c4 18             	add    $0x18,%esp
}
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    

00801f8f <sys_exit_env>:

void sys_exit_env(void) {
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 1c                	push   $0x1c
  801f9e:	e8 d1 fc ff ff       	call   801c74 <syscall>
  801fa3:	83 c4 18             	add    $0x18,%esp
}
  801fa6:	90                   	nop
  801fa7:	c9                   	leave  
  801fa8:	c3                   	ret    

00801fa9 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
  801fac:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801faf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fb2:	8d 50 04             	lea    0x4(%eax),%edx
  801fb5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	52                   	push   %edx
  801fbf:	50                   	push   %eax
  801fc0:	6a 1d                	push   $0x1d
  801fc2:	e8 ad fc ff ff       	call   801c74 <syscall>
  801fc7:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801fca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fd0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fd3:	89 01                	mov    %eax,(%ecx)
  801fd5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	c9                   	leave  
  801fdc:	c2 04 00             	ret    $0x4

00801fdf <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	ff 75 10             	pushl  0x10(%ebp)
  801fe9:	ff 75 0c             	pushl  0xc(%ebp)
  801fec:	ff 75 08             	pushl  0x8(%ebp)
  801fef:	6a 13                	push   $0x13
  801ff1:	e8 7e fc ff ff       	call   801c74 <syscall>
  801ff6:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801ff9:	90                   	nop
}
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <sys_rcr2>:
uint32 sys_rcr2() {
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 1e                	push   $0x1e
  80200b:	e8 64 fc ff ff       	call   801c74 <syscall>
  802010:	83 c4 18             	add    $0x18,%esp
}
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
  802018:	83 ec 04             	sub    $0x4,%esp
  80201b:	8b 45 08             	mov    0x8(%ebp),%eax
  80201e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802021:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	50                   	push   %eax
  80202e:	6a 1f                	push   $0x1f
  802030:	e8 3f fc ff ff       	call   801c74 <syscall>
  802035:	83 c4 18             	add    $0x18,%esp
	return;
  802038:	90                   	nop
}
  802039:	c9                   	leave  
  80203a:	c3                   	ret    

0080203b <rsttst>:
void rsttst() {
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 21                	push   $0x21
  80204a:	e8 25 fc ff ff       	call   801c74 <syscall>
  80204f:	83 c4 18             	add    $0x18,%esp
	return;
  802052:	90                   	nop
}
  802053:	c9                   	leave  
  802054:	c3                   	ret    

00802055 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
  802058:	83 ec 04             	sub    $0x4,%esp
  80205b:	8b 45 14             	mov    0x14(%ebp),%eax
  80205e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802061:	8b 55 18             	mov    0x18(%ebp),%edx
  802064:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802068:	52                   	push   %edx
  802069:	50                   	push   %eax
  80206a:	ff 75 10             	pushl  0x10(%ebp)
  80206d:	ff 75 0c             	pushl  0xc(%ebp)
  802070:	ff 75 08             	pushl  0x8(%ebp)
  802073:	6a 20                	push   $0x20
  802075:	e8 fa fb ff ff       	call   801c74 <syscall>
  80207a:	83 c4 18             	add    $0x18,%esp
	return;
  80207d:	90                   	nop
}
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <chktst>:
void chktst(uint32 n) {
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	ff 75 08             	pushl  0x8(%ebp)
  80208e:	6a 22                	push   $0x22
  802090:	e8 df fb ff ff       	call   801c74 <syscall>
  802095:	83 c4 18             	add    $0x18,%esp
	return;
  802098:	90                   	nop
}
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <inctst>:

void inctst() {
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 23                	push   $0x23
  8020aa:	e8 c5 fb ff ff       	call   801c74 <syscall>
  8020af:	83 c4 18             	add    $0x18,%esp
	return;
  8020b2:	90                   	nop
}
  8020b3:	c9                   	leave  
  8020b4:	c3                   	ret    

008020b5 <gettst>:
uint32 gettst() {
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 24                	push   $0x24
  8020c4:	e8 ab fb ff ff       	call   801c74 <syscall>
  8020c9:	83 c4 18             	add    $0x18,%esp
}
  8020cc:	c9                   	leave  
  8020cd:	c3                   	ret    

008020ce <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
  8020d1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 25                	push   $0x25
  8020e0:	e8 8f fb ff ff       	call   801c74 <syscall>
  8020e5:	83 c4 18             	add    $0x18,%esp
  8020e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8020eb:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8020ef:	75 07                	jne    8020f8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8020f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8020f6:	eb 05                	jmp    8020fd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8020f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
  802102:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 25                	push   $0x25
  802111:	e8 5e fb ff ff       	call   801c74 <syscall>
  802116:	83 c4 18             	add    $0x18,%esp
  802119:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80211c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802120:	75 07                	jne    802129 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802122:	b8 01 00 00 00       	mov    $0x1,%eax
  802127:	eb 05                	jmp    80212e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802129:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80212e:	c9                   	leave  
  80212f:	c3                   	ret    

00802130 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
  802133:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	6a 25                	push   $0x25
  802142:	e8 2d fb ff ff       	call   801c74 <syscall>
  802147:	83 c4 18             	add    $0x18,%esp
  80214a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80214d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802151:	75 07                	jne    80215a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802153:	b8 01 00 00 00       	mov    $0x1,%eax
  802158:	eb 05                	jmp    80215f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80215a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80215f:	c9                   	leave  
  802160:	c3                   	ret    

00802161 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  802161:	55                   	push   %ebp
  802162:	89 e5                	mov    %esp,%ebp
  802164:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 25                	push   $0x25
  802173:	e8 fc fa ff ff       	call   801c74 <syscall>
  802178:	83 c4 18             	add    $0x18,%esp
  80217b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80217e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802182:	75 07                	jne    80218b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802184:	b8 01 00 00 00       	mov    $0x1,%eax
  802189:	eb 05                	jmp    802190 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80218b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	ff 75 08             	pushl  0x8(%ebp)
  8021a0:	6a 26                	push   $0x26
  8021a2:	e8 cd fa ff ff       	call   801c74 <syscall>
  8021a7:	83 c4 18             	add    $0x18,%esp
	return;
  8021aa:	90                   	nop
}
  8021ab:	c9                   	leave  
  8021ac:	c3                   	ret    

008021ad <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
  8021b0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  8021b1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	6a 00                	push   $0x0
  8021bf:	53                   	push   %ebx
  8021c0:	51                   	push   %ecx
  8021c1:	52                   	push   %edx
  8021c2:	50                   	push   %eax
  8021c3:	6a 27                	push   $0x27
  8021c5:	e8 aa fa ff ff       	call   801c74 <syscall>
  8021ca:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  8021cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021d0:	c9                   	leave  
  8021d1:	c3                   	ret    

008021d2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  8021d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	52                   	push   %edx
  8021e2:	50                   	push   %eax
  8021e3:	6a 28                	push   $0x28
  8021e5:	e8 8a fa ff ff       	call   801c74 <syscall>
  8021ea:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  8021ed:	c9                   	leave  
  8021ee:	c3                   	ret    

008021ef <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  8021ef:	55                   	push   %ebp
  8021f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  8021f2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	6a 00                	push   $0x0
  8021fd:	51                   	push   %ecx
  8021fe:	ff 75 10             	pushl  0x10(%ebp)
  802201:	52                   	push   %edx
  802202:	50                   	push   %eax
  802203:	6a 29                	push   $0x29
  802205:	e8 6a fa ff ff       	call   801c74 <syscall>
  80220a:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  80220d:	c9                   	leave  
  80220e:	c3                   	ret    

0080220f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	ff 75 10             	pushl  0x10(%ebp)
  802219:	ff 75 0c             	pushl  0xc(%ebp)
  80221c:	ff 75 08             	pushl  0x8(%ebp)
  80221f:	6a 12                	push   $0x12
  802221:	e8 4e fa ff ff       	call   801c74 <syscall>
  802226:	83 c4 18             	add    $0x18,%esp
	return;
  802229:	90                   	nop
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  80222f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	52                   	push   %edx
  80223c:	50                   	push   %eax
  80223d:	6a 2a                	push   $0x2a
  80223f:	e8 30 fa ff ff       	call   801c74 <syscall>
  802244:	83 c4 18             	add    $0x18,%esp
	return;
  802247:	90                   	nop
}
  802248:	c9                   	leave  
  802249:	c3                   	ret    

0080224a <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  80224d:	8b 45 08             	mov    0x8(%ebp),%eax
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	50                   	push   %eax
  802259:	6a 2b                	push   $0x2b
  80225b:	e8 14 fa ff ff       	call   801c74 <syscall>
  802260:	83 c4 18             	add    $0x18,%esp
}
  802263:	c9                   	leave  
  802264:	c3                   	ret    

00802265 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	ff 75 0c             	pushl  0xc(%ebp)
  802271:	ff 75 08             	pushl  0x8(%ebp)
  802274:	6a 2c                	push   $0x2c
  802276:	e8 f9 f9 ff ff       	call   801c74 <syscall>
  80227b:	83 c4 18             	add    $0x18,%esp
	return;
  80227e:	90                   	nop
}
  80227f:	c9                   	leave  
  802280:	c3                   	ret    

00802281 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  802281:	55                   	push   %ebp
  802282:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	ff 75 0c             	pushl  0xc(%ebp)
  80228d:	ff 75 08             	pushl  0x8(%ebp)
  802290:	6a 2d                	push   $0x2d
  802292:	e8 dd f9 ff ff       	call   801c74 <syscall>
  802297:	83 c4 18             	add    $0x18,%esp
	return;
  80229a:	90                   	nop
}
  80229b:	c9                   	leave  
  80229c:	c3                   	ret    

0080229d <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	50                   	push   %eax
  8022ac:	6a 2f                	push   $0x2f
  8022ae:	e8 c1 f9 ff ff       	call   801c74 <syscall>
  8022b3:	83 c4 18             	add    $0x18,%esp
	return;
  8022b6:	90                   	nop
}
  8022b7:	c9                   	leave  
  8022b8:	c3                   	ret    

008022b9 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  8022bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	52                   	push   %edx
  8022c9:	50                   	push   %eax
  8022ca:	6a 30                	push   $0x30
  8022cc:	e8 a3 f9 ff ff       	call   801c74 <syscall>
  8022d1:	83 c4 18             	add    $0x18,%esp
	return;
  8022d4:	90                   	nop
}
  8022d5:	c9                   	leave  
  8022d6:	c3                   	ret    

008022d7 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  8022d7:	55                   	push   %ebp
  8022d8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  8022da:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	50                   	push   %eax
  8022e6:	6a 31                	push   $0x31
  8022e8:	e8 87 f9 ff ff       	call   801c74 <syscall>
  8022ed:	83 c4 18             	add    $0x18,%esp
	return;
  8022f0:	90                   	nop
}
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    

008022f3 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8022f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	52                   	push   %edx
  802303:	50                   	push   %eax
  802304:	6a 2e                	push   $0x2e
  802306:	e8 69 f9 ff ff       	call   801c74 <syscall>
  80230b:	83 c4 18             	add    $0x18,%esp
    return;
  80230e:	90                   	nop
}
  80230f:	c9                   	leave  
  802310:	c3                   	ret    

00802311 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802311:	55                   	push   %ebp
  802312:	89 e5                	mov    %esp,%ebp
  802314:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802317:	8b 45 08             	mov    0x8(%ebp),%eax
  80231a:	83 e8 04             	sub    $0x4,%eax
  80231d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802320:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802323:	8b 00                	mov    (%eax),%eax
  802325:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
  80232d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802330:	8b 45 08             	mov    0x8(%ebp),%eax
  802333:	83 e8 04             	sub    $0x4,%eax
  802336:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802339:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80233c:	8b 00                	mov    (%eax),%eax
  80233e:	83 e0 01             	and    $0x1,%eax
  802341:	85 c0                	test   %eax,%eax
  802343:	0f 94 c0             	sete   %al
}
  802346:	c9                   	leave  
  802347:	c3                   	ret    

00802348 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802348:	55                   	push   %ebp
  802349:	89 e5                	mov    %esp,%ebp
  80234b:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80234e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802355:	8b 45 0c             	mov    0xc(%ebp),%eax
  802358:	83 f8 02             	cmp    $0x2,%eax
  80235b:	74 2b                	je     802388 <alloc_block+0x40>
  80235d:	83 f8 02             	cmp    $0x2,%eax
  802360:	7f 07                	jg     802369 <alloc_block+0x21>
  802362:	83 f8 01             	cmp    $0x1,%eax
  802365:	74 0e                	je     802375 <alloc_block+0x2d>
  802367:	eb 58                	jmp    8023c1 <alloc_block+0x79>
  802369:	83 f8 03             	cmp    $0x3,%eax
  80236c:	74 2d                	je     80239b <alloc_block+0x53>
  80236e:	83 f8 04             	cmp    $0x4,%eax
  802371:	74 3b                	je     8023ae <alloc_block+0x66>
  802373:	eb 4c                	jmp    8023c1 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802375:	83 ec 0c             	sub    $0xc,%esp
  802378:	ff 75 08             	pushl  0x8(%ebp)
  80237b:	e8 f7 03 00 00       	call   802777 <alloc_block_FF>
  802380:	83 c4 10             	add    $0x10,%esp
  802383:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802386:	eb 4a                	jmp    8023d2 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802388:	83 ec 0c             	sub    $0xc,%esp
  80238b:	ff 75 08             	pushl  0x8(%ebp)
  80238e:	e8 f0 11 00 00       	call   803583 <alloc_block_NF>
  802393:	83 c4 10             	add    $0x10,%esp
  802396:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802399:	eb 37                	jmp    8023d2 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80239b:	83 ec 0c             	sub    $0xc,%esp
  80239e:	ff 75 08             	pushl  0x8(%ebp)
  8023a1:	e8 08 08 00 00       	call   802bae <alloc_block_BF>
  8023a6:	83 c4 10             	add    $0x10,%esp
  8023a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023ac:	eb 24                	jmp    8023d2 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8023ae:	83 ec 0c             	sub    $0xc,%esp
  8023b1:	ff 75 08             	pushl  0x8(%ebp)
  8023b4:	e8 ad 11 00 00       	call   803566 <alloc_block_WF>
  8023b9:	83 c4 10             	add    $0x10,%esp
  8023bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023bf:	eb 11                	jmp    8023d2 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8023c1:	83 ec 0c             	sub    $0xc,%esp
  8023c4:	68 98 40 80 00       	push   $0x804098
  8023c9:	e8 41 e4 ff ff       	call   80080f <cprintf>
  8023ce:	83 c4 10             	add    $0x10,%esp
		break;
  8023d1:	90                   	nop
	}
	return va;
  8023d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8023d5:	c9                   	leave  
  8023d6:	c3                   	ret    

008023d7 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8023d7:	55                   	push   %ebp
  8023d8:	89 e5                	mov    %esp,%ebp
  8023da:	53                   	push   %ebx
  8023db:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8023de:	83 ec 0c             	sub    $0xc,%esp
  8023e1:	68 b8 40 80 00       	push   $0x8040b8
  8023e6:	e8 24 e4 ff ff       	call   80080f <cprintf>
  8023eb:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8023ee:	83 ec 0c             	sub    $0xc,%esp
  8023f1:	68 e3 40 80 00       	push   $0x8040e3
  8023f6:	e8 14 e4 ff ff       	call   80080f <cprintf>
  8023fb:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8023fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802401:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802404:	eb 37                	jmp    80243d <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802406:	83 ec 0c             	sub    $0xc,%esp
  802409:	ff 75 f4             	pushl  -0xc(%ebp)
  80240c:	e8 19 ff ff ff       	call   80232a <is_free_block>
  802411:	83 c4 10             	add    $0x10,%esp
  802414:	0f be d8             	movsbl %al,%ebx
  802417:	83 ec 0c             	sub    $0xc,%esp
  80241a:	ff 75 f4             	pushl  -0xc(%ebp)
  80241d:	e8 ef fe ff ff       	call   802311 <get_block_size>
  802422:	83 c4 10             	add    $0x10,%esp
  802425:	83 ec 04             	sub    $0x4,%esp
  802428:	53                   	push   %ebx
  802429:	50                   	push   %eax
  80242a:	68 fb 40 80 00       	push   $0x8040fb
  80242f:	e8 db e3 ff ff       	call   80080f <cprintf>
  802434:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802437:	8b 45 10             	mov    0x10(%ebp),%eax
  80243a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80243d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802441:	74 07                	je     80244a <print_blocks_list+0x73>
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	8b 00                	mov    (%eax),%eax
  802448:	eb 05                	jmp    80244f <print_blocks_list+0x78>
  80244a:	b8 00 00 00 00       	mov    $0x0,%eax
  80244f:	89 45 10             	mov    %eax,0x10(%ebp)
  802452:	8b 45 10             	mov    0x10(%ebp),%eax
  802455:	85 c0                	test   %eax,%eax
  802457:	75 ad                	jne    802406 <print_blocks_list+0x2f>
  802459:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80245d:	75 a7                	jne    802406 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80245f:	83 ec 0c             	sub    $0xc,%esp
  802462:	68 b8 40 80 00       	push   $0x8040b8
  802467:	e8 a3 e3 ff ff       	call   80080f <cprintf>
  80246c:	83 c4 10             	add    $0x10,%esp

}
  80246f:	90                   	nop
  802470:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802473:	c9                   	leave  
  802474:	c3                   	ret    

00802475 <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802475:	55                   	push   %ebp
  802476:	89 e5                	mov    %esp,%ebp
  802478:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80247b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80247e:	83 e0 01             	and    $0x1,%eax
  802481:	85 c0                	test   %eax,%eax
  802483:	74 03                	je     802488 <initialize_dynamic_allocator+0x13>
  802485:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  802488:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80248c:	0f 84 f8 00 00 00    	je     80258a <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  802492:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  802499:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  80249c:	a1 40 50 98 00       	mov    0x985040,%eax
  8024a1:	85 c0                	test   %eax,%eax
  8024a3:	0f 84 e2 00 00 00    	je     80258b <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  8024a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  8024b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8024bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024be:	01 d0                	add    %edx,%eax
  8024c0:	83 e8 04             	sub    $0x4,%eax
  8024c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8024c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  8024cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d2:	83 c0 08             	add    $0x8,%eax
  8024d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  8024d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024db:	83 e8 08             	sub    $0x8,%eax
  8024de:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  8024e1:	83 ec 04             	sub    $0x4,%esp
  8024e4:	6a 00                	push   $0x0
  8024e6:	ff 75 e8             	pushl  -0x18(%ebp)
  8024e9:	ff 75 ec             	pushl  -0x14(%ebp)
  8024ec:	e8 9c 00 00 00       	call   80258d <set_block_data>
  8024f1:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  8024f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  8024fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802500:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  802507:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  80250e:	00 00 00 
  802511:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  802518:	00 00 00 
  80251b:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  802522:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  802525:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802529:	75 17                	jne    802542 <initialize_dynamic_allocator+0xcd>
  80252b:	83 ec 04             	sub    $0x4,%esp
  80252e:	68 14 41 80 00       	push   $0x804114
  802533:	68 80 00 00 00       	push   $0x80
  802538:	68 37 41 80 00       	push   $0x804137
  80253d:	e8 10 e0 ff ff       	call   800552 <_panic>
  802542:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802548:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80254b:	89 10                	mov    %edx,(%eax)
  80254d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802550:	8b 00                	mov    (%eax),%eax
  802552:	85 c0                	test   %eax,%eax
  802554:	74 0d                	je     802563 <initialize_dynamic_allocator+0xee>
  802556:	a1 48 50 98 00       	mov    0x985048,%eax
  80255b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80255e:	89 50 04             	mov    %edx,0x4(%eax)
  802561:	eb 08                	jmp    80256b <initialize_dynamic_allocator+0xf6>
  802563:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802566:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80256b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256e:	a3 48 50 98 00       	mov    %eax,0x985048
  802573:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802576:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80257d:	a1 54 50 98 00       	mov    0x985054,%eax
  802582:	40                   	inc    %eax
  802583:	a3 54 50 98 00       	mov    %eax,0x985054
  802588:	eb 01                	jmp    80258b <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  80258a:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  80258b:	c9                   	leave  
  80258c:	c3                   	ret    

0080258d <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80258d:	55                   	push   %ebp
  80258e:	89 e5                	mov    %esp,%ebp
  802590:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  802593:	8b 45 0c             	mov    0xc(%ebp),%eax
  802596:	83 e0 01             	and    $0x1,%eax
  802599:	85 c0                	test   %eax,%eax
  80259b:	74 03                	je     8025a0 <set_block_data+0x13>
	{
		totalSize++;
  80259d:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  8025a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a3:	83 e8 04             	sub    $0x4,%eax
  8025a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  8025a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ac:	83 e0 fe             	and    $0xfffffffe,%eax
  8025af:	89 c2                	mov    %eax,%edx
  8025b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8025b4:	83 e0 01             	and    $0x1,%eax
  8025b7:	09 c2                	or     %eax,%edx
  8025b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025bc:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  8025be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c1:	8d 50 f8             	lea    -0x8(%eax),%edx
  8025c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c7:	01 d0                	add    %edx,%eax
  8025c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  8025cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025cf:	83 e0 fe             	and    $0xfffffffe,%eax
  8025d2:	89 c2                	mov    %eax,%edx
  8025d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8025d7:	83 e0 01             	and    $0x1,%eax
  8025da:	09 c2                	or     %eax,%edx
  8025dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025df:	89 10                	mov    %edx,(%eax)
}
  8025e1:	90                   	nop
  8025e2:	c9                   	leave  
  8025e3:	c3                   	ret    

008025e4 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  8025e4:	55                   	push   %ebp
  8025e5:	89 e5                	mov    %esp,%ebp
  8025e7:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  8025ea:	a1 48 50 98 00       	mov    0x985048,%eax
  8025ef:	85 c0                	test   %eax,%eax
  8025f1:	75 68                	jne    80265b <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  8025f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025f7:	75 17                	jne    802610 <insert_sorted_in_freeList+0x2c>
  8025f9:	83 ec 04             	sub    $0x4,%esp
  8025fc:	68 14 41 80 00       	push   $0x804114
  802601:	68 9d 00 00 00       	push   $0x9d
  802606:	68 37 41 80 00       	push   $0x804137
  80260b:	e8 42 df ff ff       	call   800552 <_panic>
  802610:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802616:	8b 45 08             	mov    0x8(%ebp),%eax
  802619:	89 10                	mov    %edx,(%eax)
  80261b:	8b 45 08             	mov    0x8(%ebp),%eax
  80261e:	8b 00                	mov    (%eax),%eax
  802620:	85 c0                	test   %eax,%eax
  802622:	74 0d                	je     802631 <insert_sorted_in_freeList+0x4d>
  802624:	a1 48 50 98 00       	mov    0x985048,%eax
  802629:	8b 55 08             	mov    0x8(%ebp),%edx
  80262c:	89 50 04             	mov    %edx,0x4(%eax)
  80262f:	eb 08                	jmp    802639 <insert_sorted_in_freeList+0x55>
  802631:	8b 45 08             	mov    0x8(%ebp),%eax
  802634:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802639:	8b 45 08             	mov    0x8(%ebp),%eax
  80263c:	a3 48 50 98 00       	mov    %eax,0x985048
  802641:	8b 45 08             	mov    0x8(%ebp),%eax
  802644:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80264b:	a1 54 50 98 00       	mov    0x985054,%eax
  802650:	40                   	inc    %eax
  802651:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  802656:	e9 1a 01 00 00       	jmp    802775 <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  80265b:	a1 48 50 98 00       	mov    0x985048,%eax
  802660:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802663:	eb 7f                	jmp    8026e4 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  802665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802668:	3b 45 08             	cmp    0x8(%ebp),%eax
  80266b:	76 6f                	jbe    8026dc <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  80266d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802671:	74 06                	je     802679 <insert_sorted_in_freeList+0x95>
  802673:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802677:	75 17                	jne    802690 <insert_sorted_in_freeList+0xac>
  802679:	83 ec 04             	sub    $0x4,%esp
  80267c:	68 50 41 80 00       	push   $0x804150
  802681:	68 a6 00 00 00       	push   $0xa6
  802686:	68 37 41 80 00       	push   $0x804137
  80268b:	e8 c2 de ff ff       	call   800552 <_panic>
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	8b 50 04             	mov    0x4(%eax),%edx
  802696:	8b 45 08             	mov    0x8(%ebp),%eax
  802699:	89 50 04             	mov    %edx,0x4(%eax)
  80269c:	8b 45 08             	mov    0x8(%ebp),%eax
  80269f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a2:	89 10                	mov    %edx,(%eax)
  8026a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a7:	8b 40 04             	mov    0x4(%eax),%eax
  8026aa:	85 c0                	test   %eax,%eax
  8026ac:	74 0d                	je     8026bb <insert_sorted_in_freeList+0xd7>
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	8b 40 04             	mov    0x4(%eax),%eax
  8026b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b7:	89 10                	mov    %edx,(%eax)
  8026b9:	eb 08                	jmp    8026c3 <insert_sorted_in_freeList+0xdf>
  8026bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026be:	a3 48 50 98 00       	mov    %eax,0x985048
  8026c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c9:	89 50 04             	mov    %edx,0x4(%eax)
  8026cc:	a1 54 50 98 00       	mov    0x985054,%eax
  8026d1:	40                   	inc    %eax
  8026d2:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  8026d7:	e9 99 00 00 00       	jmp    802775 <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8026dc:	a1 50 50 98 00       	mov    0x985050,%eax
  8026e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e8:	74 07                	je     8026f1 <insert_sorted_in_freeList+0x10d>
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	8b 00                	mov    (%eax),%eax
  8026ef:	eb 05                	jmp    8026f6 <insert_sorted_in_freeList+0x112>
  8026f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f6:	a3 50 50 98 00       	mov    %eax,0x985050
  8026fb:	a1 50 50 98 00       	mov    0x985050,%eax
  802700:	85 c0                	test   %eax,%eax
  802702:	0f 85 5d ff ff ff    	jne    802665 <insert_sorted_in_freeList+0x81>
  802708:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270c:	0f 85 53 ff ff ff    	jne    802665 <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  802712:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802716:	75 17                	jne    80272f <insert_sorted_in_freeList+0x14b>
  802718:	83 ec 04             	sub    $0x4,%esp
  80271b:	68 88 41 80 00       	push   $0x804188
  802720:	68 ab 00 00 00       	push   $0xab
  802725:	68 37 41 80 00       	push   $0x804137
  80272a:	e8 23 de ff ff       	call   800552 <_panic>
  80272f:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  802735:	8b 45 08             	mov    0x8(%ebp),%eax
  802738:	89 50 04             	mov    %edx,0x4(%eax)
  80273b:	8b 45 08             	mov    0x8(%ebp),%eax
  80273e:	8b 40 04             	mov    0x4(%eax),%eax
  802741:	85 c0                	test   %eax,%eax
  802743:	74 0c                	je     802751 <insert_sorted_in_freeList+0x16d>
  802745:	a1 4c 50 98 00       	mov    0x98504c,%eax
  80274a:	8b 55 08             	mov    0x8(%ebp),%edx
  80274d:	89 10                	mov    %edx,(%eax)
  80274f:	eb 08                	jmp    802759 <insert_sorted_in_freeList+0x175>
  802751:	8b 45 08             	mov    0x8(%ebp),%eax
  802754:	a3 48 50 98 00       	mov    %eax,0x985048
  802759:	8b 45 08             	mov    0x8(%ebp),%eax
  80275c:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802761:	8b 45 08             	mov    0x8(%ebp),%eax
  802764:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80276a:	a1 54 50 98 00       	mov    0x985054,%eax
  80276f:	40                   	inc    %eax
  802770:	a3 54 50 98 00       	mov    %eax,0x985054
}
  802775:	c9                   	leave  
  802776:	c3                   	ret    

00802777 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802777:	55                   	push   %ebp
  802778:	89 e5                	mov    %esp,%ebp
  80277a:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80277d:	8b 45 08             	mov    0x8(%ebp),%eax
  802780:	83 e0 01             	and    $0x1,%eax
  802783:	85 c0                	test   %eax,%eax
  802785:	74 03                	je     80278a <alloc_block_FF+0x13>
  802787:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80278a:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80278e:	77 07                	ja     802797 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802790:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802797:	a1 40 50 98 00       	mov    0x985040,%eax
  80279c:	85 c0                	test   %eax,%eax
  80279e:	75 63                	jne    802803 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a3:	83 c0 10             	add    $0x10,%eax
  8027a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027a9:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8027b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b6:	01 d0                	add    %edx,%eax
  8027b8:	48                   	dec    %eax
  8027b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8027bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8027c4:	f7 75 ec             	divl   -0x14(%ebp)
  8027c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ca:	29 d0                	sub    %edx,%eax
  8027cc:	c1 e8 0c             	shr    $0xc,%eax
  8027cf:	83 ec 0c             	sub    $0xc,%esp
  8027d2:	50                   	push   %eax
  8027d3:	e8 d1 ed ff ff       	call   8015a9 <sbrk>
  8027d8:	83 c4 10             	add    $0x10,%esp
  8027db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8027de:	83 ec 0c             	sub    $0xc,%esp
  8027e1:	6a 00                	push   $0x0
  8027e3:	e8 c1 ed ff ff       	call   8015a9 <sbrk>
  8027e8:	83 c4 10             	add    $0x10,%esp
  8027eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8027ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027f1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8027f4:	83 ec 08             	sub    $0x8,%esp
  8027f7:	50                   	push   %eax
  8027f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8027fb:	e8 75 fc ff ff       	call   802475 <initialize_dynamic_allocator>
  802800:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  802803:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802807:	75 0a                	jne    802813 <alloc_block_FF+0x9c>
	{
		return NULL;
  802809:	b8 00 00 00 00       	mov    $0x0,%eax
  80280e:	e9 99 03 00 00       	jmp    802bac <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802813:	8b 45 08             	mov    0x8(%ebp),%eax
  802816:	83 c0 08             	add    $0x8,%eax
  802819:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  80281c:	a1 48 50 98 00       	mov    0x985048,%eax
  802821:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802824:	e9 03 02 00 00       	jmp    802a2c <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802829:	83 ec 0c             	sub    $0xc,%esp
  80282c:	ff 75 f4             	pushl  -0xc(%ebp)
  80282f:	e8 dd fa ff ff       	call   802311 <get_block_size>
  802834:	83 c4 10             	add    $0x10,%esp
  802837:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  80283a:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80283d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802840:	0f 82 de 01 00 00    	jb     802a24 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  802846:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802849:	83 c0 10             	add    $0x10,%eax
  80284c:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  80284f:	0f 87 32 01 00 00    	ja     802987 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  802855:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802858:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80285b:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  80285e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802861:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802864:	01 d0                	add    %edx,%eax
  802866:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  802869:	83 ec 04             	sub    $0x4,%esp
  80286c:	6a 00                	push   $0x0
  80286e:	ff 75 98             	pushl  -0x68(%ebp)
  802871:	ff 75 94             	pushl  -0x6c(%ebp)
  802874:	e8 14 fd ff ff       	call   80258d <set_block_data>
  802879:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  80287c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802880:	74 06                	je     802888 <alloc_block_FF+0x111>
  802882:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  802886:	75 17                	jne    80289f <alloc_block_FF+0x128>
  802888:	83 ec 04             	sub    $0x4,%esp
  80288b:	68 ac 41 80 00       	push   $0x8041ac
  802890:	68 de 00 00 00       	push   $0xde
  802895:	68 37 41 80 00       	push   $0x804137
  80289a:	e8 b3 dc ff ff       	call   800552 <_panic>
  80289f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a2:	8b 10                	mov    (%eax),%edx
  8028a4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8028a7:	89 10                	mov    %edx,(%eax)
  8028a9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8028ac:	8b 00                	mov    (%eax),%eax
  8028ae:	85 c0                	test   %eax,%eax
  8028b0:	74 0b                	je     8028bd <alloc_block_FF+0x146>
  8028b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b5:	8b 00                	mov    (%eax),%eax
  8028b7:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8028ba:	89 50 04             	mov    %edx,0x4(%eax)
  8028bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c0:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8028c3:	89 10                	mov    %edx,(%eax)
  8028c5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8028c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028cb:	89 50 04             	mov    %edx,0x4(%eax)
  8028ce:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8028d1:	8b 00                	mov    (%eax),%eax
  8028d3:	85 c0                	test   %eax,%eax
  8028d5:	75 08                	jne    8028df <alloc_block_FF+0x168>
  8028d7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8028da:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8028df:	a1 54 50 98 00       	mov    0x985054,%eax
  8028e4:	40                   	inc    %eax
  8028e5:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  8028ea:	83 ec 04             	sub    $0x4,%esp
  8028ed:	6a 01                	push   $0x1
  8028ef:	ff 75 dc             	pushl  -0x24(%ebp)
  8028f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8028f5:	e8 93 fc ff ff       	call   80258d <set_block_data>
  8028fa:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  8028fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802901:	75 17                	jne    80291a <alloc_block_FF+0x1a3>
  802903:	83 ec 04             	sub    $0x4,%esp
  802906:	68 e0 41 80 00       	push   $0x8041e0
  80290b:	68 e3 00 00 00       	push   $0xe3
  802910:	68 37 41 80 00       	push   $0x804137
  802915:	e8 38 dc ff ff       	call   800552 <_panic>
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	8b 00                	mov    (%eax),%eax
  80291f:	85 c0                	test   %eax,%eax
  802921:	74 10                	je     802933 <alloc_block_FF+0x1bc>
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	8b 00                	mov    (%eax),%eax
  802928:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292b:	8b 52 04             	mov    0x4(%edx),%edx
  80292e:	89 50 04             	mov    %edx,0x4(%eax)
  802931:	eb 0b                	jmp    80293e <alloc_block_FF+0x1c7>
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	8b 40 04             	mov    0x4(%eax),%eax
  802939:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80293e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802941:	8b 40 04             	mov    0x4(%eax),%eax
  802944:	85 c0                	test   %eax,%eax
  802946:	74 0f                	je     802957 <alloc_block_FF+0x1e0>
  802948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294b:	8b 40 04             	mov    0x4(%eax),%eax
  80294e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802951:	8b 12                	mov    (%edx),%edx
  802953:	89 10                	mov    %edx,(%eax)
  802955:	eb 0a                	jmp    802961 <alloc_block_FF+0x1ea>
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	8b 00                	mov    (%eax),%eax
  80295c:	a3 48 50 98 00       	mov    %eax,0x985048
  802961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802964:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802974:	a1 54 50 98 00       	mov    0x985054,%eax
  802979:	48                   	dec    %eax
  80297a:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  80297f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802982:	e9 25 02 00 00       	jmp    802bac <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  802987:	83 ec 04             	sub    $0x4,%esp
  80298a:	6a 01                	push   $0x1
  80298c:	ff 75 9c             	pushl  -0x64(%ebp)
  80298f:	ff 75 f4             	pushl  -0xc(%ebp)
  802992:	e8 f6 fb ff ff       	call   80258d <set_block_data>
  802997:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  80299a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299e:	75 17                	jne    8029b7 <alloc_block_FF+0x240>
  8029a0:	83 ec 04             	sub    $0x4,%esp
  8029a3:	68 e0 41 80 00       	push   $0x8041e0
  8029a8:	68 eb 00 00 00       	push   $0xeb
  8029ad:	68 37 41 80 00       	push   $0x804137
  8029b2:	e8 9b db ff ff       	call   800552 <_panic>
  8029b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ba:	8b 00                	mov    (%eax),%eax
  8029bc:	85 c0                	test   %eax,%eax
  8029be:	74 10                	je     8029d0 <alloc_block_FF+0x259>
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	8b 00                	mov    (%eax),%eax
  8029c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029c8:	8b 52 04             	mov    0x4(%edx),%edx
  8029cb:	89 50 04             	mov    %edx,0x4(%eax)
  8029ce:	eb 0b                	jmp    8029db <alloc_block_FF+0x264>
  8029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d3:	8b 40 04             	mov    0x4(%eax),%eax
  8029d6:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8029db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029de:	8b 40 04             	mov    0x4(%eax),%eax
  8029e1:	85 c0                	test   %eax,%eax
  8029e3:	74 0f                	je     8029f4 <alloc_block_FF+0x27d>
  8029e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e8:	8b 40 04             	mov    0x4(%eax),%eax
  8029eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ee:	8b 12                	mov    (%edx),%edx
  8029f0:	89 10                	mov    %edx,(%eax)
  8029f2:	eb 0a                	jmp    8029fe <alloc_block_FF+0x287>
  8029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f7:	8b 00                	mov    (%eax),%eax
  8029f9:	a3 48 50 98 00       	mov    %eax,0x985048
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a11:	a1 54 50 98 00       	mov    0x985054,%eax
  802a16:	48                   	dec    %eax
  802a17:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1f:	e9 88 01 00 00       	jmp    802bac <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802a24:	a1 50 50 98 00       	mov    0x985050,%eax
  802a29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a30:	74 07                	je     802a39 <alloc_block_FF+0x2c2>
  802a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a35:	8b 00                	mov    (%eax),%eax
  802a37:	eb 05                	jmp    802a3e <alloc_block_FF+0x2c7>
  802a39:	b8 00 00 00 00       	mov    $0x0,%eax
  802a3e:	a3 50 50 98 00       	mov    %eax,0x985050
  802a43:	a1 50 50 98 00       	mov    0x985050,%eax
  802a48:	85 c0                	test   %eax,%eax
  802a4a:	0f 85 d9 fd ff ff    	jne    802829 <alloc_block_FF+0xb2>
  802a50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a54:	0f 85 cf fd ff ff    	jne    802829 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  802a5a:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802a61:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a64:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a67:	01 d0                	add    %edx,%eax
  802a69:	48                   	dec    %eax
  802a6a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802a6d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a70:	ba 00 00 00 00       	mov    $0x0,%edx
  802a75:	f7 75 d8             	divl   -0x28(%ebp)
  802a78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a7b:	29 d0                	sub    %edx,%eax
  802a7d:	c1 e8 0c             	shr    $0xc,%eax
  802a80:	83 ec 0c             	sub    $0xc,%esp
  802a83:	50                   	push   %eax
  802a84:	e8 20 eb ff ff       	call   8015a9 <sbrk>
  802a89:	83 c4 10             	add    $0x10,%esp
  802a8c:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802a8f:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802a93:	75 0a                	jne    802a9f <alloc_block_FF+0x328>
		return NULL;
  802a95:	b8 00 00 00 00       	mov    $0x0,%eax
  802a9a:	e9 0d 01 00 00       	jmp    802bac <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  802a9f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802aa2:	83 e8 04             	sub    $0x4,%eax
  802aa5:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  802aa8:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  802aaf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ab2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ab5:	01 d0                	add    %edx,%eax
  802ab7:	48                   	dec    %eax
  802ab8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802abb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802abe:	ba 00 00 00 00       	mov    $0x0,%edx
  802ac3:	f7 75 c8             	divl   -0x38(%ebp)
  802ac6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ac9:	29 d0                	sub    %edx,%eax
  802acb:	c1 e8 02             	shr    $0x2,%eax
  802ace:	c1 e0 02             	shl    $0x2,%eax
  802ad1:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  802ad4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ad7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  802add:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ae0:	83 e8 08             	sub    $0x8,%eax
  802ae3:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  802ae6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ae9:	8b 00                	mov    (%eax),%eax
  802aeb:	83 e0 fe             	and    $0xfffffffe,%eax
  802aee:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  802af1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802af4:	f7 d8                	neg    %eax
  802af6:	89 c2                	mov    %eax,%edx
  802af8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802afb:	01 d0                	add    %edx,%eax
  802afd:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  802b00:	83 ec 0c             	sub    $0xc,%esp
  802b03:	ff 75 b8             	pushl  -0x48(%ebp)
  802b06:	e8 1f f8 ff ff       	call   80232a <is_free_block>
  802b0b:	83 c4 10             	add    $0x10,%esp
  802b0e:	0f be c0             	movsbl %al,%eax
  802b11:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  802b14:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802b18:	74 42                	je     802b5c <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  802b1a:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802b21:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b24:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b27:	01 d0                	add    %edx,%eax
  802b29:	48                   	dec    %eax
  802b2a:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802b2d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b30:	ba 00 00 00 00       	mov    $0x0,%edx
  802b35:	f7 75 b0             	divl   -0x50(%ebp)
  802b38:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b3b:	29 d0                	sub    %edx,%eax
  802b3d:	89 c2                	mov    %eax,%edx
  802b3f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b42:	01 d0                	add    %edx,%eax
  802b44:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  802b47:	83 ec 04             	sub    $0x4,%esp
  802b4a:	6a 00                	push   $0x0
  802b4c:	ff 75 a8             	pushl  -0x58(%ebp)
  802b4f:	ff 75 b8             	pushl  -0x48(%ebp)
  802b52:	e8 36 fa ff ff       	call   80258d <set_block_data>
  802b57:	83 c4 10             	add    $0x10,%esp
  802b5a:	eb 42                	jmp    802b9e <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802b5c:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  802b63:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b66:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802b69:	01 d0                	add    %edx,%eax
  802b6b:	48                   	dec    %eax
  802b6c:	89 45 a0             	mov    %eax,-0x60(%ebp)
  802b6f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802b72:	ba 00 00 00 00       	mov    $0x0,%edx
  802b77:	f7 75 a4             	divl   -0x5c(%ebp)
  802b7a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802b7d:	29 d0                	sub    %edx,%eax
  802b7f:	83 ec 04             	sub    $0x4,%esp
  802b82:	6a 00                	push   $0x0
  802b84:	50                   	push   %eax
  802b85:	ff 75 d0             	pushl  -0x30(%ebp)
  802b88:	e8 00 fa ff ff       	call   80258d <set_block_data>
  802b8d:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802b90:	83 ec 0c             	sub    $0xc,%esp
  802b93:	ff 75 d0             	pushl  -0x30(%ebp)
  802b96:	e8 49 fa ff ff       	call   8025e4 <insert_sorted_in_freeList>
  802b9b:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802b9e:	83 ec 0c             	sub    $0xc,%esp
  802ba1:	ff 75 08             	pushl  0x8(%ebp)
  802ba4:	e8 ce fb ff ff       	call   802777 <alloc_block_FF>
  802ba9:	83 c4 10             	add    $0x10,%esp
}
  802bac:	c9                   	leave  
  802bad:	c3                   	ret    

00802bae <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802bae:	55                   	push   %ebp
  802baf:	89 e5                	mov    %esp,%ebp
  802bb1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  802bb4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bb8:	75 0a                	jne    802bc4 <alloc_block_BF+0x16>
	{
		return NULL;
  802bba:	b8 00 00 00 00       	mov    $0x0,%eax
  802bbf:	e9 7a 02 00 00       	jmp    802e3e <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc7:	83 c0 08             	add    $0x8,%eax
  802bca:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802bcd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  802bd4:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802bdb:	a1 48 50 98 00       	mov    0x985048,%eax
  802be0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802be3:	eb 32                	jmp    802c17 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  802be5:	ff 75 ec             	pushl  -0x14(%ebp)
  802be8:	e8 24 f7 ff ff       	call   802311 <get_block_size>
  802bed:	83 c4 04             	add    $0x4,%esp
  802bf0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  802bf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bf6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802bf9:	72 14                	jb     802c0f <alloc_block_BF+0x61>
  802bfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bfe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c01:	73 0c                	jae    802c0f <alloc_block_BF+0x61>
		{
			minBlk = block;
  802c03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c06:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  802c09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802c0f:	a1 50 50 98 00       	mov    0x985050,%eax
  802c14:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802c17:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c1b:	74 07                	je     802c24 <alloc_block_BF+0x76>
  802c1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c20:	8b 00                	mov    (%eax),%eax
  802c22:	eb 05                	jmp    802c29 <alloc_block_BF+0x7b>
  802c24:	b8 00 00 00 00       	mov    $0x0,%eax
  802c29:	a3 50 50 98 00       	mov    %eax,0x985050
  802c2e:	a1 50 50 98 00       	mov    0x985050,%eax
  802c33:	85 c0                	test   %eax,%eax
  802c35:	75 ae                	jne    802be5 <alloc_block_BF+0x37>
  802c37:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c3b:	75 a8                	jne    802be5 <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802c3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c41:	75 22                	jne    802c65 <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802c43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c46:	83 ec 0c             	sub    $0xc,%esp
  802c49:	50                   	push   %eax
  802c4a:	e8 5a e9 ff ff       	call   8015a9 <sbrk>
  802c4f:	83 c4 10             	add    $0x10,%esp
  802c52:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  802c55:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802c59:	75 0a                	jne    802c65 <alloc_block_BF+0xb7>
			return NULL;
  802c5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c60:	e9 d9 01 00 00       	jmp    802e3e <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  802c65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c68:	83 c0 10             	add    $0x10,%eax
  802c6b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c6e:	0f 87 32 01 00 00    	ja     802da6 <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  802c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c77:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802c7a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802c7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c83:	01 d0                	add    %edx,%eax
  802c85:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  802c88:	83 ec 04             	sub    $0x4,%esp
  802c8b:	6a 00                	push   $0x0
  802c8d:	ff 75 dc             	pushl  -0x24(%ebp)
  802c90:	ff 75 d8             	pushl  -0x28(%ebp)
  802c93:	e8 f5 f8 ff ff       	call   80258d <set_block_data>
  802c98:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802c9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9f:	74 06                	je     802ca7 <alloc_block_BF+0xf9>
  802ca1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802ca5:	75 17                	jne    802cbe <alloc_block_BF+0x110>
  802ca7:	83 ec 04             	sub    $0x4,%esp
  802caa:	68 ac 41 80 00       	push   $0x8041ac
  802caf:	68 49 01 00 00       	push   $0x149
  802cb4:	68 37 41 80 00       	push   $0x804137
  802cb9:	e8 94 d8 ff ff       	call   800552 <_panic>
  802cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc1:	8b 10                	mov    (%eax),%edx
  802cc3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802cc6:	89 10                	mov    %edx,(%eax)
  802cc8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ccb:	8b 00                	mov    (%eax),%eax
  802ccd:	85 c0                	test   %eax,%eax
  802ccf:	74 0b                	je     802cdc <alloc_block_BF+0x12e>
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	8b 00                	mov    (%eax),%eax
  802cd6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802cd9:	89 50 04             	mov    %edx,0x4(%eax)
  802cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802ce2:	89 10                	mov    %edx,(%eax)
  802ce4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ce7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cea:	89 50 04             	mov    %edx,0x4(%eax)
  802ced:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802cf0:	8b 00                	mov    (%eax),%eax
  802cf2:	85 c0                	test   %eax,%eax
  802cf4:	75 08                	jne    802cfe <alloc_block_BF+0x150>
  802cf6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802cf9:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802cfe:	a1 54 50 98 00       	mov    0x985054,%eax
  802d03:	40                   	inc    %eax
  802d04:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802d09:	83 ec 04             	sub    $0x4,%esp
  802d0c:	6a 01                	push   $0x1
  802d0e:	ff 75 e8             	pushl  -0x18(%ebp)
  802d11:	ff 75 f4             	pushl  -0xc(%ebp)
  802d14:	e8 74 f8 ff ff       	call   80258d <set_block_data>
  802d19:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802d1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d20:	75 17                	jne    802d39 <alloc_block_BF+0x18b>
  802d22:	83 ec 04             	sub    $0x4,%esp
  802d25:	68 e0 41 80 00       	push   $0x8041e0
  802d2a:	68 4e 01 00 00       	push   $0x14e
  802d2f:	68 37 41 80 00       	push   $0x804137
  802d34:	e8 19 d8 ff ff       	call   800552 <_panic>
  802d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3c:	8b 00                	mov    (%eax),%eax
  802d3e:	85 c0                	test   %eax,%eax
  802d40:	74 10                	je     802d52 <alloc_block_BF+0x1a4>
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	8b 00                	mov    (%eax),%eax
  802d47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d4a:	8b 52 04             	mov    0x4(%edx),%edx
  802d4d:	89 50 04             	mov    %edx,0x4(%eax)
  802d50:	eb 0b                	jmp    802d5d <alloc_block_BF+0x1af>
  802d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d55:	8b 40 04             	mov    0x4(%eax),%eax
  802d58:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d60:	8b 40 04             	mov    0x4(%eax),%eax
  802d63:	85 c0                	test   %eax,%eax
  802d65:	74 0f                	je     802d76 <alloc_block_BF+0x1c8>
  802d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6a:	8b 40 04             	mov    0x4(%eax),%eax
  802d6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d70:	8b 12                	mov    (%edx),%edx
  802d72:	89 10                	mov    %edx,(%eax)
  802d74:	eb 0a                	jmp    802d80 <alloc_block_BF+0x1d2>
  802d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d79:	8b 00                	mov    (%eax),%eax
  802d7b:	a3 48 50 98 00       	mov    %eax,0x985048
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d93:	a1 54 50 98 00       	mov    0x985054,%eax
  802d98:	48                   	dec    %eax
  802d99:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da1:	e9 98 00 00 00       	jmp    802e3e <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  802da6:	83 ec 04             	sub    $0x4,%esp
  802da9:	6a 01                	push   $0x1
  802dab:	ff 75 f0             	pushl  -0x10(%ebp)
  802dae:	ff 75 f4             	pushl  -0xc(%ebp)
  802db1:	e8 d7 f7 ff ff       	call   80258d <set_block_data>
  802db6:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802db9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dbd:	75 17                	jne    802dd6 <alloc_block_BF+0x228>
  802dbf:	83 ec 04             	sub    $0x4,%esp
  802dc2:	68 e0 41 80 00       	push   $0x8041e0
  802dc7:	68 56 01 00 00       	push   $0x156
  802dcc:	68 37 41 80 00       	push   $0x804137
  802dd1:	e8 7c d7 ff ff       	call   800552 <_panic>
  802dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd9:	8b 00                	mov    (%eax),%eax
  802ddb:	85 c0                	test   %eax,%eax
  802ddd:	74 10                	je     802def <alloc_block_BF+0x241>
  802ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de2:	8b 00                	mov    (%eax),%eax
  802de4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de7:	8b 52 04             	mov    0x4(%edx),%edx
  802dea:	89 50 04             	mov    %edx,0x4(%eax)
  802ded:	eb 0b                	jmp    802dfa <alloc_block_BF+0x24c>
  802def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df2:	8b 40 04             	mov    0x4(%eax),%eax
  802df5:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfd:	8b 40 04             	mov    0x4(%eax),%eax
  802e00:	85 c0                	test   %eax,%eax
  802e02:	74 0f                	je     802e13 <alloc_block_BF+0x265>
  802e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e07:	8b 40 04             	mov    0x4(%eax),%eax
  802e0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e0d:	8b 12                	mov    (%edx),%edx
  802e0f:	89 10                	mov    %edx,(%eax)
  802e11:	eb 0a                	jmp    802e1d <alloc_block_BF+0x26f>
  802e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e16:	8b 00                	mov    (%eax),%eax
  802e18:	a3 48 50 98 00       	mov    %eax,0x985048
  802e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e30:	a1 54 50 98 00       	mov    0x985054,%eax
  802e35:	48                   	dec    %eax
  802e36:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802e3e:	c9                   	leave  
  802e3f:	c3                   	ret    

00802e40 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802e40:	55                   	push   %ebp
  802e41:	89 e5                	mov    %esp,%ebp
  802e43:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802e46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e4a:	0f 84 6a 02 00 00    	je     8030ba <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  802e50:	ff 75 08             	pushl  0x8(%ebp)
  802e53:	e8 b9 f4 ff ff       	call   802311 <get_block_size>
  802e58:	83 c4 04             	add    $0x4,%esp
  802e5b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  802e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e61:	83 e8 08             	sub    $0x8,%eax
  802e64:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  802e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6a:	8b 00                	mov    (%eax),%eax
  802e6c:	83 e0 fe             	and    $0xfffffffe,%eax
  802e6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  802e72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e75:	f7 d8                	neg    %eax
  802e77:	89 c2                	mov    %eax,%edx
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	01 d0                	add    %edx,%eax
  802e7e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802e81:	ff 75 e8             	pushl  -0x18(%ebp)
  802e84:	e8 a1 f4 ff ff       	call   80232a <is_free_block>
  802e89:	83 c4 04             	add    $0x4,%esp
  802e8c:	0f be c0             	movsbl %al,%eax
  802e8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802e92:	8b 55 08             	mov    0x8(%ebp),%edx
  802e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e98:	01 d0                	add    %edx,%eax
  802e9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802e9d:	ff 75 e0             	pushl  -0x20(%ebp)
  802ea0:	e8 85 f4 ff ff       	call   80232a <is_free_block>
  802ea5:	83 c4 04             	add    $0x4,%esp
  802ea8:	0f be c0             	movsbl %al,%eax
  802eab:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802eae:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802eb2:	75 34                	jne    802ee8 <free_block+0xa8>
  802eb4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802eb8:	75 2e                	jne    802ee8 <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802eba:	ff 75 e8             	pushl  -0x18(%ebp)
  802ebd:	e8 4f f4 ff ff       	call   802311 <get_block_size>
  802ec2:	83 c4 04             	add    $0x4,%esp
  802ec5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802ec8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ecb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ece:	01 d0                	add    %edx,%eax
  802ed0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802ed3:	6a 00                	push   $0x0
  802ed5:	ff 75 d4             	pushl  -0x2c(%ebp)
  802ed8:	ff 75 e8             	pushl  -0x18(%ebp)
  802edb:	e8 ad f6 ff ff       	call   80258d <set_block_data>
  802ee0:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802ee3:	e9 d3 01 00 00       	jmp    8030bb <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802ee8:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802eec:	0f 85 c8 00 00 00    	jne    802fba <free_block+0x17a>
  802ef2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ef6:	0f 85 be 00 00 00    	jne    802fba <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802efc:	ff 75 e0             	pushl  -0x20(%ebp)
  802eff:	e8 0d f4 ff ff       	call   802311 <get_block_size>
  802f04:	83 c4 04             	add    $0x4,%esp
  802f07:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802f0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f0d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f10:	01 d0                	add    %edx,%eax
  802f12:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802f15:	6a 00                	push   $0x0
  802f17:	ff 75 cc             	pushl  -0x34(%ebp)
  802f1a:	ff 75 08             	pushl  0x8(%ebp)
  802f1d:	e8 6b f6 ff ff       	call   80258d <set_block_data>
  802f22:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802f25:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f29:	75 17                	jne    802f42 <free_block+0x102>
  802f2b:	83 ec 04             	sub    $0x4,%esp
  802f2e:	68 e0 41 80 00       	push   $0x8041e0
  802f33:	68 87 01 00 00       	push   $0x187
  802f38:	68 37 41 80 00       	push   $0x804137
  802f3d:	e8 10 d6 ff ff       	call   800552 <_panic>
  802f42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f45:	8b 00                	mov    (%eax),%eax
  802f47:	85 c0                	test   %eax,%eax
  802f49:	74 10                	je     802f5b <free_block+0x11b>
  802f4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f4e:	8b 00                	mov    (%eax),%eax
  802f50:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f53:	8b 52 04             	mov    0x4(%edx),%edx
  802f56:	89 50 04             	mov    %edx,0x4(%eax)
  802f59:	eb 0b                	jmp    802f66 <free_block+0x126>
  802f5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f5e:	8b 40 04             	mov    0x4(%eax),%eax
  802f61:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802f66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f69:	8b 40 04             	mov    0x4(%eax),%eax
  802f6c:	85 c0                	test   %eax,%eax
  802f6e:	74 0f                	je     802f7f <free_block+0x13f>
  802f70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f73:	8b 40 04             	mov    0x4(%eax),%eax
  802f76:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f79:	8b 12                	mov    (%edx),%edx
  802f7b:	89 10                	mov    %edx,(%eax)
  802f7d:	eb 0a                	jmp    802f89 <free_block+0x149>
  802f7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f82:	8b 00                	mov    (%eax),%eax
  802f84:	a3 48 50 98 00       	mov    %eax,0x985048
  802f89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9c:	a1 54 50 98 00       	mov    0x985054,%eax
  802fa1:	48                   	dec    %eax
  802fa2:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802fa7:	83 ec 0c             	sub    $0xc,%esp
  802faa:	ff 75 08             	pushl  0x8(%ebp)
  802fad:	e8 32 f6 ff ff       	call   8025e4 <insert_sorted_in_freeList>
  802fb2:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802fb5:	e9 01 01 00 00       	jmp    8030bb <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  802fba:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802fbe:	0f 85 d3 00 00 00    	jne    803097 <free_block+0x257>
  802fc4:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802fc8:	0f 85 c9 00 00 00    	jne    803097 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  802fce:	83 ec 0c             	sub    $0xc,%esp
  802fd1:	ff 75 e8             	pushl  -0x18(%ebp)
  802fd4:	e8 38 f3 ff ff       	call   802311 <get_block_size>
  802fd9:	83 c4 10             	add    $0x10,%esp
  802fdc:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  802fdf:	83 ec 0c             	sub    $0xc,%esp
  802fe2:	ff 75 e0             	pushl  -0x20(%ebp)
  802fe5:	e8 27 f3 ff ff       	call   802311 <get_block_size>
  802fea:	83 c4 10             	add    $0x10,%esp
  802fed:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  802ff0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ff3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ff6:	01 c2                	add    %eax,%edx
  802ff8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ffb:	01 d0                	add    %edx,%eax
  802ffd:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  803000:	83 ec 04             	sub    $0x4,%esp
  803003:	6a 00                	push   $0x0
  803005:	ff 75 c0             	pushl  -0x40(%ebp)
  803008:	ff 75 e8             	pushl  -0x18(%ebp)
  80300b:	e8 7d f5 ff ff       	call   80258d <set_block_data>
  803010:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  803013:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803017:	75 17                	jne    803030 <free_block+0x1f0>
  803019:	83 ec 04             	sub    $0x4,%esp
  80301c:	68 e0 41 80 00       	push   $0x8041e0
  803021:	68 94 01 00 00       	push   $0x194
  803026:	68 37 41 80 00       	push   $0x804137
  80302b:	e8 22 d5 ff ff       	call   800552 <_panic>
  803030:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803033:	8b 00                	mov    (%eax),%eax
  803035:	85 c0                	test   %eax,%eax
  803037:	74 10                	je     803049 <free_block+0x209>
  803039:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80303c:	8b 00                	mov    (%eax),%eax
  80303e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803041:	8b 52 04             	mov    0x4(%edx),%edx
  803044:	89 50 04             	mov    %edx,0x4(%eax)
  803047:	eb 0b                	jmp    803054 <free_block+0x214>
  803049:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80304c:	8b 40 04             	mov    0x4(%eax),%eax
  80304f:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803054:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803057:	8b 40 04             	mov    0x4(%eax),%eax
  80305a:	85 c0                	test   %eax,%eax
  80305c:	74 0f                	je     80306d <free_block+0x22d>
  80305e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803061:	8b 40 04             	mov    0x4(%eax),%eax
  803064:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803067:	8b 12                	mov    (%edx),%edx
  803069:	89 10                	mov    %edx,(%eax)
  80306b:	eb 0a                	jmp    803077 <free_block+0x237>
  80306d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803070:	8b 00                	mov    (%eax),%eax
  803072:	a3 48 50 98 00       	mov    %eax,0x985048
  803077:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80307a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803080:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803083:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80308a:	a1 54 50 98 00       	mov    0x985054,%eax
  80308f:	48                   	dec    %eax
  803090:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  803095:	eb 24                	jmp    8030bb <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  803097:	83 ec 04             	sub    $0x4,%esp
  80309a:	6a 00                	push   $0x0
  80309c:	ff 75 f4             	pushl  -0xc(%ebp)
  80309f:	ff 75 08             	pushl  0x8(%ebp)
  8030a2:	e8 e6 f4 ff ff       	call   80258d <set_block_data>
  8030a7:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  8030aa:	83 ec 0c             	sub    $0xc,%esp
  8030ad:	ff 75 08             	pushl  0x8(%ebp)
  8030b0:	e8 2f f5 ff ff       	call   8025e4 <insert_sorted_in_freeList>
  8030b5:	83 c4 10             	add    $0x10,%esp
  8030b8:	eb 01                	jmp    8030bb <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  8030ba:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  8030bb:	c9                   	leave  
  8030bc:	c3                   	ret    

008030bd <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  8030bd:	55                   	push   %ebp
  8030be:	89 e5                	mov    %esp,%ebp
  8030c0:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  8030c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c7:	75 10                	jne    8030d9 <realloc_block_FF+0x1c>
  8030c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030cd:	75 0a                	jne    8030d9 <realloc_block_FF+0x1c>
	{
		return NULL;
  8030cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8030d4:	e9 8b 04 00 00       	jmp    803564 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  8030d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030dd:	75 18                	jne    8030f7 <realloc_block_FF+0x3a>
	{
		free_block(va);
  8030df:	83 ec 0c             	sub    $0xc,%esp
  8030e2:	ff 75 08             	pushl  0x8(%ebp)
  8030e5:	e8 56 fd ff ff       	call   802e40 <free_block>
  8030ea:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8030ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f2:	e9 6d 04 00 00       	jmp    803564 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  8030f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030fb:	75 13                	jne    803110 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  8030fd:	83 ec 0c             	sub    $0xc,%esp
  803100:	ff 75 0c             	pushl  0xc(%ebp)
  803103:	e8 6f f6 ff ff       	call   802777 <alloc_block_FF>
  803108:	83 c4 10             	add    $0x10,%esp
  80310b:	e9 54 04 00 00       	jmp    803564 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  803110:	8b 45 0c             	mov    0xc(%ebp),%eax
  803113:	83 e0 01             	and    $0x1,%eax
  803116:	85 c0                	test   %eax,%eax
  803118:	74 03                	je     80311d <realloc_block_FF+0x60>
	{
		new_size++;
  80311a:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  80311d:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803121:	77 07                	ja     80312a <realloc_block_FF+0x6d>
	{
		new_size = 8;
  803123:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  80312a:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  80312e:	83 ec 0c             	sub    $0xc,%esp
  803131:	ff 75 08             	pushl  0x8(%ebp)
  803134:	e8 d8 f1 ff ff       	call   802311 <get_block_size>
  803139:	83 c4 10             	add    $0x10,%esp
  80313c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  80313f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803142:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803145:	75 08                	jne    80314f <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  803147:	8b 45 08             	mov    0x8(%ebp),%eax
  80314a:	e9 15 04 00 00       	jmp    803564 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  80314f:	8b 55 08             	mov    0x8(%ebp),%edx
  803152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803155:	01 d0                	add    %edx,%eax
  803157:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  80315a:	83 ec 0c             	sub    $0xc,%esp
  80315d:	ff 75 f0             	pushl  -0x10(%ebp)
  803160:	e8 c5 f1 ff ff       	call   80232a <is_free_block>
  803165:	83 c4 10             	add    $0x10,%esp
  803168:	0f be c0             	movsbl %al,%eax
  80316b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  80316e:	83 ec 0c             	sub    $0xc,%esp
  803171:	ff 75 f0             	pushl  -0x10(%ebp)
  803174:	e8 98 f1 ff ff       	call   802311 <get_block_size>
  803179:	83 c4 10             	add    $0x10,%esp
  80317c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  80317f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803182:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803185:	0f 86 a7 02 00 00    	jbe    803432 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  80318b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80318f:	0f 84 86 02 00 00    	je     80341b <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  803195:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319b:	01 d0                	add    %edx,%eax
  80319d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8031a0:	0f 85 b2 00 00 00    	jne    803258 <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  8031a6:	83 ec 0c             	sub    $0xc,%esp
  8031a9:	ff 75 08             	pushl  0x8(%ebp)
  8031ac:	e8 79 f1 ff ff       	call   80232a <is_free_block>
  8031b1:	83 c4 10             	add    $0x10,%esp
  8031b4:	84 c0                	test   %al,%al
  8031b6:	0f 94 c0             	sete   %al
  8031b9:	0f b6 c0             	movzbl %al,%eax
  8031bc:	83 ec 04             	sub    $0x4,%esp
  8031bf:	50                   	push   %eax
  8031c0:	ff 75 0c             	pushl  0xc(%ebp)
  8031c3:	ff 75 08             	pushl  0x8(%ebp)
  8031c6:	e8 c2 f3 ff ff       	call   80258d <set_block_data>
  8031cb:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  8031ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031d2:	75 17                	jne    8031eb <realloc_block_FF+0x12e>
  8031d4:	83 ec 04             	sub    $0x4,%esp
  8031d7:	68 e0 41 80 00       	push   $0x8041e0
  8031dc:	68 db 01 00 00       	push   $0x1db
  8031e1:	68 37 41 80 00       	push   $0x804137
  8031e6:	e8 67 d3 ff ff       	call   800552 <_panic>
  8031eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ee:	8b 00                	mov    (%eax),%eax
  8031f0:	85 c0                	test   %eax,%eax
  8031f2:	74 10                	je     803204 <realloc_block_FF+0x147>
  8031f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f7:	8b 00                	mov    (%eax),%eax
  8031f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031fc:	8b 52 04             	mov    0x4(%edx),%edx
  8031ff:	89 50 04             	mov    %edx,0x4(%eax)
  803202:	eb 0b                	jmp    80320f <realloc_block_FF+0x152>
  803204:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803207:	8b 40 04             	mov    0x4(%eax),%eax
  80320a:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80320f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803212:	8b 40 04             	mov    0x4(%eax),%eax
  803215:	85 c0                	test   %eax,%eax
  803217:	74 0f                	je     803228 <realloc_block_FF+0x16b>
  803219:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321c:	8b 40 04             	mov    0x4(%eax),%eax
  80321f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803222:	8b 12                	mov    (%edx),%edx
  803224:	89 10                	mov    %edx,(%eax)
  803226:	eb 0a                	jmp    803232 <realloc_block_FF+0x175>
  803228:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322b:	8b 00                	mov    (%eax),%eax
  80322d:	a3 48 50 98 00       	mov    %eax,0x985048
  803232:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803235:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80323b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803245:	a1 54 50 98 00       	mov    0x985054,%eax
  80324a:	48                   	dec    %eax
  80324b:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  803250:	8b 45 08             	mov    0x8(%ebp),%eax
  803253:	e9 0c 03 00 00       	jmp    803564 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  803258:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80325b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325e:	01 d0                	add    %edx,%eax
  803260:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803263:	0f 86 b2 01 00 00    	jbe    80341b <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  803269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80326c:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80326f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  803272:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803275:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803278:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  80327b:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  80327f:	0f 87 b8 00 00 00    	ja     80333d <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  803285:	83 ec 0c             	sub    $0xc,%esp
  803288:	ff 75 08             	pushl  0x8(%ebp)
  80328b:	e8 9a f0 ff ff       	call   80232a <is_free_block>
  803290:	83 c4 10             	add    $0x10,%esp
  803293:	84 c0                	test   %al,%al
  803295:	0f 94 c0             	sete   %al
  803298:	0f b6 c0             	movzbl %al,%eax
  80329b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80329e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032a1:	01 ca                	add    %ecx,%edx
  8032a3:	83 ec 04             	sub    $0x4,%esp
  8032a6:	50                   	push   %eax
  8032a7:	52                   	push   %edx
  8032a8:	ff 75 08             	pushl  0x8(%ebp)
  8032ab:	e8 dd f2 ff ff       	call   80258d <set_block_data>
  8032b0:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8032b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032b7:	75 17                	jne    8032d0 <realloc_block_FF+0x213>
  8032b9:	83 ec 04             	sub    $0x4,%esp
  8032bc:	68 e0 41 80 00       	push   $0x8041e0
  8032c1:	68 e8 01 00 00       	push   $0x1e8
  8032c6:	68 37 41 80 00       	push   $0x804137
  8032cb:	e8 82 d2 ff ff       	call   800552 <_panic>
  8032d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d3:	8b 00                	mov    (%eax),%eax
  8032d5:	85 c0                	test   %eax,%eax
  8032d7:	74 10                	je     8032e9 <realloc_block_FF+0x22c>
  8032d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032dc:	8b 00                	mov    (%eax),%eax
  8032de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032e1:	8b 52 04             	mov    0x4(%edx),%edx
  8032e4:	89 50 04             	mov    %edx,0x4(%eax)
  8032e7:	eb 0b                	jmp    8032f4 <realloc_block_FF+0x237>
  8032e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ec:	8b 40 04             	mov    0x4(%eax),%eax
  8032ef:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8032f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f7:	8b 40 04             	mov    0x4(%eax),%eax
  8032fa:	85 c0                	test   %eax,%eax
  8032fc:	74 0f                	je     80330d <realloc_block_FF+0x250>
  8032fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803301:	8b 40 04             	mov    0x4(%eax),%eax
  803304:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803307:	8b 12                	mov    (%edx),%edx
  803309:	89 10                	mov    %edx,(%eax)
  80330b:	eb 0a                	jmp    803317 <realloc_block_FF+0x25a>
  80330d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803310:	8b 00                	mov    (%eax),%eax
  803312:	a3 48 50 98 00       	mov    %eax,0x985048
  803317:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803320:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803323:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80332a:	a1 54 50 98 00       	mov    0x985054,%eax
  80332f:	48                   	dec    %eax
  803330:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  803335:	8b 45 08             	mov    0x8(%ebp),%eax
  803338:	e9 27 02 00 00       	jmp    803564 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  80333d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803341:	75 17                	jne    80335a <realloc_block_FF+0x29d>
  803343:	83 ec 04             	sub    $0x4,%esp
  803346:	68 e0 41 80 00       	push   $0x8041e0
  80334b:	68 ed 01 00 00       	push   $0x1ed
  803350:	68 37 41 80 00       	push   $0x804137
  803355:	e8 f8 d1 ff ff       	call   800552 <_panic>
  80335a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335d:	8b 00                	mov    (%eax),%eax
  80335f:	85 c0                	test   %eax,%eax
  803361:	74 10                	je     803373 <realloc_block_FF+0x2b6>
  803363:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803366:	8b 00                	mov    (%eax),%eax
  803368:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80336b:	8b 52 04             	mov    0x4(%edx),%edx
  80336e:	89 50 04             	mov    %edx,0x4(%eax)
  803371:	eb 0b                	jmp    80337e <realloc_block_FF+0x2c1>
  803373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803376:	8b 40 04             	mov    0x4(%eax),%eax
  803379:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80337e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803381:	8b 40 04             	mov    0x4(%eax),%eax
  803384:	85 c0                	test   %eax,%eax
  803386:	74 0f                	je     803397 <realloc_block_FF+0x2da>
  803388:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80338b:	8b 40 04             	mov    0x4(%eax),%eax
  80338e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803391:	8b 12                	mov    (%edx),%edx
  803393:	89 10                	mov    %edx,(%eax)
  803395:	eb 0a                	jmp    8033a1 <realloc_block_FF+0x2e4>
  803397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80339a:	8b 00                	mov    (%eax),%eax
  80339c:	a3 48 50 98 00       	mov    %eax,0x985048
  8033a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b4:	a1 54 50 98 00       	mov    0x985054,%eax
  8033b9:	48                   	dec    %eax
  8033ba:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  8033bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c5:	01 d0                	add    %edx,%eax
  8033c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  8033ca:	83 ec 04             	sub    $0x4,%esp
  8033cd:	6a 00                	push   $0x0
  8033cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8033d2:	ff 75 f0             	pushl  -0x10(%ebp)
  8033d5:	e8 b3 f1 ff ff       	call   80258d <set_block_data>
  8033da:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  8033dd:	83 ec 0c             	sub    $0xc,%esp
  8033e0:	ff 75 08             	pushl  0x8(%ebp)
  8033e3:	e8 42 ef ff ff       	call   80232a <is_free_block>
  8033e8:	83 c4 10             	add    $0x10,%esp
  8033eb:	84 c0                	test   %al,%al
  8033ed:	0f 94 c0             	sete   %al
  8033f0:	0f b6 c0             	movzbl %al,%eax
  8033f3:	83 ec 04             	sub    $0x4,%esp
  8033f6:	50                   	push   %eax
  8033f7:	ff 75 0c             	pushl  0xc(%ebp)
  8033fa:	ff 75 08             	pushl  0x8(%ebp)
  8033fd:	e8 8b f1 ff ff       	call   80258d <set_block_data>
  803402:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  803405:	83 ec 0c             	sub    $0xc,%esp
  803408:	ff 75 f0             	pushl  -0x10(%ebp)
  80340b:	e8 d4 f1 ff ff       	call   8025e4 <insert_sorted_in_freeList>
  803410:	83 c4 10             	add    $0x10,%esp
					return va;
  803413:	8b 45 08             	mov    0x8(%ebp),%eax
  803416:	e9 49 01 00 00       	jmp    803564 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  80341b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80341e:	83 e8 08             	sub    $0x8,%eax
  803421:	83 ec 0c             	sub    $0xc,%esp
  803424:	50                   	push   %eax
  803425:	e8 4d f3 ff ff       	call   802777 <alloc_block_FF>
  80342a:	83 c4 10             	add    $0x10,%esp
  80342d:	e9 32 01 00 00       	jmp    803564 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  803432:	8b 45 0c             	mov    0xc(%ebp),%eax
  803435:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803438:	0f 83 21 01 00 00    	jae    80355f <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  80343e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803441:	2b 45 0c             	sub    0xc(%ebp),%eax
  803444:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  803447:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  80344b:	77 0e                	ja     80345b <realloc_block_FF+0x39e>
  80344d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803451:	75 08                	jne    80345b <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  803453:	8b 45 08             	mov    0x8(%ebp),%eax
  803456:	e9 09 01 00 00       	jmp    803564 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  80345b:	8b 45 08             	mov    0x8(%ebp),%eax
  80345e:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  803461:	83 ec 0c             	sub    $0xc,%esp
  803464:	ff 75 08             	pushl  0x8(%ebp)
  803467:	e8 be ee ff ff       	call   80232a <is_free_block>
  80346c:	83 c4 10             	add    $0x10,%esp
  80346f:	84 c0                	test   %al,%al
  803471:	0f 94 c0             	sete   %al
  803474:	0f b6 c0             	movzbl %al,%eax
  803477:	83 ec 04             	sub    $0x4,%esp
  80347a:	50                   	push   %eax
  80347b:	ff 75 0c             	pushl  0xc(%ebp)
  80347e:	ff 75 d8             	pushl  -0x28(%ebp)
  803481:	e8 07 f1 ff ff       	call   80258d <set_block_data>
  803486:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  803489:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80348c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80348f:	01 d0                	add    %edx,%eax
  803491:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  803494:	83 ec 04             	sub    $0x4,%esp
  803497:	6a 00                	push   $0x0
  803499:	ff 75 dc             	pushl  -0x24(%ebp)
  80349c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80349f:	e8 e9 f0 ff ff       	call   80258d <set_block_data>
  8034a4:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  8034a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034ab:	0f 84 9b 00 00 00    	je     80354c <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  8034b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b7:	01 d0                	add    %edx,%eax
  8034b9:	83 ec 04             	sub    $0x4,%esp
  8034bc:	6a 00                	push   $0x0
  8034be:	50                   	push   %eax
  8034bf:	ff 75 d4             	pushl  -0x2c(%ebp)
  8034c2:	e8 c6 f0 ff ff       	call   80258d <set_block_data>
  8034c7:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  8034ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034ce:	75 17                	jne    8034e7 <realloc_block_FF+0x42a>
  8034d0:	83 ec 04             	sub    $0x4,%esp
  8034d3:	68 e0 41 80 00       	push   $0x8041e0
  8034d8:	68 10 02 00 00       	push   $0x210
  8034dd:	68 37 41 80 00       	push   $0x804137
  8034e2:	e8 6b d0 ff ff       	call   800552 <_panic>
  8034e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ea:	8b 00                	mov    (%eax),%eax
  8034ec:	85 c0                	test   %eax,%eax
  8034ee:	74 10                	je     803500 <realloc_block_FF+0x443>
  8034f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f3:	8b 00                	mov    (%eax),%eax
  8034f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034f8:	8b 52 04             	mov    0x4(%edx),%edx
  8034fb:	89 50 04             	mov    %edx,0x4(%eax)
  8034fe:	eb 0b                	jmp    80350b <realloc_block_FF+0x44e>
  803500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803503:	8b 40 04             	mov    0x4(%eax),%eax
  803506:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80350b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80350e:	8b 40 04             	mov    0x4(%eax),%eax
  803511:	85 c0                	test   %eax,%eax
  803513:	74 0f                	je     803524 <realloc_block_FF+0x467>
  803515:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803518:	8b 40 04             	mov    0x4(%eax),%eax
  80351b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80351e:	8b 12                	mov    (%edx),%edx
  803520:	89 10                	mov    %edx,(%eax)
  803522:	eb 0a                	jmp    80352e <realloc_block_FF+0x471>
  803524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803527:	8b 00                	mov    (%eax),%eax
  803529:	a3 48 50 98 00       	mov    %eax,0x985048
  80352e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803531:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803541:	a1 54 50 98 00       	mov    0x985054,%eax
  803546:	48                   	dec    %eax
  803547:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  80354c:	83 ec 0c             	sub    $0xc,%esp
  80354f:	ff 75 d4             	pushl  -0x2c(%ebp)
  803552:	e8 8d f0 ff ff       	call   8025e4 <insert_sorted_in_freeList>
  803557:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  80355a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80355d:	eb 05                	jmp    803564 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  80355f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803564:	c9                   	leave  
  803565:	c3                   	ret    

00803566 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803566:	55                   	push   %ebp
  803567:	89 e5                	mov    %esp,%ebp
  803569:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80356c:	83 ec 04             	sub    $0x4,%esp
  80356f:	68 00 42 80 00       	push   $0x804200
  803574:	68 20 02 00 00       	push   $0x220
  803579:	68 37 41 80 00       	push   $0x804137
  80357e:	e8 cf cf ff ff       	call   800552 <_panic>

00803583 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803583:	55                   	push   %ebp
  803584:	89 e5                	mov    %esp,%ebp
  803586:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803589:	83 ec 04             	sub    $0x4,%esp
  80358c:	68 28 42 80 00       	push   $0x804228
  803591:	68 28 02 00 00       	push   $0x228
  803596:	68 37 41 80 00       	push   $0x804137
  80359b:	e8 b2 cf ff ff       	call   800552 <_panic>

008035a0 <__udivdi3>:
  8035a0:	55                   	push   %ebp
  8035a1:	57                   	push   %edi
  8035a2:	56                   	push   %esi
  8035a3:	53                   	push   %ebx
  8035a4:	83 ec 1c             	sub    $0x1c,%esp
  8035a7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8035ab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8035af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035b7:	89 ca                	mov    %ecx,%edx
  8035b9:	89 f8                	mov    %edi,%eax
  8035bb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8035bf:	85 f6                	test   %esi,%esi
  8035c1:	75 2d                	jne    8035f0 <__udivdi3+0x50>
  8035c3:	39 cf                	cmp    %ecx,%edi
  8035c5:	77 65                	ja     80362c <__udivdi3+0x8c>
  8035c7:	89 fd                	mov    %edi,%ebp
  8035c9:	85 ff                	test   %edi,%edi
  8035cb:	75 0b                	jne    8035d8 <__udivdi3+0x38>
  8035cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8035d2:	31 d2                	xor    %edx,%edx
  8035d4:	f7 f7                	div    %edi
  8035d6:	89 c5                	mov    %eax,%ebp
  8035d8:	31 d2                	xor    %edx,%edx
  8035da:	89 c8                	mov    %ecx,%eax
  8035dc:	f7 f5                	div    %ebp
  8035de:	89 c1                	mov    %eax,%ecx
  8035e0:	89 d8                	mov    %ebx,%eax
  8035e2:	f7 f5                	div    %ebp
  8035e4:	89 cf                	mov    %ecx,%edi
  8035e6:	89 fa                	mov    %edi,%edx
  8035e8:	83 c4 1c             	add    $0x1c,%esp
  8035eb:	5b                   	pop    %ebx
  8035ec:	5e                   	pop    %esi
  8035ed:	5f                   	pop    %edi
  8035ee:	5d                   	pop    %ebp
  8035ef:	c3                   	ret    
  8035f0:	39 ce                	cmp    %ecx,%esi
  8035f2:	77 28                	ja     80361c <__udivdi3+0x7c>
  8035f4:	0f bd fe             	bsr    %esi,%edi
  8035f7:	83 f7 1f             	xor    $0x1f,%edi
  8035fa:	75 40                	jne    80363c <__udivdi3+0x9c>
  8035fc:	39 ce                	cmp    %ecx,%esi
  8035fe:	72 0a                	jb     80360a <__udivdi3+0x6a>
  803600:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803604:	0f 87 9e 00 00 00    	ja     8036a8 <__udivdi3+0x108>
  80360a:	b8 01 00 00 00       	mov    $0x1,%eax
  80360f:	89 fa                	mov    %edi,%edx
  803611:	83 c4 1c             	add    $0x1c,%esp
  803614:	5b                   	pop    %ebx
  803615:	5e                   	pop    %esi
  803616:	5f                   	pop    %edi
  803617:	5d                   	pop    %ebp
  803618:	c3                   	ret    
  803619:	8d 76 00             	lea    0x0(%esi),%esi
  80361c:	31 ff                	xor    %edi,%edi
  80361e:	31 c0                	xor    %eax,%eax
  803620:	89 fa                	mov    %edi,%edx
  803622:	83 c4 1c             	add    $0x1c,%esp
  803625:	5b                   	pop    %ebx
  803626:	5e                   	pop    %esi
  803627:	5f                   	pop    %edi
  803628:	5d                   	pop    %ebp
  803629:	c3                   	ret    
  80362a:	66 90                	xchg   %ax,%ax
  80362c:	89 d8                	mov    %ebx,%eax
  80362e:	f7 f7                	div    %edi
  803630:	31 ff                	xor    %edi,%edi
  803632:	89 fa                	mov    %edi,%edx
  803634:	83 c4 1c             	add    $0x1c,%esp
  803637:	5b                   	pop    %ebx
  803638:	5e                   	pop    %esi
  803639:	5f                   	pop    %edi
  80363a:	5d                   	pop    %ebp
  80363b:	c3                   	ret    
  80363c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803641:	89 eb                	mov    %ebp,%ebx
  803643:	29 fb                	sub    %edi,%ebx
  803645:	89 f9                	mov    %edi,%ecx
  803647:	d3 e6                	shl    %cl,%esi
  803649:	89 c5                	mov    %eax,%ebp
  80364b:	88 d9                	mov    %bl,%cl
  80364d:	d3 ed                	shr    %cl,%ebp
  80364f:	89 e9                	mov    %ebp,%ecx
  803651:	09 f1                	or     %esi,%ecx
  803653:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803657:	89 f9                	mov    %edi,%ecx
  803659:	d3 e0                	shl    %cl,%eax
  80365b:	89 c5                	mov    %eax,%ebp
  80365d:	89 d6                	mov    %edx,%esi
  80365f:	88 d9                	mov    %bl,%cl
  803661:	d3 ee                	shr    %cl,%esi
  803663:	89 f9                	mov    %edi,%ecx
  803665:	d3 e2                	shl    %cl,%edx
  803667:	8b 44 24 08          	mov    0x8(%esp),%eax
  80366b:	88 d9                	mov    %bl,%cl
  80366d:	d3 e8                	shr    %cl,%eax
  80366f:	09 c2                	or     %eax,%edx
  803671:	89 d0                	mov    %edx,%eax
  803673:	89 f2                	mov    %esi,%edx
  803675:	f7 74 24 0c          	divl   0xc(%esp)
  803679:	89 d6                	mov    %edx,%esi
  80367b:	89 c3                	mov    %eax,%ebx
  80367d:	f7 e5                	mul    %ebp
  80367f:	39 d6                	cmp    %edx,%esi
  803681:	72 19                	jb     80369c <__udivdi3+0xfc>
  803683:	74 0b                	je     803690 <__udivdi3+0xf0>
  803685:	89 d8                	mov    %ebx,%eax
  803687:	31 ff                	xor    %edi,%edi
  803689:	e9 58 ff ff ff       	jmp    8035e6 <__udivdi3+0x46>
  80368e:	66 90                	xchg   %ax,%ax
  803690:	8b 54 24 08          	mov    0x8(%esp),%edx
  803694:	89 f9                	mov    %edi,%ecx
  803696:	d3 e2                	shl    %cl,%edx
  803698:	39 c2                	cmp    %eax,%edx
  80369a:	73 e9                	jae    803685 <__udivdi3+0xe5>
  80369c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80369f:	31 ff                	xor    %edi,%edi
  8036a1:	e9 40 ff ff ff       	jmp    8035e6 <__udivdi3+0x46>
  8036a6:	66 90                	xchg   %ax,%ax
  8036a8:	31 c0                	xor    %eax,%eax
  8036aa:	e9 37 ff ff ff       	jmp    8035e6 <__udivdi3+0x46>
  8036af:	90                   	nop

008036b0 <__umoddi3>:
  8036b0:	55                   	push   %ebp
  8036b1:	57                   	push   %edi
  8036b2:	56                   	push   %esi
  8036b3:	53                   	push   %ebx
  8036b4:	83 ec 1c             	sub    $0x1c,%esp
  8036b7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8036bb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8036bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036c3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8036c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036cf:	89 f3                	mov    %esi,%ebx
  8036d1:	89 fa                	mov    %edi,%edx
  8036d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036d7:	89 34 24             	mov    %esi,(%esp)
  8036da:	85 c0                	test   %eax,%eax
  8036dc:	75 1a                	jne    8036f8 <__umoddi3+0x48>
  8036de:	39 f7                	cmp    %esi,%edi
  8036e0:	0f 86 a2 00 00 00    	jbe    803788 <__umoddi3+0xd8>
  8036e6:	89 c8                	mov    %ecx,%eax
  8036e8:	89 f2                	mov    %esi,%edx
  8036ea:	f7 f7                	div    %edi
  8036ec:	89 d0                	mov    %edx,%eax
  8036ee:	31 d2                	xor    %edx,%edx
  8036f0:	83 c4 1c             	add    $0x1c,%esp
  8036f3:	5b                   	pop    %ebx
  8036f4:	5e                   	pop    %esi
  8036f5:	5f                   	pop    %edi
  8036f6:	5d                   	pop    %ebp
  8036f7:	c3                   	ret    
  8036f8:	39 f0                	cmp    %esi,%eax
  8036fa:	0f 87 ac 00 00 00    	ja     8037ac <__umoddi3+0xfc>
  803700:	0f bd e8             	bsr    %eax,%ebp
  803703:	83 f5 1f             	xor    $0x1f,%ebp
  803706:	0f 84 ac 00 00 00    	je     8037b8 <__umoddi3+0x108>
  80370c:	bf 20 00 00 00       	mov    $0x20,%edi
  803711:	29 ef                	sub    %ebp,%edi
  803713:	89 fe                	mov    %edi,%esi
  803715:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803719:	89 e9                	mov    %ebp,%ecx
  80371b:	d3 e0                	shl    %cl,%eax
  80371d:	89 d7                	mov    %edx,%edi
  80371f:	89 f1                	mov    %esi,%ecx
  803721:	d3 ef                	shr    %cl,%edi
  803723:	09 c7                	or     %eax,%edi
  803725:	89 e9                	mov    %ebp,%ecx
  803727:	d3 e2                	shl    %cl,%edx
  803729:	89 14 24             	mov    %edx,(%esp)
  80372c:	89 d8                	mov    %ebx,%eax
  80372e:	d3 e0                	shl    %cl,%eax
  803730:	89 c2                	mov    %eax,%edx
  803732:	8b 44 24 08          	mov    0x8(%esp),%eax
  803736:	d3 e0                	shl    %cl,%eax
  803738:	89 44 24 04          	mov    %eax,0x4(%esp)
  80373c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803740:	89 f1                	mov    %esi,%ecx
  803742:	d3 e8                	shr    %cl,%eax
  803744:	09 d0                	or     %edx,%eax
  803746:	d3 eb                	shr    %cl,%ebx
  803748:	89 da                	mov    %ebx,%edx
  80374a:	f7 f7                	div    %edi
  80374c:	89 d3                	mov    %edx,%ebx
  80374e:	f7 24 24             	mull   (%esp)
  803751:	89 c6                	mov    %eax,%esi
  803753:	89 d1                	mov    %edx,%ecx
  803755:	39 d3                	cmp    %edx,%ebx
  803757:	0f 82 87 00 00 00    	jb     8037e4 <__umoddi3+0x134>
  80375d:	0f 84 91 00 00 00    	je     8037f4 <__umoddi3+0x144>
  803763:	8b 54 24 04          	mov    0x4(%esp),%edx
  803767:	29 f2                	sub    %esi,%edx
  803769:	19 cb                	sbb    %ecx,%ebx
  80376b:	89 d8                	mov    %ebx,%eax
  80376d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803771:	d3 e0                	shl    %cl,%eax
  803773:	89 e9                	mov    %ebp,%ecx
  803775:	d3 ea                	shr    %cl,%edx
  803777:	09 d0                	or     %edx,%eax
  803779:	89 e9                	mov    %ebp,%ecx
  80377b:	d3 eb                	shr    %cl,%ebx
  80377d:	89 da                	mov    %ebx,%edx
  80377f:	83 c4 1c             	add    $0x1c,%esp
  803782:	5b                   	pop    %ebx
  803783:	5e                   	pop    %esi
  803784:	5f                   	pop    %edi
  803785:	5d                   	pop    %ebp
  803786:	c3                   	ret    
  803787:	90                   	nop
  803788:	89 fd                	mov    %edi,%ebp
  80378a:	85 ff                	test   %edi,%edi
  80378c:	75 0b                	jne    803799 <__umoddi3+0xe9>
  80378e:	b8 01 00 00 00       	mov    $0x1,%eax
  803793:	31 d2                	xor    %edx,%edx
  803795:	f7 f7                	div    %edi
  803797:	89 c5                	mov    %eax,%ebp
  803799:	89 f0                	mov    %esi,%eax
  80379b:	31 d2                	xor    %edx,%edx
  80379d:	f7 f5                	div    %ebp
  80379f:	89 c8                	mov    %ecx,%eax
  8037a1:	f7 f5                	div    %ebp
  8037a3:	89 d0                	mov    %edx,%eax
  8037a5:	e9 44 ff ff ff       	jmp    8036ee <__umoddi3+0x3e>
  8037aa:	66 90                	xchg   %ax,%ax
  8037ac:	89 c8                	mov    %ecx,%eax
  8037ae:	89 f2                	mov    %esi,%edx
  8037b0:	83 c4 1c             	add    $0x1c,%esp
  8037b3:	5b                   	pop    %ebx
  8037b4:	5e                   	pop    %esi
  8037b5:	5f                   	pop    %edi
  8037b6:	5d                   	pop    %ebp
  8037b7:	c3                   	ret    
  8037b8:	3b 04 24             	cmp    (%esp),%eax
  8037bb:	72 06                	jb     8037c3 <__umoddi3+0x113>
  8037bd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8037c1:	77 0f                	ja     8037d2 <__umoddi3+0x122>
  8037c3:	89 f2                	mov    %esi,%edx
  8037c5:	29 f9                	sub    %edi,%ecx
  8037c7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037cb:	89 14 24             	mov    %edx,(%esp)
  8037ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037d2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037d6:	8b 14 24             	mov    (%esp),%edx
  8037d9:	83 c4 1c             	add    $0x1c,%esp
  8037dc:	5b                   	pop    %ebx
  8037dd:	5e                   	pop    %esi
  8037de:	5f                   	pop    %edi
  8037df:	5d                   	pop    %ebp
  8037e0:	c3                   	ret    
  8037e1:	8d 76 00             	lea    0x0(%esi),%esi
  8037e4:	2b 04 24             	sub    (%esp),%eax
  8037e7:	19 fa                	sbb    %edi,%edx
  8037e9:	89 d1                	mov    %edx,%ecx
  8037eb:	89 c6                	mov    %eax,%esi
  8037ed:	e9 71 ff ff ff       	jmp    803763 <__umoddi3+0xb3>
  8037f2:	66 90                	xchg   %ax,%ax
  8037f4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037f8:	72 ea                	jb     8037e4 <__umoddi3+0x134>
  8037fa:	89 d9                	mov    %ebx,%ecx
  8037fc:	e9 62 ff ff ff       	jmp    803763 <__umoddi3+0xb3>
