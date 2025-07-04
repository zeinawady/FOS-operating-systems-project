
obj/user/tst_placement_3:     file format elf32-i386


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
  800031:	e8 f6 03 00 00       	call   80042c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

#include <inc/lib.h>
extern uint32 initFreeFrames;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 80 00 00 01    	sub    $0x1000080,%esp

	int8 arr[PAGE_SIZE*1024*4];
	int x = 0;
  800043:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	//uint32 actual_active_list[13] = {0xedbfd000,0xeebfd000,0x803000,0x802000,0x801000,0x800000,0x205000,0x204000,0x203000,0x202000,0x201000,0x200000};
	uint32 actual_active_list[13] ;
	{
		actual_active_list[0] = 0xedbfd000;
  80004a:	c7 85 94 ff ff fe 00 	movl   $0xedbfd000,-0x100006c(%ebp)
  800051:	d0 bf ed 
		actual_active_list[1] = 0xeebfd000;
  800054:	c7 85 98 ff ff fe 00 	movl   $0xeebfd000,-0x1000068(%ebp)
  80005b:	d0 bf ee 
		actual_active_list[2] = 0x803000;
  80005e:	c7 85 9c ff ff fe 00 	movl   $0x803000,-0x1000064(%ebp)
  800065:	30 80 00 
		actual_active_list[3] = 0x802000;
  800068:	c7 85 a0 ff ff fe 00 	movl   $0x802000,-0x1000060(%ebp)
  80006f:	20 80 00 
		actual_active_list[4] = 0x801000;
  800072:	c7 85 a4 ff ff fe 00 	movl   $0x801000,-0x100005c(%ebp)
  800079:	10 80 00 
		actual_active_list[5] = 0x800000;
  80007c:	c7 85 a8 ff ff fe 00 	movl   $0x800000,-0x1000058(%ebp)
  800083:	00 80 00 
		actual_active_list[6] = 0x205000;
  800086:	c7 85 ac ff ff fe 00 	movl   $0x205000,-0x1000054(%ebp)
  80008d:	50 20 00 
		actual_active_list[7] = 0x204000;
  800090:	c7 85 b0 ff ff fe 00 	movl   $0x204000,-0x1000050(%ebp)
  800097:	40 20 00 
		actual_active_list[8] = 0x203000;
  80009a:	c7 85 b4 ff ff fe 00 	movl   $0x203000,-0x100004c(%ebp)
  8000a1:	30 20 00 
		actual_active_list[9] = 0x202000;
  8000a4:	c7 85 b8 ff ff fe 00 	movl   $0x202000,-0x1000048(%ebp)
  8000ab:	20 20 00 
		actual_active_list[10] = 0x201000;
  8000ae:	c7 85 bc ff ff fe 00 	movl   $0x201000,-0x1000044(%ebp)
  8000b5:	10 20 00 
		actual_active_list[11] = 0x200000;
  8000b8:	c7 85 c0 ff ff fe 00 	movl   $0x200000,-0x1000040(%ebp)
  8000bf:	00 20 00 
	}
	uint32 actual_second_list[7] = {};
  8000c2:	8d 95 78 ff ff fe    	lea    -0x1000088(%ebp),%edx
  8000c8:	b9 07 00 00 00       	mov    $0x7,%ecx
  8000cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d2:	89 d7                	mov    %edx,%edi
  8000d4:	f3 ab                	rep stos %eax,%es:(%edi)
	("STEP 0: checking Initial LRU lists entries ...\n");
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 12, 0);
  8000d6:	6a 00                	push   $0x0
  8000d8:	6a 0c                	push   $0xc
  8000da:	8d 85 78 ff ff fe    	lea    -0x1000088(%ebp),%eax
  8000e0:	50                   	push   %eax
  8000e1:	8d 85 94 ff ff fe    	lea    -0x100006c(%ebp),%eax
  8000e7:	50                   	push   %eax
  8000e8:	e8 14 1a 00 00       	call   801b01 <sys_check_LRU_lists>
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if(check == 0)
  8000f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8000f7:	75 14                	jne    80010d <_main+0xd5>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	68 e0 1e 80 00       	push   $0x801ee0
  800101:	6a 24                	push   $0x24
  800103:	68 62 1f 80 00       	push   $0x801f62
  800108:	e8 64 04 00 00       	call   800571 <_panic>
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010d:	e8 21 16 00 00       	call   801733 <sys_pf_calculate_allocated_pages>
  800112:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int freePages = sys_calculate_free_frames();
  800115:	e8 ce 15 00 00       	call   8016e8 <sys_calculate_free_frames>
  80011a:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int i=0;
  80011d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(;i<=PAGE_SIZE;i++)
  800124:	eb 11                	jmp    800137 <_main+0xff>
	{
		arr[i] = -1;
  800126:	8d 95 c8 ff ff fe    	lea    -0x1000038(%ebp),%edx
  80012c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80012f:	01 d0                	add    %edx,%eax
  800131:	c6 00 ff             	movb   $0xff,(%eax)

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int freePages = sys_calculate_free_frames();

	int i=0;
	for(;i<=PAGE_SIZE;i++)
  800134:	ff 45 f4             	incl   -0xc(%ebp)
  800137:	81 7d f4 00 10 00 00 	cmpl   $0x1000,-0xc(%ebp)
  80013e:	7e e6                	jle    800126 <_main+0xee>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
  800140:	c7 45 f4 00 00 40 00 	movl   $0x400000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800147:	eb 11                	jmp    80015a <_main+0x122>
	{
		arr[i] = -1;
  800149:	8d 95 c8 ff ff fe    	lea    -0x1000038(%ebp),%edx
  80014f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800152:	01 d0                	add    %edx,%eax
  800154:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800157:	ff 45 f4             	incl   -0xc(%ebp)
  80015a:	81 7d f4 00 10 40 00 	cmpl   $0x401000,-0xc(%ebp)
  800161:	7e e6                	jle    800149 <_main+0x111>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
  800163:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  80016a:	eb 11                	jmp    80017d <_main+0x145>
	{
		arr[i] = -1;
  80016c:	8d 95 c8 ff ff fe    	lea    -0x1000038(%ebp),%edx
  800172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800175:	01 d0                	add    %edx,%eax
  800177:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  80017a:	ff 45 f4             	incl   -0xc(%ebp)
  80017d:	81 7d f4 00 10 80 00 	cmpl   $0x801000,-0xc(%ebp)
  800184:	7e e6                	jle    80016c <_main+0x134>
	{
		arr[i] = -1;
	}

	uint32* secondlistVA= (uint32*)0x200000;
  800186:	c7 45 d4 00 00 20 00 	movl   $0x200000,-0x2c(%ebp)
	x = x + *secondlistVA;
  80018d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800190:	8b 10                	mov    (%eax),%edx
  800192:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800195:	01 d0                	add    %edx,%eax
  800197:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	secondlistVA = (uint32*) 0x202000;
  80019a:	c7 45 d4 00 20 20 00 	movl   $0x202000,-0x2c(%ebp)
	x = x + *secondlistVA;
  8001a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001a4:	8b 10                	mov    (%eax),%edx
  8001a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001a9:	01 d0                	add    %edx,%eax
  8001ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	actual_second_list[0]=0X205000;
  8001ae:	c7 85 78 ff ff fe 00 	movl   $0x205000,-0x1000088(%ebp)
  8001b5:	50 20 00 
	actual_second_list[1]=0X204000;
  8001b8:	c7 85 7c ff ff fe 00 	movl   $0x204000,-0x1000084(%ebp)
  8001bf:	40 20 00 
	actual_second_list[2]=0x203000;
  8001c2:	c7 85 80 ff ff fe 00 	movl   $0x203000,-0x1000080(%ebp)
  8001c9:	30 20 00 
	actual_second_list[3]=0x201000;
  8001cc:	c7 85 84 ff ff fe 00 	movl   $0x201000,-0x100007c(%ebp)
  8001d3:	10 20 00 
	for (int i=12;i>6;i--)
  8001d6:	c7 45 f0 0c 00 00 00 	movl   $0xc,-0x10(%ebp)
  8001dd:	eb 1a                	jmp    8001f9 <_main+0x1c1>
		actual_active_list[i]=actual_active_list[i-7];
  8001df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001e2:	83 e8 07             	sub    $0x7,%eax
  8001e5:	8b 94 85 94 ff ff fe 	mov    -0x100006c(%ebp,%eax,4),%edx
  8001ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001ef:	89 94 85 94 ff ff fe 	mov    %edx,-0x100006c(%ebp,%eax,4)

	actual_second_list[0]=0X205000;
	actual_second_list[1]=0X204000;
	actual_second_list[2]=0x203000;
	actual_second_list[3]=0x201000;
	for (int i=12;i>6;i--)
  8001f6:	ff 4d f0             	decl   -0x10(%ebp)
  8001f9:	83 7d f0 06          	cmpl   $0x6,-0x10(%ebp)
  8001fd:	7f e0                	jg     8001df <_main+0x1a7>
		actual_active_list[i]=actual_active_list[i-7];

	actual_active_list[0]=0x202000;
  8001ff:	c7 85 94 ff ff fe 00 	movl   $0x202000,-0x100006c(%ebp)
  800206:	20 20 00 
	actual_active_list[1]=0x200000;
  800209:	c7 85 98 ff ff fe 00 	movl   $0x200000,-0x1000068(%ebp)
  800210:	00 20 00 
	actual_active_list[2]=0xee3fe000;
  800213:	c7 85 9c ff ff fe 00 	movl   $0xee3fe000,-0x1000064(%ebp)
  80021a:	e0 3f ee 
	actual_active_list[3]=0xee3fd000;
  80021d:	c7 85 a0 ff ff fe 00 	movl   $0xee3fd000,-0x1000060(%ebp)
  800224:	d0 3f ee 
	actual_active_list[4]=0xedffe000;
  800227:	c7 85 a4 ff ff fe 00 	movl   $0xedffe000,-0x100005c(%ebp)
  80022e:	e0 ff ed 
	actual_active_list[5]=0xedffd000;
  800231:	c7 85 a8 ff ff fe 00 	movl   $0xedffd000,-0x1000058(%ebp)
  800238:	d0 ff ed 
	actual_active_list[6]=0xedbfe000;
  80023b:	c7 85 ac ff ff fe 00 	movl   $0xedbfe000,-0x1000054(%ebp)
  800242:	e0 bf ed 

	int eval = 0;
  800245:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	bool is_correct = 1;
  80024c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)

	uint32 expected, actual ;
	cprintf("STEP A: checking PLACEMENT fault handling ... \n");
  800253:	83 ec 0c             	sub    $0xc,%esp
  800256:	68 7c 1f 80 00       	push   $0x801f7c
  80025b:	e8 ce 05 00 00       	call   80082e <cprintf>
  800260:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800263:	8a 85 c8 ff ff fe    	mov    -0x1000038(%ebp),%al
  800269:	3c ff                	cmp    $0xff,%al
  80026b:	74 17                	je     800284 <_main+0x24c>
  80026d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	68 ac 1f 80 00       	push   $0x801fac
  80027c:	e8 ad 05 00 00       	call   80082e <cprintf>
  800281:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800284:	8a 85 c8 0f 00 ff    	mov    -0xfff038(%ebp),%al
  80028a:	3c ff                	cmp    $0xff,%al
  80028c:	74 17                	je     8002a5 <_main+0x26d>
  80028e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	68 ac 1f 80 00       	push   $0x801fac
  80029d:	e8 8c 05 00 00       	call   80082e <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8002a5:	8a 85 c8 ff 3f ff    	mov    -0xc00038(%ebp),%al
  8002ab:	3c ff                	cmp    $0xff,%al
  8002ad:	74 17                	je     8002c6 <_main+0x28e>
  8002af:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002b6:	83 ec 0c             	sub    $0xc,%esp
  8002b9:	68 ac 1f 80 00       	push   $0x801fac
  8002be:	e8 6b 05 00 00       	call   80082e <cprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1025] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8002c6:	8a 85 c8 0f 40 ff    	mov    -0xbff038(%ebp),%al
  8002cc:	3c ff                	cmp    $0xff,%al
  8002ce:	74 17                	je     8002e7 <_main+0x2af>
  8002d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 ac 1f 80 00       	push   $0x801fac
  8002df:	e8 4a 05 00 00       	call   80082e <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024*2] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8002e7:	8a 85 c8 ff 7f ff    	mov    -0x800038(%ebp),%al
  8002ed:	3c ff                	cmp    $0xff,%al
  8002ef:	74 17                	je     800308 <_main+0x2d0>
  8002f1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002f8:	83 ec 0c             	sub    $0xc,%esp
  8002fb:	68 ac 1f 80 00       	push   $0x801fac
  800300:	e8 29 05 00 00       	call   80082e <cprintf>
  800305:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800308:	8a 85 c8 0f 80 ff    	mov    -0x7ff038(%ebp),%al
  80030e:	3c ff                	cmp    $0xff,%al
  800310:	74 17                	je     800329 <_main+0x2f1>
  800312:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	68 ac 1f 80 00       	push   $0x801fac
  800321:	e8 08 05 00 00       	call   80082e <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("new stack pages should NOT written to Page File until it's replaced\n"); }
  800329:	e8 05 14 00 00       	call   801733 <sys_pf_calculate_allocated_pages>
  80032e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800331:	74 17                	je     80034a <_main+0x312>
  800333:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80033a:	83 ec 0c             	sub    $0xc,%esp
  80033d:	68 cc 1f 80 00       	push   $0x801fcc
  800342:	e8 e7 04 00 00       	call   80082e <cprintf>
  800347:	83 c4 10             	add    $0x10,%esp

		expected = 6 /*pages*/ + 3 /*tables*/ - 2 /*table + page due to a fault in the 1st call of sys_calculate_free_frames*/;
  80034a:	c7 45 d0 07 00 00 00 	movl   $0x7,-0x30(%ebp)
		actual = (freePages - sys_calculate_free_frames()) ;
  800351:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800354:	e8 8f 13 00 00       	call   8016e8 <sys_calculate_free_frames>
  800359:	29 c3                	sub    %eax,%ebx
  80035b:	89 d8                	mov    %ebx,%eax
  80035d:	89 45 cc             	mov    %eax,-0x34(%ebp)
		//actual = (initFreeFrames - sys_calculate_free_frames()) ;
		if(actual != expected) { is_correct = 0; cprintf("allocated memory size incorrect. Expected = %d, Actual = %d\n", expected, actual); }
  800360:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800363:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800366:	74 1d                	je     800385 <_main+0x34d>
  800368:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80036f:	83 ec 04             	sub    $0x4,%esp
  800372:	ff 75 cc             	pushl  -0x34(%ebp)
  800375:	ff 75 d0             	pushl  -0x30(%ebp)
  800378:	68 14 20 80 00       	push   $0x802014
  80037d:	e8 ac 04 00 00       	call   80082e <cprintf>
  800382:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  800385:	83 ec 0c             	sub    $0xc,%esp
  800388:	68 54 20 80 00       	push   $0x802054
  80038d:	e8 9c 04 00 00       	call   80082e <cprintf>
  800392:	83 c4 10             	add    $0x10,%esp
	if (is_correct)
  800395:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800399:	74 04                	je     80039f <_main+0x367>
		eval += 50 ;
  80039b:	83 45 ec 32          	addl   $0x32,-0x14(%ebp)
	is_correct = 1;
  80039f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)

	cprintf("STEP B: checking LRU lists entries After Required PAGES IN SECOND LIST...\n");
  8003a6:	83 ec 0c             	sub    $0xc,%esp
  8003a9:	68 88 20 80 00       	push   $0x802088
  8003ae:	e8 7b 04 00 00       	call   80082e <cprintf>
  8003b3:	83 c4 10             	add    $0x10,%esp
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 13, 4);
  8003b6:	6a 04                	push   $0x4
  8003b8:	6a 0d                	push   $0xd
  8003ba:	8d 85 78 ff ff fe    	lea    -0x1000088(%ebp),%eax
  8003c0:	50                   	push   %eax
  8003c1:	8d 85 94 ff ff fe    	lea    -0x100006c(%ebp),%eax
  8003c7:	50                   	push   %eax
  8003c8:	e8 34 17 00 00       	call   801b01 <sys_check_LRU_lists>
  8003cd:	83 c4 10             	add    $0x10,%esp
  8003d0:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if(check == 0)
  8003d3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8003d7:	75 17                	jne    8003f0 <_main+0x3b8>
			{ is_correct = 0; cprintf("LRU lists entries are not correct, check your logic again!!\n"); }
  8003d9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003e0:	83 ec 0c             	sub    $0xc,%esp
  8003e3:	68 d4 20 80 00       	push   $0x8020d4
  8003e8:	e8 41 04 00 00       	call   80082e <cprintf>
  8003ed:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP B passed: checking LRU lists entries After Required PAGES IN SECOND LIST test are correct\n\n\n");
  8003f0:	83 ec 0c             	sub    $0xc,%esp
  8003f3:	68 14 21 80 00       	push   $0x802114
  8003f8:	e8 31 04 00 00       	call   80082e <cprintf>
  8003fd:	83 c4 10             	add    $0x10,%esp
	if (is_correct)
  800400:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800404:	74 04                	je     80040a <_main+0x3d2>
		eval += 50 ;
  800406:	83 45 ec 32          	addl   $0x32,-0x14(%ebp)
	is_correct = 1;
  80040a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)

	cprintf("Congratulations!! Test of PAGE PLACEMENT THIRD SCENARIO completed. Eval = %d\n\n\n", eval);
  800411:	83 ec 08             	sub    $0x8,%esp
  800414:	ff 75 ec             	pushl  -0x14(%ebp)
  800417:	68 78 21 80 00       	push   $0x802178
  80041c:	e8 0d 04 00 00       	call   80082e <cprintf>
  800421:	83 c4 10             	add    $0x10,%esp
	return;
  800424:	90                   	nop
}
  800425:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800428:	5b                   	pop    %ebx
  800429:	5f                   	pop    %edi
  80042a:	5d                   	pop    %ebp
  80042b:	c3                   	ret    

0080042c <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
  80042f:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800432:	e8 7a 14 00 00       	call   8018b1 <sys_getenvindex>
  800437:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80043a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80043d:	89 d0                	mov    %edx,%eax
  80043f:	c1 e0 02             	shl    $0x2,%eax
  800442:	01 d0                	add    %edx,%eax
  800444:	c1 e0 03             	shl    $0x3,%eax
  800447:	01 d0                	add    %edx,%eax
  800449:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800450:	01 d0                	add    %edx,%eax
  800452:	c1 e0 02             	shl    $0x2,%eax
  800455:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80045a:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80045f:	a1 08 30 80 00       	mov    0x803008,%eax
  800464:	8a 40 20             	mov    0x20(%eax),%al
  800467:	84 c0                	test   %al,%al
  800469:	74 0d                	je     800478 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  80046b:	a1 08 30 80 00       	mov    0x803008,%eax
  800470:	83 c0 20             	add    $0x20,%eax
  800473:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800478:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80047c:	7e 0a                	jle    800488 <libmain+0x5c>
		binaryname = argv[0];
  80047e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800481:	8b 00                	mov    (%eax),%eax
  800483:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800488:	83 ec 08             	sub    $0x8,%esp
  80048b:	ff 75 0c             	pushl  0xc(%ebp)
  80048e:	ff 75 08             	pushl  0x8(%ebp)
  800491:	e8 a2 fb ff ff       	call   800038 <_main>
  800496:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800499:	a1 00 30 80 00       	mov    0x803000,%eax
  80049e:	85 c0                	test   %eax,%eax
  8004a0:	0f 84 9f 00 00 00    	je     800545 <libmain+0x119>
	{
		sys_lock_cons();
  8004a6:	e8 8a 11 00 00       	call   801635 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8004ab:	83 ec 0c             	sub    $0xc,%esp
  8004ae:	68 e0 21 80 00       	push   $0x8021e0
  8004b3:	e8 76 03 00 00       	call   80082e <cprintf>
  8004b8:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004bb:	a1 08 30 80 00       	mov    0x803008,%eax
  8004c0:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8004c6:	a1 08 30 80 00       	mov    0x803008,%eax
  8004cb:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8004d1:	83 ec 04             	sub    $0x4,%esp
  8004d4:	52                   	push   %edx
  8004d5:	50                   	push   %eax
  8004d6:	68 08 22 80 00       	push   $0x802208
  8004db:	e8 4e 03 00 00       	call   80082e <cprintf>
  8004e0:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004e3:	a1 08 30 80 00       	mov    0x803008,%eax
  8004e8:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8004ee:	a1 08 30 80 00       	mov    0x803008,%eax
  8004f3:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8004f9:	a1 08 30 80 00       	mov    0x803008,%eax
  8004fe:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800504:	51                   	push   %ecx
  800505:	52                   	push   %edx
  800506:	50                   	push   %eax
  800507:	68 30 22 80 00       	push   $0x802230
  80050c:	e8 1d 03 00 00       	call   80082e <cprintf>
  800511:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800514:	a1 08 30 80 00       	mov    0x803008,%eax
  800519:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80051f:	83 ec 08             	sub    $0x8,%esp
  800522:	50                   	push   %eax
  800523:	68 88 22 80 00       	push   $0x802288
  800528:	e8 01 03 00 00       	call   80082e <cprintf>
  80052d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800530:	83 ec 0c             	sub    $0xc,%esp
  800533:	68 e0 21 80 00       	push   $0x8021e0
  800538:	e8 f1 02 00 00       	call   80082e <cprintf>
  80053d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800540:	e8 0a 11 00 00       	call   80164f <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800545:	e8 19 00 00 00       	call   800563 <exit>
}
  80054a:	90                   	nop
  80054b:	c9                   	leave  
  80054c:	c3                   	ret    

0080054d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80054d:	55                   	push   %ebp
  80054e:	89 e5                	mov    %esp,%ebp
  800550:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800553:	83 ec 0c             	sub    $0xc,%esp
  800556:	6a 00                	push   $0x0
  800558:	e8 20 13 00 00       	call   80187d <sys_destroy_env>
  80055d:	83 c4 10             	add    $0x10,%esp
}
  800560:	90                   	nop
  800561:	c9                   	leave  
  800562:	c3                   	ret    

00800563 <exit>:

void
exit(void)
{
  800563:	55                   	push   %ebp
  800564:	89 e5                	mov    %esp,%ebp
  800566:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800569:	e8 75 13 00 00       	call   8018e3 <sys_exit_env>
}
  80056e:	90                   	nop
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800577:	8d 45 10             	lea    0x10(%ebp),%eax
  80057a:	83 c0 04             	add    $0x4,%eax
  80057d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800580:	a1 28 30 80 00       	mov    0x803028,%eax
  800585:	85 c0                	test   %eax,%eax
  800587:	74 16                	je     80059f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800589:	a1 28 30 80 00       	mov    0x803028,%eax
  80058e:	83 ec 08             	sub    $0x8,%esp
  800591:	50                   	push   %eax
  800592:	68 9c 22 80 00       	push   $0x80229c
  800597:	e8 92 02 00 00       	call   80082e <cprintf>
  80059c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80059f:	a1 04 30 80 00       	mov    0x803004,%eax
  8005a4:	ff 75 0c             	pushl  0xc(%ebp)
  8005a7:	ff 75 08             	pushl  0x8(%ebp)
  8005aa:	50                   	push   %eax
  8005ab:	68 a1 22 80 00       	push   $0x8022a1
  8005b0:	e8 79 02 00 00       	call   80082e <cprintf>
  8005b5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8005bb:	83 ec 08             	sub    $0x8,%esp
  8005be:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c1:	50                   	push   %eax
  8005c2:	e8 fc 01 00 00       	call   8007c3 <vcprintf>
  8005c7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005ca:	83 ec 08             	sub    $0x8,%esp
  8005cd:	6a 00                	push   $0x0
  8005cf:	68 bd 22 80 00       	push   $0x8022bd
  8005d4:	e8 ea 01 00 00       	call   8007c3 <vcprintf>
  8005d9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005dc:	e8 82 ff ff ff       	call   800563 <exit>

	// should not return here
	while (1) ;
  8005e1:	eb fe                	jmp    8005e1 <_panic+0x70>

008005e3 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005e3:	55                   	push   %ebp
  8005e4:	89 e5                	mov    %esp,%ebp
  8005e6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005e9:	a1 08 30 80 00       	mov    0x803008,%eax
  8005ee:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8005f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f7:	39 c2                	cmp    %eax,%edx
  8005f9:	74 14                	je     80060f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005fb:	83 ec 04             	sub    $0x4,%esp
  8005fe:	68 c0 22 80 00       	push   $0x8022c0
  800603:	6a 26                	push   $0x26
  800605:	68 0c 23 80 00       	push   $0x80230c
  80060a:	e8 62 ff ff ff       	call   800571 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80060f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800616:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80061d:	e9 c5 00 00 00       	jmp    8006e7 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800622:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800625:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80062c:	8b 45 08             	mov    0x8(%ebp),%eax
  80062f:	01 d0                	add    %edx,%eax
  800631:	8b 00                	mov    (%eax),%eax
  800633:	85 c0                	test   %eax,%eax
  800635:	75 08                	jne    80063f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800637:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80063a:	e9 a5 00 00 00       	jmp    8006e4 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80063f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800646:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80064d:	eb 69                	jmp    8006b8 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80064f:	a1 08 30 80 00       	mov    0x803008,%eax
  800654:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80065a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80065d:	89 d0                	mov    %edx,%eax
  80065f:	01 c0                	add    %eax,%eax
  800661:	01 d0                	add    %edx,%eax
  800663:	c1 e0 03             	shl    $0x3,%eax
  800666:	01 c8                	add    %ecx,%eax
  800668:	8a 40 04             	mov    0x4(%eax),%al
  80066b:	84 c0                	test   %al,%al
  80066d:	75 46                	jne    8006b5 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80066f:	a1 08 30 80 00       	mov    0x803008,%eax
  800674:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80067a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80067d:	89 d0                	mov    %edx,%eax
  80067f:	01 c0                	add    %eax,%eax
  800681:	01 d0                	add    %edx,%eax
  800683:	c1 e0 03             	shl    $0x3,%eax
  800686:	01 c8                	add    %ecx,%eax
  800688:	8b 00                	mov    (%eax),%eax
  80068a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80068d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800690:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800695:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800697:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80069a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a4:	01 c8                	add    %ecx,%eax
  8006a6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006a8:	39 c2                	cmp    %eax,%edx
  8006aa:	75 09                	jne    8006b5 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8006ac:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006b3:	eb 15                	jmp    8006ca <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006b5:	ff 45 e8             	incl   -0x18(%ebp)
  8006b8:	a1 08 30 80 00       	mov    0x803008,%eax
  8006bd:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8006c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006c6:	39 c2                	cmp    %eax,%edx
  8006c8:	77 85                	ja     80064f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8006ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006ce:	75 14                	jne    8006e4 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8006d0:	83 ec 04             	sub    $0x4,%esp
  8006d3:	68 18 23 80 00       	push   $0x802318
  8006d8:	6a 3a                	push   $0x3a
  8006da:	68 0c 23 80 00       	push   $0x80230c
  8006df:	e8 8d fe ff ff       	call   800571 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006e4:	ff 45 f0             	incl   -0x10(%ebp)
  8006e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006ed:	0f 8c 2f ff ff ff    	jl     800622 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800701:	eb 26                	jmp    800729 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800703:	a1 08 30 80 00       	mov    0x803008,%eax
  800708:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80070e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800711:	89 d0                	mov    %edx,%eax
  800713:	01 c0                	add    %eax,%eax
  800715:	01 d0                	add    %edx,%eax
  800717:	c1 e0 03             	shl    $0x3,%eax
  80071a:	01 c8                	add    %ecx,%eax
  80071c:	8a 40 04             	mov    0x4(%eax),%al
  80071f:	3c 01                	cmp    $0x1,%al
  800721:	75 03                	jne    800726 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800723:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800726:	ff 45 e0             	incl   -0x20(%ebp)
  800729:	a1 08 30 80 00       	mov    0x803008,%eax
  80072e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800734:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800737:	39 c2                	cmp    %eax,%edx
  800739:	77 c8                	ja     800703 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80073b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80073e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800741:	74 14                	je     800757 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800743:	83 ec 04             	sub    $0x4,%esp
  800746:	68 6c 23 80 00       	push   $0x80236c
  80074b:	6a 44                	push   $0x44
  80074d:	68 0c 23 80 00       	push   $0x80230c
  800752:	e8 1a fe ff ff       	call   800571 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800757:	90                   	nop
  800758:	c9                   	leave  
  800759:	c3                   	ret    

0080075a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80075a:	55                   	push   %ebp
  80075b:	89 e5                	mov    %esp,%ebp
  80075d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800760:	8b 45 0c             	mov    0xc(%ebp),%eax
  800763:	8b 00                	mov    (%eax),%eax
  800765:	8d 48 01             	lea    0x1(%eax),%ecx
  800768:	8b 55 0c             	mov    0xc(%ebp),%edx
  80076b:	89 0a                	mov    %ecx,(%edx)
  80076d:	8b 55 08             	mov    0x8(%ebp),%edx
  800770:	88 d1                	mov    %dl,%cl
  800772:	8b 55 0c             	mov    0xc(%ebp),%edx
  800775:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800779:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077c:	8b 00                	mov    (%eax),%eax
  80077e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800783:	75 2c                	jne    8007b1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800785:	a0 0c 30 80 00       	mov    0x80300c,%al
  80078a:	0f b6 c0             	movzbl %al,%eax
  80078d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800790:	8b 12                	mov    (%edx),%edx
  800792:	89 d1                	mov    %edx,%ecx
  800794:	8b 55 0c             	mov    0xc(%ebp),%edx
  800797:	83 c2 08             	add    $0x8,%edx
  80079a:	83 ec 04             	sub    $0x4,%esp
  80079d:	50                   	push   %eax
  80079e:	51                   	push   %ecx
  80079f:	52                   	push   %edx
  8007a0:	e8 4e 0e 00 00       	call   8015f3 <sys_cputs>
  8007a5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b4:	8b 40 04             	mov    0x4(%eax),%eax
  8007b7:	8d 50 01             	lea    0x1(%eax),%edx
  8007ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bd:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007c0:	90                   	nop
  8007c1:	c9                   	leave  
  8007c2:	c3                   	ret    

008007c3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007c3:	55                   	push   %ebp
  8007c4:	89 e5                	mov    %esp,%ebp
  8007c6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007cc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007d3:	00 00 00 
	b.cnt = 0;
  8007d6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007dd:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007e0:	ff 75 0c             	pushl  0xc(%ebp)
  8007e3:	ff 75 08             	pushl  0x8(%ebp)
  8007e6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007ec:	50                   	push   %eax
  8007ed:	68 5a 07 80 00       	push   $0x80075a
  8007f2:	e8 11 02 00 00       	call   800a08 <vprintfmt>
  8007f7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007fa:	a0 0c 30 80 00       	mov    0x80300c,%al
  8007ff:	0f b6 c0             	movzbl %al,%eax
  800802:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800808:	83 ec 04             	sub    $0x4,%esp
  80080b:	50                   	push   %eax
  80080c:	52                   	push   %edx
  80080d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800813:	83 c0 08             	add    $0x8,%eax
  800816:	50                   	push   %eax
  800817:	e8 d7 0d 00 00       	call   8015f3 <sys_cputs>
  80081c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80081f:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  800826:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80082c:	c9                   	leave  
  80082d:	c3                   	ret    

0080082e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800834:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  80083b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80083e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800841:	8b 45 08             	mov    0x8(%ebp),%eax
  800844:	83 ec 08             	sub    $0x8,%esp
  800847:	ff 75 f4             	pushl  -0xc(%ebp)
  80084a:	50                   	push   %eax
  80084b:	e8 73 ff ff ff       	call   8007c3 <vcprintf>
  800850:	83 c4 10             	add    $0x10,%esp
  800853:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800856:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800859:	c9                   	leave  
  80085a:	c3                   	ret    

0080085b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800861:	e8 cf 0d 00 00       	call   801635 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800866:	8d 45 0c             	lea    0xc(%ebp),%eax
  800869:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80086c:	8b 45 08             	mov    0x8(%ebp),%eax
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	ff 75 f4             	pushl  -0xc(%ebp)
  800875:	50                   	push   %eax
  800876:	e8 48 ff ff ff       	call   8007c3 <vcprintf>
  80087b:	83 c4 10             	add    $0x10,%esp
  80087e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800881:	e8 c9 0d 00 00       	call   80164f <sys_unlock_cons>
	return cnt;
  800886:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800889:	c9                   	leave  
  80088a:	c3                   	ret    

0080088b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	53                   	push   %ebx
  80088f:	83 ec 14             	sub    $0x14,%esp
  800892:	8b 45 10             	mov    0x10(%ebp),%eax
  800895:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800898:	8b 45 14             	mov    0x14(%ebp),%eax
  80089b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80089e:	8b 45 18             	mov    0x18(%ebp),%eax
  8008a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008a9:	77 55                	ja     800900 <printnum+0x75>
  8008ab:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008ae:	72 05                	jb     8008b5 <printnum+0x2a>
  8008b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008b3:	77 4b                	ja     800900 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008b5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008b8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008bb:	8b 45 18             	mov    0x18(%ebp),%eax
  8008be:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c3:	52                   	push   %edx
  8008c4:	50                   	push   %eax
  8008c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8008c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8008cb:	e8 98 13 00 00       	call   801c68 <__udivdi3>
  8008d0:	83 c4 10             	add    $0x10,%esp
  8008d3:	83 ec 04             	sub    $0x4,%esp
  8008d6:	ff 75 20             	pushl  0x20(%ebp)
  8008d9:	53                   	push   %ebx
  8008da:	ff 75 18             	pushl  0x18(%ebp)
  8008dd:	52                   	push   %edx
  8008de:	50                   	push   %eax
  8008df:	ff 75 0c             	pushl  0xc(%ebp)
  8008e2:	ff 75 08             	pushl  0x8(%ebp)
  8008e5:	e8 a1 ff ff ff       	call   80088b <printnum>
  8008ea:	83 c4 20             	add    $0x20,%esp
  8008ed:	eb 1a                	jmp    800909 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	ff 75 0c             	pushl  0xc(%ebp)
  8008f5:	ff 75 20             	pushl  0x20(%ebp)
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	ff d0                	call   *%eax
  8008fd:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800900:	ff 4d 1c             	decl   0x1c(%ebp)
  800903:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800907:	7f e6                	jg     8008ef <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800909:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80090c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800911:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800914:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800917:	53                   	push   %ebx
  800918:	51                   	push   %ecx
  800919:	52                   	push   %edx
  80091a:	50                   	push   %eax
  80091b:	e8 58 14 00 00       	call   801d78 <__umoddi3>
  800920:	83 c4 10             	add    $0x10,%esp
  800923:	05 d4 25 80 00       	add    $0x8025d4,%eax
  800928:	8a 00                	mov    (%eax),%al
  80092a:	0f be c0             	movsbl %al,%eax
  80092d:	83 ec 08             	sub    $0x8,%esp
  800930:	ff 75 0c             	pushl  0xc(%ebp)
  800933:	50                   	push   %eax
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	ff d0                	call   *%eax
  800939:	83 c4 10             	add    $0x10,%esp
}
  80093c:	90                   	nop
  80093d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800940:	c9                   	leave  
  800941:	c3                   	ret    

00800942 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800945:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800949:	7e 1c                	jle    800967 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	8b 00                	mov    (%eax),%eax
  800950:	8d 50 08             	lea    0x8(%eax),%edx
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	89 10                	mov    %edx,(%eax)
  800958:	8b 45 08             	mov    0x8(%ebp),%eax
  80095b:	8b 00                	mov    (%eax),%eax
  80095d:	83 e8 08             	sub    $0x8,%eax
  800960:	8b 50 04             	mov    0x4(%eax),%edx
  800963:	8b 00                	mov    (%eax),%eax
  800965:	eb 40                	jmp    8009a7 <getuint+0x65>
	else if (lflag)
  800967:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80096b:	74 1e                	je     80098b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	8b 00                	mov    (%eax),%eax
  800972:	8d 50 04             	lea    0x4(%eax),%edx
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	89 10                	mov    %edx,(%eax)
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	8b 00                	mov    (%eax),%eax
  80097f:	83 e8 04             	sub    $0x4,%eax
  800982:	8b 00                	mov    (%eax),%eax
  800984:	ba 00 00 00 00       	mov    $0x0,%edx
  800989:	eb 1c                	jmp    8009a7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	8b 00                	mov    (%eax),%eax
  800990:	8d 50 04             	lea    0x4(%eax),%edx
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	89 10                	mov    %edx,(%eax)
  800998:	8b 45 08             	mov    0x8(%ebp),%eax
  80099b:	8b 00                	mov    (%eax),%eax
  80099d:	83 e8 04             	sub    $0x4,%eax
  8009a0:	8b 00                	mov    (%eax),%eax
  8009a2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009a7:	5d                   	pop    %ebp
  8009a8:	c3                   	ret    

008009a9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009a9:	55                   	push   %ebp
  8009aa:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009ac:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009b0:	7e 1c                	jle    8009ce <getint+0x25>
		return va_arg(*ap, long long);
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	8b 00                	mov    (%eax),%eax
  8009b7:	8d 50 08             	lea    0x8(%eax),%edx
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	89 10                	mov    %edx,(%eax)
  8009bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c2:	8b 00                	mov    (%eax),%eax
  8009c4:	83 e8 08             	sub    $0x8,%eax
  8009c7:	8b 50 04             	mov    0x4(%eax),%edx
  8009ca:	8b 00                	mov    (%eax),%eax
  8009cc:	eb 38                	jmp    800a06 <getint+0x5d>
	else if (lflag)
  8009ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009d2:	74 1a                	je     8009ee <getint+0x45>
		return va_arg(*ap, long);
  8009d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d7:	8b 00                	mov    (%eax),%eax
  8009d9:	8d 50 04             	lea    0x4(%eax),%edx
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	89 10                	mov    %edx,(%eax)
  8009e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e4:	8b 00                	mov    (%eax),%eax
  8009e6:	83 e8 04             	sub    $0x4,%eax
  8009e9:	8b 00                	mov    (%eax),%eax
  8009eb:	99                   	cltd   
  8009ec:	eb 18                	jmp    800a06 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	8b 00                	mov    (%eax),%eax
  8009f3:	8d 50 04             	lea    0x4(%eax),%edx
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	89 10                	mov    %edx,(%eax)
  8009fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fe:	8b 00                	mov    (%eax),%eax
  800a00:	83 e8 04             	sub    $0x4,%eax
  800a03:	8b 00                	mov    (%eax),%eax
  800a05:	99                   	cltd   
}
  800a06:	5d                   	pop    %ebp
  800a07:	c3                   	ret    

00800a08 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a08:	55                   	push   %ebp
  800a09:	89 e5                	mov    %esp,%ebp
  800a0b:	56                   	push   %esi
  800a0c:	53                   	push   %ebx
  800a0d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a10:	eb 17                	jmp    800a29 <vprintfmt+0x21>
			if (ch == '\0')
  800a12:	85 db                	test   %ebx,%ebx
  800a14:	0f 84 c1 03 00 00    	je     800ddb <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800a1a:	83 ec 08             	sub    $0x8,%esp
  800a1d:	ff 75 0c             	pushl  0xc(%ebp)
  800a20:	53                   	push   %ebx
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	ff d0                	call   *%eax
  800a26:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a29:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2c:	8d 50 01             	lea    0x1(%eax),%edx
  800a2f:	89 55 10             	mov    %edx,0x10(%ebp)
  800a32:	8a 00                	mov    (%eax),%al
  800a34:	0f b6 d8             	movzbl %al,%ebx
  800a37:	83 fb 25             	cmp    $0x25,%ebx
  800a3a:	75 d6                	jne    800a12 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a3c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a40:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a47:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a4e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a55:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a5f:	8d 50 01             	lea    0x1(%eax),%edx
  800a62:	89 55 10             	mov    %edx,0x10(%ebp)
  800a65:	8a 00                	mov    (%eax),%al
  800a67:	0f b6 d8             	movzbl %al,%ebx
  800a6a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a6d:	83 f8 5b             	cmp    $0x5b,%eax
  800a70:	0f 87 3d 03 00 00    	ja     800db3 <vprintfmt+0x3ab>
  800a76:	8b 04 85 f8 25 80 00 	mov    0x8025f8(,%eax,4),%eax
  800a7d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a7f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a83:	eb d7                	jmp    800a5c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a85:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a89:	eb d1                	jmp    800a5c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a8b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a92:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a95:	89 d0                	mov    %edx,%eax
  800a97:	c1 e0 02             	shl    $0x2,%eax
  800a9a:	01 d0                	add    %edx,%eax
  800a9c:	01 c0                	add    %eax,%eax
  800a9e:	01 d8                	add    %ebx,%eax
  800aa0:	83 e8 30             	sub    $0x30,%eax
  800aa3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800aa6:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa9:	8a 00                	mov    (%eax),%al
  800aab:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800aae:	83 fb 2f             	cmp    $0x2f,%ebx
  800ab1:	7e 3e                	jle    800af1 <vprintfmt+0xe9>
  800ab3:	83 fb 39             	cmp    $0x39,%ebx
  800ab6:	7f 39                	jg     800af1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ab8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800abb:	eb d5                	jmp    800a92 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800abd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac0:	83 c0 04             	add    $0x4,%eax
  800ac3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac9:	83 e8 04             	sub    $0x4,%eax
  800acc:	8b 00                	mov    (%eax),%eax
  800ace:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ad1:	eb 1f                	jmp    800af2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ad3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad7:	79 83                	jns    800a5c <vprintfmt+0x54>
				width = 0;
  800ad9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ae0:	e9 77 ff ff ff       	jmp    800a5c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ae5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800aec:	e9 6b ff ff ff       	jmp    800a5c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800af1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800af2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af6:	0f 89 60 ff ff ff    	jns    800a5c <vprintfmt+0x54>
				width = precision, precision = -1;
  800afc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b02:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b09:	e9 4e ff ff ff       	jmp    800a5c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b0e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b11:	e9 46 ff ff ff       	jmp    800a5c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b16:	8b 45 14             	mov    0x14(%ebp),%eax
  800b19:	83 c0 04             	add    $0x4,%eax
  800b1c:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b22:	83 e8 04             	sub    $0x4,%eax
  800b25:	8b 00                	mov    (%eax),%eax
  800b27:	83 ec 08             	sub    $0x8,%esp
  800b2a:	ff 75 0c             	pushl  0xc(%ebp)
  800b2d:	50                   	push   %eax
  800b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b31:	ff d0                	call   *%eax
  800b33:	83 c4 10             	add    $0x10,%esp
			break;
  800b36:	e9 9b 02 00 00       	jmp    800dd6 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b3b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3e:	83 c0 04             	add    $0x4,%eax
  800b41:	89 45 14             	mov    %eax,0x14(%ebp)
  800b44:	8b 45 14             	mov    0x14(%ebp),%eax
  800b47:	83 e8 04             	sub    $0x4,%eax
  800b4a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b4c:	85 db                	test   %ebx,%ebx
  800b4e:	79 02                	jns    800b52 <vprintfmt+0x14a>
				err = -err;
  800b50:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b52:	83 fb 64             	cmp    $0x64,%ebx
  800b55:	7f 0b                	jg     800b62 <vprintfmt+0x15a>
  800b57:	8b 34 9d 40 24 80 00 	mov    0x802440(,%ebx,4),%esi
  800b5e:	85 f6                	test   %esi,%esi
  800b60:	75 19                	jne    800b7b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b62:	53                   	push   %ebx
  800b63:	68 e5 25 80 00       	push   $0x8025e5
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	ff 75 08             	pushl  0x8(%ebp)
  800b6e:	e8 70 02 00 00       	call   800de3 <printfmt>
  800b73:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b76:	e9 5b 02 00 00       	jmp    800dd6 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b7b:	56                   	push   %esi
  800b7c:	68 ee 25 80 00       	push   $0x8025ee
  800b81:	ff 75 0c             	pushl  0xc(%ebp)
  800b84:	ff 75 08             	pushl  0x8(%ebp)
  800b87:	e8 57 02 00 00       	call   800de3 <printfmt>
  800b8c:	83 c4 10             	add    $0x10,%esp
			break;
  800b8f:	e9 42 02 00 00       	jmp    800dd6 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b94:	8b 45 14             	mov    0x14(%ebp),%eax
  800b97:	83 c0 04             	add    $0x4,%eax
  800b9a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba0:	83 e8 04             	sub    $0x4,%eax
  800ba3:	8b 30                	mov    (%eax),%esi
  800ba5:	85 f6                	test   %esi,%esi
  800ba7:	75 05                	jne    800bae <vprintfmt+0x1a6>
				p = "(null)";
  800ba9:	be f1 25 80 00       	mov    $0x8025f1,%esi
			if (width > 0 && padc != '-')
  800bae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb2:	7e 6d                	jle    800c21 <vprintfmt+0x219>
  800bb4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bb8:	74 67                	je     800c21 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bbd:	83 ec 08             	sub    $0x8,%esp
  800bc0:	50                   	push   %eax
  800bc1:	56                   	push   %esi
  800bc2:	e8 1e 03 00 00       	call   800ee5 <strnlen>
  800bc7:	83 c4 10             	add    $0x10,%esp
  800bca:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800bcd:	eb 16                	jmp    800be5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800bcf:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800bd3:	83 ec 08             	sub    $0x8,%esp
  800bd6:	ff 75 0c             	pushl  0xc(%ebp)
  800bd9:	50                   	push   %eax
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	ff d0                	call   *%eax
  800bdf:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800be2:	ff 4d e4             	decl   -0x1c(%ebp)
  800be5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800be9:	7f e4                	jg     800bcf <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800beb:	eb 34                	jmp    800c21 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bed:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bf1:	74 1c                	je     800c0f <vprintfmt+0x207>
  800bf3:	83 fb 1f             	cmp    $0x1f,%ebx
  800bf6:	7e 05                	jle    800bfd <vprintfmt+0x1f5>
  800bf8:	83 fb 7e             	cmp    $0x7e,%ebx
  800bfb:	7e 12                	jle    800c0f <vprintfmt+0x207>
					putch('?', putdat);
  800bfd:	83 ec 08             	sub    $0x8,%esp
  800c00:	ff 75 0c             	pushl  0xc(%ebp)
  800c03:	6a 3f                	push   $0x3f
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	ff d0                	call   *%eax
  800c0a:	83 c4 10             	add    $0x10,%esp
  800c0d:	eb 0f                	jmp    800c1e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c0f:	83 ec 08             	sub    $0x8,%esp
  800c12:	ff 75 0c             	pushl  0xc(%ebp)
  800c15:	53                   	push   %ebx
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	ff d0                	call   *%eax
  800c1b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c1e:	ff 4d e4             	decl   -0x1c(%ebp)
  800c21:	89 f0                	mov    %esi,%eax
  800c23:	8d 70 01             	lea    0x1(%eax),%esi
  800c26:	8a 00                	mov    (%eax),%al
  800c28:	0f be d8             	movsbl %al,%ebx
  800c2b:	85 db                	test   %ebx,%ebx
  800c2d:	74 24                	je     800c53 <vprintfmt+0x24b>
  800c2f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c33:	78 b8                	js     800bed <vprintfmt+0x1e5>
  800c35:	ff 4d e0             	decl   -0x20(%ebp)
  800c38:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c3c:	79 af                	jns    800bed <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c3e:	eb 13                	jmp    800c53 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c40:	83 ec 08             	sub    $0x8,%esp
  800c43:	ff 75 0c             	pushl  0xc(%ebp)
  800c46:	6a 20                	push   $0x20
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	ff d0                	call   *%eax
  800c4d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c50:	ff 4d e4             	decl   -0x1c(%ebp)
  800c53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c57:	7f e7                	jg     800c40 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c59:	e9 78 01 00 00       	jmp    800dd6 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c5e:	83 ec 08             	sub    $0x8,%esp
  800c61:	ff 75 e8             	pushl  -0x18(%ebp)
  800c64:	8d 45 14             	lea    0x14(%ebp),%eax
  800c67:	50                   	push   %eax
  800c68:	e8 3c fd ff ff       	call   8009a9 <getint>
  800c6d:	83 c4 10             	add    $0x10,%esp
  800c70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c73:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c7c:	85 d2                	test   %edx,%edx
  800c7e:	79 23                	jns    800ca3 <vprintfmt+0x29b>
				putch('-', putdat);
  800c80:	83 ec 08             	sub    $0x8,%esp
  800c83:	ff 75 0c             	pushl  0xc(%ebp)
  800c86:	6a 2d                	push   $0x2d
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	ff d0                	call   *%eax
  800c8d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c96:	f7 d8                	neg    %eax
  800c98:	83 d2 00             	adc    $0x0,%edx
  800c9b:	f7 da                	neg    %edx
  800c9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ca3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800caa:	e9 bc 00 00 00       	jmp    800d6b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800caf:	83 ec 08             	sub    $0x8,%esp
  800cb2:	ff 75 e8             	pushl  -0x18(%ebp)
  800cb5:	8d 45 14             	lea    0x14(%ebp),%eax
  800cb8:	50                   	push   %eax
  800cb9:	e8 84 fc ff ff       	call   800942 <getuint>
  800cbe:	83 c4 10             	add    $0x10,%esp
  800cc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800cc7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cce:	e9 98 00 00 00       	jmp    800d6b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800cd3:	83 ec 08             	sub    $0x8,%esp
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	6a 58                	push   $0x58
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	ff d0                	call   *%eax
  800ce0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ce3:	83 ec 08             	sub    $0x8,%esp
  800ce6:	ff 75 0c             	pushl  0xc(%ebp)
  800ce9:	6a 58                	push   $0x58
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	ff d0                	call   *%eax
  800cf0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cf3:	83 ec 08             	sub    $0x8,%esp
  800cf6:	ff 75 0c             	pushl  0xc(%ebp)
  800cf9:	6a 58                	push   $0x58
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	ff d0                	call   *%eax
  800d00:	83 c4 10             	add    $0x10,%esp
			break;
  800d03:	e9 ce 00 00 00       	jmp    800dd6 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800d08:	83 ec 08             	sub    $0x8,%esp
  800d0b:	ff 75 0c             	pushl  0xc(%ebp)
  800d0e:	6a 30                	push   $0x30
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	ff d0                	call   *%eax
  800d15:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d18:	83 ec 08             	sub    $0x8,%esp
  800d1b:	ff 75 0c             	pushl  0xc(%ebp)
  800d1e:	6a 78                	push   $0x78
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	ff d0                	call   *%eax
  800d25:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d28:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2b:	83 c0 04             	add    $0x4,%eax
  800d2e:	89 45 14             	mov    %eax,0x14(%ebp)
  800d31:	8b 45 14             	mov    0x14(%ebp),%eax
  800d34:	83 e8 04             	sub    $0x4,%eax
  800d37:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d43:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d4a:	eb 1f                	jmp    800d6b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d4c:	83 ec 08             	sub    $0x8,%esp
  800d4f:	ff 75 e8             	pushl  -0x18(%ebp)
  800d52:	8d 45 14             	lea    0x14(%ebp),%eax
  800d55:	50                   	push   %eax
  800d56:	e8 e7 fb ff ff       	call   800942 <getuint>
  800d5b:	83 c4 10             	add    $0x10,%esp
  800d5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d61:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d64:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d6b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d72:	83 ec 04             	sub    $0x4,%esp
  800d75:	52                   	push   %edx
  800d76:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d79:	50                   	push   %eax
  800d7a:	ff 75 f4             	pushl  -0xc(%ebp)
  800d7d:	ff 75 f0             	pushl  -0x10(%ebp)
  800d80:	ff 75 0c             	pushl  0xc(%ebp)
  800d83:	ff 75 08             	pushl  0x8(%ebp)
  800d86:	e8 00 fb ff ff       	call   80088b <printnum>
  800d8b:	83 c4 20             	add    $0x20,%esp
			break;
  800d8e:	eb 46                	jmp    800dd6 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d90:	83 ec 08             	sub    $0x8,%esp
  800d93:	ff 75 0c             	pushl  0xc(%ebp)
  800d96:	53                   	push   %ebx
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	ff d0                	call   *%eax
  800d9c:	83 c4 10             	add    $0x10,%esp
			break;
  800d9f:	eb 35                	jmp    800dd6 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800da1:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  800da8:	eb 2c                	jmp    800dd6 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800daa:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  800db1:	eb 23                	jmp    800dd6 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800db3:	83 ec 08             	sub    $0x8,%esp
  800db6:	ff 75 0c             	pushl  0xc(%ebp)
  800db9:	6a 25                	push   $0x25
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	ff d0                	call   *%eax
  800dc0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dc3:	ff 4d 10             	decl   0x10(%ebp)
  800dc6:	eb 03                	jmp    800dcb <vprintfmt+0x3c3>
  800dc8:	ff 4d 10             	decl   0x10(%ebp)
  800dcb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dce:	48                   	dec    %eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	3c 25                	cmp    $0x25,%al
  800dd3:	75 f3                	jne    800dc8 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800dd5:	90                   	nop
		}
	}
  800dd6:	e9 35 fc ff ff       	jmp    800a10 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ddb:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ddc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ddf:	5b                   	pop    %ebx
  800de0:	5e                   	pop    %esi
  800de1:	5d                   	pop    %ebp
  800de2:	c3                   	ret    

00800de3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800de9:	8d 45 10             	lea    0x10(%ebp),%eax
  800dec:	83 c0 04             	add    $0x4,%eax
  800def:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800df2:	8b 45 10             	mov    0x10(%ebp),%eax
  800df5:	ff 75 f4             	pushl  -0xc(%ebp)
  800df8:	50                   	push   %eax
  800df9:	ff 75 0c             	pushl  0xc(%ebp)
  800dfc:	ff 75 08             	pushl  0x8(%ebp)
  800dff:	e8 04 fc ff ff       	call   800a08 <vprintfmt>
  800e04:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e07:	90                   	nop
  800e08:	c9                   	leave  
  800e09:	c3                   	ret    

00800e0a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e10:	8b 40 08             	mov    0x8(%eax),%eax
  800e13:	8d 50 01             	lea    0x1(%eax),%edx
  800e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e19:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1f:	8b 10                	mov    (%eax),%edx
  800e21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e24:	8b 40 04             	mov    0x4(%eax),%eax
  800e27:	39 c2                	cmp    %eax,%edx
  800e29:	73 12                	jae    800e3d <sprintputch+0x33>
		*b->buf++ = ch;
  800e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2e:	8b 00                	mov    (%eax),%eax
  800e30:	8d 48 01             	lea    0x1(%eax),%ecx
  800e33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e36:	89 0a                	mov    %ecx,(%edx)
  800e38:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3b:	88 10                	mov    %dl,(%eax)
}
  800e3d:	90                   	nop
  800e3e:	5d                   	pop    %ebp
  800e3f:	c3                   	ret    

00800e40 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	01 d0                	add    %edx,%eax
  800e57:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e61:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e65:	74 06                	je     800e6d <vsnprintf+0x2d>
  800e67:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e6b:	7f 07                	jg     800e74 <vsnprintf+0x34>
		return -E_INVAL;
  800e6d:	b8 03 00 00 00       	mov    $0x3,%eax
  800e72:	eb 20                	jmp    800e94 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e74:	ff 75 14             	pushl  0x14(%ebp)
  800e77:	ff 75 10             	pushl  0x10(%ebp)
  800e7a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e7d:	50                   	push   %eax
  800e7e:	68 0a 0e 80 00       	push   $0x800e0a
  800e83:	e8 80 fb ff ff       	call   800a08 <vprintfmt>
  800e88:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e8e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e94:	c9                   	leave  
  800e95:	c3                   	ret    

00800e96 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e9c:	8d 45 10             	lea    0x10(%ebp),%eax
  800e9f:	83 c0 04             	add    $0x4,%eax
  800ea2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ea5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea8:	ff 75 f4             	pushl  -0xc(%ebp)
  800eab:	50                   	push   %eax
  800eac:	ff 75 0c             	pushl  0xc(%ebp)
  800eaf:	ff 75 08             	pushl  0x8(%ebp)
  800eb2:	e8 89 ff ff ff       	call   800e40 <vsnprintf>
  800eb7:	83 c4 10             	add    $0x10,%esp
  800eba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ebd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ec8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ecf:	eb 06                	jmp    800ed7 <strlen+0x15>
		n++;
  800ed1:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ed4:	ff 45 08             	incl   0x8(%ebp)
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	84 c0                	test   %al,%al
  800ede:	75 f1                	jne    800ed1 <strlen+0xf>
		n++;
	return n;
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ee3:	c9                   	leave  
  800ee4:	c3                   	ret    

00800ee5 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eeb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ef2:	eb 09                	jmp    800efd <strnlen+0x18>
		n++;
  800ef4:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ef7:	ff 45 08             	incl   0x8(%ebp)
  800efa:	ff 4d 0c             	decl   0xc(%ebp)
  800efd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f01:	74 09                	je     800f0c <strnlen+0x27>
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	8a 00                	mov    (%eax),%al
  800f08:	84 c0                	test   %al,%al
  800f0a:	75 e8                	jne    800ef4 <strnlen+0xf>
		n++;
	return n;
  800f0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f0f:	c9                   	leave  
  800f10:	c3                   	ret    

00800f11 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f11:	55                   	push   %ebp
  800f12:	89 e5                	mov    %esp,%ebp
  800f14:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f1d:	90                   	nop
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	8d 50 01             	lea    0x1(%eax),%edx
  800f24:	89 55 08             	mov    %edx,0x8(%ebp)
  800f27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f2d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f30:	8a 12                	mov    (%edx),%dl
  800f32:	88 10                	mov    %dl,(%eax)
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	84 c0                	test   %al,%al
  800f38:	75 e4                	jne    800f1e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f3d:	c9                   	leave  
  800f3e:	c3                   	ret    

00800f3f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f4b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f52:	eb 1f                	jmp    800f73 <strncpy+0x34>
		*dst++ = *src;
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	8d 50 01             	lea    0x1(%eax),%edx
  800f5a:	89 55 08             	mov    %edx,0x8(%ebp)
  800f5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f60:	8a 12                	mov    (%edx),%dl
  800f62:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	84 c0                	test   %al,%al
  800f6b:	74 03                	je     800f70 <strncpy+0x31>
			src++;
  800f6d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f70:	ff 45 fc             	incl   -0x4(%ebp)
  800f73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f76:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f79:	72 d9                	jb     800f54 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f7e:	c9                   	leave  
  800f7f:	c3                   	ret    

00800f80 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f90:	74 30                	je     800fc2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f92:	eb 16                	jmp    800faa <strlcpy+0x2a>
			*dst++ = *src++;
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	8d 50 01             	lea    0x1(%eax),%edx
  800f9a:	89 55 08             	mov    %edx,0x8(%ebp)
  800f9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fa0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fa3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fa6:	8a 12                	mov    (%edx),%dl
  800fa8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800faa:	ff 4d 10             	decl   0x10(%ebp)
  800fad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb1:	74 09                	je     800fbc <strlcpy+0x3c>
  800fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	84 c0                	test   %al,%al
  800fba:	75 d8                	jne    800f94 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc8:	29 c2                	sub    %eax,%edx
  800fca:	89 d0                	mov    %edx,%eax
}
  800fcc:	c9                   	leave  
  800fcd:	c3                   	ret    

00800fce <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800fd1:	eb 06                	jmp    800fd9 <strcmp+0xb>
		p++, q++;
  800fd3:	ff 45 08             	incl   0x8(%ebp)
  800fd6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	8a 00                	mov    (%eax),%al
  800fde:	84 c0                	test   %al,%al
  800fe0:	74 0e                	je     800ff0 <strcmp+0x22>
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	8a 10                	mov    (%eax),%dl
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	38 c2                	cmp    %al,%dl
  800fee:	74 e3                	je     800fd3 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	8a 00                	mov    (%eax),%al
  800ff5:	0f b6 d0             	movzbl %al,%edx
  800ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	0f b6 c0             	movzbl %al,%eax
  801000:	29 c2                	sub    %eax,%edx
  801002:	89 d0                	mov    %edx,%eax
}
  801004:	5d                   	pop    %ebp
  801005:	c3                   	ret    

00801006 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801009:	eb 09                	jmp    801014 <strncmp+0xe>
		n--, p++, q++;
  80100b:	ff 4d 10             	decl   0x10(%ebp)
  80100e:	ff 45 08             	incl   0x8(%ebp)
  801011:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801014:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801018:	74 17                	je     801031 <strncmp+0x2b>
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	84 c0                	test   %al,%al
  801021:	74 0e                	je     801031 <strncmp+0x2b>
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	8a 10                	mov    (%eax),%dl
  801028:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	38 c2                	cmp    %al,%dl
  80102f:	74 da                	je     80100b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801031:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801035:	75 07                	jne    80103e <strncmp+0x38>
		return 0;
  801037:	b8 00 00 00 00       	mov    $0x0,%eax
  80103c:	eb 14                	jmp    801052 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	0f b6 d0             	movzbl %al,%edx
  801046:	8b 45 0c             	mov    0xc(%ebp),%eax
  801049:	8a 00                	mov    (%eax),%al
  80104b:	0f b6 c0             	movzbl %al,%eax
  80104e:	29 c2                	sub    %eax,%edx
  801050:	89 d0                	mov    %edx,%eax
}
  801052:	5d                   	pop    %ebp
  801053:	c3                   	ret    

00801054 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	83 ec 04             	sub    $0x4,%esp
  80105a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801060:	eb 12                	jmp    801074 <strchr+0x20>
		if (*s == c)
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80106a:	75 05                	jne    801071 <strchr+0x1d>
			return (char *) s;
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	eb 11                	jmp    801082 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801071:	ff 45 08             	incl   0x8(%ebp)
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	84 c0                	test   %al,%al
  80107b:	75 e5                	jne    801062 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80107d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801082:	c9                   	leave  
  801083:	c3                   	ret    

00801084 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
  801087:	83 ec 04             	sub    $0x4,%esp
  80108a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801090:	eb 0d                	jmp    80109f <strfind+0x1b>
		if (*s == c)
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	8a 00                	mov    (%eax),%al
  801097:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80109a:	74 0e                	je     8010aa <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80109c:	ff 45 08             	incl   0x8(%ebp)
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	8a 00                	mov    (%eax),%al
  8010a4:	84 c0                	test   %al,%al
  8010a6:	75 ea                	jne    801092 <strfind+0xe>
  8010a8:	eb 01                	jmp    8010ab <strfind+0x27>
		if (*s == c)
			break;
  8010aa:	90                   	nop
	return (char *) s;
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ae:	c9                   	leave  
  8010af:	c3                   	ret    

008010b0 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
  8010b3:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8010bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010c2:	eb 0e                	jmp    8010d2 <memset+0x22>
		*p++ = c;
  8010c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c7:	8d 50 01             	lea    0x1(%eax),%edx
  8010ca:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d0:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010d2:	ff 4d f8             	decl   -0x8(%ebp)
  8010d5:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010d9:	79 e9                	jns    8010c4 <memset+0x14>
		*p++ = c;

	return v;
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010de:	c9                   	leave  
  8010df:	c3                   	ret    

008010e0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010f2:	eb 16                	jmp    80110a <memcpy+0x2a>
		*d++ = *s++;
  8010f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f7:	8d 50 01             	lea    0x1(%eax),%edx
  8010fa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801100:	8d 4a 01             	lea    0x1(%edx),%ecx
  801103:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801106:	8a 12                	mov    (%edx),%dl
  801108:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80110a:	8b 45 10             	mov    0x10(%ebp),%eax
  80110d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801110:	89 55 10             	mov    %edx,0x10(%ebp)
  801113:	85 c0                	test   %eax,%eax
  801115:	75 dd                	jne    8010f4 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80111a:	c9                   	leave  
  80111b:	c3                   	ret    

0080111c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801122:	8b 45 0c             	mov    0xc(%ebp),%eax
  801125:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80112e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801131:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801134:	73 50                	jae    801186 <memmove+0x6a>
  801136:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801139:	8b 45 10             	mov    0x10(%ebp),%eax
  80113c:	01 d0                	add    %edx,%eax
  80113e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801141:	76 43                	jbe    801186 <memmove+0x6a>
		s += n;
  801143:	8b 45 10             	mov    0x10(%ebp),%eax
  801146:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801149:	8b 45 10             	mov    0x10(%ebp),%eax
  80114c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80114f:	eb 10                	jmp    801161 <memmove+0x45>
			*--d = *--s;
  801151:	ff 4d f8             	decl   -0x8(%ebp)
  801154:	ff 4d fc             	decl   -0x4(%ebp)
  801157:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115a:	8a 10                	mov    (%eax),%dl
  80115c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801161:	8b 45 10             	mov    0x10(%ebp),%eax
  801164:	8d 50 ff             	lea    -0x1(%eax),%edx
  801167:	89 55 10             	mov    %edx,0x10(%ebp)
  80116a:	85 c0                	test   %eax,%eax
  80116c:	75 e3                	jne    801151 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80116e:	eb 23                	jmp    801193 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801170:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801173:	8d 50 01             	lea    0x1(%eax),%edx
  801176:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801179:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80117c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80117f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801182:	8a 12                	mov    (%edx),%dl
  801184:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801186:	8b 45 10             	mov    0x10(%ebp),%eax
  801189:	8d 50 ff             	lea    -0x1(%eax),%edx
  80118c:	89 55 10             	mov    %edx,0x10(%ebp)
  80118f:	85 c0                	test   %eax,%eax
  801191:	75 dd                	jne    801170 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801196:	c9                   	leave  
  801197:	c3                   	ret    

00801198 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
  80119b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011aa:	eb 2a                	jmp    8011d6 <memcmp+0x3e>
		if (*s1 != *s2)
  8011ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011af:	8a 10                	mov    (%eax),%dl
  8011b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b4:	8a 00                	mov    (%eax),%al
  8011b6:	38 c2                	cmp    %al,%dl
  8011b8:	74 16                	je     8011d0 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011bd:	8a 00                	mov    (%eax),%al
  8011bf:	0f b6 d0             	movzbl %al,%edx
  8011c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c5:	8a 00                	mov    (%eax),%al
  8011c7:	0f b6 c0             	movzbl %al,%eax
  8011ca:	29 c2                	sub    %eax,%edx
  8011cc:	89 d0                	mov    %edx,%eax
  8011ce:	eb 18                	jmp    8011e8 <memcmp+0x50>
		s1++, s2++;
  8011d0:	ff 45 fc             	incl   -0x4(%ebp)
  8011d3:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011dc:	89 55 10             	mov    %edx,0x10(%ebp)
  8011df:	85 c0                	test   %eax,%eax
  8011e1:	75 c9                	jne    8011ac <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e8:	c9                   	leave  
  8011e9:	c3                   	ret    

008011ea <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
  8011ed:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f6:	01 d0                	add    %edx,%eax
  8011f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011fb:	eb 15                	jmp    801212 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	0f b6 d0             	movzbl %al,%edx
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	0f b6 c0             	movzbl %al,%eax
  80120b:	39 c2                	cmp    %eax,%edx
  80120d:	74 0d                	je     80121c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80120f:	ff 45 08             	incl   0x8(%ebp)
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801218:	72 e3                	jb     8011fd <memfind+0x13>
  80121a:	eb 01                	jmp    80121d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80121c:	90                   	nop
	return (void *) s;
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801220:	c9                   	leave  
  801221:	c3                   	ret    

00801222 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
  801225:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801228:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80122f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801236:	eb 03                	jmp    80123b <strtol+0x19>
		s++;
  801238:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	8a 00                	mov    (%eax),%al
  801240:	3c 20                	cmp    $0x20,%al
  801242:	74 f4                	je     801238 <strtol+0x16>
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	8a 00                	mov    (%eax),%al
  801249:	3c 09                	cmp    $0x9,%al
  80124b:	74 eb                	je     801238 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	3c 2b                	cmp    $0x2b,%al
  801254:	75 05                	jne    80125b <strtol+0x39>
		s++;
  801256:	ff 45 08             	incl   0x8(%ebp)
  801259:	eb 13                	jmp    80126e <strtol+0x4c>
	else if (*s == '-')
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
  80125e:	8a 00                	mov    (%eax),%al
  801260:	3c 2d                	cmp    $0x2d,%al
  801262:	75 0a                	jne    80126e <strtol+0x4c>
		s++, neg = 1;
  801264:	ff 45 08             	incl   0x8(%ebp)
  801267:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80126e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801272:	74 06                	je     80127a <strtol+0x58>
  801274:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801278:	75 20                	jne    80129a <strtol+0x78>
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
  80127d:	8a 00                	mov    (%eax),%al
  80127f:	3c 30                	cmp    $0x30,%al
  801281:	75 17                	jne    80129a <strtol+0x78>
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	40                   	inc    %eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	3c 78                	cmp    $0x78,%al
  80128b:	75 0d                	jne    80129a <strtol+0x78>
		s += 2, base = 16;
  80128d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801291:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801298:	eb 28                	jmp    8012c2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80129a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80129e:	75 15                	jne    8012b5 <strtol+0x93>
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	3c 30                	cmp    $0x30,%al
  8012a7:	75 0c                	jne    8012b5 <strtol+0x93>
		s++, base = 8;
  8012a9:	ff 45 08             	incl   0x8(%ebp)
  8012ac:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012b3:	eb 0d                	jmp    8012c2 <strtol+0xa0>
	else if (base == 0)
  8012b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b9:	75 07                	jne    8012c2 <strtol+0xa0>
		base = 10;
  8012bb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	8a 00                	mov    (%eax),%al
  8012c7:	3c 2f                	cmp    $0x2f,%al
  8012c9:	7e 19                	jle    8012e4 <strtol+0xc2>
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	8a 00                	mov    (%eax),%al
  8012d0:	3c 39                	cmp    $0x39,%al
  8012d2:	7f 10                	jg     8012e4 <strtol+0xc2>
			dig = *s - '0';
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	8a 00                	mov    (%eax),%al
  8012d9:	0f be c0             	movsbl %al,%eax
  8012dc:	83 e8 30             	sub    $0x30,%eax
  8012df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012e2:	eb 42                	jmp    801326 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	8a 00                	mov    (%eax),%al
  8012e9:	3c 60                	cmp    $0x60,%al
  8012eb:	7e 19                	jle    801306 <strtol+0xe4>
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	8a 00                	mov    (%eax),%al
  8012f2:	3c 7a                	cmp    $0x7a,%al
  8012f4:	7f 10                	jg     801306 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f9:	8a 00                	mov    (%eax),%al
  8012fb:	0f be c0             	movsbl %al,%eax
  8012fe:	83 e8 57             	sub    $0x57,%eax
  801301:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801304:	eb 20                	jmp    801326 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	3c 40                	cmp    $0x40,%al
  80130d:	7e 39                	jle    801348 <strtol+0x126>
  80130f:	8b 45 08             	mov    0x8(%ebp),%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	3c 5a                	cmp    $0x5a,%al
  801316:	7f 30                	jg     801348 <strtol+0x126>
			dig = *s - 'A' + 10;
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
  80131b:	8a 00                	mov    (%eax),%al
  80131d:	0f be c0             	movsbl %al,%eax
  801320:	83 e8 37             	sub    $0x37,%eax
  801323:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801329:	3b 45 10             	cmp    0x10(%ebp),%eax
  80132c:	7d 19                	jge    801347 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80132e:	ff 45 08             	incl   0x8(%ebp)
  801331:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801334:	0f af 45 10          	imul   0x10(%ebp),%eax
  801338:	89 c2                	mov    %eax,%edx
  80133a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133d:	01 d0                	add    %edx,%eax
  80133f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801342:	e9 7b ff ff ff       	jmp    8012c2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801347:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801348:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80134c:	74 08                	je     801356 <strtol+0x134>
		*endptr = (char *) s;
  80134e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801351:	8b 55 08             	mov    0x8(%ebp),%edx
  801354:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801356:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80135a:	74 07                	je     801363 <strtol+0x141>
  80135c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135f:	f7 d8                	neg    %eax
  801361:	eb 03                	jmp    801366 <strtol+0x144>
  801363:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801366:	c9                   	leave  
  801367:	c3                   	ret    

00801368 <ltostr>:

void
ltostr(long value, char *str)
{
  801368:	55                   	push   %ebp
  801369:	89 e5                	mov    %esp,%ebp
  80136b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80136e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801375:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80137c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801380:	79 13                	jns    801395 <ltostr+0x2d>
	{
		neg = 1;
  801382:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801389:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80138f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801392:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80139d:	99                   	cltd   
  80139e:	f7 f9                	idiv   %ecx
  8013a0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a6:	8d 50 01             	lea    0x1(%eax),%edx
  8013a9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013ac:	89 c2                	mov    %eax,%edx
  8013ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b1:	01 d0                	add    %edx,%eax
  8013b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013b6:	83 c2 30             	add    $0x30,%edx
  8013b9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013be:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013c3:	f7 e9                	imul   %ecx
  8013c5:	c1 fa 02             	sar    $0x2,%edx
  8013c8:	89 c8                	mov    %ecx,%eax
  8013ca:	c1 f8 1f             	sar    $0x1f,%eax
  8013cd:	29 c2                	sub    %eax,%edx
  8013cf:	89 d0                	mov    %edx,%eax
  8013d1:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013d8:	75 bb                	jne    801395 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e4:	48                   	dec    %eax
  8013e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013ec:	74 3d                	je     80142b <ltostr+0xc3>
		start = 1 ;
  8013ee:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013f5:	eb 34                	jmp    80142b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fd:	01 d0                	add    %edx,%eax
  8013ff:	8a 00                	mov    (%eax),%al
  801401:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801404:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801407:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140a:	01 c2                	add    %eax,%edx
  80140c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80140f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801412:	01 c8                	add    %ecx,%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801418:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80141b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141e:	01 c2                	add    %eax,%edx
  801420:	8a 45 eb             	mov    -0x15(%ebp),%al
  801423:	88 02                	mov    %al,(%edx)
		start++ ;
  801425:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801428:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80142b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801431:	7c c4                	jl     8013f7 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801433:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801436:	8b 45 0c             	mov    0xc(%ebp),%eax
  801439:	01 d0                	add    %edx,%eax
  80143b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80143e:	90                   	nop
  80143f:	c9                   	leave  
  801440:	c3                   	ret    

00801441 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801441:	55                   	push   %ebp
  801442:	89 e5                	mov    %esp,%ebp
  801444:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801447:	ff 75 08             	pushl  0x8(%ebp)
  80144a:	e8 73 fa ff ff       	call   800ec2 <strlen>
  80144f:	83 c4 04             	add    $0x4,%esp
  801452:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801455:	ff 75 0c             	pushl  0xc(%ebp)
  801458:	e8 65 fa ff ff       	call   800ec2 <strlen>
  80145d:	83 c4 04             	add    $0x4,%esp
  801460:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801463:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80146a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801471:	eb 17                	jmp    80148a <strcconcat+0x49>
		final[s] = str1[s] ;
  801473:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801476:	8b 45 10             	mov    0x10(%ebp),%eax
  801479:	01 c2                	add    %eax,%edx
  80147b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	01 c8                	add    %ecx,%eax
  801483:	8a 00                	mov    (%eax),%al
  801485:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801487:	ff 45 fc             	incl   -0x4(%ebp)
  80148a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80148d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801490:	7c e1                	jl     801473 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801492:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801499:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014a0:	eb 1f                	jmp    8014c1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a5:	8d 50 01             	lea    0x1(%eax),%edx
  8014a8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014ab:	89 c2                	mov    %eax,%edx
  8014ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b0:	01 c2                	add    %eax,%edx
  8014b2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b8:	01 c8                	add    %ecx,%eax
  8014ba:	8a 00                	mov    (%eax),%al
  8014bc:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014be:	ff 45 f8             	incl   -0x8(%ebp)
  8014c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014c7:	7c d9                	jl     8014a2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cf:	01 d0                	add    %edx,%eax
  8014d1:	c6 00 00             	movb   $0x0,(%eax)
}
  8014d4:	90                   	nop
  8014d5:	c9                   	leave  
  8014d6:	c3                   	ret    

008014d7 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014da:	8b 45 14             	mov    0x14(%ebp),%eax
  8014dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e6:	8b 00                	mov    (%eax),%eax
  8014e8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f2:	01 d0                	add    %edx,%eax
  8014f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014fa:	eb 0c                	jmp    801508 <strsplit+0x31>
			*string++ = 0;
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	8d 50 01             	lea    0x1(%eax),%edx
  801502:	89 55 08             	mov    %edx,0x8(%ebp)
  801505:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801508:	8b 45 08             	mov    0x8(%ebp),%eax
  80150b:	8a 00                	mov    (%eax),%al
  80150d:	84 c0                	test   %al,%al
  80150f:	74 18                	je     801529 <strsplit+0x52>
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
  801514:	8a 00                	mov    (%eax),%al
  801516:	0f be c0             	movsbl %al,%eax
  801519:	50                   	push   %eax
  80151a:	ff 75 0c             	pushl  0xc(%ebp)
  80151d:	e8 32 fb ff ff       	call   801054 <strchr>
  801522:	83 c4 08             	add    $0x8,%esp
  801525:	85 c0                	test   %eax,%eax
  801527:	75 d3                	jne    8014fc <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801529:	8b 45 08             	mov    0x8(%ebp),%eax
  80152c:	8a 00                	mov    (%eax),%al
  80152e:	84 c0                	test   %al,%al
  801530:	74 5a                	je     80158c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801532:	8b 45 14             	mov    0x14(%ebp),%eax
  801535:	8b 00                	mov    (%eax),%eax
  801537:	83 f8 0f             	cmp    $0xf,%eax
  80153a:	75 07                	jne    801543 <strsplit+0x6c>
		{
			return 0;
  80153c:	b8 00 00 00 00       	mov    $0x0,%eax
  801541:	eb 66                	jmp    8015a9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801543:	8b 45 14             	mov    0x14(%ebp),%eax
  801546:	8b 00                	mov    (%eax),%eax
  801548:	8d 48 01             	lea    0x1(%eax),%ecx
  80154b:	8b 55 14             	mov    0x14(%ebp),%edx
  80154e:	89 0a                	mov    %ecx,(%edx)
  801550:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801557:	8b 45 10             	mov    0x10(%ebp),%eax
  80155a:	01 c2                	add    %eax,%edx
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
  80155f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801561:	eb 03                	jmp    801566 <strsplit+0x8f>
			string++;
  801563:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	8a 00                	mov    (%eax),%al
  80156b:	84 c0                	test   %al,%al
  80156d:	74 8b                	je     8014fa <strsplit+0x23>
  80156f:	8b 45 08             	mov    0x8(%ebp),%eax
  801572:	8a 00                	mov    (%eax),%al
  801574:	0f be c0             	movsbl %al,%eax
  801577:	50                   	push   %eax
  801578:	ff 75 0c             	pushl  0xc(%ebp)
  80157b:	e8 d4 fa ff ff       	call   801054 <strchr>
  801580:	83 c4 08             	add    $0x8,%esp
  801583:	85 c0                	test   %eax,%eax
  801585:	74 dc                	je     801563 <strsplit+0x8c>
			string++;
	}
  801587:	e9 6e ff ff ff       	jmp    8014fa <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80158c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80158d:	8b 45 14             	mov    0x14(%ebp),%eax
  801590:	8b 00                	mov    (%eax),%eax
  801592:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801599:	8b 45 10             	mov    0x10(%ebp),%eax
  80159c:	01 d0                	add    %edx,%eax
  80159e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015a4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8015b1:	83 ec 04             	sub    $0x4,%esp
  8015b4:	68 68 27 80 00       	push   $0x802768
  8015b9:	68 3f 01 00 00       	push   $0x13f
  8015be:	68 8a 27 80 00       	push   $0x80278a
  8015c3:	e8 a9 ef ff ff       	call   800571 <_panic>

008015c8 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
  8015cb:	57                   	push   %edi
  8015cc:	56                   	push   %esi
  8015cd:	53                   	push   %ebx
  8015ce:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015dd:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015e0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015e3:	cd 30                	int    $0x30
  8015e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  8015e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015eb:	83 c4 10             	add    $0x10,%esp
  8015ee:	5b                   	pop    %ebx
  8015ef:	5e                   	pop    %esi
  8015f0:	5f                   	pop    %edi
  8015f1:	5d                   	pop    %ebp
  8015f2:	c3                   	ret    

008015f3 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
  8015f6:	83 ec 04             	sub    $0x4,%esp
  8015f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8015ff:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	52                   	push   %edx
  80160b:	ff 75 0c             	pushl  0xc(%ebp)
  80160e:	50                   	push   %eax
  80160f:	6a 00                	push   $0x0
  801611:	e8 b2 ff ff ff       	call   8015c8 <syscall>
  801616:	83 c4 18             	add    $0x18,%esp
}
  801619:	90                   	nop
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <sys_cgetc>:

int sys_cgetc(void) {
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 02                	push   $0x2
  80162b:	e8 98 ff ff ff       	call   8015c8 <syscall>
  801630:	83 c4 18             	add    $0x18,%esp
}
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <sys_lock_cons>:

void sys_lock_cons(void) {
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 03                	push   $0x3
  801644:	e8 7f ff ff ff       	call   8015c8 <syscall>
  801649:	83 c4 18             	add    $0x18,%esp
}
  80164c:	90                   	nop
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <sys_unlock_cons>:
void sys_unlock_cons(void) {
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 04                	push   $0x4
  80165e:	e8 65 ff ff ff       	call   8015c8 <syscall>
  801663:	83 c4 18             	add    $0x18,%esp
}
  801666:	90                   	nop
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  80166c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	52                   	push   %edx
  801679:	50                   	push   %eax
  80167a:	6a 08                	push   $0x8
  80167c:	e8 47 ff ff ff       	call   8015c8 <syscall>
  801681:	83 c4 18             	add    $0x18,%esp
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	56                   	push   %esi
  80168a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  80168b:	8b 75 18             	mov    0x18(%ebp),%esi
  80168e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801691:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801694:	8b 55 0c             	mov    0xc(%ebp),%edx
  801697:	8b 45 08             	mov    0x8(%ebp),%eax
  80169a:	56                   	push   %esi
  80169b:	53                   	push   %ebx
  80169c:	51                   	push   %ecx
  80169d:	52                   	push   %edx
  80169e:	50                   	push   %eax
  80169f:	6a 09                	push   $0x9
  8016a1:	e8 22 ff ff ff       	call   8015c8 <syscall>
  8016a6:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  8016a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016ac:	5b                   	pop    %ebx
  8016ad:	5e                   	pop    %esi
  8016ae:	5d                   	pop    %ebp
  8016af:	c3                   	ret    

008016b0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	52                   	push   %edx
  8016c0:	50                   	push   %eax
  8016c1:	6a 0a                	push   $0xa
  8016c3:	e8 00 ff ff ff       	call   8015c8 <syscall>
  8016c8:	83 c4 18             	add    $0x18,%esp
}
  8016cb:	c9                   	leave  
  8016cc:	c3                   	ret    

008016cd <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	ff 75 0c             	pushl  0xc(%ebp)
  8016d9:	ff 75 08             	pushl  0x8(%ebp)
  8016dc:	6a 0b                	push   $0xb
  8016de:	e8 e5 fe ff ff       	call   8015c8 <syscall>
  8016e3:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 0c                	push   $0xc
  8016f7:	e8 cc fe ff ff       	call   8015c8 <syscall>
  8016fc:	83 c4 18             	add    $0x18,%esp
}
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 0d                	push   $0xd
  801710:	e8 b3 fe ff ff       	call   8015c8 <syscall>
  801715:	83 c4 18             	add    $0x18,%esp
}
  801718:	c9                   	leave  
  801719:	c3                   	ret    

0080171a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  80171a:	55                   	push   %ebp
  80171b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 0e                	push   $0xe
  801729:	e8 9a fe ff ff       	call   8015c8 <syscall>
  80172e:	83 c4 18             	add    $0x18,%esp
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 0f                	push   $0xf
  801742:	e8 81 fe ff ff       	call   8015c8 <syscall>
  801747:	83 c4 18             	add    $0x18,%esp
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	ff 75 08             	pushl  0x8(%ebp)
  80175a:	6a 10                	push   $0x10
  80175c:	e8 67 fe ff ff       	call   8015c8 <syscall>
  801761:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <sys_scarce_memory>:

void sys_scarce_memory() {
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 11                	push   $0x11
  801775:	e8 4e fe ff ff       	call   8015c8 <syscall>
  80177a:	83 c4 18             	add    $0x18,%esp
}
  80177d:	90                   	nop
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <sys_cputc>:

void sys_cputc(const char c) {
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	83 ec 04             	sub    $0x4,%esp
  801786:	8b 45 08             	mov    0x8(%ebp),%eax
  801789:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80178c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	50                   	push   %eax
  801799:	6a 01                	push   $0x1
  80179b:	e8 28 fe ff ff       	call   8015c8 <syscall>
  8017a0:	83 c4 18             	add    $0x18,%esp
}
  8017a3:	90                   	nop
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 14                	push   $0x14
  8017b5:	e8 0e fe ff ff       	call   8015c8 <syscall>
  8017ba:	83 c4 18             	add    $0x18,%esp
}
  8017bd:	90                   	nop
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 04             	sub    $0x4,%esp
  8017c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  8017cc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017cf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d6:	6a 00                	push   $0x0
  8017d8:	51                   	push   %ecx
  8017d9:	52                   	push   %edx
  8017da:	ff 75 0c             	pushl  0xc(%ebp)
  8017dd:	50                   	push   %eax
  8017de:	6a 15                	push   $0x15
  8017e0:	e8 e3 fd ff ff       	call   8015c8 <syscall>
  8017e5:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  8017ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	52                   	push   %edx
  8017fa:	50                   	push   %eax
  8017fb:	6a 16                	push   $0x16
  8017fd:	e8 c6 fd ff ff       	call   8015c8 <syscall>
  801802:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  80180a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80180d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	51                   	push   %ecx
  801818:	52                   	push   %edx
  801819:	50                   	push   %eax
  80181a:	6a 17                	push   $0x17
  80181c:	e8 a7 fd ff ff       	call   8015c8 <syscall>
  801821:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801829:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182c:	8b 45 08             	mov    0x8(%ebp),%eax
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	52                   	push   %edx
  801836:	50                   	push   %eax
  801837:	6a 18                	push   $0x18
  801839:	e8 8a fd ff ff       	call   8015c8 <syscall>
  80183e:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	6a 00                	push   $0x0
  80184b:	ff 75 14             	pushl  0x14(%ebp)
  80184e:	ff 75 10             	pushl  0x10(%ebp)
  801851:	ff 75 0c             	pushl  0xc(%ebp)
  801854:	50                   	push   %eax
  801855:	6a 19                	push   $0x19
  801857:	e8 6c fd ff ff       	call   8015c8 <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sys_run_env>:

void sys_run_env(int32 envId) {
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801864:	8b 45 08             	mov    0x8(%ebp),%eax
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	50                   	push   %eax
  801870:	6a 1a                	push   $0x1a
  801872:	e8 51 fd ff ff       	call   8015c8 <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
}
  80187a:	90                   	nop
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801880:	8b 45 08             	mov    0x8(%ebp),%eax
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	50                   	push   %eax
  80188c:	6a 1b                	push   $0x1b
  80188e:	e8 35 fd ff ff       	call   8015c8 <syscall>
  801893:	83 c4 18             	add    $0x18,%esp
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <sys_getenvid>:

int32 sys_getenvid(void) {
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 05                	push   $0x5
  8018a7:	e8 1c fd ff ff       	call   8015c8 <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
}
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 06                	push   $0x6
  8018c0:	e8 03 fd ff ff       	call   8015c8 <syscall>
  8018c5:	83 c4 18             	add    $0x18,%esp
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 07                	push   $0x7
  8018d9:	e8 ea fc ff ff       	call   8015c8 <syscall>
  8018de:	83 c4 18             	add    $0x18,%esp
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <sys_exit_env>:

void sys_exit_env(void) {
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 1c                	push   $0x1c
  8018f2:	e8 d1 fc ff ff       	call   8015c8 <syscall>
  8018f7:	83 c4 18             	add    $0x18,%esp
}
  8018fa:	90                   	nop
  8018fb:	c9                   	leave  
  8018fc:	c3                   	ret    

008018fd <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
  801900:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801903:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801906:	8d 50 04             	lea    0x4(%eax),%edx
  801909:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	52                   	push   %edx
  801913:	50                   	push   %eax
  801914:	6a 1d                	push   $0x1d
  801916:	e8 ad fc ff ff       	call   8015c8 <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  80191e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801921:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801924:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801927:	89 01                	mov    %eax,(%ecx)
  801929:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80192c:	8b 45 08             	mov    0x8(%ebp),%eax
  80192f:	c9                   	leave  
  801930:	c2 04 00             	ret    $0x4

00801933 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	ff 75 10             	pushl  0x10(%ebp)
  80193d:	ff 75 0c             	pushl  0xc(%ebp)
  801940:	ff 75 08             	pushl  0x8(%ebp)
  801943:	6a 13                	push   $0x13
  801945:	e8 7e fc ff ff       	call   8015c8 <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  80194d:	90                   	nop
}
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <sys_rcr2>:
uint32 sys_rcr2() {
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 1e                	push   $0x1e
  80195f:	e8 64 fc ff ff       	call   8015c8 <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	83 ec 04             	sub    $0x4,%esp
  80196f:	8b 45 08             	mov    0x8(%ebp),%eax
  801972:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801975:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	50                   	push   %eax
  801982:	6a 1f                	push   $0x1f
  801984:	e8 3f fc ff ff       	call   8015c8 <syscall>
  801989:	83 c4 18             	add    $0x18,%esp
	return;
  80198c:	90                   	nop
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <rsttst>:
void rsttst() {
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 21                	push   $0x21
  80199e:	e8 25 fc ff ff       	call   8015c8 <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
	return;
  8019a6:	90                   	nop
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	83 ec 04             	sub    $0x4,%esp
  8019af:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019b5:	8b 55 18             	mov    0x18(%ebp),%edx
  8019b8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019bc:	52                   	push   %edx
  8019bd:	50                   	push   %eax
  8019be:	ff 75 10             	pushl  0x10(%ebp)
  8019c1:	ff 75 0c             	pushl  0xc(%ebp)
  8019c4:	ff 75 08             	pushl  0x8(%ebp)
  8019c7:	6a 20                	push   $0x20
  8019c9:	e8 fa fb ff ff       	call   8015c8 <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
	return;
  8019d1:	90                   	nop
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <chktst>:
void chktst(uint32 n) {
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	ff 75 08             	pushl  0x8(%ebp)
  8019e2:	6a 22                	push   $0x22
  8019e4:	e8 df fb ff ff       	call   8015c8 <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
	return;
  8019ec:	90                   	nop
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <inctst>:

void inctst() {
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 23                	push   $0x23
  8019fe:	e8 c5 fb ff ff       	call   8015c8 <syscall>
  801a03:	83 c4 18             	add    $0x18,%esp
	return;
  801a06:	90                   	nop
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <gettst>:
uint32 gettst() {
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 24                	push   $0x24
  801a18:	e8 ab fb ff ff       	call   8015c8 <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
}
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
  801a25:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 25                	push   $0x25
  801a34:	e8 8f fb ff ff       	call   8015c8 <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
  801a3c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a3f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a43:	75 07                	jne    801a4c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a45:	b8 01 00 00 00       	mov    $0x1,%eax
  801a4a:	eb 05                	jmp    801a51 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
  801a56:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 25                	push   $0x25
  801a65:	e8 5e fb ff ff       	call   8015c8 <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
  801a6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a70:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a74:	75 07                	jne    801a7d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a76:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7b:	eb 05                	jmp    801a82 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
  801a87:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 25                	push   $0x25
  801a96:	e8 2d fb ff ff       	call   8015c8 <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
  801a9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801aa1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801aa5:	75 07                	jne    801aae <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801aa7:	b8 01 00 00 00       	mov    $0x1,%eax
  801aac:	eb 05                	jmp    801ab3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801aae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
  801ab8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 25                	push   $0x25
  801ac7:	e8 fc fa ff ff       	call   8015c8 <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
  801acf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ad2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ad6:	75 07                	jne    801adf <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ad8:	b8 01 00 00 00       	mov    $0x1,%eax
  801add:	eb 05                	jmp    801ae4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801adf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	ff 75 08             	pushl  0x8(%ebp)
  801af4:	6a 26                	push   $0x26
  801af6:	e8 cd fa ff ff       	call   8015c8 <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
	return;
  801afe:	90                   	nop
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801b05:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b08:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b11:	6a 00                	push   $0x0
  801b13:	53                   	push   %ebx
  801b14:	51                   	push   %ecx
  801b15:	52                   	push   %edx
  801b16:	50                   	push   %eax
  801b17:	6a 27                	push   $0x27
  801b19:	e8 aa fa ff ff       	call   8015c8 <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801b21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	52                   	push   %edx
  801b36:	50                   	push   %eax
  801b37:	6a 28                	push   $0x28
  801b39:	e8 8a fa ff ff       	call   8015c8 <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801b46:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	6a 00                	push   $0x0
  801b51:	51                   	push   %ecx
  801b52:	ff 75 10             	pushl  0x10(%ebp)
  801b55:	52                   	push   %edx
  801b56:	50                   	push   %eax
  801b57:	6a 29                	push   $0x29
  801b59:	e8 6a fa ff ff       	call   8015c8 <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	ff 75 10             	pushl  0x10(%ebp)
  801b6d:	ff 75 0c             	pushl  0xc(%ebp)
  801b70:	ff 75 08             	pushl  0x8(%ebp)
  801b73:	6a 12                	push   $0x12
  801b75:	e8 4e fa ff ff       	call   8015c8 <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
	return;
  801b7d:	90                   	nop
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801b83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	52                   	push   %edx
  801b90:	50                   	push   %eax
  801b91:	6a 2a                	push   $0x2a
  801b93:	e8 30 fa ff ff       	call   8015c8 <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
	return;
  801b9b:	90                   	nop
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	50                   	push   %eax
  801bad:	6a 2b                	push   $0x2b
  801baf:	e8 14 fa ff ff       	call   8015c8 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	ff 75 0c             	pushl  0xc(%ebp)
  801bc5:	ff 75 08             	pushl  0x8(%ebp)
  801bc8:	6a 2c                	push   $0x2c
  801bca:	e8 f9 f9 ff ff       	call   8015c8 <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
	return;
  801bd2:	90                   	nop
}
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	ff 75 0c             	pushl  0xc(%ebp)
  801be1:	ff 75 08             	pushl  0x8(%ebp)
  801be4:	6a 2d                	push   $0x2d
  801be6:	e8 dd f9 ff ff       	call   8015c8 <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
	return;
  801bee:	90                   	nop
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	50                   	push   %eax
  801c00:	6a 2f                	push   $0x2f
  801c02:	e8 c1 f9 ff ff       	call   8015c8 <syscall>
  801c07:	83 c4 18             	add    $0x18,%esp
	return;
  801c0a:	90                   	nop
}
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  801c10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c13:	8b 45 08             	mov    0x8(%ebp),%eax
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	52                   	push   %edx
  801c1d:	50                   	push   %eax
  801c1e:	6a 30                	push   $0x30
  801c20:	e8 a3 f9 ff ff       	call   8015c8 <syscall>
  801c25:	83 c4 18             	add    $0x18,%esp
	return;
  801c28:	90                   	nop
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  801c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	50                   	push   %eax
  801c3a:	6a 31                	push   $0x31
  801c3c:	e8 87 f9 ff ff       	call   8015c8 <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
	return;
  801c44:	90                   	nop
}
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801c4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	52                   	push   %edx
  801c57:	50                   	push   %eax
  801c58:	6a 2e                	push   $0x2e
  801c5a:	e8 69 f9 ff ff       	call   8015c8 <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
    return;
  801c62:	90                   	nop
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    
  801c65:	66 90                	xchg   %ax,%ax
  801c67:	90                   	nop

00801c68 <__udivdi3>:
  801c68:	55                   	push   %ebp
  801c69:	57                   	push   %edi
  801c6a:	56                   	push   %esi
  801c6b:	53                   	push   %ebx
  801c6c:	83 ec 1c             	sub    $0x1c,%esp
  801c6f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c73:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c7b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c7f:	89 ca                	mov    %ecx,%edx
  801c81:	89 f8                	mov    %edi,%eax
  801c83:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c87:	85 f6                	test   %esi,%esi
  801c89:	75 2d                	jne    801cb8 <__udivdi3+0x50>
  801c8b:	39 cf                	cmp    %ecx,%edi
  801c8d:	77 65                	ja     801cf4 <__udivdi3+0x8c>
  801c8f:	89 fd                	mov    %edi,%ebp
  801c91:	85 ff                	test   %edi,%edi
  801c93:	75 0b                	jne    801ca0 <__udivdi3+0x38>
  801c95:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9a:	31 d2                	xor    %edx,%edx
  801c9c:	f7 f7                	div    %edi
  801c9e:	89 c5                	mov    %eax,%ebp
  801ca0:	31 d2                	xor    %edx,%edx
  801ca2:	89 c8                	mov    %ecx,%eax
  801ca4:	f7 f5                	div    %ebp
  801ca6:	89 c1                	mov    %eax,%ecx
  801ca8:	89 d8                	mov    %ebx,%eax
  801caa:	f7 f5                	div    %ebp
  801cac:	89 cf                	mov    %ecx,%edi
  801cae:	89 fa                	mov    %edi,%edx
  801cb0:	83 c4 1c             	add    $0x1c,%esp
  801cb3:	5b                   	pop    %ebx
  801cb4:	5e                   	pop    %esi
  801cb5:	5f                   	pop    %edi
  801cb6:	5d                   	pop    %ebp
  801cb7:	c3                   	ret    
  801cb8:	39 ce                	cmp    %ecx,%esi
  801cba:	77 28                	ja     801ce4 <__udivdi3+0x7c>
  801cbc:	0f bd fe             	bsr    %esi,%edi
  801cbf:	83 f7 1f             	xor    $0x1f,%edi
  801cc2:	75 40                	jne    801d04 <__udivdi3+0x9c>
  801cc4:	39 ce                	cmp    %ecx,%esi
  801cc6:	72 0a                	jb     801cd2 <__udivdi3+0x6a>
  801cc8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ccc:	0f 87 9e 00 00 00    	ja     801d70 <__udivdi3+0x108>
  801cd2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd7:	89 fa                	mov    %edi,%edx
  801cd9:	83 c4 1c             	add    $0x1c,%esp
  801cdc:	5b                   	pop    %ebx
  801cdd:	5e                   	pop    %esi
  801cde:	5f                   	pop    %edi
  801cdf:	5d                   	pop    %ebp
  801ce0:	c3                   	ret    
  801ce1:	8d 76 00             	lea    0x0(%esi),%esi
  801ce4:	31 ff                	xor    %edi,%edi
  801ce6:	31 c0                	xor    %eax,%eax
  801ce8:	89 fa                	mov    %edi,%edx
  801cea:	83 c4 1c             	add    $0x1c,%esp
  801ced:	5b                   	pop    %ebx
  801cee:	5e                   	pop    %esi
  801cef:	5f                   	pop    %edi
  801cf0:	5d                   	pop    %ebp
  801cf1:	c3                   	ret    
  801cf2:	66 90                	xchg   %ax,%ax
  801cf4:	89 d8                	mov    %ebx,%eax
  801cf6:	f7 f7                	div    %edi
  801cf8:	31 ff                	xor    %edi,%edi
  801cfa:	89 fa                	mov    %edi,%edx
  801cfc:	83 c4 1c             	add    $0x1c,%esp
  801cff:	5b                   	pop    %ebx
  801d00:	5e                   	pop    %esi
  801d01:	5f                   	pop    %edi
  801d02:	5d                   	pop    %ebp
  801d03:	c3                   	ret    
  801d04:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d09:	89 eb                	mov    %ebp,%ebx
  801d0b:	29 fb                	sub    %edi,%ebx
  801d0d:	89 f9                	mov    %edi,%ecx
  801d0f:	d3 e6                	shl    %cl,%esi
  801d11:	89 c5                	mov    %eax,%ebp
  801d13:	88 d9                	mov    %bl,%cl
  801d15:	d3 ed                	shr    %cl,%ebp
  801d17:	89 e9                	mov    %ebp,%ecx
  801d19:	09 f1                	or     %esi,%ecx
  801d1b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d1f:	89 f9                	mov    %edi,%ecx
  801d21:	d3 e0                	shl    %cl,%eax
  801d23:	89 c5                	mov    %eax,%ebp
  801d25:	89 d6                	mov    %edx,%esi
  801d27:	88 d9                	mov    %bl,%cl
  801d29:	d3 ee                	shr    %cl,%esi
  801d2b:	89 f9                	mov    %edi,%ecx
  801d2d:	d3 e2                	shl    %cl,%edx
  801d2f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d33:	88 d9                	mov    %bl,%cl
  801d35:	d3 e8                	shr    %cl,%eax
  801d37:	09 c2                	or     %eax,%edx
  801d39:	89 d0                	mov    %edx,%eax
  801d3b:	89 f2                	mov    %esi,%edx
  801d3d:	f7 74 24 0c          	divl   0xc(%esp)
  801d41:	89 d6                	mov    %edx,%esi
  801d43:	89 c3                	mov    %eax,%ebx
  801d45:	f7 e5                	mul    %ebp
  801d47:	39 d6                	cmp    %edx,%esi
  801d49:	72 19                	jb     801d64 <__udivdi3+0xfc>
  801d4b:	74 0b                	je     801d58 <__udivdi3+0xf0>
  801d4d:	89 d8                	mov    %ebx,%eax
  801d4f:	31 ff                	xor    %edi,%edi
  801d51:	e9 58 ff ff ff       	jmp    801cae <__udivdi3+0x46>
  801d56:	66 90                	xchg   %ax,%ax
  801d58:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d5c:	89 f9                	mov    %edi,%ecx
  801d5e:	d3 e2                	shl    %cl,%edx
  801d60:	39 c2                	cmp    %eax,%edx
  801d62:	73 e9                	jae    801d4d <__udivdi3+0xe5>
  801d64:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d67:	31 ff                	xor    %edi,%edi
  801d69:	e9 40 ff ff ff       	jmp    801cae <__udivdi3+0x46>
  801d6e:	66 90                	xchg   %ax,%ax
  801d70:	31 c0                	xor    %eax,%eax
  801d72:	e9 37 ff ff ff       	jmp    801cae <__udivdi3+0x46>
  801d77:	90                   	nop

00801d78 <__umoddi3>:
  801d78:	55                   	push   %ebp
  801d79:	57                   	push   %edi
  801d7a:	56                   	push   %esi
  801d7b:	53                   	push   %ebx
  801d7c:	83 ec 1c             	sub    $0x1c,%esp
  801d7f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d83:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d93:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d97:	89 f3                	mov    %esi,%ebx
  801d99:	89 fa                	mov    %edi,%edx
  801d9b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d9f:	89 34 24             	mov    %esi,(%esp)
  801da2:	85 c0                	test   %eax,%eax
  801da4:	75 1a                	jne    801dc0 <__umoddi3+0x48>
  801da6:	39 f7                	cmp    %esi,%edi
  801da8:	0f 86 a2 00 00 00    	jbe    801e50 <__umoddi3+0xd8>
  801dae:	89 c8                	mov    %ecx,%eax
  801db0:	89 f2                	mov    %esi,%edx
  801db2:	f7 f7                	div    %edi
  801db4:	89 d0                	mov    %edx,%eax
  801db6:	31 d2                	xor    %edx,%edx
  801db8:	83 c4 1c             	add    $0x1c,%esp
  801dbb:	5b                   	pop    %ebx
  801dbc:	5e                   	pop    %esi
  801dbd:	5f                   	pop    %edi
  801dbe:	5d                   	pop    %ebp
  801dbf:	c3                   	ret    
  801dc0:	39 f0                	cmp    %esi,%eax
  801dc2:	0f 87 ac 00 00 00    	ja     801e74 <__umoddi3+0xfc>
  801dc8:	0f bd e8             	bsr    %eax,%ebp
  801dcb:	83 f5 1f             	xor    $0x1f,%ebp
  801dce:	0f 84 ac 00 00 00    	je     801e80 <__umoddi3+0x108>
  801dd4:	bf 20 00 00 00       	mov    $0x20,%edi
  801dd9:	29 ef                	sub    %ebp,%edi
  801ddb:	89 fe                	mov    %edi,%esi
  801ddd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801de1:	89 e9                	mov    %ebp,%ecx
  801de3:	d3 e0                	shl    %cl,%eax
  801de5:	89 d7                	mov    %edx,%edi
  801de7:	89 f1                	mov    %esi,%ecx
  801de9:	d3 ef                	shr    %cl,%edi
  801deb:	09 c7                	or     %eax,%edi
  801ded:	89 e9                	mov    %ebp,%ecx
  801def:	d3 e2                	shl    %cl,%edx
  801df1:	89 14 24             	mov    %edx,(%esp)
  801df4:	89 d8                	mov    %ebx,%eax
  801df6:	d3 e0                	shl    %cl,%eax
  801df8:	89 c2                	mov    %eax,%edx
  801dfa:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dfe:	d3 e0                	shl    %cl,%eax
  801e00:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e04:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e08:	89 f1                	mov    %esi,%ecx
  801e0a:	d3 e8                	shr    %cl,%eax
  801e0c:	09 d0                	or     %edx,%eax
  801e0e:	d3 eb                	shr    %cl,%ebx
  801e10:	89 da                	mov    %ebx,%edx
  801e12:	f7 f7                	div    %edi
  801e14:	89 d3                	mov    %edx,%ebx
  801e16:	f7 24 24             	mull   (%esp)
  801e19:	89 c6                	mov    %eax,%esi
  801e1b:	89 d1                	mov    %edx,%ecx
  801e1d:	39 d3                	cmp    %edx,%ebx
  801e1f:	0f 82 87 00 00 00    	jb     801eac <__umoddi3+0x134>
  801e25:	0f 84 91 00 00 00    	je     801ebc <__umoddi3+0x144>
  801e2b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e2f:	29 f2                	sub    %esi,%edx
  801e31:	19 cb                	sbb    %ecx,%ebx
  801e33:	89 d8                	mov    %ebx,%eax
  801e35:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e39:	d3 e0                	shl    %cl,%eax
  801e3b:	89 e9                	mov    %ebp,%ecx
  801e3d:	d3 ea                	shr    %cl,%edx
  801e3f:	09 d0                	or     %edx,%eax
  801e41:	89 e9                	mov    %ebp,%ecx
  801e43:	d3 eb                	shr    %cl,%ebx
  801e45:	89 da                	mov    %ebx,%edx
  801e47:	83 c4 1c             	add    $0x1c,%esp
  801e4a:	5b                   	pop    %ebx
  801e4b:	5e                   	pop    %esi
  801e4c:	5f                   	pop    %edi
  801e4d:	5d                   	pop    %ebp
  801e4e:	c3                   	ret    
  801e4f:	90                   	nop
  801e50:	89 fd                	mov    %edi,%ebp
  801e52:	85 ff                	test   %edi,%edi
  801e54:	75 0b                	jne    801e61 <__umoddi3+0xe9>
  801e56:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5b:	31 d2                	xor    %edx,%edx
  801e5d:	f7 f7                	div    %edi
  801e5f:	89 c5                	mov    %eax,%ebp
  801e61:	89 f0                	mov    %esi,%eax
  801e63:	31 d2                	xor    %edx,%edx
  801e65:	f7 f5                	div    %ebp
  801e67:	89 c8                	mov    %ecx,%eax
  801e69:	f7 f5                	div    %ebp
  801e6b:	89 d0                	mov    %edx,%eax
  801e6d:	e9 44 ff ff ff       	jmp    801db6 <__umoddi3+0x3e>
  801e72:	66 90                	xchg   %ax,%ax
  801e74:	89 c8                	mov    %ecx,%eax
  801e76:	89 f2                	mov    %esi,%edx
  801e78:	83 c4 1c             	add    $0x1c,%esp
  801e7b:	5b                   	pop    %ebx
  801e7c:	5e                   	pop    %esi
  801e7d:	5f                   	pop    %edi
  801e7e:	5d                   	pop    %ebp
  801e7f:	c3                   	ret    
  801e80:	3b 04 24             	cmp    (%esp),%eax
  801e83:	72 06                	jb     801e8b <__umoddi3+0x113>
  801e85:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e89:	77 0f                	ja     801e9a <__umoddi3+0x122>
  801e8b:	89 f2                	mov    %esi,%edx
  801e8d:	29 f9                	sub    %edi,%ecx
  801e8f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e93:	89 14 24             	mov    %edx,(%esp)
  801e96:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e9a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e9e:	8b 14 24             	mov    (%esp),%edx
  801ea1:	83 c4 1c             	add    $0x1c,%esp
  801ea4:	5b                   	pop    %ebx
  801ea5:	5e                   	pop    %esi
  801ea6:	5f                   	pop    %edi
  801ea7:	5d                   	pop    %ebp
  801ea8:	c3                   	ret    
  801ea9:	8d 76 00             	lea    0x0(%esi),%esi
  801eac:	2b 04 24             	sub    (%esp),%eax
  801eaf:	19 fa                	sbb    %edi,%edx
  801eb1:	89 d1                	mov    %edx,%ecx
  801eb3:	89 c6                	mov    %eax,%esi
  801eb5:	e9 71 ff ff ff       	jmp    801e2b <__umoddi3+0xb3>
  801eba:	66 90                	xchg   %ax,%ax
  801ebc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ec0:	72 ea                	jb     801eac <__umoddi3+0x134>
  801ec2:	89 d9                	mov    %ebx,%ecx
  801ec4:	e9 62 ff ff ff       	jmp    801e2b <__umoddi3+0xb3>
