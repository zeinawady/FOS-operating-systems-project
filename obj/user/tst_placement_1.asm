
obj/user/tst_placement_1:     file format elf32-i386


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
  800031:	e8 81 03 00 00       	call   8003b7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 84 00 00 01    	sub    $0x1000084,%esp
	int freePages = sys_calculate_free_frames();
  800042:	e8 2c 16 00 00       	call   801673 <sys_calculate_free_frames>
  800047:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	char arr[PAGE_SIZE*1024*4];

	//uint32 actual_active_list[17] = {0xedbfd000,0xeebfd000,0x803000,0x802000,0x801000,0x800000,0x205000,0x204000,0x203000,0x202000,0x201000,0x200000};
	uint32 actual_active_list[17] ;
	{
		actual_active_list[0] = 0xedbfd000;
  80004a:	c7 85 8c ff ff fe 00 	movl   $0xedbfd000,-0x1000074(%ebp)
  800051:	d0 bf ed 
		actual_active_list[1] = 0xeebfd000;
  800054:	c7 85 90 ff ff fe 00 	movl   $0xeebfd000,-0x1000070(%ebp)
  80005b:	d0 bf ee 
		actual_active_list[2] = 0x803000;
  80005e:	c7 85 94 ff ff fe 00 	movl   $0x803000,-0x100006c(%ebp)
  800065:	30 80 00 
		actual_active_list[3] = 0x802000;
  800068:	c7 85 98 ff ff fe 00 	movl   $0x802000,-0x1000068(%ebp)
  80006f:	20 80 00 
		actual_active_list[4] = 0x801000;
  800072:	c7 85 9c ff ff fe 00 	movl   $0x801000,-0x1000064(%ebp)
  800079:	10 80 00 
		actual_active_list[5] = 0x800000;
  80007c:	c7 85 a0 ff ff fe 00 	movl   $0x800000,-0x1000060(%ebp)
  800083:	00 80 00 
		actual_active_list[6] = 0x205000;
  800086:	c7 85 a4 ff ff fe 00 	movl   $0x205000,-0x100005c(%ebp)
  80008d:	50 20 00 
		actual_active_list[7] = 0x204000;
  800090:	c7 85 a8 ff ff fe 00 	movl   $0x204000,-0x1000058(%ebp)
  800097:	40 20 00 
		actual_active_list[8] = 0x203000;
  80009a:	c7 85 ac ff ff fe 00 	movl   $0x203000,-0x1000054(%ebp)
  8000a1:	30 20 00 
		actual_active_list[9] = 0x202000;
  8000a4:	c7 85 b0 ff ff fe 00 	movl   $0x202000,-0x1000050(%ebp)
  8000ab:	20 20 00 
		actual_active_list[10] = 0x201000;
  8000ae:	c7 85 b4 ff ff fe 00 	movl   $0x201000,-0x100004c(%ebp)
  8000b5:	10 20 00 
		actual_active_list[11] = 0x200000;
  8000b8:	c7 85 b8 ff ff fe 00 	movl   $0x200000,-0x1000048(%ebp)
  8000bf:	00 20 00 
	}
	uint32 actual_second_list[2] = {};
  8000c2:	c7 85 84 ff ff fe 00 	movl   $0x0,-0x100007c(%ebp)
  8000c9:	00 00 00 
  8000cc:	c7 85 88 ff ff fe 00 	movl   $0x0,-0x1000078(%ebp)
  8000d3:	00 00 00 

	("STEP 0: checking Initial LRU lists entries ...\n");
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 12, 0);
  8000d6:	6a 00                	push   $0x0
  8000d8:	6a 0c                	push   $0xc
  8000da:	8d 85 84 ff ff fe    	lea    -0x100007c(%ebp),%eax
  8000e0:	50                   	push   %eax
  8000e1:	8d 85 8c ff ff fe    	lea    -0x1000074(%ebp),%eax
  8000e7:	50                   	push   %eax
  8000e8:	e8 9f 19 00 00       	call   801a8c <sys_check_LRU_lists>
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if(check == 0)
  8000f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8000f7:	75 14                	jne    80010d <_main+0xd5>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	68 60 1e 80 00       	push   $0x801e60
  800101:	6a 26                	push   $0x26
  800103:	68 e2 1e 80 00       	push   $0x801ee2
  800108:	e8 ef 03 00 00       	call   8004fc <_panic>
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010d:	e8 ac 15 00 00       	call   8016be <sys_pf_calculate_allocated_pages>
  800112:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i=0;
  800115:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(;i<=PAGE_SIZE;i++)
  80011c:	eb 11                	jmp    80012f <_main+0xf7>
	{
		arr[i] = 'A';
  80011e:	8d 95 d0 ff ff fe    	lea    -0x1000030(%ebp),%edx
  800124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800127:	01 d0                	add    %edx,%eax
  800129:	c6 00 41             	movb   $0x41,(%eax)
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int i=0;
	for(;i<=PAGE_SIZE;i++)
  80012c:	ff 45 f4             	incl   -0xc(%ebp)
  80012f:	81 7d f4 00 10 00 00 	cmpl   $0x1000,-0xc(%ebp)
  800136:	7e e6                	jle    80011e <_main+0xe6>
	{
		arr[i] = 'A';
	}
//	cprintf("1. free frames = %d\n", sys_calculate_free_frames());

	i=PAGE_SIZE*1024;
  800138:	c7 45 f4 00 00 40 00 	movl   $0x400000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  80013f:	eb 11                	jmp    800152 <_main+0x11a>
	{
		arr[i] = 'A';
  800141:	8d 95 d0 ff ff fe    	lea    -0x1000030(%ebp),%edx
  800147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	c6 00 41             	movb   $0x41,(%eax)
		arr[i] = 'A';
	}
//	cprintf("1. free frames = %d\n", sys_calculate_free_frames());

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  80014f:	ff 45 f4             	incl   -0xc(%ebp)
  800152:	81 7d f4 00 10 40 00 	cmpl   $0x401000,-0xc(%ebp)
  800159:	7e e6                	jle    800141 <_main+0x109>
	{
		arr[i] = 'A';
	}
	//cprintf("2. free frames = %d\n", sys_calculate_free_frames());

	i=PAGE_SIZE*1024*2;
  80015b:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800162:	eb 11                	jmp    800175 <_main+0x13d>
	{
		arr[i] = 'A';
  800164:	8d 95 d0 ff ff fe    	lea    -0x1000030(%ebp),%edx
  80016a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80016d:	01 d0                	add    %edx,%eax
  80016f:	c6 00 41             	movb   $0x41,(%eax)
		arr[i] = 'A';
	}
	//cprintf("2. free frames = %d\n", sys_calculate_free_frames());

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800172:	ff 45 f4             	incl   -0xc(%ebp)
  800175:	81 7d f4 00 10 80 00 	cmpl   $0x801000,-0xc(%ebp)
  80017c:	7e e6                	jle    800164 <_main+0x12c>
		arr[i] = 'A';
	}
	//cprintf("3. free frames = %d\n", sys_calculate_free_frames());


	int eval = 0;
  80017e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	bool is_correct = 1;
  800185:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
	uint32 expected, actual ;
	cprintf("STEP A: checking PLACEMENT fault handling ... \n");
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	68 fc 1e 80 00       	push   $0x801efc
  800194:	e8 20 06 00 00       	call   8007b9 <cprintf>
  800199:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] != 'A')  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  80019c:	8a 85 d0 ff ff fe    	mov    -0x1000030(%ebp),%al
  8001a2:	3c 41                	cmp    $0x41,%al
  8001a4:	74 17                	je     8001bd <_main+0x185>
  8001a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	68 2c 1f 80 00       	push   $0x801f2c
  8001b5:	e8 ff 05 00 00       	call   8007b9 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE] != 'A')  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  8001bd:	8a 85 d0 0f 00 ff    	mov    -0xfff030(%ebp),%al
  8001c3:	3c 41                	cmp    $0x41,%al
  8001c5:	74 17                	je     8001de <_main+0x1a6>
  8001c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001ce:	83 ec 0c             	sub    $0xc,%esp
  8001d1:	68 2c 1f 80 00       	push   $0x801f2c
  8001d6:	e8 de 05 00 00       	call   8007b9 <cprintf>
  8001db:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024] != 'A')  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8001de:	8a 85 d0 ff 3f ff    	mov    -0xc00030(%ebp),%al
  8001e4:	3c 41                	cmp    $0x41,%al
  8001e6:	74 17                	je     8001ff <_main+0x1c7>
  8001e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001ef:	83 ec 0c             	sub    $0xc,%esp
  8001f2:	68 2c 1f 80 00       	push   $0x801f2c
  8001f7:	e8 bd 05 00 00       	call   8007b9 <cprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1025] != 'A')  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8001ff:	8a 85 d0 0f 40 ff    	mov    -0xbff030(%ebp),%al
  800205:	3c 41                	cmp    $0x41,%al
  800207:	74 17                	je     800220 <_main+0x1e8>
  800209:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	68 2c 1f 80 00       	push   $0x801f2c
  800218:	e8 9c 05 00 00       	call   8007b9 <cprintf>
  80021d:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024*2] != 'A')  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800220:	8a 85 d0 ff 7f ff    	mov    -0x800030(%ebp),%al
  800226:	3c 41                	cmp    $0x41,%al
  800228:	74 17                	je     800241 <_main+0x209>
  80022a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800231:	83 ec 0c             	sub    $0xc,%esp
  800234:	68 2c 1f 80 00       	push   $0x801f2c
  800239:	e8 7b 05 00 00       	call   8007b9 <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] != 'A')  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800241:	8a 85 d0 0f 80 ff    	mov    -0x7ff030(%ebp),%al
  800247:	3c 41                	cmp    $0x41,%al
  800249:	74 17                	je     800262 <_main+0x22a>
  80024b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800252:	83 ec 0c             	sub    $0xc,%esp
  800255:	68 2c 1f 80 00       	push   $0x801f2c
  80025a:	e8 5a 05 00 00       	call   8007b9 <cprintf>
  80025f:	83 c4 10             	add    $0x10,%esp

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("new stack pages should NOT written to Page File until it's replaced\n"); }
  800262:	e8 57 14 00 00       	call   8016be <sys_pf_calculate_allocated_pages>
  800267:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80026a:	74 17                	je     800283 <_main+0x24b>
  80026c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800273:	83 ec 0c             	sub    $0xc,%esp
  800276:	68 4c 1f 80 00       	push   $0x801f4c
  80027b:	e8 39 05 00 00       	call   8007b9 <cprintf>
  800280:	83 c4 10             	add    $0x10,%esp

		expected = 6 /*pages*/ + 3 /*tables*/ - 2 /*table + page due to a fault in the 1st call of sys_calculate_free_frames*/;
  800283:	c7 45 d8 07 00 00 00 	movl   $0x7,-0x28(%ebp)
		actual = (freePages - sys_calculate_free_frames()) ;
  80028a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80028d:	e8 e1 13 00 00       	call   801673 <sys_calculate_free_frames>
  800292:	29 c3                	sub    %eax,%ebx
  800294:	89 d8                	mov    %ebx,%eax
  800296:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		//actual = (initFreeFrames - sys_calculate_free_frames()) ;

		if(actual != expected) { is_correct = 0; cprintf("allocated memory size incorrect. Expected = %d, Actual = %d\n", expected, actual); }
  800299:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80029c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80029f:	74 1d                	je     8002be <_main+0x286>
  8002a1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8002a8:	83 ec 04             	sub    $0x4,%esp
  8002ab:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002ae:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b1:	68 94 1f 80 00       	push   $0x801f94
  8002b6:	e8 fe 04 00 00       	call   8007b9 <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	68 d4 1f 80 00       	push   $0x801fd4
  8002c6:	e8 ee 04 00 00       	call   8007b9 <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
	if (is_correct)
  8002ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8002d2:	74 04                	je     8002d8 <_main+0x2a0>
		eval += 50 ;
  8002d4:	83 45 f0 32          	addl   $0x32,-0x10(%ebp)
	is_correct = 1;
  8002d8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)

	for (int i=16;i>4;i--)
  8002df:	c7 45 e8 10 00 00 00 	movl   $0x10,-0x18(%ebp)
  8002e6:	eb 1a                	jmp    800302 <_main+0x2ca>
		actual_active_list[i]=actual_active_list[i-5];
  8002e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002eb:	83 e8 05             	sub    $0x5,%eax
  8002ee:	8b 94 85 8c ff ff fe 	mov    -0x1000074(%ebp,%eax,4),%edx
  8002f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002f8:	89 94 85 8c ff ff fe 	mov    %edx,-0x1000074(%ebp,%eax,4)
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
	if (is_correct)
		eval += 50 ;
	is_correct = 1;

	for (int i=16;i>4;i--)
  8002ff:	ff 4d e8             	decl   -0x18(%ebp)
  800302:	83 7d e8 04          	cmpl   $0x4,-0x18(%ebp)
  800306:	7f e0                	jg     8002e8 <_main+0x2b0>
		actual_active_list[i]=actual_active_list[i-5];

	actual_active_list[0]=0xee3fe000;
  800308:	c7 85 8c ff ff fe 00 	movl   $0xee3fe000,-0x1000074(%ebp)
  80030f:	e0 3f ee 
	actual_active_list[1]=0xee3fd000;
  800312:	c7 85 90 ff ff fe 00 	movl   $0xee3fd000,-0x1000070(%ebp)
  800319:	d0 3f ee 
	actual_active_list[2]=0xedffe000;
  80031c:	c7 85 94 ff ff fe 00 	movl   $0xedffe000,-0x100006c(%ebp)
  800323:	e0 ff ed 
	actual_active_list[3]=0xedffd000;
  800326:	c7 85 98 ff ff fe 00 	movl   $0xedffd000,-0x1000068(%ebp)
  80032d:	d0 ff ed 
	actual_active_list[4]=0xedbfe000;
  800330:	c7 85 9c ff ff fe 00 	movl   $0xedbfe000,-0x1000064(%ebp)
  800337:	e0 bf ed 

	cprintf("STEP B: checking LRU lists entries ...\n");
  80033a:	83 ec 0c             	sub    $0xc,%esp
  80033d:	68 08 20 80 00       	push   $0x802008
  800342:	e8 72 04 00 00       	call   8007b9 <cprintf>
  800347:	83 c4 10             	add    $0x10,%esp
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 17, 0);
  80034a:	6a 00                	push   $0x0
  80034c:	6a 11                	push   $0x11
  80034e:	8d 85 84 ff ff fe    	lea    -0x100007c(%ebp),%eax
  800354:	50                   	push   %eax
  800355:	8d 85 8c ff ff fe    	lea    -0x1000074(%ebp),%eax
  80035b:	50                   	push   %eax
  80035c:	e8 2b 17 00 00       	call   801a8c <sys_check_LRU_lists>
  800361:	83 c4 10             	add    $0x10,%esp
  800364:	89 45 d0             	mov    %eax,-0x30(%ebp)
			if(check == 0)
  800367:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80036b:	75 17                	jne    800384 <_main+0x34c>
				{ is_correct = 0; cprintf("LRU lists entries are not correct, check your logic again!!\n"); }
  80036d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800374:	83 ec 0c             	sub    $0xc,%esp
  800377:	68 30 20 80 00       	push   $0x802030
  80037c:	e8 38 04 00 00       	call   8007b9 <cprintf>
  800381:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP B passed: LRU lists entries test are correct\n\n\n");
  800384:	83 ec 0c             	sub    $0xc,%esp
  800387:	68 70 20 80 00       	push   $0x802070
  80038c:	e8 28 04 00 00       	call   8007b9 <cprintf>
  800391:	83 c4 10             	add    $0x10,%esp
	if (is_correct)
  800394:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800398:	74 04                	je     80039e <_main+0x366>
		eval += 50 ;
  80039a:	83 45 f0 32          	addl   $0x32,-0x10(%ebp)

	cprintf("Congratulations!! Test of PAGE PLACEMENT FIRST SCENARIO completed. Eval = %d\n\n\n", eval);
  80039e:	83 ec 08             	sub    $0x8,%esp
  8003a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8003a4:	68 a8 20 80 00       	push   $0x8020a8
  8003a9:	e8 0b 04 00 00       	call   8007b9 <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp
	return;
  8003b1:	90                   	nop
}
  8003b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003b5:	c9                   	leave  
  8003b6:	c3                   	ret    

008003b7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8003b7:	55                   	push   %ebp
  8003b8:	89 e5                	mov    %esp,%ebp
  8003ba:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8003bd:	e8 7a 14 00 00       	call   80183c <sys_getenvindex>
  8003c2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8003c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003c8:	89 d0                	mov    %edx,%eax
  8003ca:	c1 e0 02             	shl    $0x2,%eax
  8003cd:	01 d0                	add    %edx,%eax
  8003cf:	c1 e0 03             	shl    $0x3,%eax
  8003d2:	01 d0                	add    %edx,%eax
  8003d4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8003db:	01 d0                	add    %edx,%eax
  8003dd:	c1 e0 02             	shl    $0x2,%eax
  8003e0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003e5:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003ea:	a1 08 30 80 00       	mov    0x803008,%eax
  8003ef:	8a 40 20             	mov    0x20(%eax),%al
  8003f2:	84 c0                	test   %al,%al
  8003f4:	74 0d                	je     800403 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  8003f6:	a1 08 30 80 00       	mov    0x803008,%eax
  8003fb:	83 c0 20             	add    $0x20,%eax
  8003fe:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800403:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800407:	7e 0a                	jle    800413 <libmain+0x5c>
		binaryname = argv[0];
  800409:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040c:	8b 00                	mov    (%eax),%eax
  80040e:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800413:	83 ec 08             	sub    $0x8,%esp
  800416:	ff 75 0c             	pushl  0xc(%ebp)
  800419:	ff 75 08             	pushl  0x8(%ebp)
  80041c:	e8 17 fc ff ff       	call   800038 <_main>
  800421:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800424:	a1 00 30 80 00       	mov    0x803000,%eax
  800429:	85 c0                	test   %eax,%eax
  80042b:	0f 84 9f 00 00 00    	je     8004d0 <libmain+0x119>
	{
		sys_lock_cons();
  800431:	e8 8a 11 00 00       	call   8015c0 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800436:	83 ec 0c             	sub    $0xc,%esp
  800439:	68 10 21 80 00       	push   $0x802110
  80043e:	e8 76 03 00 00       	call   8007b9 <cprintf>
  800443:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800446:	a1 08 30 80 00       	mov    0x803008,%eax
  80044b:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800451:	a1 08 30 80 00       	mov    0x803008,%eax
  800456:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80045c:	83 ec 04             	sub    $0x4,%esp
  80045f:	52                   	push   %edx
  800460:	50                   	push   %eax
  800461:	68 38 21 80 00       	push   $0x802138
  800466:	e8 4e 03 00 00       	call   8007b9 <cprintf>
  80046b:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80046e:	a1 08 30 80 00       	mov    0x803008,%eax
  800473:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800479:	a1 08 30 80 00       	mov    0x803008,%eax
  80047e:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800484:	a1 08 30 80 00       	mov    0x803008,%eax
  800489:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80048f:	51                   	push   %ecx
  800490:	52                   	push   %edx
  800491:	50                   	push   %eax
  800492:	68 60 21 80 00       	push   $0x802160
  800497:	e8 1d 03 00 00       	call   8007b9 <cprintf>
  80049c:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80049f:	a1 08 30 80 00       	mov    0x803008,%eax
  8004a4:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8004aa:	83 ec 08             	sub    $0x8,%esp
  8004ad:	50                   	push   %eax
  8004ae:	68 b8 21 80 00       	push   $0x8021b8
  8004b3:	e8 01 03 00 00       	call   8007b9 <cprintf>
  8004b8:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8004bb:	83 ec 0c             	sub    $0xc,%esp
  8004be:	68 10 21 80 00       	push   $0x802110
  8004c3:	e8 f1 02 00 00       	call   8007b9 <cprintf>
  8004c8:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8004cb:	e8 0a 11 00 00       	call   8015da <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8004d0:	e8 19 00 00 00       	call   8004ee <exit>
}
  8004d5:	90                   	nop
  8004d6:	c9                   	leave  
  8004d7:	c3                   	ret    

008004d8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004d8:	55                   	push   %ebp
  8004d9:	89 e5                	mov    %esp,%ebp
  8004db:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004de:	83 ec 0c             	sub    $0xc,%esp
  8004e1:	6a 00                	push   $0x0
  8004e3:	e8 20 13 00 00       	call   801808 <sys_destroy_env>
  8004e8:	83 c4 10             	add    $0x10,%esp
}
  8004eb:	90                   	nop
  8004ec:	c9                   	leave  
  8004ed:	c3                   	ret    

008004ee <exit>:

void
exit(void)
{
  8004ee:	55                   	push   %ebp
  8004ef:	89 e5                	mov    %esp,%ebp
  8004f1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004f4:	e8 75 13 00 00       	call   80186e <sys_exit_env>
}
  8004f9:	90                   	nop
  8004fa:	c9                   	leave  
  8004fb:	c3                   	ret    

008004fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004fc:	55                   	push   %ebp
  8004fd:	89 e5                	mov    %esp,%ebp
  8004ff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800502:	8d 45 10             	lea    0x10(%ebp),%eax
  800505:	83 c0 04             	add    $0x4,%eax
  800508:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80050b:	a1 28 30 80 00       	mov    0x803028,%eax
  800510:	85 c0                	test   %eax,%eax
  800512:	74 16                	je     80052a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800514:	a1 28 30 80 00       	mov    0x803028,%eax
  800519:	83 ec 08             	sub    $0x8,%esp
  80051c:	50                   	push   %eax
  80051d:	68 cc 21 80 00       	push   $0x8021cc
  800522:	e8 92 02 00 00       	call   8007b9 <cprintf>
  800527:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80052a:	a1 04 30 80 00       	mov    0x803004,%eax
  80052f:	ff 75 0c             	pushl  0xc(%ebp)
  800532:	ff 75 08             	pushl  0x8(%ebp)
  800535:	50                   	push   %eax
  800536:	68 d1 21 80 00       	push   $0x8021d1
  80053b:	e8 79 02 00 00       	call   8007b9 <cprintf>
  800540:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800543:	8b 45 10             	mov    0x10(%ebp),%eax
  800546:	83 ec 08             	sub    $0x8,%esp
  800549:	ff 75 f4             	pushl  -0xc(%ebp)
  80054c:	50                   	push   %eax
  80054d:	e8 fc 01 00 00       	call   80074e <vcprintf>
  800552:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800555:	83 ec 08             	sub    $0x8,%esp
  800558:	6a 00                	push   $0x0
  80055a:	68 ed 21 80 00       	push   $0x8021ed
  80055f:	e8 ea 01 00 00       	call   80074e <vcprintf>
  800564:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800567:	e8 82 ff ff ff       	call   8004ee <exit>

	// should not return here
	while (1) ;
  80056c:	eb fe                	jmp    80056c <_panic+0x70>

0080056e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80056e:	55                   	push   %ebp
  80056f:	89 e5                	mov    %esp,%ebp
  800571:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800574:	a1 08 30 80 00       	mov    0x803008,%eax
  800579:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80057f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800582:	39 c2                	cmp    %eax,%edx
  800584:	74 14                	je     80059a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800586:	83 ec 04             	sub    $0x4,%esp
  800589:	68 f0 21 80 00       	push   $0x8021f0
  80058e:	6a 26                	push   $0x26
  800590:	68 3c 22 80 00       	push   $0x80223c
  800595:	e8 62 ff ff ff       	call   8004fc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80059a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005a1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005a8:	e9 c5 00 00 00       	jmp    800672 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8005ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ba:	01 d0                	add    %edx,%eax
  8005bc:	8b 00                	mov    (%eax),%eax
  8005be:	85 c0                	test   %eax,%eax
  8005c0:	75 08                	jne    8005ca <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8005c2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005c5:	e9 a5 00 00 00       	jmp    80066f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8005ca:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005d1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005d8:	eb 69                	jmp    800643 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005da:	a1 08 30 80 00       	mov    0x803008,%eax
  8005df:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8005e5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005e8:	89 d0                	mov    %edx,%eax
  8005ea:	01 c0                	add    %eax,%eax
  8005ec:	01 d0                	add    %edx,%eax
  8005ee:	c1 e0 03             	shl    $0x3,%eax
  8005f1:	01 c8                	add    %ecx,%eax
  8005f3:	8a 40 04             	mov    0x4(%eax),%al
  8005f6:	84 c0                	test   %al,%al
  8005f8:	75 46                	jne    800640 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005fa:	a1 08 30 80 00       	mov    0x803008,%eax
  8005ff:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800605:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800608:	89 d0                	mov    %edx,%eax
  80060a:	01 c0                	add    %eax,%eax
  80060c:	01 d0                	add    %edx,%eax
  80060e:	c1 e0 03             	shl    $0x3,%eax
  800611:	01 c8                	add    %ecx,%eax
  800613:	8b 00                	mov    (%eax),%eax
  800615:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800618:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80061b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800620:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800622:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800625:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80062c:	8b 45 08             	mov    0x8(%ebp),%eax
  80062f:	01 c8                	add    %ecx,%eax
  800631:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800633:	39 c2                	cmp    %eax,%edx
  800635:	75 09                	jne    800640 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800637:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80063e:	eb 15                	jmp    800655 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800640:	ff 45 e8             	incl   -0x18(%ebp)
  800643:	a1 08 30 80 00       	mov    0x803008,%eax
  800648:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80064e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800651:	39 c2                	cmp    %eax,%edx
  800653:	77 85                	ja     8005da <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800655:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800659:	75 14                	jne    80066f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80065b:	83 ec 04             	sub    $0x4,%esp
  80065e:	68 48 22 80 00       	push   $0x802248
  800663:	6a 3a                	push   $0x3a
  800665:	68 3c 22 80 00       	push   $0x80223c
  80066a:	e8 8d fe ff ff       	call   8004fc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80066f:	ff 45 f0             	incl   -0x10(%ebp)
  800672:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800675:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800678:	0f 8c 2f ff ff ff    	jl     8005ad <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80067e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800685:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80068c:	eb 26                	jmp    8006b4 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80068e:	a1 08 30 80 00       	mov    0x803008,%eax
  800693:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800699:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80069c:	89 d0                	mov    %edx,%eax
  80069e:	01 c0                	add    %eax,%eax
  8006a0:	01 d0                	add    %edx,%eax
  8006a2:	c1 e0 03             	shl    $0x3,%eax
  8006a5:	01 c8                	add    %ecx,%eax
  8006a7:	8a 40 04             	mov    0x4(%eax),%al
  8006aa:	3c 01                	cmp    $0x1,%al
  8006ac:	75 03                	jne    8006b1 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8006ae:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006b1:	ff 45 e0             	incl   -0x20(%ebp)
  8006b4:	a1 08 30 80 00       	mov    0x803008,%eax
  8006b9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8006bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c2:	39 c2                	cmp    %eax,%edx
  8006c4:	77 c8                	ja     80068e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006c9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006cc:	74 14                	je     8006e2 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8006ce:	83 ec 04             	sub    $0x4,%esp
  8006d1:	68 9c 22 80 00       	push   $0x80229c
  8006d6:	6a 44                	push   $0x44
  8006d8:	68 3c 22 80 00       	push   $0x80223c
  8006dd:	e8 1a fe ff ff       	call   8004fc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006e2:	90                   	nop
  8006e3:	c9                   	leave  
  8006e4:	c3                   	ret    

008006e5 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
  8006e8:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	8d 48 01             	lea    0x1(%eax),%ecx
  8006f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006f6:	89 0a                	mov    %ecx,(%edx)
  8006f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8006fb:	88 d1                	mov    %dl,%cl
  8006fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800700:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800704:	8b 45 0c             	mov    0xc(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	3d ff 00 00 00       	cmp    $0xff,%eax
  80070e:	75 2c                	jne    80073c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800710:	a0 0c 30 80 00       	mov    0x80300c,%al
  800715:	0f b6 c0             	movzbl %al,%eax
  800718:	8b 55 0c             	mov    0xc(%ebp),%edx
  80071b:	8b 12                	mov    (%edx),%edx
  80071d:	89 d1                	mov    %edx,%ecx
  80071f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800722:	83 c2 08             	add    $0x8,%edx
  800725:	83 ec 04             	sub    $0x4,%esp
  800728:	50                   	push   %eax
  800729:	51                   	push   %ecx
  80072a:	52                   	push   %edx
  80072b:	e8 4e 0e 00 00       	call   80157e <sys_cputs>
  800730:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800733:	8b 45 0c             	mov    0xc(%ebp),%eax
  800736:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80073c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80073f:	8b 40 04             	mov    0x4(%eax),%eax
  800742:	8d 50 01             	lea    0x1(%eax),%edx
  800745:	8b 45 0c             	mov    0xc(%ebp),%eax
  800748:	89 50 04             	mov    %edx,0x4(%eax)
}
  80074b:	90                   	nop
  80074c:	c9                   	leave  
  80074d:	c3                   	ret    

0080074e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80074e:	55                   	push   %ebp
  80074f:	89 e5                	mov    %esp,%ebp
  800751:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800757:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80075e:	00 00 00 
	b.cnt = 0;
  800761:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800768:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80076b:	ff 75 0c             	pushl  0xc(%ebp)
  80076e:	ff 75 08             	pushl  0x8(%ebp)
  800771:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800777:	50                   	push   %eax
  800778:	68 e5 06 80 00       	push   $0x8006e5
  80077d:	e8 11 02 00 00       	call   800993 <vprintfmt>
  800782:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800785:	a0 0c 30 80 00       	mov    0x80300c,%al
  80078a:	0f b6 c0             	movzbl %al,%eax
  80078d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800793:	83 ec 04             	sub    $0x4,%esp
  800796:	50                   	push   %eax
  800797:	52                   	push   %edx
  800798:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80079e:	83 c0 08             	add    $0x8,%eax
  8007a1:	50                   	push   %eax
  8007a2:	e8 d7 0d 00 00       	call   80157e <sys_cputs>
  8007a7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007aa:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  8007b1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007b7:	c9                   	leave  
  8007b8:	c3                   	ret    

008007b9 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8007b9:	55                   	push   %ebp
  8007ba:	89 e5                	mov    %esp,%ebp
  8007bc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007bf:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  8007c6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	83 ec 08             	sub    $0x8,%esp
  8007d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d5:	50                   	push   %eax
  8007d6:	e8 73 ff ff ff       	call   80074e <vcprintf>
  8007db:	83 c4 10             	add    $0x10,%esp
  8007de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e4:	c9                   	leave  
  8007e5:	c3                   	ret    

008007e6 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007e6:	55                   	push   %ebp
  8007e7:	89 e5                	mov    %esp,%ebp
  8007e9:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007ec:	e8 cf 0d 00 00       	call   8015c0 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007f1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	83 ec 08             	sub    $0x8,%esp
  8007fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800800:	50                   	push   %eax
  800801:	e8 48 ff ff ff       	call   80074e <vcprintf>
  800806:	83 c4 10             	add    $0x10,%esp
  800809:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80080c:	e8 c9 0d 00 00       	call   8015da <sys_unlock_cons>
	return cnt;
  800811:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800814:	c9                   	leave  
  800815:	c3                   	ret    

00800816 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800816:	55                   	push   %ebp
  800817:	89 e5                	mov    %esp,%ebp
  800819:	53                   	push   %ebx
  80081a:	83 ec 14             	sub    $0x14,%esp
  80081d:	8b 45 10             	mov    0x10(%ebp),%eax
  800820:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800823:	8b 45 14             	mov    0x14(%ebp),%eax
  800826:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800829:	8b 45 18             	mov    0x18(%ebp),%eax
  80082c:	ba 00 00 00 00       	mov    $0x0,%edx
  800831:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800834:	77 55                	ja     80088b <printnum+0x75>
  800836:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800839:	72 05                	jb     800840 <printnum+0x2a>
  80083b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80083e:	77 4b                	ja     80088b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800840:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800843:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800846:	8b 45 18             	mov    0x18(%ebp),%eax
  800849:	ba 00 00 00 00       	mov    $0x0,%edx
  80084e:	52                   	push   %edx
  80084f:	50                   	push   %eax
  800850:	ff 75 f4             	pushl  -0xc(%ebp)
  800853:	ff 75 f0             	pushl  -0x10(%ebp)
  800856:	e8 95 13 00 00       	call   801bf0 <__udivdi3>
  80085b:	83 c4 10             	add    $0x10,%esp
  80085e:	83 ec 04             	sub    $0x4,%esp
  800861:	ff 75 20             	pushl  0x20(%ebp)
  800864:	53                   	push   %ebx
  800865:	ff 75 18             	pushl  0x18(%ebp)
  800868:	52                   	push   %edx
  800869:	50                   	push   %eax
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	ff 75 08             	pushl  0x8(%ebp)
  800870:	e8 a1 ff ff ff       	call   800816 <printnum>
  800875:	83 c4 20             	add    $0x20,%esp
  800878:	eb 1a                	jmp    800894 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80087a:	83 ec 08             	sub    $0x8,%esp
  80087d:	ff 75 0c             	pushl  0xc(%ebp)
  800880:	ff 75 20             	pushl  0x20(%ebp)
  800883:	8b 45 08             	mov    0x8(%ebp),%eax
  800886:	ff d0                	call   *%eax
  800888:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80088b:	ff 4d 1c             	decl   0x1c(%ebp)
  80088e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800892:	7f e6                	jg     80087a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800894:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800897:	bb 00 00 00 00       	mov    $0x0,%ebx
  80089c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80089f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a2:	53                   	push   %ebx
  8008a3:	51                   	push   %ecx
  8008a4:	52                   	push   %edx
  8008a5:	50                   	push   %eax
  8008a6:	e8 55 14 00 00       	call   801d00 <__umoddi3>
  8008ab:	83 c4 10             	add    $0x10,%esp
  8008ae:	05 14 25 80 00       	add    $0x802514,%eax
  8008b3:	8a 00                	mov    (%eax),%al
  8008b5:	0f be c0             	movsbl %al,%eax
  8008b8:	83 ec 08             	sub    $0x8,%esp
  8008bb:	ff 75 0c             	pushl  0xc(%ebp)
  8008be:	50                   	push   %eax
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	ff d0                	call   *%eax
  8008c4:	83 c4 10             	add    $0x10,%esp
}
  8008c7:	90                   	nop
  8008c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008cb:	c9                   	leave  
  8008cc:	c3                   	ret    

008008cd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008cd:	55                   	push   %ebp
  8008ce:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008d0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008d4:	7e 1c                	jle    8008f2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	8d 50 08             	lea    0x8(%eax),%edx
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	89 10                	mov    %edx,(%eax)
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	8b 00                	mov    (%eax),%eax
  8008e8:	83 e8 08             	sub    $0x8,%eax
  8008eb:	8b 50 04             	mov    0x4(%eax),%edx
  8008ee:	8b 00                	mov    (%eax),%eax
  8008f0:	eb 40                	jmp    800932 <getuint+0x65>
	else if (lflag)
  8008f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f6:	74 1e                	je     800916 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	8b 00                	mov    (%eax),%eax
  8008fd:	8d 50 04             	lea    0x4(%eax),%edx
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	89 10                	mov    %edx,(%eax)
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	8b 00                	mov    (%eax),%eax
  80090a:	83 e8 04             	sub    $0x4,%eax
  80090d:	8b 00                	mov    (%eax),%eax
  80090f:	ba 00 00 00 00       	mov    $0x0,%edx
  800914:	eb 1c                	jmp    800932 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	8b 00                	mov    (%eax),%eax
  80091b:	8d 50 04             	lea    0x4(%eax),%edx
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	89 10                	mov    %edx,(%eax)
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	8b 00                	mov    (%eax),%eax
  800928:	83 e8 04             	sub    $0x4,%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    

00800934 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800937:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80093b:	7e 1c                	jle    800959 <getint+0x25>
		return va_arg(*ap, long long);
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	8d 50 08             	lea    0x8(%eax),%edx
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	89 10                	mov    %edx,(%eax)
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	83 e8 08             	sub    $0x8,%eax
  800952:	8b 50 04             	mov    0x4(%eax),%edx
  800955:	8b 00                	mov    (%eax),%eax
  800957:	eb 38                	jmp    800991 <getint+0x5d>
	else if (lflag)
  800959:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80095d:	74 1a                	je     800979 <getint+0x45>
		return va_arg(*ap, long);
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	8b 00                	mov    (%eax),%eax
  800964:	8d 50 04             	lea    0x4(%eax),%edx
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	89 10                	mov    %edx,(%eax)
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	8b 00                	mov    (%eax),%eax
  800971:	83 e8 04             	sub    $0x4,%eax
  800974:	8b 00                	mov    (%eax),%eax
  800976:	99                   	cltd   
  800977:	eb 18                	jmp    800991 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	8b 00                	mov    (%eax),%eax
  80097e:	8d 50 04             	lea    0x4(%eax),%edx
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	89 10                	mov    %edx,(%eax)
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	8b 00                	mov    (%eax),%eax
  80098b:	83 e8 04             	sub    $0x4,%eax
  80098e:	8b 00                	mov    (%eax),%eax
  800990:	99                   	cltd   
}
  800991:	5d                   	pop    %ebp
  800992:	c3                   	ret    

00800993 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	56                   	push   %esi
  800997:	53                   	push   %ebx
  800998:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80099b:	eb 17                	jmp    8009b4 <vprintfmt+0x21>
			if (ch == '\0')
  80099d:	85 db                	test   %ebx,%ebx
  80099f:	0f 84 c1 03 00 00    	je     800d66 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009a5:	83 ec 08             	sub    $0x8,%esp
  8009a8:	ff 75 0c             	pushl  0xc(%ebp)
  8009ab:	53                   	push   %ebx
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	ff d0                	call   *%eax
  8009b1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b7:	8d 50 01             	lea    0x1(%eax),%edx
  8009ba:	89 55 10             	mov    %edx,0x10(%ebp)
  8009bd:	8a 00                	mov    (%eax),%al
  8009bf:	0f b6 d8             	movzbl %al,%ebx
  8009c2:	83 fb 25             	cmp    $0x25,%ebx
  8009c5:	75 d6                	jne    80099d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009c7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009cb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009d2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009d9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009e0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ea:	8d 50 01             	lea    0x1(%eax),%edx
  8009ed:	89 55 10             	mov    %edx,0x10(%ebp)
  8009f0:	8a 00                	mov    (%eax),%al
  8009f2:	0f b6 d8             	movzbl %al,%ebx
  8009f5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009f8:	83 f8 5b             	cmp    $0x5b,%eax
  8009fb:	0f 87 3d 03 00 00    	ja     800d3e <vprintfmt+0x3ab>
  800a01:	8b 04 85 38 25 80 00 	mov    0x802538(,%eax,4),%eax
  800a08:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a0a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a0e:	eb d7                	jmp    8009e7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a10:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a14:	eb d1                	jmp    8009e7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a16:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a1d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a20:	89 d0                	mov    %edx,%eax
  800a22:	c1 e0 02             	shl    $0x2,%eax
  800a25:	01 d0                	add    %edx,%eax
  800a27:	01 c0                	add    %eax,%eax
  800a29:	01 d8                	add    %ebx,%eax
  800a2b:	83 e8 30             	sub    $0x30,%eax
  800a2e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a31:	8b 45 10             	mov    0x10(%ebp),%eax
  800a34:	8a 00                	mov    (%eax),%al
  800a36:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a39:	83 fb 2f             	cmp    $0x2f,%ebx
  800a3c:	7e 3e                	jle    800a7c <vprintfmt+0xe9>
  800a3e:	83 fb 39             	cmp    $0x39,%ebx
  800a41:	7f 39                	jg     800a7c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a43:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a46:	eb d5                	jmp    800a1d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a48:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4b:	83 c0 04             	add    $0x4,%eax
  800a4e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a51:	8b 45 14             	mov    0x14(%ebp),%eax
  800a54:	83 e8 04             	sub    $0x4,%eax
  800a57:	8b 00                	mov    (%eax),%eax
  800a59:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a5c:	eb 1f                	jmp    800a7d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a62:	79 83                	jns    8009e7 <vprintfmt+0x54>
				width = 0;
  800a64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a6b:	e9 77 ff ff ff       	jmp    8009e7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a70:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a77:	e9 6b ff ff ff       	jmp    8009e7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a7c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a7d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a81:	0f 89 60 ff ff ff    	jns    8009e7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a8d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a94:	e9 4e ff ff ff       	jmp    8009e7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a99:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a9c:	e9 46 ff ff ff       	jmp    8009e7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800aa1:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa4:	83 c0 04             	add    $0x4,%eax
  800aa7:	89 45 14             	mov    %eax,0x14(%ebp)
  800aaa:	8b 45 14             	mov    0x14(%ebp),%eax
  800aad:	83 e8 04             	sub    $0x4,%eax
  800ab0:	8b 00                	mov    (%eax),%eax
  800ab2:	83 ec 08             	sub    $0x8,%esp
  800ab5:	ff 75 0c             	pushl  0xc(%ebp)
  800ab8:	50                   	push   %eax
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	ff d0                	call   *%eax
  800abe:	83 c4 10             	add    $0x10,%esp
			break;
  800ac1:	e9 9b 02 00 00       	jmp    800d61 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ac6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac9:	83 c0 04             	add    $0x4,%eax
  800acc:	89 45 14             	mov    %eax,0x14(%ebp)
  800acf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad2:	83 e8 04             	sub    $0x4,%eax
  800ad5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ad7:	85 db                	test   %ebx,%ebx
  800ad9:	79 02                	jns    800add <vprintfmt+0x14a>
				err = -err;
  800adb:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800add:	83 fb 64             	cmp    $0x64,%ebx
  800ae0:	7f 0b                	jg     800aed <vprintfmt+0x15a>
  800ae2:	8b 34 9d 80 23 80 00 	mov    0x802380(,%ebx,4),%esi
  800ae9:	85 f6                	test   %esi,%esi
  800aeb:	75 19                	jne    800b06 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aed:	53                   	push   %ebx
  800aee:	68 25 25 80 00       	push   $0x802525
  800af3:	ff 75 0c             	pushl  0xc(%ebp)
  800af6:	ff 75 08             	pushl  0x8(%ebp)
  800af9:	e8 70 02 00 00       	call   800d6e <printfmt>
  800afe:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b01:	e9 5b 02 00 00       	jmp    800d61 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b06:	56                   	push   %esi
  800b07:	68 2e 25 80 00       	push   $0x80252e
  800b0c:	ff 75 0c             	pushl  0xc(%ebp)
  800b0f:	ff 75 08             	pushl  0x8(%ebp)
  800b12:	e8 57 02 00 00       	call   800d6e <printfmt>
  800b17:	83 c4 10             	add    $0x10,%esp
			break;
  800b1a:	e9 42 02 00 00       	jmp    800d61 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b22:	83 c0 04             	add    $0x4,%eax
  800b25:	89 45 14             	mov    %eax,0x14(%ebp)
  800b28:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2b:	83 e8 04             	sub    $0x4,%eax
  800b2e:	8b 30                	mov    (%eax),%esi
  800b30:	85 f6                	test   %esi,%esi
  800b32:	75 05                	jne    800b39 <vprintfmt+0x1a6>
				p = "(null)";
  800b34:	be 31 25 80 00       	mov    $0x802531,%esi
			if (width > 0 && padc != '-')
  800b39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b3d:	7e 6d                	jle    800bac <vprintfmt+0x219>
  800b3f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b43:	74 67                	je     800bac <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b48:	83 ec 08             	sub    $0x8,%esp
  800b4b:	50                   	push   %eax
  800b4c:	56                   	push   %esi
  800b4d:	e8 1e 03 00 00       	call   800e70 <strnlen>
  800b52:	83 c4 10             	add    $0x10,%esp
  800b55:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b58:	eb 16                	jmp    800b70 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b5a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b5e:	83 ec 08             	sub    $0x8,%esp
  800b61:	ff 75 0c             	pushl  0xc(%ebp)
  800b64:	50                   	push   %eax
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	ff d0                	call   *%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b6d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b70:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b74:	7f e4                	jg     800b5a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b76:	eb 34                	jmp    800bac <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b78:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b7c:	74 1c                	je     800b9a <vprintfmt+0x207>
  800b7e:	83 fb 1f             	cmp    $0x1f,%ebx
  800b81:	7e 05                	jle    800b88 <vprintfmt+0x1f5>
  800b83:	83 fb 7e             	cmp    $0x7e,%ebx
  800b86:	7e 12                	jle    800b9a <vprintfmt+0x207>
					putch('?', putdat);
  800b88:	83 ec 08             	sub    $0x8,%esp
  800b8b:	ff 75 0c             	pushl  0xc(%ebp)
  800b8e:	6a 3f                	push   $0x3f
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
  800b93:	ff d0                	call   *%eax
  800b95:	83 c4 10             	add    $0x10,%esp
  800b98:	eb 0f                	jmp    800ba9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b9a:	83 ec 08             	sub    $0x8,%esp
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	53                   	push   %ebx
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	ff d0                	call   *%eax
  800ba6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ba9:	ff 4d e4             	decl   -0x1c(%ebp)
  800bac:	89 f0                	mov    %esi,%eax
  800bae:	8d 70 01             	lea    0x1(%eax),%esi
  800bb1:	8a 00                	mov    (%eax),%al
  800bb3:	0f be d8             	movsbl %al,%ebx
  800bb6:	85 db                	test   %ebx,%ebx
  800bb8:	74 24                	je     800bde <vprintfmt+0x24b>
  800bba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bbe:	78 b8                	js     800b78 <vprintfmt+0x1e5>
  800bc0:	ff 4d e0             	decl   -0x20(%ebp)
  800bc3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bc7:	79 af                	jns    800b78 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc9:	eb 13                	jmp    800bde <vprintfmt+0x24b>
				putch(' ', putdat);
  800bcb:	83 ec 08             	sub    $0x8,%esp
  800bce:	ff 75 0c             	pushl  0xc(%ebp)
  800bd1:	6a 20                	push   $0x20
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	ff d0                	call   *%eax
  800bd8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bdb:	ff 4d e4             	decl   -0x1c(%ebp)
  800bde:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800be2:	7f e7                	jg     800bcb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800be4:	e9 78 01 00 00       	jmp    800d61 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800be9:	83 ec 08             	sub    $0x8,%esp
  800bec:	ff 75 e8             	pushl  -0x18(%ebp)
  800bef:	8d 45 14             	lea    0x14(%ebp),%eax
  800bf2:	50                   	push   %eax
  800bf3:	e8 3c fd ff ff       	call   800934 <getint>
  800bf8:	83 c4 10             	add    $0x10,%esp
  800bfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c07:	85 d2                	test   %edx,%edx
  800c09:	79 23                	jns    800c2e <vprintfmt+0x29b>
				putch('-', putdat);
  800c0b:	83 ec 08             	sub    $0x8,%esp
  800c0e:	ff 75 0c             	pushl  0xc(%ebp)
  800c11:	6a 2d                	push   $0x2d
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	ff d0                	call   *%eax
  800c18:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c21:	f7 d8                	neg    %eax
  800c23:	83 d2 00             	adc    $0x0,%edx
  800c26:	f7 da                	neg    %edx
  800c28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c2e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c35:	e9 bc 00 00 00       	jmp    800cf6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c3a:	83 ec 08             	sub    $0x8,%esp
  800c3d:	ff 75 e8             	pushl  -0x18(%ebp)
  800c40:	8d 45 14             	lea    0x14(%ebp),%eax
  800c43:	50                   	push   %eax
  800c44:	e8 84 fc ff ff       	call   8008cd <getuint>
  800c49:	83 c4 10             	add    $0x10,%esp
  800c4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c52:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c59:	e9 98 00 00 00       	jmp    800cf6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c5e:	83 ec 08             	sub    $0x8,%esp
  800c61:	ff 75 0c             	pushl  0xc(%ebp)
  800c64:	6a 58                	push   $0x58
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	ff d0                	call   *%eax
  800c6b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c6e:	83 ec 08             	sub    $0x8,%esp
  800c71:	ff 75 0c             	pushl  0xc(%ebp)
  800c74:	6a 58                	push   $0x58
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	ff d0                	call   *%eax
  800c7b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c7e:	83 ec 08             	sub    $0x8,%esp
  800c81:	ff 75 0c             	pushl  0xc(%ebp)
  800c84:	6a 58                	push   $0x58
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	ff d0                	call   *%eax
  800c8b:	83 c4 10             	add    $0x10,%esp
			break;
  800c8e:	e9 ce 00 00 00       	jmp    800d61 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c93:	83 ec 08             	sub    $0x8,%esp
  800c96:	ff 75 0c             	pushl  0xc(%ebp)
  800c99:	6a 30                	push   $0x30
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	ff d0                	call   *%eax
  800ca0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ca3:	83 ec 08             	sub    $0x8,%esp
  800ca6:	ff 75 0c             	pushl  0xc(%ebp)
  800ca9:	6a 78                	push   $0x78
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	ff d0                	call   *%eax
  800cb0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb6:	83 c0 04             	add    $0x4,%eax
  800cb9:	89 45 14             	mov    %eax,0x14(%ebp)
  800cbc:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbf:	83 e8 04             	sub    $0x4,%eax
  800cc2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cce:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cd5:	eb 1f                	jmp    800cf6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cd7:	83 ec 08             	sub    $0x8,%esp
  800cda:	ff 75 e8             	pushl  -0x18(%ebp)
  800cdd:	8d 45 14             	lea    0x14(%ebp),%eax
  800ce0:	50                   	push   %eax
  800ce1:	e8 e7 fb ff ff       	call   8008cd <getuint>
  800ce6:	83 c4 10             	add    $0x10,%esp
  800ce9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cf6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cfd:	83 ec 04             	sub    $0x4,%esp
  800d00:	52                   	push   %edx
  800d01:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d04:	50                   	push   %eax
  800d05:	ff 75 f4             	pushl  -0xc(%ebp)
  800d08:	ff 75 f0             	pushl  -0x10(%ebp)
  800d0b:	ff 75 0c             	pushl  0xc(%ebp)
  800d0e:	ff 75 08             	pushl  0x8(%ebp)
  800d11:	e8 00 fb ff ff       	call   800816 <printnum>
  800d16:	83 c4 20             	add    $0x20,%esp
			break;
  800d19:	eb 46                	jmp    800d61 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d1b:	83 ec 08             	sub    $0x8,%esp
  800d1e:	ff 75 0c             	pushl  0xc(%ebp)
  800d21:	53                   	push   %ebx
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	ff d0                	call   *%eax
  800d27:	83 c4 10             	add    $0x10,%esp
			break;
  800d2a:	eb 35                	jmp    800d61 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d2c:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  800d33:	eb 2c                	jmp    800d61 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d35:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  800d3c:	eb 23                	jmp    800d61 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d3e:	83 ec 08             	sub    $0x8,%esp
  800d41:	ff 75 0c             	pushl  0xc(%ebp)
  800d44:	6a 25                	push   $0x25
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	ff d0                	call   *%eax
  800d4b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d4e:	ff 4d 10             	decl   0x10(%ebp)
  800d51:	eb 03                	jmp    800d56 <vprintfmt+0x3c3>
  800d53:	ff 4d 10             	decl   0x10(%ebp)
  800d56:	8b 45 10             	mov    0x10(%ebp),%eax
  800d59:	48                   	dec    %eax
  800d5a:	8a 00                	mov    (%eax),%al
  800d5c:	3c 25                	cmp    $0x25,%al
  800d5e:	75 f3                	jne    800d53 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d60:	90                   	nop
		}
	}
  800d61:	e9 35 fc ff ff       	jmp    80099b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d66:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d67:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d6a:	5b                   	pop    %ebx
  800d6b:	5e                   	pop    %esi
  800d6c:	5d                   	pop    %ebp
  800d6d:	c3                   	ret    

00800d6e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d74:	8d 45 10             	lea    0x10(%ebp),%eax
  800d77:	83 c0 04             	add    $0x4,%eax
  800d7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d80:	ff 75 f4             	pushl  -0xc(%ebp)
  800d83:	50                   	push   %eax
  800d84:	ff 75 0c             	pushl  0xc(%ebp)
  800d87:	ff 75 08             	pushl  0x8(%ebp)
  800d8a:	e8 04 fc ff ff       	call   800993 <vprintfmt>
  800d8f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d92:	90                   	nop
  800d93:	c9                   	leave  
  800d94:	c3                   	ret    

00800d95 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9b:	8b 40 08             	mov    0x8(%eax),%eax
  800d9e:	8d 50 01             	lea    0x1(%eax),%edx
  800da1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daa:	8b 10                	mov    (%eax),%edx
  800dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daf:	8b 40 04             	mov    0x4(%eax),%eax
  800db2:	39 c2                	cmp    %eax,%edx
  800db4:	73 12                	jae    800dc8 <sprintputch+0x33>
		*b->buf++ = ch;
  800db6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db9:	8b 00                	mov    (%eax),%eax
  800dbb:	8d 48 01             	lea    0x1(%eax),%ecx
  800dbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc1:	89 0a                	mov    %ecx,(%edx)
  800dc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc6:	88 10                	mov    %dl,(%eax)
}
  800dc8:	90                   	nop
  800dc9:	5d                   	pop    %ebp
  800dca:	c3                   	ret    

00800dcb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dda:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	01 d0                	add    %edx,%eax
  800de2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800de5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800df0:	74 06                	je     800df8 <vsnprintf+0x2d>
  800df2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800df6:	7f 07                	jg     800dff <vsnprintf+0x34>
		return -E_INVAL;
  800df8:	b8 03 00 00 00       	mov    $0x3,%eax
  800dfd:	eb 20                	jmp    800e1f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dff:	ff 75 14             	pushl  0x14(%ebp)
  800e02:	ff 75 10             	pushl  0x10(%ebp)
  800e05:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e08:	50                   	push   %eax
  800e09:	68 95 0d 80 00       	push   $0x800d95
  800e0e:	e8 80 fb ff ff       	call   800993 <vprintfmt>
  800e13:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e19:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e1f:	c9                   	leave  
  800e20:	c3                   	ret    

00800e21 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e27:	8d 45 10             	lea    0x10(%ebp),%eax
  800e2a:	83 c0 04             	add    $0x4,%eax
  800e2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e30:	8b 45 10             	mov    0x10(%ebp),%eax
  800e33:	ff 75 f4             	pushl  -0xc(%ebp)
  800e36:	50                   	push   %eax
  800e37:	ff 75 0c             	pushl  0xc(%ebp)
  800e3a:	ff 75 08             	pushl  0x8(%ebp)
  800e3d:	e8 89 ff ff ff       	call   800dcb <vsnprintf>
  800e42:	83 c4 10             	add    $0x10,%esp
  800e45:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e4b:	c9                   	leave  
  800e4c:	c3                   	ret    

00800e4d <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e5a:	eb 06                	jmp    800e62 <strlen+0x15>
		n++;
  800e5c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e5f:	ff 45 08             	incl   0x8(%ebp)
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	8a 00                	mov    (%eax),%al
  800e67:	84 c0                	test   %al,%al
  800e69:	75 f1                	jne    800e5c <strlen+0xf>
		n++;
	return n;
  800e6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e6e:	c9                   	leave  
  800e6f:	c3                   	ret    

00800e70 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e7d:	eb 09                	jmp    800e88 <strnlen+0x18>
		n++;
  800e7f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e82:	ff 45 08             	incl   0x8(%ebp)
  800e85:	ff 4d 0c             	decl   0xc(%ebp)
  800e88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e8c:	74 09                	je     800e97 <strnlen+0x27>
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	8a 00                	mov    (%eax),%al
  800e93:	84 c0                	test   %al,%al
  800e95:	75 e8                	jne    800e7f <strnlen+0xf>
		n++;
	return n;
  800e97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e9a:	c9                   	leave  
  800e9b:	c3                   	ret    

00800e9c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ea8:	90                   	nop
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8d 50 01             	lea    0x1(%eax),%edx
  800eaf:	89 55 08             	mov    %edx,0x8(%ebp)
  800eb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ebb:	8a 12                	mov    (%edx),%dl
  800ebd:	88 10                	mov    %dl,(%eax)
  800ebf:	8a 00                	mov    (%eax),%al
  800ec1:	84 c0                	test   %al,%al
  800ec3:	75 e4                	jne    800ea9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ec5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ec8:	c9                   	leave  
  800ec9:	c3                   	ret    

00800eca <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ed6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800edd:	eb 1f                	jmp    800efe <strncpy+0x34>
		*dst++ = *src;
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	8d 50 01             	lea    0x1(%eax),%edx
  800ee5:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eeb:	8a 12                	mov    (%edx),%dl
  800eed:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	84 c0                	test   %al,%al
  800ef6:	74 03                	je     800efb <strncpy+0x31>
			src++;
  800ef8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800efb:	ff 45 fc             	incl   -0x4(%ebp)
  800efe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f01:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f04:	72 d9                	jb     800edf <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f06:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f09:	c9                   	leave  
  800f0a:	c3                   	ret    

00800f0b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1b:	74 30                	je     800f4d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f1d:	eb 16                	jmp    800f35 <strlcpy+0x2a>
			*dst++ = *src++;
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8d 50 01             	lea    0x1(%eax),%edx
  800f25:	89 55 08             	mov    %edx,0x8(%ebp)
  800f28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f2e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f31:	8a 12                	mov    (%edx),%dl
  800f33:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f35:	ff 4d 10             	decl   0x10(%ebp)
  800f38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3c:	74 09                	je     800f47 <strlcpy+0x3c>
  800f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f41:	8a 00                	mov    (%eax),%al
  800f43:	84 c0                	test   %al,%al
  800f45:	75 d8                	jne    800f1f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f53:	29 c2                	sub    %eax,%edx
  800f55:	89 d0                	mov    %edx,%eax
}
  800f57:	c9                   	leave  
  800f58:	c3                   	ret    

00800f59 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f5c:	eb 06                	jmp    800f64 <strcmp+0xb>
		p++, q++;
  800f5e:	ff 45 08             	incl   0x8(%ebp)
  800f61:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	84 c0                	test   %al,%al
  800f6b:	74 0e                	je     800f7b <strcmp+0x22>
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 10                	mov    (%eax),%dl
  800f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	38 c2                	cmp    %al,%dl
  800f79:	74 e3                	je     800f5e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7e:	8a 00                	mov    (%eax),%al
  800f80:	0f b6 d0             	movzbl %al,%edx
  800f83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f86:	8a 00                	mov    (%eax),%al
  800f88:	0f b6 c0             	movzbl %al,%eax
  800f8b:	29 c2                	sub    %eax,%edx
  800f8d:	89 d0                	mov    %edx,%eax
}
  800f8f:	5d                   	pop    %ebp
  800f90:	c3                   	ret    

00800f91 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f94:	eb 09                	jmp    800f9f <strncmp+0xe>
		n--, p++, q++;
  800f96:	ff 4d 10             	decl   0x10(%ebp)
  800f99:	ff 45 08             	incl   0x8(%ebp)
  800f9c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa3:	74 17                	je     800fbc <strncmp+0x2b>
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	84 c0                	test   %al,%al
  800fac:	74 0e                	je     800fbc <strncmp+0x2b>
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	8a 10                	mov    (%eax),%dl
  800fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	38 c2                	cmp    %al,%dl
  800fba:	74 da                	je     800f96 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fbc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc0:	75 07                	jne    800fc9 <strncmp+0x38>
		return 0;
  800fc2:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc7:	eb 14                	jmp    800fdd <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	0f b6 d0             	movzbl %al,%edx
  800fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	0f b6 c0             	movzbl %al,%eax
  800fd9:	29 c2                	sub    %eax,%edx
  800fdb:	89 d0                	mov    %edx,%eax
}
  800fdd:	5d                   	pop    %ebp
  800fde:	c3                   	ret    

00800fdf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	83 ec 04             	sub    $0x4,%esp
  800fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800feb:	eb 12                	jmp    800fff <strchr+0x20>
		if (*s == c)
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	8a 00                	mov    (%eax),%al
  800ff2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ff5:	75 05                	jne    800ffc <strchr+0x1d>
			return (char *) s;
  800ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffa:	eb 11                	jmp    80100d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ffc:	ff 45 08             	incl   0x8(%ebp)
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	8a 00                	mov    (%eax),%al
  801004:	84 c0                	test   %al,%al
  801006:	75 e5                	jne    800fed <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801008:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80100d:	c9                   	leave  
  80100e:	c3                   	ret    

0080100f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	83 ec 04             	sub    $0x4,%esp
  801015:	8b 45 0c             	mov    0xc(%ebp),%eax
  801018:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80101b:	eb 0d                	jmp    80102a <strfind+0x1b>
		if (*s == c)
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801025:	74 0e                	je     801035 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801027:	ff 45 08             	incl   0x8(%ebp)
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	84 c0                	test   %al,%al
  801031:	75 ea                	jne    80101d <strfind+0xe>
  801033:	eb 01                	jmp    801036 <strfind+0x27>
		if (*s == c)
			break;
  801035:	90                   	nop
	return (char *) s;
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801039:	c9                   	leave  
  80103a:	c3                   	ret    

0080103b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80103b:	55                   	push   %ebp
  80103c:	89 e5                	mov    %esp,%ebp
  80103e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801047:	8b 45 10             	mov    0x10(%ebp),%eax
  80104a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80104d:	eb 0e                	jmp    80105d <memset+0x22>
		*p++ = c;
  80104f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801052:	8d 50 01             	lea    0x1(%eax),%edx
  801055:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801058:	8b 55 0c             	mov    0xc(%ebp),%edx
  80105b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80105d:	ff 4d f8             	decl   -0x8(%ebp)
  801060:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801064:	79 e9                	jns    80104f <memset+0x14>
		*p++ = c;

	return v;
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801069:	c9                   	leave  
  80106a:	c3                   	ret    

0080106b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801071:	8b 45 0c             	mov    0xc(%ebp),%eax
  801074:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801077:	8b 45 08             	mov    0x8(%ebp),%eax
  80107a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80107d:	eb 16                	jmp    801095 <memcpy+0x2a>
		*d++ = *s++;
  80107f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801082:	8d 50 01             	lea    0x1(%eax),%edx
  801085:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801088:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80108b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80108e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801091:	8a 12                	mov    (%edx),%dl
  801093:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801095:	8b 45 10             	mov    0x10(%ebp),%eax
  801098:	8d 50 ff             	lea    -0x1(%eax),%edx
  80109b:	89 55 10             	mov    %edx,0x10(%ebp)
  80109e:	85 c0                	test   %eax,%eax
  8010a0:	75 dd                	jne    80107f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010bc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010bf:	73 50                	jae    801111 <memmove+0x6a>
  8010c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c7:	01 d0                	add    %edx,%eax
  8010c9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010cc:	76 43                	jbe    801111 <memmove+0x6a>
		s += n;
  8010ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010da:	eb 10                	jmp    8010ec <memmove+0x45>
			*--d = *--s;
  8010dc:	ff 4d f8             	decl   -0x8(%ebp)
  8010df:	ff 4d fc             	decl   -0x4(%ebp)
  8010e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e5:	8a 10                	mov    (%eax),%dl
  8010e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ea:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f5:	85 c0                	test   %eax,%eax
  8010f7:	75 e3                	jne    8010dc <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010f9:	eb 23                	jmp    80111e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fe:	8d 50 01             	lea    0x1(%eax),%edx
  801101:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801104:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801107:	8d 4a 01             	lea    0x1(%edx),%ecx
  80110a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80110d:	8a 12                	mov    (%edx),%dl
  80110f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801111:	8b 45 10             	mov    0x10(%ebp),%eax
  801114:	8d 50 ff             	lea    -0x1(%eax),%edx
  801117:	89 55 10             	mov    %edx,0x10(%ebp)
  80111a:	85 c0                	test   %eax,%eax
  80111c:	75 dd                	jne    8010fb <memmove+0x54>
			*d++ = *s++;

	return dst;
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801121:	c9                   	leave  
  801122:	c3                   	ret    

00801123 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801123:	55                   	push   %ebp
  801124:	89 e5                	mov    %esp,%ebp
  801126:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80112f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801132:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801135:	eb 2a                	jmp    801161 <memcmp+0x3e>
		if (*s1 != *s2)
  801137:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80113a:	8a 10                	mov    (%eax),%dl
  80113c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	38 c2                	cmp    %al,%dl
  801143:	74 16                	je     80115b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801145:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	0f b6 d0             	movzbl %al,%edx
  80114d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	0f b6 c0             	movzbl %al,%eax
  801155:	29 c2                	sub    %eax,%edx
  801157:	89 d0                	mov    %edx,%eax
  801159:	eb 18                	jmp    801173 <memcmp+0x50>
		s1++, s2++;
  80115b:	ff 45 fc             	incl   -0x4(%ebp)
  80115e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801161:	8b 45 10             	mov    0x10(%ebp),%eax
  801164:	8d 50 ff             	lea    -0x1(%eax),%edx
  801167:	89 55 10             	mov    %edx,0x10(%ebp)
  80116a:	85 c0                	test   %eax,%eax
  80116c:	75 c9                	jne    801137 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80116e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801173:	c9                   	leave  
  801174:	c3                   	ret    

00801175 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
  801178:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80117b:	8b 55 08             	mov    0x8(%ebp),%edx
  80117e:	8b 45 10             	mov    0x10(%ebp),%eax
  801181:	01 d0                	add    %edx,%eax
  801183:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801186:	eb 15                	jmp    80119d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	8a 00                	mov    (%eax),%al
  80118d:	0f b6 d0             	movzbl %al,%edx
  801190:	8b 45 0c             	mov    0xc(%ebp),%eax
  801193:	0f b6 c0             	movzbl %al,%eax
  801196:	39 c2                	cmp    %eax,%edx
  801198:	74 0d                	je     8011a7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80119a:	ff 45 08             	incl   0x8(%ebp)
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011a3:	72 e3                	jb     801188 <memfind+0x13>
  8011a5:	eb 01                	jmp    8011a8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011a7:	90                   	nop
	return (void *) s;
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011ab:	c9                   	leave  
  8011ac:	c3                   	ret    

008011ad <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
  8011b0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011ba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011c1:	eb 03                	jmp    8011c6 <strtol+0x19>
		s++;
  8011c3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	3c 20                	cmp    $0x20,%al
  8011cd:	74 f4                	je     8011c3 <strtol+0x16>
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	3c 09                	cmp    $0x9,%al
  8011d6:	74 eb                	je     8011c3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	3c 2b                	cmp    $0x2b,%al
  8011df:	75 05                	jne    8011e6 <strtol+0x39>
		s++;
  8011e1:	ff 45 08             	incl   0x8(%ebp)
  8011e4:	eb 13                	jmp    8011f9 <strtol+0x4c>
	else if (*s == '-')
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8a 00                	mov    (%eax),%al
  8011eb:	3c 2d                	cmp    $0x2d,%al
  8011ed:	75 0a                	jne    8011f9 <strtol+0x4c>
		s++, neg = 1;
  8011ef:	ff 45 08             	incl   0x8(%ebp)
  8011f2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011fd:	74 06                	je     801205 <strtol+0x58>
  8011ff:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801203:	75 20                	jne    801225 <strtol+0x78>
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	8a 00                	mov    (%eax),%al
  80120a:	3c 30                	cmp    $0x30,%al
  80120c:	75 17                	jne    801225 <strtol+0x78>
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	40                   	inc    %eax
  801212:	8a 00                	mov    (%eax),%al
  801214:	3c 78                	cmp    $0x78,%al
  801216:	75 0d                	jne    801225 <strtol+0x78>
		s += 2, base = 16;
  801218:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80121c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801223:	eb 28                	jmp    80124d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801225:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801229:	75 15                	jne    801240 <strtol+0x93>
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8a 00                	mov    (%eax),%al
  801230:	3c 30                	cmp    $0x30,%al
  801232:	75 0c                	jne    801240 <strtol+0x93>
		s++, base = 8;
  801234:	ff 45 08             	incl   0x8(%ebp)
  801237:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80123e:	eb 0d                	jmp    80124d <strtol+0xa0>
	else if (base == 0)
  801240:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801244:	75 07                	jne    80124d <strtol+0xa0>
		base = 10;
  801246:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	3c 2f                	cmp    $0x2f,%al
  801254:	7e 19                	jle    80126f <strtol+0xc2>
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	8a 00                	mov    (%eax),%al
  80125b:	3c 39                	cmp    $0x39,%al
  80125d:	7f 10                	jg     80126f <strtol+0xc2>
			dig = *s - '0';
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	0f be c0             	movsbl %al,%eax
  801267:	83 e8 30             	sub    $0x30,%eax
  80126a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80126d:	eb 42                	jmp    8012b1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	8a 00                	mov    (%eax),%al
  801274:	3c 60                	cmp    $0x60,%al
  801276:	7e 19                	jle    801291 <strtol+0xe4>
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8a 00                	mov    (%eax),%al
  80127d:	3c 7a                	cmp    $0x7a,%al
  80127f:	7f 10                	jg     801291 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	0f be c0             	movsbl %al,%eax
  801289:	83 e8 57             	sub    $0x57,%eax
  80128c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80128f:	eb 20                	jmp    8012b1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	8a 00                	mov    (%eax),%al
  801296:	3c 40                	cmp    $0x40,%al
  801298:	7e 39                	jle    8012d3 <strtol+0x126>
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	8a 00                	mov    (%eax),%al
  80129f:	3c 5a                	cmp    $0x5a,%al
  8012a1:	7f 30                	jg     8012d3 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	0f be c0             	movsbl %al,%eax
  8012ab:	83 e8 37             	sub    $0x37,%eax
  8012ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012b7:	7d 19                	jge    8012d2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012b9:	ff 45 08             	incl   0x8(%ebp)
  8012bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012bf:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012c3:	89 c2                	mov    %eax,%edx
  8012c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c8:	01 d0                	add    %edx,%eax
  8012ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012cd:	e9 7b ff ff ff       	jmp    80124d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012d2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012d7:	74 08                	je     8012e1 <strtol+0x134>
		*endptr = (char *) s;
  8012d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8012df:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012e5:	74 07                	je     8012ee <strtol+0x141>
  8012e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ea:	f7 d8                	neg    %eax
  8012ec:	eb 03                	jmp    8012f1 <strtol+0x144>
  8012ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012f1:	c9                   	leave  
  8012f2:	c3                   	ret    

008012f3 <ltostr>:

void
ltostr(long value, char *str)
{
  8012f3:	55                   	push   %ebp
  8012f4:	89 e5                	mov    %esp,%ebp
  8012f6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801300:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801307:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80130b:	79 13                	jns    801320 <ltostr+0x2d>
	{
		neg = 1;
  80130d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801314:	8b 45 0c             	mov    0xc(%ebp),%eax
  801317:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80131a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80131d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801328:	99                   	cltd   
  801329:	f7 f9                	idiv   %ecx
  80132b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80132e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801331:	8d 50 01             	lea    0x1(%eax),%edx
  801334:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801337:	89 c2                	mov    %eax,%edx
  801339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133c:	01 d0                	add    %edx,%eax
  80133e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801341:	83 c2 30             	add    $0x30,%edx
  801344:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801346:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801349:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80134e:	f7 e9                	imul   %ecx
  801350:	c1 fa 02             	sar    $0x2,%edx
  801353:	89 c8                	mov    %ecx,%eax
  801355:	c1 f8 1f             	sar    $0x1f,%eax
  801358:	29 c2                	sub    %eax,%edx
  80135a:	89 d0                	mov    %edx,%eax
  80135c:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80135f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801363:	75 bb                	jne    801320 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801365:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80136c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136f:	48                   	dec    %eax
  801370:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801373:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801377:	74 3d                	je     8013b6 <ltostr+0xc3>
		start = 1 ;
  801379:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801380:	eb 34                	jmp    8013b6 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801382:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801385:	8b 45 0c             	mov    0xc(%ebp),%eax
  801388:	01 d0                	add    %edx,%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80138f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801392:	8b 45 0c             	mov    0xc(%ebp),%eax
  801395:	01 c2                	add    %eax,%edx
  801397:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80139a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139d:	01 c8                	add    %ecx,%eax
  80139f:	8a 00                	mov    (%eax),%al
  8013a1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a9:	01 c2                	add    %eax,%edx
  8013ab:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013ae:	88 02                	mov    %al,(%edx)
		start++ ;
  8013b0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013b3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013bc:	7c c4                	jl     801382 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013be:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c4:	01 d0                	add    %edx,%eax
  8013c6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013c9:	90                   	nop
  8013ca:	c9                   	leave  
  8013cb:	c3                   	ret    

008013cc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
  8013cf:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013d2:	ff 75 08             	pushl  0x8(%ebp)
  8013d5:	e8 73 fa ff ff       	call   800e4d <strlen>
  8013da:	83 c4 04             	add    $0x4,%esp
  8013dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013e0:	ff 75 0c             	pushl  0xc(%ebp)
  8013e3:	e8 65 fa ff ff       	call   800e4d <strlen>
  8013e8:	83 c4 04             	add    $0x4,%esp
  8013eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013fc:	eb 17                	jmp    801415 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801401:	8b 45 10             	mov    0x10(%ebp),%eax
  801404:	01 c2                	add    %eax,%edx
  801406:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801409:	8b 45 08             	mov    0x8(%ebp),%eax
  80140c:	01 c8                	add    %ecx,%eax
  80140e:	8a 00                	mov    (%eax),%al
  801410:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801412:	ff 45 fc             	incl   -0x4(%ebp)
  801415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801418:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80141b:	7c e1                	jl     8013fe <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80141d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801424:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80142b:	eb 1f                	jmp    80144c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80142d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801430:	8d 50 01             	lea    0x1(%eax),%edx
  801433:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801436:	89 c2                	mov    %eax,%edx
  801438:	8b 45 10             	mov    0x10(%ebp),%eax
  80143b:	01 c2                	add    %eax,%edx
  80143d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801440:	8b 45 0c             	mov    0xc(%ebp),%eax
  801443:	01 c8                	add    %ecx,%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801449:	ff 45 f8             	incl   -0x8(%ebp)
  80144c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80144f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801452:	7c d9                	jl     80142d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801454:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801457:	8b 45 10             	mov    0x10(%ebp),%eax
  80145a:	01 d0                	add    %edx,%eax
  80145c:	c6 00 00             	movb   $0x0,(%eax)
}
  80145f:	90                   	nop
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801465:	8b 45 14             	mov    0x14(%ebp),%eax
  801468:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80146e:	8b 45 14             	mov    0x14(%ebp),%eax
  801471:	8b 00                	mov    (%eax),%eax
  801473:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80147a:	8b 45 10             	mov    0x10(%ebp),%eax
  80147d:	01 d0                	add    %edx,%eax
  80147f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801485:	eb 0c                	jmp    801493 <strsplit+0x31>
			*string++ = 0;
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
  80148a:	8d 50 01             	lea    0x1(%eax),%edx
  80148d:	89 55 08             	mov    %edx,0x8(%ebp)
  801490:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
  801496:	8a 00                	mov    (%eax),%al
  801498:	84 c0                	test   %al,%al
  80149a:	74 18                	je     8014b4 <strsplit+0x52>
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	8a 00                	mov    (%eax),%al
  8014a1:	0f be c0             	movsbl %al,%eax
  8014a4:	50                   	push   %eax
  8014a5:	ff 75 0c             	pushl  0xc(%ebp)
  8014a8:	e8 32 fb ff ff       	call   800fdf <strchr>
  8014ad:	83 c4 08             	add    $0x8,%esp
  8014b0:	85 c0                	test   %eax,%eax
  8014b2:	75 d3                	jne    801487 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	8a 00                	mov    (%eax),%al
  8014b9:	84 c0                	test   %al,%al
  8014bb:	74 5a                	je     801517 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c0:	8b 00                	mov    (%eax),%eax
  8014c2:	83 f8 0f             	cmp    $0xf,%eax
  8014c5:	75 07                	jne    8014ce <strsplit+0x6c>
		{
			return 0;
  8014c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014cc:	eb 66                	jmp    801534 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d1:	8b 00                	mov    (%eax),%eax
  8014d3:	8d 48 01             	lea    0x1(%eax),%ecx
  8014d6:	8b 55 14             	mov    0x14(%ebp),%edx
  8014d9:	89 0a                	mov    %ecx,(%edx)
  8014db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e5:	01 c2                	add    %eax,%edx
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014ec:	eb 03                	jmp    8014f1 <strsplit+0x8f>
			string++;
  8014ee:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	8a 00                	mov    (%eax),%al
  8014f6:	84 c0                	test   %al,%al
  8014f8:	74 8b                	je     801485 <strsplit+0x23>
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	8a 00                	mov    (%eax),%al
  8014ff:	0f be c0             	movsbl %al,%eax
  801502:	50                   	push   %eax
  801503:	ff 75 0c             	pushl  0xc(%ebp)
  801506:	e8 d4 fa ff ff       	call   800fdf <strchr>
  80150b:	83 c4 08             	add    $0x8,%esp
  80150e:	85 c0                	test   %eax,%eax
  801510:	74 dc                	je     8014ee <strsplit+0x8c>
			string++;
	}
  801512:	e9 6e ff ff ff       	jmp    801485 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801517:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801518:	8b 45 14             	mov    0x14(%ebp),%eax
  80151b:	8b 00                	mov    (%eax),%eax
  80151d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801524:	8b 45 10             	mov    0x10(%ebp),%eax
  801527:	01 d0                	add    %edx,%eax
  801529:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80152f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801534:	c9                   	leave  
  801535:	c3                   	ret    

00801536 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
  801539:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80153c:	83 ec 04             	sub    $0x4,%esp
  80153f:	68 a8 26 80 00       	push   $0x8026a8
  801544:	68 3f 01 00 00       	push   $0x13f
  801549:	68 ca 26 80 00       	push   $0x8026ca
  80154e:	e8 a9 ef ff ff       	call   8004fc <_panic>

00801553 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	57                   	push   %edi
  801557:	56                   	push   %esi
  801558:	53                   	push   %ebx
  801559:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
  80155f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801562:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801565:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801568:	8b 7d 18             	mov    0x18(%ebp),%edi
  80156b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80156e:	cd 30                	int    $0x30
  801570:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801573:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801576:	83 c4 10             	add    $0x10,%esp
  801579:	5b                   	pop    %ebx
  80157a:	5e                   	pop    %esi
  80157b:	5f                   	pop    %edi
  80157c:	5d                   	pop    %ebp
  80157d:	c3                   	ret    

0080157e <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	83 ec 04             	sub    $0x4,%esp
  801584:	8b 45 10             	mov    0x10(%ebp),%eax
  801587:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  80158a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80158e:	8b 45 08             	mov    0x8(%ebp),%eax
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	52                   	push   %edx
  801596:	ff 75 0c             	pushl  0xc(%ebp)
  801599:	50                   	push   %eax
  80159a:	6a 00                	push   $0x0
  80159c:	e8 b2 ff ff ff       	call   801553 <syscall>
  8015a1:	83 c4 18             	add    $0x18,%esp
}
  8015a4:	90                   	nop
  8015a5:	c9                   	leave  
  8015a6:	c3                   	ret    

008015a7 <sys_cgetc>:

int sys_cgetc(void) {
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 02                	push   $0x2
  8015b6:	e8 98 ff ff ff       	call   801553 <syscall>
  8015bb:	83 c4 18             	add    $0x18,%esp
}
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    

008015c0 <sys_lock_cons>:

void sys_lock_cons(void) {
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 03                	push   $0x3
  8015cf:	e8 7f ff ff ff       	call   801553 <syscall>
  8015d4:	83 c4 18             	add    $0x18,%esp
}
  8015d7:	90                   	nop
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <sys_unlock_cons>:
void sys_unlock_cons(void) {
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 04                	push   $0x4
  8015e9:	e8 65 ff ff ff       	call   801553 <syscall>
  8015ee:	83 c4 18             	add    $0x18,%esp
}
  8015f1:	90                   	nop
  8015f2:	c9                   	leave  
  8015f3:	c3                   	ret    

008015f4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  8015f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	52                   	push   %edx
  801604:	50                   	push   %eax
  801605:	6a 08                	push   $0x8
  801607:	e8 47 ff ff ff       	call   801553 <syscall>
  80160c:	83 c4 18             	add    $0x18,%esp
}
  80160f:	c9                   	leave  
  801610:	c3                   	ret    

00801611 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
  801614:	56                   	push   %esi
  801615:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801616:	8b 75 18             	mov    0x18(%ebp),%esi
  801619:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80161c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80161f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801622:	8b 45 08             	mov    0x8(%ebp),%eax
  801625:	56                   	push   %esi
  801626:	53                   	push   %ebx
  801627:	51                   	push   %ecx
  801628:	52                   	push   %edx
  801629:	50                   	push   %eax
  80162a:	6a 09                	push   $0x9
  80162c:	e8 22 ff ff ff       	call   801553 <syscall>
  801631:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801634:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801637:	5b                   	pop    %ebx
  801638:	5e                   	pop    %esi
  801639:	5d                   	pop    %ebp
  80163a:	c3                   	ret    

0080163b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80163e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801641:	8b 45 08             	mov    0x8(%ebp),%eax
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	52                   	push   %edx
  80164b:	50                   	push   %eax
  80164c:	6a 0a                	push   $0xa
  80164e:	e8 00 ff ff ff       	call   801553 <syscall>
  801653:	83 c4 18             	add    $0x18,%esp
}
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	ff 75 0c             	pushl  0xc(%ebp)
  801664:	ff 75 08             	pushl  0x8(%ebp)
  801667:	6a 0b                	push   $0xb
  801669:	e8 e5 fe ff ff       	call   801553 <syscall>
  80166e:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801671:	c9                   	leave  
  801672:	c3                   	ret    

00801673 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 0c                	push   $0xc
  801682:	e8 cc fe ff ff       	call   801553 <syscall>
  801687:	83 c4 18             	add    $0x18,%esp
}
  80168a:	c9                   	leave  
  80168b:	c3                   	ret    

0080168c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 0d                	push   $0xd
  80169b:	e8 b3 fe ff ff       	call   801553 <syscall>
  8016a0:	83 c4 18             	add    $0x18,%esp
}
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    

008016a5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 0e                	push   $0xe
  8016b4:	e8 9a fe ff ff       	call   801553 <syscall>
  8016b9:	83 c4 18             	add    $0x18,%esp
}
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    

008016be <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 0f                	push   $0xf
  8016cd:	e8 81 fe ff ff       	call   801553 <syscall>
  8016d2:	83 c4 18             	add    $0x18,%esp
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	ff 75 08             	pushl  0x8(%ebp)
  8016e5:	6a 10                	push   $0x10
  8016e7:	e8 67 fe ff ff       	call   801553 <syscall>
  8016ec:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <sys_scarce_memory>:

void sys_scarce_memory() {
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 11                	push   $0x11
  801700:	e8 4e fe ff ff       	call   801553 <syscall>
  801705:	83 c4 18             	add    $0x18,%esp
}
  801708:	90                   	nop
  801709:	c9                   	leave  
  80170a:	c3                   	ret    

0080170b <sys_cputc>:

void sys_cputc(const char c) {
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
  80170e:	83 ec 04             	sub    $0x4,%esp
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801717:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	50                   	push   %eax
  801724:	6a 01                	push   $0x1
  801726:	e8 28 fe ff ff       	call   801553 <syscall>
  80172b:	83 c4 18             	add    $0x18,%esp
}
  80172e:	90                   	nop
  80172f:	c9                   	leave  
  801730:	c3                   	ret    

00801731 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 14                	push   $0x14
  801740:	e8 0e fe ff ff       	call   801553 <syscall>
  801745:	83 c4 18             	add    $0x18,%esp
}
  801748:	90                   	nop
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	83 ec 04             	sub    $0x4,%esp
  801751:	8b 45 10             	mov    0x10(%ebp),%eax
  801754:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801757:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80175a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	6a 00                	push   $0x0
  801763:	51                   	push   %ecx
  801764:	52                   	push   %edx
  801765:	ff 75 0c             	pushl  0xc(%ebp)
  801768:	50                   	push   %eax
  801769:	6a 15                	push   $0x15
  80176b:	e8 e3 fd ff ff       	call   801553 <syscall>
  801770:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801778:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177b:	8b 45 08             	mov    0x8(%ebp),%eax
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	52                   	push   %edx
  801785:	50                   	push   %eax
  801786:	6a 16                	push   $0x16
  801788:	e8 c6 fd ff ff       	call   801553 <syscall>
  80178d:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801795:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801798:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	51                   	push   %ecx
  8017a3:	52                   	push   %edx
  8017a4:	50                   	push   %eax
  8017a5:	6a 17                	push   $0x17
  8017a7:	e8 a7 fd ff ff       	call   801553 <syscall>
  8017ac:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    

008017b1 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  8017b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	52                   	push   %edx
  8017c1:	50                   	push   %eax
  8017c2:	6a 18                	push   $0x18
  8017c4:	e8 8a fd ff ff       	call   801553 <syscall>
  8017c9:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  8017d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d4:	6a 00                	push   $0x0
  8017d6:	ff 75 14             	pushl  0x14(%ebp)
  8017d9:	ff 75 10             	pushl  0x10(%ebp)
  8017dc:	ff 75 0c             	pushl  0xc(%ebp)
  8017df:	50                   	push   %eax
  8017e0:	6a 19                	push   $0x19
  8017e2:	e8 6c fd ff ff       	call   801553 <syscall>
  8017e7:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <sys_run_env>:

void sys_run_env(int32 envId) {
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  8017ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	50                   	push   %eax
  8017fb:	6a 1a                	push   $0x1a
  8017fd:	e8 51 fd ff ff       	call   801553 <syscall>
  801802:	83 c4 18             	add    $0x18,%esp
}
  801805:	90                   	nop
  801806:	c9                   	leave  
  801807:	c3                   	ret    

00801808 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	50                   	push   %eax
  801817:	6a 1b                	push   $0x1b
  801819:	e8 35 fd ff ff       	call   801553 <syscall>
  80181e:	83 c4 18             	add    $0x18,%esp
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <sys_getenvid>:

int32 sys_getenvid(void) {
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 05                	push   $0x5
  801832:	e8 1c fd ff ff       	call   801553 <syscall>
  801837:	83 c4 18             	add    $0x18,%esp
}
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 06                	push   $0x6
  80184b:	e8 03 fd ff ff       	call   801553 <syscall>
  801850:	83 c4 18             	add    $0x18,%esp
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 07                	push   $0x7
  801864:	e8 ea fc ff ff       	call   801553 <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <sys_exit_env>:

void sys_exit_env(void) {
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 1c                	push   $0x1c
  80187d:	e8 d1 fc ff ff       	call   801553 <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	90                   	nop
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  80188e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801891:	8d 50 04             	lea    0x4(%eax),%edx
  801894:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	52                   	push   %edx
  80189e:	50                   	push   %eax
  80189f:	6a 1d                	push   $0x1d
  8018a1:	e8 ad fc ff ff       	call   801553 <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  8018a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018af:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018b2:	89 01                	mov    %eax,(%ecx)
  8018b4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	c9                   	leave  
  8018bb:	c2 04 00             	ret    $0x4

008018be <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	ff 75 10             	pushl  0x10(%ebp)
  8018c8:	ff 75 0c             	pushl  0xc(%ebp)
  8018cb:	ff 75 08             	pushl  0x8(%ebp)
  8018ce:	6a 13                	push   $0x13
  8018d0:	e8 7e fc ff ff       	call   801553 <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  8018d8:	90                   	nop
}
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <sys_rcr2>:
uint32 sys_rcr2() {
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 1e                	push   $0x1e
  8018ea:	e8 64 fc ff ff       	call   801553 <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	83 ec 04             	sub    $0x4,%esp
  8018fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801900:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	50                   	push   %eax
  80190d:	6a 1f                	push   $0x1f
  80190f:	e8 3f fc ff ff       	call   801553 <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
	return;
  801917:	90                   	nop
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <rsttst>:
void rsttst() {
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 21                	push   $0x21
  801929:	e8 25 fc ff ff       	call   801553 <syscall>
  80192e:	83 c4 18             	add    $0x18,%esp
	return;
  801931:	90                   	nop
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	83 ec 04             	sub    $0x4,%esp
  80193a:	8b 45 14             	mov    0x14(%ebp),%eax
  80193d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801940:	8b 55 18             	mov    0x18(%ebp),%edx
  801943:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801947:	52                   	push   %edx
  801948:	50                   	push   %eax
  801949:	ff 75 10             	pushl  0x10(%ebp)
  80194c:	ff 75 0c             	pushl  0xc(%ebp)
  80194f:	ff 75 08             	pushl  0x8(%ebp)
  801952:	6a 20                	push   $0x20
  801954:	e8 fa fb ff ff       	call   801553 <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
	return;
  80195c:	90                   	nop
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <chktst>:
void chktst(uint32 n) {
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	ff 75 08             	pushl  0x8(%ebp)
  80196d:	6a 22                	push   $0x22
  80196f:	e8 df fb ff ff       	call   801553 <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
	return;
  801977:	90                   	nop
}
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <inctst>:

void inctst() {
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 23                	push   $0x23
  801989:	e8 c5 fb ff ff       	call   801553 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
	return;
  801991:	90                   	nop
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <gettst>:
uint32 gettst() {
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 24                	push   $0x24
  8019a3:	e8 ab fb ff ff       	call   801553 <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
  8019b0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 25                	push   $0x25
  8019bf:	e8 8f fb ff ff       	call   801553 <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
  8019c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019ca:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019ce:	75 07                	jne    8019d7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019d0:	b8 01 00 00 00       	mov    $0x1,%eax
  8019d5:	eb 05                	jmp    8019dc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
  8019e1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 25                	push   $0x25
  8019f0:	e8 5e fb ff ff       	call   801553 <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
  8019f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8019fb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8019ff:	75 07                	jne    801a08 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a01:	b8 01 00 00 00       	mov    $0x1,%eax
  801a06:	eb 05                	jmp    801a0d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 25                	push   $0x25
  801a21:	e8 2d fb ff ff       	call   801553 <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
  801a29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a2c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a30:	75 07                	jne    801a39 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a32:	b8 01 00 00 00       	mov    $0x1,%eax
  801a37:	eb 05                	jmp    801a3e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 25                	push   $0x25
  801a52:	e8 fc fa ff ff       	call   801553 <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
  801a5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a5d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a61:	75 07                	jne    801a6a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a63:	b8 01 00 00 00       	mov    $0x1,%eax
  801a68:	eb 05                	jmp    801a6f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	ff 75 08             	pushl  0x8(%ebp)
  801a7f:	6a 26                	push   $0x26
  801a81:	e8 cd fa ff ff       	call   801553 <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
	return;
  801a89:	90                   	nop
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801a90:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a93:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	6a 00                	push   $0x0
  801a9e:	53                   	push   %ebx
  801a9f:	51                   	push   %ecx
  801aa0:	52                   	push   %edx
  801aa1:	50                   	push   %eax
  801aa2:	6a 27                	push   $0x27
  801aa4:	e8 aa fa ff ff       	call   801553 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801aac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801ab4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	52                   	push   %edx
  801ac1:	50                   	push   %eax
  801ac2:	6a 28                	push   $0x28
  801ac4:	e8 8a fa ff ff       	call   801553 <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801ad1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ad4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	6a 00                	push   $0x0
  801adc:	51                   	push   %ecx
  801add:	ff 75 10             	pushl  0x10(%ebp)
  801ae0:	52                   	push   %edx
  801ae1:	50                   	push   %eax
  801ae2:	6a 29                	push   $0x29
  801ae4:	e8 6a fa ff ff       	call   801553 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	ff 75 10             	pushl  0x10(%ebp)
  801af8:	ff 75 0c             	pushl  0xc(%ebp)
  801afb:	ff 75 08             	pushl  0x8(%ebp)
  801afe:	6a 12                	push   $0x12
  801b00:	e8 4e fa ff ff       	call   801553 <syscall>
  801b05:	83 c4 18             	add    $0x18,%esp
	return;
  801b08:	90                   	nop
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801b0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	52                   	push   %edx
  801b1b:	50                   	push   %eax
  801b1c:	6a 2a                	push   $0x2a
  801b1e:	e8 30 fa ff ff       	call   801553 <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
	return;
  801b26:	90                   	nop
}
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	50                   	push   %eax
  801b38:	6a 2b                	push   $0x2b
  801b3a:	e8 14 fa ff ff       	call   801553 <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	ff 75 0c             	pushl  0xc(%ebp)
  801b50:	ff 75 08             	pushl  0x8(%ebp)
  801b53:	6a 2c                	push   $0x2c
  801b55:	e8 f9 f9 ff ff       	call   801553 <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
	return;
  801b5d:	90                   	nop
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	ff 75 0c             	pushl  0xc(%ebp)
  801b6c:	ff 75 08             	pushl  0x8(%ebp)
  801b6f:	6a 2d                	push   $0x2d
  801b71:	e8 dd f9 ff ff       	call   801553 <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
	return;
  801b79:	90                   	nop
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	50                   	push   %eax
  801b8b:	6a 2f                	push   $0x2f
  801b8d:	e8 c1 f9 ff ff       	call   801553 <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
	return;
  801b95:	90                   	nop
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  801b9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	52                   	push   %edx
  801ba8:	50                   	push   %eax
  801ba9:	6a 30                	push   $0x30
  801bab:	e8 a3 f9 ff ff       	call   801553 <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
	return;
  801bb3:	90                   	nop
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  801bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	50                   	push   %eax
  801bc5:	6a 31                	push   $0x31
  801bc7:	e8 87 f9 ff ff       	call   801553 <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
	return;
  801bcf:	90                   	nop
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801bd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	52                   	push   %edx
  801be2:	50                   	push   %eax
  801be3:	6a 2e                	push   $0x2e
  801be5:	e8 69 f9 ff ff       	call   801553 <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
    return;
  801bed:	90                   	nop
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <__udivdi3>:
  801bf0:	55                   	push   %ebp
  801bf1:	57                   	push   %edi
  801bf2:	56                   	push   %esi
  801bf3:	53                   	push   %ebx
  801bf4:	83 ec 1c             	sub    $0x1c,%esp
  801bf7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801bfb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801bff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c03:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c07:	89 ca                	mov    %ecx,%edx
  801c09:	89 f8                	mov    %edi,%eax
  801c0b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c0f:	85 f6                	test   %esi,%esi
  801c11:	75 2d                	jne    801c40 <__udivdi3+0x50>
  801c13:	39 cf                	cmp    %ecx,%edi
  801c15:	77 65                	ja     801c7c <__udivdi3+0x8c>
  801c17:	89 fd                	mov    %edi,%ebp
  801c19:	85 ff                	test   %edi,%edi
  801c1b:	75 0b                	jne    801c28 <__udivdi3+0x38>
  801c1d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c22:	31 d2                	xor    %edx,%edx
  801c24:	f7 f7                	div    %edi
  801c26:	89 c5                	mov    %eax,%ebp
  801c28:	31 d2                	xor    %edx,%edx
  801c2a:	89 c8                	mov    %ecx,%eax
  801c2c:	f7 f5                	div    %ebp
  801c2e:	89 c1                	mov    %eax,%ecx
  801c30:	89 d8                	mov    %ebx,%eax
  801c32:	f7 f5                	div    %ebp
  801c34:	89 cf                	mov    %ecx,%edi
  801c36:	89 fa                	mov    %edi,%edx
  801c38:	83 c4 1c             	add    $0x1c,%esp
  801c3b:	5b                   	pop    %ebx
  801c3c:	5e                   	pop    %esi
  801c3d:	5f                   	pop    %edi
  801c3e:	5d                   	pop    %ebp
  801c3f:	c3                   	ret    
  801c40:	39 ce                	cmp    %ecx,%esi
  801c42:	77 28                	ja     801c6c <__udivdi3+0x7c>
  801c44:	0f bd fe             	bsr    %esi,%edi
  801c47:	83 f7 1f             	xor    $0x1f,%edi
  801c4a:	75 40                	jne    801c8c <__udivdi3+0x9c>
  801c4c:	39 ce                	cmp    %ecx,%esi
  801c4e:	72 0a                	jb     801c5a <__udivdi3+0x6a>
  801c50:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c54:	0f 87 9e 00 00 00    	ja     801cf8 <__udivdi3+0x108>
  801c5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c5f:	89 fa                	mov    %edi,%edx
  801c61:	83 c4 1c             	add    $0x1c,%esp
  801c64:	5b                   	pop    %ebx
  801c65:	5e                   	pop    %esi
  801c66:	5f                   	pop    %edi
  801c67:	5d                   	pop    %ebp
  801c68:	c3                   	ret    
  801c69:	8d 76 00             	lea    0x0(%esi),%esi
  801c6c:	31 ff                	xor    %edi,%edi
  801c6e:	31 c0                	xor    %eax,%eax
  801c70:	89 fa                	mov    %edi,%edx
  801c72:	83 c4 1c             	add    $0x1c,%esp
  801c75:	5b                   	pop    %ebx
  801c76:	5e                   	pop    %esi
  801c77:	5f                   	pop    %edi
  801c78:	5d                   	pop    %ebp
  801c79:	c3                   	ret    
  801c7a:	66 90                	xchg   %ax,%ax
  801c7c:	89 d8                	mov    %ebx,%eax
  801c7e:	f7 f7                	div    %edi
  801c80:	31 ff                	xor    %edi,%edi
  801c82:	89 fa                	mov    %edi,%edx
  801c84:	83 c4 1c             	add    $0x1c,%esp
  801c87:	5b                   	pop    %ebx
  801c88:	5e                   	pop    %esi
  801c89:	5f                   	pop    %edi
  801c8a:	5d                   	pop    %ebp
  801c8b:	c3                   	ret    
  801c8c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c91:	89 eb                	mov    %ebp,%ebx
  801c93:	29 fb                	sub    %edi,%ebx
  801c95:	89 f9                	mov    %edi,%ecx
  801c97:	d3 e6                	shl    %cl,%esi
  801c99:	89 c5                	mov    %eax,%ebp
  801c9b:	88 d9                	mov    %bl,%cl
  801c9d:	d3 ed                	shr    %cl,%ebp
  801c9f:	89 e9                	mov    %ebp,%ecx
  801ca1:	09 f1                	or     %esi,%ecx
  801ca3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ca7:	89 f9                	mov    %edi,%ecx
  801ca9:	d3 e0                	shl    %cl,%eax
  801cab:	89 c5                	mov    %eax,%ebp
  801cad:	89 d6                	mov    %edx,%esi
  801caf:	88 d9                	mov    %bl,%cl
  801cb1:	d3 ee                	shr    %cl,%esi
  801cb3:	89 f9                	mov    %edi,%ecx
  801cb5:	d3 e2                	shl    %cl,%edx
  801cb7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cbb:	88 d9                	mov    %bl,%cl
  801cbd:	d3 e8                	shr    %cl,%eax
  801cbf:	09 c2                	or     %eax,%edx
  801cc1:	89 d0                	mov    %edx,%eax
  801cc3:	89 f2                	mov    %esi,%edx
  801cc5:	f7 74 24 0c          	divl   0xc(%esp)
  801cc9:	89 d6                	mov    %edx,%esi
  801ccb:	89 c3                	mov    %eax,%ebx
  801ccd:	f7 e5                	mul    %ebp
  801ccf:	39 d6                	cmp    %edx,%esi
  801cd1:	72 19                	jb     801cec <__udivdi3+0xfc>
  801cd3:	74 0b                	je     801ce0 <__udivdi3+0xf0>
  801cd5:	89 d8                	mov    %ebx,%eax
  801cd7:	31 ff                	xor    %edi,%edi
  801cd9:	e9 58 ff ff ff       	jmp    801c36 <__udivdi3+0x46>
  801cde:	66 90                	xchg   %ax,%ax
  801ce0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ce4:	89 f9                	mov    %edi,%ecx
  801ce6:	d3 e2                	shl    %cl,%edx
  801ce8:	39 c2                	cmp    %eax,%edx
  801cea:	73 e9                	jae    801cd5 <__udivdi3+0xe5>
  801cec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801cef:	31 ff                	xor    %edi,%edi
  801cf1:	e9 40 ff ff ff       	jmp    801c36 <__udivdi3+0x46>
  801cf6:	66 90                	xchg   %ax,%ax
  801cf8:	31 c0                	xor    %eax,%eax
  801cfa:	e9 37 ff ff ff       	jmp    801c36 <__udivdi3+0x46>
  801cff:	90                   	nop

00801d00 <__umoddi3>:
  801d00:	55                   	push   %ebp
  801d01:	57                   	push   %edi
  801d02:	56                   	push   %esi
  801d03:	53                   	push   %ebx
  801d04:	83 ec 1c             	sub    $0x1c,%esp
  801d07:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d0b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d13:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d1b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d1f:	89 f3                	mov    %esi,%ebx
  801d21:	89 fa                	mov    %edi,%edx
  801d23:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d27:	89 34 24             	mov    %esi,(%esp)
  801d2a:	85 c0                	test   %eax,%eax
  801d2c:	75 1a                	jne    801d48 <__umoddi3+0x48>
  801d2e:	39 f7                	cmp    %esi,%edi
  801d30:	0f 86 a2 00 00 00    	jbe    801dd8 <__umoddi3+0xd8>
  801d36:	89 c8                	mov    %ecx,%eax
  801d38:	89 f2                	mov    %esi,%edx
  801d3a:	f7 f7                	div    %edi
  801d3c:	89 d0                	mov    %edx,%eax
  801d3e:	31 d2                	xor    %edx,%edx
  801d40:	83 c4 1c             	add    $0x1c,%esp
  801d43:	5b                   	pop    %ebx
  801d44:	5e                   	pop    %esi
  801d45:	5f                   	pop    %edi
  801d46:	5d                   	pop    %ebp
  801d47:	c3                   	ret    
  801d48:	39 f0                	cmp    %esi,%eax
  801d4a:	0f 87 ac 00 00 00    	ja     801dfc <__umoddi3+0xfc>
  801d50:	0f bd e8             	bsr    %eax,%ebp
  801d53:	83 f5 1f             	xor    $0x1f,%ebp
  801d56:	0f 84 ac 00 00 00    	je     801e08 <__umoddi3+0x108>
  801d5c:	bf 20 00 00 00       	mov    $0x20,%edi
  801d61:	29 ef                	sub    %ebp,%edi
  801d63:	89 fe                	mov    %edi,%esi
  801d65:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d69:	89 e9                	mov    %ebp,%ecx
  801d6b:	d3 e0                	shl    %cl,%eax
  801d6d:	89 d7                	mov    %edx,%edi
  801d6f:	89 f1                	mov    %esi,%ecx
  801d71:	d3 ef                	shr    %cl,%edi
  801d73:	09 c7                	or     %eax,%edi
  801d75:	89 e9                	mov    %ebp,%ecx
  801d77:	d3 e2                	shl    %cl,%edx
  801d79:	89 14 24             	mov    %edx,(%esp)
  801d7c:	89 d8                	mov    %ebx,%eax
  801d7e:	d3 e0                	shl    %cl,%eax
  801d80:	89 c2                	mov    %eax,%edx
  801d82:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d86:	d3 e0                	shl    %cl,%eax
  801d88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d8c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d90:	89 f1                	mov    %esi,%ecx
  801d92:	d3 e8                	shr    %cl,%eax
  801d94:	09 d0                	or     %edx,%eax
  801d96:	d3 eb                	shr    %cl,%ebx
  801d98:	89 da                	mov    %ebx,%edx
  801d9a:	f7 f7                	div    %edi
  801d9c:	89 d3                	mov    %edx,%ebx
  801d9e:	f7 24 24             	mull   (%esp)
  801da1:	89 c6                	mov    %eax,%esi
  801da3:	89 d1                	mov    %edx,%ecx
  801da5:	39 d3                	cmp    %edx,%ebx
  801da7:	0f 82 87 00 00 00    	jb     801e34 <__umoddi3+0x134>
  801dad:	0f 84 91 00 00 00    	je     801e44 <__umoddi3+0x144>
  801db3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801db7:	29 f2                	sub    %esi,%edx
  801db9:	19 cb                	sbb    %ecx,%ebx
  801dbb:	89 d8                	mov    %ebx,%eax
  801dbd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801dc1:	d3 e0                	shl    %cl,%eax
  801dc3:	89 e9                	mov    %ebp,%ecx
  801dc5:	d3 ea                	shr    %cl,%edx
  801dc7:	09 d0                	or     %edx,%eax
  801dc9:	89 e9                	mov    %ebp,%ecx
  801dcb:	d3 eb                	shr    %cl,%ebx
  801dcd:	89 da                	mov    %ebx,%edx
  801dcf:	83 c4 1c             	add    $0x1c,%esp
  801dd2:	5b                   	pop    %ebx
  801dd3:	5e                   	pop    %esi
  801dd4:	5f                   	pop    %edi
  801dd5:	5d                   	pop    %ebp
  801dd6:	c3                   	ret    
  801dd7:	90                   	nop
  801dd8:	89 fd                	mov    %edi,%ebp
  801dda:	85 ff                	test   %edi,%edi
  801ddc:	75 0b                	jne    801de9 <__umoddi3+0xe9>
  801dde:	b8 01 00 00 00       	mov    $0x1,%eax
  801de3:	31 d2                	xor    %edx,%edx
  801de5:	f7 f7                	div    %edi
  801de7:	89 c5                	mov    %eax,%ebp
  801de9:	89 f0                	mov    %esi,%eax
  801deb:	31 d2                	xor    %edx,%edx
  801ded:	f7 f5                	div    %ebp
  801def:	89 c8                	mov    %ecx,%eax
  801df1:	f7 f5                	div    %ebp
  801df3:	89 d0                	mov    %edx,%eax
  801df5:	e9 44 ff ff ff       	jmp    801d3e <__umoddi3+0x3e>
  801dfa:	66 90                	xchg   %ax,%ax
  801dfc:	89 c8                	mov    %ecx,%eax
  801dfe:	89 f2                	mov    %esi,%edx
  801e00:	83 c4 1c             	add    $0x1c,%esp
  801e03:	5b                   	pop    %ebx
  801e04:	5e                   	pop    %esi
  801e05:	5f                   	pop    %edi
  801e06:	5d                   	pop    %ebp
  801e07:	c3                   	ret    
  801e08:	3b 04 24             	cmp    (%esp),%eax
  801e0b:	72 06                	jb     801e13 <__umoddi3+0x113>
  801e0d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e11:	77 0f                	ja     801e22 <__umoddi3+0x122>
  801e13:	89 f2                	mov    %esi,%edx
  801e15:	29 f9                	sub    %edi,%ecx
  801e17:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e1b:	89 14 24             	mov    %edx,(%esp)
  801e1e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e22:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e26:	8b 14 24             	mov    (%esp),%edx
  801e29:	83 c4 1c             	add    $0x1c,%esp
  801e2c:	5b                   	pop    %ebx
  801e2d:	5e                   	pop    %esi
  801e2e:	5f                   	pop    %edi
  801e2f:	5d                   	pop    %ebp
  801e30:	c3                   	ret    
  801e31:	8d 76 00             	lea    0x0(%esi),%esi
  801e34:	2b 04 24             	sub    (%esp),%eax
  801e37:	19 fa                	sbb    %edi,%edx
  801e39:	89 d1                	mov    %edx,%ecx
  801e3b:	89 c6                	mov    %eax,%esi
  801e3d:	e9 71 ff ff ff       	jmp    801db3 <__umoddi3+0xb3>
  801e42:	66 90                	xchg   %ax,%ax
  801e44:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e48:	72 ea                	jb     801e34 <__umoddi3+0x134>
  801e4a:	89 d9                	mov    %ebx,%ecx
  801e4c:	e9 62 ff ff ff       	jmp    801db3 <__umoddi3+0xb3>
