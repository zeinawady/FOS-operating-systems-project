
obj/user/tst_first_fit_3:     file format elf32-i386


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
  800031:	e8 04 10 00 00       	call   80103a <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 1000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 c4 80             	add    $0xffffff80,%esp

	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 75 2d 00 00       	call   802dbf <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80004d:	a1 20 50 80 00       	mov    0x805020,%eax
  800052:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  800058:	a1 20 50 80 00       	mov    0x805020,%eax
  80005d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800063:	39 c2                	cmp    %eax,%edx
  800065:	72 14                	jb     80007b <_main+0x43>
			panic("Please increase the WS size");
  800067:	83 ec 04             	sub    $0x4,%esp
  80006a:	68 40 44 80 00       	push   $0x804440
  80006f:	6a 18                	push   $0x18
  800071:	68 5c 44 80 00       	push   $0x80445c
  800076:	e8 04 11 00 00       	call   80117f <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	int eval = 0;
  80007b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  800082:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	int envID = sys_getenvid();
  800089:	e8 e3 2a 00 00       	call   802b71 <sys_getenvid>
  80008e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//cprintf("2\n");

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800091:	c7 45 e8 00 10 00 82 	movl   $0x82001000,-0x18(%ebp)


	int Mega = 1024*1024;
  800098:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  80009f:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)
	void* ptr_allocations[20] = {0};
  8000a6:	8d 55 80             	lea    -0x80(%ebp),%edx
  8000a9:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b3:	89 d7                	mov    %edx,%edi
  8000b5:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames, expected, diff;
	int usedDiskPages;
	//[1] Allocate all
	cprintf("\n%~[1] Allocate spaces of different sizes in PAGE ALLOCATOR\n");
  8000b7:	83 ec 0c             	sub    $0xc,%esp
  8000ba:	68 74 44 80 00       	push   $0x804474
  8000bf:	e8 78 13 00 00       	call   80143c <cprintf>
  8000c4:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate Shared 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000c7:	e8 f5 28 00 00       	call   8029c1 <sys_calculate_free_frames>
  8000cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000cf:	e8 38 29 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  8000d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[0] = smalloc("x", 1*Mega, 1);
  8000d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000da:	83 ec 04             	sub    $0x4,%esp
  8000dd:	6a 01                	push   $0x1
  8000df:	50                   	push   %eax
  8000e0:	68 b1 44 80 00       	push   $0x8044b1
  8000e5:	e8 b9 23 00 00       	call   8024a3 <smalloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 80             	mov    %eax,-0x80(%ebp)
		if (ptr_allocations[0] != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8000f0:	8b 55 80             	mov    -0x80(%ebp),%edx
  8000f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f6:	39 c2                	cmp    %eax,%edx
  8000f8:	74 17                	je     800111 <_main+0xd9>
  8000fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800101:	83 ec 0c             	sub    $0xc,%esp
  800104:	68 b4 44 80 00       	push   $0x8044b4
  800109:	e8 2e 13 00 00       	call   80143c <cprintf>
  80010e:	83 c4 10             	add    $0x10,%esp
		expected = 256+1; /*256pages +1table*/
  800111:	c7 45 d4 01 01 00 00 	movl   $0x101,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800118:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80011b:	e8 a1 28 00 00       	call   8029c1 <sys_calculate_free_frames>
  800120:	29 c3                	sub    %eax,%ebx
  800122:	89 d8                	mov    %ebx,%eax
  800124:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800127:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80012a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80012d:	7c 0b                	jl     80013a <_main+0x102>
  80012f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800132:	83 c0 02             	add    $0x2,%eax
  800135:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800138:	7d 27                	jge    800161 <_main+0x129>
  80013a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800141:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800144:	e8 78 28 00 00       	call   8029c1 <sys_calculate_free_frames>
  800149:	29 c3                	sub    %eax,%ebx
  80014b:	89 d8                	mov    %ebx,%eax
  80014d:	83 ec 04             	sub    $0x4,%esp
  800150:	ff 75 d4             	pushl  -0x2c(%ebp)
  800153:	50                   	push   %eax
  800154:	68 20 45 80 00       	push   $0x804520
  800159:	e8 de 12 00 00       	call   80143c <cprintf>
  80015e:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800161:	e8 a6 28 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800166:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800169:	74 17                	je     800182 <_main+0x14a>
  80016b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800172:	83 ec 0c             	sub    $0xc,%esp
  800175:	68 b8 45 80 00       	push   $0x8045b8
  80017a:	e8 bd 12 00 00       	call   80143c <cprintf>
  80017f:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800182:	e8 3a 28 00 00       	call   8029c1 <sys_calculate_free_frames>
  800187:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80018a:	e8 7d 28 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  80018f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  800192:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800195:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800198:	83 ec 0c             	sub    $0xc,%esp
  80019b:	50                   	push   %eax
  80019c:	e8 4b 20 00 00       	call   8021ec <malloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[1] != (pagealloc_start + 1*Mega)) {is_correct = 0; cprintf("Wrong start address for the allocated space... ");}
  8001a7:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8001aa:	89 c1                	mov    %eax,%ecx
  8001ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001b2:	01 d0                	add    %edx,%eax
  8001b4:	39 c1                	cmp    %eax,%ecx
  8001b6:	74 17                	je     8001cf <_main+0x197>
  8001b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001bf:	83 ec 0c             	sub    $0xc,%esp
  8001c2:	68 d8 45 80 00       	push   $0x8045d8
  8001c7:	e8 70 12 00 00       	call   80143c <cprintf>
  8001cc:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8001cf:	e8 38 28 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  8001d4:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8001d7:	74 17                	je     8001f0 <_main+0x1b8>
  8001d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001e0:	83 ec 0c             	sub    $0xc,%esp
  8001e3:	68 b8 45 80 00       	push   $0x8045b8
  8001e8:	e8 4f 12 00 00       	call   80143c <cprintf>
  8001ed:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) {is_correct = 0; cprintf("Wrong allocation: ");}
  8001f0:	e8 cc 27 00 00       	call   8029c1 <sys_calculate_free_frames>
  8001f5:	89 c2                	mov    %eax,%edx
  8001f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001fa:	39 c2                	cmp    %eax,%edx
  8001fc:	74 17                	je     800215 <_main+0x1dd>
  8001fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 08 46 80 00       	push   $0x804608
  80020d:	e8 2a 12 00 00       	call   80143c <cprintf>
  800212:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800215:	e8 a7 27 00 00       	call   8029c1 <sys_calculate_free_frames>
  80021a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80021d:	e8 ea 27 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800222:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800225:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800228:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80022b:	83 ec 0c             	sub    $0xc,%esp
  80022e:	50                   	push   %eax
  80022f:	e8 b8 1f 00 00       	call   8021ec <malloc>
  800234:	83 c4 10             	add    $0x10,%esp
  800237:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[2] != (pagealloc_start + 2*Mega)) {is_correct = 0; cprintf("Wrong start address for the allocated space... ");}
  80023a:	8b 45 88             	mov    -0x78(%ebp),%eax
  80023d:	89 c2                	mov    %eax,%edx
  80023f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800242:	01 c0                	add    %eax,%eax
  800244:	89 c1                	mov    %eax,%ecx
  800246:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800249:	01 c8                	add    %ecx,%eax
  80024b:	39 c2                	cmp    %eax,%edx
  80024d:	74 17                	je     800266 <_main+0x22e>
  80024f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	68 d8 45 80 00       	push   $0x8045d8
  80025e:	e8 d9 11 00 00       	call   80143c <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800266:	e8 a1 27 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  80026b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80026e:	74 17                	je     800287 <_main+0x24f>
  800270:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	68 b8 45 80 00       	push   $0x8045b8
  80027f:	e8 b8 11 00 00       	call   80143c <cprintf>
  800284:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800287:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80028e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800291:	e8 2b 27 00 00       	call   8029c1 <sys_calculate_free_frames>
  800296:	29 c3                	sub    %eax,%ebx
  800298:	89 d8                	mov    %ebx,%eax
  80029a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected)
  80029d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002a0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8002a3:	74 1d                	je     8002c2 <_main+0x28a>
		{is_correct = 0; cprintf("Wrong allocation by malloc(): expected = %d, actual = %d", expected, diff);}
  8002a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	ff 75 d0             	pushl  -0x30(%ebp)
  8002b2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002b5:	68 1c 46 80 00       	push   $0x80461c
  8002ba:	e8 7d 11 00 00       	call   80143c <cprintf>
  8002bf:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB (New Table)
		freeFrames = sys_calculate_free_frames() ;
  8002c2:	e8 fa 26 00 00       	call   8029c1 <sys_calculate_free_frames>
  8002c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002ca:	e8 3d 27 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  8002cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  8002d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002d5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002d8:	83 ec 0c             	sub    $0xc,%esp
  8002db:	50                   	push   %eax
  8002dc:	e8 0b 1f 00 00       	call   8021ec <malloc>
  8002e1:	83 c4 10             	add    $0x10,%esp
  8002e4:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[3] != (pagealloc_start + 3*Mega) ) {is_correct = 0; cprintf("Wrong start address for the allocated space... ");}
  8002e7:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8002ea:	89 c1                	mov    %eax,%ecx
  8002ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002ef:	89 c2                	mov    %eax,%edx
  8002f1:	01 d2                	add    %edx,%edx
  8002f3:	01 d0                	add    %edx,%eax
  8002f5:	89 c2                	mov    %eax,%edx
  8002f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002fa:	01 d0                	add    %edx,%eax
  8002fc:	39 c1                	cmp    %eax,%ecx
  8002fe:	74 17                	je     800317 <_main+0x2df>
  800300:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	68 d8 45 80 00       	push   $0x8045d8
  80030f:	e8 28 11 00 00       	call   80143c <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800317:	e8 f0 26 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  80031c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80031f:	74 17                	je     800338 <_main+0x300>
  800321:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800328:	83 ec 0c             	sub    $0xc,%esp
  80032b:	68 b8 45 80 00       	push   $0x8045b8
  800330:	e8 07 11 00 00       	call   80143c <cprintf>
  800335:	83 c4 10             	add    $0x10,%esp
		expected = 1; /*1table since pagealloc_start starts at UH + 32MB + 4KB*/
  800338:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80033f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800342:	e8 7a 26 00 00       	call   8029c1 <sys_calculate_free_frames>
  800347:	29 c3                	sub    %eax,%ebx
  800349:	89 d8                	mov    %ebx,%eax
  80034b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected)
  80034e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800351:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800354:	74 1d                	je     800373 <_main+0x33b>
		{is_correct = 0; cprintf("Wrong allocation by malloc(): expected = %d, actual = %d", expected, diff);}
  800356:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80035d:	83 ec 04             	sub    $0x4,%esp
  800360:	ff 75 d0             	pushl  -0x30(%ebp)
  800363:	ff 75 d4             	pushl  -0x2c(%ebp)
  800366:	68 1c 46 80 00       	push   $0x80461c
  80036b:	e8 cc 10 00 00       	call   80143c <cprintf>
  800370:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800373:	e8 49 26 00 00       	call   8029c1 <sys_calculate_free_frames>
  800378:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80037b:	e8 8c 26 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800380:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800383:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800386:	01 c0                	add    %eax,%eax
  800388:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80038b:	83 ec 0c             	sub    $0xc,%esp
  80038e:	50                   	push   %eax
  80038f:	e8 58 1e 00 00       	call   8021ec <malloc>
  800394:	83 c4 10             	add    $0x10,%esp
  800397:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[4] != (pagealloc_start + 4*Mega)) {is_correct = 0; cprintf("Wrong start address for the allocated space... ");}
  80039a:	8b 45 90             	mov    -0x70(%ebp),%eax
  80039d:	89 c2                	mov    %eax,%edx
  80039f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003a2:	c1 e0 02             	shl    $0x2,%eax
  8003a5:	89 c1                	mov    %eax,%ecx
  8003a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003aa:	01 c8                	add    %ecx,%eax
  8003ac:	39 c2                	cmp    %eax,%edx
  8003ae:	74 17                	je     8003c7 <_main+0x38f>
  8003b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003b7:	83 ec 0c             	sub    $0xc,%esp
  8003ba:	68 d8 45 80 00       	push   $0x8045d8
  8003bf:	e8 78 10 00 00       	call   80143c <cprintf>
  8003c4:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8003c7:	e8 40 26 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  8003cc:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8003cf:	74 17                	je     8003e8 <_main+0x3b0>
  8003d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d8:	83 ec 0c             	sub    $0xc,%esp
  8003db:	68 b8 45 80 00       	push   $0x8045b8
  8003e0:	e8 57 10 00 00       	call   80143c <cprintf>
  8003e5:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  8003e8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8003ef:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8003f2:	e8 ca 25 00 00       	call   8029c1 <sys_calculate_free_frames>
  8003f7:	29 c3                	sub    %eax,%ebx
  8003f9:	89 d8                	mov    %ebx,%eax
  8003fb:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected)
  8003fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800401:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800404:	74 1d                	je     800423 <_main+0x3eb>
		{is_correct = 0; cprintf("Wrong allocation by malloc(): expected = %d, actual = %d", expected, diff);}
  800406:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80040d:	83 ec 04             	sub    $0x4,%esp
  800410:	ff 75 d0             	pushl  -0x30(%ebp)
  800413:	ff 75 d4             	pushl  -0x2c(%ebp)
  800416:	68 1c 46 80 00       	push   $0x80461c
  80041b:	e8 1c 10 00 00       	call   80143c <cprintf>
  800420:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 2 MB (New Table)
		freeFrames = sys_calculate_free_frames() ;
  800423:	e8 99 25 00 00       	call   8029c1 <sys_calculate_free_frames>
  800428:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80042b:	e8 dc 25 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800430:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[5] = smalloc("y", 2*Mega, 1);
  800433:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800436:	01 c0                	add    %eax,%eax
  800438:	83 ec 04             	sub    $0x4,%esp
  80043b:	6a 01                	push   $0x1
  80043d:	50                   	push   %eax
  80043e:	68 55 46 80 00       	push   $0x804655
  800443:	e8 5b 20 00 00       	call   8024a3 <smalloc>
  800448:	83 c4 10             	add    $0x10,%esp
  80044b:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if (ptr_allocations[5] != (uint32*)(pagealloc_start + 6*Mega))
  80044e:	8b 4d 94             	mov    -0x6c(%ebp),%ecx
  800451:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800454:	89 d0                	mov    %edx,%eax
  800456:	01 c0                	add    %eax,%eax
  800458:	01 d0                	add    %edx,%eax
  80045a:	01 c0                	add    %eax,%eax
  80045c:	89 c2                	mov    %eax,%edx
  80045e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800461:	01 d0                	add    %edx,%eax
  800463:	39 c1                	cmp    %eax,%ecx
  800465:	74 17                	je     80047e <_main+0x446>
		{is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800467:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80046e:	83 ec 0c             	sub    $0xc,%esp
  800471:	68 b4 44 80 00       	push   $0x8044b4
  800476:	e8 c1 0f 00 00       	call   80143c <cprintf>
  80047b:	83 c4 10             	add    $0x10,%esp
		expected = 512+1; /*512pages +1table*/
  80047e:	c7 45 d4 01 02 00 00 	movl   $0x201,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800485:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800488:	e8 34 25 00 00       	call   8029c1 <sys_calculate_free_frames>
  80048d:	29 c3                	sub    %eax,%ebx
  80048f:	89 d8                	mov    %ebx,%eax
  800491:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/)
  800494:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800497:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80049a:	7c 0b                	jl     8004a7 <_main+0x46f>
  80049c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80049f:	83 c0 02             	add    $0x2,%eax
  8004a2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8004a5:	7d 27                	jge    8004ce <_main+0x496>
		{is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8004a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ae:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8004b1:	e8 0b 25 00 00       	call   8029c1 <sys_calculate_free_frames>
  8004b6:	29 c3                	sub    %eax,%ebx
  8004b8:	89 d8                	mov    %ebx,%eax
  8004ba:	83 ec 04             	sub    $0x4,%esp
  8004bd:	ff 75 d4             	pushl  -0x2c(%ebp)
  8004c0:	50                   	push   %eax
  8004c1:	68 20 45 80 00       	push   $0x804520
  8004c6:	e8 71 0f 00 00       	call   80143c <cprintf>
  8004cb:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8004ce:	e8 39 25 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  8004d3:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8004d6:	74 17                	je     8004ef <_main+0x4b7>
  8004d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004df:	83 ec 0c             	sub    $0xc,%esp
  8004e2:	68 b8 45 80 00       	push   $0x8045b8
  8004e7:	e8 50 0f 00 00       	call   80143c <cprintf>
  8004ec:	83 c4 10             	add    $0x10,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004ef:	e8 cd 24 00 00       	call   8029c1 <sys_calculate_free_frames>
  8004f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f7:	e8 10 25 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  8004fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8004ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800502:	89 c2                	mov    %eax,%edx
  800504:	01 d2                	add    %edx,%edx
  800506:	01 d0                	add    %edx,%eax
  800508:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80050b:	83 ec 0c             	sub    $0xc,%esp
  80050e:	50                   	push   %eax
  80050f:	e8 d8 1c 00 00       	call   8021ec <malloc>
  800514:	83 c4 10             	add    $0x10,%esp
  800517:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[6] != (pagealloc_start + 8*Mega)) {is_correct = 0; cprintf("Wrong start address for the allocated space... ");}
  80051a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80051d:	89 c2                	mov    %eax,%edx
  80051f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800522:	c1 e0 03             	shl    $0x3,%eax
  800525:	89 c1                	mov    %eax,%ecx
  800527:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80052a:	01 c8                	add    %ecx,%eax
  80052c:	39 c2                	cmp    %eax,%edx
  80052e:	74 17                	je     800547 <_main+0x50f>
  800530:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800537:	83 ec 0c             	sub    $0xc,%esp
  80053a:	68 d8 45 80 00       	push   $0x8045d8
  80053f:	e8 f8 0e 00 00       	call   80143c <cprintf>
  800544:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800547:	e8 c0 24 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  80054c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80054f:	74 17                	je     800568 <_main+0x530>
  800551:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800558:	83 ec 0c             	sub    $0xc,%esp
  80055b:	68 b8 45 80 00       	push   $0x8045b8
  800560:	e8 d7 0e 00 00       	call   80143c <cprintf>
  800565:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800568:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80056f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800572:	e8 4a 24 00 00       	call   8029c1 <sys_calculate_free_frames>
  800577:	29 c3                	sub    %eax,%ebx
  800579:	89 d8                	mov    %ebx,%eax
  80057b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong allocation by malloc(): expected = %d, actual = %d", expected, diff);}
  80057e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800581:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800584:	74 1d                	je     8005a3 <_main+0x56b>
  800586:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80058d:	83 ec 04             	sub    $0x4,%esp
  800590:	ff 75 d0             	pushl  -0x30(%ebp)
  800593:	ff 75 d4             	pushl  -0x2c(%ebp)
  800596:	68 1c 46 80 00       	push   $0x80461c
  80059b:	e8 9c 0e 00 00       	call   80143c <cprintf>
  8005a0:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 3 MB (New Table)
		freeFrames = sys_calculate_free_frames() ;
  8005a3:	e8 19 24 00 00       	call   8029c1 <sys_calculate_free_frames>
  8005a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005ab:	e8 5c 24 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  8005b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[7] = smalloc("z", 3*Mega, 0);
  8005b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005b6:	89 c2                	mov    %eax,%edx
  8005b8:	01 d2                	add    %edx,%edx
  8005ba:	01 d0                	add    %edx,%eax
  8005bc:	83 ec 04             	sub    $0x4,%esp
  8005bf:	6a 00                	push   $0x0
  8005c1:	50                   	push   %eax
  8005c2:	68 57 46 80 00       	push   $0x804657
  8005c7:	e8 d7 1e 00 00       	call   8024a3 <smalloc>
  8005cc:	83 c4 10             	add    $0x10,%esp
  8005cf:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if (ptr_allocations[7] != (uint32*)(pagealloc_start + 11*Mega)) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8005d2:	8b 4d 9c             	mov    -0x64(%ebp),%ecx
  8005d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005d8:	89 d0                	mov    %edx,%eax
  8005da:	c1 e0 02             	shl    $0x2,%eax
  8005dd:	01 d0                	add    %edx,%eax
  8005df:	01 c0                	add    %eax,%eax
  8005e1:	01 d0                	add    %edx,%eax
  8005e3:	89 c2                	mov    %eax,%edx
  8005e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e8:	01 d0                	add    %edx,%eax
  8005ea:	39 c1                	cmp    %eax,%ecx
  8005ec:	74 17                	je     800605 <_main+0x5cd>
  8005ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005f5:	83 ec 0c             	sub    $0xc,%esp
  8005f8:	68 b4 44 80 00       	push   $0x8044b4
  8005fd:	e8 3a 0e 00 00       	call   80143c <cprintf>
  800602:	83 c4 10             	add    $0x10,%esp
		expected = 768+1+1; /*768pages +1table +1page for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  800605:	c7 45 d4 02 03 00 00 	movl   $0x302,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80060c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80060f:	e8 ad 23 00 00       	call   8029c1 <sys_calculate_free_frames>
  800614:	29 c3                	sub    %eax,%ebx
  800616:	89 d8                	mov    %ebx,%eax
  800618:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/)
  80061b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80061e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800621:	7c 0b                	jl     80062e <_main+0x5f6>
  800623:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800626:	83 c0 02             	add    $0x2,%eax
  800629:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80062c:	7d 27                	jge    800655 <_main+0x61d>
		{is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  80062e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800635:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800638:	e8 84 23 00 00       	call   8029c1 <sys_calculate_free_frames>
  80063d:	29 c3                	sub    %eax,%ebx
  80063f:	89 d8                	mov    %ebx,%eax
  800641:	83 ec 04             	sub    $0x4,%esp
  800644:	ff 75 d4             	pushl  -0x2c(%ebp)
  800647:	50                   	push   %eax
  800648:	68 20 45 80 00       	push   $0x804520
  80064d:	e8 ea 0d 00 00       	call   80143c <cprintf>
  800652:	83 c4 10             	add    $0x10,%esp
		//		if ((freeFrames - sys_calculate_free_frames()) !=  768+2+2) {is_correct = 0; cprintf("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800655:	e8 b2 23 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  80065a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80065d:	74 17                	je     800676 <_main+0x63e>
  80065f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800666:	83 ec 0c             	sub    $0xc,%esp
  800669:	68 b8 45 80 00       	push   $0x8045b8
  80066e:	e8 c9 0d 00 00       	call   80143c <cprintf>
  800673:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=10;
  800676:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80067a:	74 04                	je     800680 <_main+0x648>
  80067c:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
	is_correct = 1;
  800680:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//[2] Free some to create holes
	cprintf("\n%~[2] Free some to create holes\n");
  800687:	83 ec 0c             	sub    $0xc,%esp
  80068a:	68 5c 46 80 00       	push   $0x80465c
  80068f:	e8 a8 0d 00 00       	call   80143c <cprintf>
  800694:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800697:	e8 25 23 00 00       	call   8029c1 <sys_calculate_free_frames>
  80069c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80069f:	e8 68 23 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  8006a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[1]);
  8006a7:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8006aa:	83 ec 0c             	sub    $0xc,%esp
  8006ad:	50                   	push   %eax
  8006ae:	e8 ef 1c 00 00       	call   8023a2 <free>
  8006b3:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  8006b6:	e8 51 23 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  8006bb:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8006be:	74 17                	je     8006d7 <_main+0x69f>
  8006c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006c7:	83 ec 0c             	sub    $0xc,%esp
  8006ca:	68 7e 46 80 00       	push   $0x80467e
  8006cf:	e8 68 0d 00 00       	call   80143c <cprintf>
  8006d4:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  8006d7:	e8 e5 22 00 00       	call   8029c1 <sys_calculate_free_frames>
  8006dc:	89 c2                	mov    %eax,%edx
  8006de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006e1:	39 c2                	cmp    %eax,%edx
  8006e3:	74 17                	je     8006fc <_main+0x6c4>
  8006e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006ec:	83 ec 0c             	sub    $0xc,%esp
  8006ef:	68 95 46 80 00       	push   $0x804695
  8006f4:	e8 43 0d 00 00       	call   80143c <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006fc:	e8 c0 22 00 00       	call   8029c1 <sys_calculate_free_frames>
  800701:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800704:	e8 03 23 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800709:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[4]);
  80070c:	8b 45 90             	mov    -0x70(%ebp),%eax
  80070f:	83 ec 0c             	sub    $0xc,%esp
  800712:	50                   	push   %eax
  800713:	e8 8a 1c 00 00       	call   8023a2 <free>
  800718:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  80071b:	e8 ec 22 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800720:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800723:	74 17                	je     80073c <_main+0x704>
  800725:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80072c:	83 ec 0c             	sub    $0xc,%esp
  80072f:	68 7e 46 80 00       	push   $0x80467e
  800734:	e8 03 0d 00 00       	call   80143c <cprintf>
  800739:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  80073c:	e8 80 22 00 00       	call   8029c1 <sys_calculate_free_frames>
  800741:	89 c2                	mov    %eax,%edx
  800743:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800746:	39 c2                	cmp    %eax,%edx
  800748:	74 17                	je     800761 <_main+0x729>
  80074a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800751:	83 ec 0c             	sub    $0xc,%esp
  800754:	68 95 46 80 00       	push   $0x804695
  800759:	e8 de 0c 00 00       	call   80143c <cprintf>
  80075e:	83 c4 10             	add    $0x10,%esp

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800761:	e8 5b 22 00 00       	call   8029c1 <sys_calculate_free_frames>
  800766:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800769:	e8 9e 22 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  80076e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[6]);
  800771:	8b 45 98             	mov    -0x68(%ebp),%eax
  800774:	83 ec 0c             	sub    $0xc,%esp
  800777:	50                   	push   %eax
  800778:	e8 25 1c 00 00       	call   8023a2 <free>
  80077d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  800780:	e8 87 22 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800785:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800788:	74 17                	je     8007a1 <_main+0x769>
  80078a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800791:	83 ec 0c             	sub    $0xc,%esp
  800794:	68 7e 46 80 00       	push   $0x80467e
  800799:	e8 9e 0c 00 00       	call   80143c <cprintf>
  80079e:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  8007a1:	e8 1b 22 00 00       	call   8029c1 <sys_calculate_free_frames>
  8007a6:	89 c2                	mov    %eax,%edx
  8007a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007ab:	39 c2                	cmp    %eax,%edx
  8007ad:	74 17                	je     8007c6 <_main+0x78e>
  8007af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007b6:	83 ec 0c             	sub    $0xc,%esp
  8007b9:	68 95 46 80 00       	push   $0x804695
  8007be:	e8 79 0c 00 00       	call   80143c <cprintf>
  8007c3:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=10;
  8007c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8007ca:	74 04                	je     8007d0 <_main+0x798>
  8007cc:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
	is_correct = 1;
  8007d0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//[3] Allocate again [test first fit]
	cprintf("\n%~[3] Allocate again [test first fit]\n");
  8007d7:	83 ec 0c             	sub    $0xc,%esp
  8007da:	68 a4 46 80 00       	push   $0x8046a4
  8007df:	e8 58 0c 00 00       	call   80143c <cprintf>
  8007e4:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007e7:	e8 d5 21 00 00       	call   8029c1 <sys_calculate_free_frames>
  8007ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007ef:	e8 18 22 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  8007f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  8007f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007fa:	89 d0                	mov    %edx,%eax
  8007fc:	c1 e0 09             	shl    $0x9,%eax
  8007ff:	29 d0                	sub    %edx,%eax
  800801:	83 ec 0c             	sub    $0xc,%esp
  800804:	50                   	push   %eax
  800805:	e8 e2 19 00 00       	call   8021ec <malloc>
  80080a:	83 c4 10             	add    $0x10,%esp
  80080d:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[8] != (pagealloc_start + 1*Mega))
  800810:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800813:	89 c1                	mov    %eax,%ecx
  800815:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800818:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80081b:	01 d0                	add    %edx,%eax
  80081d:	39 c1                	cmp    %eax,%ecx
  80081f:	74 17                	je     800838 <_main+0x800>
		{is_correct = 0; cprintf("Wrong start address for the allocated space... ");}
  800821:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800828:	83 ec 0c             	sub    $0xc,%esp
  80082b:	68 d8 45 80 00       	push   $0x8045d8
  800830:	e8 07 0c 00 00       	call   80143c <cprintf>
  800835:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 128) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800838:	e8 cf 21 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  80083d:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800840:	74 17                	je     800859 <_main+0x821>
  800842:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800849:	83 ec 0c             	sub    $0xc,%esp
  80084c:	68 b8 45 80 00       	push   $0x8045b8
  800851:	e8 e6 0b 00 00       	call   80143c <cprintf>
  800856:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800859:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800860:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800863:	e8 59 21 00 00       	call   8029c1 <sys_calculate_free_frames>
  800868:	29 c3                	sub    %eax,%ebx
  80086a:	89 d8                	mov    %ebx,%eax
  80086c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong allocation by malloc(): expected = %d, actual = %d", expected, diff);}
  80086f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800872:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800875:	74 1d                	je     800894 <_main+0x85c>
  800877:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80087e:	83 ec 04             	sub    $0x4,%esp
  800881:	ff 75 d0             	pushl  -0x30(%ebp)
  800884:	ff 75 d4             	pushl  -0x2c(%ebp)
  800887:	68 1c 46 80 00       	push   $0x80461c
  80088c:	e8 ab 0b 00 00       	call   80143c <cprintf>
  800891:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800894:	e8 28 21 00 00       	call   8029c1 <sys_calculate_free_frames>
  800899:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80089c:	e8 6b 21 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  8008a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  8008a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008a7:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8008aa:	83 ec 0c             	sub    $0xc,%esp
  8008ad:	50                   	push   %eax
  8008ae:	e8 39 19 00 00       	call   8021ec <malloc>
  8008b3:	83 c4 10             	add    $0x10,%esp
  8008b6:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[9] != (pagealloc_start + 4*Mega)) {is_correct = 0; cprintf("Wrong start address for the allocated space... ");}
  8008b9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8008bc:	89 c2                	mov    %eax,%edx
  8008be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008c1:	c1 e0 02             	shl    $0x2,%eax
  8008c4:	89 c1                	mov    %eax,%ecx
  8008c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008c9:	01 c8                	add    %ecx,%eax
  8008cb:	39 c2                	cmp    %eax,%edx
  8008cd:	74 17                	je     8008e6 <_main+0x8ae>
  8008cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008d6:	83 ec 0c             	sub    $0xc,%esp
  8008d9:	68 d8 45 80 00       	push   $0x8045d8
  8008de:	e8 59 0b 00 00       	call   80143c <cprintf>
  8008e3:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8008e6:	e8 21 21 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  8008eb:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8008ee:	74 17                	je     800907 <_main+0x8cf>
  8008f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008f7:	83 ec 0c             	sub    $0xc,%esp
  8008fa:	68 b8 45 80 00       	push   $0x8045b8
  8008ff:	e8 38 0b 00 00       	call   80143c <cprintf>
  800904:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800907:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80090e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800911:	e8 ab 20 00 00       	call   8029c1 <sys_calculate_free_frames>
  800916:	29 c3                	sub    %eax,%ebx
  800918:	89 d8                	mov    %ebx,%eax
  80091a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong allocation by malloc(): expected = %d, actual = %d", expected, diff);}
  80091d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800920:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800923:	74 1d                	je     800942 <_main+0x90a>
  800925:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80092c:	83 ec 04             	sub    $0x4,%esp
  80092f:	ff 75 d0             	pushl  -0x30(%ebp)
  800932:	ff 75 d4             	pushl  -0x2c(%ebp)
  800935:	68 1c 46 80 00       	push   $0x80461c
  80093a:	e8 fd 0a 00 00       	call   80143c <cprintf>
  80093f:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800942:	e8 7a 20 00 00       	call   8029c1 <sys_calculate_free_frames>
  800947:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80094a:	e8 bd 20 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  80094f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		//ptr_allocations[10] = malloc(256*kilo - kilo);
		ptr_allocations[10] = smalloc("a", 256*kilo - kilo, 0);
  800952:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800955:	89 d0                	mov    %edx,%eax
  800957:	c1 e0 08             	shl    $0x8,%eax
  80095a:	29 d0                	sub    %edx,%eax
  80095c:	83 ec 04             	sub    $0x4,%esp
  80095f:	6a 00                	push   $0x0
  800961:	50                   	push   %eax
  800962:	68 cc 46 80 00       	push   $0x8046cc
  800967:	e8 37 1b 00 00       	call   8024a3 <smalloc>
  80096c:	83 c4 10             	add    $0x10,%esp
  80096f:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[10] != (pagealloc_start + 1*Mega + 512*kilo)) {is_correct = 0; cprintf("Wrong start address for the allocated space... ");}
  800972:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800975:	89 c1                	mov    %eax,%ecx
  800977:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80097a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80097d:	01 c2                	add    %eax,%edx
  80097f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800982:	c1 e0 09             	shl    $0x9,%eax
  800985:	01 d0                	add    %edx,%eax
  800987:	39 c1                	cmp    %eax,%ecx
  800989:	74 17                	je     8009a2 <_main+0x96a>
  80098b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800992:	83 ec 0c             	sub    $0xc,%esp
  800995:	68 d8 45 80 00       	push   $0x8045d8
  80099a:	e8 9d 0a 00 00       	call   80143c <cprintf>
  80099f:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8009a2:	e8 65 20 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  8009a7:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8009aa:	74 17                	je     8009c3 <_main+0x98b>
  8009ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009b3:	83 ec 0c             	sub    $0xc,%esp
  8009b6:	68 b8 45 80 00       	push   $0x8045b8
  8009bb:	e8 7c 0a 00 00       	call   80143c <cprintf>
  8009c0:	83 c4 10             	add    $0x10,%esp
		expected = 64; /*64pages*/
  8009c3:	c7 45 d4 40 00 00 00 	movl   $0x40,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8009ca:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8009cd:	e8 ef 1f 00 00       	call   8029c1 <sys_calculate_free_frames>
  8009d2:	29 c3                	sub    %eax,%ebx
  8009d4:	89 d8                	mov    %ebx,%eax
  8009d6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8009d9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8009dc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8009df:	7c 0b                	jl     8009ec <_main+0x9b4>
  8009e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009e4:	83 c0 02             	add    $0x2,%eax
  8009e7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8009ea:	7d 27                	jge    800a13 <_main+0x9db>
  8009ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009f3:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8009f6:	e8 c6 1f 00 00       	call   8029c1 <sys_calculate_free_frames>
  8009fb:	29 c3                	sub    %eax,%ebx
  8009fd:	89 d8                	mov    %ebx,%eax
  8009ff:	83 ec 04             	sub    $0x4,%esp
  800a02:	ff 75 d4             	pushl  -0x2c(%ebp)
  800a05:	50                   	push   %eax
  800a06:	68 20 45 80 00       	push   $0x804520
  800a0b:	e8 2c 0a 00 00       	call   80143c <cprintf>
  800a10:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800a13:	e8 a9 1f 00 00       	call   8029c1 <sys_calculate_free_frames>
  800a18:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a1b:	e8 ec 1f 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800a20:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  800a23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a26:	01 c0                	add    %eax,%eax
  800a28:	83 ec 0c             	sub    $0xc,%esp
  800a2b:	50                   	push   %eax
  800a2c:	e8 bb 17 00 00       	call   8021ec <malloc>
  800a31:	83 c4 10             	add    $0x10,%esp
  800a34:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[11] != (pagealloc_start + 8*Mega)) {is_correct = 0; cprintf("Wrong start address for the allocated space... ");}
  800a37:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800a3a:	89 c2                	mov    %eax,%edx
  800a3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a3f:	c1 e0 03             	shl    $0x3,%eax
  800a42:	89 c1                	mov    %eax,%ecx
  800a44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a47:	01 c8                	add    %ecx,%eax
  800a49:	39 c2                	cmp    %eax,%edx
  800a4b:	74 17                	je     800a64 <_main+0xa2c>
  800a4d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a54:	83 ec 0c             	sub    $0xc,%esp
  800a57:	68 d8 45 80 00       	push   $0x8045d8
  800a5c:	e8 db 09 00 00       	call   80143c <cprintf>
  800a61:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800a64:	e8 a3 1f 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800a69:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800a6c:	74 17                	je     800a85 <_main+0xa4d>
  800a6e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a75:	83 ec 0c             	sub    $0xc,%esp
  800a78:	68 b8 45 80 00       	push   $0x8045b8
  800a7d:	e8 ba 09 00 00       	call   80143c <cprintf>
  800a82:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800a85:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800a8c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800a8f:	e8 2d 1f 00 00       	call   8029c1 <sys_calculate_free_frames>
  800a94:	29 c3                	sub    %eax,%ebx
  800a96:	89 d8                	mov    %ebx,%eax
  800a98:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong allocation by malloc(): expected = %d, actual = %d", expected, diff);}
  800a9b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a9e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800aa1:	74 1d                	je     800ac0 <_main+0xa88>
  800aa3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800aaa:	83 ec 04             	sub    $0x4,%esp
  800aad:	ff 75 d0             	pushl  -0x30(%ebp)
  800ab0:	ff 75 d4             	pushl  -0x2c(%ebp)
  800ab3:	68 1c 46 80 00       	push   $0x80461c
  800ab8:	e8 7f 09 00 00       	call   80143c <cprintf>
  800abd:	83 c4 10             	add    $0x10,%esp

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800ac0:	e8 fc 1e 00 00       	call   8029c1 <sys_calculate_free_frames>
  800ac5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800ac8:	e8 3f 1f 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800acd:	89 45 d8             	mov    %eax,-0x28(%ebp)
		//ptr_allocations[12] = malloc(4*Mega - kilo);
		ptr_allocations[12] = smalloc("b", 4*Mega - kilo, 0);
  800ad0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ad3:	c1 e0 02             	shl    $0x2,%eax
  800ad6:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	6a 00                	push   $0x0
  800ade:	50                   	push   %eax
  800adf:	68 ce 46 80 00       	push   $0x8046ce
  800ae4:	e8 ba 19 00 00       	call   8024a3 <smalloc>
  800ae9:	83 c4 10             	add    $0x10,%esp
  800aec:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[12] != (pagealloc_start + 14*Mega) ) {is_correct = 0; cprintf("Wrong start address for the allocated space... ");}
  800aef:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800af2:	89 c1                	mov    %eax,%ecx
  800af4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800af7:	89 d0                	mov    %edx,%eax
  800af9:	01 c0                	add    %eax,%eax
  800afb:	01 d0                	add    %edx,%eax
  800afd:	01 c0                	add    %eax,%eax
  800aff:	01 d0                	add    %edx,%eax
  800b01:	01 c0                	add    %eax,%eax
  800b03:	89 c2                	mov    %eax,%edx
  800b05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b08:	01 d0                	add    %edx,%eax
  800b0a:	39 c1                	cmp    %eax,%ecx
  800b0c:	74 17                	je     800b25 <_main+0xaed>
  800b0e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b15:	83 ec 0c             	sub    $0xc,%esp
  800b18:	68 d8 45 80 00       	push   $0x8045d8
  800b1d:	e8 1a 09 00 00       	call   80143c <cprintf>
  800b22:	83 c4 10             	add    $0x10,%esp
		expected = 1024+1+1; /*1024pages +1table +1page for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  800b25:	c7 45 d4 02 04 00 00 	movl   $0x402,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800b2c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800b2f:	e8 8d 1e 00 00       	call   8029c1 <sys_calculate_free_frames>
  800b34:	29 c3                	sub    %eax,%ebx
  800b36:	89 d8                	mov    %ebx,%eax
  800b38:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800b3b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b3e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800b41:	7c 0b                	jl     800b4e <_main+0xb16>
  800b43:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b46:	83 c0 02             	add    $0x2,%eax
  800b49:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800b4c:	7d 27                	jge    800b75 <_main+0xb3d>
  800b4e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b55:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800b58:	e8 64 1e 00 00       	call   8029c1 <sys_calculate_free_frames>
  800b5d:	29 c3                	sub    %eax,%ebx
  800b5f:	89 d8                	mov    %ebx,%eax
  800b61:	83 ec 04             	sub    $0x4,%esp
  800b64:	ff 75 d4             	pushl  -0x2c(%ebp)
  800b67:	50                   	push   %eax
  800b68:	68 20 45 80 00       	push   $0x804520
  800b6d:	e8 ca 08 00 00       	call   80143c <cprintf>
  800b72:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800b75:	e8 92 1e 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800b7a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800b7d:	74 17                	je     800b96 <_main+0xb5e>
  800b7f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b86:	83 ec 0c             	sub    $0xc,%esp
  800b89:	68 b8 45 80 00       	push   $0x8045b8
  800b8e:	e8 a9 08 00 00       	call   80143c <cprintf>
  800b93:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=30;
  800b96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b9a:	74 04                	je     800ba0 <_main+0xb68>
  800b9c:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	is_correct = 1;
  800ba0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//[4] Free contiguous allocations
	cprintf("\n%~[4] Free contiguous allocations\n");
  800ba7:	83 ec 0c             	sub    $0xc,%esp
  800baa:	68 d0 46 80 00       	push   $0x8046d0
  800baf:	e8 88 08 00 00       	call   80143c <cprintf>
  800bb4:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  800bb7:	e8 05 1e 00 00       	call   8029c1 <sys_calculate_free_frames>
  800bbc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800bbf:	e8 48 1e 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800bc4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[2]);
  800bc7:	8b 45 88             	mov    -0x78(%ebp),%eax
  800bca:	83 ec 0c             	sub    $0xc,%esp
  800bcd:	50                   	push   %eax
  800bce:	e8 cf 17 00 00       	call   8023a2 <free>
  800bd3:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  800bd6:	e8 31 1e 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800bdb:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800bde:	74 17                	je     800bf7 <_main+0xbbf>
  800be0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800be7:	83 ec 0c             	sub    $0xc,%esp
  800bea:	68 7e 46 80 00       	push   $0x80467e
  800bef:	e8 48 08 00 00       	call   80143c <cprintf>
  800bf4:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  800bf7:	e8 c5 1d 00 00       	call   8029c1 <sys_calculate_free_frames>
  800bfc:	89 c2                	mov    %eax,%edx
  800bfe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c01:	39 c2                	cmp    %eax,%edx
  800c03:	74 17                	je     800c1c <_main+0xbe4>
  800c05:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c0c:	83 ec 0c             	sub    $0xc,%esp
  800c0f:	68 95 46 80 00       	push   $0x804695
  800c14:	e8 23 08 00 00       	call   80143c <cprintf>
  800c19:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800c1c:	e8 a0 1d 00 00       	call   8029c1 <sys_calculate_free_frames>
  800c21:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c24:	e8 e3 1d 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800c29:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[9]);
  800c2c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800c2f:	83 ec 0c             	sub    $0xc,%esp
  800c32:	50                   	push   %eax
  800c33:	e8 6a 17 00 00       	call   8023a2 <free>
  800c38:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  800c3b:	e8 cc 1d 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800c40:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800c43:	74 17                	je     800c5c <_main+0xc24>
  800c45:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c4c:	83 ec 0c             	sub    $0xc,%esp
  800c4f:	68 7e 46 80 00       	push   $0x80467e
  800c54:	e8 e3 07 00 00       	call   80143c <cprintf>
  800c59:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  800c5c:	e8 60 1d 00 00       	call   8029c1 <sys_calculate_free_frames>
  800c61:	89 c2                	mov    %eax,%edx
  800c63:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c66:	39 c2                	cmp    %eax,%edx
  800c68:	74 17                	je     800c81 <_main+0xc49>
  800c6a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c71:	83 ec 0c             	sub    $0xc,%esp
  800c74:	68 95 46 80 00       	push   $0x804695
  800c79:	e8 be 07 00 00       	call   80143c <cprintf>
  800c7e:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800c81:	e8 3b 1d 00 00       	call   8029c1 <sys_calculate_free_frames>
  800c86:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c89:	e8 7e 1d 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800c8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[3]);
  800c91:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800c94:	83 ec 0c             	sub    $0xc,%esp
  800c97:	50                   	push   %eax
  800c98:	e8 05 17 00 00       	call   8023a2 <free>
  800c9d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  800ca0:	e8 67 1d 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800ca5:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800ca8:	74 17                	je     800cc1 <_main+0xc89>
  800caa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cb1:	83 ec 0c             	sub    $0xc,%esp
  800cb4:	68 7e 46 80 00       	push   $0x80467e
  800cb9:	e8 7e 07 00 00       	call   80143c <cprintf>
  800cbe:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  800cc1:	e8 fb 1c 00 00       	call   8029c1 <sys_calculate_free_frames>
  800cc6:	89 c2                	mov    %eax,%edx
  800cc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ccb:	39 c2                	cmp    %eax,%edx
  800ccd:	74 17                	je     800ce6 <_main+0xcae>
  800ccf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cd6:	83 ec 0c             	sub    $0xc,%esp
  800cd9:	68 95 46 80 00       	push   $0x804695
  800cde:	e8 59 07 00 00       	call   80143c <cprintf>
  800ce3:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=10;
  800ce6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800cea:	74 04                	je     800cf0 <_main+0xcb8>
  800cec:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
	is_correct = 1;
  800cf0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//[5] Allocate again [test first fit]
	cprintf("\n%~[5] Allocate again [test first fit]\n");
  800cf7:	83 ec 0c             	sub    $0xc,%esp
  800cfa:	68 f4 46 80 00       	push   $0x8046f4
  800cff:	e8 38 07 00 00       	call   80143c <cprintf>
  800d04:	83 c4 10             	add    $0x10,%esp
	{
		//[FIRST FIT Case]
		//Allocate 1 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800d07:	e8 b5 1c 00 00       	call   8029c1 <sys_calculate_free_frames>
  800d0c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800d0f:	e8 f8 1c 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800d14:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[13] = malloc(1*Mega + 256*kilo - kilo);
  800d17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d1a:	c1 e0 08             	shl    $0x8,%eax
  800d1d:	89 c2                	mov    %eax,%edx
  800d1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800d22:	01 d0                	add    %edx,%eax
  800d24:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800d27:	83 ec 0c             	sub    $0xc,%esp
  800d2a:	50                   	push   %eax
  800d2b:	e8 bc 14 00 00       	call   8021ec <malloc>
  800d30:	83 c4 10             	add    $0x10,%esp
  800d33:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[13] != (pagealloc_start + 1*Mega + 768*kilo)) {is_correct = 0; cprintf("Wrong start address for the allocated space... ");}
  800d36:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800d39:	89 c1                	mov    %eax,%ecx
  800d3b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800d3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800d41:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  800d44:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d47:	89 d0                	mov    %edx,%eax
  800d49:	01 c0                	add    %eax,%eax
  800d4b:	01 d0                	add    %edx,%eax
  800d4d:	c1 e0 08             	shl    $0x8,%eax
  800d50:	01 d8                	add    %ebx,%eax
  800d52:	39 c1                	cmp    %eax,%ecx
  800d54:	74 17                	je     800d6d <_main+0xd35>
  800d56:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d5d:	83 ec 0c             	sub    $0xc,%esp
  800d60:	68 d8 45 80 00       	push   $0x8045d8
  800d65:	e8 d2 06 00 00       	call   80143c <cprintf>
  800d6a:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800d6d:	e8 9a 1c 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800d72:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800d75:	74 17                	je     800d8e <_main+0xd56>
  800d77:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d7e:	83 ec 0c             	sub    $0xc,%esp
  800d81:	68 b8 45 80 00       	push   $0x8045b8
  800d86:	e8 b1 06 00 00       	call   80143c <cprintf>
  800d8b:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800d8e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800d95:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800d98:	e8 24 1c 00 00       	call   8029c1 <sys_calculate_free_frames>
  800d9d:	29 c3                	sub    %eax,%ebx
  800d9f:	89 d8                	mov    %ebx,%eax
  800da1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong allocation by malloc(): expected = %d, actual = %d", expected, diff);}
  800da4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800da7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800daa:	74 1d                	je     800dc9 <_main+0xd91>
  800dac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800db3:	83 ec 04             	sub    $0x4,%esp
  800db6:	ff 75 d0             	pushl  -0x30(%ebp)
  800db9:	ff 75 d4             	pushl  -0x2c(%ebp)
  800dbc:	68 1c 46 80 00       	push   $0x80461c
  800dc1:	e8 76 06 00 00       	call   80143c <cprintf>
  800dc6:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 4 MB [should be placed at the end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800dc9:	e8 f3 1b 00 00       	call   8029c1 <sys_calculate_free_frames>
  800dce:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800dd1:	e8 36 1c 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800dd6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[14] = smalloc("w", 4*Mega, 0);
  800dd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ddc:	c1 e0 02             	shl    $0x2,%eax
  800ddf:	83 ec 04             	sub    $0x4,%esp
  800de2:	6a 00                	push   $0x0
  800de4:	50                   	push   %eax
  800de5:	68 1c 47 80 00       	push   $0x80471c
  800dea:	e8 b4 16 00 00       	call   8024a3 <smalloc>
  800def:	83 c4 10             	add    $0x10,%esp
  800df2:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if (ptr_allocations[14] != (uint32*)(pagealloc_start + 18*Mega))
  800df5:	8b 4d b8             	mov    -0x48(%ebp),%ecx
  800df8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800dfb:	89 d0                	mov    %edx,%eax
  800dfd:	c1 e0 03             	shl    $0x3,%eax
  800e00:	01 d0                	add    %edx,%eax
  800e02:	01 c0                	add    %eax,%eax
  800e04:	89 c2                	mov    %eax,%edx
  800e06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800e09:	01 d0                	add    %edx,%eax
  800e0b:	39 c1                	cmp    %eax,%ecx
  800e0d:	74 17                	je     800e26 <_main+0xdee>
		{is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800e0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e16:	83 ec 0c             	sub    $0xc,%esp
  800e19:	68 b4 44 80 00       	push   $0x8044b4
  800e1e:	e8 19 06 00 00       	call   80143c <cprintf>
  800e23:	83 c4 10             	add    $0x10,%esp
		expected = 1024+1+1; /*1024pages +1table +1page for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  800e26:	c7 45 d4 02 04 00 00 	movl   $0x402,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800e2d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800e30:	e8 8c 1b 00 00       	call   8029c1 <sys_calculate_free_frames>
  800e35:	29 c3                	sub    %eax,%ebx
  800e37:	89 d8                	mov    %ebx,%eax
  800e39:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/)
  800e3c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e3f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800e42:	7c 0b                	jl     800e4f <_main+0xe17>
  800e44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e47:	83 c0 02             	add    $0x2,%eax
  800e4a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800e4d:	7d 27                	jge    800e76 <_main+0xe3e>
		{is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800e4f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e56:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800e59:	e8 63 1b 00 00       	call   8029c1 <sys_calculate_free_frames>
  800e5e:	29 c3                	sub    %eax,%ebx
  800e60:	89 d8                	mov    %ebx,%eax
  800e62:	83 ec 04             	sub    $0x4,%esp
  800e65:	ff 75 d4             	pushl  -0x2c(%ebp)
  800e68:	50                   	push   %eax
  800e69:	68 20 45 80 00       	push   $0x804520
  800e6e:	e8 c9 05 00 00       	call   80143c <cprintf>
  800e73:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800e76:	e8 91 1b 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800e7b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800e7e:	74 17                	je     800e97 <_main+0xe5f>
  800e80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e87:	83 ec 0c             	sub    $0xc,%esp
  800e8a:	68 b8 45 80 00       	push   $0x8045b8
  800e8f:	e8 a8 05 00 00       	call   80143c <cprintf>
  800e94:	83 c4 10             	add    $0x10,%esp

		//Get shared of 3 MB [should be placed in the remaining part of the contiguous (256 KB + 4 MB) hole
		freeFrames = sys_calculate_free_frames() ;
  800e97:	e8 25 1b 00 00       	call   8029c1 <sys_calculate_free_frames>
  800e9c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800e9f:	e8 68 1b 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800ea4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[15] = sget(envID, "z");
  800ea7:	83 ec 08             	sub    $0x8,%esp
  800eaa:	68 57 46 80 00       	push   $0x804657
  800eaf:	ff 75 ec             	pushl  -0x14(%ebp)
  800eb2:	e8 87 17 00 00       	call   80263e <sget>
  800eb7:	83 c4 10             	add    $0x10,%esp
  800eba:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if (ptr_allocations[15] != (uint32*)(pagealloc_start + 3*Mega)) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800ebd:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800ec0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ec3:	89 c1                	mov    %eax,%ecx
  800ec5:	01 c9                	add    %ecx,%ecx
  800ec7:	01 c8                	add    %ecx,%eax
  800ec9:	89 c1                	mov    %eax,%ecx
  800ecb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ece:	01 c8                	add    %ecx,%eax
  800ed0:	39 c2                	cmp    %eax,%edx
  800ed2:	74 17                	je     800eeb <_main+0xeb3>
  800ed4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800edb:	83 ec 0c             	sub    $0xc,%esp
  800ede:	68 b4 44 80 00       	push   $0x8044b4
  800ee3:	e8 54 05 00 00       	call   80143c <cprintf>
  800ee8:	83 c4 10             	add    $0x10,%esp
		expected = 0+0; /*0pages +0table*/
  800eeb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800ef2:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800ef5:	e8 c7 1a 00 00       	call   8029c1 <sys_calculate_free_frames>
  800efa:	29 c3                	sub    %eax,%ebx
  800efc:	89 d8                	mov    %ebx,%eax
  800efe:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected /*Exact! since sget don't create any new objects, so sbrk not invoked*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800f01:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f04:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800f07:	74 27                	je     800f30 <_main+0xef8>
  800f09:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f10:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800f13:	e8 a9 1a 00 00       	call   8029c1 <sys_calculate_free_frames>
  800f18:	29 c3                	sub    %eax,%ebx
  800f1a:	89 d8                	mov    %ebx,%eax
  800f1c:	83 ec 04             	sub    $0x4,%esp
  800f1f:	ff 75 d4             	pushl  -0x2c(%ebp)
  800f22:	50                   	push   %eax
  800f23:	68 20 45 80 00       	push   $0x804520
  800f28:	e8 0f 05 00 00       	call   80143c <cprintf>
  800f2d:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800f30:	e8 d7 1a 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800f35:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800f38:	74 17                	je     800f51 <_main+0xf19>
  800f3a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f41:	83 ec 0c             	sub    $0xc,%esp
  800f44:	68 b8 45 80 00       	push   $0x8045b8
  800f49:	e8 ee 04 00 00       	call   80143c <cprintf>
  800f4e:	83 c4 10             	add    $0x10,%esp

		//Get shared of 1st 1 MB [should be placed in the remaining part of the 3 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800f51:	e8 6b 1a 00 00       	call   8029c1 <sys_calculate_free_frames>
  800f56:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800f59:	e8 ae 1a 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800f5e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[16] = sget(envID, "x");
  800f61:	83 ec 08             	sub    $0x8,%esp
  800f64:	68 b1 44 80 00       	push   $0x8044b1
  800f69:	ff 75 ec             	pushl  -0x14(%ebp)
  800f6c:	e8 cd 16 00 00       	call   80263e <sget>
  800f71:	83 c4 10             	add    $0x10,%esp
  800f74:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if (ptr_allocations[16] != (uint32*)(pagealloc_start + 10*Mega)) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800f77:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800f7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f7d:	89 d0                	mov    %edx,%eax
  800f7f:	c1 e0 02             	shl    $0x2,%eax
  800f82:	01 d0                	add    %edx,%eax
  800f84:	01 c0                	add    %eax,%eax
  800f86:	89 c2                	mov    %eax,%edx
  800f88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f8b:	01 d0                	add    %edx,%eax
  800f8d:	39 c1                	cmp    %eax,%ecx
  800f8f:	74 17                	je     800fa8 <_main+0xf70>
  800f91:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f98:	83 ec 0c             	sub    $0xc,%esp
  800f9b:	68 b4 44 80 00       	push   $0x8044b4
  800fa0:	e8 97 04 00 00       	call   80143c <cprintf>
  800fa5:	83 c4 10             	add    $0x10,%esp
		expected = 0+0; /*0pages +0table*/
  800fa8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800faf:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800fb2:	e8 0a 1a 00 00       	call   8029c1 <sys_calculate_free_frames>
  800fb7:	29 c3                	sub    %eax,%ebx
  800fb9:	89 d8                	mov    %ebx,%eax
  800fbb:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected /*Exact! since sget don't create any new objects, so sbrk not invoked*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800fbe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fc1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800fc4:	74 27                	je     800fed <_main+0xfb5>
  800fc6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fcd:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800fd0:	e8 ec 19 00 00       	call   8029c1 <sys_calculate_free_frames>
  800fd5:	29 c3                	sub    %eax,%ebx
  800fd7:	89 d8                	mov    %ebx,%eax
  800fd9:	83 ec 04             	sub    $0x4,%esp
  800fdc:	ff 75 d4             	pushl  -0x2c(%ebp)
  800fdf:	50                   	push   %eax
  800fe0:	68 20 45 80 00       	push   $0x804520
  800fe5:	e8 52 04 00 00       	call   80143c <cprintf>
  800fea:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800fed:	e8 1a 1a 00 00       	call   802a0c <sys_pf_calculate_allocated_pages>
  800ff2:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800ff5:	74 17                	je     80100e <_main+0xfd6>
  800ff7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ffe:	83 ec 0c             	sub    $0xc,%esp
  801001:	68 b8 45 80 00       	push   $0x8045b8
  801006:	e8 31 04 00 00       	call   80143c <cprintf>
  80100b:	83 c4 10             	add    $0x10,%esp

	}
	if (is_correct)	eval+=40;
  80100e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801012:	74 04                	je     801018 <_main+0xfe0>
  801014:	83 45 f4 28          	addl   $0x28,-0xc(%ebp)
	is_correct = 1;
  801018:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("%~\ntest FIRST FIT allocation (3) completed. Eval = %d%%\n\n", eval);
  80101f:	83 ec 08             	sub    $0x8,%esp
  801022:	ff 75 f4             	pushl  -0xc(%ebp)
  801025:	68 20 47 80 00       	push   $0x804720
  80102a:	e8 0d 04 00 00       	call   80143c <cprintf>
  80102f:	83 c4 10             	add    $0x10,%esp

	return;
  801032:	90                   	nop
}
  801033:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801036:	5b                   	pop    %ebx
  801037:	5f                   	pop    %edi
  801038:	5d                   	pop    %ebp
  801039:	c3                   	ret    

0080103a <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  801040:	e8 45 1b 00 00       	call   802b8a <sys_getenvindex>
  801045:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  801048:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80104b:	89 d0                	mov    %edx,%eax
  80104d:	c1 e0 02             	shl    $0x2,%eax
  801050:	01 d0                	add    %edx,%eax
  801052:	c1 e0 03             	shl    $0x3,%eax
  801055:	01 d0                	add    %edx,%eax
  801057:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80105e:	01 d0                	add    %edx,%eax
  801060:	c1 e0 02             	shl    $0x2,%eax
  801063:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801068:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80106d:	a1 20 50 80 00       	mov    0x805020,%eax
  801072:	8a 40 20             	mov    0x20(%eax),%al
  801075:	84 c0                	test   %al,%al
  801077:	74 0d                	je     801086 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  801079:	a1 20 50 80 00       	mov    0x805020,%eax
  80107e:	83 c0 20             	add    $0x20,%eax
  801081:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801086:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80108a:	7e 0a                	jle    801096 <libmain+0x5c>
		binaryname = argv[0];
  80108c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108f:	8b 00                	mov    (%eax),%eax
  801091:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  801096:	83 ec 08             	sub    $0x8,%esp
  801099:	ff 75 0c             	pushl  0xc(%ebp)
  80109c:	ff 75 08             	pushl  0x8(%ebp)
  80109f:	e8 94 ef ff ff       	call   800038 <_main>
  8010a4:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8010a7:	a1 00 50 80 00       	mov    0x805000,%eax
  8010ac:	85 c0                	test   %eax,%eax
  8010ae:	0f 84 9f 00 00 00    	je     801153 <libmain+0x119>
	{
		sys_lock_cons();
  8010b4:	e8 55 18 00 00       	call   80290e <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8010b9:	83 ec 0c             	sub    $0xc,%esp
  8010bc:	68 74 47 80 00       	push   $0x804774
  8010c1:	e8 76 03 00 00       	call   80143c <cprintf>
  8010c6:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8010c9:	a1 20 50 80 00       	mov    0x805020,%eax
  8010ce:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8010d4:	a1 20 50 80 00       	mov    0x805020,%eax
  8010d9:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8010df:	83 ec 04             	sub    $0x4,%esp
  8010e2:	52                   	push   %edx
  8010e3:	50                   	push   %eax
  8010e4:	68 9c 47 80 00       	push   $0x80479c
  8010e9:	e8 4e 03 00 00       	call   80143c <cprintf>
  8010ee:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8010f1:	a1 20 50 80 00       	mov    0x805020,%eax
  8010f6:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8010fc:	a1 20 50 80 00       	mov    0x805020,%eax
  801101:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  801107:	a1 20 50 80 00       	mov    0x805020,%eax
  80110c:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  801112:	51                   	push   %ecx
  801113:	52                   	push   %edx
  801114:	50                   	push   %eax
  801115:	68 c4 47 80 00       	push   $0x8047c4
  80111a:	e8 1d 03 00 00       	call   80143c <cprintf>
  80111f:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801122:	a1 20 50 80 00       	mov    0x805020,%eax
  801127:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80112d:	83 ec 08             	sub    $0x8,%esp
  801130:	50                   	push   %eax
  801131:	68 1c 48 80 00       	push   $0x80481c
  801136:	e8 01 03 00 00       	call   80143c <cprintf>
  80113b:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80113e:	83 ec 0c             	sub    $0xc,%esp
  801141:	68 74 47 80 00       	push   $0x804774
  801146:	e8 f1 02 00 00       	call   80143c <cprintf>
  80114b:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80114e:	e8 d5 17 00 00       	call   802928 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  801153:	e8 19 00 00 00       	call   801171 <exit>
}
  801158:	90                   	nop
  801159:	c9                   	leave  
  80115a:	c3                   	ret    

0080115b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
  80115e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801161:	83 ec 0c             	sub    $0xc,%esp
  801164:	6a 00                	push   $0x0
  801166:	e8 eb 19 00 00       	call   802b56 <sys_destroy_env>
  80116b:	83 c4 10             	add    $0x10,%esp
}
  80116e:	90                   	nop
  80116f:	c9                   	leave  
  801170:	c3                   	ret    

00801171 <exit>:

void
exit(void)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
  801174:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801177:	e8 40 1a 00 00       	call   802bbc <sys_exit_env>
}
  80117c:	90                   	nop
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801185:	8d 45 10             	lea    0x10(%ebp),%eax
  801188:	83 c0 04             	add    $0x4,%eax
  80118b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80118e:	a1 60 50 98 00       	mov    0x985060,%eax
  801193:	85 c0                	test   %eax,%eax
  801195:	74 16                	je     8011ad <_panic+0x2e>
		cprintf("%s: ", argv0);
  801197:	a1 60 50 98 00       	mov    0x985060,%eax
  80119c:	83 ec 08             	sub    $0x8,%esp
  80119f:	50                   	push   %eax
  8011a0:	68 30 48 80 00       	push   $0x804830
  8011a5:	e8 92 02 00 00       	call   80143c <cprintf>
  8011aa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8011ad:	a1 04 50 80 00       	mov    0x805004,%eax
  8011b2:	ff 75 0c             	pushl  0xc(%ebp)
  8011b5:	ff 75 08             	pushl  0x8(%ebp)
  8011b8:	50                   	push   %eax
  8011b9:	68 35 48 80 00       	push   $0x804835
  8011be:	e8 79 02 00 00       	call   80143c <cprintf>
  8011c3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8011c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c9:	83 ec 08             	sub    $0x8,%esp
  8011cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8011cf:	50                   	push   %eax
  8011d0:	e8 fc 01 00 00       	call   8013d1 <vcprintf>
  8011d5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8011d8:	83 ec 08             	sub    $0x8,%esp
  8011db:	6a 00                	push   $0x0
  8011dd:	68 51 48 80 00       	push   $0x804851
  8011e2:	e8 ea 01 00 00       	call   8013d1 <vcprintf>
  8011e7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8011ea:	e8 82 ff ff ff       	call   801171 <exit>

	// should not return here
	while (1) ;
  8011ef:	eb fe                	jmp    8011ef <_panic+0x70>

008011f1 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8011f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8011fc:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801202:	8b 45 0c             	mov    0xc(%ebp),%eax
  801205:	39 c2                	cmp    %eax,%edx
  801207:	74 14                	je     80121d <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801209:	83 ec 04             	sub    $0x4,%esp
  80120c:	68 54 48 80 00       	push   $0x804854
  801211:	6a 26                	push   $0x26
  801213:	68 a0 48 80 00       	push   $0x8048a0
  801218:	e8 62 ff ff ff       	call   80117f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80121d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801224:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80122b:	e9 c5 00 00 00       	jmp    8012f5 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801230:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801233:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	01 d0                	add    %edx,%eax
  80123f:	8b 00                	mov    (%eax),%eax
  801241:	85 c0                	test   %eax,%eax
  801243:	75 08                	jne    80124d <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801245:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801248:	e9 a5 00 00 00       	jmp    8012f2 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80124d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801254:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80125b:	eb 69                	jmp    8012c6 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80125d:	a1 20 50 80 00       	mov    0x805020,%eax
  801262:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801268:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80126b:	89 d0                	mov    %edx,%eax
  80126d:	01 c0                	add    %eax,%eax
  80126f:	01 d0                	add    %edx,%eax
  801271:	c1 e0 03             	shl    $0x3,%eax
  801274:	01 c8                	add    %ecx,%eax
  801276:	8a 40 04             	mov    0x4(%eax),%al
  801279:	84 c0                	test   %al,%al
  80127b:	75 46                	jne    8012c3 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80127d:	a1 20 50 80 00       	mov    0x805020,%eax
  801282:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801288:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80128b:	89 d0                	mov    %edx,%eax
  80128d:	01 c0                	add    %eax,%eax
  80128f:	01 d0                	add    %edx,%eax
  801291:	c1 e0 03             	shl    $0x3,%eax
  801294:	01 c8                	add    %ecx,%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80129b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80129e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012a3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8012a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	01 c8                	add    %ecx,%eax
  8012b4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8012b6:	39 c2                	cmp    %eax,%edx
  8012b8:	75 09                	jne    8012c3 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8012ba:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8012c1:	eb 15                	jmp    8012d8 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8012c3:	ff 45 e8             	incl   -0x18(%ebp)
  8012c6:	a1 20 50 80 00       	mov    0x805020,%eax
  8012cb:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8012d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012d4:	39 c2                	cmp    %eax,%edx
  8012d6:	77 85                	ja     80125d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8012d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012dc:	75 14                	jne    8012f2 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8012de:	83 ec 04             	sub    $0x4,%esp
  8012e1:	68 ac 48 80 00       	push   $0x8048ac
  8012e6:	6a 3a                	push   $0x3a
  8012e8:	68 a0 48 80 00       	push   $0x8048a0
  8012ed:	e8 8d fe ff ff       	call   80117f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8012f2:	ff 45 f0             	incl   -0x10(%ebp)
  8012f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8012fb:	0f 8c 2f ff ff ff    	jl     801230 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801301:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801308:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80130f:	eb 26                	jmp    801337 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801311:	a1 20 50 80 00       	mov    0x805020,%eax
  801316:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80131c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80131f:	89 d0                	mov    %edx,%eax
  801321:	01 c0                	add    %eax,%eax
  801323:	01 d0                	add    %edx,%eax
  801325:	c1 e0 03             	shl    $0x3,%eax
  801328:	01 c8                	add    %ecx,%eax
  80132a:	8a 40 04             	mov    0x4(%eax),%al
  80132d:	3c 01                	cmp    $0x1,%al
  80132f:	75 03                	jne    801334 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801331:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801334:	ff 45 e0             	incl   -0x20(%ebp)
  801337:	a1 20 50 80 00       	mov    0x805020,%eax
  80133c:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801342:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801345:	39 c2                	cmp    %eax,%edx
  801347:	77 c8                	ja     801311 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80134f:	74 14                	je     801365 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801351:	83 ec 04             	sub    $0x4,%esp
  801354:	68 00 49 80 00       	push   $0x804900
  801359:	6a 44                	push   $0x44
  80135b:	68 a0 48 80 00       	push   $0x8048a0
  801360:	e8 1a fe ff ff       	call   80117f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801365:	90                   	nop
  801366:	c9                   	leave  
  801367:	c3                   	ret    

00801368 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801368:	55                   	push   %ebp
  801369:	89 e5                	mov    %esp,%ebp
  80136b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80136e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801371:	8b 00                	mov    (%eax),%eax
  801373:	8d 48 01             	lea    0x1(%eax),%ecx
  801376:	8b 55 0c             	mov    0xc(%ebp),%edx
  801379:	89 0a                	mov    %ecx,(%edx)
  80137b:	8b 55 08             	mov    0x8(%ebp),%edx
  80137e:	88 d1                	mov    %dl,%cl
  801380:	8b 55 0c             	mov    0xc(%ebp),%edx
  801383:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801387:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138a:	8b 00                	mov    (%eax),%eax
  80138c:	3d ff 00 00 00       	cmp    $0xff,%eax
  801391:	75 2c                	jne    8013bf <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801393:	a0 44 50 98 00       	mov    0x985044,%al
  801398:	0f b6 c0             	movzbl %al,%eax
  80139b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139e:	8b 12                	mov    (%edx),%edx
  8013a0:	89 d1                	mov    %edx,%ecx
  8013a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a5:	83 c2 08             	add    $0x8,%edx
  8013a8:	83 ec 04             	sub    $0x4,%esp
  8013ab:	50                   	push   %eax
  8013ac:	51                   	push   %ecx
  8013ad:	52                   	push   %edx
  8013ae:	e8 19 15 00 00       	call   8028cc <sys_cputs>
  8013b3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8013b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8013bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c2:	8b 40 04             	mov    0x4(%eax),%eax
  8013c5:	8d 50 01             	lea    0x1(%eax),%edx
  8013c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cb:	89 50 04             	mov    %edx,0x4(%eax)
}
  8013ce:	90                   	nop
  8013cf:	c9                   	leave  
  8013d0:	c3                   	ret    

008013d1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
  8013d4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8013da:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8013e1:	00 00 00 
	b.cnt = 0;
  8013e4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8013eb:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8013ee:	ff 75 0c             	pushl  0xc(%ebp)
  8013f1:	ff 75 08             	pushl  0x8(%ebp)
  8013f4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8013fa:	50                   	push   %eax
  8013fb:	68 68 13 80 00       	push   $0x801368
  801400:	e8 11 02 00 00       	call   801616 <vprintfmt>
  801405:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801408:	a0 44 50 98 00       	mov    0x985044,%al
  80140d:	0f b6 c0             	movzbl %al,%eax
  801410:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801416:	83 ec 04             	sub    $0x4,%esp
  801419:	50                   	push   %eax
  80141a:	52                   	push   %edx
  80141b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801421:	83 c0 08             	add    $0x8,%eax
  801424:	50                   	push   %eax
  801425:	e8 a2 14 00 00       	call   8028cc <sys_cputs>
  80142a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80142d:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  801434:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80143a:	c9                   	leave  
  80143b:	c3                   	ret    

0080143c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801442:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  801449:	8d 45 0c             	lea    0xc(%ebp),%eax
  80144c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80144f:	8b 45 08             	mov    0x8(%ebp),%eax
  801452:	83 ec 08             	sub    $0x8,%esp
  801455:	ff 75 f4             	pushl  -0xc(%ebp)
  801458:	50                   	push   %eax
  801459:	e8 73 ff ff ff       	call   8013d1 <vcprintf>
  80145e:	83 c4 10             	add    $0x10,%esp
  801461:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801464:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
  80146c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80146f:	e8 9a 14 00 00       	call   80290e <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801474:	8d 45 0c             	lea    0xc(%ebp),%eax
  801477:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
  80147d:	83 ec 08             	sub    $0x8,%esp
  801480:	ff 75 f4             	pushl  -0xc(%ebp)
  801483:	50                   	push   %eax
  801484:	e8 48 ff ff ff       	call   8013d1 <vcprintf>
  801489:	83 c4 10             	add    $0x10,%esp
  80148c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80148f:	e8 94 14 00 00       	call   802928 <sys_unlock_cons>
	return cnt;
  801494:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801497:	c9                   	leave  
  801498:	c3                   	ret    

00801499 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	53                   	push   %ebx
  80149d:	83 ec 14             	sub    $0x14,%esp
  8014a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8014ac:	8b 45 18             	mov    0x18(%ebp),%eax
  8014af:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8014b7:	77 55                	ja     80150e <printnum+0x75>
  8014b9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8014bc:	72 05                	jb     8014c3 <printnum+0x2a>
  8014be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014c1:	77 4b                	ja     80150e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8014c3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8014c6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8014c9:	8b 45 18             	mov    0x18(%ebp),%eax
  8014cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d1:	52                   	push   %edx
  8014d2:	50                   	push   %eax
  8014d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8014d6:	ff 75 f0             	pushl  -0x10(%ebp)
  8014d9:	e8 f2 2c 00 00       	call   8041d0 <__udivdi3>
  8014de:	83 c4 10             	add    $0x10,%esp
  8014e1:	83 ec 04             	sub    $0x4,%esp
  8014e4:	ff 75 20             	pushl  0x20(%ebp)
  8014e7:	53                   	push   %ebx
  8014e8:	ff 75 18             	pushl  0x18(%ebp)
  8014eb:	52                   	push   %edx
  8014ec:	50                   	push   %eax
  8014ed:	ff 75 0c             	pushl  0xc(%ebp)
  8014f0:	ff 75 08             	pushl  0x8(%ebp)
  8014f3:	e8 a1 ff ff ff       	call   801499 <printnum>
  8014f8:	83 c4 20             	add    $0x20,%esp
  8014fb:	eb 1a                	jmp    801517 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8014fd:	83 ec 08             	sub    $0x8,%esp
  801500:	ff 75 0c             	pushl  0xc(%ebp)
  801503:	ff 75 20             	pushl  0x20(%ebp)
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	ff d0                	call   *%eax
  80150b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80150e:	ff 4d 1c             	decl   0x1c(%ebp)
  801511:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801515:	7f e6                	jg     8014fd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801517:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80151a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80151f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801522:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801525:	53                   	push   %ebx
  801526:	51                   	push   %ecx
  801527:	52                   	push   %edx
  801528:	50                   	push   %eax
  801529:	e8 b2 2d 00 00       	call   8042e0 <__umoddi3>
  80152e:	83 c4 10             	add    $0x10,%esp
  801531:	05 74 4b 80 00       	add    $0x804b74,%eax
  801536:	8a 00                	mov    (%eax),%al
  801538:	0f be c0             	movsbl %al,%eax
  80153b:	83 ec 08             	sub    $0x8,%esp
  80153e:	ff 75 0c             	pushl  0xc(%ebp)
  801541:	50                   	push   %eax
  801542:	8b 45 08             	mov    0x8(%ebp),%eax
  801545:	ff d0                	call   *%eax
  801547:	83 c4 10             	add    $0x10,%esp
}
  80154a:	90                   	nop
  80154b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80154e:	c9                   	leave  
  80154f:	c3                   	ret    

00801550 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801553:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801557:	7e 1c                	jle    801575 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	8b 00                	mov    (%eax),%eax
  80155e:	8d 50 08             	lea    0x8(%eax),%edx
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	89 10                	mov    %edx,(%eax)
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	8b 00                	mov    (%eax),%eax
  80156b:	83 e8 08             	sub    $0x8,%eax
  80156e:	8b 50 04             	mov    0x4(%eax),%edx
  801571:	8b 00                	mov    (%eax),%eax
  801573:	eb 40                	jmp    8015b5 <getuint+0x65>
	else if (lflag)
  801575:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801579:	74 1e                	je     801599 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80157b:	8b 45 08             	mov    0x8(%ebp),%eax
  80157e:	8b 00                	mov    (%eax),%eax
  801580:	8d 50 04             	lea    0x4(%eax),%edx
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	89 10                	mov    %edx,(%eax)
  801588:	8b 45 08             	mov    0x8(%ebp),%eax
  80158b:	8b 00                	mov    (%eax),%eax
  80158d:	83 e8 04             	sub    $0x4,%eax
  801590:	8b 00                	mov    (%eax),%eax
  801592:	ba 00 00 00 00       	mov    $0x0,%edx
  801597:	eb 1c                	jmp    8015b5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	8b 00                	mov    (%eax),%eax
  80159e:	8d 50 04             	lea    0x4(%eax),%edx
  8015a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a4:	89 10                	mov    %edx,(%eax)
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	8b 00                	mov    (%eax),%eax
  8015ab:	83 e8 04             	sub    $0x4,%eax
  8015ae:	8b 00                	mov    (%eax),%eax
  8015b0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8015b5:	5d                   	pop    %ebp
  8015b6:	c3                   	ret    

008015b7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8015ba:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8015be:	7e 1c                	jle    8015dc <getint+0x25>
		return va_arg(*ap, long long);
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c3:	8b 00                	mov    (%eax),%eax
  8015c5:	8d 50 08             	lea    0x8(%eax),%edx
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	89 10                	mov    %edx,(%eax)
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	8b 00                	mov    (%eax),%eax
  8015d2:	83 e8 08             	sub    $0x8,%eax
  8015d5:	8b 50 04             	mov    0x4(%eax),%edx
  8015d8:	8b 00                	mov    (%eax),%eax
  8015da:	eb 38                	jmp    801614 <getint+0x5d>
	else if (lflag)
  8015dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015e0:	74 1a                	je     8015fc <getint+0x45>
		return va_arg(*ap, long);
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	8b 00                	mov    (%eax),%eax
  8015e7:	8d 50 04             	lea    0x4(%eax),%edx
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	89 10                	mov    %edx,(%eax)
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	8b 00                	mov    (%eax),%eax
  8015f4:	83 e8 04             	sub    $0x4,%eax
  8015f7:	8b 00                	mov    (%eax),%eax
  8015f9:	99                   	cltd   
  8015fa:	eb 18                	jmp    801614 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ff:	8b 00                	mov    (%eax),%eax
  801601:	8d 50 04             	lea    0x4(%eax),%edx
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
  801607:	89 10                	mov    %edx,(%eax)
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
  80160c:	8b 00                	mov    (%eax),%eax
  80160e:	83 e8 04             	sub    $0x4,%eax
  801611:	8b 00                	mov    (%eax),%eax
  801613:	99                   	cltd   
}
  801614:	5d                   	pop    %ebp
  801615:	c3                   	ret    

00801616 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	56                   	push   %esi
  80161a:	53                   	push   %ebx
  80161b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80161e:	eb 17                	jmp    801637 <vprintfmt+0x21>
			if (ch == '\0')
  801620:	85 db                	test   %ebx,%ebx
  801622:	0f 84 c1 03 00 00    	je     8019e9 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801628:	83 ec 08             	sub    $0x8,%esp
  80162b:	ff 75 0c             	pushl  0xc(%ebp)
  80162e:	53                   	push   %ebx
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	ff d0                	call   *%eax
  801634:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801637:	8b 45 10             	mov    0x10(%ebp),%eax
  80163a:	8d 50 01             	lea    0x1(%eax),%edx
  80163d:	89 55 10             	mov    %edx,0x10(%ebp)
  801640:	8a 00                	mov    (%eax),%al
  801642:	0f b6 d8             	movzbl %al,%ebx
  801645:	83 fb 25             	cmp    $0x25,%ebx
  801648:	75 d6                	jne    801620 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80164a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80164e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801655:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80165c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801663:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80166a:	8b 45 10             	mov    0x10(%ebp),%eax
  80166d:	8d 50 01             	lea    0x1(%eax),%edx
  801670:	89 55 10             	mov    %edx,0x10(%ebp)
  801673:	8a 00                	mov    (%eax),%al
  801675:	0f b6 d8             	movzbl %al,%ebx
  801678:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80167b:	83 f8 5b             	cmp    $0x5b,%eax
  80167e:	0f 87 3d 03 00 00    	ja     8019c1 <vprintfmt+0x3ab>
  801684:	8b 04 85 98 4b 80 00 	mov    0x804b98(,%eax,4),%eax
  80168b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80168d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801691:	eb d7                	jmp    80166a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801693:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801697:	eb d1                	jmp    80166a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801699:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8016a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016a3:	89 d0                	mov    %edx,%eax
  8016a5:	c1 e0 02             	shl    $0x2,%eax
  8016a8:	01 d0                	add    %edx,%eax
  8016aa:	01 c0                	add    %eax,%eax
  8016ac:	01 d8                	add    %ebx,%eax
  8016ae:	83 e8 30             	sub    $0x30,%eax
  8016b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8016b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b7:	8a 00                	mov    (%eax),%al
  8016b9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8016bc:	83 fb 2f             	cmp    $0x2f,%ebx
  8016bf:	7e 3e                	jle    8016ff <vprintfmt+0xe9>
  8016c1:	83 fb 39             	cmp    $0x39,%ebx
  8016c4:	7f 39                	jg     8016ff <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8016c6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8016c9:	eb d5                	jmp    8016a0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8016cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ce:	83 c0 04             	add    $0x4,%eax
  8016d1:	89 45 14             	mov    %eax,0x14(%ebp)
  8016d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d7:	83 e8 04             	sub    $0x4,%eax
  8016da:	8b 00                	mov    (%eax),%eax
  8016dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8016df:	eb 1f                	jmp    801700 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8016e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016e5:	79 83                	jns    80166a <vprintfmt+0x54>
				width = 0;
  8016e7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8016ee:	e9 77 ff ff ff       	jmp    80166a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8016f3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8016fa:	e9 6b ff ff ff       	jmp    80166a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8016ff:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801700:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801704:	0f 89 60 ff ff ff    	jns    80166a <vprintfmt+0x54>
				width = precision, precision = -1;
  80170a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80170d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801710:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801717:	e9 4e ff ff ff       	jmp    80166a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80171c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80171f:	e9 46 ff ff ff       	jmp    80166a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801724:	8b 45 14             	mov    0x14(%ebp),%eax
  801727:	83 c0 04             	add    $0x4,%eax
  80172a:	89 45 14             	mov    %eax,0x14(%ebp)
  80172d:	8b 45 14             	mov    0x14(%ebp),%eax
  801730:	83 e8 04             	sub    $0x4,%eax
  801733:	8b 00                	mov    (%eax),%eax
  801735:	83 ec 08             	sub    $0x8,%esp
  801738:	ff 75 0c             	pushl  0xc(%ebp)
  80173b:	50                   	push   %eax
  80173c:	8b 45 08             	mov    0x8(%ebp),%eax
  80173f:	ff d0                	call   *%eax
  801741:	83 c4 10             	add    $0x10,%esp
			break;
  801744:	e9 9b 02 00 00       	jmp    8019e4 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801749:	8b 45 14             	mov    0x14(%ebp),%eax
  80174c:	83 c0 04             	add    $0x4,%eax
  80174f:	89 45 14             	mov    %eax,0x14(%ebp)
  801752:	8b 45 14             	mov    0x14(%ebp),%eax
  801755:	83 e8 04             	sub    $0x4,%eax
  801758:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80175a:	85 db                	test   %ebx,%ebx
  80175c:	79 02                	jns    801760 <vprintfmt+0x14a>
				err = -err;
  80175e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801760:	83 fb 64             	cmp    $0x64,%ebx
  801763:	7f 0b                	jg     801770 <vprintfmt+0x15a>
  801765:	8b 34 9d e0 49 80 00 	mov    0x8049e0(,%ebx,4),%esi
  80176c:	85 f6                	test   %esi,%esi
  80176e:	75 19                	jne    801789 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801770:	53                   	push   %ebx
  801771:	68 85 4b 80 00       	push   $0x804b85
  801776:	ff 75 0c             	pushl  0xc(%ebp)
  801779:	ff 75 08             	pushl  0x8(%ebp)
  80177c:	e8 70 02 00 00       	call   8019f1 <printfmt>
  801781:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801784:	e9 5b 02 00 00       	jmp    8019e4 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801789:	56                   	push   %esi
  80178a:	68 8e 4b 80 00       	push   $0x804b8e
  80178f:	ff 75 0c             	pushl  0xc(%ebp)
  801792:	ff 75 08             	pushl  0x8(%ebp)
  801795:	e8 57 02 00 00       	call   8019f1 <printfmt>
  80179a:	83 c4 10             	add    $0x10,%esp
			break;
  80179d:	e9 42 02 00 00       	jmp    8019e4 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8017a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a5:	83 c0 04             	add    $0x4,%eax
  8017a8:	89 45 14             	mov    %eax,0x14(%ebp)
  8017ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ae:	83 e8 04             	sub    $0x4,%eax
  8017b1:	8b 30                	mov    (%eax),%esi
  8017b3:	85 f6                	test   %esi,%esi
  8017b5:	75 05                	jne    8017bc <vprintfmt+0x1a6>
				p = "(null)";
  8017b7:	be 91 4b 80 00       	mov    $0x804b91,%esi
			if (width > 0 && padc != '-')
  8017bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017c0:	7e 6d                	jle    80182f <vprintfmt+0x219>
  8017c2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8017c6:	74 67                	je     80182f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8017c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017cb:	83 ec 08             	sub    $0x8,%esp
  8017ce:	50                   	push   %eax
  8017cf:	56                   	push   %esi
  8017d0:	e8 1e 03 00 00       	call   801af3 <strnlen>
  8017d5:	83 c4 10             	add    $0x10,%esp
  8017d8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8017db:	eb 16                	jmp    8017f3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8017dd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8017e1:	83 ec 08             	sub    $0x8,%esp
  8017e4:	ff 75 0c             	pushl  0xc(%ebp)
  8017e7:	50                   	push   %eax
  8017e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017eb:	ff d0                	call   *%eax
  8017ed:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8017f0:	ff 4d e4             	decl   -0x1c(%ebp)
  8017f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017f7:	7f e4                	jg     8017dd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8017f9:	eb 34                	jmp    80182f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8017fb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8017ff:	74 1c                	je     80181d <vprintfmt+0x207>
  801801:	83 fb 1f             	cmp    $0x1f,%ebx
  801804:	7e 05                	jle    80180b <vprintfmt+0x1f5>
  801806:	83 fb 7e             	cmp    $0x7e,%ebx
  801809:	7e 12                	jle    80181d <vprintfmt+0x207>
					putch('?', putdat);
  80180b:	83 ec 08             	sub    $0x8,%esp
  80180e:	ff 75 0c             	pushl  0xc(%ebp)
  801811:	6a 3f                	push   $0x3f
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	ff d0                	call   *%eax
  801818:	83 c4 10             	add    $0x10,%esp
  80181b:	eb 0f                	jmp    80182c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80181d:	83 ec 08             	sub    $0x8,%esp
  801820:	ff 75 0c             	pushl  0xc(%ebp)
  801823:	53                   	push   %ebx
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	ff d0                	call   *%eax
  801829:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80182c:	ff 4d e4             	decl   -0x1c(%ebp)
  80182f:	89 f0                	mov    %esi,%eax
  801831:	8d 70 01             	lea    0x1(%eax),%esi
  801834:	8a 00                	mov    (%eax),%al
  801836:	0f be d8             	movsbl %al,%ebx
  801839:	85 db                	test   %ebx,%ebx
  80183b:	74 24                	je     801861 <vprintfmt+0x24b>
  80183d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801841:	78 b8                	js     8017fb <vprintfmt+0x1e5>
  801843:	ff 4d e0             	decl   -0x20(%ebp)
  801846:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80184a:	79 af                	jns    8017fb <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80184c:	eb 13                	jmp    801861 <vprintfmt+0x24b>
				putch(' ', putdat);
  80184e:	83 ec 08             	sub    $0x8,%esp
  801851:	ff 75 0c             	pushl  0xc(%ebp)
  801854:	6a 20                	push   $0x20
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	ff d0                	call   *%eax
  80185b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80185e:	ff 4d e4             	decl   -0x1c(%ebp)
  801861:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801865:	7f e7                	jg     80184e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801867:	e9 78 01 00 00       	jmp    8019e4 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80186c:	83 ec 08             	sub    $0x8,%esp
  80186f:	ff 75 e8             	pushl  -0x18(%ebp)
  801872:	8d 45 14             	lea    0x14(%ebp),%eax
  801875:	50                   	push   %eax
  801876:	e8 3c fd ff ff       	call   8015b7 <getint>
  80187b:	83 c4 10             	add    $0x10,%esp
  80187e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801881:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801884:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801887:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80188a:	85 d2                	test   %edx,%edx
  80188c:	79 23                	jns    8018b1 <vprintfmt+0x29b>
				putch('-', putdat);
  80188e:	83 ec 08             	sub    $0x8,%esp
  801891:	ff 75 0c             	pushl  0xc(%ebp)
  801894:	6a 2d                	push   $0x2d
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	ff d0                	call   *%eax
  80189b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80189e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a4:	f7 d8                	neg    %eax
  8018a6:	83 d2 00             	adc    $0x0,%edx
  8018a9:	f7 da                	neg    %edx
  8018ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8018b1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8018b8:	e9 bc 00 00 00       	jmp    801979 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8018bd:	83 ec 08             	sub    $0x8,%esp
  8018c0:	ff 75 e8             	pushl  -0x18(%ebp)
  8018c3:	8d 45 14             	lea    0x14(%ebp),%eax
  8018c6:	50                   	push   %eax
  8018c7:	e8 84 fc ff ff       	call   801550 <getuint>
  8018cc:	83 c4 10             	add    $0x10,%esp
  8018cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018d2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8018d5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8018dc:	e9 98 00 00 00       	jmp    801979 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8018e1:	83 ec 08             	sub    $0x8,%esp
  8018e4:	ff 75 0c             	pushl  0xc(%ebp)
  8018e7:	6a 58                	push   $0x58
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	ff d0                	call   *%eax
  8018ee:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8018f1:	83 ec 08             	sub    $0x8,%esp
  8018f4:	ff 75 0c             	pushl  0xc(%ebp)
  8018f7:	6a 58                	push   $0x58
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	ff d0                	call   *%eax
  8018fe:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801901:	83 ec 08             	sub    $0x8,%esp
  801904:	ff 75 0c             	pushl  0xc(%ebp)
  801907:	6a 58                	push   $0x58
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	ff d0                	call   *%eax
  80190e:	83 c4 10             	add    $0x10,%esp
			break;
  801911:	e9 ce 00 00 00       	jmp    8019e4 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801916:	83 ec 08             	sub    $0x8,%esp
  801919:	ff 75 0c             	pushl  0xc(%ebp)
  80191c:	6a 30                	push   $0x30
  80191e:	8b 45 08             	mov    0x8(%ebp),%eax
  801921:	ff d0                	call   *%eax
  801923:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801926:	83 ec 08             	sub    $0x8,%esp
  801929:	ff 75 0c             	pushl  0xc(%ebp)
  80192c:	6a 78                	push   $0x78
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	ff d0                	call   *%eax
  801933:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801936:	8b 45 14             	mov    0x14(%ebp),%eax
  801939:	83 c0 04             	add    $0x4,%eax
  80193c:	89 45 14             	mov    %eax,0x14(%ebp)
  80193f:	8b 45 14             	mov    0x14(%ebp),%eax
  801942:	83 e8 04             	sub    $0x4,%eax
  801945:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801947:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80194a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801951:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801958:	eb 1f                	jmp    801979 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80195a:	83 ec 08             	sub    $0x8,%esp
  80195d:	ff 75 e8             	pushl  -0x18(%ebp)
  801960:	8d 45 14             	lea    0x14(%ebp),%eax
  801963:	50                   	push   %eax
  801964:	e8 e7 fb ff ff       	call   801550 <getuint>
  801969:	83 c4 10             	add    $0x10,%esp
  80196c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80196f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801972:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801979:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80197d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801980:	83 ec 04             	sub    $0x4,%esp
  801983:	52                   	push   %edx
  801984:	ff 75 e4             	pushl  -0x1c(%ebp)
  801987:	50                   	push   %eax
  801988:	ff 75 f4             	pushl  -0xc(%ebp)
  80198b:	ff 75 f0             	pushl  -0x10(%ebp)
  80198e:	ff 75 0c             	pushl  0xc(%ebp)
  801991:	ff 75 08             	pushl  0x8(%ebp)
  801994:	e8 00 fb ff ff       	call   801499 <printnum>
  801999:	83 c4 20             	add    $0x20,%esp
			break;
  80199c:	eb 46                	jmp    8019e4 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80199e:	83 ec 08             	sub    $0x8,%esp
  8019a1:	ff 75 0c             	pushl  0xc(%ebp)
  8019a4:	53                   	push   %ebx
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	ff d0                	call   *%eax
  8019aa:	83 c4 10             	add    $0x10,%esp
			break;
  8019ad:	eb 35                	jmp    8019e4 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8019af:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  8019b6:	eb 2c                	jmp    8019e4 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8019b8:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  8019bf:	eb 23                	jmp    8019e4 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8019c1:	83 ec 08             	sub    $0x8,%esp
  8019c4:	ff 75 0c             	pushl  0xc(%ebp)
  8019c7:	6a 25                	push   $0x25
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	ff d0                	call   *%eax
  8019ce:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8019d1:	ff 4d 10             	decl   0x10(%ebp)
  8019d4:	eb 03                	jmp    8019d9 <vprintfmt+0x3c3>
  8019d6:	ff 4d 10             	decl   0x10(%ebp)
  8019d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019dc:	48                   	dec    %eax
  8019dd:	8a 00                	mov    (%eax),%al
  8019df:	3c 25                	cmp    $0x25,%al
  8019e1:	75 f3                	jne    8019d6 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8019e3:	90                   	nop
		}
	}
  8019e4:	e9 35 fc ff ff       	jmp    80161e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8019e9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8019ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ed:	5b                   	pop    %ebx
  8019ee:	5e                   	pop    %esi
  8019ef:	5d                   	pop    %ebp
  8019f0:	c3                   	ret    

008019f1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8019f7:	8d 45 10             	lea    0x10(%ebp),%eax
  8019fa:	83 c0 04             	add    $0x4,%eax
  8019fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801a00:	8b 45 10             	mov    0x10(%ebp),%eax
  801a03:	ff 75 f4             	pushl  -0xc(%ebp)
  801a06:	50                   	push   %eax
  801a07:	ff 75 0c             	pushl  0xc(%ebp)
  801a0a:	ff 75 08             	pushl  0x8(%ebp)
  801a0d:	e8 04 fc ff ff       	call   801616 <vprintfmt>
  801a12:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801a15:	90                   	nop
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1e:	8b 40 08             	mov    0x8(%eax),%eax
  801a21:	8d 50 01             	lea    0x1(%eax),%edx
  801a24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a27:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2d:	8b 10                	mov    (%eax),%edx
  801a2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a32:	8b 40 04             	mov    0x4(%eax),%eax
  801a35:	39 c2                	cmp    %eax,%edx
  801a37:	73 12                	jae    801a4b <sprintputch+0x33>
		*b->buf++ = ch;
  801a39:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3c:	8b 00                	mov    (%eax),%eax
  801a3e:	8d 48 01             	lea    0x1(%eax),%ecx
  801a41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a44:	89 0a                	mov    %ecx,(%edx)
  801a46:	8b 55 08             	mov    0x8(%ebp),%edx
  801a49:	88 10                	mov    %dl,(%eax)
}
  801a4b:	90                   	nop
  801a4c:	5d                   	pop    %ebp
  801a4d:	c3                   	ret    

00801a4e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
  801a51:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	01 d0                	add    %edx,%eax
  801a65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801a6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a73:	74 06                	je     801a7b <vsnprintf+0x2d>
  801a75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a79:	7f 07                	jg     801a82 <vsnprintf+0x34>
		return -E_INVAL;
  801a7b:	b8 03 00 00 00       	mov    $0x3,%eax
  801a80:	eb 20                	jmp    801aa2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801a82:	ff 75 14             	pushl  0x14(%ebp)
  801a85:	ff 75 10             	pushl  0x10(%ebp)
  801a88:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801a8b:	50                   	push   %eax
  801a8c:	68 18 1a 80 00       	push   $0x801a18
  801a91:	e8 80 fb ff ff       	call   801616 <vprintfmt>
  801a96:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801a99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a9c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801aaa:	8d 45 10             	lea    0x10(%ebp),%eax
  801aad:	83 c0 04             	add    $0x4,%eax
  801ab0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801ab3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ab9:	50                   	push   %eax
  801aba:	ff 75 0c             	pushl  0xc(%ebp)
  801abd:	ff 75 08             	pushl  0x8(%ebp)
  801ac0:	e8 89 ff ff ff       	call   801a4e <vsnprintf>
  801ac5:	83 c4 10             	add    $0x10,%esp
  801ac8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
  801ad3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801ad6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801add:	eb 06                	jmp    801ae5 <strlen+0x15>
		n++;
  801adf:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801ae2:	ff 45 08             	incl   0x8(%ebp)
  801ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae8:	8a 00                	mov    (%eax),%al
  801aea:	84 c0                	test   %al,%al
  801aec:	75 f1                	jne    801adf <strlen+0xf>
		n++;
	return n;
  801aee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801af9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b00:	eb 09                	jmp    801b0b <strnlen+0x18>
		n++;
  801b02:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b05:	ff 45 08             	incl   0x8(%ebp)
  801b08:	ff 4d 0c             	decl   0xc(%ebp)
  801b0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b0f:	74 09                	je     801b1a <strnlen+0x27>
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	8a 00                	mov    (%eax),%al
  801b16:	84 c0                	test   %al,%al
  801b18:	75 e8                	jne    801b02 <strnlen+0xf>
		n++;
	return n;
  801b1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801b25:	8b 45 08             	mov    0x8(%ebp),%eax
  801b28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801b2b:	90                   	nop
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	8d 50 01             	lea    0x1(%eax),%edx
  801b32:	89 55 08             	mov    %edx,0x8(%ebp)
  801b35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b38:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b3b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801b3e:	8a 12                	mov    (%edx),%dl
  801b40:	88 10                	mov    %dl,(%eax)
  801b42:	8a 00                	mov    (%eax),%al
  801b44:	84 c0                	test   %al,%al
  801b46:	75 e4                	jne    801b2c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801b48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
  801b50:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801b59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b60:	eb 1f                	jmp    801b81 <strncpy+0x34>
		*dst++ = *src;
  801b62:	8b 45 08             	mov    0x8(%ebp),%eax
  801b65:	8d 50 01             	lea    0x1(%eax),%edx
  801b68:	89 55 08             	mov    %edx,0x8(%ebp)
  801b6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6e:	8a 12                	mov    (%edx),%dl
  801b70:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801b72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b75:	8a 00                	mov    (%eax),%al
  801b77:	84 c0                	test   %al,%al
  801b79:	74 03                	je     801b7e <strncpy+0x31>
			src++;
  801b7b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801b7e:	ff 45 fc             	incl   -0x4(%ebp)
  801b81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b84:	3b 45 10             	cmp    0x10(%ebp),%eax
  801b87:	72 d9                	jb     801b62 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801b89:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
  801b91:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801b9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b9e:	74 30                	je     801bd0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801ba0:	eb 16                	jmp    801bb8 <strlcpy+0x2a>
			*dst++ = *src++;
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba5:	8d 50 01             	lea    0x1(%eax),%edx
  801ba8:	89 55 08             	mov    %edx,0x8(%ebp)
  801bab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bae:	8d 4a 01             	lea    0x1(%edx),%ecx
  801bb1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801bb4:	8a 12                	mov    (%edx),%dl
  801bb6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801bb8:	ff 4d 10             	decl   0x10(%ebp)
  801bbb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bbf:	74 09                	je     801bca <strlcpy+0x3c>
  801bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc4:	8a 00                	mov    (%eax),%al
  801bc6:	84 c0                	test   %al,%al
  801bc8:	75 d8                	jne    801ba2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801bca:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801bd0:	8b 55 08             	mov    0x8(%ebp),%edx
  801bd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bd6:	29 c2                	sub    %eax,%edx
  801bd8:	89 d0                	mov    %edx,%eax
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801bdf:	eb 06                	jmp    801be7 <strcmp+0xb>
		p++, q++;
  801be1:	ff 45 08             	incl   0x8(%ebp)
  801be4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801be7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bea:	8a 00                	mov    (%eax),%al
  801bec:	84 c0                	test   %al,%al
  801bee:	74 0e                	je     801bfe <strcmp+0x22>
  801bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf3:	8a 10                	mov    (%eax),%dl
  801bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf8:	8a 00                	mov    (%eax),%al
  801bfa:	38 c2                	cmp    %al,%dl
  801bfc:	74 e3                	je     801be1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801c01:	8a 00                	mov    (%eax),%al
  801c03:	0f b6 d0             	movzbl %al,%edx
  801c06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c09:	8a 00                	mov    (%eax),%al
  801c0b:	0f b6 c0             	movzbl %al,%eax
  801c0e:	29 c2                	sub    %eax,%edx
  801c10:	89 d0                	mov    %edx,%eax
}
  801c12:	5d                   	pop    %ebp
  801c13:	c3                   	ret    

00801c14 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801c17:	eb 09                	jmp    801c22 <strncmp+0xe>
		n--, p++, q++;
  801c19:	ff 4d 10             	decl   0x10(%ebp)
  801c1c:	ff 45 08             	incl   0x8(%ebp)
  801c1f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801c22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c26:	74 17                	je     801c3f <strncmp+0x2b>
  801c28:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2b:	8a 00                	mov    (%eax),%al
  801c2d:	84 c0                	test   %al,%al
  801c2f:	74 0e                	je     801c3f <strncmp+0x2b>
  801c31:	8b 45 08             	mov    0x8(%ebp),%eax
  801c34:	8a 10                	mov    (%eax),%dl
  801c36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c39:	8a 00                	mov    (%eax),%al
  801c3b:	38 c2                	cmp    %al,%dl
  801c3d:	74 da                	je     801c19 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801c3f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c43:	75 07                	jne    801c4c <strncmp+0x38>
		return 0;
  801c45:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4a:	eb 14                	jmp    801c60 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	8a 00                	mov    (%eax),%al
  801c51:	0f b6 d0             	movzbl %al,%edx
  801c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c57:	8a 00                	mov    (%eax),%al
  801c59:	0f b6 c0             	movzbl %al,%eax
  801c5c:	29 c2                	sub    %eax,%edx
  801c5e:	89 d0                	mov    %edx,%eax
}
  801c60:	5d                   	pop    %ebp
  801c61:	c3                   	ret    

00801c62 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	83 ec 04             	sub    $0x4,%esp
  801c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801c6e:	eb 12                	jmp    801c82 <strchr+0x20>
		if (*s == c)
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	8a 00                	mov    (%eax),%al
  801c75:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801c78:	75 05                	jne    801c7f <strchr+0x1d>
			return (char *) s;
  801c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7d:	eb 11                	jmp    801c90 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801c7f:	ff 45 08             	incl   0x8(%ebp)
  801c82:	8b 45 08             	mov    0x8(%ebp),%eax
  801c85:	8a 00                	mov    (%eax),%al
  801c87:	84 c0                	test   %al,%al
  801c89:	75 e5                	jne    801c70 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801c8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
  801c95:	83 ec 04             	sub    $0x4,%esp
  801c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c9b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801c9e:	eb 0d                	jmp    801cad <strfind+0x1b>
		if (*s == c)
  801ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca3:	8a 00                	mov    (%eax),%al
  801ca5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801ca8:	74 0e                	je     801cb8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801caa:	ff 45 08             	incl   0x8(%ebp)
  801cad:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb0:	8a 00                	mov    (%eax),%al
  801cb2:	84 c0                	test   %al,%al
  801cb4:	75 ea                	jne    801ca0 <strfind+0xe>
  801cb6:	eb 01                	jmp    801cb9 <strfind+0x27>
		if (*s == c)
			break;
  801cb8:	90                   	nop
	return (char *) s;
  801cb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    

00801cbe <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
  801cc1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801cca:	8b 45 10             	mov    0x10(%ebp),%eax
  801ccd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801cd0:	eb 0e                	jmp    801ce0 <memset+0x22>
		*p++ = c;
  801cd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cd5:	8d 50 01             	lea    0x1(%eax),%edx
  801cd8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801cdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cde:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801ce0:	ff 4d f8             	decl   -0x8(%ebp)
  801ce3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801ce7:	79 e9                	jns    801cd2 <memset+0x14>
		*p++ = c;

	return v;
  801ce9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
  801cf1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801cf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801d00:	eb 16                	jmp    801d18 <memcpy+0x2a>
		*d++ = *s++;
  801d02:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d05:	8d 50 01             	lea    0x1(%eax),%edx
  801d08:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801d0b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d0e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d11:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801d14:	8a 12                	mov    (%edx),%dl
  801d16:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801d18:	8b 45 10             	mov    0x10(%ebp),%eax
  801d1b:	8d 50 ff             	lea    -0x1(%eax),%edx
  801d1e:	89 55 10             	mov    %edx,0x10(%ebp)
  801d21:	85 c0                	test   %eax,%eax
  801d23:	75 dd                	jne    801d02 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801d30:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801d36:	8b 45 08             	mov    0x8(%ebp),%eax
  801d39:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801d3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d3f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801d42:	73 50                	jae    801d94 <memmove+0x6a>
  801d44:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d47:	8b 45 10             	mov    0x10(%ebp),%eax
  801d4a:	01 d0                	add    %edx,%eax
  801d4c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801d4f:	76 43                	jbe    801d94 <memmove+0x6a>
		s += n;
  801d51:	8b 45 10             	mov    0x10(%ebp),%eax
  801d54:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801d57:	8b 45 10             	mov    0x10(%ebp),%eax
  801d5a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801d5d:	eb 10                	jmp    801d6f <memmove+0x45>
			*--d = *--s;
  801d5f:	ff 4d f8             	decl   -0x8(%ebp)
  801d62:	ff 4d fc             	decl   -0x4(%ebp)
  801d65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d68:	8a 10                	mov    (%eax),%dl
  801d6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d6d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801d6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d72:	8d 50 ff             	lea    -0x1(%eax),%edx
  801d75:	89 55 10             	mov    %edx,0x10(%ebp)
  801d78:	85 c0                	test   %eax,%eax
  801d7a:	75 e3                	jne    801d5f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801d7c:	eb 23                	jmp    801da1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801d7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d81:	8d 50 01             	lea    0x1(%eax),%edx
  801d84:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801d87:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d8a:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d8d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801d90:	8a 12                	mov    (%edx),%dl
  801d92:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801d94:	8b 45 10             	mov    0x10(%ebp),%eax
  801d97:	8d 50 ff             	lea    -0x1(%eax),%edx
  801d9a:	89 55 10             	mov    %edx,0x10(%ebp)
  801d9d:	85 c0                	test   %eax,%eax
  801d9f:	75 dd                	jne    801d7e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801da1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
  801da9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801dac:	8b 45 08             	mov    0x8(%ebp),%eax
  801daf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801db8:	eb 2a                	jmp    801de4 <memcmp+0x3e>
		if (*s1 != *s2)
  801dba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dbd:	8a 10                	mov    (%eax),%dl
  801dbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dc2:	8a 00                	mov    (%eax),%al
  801dc4:	38 c2                	cmp    %al,%dl
  801dc6:	74 16                	je     801dde <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801dc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dcb:	8a 00                	mov    (%eax),%al
  801dcd:	0f b6 d0             	movzbl %al,%edx
  801dd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dd3:	8a 00                	mov    (%eax),%al
  801dd5:	0f b6 c0             	movzbl %al,%eax
  801dd8:	29 c2                	sub    %eax,%edx
  801dda:	89 d0                	mov    %edx,%eax
  801ddc:	eb 18                	jmp    801df6 <memcmp+0x50>
		s1++, s2++;
  801dde:	ff 45 fc             	incl   -0x4(%ebp)
  801de1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801de4:	8b 45 10             	mov    0x10(%ebp),%eax
  801de7:	8d 50 ff             	lea    -0x1(%eax),%edx
  801dea:	89 55 10             	mov    %edx,0x10(%ebp)
  801ded:	85 c0                	test   %eax,%eax
  801def:	75 c9                	jne    801dba <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801df1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    

00801df8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
  801dfb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801dfe:	8b 55 08             	mov    0x8(%ebp),%edx
  801e01:	8b 45 10             	mov    0x10(%ebp),%eax
  801e04:	01 d0                	add    %edx,%eax
  801e06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801e09:	eb 15                	jmp    801e20 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0e:	8a 00                	mov    (%eax),%al
  801e10:	0f b6 d0             	movzbl %al,%edx
  801e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e16:	0f b6 c0             	movzbl %al,%eax
  801e19:	39 c2                	cmp    %eax,%edx
  801e1b:	74 0d                	je     801e2a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801e1d:	ff 45 08             	incl   0x8(%ebp)
  801e20:	8b 45 08             	mov    0x8(%ebp),%eax
  801e23:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801e26:	72 e3                	jb     801e0b <memfind+0x13>
  801e28:	eb 01                	jmp    801e2b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801e2a:	90                   	nop
	return (void *) s;
  801e2b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
  801e33:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801e36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801e3d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e44:	eb 03                	jmp    801e49 <strtol+0x19>
		s++;
  801e46:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e49:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4c:	8a 00                	mov    (%eax),%al
  801e4e:	3c 20                	cmp    $0x20,%al
  801e50:	74 f4                	je     801e46 <strtol+0x16>
  801e52:	8b 45 08             	mov    0x8(%ebp),%eax
  801e55:	8a 00                	mov    (%eax),%al
  801e57:	3c 09                	cmp    $0x9,%al
  801e59:	74 eb                	je     801e46 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	8a 00                	mov    (%eax),%al
  801e60:	3c 2b                	cmp    $0x2b,%al
  801e62:	75 05                	jne    801e69 <strtol+0x39>
		s++;
  801e64:	ff 45 08             	incl   0x8(%ebp)
  801e67:	eb 13                	jmp    801e7c <strtol+0x4c>
	else if (*s == '-')
  801e69:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6c:	8a 00                	mov    (%eax),%al
  801e6e:	3c 2d                	cmp    $0x2d,%al
  801e70:	75 0a                	jne    801e7c <strtol+0x4c>
		s++, neg = 1;
  801e72:	ff 45 08             	incl   0x8(%ebp)
  801e75:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e80:	74 06                	je     801e88 <strtol+0x58>
  801e82:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801e86:	75 20                	jne    801ea8 <strtol+0x78>
  801e88:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8b:	8a 00                	mov    (%eax),%al
  801e8d:	3c 30                	cmp    $0x30,%al
  801e8f:	75 17                	jne    801ea8 <strtol+0x78>
  801e91:	8b 45 08             	mov    0x8(%ebp),%eax
  801e94:	40                   	inc    %eax
  801e95:	8a 00                	mov    (%eax),%al
  801e97:	3c 78                	cmp    $0x78,%al
  801e99:	75 0d                	jne    801ea8 <strtol+0x78>
		s += 2, base = 16;
  801e9b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801e9f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801ea6:	eb 28                	jmp    801ed0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801ea8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eac:	75 15                	jne    801ec3 <strtol+0x93>
  801eae:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb1:	8a 00                	mov    (%eax),%al
  801eb3:	3c 30                	cmp    $0x30,%al
  801eb5:	75 0c                	jne    801ec3 <strtol+0x93>
		s++, base = 8;
  801eb7:	ff 45 08             	incl   0x8(%ebp)
  801eba:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801ec1:	eb 0d                	jmp    801ed0 <strtol+0xa0>
	else if (base == 0)
  801ec3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ec7:	75 07                	jne    801ed0 <strtol+0xa0>
		base = 10;
  801ec9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed3:	8a 00                	mov    (%eax),%al
  801ed5:	3c 2f                	cmp    $0x2f,%al
  801ed7:	7e 19                	jle    801ef2 <strtol+0xc2>
  801ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  801edc:	8a 00                	mov    (%eax),%al
  801ede:	3c 39                	cmp    $0x39,%al
  801ee0:	7f 10                	jg     801ef2 <strtol+0xc2>
			dig = *s - '0';
  801ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee5:	8a 00                	mov    (%eax),%al
  801ee7:	0f be c0             	movsbl %al,%eax
  801eea:	83 e8 30             	sub    $0x30,%eax
  801eed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ef0:	eb 42                	jmp    801f34 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef5:	8a 00                	mov    (%eax),%al
  801ef7:	3c 60                	cmp    $0x60,%al
  801ef9:	7e 19                	jle    801f14 <strtol+0xe4>
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	8a 00                	mov    (%eax),%al
  801f00:	3c 7a                	cmp    $0x7a,%al
  801f02:	7f 10                	jg     801f14 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801f04:	8b 45 08             	mov    0x8(%ebp),%eax
  801f07:	8a 00                	mov    (%eax),%al
  801f09:	0f be c0             	movsbl %al,%eax
  801f0c:	83 e8 57             	sub    $0x57,%eax
  801f0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f12:	eb 20                	jmp    801f34 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801f14:	8b 45 08             	mov    0x8(%ebp),%eax
  801f17:	8a 00                	mov    (%eax),%al
  801f19:	3c 40                	cmp    $0x40,%al
  801f1b:	7e 39                	jle    801f56 <strtol+0x126>
  801f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f20:	8a 00                	mov    (%eax),%al
  801f22:	3c 5a                	cmp    $0x5a,%al
  801f24:	7f 30                	jg     801f56 <strtol+0x126>
			dig = *s - 'A' + 10;
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	8a 00                	mov    (%eax),%al
  801f2b:	0f be c0             	movsbl %al,%eax
  801f2e:	83 e8 37             	sub    $0x37,%eax
  801f31:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f37:	3b 45 10             	cmp    0x10(%ebp),%eax
  801f3a:	7d 19                	jge    801f55 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801f3c:	ff 45 08             	incl   0x8(%ebp)
  801f3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f42:	0f af 45 10          	imul   0x10(%ebp),%eax
  801f46:	89 c2                	mov    %eax,%edx
  801f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4b:	01 d0                	add    %edx,%eax
  801f4d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801f50:	e9 7b ff ff ff       	jmp    801ed0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801f55:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801f56:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f5a:	74 08                	je     801f64 <strtol+0x134>
		*endptr = (char *) s;
  801f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  801f62:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801f64:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f68:	74 07                	je     801f71 <strtol+0x141>
  801f6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f6d:	f7 d8                	neg    %eax
  801f6f:	eb 03                	jmp    801f74 <strtol+0x144>
  801f71:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <ltostr>:

void
ltostr(long value, char *str)
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
  801f79:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801f7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801f83:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801f8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f8e:	79 13                	jns    801fa3 <ltostr+0x2d>
	{
		neg = 1;
  801f90:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f9a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801f9d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801fa0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801fab:	99                   	cltd   
  801fac:	f7 f9                	idiv   %ecx
  801fae:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801fb1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fb4:	8d 50 01             	lea    0x1(%eax),%edx
  801fb7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801fba:	89 c2                	mov    %eax,%edx
  801fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fbf:	01 d0                	add    %edx,%eax
  801fc1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fc4:	83 c2 30             	add    $0x30,%edx
  801fc7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801fc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fcc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801fd1:	f7 e9                	imul   %ecx
  801fd3:	c1 fa 02             	sar    $0x2,%edx
  801fd6:	89 c8                	mov    %ecx,%eax
  801fd8:	c1 f8 1f             	sar    $0x1f,%eax
  801fdb:	29 c2                	sub    %eax,%edx
  801fdd:	89 d0                	mov    %edx,%eax
  801fdf:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801fe2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fe6:	75 bb                	jne    801fa3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801fe8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801fef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ff2:	48                   	dec    %eax
  801ff3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801ff6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ffa:	74 3d                	je     802039 <ltostr+0xc3>
		start = 1 ;
  801ffc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802003:	eb 34                	jmp    802039 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802005:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802008:	8b 45 0c             	mov    0xc(%ebp),%eax
  80200b:	01 d0                	add    %edx,%eax
  80200d:	8a 00                	mov    (%eax),%al
  80200f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802012:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802015:	8b 45 0c             	mov    0xc(%ebp),%eax
  802018:	01 c2                	add    %eax,%edx
  80201a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80201d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802020:	01 c8                	add    %ecx,%eax
  802022:	8a 00                	mov    (%eax),%al
  802024:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802026:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802029:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202c:	01 c2                	add    %eax,%edx
  80202e:	8a 45 eb             	mov    -0x15(%ebp),%al
  802031:	88 02                	mov    %al,(%edx)
		start++ ;
  802033:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802036:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80203f:	7c c4                	jl     802005 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802041:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802044:	8b 45 0c             	mov    0xc(%ebp),%eax
  802047:	01 d0                	add    %edx,%eax
  802049:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80204c:	90                   	nop
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    

0080204f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802055:	ff 75 08             	pushl  0x8(%ebp)
  802058:	e8 73 fa ff ff       	call   801ad0 <strlen>
  80205d:	83 c4 04             	add    $0x4,%esp
  802060:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802063:	ff 75 0c             	pushl  0xc(%ebp)
  802066:	e8 65 fa ff ff       	call   801ad0 <strlen>
  80206b:	83 c4 04             	add    $0x4,%esp
  80206e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802071:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802078:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80207f:	eb 17                	jmp    802098 <strcconcat+0x49>
		final[s] = str1[s] ;
  802081:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802084:	8b 45 10             	mov    0x10(%ebp),%eax
  802087:	01 c2                	add    %eax,%edx
  802089:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	01 c8                	add    %ecx,%eax
  802091:	8a 00                	mov    (%eax),%al
  802093:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802095:	ff 45 fc             	incl   -0x4(%ebp)
  802098:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80209b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80209e:	7c e1                	jl     802081 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8020a0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8020a7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8020ae:	eb 1f                	jmp    8020cf <strcconcat+0x80>
		final[s++] = str2[i] ;
  8020b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020b3:	8d 50 01             	lea    0x1(%eax),%edx
  8020b6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8020b9:	89 c2                	mov    %eax,%edx
  8020bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8020be:	01 c2                	add    %eax,%edx
  8020c0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8020c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c6:	01 c8                	add    %ecx,%eax
  8020c8:	8a 00                	mov    (%eax),%al
  8020ca:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8020cc:	ff 45 f8             	incl   -0x8(%ebp)
  8020cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020d2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8020d5:	7c d9                	jl     8020b0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8020d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020da:	8b 45 10             	mov    0x10(%ebp),%eax
  8020dd:	01 d0                	add    %edx,%eax
  8020df:	c6 00 00             	movb   $0x0,(%eax)
}
  8020e2:	90                   	nop
  8020e3:	c9                   	leave  
  8020e4:	c3                   	ret    

008020e5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8020e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8020eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8020f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8020f4:	8b 00                	mov    (%eax),%eax
  8020f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8020fd:	8b 45 10             	mov    0x10(%ebp),%eax
  802100:	01 d0                	add    %edx,%eax
  802102:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802108:	eb 0c                	jmp    802116 <strsplit+0x31>
			*string++ = 0;
  80210a:	8b 45 08             	mov    0x8(%ebp),%eax
  80210d:	8d 50 01             	lea    0x1(%eax),%edx
  802110:	89 55 08             	mov    %edx,0x8(%ebp)
  802113:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802116:	8b 45 08             	mov    0x8(%ebp),%eax
  802119:	8a 00                	mov    (%eax),%al
  80211b:	84 c0                	test   %al,%al
  80211d:	74 18                	je     802137 <strsplit+0x52>
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	8a 00                	mov    (%eax),%al
  802124:	0f be c0             	movsbl %al,%eax
  802127:	50                   	push   %eax
  802128:	ff 75 0c             	pushl  0xc(%ebp)
  80212b:	e8 32 fb ff ff       	call   801c62 <strchr>
  802130:	83 c4 08             	add    $0x8,%esp
  802133:	85 c0                	test   %eax,%eax
  802135:	75 d3                	jne    80210a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802137:	8b 45 08             	mov    0x8(%ebp),%eax
  80213a:	8a 00                	mov    (%eax),%al
  80213c:	84 c0                	test   %al,%al
  80213e:	74 5a                	je     80219a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802140:	8b 45 14             	mov    0x14(%ebp),%eax
  802143:	8b 00                	mov    (%eax),%eax
  802145:	83 f8 0f             	cmp    $0xf,%eax
  802148:	75 07                	jne    802151 <strsplit+0x6c>
		{
			return 0;
  80214a:	b8 00 00 00 00       	mov    $0x0,%eax
  80214f:	eb 66                	jmp    8021b7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802151:	8b 45 14             	mov    0x14(%ebp),%eax
  802154:	8b 00                	mov    (%eax),%eax
  802156:	8d 48 01             	lea    0x1(%eax),%ecx
  802159:	8b 55 14             	mov    0x14(%ebp),%edx
  80215c:	89 0a                	mov    %ecx,(%edx)
  80215e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802165:	8b 45 10             	mov    0x10(%ebp),%eax
  802168:	01 c2                	add    %eax,%edx
  80216a:	8b 45 08             	mov    0x8(%ebp),%eax
  80216d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80216f:	eb 03                	jmp    802174 <strsplit+0x8f>
			string++;
  802171:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802174:	8b 45 08             	mov    0x8(%ebp),%eax
  802177:	8a 00                	mov    (%eax),%al
  802179:	84 c0                	test   %al,%al
  80217b:	74 8b                	je     802108 <strsplit+0x23>
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	8a 00                	mov    (%eax),%al
  802182:	0f be c0             	movsbl %al,%eax
  802185:	50                   	push   %eax
  802186:	ff 75 0c             	pushl  0xc(%ebp)
  802189:	e8 d4 fa ff ff       	call   801c62 <strchr>
  80218e:	83 c4 08             	add    $0x8,%esp
  802191:	85 c0                	test   %eax,%eax
  802193:	74 dc                	je     802171 <strsplit+0x8c>
			string++;
	}
  802195:	e9 6e ff ff ff       	jmp    802108 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80219a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80219b:	8b 45 14             	mov    0x14(%ebp),%eax
  80219e:	8b 00                	mov    (%eax),%eax
  8021a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8021a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8021aa:	01 d0                	add    %edx,%eax
  8021ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8021b2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021b7:	c9                   	leave  
  8021b8:	c3                   	ret    

008021b9 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
  8021bc:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8021bf:	83 ec 04             	sub    $0x4,%esp
  8021c2:	68 08 4d 80 00       	push   $0x804d08
  8021c7:	68 3f 01 00 00       	push   $0x13f
  8021cc:	68 2a 4d 80 00       	push   $0x804d2a
  8021d1:	e8 a9 ef ff ff       	call   80117f <_panic>

008021d6 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8021dc:	83 ec 0c             	sub    $0xc,%esp
  8021df:	ff 75 08             	pushl  0x8(%ebp)
  8021e2:	e8 90 0c 00 00       	call   802e77 <sys_sbrk>
  8021e7:	83 c4 10             	add    $0x10,%esp
}
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
  8021ef:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8021f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021f6:	75 0a                	jne    802202 <malloc+0x16>
		return NULL;
  8021f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fd:	e9 9e 01 00 00       	jmp    8023a0 <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  802202:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802209:	77 2c                	ja     802237 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  80220b:	e8 eb 0a 00 00       	call   802cfb <sys_isUHeapPlacementStrategyFIRSTFIT>
  802210:	85 c0                	test   %eax,%eax
  802212:	74 19                	je     80222d <malloc+0x41>

			void * block = alloc_block_FF(size);
  802214:	83 ec 0c             	sub    $0xc,%esp
  802217:	ff 75 08             	pushl  0x8(%ebp)
  80221a:	e8 85 11 00 00       	call   8033a4 <alloc_block_FF>
  80221f:	83 c4 10             	add    $0x10,%esp
  802222:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  802225:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802228:	e9 73 01 00 00       	jmp    8023a0 <malloc+0x1b4>
		} else {
			return NULL;
  80222d:	b8 00 00 00 00       	mov    $0x0,%eax
  802232:	e9 69 01 00 00       	jmp    8023a0 <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  802237:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80223e:	8b 55 08             	mov    0x8(%ebp),%edx
  802241:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802244:	01 d0                	add    %edx,%eax
  802246:	48                   	dec    %eax
  802247:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80224a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80224d:	ba 00 00 00 00       	mov    $0x0,%edx
  802252:	f7 75 e0             	divl   -0x20(%ebp)
  802255:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802258:	29 d0                	sub    %edx,%eax
  80225a:	c1 e8 0c             	shr    $0xc,%eax
  80225d:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  802260:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  802267:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  80226e:	a1 20 50 80 00       	mov    0x805020,%eax
  802273:	8b 40 7c             	mov    0x7c(%eax),%eax
  802276:	05 00 10 00 00       	add    $0x1000,%eax
  80227b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  80227e:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802283:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802286:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  802289:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802290:	8b 55 08             	mov    0x8(%ebp),%edx
  802293:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802296:	01 d0                	add    %edx,%eax
  802298:	48                   	dec    %eax
  802299:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80229c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80229f:	ba 00 00 00 00       	mov    $0x0,%edx
  8022a4:	f7 75 cc             	divl   -0x34(%ebp)
  8022a7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8022aa:	29 d0                	sub    %edx,%eax
  8022ac:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8022af:	76 0a                	jbe    8022bb <malloc+0xcf>
		return NULL;
  8022b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b6:	e9 e5 00 00 00       	jmp    8023a0 <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  8022bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8022c1:	eb 48                	jmp    80230b <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  8022c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c6:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8022c9:	c1 e8 0c             	shr    $0xc,%eax
  8022cc:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  8022cf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8022d2:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8022d9:	85 c0                	test   %eax,%eax
  8022db:	75 11                	jne    8022ee <malloc+0x102>
			freePagesCount++;
  8022dd:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8022e0:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8022e4:	75 16                	jne    8022fc <malloc+0x110>
				start = i;
  8022e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8022ec:	eb 0e                	jmp    8022fc <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  8022ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8022f5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  8022fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ff:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802302:	74 12                	je     802316 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  802304:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  80230b:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  802312:	76 af                	jbe    8022c3 <malloc+0xd7>
  802314:	eb 01                	jmp    802317 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  802316:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  802317:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80231b:	74 08                	je     802325 <malloc+0x139>
  80231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802320:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802323:	74 07                	je     80232c <malloc+0x140>
		return NULL;
  802325:	b8 00 00 00 00       	mov    $0x0,%eax
  80232a:	eb 74                	jmp    8023a0 <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  80232c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802332:	c1 e8 0c             	shr    $0xc,%eax
  802335:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  802338:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80233b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80233e:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  802345:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802348:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80234b:	eb 11                	jmp    80235e <malloc+0x172>
		markedPages[i] = 1;
  80234d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802350:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  802357:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  80235b:	ff 45 e8             	incl   -0x18(%ebp)
  80235e:	8b 55 c0             	mov    -0x40(%ebp),%edx
  802361:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802364:	01 d0                	add    %edx,%eax
  802366:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802369:	77 e2                	ja     80234d <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  80236b:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802372:	8b 55 08             	mov    0x8(%ebp),%edx
  802375:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802378:	01 d0                	add    %edx,%eax
  80237a:	48                   	dec    %eax
  80237b:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80237e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802381:	ba 00 00 00 00       	mov    $0x0,%edx
  802386:	f7 75 bc             	divl   -0x44(%ebp)
  802389:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80238c:	29 d0                	sub    %edx,%eax
  80238e:	83 ec 08             	sub    $0x8,%esp
  802391:	50                   	push   %eax
  802392:	ff 75 f0             	pushl  -0x10(%ebp)
  802395:	e8 14 0b 00 00       	call   802eae <sys_allocate_user_mem>
  80239a:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  80239d:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  8023a0:	c9                   	leave  
  8023a1:	c3                   	ret    

008023a2 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  8023a2:	55                   	push   %ebp
  8023a3:	89 e5                	mov    %esp,%ebp
  8023a5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  8023a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023ac:	0f 84 ee 00 00 00    	je     8024a0 <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  8023b2:	a1 20 50 80 00       	mov    0x805020,%eax
  8023b7:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  8023ba:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023bd:	77 09                	ja     8023c8 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  8023bf:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  8023c6:	76 14                	jbe    8023dc <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  8023c8:	83 ec 04             	sub    $0x4,%esp
  8023cb:	68 38 4d 80 00       	push   $0x804d38
  8023d0:	6a 68                	push   $0x68
  8023d2:	68 52 4d 80 00       	push   $0x804d52
  8023d7:	e8 a3 ed ff ff       	call   80117f <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  8023dc:	a1 20 50 80 00       	mov    0x805020,%eax
  8023e1:	8b 40 74             	mov    0x74(%eax),%eax
  8023e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023e7:	77 20                	ja     802409 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  8023e9:	a1 20 50 80 00       	mov    0x805020,%eax
  8023ee:	8b 40 78             	mov    0x78(%eax),%eax
  8023f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f4:	76 13                	jbe    802409 <free+0x67>
		free_block(virtual_address);
  8023f6:	83 ec 0c             	sub    $0xc,%esp
  8023f9:	ff 75 08             	pushl  0x8(%ebp)
  8023fc:	e8 6c 16 00 00       	call   803a6d <free_block>
  802401:	83 c4 10             	add    $0x10,%esp
		return;
  802404:	e9 98 00 00 00       	jmp    8024a1 <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  802409:	8b 55 08             	mov    0x8(%ebp),%edx
  80240c:	a1 20 50 80 00       	mov    0x805020,%eax
  802411:	8b 40 7c             	mov    0x7c(%eax),%eax
  802414:	29 c2                	sub    %eax,%edx
  802416:	89 d0                	mov    %edx,%eax
  802418:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  80241d:	c1 e8 0c             	shr    $0xc,%eax
  802420:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  802423:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80242a:	eb 16                	jmp    802442 <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  80242c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802432:	01 d0                	add    %edx,%eax
  802434:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  80243b:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  80243f:	ff 45 f4             	incl   -0xc(%ebp)
  802442:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802445:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  80244c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80244f:	7f db                	jg     80242c <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  802451:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802454:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  80245b:	c1 e0 0c             	shl    $0xc,%eax
  80245e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  802461:	8b 45 08             	mov    0x8(%ebp),%eax
  802464:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802467:	eb 1a                	jmp    802483 <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  802469:	83 ec 08             	sub    $0x8,%esp
  80246c:	68 00 10 00 00       	push   $0x1000
  802471:	ff 75 f0             	pushl  -0x10(%ebp)
  802474:	e8 19 0a 00 00       	call   802e92 <sys_free_user_mem>
  802479:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  80247c:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802483:	8b 55 08             	mov    0x8(%ebp),%edx
  802486:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802489:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  80248b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80248e:	77 d9                	ja     802469 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  802490:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802493:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  80249a:	00 00 00 00 
  80249e:	eb 01                	jmp    8024a1 <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  8024a0:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  8024a1:	c9                   	leave  
  8024a2:	c3                   	ret    

008024a3 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8024a3:	55                   	push   %ebp
  8024a4:	89 e5                	mov    %esp,%ebp
  8024a6:	83 ec 58             	sub    $0x58,%esp
  8024a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ac:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8024af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8024b3:	75 0a                	jne    8024bf <smalloc+0x1c>
		return NULL;
  8024b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ba:	e9 7d 01 00 00       	jmp    80263c <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8024bf:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8024c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024cc:	01 d0                	add    %edx,%eax
  8024ce:	48                   	dec    %eax
  8024cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8024d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8024da:	f7 75 e4             	divl   -0x1c(%ebp)
  8024dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024e0:	29 d0                	sub    %edx,%eax
  8024e2:	c1 e8 0c             	shr    $0xc,%eax
  8024e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  8024e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8024ef:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8024f6:	a1 20 50 80 00       	mov    0x805020,%eax
  8024fb:	8b 40 7c             	mov    0x7c(%eax),%eax
  8024fe:	05 00 10 00 00       	add    $0x1000,%eax
  802503:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  802506:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80250b:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80250e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  802511:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  802518:	8b 55 0c             	mov    0xc(%ebp),%edx
  80251b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80251e:	01 d0                	add    %edx,%eax
  802520:	48                   	dec    %eax
  802521:	89 45 cc             	mov    %eax,-0x34(%ebp)
  802524:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802527:	ba 00 00 00 00       	mov    $0x0,%edx
  80252c:	f7 75 d0             	divl   -0x30(%ebp)
  80252f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802532:	29 d0                	sub    %edx,%eax
  802534:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802537:	76 0a                	jbe    802543 <smalloc+0xa0>
		return NULL;
  802539:	b8 00 00 00 00       	mov    $0x0,%eax
  80253e:	e9 f9 00 00 00       	jmp    80263c <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  802543:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802546:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802549:	eb 48                	jmp    802593 <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  80254b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80254e:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802551:	c1 e8 0c             	shr    $0xc,%eax
  802554:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  802557:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80255a:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  802561:	85 c0                	test   %eax,%eax
  802563:	75 11                	jne    802576 <smalloc+0xd3>
			freePagesCount++;
  802565:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  802568:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80256c:	75 16                	jne    802584 <smalloc+0xe1>
				start = s;
  80256e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802571:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802574:	eb 0e                	jmp    802584 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  802576:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80257d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80258a:	74 12                	je     80259e <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80258c:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  802593:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80259a:	76 af                	jbe    80254b <smalloc+0xa8>
  80259c:	eb 01                	jmp    80259f <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  80259e:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  80259f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8025a3:	74 08                	je     8025ad <smalloc+0x10a>
  8025a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8025ab:	74 0a                	je     8025b7 <smalloc+0x114>
		return NULL;
  8025ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b2:	e9 85 00 00 00       	jmp    80263c <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8025b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ba:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8025bd:	c1 e8 0c             	shr    $0xc,%eax
  8025c0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  8025c3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025c6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8025c9:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8025d0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8025d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8025d6:	eb 11                	jmp    8025e9 <smalloc+0x146>
		markedPages[s] = 1;
  8025d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025db:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  8025e2:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8025e6:	ff 45 e8             	incl   -0x18(%ebp)
  8025e9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8025ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025ef:	01 d0                	add    %edx,%eax
  8025f1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8025f4:	77 e2                	ja     8025d8 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  8025f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025f9:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  8025fd:	52                   	push   %edx
  8025fe:	50                   	push   %eax
  8025ff:	ff 75 0c             	pushl  0xc(%ebp)
  802602:	ff 75 08             	pushl  0x8(%ebp)
  802605:	e8 8f 04 00 00       	call   802a99 <sys_createSharedObject>
  80260a:	83 c4 10             	add    $0x10,%esp
  80260d:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  802610:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  802614:	78 12                	js     802628 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  802616:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802619:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80261c:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  802623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802626:	eb 14                	jmp    80263c <smalloc+0x199>
	}
	free((void*) start);
  802628:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262b:	83 ec 0c             	sub    $0xc,%esp
  80262e:	50                   	push   %eax
  80262f:	e8 6e fd ff ff       	call   8023a2 <free>
  802634:	83 c4 10             	add    $0x10,%esp
	return NULL;
  802637:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80263c:	c9                   	leave  
  80263d:	c3                   	ret    

0080263e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  80263e:	55                   	push   %ebp
  80263f:	89 e5                	mov    %esp,%ebp
  802641:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  802644:	83 ec 08             	sub    $0x8,%esp
  802647:	ff 75 0c             	pushl  0xc(%ebp)
  80264a:	ff 75 08             	pushl  0x8(%ebp)
  80264d:	e8 71 04 00 00       	call   802ac3 <sys_getSizeOfSharedObject>
  802652:	83 c4 10             	add    $0x10,%esp
  802655:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  802658:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80265f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802662:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802665:	01 d0                	add    %edx,%eax
  802667:	48                   	dec    %eax
  802668:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80266b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80266e:	ba 00 00 00 00       	mov    $0x0,%edx
  802673:	f7 75 e0             	divl   -0x20(%ebp)
  802676:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802679:	29 d0                	sub    %edx,%eax
  80267b:	c1 e8 0c             	shr    $0xc,%eax
  80267e:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  802681:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  802688:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  80268f:	a1 20 50 80 00       	mov    0x805020,%eax
  802694:	8b 40 7c             	mov    0x7c(%eax),%eax
  802697:	05 00 10 00 00       	add    $0x1000,%eax
  80269c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  80269f:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8026a4:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8026a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  8026aa:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8026b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026b4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026b7:	01 d0                	add    %edx,%eax
  8026b9:	48                   	dec    %eax
  8026ba:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8026bd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8026c5:	f7 75 cc             	divl   -0x34(%ebp)
  8026c8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026cb:	29 d0                	sub    %edx,%eax
  8026cd:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8026d0:	76 0a                	jbe    8026dc <sget+0x9e>
		return NULL;
  8026d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d7:	e9 f7 00 00 00       	jmp    8027d3 <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8026dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026df:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8026e2:	eb 48                	jmp    80272c <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  8026e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e7:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8026ea:	c1 e8 0c             	shr    $0xc,%eax
  8026ed:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  8026f0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8026f3:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8026fa:	85 c0                	test   %eax,%eax
  8026fc:	75 11                	jne    80270f <sget+0xd1>
			free_Pages_Count++;
  8026fe:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  802701:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802705:	75 16                	jne    80271d <sget+0xdf>
				start = s;
  802707:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80270d:	eb 0e                	jmp    80271d <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  80270f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  802716:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  80271d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802720:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802723:	74 12                	je     802737 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  802725:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  80272c:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  802733:	76 af                	jbe    8026e4 <sget+0xa6>
  802735:	eb 01                	jmp    802738 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  802737:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  802738:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80273c:	74 08                	je     802746 <sget+0x108>
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802741:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802744:	74 0a                	je     802750 <sget+0x112>
		return NULL;
  802746:	b8 00 00 00 00       	mov    $0x0,%eax
  80274b:	e9 83 00 00 00       	jmp    8027d3 <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  802750:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802753:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802756:	c1 e8 0c             	shr    $0xc,%eax
  802759:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  80275c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80275f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802762:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  802769:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80276c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80276f:	eb 11                	jmp    802782 <sget+0x144>
		markedPages[k] = 1;
  802771:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802774:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  80277b:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  80277f:	ff 45 e8             	incl   -0x18(%ebp)
  802782:	8b 55 c0             	mov    -0x40(%ebp),%edx
  802785:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802788:	01 d0                	add    %edx,%eax
  80278a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80278d:	77 e2                	ja     802771 <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  80278f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802792:	83 ec 04             	sub    $0x4,%esp
  802795:	50                   	push   %eax
  802796:	ff 75 0c             	pushl  0xc(%ebp)
  802799:	ff 75 08             	pushl  0x8(%ebp)
  80279c:	e8 3f 03 00 00       	call   802ae0 <sys_getSharedObject>
  8027a1:	83 c4 10             	add    $0x10,%esp
  8027a4:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  8027a7:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  8027ab:	78 12                	js     8027bf <sget+0x181>
		shardIDs[startPage] = ss;
  8027ad:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8027b0:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8027b3:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  8027ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bd:	eb 14                	jmp    8027d3 <sget+0x195>
	}
	free((void*) start);
  8027bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c2:	83 ec 0c             	sub    $0xc,%esp
  8027c5:	50                   	push   %eax
  8027c6:	e8 d7 fb ff ff       	call   8023a2 <free>
  8027cb:	83 c4 10             	add    $0x10,%esp
	return NULL;
  8027ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027d3:	c9                   	leave  
  8027d4:	c3                   	ret    

008027d5 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  8027d5:	55                   	push   %ebp
  8027d6:	89 e5                	mov    %esp,%ebp
  8027d8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8027db:	8b 55 08             	mov    0x8(%ebp),%edx
  8027de:	a1 20 50 80 00       	mov    0x805020,%eax
  8027e3:	8b 40 7c             	mov    0x7c(%eax),%eax
  8027e6:	29 c2                	sub    %eax,%edx
  8027e8:	89 d0                	mov    %edx,%eax
  8027ea:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  8027ef:	c1 e8 0c             	shr    $0xc,%eax
  8027f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  8027ff:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  802802:	83 ec 08             	sub    $0x8,%esp
  802805:	ff 75 08             	pushl  0x8(%ebp)
  802808:	ff 75 f0             	pushl  -0x10(%ebp)
  80280b:	e8 ef 02 00 00       	call   802aff <sys_freeSharedObject>
  802810:	83 c4 10             	add    $0x10,%esp
  802813:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  802816:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80281a:	75 0e                	jne    80282a <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  802826:	ff ff ff ff 
	}

}
  80282a:	90                   	nop
  80282b:	c9                   	leave  
  80282c:	c3                   	ret    

0080282d <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  80282d:	55                   	push   %ebp
  80282e:	89 e5                	mov    %esp,%ebp
  802830:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802833:	83 ec 04             	sub    $0x4,%esp
  802836:	68 60 4d 80 00       	push   $0x804d60
  80283b:	68 19 01 00 00       	push   $0x119
  802840:	68 52 4d 80 00       	push   $0x804d52
  802845:	e8 35 e9 ff ff       	call   80117f <_panic>

0080284a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  80284a:	55                   	push   %ebp
  80284b:	89 e5                	mov    %esp,%ebp
  80284d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802850:	83 ec 04             	sub    $0x4,%esp
  802853:	68 86 4d 80 00       	push   $0x804d86
  802858:	68 23 01 00 00       	push   $0x123
  80285d:	68 52 4d 80 00       	push   $0x804d52
  802862:	e8 18 e9 ff ff       	call   80117f <_panic>

00802867 <shrink>:

}
void shrink(uint32 newSize) {
  802867:	55                   	push   %ebp
  802868:	89 e5                	mov    %esp,%ebp
  80286a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80286d:	83 ec 04             	sub    $0x4,%esp
  802870:	68 86 4d 80 00       	push   $0x804d86
  802875:	68 27 01 00 00       	push   $0x127
  80287a:	68 52 4d 80 00       	push   $0x804d52
  80287f:	e8 fb e8 ff ff       	call   80117f <_panic>

00802884 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  802884:	55                   	push   %ebp
  802885:	89 e5                	mov    %esp,%ebp
  802887:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80288a:	83 ec 04             	sub    $0x4,%esp
  80288d:	68 86 4d 80 00       	push   $0x804d86
  802892:	68 2b 01 00 00       	push   $0x12b
  802897:	68 52 4d 80 00       	push   $0x804d52
  80289c:	e8 de e8 ff ff       	call   80117f <_panic>

008028a1 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8028a1:	55                   	push   %ebp
  8028a2:	89 e5                	mov    %esp,%ebp
  8028a4:	57                   	push   %edi
  8028a5:	56                   	push   %esi
  8028a6:	53                   	push   %ebx
  8028a7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8028aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028b3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028b6:	8b 7d 18             	mov    0x18(%ebp),%edi
  8028b9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8028bc:	cd 30                	int    $0x30
  8028be:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  8028c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8028c4:	83 c4 10             	add    $0x10,%esp
  8028c7:	5b                   	pop    %ebx
  8028c8:	5e                   	pop    %esi
  8028c9:	5f                   	pop    %edi
  8028ca:	5d                   	pop    %ebp
  8028cb:	c3                   	ret    

008028cc <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8028cc:	55                   	push   %ebp
  8028cd:	89 e5                	mov    %esp,%ebp
  8028cf:	83 ec 04             	sub    $0x4,%esp
  8028d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8028d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8028d8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8028dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028df:	6a 00                	push   $0x0
  8028e1:	6a 00                	push   $0x0
  8028e3:	52                   	push   %edx
  8028e4:	ff 75 0c             	pushl  0xc(%ebp)
  8028e7:	50                   	push   %eax
  8028e8:	6a 00                	push   $0x0
  8028ea:	e8 b2 ff ff ff       	call   8028a1 <syscall>
  8028ef:	83 c4 18             	add    $0x18,%esp
}
  8028f2:	90                   	nop
  8028f3:	c9                   	leave  
  8028f4:	c3                   	ret    

008028f5 <sys_cgetc>:

int sys_cgetc(void) {
  8028f5:	55                   	push   %ebp
  8028f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8028f8:	6a 00                	push   $0x0
  8028fa:	6a 00                	push   $0x0
  8028fc:	6a 00                	push   $0x0
  8028fe:	6a 00                	push   $0x0
  802900:	6a 00                	push   $0x0
  802902:	6a 02                	push   $0x2
  802904:	e8 98 ff ff ff       	call   8028a1 <syscall>
  802909:	83 c4 18             	add    $0x18,%esp
}
  80290c:	c9                   	leave  
  80290d:	c3                   	ret    

0080290e <sys_lock_cons>:

void sys_lock_cons(void) {
  80290e:	55                   	push   %ebp
  80290f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802911:	6a 00                	push   $0x0
  802913:	6a 00                	push   $0x0
  802915:	6a 00                	push   $0x0
  802917:	6a 00                	push   $0x0
  802919:	6a 00                	push   $0x0
  80291b:	6a 03                	push   $0x3
  80291d:	e8 7f ff ff ff       	call   8028a1 <syscall>
  802922:	83 c4 18             	add    $0x18,%esp
}
  802925:	90                   	nop
  802926:	c9                   	leave  
  802927:	c3                   	ret    

00802928 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  802928:	55                   	push   %ebp
  802929:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80292b:	6a 00                	push   $0x0
  80292d:	6a 00                	push   $0x0
  80292f:	6a 00                	push   $0x0
  802931:	6a 00                	push   $0x0
  802933:	6a 00                	push   $0x0
  802935:	6a 04                	push   $0x4
  802937:	e8 65 ff ff ff       	call   8028a1 <syscall>
  80293c:	83 c4 18             	add    $0x18,%esp
}
  80293f:	90                   	nop
  802940:	c9                   	leave  
  802941:	c3                   	ret    

00802942 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  802942:	55                   	push   %ebp
  802943:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  802945:	8b 55 0c             	mov    0xc(%ebp),%edx
  802948:	8b 45 08             	mov    0x8(%ebp),%eax
  80294b:	6a 00                	push   $0x0
  80294d:	6a 00                	push   $0x0
  80294f:	6a 00                	push   $0x0
  802951:	52                   	push   %edx
  802952:	50                   	push   %eax
  802953:	6a 08                	push   $0x8
  802955:	e8 47 ff ff ff       	call   8028a1 <syscall>
  80295a:	83 c4 18             	add    $0x18,%esp
}
  80295d:	c9                   	leave  
  80295e:	c3                   	ret    

0080295f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  80295f:	55                   	push   %ebp
  802960:	89 e5                	mov    %esp,%ebp
  802962:	56                   	push   %esi
  802963:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  802964:	8b 75 18             	mov    0x18(%ebp),%esi
  802967:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80296a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80296d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802970:	8b 45 08             	mov    0x8(%ebp),%eax
  802973:	56                   	push   %esi
  802974:	53                   	push   %ebx
  802975:	51                   	push   %ecx
  802976:	52                   	push   %edx
  802977:	50                   	push   %eax
  802978:	6a 09                	push   $0x9
  80297a:	e8 22 ff ff ff       	call   8028a1 <syscall>
  80297f:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  802982:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802985:	5b                   	pop    %ebx
  802986:	5e                   	pop    %esi
  802987:	5d                   	pop    %ebp
  802988:	c3                   	ret    

00802989 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  802989:	55                   	push   %ebp
  80298a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80298c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80298f:	8b 45 08             	mov    0x8(%ebp),%eax
  802992:	6a 00                	push   $0x0
  802994:	6a 00                	push   $0x0
  802996:	6a 00                	push   $0x0
  802998:	52                   	push   %edx
  802999:	50                   	push   %eax
  80299a:	6a 0a                	push   $0xa
  80299c:	e8 00 ff ff ff       	call   8028a1 <syscall>
  8029a1:	83 c4 18             	add    $0x18,%esp
}
  8029a4:	c9                   	leave  
  8029a5:	c3                   	ret    

008029a6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  8029a6:	55                   	push   %ebp
  8029a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  8029a9:	6a 00                	push   $0x0
  8029ab:	6a 00                	push   $0x0
  8029ad:	6a 00                	push   $0x0
  8029af:	ff 75 0c             	pushl  0xc(%ebp)
  8029b2:	ff 75 08             	pushl  0x8(%ebp)
  8029b5:	6a 0b                	push   $0xb
  8029b7:	e8 e5 fe ff ff       	call   8028a1 <syscall>
  8029bc:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  8029bf:	c9                   	leave  
  8029c0:	c3                   	ret    

008029c1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  8029c1:	55                   	push   %ebp
  8029c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8029c4:	6a 00                	push   $0x0
  8029c6:	6a 00                	push   $0x0
  8029c8:	6a 00                	push   $0x0
  8029ca:	6a 00                	push   $0x0
  8029cc:	6a 00                	push   $0x0
  8029ce:	6a 0c                	push   $0xc
  8029d0:	e8 cc fe ff ff       	call   8028a1 <syscall>
  8029d5:	83 c4 18             	add    $0x18,%esp
}
  8029d8:	c9                   	leave  
  8029d9:	c3                   	ret    

008029da <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  8029da:	55                   	push   %ebp
  8029db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8029dd:	6a 00                	push   $0x0
  8029df:	6a 00                	push   $0x0
  8029e1:	6a 00                	push   $0x0
  8029e3:	6a 00                	push   $0x0
  8029e5:	6a 00                	push   $0x0
  8029e7:	6a 0d                	push   $0xd
  8029e9:	e8 b3 fe ff ff       	call   8028a1 <syscall>
  8029ee:	83 c4 18             	add    $0x18,%esp
}
  8029f1:	c9                   	leave  
  8029f2:	c3                   	ret    

008029f3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  8029f3:	55                   	push   %ebp
  8029f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8029f6:	6a 00                	push   $0x0
  8029f8:	6a 00                	push   $0x0
  8029fa:	6a 00                	push   $0x0
  8029fc:	6a 00                	push   $0x0
  8029fe:	6a 00                	push   $0x0
  802a00:	6a 0e                	push   $0xe
  802a02:	e8 9a fe ff ff       	call   8028a1 <syscall>
  802a07:	83 c4 18             	add    $0x18,%esp
}
  802a0a:	c9                   	leave  
  802a0b:	c3                   	ret    

00802a0c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  802a0c:	55                   	push   %ebp
  802a0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  802a0f:	6a 00                	push   $0x0
  802a11:	6a 00                	push   $0x0
  802a13:	6a 00                	push   $0x0
  802a15:	6a 00                	push   $0x0
  802a17:	6a 00                	push   $0x0
  802a19:	6a 0f                	push   $0xf
  802a1b:	e8 81 fe ff ff       	call   8028a1 <syscall>
  802a20:	83 c4 18             	add    $0x18,%esp
}
  802a23:	c9                   	leave  
  802a24:	c3                   	ret    

00802a25 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  802a25:	55                   	push   %ebp
  802a26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  802a28:	6a 00                	push   $0x0
  802a2a:	6a 00                	push   $0x0
  802a2c:	6a 00                	push   $0x0
  802a2e:	6a 00                	push   $0x0
  802a30:	ff 75 08             	pushl  0x8(%ebp)
  802a33:	6a 10                	push   $0x10
  802a35:	e8 67 fe ff ff       	call   8028a1 <syscall>
  802a3a:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  802a3d:	c9                   	leave  
  802a3e:	c3                   	ret    

00802a3f <sys_scarce_memory>:

void sys_scarce_memory() {
  802a3f:	55                   	push   %ebp
  802a40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  802a42:	6a 00                	push   $0x0
  802a44:	6a 00                	push   $0x0
  802a46:	6a 00                	push   $0x0
  802a48:	6a 00                	push   $0x0
  802a4a:	6a 00                	push   $0x0
  802a4c:	6a 11                	push   $0x11
  802a4e:	e8 4e fe ff ff       	call   8028a1 <syscall>
  802a53:	83 c4 18             	add    $0x18,%esp
}
  802a56:	90                   	nop
  802a57:	c9                   	leave  
  802a58:	c3                   	ret    

00802a59 <sys_cputc>:

void sys_cputc(const char c) {
  802a59:	55                   	push   %ebp
  802a5a:	89 e5                	mov    %esp,%ebp
  802a5c:	83 ec 04             	sub    $0x4,%esp
  802a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a62:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802a65:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a69:	6a 00                	push   $0x0
  802a6b:	6a 00                	push   $0x0
  802a6d:	6a 00                	push   $0x0
  802a6f:	6a 00                	push   $0x0
  802a71:	50                   	push   %eax
  802a72:	6a 01                	push   $0x1
  802a74:	e8 28 fe ff ff       	call   8028a1 <syscall>
  802a79:	83 c4 18             	add    $0x18,%esp
}
  802a7c:	90                   	nop
  802a7d:	c9                   	leave  
  802a7e:	c3                   	ret    

00802a7f <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  802a7f:	55                   	push   %ebp
  802a80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  802a82:	6a 00                	push   $0x0
  802a84:	6a 00                	push   $0x0
  802a86:	6a 00                	push   $0x0
  802a88:	6a 00                	push   $0x0
  802a8a:	6a 00                	push   $0x0
  802a8c:	6a 14                	push   $0x14
  802a8e:	e8 0e fe ff ff       	call   8028a1 <syscall>
  802a93:	83 c4 18             	add    $0x18,%esp
}
  802a96:	90                   	nop
  802a97:	c9                   	leave  
  802a98:	c3                   	ret    

00802a99 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  802a99:	55                   	push   %ebp
  802a9a:	89 e5                	mov    %esp,%ebp
  802a9c:	83 ec 04             	sub    $0x4,%esp
  802a9f:	8b 45 10             	mov    0x10(%ebp),%eax
  802aa2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  802aa5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802aa8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802aac:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaf:	6a 00                	push   $0x0
  802ab1:	51                   	push   %ecx
  802ab2:	52                   	push   %edx
  802ab3:	ff 75 0c             	pushl  0xc(%ebp)
  802ab6:	50                   	push   %eax
  802ab7:	6a 15                	push   $0x15
  802ab9:	e8 e3 fd ff ff       	call   8028a1 <syscall>
  802abe:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  802ac1:	c9                   	leave  
  802ac2:	c3                   	ret    

00802ac3 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  802ac3:	55                   	push   %ebp
  802ac4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  802ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  802acc:	6a 00                	push   $0x0
  802ace:	6a 00                	push   $0x0
  802ad0:	6a 00                	push   $0x0
  802ad2:	52                   	push   %edx
  802ad3:	50                   	push   %eax
  802ad4:	6a 16                	push   $0x16
  802ad6:	e8 c6 fd ff ff       	call   8028a1 <syscall>
  802adb:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  802ade:	c9                   	leave  
  802adf:	c3                   	ret    

00802ae0 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  802ae0:	55                   	push   %ebp
  802ae1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  802ae3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ae6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aec:	6a 00                	push   $0x0
  802aee:	6a 00                	push   $0x0
  802af0:	51                   	push   %ecx
  802af1:	52                   	push   %edx
  802af2:	50                   	push   %eax
  802af3:	6a 17                	push   $0x17
  802af5:	e8 a7 fd ff ff       	call   8028a1 <syscall>
  802afa:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  802afd:	c9                   	leave  
  802afe:	c3                   	ret    

00802aff <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  802aff:	55                   	push   %ebp
  802b00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  802b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b05:	8b 45 08             	mov    0x8(%ebp),%eax
  802b08:	6a 00                	push   $0x0
  802b0a:	6a 00                	push   $0x0
  802b0c:	6a 00                	push   $0x0
  802b0e:	52                   	push   %edx
  802b0f:	50                   	push   %eax
  802b10:	6a 18                	push   $0x18
  802b12:	e8 8a fd ff ff       	call   8028a1 <syscall>
  802b17:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  802b1a:	c9                   	leave  
  802b1b:	c3                   	ret    

00802b1c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  802b1c:	55                   	push   %ebp
  802b1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  802b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b22:	6a 00                	push   $0x0
  802b24:	ff 75 14             	pushl  0x14(%ebp)
  802b27:	ff 75 10             	pushl  0x10(%ebp)
  802b2a:	ff 75 0c             	pushl  0xc(%ebp)
  802b2d:	50                   	push   %eax
  802b2e:	6a 19                	push   $0x19
  802b30:	e8 6c fd ff ff       	call   8028a1 <syscall>
  802b35:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  802b38:	c9                   	leave  
  802b39:	c3                   	ret    

00802b3a <sys_run_env>:

void sys_run_env(int32 envId) {
  802b3a:	55                   	push   %ebp
  802b3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  802b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b40:	6a 00                	push   $0x0
  802b42:	6a 00                	push   $0x0
  802b44:	6a 00                	push   $0x0
  802b46:	6a 00                	push   $0x0
  802b48:	50                   	push   %eax
  802b49:	6a 1a                	push   $0x1a
  802b4b:	e8 51 fd ff ff       	call   8028a1 <syscall>
  802b50:	83 c4 18             	add    $0x18,%esp
}
  802b53:	90                   	nop
  802b54:	c9                   	leave  
  802b55:	c3                   	ret    

00802b56 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  802b56:	55                   	push   %ebp
  802b57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802b59:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5c:	6a 00                	push   $0x0
  802b5e:	6a 00                	push   $0x0
  802b60:	6a 00                	push   $0x0
  802b62:	6a 00                	push   $0x0
  802b64:	50                   	push   %eax
  802b65:	6a 1b                	push   $0x1b
  802b67:	e8 35 fd ff ff       	call   8028a1 <syscall>
  802b6c:	83 c4 18             	add    $0x18,%esp
}
  802b6f:	c9                   	leave  
  802b70:	c3                   	ret    

00802b71 <sys_getenvid>:

int32 sys_getenvid(void) {
  802b71:	55                   	push   %ebp
  802b72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802b74:	6a 00                	push   $0x0
  802b76:	6a 00                	push   $0x0
  802b78:	6a 00                	push   $0x0
  802b7a:	6a 00                	push   $0x0
  802b7c:	6a 00                	push   $0x0
  802b7e:	6a 05                	push   $0x5
  802b80:	e8 1c fd ff ff       	call   8028a1 <syscall>
  802b85:	83 c4 18             	add    $0x18,%esp
}
  802b88:	c9                   	leave  
  802b89:	c3                   	ret    

00802b8a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  802b8a:	55                   	push   %ebp
  802b8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802b8d:	6a 00                	push   $0x0
  802b8f:	6a 00                	push   $0x0
  802b91:	6a 00                	push   $0x0
  802b93:	6a 00                	push   $0x0
  802b95:	6a 00                	push   $0x0
  802b97:	6a 06                	push   $0x6
  802b99:	e8 03 fd ff ff       	call   8028a1 <syscall>
  802b9e:	83 c4 18             	add    $0x18,%esp
}
  802ba1:	c9                   	leave  
  802ba2:	c3                   	ret    

00802ba3 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  802ba3:	55                   	push   %ebp
  802ba4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802ba6:	6a 00                	push   $0x0
  802ba8:	6a 00                	push   $0x0
  802baa:	6a 00                	push   $0x0
  802bac:	6a 00                	push   $0x0
  802bae:	6a 00                	push   $0x0
  802bb0:	6a 07                	push   $0x7
  802bb2:	e8 ea fc ff ff       	call   8028a1 <syscall>
  802bb7:	83 c4 18             	add    $0x18,%esp
}
  802bba:	c9                   	leave  
  802bbb:	c3                   	ret    

00802bbc <sys_exit_env>:

void sys_exit_env(void) {
  802bbc:	55                   	push   %ebp
  802bbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802bbf:	6a 00                	push   $0x0
  802bc1:	6a 00                	push   $0x0
  802bc3:	6a 00                	push   $0x0
  802bc5:	6a 00                	push   $0x0
  802bc7:	6a 00                	push   $0x0
  802bc9:	6a 1c                	push   $0x1c
  802bcb:	e8 d1 fc ff ff       	call   8028a1 <syscall>
  802bd0:	83 c4 18             	add    $0x18,%esp
}
  802bd3:	90                   	nop
  802bd4:	c9                   	leave  
  802bd5:	c3                   	ret    

00802bd6 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  802bd6:	55                   	push   %ebp
  802bd7:	89 e5                	mov    %esp,%ebp
  802bd9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  802bdc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802bdf:	8d 50 04             	lea    0x4(%eax),%edx
  802be2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802be5:	6a 00                	push   $0x0
  802be7:	6a 00                	push   $0x0
  802be9:	6a 00                	push   $0x0
  802beb:	52                   	push   %edx
  802bec:	50                   	push   %eax
  802bed:	6a 1d                	push   $0x1d
  802bef:	e8 ad fc ff ff       	call   8028a1 <syscall>
  802bf4:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  802bf7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802bfa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802bfd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802c00:	89 01                	mov    %eax,(%ecx)
  802c02:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802c05:	8b 45 08             	mov    0x8(%ebp),%eax
  802c08:	c9                   	leave  
  802c09:	c2 04 00             	ret    $0x4

00802c0c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  802c0c:	55                   	push   %ebp
  802c0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  802c0f:	6a 00                	push   $0x0
  802c11:	6a 00                	push   $0x0
  802c13:	ff 75 10             	pushl  0x10(%ebp)
  802c16:	ff 75 0c             	pushl  0xc(%ebp)
  802c19:	ff 75 08             	pushl  0x8(%ebp)
  802c1c:	6a 13                	push   $0x13
  802c1e:	e8 7e fc ff ff       	call   8028a1 <syscall>
  802c23:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  802c26:	90                   	nop
}
  802c27:	c9                   	leave  
  802c28:	c3                   	ret    

00802c29 <sys_rcr2>:
uint32 sys_rcr2() {
  802c29:	55                   	push   %ebp
  802c2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802c2c:	6a 00                	push   $0x0
  802c2e:	6a 00                	push   $0x0
  802c30:	6a 00                	push   $0x0
  802c32:	6a 00                	push   $0x0
  802c34:	6a 00                	push   $0x0
  802c36:	6a 1e                	push   $0x1e
  802c38:	e8 64 fc ff ff       	call   8028a1 <syscall>
  802c3d:	83 c4 18             	add    $0x18,%esp
}
  802c40:	c9                   	leave  
  802c41:	c3                   	ret    

00802c42 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  802c42:	55                   	push   %ebp
  802c43:	89 e5                	mov    %esp,%ebp
  802c45:	83 ec 04             	sub    $0x4,%esp
  802c48:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802c4e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802c52:	6a 00                	push   $0x0
  802c54:	6a 00                	push   $0x0
  802c56:	6a 00                	push   $0x0
  802c58:	6a 00                	push   $0x0
  802c5a:	50                   	push   %eax
  802c5b:	6a 1f                	push   $0x1f
  802c5d:	e8 3f fc ff ff       	call   8028a1 <syscall>
  802c62:	83 c4 18             	add    $0x18,%esp
	return;
  802c65:	90                   	nop
}
  802c66:	c9                   	leave  
  802c67:	c3                   	ret    

00802c68 <rsttst>:
void rsttst() {
  802c68:	55                   	push   %ebp
  802c69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802c6b:	6a 00                	push   $0x0
  802c6d:	6a 00                	push   $0x0
  802c6f:	6a 00                	push   $0x0
  802c71:	6a 00                	push   $0x0
  802c73:	6a 00                	push   $0x0
  802c75:	6a 21                	push   $0x21
  802c77:	e8 25 fc ff ff       	call   8028a1 <syscall>
  802c7c:	83 c4 18             	add    $0x18,%esp
	return;
  802c7f:	90                   	nop
}
  802c80:	c9                   	leave  
  802c81:	c3                   	ret    

00802c82 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  802c82:	55                   	push   %ebp
  802c83:	89 e5                	mov    %esp,%ebp
  802c85:	83 ec 04             	sub    $0x4,%esp
  802c88:	8b 45 14             	mov    0x14(%ebp),%eax
  802c8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802c8e:	8b 55 18             	mov    0x18(%ebp),%edx
  802c91:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802c95:	52                   	push   %edx
  802c96:	50                   	push   %eax
  802c97:	ff 75 10             	pushl  0x10(%ebp)
  802c9a:	ff 75 0c             	pushl  0xc(%ebp)
  802c9d:	ff 75 08             	pushl  0x8(%ebp)
  802ca0:	6a 20                	push   $0x20
  802ca2:	e8 fa fb ff ff       	call   8028a1 <syscall>
  802ca7:	83 c4 18             	add    $0x18,%esp
	return;
  802caa:	90                   	nop
}
  802cab:	c9                   	leave  
  802cac:	c3                   	ret    

00802cad <chktst>:
void chktst(uint32 n) {
  802cad:	55                   	push   %ebp
  802cae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802cb0:	6a 00                	push   $0x0
  802cb2:	6a 00                	push   $0x0
  802cb4:	6a 00                	push   $0x0
  802cb6:	6a 00                	push   $0x0
  802cb8:	ff 75 08             	pushl  0x8(%ebp)
  802cbb:	6a 22                	push   $0x22
  802cbd:	e8 df fb ff ff       	call   8028a1 <syscall>
  802cc2:	83 c4 18             	add    $0x18,%esp
	return;
  802cc5:	90                   	nop
}
  802cc6:	c9                   	leave  
  802cc7:	c3                   	ret    

00802cc8 <inctst>:

void inctst() {
  802cc8:	55                   	push   %ebp
  802cc9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802ccb:	6a 00                	push   $0x0
  802ccd:	6a 00                	push   $0x0
  802ccf:	6a 00                	push   $0x0
  802cd1:	6a 00                	push   $0x0
  802cd3:	6a 00                	push   $0x0
  802cd5:	6a 23                	push   $0x23
  802cd7:	e8 c5 fb ff ff       	call   8028a1 <syscall>
  802cdc:	83 c4 18             	add    $0x18,%esp
	return;
  802cdf:	90                   	nop
}
  802ce0:	c9                   	leave  
  802ce1:	c3                   	ret    

00802ce2 <gettst>:
uint32 gettst() {
  802ce2:	55                   	push   %ebp
  802ce3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802ce5:	6a 00                	push   $0x0
  802ce7:	6a 00                	push   $0x0
  802ce9:	6a 00                	push   $0x0
  802ceb:	6a 00                	push   $0x0
  802ced:	6a 00                	push   $0x0
  802cef:	6a 24                	push   $0x24
  802cf1:	e8 ab fb ff ff       	call   8028a1 <syscall>
  802cf6:	83 c4 18             	add    $0x18,%esp
}
  802cf9:	c9                   	leave  
  802cfa:	c3                   	ret    

00802cfb <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  802cfb:	55                   	push   %ebp
  802cfc:	89 e5                	mov    %esp,%ebp
  802cfe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d01:	6a 00                	push   $0x0
  802d03:	6a 00                	push   $0x0
  802d05:	6a 00                	push   $0x0
  802d07:	6a 00                	push   $0x0
  802d09:	6a 00                	push   $0x0
  802d0b:	6a 25                	push   $0x25
  802d0d:	e8 8f fb ff ff       	call   8028a1 <syscall>
  802d12:	83 c4 18             	add    $0x18,%esp
  802d15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802d18:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802d1c:	75 07                	jne    802d25 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802d1e:	b8 01 00 00 00       	mov    $0x1,%eax
  802d23:	eb 05                	jmp    802d2a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802d25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d2a:	c9                   	leave  
  802d2b:	c3                   	ret    

00802d2c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  802d2c:	55                   	push   %ebp
  802d2d:	89 e5                	mov    %esp,%ebp
  802d2f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d32:	6a 00                	push   $0x0
  802d34:	6a 00                	push   $0x0
  802d36:	6a 00                	push   $0x0
  802d38:	6a 00                	push   $0x0
  802d3a:	6a 00                	push   $0x0
  802d3c:	6a 25                	push   $0x25
  802d3e:	e8 5e fb ff ff       	call   8028a1 <syscall>
  802d43:	83 c4 18             	add    $0x18,%esp
  802d46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802d49:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802d4d:	75 07                	jne    802d56 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802d4f:	b8 01 00 00 00       	mov    $0x1,%eax
  802d54:	eb 05                	jmp    802d5b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802d56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d5b:	c9                   	leave  
  802d5c:	c3                   	ret    

00802d5d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  802d5d:	55                   	push   %ebp
  802d5e:	89 e5                	mov    %esp,%ebp
  802d60:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d63:	6a 00                	push   $0x0
  802d65:	6a 00                	push   $0x0
  802d67:	6a 00                	push   $0x0
  802d69:	6a 00                	push   $0x0
  802d6b:	6a 00                	push   $0x0
  802d6d:	6a 25                	push   $0x25
  802d6f:	e8 2d fb ff ff       	call   8028a1 <syscall>
  802d74:	83 c4 18             	add    $0x18,%esp
  802d77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802d7a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802d7e:	75 07                	jne    802d87 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802d80:	b8 01 00 00 00       	mov    $0x1,%eax
  802d85:	eb 05                	jmp    802d8c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802d87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d8c:	c9                   	leave  
  802d8d:	c3                   	ret    

00802d8e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  802d8e:	55                   	push   %ebp
  802d8f:	89 e5                	mov    %esp,%ebp
  802d91:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d94:	6a 00                	push   $0x0
  802d96:	6a 00                	push   $0x0
  802d98:	6a 00                	push   $0x0
  802d9a:	6a 00                	push   $0x0
  802d9c:	6a 00                	push   $0x0
  802d9e:	6a 25                	push   $0x25
  802da0:	e8 fc fa ff ff       	call   8028a1 <syscall>
  802da5:	83 c4 18             	add    $0x18,%esp
  802da8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802dab:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802daf:	75 07                	jne    802db8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802db1:	b8 01 00 00 00       	mov    $0x1,%eax
  802db6:	eb 05                	jmp    802dbd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802db8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dbd:	c9                   	leave  
  802dbe:	c3                   	ret    

00802dbf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  802dbf:	55                   	push   %ebp
  802dc0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802dc2:	6a 00                	push   $0x0
  802dc4:	6a 00                	push   $0x0
  802dc6:	6a 00                	push   $0x0
  802dc8:	6a 00                	push   $0x0
  802dca:	ff 75 08             	pushl  0x8(%ebp)
  802dcd:	6a 26                	push   $0x26
  802dcf:	e8 cd fa ff ff       	call   8028a1 <syscall>
  802dd4:	83 c4 18             	add    $0x18,%esp
	return;
  802dd7:	90                   	nop
}
  802dd8:	c9                   	leave  
  802dd9:	c3                   	ret    

00802dda <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  802dda:	55                   	push   %ebp
  802ddb:	89 e5                	mov    %esp,%ebp
  802ddd:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  802dde:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802de1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802de4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802de7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dea:	6a 00                	push   $0x0
  802dec:	53                   	push   %ebx
  802ded:	51                   	push   %ecx
  802dee:	52                   	push   %edx
  802def:	50                   	push   %eax
  802df0:	6a 27                	push   $0x27
  802df2:	e8 aa fa ff ff       	call   8028a1 <syscall>
  802df7:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  802dfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802dfd:	c9                   	leave  
  802dfe:	c3                   	ret    

00802dff <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  802dff:	55                   	push   %ebp
  802e00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  802e02:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e05:	8b 45 08             	mov    0x8(%ebp),%eax
  802e08:	6a 00                	push   $0x0
  802e0a:	6a 00                	push   $0x0
  802e0c:	6a 00                	push   $0x0
  802e0e:	52                   	push   %edx
  802e0f:	50                   	push   %eax
  802e10:	6a 28                	push   $0x28
  802e12:	e8 8a fa ff ff       	call   8028a1 <syscall>
  802e17:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  802e1a:	c9                   	leave  
  802e1b:	c3                   	ret    

00802e1c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  802e1c:	55                   	push   %ebp
  802e1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  802e1f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802e22:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e25:	8b 45 08             	mov    0x8(%ebp),%eax
  802e28:	6a 00                	push   $0x0
  802e2a:	51                   	push   %ecx
  802e2b:	ff 75 10             	pushl  0x10(%ebp)
  802e2e:	52                   	push   %edx
  802e2f:	50                   	push   %eax
  802e30:	6a 29                	push   $0x29
  802e32:	e8 6a fa ff ff       	call   8028a1 <syscall>
  802e37:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  802e3a:	c9                   	leave  
  802e3b:	c3                   	ret    

00802e3c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  802e3c:	55                   	push   %ebp
  802e3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802e3f:	6a 00                	push   $0x0
  802e41:	6a 00                	push   $0x0
  802e43:	ff 75 10             	pushl  0x10(%ebp)
  802e46:	ff 75 0c             	pushl  0xc(%ebp)
  802e49:	ff 75 08             	pushl  0x8(%ebp)
  802e4c:	6a 12                	push   $0x12
  802e4e:	e8 4e fa ff ff       	call   8028a1 <syscall>
  802e53:	83 c4 18             	add    $0x18,%esp
	return;
  802e56:	90                   	nop
}
  802e57:	c9                   	leave  
  802e58:	c3                   	ret    

00802e59 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  802e59:	55                   	push   %ebp
  802e5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  802e5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e62:	6a 00                	push   $0x0
  802e64:	6a 00                	push   $0x0
  802e66:	6a 00                	push   $0x0
  802e68:	52                   	push   %edx
  802e69:	50                   	push   %eax
  802e6a:	6a 2a                	push   $0x2a
  802e6c:	e8 30 fa ff ff       	call   8028a1 <syscall>
  802e71:	83 c4 18             	add    $0x18,%esp
	return;
  802e74:	90                   	nop
}
  802e75:	c9                   	leave  
  802e76:	c3                   	ret    

00802e77 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  802e77:	55                   	push   %ebp
  802e78:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  802e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7d:	6a 00                	push   $0x0
  802e7f:	6a 00                	push   $0x0
  802e81:	6a 00                	push   $0x0
  802e83:	6a 00                	push   $0x0
  802e85:	50                   	push   %eax
  802e86:	6a 2b                	push   $0x2b
  802e88:	e8 14 fa ff ff       	call   8028a1 <syscall>
  802e8d:	83 c4 18             	add    $0x18,%esp
}
  802e90:	c9                   	leave  
  802e91:	c3                   	ret    

00802e92 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  802e92:	55                   	push   %ebp
  802e93:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802e95:	6a 00                	push   $0x0
  802e97:	6a 00                	push   $0x0
  802e99:	6a 00                	push   $0x0
  802e9b:	ff 75 0c             	pushl  0xc(%ebp)
  802e9e:	ff 75 08             	pushl  0x8(%ebp)
  802ea1:	6a 2c                	push   $0x2c
  802ea3:	e8 f9 f9 ff ff       	call   8028a1 <syscall>
  802ea8:	83 c4 18             	add    $0x18,%esp
	return;
  802eab:	90                   	nop
}
  802eac:	c9                   	leave  
  802ead:	c3                   	ret    

00802eae <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  802eae:	55                   	push   %ebp
  802eaf:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802eb1:	6a 00                	push   $0x0
  802eb3:	6a 00                	push   $0x0
  802eb5:	6a 00                	push   $0x0
  802eb7:	ff 75 0c             	pushl  0xc(%ebp)
  802eba:	ff 75 08             	pushl  0x8(%ebp)
  802ebd:	6a 2d                	push   $0x2d
  802ebf:	e8 dd f9 ff ff       	call   8028a1 <syscall>
  802ec4:	83 c4 18             	add    $0x18,%esp
	return;
  802ec7:	90                   	nop
}
  802ec8:	c9                   	leave  
  802ec9:	c3                   	ret    

00802eca <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  802eca:	55                   	push   %ebp
  802ecb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  802ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed0:	6a 00                	push   $0x0
  802ed2:	6a 00                	push   $0x0
  802ed4:	6a 00                	push   $0x0
  802ed6:	6a 00                	push   $0x0
  802ed8:	50                   	push   %eax
  802ed9:	6a 2f                	push   $0x2f
  802edb:	e8 c1 f9 ff ff       	call   8028a1 <syscall>
  802ee0:	83 c4 18             	add    $0x18,%esp
	return;
  802ee3:	90                   	nop
}
  802ee4:	c9                   	leave  
  802ee5:	c3                   	ret    

00802ee6 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  802ee6:	55                   	push   %ebp
  802ee7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  802ee9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eec:	8b 45 08             	mov    0x8(%ebp),%eax
  802eef:	6a 00                	push   $0x0
  802ef1:	6a 00                	push   $0x0
  802ef3:	6a 00                	push   $0x0
  802ef5:	52                   	push   %edx
  802ef6:	50                   	push   %eax
  802ef7:	6a 30                	push   $0x30
  802ef9:	e8 a3 f9 ff ff       	call   8028a1 <syscall>
  802efe:	83 c4 18             	add    $0x18,%esp
	return;
  802f01:	90                   	nop
}
  802f02:	c9                   	leave  
  802f03:	c3                   	ret    

00802f04 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  802f04:	55                   	push   %ebp
  802f05:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  802f07:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0a:	6a 00                	push   $0x0
  802f0c:	6a 00                	push   $0x0
  802f0e:	6a 00                	push   $0x0
  802f10:	6a 00                	push   $0x0
  802f12:	50                   	push   %eax
  802f13:	6a 31                	push   $0x31
  802f15:	e8 87 f9 ff ff       	call   8028a1 <syscall>
  802f1a:	83 c4 18             	add    $0x18,%esp
	return;
  802f1d:	90                   	nop
}
  802f1e:	c9                   	leave  
  802f1f:	c3                   	ret    

00802f20 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  802f20:	55                   	push   %ebp
  802f21:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802f23:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f26:	8b 45 08             	mov    0x8(%ebp),%eax
  802f29:	6a 00                	push   $0x0
  802f2b:	6a 00                	push   $0x0
  802f2d:	6a 00                	push   $0x0
  802f2f:	52                   	push   %edx
  802f30:	50                   	push   %eax
  802f31:	6a 2e                	push   $0x2e
  802f33:	e8 69 f9 ff ff       	call   8028a1 <syscall>
  802f38:	83 c4 18             	add    $0x18,%esp
    return;
  802f3b:	90                   	nop
}
  802f3c:	c9                   	leave  
  802f3d:	c3                   	ret    

00802f3e <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802f3e:	55                   	push   %ebp
  802f3f:	89 e5                	mov    %esp,%ebp
  802f41:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802f44:	8b 45 08             	mov    0x8(%ebp),%eax
  802f47:	83 e8 04             	sub    $0x4,%eax
  802f4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802f4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f50:	8b 00                	mov    (%eax),%eax
  802f52:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802f55:	c9                   	leave  
  802f56:	c3                   	ret    

00802f57 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802f57:	55                   	push   %ebp
  802f58:	89 e5                	mov    %esp,%ebp
  802f5a:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f60:	83 e8 04             	sub    $0x4,%eax
  802f63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802f66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f69:	8b 00                	mov    (%eax),%eax
  802f6b:	83 e0 01             	and    $0x1,%eax
  802f6e:	85 c0                	test   %eax,%eax
  802f70:	0f 94 c0             	sete   %al
}
  802f73:	c9                   	leave  
  802f74:	c3                   	ret    

00802f75 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802f75:	55                   	push   %ebp
  802f76:	89 e5                	mov    %esp,%ebp
  802f78:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802f7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802f82:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f85:	83 f8 02             	cmp    $0x2,%eax
  802f88:	74 2b                	je     802fb5 <alloc_block+0x40>
  802f8a:	83 f8 02             	cmp    $0x2,%eax
  802f8d:	7f 07                	jg     802f96 <alloc_block+0x21>
  802f8f:	83 f8 01             	cmp    $0x1,%eax
  802f92:	74 0e                	je     802fa2 <alloc_block+0x2d>
  802f94:	eb 58                	jmp    802fee <alloc_block+0x79>
  802f96:	83 f8 03             	cmp    $0x3,%eax
  802f99:	74 2d                	je     802fc8 <alloc_block+0x53>
  802f9b:	83 f8 04             	cmp    $0x4,%eax
  802f9e:	74 3b                	je     802fdb <alloc_block+0x66>
  802fa0:	eb 4c                	jmp    802fee <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802fa2:	83 ec 0c             	sub    $0xc,%esp
  802fa5:	ff 75 08             	pushl  0x8(%ebp)
  802fa8:	e8 f7 03 00 00       	call   8033a4 <alloc_block_FF>
  802fad:	83 c4 10             	add    $0x10,%esp
  802fb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802fb3:	eb 4a                	jmp    802fff <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802fb5:	83 ec 0c             	sub    $0xc,%esp
  802fb8:	ff 75 08             	pushl  0x8(%ebp)
  802fbb:	e8 f0 11 00 00       	call   8041b0 <alloc_block_NF>
  802fc0:	83 c4 10             	add    $0x10,%esp
  802fc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802fc6:	eb 37                	jmp    802fff <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802fc8:	83 ec 0c             	sub    $0xc,%esp
  802fcb:	ff 75 08             	pushl  0x8(%ebp)
  802fce:	e8 08 08 00 00       	call   8037db <alloc_block_BF>
  802fd3:	83 c4 10             	add    $0x10,%esp
  802fd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802fd9:	eb 24                	jmp    802fff <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802fdb:	83 ec 0c             	sub    $0xc,%esp
  802fde:	ff 75 08             	pushl  0x8(%ebp)
  802fe1:	e8 ad 11 00 00       	call   804193 <alloc_block_WF>
  802fe6:	83 c4 10             	add    $0x10,%esp
  802fe9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802fec:	eb 11                	jmp    802fff <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802fee:	83 ec 0c             	sub    $0xc,%esp
  802ff1:	68 98 4d 80 00       	push   $0x804d98
  802ff6:	e8 41 e4 ff ff       	call   80143c <cprintf>
  802ffb:	83 c4 10             	add    $0x10,%esp
		break;
  802ffe:	90                   	nop
	}
	return va;
  802fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  803002:	c9                   	leave  
  803003:	c3                   	ret    

00803004 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  803004:	55                   	push   %ebp
  803005:	89 e5                	mov    %esp,%ebp
  803007:	53                   	push   %ebx
  803008:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80300b:	83 ec 0c             	sub    $0xc,%esp
  80300e:	68 b8 4d 80 00       	push   $0x804db8
  803013:	e8 24 e4 ff ff       	call   80143c <cprintf>
  803018:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80301b:	83 ec 0c             	sub    $0xc,%esp
  80301e:	68 e3 4d 80 00       	push   $0x804de3
  803023:	e8 14 e4 ff ff       	call   80143c <cprintf>
  803028:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80302b:	8b 45 08             	mov    0x8(%ebp),%eax
  80302e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803031:	eb 37                	jmp    80306a <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  803033:	83 ec 0c             	sub    $0xc,%esp
  803036:	ff 75 f4             	pushl  -0xc(%ebp)
  803039:	e8 19 ff ff ff       	call   802f57 <is_free_block>
  80303e:	83 c4 10             	add    $0x10,%esp
  803041:	0f be d8             	movsbl %al,%ebx
  803044:	83 ec 0c             	sub    $0xc,%esp
  803047:	ff 75 f4             	pushl  -0xc(%ebp)
  80304a:	e8 ef fe ff ff       	call   802f3e <get_block_size>
  80304f:	83 c4 10             	add    $0x10,%esp
  803052:	83 ec 04             	sub    $0x4,%esp
  803055:	53                   	push   %ebx
  803056:	50                   	push   %eax
  803057:	68 fb 4d 80 00       	push   $0x804dfb
  80305c:	e8 db e3 ff ff       	call   80143c <cprintf>
  803061:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  803064:	8b 45 10             	mov    0x10(%ebp),%eax
  803067:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80306a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80306e:	74 07                	je     803077 <print_blocks_list+0x73>
  803070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803073:	8b 00                	mov    (%eax),%eax
  803075:	eb 05                	jmp    80307c <print_blocks_list+0x78>
  803077:	b8 00 00 00 00       	mov    $0x0,%eax
  80307c:	89 45 10             	mov    %eax,0x10(%ebp)
  80307f:	8b 45 10             	mov    0x10(%ebp),%eax
  803082:	85 c0                	test   %eax,%eax
  803084:	75 ad                	jne    803033 <print_blocks_list+0x2f>
  803086:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80308a:	75 a7                	jne    803033 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80308c:	83 ec 0c             	sub    $0xc,%esp
  80308f:	68 b8 4d 80 00       	push   $0x804db8
  803094:	e8 a3 e3 ff ff       	call   80143c <cprintf>
  803099:	83 c4 10             	add    $0x10,%esp

}
  80309c:	90                   	nop
  80309d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030a0:	c9                   	leave  
  8030a1:	c3                   	ret    

008030a2 <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8030a2:	55                   	push   %ebp
  8030a3:	89 e5                	mov    %esp,%ebp
  8030a5:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8030a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ab:	83 e0 01             	and    $0x1,%eax
  8030ae:	85 c0                	test   %eax,%eax
  8030b0:	74 03                	je     8030b5 <initialize_dynamic_allocator+0x13>
  8030b2:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  8030b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030b9:	0f 84 f8 00 00 00    	je     8031b7 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  8030bf:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  8030c6:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  8030c9:	a1 40 50 98 00       	mov    0x985040,%eax
  8030ce:	85 c0                	test   %eax,%eax
  8030d0:	0f 84 e2 00 00 00    	je     8031b8 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  8030d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8030dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030df:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  8030e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030eb:	01 d0                	add    %edx,%eax
  8030ed:	83 e8 04             	sub    $0x4,%eax
  8030f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8030f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  8030fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ff:	83 c0 08             	add    $0x8,%eax
  803102:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  803105:	8b 45 0c             	mov    0xc(%ebp),%eax
  803108:	83 e8 08             	sub    $0x8,%eax
  80310b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  80310e:	83 ec 04             	sub    $0x4,%esp
  803111:	6a 00                	push   $0x0
  803113:	ff 75 e8             	pushl  -0x18(%ebp)
  803116:	ff 75 ec             	pushl  -0x14(%ebp)
  803119:	e8 9c 00 00 00       	call   8031ba <set_block_data>
  80311e:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  803121:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803124:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  80312a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80312d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  803134:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  80313b:	00 00 00 
  80313e:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  803145:	00 00 00 
  803148:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  80314f:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  803152:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803156:	75 17                	jne    80316f <initialize_dynamic_allocator+0xcd>
  803158:	83 ec 04             	sub    $0x4,%esp
  80315b:	68 14 4e 80 00       	push   $0x804e14
  803160:	68 80 00 00 00       	push   $0x80
  803165:	68 37 4e 80 00       	push   $0x804e37
  80316a:	e8 10 e0 ff ff       	call   80117f <_panic>
  80316f:	8b 15 48 50 98 00    	mov    0x985048,%edx
  803175:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803178:	89 10                	mov    %edx,(%eax)
  80317a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80317d:	8b 00                	mov    (%eax),%eax
  80317f:	85 c0                	test   %eax,%eax
  803181:	74 0d                	je     803190 <initialize_dynamic_allocator+0xee>
  803183:	a1 48 50 98 00       	mov    0x985048,%eax
  803188:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80318b:	89 50 04             	mov    %edx,0x4(%eax)
  80318e:	eb 08                	jmp    803198 <initialize_dynamic_allocator+0xf6>
  803190:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803193:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803198:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80319b:	a3 48 50 98 00       	mov    %eax,0x985048
  8031a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031aa:	a1 54 50 98 00       	mov    0x985054,%eax
  8031af:	40                   	inc    %eax
  8031b0:	a3 54 50 98 00       	mov    %eax,0x985054
  8031b5:	eb 01                	jmp    8031b8 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  8031b7:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  8031b8:	c9                   	leave  
  8031b9:	c3                   	ret    

008031ba <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8031ba:	55                   	push   %ebp
  8031bb:	89 e5                	mov    %esp,%ebp
  8031bd:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  8031c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031c3:	83 e0 01             	and    $0x1,%eax
  8031c6:	85 c0                	test   %eax,%eax
  8031c8:	74 03                	je     8031cd <set_block_data+0x13>
	{
		totalSize++;
  8031ca:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  8031cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d0:	83 e8 04             	sub    $0x4,%eax
  8031d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  8031d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031d9:	83 e0 fe             	and    $0xfffffffe,%eax
  8031dc:	89 c2                	mov    %eax,%edx
  8031de:	8b 45 10             	mov    0x10(%ebp),%eax
  8031e1:	83 e0 01             	and    $0x1,%eax
  8031e4:	09 c2                	or     %eax,%edx
  8031e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031e9:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  8031eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ee:	8d 50 f8             	lea    -0x8(%eax),%edx
  8031f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f4:	01 d0                	add    %edx,%eax
  8031f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  8031f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031fc:	83 e0 fe             	and    $0xfffffffe,%eax
  8031ff:	89 c2                	mov    %eax,%edx
  803201:	8b 45 10             	mov    0x10(%ebp),%eax
  803204:	83 e0 01             	and    $0x1,%eax
  803207:	09 c2                	or     %eax,%edx
  803209:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80320c:	89 10                	mov    %edx,(%eax)
}
  80320e:	90                   	nop
  80320f:	c9                   	leave  
  803210:	c3                   	ret    

00803211 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  803211:	55                   	push   %ebp
  803212:	89 e5                	mov    %esp,%ebp
  803214:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  803217:	a1 48 50 98 00       	mov    0x985048,%eax
  80321c:	85 c0                	test   %eax,%eax
  80321e:	75 68                	jne    803288 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  803220:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803224:	75 17                	jne    80323d <insert_sorted_in_freeList+0x2c>
  803226:	83 ec 04             	sub    $0x4,%esp
  803229:	68 14 4e 80 00       	push   $0x804e14
  80322e:	68 9d 00 00 00       	push   $0x9d
  803233:	68 37 4e 80 00       	push   $0x804e37
  803238:	e8 42 df ff ff       	call   80117f <_panic>
  80323d:	8b 15 48 50 98 00    	mov    0x985048,%edx
  803243:	8b 45 08             	mov    0x8(%ebp),%eax
  803246:	89 10                	mov    %edx,(%eax)
  803248:	8b 45 08             	mov    0x8(%ebp),%eax
  80324b:	8b 00                	mov    (%eax),%eax
  80324d:	85 c0                	test   %eax,%eax
  80324f:	74 0d                	je     80325e <insert_sorted_in_freeList+0x4d>
  803251:	a1 48 50 98 00       	mov    0x985048,%eax
  803256:	8b 55 08             	mov    0x8(%ebp),%edx
  803259:	89 50 04             	mov    %edx,0x4(%eax)
  80325c:	eb 08                	jmp    803266 <insert_sorted_in_freeList+0x55>
  80325e:	8b 45 08             	mov    0x8(%ebp),%eax
  803261:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803266:	8b 45 08             	mov    0x8(%ebp),%eax
  803269:	a3 48 50 98 00       	mov    %eax,0x985048
  80326e:	8b 45 08             	mov    0x8(%ebp),%eax
  803271:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803278:	a1 54 50 98 00       	mov    0x985054,%eax
  80327d:	40                   	inc    %eax
  80327e:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  803283:	e9 1a 01 00 00       	jmp    8033a2 <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  803288:	a1 48 50 98 00       	mov    0x985048,%eax
  80328d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803290:	eb 7f                	jmp    803311 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  803292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803295:	3b 45 08             	cmp    0x8(%ebp),%eax
  803298:	76 6f                	jbe    803309 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  80329a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80329e:	74 06                	je     8032a6 <insert_sorted_in_freeList+0x95>
  8032a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032a4:	75 17                	jne    8032bd <insert_sorted_in_freeList+0xac>
  8032a6:	83 ec 04             	sub    $0x4,%esp
  8032a9:	68 50 4e 80 00       	push   $0x804e50
  8032ae:	68 a6 00 00 00       	push   $0xa6
  8032b3:	68 37 4e 80 00       	push   $0x804e37
  8032b8:	e8 c2 de ff ff       	call   80117f <_panic>
  8032bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c0:	8b 50 04             	mov    0x4(%eax),%edx
  8032c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c6:	89 50 04             	mov    %edx,0x4(%eax)
  8032c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032cf:	89 10                	mov    %edx,(%eax)
  8032d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d4:	8b 40 04             	mov    0x4(%eax),%eax
  8032d7:	85 c0                	test   %eax,%eax
  8032d9:	74 0d                	je     8032e8 <insert_sorted_in_freeList+0xd7>
  8032db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032de:	8b 40 04             	mov    0x4(%eax),%eax
  8032e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e4:	89 10                	mov    %edx,(%eax)
  8032e6:	eb 08                	jmp    8032f0 <insert_sorted_in_freeList+0xdf>
  8032e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032eb:	a3 48 50 98 00       	mov    %eax,0x985048
  8032f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f6:	89 50 04             	mov    %edx,0x4(%eax)
  8032f9:	a1 54 50 98 00       	mov    0x985054,%eax
  8032fe:	40                   	inc    %eax
  8032ff:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  803304:	e9 99 00 00 00       	jmp    8033a2 <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  803309:	a1 50 50 98 00       	mov    0x985050,%eax
  80330e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803311:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803315:	74 07                	je     80331e <insert_sorted_in_freeList+0x10d>
  803317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331a:	8b 00                	mov    (%eax),%eax
  80331c:	eb 05                	jmp    803323 <insert_sorted_in_freeList+0x112>
  80331e:	b8 00 00 00 00       	mov    $0x0,%eax
  803323:	a3 50 50 98 00       	mov    %eax,0x985050
  803328:	a1 50 50 98 00       	mov    0x985050,%eax
  80332d:	85 c0                	test   %eax,%eax
  80332f:	0f 85 5d ff ff ff    	jne    803292 <insert_sorted_in_freeList+0x81>
  803335:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803339:	0f 85 53 ff ff ff    	jne    803292 <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  80333f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803343:	75 17                	jne    80335c <insert_sorted_in_freeList+0x14b>
  803345:	83 ec 04             	sub    $0x4,%esp
  803348:	68 88 4e 80 00       	push   $0x804e88
  80334d:	68 ab 00 00 00       	push   $0xab
  803352:	68 37 4e 80 00       	push   $0x804e37
  803357:	e8 23 de ff ff       	call   80117f <_panic>
  80335c:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  803362:	8b 45 08             	mov    0x8(%ebp),%eax
  803365:	89 50 04             	mov    %edx,0x4(%eax)
  803368:	8b 45 08             	mov    0x8(%ebp),%eax
  80336b:	8b 40 04             	mov    0x4(%eax),%eax
  80336e:	85 c0                	test   %eax,%eax
  803370:	74 0c                	je     80337e <insert_sorted_in_freeList+0x16d>
  803372:	a1 4c 50 98 00       	mov    0x98504c,%eax
  803377:	8b 55 08             	mov    0x8(%ebp),%edx
  80337a:	89 10                	mov    %edx,(%eax)
  80337c:	eb 08                	jmp    803386 <insert_sorted_in_freeList+0x175>
  80337e:	8b 45 08             	mov    0x8(%ebp),%eax
  803381:	a3 48 50 98 00       	mov    %eax,0x985048
  803386:	8b 45 08             	mov    0x8(%ebp),%eax
  803389:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80338e:	8b 45 08             	mov    0x8(%ebp),%eax
  803391:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803397:	a1 54 50 98 00       	mov    0x985054,%eax
  80339c:	40                   	inc    %eax
  80339d:	a3 54 50 98 00       	mov    %eax,0x985054
}
  8033a2:	c9                   	leave  
  8033a3:	c3                   	ret    

008033a4 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8033a4:	55                   	push   %ebp
  8033a5:	89 e5                	mov    %esp,%ebp
  8033a7:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8033aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ad:	83 e0 01             	and    $0x1,%eax
  8033b0:	85 c0                	test   %eax,%eax
  8033b2:	74 03                	je     8033b7 <alloc_block_FF+0x13>
  8033b4:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8033b7:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8033bb:	77 07                	ja     8033c4 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8033bd:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8033c4:	a1 40 50 98 00       	mov    0x985040,%eax
  8033c9:	85 c0                	test   %eax,%eax
  8033cb:	75 63                	jne    803430 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8033cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d0:	83 c0 10             	add    $0x10,%eax
  8033d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8033d6:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8033dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033e3:	01 d0                	add    %edx,%eax
  8033e5:	48                   	dec    %eax
  8033e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8033e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8033f1:	f7 75 ec             	divl   -0x14(%ebp)
  8033f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f7:	29 d0                	sub    %edx,%eax
  8033f9:	c1 e8 0c             	shr    $0xc,%eax
  8033fc:	83 ec 0c             	sub    $0xc,%esp
  8033ff:	50                   	push   %eax
  803400:	e8 d1 ed ff ff       	call   8021d6 <sbrk>
  803405:	83 c4 10             	add    $0x10,%esp
  803408:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80340b:	83 ec 0c             	sub    $0xc,%esp
  80340e:	6a 00                	push   $0x0
  803410:	e8 c1 ed ff ff       	call   8021d6 <sbrk>
  803415:	83 c4 10             	add    $0x10,%esp
  803418:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80341b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80341e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803421:	83 ec 08             	sub    $0x8,%esp
  803424:	50                   	push   %eax
  803425:	ff 75 e4             	pushl  -0x1c(%ebp)
  803428:	e8 75 fc ff ff       	call   8030a2 <initialize_dynamic_allocator>
  80342d:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  803430:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803434:	75 0a                	jne    803440 <alloc_block_FF+0x9c>
	{
		return NULL;
  803436:	b8 00 00 00 00       	mov    $0x0,%eax
  80343b:	e9 99 03 00 00       	jmp    8037d9 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  803440:	8b 45 08             	mov    0x8(%ebp),%eax
  803443:	83 c0 08             	add    $0x8,%eax
  803446:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803449:	a1 48 50 98 00       	mov    0x985048,%eax
  80344e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803451:	e9 03 02 00 00       	jmp    803659 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  803456:	83 ec 0c             	sub    $0xc,%esp
  803459:	ff 75 f4             	pushl  -0xc(%ebp)
  80345c:	e8 dd fa ff ff       	call   802f3e <get_block_size>
  803461:	83 c4 10             	add    $0x10,%esp
  803464:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  803467:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80346a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80346d:	0f 82 de 01 00 00    	jb     803651 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  803473:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803476:	83 c0 10             	add    $0x10,%eax
  803479:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  80347c:	0f 87 32 01 00 00    	ja     8035b4 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  803482:	8b 45 9c             	mov    -0x64(%ebp),%eax
  803485:	2b 45 dc             	sub    -0x24(%ebp),%eax
  803488:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  80348b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80348e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803491:	01 d0                	add    %edx,%eax
  803493:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  803496:	83 ec 04             	sub    $0x4,%esp
  803499:	6a 00                	push   $0x0
  80349b:	ff 75 98             	pushl  -0x68(%ebp)
  80349e:	ff 75 94             	pushl  -0x6c(%ebp)
  8034a1:	e8 14 fd ff ff       	call   8031ba <set_block_data>
  8034a6:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  8034a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034ad:	74 06                	je     8034b5 <alloc_block_FF+0x111>
  8034af:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  8034b3:	75 17                	jne    8034cc <alloc_block_FF+0x128>
  8034b5:	83 ec 04             	sub    $0x4,%esp
  8034b8:	68 ac 4e 80 00       	push   $0x804eac
  8034bd:	68 de 00 00 00       	push   $0xde
  8034c2:	68 37 4e 80 00       	push   $0x804e37
  8034c7:	e8 b3 dc ff ff       	call   80117f <_panic>
  8034cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cf:	8b 10                	mov    (%eax),%edx
  8034d1:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8034d4:	89 10                	mov    %edx,(%eax)
  8034d6:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8034d9:	8b 00                	mov    (%eax),%eax
  8034db:	85 c0                	test   %eax,%eax
  8034dd:	74 0b                	je     8034ea <alloc_block_FF+0x146>
  8034df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e2:	8b 00                	mov    (%eax),%eax
  8034e4:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8034e7:	89 50 04             	mov    %edx,0x4(%eax)
  8034ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ed:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8034f0:	89 10                	mov    %edx,(%eax)
  8034f2:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8034f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034f8:	89 50 04             	mov    %edx,0x4(%eax)
  8034fb:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8034fe:	8b 00                	mov    (%eax),%eax
  803500:	85 c0                	test   %eax,%eax
  803502:	75 08                	jne    80350c <alloc_block_FF+0x168>
  803504:	8b 45 94             	mov    -0x6c(%ebp),%eax
  803507:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80350c:	a1 54 50 98 00       	mov    0x985054,%eax
  803511:	40                   	inc    %eax
  803512:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  803517:	83 ec 04             	sub    $0x4,%esp
  80351a:	6a 01                	push   $0x1
  80351c:	ff 75 dc             	pushl  -0x24(%ebp)
  80351f:	ff 75 f4             	pushl  -0xc(%ebp)
  803522:	e8 93 fc ff ff       	call   8031ba <set_block_data>
  803527:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  80352a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80352e:	75 17                	jne    803547 <alloc_block_FF+0x1a3>
  803530:	83 ec 04             	sub    $0x4,%esp
  803533:	68 e0 4e 80 00       	push   $0x804ee0
  803538:	68 e3 00 00 00       	push   $0xe3
  80353d:	68 37 4e 80 00       	push   $0x804e37
  803542:	e8 38 dc ff ff       	call   80117f <_panic>
  803547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354a:	8b 00                	mov    (%eax),%eax
  80354c:	85 c0                	test   %eax,%eax
  80354e:	74 10                	je     803560 <alloc_block_FF+0x1bc>
  803550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803553:	8b 00                	mov    (%eax),%eax
  803555:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803558:	8b 52 04             	mov    0x4(%edx),%edx
  80355b:	89 50 04             	mov    %edx,0x4(%eax)
  80355e:	eb 0b                	jmp    80356b <alloc_block_FF+0x1c7>
  803560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803563:	8b 40 04             	mov    0x4(%eax),%eax
  803566:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80356b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356e:	8b 40 04             	mov    0x4(%eax),%eax
  803571:	85 c0                	test   %eax,%eax
  803573:	74 0f                	je     803584 <alloc_block_FF+0x1e0>
  803575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803578:	8b 40 04             	mov    0x4(%eax),%eax
  80357b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80357e:	8b 12                	mov    (%edx),%edx
  803580:	89 10                	mov    %edx,(%eax)
  803582:	eb 0a                	jmp    80358e <alloc_block_FF+0x1ea>
  803584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803587:	8b 00                	mov    (%eax),%eax
  803589:	a3 48 50 98 00       	mov    %eax,0x985048
  80358e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803591:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035a1:	a1 54 50 98 00       	mov    0x985054,%eax
  8035a6:	48                   	dec    %eax
  8035a7:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  8035ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035af:	e9 25 02 00 00       	jmp    8037d9 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  8035b4:	83 ec 04             	sub    $0x4,%esp
  8035b7:	6a 01                	push   $0x1
  8035b9:	ff 75 9c             	pushl  -0x64(%ebp)
  8035bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8035bf:	e8 f6 fb ff ff       	call   8031ba <set_block_data>
  8035c4:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  8035c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035cb:	75 17                	jne    8035e4 <alloc_block_FF+0x240>
  8035cd:	83 ec 04             	sub    $0x4,%esp
  8035d0:	68 e0 4e 80 00       	push   $0x804ee0
  8035d5:	68 eb 00 00 00       	push   $0xeb
  8035da:	68 37 4e 80 00       	push   $0x804e37
  8035df:	e8 9b db ff ff       	call   80117f <_panic>
  8035e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e7:	8b 00                	mov    (%eax),%eax
  8035e9:	85 c0                	test   %eax,%eax
  8035eb:	74 10                	je     8035fd <alloc_block_FF+0x259>
  8035ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f0:	8b 00                	mov    (%eax),%eax
  8035f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035f5:	8b 52 04             	mov    0x4(%edx),%edx
  8035f8:	89 50 04             	mov    %edx,0x4(%eax)
  8035fb:	eb 0b                	jmp    803608 <alloc_block_FF+0x264>
  8035fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803600:	8b 40 04             	mov    0x4(%eax),%eax
  803603:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360b:	8b 40 04             	mov    0x4(%eax),%eax
  80360e:	85 c0                	test   %eax,%eax
  803610:	74 0f                	je     803621 <alloc_block_FF+0x27d>
  803612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803615:	8b 40 04             	mov    0x4(%eax),%eax
  803618:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80361b:	8b 12                	mov    (%edx),%edx
  80361d:	89 10                	mov    %edx,(%eax)
  80361f:	eb 0a                	jmp    80362b <alloc_block_FF+0x287>
  803621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803624:	8b 00                	mov    (%eax),%eax
  803626:	a3 48 50 98 00       	mov    %eax,0x985048
  80362b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803637:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80363e:	a1 54 50 98 00       	mov    0x985054,%eax
  803643:	48                   	dec    %eax
  803644:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  803649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364c:	e9 88 01 00 00       	jmp    8037d9 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803651:	a1 50 50 98 00       	mov    0x985050,%eax
  803656:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803659:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80365d:	74 07                	je     803666 <alloc_block_FF+0x2c2>
  80365f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803662:	8b 00                	mov    (%eax),%eax
  803664:	eb 05                	jmp    80366b <alloc_block_FF+0x2c7>
  803666:	b8 00 00 00 00       	mov    $0x0,%eax
  80366b:	a3 50 50 98 00       	mov    %eax,0x985050
  803670:	a1 50 50 98 00       	mov    0x985050,%eax
  803675:	85 c0                	test   %eax,%eax
  803677:	0f 85 d9 fd ff ff    	jne    803456 <alloc_block_FF+0xb2>
  80367d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803681:	0f 85 cf fd ff ff    	jne    803456 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  803687:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80368e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803691:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803694:	01 d0                	add    %edx,%eax
  803696:	48                   	dec    %eax
  803697:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80369a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80369d:	ba 00 00 00 00       	mov    $0x0,%edx
  8036a2:	f7 75 d8             	divl   -0x28(%ebp)
  8036a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a8:	29 d0                	sub    %edx,%eax
  8036aa:	c1 e8 0c             	shr    $0xc,%eax
  8036ad:	83 ec 0c             	sub    $0xc,%esp
  8036b0:	50                   	push   %eax
  8036b1:	e8 20 eb ff ff       	call   8021d6 <sbrk>
  8036b6:	83 c4 10             	add    $0x10,%esp
  8036b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  8036bc:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8036c0:	75 0a                	jne    8036cc <alloc_block_FF+0x328>
		return NULL;
  8036c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8036c7:	e9 0d 01 00 00       	jmp    8037d9 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  8036cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8036cf:	83 e8 04             	sub    $0x4,%eax
  8036d2:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  8036d5:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  8036dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036df:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8036e2:	01 d0                	add    %edx,%eax
  8036e4:	48                   	dec    %eax
  8036e5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8036e8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8036eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8036f0:	f7 75 c8             	divl   -0x38(%ebp)
  8036f3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8036f6:	29 d0                	sub    %edx,%eax
  8036f8:	c1 e8 02             	shr    $0x2,%eax
  8036fb:	c1 e0 02             	shl    $0x2,%eax
  8036fe:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  803701:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803704:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  80370a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80370d:	83 e8 08             	sub    $0x8,%eax
  803710:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  803713:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803716:	8b 00                	mov    (%eax),%eax
  803718:	83 e0 fe             	and    $0xfffffffe,%eax
  80371b:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  80371e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803721:	f7 d8                	neg    %eax
  803723:	89 c2                	mov    %eax,%edx
  803725:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803728:	01 d0                	add    %edx,%eax
  80372a:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  80372d:	83 ec 0c             	sub    $0xc,%esp
  803730:	ff 75 b8             	pushl  -0x48(%ebp)
  803733:	e8 1f f8 ff ff       	call   802f57 <is_free_block>
  803738:	83 c4 10             	add    $0x10,%esp
  80373b:	0f be c0             	movsbl %al,%eax
  80373e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  803741:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  803745:	74 42                	je     803789 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  803747:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80374e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803751:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803754:	01 d0                	add    %edx,%eax
  803756:	48                   	dec    %eax
  803757:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80375a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80375d:	ba 00 00 00 00       	mov    $0x0,%edx
  803762:	f7 75 b0             	divl   -0x50(%ebp)
  803765:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803768:	29 d0                	sub    %edx,%eax
  80376a:	89 c2                	mov    %eax,%edx
  80376c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80376f:	01 d0                	add    %edx,%eax
  803771:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  803774:	83 ec 04             	sub    $0x4,%esp
  803777:	6a 00                	push   $0x0
  803779:	ff 75 a8             	pushl  -0x58(%ebp)
  80377c:	ff 75 b8             	pushl  -0x48(%ebp)
  80377f:	e8 36 fa ff ff       	call   8031ba <set_block_data>
  803784:	83 c4 10             	add    $0x10,%esp
  803787:	eb 42                	jmp    8037cb <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  803789:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  803790:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803793:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803796:	01 d0                	add    %edx,%eax
  803798:	48                   	dec    %eax
  803799:	89 45 a0             	mov    %eax,-0x60(%ebp)
  80379c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80379f:	ba 00 00 00 00       	mov    $0x0,%edx
  8037a4:	f7 75 a4             	divl   -0x5c(%ebp)
  8037a7:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8037aa:	29 d0                	sub    %edx,%eax
  8037ac:	83 ec 04             	sub    $0x4,%esp
  8037af:	6a 00                	push   $0x0
  8037b1:	50                   	push   %eax
  8037b2:	ff 75 d0             	pushl  -0x30(%ebp)
  8037b5:	e8 00 fa ff ff       	call   8031ba <set_block_data>
  8037ba:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  8037bd:	83 ec 0c             	sub    $0xc,%esp
  8037c0:	ff 75 d0             	pushl  -0x30(%ebp)
  8037c3:	e8 49 fa ff ff       	call   803211 <insert_sorted_in_freeList>
  8037c8:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  8037cb:	83 ec 0c             	sub    $0xc,%esp
  8037ce:	ff 75 08             	pushl  0x8(%ebp)
  8037d1:	e8 ce fb ff ff       	call   8033a4 <alloc_block_FF>
  8037d6:	83 c4 10             	add    $0x10,%esp
}
  8037d9:	c9                   	leave  
  8037da:	c3                   	ret    

008037db <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8037db:	55                   	push   %ebp
  8037dc:	89 e5                	mov    %esp,%ebp
  8037de:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  8037e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037e5:	75 0a                	jne    8037f1 <alloc_block_BF+0x16>
	{
		return NULL;
  8037e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ec:	e9 7a 02 00 00       	jmp    803a6b <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  8037f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f4:	83 c0 08             	add    $0x8,%eax
  8037f7:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  8037fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  803801:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803808:	a1 48 50 98 00       	mov    0x985048,%eax
  80380d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803810:	eb 32                	jmp    803844 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  803812:	ff 75 ec             	pushl  -0x14(%ebp)
  803815:	e8 24 f7 ff ff       	call   802f3e <get_block_size>
  80381a:	83 c4 04             	add    $0x4,%esp
  80381d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  803820:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803823:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803826:	72 14                	jb     80383c <alloc_block_BF+0x61>
  803828:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80382e:	73 0c                	jae    80383c <alloc_block_BF+0x61>
		{
			minBlk = block;
  803830:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803833:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  803836:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803839:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  80383c:	a1 50 50 98 00       	mov    0x985050,%eax
  803841:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803844:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803848:	74 07                	je     803851 <alloc_block_BF+0x76>
  80384a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80384d:	8b 00                	mov    (%eax),%eax
  80384f:	eb 05                	jmp    803856 <alloc_block_BF+0x7b>
  803851:	b8 00 00 00 00       	mov    $0x0,%eax
  803856:	a3 50 50 98 00       	mov    %eax,0x985050
  80385b:	a1 50 50 98 00       	mov    0x985050,%eax
  803860:	85 c0                	test   %eax,%eax
  803862:	75 ae                	jne    803812 <alloc_block_BF+0x37>
  803864:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803868:	75 a8                	jne    803812 <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  80386a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80386e:	75 22                	jne    803892 <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  803870:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803873:	83 ec 0c             	sub    $0xc,%esp
  803876:	50                   	push   %eax
  803877:	e8 5a e9 ff ff       	call   8021d6 <sbrk>
  80387c:	83 c4 10             	add    $0x10,%esp
  80387f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  803882:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  803886:	75 0a                	jne    803892 <alloc_block_BF+0xb7>
			return NULL;
  803888:	b8 00 00 00 00       	mov    $0x0,%eax
  80388d:	e9 d9 01 00 00       	jmp    803a6b <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  803892:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803895:	83 c0 10             	add    $0x10,%eax
  803898:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80389b:	0f 87 32 01 00 00    	ja     8039d3 <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  8038a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038a4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8038a7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  8038aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b0:	01 d0                	add    %edx,%eax
  8038b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  8038b5:	83 ec 04             	sub    $0x4,%esp
  8038b8:	6a 00                	push   $0x0
  8038ba:	ff 75 dc             	pushl  -0x24(%ebp)
  8038bd:	ff 75 d8             	pushl  -0x28(%ebp)
  8038c0:	e8 f5 f8 ff ff       	call   8031ba <set_block_data>
  8038c5:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  8038c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038cc:	74 06                	je     8038d4 <alloc_block_BF+0xf9>
  8038ce:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8038d2:	75 17                	jne    8038eb <alloc_block_BF+0x110>
  8038d4:	83 ec 04             	sub    $0x4,%esp
  8038d7:	68 ac 4e 80 00       	push   $0x804eac
  8038dc:	68 49 01 00 00       	push   $0x149
  8038e1:	68 37 4e 80 00       	push   $0x804e37
  8038e6:	e8 94 d8 ff ff       	call   80117f <_panic>
  8038eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ee:	8b 10                	mov    (%eax),%edx
  8038f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038f3:	89 10                	mov    %edx,(%eax)
  8038f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038f8:	8b 00                	mov    (%eax),%eax
  8038fa:	85 c0                	test   %eax,%eax
  8038fc:	74 0b                	je     803909 <alloc_block_BF+0x12e>
  8038fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803901:	8b 00                	mov    (%eax),%eax
  803903:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803906:	89 50 04             	mov    %edx,0x4(%eax)
  803909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80390f:	89 10                	mov    %edx,(%eax)
  803911:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803914:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803917:	89 50 04             	mov    %edx,0x4(%eax)
  80391a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80391d:	8b 00                	mov    (%eax),%eax
  80391f:	85 c0                	test   %eax,%eax
  803921:	75 08                	jne    80392b <alloc_block_BF+0x150>
  803923:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803926:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80392b:	a1 54 50 98 00       	mov    0x985054,%eax
  803930:	40                   	inc    %eax
  803931:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  803936:	83 ec 04             	sub    $0x4,%esp
  803939:	6a 01                	push   $0x1
  80393b:	ff 75 e8             	pushl  -0x18(%ebp)
  80393e:	ff 75 f4             	pushl  -0xc(%ebp)
  803941:	e8 74 f8 ff ff       	call   8031ba <set_block_data>
  803946:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  803949:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80394d:	75 17                	jne    803966 <alloc_block_BF+0x18b>
  80394f:	83 ec 04             	sub    $0x4,%esp
  803952:	68 e0 4e 80 00       	push   $0x804ee0
  803957:	68 4e 01 00 00       	push   $0x14e
  80395c:	68 37 4e 80 00       	push   $0x804e37
  803961:	e8 19 d8 ff ff       	call   80117f <_panic>
  803966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803969:	8b 00                	mov    (%eax),%eax
  80396b:	85 c0                	test   %eax,%eax
  80396d:	74 10                	je     80397f <alloc_block_BF+0x1a4>
  80396f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803972:	8b 00                	mov    (%eax),%eax
  803974:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803977:	8b 52 04             	mov    0x4(%edx),%edx
  80397a:	89 50 04             	mov    %edx,0x4(%eax)
  80397d:	eb 0b                	jmp    80398a <alloc_block_BF+0x1af>
  80397f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803982:	8b 40 04             	mov    0x4(%eax),%eax
  803985:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80398a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80398d:	8b 40 04             	mov    0x4(%eax),%eax
  803990:	85 c0                	test   %eax,%eax
  803992:	74 0f                	je     8039a3 <alloc_block_BF+0x1c8>
  803994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803997:	8b 40 04             	mov    0x4(%eax),%eax
  80399a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80399d:	8b 12                	mov    (%edx),%edx
  80399f:	89 10                	mov    %edx,(%eax)
  8039a1:	eb 0a                	jmp    8039ad <alloc_block_BF+0x1d2>
  8039a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a6:	8b 00                	mov    (%eax),%eax
  8039a8:	a3 48 50 98 00       	mov    %eax,0x985048
  8039ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039c0:	a1 54 50 98 00       	mov    0x985054,%eax
  8039c5:	48                   	dec    %eax
  8039c6:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  8039cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ce:	e9 98 00 00 00       	jmp    803a6b <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  8039d3:	83 ec 04             	sub    $0x4,%esp
  8039d6:	6a 01                	push   $0x1
  8039d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8039db:	ff 75 f4             	pushl  -0xc(%ebp)
  8039de:	e8 d7 f7 ff ff       	call   8031ba <set_block_data>
  8039e3:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  8039e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039ea:	75 17                	jne    803a03 <alloc_block_BF+0x228>
  8039ec:	83 ec 04             	sub    $0x4,%esp
  8039ef:	68 e0 4e 80 00       	push   $0x804ee0
  8039f4:	68 56 01 00 00       	push   $0x156
  8039f9:	68 37 4e 80 00       	push   $0x804e37
  8039fe:	e8 7c d7 ff ff       	call   80117f <_panic>
  803a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a06:	8b 00                	mov    (%eax),%eax
  803a08:	85 c0                	test   %eax,%eax
  803a0a:	74 10                	je     803a1c <alloc_block_BF+0x241>
  803a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a0f:	8b 00                	mov    (%eax),%eax
  803a11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a14:	8b 52 04             	mov    0x4(%edx),%edx
  803a17:	89 50 04             	mov    %edx,0x4(%eax)
  803a1a:	eb 0b                	jmp    803a27 <alloc_block_BF+0x24c>
  803a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1f:	8b 40 04             	mov    0x4(%eax),%eax
  803a22:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a2a:	8b 40 04             	mov    0x4(%eax),%eax
  803a2d:	85 c0                	test   %eax,%eax
  803a2f:	74 0f                	je     803a40 <alloc_block_BF+0x265>
  803a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a34:	8b 40 04             	mov    0x4(%eax),%eax
  803a37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a3a:	8b 12                	mov    (%edx),%edx
  803a3c:	89 10                	mov    %edx,(%eax)
  803a3e:	eb 0a                	jmp    803a4a <alloc_block_BF+0x26f>
  803a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a43:	8b 00                	mov    (%eax),%eax
  803a45:	a3 48 50 98 00       	mov    %eax,0x985048
  803a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a5d:	a1 54 50 98 00       	mov    0x985054,%eax
  803a62:	48                   	dec    %eax
  803a63:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  803a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  803a6b:	c9                   	leave  
  803a6c:	c3                   	ret    

00803a6d <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803a6d:	55                   	push   %ebp
  803a6e:	89 e5                	mov    %esp,%ebp
  803a70:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  803a73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a77:	0f 84 6a 02 00 00    	je     803ce7 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  803a7d:	ff 75 08             	pushl  0x8(%ebp)
  803a80:	e8 b9 f4 ff ff       	call   802f3e <get_block_size>
  803a85:	83 c4 04             	add    $0x4,%esp
  803a88:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  803a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a8e:	83 e8 08             	sub    $0x8,%eax
  803a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  803a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a97:	8b 00                	mov    (%eax),%eax
  803a99:	83 e0 fe             	and    $0xfffffffe,%eax
  803a9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  803a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803aa2:	f7 d8                	neg    %eax
  803aa4:	89 c2                	mov    %eax,%edx
  803aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa9:	01 d0                	add    %edx,%eax
  803aab:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  803aae:	ff 75 e8             	pushl  -0x18(%ebp)
  803ab1:	e8 a1 f4 ff ff       	call   802f57 <is_free_block>
  803ab6:	83 c4 04             	add    $0x4,%esp
  803ab9:	0f be c0             	movsbl %al,%eax
  803abc:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  803abf:	8b 55 08             	mov    0x8(%ebp),%edx
  803ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac5:	01 d0                	add    %edx,%eax
  803ac7:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  803aca:	ff 75 e0             	pushl  -0x20(%ebp)
  803acd:	e8 85 f4 ff ff       	call   802f57 <is_free_block>
  803ad2:	83 c4 04             	add    $0x4,%esp
  803ad5:	0f be c0             	movsbl %al,%eax
  803ad8:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  803adb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  803adf:	75 34                	jne    803b15 <free_block+0xa8>
  803ae1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803ae5:	75 2e                	jne    803b15 <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  803ae7:	ff 75 e8             	pushl  -0x18(%ebp)
  803aea:	e8 4f f4 ff ff       	call   802f3e <get_block_size>
  803aef:	83 c4 04             	add    $0x4,%esp
  803af2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  803af5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803af8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803afb:	01 d0                	add    %edx,%eax
  803afd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  803b00:	6a 00                	push   $0x0
  803b02:	ff 75 d4             	pushl  -0x2c(%ebp)
  803b05:	ff 75 e8             	pushl  -0x18(%ebp)
  803b08:	e8 ad f6 ff ff       	call   8031ba <set_block_data>
  803b0d:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  803b10:	e9 d3 01 00 00       	jmp    803ce8 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  803b15:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  803b19:	0f 85 c8 00 00 00    	jne    803be7 <free_block+0x17a>
  803b1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b23:	0f 85 be 00 00 00    	jne    803be7 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  803b29:	ff 75 e0             	pushl  -0x20(%ebp)
  803b2c:	e8 0d f4 ff ff       	call   802f3e <get_block_size>
  803b31:	83 c4 04             	add    $0x4,%esp
  803b34:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  803b37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b3a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b3d:	01 d0                	add    %edx,%eax
  803b3f:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  803b42:	6a 00                	push   $0x0
  803b44:	ff 75 cc             	pushl  -0x34(%ebp)
  803b47:	ff 75 08             	pushl  0x8(%ebp)
  803b4a:	e8 6b f6 ff ff       	call   8031ba <set_block_data>
  803b4f:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  803b52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803b56:	75 17                	jne    803b6f <free_block+0x102>
  803b58:	83 ec 04             	sub    $0x4,%esp
  803b5b:	68 e0 4e 80 00       	push   $0x804ee0
  803b60:	68 87 01 00 00       	push   $0x187
  803b65:	68 37 4e 80 00       	push   $0x804e37
  803b6a:	e8 10 d6 ff ff       	call   80117f <_panic>
  803b6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b72:	8b 00                	mov    (%eax),%eax
  803b74:	85 c0                	test   %eax,%eax
  803b76:	74 10                	je     803b88 <free_block+0x11b>
  803b78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b7b:	8b 00                	mov    (%eax),%eax
  803b7d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b80:	8b 52 04             	mov    0x4(%edx),%edx
  803b83:	89 50 04             	mov    %edx,0x4(%eax)
  803b86:	eb 0b                	jmp    803b93 <free_block+0x126>
  803b88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b8b:	8b 40 04             	mov    0x4(%eax),%eax
  803b8e:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803b93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b96:	8b 40 04             	mov    0x4(%eax),%eax
  803b99:	85 c0                	test   %eax,%eax
  803b9b:	74 0f                	je     803bac <free_block+0x13f>
  803b9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ba0:	8b 40 04             	mov    0x4(%eax),%eax
  803ba3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803ba6:	8b 12                	mov    (%edx),%edx
  803ba8:	89 10                	mov    %edx,(%eax)
  803baa:	eb 0a                	jmp    803bb6 <free_block+0x149>
  803bac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803baf:	8b 00                	mov    (%eax),%eax
  803bb1:	a3 48 50 98 00       	mov    %eax,0x985048
  803bb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bb9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bc2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bc9:	a1 54 50 98 00       	mov    0x985054,%eax
  803bce:	48                   	dec    %eax
  803bcf:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  803bd4:	83 ec 0c             	sub    $0xc,%esp
  803bd7:	ff 75 08             	pushl  0x8(%ebp)
  803bda:	e8 32 f6 ff ff       	call   803211 <insert_sorted_in_freeList>
  803bdf:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  803be2:	e9 01 01 00 00       	jmp    803ce8 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  803be7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  803beb:	0f 85 d3 00 00 00    	jne    803cc4 <free_block+0x257>
  803bf1:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  803bf5:	0f 85 c9 00 00 00    	jne    803cc4 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  803bfb:	83 ec 0c             	sub    $0xc,%esp
  803bfe:	ff 75 e8             	pushl  -0x18(%ebp)
  803c01:	e8 38 f3 ff ff       	call   802f3e <get_block_size>
  803c06:	83 c4 10             	add    $0x10,%esp
  803c09:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  803c0c:	83 ec 0c             	sub    $0xc,%esp
  803c0f:	ff 75 e0             	pushl  -0x20(%ebp)
  803c12:	e8 27 f3 ff ff       	call   802f3e <get_block_size>
  803c17:	83 c4 10             	add    $0x10,%esp
  803c1a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  803c1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c20:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c23:	01 c2                	add    %eax,%edx
  803c25:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803c28:	01 d0                	add    %edx,%eax
  803c2a:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  803c2d:	83 ec 04             	sub    $0x4,%esp
  803c30:	6a 00                	push   $0x0
  803c32:	ff 75 c0             	pushl  -0x40(%ebp)
  803c35:	ff 75 e8             	pushl  -0x18(%ebp)
  803c38:	e8 7d f5 ff ff       	call   8031ba <set_block_data>
  803c3d:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  803c40:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803c44:	75 17                	jne    803c5d <free_block+0x1f0>
  803c46:	83 ec 04             	sub    $0x4,%esp
  803c49:	68 e0 4e 80 00       	push   $0x804ee0
  803c4e:	68 94 01 00 00       	push   $0x194
  803c53:	68 37 4e 80 00       	push   $0x804e37
  803c58:	e8 22 d5 ff ff       	call   80117f <_panic>
  803c5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c60:	8b 00                	mov    (%eax),%eax
  803c62:	85 c0                	test   %eax,%eax
  803c64:	74 10                	je     803c76 <free_block+0x209>
  803c66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c69:	8b 00                	mov    (%eax),%eax
  803c6b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c6e:	8b 52 04             	mov    0x4(%edx),%edx
  803c71:	89 50 04             	mov    %edx,0x4(%eax)
  803c74:	eb 0b                	jmp    803c81 <free_block+0x214>
  803c76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c79:	8b 40 04             	mov    0x4(%eax),%eax
  803c7c:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803c81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c84:	8b 40 04             	mov    0x4(%eax),%eax
  803c87:	85 c0                	test   %eax,%eax
  803c89:	74 0f                	je     803c9a <free_block+0x22d>
  803c8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c8e:	8b 40 04             	mov    0x4(%eax),%eax
  803c91:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c94:	8b 12                	mov    (%edx),%edx
  803c96:	89 10                	mov    %edx,(%eax)
  803c98:	eb 0a                	jmp    803ca4 <free_block+0x237>
  803c9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c9d:	8b 00                	mov    (%eax),%eax
  803c9f:	a3 48 50 98 00       	mov    %eax,0x985048
  803ca4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ca7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cb7:	a1 54 50 98 00       	mov    0x985054,%eax
  803cbc:	48                   	dec    %eax
  803cbd:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  803cc2:	eb 24                	jmp    803ce8 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  803cc4:	83 ec 04             	sub    $0x4,%esp
  803cc7:	6a 00                	push   $0x0
  803cc9:	ff 75 f4             	pushl  -0xc(%ebp)
  803ccc:	ff 75 08             	pushl  0x8(%ebp)
  803ccf:	e8 e6 f4 ff ff       	call   8031ba <set_block_data>
  803cd4:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  803cd7:	83 ec 0c             	sub    $0xc,%esp
  803cda:	ff 75 08             	pushl  0x8(%ebp)
  803cdd:	e8 2f f5 ff ff       	call   803211 <insert_sorted_in_freeList>
  803ce2:	83 c4 10             	add    $0x10,%esp
  803ce5:	eb 01                	jmp    803ce8 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  803ce7:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  803ce8:	c9                   	leave  
  803ce9:	c3                   	ret    

00803cea <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  803cea:	55                   	push   %ebp
  803ceb:	89 e5                	mov    %esp,%ebp
  803ced:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  803cf0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803cf4:	75 10                	jne    803d06 <realloc_block_FF+0x1c>
  803cf6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803cfa:	75 0a                	jne    803d06 <realloc_block_FF+0x1c>
	{
		return NULL;
  803cfc:	b8 00 00 00 00       	mov    $0x0,%eax
  803d01:	e9 8b 04 00 00       	jmp    804191 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  803d06:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803d0a:	75 18                	jne    803d24 <realloc_block_FF+0x3a>
	{
		free_block(va);
  803d0c:	83 ec 0c             	sub    $0xc,%esp
  803d0f:	ff 75 08             	pushl  0x8(%ebp)
  803d12:	e8 56 fd ff ff       	call   803a6d <free_block>
  803d17:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803d1a:	b8 00 00 00 00       	mov    $0x0,%eax
  803d1f:	e9 6d 04 00 00       	jmp    804191 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  803d24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d28:	75 13                	jne    803d3d <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  803d2a:	83 ec 0c             	sub    $0xc,%esp
  803d2d:	ff 75 0c             	pushl  0xc(%ebp)
  803d30:	e8 6f f6 ff ff       	call   8033a4 <alloc_block_FF>
  803d35:	83 c4 10             	add    $0x10,%esp
  803d38:	e9 54 04 00 00       	jmp    804191 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  803d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d40:	83 e0 01             	and    $0x1,%eax
  803d43:	85 c0                	test   %eax,%eax
  803d45:	74 03                	je     803d4a <realloc_block_FF+0x60>
	{
		new_size++;
  803d47:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  803d4a:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803d4e:	77 07                	ja     803d57 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  803d50:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  803d57:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  803d5b:	83 ec 0c             	sub    $0xc,%esp
  803d5e:	ff 75 08             	pushl  0x8(%ebp)
  803d61:	e8 d8 f1 ff ff       	call   802f3e <get_block_size>
  803d66:	83 c4 10             	add    $0x10,%esp
  803d69:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  803d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d6f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803d72:	75 08                	jne    803d7c <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  803d74:	8b 45 08             	mov    0x8(%ebp),%eax
  803d77:	e9 15 04 00 00       	jmp    804191 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  803d7c:	8b 55 08             	mov    0x8(%ebp),%edx
  803d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d82:	01 d0                	add    %edx,%eax
  803d84:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  803d87:	83 ec 0c             	sub    $0xc,%esp
  803d8a:	ff 75 f0             	pushl  -0x10(%ebp)
  803d8d:	e8 c5 f1 ff ff       	call   802f57 <is_free_block>
  803d92:	83 c4 10             	add    $0x10,%esp
  803d95:	0f be c0             	movsbl %al,%eax
  803d98:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  803d9b:	83 ec 0c             	sub    $0xc,%esp
  803d9e:	ff 75 f0             	pushl  -0x10(%ebp)
  803da1:	e8 98 f1 ff ff       	call   802f3e <get_block_size>
  803da6:	83 c4 10             	add    $0x10,%esp
  803da9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  803dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  803daf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803db2:	0f 86 a7 02 00 00    	jbe    80405f <realloc_block_FF+0x375>
	{
		if(isNextFree)
  803db8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803dbc:	0f 84 86 02 00 00    	je     804048 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  803dc2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc8:	01 d0                	add    %edx,%eax
  803dca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803dcd:	0f 85 b2 00 00 00    	jne    803e85 <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  803dd3:	83 ec 0c             	sub    $0xc,%esp
  803dd6:	ff 75 08             	pushl  0x8(%ebp)
  803dd9:	e8 79 f1 ff ff       	call   802f57 <is_free_block>
  803dde:	83 c4 10             	add    $0x10,%esp
  803de1:	84 c0                	test   %al,%al
  803de3:	0f 94 c0             	sete   %al
  803de6:	0f b6 c0             	movzbl %al,%eax
  803de9:	83 ec 04             	sub    $0x4,%esp
  803dec:	50                   	push   %eax
  803ded:	ff 75 0c             	pushl  0xc(%ebp)
  803df0:	ff 75 08             	pushl  0x8(%ebp)
  803df3:	e8 c2 f3 ff ff       	call   8031ba <set_block_data>
  803df8:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  803dfb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803dff:	75 17                	jne    803e18 <realloc_block_FF+0x12e>
  803e01:	83 ec 04             	sub    $0x4,%esp
  803e04:	68 e0 4e 80 00       	push   $0x804ee0
  803e09:	68 db 01 00 00       	push   $0x1db
  803e0e:	68 37 4e 80 00       	push   $0x804e37
  803e13:	e8 67 d3 ff ff       	call   80117f <_panic>
  803e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e1b:	8b 00                	mov    (%eax),%eax
  803e1d:	85 c0                	test   %eax,%eax
  803e1f:	74 10                	je     803e31 <realloc_block_FF+0x147>
  803e21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e24:	8b 00                	mov    (%eax),%eax
  803e26:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e29:	8b 52 04             	mov    0x4(%edx),%edx
  803e2c:	89 50 04             	mov    %edx,0x4(%eax)
  803e2f:	eb 0b                	jmp    803e3c <realloc_block_FF+0x152>
  803e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e34:	8b 40 04             	mov    0x4(%eax),%eax
  803e37:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e3f:	8b 40 04             	mov    0x4(%eax),%eax
  803e42:	85 c0                	test   %eax,%eax
  803e44:	74 0f                	je     803e55 <realloc_block_FF+0x16b>
  803e46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e49:	8b 40 04             	mov    0x4(%eax),%eax
  803e4c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e4f:	8b 12                	mov    (%edx),%edx
  803e51:	89 10                	mov    %edx,(%eax)
  803e53:	eb 0a                	jmp    803e5f <realloc_block_FF+0x175>
  803e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e58:	8b 00                	mov    (%eax),%eax
  803e5a:	a3 48 50 98 00       	mov    %eax,0x985048
  803e5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e72:	a1 54 50 98 00       	mov    0x985054,%eax
  803e77:	48                   	dec    %eax
  803e78:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  803e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e80:	e9 0c 03 00 00       	jmp    804191 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  803e85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e8b:	01 d0                	add    %edx,%eax
  803e8d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803e90:	0f 86 b2 01 00 00    	jbe    804048 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  803e96:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e99:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803e9c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  803e9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ea2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  803ea8:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  803eac:	0f 87 b8 00 00 00    	ja     803f6a <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  803eb2:	83 ec 0c             	sub    $0xc,%esp
  803eb5:	ff 75 08             	pushl  0x8(%ebp)
  803eb8:	e8 9a f0 ff ff       	call   802f57 <is_free_block>
  803ebd:	83 c4 10             	add    $0x10,%esp
  803ec0:	84 c0                	test   %al,%al
  803ec2:	0f 94 c0             	sete   %al
  803ec5:	0f b6 c0             	movzbl %al,%eax
  803ec8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803ecb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ece:	01 ca                	add    %ecx,%edx
  803ed0:	83 ec 04             	sub    $0x4,%esp
  803ed3:	50                   	push   %eax
  803ed4:	52                   	push   %edx
  803ed5:	ff 75 08             	pushl  0x8(%ebp)
  803ed8:	e8 dd f2 ff ff       	call   8031ba <set_block_data>
  803edd:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803ee0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ee4:	75 17                	jne    803efd <realloc_block_FF+0x213>
  803ee6:	83 ec 04             	sub    $0x4,%esp
  803ee9:	68 e0 4e 80 00       	push   $0x804ee0
  803eee:	68 e8 01 00 00       	push   $0x1e8
  803ef3:	68 37 4e 80 00       	push   $0x804e37
  803ef8:	e8 82 d2 ff ff       	call   80117f <_panic>
  803efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f00:	8b 00                	mov    (%eax),%eax
  803f02:	85 c0                	test   %eax,%eax
  803f04:	74 10                	je     803f16 <realloc_block_FF+0x22c>
  803f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f09:	8b 00                	mov    (%eax),%eax
  803f0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f0e:	8b 52 04             	mov    0x4(%edx),%edx
  803f11:	89 50 04             	mov    %edx,0x4(%eax)
  803f14:	eb 0b                	jmp    803f21 <realloc_block_FF+0x237>
  803f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f19:	8b 40 04             	mov    0x4(%eax),%eax
  803f1c:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f24:	8b 40 04             	mov    0x4(%eax),%eax
  803f27:	85 c0                	test   %eax,%eax
  803f29:	74 0f                	je     803f3a <realloc_block_FF+0x250>
  803f2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f2e:	8b 40 04             	mov    0x4(%eax),%eax
  803f31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f34:	8b 12                	mov    (%edx),%edx
  803f36:	89 10                	mov    %edx,(%eax)
  803f38:	eb 0a                	jmp    803f44 <realloc_block_FF+0x25a>
  803f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f3d:	8b 00                	mov    (%eax),%eax
  803f3f:	a3 48 50 98 00       	mov    %eax,0x985048
  803f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f57:	a1 54 50 98 00       	mov    0x985054,%eax
  803f5c:	48                   	dec    %eax
  803f5d:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  803f62:	8b 45 08             	mov    0x8(%ebp),%eax
  803f65:	e9 27 02 00 00       	jmp    804191 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803f6a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f6e:	75 17                	jne    803f87 <realloc_block_FF+0x29d>
  803f70:	83 ec 04             	sub    $0x4,%esp
  803f73:	68 e0 4e 80 00       	push   $0x804ee0
  803f78:	68 ed 01 00 00       	push   $0x1ed
  803f7d:	68 37 4e 80 00       	push   $0x804e37
  803f82:	e8 f8 d1 ff ff       	call   80117f <_panic>
  803f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f8a:	8b 00                	mov    (%eax),%eax
  803f8c:	85 c0                	test   %eax,%eax
  803f8e:	74 10                	je     803fa0 <realloc_block_FF+0x2b6>
  803f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f93:	8b 00                	mov    (%eax),%eax
  803f95:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f98:	8b 52 04             	mov    0x4(%edx),%edx
  803f9b:	89 50 04             	mov    %edx,0x4(%eax)
  803f9e:	eb 0b                	jmp    803fab <realloc_block_FF+0x2c1>
  803fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fa3:	8b 40 04             	mov    0x4(%eax),%eax
  803fa6:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803fab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fae:	8b 40 04             	mov    0x4(%eax),%eax
  803fb1:	85 c0                	test   %eax,%eax
  803fb3:	74 0f                	je     803fc4 <realloc_block_FF+0x2da>
  803fb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fb8:	8b 40 04             	mov    0x4(%eax),%eax
  803fbb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803fbe:	8b 12                	mov    (%edx),%edx
  803fc0:	89 10                	mov    %edx,(%eax)
  803fc2:	eb 0a                	jmp    803fce <realloc_block_FF+0x2e4>
  803fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fc7:	8b 00                	mov    (%eax),%eax
  803fc9:	a3 48 50 98 00       	mov    %eax,0x985048
  803fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fd1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fda:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fe1:	a1 54 50 98 00       	mov    0x985054,%eax
  803fe6:	48                   	dec    %eax
  803fe7:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  803fec:	8b 55 08             	mov    0x8(%ebp),%edx
  803fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ff2:	01 d0                	add    %edx,%eax
  803ff4:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  803ff7:	83 ec 04             	sub    $0x4,%esp
  803ffa:	6a 00                	push   $0x0
  803ffc:	ff 75 e0             	pushl  -0x20(%ebp)
  803fff:	ff 75 f0             	pushl  -0x10(%ebp)
  804002:	e8 b3 f1 ff ff       	call   8031ba <set_block_data>
  804007:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  80400a:	83 ec 0c             	sub    $0xc,%esp
  80400d:	ff 75 08             	pushl  0x8(%ebp)
  804010:	e8 42 ef ff ff       	call   802f57 <is_free_block>
  804015:	83 c4 10             	add    $0x10,%esp
  804018:	84 c0                	test   %al,%al
  80401a:	0f 94 c0             	sete   %al
  80401d:	0f b6 c0             	movzbl %al,%eax
  804020:	83 ec 04             	sub    $0x4,%esp
  804023:	50                   	push   %eax
  804024:	ff 75 0c             	pushl  0xc(%ebp)
  804027:	ff 75 08             	pushl  0x8(%ebp)
  80402a:	e8 8b f1 ff ff       	call   8031ba <set_block_data>
  80402f:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  804032:	83 ec 0c             	sub    $0xc,%esp
  804035:	ff 75 f0             	pushl  -0x10(%ebp)
  804038:	e8 d4 f1 ff ff       	call   803211 <insert_sorted_in_freeList>
  80403d:	83 c4 10             	add    $0x10,%esp
					return va;
  804040:	8b 45 08             	mov    0x8(%ebp),%eax
  804043:	e9 49 01 00 00       	jmp    804191 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  804048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80404b:	83 e8 08             	sub    $0x8,%eax
  80404e:	83 ec 0c             	sub    $0xc,%esp
  804051:	50                   	push   %eax
  804052:	e8 4d f3 ff ff       	call   8033a4 <alloc_block_FF>
  804057:	83 c4 10             	add    $0x10,%esp
  80405a:	e9 32 01 00 00       	jmp    804191 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  80405f:	8b 45 0c             	mov    0xc(%ebp),%eax
  804062:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  804065:	0f 83 21 01 00 00    	jae    80418c <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  80406b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80406e:	2b 45 0c             	sub    0xc(%ebp),%eax
  804071:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  804074:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  804078:	77 0e                	ja     804088 <realloc_block_FF+0x39e>
  80407a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80407e:	75 08                	jne    804088 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  804080:	8b 45 08             	mov    0x8(%ebp),%eax
  804083:	e9 09 01 00 00       	jmp    804191 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  804088:	8b 45 08             	mov    0x8(%ebp),%eax
  80408b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  80408e:	83 ec 0c             	sub    $0xc,%esp
  804091:	ff 75 08             	pushl  0x8(%ebp)
  804094:	e8 be ee ff ff       	call   802f57 <is_free_block>
  804099:	83 c4 10             	add    $0x10,%esp
  80409c:	84 c0                	test   %al,%al
  80409e:	0f 94 c0             	sete   %al
  8040a1:	0f b6 c0             	movzbl %al,%eax
  8040a4:	83 ec 04             	sub    $0x4,%esp
  8040a7:	50                   	push   %eax
  8040a8:	ff 75 0c             	pushl  0xc(%ebp)
  8040ab:	ff 75 d8             	pushl  -0x28(%ebp)
  8040ae:	e8 07 f1 ff ff       	call   8031ba <set_block_data>
  8040b3:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  8040b6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8040b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040bc:	01 d0                	add    %edx,%eax
  8040be:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  8040c1:	83 ec 04             	sub    $0x4,%esp
  8040c4:	6a 00                	push   $0x0
  8040c6:	ff 75 dc             	pushl  -0x24(%ebp)
  8040c9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8040cc:	e8 e9 f0 ff ff       	call   8031ba <set_block_data>
  8040d1:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  8040d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8040d8:	0f 84 9b 00 00 00    	je     804179 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  8040de:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8040e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040e4:	01 d0                	add    %edx,%eax
  8040e6:	83 ec 04             	sub    $0x4,%esp
  8040e9:	6a 00                	push   $0x0
  8040eb:	50                   	push   %eax
  8040ec:	ff 75 d4             	pushl  -0x2c(%ebp)
  8040ef:	e8 c6 f0 ff ff       	call   8031ba <set_block_data>
  8040f4:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  8040f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8040fb:	75 17                	jne    804114 <realloc_block_FF+0x42a>
  8040fd:	83 ec 04             	sub    $0x4,%esp
  804100:	68 e0 4e 80 00       	push   $0x804ee0
  804105:	68 10 02 00 00       	push   $0x210
  80410a:	68 37 4e 80 00       	push   $0x804e37
  80410f:	e8 6b d0 ff ff       	call   80117f <_panic>
  804114:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804117:	8b 00                	mov    (%eax),%eax
  804119:	85 c0                	test   %eax,%eax
  80411b:	74 10                	je     80412d <realloc_block_FF+0x443>
  80411d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804120:	8b 00                	mov    (%eax),%eax
  804122:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804125:	8b 52 04             	mov    0x4(%edx),%edx
  804128:	89 50 04             	mov    %edx,0x4(%eax)
  80412b:	eb 0b                	jmp    804138 <realloc_block_FF+0x44e>
  80412d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804130:	8b 40 04             	mov    0x4(%eax),%eax
  804133:	a3 4c 50 98 00       	mov    %eax,0x98504c
  804138:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80413b:	8b 40 04             	mov    0x4(%eax),%eax
  80413e:	85 c0                	test   %eax,%eax
  804140:	74 0f                	je     804151 <realloc_block_FF+0x467>
  804142:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804145:	8b 40 04             	mov    0x4(%eax),%eax
  804148:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80414b:	8b 12                	mov    (%edx),%edx
  80414d:	89 10                	mov    %edx,(%eax)
  80414f:	eb 0a                	jmp    80415b <realloc_block_FF+0x471>
  804151:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804154:	8b 00                	mov    (%eax),%eax
  804156:	a3 48 50 98 00       	mov    %eax,0x985048
  80415b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80415e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804164:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804167:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80416e:	a1 54 50 98 00       	mov    0x985054,%eax
  804173:	48                   	dec    %eax
  804174:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  804179:	83 ec 0c             	sub    $0xc,%esp
  80417c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80417f:	e8 8d f0 ff ff       	call   803211 <insert_sorted_in_freeList>
  804184:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  804187:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80418a:	eb 05                	jmp    804191 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  80418c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804191:	c9                   	leave  
  804192:	c3                   	ret    

00804193 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804193:	55                   	push   %ebp
  804194:	89 e5                	mov    %esp,%ebp
  804196:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804199:	83 ec 04             	sub    $0x4,%esp
  80419c:	68 00 4f 80 00       	push   $0x804f00
  8041a1:	68 20 02 00 00       	push   $0x220
  8041a6:	68 37 4e 80 00       	push   $0x804e37
  8041ab:	e8 cf cf ff ff       	call   80117f <_panic>

008041b0 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8041b0:	55                   	push   %ebp
  8041b1:	89 e5                	mov    %esp,%ebp
  8041b3:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8041b6:	83 ec 04             	sub    $0x4,%esp
  8041b9:	68 28 4f 80 00       	push   $0x804f28
  8041be:	68 28 02 00 00       	push   $0x228
  8041c3:	68 37 4e 80 00       	push   $0x804e37
  8041c8:	e8 b2 cf ff ff       	call   80117f <_panic>
  8041cd:	66 90                	xchg   %ax,%ax
  8041cf:	90                   	nop

008041d0 <__udivdi3>:
  8041d0:	55                   	push   %ebp
  8041d1:	57                   	push   %edi
  8041d2:	56                   	push   %esi
  8041d3:	53                   	push   %ebx
  8041d4:	83 ec 1c             	sub    $0x1c,%esp
  8041d7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8041db:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8041df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8041e7:	89 ca                	mov    %ecx,%edx
  8041e9:	89 f8                	mov    %edi,%eax
  8041eb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8041ef:	85 f6                	test   %esi,%esi
  8041f1:	75 2d                	jne    804220 <__udivdi3+0x50>
  8041f3:	39 cf                	cmp    %ecx,%edi
  8041f5:	77 65                	ja     80425c <__udivdi3+0x8c>
  8041f7:	89 fd                	mov    %edi,%ebp
  8041f9:	85 ff                	test   %edi,%edi
  8041fb:	75 0b                	jne    804208 <__udivdi3+0x38>
  8041fd:	b8 01 00 00 00       	mov    $0x1,%eax
  804202:	31 d2                	xor    %edx,%edx
  804204:	f7 f7                	div    %edi
  804206:	89 c5                	mov    %eax,%ebp
  804208:	31 d2                	xor    %edx,%edx
  80420a:	89 c8                	mov    %ecx,%eax
  80420c:	f7 f5                	div    %ebp
  80420e:	89 c1                	mov    %eax,%ecx
  804210:	89 d8                	mov    %ebx,%eax
  804212:	f7 f5                	div    %ebp
  804214:	89 cf                	mov    %ecx,%edi
  804216:	89 fa                	mov    %edi,%edx
  804218:	83 c4 1c             	add    $0x1c,%esp
  80421b:	5b                   	pop    %ebx
  80421c:	5e                   	pop    %esi
  80421d:	5f                   	pop    %edi
  80421e:	5d                   	pop    %ebp
  80421f:	c3                   	ret    
  804220:	39 ce                	cmp    %ecx,%esi
  804222:	77 28                	ja     80424c <__udivdi3+0x7c>
  804224:	0f bd fe             	bsr    %esi,%edi
  804227:	83 f7 1f             	xor    $0x1f,%edi
  80422a:	75 40                	jne    80426c <__udivdi3+0x9c>
  80422c:	39 ce                	cmp    %ecx,%esi
  80422e:	72 0a                	jb     80423a <__udivdi3+0x6a>
  804230:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804234:	0f 87 9e 00 00 00    	ja     8042d8 <__udivdi3+0x108>
  80423a:	b8 01 00 00 00       	mov    $0x1,%eax
  80423f:	89 fa                	mov    %edi,%edx
  804241:	83 c4 1c             	add    $0x1c,%esp
  804244:	5b                   	pop    %ebx
  804245:	5e                   	pop    %esi
  804246:	5f                   	pop    %edi
  804247:	5d                   	pop    %ebp
  804248:	c3                   	ret    
  804249:	8d 76 00             	lea    0x0(%esi),%esi
  80424c:	31 ff                	xor    %edi,%edi
  80424e:	31 c0                	xor    %eax,%eax
  804250:	89 fa                	mov    %edi,%edx
  804252:	83 c4 1c             	add    $0x1c,%esp
  804255:	5b                   	pop    %ebx
  804256:	5e                   	pop    %esi
  804257:	5f                   	pop    %edi
  804258:	5d                   	pop    %ebp
  804259:	c3                   	ret    
  80425a:	66 90                	xchg   %ax,%ax
  80425c:	89 d8                	mov    %ebx,%eax
  80425e:	f7 f7                	div    %edi
  804260:	31 ff                	xor    %edi,%edi
  804262:	89 fa                	mov    %edi,%edx
  804264:	83 c4 1c             	add    $0x1c,%esp
  804267:	5b                   	pop    %ebx
  804268:	5e                   	pop    %esi
  804269:	5f                   	pop    %edi
  80426a:	5d                   	pop    %ebp
  80426b:	c3                   	ret    
  80426c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804271:	89 eb                	mov    %ebp,%ebx
  804273:	29 fb                	sub    %edi,%ebx
  804275:	89 f9                	mov    %edi,%ecx
  804277:	d3 e6                	shl    %cl,%esi
  804279:	89 c5                	mov    %eax,%ebp
  80427b:	88 d9                	mov    %bl,%cl
  80427d:	d3 ed                	shr    %cl,%ebp
  80427f:	89 e9                	mov    %ebp,%ecx
  804281:	09 f1                	or     %esi,%ecx
  804283:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804287:	89 f9                	mov    %edi,%ecx
  804289:	d3 e0                	shl    %cl,%eax
  80428b:	89 c5                	mov    %eax,%ebp
  80428d:	89 d6                	mov    %edx,%esi
  80428f:	88 d9                	mov    %bl,%cl
  804291:	d3 ee                	shr    %cl,%esi
  804293:	89 f9                	mov    %edi,%ecx
  804295:	d3 e2                	shl    %cl,%edx
  804297:	8b 44 24 08          	mov    0x8(%esp),%eax
  80429b:	88 d9                	mov    %bl,%cl
  80429d:	d3 e8                	shr    %cl,%eax
  80429f:	09 c2                	or     %eax,%edx
  8042a1:	89 d0                	mov    %edx,%eax
  8042a3:	89 f2                	mov    %esi,%edx
  8042a5:	f7 74 24 0c          	divl   0xc(%esp)
  8042a9:	89 d6                	mov    %edx,%esi
  8042ab:	89 c3                	mov    %eax,%ebx
  8042ad:	f7 e5                	mul    %ebp
  8042af:	39 d6                	cmp    %edx,%esi
  8042b1:	72 19                	jb     8042cc <__udivdi3+0xfc>
  8042b3:	74 0b                	je     8042c0 <__udivdi3+0xf0>
  8042b5:	89 d8                	mov    %ebx,%eax
  8042b7:	31 ff                	xor    %edi,%edi
  8042b9:	e9 58 ff ff ff       	jmp    804216 <__udivdi3+0x46>
  8042be:	66 90                	xchg   %ax,%ax
  8042c0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8042c4:	89 f9                	mov    %edi,%ecx
  8042c6:	d3 e2                	shl    %cl,%edx
  8042c8:	39 c2                	cmp    %eax,%edx
  8042ca:	73 e9                	jae    8042b5 <__udivdi3+0xe5>
  8042cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8042cf:	31 ff                	xor    %edi,%edi
  8042d1:	e9 40 ff ff ff       	jmp    804216 <__udivdi3+0x46>
  8042d6:	66 90                	xchg   %ax,%ax
  8042d8:	31 c0                	xor    %eax,%eax
  8042da:	e9 37 ff ff ff       	jmp    804216 <__udivdi3+0x46>
  8042df:	90                   	nop

008042e0 <__umoddi3>:
  8042e0:	55                   	push   %ebp
  8042e1:	57                   	push   %edi
  8042e2:	56                   	push   %esi
  8042e3:	53                   	push   %ebx
  8042e4:	83 ec 1c             	sub    $0x1c,%esp
  8042e7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8042eb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8042ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8042f3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8042f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8042fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8042ff:	89 f3                	mov    %esi,%ebx
  804301:	89 fa                	mov    %edi,%edx
  804303:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804307:	89 34 24             	mov    %esi,(%esp)
  80430a:	85 c0                	test   %eax,%eax
  80430c:	75 1a                	jne    804328 <__umoddi3+0x48>
  80430e:	39 f7                	cmp    %esi,%edi
  804310:	0f 86 a2 00 00 00    	jbe    8043b8 <__umoddi3+0xd8>
  804316:	89 c8                	mov    %ecx,%eax
  804318:	89 f2                	mov    %esi,%edx
  80431a:	f7 f7                	div    %edi
  80431c:	89 d0                	mov    %edx,%eax
  80431e:	31 d2                	xor    %edx,%edx
  804320:	83 c4 1c             	add    $0x1c,%esp
  804323:	5b                   	pop    %ebx
  804324:	5e                   	pop    %esi
  804325:	5f                   	pop    %edi
  804326:	5d                   	pop    %ebp
  804327:	c3                   	ret    
  804328:	39 f0                	cmp    %esi,%eax
  80432a:	0f 87 ac 00 00 00    	ja     8043dc <__umoddi3+0xfc>
  804330:	0f bd e8             	bsr    %eax,%ebp
  804333:	83 f5 1f             	xor    $0x1f,%ebp
  804336:	0f 84 ac 00 00 00    	je     8043e8 <__umoddi3+0x108>
  80433c:	bf 20 00 00 00       	mov    $0x20,%edi
  804341:	29 ef                	sub    %ebp,%edi
  804343:	89 fe                	mov    %edi,%esi
  804345:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804349:	89 e9                	mov    %ebp,%ecx
  80434b:	d3 e0                	shl    %cl,%eax
  80434d:	89 d7                	mov    %edx,%edi
  80434f:	89 f1                	mov    %esi,%ecx
  804351:	d3 ef                	shr    %cl,%edi
  804353:	09 c7                	or     %eax,%edi
  804355:	89 e9                	mov    %ebp,%ecx
  804357:	d3 e2                	shl    %cl,%edx
  804359:	89 14 24             	mov    %edx,(%esp)
  80435c:	89 d8                	mov    %ebx,%eax
  80435e:	d3 e0                	shl    %cl,%eax
  804360:	89 c2                	mov    %eax,%edx
  804362:	8b 44 24 08          	mov    0x8(%esp),%eax
  804366:	d3 e0                	shl    %cl,%eax
  804368:	89 44 24 04          	mov    %eax,0x4(%esp)
  80436c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804370:	89 f1                	mov    %esi,%ecx
  804372:	d3 e8                	shr    %cl,%eax
  804374:	09 d0                	or     %edx,%eax
  804376:	d3 eb                	shr    %cl,%ebx
  804378:	89 da                	mov    %ebx,%edx
  80437a:	f7 f7                	div    %edi
  80437c:	89 d3                	mov    %edx,%ebx
  80437e:	f7 24 24             	mull   (%esp)
  804381:	89 c6                	mov    %eax,%esi
  804383:	89 d1                	mov    %edx,%ecx
  804385:	39 d3                	cmp    %edx,%ebx
  804387:	0f 82 87 00 00 00    	jb     804414 <__umoddi3+0x134>
  80438d:	0f 84 91 00 00 00    	je     804424 <__umoddi3+0x144>
  804393:	8b 54 24 04          	mov    0x4(%esp),%edx
  804397:	29 f2                	sub    %esi,%edx
  804399:	19 cb                	sbb    %ecx,%ebx
  80439b:	89 d8                	mov    %ebx,%eax
  80439d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8043a1:	d3 e0                	shl    %cl,%eax
  8043a3:	89 e9                	mov    %ebp,%ecx
  8043a5:	d3 ea                	shr    %cl,%edx
  8043a7:	09 d0                	or     %edx,%eax
  8043a9:	89 e9                	mov    %ebp,%ecx
  8043ab:	d3 eb                	shr    %cl,%ebx
  8043ad:	89 da                	mov    %ebx,%edx
  8043af:	83 c4 1c             	add    $0x1c,%esp
  8043b2:	5b                   	pop    %ebx
  8043b3:	5e                   	pop    %esi
  8043b4:	5f                   	pop    %edi
  8043b5:	5d                   	pop    %ebp
  8043b6:	c3                   	ret    
  8043b7:	90                   	nop
  8043b8:	89 fd                	mov    %edi,%ebp
  8043ba:	85 ff                	test   %edi,%edi
  8043bc:	75 0b                	jne    8043c9 <__umoddi3+0xe9>
  8043be:	b8 01 00 00 00       	mov    $0x1,%eax
  8043c3:	31 d2                	xor    %edx,%edx
  8043c5:	f7 f7                	div    %edi
  8043c7:	89 c5                	mov    %eax,%ebp
  8043c9:	89 f0                	mov    %esi,%eax
  8043cb:	31 d2                	xor    %edx,%edx
  8043cd:	f7 f5                	div    %ebp
  8043cf:	89 c8                	mov    %ecx,%eax
  8043d1:	f7 f5                	div    %ebp
  8043d3:	89 d0                	mov    %edx,%eax
  8043d5:	e9 44 ff ff ff       	jmp    80431e <__umoddi3+0x3e>
  8043da:	66 90                	xchg   %ax,%ax
  8043dc:	89 c8                	mov    %ecx,%eax
  8043de:	89 f2                	mov    %esi,%edx
  8043e0:	83 c4 1c             	add    $0x1c,%esp
  8043e3:	5b                   	pop    %ebx
  8043e4:	5e                   	pop    %esi
  8043e5:	5f                   	pop    %edi
  8043e6:	5d                   	pop    %ebp
  8043e7:	c3                   	ret    
  8043e8:	3b 04 24             	cmp    (%esp),%eax
  8043eb:	72 06                	jb     8043f3 <__umoddi3+0x113>
  8043ed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8043f1:	77 0f                	ja     804402 <__umoddi3+0x122>
  8043f3:	89 f2                	mov    %esi,%edx
  8043f5:	29 f9                	sub    %edi,%ecx
  8043f7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8043fb:	89 14 24             	mov    %edx,(%esp)
  8043fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804402:	8b 44 24 04          	mov    0x4(%esp),%eax
  804406:	8b 14 24             	mov    (%esp),%edx
  804409:	83 c4 1c             	add    $0x1c,%esp
  80440c:	5b                   	pop    %ebx
  80440d:	5e                   	pop    %esi
  80440e:	5f                   	pop    %edi
  80440f:	5d                   	pop    %ebp
  804410:	c3                   	ret    
  804411:	8d 76 00             	lea    0x0(%esi),%esi
  804414:	2b 04 24             	sub    (%esp),%eax
  804417:	19 fa                	sbb    %edi,%edx
  804419:	89 d1                	mov    %edx,%ecx
  80441b:	89 c6                	mov    %eax,%esi
  80441d:	e9 71 ff ff ff       	jmp    804393 <__umoddi3+0xb3>
  804422:	66 90                	xchg   %ax,%ax
  804424:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804428:	72 ea                	jb     804414 <__umoddi3+0x134>
  80442a:	89 d9                	mov    %ebx,%ecx
  80442c:	e9 62 ff ff ff       	jmp    804393 <__umoddi3+0xb3>
