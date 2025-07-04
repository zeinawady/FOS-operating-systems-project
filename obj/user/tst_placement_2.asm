
obj/user/tst_placement_2:     file format elf32-i386


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
  800031:	e8 c0 03 00 00       	call   8003f6 <libmain>
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

	//uint32 actual_active_list[13] = {0xedbfd000,0xeebfd000,0x803000,0x802000,0x801000,0x800000,0x205000,0x204000,0x203000,0x202000,0x201000,0x200000};
	uint32 actual_active_list[13] ;
	{
		actual_active_list[0] = 0xedbfd000;
  800043:	c7 85 94 ff ff fe 00 	movl   $0xedbfd000,-0x100006c(%ebp)
  80004a:	d0 bf ed 
		actual_active_list[1] = 0xeebfd000;
  80004d:	c7 85 98 ff ff fe 00 	movl   $0xeebfd000,-0x1000068(%ebp)
  800054:	d0 bf ee 
		actual_active_list[2] = 0x803000;
  800057:	c7 85 9c ff ff fe 00 	movl   $0x803000,-0x1000064(%ebp)
  80005e:	30 80 00 
		actual_active_list[3] = 0x802000;
  800061:	c7 85 a0 ff ff fe 00 	movl   $0x802000,-0x1000060(%ebp)
  800068:	20 80 00 
		actual_active_list[4] = 0x801000;
  80006b:	c7 85 a4 ff ff fe 00 	movl   $0x801000,-0x100005c(%ebp)
  800072:	10 80 00 
		actual_active_list[5] = 0x800000;
  800075:	c7 85 a8 ff ff fe 00 	movl   $0x800000,-0x1000058(%ebp)
  80007c:	00 80 00 
		actual_active_list[6] = 0x205000;
  80007f:	c7 85 ac ff ff fe 00 	movl   $0x205000,-0x1000054(%ebp)
  800086:	50 20 00 
		actual_active_list[7] = 0x204000;
  800089:	c7 85 b0 ff ff fe 00 	movl   $0x204000,-0x1000050(%ebp)
  800090:	40 20 00 
		actual_active_list[8] = 0x203000;
  800093:	c7 85 b4 ff ff fe 00 	movl   $0x203000,-0x100004c(%ebp)
  80009a:	30 20 00 
		actual_active_list[9] = 0x202000;
  80009d:	c7 85 b8 ff ff fe 00 	movl   $0x202000,-0x1000048(%ebp)
  8000a4:	20 20 00 
		actual_active_list[10] = 0x201000;
  8000a7:	c7 85 bc ff ff fe 00 	movl   $0x201000,-0x1000044(%ebp)
  8000ae:	10 20 00 
		actual_active_list[11] = 0x200000;
  8000b1:	c7 85 c0 ff ff fe 00 	movl   $0x200000,-0x1000040(%ebp)
  8000b8:	00 20 00 
	}
	uint32 actual_second_list[7] = {};
  8000bb:	8d 95 78 ff ff fe    	lea    -0x1000088(%ebp),%edx
  8000c1:	b9 07 00 00 00       	mov    $0x7,%ecx
  8000c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000cb:	89 d7                	mov    %edx,%edi
  8000cd:	f3 ab                	rep stos %eax,%es:(%edi)
	("STEP 0: checking Initial LRU lists entries ...\n");
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 12, 0);
  8000cf:	6a 00                	push   $0x0
  8000d1:	6a 0c                	push   $0xc
  8000d3:	8d 85 78 ff ff fe    	lea    -0x1000088(%ebp),%eax
  8000d9:	50                   	push   %eax
  8000da:	8d 85 94 ff ff fe    	lea    -0x100006c(%ebp),%eax
  8000e0:	50                   	push   %eax
  8000e1:	e8 e5 19 00 00       	call   801acb <sys_check_LRU_lists>
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if(check == 0)
  8000ec:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8000f0:	75 14                	jne    800106 <_main+0xce>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 a0 1e 80 00       	push   $0x801ea0
  8000fa:	6a 24                	push   $0x24
  8000fc:	68 22 1f 80 00       	push   $0x801f22
  800101:	e8 35 04 00 00       	call   80053b <_panic>
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800106:	e8 f2 15 00 00       	call   8016fd <sys_pf_calculate_allocated_pages>
  80010b:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int freePages = sys_calculate_free_frames();
  80010e:	e8 9f 15 00 00       	call   8016b2 <sys_calculate_free_frames>
  800113:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i=0;
  800116:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(;i<=PAGE_SIZE;i++)
  80011d:	eb 11                	jmp    800130 <_main+0xf8>
	{
		arr[i] = -1;
  80011f:	8d 95 c8 ff ff fe    	lea    -0x1000038(%ebp),%edx
  800125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800128:	01 d0                	add    %edx,%eax
  80012a:	c6 00 ff             	movb   $0xff,(%eax)

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int freePages = sys_calculate_free_frames();

	int i=0;
	for(;i<=PAGE_SIZE;i++)
  80012d:	ff 45 f4             	incl   -0xc(%ebp)
  800130:	81 7d f4 00 10 00 00 	cmpl   $0x1000,-0xc(%ebp)
  800137:	7e e6                	jle    80011f <_main+0xe7>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
  800139:	c7 45 f4 00 00 40 00 	movl   $0x400000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800140:	eb 11                	jmp    800153 <_main+0x11b>
	{
		arr[i] = -1;
  800142:	8d 95 c8 ff ff fe    	lea    -0x1000038(%ebp),%edx
  800148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80014b:	01 d0                	add    %edx,%eax
  80014d:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800150:	ff 45 f4             	incl   -0xc(%ebp)
  800153:	81 7d f4 00 10 40 00 	cmpl   $0x401000,-0xc(%ebp)
  80015a:	7e e6                	jle    800142 <_main+0x10a>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
  80015c:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800163:	eb 11                	jmp    800176 <_main+0x13e>
	{
		arr[i] = -1;
  800165:	8d 95 c8 ff ff fe    	lea    -0x1000038(%ebp),%edx
  80016b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80016e:	01 d0                	add    %edx,%eax
  800170:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800173:	ff 45 f4             	incl   -0xc(%ebp)
  800176:	81 7d f4 00 10 80 00 	cmpl   $0x801000,-0xc(%ebp)
  80017d:	7e e6                	jle    800165 <_main+0x12d>
	{
		arr[i] = -1;
	}

	int eval = 0;
  80017f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	bool is_correct = 1;
  800186:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)

	uint32 expected, actual ;
	cprintf("STEP A: checking PLACEMENT fault handling ... \n");
  80018d:	83 ec 0c             	sub    $0xc,%esp
  800190:	68 3c 1f 80 00       	push   $0x801f3c
  800195:	e8 5e 06 00 00       	call   8007f8 <cprintf>
  80019a:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  80019d:	8a 85 c8 ff ff fe    	mov    -0x1000038(%ebp),%al
  8001a3:	3c ff                	cmp    $0xff,%al
  8001a5:	74 17                	je     8001be <_main+0x186>
  8001a7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	68 6c 1f 80 00       	push   $0x801f6c
  8001b6:	e8 3d 06 00 00       	call   8007f8 <cprintf>
  8001bb:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8001be:	8a 85 c8 0f 00 ff    	mov    -0xfff038(%ebp),%al
  8001c4:	3c ff                	cmp    $0xff,%al
  8001c6:	74 17                	je     8001df <_main+0x1a7>
  8001c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001cf:	83 ec 0c             	sub    $0xc,%esp
  8001d2:	68 6c 1f 80 00       	push   $0x801f6c
  8001d7:	e8 1c 06 00 00       	call   8007f8 <cprintf>
  8001dc:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8001df:	8a 85 c8 ff 3f ff    	mov    -0xc00038(%ebp),%al
  8001e5:	3c ff                	cmp    $0xff,%al
  8001e7:	74 17                	je     800200 <_main+0x1c8>
  8001e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	68 6c 1f 80 00       	push   $0x801f6c
  8001f8:	e8 fb 05 00 00       	call   8007f8 <cprintf>
  8001fd:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1025] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800200:	8a 85 c8 0f 40 ff    	mov    -0xbff038(%ebp),%al
  800206:	3c ff                	cmp    $0xff,%al
  800208:	74 17                	je     800221 <_main+0x1e9>
  80020a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800211:	83 ec 0c             	sub    $0xc,%esp
  800214:	68 6c 1f 80 00       	push   $0x801f6c
  800219:	e8 da 05 00 00       	call   8007f8 <cprintf>
  80021e:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024*2] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800221:	8a 85 c8 ff 7f ff    	mov    -0x800038(%ebp),%al
  800227:	3c ff                	cmp    $0xff,%al
  800229:	74 17                	je     800242 <_main+0x20a>
  80022b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 6c 1f 80 00       	push   $0x801f6c
  80023a:	e8 b9 05 00 00       	call   8007f8 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800242:	8a 85 c8 0f 80 ff    	mov    -0x7ff038(%ebp),%al
  800248:	3c ff                	cmp    $0xff,%al
  80024a:	74 17                	je     800263 <_main+0x22b>
  80024c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800253:	83 ec 0c             	sub    $0xc,%esp
  800256:	68 6c 1f 80 00       	push   $0x801f6c
  80025b:	e8 98 05 00 00       	call   8007f8 <cprintf>
  800260:	83 c4 10             	add    $0x10,%esp


		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("new stack pages should NOT written to Page File until it's replaced\n"); }
  800263:	e8 95 14 00 00       	call   8016fd <sys_pf_calculate_allocated_pages>
  800268:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80026b:	74 17                	je     800284 <_main+0x24c>
  80026d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	68 8c 1f 80 00       	push   $0x801f8c
  80027c:	e8 77 05 00 00       	call   8007f8 <cprintf>
  800281:	83 c4 10             	add    $0x10,%esp

		expected = 6 /*pages*/ + 3 /*tables*/ - 2 /*table + page due to a fault in the 1st call of sys_calculate_free_frames*/;
  800284:	c7 45 d0 07 00 00 00 	movl   $0x7,-0x30(%ebp)
		actual = (freePages - sys_calculate_free_frames()) ;
  80028b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80028e:	e8 1f 14 00 00       	call   8016b2 <sys_calculate_free_frames>
  800293:	29 c3                	sub    %eax,%ebx
  800295:	89 d8                	mov    %ebx,%eax
  800297:	89 45 cc             	mov    %eax,-0x34(%ebp)
		//actual = (initFreeFrames - sys_calculate_free_frames()) ;
		if(actual != expected) { is_correct = 0; cprintf("allocated memory size incorrect. Expected = %d, Actual = %d\n", expected, actual); }
  80029a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80029d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8002a0:	74 1d                	je     8002bf <_main+0x287>
  8002a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8002a9:	83 ec 04             	sub    $0x4,%esp
  8002ac:	ff 75 cc             	pushl  -0x34(%ebp)
  8002af:	ff 75 d0             	pushl  -0x30(%ebp)
  8002b2:	68 d4 1f 80 00       	push   $0x801fd4
  8002b7:	e8 3c 05 00 00       	call   8007f8 <cprintf>
  8002bc:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  8002bf:	83 ec 0c             	sub    $0xc,%esp
  8002c2:	68 14 20 80 00       	push   $0x802014
  8002c7:	e8 2c 05 00 00       	call   8007f8 <cprintf>
  8002cc:	83 c4 10             	add    $0x10,%esp
	if (is_correct)
  8002cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8002d3:	74 04                	je     8002d9 <_main+0x2a1>
		eval += 50 ;
  8002d5:	83 45 f0 32          	addl   $0x32,-0x10(%ebp)
	is_correct = 1;
  8002d9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)

	int j=0;
  8002e0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	for (int i=3;i>=0;i--,j++)
  8002e7:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
  8002ee:	eb 1f                	jmp    80030f <_main+0x2d7>
		actual_second_list[i]=actual_active_list[11-j];
  8002f0:	b8 0b 00 00 00       	mov    $0xb,%eax
  8002f5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8002f8:	8b 94 85 94 ff ff fe 	mov    -0x100006c(%ebp,%eax,4),%edx
  8002ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800302:	89 94 85 78 ff ff fe 	mov    %edx,-0x1000088(%ebp,%eax,4)
	if (is_correct)
		eval += 50 ;
	is_correct = 1;

	int j=0;
	for (int i=3;i>=0;i--,j++)
  800309:	ff 4d e4             	decl   -0x1c(%ebp)
  80030c:	ff 45 e8             	incl   -0x18(%ebp)
  80030f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800313:	79 db                	jns    8002f0 <_main+0x2b8>
		actual_second_list[i]=actual_active_list[11-j];
	for (int i=12;i>4;i--)
  800315:	c7 45 e0 0c 00 00 00 	movl   $0xc,-0x20(%ebp)
  80031c:	eb 1a                	jmp    800338 <_main+0x300>
		actual_active_list[i]=actual_active_list[i-5];
  80031e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800321:	83 e8 05             	sub    $0x5,%eax
  800324:	8b 94 85 94 ff ff fe 	mov    -0x100006c(%ebp,%eax,4),%edx
  80032b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80032e:	89 94 85 94 ff ff fe 	mov    %edx,-0x100006c(%ebp,%eax,4)
	is_correct = 1;

	int j=0;
	for (int i=3;i>=0;i--,j++)
		actual_second_list[i]=actual_active_list[11-j];
	for (int i=12;i>4;i--)
  800335:	ff 4d e0             	decl   -0x20(%ebp)
  800338:	83 7d e0 04          	cmpl   $0x4,-0x20(%ebp)
  80033c:	7f e0                	jg     80031e <_main+0x2e6>
		actual_active_list[i]=actual_active_list[i-5];
	actual_active_list[0]=0xee3fe000;
  80033e:	c7 85 94 ff ff fe 00 	movl   $0xee3fe000,-0x100006c(%ebp)
  800345:	e0 3f ee 
	actual_active_list[1]=0xee3fd000;
  800348:	c7 85 98 ff ff fe 00 	movl   $0xee3fd000,-0x1000068(%ebp)
  80034f:	d0 3f ee 
	actual_active_list[2]=0xedffe000;
  800352:	c7 85 9c ff ff fe 00 	movl   $0xedffe000,-0x1000064(%ebp)
  800359:	e0 ff ed 
	actual_active_list[3]=0xedffd000;
  80035c:	c7 85 a0 ff ff fe 00 	movl   $0xedffd000,-0x1000060(%ebp)
  800363:	d0 ff ed 
	actual_active_list[4]=0xedbfe000;
  800366:	c7 85 a4 ff ff fe 00 	movl   $0xedbfe000,-0x100005c(%ebp)
  80036d:	e0 bf ed 

	cprintf("STEP B: checking LRU lists entries ...\n");
  800370:	83 ec 0c             	sub    $0xc,%esp
  800373:	68 48 20 80 00       	push   $0x802048
  800378:	e8 7b 04 00 00       	call   8007f8 <cprintf>
  80037d:	83 c4 10             	add    $0x10,%esp
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 13, 4);
  800380:	6a 04                	push   $0x4
  800382:	6a 0d                	push   $0xd
  800384:	8d 85 78 ff ff fe    	lea    -0x1000088(%ebp),%eax
  80038a:	50                   	push   %eax
  80038b:	8d 85 94 ff ff fe    	lea    -0x100006c(%ebp),%eax
  800391:	50                   	push   %eax
  800392:	e8 34 17 00 00       	call   801acb <sys_check_LRU_lists>
  800397:	83 c4 10             	add    $0x10,%esp
  80039a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if(check == 0)
  80039d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8003a1:	75 17                	jne    8003ba <_main+0x382>
			{ is_correct = 0; cprintf("LRU lists entries are not correct, check your logic again!!\n"); }
  8003a3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8003aa:	83 ec 0c             	sub    $0xc,%esp
  8003ad:	68 70 20 80 00       	push   $0x802070
  8003b2:	e8 41 04 00 00       	call   8007f8 <cprintf>
  8003b7:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP B passed: LRU lists entries test are correct\n\n\n");
  8003ba:	83 ec 0c             	sub    $0xc,%esp
  8003bd:	68 b0 20 80 00       	push   $0x8020b0
  8003c2:	e8 31 04 00 00       	call   8007f8 <cprintf>
  8003c7:	83 c4 10             	add    $0x10,%esp
	if (is_correct)
  8003ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003ce:	74 04                	je     8003d4 <_main+0x39c>
		eval += 50 ;
  8003d0:	83 45 f0 32          	addl   $0x32,-0x10(%ebp)
	is_correct = 1;
  8003d4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)

	cprintf("Congratulations!! Test of PAGE PLACEMENT SECOND SCENARIO completed. Eval = %d\n\n\n", eval);
  8003db:	83 ec 08             	sub    $0x8,%esp
  8003de:	ff 75 f0             	pushl  -0x10(%ebp)
  8003e1:	68 e8 20 80 00       	push   $0x8020e8
  8003e6:	e8 0d 04 00 00       	call   8007f8 <cprintf>
  8003eb:	83 c4 10             	add    $0x10,%esp
	return;
  8003ee:	90                   	nop
}
  8003ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8003f2:	5b                   	pop    %ebx
  8003f3:	5f                   	pop    %edi
  8003f4:	5d                   	pop    %ebp
  8003f5:	c3                   	ret    

008003f6 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8003f6:	55                   	push   %ebp
  8003f7:	89 e5                	mov    %esp,%ebp
  8003f9:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8003fc:	e8 7a 14 00 00       	call   80187b <sys_getenvindex>
  800401:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800404:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800407:	89 d0                	mov    %edx,%eax
  800409:	c1 e0 02             	shl    $0x2,%eax
  80040c:	01 d0                	add    %edx,%eax
  80040e:	c1 e0 03             	shl    $0x3,%eax
  800411:	01 d0                	add    %edx,%eax
  800413:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80041a:	01 d0                	add    %edx,%eax
  80041c:	c1 e0 02             	shl    $0x2,%eax
  80041f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800424:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800429:	a1 08 30 80 00       	mov    0x803008,%eax
  80042e:	8a 40 20             	mov    0x20(%eax),%al
  800431:	84 c0                	test   %al,%al
  800433:	74 0d                	je     800442 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800435:	a1 08 30 80 00       	mov    0x803008,%eax
  80043a:	83 c0 20             	add    $0x20,%eax
  80043d:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800442:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800446:	7e 0a                	jle    800452 <libmain+0x5c>
		binaryname = argv[0];
  800448:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044b:	8b 00                	mov    (%eax),%eax
  80044d:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800452:	83 ec 08             	sub    $0x8,%esp
  800455:	ff 75 0c             	pushl  0xc(%ebp)
  800458:	ff 75 08             	pushl  0x8(%ebp)
  80045b:	e8 d8 fb ff ff       	call   800038 <_main>
  800460:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800463:	a1 00 30 80 00       	mov    0x803000,%eax
  800468:	85 c0                	test   %eax,%eax
  80046a:	0f 84 9f 00 00 00    	je     80050f <libmain+0x119>
	{
		sys_lock_cons();
  800470:	e8 8a 11 00 00       	call   8015ff <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800475:	83 ec 0c             	sub    $0xc,%esp
  800478:	68 54 21 80 00       	push   $0x802154
  80047d:	e8 76 03 00 00       	call   8007f8 <cprintf>
  800482:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800485:	a1 08 30 80 00       	mov    0x803008,%eax
  80048a:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800490:	a1 08 30 80 00       	mov    0x803008,%eax
  800495:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80049b:	83 ec 04             	sub    $0x4,%esp
  80049e:	52                   	push   %edx
  80049f:	50                   	push   %eax
  8004a0:	68 7c 21 80 00       	push   $0x80217c
  8004a5:	e8 4e 03 00 00       	call   8007f8 <cprintf>
  8004aa:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004ad:	a1 08 30 80 00       	mov    0x803008,%eax
  8004b2:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8004b8:	a1 08 30 80 00       	mov    0x803008,%eax
  8004bd:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8004c3:	a1 08 30 80 00       	mov    0x803008,%eax
  8004c8:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8004ce:	51                   	push   %ecx
  8004cf:	52                   	push   %edx
  8004d0:	50                   	push   %eax
  8004d1:	68 a4 21 80 00       	push   $0x8021a4
  8004d6:	e8 1d 03 00 00       	call   8007f8 <cprintf>
  8004db:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004de:	a1 08 30 80 00       	mov    0x803008,%eax
  8004e3:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8004e9:	83 ec 08             	sub    $0x8,%esp
  8004ec:	50                   	push   %eax
  8004ed:	68 fc 21 80 00       	push   $0x8021fc
  8004f2:	e8 01 03 00 00       	call   8007f8 <cprintf>
  8004f7:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8004fa:	83 ec 0c             	sub    $0xc,%esp
  8004fd:	68 54 21 80 00       	push   $0x802154
  800502:	e8 f1 02 00 00       	call   8007f8 <cprintf>
  800507:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80050a:	e8 0a 11 00 00       	call   801619 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80050f:	e8 19 00 00 00       	call   80052d <exit>
}
  800514:	90                   	nop
  800515:	c9                   	leave  
  800516:	c3                   	ret    

00800517 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800517:	55                   	push   %ebp
  800518:	89 e5                	mov    %esp,%ebp
  80051a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80051d:	83 ec 0c             	sub    $0xc,%esp
  800520:	6a 00                	push   $0x0
  800522:	e8 20 13 00 00       	call   801847 <sys_destroy_env>
  800527:	83 c4 10             	add    $0x10,%esp
}
  80052a:	90                   	nop
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <exit>:

void
exit(void)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800533:	e8 75 13 00 00       	call   8018ad <sys_exit_env>
}
  800538:	90                   	nop
  800539:	c9                   	leave  
  80053a:	c3                   	ret    

0080053b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80053b:	55                   	push   %ebp
  80053c:	89 e5                	mov    %esp,%ebp
  80053e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800541:	8d 45 10             	lea    0x10(%ebp),%eax
  800544:	83 c0 04             	add    $0x4,%eax
  800547:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80054a:	a1 28 30 80 00       	mov    0x803028,%eax
  80054f:	85 c0                	test   %eax,%eax
  800551:	74 16                	je     800569 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800553:	a1 28 30 80 00       	mov    0x803028,%eax
  800558:	83 ec 08             	sub    $0x8,%esp
  80055b:	50                   	push   %eax
  80055c:	68 10 22 80 00       	push   $0x802210
  800561:	e8 92 02 00 00       	call   8007f8 <cprintf>
  800566:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800569:	a1 04 30 80 00       	mov    0x803004,%eax
  80056e:	ff 75 0c             	pushl  0xc(%ebp)
  800571:	ff 75 08             	pushl  0x8(%ebp)
  800574:	50                   	push   %eax
  800575:	68 15 22 80 00       	push   $0x802215
  80057a:	e8 79 02 00 00       	call   8007f8 <cprintf>
  80057f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800582:	8b 45 10             	mov    0x10(%ebp),%eax
  800585:	83 ec 08             	sub    $0x8,%esp
  800588:	ff 75 f4             	pushl  -0xc(%ebp)
  80058b:	50                   	push   %eax
  80058c:	e8 fc 01 00 00       	call   80078d <vcprintf>
  800591:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800594:	83 ec 08             	sub    $0x8,%esp
  800597:	6a 00                	push   $0x0
  800599:	68 31 22 80 00       	push   $0x802231
  80059e:	e8 ea 01 00 00       	call   80078d <vcprintf>
  8005a3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005a6:	e8 82 ff ff ff       	call   80052d <exit>

	// should not return here
	while (1) ;
  8005ab:	eb fe                	jmp    8005ab <_panic+0x70>

008005ad <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005ad:	55                   	push   %ebp
  8005ae:	89 e5                	mov    %esp,%ebp
  8005b0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005b3:	a1 08 30 80 00       	mov    0x803008,%eax
  8005b8:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8005be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c1:	39 c2                	cmp    %eax,%edx
  8005c3:	74 14                	je     8005d9 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005c5:	83 ec 04             	sub    $0x4,%esp
  8005c8:	68 34 22 80 00       	push   $0x802234
  8005cd:	6a 26                	push   $0x26
  8005cf:	68 80 22 80 00       	push   $0x802280
  8005d4:	e8 62 ff ff ff       	call   80053b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005e7:	e9 c5 00 00 00       	jmp    8006b1 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8005ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f9:	01 d0                	add    %edx,%eax
  8005fb:	8b 00                	mov    (%eax),%eax
  8005fd:	85 c0                	test   %eax,%eax
  8005ff:	75 08                	jne    800609 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800601:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800604:	e9 a5 00 00 00       	jmp    8006ae <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800609:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800610:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800617:	eb 69                	jmp    800682 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800619:	a1 08 30 80 00       	mov    0x803008,%eax
  80061e:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800624:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800627:	89 d0                	mov    %edx,%eax
  800629:	01 c0                	add    %eax,%eax
  80062b:	01 d0                	add    %edx,%eax
  80062d:	c1 e0 03             	shl    $0x3,%eax
  800630:	01 c8                	add    %ecx,%eax
  800632:	8a 40 04             	mov    0x4(%eax),%al
  800635:	84 c0                	test   %al,%al
  800637:	75 46                	jne    80067f <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800639:	a1 08 30 80 00       	mov    0x803008,%eax
  80063e:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800644:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800647:	89 d0                	mov    %edx,%eax
  800649:	01 c0                	add    %eax,%eax
  80064b:	01 d0                	add    %edx,%eax
  80064d:	c1 e0 03             	shl    $0x3,%eax
  800650:	01 c8                	add    %ecx,%eax
  800652:	8b 00                	mov    (%eax),%eax
  800654:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800657:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80065a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80065f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800661:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800664:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80066b:	8b 45 08             	mov    0x8(%ebp),%eax
  80066e:	01 c8                	add    %ecx,%eax
  800670:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800672:	39 c2                	cmp    %eax,%edx
  800674:	75 09                	jne    80067f <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800676:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80067d:	eb 15                	jmp    800694 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80067f:	ff 45 e8             	incl   -0x18(%ebp)
  800682:	a1 08 30 80 00       	mov    0x803008,%eax
  800687:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80068d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800690:	39 c2                	cmp    %eax,%edx
  800692:	77 85                	ja     800619 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800694:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800698:	75 14                	jne    8006ae <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80069a:	83 ec 04             	sub    $0x4,%esp
  80069d:	68 8c 22 80 00       	push   $0x80228c
  8006a2:	6a 3a                	push   $0x3a
  8006a4:	68 80 22 80 00       	push   $0x802280
  8006a9:	e8 8d fe ff ff       	call   80053b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006ae:	ff 45 f0             	incl   -0x10(%ebp)
  8006b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006b7:	0f 8c 2f ff ff ff    	jl     8005ec <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006bd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006c4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006cb:	eb 26                	jmp    8006f3 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006cd:	a1 08 30 80 00       	mov    0x803008,%eax
  8006d2:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8006d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006db:	89 d0                	mov    %edx,%eax
  8006dd:	01 c0                	add    %eax,%eax
  8006df:	01 d0                	add    %edx,%eax
  8006e1:	c1 e0 03             	shl    $0x3,%eax
  8006e4:	01 c8                	add    %ecx,%eax
  8006e6:	8a 40 04             	mov    0x4(%eax),%al
  8006e9:	3c 01                	cmp    $0x1,%al
  8006eb:	75 03                	jne    8006f0 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8006ed:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006f0:	ff 45 e0             	incl   -0x20(%ebp)
  8006f3:	a1 08 30 80 00       	mov    0x803008,%eax
  8006f8:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800701:	39 c2                	cmp    %eax,%edx
  800703:	77 c8                	ja     8006cd <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800708:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80070b:	74 14                	je     800721 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80070d:	83 ec 04             	sub    $0x4,%esp
  800710:	68 e0 22 80 00       	push   $0x8022e0
  800715:	6a 44                	push   $0x44
  800717:	68 80 22 80 00       	push   $0x802280
  80071c:	e8 1a fe ff ff       	call   80053b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800721:	90                   	nop
  800722:	c9                   	leave  
  800723:	c3                   	ret    

00800724 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800724:	55                   	push   %ebp
  800725:	89 e5                	mov    %esp,%ebp
  800727:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80072a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	8d 48 01             	lea    0x1(%eax),%ecx
  800732:	8b 55 0c             	mov    0xc(%ebp),%edx
  800735:	89 0a                	mov    %ecx,(%edx)
  800737:	8b 55 08             	mov    0x8(%ebp),%edx
  80073a:	88 d1                	mov    %dl,%cl
  80073c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80073f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800743:	8b 45 0c             	mov    0xc(%ebp),%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	3d ff 00 00 00       	cmp    $0xff,%eax
  80074d:	75 2c                	jne    80077b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80074f:	a0 0c 30 80 00       	mov    0x80300c,%al
  800754:	0f b6 c0             	movzbl %al,%eax
  800757:	8b 55 0c             	mov    0xc(%ebp),%edx
  80075a:	8b 12                	mov    (%edx),%edx
  80075c:	89 d1                	mov    %edx,%ecx
  80075e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800761:	83 c2 08             	add    $0x8,%edx
  800764:	83 ec 04             	sub    $0x4,%esp
  800767:	50                   	push   %eax
  800768:	51                   	push   %ecx
  800769:	52                   	push   %edx
  80076a:	e8 4e 0e 00 00       	call   8015bd <sys_cputs>
  80076f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800772:	8b 45 0c             	mov    0xc(%ebp),%eax
  800775:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80077b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077e:	8b 40 04             	mov    0x4(%eax),%eax
  800781:	8d 50 01             	lea    0x1(%eax),%edx
  800784:	8b 45 0c             	mov    0xc(%ebp),%eax
  800787:	89 50 04             	mov    %edx,0x4(%eax)
}
  80078a:	90                   	nop
  80078b:	c9                   	leave  
  80078c:	c3                   	ret    

0080078d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80078d:	55                   	push   %ebp
  80078e:	89 e5                	mov    %esp,%ebp
  800790:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800796:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80079d:	00 00 00 
	b.cnt = 0;
  8007a0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007a7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007aa:	ff 75 0c             	pushl  0xc(%ebp)
  8007ad:	ff 75 08             	pushl  0x8(%ebp)
  8007b0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007b6:	50                   	push   %eax
  8007b7:	68 24 07 80 00       	push   $0x800724
  8007bc:	e8 11 02 00 00       	call   8009d2 <vprintfmt>
  8007c1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007c4:	a0 0c 30 80 00       	mov    0x80300c,%al
  8007c9:	0f b6 c0             	movzbl %al,%eax
  8007cc:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007d2:	83 ec 04             	sub    $0x4,%esp
  8007d5:	50                   	push   %eax
  8007d6:	52                   	push   %edx
  8007d7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007dd:	83 c0 08             	add    $0x8,%eax
  8007e0:	50                   	push   %eax
  8007e1:	e8 d7 0d 00 00       	call   8015bd <sys_cputs>
  8007e6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007e9:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  8007f0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007f6:	c9                   	leave  
  8007f7:	c3                   	ret    

008007f8 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007fe:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  800805:	8d 45 0c             	lea    0xc(%ebp),%eax
  800808:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80080b:	8b 45 08             	mov    0x8(%ebp),%eax
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	ff 75 f4             	pushl  -0xc(%ebp)
  800814:	50                   	push   %eax
  800815:	e8 73 ff ff ff       	call   80078d <vcprintf>
  80081a:	83 c4 10             	add    $0x10,%esp
  80081d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800820:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800823:	c9                   	leave  
  800824:	c3                   	ret    

00800825 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800825:	55                   	push   %ebp
  800826:	89 e5                	mov    %esp,%ebp
  800828:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80082b:	e8 cf 0d 00 00       	call   8015ff <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800830:	8d 45 0c             	lea    0xc(%ebp),%eax
  800833:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	83 ec 08             	sub    $0x8,%esp
  80083c:	ff 75 f4             	pushl  -0xc(%ebp)
  80083f:	50                   	push   %eax
  800840:	e8 48 ff ff ff       	call   80078d <vcprintf>
  800845:	83 c4 10             	add    $0x10,%esp
  800848:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80084b:	e8 c9 0d 00 00       	call   801619 <sys_unlock_cons>
	return cnt;
  800850:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800853:	c9                   	leave  
  800854:	c3                   	ret    

00800855 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800855:	55                   	push   %ebp
  800856:	89 e5                	mov    %esp,%ebp
  800858:	53                   	push   %ebx
  800859:	83 ec 14             	sub    $0x14,%esp
  80085c:	8b 45 10             	mov    0x10(%ebp),%eax
  80085f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800868:	8b 45 18             	mov    0x18(%ebp),%eax
  80086b:	ba 00 00 00 00       	mov    $0x0,%edx
  800870:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800873:	77 55                	ja     8008ca <printnum+0x75>
  800875:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800878:	72 05                	jb     80087f <printnum+0x2a>
  80087a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80087d:	77 4b                	ja     8008ca <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80087f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800882:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800885:	8b 45 18             	mov    0x18(%ebp),%eax
  800888:	ba 00 00 00 00       	mov    $0x0,%edx
  80088d:	52                   	push   %edx
  80088e:	50                   	push   %eax
  80088f:	ff 75 f4             	pushl  -0xc(%ebp)
  800892:	ff 75 f0             	pushl  -0x10(%ebp)
  800895:	e8 96 13 00 00       	call   801c30 <__udivdi3>
  80089a:	83 c4 10             	add    $0x10,%esp
  80089d:	83 ec 04             	sub    $0x4,%esp
  8008a0:	ff 75 20             	pushl  0x20(%ebp)
  8008a3:	53                   	push   %ebx
  8008a4:	ff 75 18             	pushl  0x18(%ebp)
  8008a7:	52                   	push   %edx
  8008a8:	50                   	push   %eax
  8008a9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ac:	ff 75 08             	pushl  0x8(%ebp)
  8008af:	e8 a1 ff ff ff       	call   800855 <printnum>
  8008b4:	83 c4 20             	add    $0x20,%esp
  8008b7:	eb 1a                	jmp    8008d3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008b9:	83 ec 08             	sub    $0x8,%esp
  8008bc:	ff 75 0c             	pushl  0xc(%ebp)
  8008bf:	ff 75 20             	pushl  0x20(%ebp)
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	ff d0                	call   *%eax
  8008c7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008ca:	ff 4d 1c             	decl   0x1c(%ebp)
  8008cd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008d1:	7f e6                	jg     8008b9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008d3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008d6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008e1:	53                   	push   %ebx
  8008e2:	51                   	push   %ecx
  8008e3:	52                   	push   %edx
  8008e4:	50                   	push   %eax
  8008e5:	e8 56 14 00 00       	call   801d40 <__umoddi3>
  8008ea:	83 c4 10             	add    $0x10,%esp
  8008ed:	05 54 25 80 00       	add    $0x802554,%eax
  8008f2:	8a 00                	mov    (%eax),%al
  8008f4:	0f be c0             	movsbl %al,%eax
  8008f7:	83 ec 08             	sub    $0x8,%esp
  8008fa:	ff 75 0c             	pushl  0xc(%ebp)
  8008fd:	50                   	push   %eax
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	ff d0                	call   *%eax
  800903:	83 c4 10             	add    $0x10,%esp
}
  800906:	90                   	nop
  800907:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80090a:	c9                   	leave  
  80090b:	c3                   	ret    

0080090c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80090f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800913:	7e 1c                	jle    800931 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	8d 50 08             	lea    0x8(%eax),%edx
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	89 10                	mov    %edx,(%eax)
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	8b 00                	mov    (%eax),%eax
  800927:	83 e8 08             	sub    $0x8,%eax
  80092a:	8b 50 04             	mov    0x4(%eax),%edx
  80092d:	8b 00                	mov    (%eax),%eax
  80092f:	eb 40                	jmp    800971 <getuint+0x65>
	else if (lflag)
  800931:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800935:	74 1e                	je     800955 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	8d 50 04             	lea    0x4(%eax),%edx
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	89 10                	mov    %edx,(%eax)
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	8b 00                	mov    (%eax),%eax
  800949:	83 e8 04             	sub    $0x4,%eax
  80094c:	8b 00                	mov    (%eax),%eax
  80094e:	ba 00 00 00 00       	mov    $0x0,%edx
  800953:	eb 1c                	jmp    800971 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	8b 00                	mov    (%eax),%eax
  80095a:	8d 50 04             	lea    0x4(%eax),%edx
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	89 10                	mov    %edx,(%eax)
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	8b 00                	mov    (%eax),%eax
  800967:	83 e8 04             	sub    $0x4,%eax
  80096a:	8b 00                	mov    (%eax),%eax
  80096c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800971:	5d                   	pop    %ebp
  800972:	c3                   	ret    

00800973 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800976:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80097a:	7e 1c                	jle    800998 <getint+0x25>
		return va_arg(*ap, long long);
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	8b 00                	mov    (%eax),%eax
  800981:	8d 50 08             	lea    0x8(%eax),%edx
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	89 10                	mov    %edx,(%eax)
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	8b 00                	mov    (%eax),%eax
  80098e:	83 e8 08             	sub    $0x8,%eax
  800991:	8b 50 04             	mov    0x4(%eax),%edx
  800994:	8b 00                	mov    (%eax),%eax
  800996:	eb 38                	jmp    8009d0 <getint+0x5d>
	else if (lflag)
  800998:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80099c:	74 1a                	je     8009b8 <getint+0x45>
		return va_arg(*ap, long);
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	8b 00                	mov    (%eax),%eax
  8009a3:	8d 50 04             	lea    0x4(%eax),%edx
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	89 10                	mov    %edx,(%eax)
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	8b 00                	mov    (%eax),%eax
  8009b0:	83 e8 04             	sub    $0x4,%eax
  8009b3:	8b 00                	mov    (%eax),%eax
  8009b5:	99                   	cltd   
  8009b6:	eb 18                	jmp    8009d0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bb:	8b 00                	mov    (%eax),%eax
  8009bd:	8d 50 04             	lea    0x4(%eax),%edx
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	89 10                	mov    %edx,(%eax)
  8009c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c8:	8b 00                	mov    (%eax),%eax
  8009ca:	83 e8 04             	sub    $0x4,%eax
  8009cd:	8b 00                	mov    (%eax),%eax
  8009cf:	99                   	cltd   
}
  8009d0:	5d                   	pop    %ebp
  8009d1:	c3                   	ret    

008009d2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	56                   	push   %esi
  8009d6:	53                   	push   %ebx
  8009d7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009da:	eb 17                	jmp    8009f3 <vprintfmt+0x21>
			if (ch == '\0')
  8009dc:	85 db                	test   %ebx,%ebx
  8009de:	0f 84 c1 03 00 00    	je     800da5 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009e4:	83 ec 08             	sub    $0x8,%esp
  8009e7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ea:	53                   	push   %ebx
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	ff d0                	call   *%eax
  8009f0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f6:	8d 50 01             	lea    0x1(%eax),%edx
  8009f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8009fc:	8a 00                	mov    (%eax),%al
  8009fe:	0f b6 d8             	movzbl %al,%ebx
  800a01:	83 fb 25             	cmp    $0x25,%ebx
  800a04:	75 d6                	jne    8009dc <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a06:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a0a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a11:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a18:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a1f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a26:	8b 45 10             	mov    0x10(%ebp),%eax
  800a29:	8d 50 01             	lea    0x1(%eax),%edx
  800a2c:	89 55 10             	mov    %edx,0x10(%ebp)
  800a2f:	8a 00                	mov    (%eax),%al
  800a31:	0f b6 d8             	movzbl %al,%ebx
  800a34:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a37:	83 f8 5b             	cmp    $0x5b,%eax
  800a3a:	0f 87 3d 03 00 00    	ja     800d7d <vprintfmt+0x3ab>
  800a40:	8b 04 85 78 25 80 00 	mov    0x802578(,%eax,4),%eax
  800a47:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a49:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a4d:	eb d7                	jmp    800a26 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a4f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a53:	eb d1                	jmp    800a26 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a55:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a5c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a5f:	89 d0                	mov    %edx,%eax
  800a61:	c1 e0 02             	shl    $0x2,%eax
  800a64:	01 d0                	add    %edx,%eax
  800a66:	01 c0                	add    %eax,%eax
  800a68:	01 d8                	add    %ebx,%eax
  800a6a:	83 e8 30             	sub    $0x30,%eax
  800a6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a70:	8b 45 10             	mov    0x10(%ebp),%eax
  800a73:	8a 00                	mov    (%eax),%al
  800a75:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a78:	83 fb 2f             	cmp    $0x2f,%ebx
  800a7b:	7e 3e                	jle    800abb <vprintfmt+0xe9>
  800a7d:	83 fb 39             	cmp    $0x39,%ebx
  800a80:	7f 39                	jg     800abb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a82:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a85:	eb d5                	jmp    800a5c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a87:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8a:	83 c0 04             	add    $0x4,%eax
  800a8d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a90:	8b 45 14             	mov    0x14(%ebp),%eax
  800a93:	83 e8 04             	sub    $0x4,%eax
  800a96:	8b 00                	mov    (%eax),%eax
  800a98:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a9b:	eb 1f                	jmp    800abc <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a9d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aa1:	79 83                	jns    800a26 <vprintfmt+0x54>
				width = 0;
  800aa3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800aaa:	e9 77 ff ff ff       	jmp    800a26 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800aaf:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ab6:	e9 6b ff ff ff       	jmp    800a26 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800abb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800abc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac0:	0f 89 60 ff ff ff    	jns    800a26 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ac6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ac9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800acc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ad3:	e9 4e ff ff ff       	jmp    800a26 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ad8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800adb:	e9 46 ff ff ff       	jmp    800a26 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ae0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae3:	83 c0 04             	add    $0x4,%eax
  800ae6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aec:	83 e8 04             	sub    $0x4,%eax
  800aef:	8b 00                	mov    (%eax),%eax
  800af1:	83 ec 08             	sub    $0x8,%esp
  800af4:	ff 75 0c             	pushl  0xc(%ebp)
  800af7:	50                   	push   %eax
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	ff d0                	call   *%eax
  800afd:	83 c4 10             	add    $0x10,%esp
			break;
  800b00:	e9 9b 02 00 00       	jmp    800da0 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b05:	8b 45 14             	mov    0x14(%ebp),%eax
  800b08:	83 c0 04             	add    $0x4,%eax
  800b0b:	89 45 14             	mov    %eax,0x14(%ebp)
  800b0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b11:	83 e8 04             	sub    $0x4,%eax
  800b14:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b16:	85 db                	test   %ebx,%ebx
  800b18:	79 02                	jns    800b1c <vprintfmt+0x14a>
				err = -err;
  800b1a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b1c:	83 fb 64             	cmp    $0x64,%ebx
  800b1f:	7f 0b                	jg     800b2c <vprintfmt+0x15a>
  800b21:	8b 34 9d c0 23 80 00 	mov    0x8023c0(,%ebx,4),%esi
  800b28:	85 f6                	test   %esi,%esi
  800b2a:	75 19                	jne    800b45 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b2c:	53                   	push   %ebx
  800b2d:	68 65 25 80 00       	push   $0x802565
  800b32:	ff 75 0c             	pushl  0xc(%ebp)
  800b35:	ff 75 08             	pushl  0x8(%ebp)
  800b38:	e8 70 02 00 00       	call   800dad <printfmt>
  800b3d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b40:	e9 5b 02 00 00       	jmp    800da0 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b45:	56                   	push   %esi
  800b46:	68 6e 25 80 00       	push   $0x80256e
  800b4b:	ff 75 0c             	pushl  0xc(%ebp)
  800b4e:	ff 75 08             	pushl  0x8(%ebp)
  800b51:	e8 57 02 00 00       	call   800dad <printfmt>
  800b56:	83 c4 10             	add    $0x10,%esp
			break;
  800b59:	e9 42 02 00 00       	jmp    800da0 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b61:	83 c0 04             	add    $0x4,%eax
  800b64:	89 45 14             	mov    %eax,0x14(%ebp)
  800b67:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6a:	83 e8 04             	sub    $0x4,%eax
  800b6d:	8b 30                	mov    (%eax),%esi
  800b6f:	85 f6                	test   %esi,%esi
  800b71:	75 05                	jne    800b78 <vprintfmt+0x1a6>
				p = "(null)";
  800b73:	be 71 25 80 00       	mov    $0x802571,%esi
			if (width > 0 && padc != '-')
  800b78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b7c:	7e 6d                	jle    800beb <vprintfmt+0x219>
  800b7e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b82:	74 67                	je     800beb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	50                   	push   %eax
  800b8b:	56                   	push   %esi
  800b8c:	e8 1e 03 00 00       	call   800eaf <strnlen>
  800b91:	83 c4 10             	add    $0x10,%esp
  800b94:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b97:	eb 16                	jmp    800baf <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b99:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b9d:	83 ec 08             	sub    $0x8,%esp
  800ba0:	ff 75 0c             	pushl  0xc(%ebp)
  800ba3:	50                   	push   %eax
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	ff d0                	call   *%eax
  800ba9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bac:	ff 4d e4             	decl   -0x1c(%ebp)
  800baf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb3:	7f e4                	jg     800b99 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bb5:	eb 34                	jmp    800beb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bb7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bbb:	74 1c                	je     800bd9 <vprintfmt+0x207>
  800bbd:	83 fb 1f             	cmp    $0x1f,%ebx
  800bc0:	7e 05                	jle    800bc7 <vprintfmt+0x1f5>
  800bc2:	83 fb 7e             	cmp    $0x7e,%ebx
  800bc5:	7e 12                	jle    800bd9 <vprintfmt+0x207>
					putch('?', putdat);
  800bc7:	83 ec 08             	sub    $0x8,%esp
  800bca:	ff 75 0c             	pushl  0xc(%ebp)
  800bcd:	6a 3f                	push   $0x3f
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	ff d0                	call   *%eax
  800bd4:	83 c4 10             	add    $0x10,%esp
  800bd7:	eb 0f                	jmp    800be8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bd9:	83 ec 08             	sub    $0x8,%esp
  800bdc:	ff 75 0c             	pushl  0xc(%ebp)
  800bdf:	53                   	push   %ebx
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	ff d0                	call   *%eax
  800be5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800be8:	ff 4d e4             	decl   -0x1c(%ebp)
  800beb:	89 f0                	mov    %esi,%eax
  800bed:	8d 70 01             	lea    0x1(%eax),%esi
  800bf0:	8a 00                	mov    (%eax),%al
  800bf2:	0f be d8             	movsbl %al,%ebx
  800bf5:	85 db                	test   %ebx,%ebx
  800bf7:	74 24                	je     800c1d <vprintfmt+0x24b>
  800bf9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bfd:	78 b8                	js     800bb7 <vprintfmt+0x1e5>
  800bff:	ff 4d e0             	decl   -0x20(%ebp)
  800c02:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c06:	79 af                	jns    800bb7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c08:	eb 13                	jmp    800c1d <vprintfmt+0x24b>
				putch(' ', putdat);
  800c0a:	83 ec 08             	sub    $0x8,%esp
  800c0d:	ff 75 0c             	pushl  0xc(%ebp)
  800c10:	6a 20                	push   $0x20
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	ff d0                	call   *%eax
  800c17:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c1a:	ff 4d e4             	decl   -0x1c(%ebp)
  800c1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c21:	7f e7                	jg     800c0a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c23:	e9 78 01 00 00       	jmp    800da0 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c28:	83 ec 08             	sub    $0x8,%esp
  800c2b:	ff 75 e8             	pushl  -0x18(%ebp)
  800c2e:	8d 45 14             	lea    0x14(%ebp),%eax
  800c31:	50                   	push   %eax
  800c32:	e8 3c fd ff ff       	call   800973 <getint>
  800c37:	83 c4 10             	add    $0x10,%esp
  800c3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c46:	85 d2                	test   %edx,%edx
  800c48:	79 23                	jns    800c6d <vprintfmt+0x29b>
				putch('-', putdat);
  800c4a:	83 ec 08             	sub    $0x8,%esp
  800c4d:	ff 75 0c             	pushl  0xc(%ebp)
  800c50:	6a 2d                	push   $0x2d
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	ff d0                	call   *%eax
  800c57:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c60:	f7 d8                	neg    %eax
  800c62:	83 d2 00             	adc    $0x0,%edx
  800c65:	f7 da                	neg    %edx
  800c67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c6a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c6d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c74:	e9 bc 00 00 00       	jmp    800d35 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c79:	83 ec 08             	sub    $0x8,%esp
  800c7c:	ff 75 e8             	pushl  -0x18(%ebp)
  800c7f:	8d 45 14             	lea    0x14(%ebp),%eax
  800c82:	50                   	push   %eax
  800c83:	e8 84 fc ff ff       	call   80090c <getuint>
  800c88:	83 c4 10             	add    $0x10,%esp
  800c8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c8e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c91:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c98:	e9 98 00 00 00       	jmp    800d35 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c9d:	83 ec 08             	sub    $0x8,%esp
  800ca0:	ff 75 0c             	pushl  0xc(%ebp)
  800ca3:	6a 58                	push   $0x58
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	ff d0                	call   *%eax
  800caa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cad:	83 ec 08             	sub    $0x8,%esp
  800cb0:	ff 75 0c             	pushl  0xc(%ebp)
  800cb3:	6a 58                	push   $0x58
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	ff d0                	call   *%eax
  800cba:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cbd:	83 ec 08             	sub    $0x8,%esp
  800cc0:	ff 75 0c             	pushl  0xc(%ebp)
  800cc3:	6a 58                	push   $0x58
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	ff d0                	call   *%eax
  800cca:	83 c4 10             	add    $0x10,%esp
			break;
  800ccd:	e9 ce 00 00 00       	jmp    800da0 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800cd2:	83 ec 08             	sub    $0x8,%esp
  800cd5:	ff 75 0c             	pushl  0xc(%ebp)
  800cd8:	6a 30                	push   $0x30
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	ff d0                	call   *%eax
  800cdf:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ce2:	83 ec 08             	sub    $0x8,%esp
  800ce5:	ff 75 0c             	pushl  0xc(%ebp)
  800ce8:	6a 78                	push   $0x78
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	ff d0                	call   *%eax
  800cef:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cf2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf5:	83 c0 04             	add    $0x4,%eax
  800cf8:	89 45 14             	mov    %eax,0x14(%ebp)
  800cfb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfe:	83 e8 04             	sub    $0x4,%eax
  800d01:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d0d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d14:	eb 1f                	jmp    800d35 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d16:	83 ec 08             	sub    $0x8,%esp
  800d19:	ff 75 e8             	pushl  -0x18(%ebp)
  800d1c:	8d 45 14             	lea    0x14(%ebp),%eax
  800d1f:	50                   	push   %eax
  800d20:	e8 e7 fb ff ff       	call   80090c <getuint>
  800d25:	83 c4 10             	add    $0x10,%esp
  800d28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d2b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d2e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d35:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d3c:	83 ec 04             	sub    $0x4,%esp
  800d3f:	52                   	push   %edx
  800d40:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d43:	50                   	push   %eax
  800d44:	ff 75 f4             	pushl  -0xc(%ebp)
  800d47:	ff 75 f0             	pushl  -0x10(%ebp)
  800d4a:	ff 75 0c             	pushl  0xc(%ebp)
  800d4d:	ff 75 08             	pushl  0x8(%ebp)
  800d50:	e8 00 fb ff ff       	call   800855 <printnum>
  800d55:	83 c4 20             	add    $0x20,%esp
			break;
  800d58:	eb 46                	jmp    800da0 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d5a:	83 ec 08             	sub    $0x8,%esp
  800d5d:	ff 75 0c             	pushl  0xc(%ebp)
  800d60:	53                   	push   %ebx
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	ff d0                	call   *%eax
  800d66:	83 c4 10             	add    $0x10,%esp
			break;
  800d69:	eb 35                	jmp    800da0 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d6b:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  800d72:	eb 2c                	jmp    800da0 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d74:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  800d7b:	eb 23                	jmp    800da0 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d7d:	83 ec 08             	sub    $0x8,%esp
  800d80:	ff 75 0c             	pushl  0xc(%ebp)
  800d83:	6a 25                	push   $0x25
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	ff d0                	call   *%eax
  800d8a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d8d:	ff 4d 10             	decl   0x10(%ebp)
  800d90:	eb 03                	jmp    800d95 <vprintfmt+0x3c3>
  800d92:	ff 4d 10             	decl   0x10(%ebp)
  800d95:	8b 45 10             	mov    0x10(%ebp),%eax
  800d98:	48                   	dec    %eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	3c 25                	cmp    $0x25,%al
  800d9d:	75 f3                	jne    800d92 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d9f:	90                   	nop
		}
	}
  800da0:	e9 35 fc ff ff       	jmp    8009da <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800da5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800da6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800da9:	5b                   	pop    %ebx
  800daa:	5e                   	pop    %esi
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    

00800dad <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800db3:	8d 45 10             	lea    0x10(%ebp),%eax
  800db6:	83 c0 04             	add    $0x4,%eax
  800db9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800dbc:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbf:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc2:	50                   	push   %eax
  800dc3:	ff 75 0c             	pushl  0xc(%ebp)
  800dc6:	ff 75 08             	pushl  0x8(%ebp)
  800dc9:	e8 04 fc ff ff       	call   8009d2 <vprintfmt>
  800dce:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dd1:	90                   	nop
  800dd2:	c9                   	leave  
  800dd3:	c3                   	ret    

00800dd4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dda:	8b 40 08             	mov    0x8(%eax),%eax
  800ddd:	8d 50 01             	lea    0x1(%eax),%edx
  800de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800de6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de9:	8b 10                	mov    (%eax),%edx
  800deb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dee:	8b 40 04             	mov    0x4(%eax),%eax
  800df1:	39 c2                	cmp    %eax,%edx
  800df3:	73 12                	jae    800e07 <sprintputch+0x33>
		*b->buf++ = ch;
  800df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df8:	8b 00                	mov    (%eax),%eax
  800dfa:	8d 48 01             	lea    0x1(%eax),%ecx
  800dfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e00:	89 0a                	mov    %ecx,(%edx)
  800e02:	8b 55 08             	mov    0x8(%ebp),%edx
  800e05:	88 10                	mov    %dl,(%eax)
}
  800e07:	90                   	nop
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    

00800e0a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e19:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	01 d0                	add    %edx,%eax
  800e21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e2f:	74 06                	je     800e37 <vsnprintf+0x2d>
  800e31:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e35:	7f 07                	jg     800e3e <vsnprintf+0x34>
		return -E_INVAL;
  800e37:	b8 03 00 00 00       	mov    $0x3,%eax
  800e3c:	eb 20                	jmp    800e5e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e3e:	ff 75 14             	pushl  0x14(%ebp)
  800e41:	ff 75 10             	pushl  0x10(%ebp)
  800e44:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e47:	50                   	push   %eax
  800e48:	68 d4 0d 80 00       	push   $0x800dd4
  800e4d:	e8 80 fb ff ff       	call   8009d2 <vprintfmt>
  800e52:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e58:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e5e:	c9                   	leave  
  800e5f:	c3                   	ret    

00800e60 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e66:	8d 45 10             	lea    0x10(%ebp),%eax
  800e69:	83 c0 04             	add    $0x4,%eax
  800e6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e72:	ff 75 f4             	pushl  -0xc(%ebp)
  800e75:	50                   	push   %eax
  800e76:	ff 75 0c             	pushl  0xc(%ebp)
  800e79:	ff 75 08             	pushl  0x8(%ebp)
  800e7c:	e8 89 ff ff ff       	call   800e0a <vsnprintf>
  800e81:	83 c4 10             	add    $0x10,%esp
  800e84:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e87:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e8a:	c9                   	leave  
  800e8b:	c3                   	ret    

00800e8c <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e99:	eb 06                	jmp    800ea1 <strlen+0x15>
		n++;
  800e9b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e9e:	ff 45 08             	incl   0x8(%ebp)
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	8a 00                	mov    (%eax),%al
  800ea6:	84 c0                	test   %al,%al
  800ea8:	75 f1                	jne    800e9b <strlen+0xf>
		n++;
	return n;
  800eaa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ead:	c9                   	leave  
  800eae:	c3                   	ret    

00800eaf <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ebc:	eb 09                	jmp    800ec7 <strnlen+0x18>
		n++;
  800ebe:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ec1:	ff 45 08             	incl   0x8(%ebp)
  800ec4:	ff 4d 0c             	decl   0xc(%ebp)
  800ec7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ecb:	74 09                	je     800ed6 <strnlen+0x27>
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	8a 00                	mov    (%eax),%al
  800ed2:	84 c0                	test   %al,%al
  800ed4:	75 e8                	jne    800ebe <strnlen+0xf>
		n++;
	return n;
  800ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ed9:	c9                   	leave  
  800eda:	c3                   	ret    

00800edb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ee7:	90                   	nop
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8d 50 01             	lea    0x1(%eax),%edx
  800eee:	89 55 08             	mov    %edx,0x8(%ebp)
  800ef1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ef7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800efa:	8a 12                	mov    (%edx),%dl
  800efc:	88 10                	mov    %dl,(%eax)
  800efe:	8a 00                	mov    (%eax),%al
  800f00:	84 c0                	test   %al,%al
  800f02:	75 e4                	jne    800ee8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f04:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f07:	c9                   	leave  
  800f08:	c3                   	ret    

00800f09 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f1c:	eb 1f                	jmp    800f3d <strncpy+0x34>
		*dst++ = *src;
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	8d 50 01             	lea    0x1(%eax),%edx
  800f24:	89 55 08             	mov    %edx,0x8(%ebp)
  800f27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2a:	8a 12                	mov    (%edx),%dl
  800f2c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	84 c0                	test   %al,%al
  800f35:	74 03                	je     800f3a <strncpy+0x31>
			src++;
  800f37:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f3a:	ff 45 fc             	incl   -0x4(%ebp)
  800f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f40:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f43:	72 d9                	jb     800f1e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f45:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f48:	c9                   	leave  
  800f49:	c3                   	ret    

00800f4a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5a:	74 30                	je     800f8c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f5c:	eb 16                	jmp    800f74 <strlcpy+0x2a>
			*dst++ = *src++;
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	8d 50 01             	lea    0x1(%eax),%edx
  800f64:	89 55 08             	mov    %edx,0x8(%ebp)
  800f67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f6a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f6d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f70:	8a 12                	mov    (%edx),%dl
  800f72:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f74:	ff 4d 10             	decl   0x10(%ebp)
  800f77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7b:	74 09                	je     800f86 <strlcpy+0x3c>
  800f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	84 c0                	test   %al,%al
  800f84:	75 d8                	jne    800f5e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f92:	29 c2                	sub    %eax,%edx
  800f94:	89 d0                	mov    %edx,%eax
}
  800f96:	c9                   	leave  
  800f97:	c3                   	ret    

00800f98 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f9b:	eb 06                	jmp    800fa3 <strcmp+0xb>
		p++, q++;
  800f9d:	ff 45 08             	incl   0x8(%ebp)
  800fa0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	84 c0                	test   %al,%al
  800faa:	74 0e                	je     800fba <strcmp+0x22>
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 10                	mov    (%eax),%dl
  800fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb4:	8a 00                	mov    (%eax),%al
  800fb6:	38 c2                	cmp    %al,%dl
  800fb8:	74 e3                	je     800f9d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	0f b6 d0             	movzbl %al,%edx
  800fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc5:	8a 00                	mov    (%eax),%al
  800fc7:	0f b6 c0             	movzbl %al,%eax
  800fca:	29 c2                	sub    %eax,%edx
  800fcc:	89 d0                	mov    %edx,%eax
}
  800fce:	5d                   	pop    %ebp
  800fcf:	c3                   	ret    

00800fd0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fd3:	eb 09                	jmp    800fde <strncmp+0xe>
		n--, p++, q++;
  800fd5:	ff 4d 10             	decl   0x10(%ebp)
  800fd8:	ff 45 08             	incl   0x8(%ebp)
  800fdb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe2:	74 17                	je     800ffb <strncmp+0x2b>
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	84 c0                	test   %al,%al
  800feb:	74 0e                	je     800ffb <strncmp+0x2b>
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	8a 10                	mov    (%eax),%dl
  800ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff5:	8a 00                	mov    (%eax),%al
  800ff7:	38 c2                	cmp    %al,%dl
  800ff9:	74 da                	je     800fd5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ffb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fff:	75 07                	jne    801008 <strncmp+0x38>
		return 0;
  801001:	b8 00 00 00 00       	mov    $0x0,%eax
  801006:	eb 14                	jmp    80101c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
  80100b:	8a 00                	mov    (%eax),%al
  80100d:	0f b6 d0             	movzbl %al,%edx
  801010:	8b 45 0c             	mov    0xc(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	0f b6 c0             	movzbl %al,%eax
  801018:	29 c2                	sub    %eax,%edx
  80101a:	89 d0                	mov    %edx,%eax
}
  80101c:	5d                   	pop    %ebp
  80101d:	c3                   	ret    

0080101e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	83 ec 04             	sub    $0x4,%esp
  801024:	8b 45 0c             	mov    0xc(%ebp),%eax
  801027:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80102a:	eb 12                	jmp    80103e <strchr+0x20>
		if (*s == c)
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801034:	75 05                	jne    80103b <strchr+0x1d>
			return (char *) s;
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	eb 11                	jmp    80104c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80103b:	ff 45 08             	incl   0x8(%ebp)
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	84 c0                	test   %al,%al
  801045:	75 e5                	jne    80102c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801047:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80104c:	c9                   	leave  
  80104d:	c3                   	ret    

0080104e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80104e:	55                   	push   %ebp
  80104f:	89 e5                	mov    %esp,%ebp
  801051:	83 ec 04             	sub    $0x4,%esp
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80105a:	eb 0d                	jmp    801069 <strfind+0x1b>
		if (*s == c)
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801064:	74 0e                	je     801074 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801066:	ff 45 08             	incl   0x8(%ebp)
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	84 c0                	test   %al,%al
  801070:	75 ea                	jne    80105c <strfind+0xe>
  801072:	eb 01                	jmp    801075 <strfind+0x27>
		if (*s == c)
			break;
  801074:	90                   	nop
	return (char *) s;
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801078:	c9                   	leave  
  801079:	c3                   	ret    

0080107a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801086:	8b 45 10             	mov    0x10(%ebp),%eax
  801089:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80108c:	eb 0e                	jmp    80109c <memset+0x22>
		*p++ = c;
  80108e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801091:	8d 50 01             	lea    0x1(%eax),%edx
  801094:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801097:	8b 55 0c             	mov    0xc(%ebp),%edx
  80109a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80109c:	ff 4d f8             	decl   -0x8(%ebp)
  80109f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010a3:	79 e9                	jns    80108e <memset+0x14>
		*p++ = c;

	return v;
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    

008010aa <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010bc:	eb 16                	jmp    8010d4 <memcpy+0x2a>
		*d++ = *s++;
  8010be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c1:	8d 50 01             	lea    0x1(%eax),%edx
  8010c4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010cd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010d0:	8a 12                	mov    (%edx),%dl
  8010d2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010da:	89 55 10             	mov    %edx,0x10(%ebp)
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	75 dd                	jne    8010be <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010e4:	c9                   	leave  
  8010e5:	c3                   	ret    

008010e6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010fe:	73 50                	jae    801150 <memmove+0x6a>
  801100:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801103:	8b 45 10             	mov    0x10(%ebp),%eax
  801106:	01 d0                	add    %edx,%eax
  801108:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80110b:	76 43                	jbe    801150 <memmove+0x6a>
		s += n;
  80110d:	8b 45 10             	mov    0x10(%ebp),%eax
  801110:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801113:	8b 45 10             	mov    0x10(%ebp),%eax
  801116:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801119:	eb 10                	jmp    80112b <memmove+0x45>
			*--d = *--s;
  80111b:	ff 4d f8             	decl   -0x8(%ebp)
  80111e:	ff 4d fc             	decl   -0x4(%ebp)
  801121:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801124:	8a 10                	mov    (%eax),%dl
  801126:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801129:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80112b:	8b 45 10             	mov    0x10(%ebp),%eax
  80112e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801131:	89 55 10             	mov    %edx,0x10(%ebp)
  801134:	85 c0                	test   %eax,%eax
  801136:	75 e3                	jne    80111b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801138:	eb 23                	jmp    80115d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80113a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113d:	8d 50 01             	lea    0x1(%eax),%edx
  801140:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801143:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801146:	8d 4a 01             	lea    0x1(%edx),%ecx
  801149:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80114c:	8a 12                	mov    (%edx),%dl
  80114e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801150:	8b 45 10             	mov    0x10(%ebp),%eax
  801153:	8d 50 ff             	lea    -0x1(%eax),%edx
  801156:	89 55 10             	mov    %edx,0x10(%ebp)
  801159:	85 c0                	test   %eax,%eax
  80115b:	75 dd                	jne    80113a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801160:	c9                   	leave  
  801161:	c3                   	ret    

00801162 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80116e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801171:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801174:	eb 2a                	jmp    8011a0 <memcmp+0x3e>
		if (*s1 != *s2)
  801176:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801179:	8a 10                	mov    (%eax),%dl
  80117b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117e:	8a 00                	mov    (%eax),%al
  801180:	38 c2                	cmp    %al,%dl
  801182:	74 16                	je     80119a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801184:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801187:	8a 00                	mov    (%eax),%al
  801189:	0f b6 d0             	movzbl %al,%edx
  80118c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	0f b6 c0             	movzbl %al,%eax
  801194:	29 c2                	sub    %eax,%edx
  801196:	89 d0                	mov    %edx,%eax
  801198:	eb 18                	jmp    8011b2 <memcmp+0x50>
		s1++, s2++;
  80119a:	ff 45 fc             	incl   -0x4(%ebp)
  80119d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a6:	89 55 10             	mov    %edx,0x10(%ebp)
  8011a9:	85 c0                	test   %eax,%eax
  8011ab:	75 c9                	jne    801176 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011b2:	c9                   	leave  
  8011b3:	c3                   	ret    

008011b4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c0:	01 d0                	add    %edx,%eax
  8011c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011c5:	eb 15                	jmp    8011dc <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	0f b6 d0             	movzbl %al,%edx
  8011cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d2:	0f b6 c0             	movzbl %al,%eax
  8011d5:	39 c2                	cmp    %eax,%edx
  8011d7:	74 0d                	je     8011e6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011d9:	ff 45 08             	incl   0x8(%ebp)
  8011dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011df:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011e2:	72 e3                	jb     8011c7 <memfind+0x13>
  8011e4:	eb 01                	jmp    8011e7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011e6:	90                   	nop
	return (void *) s;
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011ea:	c9                   	leave  
  8011eb:	c3                   	ret    

008011ec <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
  8011ef:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011f9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801200:	eb 03                	jmp    801205 <strtol+0x19>
		s++;
  801202:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	8a 00                	mov    (%eax),%al
  80120a:	3c 20                	cmp    $0x20,%al
  80120c:	74 f4                	je     801202 <strtol+0x16>
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	8a 00                	mov    (%eax),%al
  801213:	3c 09                	cmp    $0x9,%al
  801215:	74 eb                	je     801202 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	3c 2b                	cmp    $0x2b,%al
  80121e:	75 05                	jne    801225 <strtol+0x39>
		s++;
  801220:	ff 45 08             	incl   0x8(%ebp)
  801223:	eb 13                	jmp    801238 <strtol+0x4c>
	else if (*s == '-')
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	3c 2d                	cmp    $0x2d,%al
  80122c:	75 0a                	jne    801238 <strtol+0x4c>
		s++, neg = 1;
  80122e:	ff 45 08             	incl   0x8(%ebp)
  801231:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801238:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80123c:	74 06                	je     801244 <strtol+0x58>
  80123e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801242:	75 20                	jne    801264 <strtol+0x78>
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	8a 00                	mov    (%eax),%al
  801249:	3c 30                	cmp    $0x30,%al
  80124b:	75 17                	jne    801264 <strtol+0x78>
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	40                   	inc    %eax
  801251:	8a 00                	mov    (%eax),%al
  801253:	3c 78                	cmp    $0x78,%al
  801255:	75 0d                	jne    801264 <strtol+0x78>
		s += 2, base = 16;
  801257:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80125b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801262:	eb 28                	jmp    80128c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801264:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801268:	75 15                	jne    80127f <strtol+0x93>
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	3c 30                	cmp    $0x30,%al
  801271:	75 0c                	jne    80127f <strtol+0x93>
		s++, base = 8;
  801273:	ff 45 08             	incl   0x8(%ebp)
  801276:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80127d:	eb 0d                	jmp    80128c <strtol+0xa0>
	else if (base == 0)
  80127f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801283:	75 07                	jne    80128c <strtol+0xa0>
		base = 10;
  801285:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80128c:	8b 45 08             	mov    0x8(%ebp),%eax
  80128f:	8a 00                	mov    (%eax),%al
  801291:	3c 2f                	cmp    $0x2f,%al
  801293:	7e 19                	jle    8012ae <strtol+0xc2>
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	8a 00                	mov    (%eax),%al
  80129a:	3c 39                	cmp    $0x39,%al
  80129c:	7f 10                	jg     8012ae <strtol+0xc2>
			dig = *s - '0';
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	8a 00                	mov    (%eax),%al
  8012a3:	0f be c0             	movsbl %al,%eax
  8012a6:	83 e8 30             	sub    $0x30,%eax
  8012a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012ac:	eb 42                	jmp    8012f0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	8a 00                	mov    (%eax),%al
  8012b3:	3c 60                	cmp    $0x60,%al
  8012b5:	7e 19                	jle    8012d0 <strtol+0xe4>
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	8a 00                	mov    (%eax),%al
  8012bc:	3c 7a                	cmp    $0x7a,%al
  8012be:	7f 10                	jg     8012d0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	8a 00                	mov    (%eax),%al
  8012c5:	0f be c0             	movsbl %al,%eax
  8012c8:	83 e8 57             	sub    $0x57,%eax
  8012cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012ce:	eb 20                	jmp    8012f0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	3c 40                	cmp    $0x40,%al
  8012d7:	7e 39                	jle    801312 <strtol+0x126>
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	3c 5a                	cmp    $0x5a,%al
  8012e0:	7f 30                	jg     801312 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	0f be c0             	movsbl %al,%eax
  8012ea:	83 e8 37             	sub    $0x37,%eax
  8012ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012f3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012f6:	7d 19                	jge    801311 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012f8:	ff 45 08             	incl   0x8(%ebp)
  8012fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012fe:	0f af 45 10          	imul   0x10(%ebp),%eax
  801302:	89 c2                	mov    %eax,%edx
  801304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801307:	01 d0                	add    %edx,%eax
  801309:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80130c:	e9 7b ff ff ff       	jmp    80128c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801311:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801312:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801316:	74 08                	je     801320 <strtol+0x134>
		*endptr = (char *) s;
  801318:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131b:	8b 55 08             	mov    0x8(%ebp),%edx
  80131e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801320:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801324:	74 07                	je     80132d <strtol+0x141>
  801326:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801329:	f7 d8                	neg    %eax
  80132b:	eb 03                	jmp    801330 <strtol+0x144>
  80132d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801330:	c9                   	leave  
  801331:	c3                   	ret    

00801332 <ltostr>:

void
ltostr(long value, char *str)
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
  801335:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801338:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80133f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801346:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80134a:	79 13                	jns    80135f <ltostr+0x2d>
	{
		neg = 1;
  80134c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801353:	8b 45 0c             	mov    0xc(%ebp),%eax
  801356:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801359:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80135c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801367:	99                   	cltd   
  801368:	f7 f9                	idiv   %ecx
  80136a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80136d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801370:	8d 50 01             	lea    0x1(%eax),%edx
  801373:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801376:	89 c2                	mov    %eax,%edx
  801378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137b:	01 d0                	add    %edx,%eax
  80137d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801380:	83 c2 30             	add    $0x30,%edx
  801383:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801385:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801388:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80138d:	f7 e9                	imul   %ecx
  80138f:	c1 fa 02             	sar    $0x2,%edx
  801392:	89 c8                	mov    %ecx,%eax
  801394:	c1 f8 1f             	sar    $0x1f,%eax
  801397:	29 c2                	sub    %eax,%edx
  801399:	89 d0                	mov    %edx,%eax
  80139b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80139e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013a2:	75 bb                	jne    80135f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ae:	48                   	dec    %eax
  8013af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013b6:	74 3d                	je     8013f5 <ltostr+0xc3>
		start = 1 ;
  8013b8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013bf:	eb 34                	jmp    8013f5 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c7:	01 d0                	add    %edx,%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d4:	01 c2                	add    %eax,%edx
  8013d6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dc:	01 c8                	add    %ecx,%eax
  8013de:	8a 00                	mov    (%eax),%al
  8013e0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e8:	01 c2                	add    %eax,%edx
  8013ea:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013ed:	88 02                	mov    %al,(%edx)
		start++ ;
  8013ef:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013f2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013fb:	7c c4                	jl     8013c1 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013fd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801400:	8b 45 0c             	mov    0xc(%ebp),%eax
  801403:	01 d0                	add    %edx,%eax
  801405:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801408:	90                   	nop
  801409:	c9                   	leave  
  80140a:	c3                   	ret    

0080140b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
  80140e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801411:	ff 75 08             	pushl  0x8(%ebp)
  801414:	e8 73 fa ff ff       	call   800e8c <strlen>
  801419:	83 c4 04             	add    $0x4,%esp
  80141c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80141f:	ff 75 0c             	pushl  0xc(%ebp)
  801422:	e8 65 fa ff ff       	call   800e8c <strlen>
  801427:	83 c4 04             	add    $0x4,%esp
  80142a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80142d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801434:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80143b:	eb 17                	jmp    801454 <strcconcat+0x49>
		final[s] = str1[s] ;
  80143d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801440:	8b 45 10             	mov    0x10(%ebp),%eax
  801443:	01 c2                	add    %eax,%edx
  801445:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801448:	8b 45 08             	mov    0x8(%ebp),%eax
  80144b:	01 c8                	add    %ecx,%eax
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801451:	ff 45 fc             	incl   -0x4(%ebp)
  801454:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801457:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80145a:	7c e1                	jl     80143d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80145c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801463:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80146a:	eb 1f                	jmp    80148b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80146c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80146f:	8d 50 01             	lea    0x1(%eax),%edx
  801472:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801475:	89 c2                	mov    %eax,%edx
  801477:	8b 45 10             	mov    0x10(%ebp),%eax
  80147a:	01 c2                	add    %eax,%edx
  80147c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80147f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801482:	01 c8                	add    %ecx,%eax
  801484:	8a 00                	mov    (%eax),%al
  801486:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801488:	ff 45 f8             	incl   -0x8(%ebp)
  80148b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80148e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801491:	7c d9                	jl     80146c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801493:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801496:	8b 45 10             	mov    0x10(%ebp),%eax
  801499:	01 d0                	add    %edx,%eax
  80149b:	c6 00 00             	movb   $0x0,(%eax)
}
  80149e:	90                   	nop
  80149f:	c9                   	leave  
  8014a0:	c3                   	ret    

008014a1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b0:	8b 00                	mov    (%eax),%eax
  8014b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bc:	01 d0                	add    %edx,%eax
  8014be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014c4:	eb 0c                	jmp    8014d2 <strsplit+0x31>
			*string++ = 0;
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	8d 50 01             	lea    0x1(%eax),%edx
  8014cc:	89 55 08             	mov    %edx,0x8(%ebp)
  8014cf:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d5:	8a 00                	mov    (%eax),%al
  8014d7:	84 c0                	test   %al,%al
  8014d9:	74 18                	je     8014f3 <strsplit+0x52>
  8014db:	8b 45 08             	mov    0x8(%ebp),%eax
  8014de:	8a 00                	mov    (%eax),%al
  8014e0:	0f be c0             	movsbl %al,%eax
  8014e3:	50                   	push   %eax
  8014e4:	ff 75 0c             	pushl  0xc(%ebp)
  8014e7:	e8 32 fb ff ff       	call   80101e <strchr>
  8014ec:	83 c4 08             	add    $0x8,%esp
  8014ef:	85 c0                	test   %eax,%eax
  8014f1:	75 d3                	jne    8014c6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	8a 00                	mov    (%eax),%al
  8014f8:	84 c0                	test   %al,%al
  8014fa:	74 5a                	je     801556 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ff:	8b 00                	mov    (%eax),%eax
  801501:	83 f8 0f             	cmp    $0xf,%eax
  801504:	75 07                	jne    80150d <strsplit+0x6c>
		{
			return 0;
  801506:	b8 00 00 00 00       	mov    $0x0,%eax
  80150b:	eb 66                	jmp    801573 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80150d:	8b 45 14             	mov    0x14(%ebp),%eax
  801510:	8b 00                	mov    (%eax),%eax
  801512:	8d 48 01             	lea    0x1(%eax),%ecx
  801515:	8b 55 14             	mov    0x14(%ebp),%edx
  801518:	89 0a                	mov    %ecx,(%edx)
  80151a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801521:	8b 45 10             	mov    0x10(%ebp),%eax
  801524:	01 c2                	add    %eax,%edx
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80152b:	eb 03                	jmp    801530 <strsplit+0x8f>
			string++;
  80152d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
  801533:	8a 00                	mov    (%eax),%al
  801535:	84 c0                	test   %al,%al
  801537:	74 8b                	je     8014c4 <strsplit+0x23>
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	8a 00                	mov    (%eax),%al
  80153e:	0f be c0             	movsbl %al,%eax
  801541:	50                   	push   %eax
  801542:	ff 75 0c             	pushl  0xc(%ebp)
  801545:	e8 d4 fa ff ff       	call   80101e <strchr>
  80154a:	83 c4 08             	add    $0x8,%esp
  80154d:	85 c0                	test   %eax,%eax
  80154f:	74 dc                	je     80152d <strsplit+0x8c>
			string++;
	}
  801551:	e9 6e ff ff ff       	jmp    8014c4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801556:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801557:	8b 45 14             	mov    0x14(%ebp),%eax
  80155a:	8b 00                	mov    (%eax),%eax
  80155c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801563:	8b 45 10             	mov    0x10(%ebp),%eax
  801566:	01 d0                	add    %edx,%eax
  801568:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80156e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801573:	c9                   	leave  
  801574:	c3                   	ret    

00801575 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
  801578:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80157b:	83 ec 04             	sub    $0x4,%esp
  80157e:	68 e8 26 80 00       	push   $0x8026e8
  801583:	68 3f 01 00 00       	push   $0x13f
  801588:	68 0a 27 80 00       	push   $0x80270a
  80158d:	e8 a9 ef ff ff       	call   80053b <_panic>

00801592 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	57                   	push   %edi
  801596:	56                   	push   %esi
  801597:	53                   	push   %ebx
  801598:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80159b:	8b 45 08             	mov    0x8(%ebp),%eax
  80159e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015a4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015a7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015aa:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015ad:	cd 30                	int    $0x30
  8015af:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  8015b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	5b                   	pop    %ebx
  8015b9:	5e                   	pop    %esi
  8015ba:	5f                   	pop    %edi
  8015bb:	5d                   	pop    %ebp
  8015bc:	c3                   	ret    

008015bd <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	83 ec 04             	sub    $0x4,%esp
  8015c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8015c9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	52                   	push   %edx
  8015d5:	ff 75 0c             	pushl  0xc(%ebp)
  8015d8:	50                   	push   %eax
  8015d9:	6a 00                	push   $0x0
  8015db:	e8 b2 ff ff ff       	call   801592 <syscall>
  8015e0:	83 c4 18             	add    $0x18,%esp
}
  8015e3:	90                   	nop
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <sys_cgetc>:

int sys_cgetc(void) {
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 02                	push   $0x2
  8015f5:	e8 98 ff ff ff       	call   801592 <syscall>
  8015fa:	83 c4 18             	add    $0x18,%esp
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <sys_lock_cons>:

void sys_lock_cons(void) {
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 03                	push   $0x3
  80160e:	e8 7f ff ff ff       	call   801592 <syscall>
  801613:	83 c4 18             	add    $0x18,%esp
}
  801616:	90                   	nop
  801617:	c9                   	leave  
  801618:	c3                   	ret    

00801619 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 04                	push   $0x4
  801628:	e8 65 ff ff ff       	call   801592 <syscall>
  80162d:	83 c4 18             	add    $0x18,%esp
}
  801630:	90                   	nop
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801636:	8b 55 0c             	mov    0xc(%ebp),%edx
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	52                   	push   %edx
  801643:	50                   	push   %eax
  801644:	6a 08                	push   $0x8
  801646:	e8 47 ff ff ff       	call   801592 <syscall>
  80164b:	83 c4 18             	add    $0x18,%esp
}
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	56                   	push   %esi
  801654:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801655:	8b 75 18             	mov    0x18(%ebp),%esi
  801658:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80165b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80165e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801661:	8b 45 08             	mov    0x8(%ebp),%eax
  801664:	56                   	push   %esi
  801665:	53                   	push   %ebx
  801666:	51                   	push   %ecx
  801667:	52                   	push   %edx
  801668:	50                   	push   %eax
  801669:	6a 09                	push   $0x9
  80166b:	e8 22 ff ff ff       	call   801592 <syscall>
  801670:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801673:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801676:	5b                   	pop    %ebx
  801677:	5e                   	pop    %esi
  801678:	5d                   	pop    %ebp
  801679:	c3                   	ret    

0080167a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80167d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	52                   	push   %edx
  80168a:	50                   	push   %eax
  80168b:	6a 0a                	push   $0xa
  80168d:	e8 00 ff ff ff       	call   801592 <syscall>
  801692:	83 c4 18             	add    $0x18,%esp
}
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	ff 75 0c             	pushl  0xc(%ebp)
  8016a3:	ff 75 08             	pushl  0x8(%ebp)
  8016a6:	6a 0b                	push   $0xb
  8016a8:	e8 e5 fe ff ff       	call   801592 <syscall>
  8016ad:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 0c                	push   $0xc
  8016c1:	e8 cc fe ff ff       	call   801592 <syscall>
  8016c6:	83 c4 18             	add    $0x18,%esp
}
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 0d                	push   $0xd
  8016da:	e8 b3 fe ff ff       	call   801592 <syscall>
  8016df:	83 c4 18             	add    $0x18,%esp
}
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 0e                	push   $0xe
  8016f3:	e8 9a fe ff ff       	call   801592 <syscall>
  8016f8:	83 c4 18             	add    $0x18,%esp
}
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 0f                	push   $0xf
  80170c:	e8 81 fe ff ff       	call   801592 <syscall>
  801711:	83 c4 18             	add    $0x18,%esp
}
  801714:	c9                   	leave  
  801715:	c3                   	ret    

00801716 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	ff 75 08             	pushl  0x8(%ebp)
  801724:	6a 10                	push   $0x10
  801726:	e8 67 fe ff ff       	call   801592 <syscall>
  80172b:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <sys_scarce_memory>:

void sys_scarce_memory() {
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 11                	push   $0x11
  80173f:	e8 4e fe ff ff       	call   801592 <syscall>
  801744:	83 c4 18             	add    $0x18,%esp
}
  801747:	90                   	nop
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <sys_cputc>:

void sys_cputc(const char c) {
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	83 ec 04             	sub    $0x4,%esp
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
  801753:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801756:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	50                   	push   %eax
  801763:	6a 01                	push   $0x1
  801765:	e8 28 fe ff ff       	call   801592 <syscall>
  80176a:	83 c4 18             	add    $0x18,%esp
}
  80176d:	90                   	nop
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 14                	push   $0x14
  80177f:	e8 0e fe ff ff       	call   801592 <syscall>
  801784:	83 c4 18             	add    $0x18,%esp
}
  801787:	90                   	nop
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	83 ec 04             	sub    $0x4,%esp
  801790:	8b 45 10             	mov    0x10(%ebp),%eax
  801793:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801796:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801799:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	6a 00                	push   $0x0
  8017a2:	51                   	push   %ecx
  8017a3:	52                   	push   %edx
  8017a4:	ff 75 0c             	pushl  0xc(%ebp)
  8017a7:	50                   	push   %eax
  8017a8:	6a 15                	push   $0x15
  8017aa:	e8 e3 fd ff ff       	call   801592 <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  8017b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	52                   	push   %edx
  8017c4:	50                   	push   %eax
  8017c5:	6a 16                	push   $0x16
  8017c7:	e8 c6 fd ff ff       	call   801592 <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  8017d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	51                   	push   %ecx
  8017e2:	52                   	push   %edx
  8017e3:	50                   	push   %eax
  8017e4:	6a 17                	push   $0x17
  8017e6:	e8 a7 fd ff ff       	call   801592 <syscall>
  8017eb:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    

008017f0 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  8017f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	52                   	push   %edx
  801800:	50                   	push   %eax
  801801:	6a 18                	push   $0x18
  801803:	e8 8a fd ff ff       	call   801592 <syscall>
  801808:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	6a 00                	push   $0x0
  801815:	ff 75 14             	pushl  0x14(%ebp)
  801818:	ff 75 10             	pushl  0x10(%ebp)
  80181b:	ff 75 0c             	pushl  0xc(%ebp)
  80181e:	50                   	push   %eax
  80181f:	6a 19                	push   $0x19
  801821:	e8 6c fd ff ff       	call   801592 <syscall>
  801826:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <sys_run_env>:

void sys_run_env(int32 envId) {
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	50                   	push   %eax
  80183a:	6a 1a                	push   $0x1a
  80183c:	e8 51 fd ff ff       	call   801592 <syscall>
  801841:	83 c4 18             	add    $0x18,%esp
}
  801844:	90                   	nop
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	50                   	push   %eax
  801856:	6a 1b                	push   $0x1b
  801858:	e8 35 fd ff ff       	call   801592 <syscall>
  80185d:	83 c4 18             	add    $0x18,%esp
}
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <sys_getenvid>:

int32 sys_getenvid(void) {
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 05                	push   $0x5
  801871:	e8 1c fd ff ff       	call   801592 <syscall>
  801876:	83 c4 18             	add    $0x18,%esp
}
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 06                	push   $0x6
  80188a:	e8 03 fd ff ff       	call   801592 <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 07                	push   $0x7
  8018a3:	e8 ea fc ff ff       	call   801592 <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
}
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <sys_exit_env>:

void sys_exit_env(void) {
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 1c                	push   $0x1c
  8018bc:	e8 d1 fc ff ff       	call   801592 <syscall>
  8018c1:	83 c4 18             	add    $0x18,%esp
}
  8018c4:	90                   	nop
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
  8018ca:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  8018cd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018d0:	8d 50 04             	lea    0x4(%eax),%edx
  8018d3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	52                   	push   %edx
  8018dd:	50                   	push   %eax
  8018de:	6a 1d                	push   $0x1d
  8018e0:	e8 ad fc ff ff       	call   801592 <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  8018e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018f1:	89 01                	mov    %eax,(%ecx)
  8018f3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f9:	c9                   	leave  
  8018fa:	c2 04 00             	ret    $0x4

008018fd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	ff 75 10             	pushl  0x10(%ebp)
  801907:	ff 75 0c             	pushl  0xc(%ebp)
  80190a:	ff 75 08             	pushl  0x8(%ebp)
  80190d:	6a 13                	push   $0x13
  80190f:	e8 7e fc ff ff       	call   801592 <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801917:	90                   	nop
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <sys_rcr2>:
uint32 sys_rcr2() {
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 1e                	push   $0x1e
  801929:	e8 64 fc ff ff       	call   801592 <syscall>
  80192e:	83 c4 18             	add    $0x18,%esp
}
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	83 ec 04             	sub    $0x4,%esp
  801939:	8b 45 08             	mov    0x8(%ebp),%eax
  80193c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80193f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	50                   	push   %eax
  80194c:	6a 1f                	push   $0x1f
  80194e:	e8 3f fc ff ff       	call   801592 <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
	return;
  801956:	90                   	nop
}
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <rsttst>:
void rsttst() {
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 21                	push   $0x21
  801968:	e8 25 fc ff ff       	call   801592 <syscall>
  80196d:	83 c4 18             	add    $0x18,%esp
	return;
  801970:	90                   	nop
}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
  801976:	83 ec 04             	sub    $0x4,%esp
  801979:	8b 45 14             	mov    0x14(%ebp),%eax
  80197c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80197f:	8b 55 18             	mov    0x18(%ebp),%edx
  801982:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801986:	52                   	push   %edx
  801987:	50                   	push   %eax
  801988:	ff 75 10             	pushl  0x10(%ebp)
  80198b:	ff 75 0c             	pushl  0xc(%ebp)
  80198e:	ff 75 08             	pushl  0x8(%ebp)
  801991:	6a 20                	push   $0x20
  801993:	e8 fa fb ff ff       	call   801592 <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
	return;
  80199b:	90                   	nop
}
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <chktst>:
void chktst(uint32 n) {
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	ff 75 08             	pushl  0x8(%ebp)
  8019ac:	6a 22                	push   $0x22
  8019ae:	e8 df fb ff ff       	call   801592 <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
	return;
  8019b6:	90                   	nop
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <inctst>:

void inctst() {
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 23                	push   $0x23
  8019c8:	e8 c5 fb ff ff       	call   801592 <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
	return;
  8019d0:	90                   	nop
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <gettst>:
uint32 gettst() {
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 24                	push   $0x24
  8019e2:	e8 ab fb ff ff       	call   801592 <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
  8019ef:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 25                	push   $0x25
  8019fe:	e8 8f fb ff ff       	call   801592 <syscall>
  801a03:	83 c4 18             	add    $0x18,%esp
  801a06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a09:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a0d:	75 07                	jne    801a16 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a0f:	b8 01 00 00 00       	mov    $0x1,%eax
  801a14:	eb 05                	jmp    801a1b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 25                	push   $0x25
  801a2f:	e8 5e fb ff ff       	call   801592 <syscall>
  801a34:	83 c4 18             	add    $0x18,%esp
  801a37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a3a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a3e:	75 07                	jne    801a47 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a40:	b8 01 00 00 00       	mov    $0x1,%eax
  801a45:	eb 05                	jmp    801a4c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
  801a51:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 25                	push   $0x25
  801a60:	e8 2d fb ff ff       	call   801592 <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
  801a68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a6b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a6f:	75 07                	jne    801a78 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a71:	b8 01 00 00 00       	mov    $0x1,%eax
  801a76:	eb 05                	jmp    801a7d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 25                	push   $0x25
  801a91:	e8 fc fa ff ff       	call   801592 <syscall>
  801a96:	83 c4 18             	add    $0x18,%esp
  801a99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a9c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801aa0:	75 07                	jne    801aa9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801aa2:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa7:	eb 05                	jmp    801aae <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801aa9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	ff 75 08             	pushl  0x8(%ebp)
  801abe:	6a 26                	push   $0x26
  801ac0:	e8 cd fa ff ff       	call   801592 <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
	return;
  801ac8:	90                   	nop
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801acf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ad2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ad5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	6a 00                	push   $0x0
  801add:	53                   	push   %ebx
  801ade:	51                   	push   %ecx
  801adf:	52                   	push   %edx
  801ae0:	50                   	push   %eax
  801ae1:	6a 27                	push   $0x27
  801ae3:	e8 aa fa ff ff       	call   801592 <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801aeb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801af3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	52                   	push   %edx
  801b00:	50                   	push   %eax
  801b01:	6a 28                	push   $0x28
  801b03:	e8 8a fa ff ff       	call   801592 <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801b10:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	6a 00                	push   $0x0
  801b1b:	51                   	push   %ecx
  801b1c:	ff 75 10             	pushl  0x10(%ebp)
  801b1f:	52                   	push   %edx
  801b20:	50                   	push   %eax
  801b21:	6a 29                	push   $0x29
  801b23:	e8 6a fa ff ff       	call   801592 <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	ff 75 10             	pushl  0x10(%ebp)
  801b37:	ff 75 0c             	pushl  0xc(%ebp)
  801b3a:	ff 75 08             	pushl  0x8(%ebp)
  801b3d:	6a 12                	push   $0x12
  801b3f:	e8 4e fa ff ff       	call   801592 <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
	return;
  801b47:	90                   	nop
}
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801b4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	52                   	push   %edx
  801b5a:	50                   	push   %eax
  801b5b:	6a 2a                	push   $0x2a
  801b5d:	e8 30 fa ff ff       	call   801592 <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
	return;
  801b65:	90                   	nop
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	50                   	push   %eax
  801b77:	6a 2b                	push   $0x2b
  801b79:	e8 14 fa ff ff       	call   801592 <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	ff 75 0c             	pushl  0xc(%ebp)
  801b8f:	ff 75 08             	pushl  0x8(%ebp)
  801b92:	6a 2c                	push   $0x2c
  801b94:	e8 f9 f9 ff ff       	call   801592 <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
	return;
  801b9c:	90                   	nop
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	ff 75 0c             	pushl  0xc(%ebp)
  801bab:	ff 75 08             	pushl  0x8(%ebp)
  801bae:	6a 2d                	push   $0x2d
  801bb0:	e8 dd f9 ff ff       	call   801592 <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
	return;
  801bb8:	90                   	nop
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	50                   	push   %eax
  801bca:	6a 2f                	push   $0x2f
  801bcc:	e8 c1 f9 ff ff       	call   801592 <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
	return;
  801bd4:	90                   	nop
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  801bda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	52                   	push   %edx
  801be7:	50                   	push   %eax
  801be8:	6a 30                	push   $0x30
  801bea:	e8 a3 f9 ff ff       	call   801592 <syscall>
  801bef:	83 c4 18             	add    $0x18,%esp
	return;
  801bf2:	90                   	nop
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	50                   	push   %eax
  801c04:	6a 31                	push   $0x31
  801c06:	e8 87 f9 ff ff       	call   801592 <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
	return;
  801c0e:	90                   	nop
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801c14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c17:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	52                   	push   %edx
  801c21:	50                   	push   %eax
  801c22:	6a 2e                	push   $0x2e
  801c24:	e8 69 f9 ff ff       	call   801592 <syscall>
  801c29:	83 c4 18             	add    $0x18,%esp
    return;
  801c2c:	90                   	nop
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    
  801c2f:	90                   	nop

00801c30 <__udivdi3>:
  801c30:	55                   	push   %ebp
  801c31:	57                   	push   %edi
  801c32:	56                   	push   %esi
  801c33:	53                   	push   %ebx
  801c34:	83 ec 1c             	sub    $0x1c,%esp
  801c37:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c3b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c43:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c47:	89 ca                	mov    %ecx,%edx
  801c49:	89 f8                	mov    %edi,%eax
  801c4b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c4f:	85 f6                	test   %esi,%esi
  801c51:	75 2d                	jne    801c80 <__udivdi3+0x50>
  801c53:	39 cf                	cmp    %ecx,%edi
  801c55:	77 65                	ja     801cbc <__udivdi3+0x8c>
  801c57:	89 fd                	mov    %edi,%ebp
  801c59:	85 ff                	test   %edi,%edi
  801c5b:	75 0b                	jne    801c68 <__udivdi3+0x38>
  801c5d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c62:	31 d2                	xor    %edx,%edx
  801c64:	f7 f7                	div    %edi
  801c66:	89 c5                	mov    %eax,%ebp
  801c68:	31 d2                	xor    %edx,%edx
  801c6a:	89 c8                	mov    %ecx,%eax
  801c6c:	f7 f5                	div    %ebp
  801c6e:	89 c1                	mov    %eax,%ecx
  801c70:	89 d8                	mov    %ebx,%eax
  801c72:	f7 f5                	div    %ebp
  801c74:	89 cf                	mov    %ecx,%edi
  801c76:	89 fa                	mov    %edi,%edx
  801c78:	83 c4 1c             	add    $0x1c,%esp
  801c7b:	5b                   	pop    %ebx
  801c7c:	5e                   	pop    %esi
  801c7d:	5f                   	pop    %edi
  801c7e:	5d                   	pop    %ebp
  801c7f:	c3                   	ret    
  801c80:	39 ce                	cmp    %ecx,%esi
  801c82:	77 28                	ja     801cac <__udivdi3+0x7c>
  801c84:	0f bd fe             	bsr    %esi,%edi
  801c87:	83 f7 1f             	xor    $0x1f,%edi
  801c8a:	75 40                	jne    801ccc <__udivdi3+0x9c>
  801c8c:	39 ce                	cmp    %ecx,%esi
  801c8e:	72 0a                	jb     801c9a <__udivdi3+0x6a>
  801c90:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c94:	0f 87 9e 00 00 00    	ja     801d38 <__udivdi3+0x108>
  801c9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9f:	89 fa                	mov    %edi,%edx
  801ca1:	83 c4 1c             	add    $0x1c,%esp
  801ca4:	5b                   	pop    %ebx
  801ca5:	5e                   	pop    %esi
  801ca6:	5f                   	pop    %edi
  801ca7:	5d                   	pop    %ebp
  801ca8:	c3                   	ret    
  801ca9:	8d 76 00             	lea    0x0(%esi),%esi
  801cac:	31 ff                	xor    %edi,%edi
  801cae:	31 c0                	xor    %eax,%eax
  801cb0:	89 fa                	mov    %edi,%edx
  801cb2:	83 c4 1c             	add    $0x1c,%esp
  801cb5:	5b                   	pop    %ebx
  801cb6:	5e                   	pop    %esi
  801cb7:	5f                   	pop    %edi
  801cb8:	5d                   	pop    %ebp
  801cb9:	c3                   	ret    
  801cba:	66 90                	xchg   %ax,%ax
  801cbc:	89 d8                	mov    %ebx,%eax
  801cbe:	f7 f7                	div    %edi
  801cc0:	31 ff                	xor    %edi,%edi
  801cc2:	89 fa                	mov    %edi,%edx
  801cc4:	83 c4 1c             	add    $0x1c,%esp
  801cc7:	5b                   	pop    %ebx
  801cc8:	5e                   	pop    %esi
  801cc9:	5f                   	pop    %edi
  801cca:	5d                   	pop    %ebp
  801ccb:	c3                   	ret    
  801ccc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cd1:	89 eb                	mov    %ebp,%ebx
  801cd3:	29 fb                	sub    %edi,%ebx
  801cd5:	89 f9                	mov    %edi,%ecx
  801cd7:	d3 e6                	shl    %cl,%esi
  801cd9:	89 c5                	mov    %eax,%ebp
  801cdb:	88 d9                	mov    %bl,%cl
  801cdd:	d3 ed                	shr    %cl,%ebp
  801cdf:	89 e9                	mov    %ebp,%ecx
  801ce1:	09 f1                	or     %esi,%ecx
  801ce3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ce7:	89 f9                	mov    %edi,%ecx
  801ce9:	d3 e0                	shl    %cl,%eax
  801ceb:	89 c5                	mov    %eax,%ebp
  801ced:	89 d6                	mov    %edx,%esi
  801cef:	88 d9                	mov    %bl,%cl
  801cf1:	d3 ee                	shr    %cl,%esi
  801cf3:	89 f9                	mov    %edi,%ecx
  801cf5:	d3 e2                	shl    %cl,%edx
  801cf7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cfb:	88 d9                	mov    %bl,%cl
  801cfd:	d3 e8                	shr    %cl,%eax
  801cff:	09 c2                	or     %eax,%edx
  801d01:	89 d0                	mov    %edx,%eax
  801d03:	89 f2                	mov    %esi,%edx
  801d05:	f7 74 24 0c          	divl   0xc(%esp)
  801d09:	89 d6                	mov    %edx,%esi
  801d0b:	89 c3                	mov    %eax,%ebx
  801d0d:	f7 e5                	mul    %ebp
  801d0f:	39 d6                	cmp    %edx,%esi
  801d11:	72 19                	jb     801d2c <__udivdi3+0xfc>
  801d13:	74 0b                	je     801d20 <__udivdi3+0xf0>
  801d15:	89 d8                	mov    %ebx,%eax
  801d17:	31 ff                	xor    %edi,%edi
  801d19:	e9 58 ff ff ff       	jmp    801c76 <__udivdi3+0x46>
  801d1e:	66 90                	xchg   %ax,%ax
  801d20:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d24:	89 f9                	mov    %edi,%ecx
  801d26:	d3 e2                	shl    %cl,%edx
  801d28:	39 c2                	cmp    %eax,%edx
  801d2a:	73 e9                	jae    801d15 <__udivdi3+0xe5>
  801d2c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d2f:	31 ff                	xor    %edi,%edi
  801d31:	e9 40 ff ff ff       	jmp    801c76 <__udivdi3+0x46>
  801d36:	66 90                	xchg   %ax,%ax
  801d38:	31 c0                	xor    %eax,%eax
  801d3a:	e9 37 ff ff ff       	jmp    801c76 <__udivdi3+0x46>
  801d3f:	90                   	nop

00801d40 <__umoddi3>:
  801d40:	55                   	push   %ebp
  801d41:	57                   	push   %edi
  801d42:	56                   	push   %esi
  801d43:	53                   	push   %ebx
  801d44:	83 ec 1c             	sub    $0x1c,%esp
  801d47:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d4b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d4f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d53:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d57:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d5b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d5f:	89 f3                	mov    %esi,%ebx
  801d61:	89 fa                	mov    %edi,%edx
  801d63:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d67:	89 34 24             	mov    %esi,(%esp)
  801d6a:	85 c0                	test   %eax,%eax
  801d6c:	75 1a                	jne    801d88 <__umoddi3+0x48>
  801d6e:	39 f7                	cmp    %esi,%edi
  801d70:	0f 86 a2 00 00 00    	jbe    801e18 <__umoddi3+0xd8>
  801d76:	89 c8                	mov    %ecx,%eax
  801d78:	89 f2                	mov    %esi,%edx
  801d7a:	f7 f7                	div    %edi
  801d7c:	89 d0                	mov    %edx,%eax
  801d7e:	31 d2                	xor    %edx,%edx
  801d80:	83 c4 1c             	add    $0x1c,%esp
  801d83:	5b                   	pop    %ebx
  801d84:	5e                   	pop    %esi
  801d85:	5f                   	pop    %edi
  801d86:	5d                   	pop    %ebp
  801d87:	c3                   	ret    
  801d88:	39 f0                	cmp    %esi,%eax
  801d8a:	0f 87 ac 00 00 00    	ja     801e3c <__umoddi3+0xfc>
  801d90:	0f bd e8             	bsr    %eax,%ebp
  801d93:	83 f5 1f             	xor    $0x1f,%ebp
  801d96:	0f 84 ac 00 00 00    	je     801e48 <__umoddi3+0x108>
  801d9c:	bf 20 00 00 00       	mov    $0x20,%edi
  801da1:	29 ef                	sub    %ebp,%edi
  801da3:	89 fe                	mov    %edi,%esi
  801da5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801da9:	89 e9                	mov    %ebp,%ecx
  801dab:	d3 e0                	shl    %cl,%eax
  801dad:	89 d7                	mov    %edx,%edi
  801daf:	89 f1                	mov    %esi,%ecx
  801db1:	d3 ef                	shr    %cl,%edi
  801db3:	09 c7                	or     %eax,%edi
  801db5:	89 e9                	mov    %ebp,%ecx
  801db7:	d3 e2                	shl    %cl,%edx
  801db9:	89 14 24             	mov    %edx,(%esp)
  801dbc:	89 d8                	mov    %ebx,%eax
  801dbe:	d3 e0                	shl    %cl,%eax
  801dc0:	89 c2                	mov    %eax,%edx
  801dc2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dc6:	d3 e0                	shl    %cl,%eax
  801dc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dcc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dd0:	89 f1                	mov    %esi,%ecx
  801dd2:	d3 e8                	shr    %cl,%eax
  801dd4:	09 d0                	or     %edx,%eax
  801dd6:	d3 eb                	shr    %cl,%ebx
  801dd8:	89 da                	mov    %ebx,%edx
  801dda:	f7 f7                	div    %edi
  801ddc:	89 d3                	mov    %edx,%ebx
  801dde:	f7 24 24             	mull   (%esp)
  801de1:	89 c6                	mov    %eax,%esi
  801de3:	89 d1                	mov    %edx,%ecx
  801de5:	39 d3                	cmp    %edx,%ebx
  801de7:	0f 82 87 00 00 00    	jb     801e74 <__umoddi3+0x134>
  801ded:	0f 84 91 00 00 00    	je     801e84 <__umoddi3+0x144>
  801df3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801df7:	29 f2                	sub    %esi,%edx
  801df9:	19 cb                	sbb    %ecx,%ebx
  801dfb:	89 d8                	mov    %ebx,%eax
  801dfd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e01:	d3 e0                	shl    %cl,%eax
  801e03:	89 e9                	mov    %ebp,%ecx
  801e05:	d3 ea                	shr    %cl,%edx
  801e07:	09 d0                	or     %edx,%eax
  801e09:	89 e9                	mov    %ebp,%ecx
  801e0b:	d3 eb                	shr    %cl,%ebx
  801e0d:	89 da                	mov    %ebx,%edx
  801e0f:	83 c4 1c             	add    $0x1c,%esp
  801e12:	5b                   	pop    %ebx
  801e13:	5e                   	pop    %esi
  801e14:	5f                   	pop    %edi
  801e15:	5d                   	pop    %ebp
  801e16:	c3                   	ret    
  801e17:	90                   	nop
  801e18:	89 fd                	mov    %edi,%ebp
  801e1a:	85 ff                	test   %edi,%edi
  801e1c:	75 0b                	jne    801e29 <__umoddi3+0xe9>
  801e1e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e23:	31 d2                	xor    %edx,%edx
  801e25:	f7 f7                	div    %edi
  801e27:	89 c5                	mov    %eax,%ebp
  801e29:	89 f0                	mov    %esi,%eax
  801e2b:	31 d2                	xor    %edx,%edx
  801e2d:	f7 f5                	div    %ebp
  801e2f:	89 c8                	mov    %ecx,%eax
  801e31:	f7 f5                	div    %ebp
  801e33:	89 d0                	mov    %edx,%eax
  801e35:	e9 44 ff ff ff       	jmp    801d7e <__umoddi3+0x3e>
  801e3a:	66 90                	xchg   %ax,%ax
  801e3c:	89 c8                	mov    %ecx,%eax
  801e3e:	89 f2                	mov    %esi,%edx
  801e40:	83 c4 1c             	add    $0x1c,%esp
  801e43:	5b                   	pop    %ebx
  801e44:	5e                   	pop    %esi
  801e45:	5f                   	pop    %edi
  801e46:	5d                   	pop    %ebp
  801e47:	c3                   	ret    
  801e48:	3b 04 24             	cmp    (%esp),%eax
  801e4b:	72 06                	jb     801e53 <__umoddi3+0x113>
  801e4d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e51:	77 0f                	ja     801e62 <__umoddi3+0x122>
  801e53:	89 f2                	mov    %esi,%edx
  801e55:	29 f9                	sub    %edi,%ecx
  801e57:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e5b:	89 14 24             	mov    %edx,(%esp)
  801e5e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e62:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e66:	8b 14 24             	mov    (%esp),%edx
  801e69:	83 c4 1c             	add    $0x1c,%esp
  801e6c:	5b                   	pop    %ebx
  801e6d:	5e                   	pop    %esi
  801e6e:	5f                   	pop    %edi
  801e6f:	5d                   	pop    %ebp
  801e70:	c3                   	ret    
  801e71:	8d 76 00             	lea    0x0(%esi),%esi
  801e74:	2b 04 24             	sub    (%esp),%eax
  801e77:	19 fa                	sbb    %edi,%edx
  801e79:	89 d1                	mov    %edx,%ecx
  801e7b:	89 c6                	mov    %eax,%esi
  801e7d:	e9 71 ff ff ff       	jmp    801df3 <__umoddi3+0xb3>
  801e82:	66 90                	xchg   %ax,%ax
  801e84:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e88:	72 ea                	jb     801e74 <__umoddi3+0x134>
  801e8a:	89 d9                	mov    %ebx,%ecx
  801e8c:	e9 62 ff ff ff       	jmp    801df3 <__umoddi3+0xb3>
