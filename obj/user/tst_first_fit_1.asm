
obj/user/tst_first_fit_1:     file format elf32-i386


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
  800031:	e8 b3 0a 00 00       	call   800ae9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 3000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
#if USE_KHEAP

	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 24 28 00 00       	call   80286e <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp
	 *********************************************************/

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
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
  80006a:	68 e0 3e 80 00       	push   $0x803ee0
  80006f:	6a 17                	push   $0x17
  800071:	68 fc 3e 80 00       	push   $0x803efc
  800076:	e8 b3 0b 00 00       	call   800c2e <_panic>
	}
	/*=================================================*/
	int eval = 0;
  80007b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  800082:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800089:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)

	int Mega = 1024*1024;
  800090:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  800097:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	void* ptr_allocations[20] = {0};
  80009e:	8d 55 8c             	lea    -0x74(%ebp),%edx
  8000a1:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ab:	89 d7                	mov    %edx,%edi
  8000ad:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate set of blocks
	cprintf("\n%~[1] Allocate spaces of different sizes in PAGE ALLOCATOR\n");
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	68 14 3f 80 00       	push   $0x803f14
  8000b7:	e8 2f 0e 00 00       	call   800eeb <cprintf>
  8000bc:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000bf:	e8 ac 23 00 00       	call   802470 <sys_calculate_free_frames>
  8000c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000c7:	e8 ef 23 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  8000cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  8000cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000d2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	50                   	push   %eax
  8000d9:	e8 bd 1b 00 00       	call   801c9b <malloc>
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[0] != (pagealloc_start)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  8000e4:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8000e7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8000ea:	74 17                	je     800103 <_main+0xcb>
  8000ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	68 54 3f 80 00       	push   $0x803f54
  8000fb:	e8 eb 0d 00 00       	call   800eeb <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800103:	e8 b3 23 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  800108:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80010b:	74 17                	je     800124 <_main+0xec>
  80010d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 85 3f 80 00       	push   $0x803f85
  80011c:	e8 ca 0d 00 00       	call   800eeb <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800124:	e8 47 23 00 00       	call   802470 <sys_calculate_free_frames>
  800129:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80012c:	e8 8a 23 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  800131:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  800134:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800137:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	50                   	push   %eax
  80013e:	e8 58 1b 00 00       	call   801c9b <malloc>
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[1] != (pagealloc_start + 1*Mega)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  800149:	8b 45 90             	mov    -0x70(%ebp),%eax
  80014c:	89 c1                	mov    %eax,%ecx
  80014e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800151:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800154:	01 d0                	add    %edx,%eax
  800156:	39 c1                	cmp    %eax,%ecx
  800158:	74 17                	je     800171 <_main+0x139>
  80015a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	68 54 3f 80 00       	push   $0x803f54
  800169:	e8 7d 0d 00 00       	call   800eeb <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800171:	e8 45 23 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  800176:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800179:	74 17                	je     800192 <_main+0x15a>
  80017b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 85 3f 80 00       	push   $0x803f85
  80018a:	e8 5c 0d 00 00       	call   800eeb <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800192:	e8 d9 22 00 00       	call   802470 <sys_calculate_free_frames>
  800197:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80019a:	e8 1c 23 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  80019f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  8001a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001a5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001a8:	83 ec 0c             	sub    $0xc,%esp
  8001ab:	50                   	push   %eax
  8001ac:	e8 ea 1a 00 00       	call   801c9b <malloc>
  8001b1:	83 c4 10             	add    $0x10,%esp
  8001b4:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[2] != (pagealloc_start + 2*Mega)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  8001b7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8001ba:	89 c2                	mov    %eax,%edx
  8001bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001bf:	01 c0                	add    %eax,%eax
  8001c1:	89 c1                	mov    %eax,%ecx
  8001c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001c6:	01 c8                	add    %ecx,%eax
  8001c8:	39 c2                	cmp    %eax,%edx
  8001ca:	74 17                	je     8001e3 <_main+0x1ab>
  8001cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001d3:	83 ec 0c             	sub    $0xc,%esp
  8001d6:	68 54 3f 80 00       	push   $0x803f54
  8001db:	e8 0b 0d 00 00       	call   800eeb <cprintf>
  8001e0:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8001e3:	e8 d3 22 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  8001e8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001eb:	74 17                	je     800204 <_main+0x1cc>
  8001ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 85 3f 80 00       	push   $0x803f85
  8001fc:	e8 ea 0c 00 00       	call   800eeb <cprintf>
  800201:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800204:	e8 67 22 00 00       	call   802470 <sys_calculate_free_frames>
  800209:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80020c:	e8 aa 22 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  800211:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800214:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800217:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	50                   	push   %eax
  80021e:	e8 78 1a 00 00       	call   801c9b <malloc>
  800223:	83 c4 10             	add    $0x10,%esp
  800226:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[3] != (pagealloc_start + 3*Mega) ) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  800229:	8b 45 98             	mov    -0x68(%ebp),%eax
  80022c:	89 c1                	mov    %eax,%ecx
  80022e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800231:	89 c2                	mov    %eax,%edx
  800233:	01 d2                	add    %edx,%edx
  800235:	01 d0                	add    %edx,%eax
  800237:	89 c2                	mov    %eax,%edx
  800239:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80023c:	01 d0                	add    %edx,%eax
  80023e:	39 c1                	cmp    %eax,%ecx
  800240:	74 17                	je     800259 <_main+0x221>
  800242:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800249:	83 ec 0c             	sub    $0xc,%esp
  80024c:	68 54 3f 80 00       	push   $0x803f54
  800251:	e8 95 0c 00 00       	call   800eeb <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800259:	e8 5d 22 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  80025e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800261:	74 17                	je     80027a <_main+0x242>
  800263:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	68 85 3f 80 00       	push   $0x803f85
  800272:	e8 74 0c 00 00       	call   800eeb <cprintf>
  800277:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  80027a:	e8 f1 21 00 00       	call   802470 <sys_calculate_free_frames>
  80027f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800282:	e8 34 22 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  800287:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  80028a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028d:	01 c0                	add    %eax,%eax
  80028f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	50                   	push   %eax
  800296:	e8 00 1a 00 00       	call   801c9b <malloc>
  80029b:	83 c4 10             	add    $0x10,%esp
  80029e:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[4] != (pagealloc_start + 4*Mega)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  8002a1:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002a4:	89 c2                	mov    %eax,%edx
  8002a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002a9:	c1 e0 02             	shl    $0x2,%eax
  8002ac:	89 c1                	mov    %eax,%ecx
  8002ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b1:	01 c8                	add    %ecx,%eax
  8002b3:	39 c2                	cmp    %eax,%edx
  8002b5:	74 17                	je     8002ce <_main+0x296>
  8002b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	68 54 3f 80 00       	push   $0x803f54
  8002c6:	e8 20 0c 00 00       	call   800eeb <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8002ce:	e8 e8 21 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  8002d3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002d6:	74 17                	je     8002ef <_main+0x2b7>
  8002d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002df:	83 ec 0c             	sub    $0xc,%esp
  8002e2:	68 85 3f 80 00       	push   $0x803f85
  8002e7:	e8 ff 0b 00 00       	call   800eeb <cprintf>
  8002ec:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002ef:	e8 7c 21 00 00       	call   802470 <sys_calculate_free_frames>
  8002f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002f7:	e8 bf 21 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  8002fc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  8002ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800302:	01 c0                	add    %eax,%eax
  800304:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	50                   	push   %eax
  80030b:	e8 8b 19 00 00       	call   801c9b <malloc>
  800310:	83 c4 10             	add    $0x10,%esp
  800313:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[5] != (pagealloc_start + 6*Mega)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  800316:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800319:	89 c1                	mov    %eax,%ecx
  80031b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80031e:	89 d0                	mov    %edx,%eax
  800320:	01 c0                	add    %eax,%eax
  800322:	01 d0                	add    %edx,%eax
  800324:	01 c0                	add    %eax,%eax
  800326:	89 c2                	mov    %eax,%edx
  800328:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80032b:	01 d0                	add    %edx,%eax
  80032d:	39 c1                	cmp    %eax,%ecx
  80032f:	74 17                	je     800348 <_main+0x310>
  800331:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800338:	83 ec 0c             	sub    $0xc,%esp
  80033b:	68 54 3f 80 00       	push   $0x803f54
  800340:	e8 a6 0b 00 00       	call   800eeb <cprintf>
  800345:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800348:	e8 6e 21 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  80034d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800350:	74 17                	je     800369 <_main+0x331>
  800352:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	68 85 3f 80 00       	push   $0x803f85
  800361:	e8 85 0b 00 00       	call   800eeb <cprintf>
  800366:	83 c4 10             	add    $0x10,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800369:	e8 02 21 00 00       	call   802470 <sys_calculate_free_frames>
  80036e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800371:	e8 45 21 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  800376:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  800379:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80037c:	89 c2                	mov    %eax,%edx
  80037e:	01 d2                	add    %edx,%edx
  800380:	01 d0                	add    %edx,%eax
  800382:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800385:	83 ec 0c             	sub    $0xc,%esp
  800388:	50                   	push   %eax
  800389:	e8 0d 19 00 00       	call   801c9b <malloc>
  80038e:	83 c4 10             	add    $0x10,%esp
  800391:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[6] != (pagealloc_start + 8*Mega)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  800394:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800397:	89 c2                	mov    %eax,%edx
  800399:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80039c:	c1 e0 03             	shl    $0x3,%eax
  80039f:	89 c1                	mov    %eax,%ecx
  8003a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003a4:	01 c8                	add    %ecx,%eax
  8003a6:	39 c2                	cmp    %eax,%edx
  8003a8:	74 17                	je     8003c1 <_main+0x389>
  8003aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003b1:	83 ec 0c             	sub    $0xc,%esp
  8003b4:	68 54 3f 80 00       	push   $0x803f54
  8003b9:	e8 2d 0b 00 00       	call   800eeb <cprintf>
  8003be:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8003c1:	e8 f5 20 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  8003c6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003c9:	74 17                	je     8003e2 <_main+0x3aa>
  8003cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d2:	83 ec 0c             	sub    $0xc,%esp
  8003d5:	68 85 3f 80 00       	push   $0x803f85
  8003da:	e8 0c 0b 00 00       	call   800eeb <cprintf>
  8003df:	83 c4 10             	add    $0x10,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003e2:	e8 89 20 00 00       	call   802470 <sys_calculate_free_frames>
  8003e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003ea:	e8 cc 20 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  8003ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  8003f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003f5:	89 c2                	mov    %eax,%edx
  8003f7:	01 d2                	add    %edx,%edx
  8003f9:	01 d0                	add    %edx,%eax
  8003fb:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8003fe:	83 ec 0c             	sub    $0xc,%esp
  800401:	50                   	push   %eax
  800402:	e8 94 18 00 00       	call   801c9b <malloc>
  800407:	83 c4 10             	add    $0x10,%esp
  80040a:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[7] != (pagealloc_start + 11*Mega)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  80040d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800410:	89 c1                	mov    %eax,%ecx
  800412:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800415:	89 d0                	mov    %edx,%eax
  800417:	c1 e0 02             	shl    $0x2,%eax
  80041a:	01 d0                	add    %edx,%eax
  80041c:	01 c0                	add    %eax,%eax
  80041e:	01 d0                	add    %edx,%eax
  800420:	89 c2                	mov    %eax,%edx
  800422:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800425:	01 d0                	add    %edx,%eax
  800427:	39 c1                	cmp    %eax,%ecx
  800429:	74 17                	je     800442 <_main+0x40a>
  80042b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800432:	83 ec 0c             	sub    $0xc,%esp
  800435:	68 54 3f 80 00       	push   $0x803f54
  80043a:	e8 ac 0a 00 00       	call   800eeb <cprintf>
  80043f:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800442:	e8 74 20 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  800447:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80044a:	74 17                	je     800463 <_main+0x42b>
  80044c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800453:	83 ec 0c             	sub    $0xc,%esp
  800456:	68 85 3f 80 00       	push   $0x803f85
  80045b:	e8 8b 0a 00 00       	call   800eeb <cprintf>
  800460:	83 c4 10             	add    $0x10,%esp
	}

	//[2] Free some to create holes
	cprintf("\n%~[2] Free some to create holes [10%]\n");
  800463:	83 ec 0c             	sub    $0xc,%esp
  800466:	68 a4 3f 80 00       	push   $0x803fa4
  80046b:	e8 7b 0a 00 00       	call   800eeb <cprintf>
  800470:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800473:	e8 f8 1f 00 00       	call   802470 <sys_calculate_free_frames>
  800478:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80047b:	e8 3b 20 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  800480:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  800483:	8b 45 90             	mov    -0x70(%ebp),%eax
  800486:	83 ec 0c             	sub    $0xc,%esp
  800489:	50                   	push   %eax
  80048a:	e8 c2 19 00 00       	call   801e51 <free>
  80048f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  800492:	e8 24 20 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  800497:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80049a:	74 17                	je     8004b3 <_main+0x47b>
  80049c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004a3:	83 ec 0c             	sub    $0xc,%esp
  8004a6:	68 cc 3f 80 00       	push   $0x803fcc
  8004ab:	e8 3b 0a 00 00       	call   800eeb <cprintf>
  8004b0:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  8004b3:	e8 b8 1f 00 00       	call   802470 <sys_calculate_free_frames>
  8004b8:	89 c2                	mov    %eax,%edx
  8004ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004bd:	39 c2                	cmp    %eax,%edx
  8004bf:	74 17                	je     8004d8 <_main+0x4a0>
  8004c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004c8:	83 ec 0c             	sub    $0xc,%esp
  8004cb:	68 e4 3f 80 00       	push   $0x803fe4
  8004d0:	e8 16 0a 00 00       	call   800eeb <cprintf>
  8004d5:	83 c4 10             	add    $0x10,%esp

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004d8:	e8 93 1f 00 00       	call   802470 <sys_calculate_free_frames>
  8004dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004e0:	e8 d6 1f 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  8004e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  8004e8:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004eb:	83 ec 0c             	sub    $0xc,%esp
  8004ee:	50                   	push   %eax
  8004ef:	e8 5d 19 00 00       	call   801e51 <free>
  8004f4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  8004f7:	e8 bf 1f 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  8004fc:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8004ff:	74 17                	je     800518 <_main+0x4e0>
  800501:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800508:	83 ec 0c             	sub    $0xc,%esp
  80050b:	68 cc 3f 80 00       	push   $0x803fcc
  800510:	e8 d6 09 00 00       	call   800eeb <cprintf>
  800515:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  800518:	e8 53 1f 00 00       	call   802470 <sys_calculate_free_frames>
  80051d:	89 c2                	mov    %eax,%edx
  80051f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800522:	39 c2                	cmp    %eax,%edx
  800524:	74 17                	je     80053d <_main+0x505>
  800526:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80052d:	83 ec 0c             	sub    $0xc,%esp
  800530:	68 e4 3f 80 00       	push   $0x803fe4
  800535:	e8 b1 09 00 00       	call   800eeb <cprintf>
  80053a:	83 c4 10             	add    $0x10,%esp

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80053d:	e8 2e 1f 00 00       	call   802470 <sys_calculate_free_frames>
  800542:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800545:	e8 71 1f 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  80054a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  80054d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	50                   	push   %eax
  800554:	e8 f8 18 00 00       	call   801e51 <free>
  800559:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  80055c:	e8 5a 1f 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  800561:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800564:	74 17                	je     80057d <_main+0x545>
  800566:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80056d:	83 ec 0c             	sub    $0xc,%esp
  800570:	68 cc 3f 80 00       	push   $0x803fcc
  800575:	e8 71 09 00 00       	call   800eeb <cprintf>
  80057a:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  80057d:	e8 ee 1e 00 00       	call   802470 <sys_calculate_free_frames>
  800582:	89 c2                	mov    %eax,%edx
  800584:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800587:	39 c2                	cmp    %eax,%edx
  800589:	74 17                	je     8005a2 <_main+0x56a>
  80058b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800592:	83 ec 0c             	sub    $0xc,%esp
  800595:	68 e4 3f 80 00       	push   $0x803fe4
  80059a:	e8 4c 09 00 00       	call   800eeb <cprintf>
  80059f:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)
  8005a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8005a6:	74 04                	je     8005ac <_main+0x574>
	{
		eval += 10;
  8005a8:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
	}
	is_correct = 1;
  8005ac:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	//[3] Allocate again [test first fit]
	cprintf("\n%~[3] Allocate again [test first fit] [50%]\n");
  8005b3:	83 ec 0c             	sub    $0xc,%esp
  8005b6:	68 f4 3f 80 00       	push   $0x803ff4
  8005bb:	e8 2b 09 00 00       	call   800eeb <cprintf>
  8005c0:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8005c3:	e8 a8 1e 00 00       	call   802470 <sys_calculate_free_frames>
  8005c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005cb:	e8 eb 1e 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  8005d0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  8005d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005d6:	89 d0                	mov    %edx,%eax
  8005d8:	c1 e0 09             	shl    $0x9,%eax
  8005db:	29 d0                	sub    %edx,%eax
  8005dd:	83 ec 0c             	sub    $0xc,%esp
  8005e0:	50                   	push   %eax
  8005e1:	e8 b5 16 00 00       	call   801c9b <malloc>
  8005e6:	83 c4 10             	add    $0x10,%esp
  8005e9:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[8] != (pagealloc_start + 1*Mega)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  8005ec:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8005ef:	89 c1                	mov    %eax,%ecx
  8005f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005f7:	01 d0                	add    %edx,%eax
  8005f9:	39 c1                	cmp    %eax,%ecx
  8005fb:	74 17                	je     800614 <_main+0x5dc>
  8005fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800604:	83 ec 0c             	sub    $0xc,%esp
  800607:	68 54 3f 80 00       	push   $0x803f54
  80060c:	e8 da 08 00 00       	call   800eeb <cprintf>
  800611:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 128) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800614:	e8 a2 1e 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  800619:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80061c:	74 17                	je     800635 <_main+0x5fd>
  80061e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800625:	83 ec 0c             	sub    $0xc,%esp
  800628:	68 85 3f 80 00       	push   $0x803f85
  80062d:	e8 b9 08 00 00       	call   800eeb <cprintf>
  800632:	83 c4 10             	add    $0x10,%esp
		if (is_correct)
  800635:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800639:	74 04                	je     80063f <_main+0x607>
		{
			eval += 10;
  80063b:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
		is_correct = 1;
  80063f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800646:	e8 25 1e 00 00       	call   802470 <sys_calculate_free_frames>
  80064b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80064e:	e8 68 1e 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  800653:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  800656:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800659:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80065c:	83 ec 0c             	sub    $0xc,%esp
  80065f:	50                   	push   %eax
  800660:	e8 36 16 00 00       	call   801c9b <malloc>
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[9] != (pagealloc_start + 4*Mega)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  80066b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80066e:	89 c2                	mov    %eax,%edx
  800670:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800673:	c1 e0 02             	shl    $0x2,%eax
  800676:	89 c1                	mov    %eax,%ecx
  800678:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80067b:	01 c8                	add    %ecx,%eax
  80067d:	39 c2                	cmp    %eax,%edx
  80067f:	74 17                	je     800698 <_main+0x660>
  800681:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800688:	83 ec 0c             	sub    $0xc,%esp
  80068b:	68 54 3f 80 00       	push   $0x803f54
  800690:	e8 56 08 00 00       	call   800eeb <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800698:	e8 1e 1e 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x681>
  8006a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	68 85 3f 80 00       	push   $0x803f85
  8006b1:	e8 35 08 00 00       	call   800eeb <cprintf>
  8006b6:	83 c4 10             	add    $0x10,%esp
		if (is_correct)
  8006b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8006bd:	74 04                	je     8006c3 <_main+0x68b>
		{
			eval += 10;
  8006bf:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
		is_correct = 1;
  8006c3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Allocate 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8006ca:	e8 a1 1d 00 00       	call   802470 <sys_calculate_free_frames>
  8006cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006d2:	e8 e4 1d 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  8006d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  8006da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006dd:	89 d0                	mov    %edx,%eax
  8006df:	c1 e0 08             	shl    $0x8,%eax
  8006e2:	29 d0                	sub    %edx,%eax
  8006e4:	83 ec 0c             	sub    $0xc,%esp
  8006e7:	50                   	push   %eax
  8006e8:	e8 ae 15 00 00       	call   801c9b <malloc>
  8006ed:	83 c4 10             	add    $0x10,%esp
  8006f0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[10] != (pagealloc_start + 1*Mega + 512*kilo)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  8006f3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8006f6:	89 c1                	mov    %eax,%ecx
  8006f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006fe:	01 c2                	add    %eax,%edx
  800700:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800703:	c1 e0 09             	shl    $0x9,%eax
  800706:	01 d0                	add    %edx,%eax
  800708:	39 c1                	cmp    %eax,%ecx
  80070a:	74 17                	je     800723 <_main+0x6eb>
  80070c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800713:	83 ec 0c             	sub    $0xc,%esp
  800716:	68 54 3f 80 00       	push   $0x803f54
  80071b:	e8 cb 07 00 00       	call   800eeb <cprintf>
  800720:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 64) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800723:	e8 93 1d 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  800728:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80072b:	74 17                	je     800744 <_main+0x70c>
  80072d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800734:	83 ec 0c             	sub    $0xc,%esp
  800737:	68 85 3f 80 00       	push   $0x803f85
  80073c:	e8 aa 07 00 00       	call   800eeb <cprintf>
  800741:	83 c4 10             	add    $0x10,%esp
		if (is_correct)
  800744:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800748:	74 04                	je     80074e <_main+0x716>
		{
			eval += 10;
  80074a:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
		is_correct = 1;
  80074e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800755:	e8 16 1d 00 00       	call   802470 <sys_calculate_free_frames>
  80075a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80075d:	e8 59 1d 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  800762:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  800765:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800768:	01 c0                	add    %eax,%eax
  80076a:	83 ec 0c             	sub    $0xc,%esp
  80076d:	50                   	push   %eax
  80076e:	e8 28 15 00 00       	call   801c9b <malloc>
  800773:	83 c4 10             	add    $0x10,%esp
  800776:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[11] != (pagealloc_start + 8*Mega)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  800779:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80077c:	89 c2                	mov    %eax,%edx
  80077e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800781:	c1 e0 03             	shl    $0x3,%eax
  800784:	89 c1                	mov    %eax,%ecx
  800786:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800789:	01 c8                	add    %ecx,%eax
  80078b:	39 c2                	cmp    %eax,%edx
  80078d:	74 17                	je     8007a6 <_main+0x76e>
  80078f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800796:	83 ec 0c             	sub    $0xc,%esp
  800799:	68 54 3f 80 00       	push   $0x803f54
  80079e:	e8 48 07 00 00       	call   800eeb <cprintf>
  8007a3:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8007a6:	e8 10 1d 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  8007ab:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8007ae:	74 17                	je     8007c7 <_main+0x78f>
  8007b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007b7:	83 ec 0c             	sub    $0xc,%esp
  8007ba:	68 85 3f 80 00       	push   $0x803f85
  8007bf:	e8 27 07 00 00       	call   800eeb <cprintf>
  8007c4:	83 c4 10             	add    $0x10,%esp
		if (is_correct)
  8007c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8007cb:	74 04                	je     8007d1 <_main+0x799>
		{
			eval += 10;
  8007cd:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
		is_correct = 1;
  8007d1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8007d8:	e8 93 1c 00 00       	call   802470 <sys_calculate_free_frames>
  8007dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007e0:	e8 d6 1c 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  8007e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[12] = malloc(4*Mega - kilo);
  8007e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007eb:	c1 e0 02             	shl    $0x2,%eax
  8007ee:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8007f1:	83 ec 0c             	sub    $0xc,%esp
  8007f4:	50                   	push   %eax
  8007f5:	e8 a1 14 00 00       	call   801c9b <malloc>
  8007fa:	83 c4 10             	add    $0x10,%esp
  8007fd:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[12] != (pagealloc_start + 14*Mega) ) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  800800:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800803:	89 c1                	mov    %eax,%ecx
  800805:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800808:	89 d0                	mov    %edx,%eax
  80080a:	01 c0                	add    %eax,%eax
  80080c:	01 d0                	add    %edx,%eax
  80080e:	01 c0                	add    %eax,%eax
  800810:	01 d0                	add    %edx,%eax
  800812:	01 c0                	add    %eax,%eax
  800814:	89 c2                	mov    %eax,%edx
  800816:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800819:	01 d0                	add    %edx,%eax
  80081b:	39 c1                	cmp    %eax,%ecx
  80081d:	74 17                	je     800836 <_main+0x7fe>
  80081f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800826:	83 ec 0c             	sub    $0xc,%esp
  800829:	68 54 3f 80 00       	push   $0x803f54
  80082e:	e8 b8 06 00 00       	call   800eeb <cprintf>
  800833:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800836:	e8 80 1c 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  80083b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80083e:	74 17                	je     800857 <_main+0x81f>
  800840:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800847:	83 ec 0c             	sub    $0xc,%esp
  80084a:	68 85 3f 80 00       	push   $0x803f85
  80084f:	e8 97 06 00 00       	call   800eeb <cprintf>
  800854:	83 c4 10             	add    $0x10,%esp
		if (is_correct)
  800857:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80085b:	74 04                	je     800861 <_main+0x829>
		{
			eval += 10;
  80085d:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
		is_correct = 1;
  800861:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}

	is_correct = 1;
  800868:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	//[4] Free contiguous allocations
	cprintf("\n%~[4] Free contiguous allocations [10%]\n");
  80086f:	83 ec 0c             	sub    $0xc,%esp
  800872:	68 24 40 80 00       	push   $0x804024
  800877:	e8 6f 06 00 00       	call   800eeb <cprintf>
  80087c:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  80087f:	e8 ec 1b 00 00       	call   802470 <sys_calculate_free_frames>
  800884:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800887:	e8 2f 1c 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  80088c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[2]);
  80088f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800892:	83 ec 0c             	sub    $0xc,%esp
  800895:	50                   	push   %eax
  800896:	e8 b6 15 00 00       	call   801e51 <free>
  80089b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  80089e:	e8 18 1c 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  8008a3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8008a6:	74 17                	je     8008bf <_main+0x887>
  8008a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008af:	83 ec 0c             	sub    $0xc,%esp
  8008b2:	68 cc 3f 80 00       	push   $0x803fcc
  8008b7:	e8 2f 06 00 00       	call   800eeb <cprintf>
  8008bc:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  8008bf:	e8 ac 1b 00 00       	call   802470 <sys_calculate_free_frames>
  8008c4:	89 c2                	mov    %eax,%edx
  8008c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c9:	39 c2                	cmp    %eax,%edx
  8008cb:	74 17                	je     8008e4 <_main+0x8ac>
  8008cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008d4:	83 ec 0c             	sub    $0xc,%esp
  8008d7:	68 e4 3f 80 00       	push   $0x803fe4
  8008dc:	e8 0a 06 00 00       	call   800eeb <cprintf>
  8008e1:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  8008e4:	e8 87 1b 00 00       	call   802470 <sys_calculate_free_frames>
  8008e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008ec:	e8 ca 1b 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  8008f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[9]);
  8008f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8008f7:	83 ec 0c             	sub    $0xc,%esp
  8008fa:	50                   	push   %eax
  8008fb:	e8 51 15 00 00       	call   801e51 <free>
  800900:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  800903:	e8 b3 1b 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  800908:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80090b:	74 17                	je     800924 <_main+0x8ec>
  80090d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800914:	83 ec 0c             	sub    $0xc,%esp
  800917:	68 cc 3f 80 00       	push   $0x803fcc
  80091c:	e8 ca 05 00 00       	call   800eeb <cprintf>
  800921:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  800924:	e8 47 1b 00 00       	call   802470 <sys_calculate_free_frames>
  800929:	89 c2                	mov    %eax,%edx
  80092b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092e:	39 c2                	cmp    %eax,%edx
  800930:	74 17                	je     800949 <_main+0x911>
  800932:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800939:	83 ec 0c             	sub    $0xc,%esp
  80093c:	68 e4 3f 80 00       	push   $0x803fe4
  800941:	e8 a5 05 00 00       	call   800eeb <cprintf>
  800946:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole [Total = 4 MB + 256 KB]
		freeFrames = sys_calculate_free_frames() ;
  800949:	e8 22 1b 00 00       	call   802470 <sys_calculate_free_frames>
  80094e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800951:	e8 65 1b 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  800956:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800959:	8b 45 98             	mov    -0x68(%ebp),%eax
  80095c:	83 ec 0c             	sub    $0xc,%esp
  80095f:	50                   	push   %eax
  800960:	e8 ec 14 00 00       	call   801e51 <free>
  800965:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  800968:	e8 4e 1b 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  80096d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800970:	74 17                	je     800989 <_main+0x951>
  800972:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800979:	83 ec 0c             	sub    $0xc,%esp
  80097c:	68 cc 3f 80 00       	push   $0x803fcc
  800981:	e8 65 05 00 00       	call   800eeb <cprintf>
  800986:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  800989:	e8 e2 1a 00 00       	call   802470 <sys_calculate_free_frames>
  80098e:	89 c2                	mov    %eax,%edx
  800990:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800993:	39 c2                	cmp    %eax,%edx
  800995:	74 17                	je     8009ae <_main+0x976>
  800997:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80099e:	83 ec 0c             	sub    $0xc,%esp
  8009a1:	68 e4 3f 80 00       	push   $0x803fe4
  8009a6:	e8 40 05 00 00       	call   800eeb <cprintf>
  8009ab:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)
  8009ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009b2:	74 04                	je     8009b8 <_main+0x980>
	{
		eval += 10;
  8009b4:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
	}
	is_correct = 1;
  8009b8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	//[5] Allocate again [test first fit]
	cprintf("\n%~[5] Allocate again [test first fit in coalesced area] [15%]\n");
  8009bf:	83 ec 0c             	sub    $0xc,%esp
  8009c2:	68 50 40 80 00       	push   $0x804050
  8009c7:	e8 1f 05 00 00       	call   800eeb <cprintf>
  8009cc:	83 c4 10             	add    $0x10,%esp
	{
		//[FIRST FIT Case]
		//Allocate 4 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  8009cf:	e8 9c 1a 00 00       	call   802470 <sys_calculate_free_frames>
  8009d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009d7:	e8 df 1a 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  8009dc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[13] = malloc(4*Mega + 256*kilo - kilo);
  8009df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009e2:	c1 e0 06             	shl    $0x6,%eax
  8009e5:	89 c2                	mov    %eax,%edx
  8009e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009ea:	01 d0                	add    %edx,%eax
  8009ec:	c1 e0 02             	shl    $0x2,%eax
  8009ef:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8009f2:	83 ec 0c             	sub    $0xc,%esp
  8009f5:	50                   	push   %eax
  8009f6:	e8 a0 12 00 00       	call   801c9b <malloc>
  8009fb:	83 c4 10             	add    $0x10,%esp
  8009fe:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[13] != (pagealloc_start + 1*Mega + 768*kilo)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  800a01:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a04:	89 c1                	mov    %eax,%ecx
  800a06:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a0c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  800a0f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a12:	89 d0                	mov    %edx,%eax
  800a14:	01 c0                	add    %eax,%eax
  800a16:	01 d0                	add    %edx,%eax
  800a18:	c1 e0 08             	shl    $0x8,%eax
  800a1b:	01 d8                	add    %ebx,%eax
  800a1d:	39 c1                	cmp    %eax,%ecx
  800a1f:	74 17                	je     800a38 <_main+0xa00>
  800a21:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a28:	83 ec 0c             	sub    $0xc,%esp
  800a2b:	68 54 3f 80 00       	push   $0x803f54
  800a30:	e8 b6 04 00 00       	call   800eeb <cprintf>
  800a35:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800a38:	e8 7e 1a 00 00       	call   8024bb <sys_pf_calculate_allocated_pages>
  800a3d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800a40:	74 17                	je     800a59 <_main+0xa21>
  800a42:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a49:	83 ec 0c             	sub    $0xc,%esp
  800a4c:	68 85 3f 80 00       	push   $0x803f85
  800a51:	e8 95 04 00 00       	call   800eeb <cprintf>
  800a56:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)
  800a59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a5d:	74 04                	je     800a63 <_main+0xa2b>
	{
		eval += 15;
  800a5f:	83 45 f4 0f          	addl   $0xf,-0xc(%ebp)
	}
	is_correct = 1;
  800a63:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	//[6] Attempt to allocate large segment with no suitable fragment to fit on
	cprintf("\n%~[6] Attempt to allocate large segment with no suitable fragment to fit on [15%]\n");
  800a6a:	83 ec 0c             	sub    $0xc,%esp
  800a6d:	68 90 40 80 00       	push   $0x804090
  800a72:	e8 74 04 00 00       	call   800eeb <cprintf>
  800a77:	83 c4 10             	add    $0x10,%esp
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[9] = malloc((USER_HEAP_MAX - pagealloc_start - 18*Mega + 1));
  800a7a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a7d:	89 d0                	mov    %edx,%eax
  800a7f:	c1 e0 03             	shl    $0x3,%eax
  800a82:	01 d0                	add    %edx,%eax
  800a84:	01 c0                	add    %eax,%eax
  800a86:	f7 d8                	neg    %eax
  800a88:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800a8b:	2d ff ff ff 5f       	sub    $0x5fffffff,%eax
  800a90:	83 ec 0c             	sub    $0xc,%esp
  800a93:	50                   	push   %eax
  800a94:	e8 02 12 00 00       	call   801c9b <malloc>
  800a99:	83 c4 10             	add    $0x10,%esp
  800a9c:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if (ptr_allocations[9] != NULL) { is_correct = 0; cprintf("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL\n");}
  800a9f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800aa2:	85 c0                	test   %eax,%eax
  800aa4:	74 17                	je     800abd <_main+0xa85>
  800aa6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800aad:	83 ec 0c             	sub    $0xc,%esp
  800ab0:	68 e4 40 80 00       	push   $0x8040e4
  800ab5:	e8 31 04 00 00       	call   800eeb <cprintf>
  800aba:	83 c4 10             	add    $0x10,%esp

	}
	if (is_correct)
  800abd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ac1:	74 04                	je     800ac7 <_main+0xa8f>
	{
		eval += 15;
  800ac3:	83 45 f4 0f          	addl   $0xf,-0xc(%ebp)
	}
	is_correct = 1;
  800ac7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf("%~\ntest FIRST FIT (1) [PAGE ALLOCATOR] completed. Eval = %d\n\n", eval);
  800ace:	83 ec 08             	sub    $0x8,%esp
  800ad1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad4:	68 48 41 80 00       	push   $0x804148
  800ad9:	e8 0d 04 00 00       	call   800eeb <cprintf>
  800ade:	83 c4 10             	add    $0x10,%esp
	//cprintf("[AUTO_GR@DING_PARTIAL]%d\n", eval);

	return;
  800ae1:	90                   	nop
#endif
}
  800ae2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ae5:	5b                   	pop    %ebx
  800ae6:	5f                   	pop    %edi
  800ae7:	5d                   	pop    %ebp
  800ae8:	c3                   	ret    

00800ae9 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800aef:	e8 45 1b 00 00       	call   802639 <sys_getenvindex>
  800af4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800af7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800afa:	89 d0                	mov    %edx,%eax
  800afc:	c1 e0 02             	shl    $0x2,%eax
  800aff:	01 d0                	add    %edx,%eax
  800b01:	c1 e0 03             	shl    $0x3,%eax
  800b04:	01 d0                	add    %edx,%eax
  800b06:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800b0d:	01 d0                	add    %edx,%eax
  800b0f:	c1 e0 02             	shl    $0x2,%eax
  800b12:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b17:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b1c:	a1 20 50 80 00       	mov    0x805020,%eax
  800b21:	8a 40 20             	mov    0x20(%eax),%al
  800b24:	84 c0                	test   %al,%al
  800b26:	74 0d                	je     800b35 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800b28:	a1 20 50 80 00       	mov    0x805020,%eax
  800b2d:	83 c0 20             	add    $0x20,%eax
  800b30:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b35:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b39:	7e 0a                	jle    800b45 <libmain+0x5c>
		binaryname = argv[0];
  800b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3e:	8b 00                	mov    (%eax),%eax
  800b40:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800b45:	83 ec 08             	sub    $0x8,%esp
  800b48:	ff 75 0c             	pushl  0xc(%ebp)
  800b4b:	ff 75 08             	pushl  0x8(%ebp)
  800b4e:	e8 e5 f4 ff ff       	call   800038 <_main>
  800b53:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800b56:	a1 00 50 80 00       	mov    0x805000,%eax
  800b5b:	85 c0                	test   %eax,%eax
  800b5d:	0f 84 9f 00 00 00    	je     800c02 <libmain+0x119>
	{
		sys_lock_cons();
  800b63:	e8 55 18 00 00       	call   8023bd <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800b68:	83 ec 0c             	sub    $0xc,%esp
  800b6b:	68 a0 41 80 00       	push   $0x8041a0
  800b70:	e8 76 03 00 00       	call   800eeb <cprintf>
  800b75:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800b78:	a1 20 50 80 00       	mov    0x805020,%eax
  800b7d:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800b83:	a1 20 50 80 00       	mov    0x805020,%eax
  800b88:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800b8e:	83 ec 04             	sub    $0x4,%esp
  800b91:	52                   	push   %edx
  800b92:	50                   	push   %eax
  800b93:	68 c8 41 80 00       	push   $0x8041c8
  800b98:	e8 4e 03 00 00       	call   800eeb <cprintf>
  800b9d:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800ba0:	a1 20 50 80 00       	mov    0x805020,%eax
  800ba5:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800bab:	a1 20 50 80 00       	mov    0x805020,%eax
  800bb0:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800bb6:	a1 20 50 80 00       	mov    0x805020,%eax
  800bbb:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800bc1:	51                   	push   %ecx
  800bc2:	52                   	push   %edx
  800bc3:	50                   	push   %eax
  800bc4:	68 f0 41 80 00       	push   $0x8041f0
  800bc9:	e8 1d 03 00 00       	call   800eeb <cprintf>
  800bce:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800bd1:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd6:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800bdc:	83 ec 08             	sub    $0x8,%esp
  800bdf:	50                   	push   %eax
  800be0:	68 48 42 80 00       	push   $0x804248
  800be5:	e8 01 03 00 00       	call   800eeb <cprintf>
  800bea:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800bed:	83 ec 0c             	sub    $0xc,%esp
  800bf0:	68 a0 41 80 00       	push   $0x8041a0
  800bf5:	e8 f1 02 00 00       	call   800eeb <cprintf>
  800bfa:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800bfd:	e8 d5 17 00 00       	call   8023d7 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800c02:	e8 19 00 00 00       	call   800c20 <exit>
}
  800c07:	90                   	nop
  800c08:	c9                   	leave  
  800c09:	c3                   	ret    

00800c0a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c10:	83 ec 0c             	sub    $0xc,%esp
  800c13:	6a 00                	push   $0x0
  800c15:	e8 eb 19 00 00       	call   802605 <sys_destroy_env>
  800c1a:	83 c4 10             	add    $0x10,%esp
}
  800c1d:	90                   	nop
  800c1e:	c9                   	leave  
  800c1f:	c3                   	ret    

00800c20 <exit>:

void
exit(void)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800c26:	e8 40 1a 00 00       	call   80266b <sys_exit_env>
}
  800c2b:	90                   	nop
  800c2c:	c9                   	leave  
  800c2d:	c3                   	ret    

00800c2e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c34:	8d 45 10             	lea    0x10(%ebp),%eax
  800c37:	83 c0 04             	add    $0x4,%eax
  800c3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800c3d:	a1 60 50 98 00       	mov    0x985060,%eax
  800c42:	85 c0                	test   %eax,%eax
  800c44:	74 16                	je     800c5c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c46:	a1 60 50 98 00       	mov    0x985060,%eax
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	50                   	push   %eax
  800c4f:	68 5c 42 80 00       	push   $0x80425c
  800c54:	e8 92 02 00 00       	call   800eeb <cprintf>
  800c59:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800c5c:	a1 04 50 80 00       	mov    0x805004,%eax
  800c61:	ff 75 0c             	pushl  0xc(%ebp)
  800c64:	ff 75 08             	pushl  0x8(%ebp)
  800c67:	50                   	push   %eax
  800c68:	68 61 42 80 00       	push   $0x804261
  800c6d:	e8 79 02 00 00       	call   800eeb <cprintf>
  800c72:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800c75:	8b 45 10             	mov    0x10(%ebp),%eax
  800c78:	83 ec 08             	sub    $0x8,%esp
  800c7b:	ff 75 f4             	pushl  -0xc(%ebp)
  800c7e:	50                   	push   %eax
  800c7f:	e8 fc 01 00 00       	call   800e80 <vcprintf>
  800c84:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800c87:	83 ec 08             	sub    $0x8,%esp
  800c8a:	6a 00                	push   $0x0
  800c8c:	68 7d 42 80 00       	push   $0x80427d
  800c91:	e8 ea 01 00 00       	call   800e80 <vcprintf>
  800c96:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800c99:	e8 82 ff ff ff       	call   800c20 <exit>

	// should not return here
	while (1) ;
  800c9e:	eb fe                	jmp    800c9e <_panic+0x70>

00800ca0 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800ca6:	a1 20 50 80 00       	mov    0x805020,%eax
  800cab:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb4:	39 c2                	cmp    %eax,%edx
  800cb6:	74 14                	je     800ccc <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800cb8:	83 ec 04             	sub    $0x4,%esp
  800cbb:	68 80 42 80 00       	push   $0x804280
  800cc0:	6a 26                	push   $0x26
  800cc2:	68 cc 42 80 00       	push   $0x8042cc
  800cc7:	e8 62 ff ff ff       	call   800c2e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800ccc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800cd3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cda:	e9 c5 00 00 00       	jmp    800da4 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800cdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ce2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	01 d0                	add    %edx,%eax
  800cee:	8b 00                	mov    (%eax),%eax
  800cf0:	85 c0                	test   %eax,%eax
  800cf2:	75 08                	jne    800cfc <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800cf4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800cf7:	e9 a5 00 00 00       	jmp    800da1 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800cfc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d03:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d0a:	eb 69                	jmp    800d75 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d0c:	a1 20 50 80 00       	mov    0x805020,%eax
  800d11:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800d17:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d1a:	89 d0                	mov    %edx,%eax
  800d1c:	01 c0                	add    %eax,%eax
  800d1e:	01 d0                	add    %edx,%eax
  800d20:	c1 e0 03             	shl    $0x3,%eax
  800d23:	01 c8                	add    %ecx,%eax
  800d25:	8a 40 04             	mov    0x4(%eax),%al
  800d28:	84 c0                	test   %al,%al
  800d2a:	75 46                	jne    800d72 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d2c:	a1 20 50 80 00       	mov    0x805020,%eax
  800d31:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800d37:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d3a:	89 d0                	mov    %edx,%eax
  800d3c:	01 c0                	add    %eax,%eax
  800d3e:	01 d0                	add    %edx,%eax
  800d40:	c1 e0 03             	shl    $0x3,%eax
  800d43:	01 c8                	add    %ecx,%eax
  800d45:	8b 00                	mov    (%eax),%eax
  800d47:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800d4a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800d4d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d52:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d57:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	01 c8                	add    %ecx,%eax
  800d63:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d65:	39 c2                	cmp    %eax,%edx
  800d67:	75 09                	jne    800d72 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800d69:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800d70:	eb 15                	jmp    800d87 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d72:	ff 45 e8             	incl   -0x18(%ebp)
  800d75:	a1 20 50 80 00       	mov    0x805020,%eax
  800d7a:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800d80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800d83:	39 c2                	cmp    %eax,%edx
  800d85:	77 85                	ja     800d0c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800d87:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800d8b:	75 14                	jne    800da1 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800d8d:	83 ec 04             	sub    $0x4,%esp
  800d90:	68 d8 42 80 00       	push   $0x8042d8
  800d95:	6a 3a                	push   $0x3a
  800d97:	68 cc 42 80 00       	push   $0x8042cc
  800d9c:	e8 8d fe ff ff       	call   800c2e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800da1:	ff 45 f0             	incl   -0x10(%ebp)
  800da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800da7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800daa:	0f 8c 2f ff ff ff    	jl     800cdf <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800db0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800db7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800dbe:	eb 26                	jmp    800de6 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800dc0:	a1 20 50 80 00       	mov    0x805020,%eax
  800dc5:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800dcb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800dce:	89 d0                	mov    %edx,%eax
  800dd0:	01 c0                	add    %eax,%eax
  800dd2:	01 d0                	add    %edx,%eax
  800dd4:	c1 e0 03             	shl    $0x3,%eax
  800dd7:	01 c8                	add    %ecx,%eax
  800dd9:	8a 40 04             	mov    0x4(%eax),%al
  800ddc:	3c 01                	cmp    $0x1,%al
  800dde:	75 03                	jne    800de3 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800de0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800de3:	ff 45 e0             	incl   -0x20(%ebp)
  800de6:	a1 20 50 80 00       	mov    0x805020,%eax
  800deb:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800df1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800df4:	39 c2                	cmp    %eax,%edx
  800df6:	77 c8                	ja     800dc0 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dfb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800dfe:	74 14                	je     800e14 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800e00:	83 ec 04             	sub    $0x4,%esp
  800e03:	68 2c 43 80 00       	push   $0x80432c
  800e08:	6a 44                	push   $0x44
  800e0a:	68 cc 42 80 00       	push   $0x8042cc
  800e0f:	e8 1a fe ff ff       	call   800c2e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e14:	90                   	nop
  800e15:	c9                   	leave  
  800e16:	c3                   	ret    

00800e17 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e20:	8b 00                	mov    (%eax),%eax
  800e22:	8d 48 01             	lea    0x1(%eax),%ecx
  800e25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e28:	89 0a                	mov    %ecx,(%edx)
  800e2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2d:	88 d1                	mov    %dl,%cl
  800e2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e32:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e39:	8b 00                	mov    (%eax),%eax
  800e3b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e40:	75 2c                	jne    800e6e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e42:	a0 44 50 98 00       	mov    0x985044,%al
  800e47:	0f b6 c0             	movzbl %al,%eax
  800e4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e4d:	8b 12                	mov    (%edx),%edx
  800e4f:	89 d1                	mov    %edx,%ecx
  800e51:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e54:	83 c2 08             	add    $0x8,%edx
  800e57:	83 ec 04             	sub    $0x4,%esp
  800e5a:	50                   	push   %eax
  800e5b:	51                   	push   %ecx
  800e5c:	52                   	push   %edx
  800e5d:	e8 19 15 00 00       	call   80237b <sys_cputs>
  800e62:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800e65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e71:	8b 40 04             	mov    0x4(%eax),%eax
  800e74:	8d 50 01             	lea    0x1(%eax),%edx
  800e77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7a:	89 50 04             	mov    %edx,0x4(%eax)
}
  800e7d:	90                   	nop
  800e7e:	c9                   	leave  
  800e7f:	c3                   	ret    

00800e80 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800e89:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800e90:	00 00 00 
	b.cnt = 0;
  800e93:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800e9a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800e9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ea0:	ff 75 08             	pushl  0x8(%ebp)
  800ea3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ea9:	50                   	push   %eax
  800eaa:	68 17 0e 80 00       	push   $0x800e17
  800eaf:	e8 11 02 00 00       	call   8010c5 <vprintfmt>
  800eb4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800eb7:	a0 44 50 98 00       	mov    0x985044,%al
  800ebc:	0f b6 c0             	movzbl %al,%eax
  800ebf:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ec5:	83 ec 04             	sub    $0x4,%esp
  800ec8:	50                   	push   %eax
  800ec9:	52                   	push   %edx
  800eca:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ed0:	83 c0 08             	add    $0x8,%eax
  800ed3:	50                   	push   %eax
  800ed4:	e8 a2 14 00 00       	call   80237b <sys_cputs>
  800ed9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800edc:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  800ee3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ee9:	c9                   	leave  
  800eea:	c3                   	ret    

00800eeb <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800eeb:	55                   	push   %ebp
  800eec:	89 e5                	mov    %esp,%ebp
  800eee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ef1:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  800ef8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800efb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	83 ec 08             	sub    $0x8,%esp
  800f04:	ff 75 f4             	pushl  -0xc(%ebp)
  800f07:	50                   	push   %eax
  800f08:	e8 73 ff ff ff       	call   800e80 <vcprintf>
  800f0d:	83 c4 10             	add    $0x10,%esp
  800f10:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800f1e:	e8 9a 14 00 00       	call   8023bd <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800f23:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f26:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	83 ec 08             	sub    $0x8,%esp
  800f2f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f32:	50                   	push   %eax
  800f33:	e8 48 ff ff ff       	call   800e80 <vcprintf>
  800f38:	83 c4 10             	add    $0x10,%esp
  800f3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800f3e:	e8 94 14 00 00       	call   8023d7 <sys_unlock_cons>
	return cnt;
  800f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f46:	c9                   	leave  
  800f47:	c3                   	ret    

00800f48 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	53                   	push   %ebx
  800f4c:	83 ec 14             	sub    $0x14,%esp
  800f4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f55:	8b 45 14             	mov    0x14(%ebp),%eax
  800f58:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800f5b:	8b 45 18             	mov    0x18(%ebp),%eax
  800f5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f63:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f66:	77 55                	ja     800fbd <printnum+0x75>
  800f68:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f6b:	72 05                	jb     800f72 <printnum+0x2a>
  800f6d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f70:	77 4b                	ja     800fbd <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800f72:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800f75:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800f78:	8b 45 18             	mov    0x18(%ebp),%eax
  800f7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f80:	52                   	push   %edx
  800f81:	50                   	push   %eax
  800f82:	ff 75 f4             	pushl  -0xc(%ebp)
  800f85:	ff 75 f0             	pushl  -0x10(%ebp)
  800f88:	e8 ef 2c 00 00       	call   803c7c <__udivdi3>
  800f8d:	83 c4 10             	add    $0x10,%esp
  800f90:	83 ec 04             	sub    $0x4,%esp
  800f93:	ff 75 20             	pushl  0x20(%ebp)
  800f96:	53                   	push   %ebx
  800f97:	ff 75 18             	pushl  0x18(%ebp)
  800f9a:	52                   	push   %edx
  800f9b:	50                   	push   %eax
  800f9c:	ff 75 0c             	pushl  0xc(%ebp)
  800f9f:	ff 75 08             	pushl  0x8(%ebp)
  800fa2:	e8 a1 ff ff ff       	call   800f48 <printnum>
  800fa7:	83 c4 20             	add    $0x20,%esp
  800faa:	eb 1a                	jmp    800fc6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800fac:	83 ec 08             	sub    $0x8,%esp
  800faf:	ff 75 0c             	pushl  0xc(%ebp)
  800fb2:	ff 75 20             	pushl  0x20(%ebp)
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	ff d0                	call   *%eax
  800fba:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800fbd:	ff 4d 1c             	decl   0x1c(%ebp)
  800fc0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800fc4:	7f e6                	jg     800fac <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800fc6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800fc9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd4:	53                   	push   %ebx
  800fd5:	51                   	push   %ecx
  800fd6:	52                   	push   %edx
  800fd7:	50                   	push   %eax
  800fd8:	e8 af 2d 00 00       	call   803d8c <__umoddi3>
  800fdd:	83 c4 10             	add    $0x10,%esp
  800fe0:	05 94 45 80 00       	add    $0x804594,%eax
  800fe5:	8a 00                	mov    (%eax),%al
  800fe7:	0f be c0             	movsbl %al,%eax
  800fea:	83 ec 08             	sub    $0x8,%esp
  800fed:	ff 75 0c             	pushl  0xc(%ebp)
  800ff0:	50                   	push   %eax
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	ff d0                	call   *%eax
  800ff6:	83 c4 10             	add    $0x10,%esp
}
  800ff9:	90                   	nop
  800ffa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ffd:	c9                   	leave  
  800ffe:	c3                   	ret    

00800fff <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801002:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801006:	7e 1c                	jle    801024 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
  80100b:	8b 00                	mov    (%eax),%eax
  80100d:	8d 50 08             	lea    0x8(%eax),%edx
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	89 10                	mov    %edx,(%eax)
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8b 00                	mov    (%eax),%eax
  80101a:	83 e8 08             	sub    $0x8,%eax
  80101d:	8b 50 04             	mov    0x4(%eax),%edx
  801020:	8b 00                	mov    (%eax),%eax
  801022:	eb 40                	jmp    801064 <getuint+0x65>
	else if (lflag)
  801024:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801028:	74 1e                	je     801048 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	8b 00                	mov    (%eax),%eax
  80102f:	8d 50 04             	lea    0x4(%eax),%edx
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	89 10                	mov    %edx,(%eax)
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8b 00                	mov    (%eax),%eax
  80103c:	83 e8 04             	sub    $0x4,%eax
  80103f:	8b 00                	mov    (%eax),%eax
  801041:	ba 00 00 00 00       	mov    $0x0,%edx
  801046:	eb 1c                	jmp    801064 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8b 00                	mov    (%eax),%eax
  80104d:	8d 50 04             	lea    0x4(%eax),%edx
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	89 10                	mov    %edx,(%eax)
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	8b 00                	mov    (%eax),%eax
  80105a:	83 e8 04             	sub    $0x4,%eax
  80105d:	8b 00                	mov    (%eax),%eax
  80105f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801064:	5d                   	pop    %ebp
  801065:	c3                   	ret    

00801066 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801069:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80106d:	7e 1c                	jle    80108b <getint+0x25>
		return va_arg(*ap, long long);
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
  801072:	8b 00                	mov    (%eax),%eax
  801074:	8d 50 08             	lea    0x8(%eax),%edx
  801077:	8b 45 08             	mov    0x8(%ebp),%eax
  80107a:	89 10                	mov    %edx,(%eax)
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8b 00                	mov    (%eax),%eax
  801081:	83 e8 08             	sub    $0x8,%eax
  801084:	8b 50 04             	mov    0x4(%eax),%edx
  801087:	8b 00                	mov    (%eax),%eax
  801089:	eb 38                	jmp    8010c3 <getint+0x5d>
	else if (lflag)
  80108b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80108f:	74 1a                	je     8010ab <getint+0x45>
		return va_arg(*ap, long);
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	8b 00                	mov    (%eax),%eax
  801096:	8d 50 04             	lea    0x4(%eax),%edx
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	89 10                	mov    %edx,(%eax)
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8b 00                	mov    (%eax),%eax
  8010a3:	83 e8 04             	sub    $0x4,%eax
  8010a6:	8b 00                	mov    (%eax),%eax
  8010a8:	99                   	cltd   
  8010a9:	eb 18                	jmp    8010c3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8b 00                	mov    (%eax),%eax
  8010b0:	8d 50 04             	lea    0x4(%eax),%edx
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	89 10                	mov    %edx,(%eax)
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8b 00                	mov    (%eax),%eax
  8010bd:	83 e8 04             	sub    $0x4,%eax
  8010c0:	8b 00                	mov    (%eax),%eax
  8010c2:	99                   	cltd   
}
  8010c3:	5d                   	pop    %ebp
  8010c4:	c3                   	ret    

008010c5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	56                   	push   %esi
  8010c9:	53                   	push   %ebx
  8010ca:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010cd:	eb 17                	jmp    8010e6 <vprintfmt+0x21>
			if (ch == '\0')
  8010cf:	85 db                	test   %ebx,%ebx
  8010d1:	0f 84 c1 03 00 00    	je     801498 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8010d7:	83 ec 08             	sub    $0x8,%esp
  8010da:	ff 75 0c             	pushl  0xc(%ebp)
  8010dd:	53                   	push   %ebx
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	ff d0                	call   *%eax
  8010e3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e9:	8d 50 01             	lea    0x1(%eax),%edx
  8010ec:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	0f b6 d8             	movzbl %al,%ebx
  8010f4:	83 fb 25             	cmp    $0x25,%ebx
  8010f7:	75 d6                	jne    8010cf <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8010f9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8010fd:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801104:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80110b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801112:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801119:	8b 45 10             	mov    0x10(%ebp),%eax
  80111c:	8d 50 01             	lea    0x1(%eax),%edx
  80111f:	89 55 10             	mov    %edx,0x10(%ebp)
  801122:	8a 00                	mov    (%eax),%al
  801124:	0f b6 d8             	movzbl %al,%ebx
  801127:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80112a:	83 f8 5b             	cmp    $0x5b,%eax
  80112d:	0f 87 3d 03 00 00    	ja     801470 <vprintfmt+0x3ab>
  801133:	8b 04 85 b8 45 80 00 	mov    0x8045b8(,%eax,4),%eax
  80113a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80113c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801140:	eb d7                	jmp    801119 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801142:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801146:	eb d1                	jmp    801119 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801148:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80114f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801152:	89 d0                	mov    %edx,%eax
  801154:	c1 e0 02             	shl    $0x2,%eax
  801157:	01 d0                	add    %edx,%eax
  801159:	01 c0                	add    %eax,%eax
  80115b:	01 d8                	add    %ebx,%eax
  80115d:	83 e8 30             	sub    $0x30,%eax
  801160:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801163:	8b 45 10             	mov    0x10(%ebp),%eax
  801166:	8a 00                	mov    (%eax),%al
  801168:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80116b:	83 fb 2f             	cmp    $0x2f,%ebx
  80116e:	7e 3e                	jle    8011ae <vprintfmt+0xe9>
  801170:	83 fb 39             	cmp    $0x39,%ebx
  801173:	7f 39                	jg     8011ae <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801175:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801178:	eb d5                	jmp    80114f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80117a:	8b 45 14             	mov    0x14(%ebp),%eax
  80117d:	83 c0 04             	add    $0x4,%eax
  801180:	89 45 14             	mov    %eax,0x14(%ebp)
  801183:	8b 45 14             	mov    0x14(%ebp),%eax
  801186:	83 e8 04             	sub    $0x4,%eax
  801189:	8b 00                	mov    (%eax),%eax
  80118b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80118e:	eb 1f                	jmp    8011af <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801190:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801194:	79 83                	jns    801119 <vprintfmt+0x54>
				width = 0;
  801196:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80119d:	e9 77 ff ff ff       	jmp    801119 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8011a2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8011a9:	e9 6b ff ff ff       	jmp    801119 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8011ae:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8011af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011b3:	0f 89 60 ff ff ff    	jns    801119 <vprintfmt+0x54>
				width = precision, precision = -1;
  8011b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011bf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8011c6:	e9 4e ff ff ff       	jmp    801119 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8011cb:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8011ce:	e9 46 ff ff ff       	jmp    801119 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8011d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d6:	83 c0 04             	add    $0x4,%eax
  8011d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8011dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8011df:	83 e8 04             	sub    $0x4,%eax
  8011e2:	8b 00                	mov    (%eax),%eax
  8011e4:	83 ec 08             	sub    $0x8,%esp
  8011e7:	ff 75 0c             	pushl  0xc(%ebp)
  8011ea:	50                   	push   %eax
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	ff d0                	call   *%eax
  8011f0:	83 c4 10             	add    $0x10,%esp
			break;
  8011f3:	e9 9b 02 00 00       	jmp    801493 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8011f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011fb:	83 c0 04             	add    $0x4,%eax
  8011fe:	89 45 14             	mov    %eax,0x14(%ebp)
  801201:	8b 45 14             	mov    0x14(%ebp),%eax
  801204:	83 e8 04             	sub    $0x4,%eax
  801207:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801209:	85 db                	test   %ebx,%ebx
  80120b:	79 02                	jns    80120f <vprintfmt+0x14a>
				err = -err;
  80120d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80120f:	83 fb 64             	cmp    $0x64,%ebx
  801212:	7f 0b                	jg     80121f <vprintfmt+0x15a>
  801214:	8b 34 9d 00 44 80 00 	mov    0x804400(,%ebx,4),%esi
  80121b:	85 f6                	test   %esi,%esi
  80121d:	75 19                	jne    801238 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80121f:	53                   	push   %ebx
  801220:	68 a5 45 80 00       	push   $0x8045a5
  801225:	ff 75 0c             	pushl  0xc(%ebp)
  801228:	ff 75 08             	pushl  0x8(%ebp)
  80122b:	e8 70 02 00 00       	call   8014a0 <printfmt>
  801230:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801233:	e9 5b 02 00 00       	jmp    801493 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801238:	56                   	push   %esi
  801239:	68 ae 45 80 00       	push   $0x8045ae
  80123e:	ff 75 0c             	pushl  0xc(%ebp)
  801241:	ff 75 08             	pushl  0x8(%ebp)
  801244:	e8 57 02 00 00       	call   8014a0 <printfmt>
  801249:	83 c4 10             	add    $0x10,%esp
			break;
  80124c:	e9 42 02 00 00       	jmp    801493 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801251:	8b 45 14             	mov    0x14(%ebp),%eax
  801254:	83 c0 04             	add    $0x4,%eax
  801257:	89 45 14             	mov    %eax,0x14(%ebp)
  80125a:	8b 45 14             	mov    0x14(%ebp),%eax
  80125d:	83 e8 04             	sub    $0x4,%eax
  801260:	8b 30                	mov    (%eax),%esi
  801262:	85 f6                	test   %esi,%esi
  801264:	75 05                	jne    80126b <vprintfmt+0x1a6>
				p = "(null)";
  801266:	be b1 45 80 00       	mov    $0x8045b1,%esi
			if (width > 0 && padc != '-')
  80126b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80126f:	7e 6d                	jle    8012de <vprintfmt+0x219>
  801271:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801275:	74 67                	je     8012de <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801277:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80127a:	83 ec 08             	sub    $0x8,%esp
  80127d:	50                   	push   %eax
  80127e:	56                   	push   %esi
  80127f:	e8 1e 03 00 00       	call   8015a2 <strnlen>
  801284:	83 c4 10             	add    $0x10,%esp
  801287:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80128a:	eb 16                	jmp    8012a2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80128c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801290:	83 ec 08             	sub    $0x8,%esp
  801293:	ff 75 0c             	pushl  0xc(%ebp)
  801296:	50                   	push   %eax
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	ff d0                	call   *%eax
  80129c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80129f:	ff 4d e4             	decl   -0x1c(%ebp)
  8012a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012a6:	7f e4                	jg     80128c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012a8:	eb 34                	jmp    8012de <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8012aa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012ae:	74 1c                	je     8012cc <vprintfmt+0x207>
  8012b0:	83 fb 1f             	cmp    $0x1f,%ebx
  8012b3:	7e 05                	jle    8012ba <vprintfmt+0x1f5>
  8012b5:	83 fb 7e             	cmp    $0x7e,%ebx
  8012b8:	7e 12                	jle    8012cc <vprintfmt+0x207>
					putch('?', putdat);
  8012ba:	83 ec 08             	sub    $0x8,%esp
  8012bd:	ff 75 0c             	pushl  0xc(%ebp)
  8012c0:	6a 3f                	push   $0x3f
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	ff d0                	call   *%eax
  8012c7:	83 c4 10             	add    $0x10,%esp
  8012ca:	eb 0f                	jmp    8012db <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8012cc:	83 ec 08             	sub    $0x8,%esp
  8012cf:	ff 75 0c             	pushl  0xc(%ebp)
  8012d2:	53                   	push   %ebx
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	ff d0                	call   *%eax
  8012d8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012db:	ff 4d e4             	decl   -0x1c(%ebp)
  8012de:	89 f0                	mov    %esi,%eax
  8012e0:	8d 70 01             	lea    0x1(%eax),%esi
  8012e3:	8a 00                	mov    (%eax),%al
  8012e5:	0f be d8             	movsbl %al,%ebx
  8012e8:	85 db                	test   %ebx,%ebx
  8012ea:	74 24                	je     801310 <vprintfmt+0x24b>
  8012ec:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012f0:	78 b8                	js     8012aa <vprintfmt+0x1e5>
  8012f2:	ff 4d e0             	decl   -0x20(%ebp)
  8012f5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012f9:	79 af                	jns    8012aa <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8012fb:	eb 13                	jmp    801310 <vprintfmt+0x24b>
				putch(' ', putdat);
  8012fd:	83 ec 08             	sub    $0x8,%esp
  801300:	ff 75 0c             	pushl  0xc(%ebp)
  801303:	6a 20                	push   $0x20
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	ff d0                	call   *%eax
  80130a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80130d:	ff 4d e4             	decl   -0x1c(%ebp)
  801310:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801314:	7f e7                	jg     8012fd <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801316:	e9 78 01 00 00       	jmp    801493 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80131b:	83 ec 08             	sub    $0x8,%esp
  80131e:	ff 75 e8             	pushl  -0x18(%ebp)
  801321:	8d 45 14             	lea    0x14(%ebp),%eax
  801324:	50                   	push   %eax
  801325:	e8 3c fd ff ff       	call   801066 <getint>
  80132a:	83 c4 10             	add    $0x10,%esp
  80132d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801330:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801333:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801336:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801339:	85 d2                	test   %edx,%edx
  80133b:	79 23                	jns    801360 <vprintfmt+0x29b>
				putch('-', putdat);
  80133d:	83 ec 08             	sub    $0x8,%esp
  801340:	ff 75 0c             	pushl  0xc(%ebp)
  801343:	6a 2d                	push   $0x2d
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
  801348:	ff d0                	call   *%eax
  80134a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80134d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801350:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801353:	f7 d8                	neg    %eax
  801355:	83 d2 00             	adc    $0x0,%edx
  801358:	f7 da                	neg    %edx
  80135a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80135d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801360:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801367:	e9 bc 00 00 00       	jmp    801428 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80136c:	83 ec 08             	sub    $0x8,%esp
  80136f:	ff 75 e8             	pushl  -0x18(%ebp)
  801372:	8d 45 14             	lea    0x14(%ebp),%eax
  801375:	50                   	push   %eax
  801376:	e8 84 fc ff ff       	call   800fff <getuint>
  80137b:	83 c4 10             	add    $0x10,%esp
  80137e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801381:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801384:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80138b:	e9 98 00 00 00       	jmp    801428 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801390:	83 ec 08             	sub    $0x8,%esp
  801393:	ff 75 0c             	pushl  0xc(%ebp)
  801396:	6a 58                	push   $0x58
  801398:	8b 45 08             	mov    0x8(%ebp),%eax
  80139b:	ff d0                	call   *%eax
  80139d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013a0:	83 ec 08             	sub    $0x8,%esp
  8013a3:	ff 75 0c             	pushl  0xc(%ebp)
  8013a6:	6a 58                	push   $0x58
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	ff d0                	call   *%eax
  8013ad:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013b0:	83 ec 08             	sub    $0x8,%esp
  8013b3:	ff 75 0c             	pushl  0xc(%ebp)
  8013b6:	6a 58                	push   $0x58
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	ff d0                	call   *%eax
  8013bd:	83 c4 10             	add    $0x10,%esp
			break;
  8013c0:	e9 ce 00 00 00       	jmp    801493 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8013c5:	83 ec 08             	sub    $0x8,%esp
  8013c8:	ff 75 0c             	pushl  0xc(%ebp)
  8013cb:	6a 30                	push   $0x30
  8013cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d0:	ff d0                	call   *%eax
  8013d2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8013d5:	83 ec 08             	sub    $0x8,%esp
  8013d8:	ff 75 0c             	pushl  0xc(%ebp)
  8013db:	6a 78                	push   $0x78
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	ff d0                	call   *%eax
  8013e2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8013e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e8:	83 c0 04             	add    $0x4,%eax
  8013eb:	89 45 14             	mov    %eax,0x14(%ebp)
  8013ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f1:	83 e8 04             	sub    $0x4,%eax
  8013f4:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8013f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801400:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801407:	eb 1f                	jmp    801428 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801409:	83 ec 08             	sub    $0x8,%esp
  80140c:	ff 75 e8             	pushl  -0x18(%ebp)
  80140f:	8d 45 14             	lea    0x14(%ebp),%eax
  801412:	50                   	push   %eax
  801413:	e8 e7 fb ff ff       	call   800fff <getuint>
  801418:	83 c4 10             	add    $0x10,%esp
  80141b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80141e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801421:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801428:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80142c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80142f:	83 ec 04             	sub    $0x4,%esp
  801432:	52                   	push   %edx
  801433:	ff 75 e4             	pushl  -0x1c(%ebp)
  801436:	50                   	push   %eax
  801437:	ff 75 f4             	pushl  -0xc(%ebp)
  80143a:	ff 75 f0             	pushl  -0x10(%ebp)
  80143d:	ff 75 0c             	pushl  0xc(%ebp)
  801440:	ff 75 08             	pushl  0x8(%ebp)
  801443:	e8 00 fb ff ff       	call   800f48 <printnum>
  801448:	83 c4 20             	add    $0x20,%esp
			break;
  80144b:	eb 46                	jmp    801493 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80144d:	83 ec 08             	sub    $0x8,%esp
  801450:	ff 75 0c             	pushl  0xc(%ebp)
  801453:	53                   	push   %ebx
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	ff d0                	call   *%eax
  801459:	83 c4 10             	add    $0x10,%esp
			break;
  80145c:	eb 35                	jmp    801493 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80145e:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  801465:	eb 2c                	jmp    801493 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801467:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  80146e:	eb 23                	jmp    801493 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801470:	83 ec 08             	sub    $0x8,%esp
  801473:	ff 75 0c             	pushl  0xc(%ebp)
  801476:	6a 25                	push   $0x25
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	ff d0                	call   *%eax
  80147d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801480:	ff 4d 10             	decl   0x10(%ebp)
  801483:	eb 03                	jmp    801488 <vprintfmt+0x3c3>
  801485:	ff 4d 10             	decl   0x10(%ebp)
  801488:	8b 45 10             	mov    0x10(%ebp),%eax
  80148b:	48                   	dec    %eax
  80148c:	8a 00                	mov    (%eax),%al
  80148e:	3c 25                	cmp    $0x25,%al
  801490:	75 f3                	jne    801485 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801492:	90                   	nop
		}
	}
  801493:	e9 35 fc ff ff       	jmp    8010cd <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801498:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801499:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80149c:	5b                   	pop    %ebx
  80149d:	5e                   	pop    %esi
  80149e:	5d                   	pop    %ebp
  80149f:	c3                   	ret    

008014a0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
  8014a3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014a6:	8d 45 10             	lea    0x10(%ebp),%eax
  8014a9:	83 c0 04             	add    $0x4,%eax
  8014ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8014af:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8014b5:	50                   	push   %eax
  8014b6:	ff 75 0c             	pushl  0xc(%ebp)
  8014b9:	ff 75 08             	pushl  0x8(%ebp)
  8014bc:	e8 04 fc ff ff       	call   8010c5 <vprintfmt>
  8014c1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8014c4:	90                   	nop
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8014ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cd:	8b 40 08             	mov    0x8(%eax),%eax
  8014d0:	8d 50 01             	lea    0x1(%eax),%edx
  8014d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8014d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014dc:	8b 10                	mov    (%eax),%edx
  8014de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e1:	8b 40 04             	mov    0x4(%eax),%eax
  8014e4:	39 c2                	cmp    %eax,%edx
  8014e6:	73 12                	jae    8014fa <sprintputch+0x33>
		*b->buf++ = ch;
  8014e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014eb:	8b 00                	mov    (%eax),%eax
  8014ed:	8d 48 01             	lea    0x1(%eax),%ecx
  8014f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f3:	89 0a                	mov    %ecx,(%edx)
  8014f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f8:	88 10                	mov    %dl,(%eax)
}
  8014fa:	90                   	nop
  8014fb:	5d                   	pop    %ebp
  8014fc:	c3                   	ret    

008014fd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8014fd:	55                   	push   %ebp
  8014fe:	89 e5                	mov    %esp,%ebp
  801500:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801503:	8b 45 08             	mov    0x8(%ebp),%eax
  801506:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801509:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	01 d0                	add    %edx,%eax
  801514:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801517:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80151e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801522:	74 06                	je     80152a <vsnprintf+0x2d>
  801524:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801528:	7f 07                	jg     801531 <vsnprintf+0x34>
		return -E_INVAL;
  80152a:	b8 03 00 00 00       	mov    $0x3,%eax
  80152f:	eb 20                	jmp    801551 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801531:	ff 75 14             	pushl  0x14(%ebp)
  801534:	ff 75 10             	pushl  0x10(%ebp)
  801537:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80153a:	50                   	push   %eax
  80153b:	68 c7 14 80 00       	push   $0x8014c7
  801540:	e8 80 fb ff ff       	call   8010c5 <vprintfmt>
  801545:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801548:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80154b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80154e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801551:	c9                   	leave  
  801552:	c3                   	ret    

00801553 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801559:	8d 45 10             	lea    0x10(%ebp),%eax
  80155c:	83 c0 04             	add    $0x4,%eax
  80155f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801562:	8b 45 10             	mov    0x10(%ebp),%eax
  801565:	ff 75 f4             	pushl  -0xc(%ebp)
  801568:	50                   	push   %eax
  801569:	ff 75 0c             	pushl  0xc(%ebp)
  80156c:	ff 75 08             	pushl  0x8(%ebp)
  80156f:	e8 89 ff ff ff       	call   8014fd <vsnprintf>
  801574:	83 c4 10             	add    $0x10,%esp
  801577:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80157a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    

0080157f <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801585:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80158c:	eb 06                	jmp    801594 <strlen+0x15>
		n++;
  80158e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801591:	ff 45 08             	incl   0x8(%ebp)
  801594:	8b 45 08             	mov    0x8(%ebp),%eax
  801597:	8a 00                	mov    (%eax),%al
  801599:	84 c0                	test   %al,%al
  80159b:	75 f1                	jne    80158e <strlen+0xf>
		n++;
	return n;
  80159d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015af:	eb 09                	jmp    8015ba <strnlen+0x18>
		n++;
  8015b1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015b4:	ff 45 08             	incl   0x8(%ebp)
  8015b7:	ff 4d 0c             	decl   0xc(%ebp)
  8015ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015be:	74 09                	je     8015c9 <strnlen+0x27>
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c3:	8a 00                	mov    (%eax),%al
  8015c5:	84 c0                	test   %al,%al
  8015c7:	75 e8                	jne    8015b1 <strnlen+0xf>
		n++;
	return n;
  8015c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8015da:	90                   	nop
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	8d 50 01             	lea    0x1(%eax),%edx
  8015e1:	89 55 08             	mov    %edx,0x8(%ebp)
  8015e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015ea:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015ed:	8a 12                	mov    (%edx),%dl
  8015ef:	88 10                	mov    %dl,(%eax)
  8015f1:	8a 00                	mov    (%eax),%al
  8015f3:	84 c0                	test   %al,%al
  8015f5:	75 e4                	jne    8015db <strcpy+0xd>
		/* do nothing */;
	return ret;
  8015f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801602:	8b 45 08             	mov    0x8(%ebp),%eax
  801605:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801608:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80160f:	eb 1f                	jmp    801630 <strncpy+0x34>
		*dst++ = *src;
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	8d 50 01             	lea    0x1(%eax),%edx
  801617:	89 55 08             	mov    %edx,0x8(%ebp)
  80161a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161d:	8a 12                	mov    (%edx),%dl
  80161f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801621:	8b 45 0c             	mov    0xc(%ebp),%eax
  801624:	8a 00                	mov    (%eax),%al
  801626:	84 c0                	test   %al,%al
  801628:	74 03                	je     80162d <strncpy+0x31>
			src++;
  80162a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80162d:	ff 45 fc             	incl   -0x4(%ebp)
  801630:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801633:	3b 45 10             	cmp    0x10(%ebp),%eax
  801636:	72 d9                	jb     801611 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801638:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80163b:	c9                   	leave  
  80163c:	c3                   	ret    

0080163d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801649:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80164d:	74 30                	je     80167f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80164f:	eb 16                	jmp    801667 <strlcpy+0x2a>
			*dst++ = *src++;
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	8d 50 01             	lea    0x1(%eax),%edx
  801657:	89 55 08             	mov    %edx,0x8(%ebp)
  80165a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801660:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801663:	8a 12                	mov    (%edx),%dl
  801665:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801667:	ff 4d 10             	decl   0x10(%ebp)
  80166a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80166e:	74 09                	je     801679 <strlcpy+0x3c>
  801670:	8b 45 0c             	mov    0xc(%ebp),%eax
  801673:	8a 00                	mov    (%eax),%al
  801675:	84 c0                	test   %al,%al
  801677:	75 d8                	jne    801651 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80167f:	8b 55 08             	mov    0x8(%ebp),%edx
  801682:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801685:	29 c2                	sub    %eax,%edx
  801687:	89 d0                	mov    %edx,%eax
}
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80168e:	eb 06                	jmp    801696 <strcmp+0xb>
		p++, q++;
  801690:	ff 45 08             	incl   0x8(%ebp)
  801693:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	8a 00                	mov    (%eax),%al
  80169b:	84 c0                	test   %al,%al
  80169d:	74 0e                	je     8016ad <strcmp+0x22>
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8a 10                	mov    (%eax),%dl
  8016a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a7:	8a 00                	mov    (%eax),%al
  8016a9:	38 c2                	cmp    %al,%dl
  8016ab:	74 e3                	je     801690 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	8a 00                	mov    (%eax),%al
  8016b2:	0f b6 d0             	movzbl %al,%edx
  8016b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b8:	8a 00                	mov    (%eax),%al
  8016ba:	0f b6 c0             	movzbl %al,%eax
  8016bd:	29 c2                	sub    %eax,%edx
  8016bf:	89 d0                	mov    %edx,%eax
}
  8016c1:	5d                   	pop    %ebp
  8016c2:	c3                   	ret    

008016c3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016c6:	eb 09                	jmp    8016d1 <strncmp+0xe>
		n--, p++, q++;
  8016c8:	ff 4d 10             	decl   0x10(%ebp)
  8016cb:	ff 45 08             	incl   0x8(%ebp)
  8016ce:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8016d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016d5:	74 17                	je     8016ee <strncmp+0x2b>
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	8a 00                	mov    (%eax),%al
  8016dc:	84 c0                	test   %al,%al
  8016de:	74 0e                	je     8016ee <strncmp+0x2b>
  8016e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e3:	8a 10                	mov    (%eax),%dl
  8016e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e8:	8a 00                	mov    (%eax),%al
  8016ea:	38 c2                	cmp    %al,%dl
  8016ec:	74 da                	je     8016c8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8016ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016f2:	75 07                	jne    8016fb <strncmp+0x38>
		return 0;
  8016f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f9:	eb 14                	jmp    80170f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	8a 00                	mov    (%eax),%al
  801700:	0f b6 d0             	movzbl %al,%edx
  801703:	8b 45 0c             	mov    0xc(%ebp),%eax
  801706:	8a 00                	mov    (%eax),%al
  801708:	0f b6 c0             	movzbl %al,%eax
  80170b:	29 c2                	sub    %eax,%edx
  80170d:	89 d0                	mov    %edx,%eax
}
  80170f:	5d                   	pop    %ebp
  801710:	c3                   	ret    

00801711 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 04             	sub    $0x4,%esp
  801717:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80171d:	eb 12                	jmp    801731 <strchr+0x20>
		if (*s == c)
  80171f:	8b 45 08             	mov    0x8(%ebp),%eax
  801722:	8a 00                	mov    (%eax),%al
  801724:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801727:	75 05                	jne    80172e <strchr+0x1d>
			return (char *) s;
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
  80172c:	eb 11                	jmp    80173f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80172e:	ff 45 08             	incl   0x8(%ebp)
  801731:	8b 45 08             	mov    0x8(%ebp),%eax
  801734:	8a 00                	mov    (%eax),%al
  801736:	84 c0                	test   %al,%al
  801738:	75 e5                	jne    80171f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80173a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
  801744:	83 ec 04             	sub    $0x4,%esp
  801747:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80174d:	eb 0d                	jmp    80175c <strfind+0x1b>
		if (*s == c)
  80174f:	8b 45 08             	mov    0x8(%ebp),%eax
  801752:	8a 00                	mov    (%eax),%al
  801754:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801757:	74 0e                	je     801767 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801759:	ff 45 08             	incl   0x8(%ebp)
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	8a 00                	mov    (%eax),%al
  801761:	84 c0                	test   %al,%al
  801763:	75 ea                	jne    80174f <strfind+0xe>
  801765:	eb 01                	jmp    801768 <strfind+0x27>
		if (*s == c)
			break;
  801767:	90                   	nop
	return (char *) s;
  801768:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801773:	8b 45 08             	mov    0x8(%ebp),%eax
  801776:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801779:	8b 45 10             	mov    0x10(%ebp),%eax
  80177c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80177f:	eb 0e                	jmp    80178f <memset+0x22>
		*p++ = c;
  801781:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801784:	8d 50 01             	lea    0x1(%eax),%edx
  801787:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80178a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80178f:	ff 4d f8             	decl   -0x8(%ebp)
  801792:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801796:	79 e9                	jns    801781 <memset+0x14>
		*p++ = c;

	return v;
  801798:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8017af:	eb 16                	jmp    8017c7 <memcpy+0x2a>
		*d++ = *s++;
  8017b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b4:	8d 50 01             	lea    0x1(%eax),%edx
  8017b7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017bd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017c0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8017c3:	8a 12                	mov    (%edx),%dl
  8017c5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8017c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017cd:	89 55 10             	mov    %edx,0x10(%ebp)
  8017d0:	85 c0                	test   %eax,%eax
  8017d2:	75 dd                	jne    8017b1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
  8017dc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8017eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017ee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017f1:	73 50                	jae    801843 <memmove+0x6a>
  8017f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f9:	01 d0                	add    %edx,%eax
  8017fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017fe:	76 43                	jbe    801843 <memmove+0x6a>
		s += n;
  801800:	8b 45 10             	mov    0x10(%ebp),%eax
  801803:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801806:	8b 45 10             	mov    0x10(%ebp),%eax
  801809:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80180c:	eb 10                	jmp    80181e <memmove+0x45>
			*--d = *--s;
  80180e:	ff 4d f8             	decl   -0x8(%ebp)
  801811:	ff 4d fc             	decl   -0x4(%ebp)
  801814:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801817:	8a 10                	mov    (%eax),%dl
  801819:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80181c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80181e:	8b 45 10             	mov    0x10(%ebp),%eax
  801821:	8d 50 ff             	lea    -0x1(%eax),%edx
  801824:	89 55 10             	mov    %edx,0x10(%ebp)
  801827:	85 c0                	test   %eax,%eax
  801829:	75 e3                	jne    80180e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80182b:	eb 23                	jmp    801850 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80182d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801830:	8d 50 01             	lea    0x1(%eax),%edx
  801833:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801836:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801839:	8d 4a 01             	lea    0x1(%edx),%ecx
  80183c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80183f:	8a 12                	mov    (%edx),%dl
  801841:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801843:	8b 45 10             	mov    0x10(%ebp),%eax
  801846:	8d 50 ff             	lea    -0x1(%eax),%edx
  801849:	89 55 10             	mov    %edx,0x10(%ebp)
  80184c:	85 c0                	test   %eax,%eax
  80184e:	75 dd                	jne    80182d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80185b:	8b 45 08             	mov    0x8(%ebp),%eax
  80185e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801861:	8b 45 0c             	mov    0xc(%ebp),%eax
  801864:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801867:	eb 2a                	jmp    801893 <memcmp+0x3e>
		if (*s1 != *s2)
  801869:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80186c:	8a 10                	mov    (%eax),%dl
  80186e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801871:	8a 00                	mov    (%eax),%al
  801873:	38 c2                	cmp    %al,%dl
  801875:	74 16                	je     80188d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801877:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80187a:	8a 00                	mov    (%eax),%al
  80187c:	0f b6 d0             	movzbl %al,%edx
  80187f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801882:	8a 00                	mov    (%eax),%al
  801884:	0f b6 c0             	movzbl %al,%eax
  801887:	29 c2                	sub    %eax,%edx
  801889:	89 d0                	mov    %edx,%eax
  80188b:	eb 18                	jmp    8018a5 <memcmp+0x50>
		s1++, s2++;
  80188d:	ff 45 fc             	incl   -0x4(%ebp)
  801890:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801893:	8b 45 10             	mov    0x10(%ebp),%eax
  801896:	8d 50 ff             	lea    -0x1(%eax),%edx
  801899:	89 55 10             	mov    %edx,0x10(%ebp)
  80189c:	85 c0                	test   %eax,%eax
  80189e:	75 c9                	jne    801869 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
  8018aa:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8018b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b3:	01 d0                	add    %edx,%eax
  8018b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018b8:	eb 15                	jmp    8018cf <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bd:	8a 00                	mov    (%eax),%al
  8018bf:	0f b6 d0             	movzbl %al,%edx
  8018c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c5:	0f b6 c0             	movzbl %al,%eax
  8018c8:	39 c2                	cmp    %eax,%edx
  8018ca:	74 0d                	je     8018d9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018cc:	ff 45 08             	incl   0x8(%ebp)
  8018cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018d5:	72 e3                	jb     8018ba <memfind+0x13>
  8018d7:	eb 01                	jmp    8018da <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018d9:	90                   	nop
	return (void *) s;
  8018da:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
  8018e2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8018e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8018ec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018f3:	eb 03                	jmp    8018f8 <strtol+0x19>
		s++;
  8018f5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fb:	8a 00                	mov    (%eax),%al
  8018fd:	3c 20                	cmp    $0x20,%al
  8018ff:	74 f4                	je     8018f5 <strtol+0x16>
  801901:	8b 45 08             	mov    0x8(%ebp),%eax
  801904:	8a 00                	mov    (%eax),%al
  801906:	3c 09                	cmp    $0x9,%al
  801908:	74 eb                	je     8018f5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	8a 00                	mov    (%eax),%al
  80190f:	3c 2b                	cmp    $0x2b,%al
  801911:	75 05                	jne    801918 <strtol+0x39>
		s++;
  801913:	ff 45 08             	incl   0x8(%ebp)
  801916:	eb 13                	jmp    80192b <strtol+0x4c>
	else if (*s == '-')
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	8a 00                	mov    (%eax),%al
  80191d:	3c 2d                	cmp    $0x2d,%al
  80191f:	75 0a                	jne    80192b <strtol+0x4c>
		s++, neg = 1;
  801921:	ff 45 08             	incl   0x8(%ebp)
  801924:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80192b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80192f:	74 06                	je     801937 <strtol+0x58>
  801931:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801935:	75 20                	jne    801957 <strtol+0x78>
  801937:	8b 45 08             	mov    0x8(%ebp),%eax
  80193a:	8a 00                	mov    (%eax),%al
  80193c:	3c 30                	cmp    $0x30,%al
  80193e:	75 17                	jne    801957 <strtol+0x78>
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	40                   	inc    %eax
  801944:	8a 00                	mov    (%eax),%al
  801946:	3c 78                	cmp    $0x78,%al
  801948:	75 0d                	jne    801957 <strtol+0x78>
		s += 2, base = 16;
  80194a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80194e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801955:	eb 28                	jmp    80197f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801957:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80195b:	75 15                	jne    801972 <strtol+0x93>
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	8a 00                	mov    (%eax),%al
  801962:	3c 30                	cmp    $0x30,%al
  801964:	75 0c                	jne    801972 <strtol+0x93>
		s++, base = 8;
  801966:	ff 45 08             	incl   0x8(%ebp)
  801969:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801970:	eb 0d                	jmp    80197f <strtol+0xa0>
	else if (base == 0)
  801972:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801976:	75 07                	jne    80197f <strtol+0xa0>
		base = 10;
  801978:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80197f:	8b 45 08             	mov    0x8(%ebp),%eax
  801982:	8a 00                	mov    (%eax),%al
  801984:	3c 2f                	cmp    $0x2f,%al
  801986:	7e 19                	jle    8019a1 <strtol+0xc2>
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	8a 00                	mov    (%eax),%al
  80198d:	3c 39                	cmp    $0x39,%al
  80198f:	7f 10                	jg     8019a1 <strtol+0xc2>
			dig = *s - '0';
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	8a 00                	mov    (%eax),%al
  801996:	0f be c0             	movsbl %al,%eax
  801999:	83 e8 30             	sub    $0x30,%eax
  80199c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80199f:	eb 42                	jmp    8019e3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	8a 00                	mov    (%eax),%al
  8019a6:	3c 60                	cmp    $0x60,%al
  8019a8:	7e 19                	jle    8019c3 <strtol+0xe4>
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	8a 00                	mov    (%eax),%al
  8019af:	3c 7a                	cmp    $0x7a,%al
  8019b1:	7f 10                	jg     8019c3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b6:	8a 00                	mov    (%eax),%al
  8019b8:	0f be c0             	movsbl %al,%eax
  8019bb:	83 e8 57             	sub    $0x57,%eax
  8019be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019c1:	eb 20                	jmp    8019e3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	8a 00                	mov    (%eax),%al
  8019c8:	3c 40                	cmp    $0x40,%al
  8019ca:	7e 39                	jle    801a05 <strtol+0x126>
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	8a 00                	mov    (%eax),%al
  8019d1:	3c 5a                	cmp    $0x5a,%al
  8019d3:	7f 30                	jg     801a05 <strtol+0x126>
			dig = *s - 'A' + 10;
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	8a 00                	mov    (%eax),%al
  8019da:	0f be c0             	movsbl %al,%eax
  8019dd:	83 e8 37             	sub    $0x37,%eax
  8019e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8019e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019e9:	7d 19                	jge    801a04 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8019eb:	ff 45 08             	incl   0x8(%ebp)
  8019ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019f1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019f5:	89 c2                	mov    %eax,%edx
  8019f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019fa:	01 d0                	add    %edx,%eax
  8019fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8019ff:	e9 7b ff ff ff       	jmp    80197f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a04:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a09:	74 08                	je     801a13 <strtol+0x134>
		*endptr = (char *) s;
  801a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0e:	8b 55 08             	mov    0x8(%ebp),%edx
  801a11:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a13:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a17:	74 07                	je     801a20 <strtol+0x141>
  801a19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a1c:	f7 d8                	neg    %eax
  801a1e:	eb 03                	jmp    801a23 <strtol+0x144>
  801a20:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <ltostr>:

void
ltostr(long value, char *str)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a2b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a32:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a3d:	79 13                	jns    801a52 <ltostr+0x2d>
	{
		neg = 1;
  801a3f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a49:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a4c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a4f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a52:	8b 45 08             	mov    0x8(%ebp),%eax
  801a55:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a5a:	99                   	cltd   
  801a5b:	f7 f9                	idiv   %ecx
  801a5d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a63:	8d 50 01             	lea    0x1(%eax),%edx
  801a66:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a69:	89 c2                	mov    %eax,%edx
  801a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6e:	01 d0                	add    %edx,%eax
  801a70:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a73:	83 c2 30             	add    $0x30,%edx
  801a76:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801a78:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a7b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a80:	f7 e9                	imul   %ecx
  801a82:	c1 fa 02             	sar    $0x2,%edx
  801a85:	89 c8                	mov    %ecx,%eax
  801a87:	c1 f8 1f             	sar    $0x1f,%eax
  801a8a:	29 c2                	sub    %eax,%edx
  801a8c:	89 d0                	mov    %edx,%eax
  801a8e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801a91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a95:	75 bb                	jne    801a52 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801a97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801a9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aa1:	48                   	dec    %eax
  801aa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801aa5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801aa9:	74 3d                	je     801ae8 <ltostr+0xc3>
		start = 1 ;
  801aab:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801ab2:	eb 34                	jmp    801ae8 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801ab4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ab7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aba:	01 d0                	add    %edx,%eax
  801abc:	8a 00                	mov    (%eax),%al
  801abe:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801ac1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac7:	01 c2                	add    %eax,%edx
  801ac9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801acc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801acf:	01 c8                	add    %ecx,%eax
  801ad1:	8a 00                	mov    (%eax),%al
  801ad3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801ad5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801adb:	01 c2                	add    %eax,%edx
  801add:	8a 45 eb             	mov    -0x15(%ebp),%al
  801ae0:	88 02                	mov    %al,(%edx)
		start++ ;
  801ae2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801ae5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aeb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801aee:	7c c4                	jl     801ab4 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801af0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801af3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af6:	01 d0                	add    %edx,%eax
  801af8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801afb:	90                   	nop
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
  801b01:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b04:	ff 75 08             	pushl  0x8(%ebp)
  801b07:	e8 73 fa ff ff       	call   80157f <strlen>
  801b0c:	83 c4 04             	add    $0x4,%esp
  801b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b12:	ff 75 0c             	pushl  0xc(%ebp)
  801b15:	e8 65 fa ff ff       	call   80157f <strlen>
  801b1a:	83 c4 04             	add    $0x4,%esp
  801b1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b2e:	eb 17                	jmp    801b47 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b30:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b33:	8b 45 10             	mov    0x10(%ebp),%eax
  801b36:	01 c2                	add    %eax,%edx
  801b38:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	01 c8                	add    %ecx,%eax
  801b40:	8a 00                	mov    (%eax),%al
  801b42:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b44:	ff 45 fc             	incl   -0x4(%ebp)
  801b47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b4a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b4d:	7c e1                	jl     801b30 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801b4f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801b56:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801b5d:	eb 1f                	jmp    801b7e <strcconcat+0x80>
		final[s++] = str2[i] ;
  801b5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b62:	8d 50 01             	lea    0x1(%eax),%edx
  801b65:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b68:	89 c2                	mov    %eax,%edx
  801b6a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6d:	01 c2                	add    %eax,%edx
  801b6f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801b72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b75:	01 c8                	add    %ecx,%eax
  801b77:	8a 00                	mov    (%eax),%al
  801b79:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801b7b:	ff 45 f8             	incl   -0x8(%ebp)
  801b7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b81:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b84:	7c d9                	jl     801b5f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801b86:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b89:	8b 45 10             	mov    0x10(%ebp),%eax
  801b8c:	01 d0                	add    %edx,%eax
  801b8e:	c6 00 00             	movb   $0x0,(%eax)
}
  801b91:	90                   	nop
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801b97:	8b 45 14             	mov    0x14(%ebp),%eax
  801b9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801ba0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba3:	8b 00                	mov    (%eax),%eax
  801ba5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bac:	8b 45 10             	mov    0x10(%ebp),%eax
  801baf:	01 d0                	add    %edx,%eax
  801bb1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bb7:	eb 0c                	jmp    801bc5 <strsplit+0x31>
			*string++ = 0;
  801bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbc:	8d 50 01             	lea    0x1(%eax),%edx
  801bbf:	89 55 08             	mov    %edx,0x8(%ebp)
  801bc2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc8:	8a 00                	mov    (%eax),%al
  801bca:	84 c0                	test   %al,%al
  801bcc:	74 18                	je     801be6 <strsplit+0x52>
  801bce:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd1:	8a 00                	mov    (%eax),%al
  801bd3:	0f be c0             	movsbl %al,%eax
  801bd6:	50                   	push   %eax
  801bd7:	ff 75 0c             	pushl  0xc(%ebp)
  801bda:	e8 32 fb ff ff       	call   801711 <strchr>
  801bdf:	83 c4 08             	add    $0x8,%esp
  801be2:	85 c0                	test   %eax,%eax
  801be4:	75 d3                	jne    801bb9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	8a 00                	mov    (%eax),%al
  801beb:	84 c0                	test   %al,%al
  801bed:	74 5a                	je     801c49 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801bef:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf2:	8b 00                	mov    (%eax),%eax
  801bf4:	83 f8 0f             	cmp    $0xf,%eax
  801bf7:	75 07                	jne    801c00 <strsplit+0x6c>
		{
			return 0;
  801bf9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bfe:	eb 66                	jmp    801c66 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c00:	8b 45 14             	mov    0x14(%ebp),%eax
  801c03:	8b 00                	mov    (%eax),%eax
  801c05:	8d 48 01             	lea    0x1(%eax),%ecx
  801c08:	8b 55 14             	mov    0x14(%ebp),%edx
  801c0b:	89 0a                	mov    %ecx,(%edx)
  801c0d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c14:	8b 45 10             	mov    0x10(%ebp),%eax
  801c17:	01 c2                	add    %eax,%edx
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c1e:	eb 03                	jmp    801c23 <strsplit+0x8f>
			string++;
  801c20:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	8a 00                	mov    (%eax),%al
  801c28:	84 c0                	test   %al,%al
  801c2a:	74 8b                	je     801bb7 <strsplit+0x23>
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	8a 00                	mov    (%eax),%al
  801c31:	0f be c0             	movsbl %al,%eax
  801c34:	50                   	push   %eax
  801c35:	ff 75 0c             	pushl  0xc(%ebp)
  801c38:	e8 d4 fa ff ff       	call   801711 <strchr>
  801c3d:	83 c4 08             	add    $0x8,%esp
  801c40:	85 c0                	test   %eax,%eax
  801c42:	74 dc                	je     801c20 <strsplit+0x8c>
			string++;
	}
  801c44:	e9 6e ff ff ff       	jmp    801bb7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c49:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c4a:	8b 45 14             	mov    0x14(%ebp),%eax
  801c4d:	8b 00                	mov    (%eax),%eax
  801c4f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c56:	8b 45 10             	mov    0x10(%ebp),%eax
  801c59:	01 d0                	add    %edx,%eax
  801c5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801c61:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
  801c6b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801c6e:	83 ec 04             	sub    $0x4,%esp
  801c71:	68 28 47 80 00       	push   $0x804728
  801c76:	68 3f 01 00 00       	push   $0x13f
  801c7b:	68 4a 47 80 00       	push   $0x80474a
  801c80:	e8 a9 ef ff ff       	call   800c2e <_panic>

00801c85 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801c8b:	83 ec 0c             	sub    $0xc,%esp
  801c8e:	ff 75 08             	pushl  0x8(%ebp)
  801c91:	e8 90 0c 00 00       	call   802926 <sys_sbrk>
  801c96:	83 c4 10             	add    $0x10,%esp
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801ca1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ca5:	75 0a                	jne    801cb1 <malloc+0x16>
		return NULL;
  801ca7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cac:	e9 9e 01 00 00       	jmp    801e4f <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801cb1:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801cb8:	77 2c                	ja     801ce6 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801cba:	e8 eb 0a 00 00       	call   8027aa <sys_isUHeapPlacementStrategyFIRSTFIT>
  801cbf:	85 c0                	test   %eax,%eax
  801cc1:	74 19                	je     801cdc <malloc+0x41>

			void * block = alloc_block_FF(size);
  801cc3:	83 ec 0c             	sub    $0xc,%esp
  801cc6:	ff 75 08             	pushl  0x8(%ebp)
  801cc9:	e8 85 11 00 00       	call   802e53 <alloc_block_FF>
  801cce:	83 c4 10             	add    $0x10,%esp
  801cd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  801cd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cd7:	e9 73 01 00 00       	jmp    801e4f <malloc+0x1b4>
		} else {
			return NULL;
  801cdc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce1:	e9 69 01 00 00       	jmp    801e4f <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801ce6:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801ced:	8b 55 08             	mov    0x8(%ebp),%edx
  801cf0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cf3:	01 d0                	add    %edx,%eax
  801cf5:	48                   	dec    %eax
  801cf6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801cf9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cfc:	ba 00 00 00 00       	mov    $0x0,%edx
  801d01:	f7 75 e0             	divl   -0x20(%ebp)
  801d04:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d07:	29 d0                	sub    %edx,%eax
  801d09:	c1 e8 0c             	shr    $0xc,%eax
  801d0c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  801d0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801d16:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801d1d:	a1 20 50 80 00       	mov    0x805020,%eax
  801d22:	8b 40 7c             	mov    0x7c(%eax),%eax
  801d25:	05 00 10 00 00       	add    $0x1000,%eax
  801d2a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801d2d:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801d32:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801d35:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801d38:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801d3f:	8b 55 08             	mov    0x8(%ebp),%edx
  801d42:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801d45:	01 d0                	add    %edx,%eax
  801d47:	48                   	dec    %eax
  801d48:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801d4b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d53:	f7 75 cc             	divl   -0x34(%ebp)
  801d56:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d59:	29 d0                	sub    %edx,%eax
  801d5b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801d5e:	76 0a                	jbe    801d6a <malloc+0xcf>
		return NULL;
  801d60:	b8 00 00 00 00       	mov    $0x0,%eax
  801d65:	e9 e5 00 00 00       	jmp    801e4f <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801d6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d70:	eb 48                	jmp    801dba <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  801d72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d75:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801d78:	c1 e8 0c             	shr    $0xc,%eax
  801d7b:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801d7e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801d81:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801d88:	85 c0                	test   %eax,%eax
  801d8a:	75 11                	jne    801d9d <malloc+0x102>
			freePagesCount++;
  801d8c:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801d8f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801d93:	75 16                	jne    801dab <malloc+0x110>
				start = i;
  801d95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d9b:	eb 0e                	jmp    801dab <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801d9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801da4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dae:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801db1:	74 12                	je     801dc5 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801db3:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801dba:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801dc1:	76 af                	jbe    801d72 <malloc+0xd7>
  801dc3:	eb 01                	jmp    801dc6 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  801dc5:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  801dc6:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801dca:	74 08                	je     801dd4 <malloc+0x139>
  801dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcf:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801dd2:	74 07                	je     801ddb <malloc+0x140>
		return NULL;
  801dd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd9:	eb 74                	jmp    801e4f <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801ddb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dde:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801de1:	c1 e8 0c             	shr    $0xc,%eax
  801de4:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801de7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801dea:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801ded:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801df4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801df7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801dfa:	eb 11                	jmp    801e0d <malloc+0x172>
		markedPages[i] = 1;
  801dfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dff:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801e06:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801e0a:	ff 45 e8             	incl   -0x18(%ebp)
  801e0d:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801e10:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e13:	01 d0                	add    %edx,%eax
  801e15:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801e18:	77 e2                	ja     801dfc <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801e1a:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801e21:	8b 55 08             	mov    0x8(%ebp),%edx
  801e24:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801e27:	01 d0                	add    %edx,%eax
  801e29:	48                   	dec    %eax
  801e2a:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801e2d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e30:	ba 00 00 00 00       	mov    $0x0,%edx
  801e35:	f7 75 bc             	divl   -0x44(%ebp)
  801e38:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e3b:	29 d0                	sub    %edx,%eax
  801e3d:	83 ec 08             	sub    $0x8,%esp
  801e40:	50                   	push   %eax
  801e41:	ff 75 f0             	pushl  -0x10(%ebp)
  801e44:	e8 14 0b 00 00       	call   80295d <sys_allocate_user_mem>
  801e49:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  801e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801e57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e5b:	0f 84 ee 00 00 00    	je     801f4f <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801e61:	a1 20 50 80 00       	mov    0x805020,%eax
  801e66:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801e69:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e6c:	77 09                	ja     801e77 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801e6e:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801e75:	76 14                	jbe    801e8b <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801e77:	83 ec 04             	sub    $0x4,%esp
  801e7a:	68 58 47 80 00       	push   $0x804758
  801e7f:	6a 68                	push   $0x68
  801e81:	68 72 47 80 00       	push   $0x804772
  801e86:	e8 a3 ed ff ff       	call   800c2e <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  801e8b:	a1 20 50 80 00       	mov    0x805020,%eax
  801e90:	8b 40 74             	mov    0x74(%eax),%eax
  801e93:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e96:	77 20                	ja     801eb8 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801e98:	a1 20 50 80 00       	mov    0x805020,%eax
  801e9d:	8b 40 78             	mov    0x78(%eax),%eax
  801ea0:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ea3:	76 13                	jbe    801eb8 <free+0x67>
		free_block(virtual_address);
  801ea5:	83 ec 0c             	sub    $0xc,%esp
  801ea8:	ff 75 08             	pushl  0x8(%ebp)
  801eab:	e8 6c 16 00 00       	call   80351c <free_block>
  801eb0:	83 c4 10             	add    $0x10,%esp
		return;
  801eb3:	e9 98 00 00 00       	jmp    801f50 <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801eb8:	8b 55 08             	mov    0x8(%ebp),%edx
  801ebb:	a1 20 50 80 00       	mov    0x805020,%eax
  801ec0:	8b 40 7c             	mov    0x7c(%eax),%eax
  801ec3:	29 c2                	sub    %eax,%edx
  801ec5:	89 d0                	mov    %edx,%eax
  801ec7:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801ecc:	c1 e8 0c             	shr    $0xc,%eax
  801ecf:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801ed2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ed9:	eb 16                	jmp    801ef1 <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801edb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ede:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee1:	01 d0                	add    %edx,%eax
  801ee3:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  801eea:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801eee:	ff 45 f4             	incl   -0xc(%ebp)
  801ef1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef4:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801efb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801efe:	7f db                	jg     801edb <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  801f00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f03:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801f0a:	c1 e0 0c             	shl    $0xc,%eax
  801f0d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f16:	eb 1a                	jmp    801f32 <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801f18:	83 ec 08             	sub    $0x8,%esp
  801f1b:	68 00 10 00 00       	push   $0x1000
  801f20:	ff 75 f0             	pushl  -0x10(%ebp)
  801f23:	e8 19 0a 00 00       	call   802941 <sys_free_user_mem>
  801f28:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801f2b:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801f32:	8b 55 08             	mov    0x8(%ebp),%edx
  801f35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f38:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801f3a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801f3d:	77 d9                	ja     801f18 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801f3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f42:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  801f49:	00 00 00 00 
  801f4d:	eb 01                	jmp    801f50 <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  801f4f:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    

00801f52 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	83 ec 58             	sub    $0x58,%esp
  801f58:	8b 45 10             	mov    0x10(%ebp),%eax
  801f5b:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801f5e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f62:	75 0a                	jne    801f6e <smalloc+0x1c>
		return NULL;
  801f64:	b8 00 00 00 00       	mov    $0x0,%eax
  801f69:	e9 7d 01 00 00       	jmp    8020eb <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801f6e:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801f75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f7b:	01 d0                	add    %edx,%eax
  801f7d:	48                   	dec    %eax
  801f7e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801f81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f84:	ba 00 00 00 00       	mov    $0x0,%edx
  801f89:	f7 75 e4             	divl   -0x1c(%ebp)
  801f8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f8f:	29 d0                	sub    %edx,%eax
  801f91:	c1 e8 0c             	shr    $0xc,%eax
  801f94:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801f97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801f9e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801fa5:	a1 20 50 80 00       	mov    0x805020,%eax
  801faa:	8b 40 7c             	mov    0x7c(%eax),%eax
  801fad:	05 00 10 00 00       	add    $0x1000,%eax
  801fb2:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801fb5:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801fba:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801fbd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801fc0:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801fc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801fcd:	01 d0                	add    %edx,%eax
  801fcf:	48                   	dec    %eax
  801fd0:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801fd3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801fd6:	ba 00 00 00 00       	mov    $0x0,%edx
  801fdb:	f7 75 d0             	divl   -0x30(%ebp)
  801fde:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801fe1:	29 d0                	sub    %edx,%eax
  801fe3:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801fe6:	76 0a                	jbe    801ff2 <smalloc+0xa0>
		return NULL;
  801fe8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fed:	e9 f9 00 00 00       	jmp    8020eb <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801ff2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ff5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ff8:	eb 48                	jmp    802042 <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801ffa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ffd:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802000:	c1 e8 0c             	shr    $0xc,%eax
  802003:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  802006:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802009:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  802010:	85 c0                	test   %eax,%eax
  802012:	75 11                	jne    802025 <smalloc+0xd3>
			freePagesCount++;
  802014:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  802017:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80201b:	75 16                	jne    802033 <smalloc+0xe1>
				start = s;
  80201d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802020:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802023:	eb 0e                	jmp    802033 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  802025:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80202c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  802033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802036:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802039:	74 12                	je     80204d <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80203b:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  802042:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  802049:	76 af                	jbe    801ffa <smalloc+0xa8>
  80204b:	eb 01                	jmp    80204e <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  80204d:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  80204e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802052:	74 08                	je     80205c <smalloc+0x10a>
  802054:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802057:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80205a:	74 0a                	je     802066 <smalloc+0x114>
		return NULL;
  80205c:	b8 00 00 00 00       	mov    $0x0,%eax
  802061:	e9 85 00 00 00       	jmp    8020eb <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  802066:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802069:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80206c:	c1 e8 0c             	shr    $0xc,%eax
  80206f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  802072:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802075:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802078:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  80207f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802082:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802085:	eb 11                	jmp    802098 <smalloc+0x146>
		markedPages[s] = 1;
  802087:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80208a:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  802091:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  802095:	ff 45 e8             	incl   -0x18(%ebp)
  802098:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80209b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80209e:	01 d0                	add    %edx,%eax
  8020a0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8020a3:	77 e2                	ja     802087 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  8020a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020a8:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  8020ac:	52                   	push   %edx
  8020ad:	50                   	push   %eax
  8020ae:	ff 75 0c             	pushl  0xc(%ebp)
  8020b1:	ff 75 08             	pushl  0x8(%ebp)
  8020b4:	e8 8f 04 00 00       	call   802548 <sys_createSharedObject>
  8020b9:	83 c4 10             	add    $0x10,%esp
  8020bc:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  8020bf:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  8020c3:	78 12                	js     8020d7 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  8020c5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8020c8:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8020cb:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  8020d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d5:	eb 14                	jmp    8020eb <smalloc+0x199>
	}
	free((void*) start);
  8020d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020da:	83 ec 0c             	sub    $0xc,%esp
  8020dd:	50                   	push   %eax
  8020de:	e8 6e fd ff ff       	call   801e51 <free>
  8020e3:	83 c4 10             	add    $0x10,%esp
	return NULL;
  8020e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    

008020ed <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
  8020f0:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  8020f3:	83 ec 08             	sub    $0x8,%esp
  8020f6:	ff 75 0c             	pushl  0xc(%ebp)
  8020f9:	ff 75 08             	pushl  0x8(%ebp)
  8020fc:	e8 71 04 00 00       	call   802572 <sys_getSizeOfSharedObject>
  802101:	83 c4 10             	add    $0x10,%esp
  802104:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  802107:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80210e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802111:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802114:	01 d0                	add    %edx,%eax
  802116:	48                   	dec    %eax
  802117:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80211a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80211d:	ba 00 00 00 00       	mov    $0x0,%edx
  802122:	f7 75 e0             	divl   -0x20(%ebp)
  802125:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802128:	29 d0                	sub    %edx,%eax
  80212a:	c1 e8 0c             	shr    $0xc,%eax
  80212d:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  802130:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  802137:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  80213e:	a1 20 50 80 00       	mov    0x805020,%eax
  802143:	8b 40 7c             	mov    0x7c(%eax),%eax
  802146:	05 00 10 00 00       	add    $0x1000,%eax
  80214b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  80214e:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802153:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802156:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  802159:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802160:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802163:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802166:	01 d0                	add    %edx,%eax
  802168:	48                   	dec    %eax
  802169:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80216c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80216f:	ba 00 00 00 00       	mov    $0x0,%edx
  802174:	f7 75 cc             	divl   -0x34(%ebp)
  802177:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80217a:	29 d0                	sub    %edx,%eax
  80217c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80217f:	76 0a                	jbe    80218b <sget+0x9e>
		return NULL;
  802181:	b8 00 00 00 00       	mov    $0x0,%eax
  802186:	e9 f7 00 00 00       	jmp    802282 <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80218b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80218e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802191:	eb 48                	jmp    8021db <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  802193:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802196:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802199:	c1 e8 0c             	shr    $0xc,%eax
  80219c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  80219f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8021a2:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8021a9:	85 c0                	test   %eax,%eax
  8021ab:	75 11                	jne    8021be <sget+0xd1>
			free_Pages_Count++;
  8021ad:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8021b0:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8021b4:	75 16                	jne    8021cc <sget+0xdf>
				start = s;
  8021b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021bc:	eb 0e                	jmp    8021cc <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  8021be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8021c5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  8021cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cf:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8021d2:	74 12                	je     8021e6 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8021d4:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8021db:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8021e2:	76 af                	jbe    802193 <sget+0xa6>
  8021e4:	eb 01                	jmp    8021e7 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  8021e6:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  8021e7:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8021eb:	74 08                	je     8021f5 <sget+0x108>
  8021ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f0:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8021f3:	74 0a                	je     8021ff <sget+0x112>
		return NULL;
  8021f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fa:	e9 83 00 00 00       	jmp    802282 <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  8021ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802202:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802205:	c1 e8 0c             	shr    $0xc,%eax
  802208:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  80220b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80220e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802211:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  802218:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80221b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80221e:	eb 11                	jmp    802231 <sget+0x144>
		markedPages[k] = 1;
  802220:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802223:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  80222a:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  80222e:	ff 45 e8             	incl   -0x18(%ebp)
  802231:	8b 55 c0             	mov    -0x40(%ebp),%edx
  802234:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802237:	01 d0                	add    %edx,%eax
  802239:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80223c:	77 e2                	ja     802220 <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  80223e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802241:	83 ec 04             	sub    $0x4,%esp
  802244:	50                   	push   %eax
  802245:	ff 75 0c             	pushl  0xc(%ebp)
  802248:	ff 75 08             	pushl  0x8(%ebp)
  80224b:	e8 3f 03 00 00       	call   80258f <sys_getSharedObject>
  802250:	83 c4 10             	add    $0x10,%esp
  802253:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  802256:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  80225a:	78 12                	js     80226e <sget+0x181>
		shardIDs[startPage] = ss;
  80225c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80225f:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802262:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  802269:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226c:	eb 14                	jmp    802282 <sget+0x195>
	}
	free((void*) start);
  80226e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802271:	83 ec 0c             	sub    $0xc,%esp
  802274:	50                   	push   %eax
  802275:	e8 d7 fb ff ff       	call   801e51 <free>
  80227a:	83 c4 10             	add    $0x10,%esp
	return NULL;
  80227d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802282:	c9                   	leave  
  802283:	c3                   	ret    

00802284 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  802284:	55                   	push   %ebp
  802285:	89 e5                	mov    %esp,%ebp
  802287:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  80228a:	8b 55 08             	mov    0x8(%ebp),%edx
  80228d:	a1 20 50 80 00       	mov    0x805020,%eax
  802292:	8b 40 7c             	mov    0x7c(%eax),%eax
  802295:	29 c2                	sub    %eax,%edx
  802297:	89 d0                	mov    %edx,%eax
  802299:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  80229e:	c1 e8 0c             	shr    $0xc,%eax
  8022a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  8022a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a7:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  8022ae:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  8022b1:	83 ec 08             	sub    $0x8,%esp
  8022b4:	ff 75 08             	pushl  0x8(%ebp)
  8022b7:	ff 75 f0             	pushl  -0x10(%ebp)
  8022ba:	e8 ef 02 00 00       	call   8025ae <sys_freeSharedObject>
  8022bf:	83 c4 10             	add    $0x10,%esp
  8022c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  8022c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022c9:	75 0e                	jne    8022d9 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  8022cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ce:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  8022d5:	ff ff ff ff 
	}

}
  8022d9:	90                   	nop
  8022da:	c9                   	leave  
  8022db:	c3                   	ret    

008022dc <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
  8022df:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8022e2:	83 ec 04             	sub    $0x4,%esp
  8022e5:	68 80 47 80 00       	push   $0x804780
  8022ea:	68 19 01 00 00       	push   $0x119
  8022ef:	68 72 47 80 00       	push   $0x804772
  8022f4:	e8 35 e9 ff ff       	call   800c2e <_panic>

008022f9 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
  8022fc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8022ff:	83 ec 04             	sub    $0x4,%esp
  802302:	68 a6 47 80 00       	push   $0x8047a6
  802307:	68 23 01 00 00       	push   $0x123
  80230c:	68 72 47 80 00       	push   $0x804772
  802311:	e8 18 e9 ff ff       	call   800c2e <_panic>

00802316 <shrink>:

}
void shrink(uint32 newSize) {
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
  802319:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80231c:	83 ec 04             	sub    $0x4,%esp
  80231f:	68 a6 47 80 00       	push   $0x8047a6
  802324:	68 27 01 00 00       	push   $0x127
  802329:	68 72 47 80 00       	push   $0x804772
  80232e:	e8 fb e8 ff ff       	call   800c2e <_panic>

00802333 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  802333:	55                   	push   %ebp
  802334:	89 e5                	mov    %esp,%ebp
  802336:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802339:	83 ec 04             	sub    $0x4,%esp
  80233c:	68 a6 47 80 00       	push   $0x8047a6
  802341:	68 2b 01 00 00       	push   $0x12b
  802346:	68 72 47 80 00       	push   $0x804772
  80234b:	e8 de e8 ff ff       	call   800c2e <_panic>

00802350 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  802350:	55                   	push   %ebp
  802351:	89 e5                	mov    %esp,%ebp
  802353:	57                   	push   %edi
  802354:	56                   	push   %esi
  802355:	53                   	push   %ebx
  802356:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802359:	8b 45 08             	mov    0x8(%ebp),%eax
  80235c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802362:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802365:	8b 7d 18             	mov    0x18(%ebp),%edi
  802368:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80236b:	cd 30                	int    $0x30
  80236d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  802370:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802373:	83 c4 10             	add    $0x10,%esp
  802376:	5b                   	pop    %ebx
  802377:	5e                   	pop    %esi
  802378:	5f                   	pop    %edi
  802379:	5d                   	pop    %ebp
  80237a:	c3                   	ret    

0080237b <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
  80237e:	83 ec 04             	sub    $0x4,%esp
  802381:	8b 45 10             	mov    0x10(%ebp),%eax
  802384:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  802387:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80238b:	8b 45 08             	mov    0x8(%ebp),%eax
  80238e:	6a 00                	push   $0x0
  802390:	6a 00                	push   $0x0
  802392:	52                   	push   %edx
  802393:	ff 75 0c             	pushl  0xc(%ebp)
  802396:	50                   	push   %eax
  802397:	6a 00                	push   $0x0
  802399:	e8 b2 ff ff ff       	call   802350 <syscall>
  80239e:	83 c4 18             	add    $0x18,%esp
}
  8023a1:	90                   	nop
  8023a2:	c9                   	leave  
  8023a3:	c3                   	ret    

008023a4 <sys_cgetc>:

int sys_cgetc(void) {
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 02                	push   $0x2
  8023b3:	e8 98 ff ff ff       	call   802350 <syscall>
  8023b8:	83 c4 18             	add    $0x18,%esp
}
  8023bb:	c9                   	leave  
  8023bc:	c3                   	ret    

008023bd <sys_lock_cons>:

void sys_lock_cons(void) {
  8023bd:	55                   	push   %ebp
  8023be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 03                	push   $0x3
  8023cc:	e8 7f ff ff ff       	call   802350 <syscall>
  8023d1:	83 c4 18             	add    $0x18,%esp
}
  8023d4:	90                   	nop
  8023d5:	c9                   	leave  
  8023d6:	c3                   	ret    

008023d7 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  8023d7:	55                   	push   %ebp
  8023d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 04                	push   $0x4
  8023e6:	e8 65 ff ff ff       	call   802350 <syscall>
  8023eb:	83 c4 18             	add    $0x18,%esp
}
  8023ee:	90                   	nop
  8023ef:	c9                   	leave  
  8023f0:	c3                   	ret    

008023f1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  8023f1:	55                   	push   %ebp
  8023f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  8023f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	52                   	push   %edx
  802401:	50                   	push   %eax
  802402:	6a 08                	push   $0x8
  802404:	e8 47 ff ff ff       	call   802350 <syscall>
  802409:	83 c4 18             	add    $0x18,%esp
}
  80240c:	c9                   	leave  
  80240d:	c3                   	ret    

0080240e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  80240e:	55                   	push   %ebp
  80240f:	89 e5                	mov    %esp,%ebp
  802411:	56                   	push   %esi
  802412:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  802413:	8b 75 18             	mov    0x18(%ebp),%esi
  802416:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802419:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80241c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80241f:	8b 45 08             	mov    0x8(%ebp),%eax
  802422:	56                   	push   %esi
  802423:	53                   	push   %ebx
  802424:	51                   	push   %ecx
  802425:	52                   	push   %edx
  802426:	50                   	push   %eax
  802427:	6a 09                	push   $0x9
  802429:	e8 22 ff ff ff       	call   802350 <syscall>
  80242e:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  802431:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802434:	5b                   	pop    %ebx
  802435:	5e                   	pop    %esi
  802436:	5d                   	pop    %ebp
  802437:	c3                   	ret    

00802438 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80243b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80243e:	8b 45 08             	mov    0x8(%ebp),%eax
  802441:	6a 00                	push   $0x0
  802443:	6a 00                	push   $0x0
  802445:	6a 00                	push   $0x0
  802447:	52                   	push   %edx
  802448:	50                   	push   %eax
  802449:	6a 0a                	push   $0xa
  80244b:	e8 00 ff ff ff       	call   802350 <syscall>
  802450:	83 c4 18             	add    $0x18,%esp
}
  802453:	c9                   	leave  
  802454:	c3                   	ret    

00802455 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  802455:	55                   	push   %ebp
  802456:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	ff 75 0c             	pushl  0xc(%ebp)
  802461:	ff 75 08             	pushl  0x8(%ebp)
  802464:	6a 0b                	push   $0xb
  802466:	e8 e5 fe ff ff       	call   802350 <syscall>
  80246b:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  80246e:	c9                   	leave  
  80246f:	c3                   	ret    

00802470 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 0c                	push   $0xc
  80247f:	e8 cc fe ff ff       	call   802350 <syscall>
  802484:	83 c4 18             	add    $0x18,%esp
}
  802487:	c9                   	leave  
  802488:	c3                   	ret    

00802489 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  802489:	55                   	push   %ebp
  80248a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	6a 0d                	push   $0xd
  802498:	e8 b3 fe ff ff       	call   802350 <syscall>
  80249d:	83 c4 18             	add    $0x18,%esp
}
  8024a0:	c9                   	leave  
  8024a1:	c3                   	ret    

008024a2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  8024a2:	55                   	push   %ebp
  8024a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8024a5:	6a 00                	push   $0x0
  8024a7:	6a 00                	push   $0x0
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 0e                	push   $0xe
  8024b1:	e8 9a fe ff ff       	call   802350 <syscall>
  8024b6:	83 c4 18             	add    $0x18,%esp
}
  8024b9:	c9                   	leave  
  8024ba:	c3                   	ret    

008024bb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  8024bb:	55                   	push   %ebp
  8024bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 00                	push   $0x0
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 0f                	push   $0xf
  8024ca:	e8 81 fe ff ff       	call   802350 <syscall>
  8024cf:	83 c4 18             	add    $0x18,%esp
}
  8024d2:	c9                   	leave  
  8024d3:	c3                   	ret    

008024d4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  8024d4:	55                   	push   %ebp
  8024d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 00                	push   $0x0
  8024df:	ff 75 08             	pushl  0x8(%ebp)
  8024e2:	6a 10                	push   $0x10
  8024e4:	e8 67 fe ff ff       	call   802350 <syscall>
  8024e9:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  8024ec:	c9                   	leave  
  8024ed:	c3                   	ret    

008024ee <sys_scarce_memory>:

void sys_scarce_memory() {
  8024ee:	55                   	push   %ebp
  8024ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 11                	push   $0x11
  8024fd:	e8 4e fe ff ff       	call   802350 <syscall>
  802502:	83 c4 18             	add    $0x18,%esp
}
  802505:	90                   	nop
  802506:	c9                   	leave  
  802507:	c3                   	ret    

00802508 <sys_cputc>:

void sys_cputc(const char c) {
  802508:	55                   	push   %ebp
  802509:	89 e5                	mov    %esp,%ebp
  80250b:	83 ec 04             	sub    $0x4,%esp
  80250e:	8b 45 08             	mov    0x8(%ebp),%eax
  802511:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802514:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802518:	6a 00                	push   $0x0
  80251a:	6a 00                	push   $0x0
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	50                   	push   %eax
  802521:	6a 01                	push   $0x1
  802523:	e8 28 fe ff ff       	call   802350 <syscall>
  802528:	83 c4 18             	add    $0x18,%esp
}
  80252b:	90                   	nop
  80252c:	c9                   	leave  
  80252d:	c3                   	ret    

0080252e <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  80252e:	55                   	push   %ebp
  80252f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  802531:	6a 00                	push   $0x0
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	6a 14                	push   $0x14
  80253d:	e8 0e fe ff ff       	call   802350 <syscall>
  802542:	83 c4 18             	add    $0x18,%esp
}
  802545:	90                   	nop
  802546:	c9                   	leave  
  802547:	c3                   	ret    

00802548 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  802548:	55                   	push   %ebp
  802549:	89 e5                	mov    %esp,%ebp
  80254b:	83 ec 04             	sub    $0x4,%esp
  80254e:	8b 45 10             	mov    0x10(%ebp),%eax
  802551:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  802554:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802557:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80255b:	8b 45 08             	mov    0x8(%ebp),%eax
  80255e:	6a 00                	push   $0x0
  802560:	51                   	push   %ecx
  802561:	52                   	push   %edx
  802562:	ff 75 0c             	pushl  0xc(%ebp)
  802565:	50                   	push   %eax
  802566:	6a 15                	push   $0x15
  802568:	e8 e3 fd ff ff       	call   802350 <syscall>
  80256d:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  802570:	c9                   	leave  
  802571:	c3                   	ret    

00802572 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  802572:	55                   	push   %ebp
  802573:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  802575:	8b 55 0c             	mov    0xc(%ebp),%edx
  802578:	8b 45 08             	mov    0x8(%ebp),%eax
  80257b:	6a 00                	push   $0x0
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	52                   	push   %edx
  802582:	50                   	push   %eax
  802583:	6a 16                	push   $0x16
  802585:	e8 c6 fd ff ff       	call   802350 <syscall>
  80258a:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  80258d:	c9                   	leave  
  80258e:	c3                   	ret    

0080258f <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  802592:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802595:	8b 55 0c             	mov    0xc(%ebp),%edx
  802598:	8b 45 08             	mov    0x8(%ebp),%eax
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	51                   	push   %ecx
  8025a0:	52                   	push   %edx
  8025a1:	50                   	push   %eax
  8025a2:	6a 17                	push   $0x17
  8025a4:	e8 a7 fd ff ff       	call   802350 <syscall>
  8025a9:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  8025ac:	c9                   	leave  
  8025ad:	c3                   	ret    

008025ae <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  8025ae:	55                   	push   %ebp
  8025af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  8025b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	52                   	push   %edx
  8025be:	50                   	push   %eax
  8025bf:	6a 18                	push   $0x18
  8025c1:	e8 8a fd ff ff       	call   802350 <syscall>
  8025c6:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  8025c9:	c9                   	leave  
  8025ca:	c3                   	ret    

008025cb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  8025cb:	55                   	push   %ebp
  8025cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  8025ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d1:	6a 00                	push   $0x0
  8025d3:	ff 75 14             	pushl  0x14(%ebp)
  8025d6:	ff 75 10             	pushl  0x10(%ebp)
  8025d9:	ff 75 0c             	pushl  0xc(%ebp)
  8025dc:	50                   	push   %eax
  8025dd:	6a 19                	push   $0x19
  8025df:	e8 6c fd ff ff       	call   802350 <syscall>
  8025e4:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  8025e7:	c9                   	leave  
  8025e8:	c3                   	ret    

008025e9 <sys_run_env>:

void sys_run_env(int32 envId) {
  8025e9:	55                   	push   %ebp
  8025ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  8025ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 00                	push   $0x0
  8025f7:	50                   	push   %eax
  8025f8:	6a 1a                	push   $0x1a
  8025fa:	e8 51 fd ff ff       	call   802350 <syscall>
  8025ff:	83 c4 18             	add    $0x18,%esp
}
  802602:	90                   	nop
  802603:	c9                   	leave  
  802604:	c3                   	ret    

00802605 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  802605:	55                   	push   %ebp
  802606:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802608:	8b 45 08             	mov    0x8(%ebp),%eax
  80260b:	6a 00                	push   $0x0
  80260d:	6a 00                	push   $0x0
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	50                   	push   %eax
  802614:	6a 1b                	push   $0x1b
  802616:	e8 35 fd ff ff       	call   802350 <syscall>
  80261b:	83 c4 18             	add    $0x18,%esp
}
  80261e:	c9                   	leave  
  80261f:	c3                   	ret    

00802620 <sys_getenvid>:

int32 sys_getenvid(void) {
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802623:	6a 00                	push   $0x0
  802625:	6a 00                	push   $0x0
  802627:	6a 00                	push   $0x0
  802629:	6a 00                	push   $0x0
  80262b:	6a 00                	push   $0x0
  80262d:	6a 05                	push   $0x5
  80262f:	e8 1c fd ff ff       	call   802350 <syscall>
  802634:	83 c4 18             	add    $0x18,%esp
}
  802637:	c9                   	leave  
  802638:	c3                   	ret    

00802639 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  802639:	55                   	push   %ebp
  80263a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80263c:	6a 00                	push   $0x0
  80263e:	6a 00                	push   $0x0
  802640:	6a 00                	push   $0x0
  802642:	6a 00                	push   $0x0
  802644:	6a 00                	push   $0x0
  802646:	6a 06                	push   $0x6
  802648:	e8 03 fd ff ff       	call   802350 <syscall>
  80264d:	83 c4 18             	add    $0x18,%esp
}
  802650:	c9                   	leave  
  802651:	c3                   	ret    

00802652 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  802652:	55                   	push   %ebp
  802653:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802655:	6a 00                	push   $0x0
  802657:	6a 00                	push   $0x0
  802659:	6a 00                	push   $0x0
  80265b:	6a 00                	push   $0x0
  80265d:	6a 00                	push   $0x0
  80265f:	6a 07                	push   $0x7
  802661:	e8 ea fc ff ff       	call   802350 <syscall>
  802666:	83 c4 18             	add    $0x18,%esp
}
  802669:	c9                   	leave  
  80266a:	c3                   	ret    

0080266b <sys_exit_env>:

void sys_exit_env(void) {
  80266b:	55                   	push   %ebp
  80266c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80266e:	6a 00                	push   $0x0
  802670:	6a 00                	push   $0x0
  802672:	6a 00                	push   $0x0
  802674:	6a 00                	push   $0x0
  802676:	6a 00                	push   $0x0
  802678:	6a 1c                	push   $0x1c
  80267a:	e8 d1 fc ff ff       	call   802350 <syscall>
  80267f:	83 c4 18             	add    $0x18,%esp
}
  802682:	90                   	nop
  802683:	c9                   	leave  
  802684:	c3                   	ret    

00802685 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  802685:	55                   	push   %ebp
  802686:	89 e5                	mov    %esp,%ebp
  802688:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  80268b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80268e:	8d 50 04             	lea    0x4(%eax),%edx
  802691:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802694:	6a 00                	push   $0x0
  802696:	6a 00                	push   $0x0
  802698:	6a 00                	push   $0x0
  80269a:	52                   	push   %edx
  80269b:	50                   	push   %eax
  80269c:	6a 1d                	push   $0x1d
  80269e:	e8 ad fc ff ff       	call   802350 <syscall>
  8026a3:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  8026a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026af:	89 01                	mov    %eax,(%ecx)
  8026b1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8026b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b7:	c9                   	leave  
  8026b8:	c2 04 00             	ret    $0x4

008026bb <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  8026bb:	55                   	push   %ebp
  8026bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  8026be:	6a 00                	push   $0x0
  8026c0:	6a 00                	push   $0x0
  8026c2:	ff 75 10             	pushl  0x10(%ebp)
  8026c5:	ff 75 0c             	pushl  0xc(%ebp)
  8026c8:	ff 75 08             	pushl  0x8(%ebp)
  8026cb:	6a 13                	push   $0x13
  8026cd:	e8 7e fc ff ff       	call   802350 <syscall>
  8026d2:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  8026d5:	90                   	nop
}
  8026d6:	c9                   	leave  
  8026d7:	c3                   	ret    

008026d8 <sys_rcr2>:
uint32 sys_rcr2() {
  8026d8:	55                   	push   %ebp
  8026d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8026db:	6a 00                	push   $0x0
  8026dd:	6a 00                	push   $0x0
  8026df:	6a 00                	push   $0x0
  8026e1:	6a 00                	push   $0x0
  8026e3:	6a 00                	push   $0x0
  8026e5:	6a 1e                	push   $0x1e
  8026e7:	e8 64 fc ff ff       	call   802350 <syscall>
  8026ec:	83 c4 18             	add    $0x18,%esp
}
  8026ef:	c9                   	leave  
  8026f0:	c3                   	ret    

008026f1 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  8026f1:	55                   	push   %ebp
  8026f2:	89 e5                	mov    %esp,%ebp
  8026f4:	83 ec 04             	sub    $0x4,%esp
  8026f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8026fd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802701:	6a 00                	push   $0x0
  802703:	6a 00                	push   $0x0
  802705:	6a 00                	push   $0x0
  802707:	6a 00                	push   $0x0
  802709:	50                   	push   %eax
  80270a:	6a 1f                	push   $0x1f
  80270c:	e8 3f fc ff ff       	call   802350 <syscall>
  802711:	83 c4 18             	add    $0x18,%esp
	return;
  802714:	90                   	nop
}
  802715:	c9                   	leave  
  802716:	c3                   	ret    

00802717 <rsttst>:
void rsttst() {
  802717:	55                   	push   %ebp
  802718:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80271a:	6a 00                	push   $0x0
  80271c:	6a 00                	push   $0x0
  80271e:	6a 00                	push   $0x0
  802720:	6a 00                	push   $0x0
  802722:	6a 00                	push   $0x0
  802724:	6a 21                	push   $0x21
  802726:	e8 25 fc ff ff       	call   802350 <syscall>
  80272b:	83 c4 18             	add    $0x18,%esp
	return;
  80272e:	90                   	nop
}
  80272f:	c9                   	leave  
  802730:	c3                   	ret    

00802731 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  802731:	55                   	push   %ebp
  802732:	89 e5                	mov    %esp,%ebp
  802734:	83 ec 04             	sub    $0x4,%esp
  802737:	8b 45 14             	mov    0x14(%ebp),%eax
  80273a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80273d:	8b 55 18             	mov    0x18(%ebp),%edx
  802740:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802744:	52                   	push   %edx
  802745:	50                   	push   %eax
  802746:	ff 75 10             	pushl  0x10(%ebp)
  802749:	ff 75 0c             	pushl  0xc(%ebp)
  80274c:	ff 75 08             	pushl  0x8(%ebp)
  80274f:	6a 20                	push   $0x20
  802751:	e8 fa fb ff ff       	call   802350 <syscall>
  802756:	83 c4 18             	add    $0x18,%esp
	return;
  802759:	90                   	nop
}
  80275a:	c9                   	leave  
  80275b:	c3                   	ret    

0080275c <chktst>:
void chktst(uint32 n) {
  80275c:	55                   	push   %ebp
  80275d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80275f:	6a 00                	push   $0x0
  802761:	6a 00                	push   $0x0
  802763:	6a 00                	push   $0x0
  802765:	6a 00                	push   $0x0
  802767:	ff 75 08             	pushl  0x8(%ebp)
  80276a:	6a 22                	push   $0x22
  80276c:	e8 df fb ff ff       	call   802350 <syscall>
  802771:	83 c4 18             	add    $0x18,%esp
	return;
  802774:	90                   	nop
}
  802775:	c9                   	leave  
  802776:	c3                   	ret    

00802777 <inctst>:

void inctst() {
  802777:	55                   	push   %ebp
  802778:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80277a:	6a 00                	push   $0x0
  80277c:	6a 00                	push   $0x0
  80277e:	6a 00                	push   $0x0
  802780:	6a 00                	push   $0x0
  802782:	6a 00                	push   $0x0
  802784:	6a 23                	push   $0x23
  802786:	e8 c5 fb ff ff       	call   802350 <syscall>
  80278b:	83 c4 18             	add    $0x18,%esp
	return;
  80278e:	90                   	nop
}
  80278f:	c9                   	leave  
  802790:	c3                   	ret    

00802791 <gettst>:
uint32 gettst() {
  802791:	55                   	push   %ebp
  802792:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802794:	6a 00                	push   $0x0
  802796:	6a 00                	push   $0x0
  802798:	6a 00                	push   $0x0
  80279a:	6a 00                	push   $0x0
  80279c:	6a 00                	push   $0x0
  80279e:	6a 24                	push   $0x24
  8027a0:	e8 ab fb ff ff       	call   802350 <syscall>
  8027a5:	83 c4 18             	add    $0x18,%esp
}
  8027a8:	c9                   	leave  
  8027a9:	c3                   	ret    

008027aa <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  8027aa:	55                   	push   %ebp
  8027ab:	89 e5                	mov    %esp,%ebp
  8027ad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027b0:	6a 00                	push   $0x0
  8027b2:	6a 00                	push   $0x0
  8027b4:	6a 00                	push   $0x0
  8027b6:	6a 00                	push   $0x0
  8027b8:	6a 00                	push   $0x0
  8027ba:	6a 25                	push   $0x25
  8027bc:	e8 8f fb ff ff       	call   802350 <syscall>
  8027c1:	83 c4 18             	add    $0x18,%esp
  8027c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8027c7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8027cb:	75 07                	jne    8027d4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8027cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8027d2:	eb 05                	jmp    8027d9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8027d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027d9:	c9                   	leave  
  8027da:	c3                   	ret    

008027db <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  8027db:	55                   	push   %ebp
  8027dc:	89 e5                	mov    %esp,%ebp
  8027de:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027e1:	6a 00                	push   $0x0
  8027e3:	6a 00                	push   $0x0
  8027e5:	6a 00                	push   $0x0
  8027e7:	6a 00                	push   $0x0
  8027e9:	6a 00                	push   $0x0
  8027eb:	6a 25                	push   $0x25
  8027ed:	e8 5e fb ff ff       	call   802350 <syscall>
  8027f2:	83 c4 18             	add    $0x18,%esp
  8027f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8027f8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8027fc:	75 07                	jne    802805 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8027fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802803:	eb 05                	jmp    80280a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802805:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80280a:	c9                   	leave  
  80280b:	c3                   	ret    

0080280c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  80280c:	55                   	push   %ebp
  80280d:	89 e5                	mov    %esp,%ebp
  80280f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802812:	6a 00                	push   $0x0
  802814:	6a 00                	push   $0x0
  802816:	6a 00                	push   $0x0
  802818:	6a 00                	push   $0x0
  80281a:	6a 00                	push   $0x0
  80281c:	6a 25                	push   $0x25
  80281e:	e8 2d fb ff ff       	call   802350 <syscall>
  802823:	83 c4 18             	add    $0x18,%esp
  802826:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802829:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80282d:	75 07                	jne    802836 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80282f:	b8 01 00 00 00       	mov    $0x1,%eax
  802834:	eb 05                	jmp    80283b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802836:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80283b:	c9                   	leave  
  80283c:	c3                   	ret    

0080283d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  80283d:	55                   	push   %ebp
  80283e:	89 e5                	mov    %esp,%ebp
  802840:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802843:	6a 00                	push   $0x0
  802845:	6a 00                	push   $0x0
  802847:	6a 00                	push   $0x0
  802849:	6a 00                	push   $0x0
  80284b:	6a 00                	push   $0x0
  80284d:	6a 25                	push   $0x25
  80284f:	e8 fc fa ff ff       	call   802350 <syscall>
  802854:	83 c4 18             	add    $0x18,%esp
  802857:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80285a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80285e:	75 07                	jne    802867 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802860:	b8 01 00 00 00       	mov    $0x1,%eax
  802865:	eb 05                	jmp    80286c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802867:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80286c:	c9                   	leave  
  80286d:	c3                   	ret    

0080286e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  80286e:	55                   	push   %ebp
  80286f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802871:	6a 00                	push   $0x0
  802873:	6a 00                	push   $0x0
  802875:	6a 00                	push   $0x0
  802877:	6a 00                	push   $0x0
  802879:	ff 75 08             	pushl  0x8(%ebp)
  80287c:	6a 26                	push   $0x26
  80287e:	e8 cd fa ff ff       	call   802350 <syscall>
  802883:	83 c4 18             	add    $0x18,%esp
	return;
  802886:	90                   	nop
}
  802887:	c9                   	leave  
  802888:	c3                   	ret    

00802889 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  802889:	55                   	push   %ebp
  80288a:	89 e5                	mov    %esp,%ebp
  80288c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  80288d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802890:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802893:	8b 55 0c             	mov    0xc(%ebp),%edx
  802896:	8b 45 08             	mov    0x8(%ebp),%eax
  802899:	6a 00                	push   $0x0
  80289b:	53                   	push   %ebx
  80289c:	51                   	push   %ecx
  80289d:	52                   	push   %edx
  80289e:	50                   	push   %eax
  80289f:	6a 27                	push   $0x27
  8028a1:	e8 aa fa ff ff       	call   802350 <syscall>
  8028a6:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  8028a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028ac:	c9                   	leave  
  8028ad:	c3                   	ret    

008028ae <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  8028ae:	55                   	push   %ebp
  8028af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  8028b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b7:	6a 00                	push   $0x0
  8028b9:	6a 00                	push   $0x0
  8028bb:	6a 00                	push   $0x0
  8028bd:	52                   	push   %edx
  8028be:	50                   	push   %eax
  8028bf:	6a 28                	push   $0x28
  8028c1:	e8 8a fa ff ff       	call   802350 <syscall>
  8028c6:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  8028c9:	c9                   	leave  
  8028ca:	c3                   	ret    

008028cb <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  8028cb:	55                   	push   %ebp
  8028cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  8028ce:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8028d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d7:	6a 00                	push   $0x0
  8028d9:	51                   	push   %ecx
  8028da:	ff 75 10             	pushl  0x10(%ebp)
  8028dd:	52                   	push   %edx
  8028de:	50                   	push   %eax
  8028df:	6a 29                	push   $0x29
  8028e1:	e8 6a fa ff ff       	call   802350 <syscall>
  8028e6:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  8028e9:	c9                   	leave  
  8028ea:	c3                   	ret    

008028eb <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  8028eb:	55                   	push   %ebp
  8028ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8028ee:	6a 00                	push   $0x0
  8028f0:	6a 00                	push   $0x0
  8028f2:	ff 75 10             	pushl  0x10(%ebp)
  8028f5:	ff 75 0c             	pushl  0xc(%ebp)
  8028f8:	ff 75 08             	pushl  0x8(%ebp)
  8028fb:	6a 12                	push   $0x12
  8028fd:	e8 4e fa ff ff       	call   802350 <syscall>
  802902:	83 c4 18             	add    $0x18,%esp
	return;
  802905:	90                   	nop
}
  802906:	c9                   	leave  
  802907:	c3                   	ret    

00802908 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  802908:	55                   	push   %ebp
  802909:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  80290b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80290e:	8b 45 08             	mov    0x8(%ebp),%eax
  802911:	6a 00                	push   $0x0
  802913:	6a 00                	push   $0x0
  802915:	6a 00                	push   $0x0
  802917:	52                   	push   %edx
  802918:	50                   	push   %eax
  802919:	6a 2a                	push   $0x2a
  80291b:	e8 30 fa ff ff       	call   802350 <syscall>
  802920:	83 c4 18             	add    $0x18,%esp
	return;
  802923:	90                   	nop
}
  802924:	c9                   	leave  
  802925:	c3                   	ret    

00802926 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  802926:	55                   	push   %ebp
  802927:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  802929:	8b 45 08             	mov    0x8(%ebp),%eax
  80292c:	6a 00                	push   $0x0
  80292e:	6a 00                	push   $0x0
  802930:	6a 00                	push   $0x0
  802932:	6a 00                	push   $0x0
  802934:	50                   	push   %eax
  802935:	6a 2b                	push   $0x2b
  802937:	e8 14 fa ff ff       	call   802350 <syscall>
  80293c:	83 c4 18             	add    $0x18,%esp
}
  80293f:	c9                   	leave  
  802940:	c3                   	ret    

00802941 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  802941:	55                   	push   %ebp
  802942:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802944:	6a 00                	push   $0x0
  802946:	6a 00                	push   $0x0
  802948:	6a 00                	push   $0x0
  80294a:	ff 75 0c             	pushl  0xc(%ebp)
  80294d:	ff 75 08             	pushl  0x8(%ebp)
  802950:	6a 2c                	push   $0x2c
  802952:	e8 f9 f9 ff ff       	call   802350 <syscall>
  802957:	83 c4 18             	add    $0x18,%esp
	return;
  80295a:	90                   	nop
}
  80295b:	c9                   	leave  
  80295c:	c3                   	ret    

0080295d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  80295d:	55                   	push   %ebp
  80295e:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802960:	6a 00                	push   $0x0
  802962:	6a 00                	push   $0x0
  802964:	6a 00                	push   $0x0
  802966:	ff 75 0c             	pushl  0xc(%ebp)
  802969:	ff 75 08             	pushl  0x8(%ebp)
  80296c:	6a 2d                	push   $0x2d
  80296e:	e8 dd f9 ff ff       	call   802350 <syscall>
  802973:	83 c4 18             	add    $0x18,%esp
	return;
  802976:	90                   	nop
}
  802977:	c9                   	leave  
  802978:	c3                   	ret    

00802979 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  802979:	55                   	push   %ebp
  80297a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  80297c:	8b 45 08             	mov    0x8(%ebp),%eax
  80297f:	6a 00                	push   $0x0
  802981:	6a 00                	push   $0x0
  802983:	6a 00                	push   $0x0
  802985:	6a 00                	push   $0x0
  802987:	50                   	push   %eax
  802988:	6a 2f                	push   $0x2f
  80298a:	e8 c1 f9 ff ff       	call   802350 <syscall>
  80298f:	83 c4 18             	add    $0x18,%esp
	return;
  802992:	90                   	nop
}
  802993:	c9                   	leave  
  802994:	c3                   	ret    

00802995 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  802995:	55                   	push   %ebp
  802996:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  802998:	8b 55 0c             	mov    0xc(%ebp),%edx
  80299b:	8b 45 08             	mov    0x8(%ebp),%eax
  80299e:	6a 00                	push   $0x0
  8029a0:	6a 00                	push   $0x0
  8029a2:	6a 00                	push   $0x0
  8029a4:	52                   	push   %edx
  8029a5:	50                   	push   %eax
  8029a6:	6a 30                	push   $0x30
  8029a8:	e8 a3 f9 ff ff       	call   802350 <syscall>
  8029ad:	83 c4 18             	add    $0x18,%esp
	return;
  8029b0:	90                   	nop
}
  8029b1:	c9                   	leave  
  8029b2:	c3                   	ret    

008029b3 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  8029b3:	55                   	push   %ebp
  8029b4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  8029b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b9:	6a 00                	push   $0x0
  8029bb:	6a 00                	push   $0x0
  8029bd:	6a 00                	push   $0x0
  8029bf:	6a 00                	push   $0x0
  8029c1:	50                   	push   %eax
  8029c2:	6a 31                	push   $0x31
  8029c4:	e8 87 f9 ff ff       	call   802350 <syscall>
  8029c9:	83 c4 18             	add    $0x18,%esp
	return;
  8029cc:	90                   	nop
}
  8029cd:	c9                   	leave  
  8029ce:	c3                   	ret    

008029cf <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  8029cf:	55                   	push   %ebp
  8029d0:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8029d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d8:	6a 00                	push   $0x0
  8029da:	6a 00                	push   $0x0
  8029dc:	6a 00                	push   $0x0
  8029de:	52                   	push   %edx
  8029df:	50                   	push   %eax
  8029e0:	6a 2e                	push   $0x2e
  8029e2:	e8 69 f9 ff ff       	call   802350 <syscall>
  8029e7:	83 c4 18             	add    $0x18,%esp
    return;
  8029ea:	90                   	nop
}
  8029eb:	c9                   	leave  
  8029ec:	c3                   	ret    

008029ed <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8029ed:	55                   	push   %ebp
  8029ee:	89 e5                	mov    %esp,%ebp
  8029f0:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	83 e8 04             	sub    $0x4,%eax
  8029f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8029fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029ff:	8b 00                	mov    (%eax),%eax
  802a01:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802a04:	c9                   	leave  
  802a05:	c3                   	ret    

00802a06 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802a06:	55                   	push   %ebp
  802a07:	89 e5                	mov    %esp,%ebp
  802a09:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	83 e8 04             	sub    $0x4,%eax
  802a12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802a15:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a18:	8b 00                	mov    (%eax),%eax
  802a1a:	83 e0 01             	and    $0x1,%eax
  802a1d:	85 c0                	test   %eax,%eax
  802a1f:	0f 94 c0             	sete   %al
}
  802a22:	c9                   	leave  
  802a23:	c3                   	ret    

00802a24 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802a24:	55                   	push   %ebp
  802a25:	89 e5                	mov    %esp,%ebp
  802a27:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802a2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802a31:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a34:	83 f8 02             	cmp    $0x2,%eax
  802a37:	74 2b                	je     802a64 <alloc_block+0x40>
  802a39:	83 f8 02             	cmp    $0x2,%eax
  802a3c:	7f 07                	jg     802a45 <alloc_block+0x21>
  802a3e:	83 f8 01             	cmp    $0x1,%eax
  802a41:	74 0e                	je     802a51 <alloc_block+0x2d>
  802a43:	eb 58                	jmp    802a9d <alloc_block+0x79>
  802a45:	83 f8 03             	cmp    $0x3,%eax
  802a48:	74 2d                	je     802a77 <alloc_block+0x53>
  802a4a:	83 f8 04             	cmp    $0x4,%eax
  802a4d:	74 3b                	je     802a8a <alloc_block+0x66>
  802a4f:	eb 4c                	jmp    802a9d <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802a51:	83 ec 0c             	sub    $0xc,%esp
  802a54:	ff 75 08             	pushl  0x8(%ebp)
  802a57:	e8 f7 03 00 00       	call   802e53 <alloc_block_FF>
  802a5c:	83 c4 10             	add    $0x10,%esp
  802a5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802a62:	eb 4a                	jmp    802aae <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802a64:	83 ec 0c             	sub    $0xc,%esp
  802a67:	ff 75 08             	pushl  0x8(%ebp)
  802a6a:	e8 f0 11 00 00       	call   803c5f <alloc_block_NF>
  802a6f:	83 c4 10             	add    $0x10,%esp
  802a72:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802a75:	eb 37                	jmp    802aae <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802a77:	83 ec 0c             	sub    $0xc,%esp
  802a7a:	ff 75 08             	pushl  0x8(%ebp)
  802a7d:	e8 08 08 00 00       	call   80328a <alloc_block_BF>
  802a82:	83 c4 10             	add    $0x10,%esp
  802a85:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802a88:	eb 24                	jmp    802aae <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802a8a:	83 ec 0c             	sub    $0xc,%esp
  802a8d:	ff 75 08             	pushl  0x8(%ebp)
  802a90:	e8 ad 11 00 00       	call   803c42 <alloc_block_WF>
  802a95:	83 c4 10             	add    $0x10,%esp
  802a98:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802a9b:	eb 11                	jmp    802aae <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802a9d:	83 ec 0c             	sub    $0xc,%esp
  802aa0:	68 b8 47 80 00       	push   $0x8047b8
  802aa5:	e8 41 e4 ff ff       	call   800eeb <cprintf>
  802aaa:	83 c4 10             	add    $0x10,%esp
		break;
  802aad:	90                   	nop
	}
	return va;
  802aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802ab1:	c9                   	leave  
  802ab2:	c3                   	ret    

00802ab3 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802ab3:	55                   	push   %ebp
  802ab4:	89 e5                	mov    %esp,%ebp
  802ab6:	53                   	push   %ebx
  802ab7:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802aba:	83 ec 0c             	sub    $0xc,%esp
  802abd:	68 d8 47 80 00       	push   $0x8047d8
  802ac2:	e8 24 e4 ff ff       	call   800eeb <cprintf>
  802ac7:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802aca:	83 ec 0c             	sub    $0xc,%esp
  802acd:	68 03 48 80 00       	push   $0x804803
  802ad2:	e8 14 e4 ff ff       	call   800eeb <cprintf>
  802ad7:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802ada:	8b 45 08             	mov    0x8(%ebp),%eax
  802add:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ae0:	eb 37                	jmp    802b19 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802ae2:	83 ec 0c             	sub    $0xc,%esp
  802ae5:	ff 75 f4             	pushl  -0xc(%ebp)
  802ae8:	e8 19 ff ff ff       	call   802a06 <is_free_block>
  802aed:	83 c4 10             	add    $0x10,%esp
  802af0:	0f be d8             	movsbl %al,%ebx
  802af3:	83 ec 0c             	sub    $0xc,%esp
  802af6:	ff 75 f4             	pushl  -0xc(%ebp)
  802af9:	e8 ef fe ff ff       	call   8029ed <get_block_size>
  802afe:	83 c4 10             	add    $0x10,%esp
  802b01:	83 ec 04             	sub    $0x4,%esp
  802b04:	53                   	push   %ebx
  802b05:	50                   	push   %eax
  802b06:	68 1b 48 80 00       	push   $0x80481b
  802b0b:	e8 db e3 ff ff       	call   800eeb <cprintf>
  802b10:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802b13:	8b 45 10             	mov    0x10(%ebp),%eax
  802b16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b1d:	74 07                	je     802b26 <print_blocks_list+0x73>
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	8b 00                	mov    (%eax),%eax
  802b24:	eb 05                	jmp    802b2b <print_blocks_list+0x78>
  802b26:	b8 00 00 00 00       	mov    $0x0,%eax
  802b2b:	89 45 10             	mov    %eax,0x10(%ebp)
  802b2e:	8b 45 10             	mov    0x10(%ebp),%eax
  802b31:	85 c0                	test   %eax,%eax
  802b33:	75 ad                	jne    802ae2 <print_blocks_list+0x2f>
  802b35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b39:	75 a7                	jne    802ae2 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802b3b:	83 ec 0c             	sub    $0xc,%esp
  802b3e:	68 d8 47 80 00       	push   $0x8047d8
  802b43:	e8 a3 e3 ff ff       	call   800eeb <cprintf>
  802b48:	83 c4 10             	add    $0x10,%esp

}
  802b4b:	90                   	nop
  802b4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b4f:	c9                   	leave  
  802b50:	c3                   	ret    

00802b51 <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802b51:	55                   	push   %ebp
  802b52:	89 e5                	mov    %esp,%ebp
  802b54:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802b57:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b5a:	83 e0 01             	and    $0x1,%eax
  802b5d:	85 c0                	test   %eax,%eax
  802b5f:	74 03                	je     802b64 <initialize_dynamic_allocator+0x13>
  802b61:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  802b64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b68:	0f 84 f8 00 00 00    	je     802c66 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  802b6e:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  802b75:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  802b78:	a1 40 50 98 00       	mov    0x985040,%eax
  802b7d:	85 c0                	test   %eax,%eax
  802b7f:	0f 84 e2 00 00 00    	je     802c67 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  802b85:	8b 45 08             	mov    0x8(%ebp),%eax
  802b88:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  802b94:	8b 55 08             	mov    0x8(%ebp),%edx
  802b97:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b9a:	01 d0                	add    %edx,%eax
  802b9c:	83 e8 04             	sub    $0x4,%eax
  802b9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  802bab:	8b 45 08             	mov    0x8(%ebp),%eax
  802bae:	83 c0 08             	add    $0x8,%eax
  802bb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  802bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bb7:	83 e8 08             	sub    $0x8,%eax
  802bba:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  802bbd:	83 ec 04             	sub    $0x4,%esp
  802bc0:	6a 00                	push   $0x0
  802bc2:	ff 75 e8             	pushl  -0x18(%ebp)
  802bc5:	ff 75 ec             	pushl  -0x14(%ebp)
  802bc8:	e8 9c 00 00 00       	call   802c69 <set_block_data>
  802bcd:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  802bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802bd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  802be3:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  802bea:	00 00 00 
  802bed:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  802bf4:	00 00 00 
  802bf7:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  802bfe:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  802c01:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c05:	75 17                	jne    802c1e <initialize_dynamic_allocator+0xcd>
  802c07:	83 ec 04             	sub    $0x4,%esp
  802c0a:	68 34 48 80 00       	push   $0x804834
  802c0f:	68 80 00 00 00       	push   $0x80
  802c14:	68 57 48 80 00       	push   $0x804857
  802c19:	e8 10 e0 ff ff       	call   800c2e <_panic>
  802c1e:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802c24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c27:	89 10                	mov    %edx,(%eax)
  802c29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2c:	8b 00                	mov    (%eax),%eax
  802c2e:	85 c0                	test   %eax,%eax
  802c30:	74 0d                	je     802c3f <initialize_dynamic_allocator+0xee>
  802c32:	a1 48 50 98 00       	mov    0x985048,%eax
  802c37:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c3a:	89 50 04             	mov    %edx,0x4(%eax)
  802c3d:	eb 08                	jmp    802c47 <initialize_dynamic_allocator+0xf6>
  802c3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c42:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802c47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4a:	a3 48 50 98 00       	mov    %eax,0x985048
  802c4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c59:	a1 54 50 98 00       	mov    0x985054,%eax
  802c5e:	40                   	inc    %eax
  802c5f:	a3 54 50 98 00       	mov    %eax,0x985054
  802c64:	eb 01                	jmp    802c67 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802c66:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  802c67:	c9                   	leave  
  802c68:	c3                   	ret    

00802c69 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802c69:	55                   	push   %ebp
  802c6a:	89 e5                	mov    %esp,%ebp
  802c6c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  802c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c72:	83 e0 01             	and    $0x1,%eax
  802c75:	85 c0                	test   %eax,%eax
  802c77:	74 03                	je     802c7c <set_block_data+0x13>
	{
		totalSize++;
  802c79:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  802c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7f:	83 e8 04             	sub    $0x4,%eax
  802c82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  802c85:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c88:	83 e0 fe             	and    $0xfffffffe,%eax
  802c8b:	89 c2                	mov    %eax,%edx
  802c8d:	8b 45 10             	mov    0x10(%ebp),%eax
  802c90:	83 e0 01             	and    $0x1,%eax
  802c93:	09 c2                	or     %eax,%edx
  802c95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c98:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  802c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c9d:	8d 50 f8             	lea    -0x8(%eax),%edx
  802ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca3:	01 d0                	add    %edx,%eax
  802ca5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  802ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cab:	83 e0 fe             	and    $0xfffffffe,%eax
  802cae:	89 c2                	mov    %eax,%edx
  802cb0:	8b 45 10             	mov    0x10(%ebp),%eax
  802cb3:	83 e0 01             	and    $0x1,%eax
  802cb6:	09 c2                	or     %eax,%edx
  802cb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802cbb:	89 10                	mov    %edx,(%eax)
}
  802cbd:	90                   	nop
  802cbe:	c9                   	leave  
  802cbf:	c3                   	ret    

00802cc0 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  802cc0:	55                   	push   %ebp
  802cc1:	89 e5                	mov    %esp,%ebp
  802cc3:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  802cc6:	a1 48 50 98 00       	mov    0x985048,%eax
  802ccb:	85 c0                	test   %eax,%eax
  802ccd:	75 68                	jne    802d37 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  802ccf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cd3:	75 17                	jne    802cec <insert_sorted_in_freeList+0x2c>
  802cd5:	83 ec 04             	sub    $0x4,%esp
  802cd8:	68 34 48 80 00       	push   $0x804834
  802cdd:	68 9d 00 00 00       	push   $0x9d
  802ce2:	68 57 48 80 00       	push   $0x804857
  802ce7:	e8 42 df ff ff       	call   800c2e <_panic>
  802cec:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf5:	89 10                	mov    %edx,(%eax)
  802cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfa:	8b 00                	mov    (%eax),%eax
  802cfc:	85 c0                	test   %eax,%eax
  802cfe:	74 0d                	je     802d0d <insert_sorted_in_freeList+0x4d>
  802d00:	a1 48 50 98 00       	mov    0x985048,%eax
  802d05:	8b 55 08             	mov    0x8(%ebp),%edx
  802d08:	89 50 04             	mov    %edx,0x4(%eax)
  802d0b:	eb 08                	jmp    802d15 <insert_sorted_in_freeList+0x55>
  802d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d10:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802d15:	8b 45 08             	mov    0x8(%ebp),%eax
  802d18:	a3 48 50 98 00       	mov    %eax,0x985048
  802d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d27:	a1 54 50 98 00       	mov    0x985054,%eax
  802d2c:	40                   	inc    %eax
  802d2d:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  802d32:	e9 1a 01 00 00       	jmp    802e51 <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802d37:	a1 48 50 98 00       	mov    0x985048,%eax
  802d3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d3f:	eb 7f                	jmp    802dc0 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  802d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d44:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d47:	76 6f                	jbe    802db8 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  802d49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d4d:	74 06                	je     802d55 <insert_sorted_in_freeList+0x95>
  802d4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d53:	75 17                	jne    802d6c <insert_sorted_in_freeList+0xac>
  802d55:	83 ec 04             	sub    $0x4,%esp
  802d58:	68 70 48 80 00       	push   $0x804870
  802d5d:	68 a6 00 00 00       	push   $0xa6
  802d62:	68 57 48 80 00       	push   $0x804857
  802d67:	e8 c2 de ff ff       	call   800c2e <_panic>
  802d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6f:	8b 50 04             	mov    0x4(%eax),%edx
  802d72:	8b 45 08             	mov    0x8(%ebp),%eax
  802d75:	89 50 04             	mov    %edx,0x4(%eax)
  802d78:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d7e:	89 10                	mov    %edx,(%eax)
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	8b 40 04             	mov    0x4(%eax),%eax
  802d86:	85 c0                	test   %eax,%eax
  802d88:	74 0d                	je     802d97 <insert_sorted_in_freeList+0xd7>
  802d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8d:	8b 40 04             	mov    0x4(%eax),%eax
  802d90:	8b 55 08             	mov    0x8(%ebp),%edx
  802d93:	89 10                	mov    %edx,(%eax)
  802d95:	eb 08                	jmp    802d9f <insert_sorted_in_freeList+0xdf>
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	a3 48 50 98 00       	mov    %eax,0x985048
  802d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da2:	8b 55 08             	mov    0x8(%ebp),%edx
  802da5:	89 50 04             	mov    %edx,0x4(%eax)
  802da8:	a1 54 50 98 00       	mov    0x985054,%eax
  802dad:	40                   	inc    %eax
  802dae:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  802db3:	e9 99 00 00 00       	jmp    802e51 <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802db8:	a1 50 50 98 00       	mov    0x985050,%eax
  802dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc4:	74 07                	je     802dcd <insert_sorted_in_freeList+0x10d>
  802dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc9:	8b 00                	mov    (%eax),%eax
  802dcb:	eb 05                	jmp    802dd2 <insert_sorted_in_freeList+0x112>
  802dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd2:	a3 50 50 98 00       	mov    %eax,0x985050
  802dd7:	a1 50 50 98 00       	mov    0x985050,%eax
  802ddc:	85 c0                	test   %eax,%eax
  802dde:	0f 85 5d ff ff ff    	jne    802d41 <insert_sorted_in_freeList+0x81>
  802de4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de8:	0f 85 53 ff ff ff    	jne    802d41 <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  802dee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802df2:	75 17                	jne    802e0b <insert_sorted_in_freeList+0x14b>
  802df4:	83 ec 04             	sub    $0x4,%esp
  802df7:	68 a8 48 80 00       	push   $0x8048a8
  802dfc:	68 ab 00 00 00       	push   $0xab
  802e01:	68 57 48 80 00       	push   $0x804857
  802e06:	e8 23 de ff ff       	call   800c2e <_panic>
  802e0b:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  802e11:	8b 45 08             	mov    0x8(%ebp),%eax
  802e14:	89 50 04             	mov    %edx,0x4(%eax)
  802e17:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1a:	8b 40 04             	mov    0x4(%eax),%eax
  802e1d:	85 c0                	test   %eax,%eax
  802e1f:	74 0c                	je     802e2d <insert_sorted_in_freeList+0x16d>
  802e21:	a1 4c 50 98 00       	mov    0x98504c,%eax
  802e26:	8b 55 08             	mov    0x8(%ebp),%edx
  802e29:	89 10                	mov    %edx,(%eax)
  802e2b:	eb 08                	jmp    802e35 <insert_sorted_in_freeList+0x175>
  802e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e30:	a3 48 50 98 00       	mov    %eax,0x985048
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e46:	a1 54 50 98 00       	mov    0x985054,%eax
  802e4b:	40                   	inc    %eax
  802e4c:	a3 54 50 98 00       	mov    %eax,0x985054
}
  802e51:	c9                   	leave  
  802e52:	c3                   	ret    

00802e53 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802e53:	55                   	push   %ebp
  802e54:	89 e5                	mov    %esp,%ebp
  802e56:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802e59:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5c:	83 e0 01             	and    $0x1,%eax
  802e5f:	85 c0                	test   %eax,%eax
  802e61:	74 03                	je     802e66 <alloc_block_FF+0x13>
  802e63:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802e66:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802e6a:	77 07                	ja     802e73 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802e6c:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802e73:	a1 40 50 98 00       	mov    0x985040,%eax
  802e78:	85 c0                	test   %eax,%eax
  802e7a:	75 63                	jne    802edf <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7f:	83 c0 10             	add    $0x10,%eax
  802e82:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802e85:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802e8c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e92:	01 d0                	add    %edx,%eax
  802e94:	48                   	dec    %eax
  802e95:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802e98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e9b:	ba 00 00 00 00       	mov    $0x0,%edx
  802ea0:	f7 75 ec             	divl   -0x14(%ebp)
  802ea3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea6:	29 d0                	sub    %edx,%eax
  802ea8:	c1 e8 0c             	shr    $0xc,%eax
  802eab:	83 ec 0c             	sub    $0xc,%esp
  802eae:	50                   	push   %eax
  802eaf:	e8 d1 ed ff ff       	call   801c85 <sbrk>
  802eb4:	83 c4 10             	add    $0x10,%esp
  802eb7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802eba:	83 ec 0c             	sub    $0xc,%esp
  802ebd:	6a 00                	push   $0x0
  802ebf:	e8 c1 ed ff ff       	call   801c85 <sbrk>
  802ec4:	83 c4 10             	add    $0x10,%esp
  802ec7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802eca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ecd:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802ed0:	83 ec 08             	sub    $0x8,%esp
  802ed3:	50                   	push   %eax
  802ed4:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ed7:	e8 75 fc ff ff       	call   802b51 <initialize_dynamic_allocator>
  802edc:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  802edf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ee3:	75 0a                	jne    802eef <alloc_block_FF+0x9c>
	{
		return NULL;
  802ee5:	b8 00 00 00 00       	mov    $0x0,%eax
  802eea:	e9 99 03 00 00       	jmp    803288 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802eef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef2:	83 c0 08             	add    $0x8,%eax
  802ef5:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802ef8:	a1 48 50 98 00       	mov    0x985048,%eax
  802efd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f00:	e9 03 02 00 00       	jmp    803108 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802f05:	83 ec 0c             	sub    $0xc,%esp
  802f08:	ff 75 f4             	pushl  -0xc(%ebp)
  802f0b:	e8 dd fa ff ff       	call   8029ed <get_block_size>
  802f10:	83 c4 10             	add    $0x10,%esp
  802f13:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802f16:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802f19:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802f1c:	0f 82 de 01 00 00    	jb     803100 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  802f22:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f25:	83 c0 10             	add    $0x10,%eax
  802f28:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802f2b:	0f 87 32 01 00 00    	ja     803063 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  802f31:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802f34:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802f37:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802f3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f40:	01 d0                	add    %edx,%eax
  802f42:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  802f45:	83 ec 04             	sub    $0x4,%esp
  802f48:	6a 00                	push   $0x0
  802f4a:	ff 75 98             	pushl  -0x68(%ebp)
  802f4d:	ff 75 94             	pushl  -0x6c(%ebp)
  802f50:	e8 14 fd ff ff       	call   802c69 <set_block_data>
  802f55:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802f58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f5c:	74 06                	je     802f64 <alloc_block_FF+0x111>
  802f5e:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  802f62:	75 17                	jne    802f7b <alloc_block_FF+0x128>
  802f64:	83 ec 04             	sub    $0x4,%esp
  802f67:	68 cc 48 80 00       	push   $0x8048cc
  802f6c:	68 de 00 00 00       	push   $0xde
  802f71:	68 57 48 80 00       	push   $0x804857
  802f76:	e8 b3 dc ff ff       	call   800c2e <_panic>
  802f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7e:	8b 10                	mov    (%eax),%edx
  802f80:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802f83:	89 10                	mov    %edx,(%eax)
  802f85:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802f88:	8b 00                	mov    (%eax),%eax
  802f8a:	85 c0                	test   %eax,%eax
  802f8c:	74 0b                	je     802f99 <alloc_block_FF+0x146>
  802f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f91:	8b 00                	mov    (%eax),%eax
  802f93:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802f96:	89 50 04             	mov    %edx,0x4(%eax)
  802f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9c:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802f9f:	89 10                	mov    %edx,(%eax)
  802fa1:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802fa4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fa7:	89 50 04             	mov    %edx,0x4(%eax)
  802faa:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802fad:	8b 00                	mov    (%eax),%eax
  802faf:	85 c0                	test   %eax,%eax
  802fb1:	75 08                	jne    802fbb <alloc_block_FF+0x168>
  802fb3:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802fb6:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802fbb:	a1 54 50 98 00       	mov    0x985054,%eax
  802fc0:	40                   	inc    %eax
  802fc1:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802fc6:	83 ec 04             	sub    $0x4,%esp
  802fc9:	6a 01                	push   $0x1
  802fcb:	ff 75 dc             	pushl  -0x24(%ebp)
  802fce:	ff 75 f4             	pushl  -0xc(%ebp)
  802fd1:	e8 93 fc ff ff       	call   802c69 <set_block_data>
  802fd6:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802fd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fdd:	75 17                	jne    802ff6 <alloc_block_FF+0x1a3>
  802fdf:	83 ec 04             	sub    $0x4,%esp
  802fe2:	68 00 49 80 00       	push   $0x804900
  802fe7:	68 e3 00 00 00       	push   $0xe3
  802fec:	68 57 48 80 00       	push   $0x804857
  802ff1:	e8 38 dc ff ff       	call   800c2e <_panic>
  802ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff9:	8b 00                	mov    (%eax),%eax
  802ffb:	85 c0                	test   %eax,%eax
  802ffd:	74 10                	je     80300f <alloc_block_FF+0x1bc>
  802fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803002:	8b 00                	mov    (%eax),%eax
  803004:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803007:	8b 52 04             	mov    0x4(%edx),%edx
  80300a:	89 50 04             	mov    %edx,0x4(%eax)
  80300d:	eb 0b                	jmp    80301a <alloc_block_FF+0x1c7>
  80300f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803012:	8b 40 04             	mov    0x4(%eax),%eax
  803015:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80301a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301d:	8b 40 04             	mov    0x4(%eax),%eax
  803020:	85 c0                	test   %eax,%eax
  803022:	74 0f                	je     803033 <alloc_block_FF+0x1e0>
  803024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803027:	8b 40 04             	mov    0x4(%eax),%eax
  80302a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80302d:	8b 12                	mov    (%edx),%edx
  80302f:	89 10                	mov    %edx,(%eax)
  803031:	eb 0a                	jmp    80303d <alloc_block_FF+0x1ea>
  803033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803036:	8b 00                	mov    (%eax),%eax
  803038:	a3 48 50 98 00       	mov    %eax,0x985048
  80303d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803040:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803049:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803050:	a1 54 50 98 00       	mov    0x985054,%eax
  803055:	48                   	dec    %eax
  803056:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  80305b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305e:	e9 25 02 00 00       	jmp    803288 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  803063:	83 ec 04             	sub    $0x4,%esp
  803066:	6a 01                	push   $0x1
  803068:	ff 75 9c             	pushl  -0x64(%ebp)
  80306b:	ff 75 f4             	pushl  -0xc(%ebp)
  80306e:	e8 f6 fb ff ff       	call   802c69 <set_block_data>
  803073:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  803076:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80307a:	75 17                	jne    803093 <alloc_block_FF+0x240>
  80307c:	83 ec 04             	sub    $0x4,%esp
  80307f:	68 00 49 80 00       	push   $0x804900
  803084:	68 eb 00 00 00       	push   $0xeb
  803089:	68 57 48 80 00       	push   $0x804857
  80308e:	e8 9b db ff ff       	call   800c2e <_panic>
  803093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803096:	8b 00                	mov    (%eax),%eax
  803098:	85 c0                	test   %eax,%eax
  80309a:	74 10                	je     8030ac <alloc_block_FF+0x259>
  80309c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309f:	8b 00                	mov    (%eax),%eax
  8030a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030a4:	8b 52 04             	mov    0x4(%edx),%edx
  8030a7:	89 50 04             	mov    %edx,0x4(%eax)
  8030aa:	eb 0b                	jmp    8030b7 <alloc_block_FF+0x264>
  8030ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030af:	8b 40 04             	mov    0x4(%eax),%eax
  8030b2:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8030b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ba:	8b 40 04             	mov    0x4(%eax),%eax
  8030bd:	85 c0                	test   %eax,%eax
  8030bf:	74 0f                	je     8030d0 <alloc_block_FF+0x27d>
  8030c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c4:	8b 40 04             	mov    0x4(%eax),%eax
  8030c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030ca:	8b 12                	mov    (%edx),%edx
  8030cc:	89 10                	mov    %edx,(%eax)
  8030ce:	eb 0a                	jmp    8030da <alloc_block_FF+0x287>
  8030d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d3:	8b 00                	mov    (%eax),%eax
  8030d5:	a3 48 50 98 00       	mov    %eax,0x985048
  8030da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ed:	a1 54 50 98 00       	mov    0x985054,%eax
  8030f2:	48                   	dec    %eax
  8030f3:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  8030f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fb:	e9 88 01 00 00       	jmp    803288 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803100:	a1 50 50 98 00       	mov    0x985050,%eax
  803105:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803108:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80310c:	74 07                	je     803115 <alloc_block_FF+0x2c2>
  80310e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803111:	8b 00                	mov    (%eax),%eax
  803113:	eb 05                	jmp    80311a <alloc_block_FF+0x2c7>
  803115:	b8 00 00 00 00       	mov    $0x0,%eax
  80311a:	a3 50 50 98 00       	mov    %eax,0x985050
  80311f:	a1 50 50 98 00       	mov    0x985050,%eax
  803124:	85 c0                	test   %eax,%eax
  803126:	0f 85 d9 fd ff ff    	jne    802f05 <alloc_block_FF+0xb2>
  80312c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803130:	0f 85 cf fd ff ff    	jne    802f05 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  803136:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80313d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803140:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803143:	01 d0                	add    %edx,%eax
  803145:	48                   	dec    %eax
  803146:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803149:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80314c:	ba 00 00 00 00       	mov    $0x0,%edx
  803151:	f7 75 d8             	divl   -0x28(%ebp)
  803154:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803157:	29 d0                	sub    %edx,%eax
  803159:	c1 e8 0c             	shr    $0xc,%eax
  80315c:	83 ec 0c             	sub    $0xc,%esp
  80315f:	50                   	push   %eax
  803160:	e8 20 eb ff ff       	call   801c85 <sbrk>
  803165:	83 c4 10             	add    $0x10,%esp
  803168:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  80316b:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80316f:	75 0a                	jne    80317b <alloc_block_FF+0x328>
		return NULL;
  803171:	b8 00 00 00 00       	mov    $0x0,%eax
  803176:	e9 0d 01 00 00       	jmp    803288 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  80317b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80317e:	83 e8 04             	sub    $0x4,%eax
  803181:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  803184:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  80318b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80318e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803191:	01 d0                	add    %edx,%eax
  803193:	48                   	dec    %eax
  803194:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  803197:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80319a:	ba 00 00 00 00       	mov    $0x0,%edx
  80319f:	f7 75 c8             	divl   -0x38(%ebp)
  8031a2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8031a5:	29 d0                	sub    %edx,%eax
  8031a7:	c1 e8 02             	shr    $0x2,%eax
  8031aa:	c1 e0 02             	shl    $0x2,%eax
  8031ad:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  8031b0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  8031b9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031bc:	83 e8 08             	sub    $0x8,%eax
  8031bf:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  8031c2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8031c5:	8b 00                	mov    (%eax),%eax
  8031c7:	83 e0 fe             	and    $0xfffffffe,%eax
  8031ca:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  8031cd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8031d0:	f7 d8                	neg    %eax
  8031d2:	89 c2                	mov    %eax,%edx
  8031d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031d7:	01 d0                	add    %edx,%eax
  8031d9:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  8031dc:	83 ec 0c             	sub    $0xc,%esp
  8031df:	ff 75 b8             	pushl  -0x48(%ebp)
  8031e2:	e8 1f f8 ff ff       	call   802a06 <is_free_block>
  8031e7:	83 c4 10             	add    $0x10,%esp
  8031ea:	0f be c0             	movsbl %al,%eax
  8031ed:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  8031f0:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8031f4:	74 42                	je     803238 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  8031f6:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8031fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803200:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803203:	01 d0                	add    %edx,%eax
  803205:	48                   	dec    %eax
  803206:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803209:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80320c:	ba 00 00 00 00       	mov    $0x0,%edx
  803211:	f7 75 b0             	divl   -0x50(%ebp)
  803214:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803217:	29 d0                	sub    %edx,%eax
  803219:	89 c2                	mov    %eax,%edx
  80321b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80321e:	01 d0                	add    %edx,%eax
  803220:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  803223:	83 ec 04             	sub    $0x4,%esp
  803226:	6a 00                	push   $0x0
  803228:	ff 75 a8             	pushl  -0x58(%ebp)
  80322b:	ff 75 b8             	pushl  -0x48(%ebp)
  80322e:	e8 36 fa ff ff       	call   802c69 <set_block_data>
  803233:	83 c4 10             	add    $0x10,%esp
  803236:	eb 42                	jmp    80327a <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  803238:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  80323f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803242:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803245:	01 d0                	add    %edx,%eax
  803247:	48                   	dec    %eax
  803248:	89 45 a0             	mov    %eax,-0x60(%ebp)
  80324b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80324e:	ba 00 00 00 00       	mov    $0x0,%edx
  803253:	f7 75 a4             	divl   -0x5c(%ebp)
  803256:	8b 45 a0             	mov    -0x60(%ebp),%eax
  803259:	29 d0                	sub    %edx,%eax
  80325b:	83 ec 04             	sub    $0x4,%esp
  80325e:	6a 00                	push   $0x0
  803260:	50                   	push   %eax
  803261:	ff 75 d0             	pushl  -0x30(%ebp)
  803264:	e8 00 fa ff ff       	call   802c69 <set_block_data>
  803269:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  80326c:	83 ec 0c             	sub    $0xc,%esp
  80326f:	ff 75 d0             	pushl  -0x30(%ebp)
  803272:	e8 49 fa ff ff       	call   802cc0 <insert_sorted_in_freeList>
  803277:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  80327a:	83 ec 0c             	sub    $0xc,%esp
  80327d:	ff 75 08             	pushl  0x8(%ebp)
  803280:	e8 ce fb ff ff       	call   802e53 <alloc_block_FF>
  803285:	83 c4 10             	add    $0x10,%esp
}
  803288:	c9                   	leave  
  803289:	c3                   	ret    

0080328a <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80328a:	55                   	push   %ebp
  80328b:	89 e5                	mov    %esp,%ebp
  80328d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  803290:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803294:	75 0a                	jne    8032a0 <alloc_block_BF+0x16>
	{
		return NULL;
  803296:	b8 00 00 00 00       	mov    $0x0,%eax
  80329b:	e9 7a 02 00 00       	jmp    80351a <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  8032a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a3:	83 c0 08             	add    $0x8,%eax
  8032a6:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  8032a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  8032b0:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8032b7:	a1 48 50 98 00       	mov    0x985048,%eax
  8032bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8032bf:	eb 32                	jmp    8032f3 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  8032c1:	ff 75 ec             	pushl  -0x14(%ebp)
  8032c4:	e8 24 f7 ff ff       	call   8029ed <get_block_size>
  8032c9:	83 c4 04             	add    $0x4,%esp
  8032cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  8032cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032d5:	72 14                	jb     8032eb <alloc_block_BF+0x61>
  8032d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032da:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8032dd:	73 0c                	jae    8032eb <alloc_block_BF+0x61>
		{
			minBlk = block;
  8032df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  8032e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8032eb:	a1 50 50 98 00       	mov    0x985050,%eax
  8032f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8032f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032f7:	74 07                	je     803300 <alloc_block_BF+0x76>
  8032f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032fc:	8b 00                	mov    (%eax),%eax
  8032fe:	eb 05                	jmp    803305 <alloc_block_BF+0x7b>
  803300:	b8 00 00 00 00       	mov    $0x0,%eax
  803305:	a3 50 50 98 00       	mov    %eax,0x985050
  80330a:	a1 50 50 98 00       	mov    0x985050,%eax
  80330f:	85 c0                	test   %eax,%eax
  803311:	75 ae                	jne    8032c1 <alloc_block_BF+0x37>
  803313:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803317:	75 a8                	jne    8032c1 <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  803319:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80331d:	75 22                	jne    803341 <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  80331f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803322:	83 ec 0c             	sub    $0xc,%esp
  803325:	50                   	push   %eax
  803326:	e8 5a e9 ff ff       	call   801c85 <sbrk>
  80332b:	83 c4 10             	add    $0x10,%esp
  80332e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  803331:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  803335:	75 0a                	jne    803341 <alloc_block_BF+0xb7>
			return NULL;
  803337:	b8 00 00 00 00       	mov    $0x0,%eax
  80333c:	e9 d9 01 00 00       	jmp    80351a <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  803341:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803344:	83 c0 10             	add    $0x10,%eax
  803347:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80334a:	0f 87 32 01 00 00    	ja     803482 <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  803350:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803353:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803356:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  803359:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80335c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335f:	01 d0                	add    %edx,%eax
  803361:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  803364:	83 ec 04             	sub    $0x4,%esp
  803367:	6a 00                	push   $0x0
  803369:	ff 75 dc             	pushl  -0x24(%ebp)
  80336c:	ff 75 d8             	pushl  -0x28(%ebp)
  80336f:	e8 f5 f8 ff ff       	call   802c69 <set_block_data>
  803374:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  803377:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80337b:	74 06                	je     803383 <alloc_block_BF+0xf9>
  80337d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803381:	75 17                	jne    80339a <alloc_block_BF+0x110>
  803383:	83 ec 04             	sub    $0x4,%esp
  803386:	68 cc 48 80 00       	push   $0x8048cc
  80338b:	68 49 01 00 00       	push   $0x149
  803390:	68 57 48 80 00       	push   $0x804857
  803395:	e8 94 d8 ff ff       	call   800c2e <_panic>
  80339a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339d:	8b 10                	mov    (%eax),%edx
  80339f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033a2:	89 10                	mov    %edx,(%eax)
  8033a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033a7:	8b 00                	mov    (%eax),%eax
  8033a9:	85 c0                	test   %eax,%eax
  8033ab:	74 0b                	je     8033b8 <alloc_block_BF+0x12e>
  8033ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b0:	8b 00                	mov    (%eax),%eax
  8033b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033b5:	89 50 04             	mov    %edx,0x4(%eax)
  8033b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033be:	89 10                	mov    %edx,(%eax)
  8033c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033c6:	89 50 04             	mov    %edx,0x4(%eax)
  8033c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033cc:	8b 00                	mov    (%eax),%eax
  8033ce:	85 c0                	test   %eax,%eax
  8033d0:	75 08                	jne    8033da <alloc_block_BF+0x150>
  8033d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033d5:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8033da:	a1 54 50 98 00       	mov    0x985054,%eax
  8033df:	40                   	inc    %eax
  8033e0:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  8033e5:	83 ec 04             	sub    $0x4,%esp
  8033e8:	6a 01                	push   $0x1
  8033ea:	ff 75 e8             	pushl  -0x18(%ebp)
  8033ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8033f0:	e8 74 f8 ff ff       	call   802c69 <set_block_data>
  8033f5:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  8033f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033fc:	75 17                	jne    803415 <alloc_block_BF+0x18b>
  8033fe:	83 ec 04             	sub    $0x4,%esp
  803401:	68 00 49 80 00       	push   $0x804900
  803406:	68 4e 01 00 00       	push   $0x14e
  80340b:	68 57 48 80 00       	push   $0x804857
  803410:	e8 19 d8 ff ff       	call   800c2e <_panic>
  803415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803418:	8b 00                	mov    (%eax),%eax
  80341a:	85 c0                	test   %eax,%eax
  80341c:	74 10                	je     80342e <alloc_block_BF+0x1a4>
  80341e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803421:	8b 00                	mov    (%eax),%eax
  803423:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803426:	8b 52 04             	mov    0x4(%edx),%edx
  803429:	89 50 04             	mov    %edx,0x4(%eax)
  80342c:	eb 0b                	jmp    803439 <alloc_block_BF+0x1af>
  80342e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803431:	8b 40 04             	mov    0x4(%eax),%eax
  803434:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343c:	8b 40 04             	mov    0x4(%eax),%eax
  80343f:	85 c0                	test   %eax,%eax
  803441:	74 0f                	je     803452 <alloc_block_BF+0x1c8>
  803443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803446:	8b 40 04             	mov    0x4(%eax),%eax
  803449:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80344c:	8b 12                	mov    (%edx),%edx
  80344e:	89 10                	mov    %edx,(%eax)
  803450:	eb 0a                	jmp    80345c <alloc_block_BF+0x1d2>
  803452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803455:	8b 00                	mov    (%eax),%eax
  803457:	a3 48 50 98 00       	mov    %eax,0x985048
  80345c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803468:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80346f:	a1 54 50 98 00       	mov    0x985054,%eax
  803474:	48                   	dec    %eax
  803475:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  80347a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347d:	e9 98 00 00 00       	jmp    80351a <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  803482:	83 ec 04             	sub    $0x4,%esp
  803485:	6a 01                	push   $0x1
  803487:	ff 75 f0             	pushl  -0x10(%ebp)
  80348a:	ff 75 f4             	pushl  -0xc(%ebp)
  80348d:	e8 d7 f7 ff ff       	call   802c69 <set_block_data>
  803492:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  803495:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803499:	75 17                	jne    8034b2 <alloc_block_BF+0x228>
  80349b:	83 ec 04             	sub    $0x4,%esp
  80349e:	68 00 49 80 00       	push   $0x804900
  8034a3:	68 56 01 00 00       	push   $0x156
  8034a8:	68 57 48 80 00       	push   $0x804857
  8034ad:	e8 7c d7 ff ff       	call   800c2e <_panic>
  8034b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b5:	8b 00                	mov    (%eax),%eax
  8034b7:	85 c0                	test   %eax,%eax
  8034b9:	74 10                	je     8034cb <alloc_block_BF+0x241>
  8034bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034be:	8b 00                	mov    (%eax),%eax
  8034c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034c3:	8b 52 04             	mov    0x4(%edx),%edx
  8034c6:	89 50 04             	mov    %edx,0x4(%eax)
  8034c9:	eb 0b                	jmp    8034d6 <alloc_block_BF+0x24c>
  8034cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ce:	8b 40 04             	mov    0x4(%eax),%eax
  8034d1:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8034d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d9:	8b 40 04             	mov    0x4(%eax),%eax
  8034dc:	85 c0                	test   %eax,%eax
  8034de:	74 0f                	je     8034ef <alloc_block_BF+0x265>
  8034e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e3:	8b 40 04             	mov    0x4(%eax),%eax
  8034e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034e9:	8b 12                	mov    (%edx),%edx
  8034eb:	89 10                	mov    %edx,(%eax)
  8034ed:	eb 0a                	jmp    8034f9 <alloc_block_BF+0x26f>
  8034ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f2:	8b 00                	mov    (%eax),%eax
  8034f4:	a3 48 50 98 00       	mov    %eax,0x985048
  8034f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803505:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80350c:	a1 54 50 98 00       	mov    0x985054,%eax
  803511:	48                   	dec    %eax
  803512:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  803517:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  80351a:	c9                   	leave  
  80351b:	c3                   	ret    

0080351c <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80351c:	55                   	push   %ebp
  80351d:	89 e5                	mov    %esp,%ebp
  80351f:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  803522:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803526:	0f 84 6a 02 00 00    	je     803796 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  80352c:	ff 75 08             	pushl  0x8(%ebp)
  80352f:	e8 b9 f4 ff ff       	call   8029ed <get_block_size>
  803534:	83 c4 04             	add    $0x4,%esp
  803537:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  80353a:	8b 45 08             	mov    0x8(%ebp),%eax
  80353d:	83 e8 08             	sub    $0x8,%eax
  803540:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  803543:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803546:	8b 00                	mov    (%eax),%eax
  803548:	83 e0 fe             	and    $0xfffffffe,%eax
  80354b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  80354e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803551:	f7 d8                	neg    %eax
  803553:	89 c2                	mov    %eax,%edx
  803555:	8b 45 08             	mov    0x8(%ebp),%eax
  803558:	01 d0                	add    %edx,%eax
  80355a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  80355d:	ff 75 e8             	pushl  -0x18(%ebp)
  803560:	e8 a1 f4 ff ff       	call   802a06 <is_free_block>
  803565:	83 c4 04             	add    $0x4,%esp
  803568:	0f be c0             	movsbl %al,%eax
  80356b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  80356e:	8b 55 08             	mov    0x8(%ebp),%edx
  803571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803574:	01 d0                	add    %edx,%eax
  803576:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  803579:	ff 75 e0             	pushl  -0x20(%ebp)
  80357c:	e8 85 f4 ff ff       	call   802a06 <is_free_block>
  803581:	83 c4 04             	add    $0x4,%esp
  803584:	0f be c0             	movsbl %al,%eax
  803587:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  80358a:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  80358e:	75 34                	jne    8035c4 <free_block+0xa8>
  803590:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803594:	75 2e                	jne    8035c4 <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  803596:	ff 75 e8             	pushl  -0x18(%ebp)
  803599:	e8 4f f4 ff ff       	call   8029ed <get_block_size>
  80359e:	83 c4 04             	add    $0x4,%esp
  8035a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  8035a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035aa:	01 d0                	add    %edx,%eax
  8035ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  8035af:	6a 00                	push   $0x0
  8035b1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8035b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8035b7:	e8 ad f6 ff ff       	call   802c69 <set_block_data>
  8035bc:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  8035bf:	e9 d3 01 00 00       	jmp    803797 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  8035c4:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  8035c8:	0f 85 c8 00 00 00    	jne    803696 <free_block+0x17a>
  8035ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035d2:	0f 85 be 00 00 00    	jne    803696 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  8035d8:	ff 75 e0             	pushl  -0x20(%ebp)
  8035db:	e8 0d f4 ff ff       	call   8029ed <get_block_size>
  8035e0:	83 c4 04             	add    $0x4,%esp
  8035e3:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  8035e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035e9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8035ec:	01 d0                	add    %edx,%eax
  8035ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  8035f1:	6a 00                	push   $0x0
  8035f3:	ff 75 cc             	pushl  -0x34(%ebp)
  8035f6:	ff 75 08             	pushl  0x8(%ebp)
  8035f9:	e8 6b f6 ff ff       	call   802c69 <set_block_data>
  8035fe:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  803601:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803605:	75 17                	jne    80361e <free_block+0x102>
  803607:	83 ec 04             	sub    $0x4,%esp
  80360a:	68 00 49 80 00       	push   $0x804900
  80360f:	68 87 01 00 00       	push   $0x187
  803614:	68 57 48 80 00       	push   $0x804857
  803619:	e8 10 d6 ff ff       	call   800c2e <_panic>
  80361e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803621:	8b 00                	mov    (%eax),%eax
  803623:	85 c0                	test   %eax,%eax
  803625:	74 10                	je     803637 <free_block+0x11b>
  803627:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80362a:	8b 00                	mov    (%eax),%eax
  80362c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80362f:	8b 52 04             	mov    0x4(%edx),%edx
  803632:	89 50 04             	mov    %edx,0x4(%eax)
  803635:	eb 0b                	jmp    803642 <free_block+0x126>
  803637:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80363a:	8b 40 04             	mov    0x4(%eax),%eax
  80363d:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803642:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803645:	8b 40 04             	mov    0x4(%eax),%eax
  803648:	85 c0                	test   %eax,%eax
  80364a:	74 0f                	je     80365b <free_block+0x13f>
  80364c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80364f:	8b 40 04             	mov    0x4(%eax),%eax
  803652:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803655:	8b 12                	mov    (%edx),%edx
  803657:	89 10                	mov    %edx,(%eax)
  803659:	eb 0a                	jmp    803665 <free_block+0x149>
  80365b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80365e:	8b 00                	mov    (%eax),%eax
  803660:	a3 48 50 98 00       	mov    %eax,0x985048
  803665:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803668:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80366e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803671:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803678:	a1 54 50 98 00       	mov    0x985054,%eax
  80367d:	48                   	dec    %eax
  80367e:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  803683:	83 ec 0c             	sub    $0xc,%esp
  803686:	ff 75 08             	pushl  0x8(%ebp)
  803689:	e8 32 f6 ff ff       	call   802cc0 <insert_sorted_in_freeList>
  80368e:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  803691:	e9 01 01 00 00       	jmp    803797 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  803696:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  80369a:	0f 85 d3 00 00 00    	jne    803773 <free_block+0x257>
  8036a0:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  8036a4:	0f 85 c9 00 00 00    	jne    803773 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  8036aa:	83 ec 0c             	sub    $0xc,%esp
  8036ad:	ff 75 e8             	pushl  -0x18(%ebp)
  8036b0:	e8 38 f3 ff ff       	call   8029ed <get_block_size>
  8036b5:	83 c4 10             	add    $0x10,%esp
  8036b8:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  8036bb:	83 ec 0c             	sub    $0xc,%esp
  8036be:	ff 75 e0             	pushl  -0x20(%ebp)
  8036c1:	e8 27 f3 ff ff       	call   8029ed <get_block_size>
  8036c6:	83 c4 10             	add    $0x10,%esp
  8036c9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  8036cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036cf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8036d2:	01 c2                	add    %eax,%edx
  8036d4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8036d7:	01 d0                	add    %edx,%eax
  8036d9:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  8036dc:	83 ec 04             	sub    $0x4,%esp
  8036df:	6a 00                	push   $0x0
  8036e1:	ff 75 c0             	pushl  -0x40(%ebp)
  8036e4:	ff 75 e8             	pushl  -0x18(%ebp)
  8036e7:	e8 7d f5 ff ff       	call   802c69 <set_block_data>
  8036ec:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  8036ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8036f3:	75 17                	jne    80370c <free_block+0x1f0>
  8036f5:	83 ec 04             	sub    $0x4,%esp
  8036f8:	68 00 49 80 00       	push   $0x804900
  8036fd:	68 94 01 00 00       	push   $0x194
  803702:	68 57 48 80 00       	push   $0x804857
  803707:	e8 22 d5 ff ff       	call   800c2e <_panic>
  80370c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80370f:	8b 00                	mov    (%eax),%eax
  803711:	85 c0                	test   %eax,%eax
  803713:	74 10                	je     803725 <free_block+0x209>
  803715:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803718:	8b 00                	mov    (%eax),%eax
  80371a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80371d:	8b 52 04             	mov    0x4(%edx),%edx
  803720:	89 50 04             	mov    %edx,0x4(%eax)
  803723:	eb 0b                	jmp    803730 <free_block+0x214>
  803725:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803728:	8b 40 04             	mov    0x4(%eax),%eax
  80372b:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803730:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803733:	8b 40 04             	mov    0x4(%eax),%eax
  803736:	85 c0                	test   %eax,%eax
  803738:	74 0f                	je     803749 <free_block+0x22d>
  80373a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80373d:	8b 40 04             	mov    0x4(%eax),%eax
  803740:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803743:	8b 12                	mov    (%edx),%edx
  803745:	89 10                	mov    %edx,(%eax)
  803747:	eb 0a                	jmp    803753 <free_block+0x237>
  803749:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80374c:	8b 00                	mov    (%eax),%eax
  80374e:	a3 48 50 98 00       	mov    %eax,0x985048
  803753:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803756:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80375c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80375f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803766:	a1 54 50 98 00       	mov    0x985054,%eax
  80376b:	48                   	dec    %eax
  80376c:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  803771:	eb 24                	jmp    803797 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  803773:	83 ec 04             	sub    $0x4,%esp
  803776:	6a 00                	push   $0x0
  803778:	ff 75 f4             	pushl  -0xc(%ebp)
  80377b:	ff 75 08             	pushl  0x8(%ebp)
  80377e:	e8 e6 f4 ff ff       	call   802c69 <set_block_data>
  803783:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  803786:	83 ec 0c             	sub    $0xc,%esp
  803789:	ff 75 08             	pushl  0x8(%ebp)
  80378c:	e8 2f f5 ff ff       	call   802cc0 <insert_sorted_in_freeList>
  803791:	83 c4 10             	add    $0x10,%esp
  803794:	eb 01                	jmp    803797 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  803796:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  803797:	c9                   	leave  
  803798:	c3                   	ret    

00803799 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  803799:	55                   	push   %ebp
  80379a:	89 e5                	mov    %esp,%ebp
  80379c:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  80379f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037a3:	75 10                	jne    8037b5 <realloc_block_FF+0x1c>
  8037a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037a9:	75 0a                	jne    8037b5 <realloc_block_FF+0x1c>
	{
		return NULL;
  8037ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8037b0:	e9 8b 04 00 00       	jmp    803c40 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  8037b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037b9:	75 18                	jne    8037d3 <realloc_block_FF+0x3a>
	{
		free_block(va);
  8037bb:	83 ec 0c             	sub    $0xc,%esp
  8037be:	ff 75 08             	pushl  0x8(%ebp)
  8037c1:	e8 56 fd ff ff       	call   80351c <free_block>
  8037c6:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8037c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ce:	e9 6d 04 00 00       	jmp    803c40 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  8037d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037d7:	75 13                	jne    8037ec <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  8037d9:	83 ec 0c             	sub    $0xc,%esp
  8037dc:	ff 75 0c             	pushl  0xc(%ebp)
  8037df:	e8 6f f6 ff ff       	call   802e53 <alloc_block_FF>
  8037e4:	83 c4 10             	add    $0x10,%esp
  8037e7:	e9 54 04 00 00       	jmp    803c40 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  8037ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037ef:	83 e0 01             	and    $0x1,%eax
  8037f2:	85 c0                	test   %eax,%eax
  8037f4:	74 03                	je     8037f9 <realloc_block_FF+0x60>
	{
		new_size++;
  8037f6:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  8037f9:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8037fd:	77 07                	ja     803806 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  8037ff:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  803806:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  80380a:	83 ec 0c             	sub    $0xc,%esp
  80380d:	ff 75 08             	pushl  0x8(%ebp)
  803810:	e8 d8 f1 ff ff       	call   8029ed <get_block_size>
  803815:	83 c4 10             	add    $0x10,%esp
  803818:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  80381b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80381e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803821:	75 08                	jne    80382b <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  803823:	8b 45 08             	mov    0x8(%ebp),%eax
  803826:	e9 15 04 00 00       	jmp    803c40 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  80382b:	8b 55 08             	mov    0x8(%ebp),%edx
  80382e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803831:	01 d0                	add    %edx,%eax
  803833:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  803836:	83 ec 0c             	sub    $0xc,%esp
  803839:	ff 75 f0             	pushl  -0x10(%ebp)
  80383c:	e8 c5 f1 ff ff       	call   802a06 <is_free_block>
  803841:	83 c4 10             	add    $0x10,%esp
  803844:	0f be c0             	movsbl %al,%eax
  803847:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  80384a:	83 ec 0c             	sub    $0xc,%esp
  80384d:	ff 75 f0             	pushl  -0x10(%ebp)
  803850:	e8 98 f1 ff ff       	call   8029ed <get_block_size>
  803855:	83 c4 10             	add    $0x10,%esp
  803858:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  80385b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80385e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803861:	0f 86 a7 02 00 00    	jbe    803b0e <realloc_block_FF+0x375>
	{
		if(isNextFree)
  803867:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80386b:	0f 84 86 02 00 00    	je     803af7 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  803871:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803877:	01 d0                	add    %edx,%eax
  803879:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80387c:	0f 85 b2 00 00 00    	jne    803934 <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  803882:	83 ec 0c             	sub    $0xc,%esp
  803885:	ff 75 08             	pushl  0x8(%ebp)
  803888:	e8 79 f1 ff ff       	call   802a06 <is_free_block>
  80388d:	83 c4 10             	add    $0x10,%esp
  803890:	84 c0                	test   %al,%al
  803892:	0f 94 c0             	sete   %al
  803895:	0f b6 c0             	movzbl %al,%eax
  803898:	83 ec 04             	sub    $0x4,%esp
  80389b:	50                   	push   %eax
  80389c:	ff 75 0c             	pushl  0xc(%ebp)
  80389f:	ff 75 08             	pushl  0x8(%ebp)
  8038a2:	e8 c2 f3 ff ff       	call   802c69 <set_block_data>
  8038a7:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  8038aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038ae:	75 17                	jne    8038c7 <realloc_block_FF+0x12e>
  8038b0:	83 ec 04             	sub    $0x4,%esp
  8038b3:	68 00 49 80 00       	push   $0x804900
  8038b8:	68 db 01 00 00       	push   $0x1db
  8038bd:	68 57 48 80 00       	push   $0x804857
  8038c2:	e8 67 d3 ff ff       	call   800c2e <_panic>
  8038c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ca:	8b 00                	mov    (%eax),%eax
  8038cc:	85 c0                	test   %eax,%eax
  8038ce:	74 10                	je     8038e0 <realloc_block_FF+0x147>
  8038d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d3:	8b 00                	mov    (%eax),%eax
  8038d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038d8:	8b 52 04             	mov    0x4(%edx),%edx
  8038db:	89 50 04             	mov    %edx,0x4(%eax)
  8038de:	eb 0b                	jmp    8038eb <realloc_block_FF+0x152>
  8038e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e3:	8b 40 04             	mov    0x4(%eax),%eax
  8038e6:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8038eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ee:	8b 40 04             	mov    0x4(%eax),%eax
  8038f1:	85 c0                	test   %eax,%eax
  8038f3:	74 0f                	je     803904 <realloc_block_FF+0x16b>
  8038f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038f8:	8b 40 04             	mov    0x4(%eax),%eax
  8038fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038fe:	8b 12                	mov    (%edx),%edx
  803900:	89 10                	mov    %edx,(%eax)
  803902:	eb 0a                	jmp    80390e <realloc_block_FF+0x175>
  803904:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803907:	8b 00                	mov    (%eax),%eax
  803909:	a3 48 50 98 00       	mov    %eax,0x985048
  80390e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803911:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803917:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80391a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803921:	a1 54 50 98 00       	mov    0x985054,%eax
  803926:	48                   	dec    %eax
  803927:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  80392c:	8b 45 08             	mov    0x8(%ebp),%eax
  80392f:	e9 0c 03 00 00       	jmp    803c40 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  803934:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393a:	01 d0                	add    %edx,%eax
  80393c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80393f:	0f 86 b2 01 00 00    	jbe    803af7 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  803945:	8b 45 0c             	mov    0xc(%ebp),%eax
  803948:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80394b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  80394e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803951:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803954:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  803957:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  80395b:	0f 87 b8 00 00 00    	ja     803a19 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  803961:	83 ec 0c             	sub    $0xc,%esp
  803964:	ff 75 08             	pushl  0x8(%ebp)
  803967:	e8 9a f0 ff ff       	call   802a06 <is_free_block>
  80396c:	83 c4 10             	add    $0x10,%esp
  80396f:	84 c0                	test   %al,%al
  803971:	0f 94 c0             	sete   %al
  803974:	0f b6 c0             	movzbl %al,%eax
  803977:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80397a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80397d:	01 ca                	add    %ecx,%edx
  80397f:	83 ec 04             	sub    $0x4,%esp
  803982:	50                   	push   %eax
  803983:	52                   	push   %edx
  803984:	ff 75 08             	pushl  0x8(%ebp)
  803987:	e8 dd f2 ff ff       	call   802c69 <set_block_data>
  80398c:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  80398f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803993:	75 17                	jne    8039ac <realloc_block_FF+0x213>
  803995:	83 ec 04             	sub    $0x4,%esp
  803998:	68 00 49 80 00       	push   $0x804900
  80399d:	68 e8 01 00 00       	push   $0x1e8
  8039a2:	68 57 48 80 00       	push   $0x804857
  8039a7:	e8 82 d2 ff ff       	call   800c2e <_panic>
  8039ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039af:	8b 00                	mov    (%eax),%eax
  8039b1:	85 c0                	test   %eax,%eax
  8039b3:	74 10                	je     8039c5 <realloc_block_FF+0x22c>
  8039b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039b8:	8b 00                	mov    (%eax),%eax
  8039ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039bd:	8b 52 04             	mov    0x4(%edx),%edx
  8039c0:	89 50 04             	mov    %edx,0x4(%eax)
  8039c3:	eb 0b                	jmp    8039d0 <realloc_block_FF+0x237>
  8039c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039c8:	8b 40 04             	mov    0x4(%eax),%eax
  8039cb:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8039d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039d3:	8b 40 04             	mov    0x4(%eax),%eax
  8039d6:	85 c0                	test   %eax,%eax
  8039d8:	74 0f                	je     8039e9 <realloc_block_FF+0x250>
  8039da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039dd:	8b 40 04             	mov    0x4(%eax),%eax
  8039e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039e3:	8b 12                	mov    (%edx),%edx
  8039e5:	89 10                	mov    %edx,(%eax)
  8039e7:	eb 0a                	jmp    8039f3 <realloc_block_FF+0x25a>
  8039e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ec:	8b 00                	mov    (%eax),%eax
  8039ee:	a3 48 50 98 00       	mov    %eax,0x985048
  8039f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a06:	a1 54 50 98 00       	mov    0x985054,%eax
  803a0b:	48                   	dec    %eax
  803a0c:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  803a11:	8b 45 08             	mov    0x8(%ebp),%eax
  803a14:	e9 27 02 00 00       	jmp    803c40 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803a19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a1d:	75 17                	jne    803a36 <realloc_block_FF+0x29d>
  803a1f:	83 ec 04             	sub    $0x4,%esp
  803a22:	68 00 49 80 00       	push   $0x804900
  803a27:	68 ed 01 00 00       	push   $0x1ed
  803a2c:	68 57 48 80 00       	push   $0x804857
  803a31:	e8 f8 d1 ff ff       	call   800c2e <_panic>
  803a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a39:	8b 00                	mov    (%eax),%eax
  803a3b:	85 c0                	test   %eax,%eax
  803a3d:	74 10                	je     803a4f <realloc_block_FF+0x2b6>
  803a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a42:	8b 00                	mov    (%eax),%eax
  803a44:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a47:	8b 52 04             	mov    0x4(%edx),%edx
  803a4a:	89 50 04             	mov    %edx,0x4(%eax)
  803a4d:	eb 0b                	jmp    803a5a <realloc_block_FF+0x2c1>
  803a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a52:	8b 40 04             	mov    0x4(%eax),%eax
  803a55:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a5d:	8b 40 04             	mov    0x4(%eax),%eax
  803a60:	85 c0                	test   %eax,%eax
  803a62:	74 0f                	je     803a73 <realloc_block_FF+0x2da>
  803a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a67:	8b 40 04             	mov    0x4(%eax),%eax
  803a6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a6d:	8b 12                	mov    (%edx),%edx
  803a6f:	89 10                	mov    %edx,(%eax)
  803a71:	eb 0a                	jmp    803a7d <realloc_block_FF+0x2e4>
  803a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a76:	8b 00                	mov    (%eax),%eax
  803a78:	a3 48 50 98 00       	mov    %eax,0x985048
  803a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a90:	a1 54 50 98 00       	mov    0x985054,%eax
  803a95:	48                   	dec    %eax
  803a96:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  803a9b:	8b 55 08             	mov    0x8(%ebp),%edx
  803a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aa1:	01 d0                	add    %edx,%eax
  803aa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  803aa6:	83 ec 04             	sub    $0x4,%esp
  803aa9:	6a 00                	push   $0x0
  803aab:	ff 75 e0             	pushl  -0x20(%ebp)
  803aae:	ff 75 f0             	pushl  -0x10(%ebp)
  803ab1:	e8 b3 f1 ff ff       	call   802c69 <set_block_data>
  803ab6:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  803ab9:	83 ec 0c             	sub    $0xc,%esp
  803abc:	ff 75 08             	pushl  0x8(%ebp)
  803abf:	e8 42 ef ff ff       	call   802a06 <is_free_block>
  803ac4:	83 c4 10             	add    $0x10,%esp
  803ac7:	84 c0                	test   %al,%al
  803ac9:	0f 94 c0             	sete   %al
  803acc:	0f b6 c0             	movzbl %al,%eax
  803acf:	83 ec 04             	sub    $0x4,%esp
  803ad2:	50                   	push   %eax
  803ad3:	ff 75 0c             	pushl  0xc(%ebp)
  803ad6:	ff 75 08             	pushl  0x8(%ebp)
  803ad9:	e8 8b f1 ff ff       	call   802c69 <set_block_data>
  803ade:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  803ae1:	83 ec 0c             	sub    $0xc,%esp
  803ae4:	ff 75 f0             	pushl  -0x10(%ebp)
  803ae7:	e8 d4 f1 ff ff       	call   802cc0 <insert_sorted_in_freeList>
  803aec:	83 c4 10             	add    $0x10,%esp
					return va;
  803aef:	8b 45 08             	mov    0x8(%ebp),%eax
  803af2:	e9 49 01 00 00       	jmp    803c40 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803af7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803afa:	83 e8 08             	sub    $0x8,%eax
  803afd:	83 ec 0c             	sub    $0xc,%esp
  803b00:	50                   	push   %eax
  803b01:	e8 4d f3 ff ff       	call   802e53 <alloc_block_FF>
  803b06:	83 c4 10             	add    $0x10,%esp
  803b09:	e9 32 01 00 00       	jmp    803c40 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  803b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b11:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803b14:	0f 83 21 01 00 00    	jae    803c3b <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  803b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b1d:	2b 45 0c             	sub    0xc(%ebp),%eax
  803b20:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  803b23:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  803b27:	77 0e                	ja     803b37 <realloc_block_FF+0x39e>
  803b29:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b2d:	75 08                	jne    803b37 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  803b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b32:	e9 09 01 00 00       	jmp    803c40 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  803b37:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  803b3d:	83 ec 0c             	sub    $0xc,%esp
  803b40:	ff 75 08             	pushl  0x8(%ebp)
  803b43:	e8 be ee ff ff       	call   802a06 <is_free_block>
  803b48:	83 c4 10             	add    $0x10,%esp
  803b4b:	84 c0                	test   %al,%al
  803b4d:	0f 94 c0             	sete   %al
  803b50:	0f b6 c0             	movzbl %al,%eax
  803b53:	83 ec 04             	sub    $0x4,%esp
  803b56:	50                   	push   %eax
  803b57:	ff 75 0c             	pushl  0xc(%ebp)
  803b5a:	ff 75 d8             	pushl  -0x28(%ebp)
  803b5d:	e8 07 f1 ff ff       	call   802c69 <set_block_data>
  803b62:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  803b65:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803b68:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b6b:	01 d0                	add    %edx,%eax
  803b6d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  803b70:	83 ec 04             	sub    $0x4,%esp
  803b73:	6a 00                	push   $0x0
  803b75:	ff 75 dc             	pushl  -0x24(%ebp)
  803b78:	ff 75 d4             	pushl  -0x2c(%ebp)
  803b7b:	e8 e9 f0 ff ff       	call   802c69 <set_block_data>
  803b80:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  803b83:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b87:	0f 84 9b 00 00 00    	je     803c28 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  803b8d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b93:	01 d0                	add    %edx,%eax
  803b95:	83 ec 04             	sub    $0x4,%esp
  803b98:	6a 00                	push   $0x0
  803b9a:	50                   	push   %eax
  803b9b:	ff 75 d4             	pushl  -0x2c(%ebp)
  803b9e:	e8 c6 f0 ff ff       	call   802c69 <set_block_data>
  803ba3:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  803ba6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803baa:	75 17                	jne    803bc3 <realloc_block_FF+0x42a>
  803bac:	83 ec 04             	sub    $0x4,%esp
  803baf:	68 00 49 80 00       	push   $0x804900
  803bb4:	68 10 02 00 00       	push   $0x210
  803bb9:	68 57 48 80 00       	push   $0x804857
  803bbe:	e8 6b d0 ff ff       	call   800c2e <_panic>
  803bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bc6:	8b 00                	mov    (%eax),%eax
  803bc8:	85 c0                	test   %eax,%eax
  803bca:	74 10                	je     803bdc <realloc_block_FF+0x443>
  803bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bcf:	8b 00                	mov    (%eax),%eax
  803bd1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bd4:	8b 52 04             	mov    0x4(%edx),%edx
  803bd7:	89 50 04             	mov    %edx,0x4(%eax)
  803bda:	eb 0b                	jmp    803be7 <realloc_block_FF+0x44e>
  803bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bdf:	8b 40 04             	mov    0x4(%eax),%eax
  803be2:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bea:	8b 40 04             	mov    0x4(%eax),%eax
  803bed:	85 c0                	test   %eax,%eax
  803bef:	74 0f                	je     803c00 <realloc_block_FF+0x467>
  803bf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bf4:	8b 40 04             	mov    0x4(%eax),%eax
  803bf7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bfa:	8b 12                	mov    (%edx),%edx
  803bfc:	89 10                	mov    %edx,(%eax)
  803bfe:	eb 0a                	jmp    803c0a <realloc_block_FF+0x471>
  803c00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c03:	8b 00                	mov    (%eax),%eax
  803c05:	a3 48 50 98 00       	mov    %eax,0x985048
  803c0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c1d:	a1 54 50 98 00       	mov    0x985054,%eax
  803c22:	48                   	dec    %eax
  803c23:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  803c28:	83 ec 0c             	sub    $0xc,%esp
  803c2b:	ff 75 d4             	pushl  -0x2c(%ebp)
  803c2e:	e8 8d f0 ff ff       	call   802cc0 <insert_sorted_in_freeList>
  803c33:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  803c36:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c39:	eb 05                	jmp    803c40 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  803c3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c40:	c9                   	leave  
  803c41:	c3                   	ret    

00803c42 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803c42:	55                   	push   %ebp
  803c43:	89 e5                	mov    %esp,%ebp
  803c45:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803c48:	83 ec 04             	sub    $0x4,%esp
  803c4b:	68 20 49 80 00       	push   $0x804920
  803c50:	68 20 02 00 00       	push   $0x220
  803c55:	68 57 48 80 00       	push   $0x804857
  803c5a:	e8 cf cf ff ff       	call   800c2e <_panic>

00803c5f <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803c5f:	55                   	push   %ebp
  803c60:	89 e5                	mov    %esp,%ebp
  803c62:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803c65:	83 ec 04             	sub    $0x4,%esp
  803c68:	68 48 49 80 00       	push   $0x804948
  803c6d:	68 28 02 00 00       	push   $0x228
  803c72:	68 57 48 80 00       	push   $0x804857
  803c77:	e8 b2 cf ff ff       	call   800c2e <_panic>

00803c7c <__udivdi3>:
  803c7c:	55                   	push   %ebp
  803c7d:	57                   	push   %edi
  803c7e:	56                   	push   %esi
  803c7f:	53                   	push   %ebx
  803c80:	83 ec 1c             	sub    $0x1c,%esp
  803c83:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c87:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c8f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c93:	89 ca                	mov    %ecx,%edx
  803c95:	89 f8                	mov    %edi,%eax
  803c97:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c9b:	85 f6                	test   %esi,%esi
  803c9d:	75 2d                	jne    803ccc <__udivdi3+0x50>
  803c9f:	39 cf                	cmp    %ecx,%edi
  803ca1:	77 65                	ja     803d08 <__udivdi3+0x8c>
  803ca3:	89 fd                	mov    %edi,%ebp
  803ca5:	85 ff                	test   %edi,%edi
  803ca7:	75 0b                	jne    803cb4 <__udivdi3+0x38>
  803ca9:	b8 01 00 00 00       	mov    $0x1,%eax
  803cae:	31 d2                	xor    %edx,%edx
  803cb0:	f7 f7                	div    %edi
  803cb2:	89 c5                	mov    %eax,%ebp
  803cb4:	31 d2                	xor    %edx,%edx
  803cb6:	89 c8                	mov    %ecx,%eax
  803cb8:	f7 f5                	div    %ebp
  803cba:	89 c1                	mov    %eax,%ecx
  803cbc:	89 d8                	mov    %ebx,%eax
  803cbe:	f7 f5                	div    %ebp
  803cc0:	89 cf                	mov    %ecx,%edi
  803cc2:	89 fa                	mov    %edi,%edx
  803cc4:	83 c4 1c             	add    $0x1c,%esp
  803cc7:	5b                   	pop    %ebx
  803cc8:	5e                   	pop    %esi
  803cc9:	5f                   	pop    %edi
  803cca:	5d                   	pop    %ebp
  803ccb:	c3                   	ret    
  803ccc:	39 ce                	cmp    %ecx,%esi
  803cce:	77 28                	ja     803cf8 <__udivdi3+0x7c>
  803cd0:	0f bd fe             	bsr    %esi,%edi
  803cd3:	83 f7 1f             	xor    $0x1f,%edi
  803cd6:	75 40                	jne    803d18 <__udivdi3+0x9c>
  803cd8:	39 ce                	cmp    %ecx,%esi
  803cda:	72 0a                	jb     803ce6 <__udivdi3+0x6a>
  803cdc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ce0:	0f 87 9e 00 00 00    	ja     803d84 <__udivdi3+0x108>
  803ce6:	b8 01 00 00 00       	mov    $0x1,%eax
  803ceb:	89 fa                	mov    %edi,%edx
  803ced:	83 c4 1c             	add    $0x1c,%esp
  803cf0:	5b                   	pop    %ebx
  803cf1:	5e                   	pop    %esi
  803cf2:	5f                   	pop    %edi
  803cf3:	5d                   	pop    %ebp
  803cf4:	c3                   	ret    
  803cf5:	8d 76 00             	lea    0x0(%esi),%esi
  803cf8:	31 ff                	xor    %edi,%edi
  803cfa:	31 c0                	xor    %eax,%eax
  803cfc:	89 fa                	mov    %edi,%edx
  803cfe:	83 c4 1c             	add    $0x1c,%esp
  803d01:	5b                   	pop    %ebx
  803d02:	5e                   	pop    %esi
  803d03:	5f                   	pop    %edi
  803d04:	5d                   	pop    %ebp
  803d05:	c3                   	ret    
  803d06:	66 90                	xchg   %ax,%ax
  803d08:	89 d8                	mov    %ebx,%eax
  803d0a:	f7 f7                	div    %edi
  803d0c:	31 ff                	xor    %edi,%edi
  803d0e:	89 fa                	mov    %edi,%edx
  803d10:	83 c4 1c             	add    $0x1c,%esp
  803d13:	5b                   	pop    %ebx
  803d14:	5e                   	pop    %esi
  803d15:	5f                   	pop    %edi
  803d16:	5d                   	pop    %ebp
  803d17:	c3                   	ret    
  803d18:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d1d:	89 eb                	mov    %ebp,%ebx
  803d1f:	29 fb                	sub    %edi,%ebx
  803d21:	89 f9                	mov    %edi,%ecx
  803d23:	d3 e6                	shl    %cl,%esi
  803d25:	89 c5                	mov    %eax,%ebp
  803d27:	88 d9                	mov    %bl,%cl
  803d29:	d3 ed                	shr    %cl,%ebp
  803d2b:	89 e9                	mov    %ebp,%ecx
  803d2d:	09 f1                	or     %esi,%ecx
  803d2f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d33:	89 f9                	mov    %edi,%ecx
  803d35:	d3 e0                	shl    %cl,%eax
  803d37:	89 c5                	mov    %eax,%ebp
  803d39:	89 d6                	mov    %edx,%esi
  803d3b:	88 d9                	mov    %bl,%cl
  803d3d:	d3 ee                	shr    %cl,%esi
  803d3f:	89 f9                	mov    %edi,%ecx
  803d41:	d3 e2                	shl    %cl,%edx
  803d43:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d47:	88 d9                	mov    %bl,%cl
  803d49:	d3 e8                	shr    %cl,%eax
  803d4b:	09 c2                	or     %eax,%edx
  803d4d:	89 d0                	mov    %edx,%eax
  803d4f:	89 f2                	mov    %esi,%edx
  803d51:	f7 74 24 0c          	divl   0xc(%esp)
  803d55:	89 d6                	mov    %edx,%esi
  803d57:	89 c3                	mov    %eax,%ebx
  803d59:	f7 e5                	mul    %ebp
  803d5b:	39 d6                	cmp    %edx,%esi
  803d5d:	72 19                	jb     803d78 <__udivdi3+0xfc>
  803d5f:	74 0b                	je     803d6c <__udivdi3+0xf0>
  803d61:	89 d8                	mov    %ebx,%eax
  803d63:	31 ff                	xor    %edi,%edi
  803d65:	e9 58 ff ff ff       	jmp    803cc2 <__udivdi3+0x46>
  803d6a:	66 90                	xchg   %ax,%ax
  803d6c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d70:	89 f9                	mov    %edi,%ecx
  803d72:	d3 e2                	shl    %cl,%edx
  803d74:	39 c2                	cmp    %eax,%edx
  803d76:	73 e9                	jae    803d61 <__udivdi3+0xe5>
  803d78:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d7b:	31 ff                	xor    %edi,%edi
  803d7d:	e9 40 ff ff ff       	jmp    803cc2 <__udivdi3+0x46>
  803d82:	66 90                	xchg   %ax,%ax
  803d84:	31 c0                	xor    %eax,%eax
  803d86:	e9 37 ff ff ff       	jmp    803cc2 <__udivdi3+0x46>
  803d8b:	90                   	nop

00803d8c <__umoddi3>:
  803d8c:	55                   	push   %ebp
  803d8d:	57                   	push   %edi
  803d8e:	56                   	push   %esi
  803d8f:	53                   	push   %ebx
  803d90:	83 ec 1c             	sub    $0x1c,%esp
  803d93:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d97:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d9f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803da3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803da7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803dab:	89 f3                	mov    %esi,%ebx
  803dad:	89 fa                	mov    %edi,%edx
  803daf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803db3:	89 34 24             	mov    %esi,(%esp)
  803db6:	85 c0                	test   %eax,%eax
  803db8:	75 1a                	jne    803dd4 <__umoddi3+0x48>
  803dba:	39 f7                	cmp    %esi,%edi
  803dbc:	0f 86 a2 00 00 00    	jbe    803e64 <__umoddi3+0xd8>
  803dc2:	89 c8                	mov    %ecx,%eax
  803dc4:	89 f2                	mov    %esi,%edx
  803dc6:	f7 f7                	div    %edi
  803dc8:	89 d0                	mov    %edx,%eax
  803dca:	31 d2                	xor    %edx,%edx
  803dcc:	83 c4 1c             	add    $0x1c,%esp
  803dcf:	5b                   	pop    %ebx
  803dd0:	5e                   	pop    %esi
  803dd1:	5f                   	pop    %edi
  803dd2:	5d                   	pop    %ebp
  803dd3:	c3                   	ret    
  803dd4:	39 f0                	cmp    %esi,%eax
  803dd6:	0f 87 ac 00 00 00    	ja     803e88 <__umoddi3+0xfc>
  803ddc:	0f bd e8             	bsr    %eax,%ebp
  803ddf:	83 f5 1f             	xor    $0x1f,%ebp
  803de2:	0f 84 ac 00 00 00    	je     803e94 <__umoddi3+0x108>
  803de8:	bf 20 00 00 00       	mov    $0x20,%edi
  803ded:	29 ef                	sub    %ebp,%edi
  803def:	89 fe                	mov    %edi,%esi
  803df1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803df5:	89 e9                	mov    %ebp,%ecx
  803df7:	d3 e0                	shl    %cl,%eax
  803df9:	89 d7                	mov    %edx,%edi
  803dfb:	89 f1                	mov    %esi,%ecx
  803dfd:	d3 ef                	shr    %cl,%edi
  803dff:	09 c7                	or     %eax,%edi
  803e01:	89 e9                	mov    %ebp,%ecx
  803e03:	d3 e2                	shl    %cl,%edx
  803e05:	89 14 24             	mov    %edx,(%esp)
  803e08:	89 d8                	mov    %ebx,%eax
  803e0a:	d3 e0                	shl    %cl,%eax
  803e0c:	89 c2                	mov    %eax,%edx
  803e0e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e12:	d3 e0                	shl    %cl,%eax
  803e14:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e18:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e1c:	89 f1                	mov    %esi,%ecx
  803e1e:	d3 e8                	shr    %cl,%eax
  803e20:	09 d0                	or     %edx,%eax
  803e22:	d3 eb                	shr    %cl,%ebx
  803e24:	89 da                	mov    %ebx,%edx
  803e26:	f7 f7                	div    %edi
  803e28:	89 d3                	mov    %edx,%ebx
  803e2a:	f7 24 24             	mull   (%esp)
  803e2d:	89 c6                	mov    %eax,%esi
  803e2f:	89 d1                	mov    %edx,%ecx
  803e31:	39 d3                	cmp    %edx,%ebx
  803e33:	0f 82 87 00 00 00    	jb     803ec0 <__umoddi3+0x134>
  803e39:	0f 84 91 00 00 00    	je     803ed0 <__umoddi3+0x144>
  803e3f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e43:	29 f2                	sub    %esi,%edx
  803e45:	19 cb                	sbb    %ecx,%ebx
  803e47:	89 d8                	mov    %ebx,%eax
  803e49:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e4d:	d3 e0                	shl    %cl,%eax
  803e4f:	89 e9                	mov    %ebp,%ecx
  803e51:	d3 ea                	shr    %cl,%edx
  803e53:	09 d0                	or     %edx,%eax
  803e55:	89 e9                	mov    %ebp,%ecx
  803e57:	d3 eb                	shr    %cl,%ebx
  803e59:	89 da                	mov    %ebx,%edx
  803e5b:	83 c4 1c             	add    $0x1c,%esp
  803e5e:	5b                   	pop    %ebx
  803e5f:	5e                   	pop    %esi
  803e60:	5f                   	pop    %edi
  803e61:	5d                   	pop    %ebp
  803e62:	c3                   	ret    
  803e63:	90                   	nop
  803e64:	89 fd                	mov    %edi,%ebp
  803e66:	85 ff                	test   %edi,%edi
  803e68:	75 0b                	jne    803e75 <__umoddi3+0xe9>
  803e6a:	b8 01 00 00 00       	mov    $0x1,%eax
  803e6f:	31 d2                	xor    %edx,%edx
  803e71:	f7 f7                	div    %edi
  803e73:	89 c5                	mov    %eax,%ebp
  803e75:	89 f0                	mov    %esi,%eax
  803e77:	31 d2                	xor    %edx,%edx
  803e79:	f7 f5                	div    %ebp
  803e7b:	89 c8                	mov    %ecx,%eax
  803e7d:	f7 f5                	div    %ebp
  803e7f:	89 d0                	mov    %edx,%eax
  803e81:	e9 44 ff ff ff       	jmp    803dca <__umoddi3+0x3e>
  803e86:	66 90                	xchg   %ax,%ax
  803e88:	89 c8                	mov    %ecx,%eax
  803e8a:	89 f2                	mov    %esi,%edx
  803e8c:	83 c4 1c             	add    $0x1c,%esp
  803e8f:	5b                   	pop    %ebx
  803e90:	5e                   	pop    %esi
  803e91:	5f                   	pop    %edi
  803e92:	5d                   	pop    %ebp
  803e93:	c3                   	ret    
  803e94:	3b 04 24             	cmp    (%esp),%eax
  803e97:	72 06                	jb     803e9f <__umoddi3+0x113>
  803e99:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e9d:	77 0f                	ja     803eae <__umoddi3+0x122>
  803e9f:	89 f2                	mov    %esi,%edx
  803ea1:	29 f9                	sub    %edi,%ecx
  803ea3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ea7:	89 14 24             	mov    %edx,(%esp)
  803eaa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803eae:	8b 44 24 04          	mov    0x4(%esp),%eax
  803eb2:	8b 14 24             	mov    (%esp),%edx
  803eb5:	83 c4 1c             	add    $0x1c,%esp
  803eb8:	5b                   	pop    %ebx
  803eb9:	5e                   	pop    %esi
  803eba:	5f                   	pop    %edi
  803ebb:	5d                   	pop    %ebp
  803ebc:	c3                   	ret    
  803ebd:	8d 76 00             	lea    0x0(%esi),%esi
  803ec0:	2b 04 24             	sub    (%esp),%eax
  803ec3:	19 fa                	sbb    %edi,%edx
  803ec5:	89 d1                	mov    %edx,%ecx
  803ec7:	89 c6                	mov    %eax,%esi
  803ec9:	e9 71 ff ff ff       	jmp    803e3f <__umoddi3+0xb3>
  803ece:	66 90                	xchg   %ax,%ax
  803ed0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ed4:	72 ea                	jb     803ec0 <__umoddi3+0x134>
  803ed6:	89 d9                	mov    %ebx,%ecx
  803ed8:	e9 62 ff ff ff       	jmp    803e3f <__umoddi3+0xb3>
