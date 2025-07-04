
obj/user/tst_placement:     file format elf32-i386


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
  800031:	e8 1e 05 00 00       	call   800554 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
		0x200000, 0x201000, 0x202000, 0x203000, 0x204000, 0x205000, 0x206000,0x207000,	//Data
		0x800000, 0x801000, 0x802000, 0x803000,		//Code
		0xeebfd000, 0xedbfd000 /*will be created during the call of sys_check_WS_list*/} ;//Stack

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 74 00 00 01    	sub    $0x1000074,%esp

	char arr[PAGE_SIZE*1024*4];
	bool found ;
	//("STEP 0: checking Initial WS entries ...\n");
	{
		found = sys_check_WS_list(expectedInitialVAs, 14, 0, 1);
  800042:	6a 01                	push   $0x1
  800044:	6a 00                	push   $0x0
  800046:	6a 0e                	push   $0xe
  800048:	68 00 30 80 00       	push   $0x803000
  80004d:	e8 19 1c 00 00       	call   801c6b <sys_check_WS_list>
  800052:	83 c4 10             	add    $0x10,%esp
  800055:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800058:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80005c:	74 14                	je     800072 <_main+0x3a>
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	68 00 20 80 00       	push   $0x802000
  800066:	6a 15                	push   $0x15
  800068:	68 41 20 80 00       	push   $0x802041
  80006d:	e8 27 06 00 00       	call   800699 <_panic>

		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		if( myEnv->page_last_WS_element !=  NULL)
  800072:	a1 40 30 80 00       	mov    0x803040,%eax
  800077:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
  80007d:	85 c0                	test   %eax,%eax
  80007f:	74 14                	je     800095 <_main+0x5d>
			panic("INITIAL PAGE last WS checking failed! Review size of the WS..!!");
  800081:	83 ec 04             	sub    $0x4,%esp
  800084:	68 58 20 80 00       	push   $0x802058
  800089:	6a 19                	push   $0x19
  80008b:	68 41 20 80 00       	push   $0x802041
  800090:	e8 04 06 00 00       	call   800699 <_panic>
		/*====================================*/
	}
	int eval = 0;
  800095:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  80009c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000a3:	e8 b3 17 00 00       	call   80185b <sys_pf_calculate_allocated_pages>
  8000a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int freePages = sys_calculate_free_frames();
  8000ab:	e8 60 17 00 00       	call   801810 <sys_calculate_free_frames>
  8000b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int i=0;
  8000b3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	for(;i<=PAGE_SIZE;i++)
  8000ba:	eb 11                	jmp    8000cd <_main+0x95>
	{
		arr[i] = 1;
  8000bc:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  8000c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000c5:	01 d0                	add    %edx,%eax
  8000c7:	c6 00 01             	movb   $0x1,(%eax)
	int eval = 0;
	bool is_correct = 1;
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int freePages = sys_calculate_free_frames();
	int i=0;
	for(;i<=PAGE_SIZE;i++)
  8000ca:	ff 45 ec             	incl   -0x14(%ebp)
  8000cd:	81 7d ec 00 10 00 00 	cmpl   $0x1000,-0x14(%ebp)
  8000d4:	7e e6                	jle    8000bc <_main+0x84>
	{
		arr[i] = 1;
	}

	i=PAGE_SIZE*1024;
  8000d6:	c7 45 ec 00 00 40 00 	movl   $0x400000,-0x14(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  8000dd:	eb 11                	jmp    8000f0 <_main+0xb8>
	{
		arr[i] = 2;
  8000df:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  8000e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000e8:	01 d0                	add    %edx,%eax
  8000ea:	c6 00 02             	movb   $0x2,(%eax)
	{
		arr[i] = 1;
	}

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  8000ed:	ff 45 ec             	incl   -0x14(%ebp)
  8000f0:	81 7d ec 00 10 40 00 	cmpl   $0x401000,-0x14(%ebp)
  8000f7:	7e e6                	jle    8000df <_main+0xa7>
	{
		arr[i] = 2;
	}

	i=PAGE_SIZE*1024*2;
  8000f9:	c7 45 ec 00 00 80 00 	movl   $0x800000,-0x14(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800100:	eb 11                	jmp    800113 <_main+0xdb>
	{
		arr[i] = 3;
  800102:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  800108:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80010b:	01 d0                	add    %edx,%eax
  80010d:	c6 00 03             	movb   $0x3,(%eax)
	{
		arr[i] = 2;
	}

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800110:	ff 45 ec             	incl   -0x14(%ebp)
  800113:	81 7d ec 00 10 80 00 	cmpl   $0x801000,-0x14(%ebp)
  80011a:	7e e6                	jle    800102 <_main+0xca>
	{
		arr[i] = 3;
	}

	is_correct = 1;
  80011c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf("STEP A: checking PLACEMENT fault handling... [40%] \n");
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 98 20 80 00       	push   $0x802098
  80012b:	e8 26 08 00 00       	call   800956 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  800133:	8a 85 dc ff ff fe    	mov    -0x1000024(%ebp),%al
  800139:	3c 01                	cmp    $0x1,%al
  80013b:	74 17                	je     800154 <_main+0x11c>
  80013d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	68 d0 20 80 00       	push   $0x8020d0
  80014c:	e8 05 08 00 00       	call   800956 <cprintf>
  800151:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE] !=  1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  800154:	8a 85 dc 0f 00 ff    	mov    -0xfff024(%ebp),%al
  80015a:	3c 01                	cmp    $0x1,%al
  80015c:	74 17                	je     800175 <_main+0x13d>
  80015e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	68 d0 20 80 00       	push   $0x8020d0
  80016d:	e8 e4 07 00 00       	call   800956 <cprintf>
  800172:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024] !=  2)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  800175:	8a 85 dc ff 3f ff    	mov    -0xc00024(%ebp),%al
  80017b:	3c 02                	cmp    $0x2,%al
  80017d:	74 17                	je     800196 <_main+0x15e>
  80017f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	68 d0 20 80 00       	push   $0x8020d0
  80018e:	e8 c3 07 00 00       	call   800956 <cprintf>
  800193:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1025] !=  2)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  800196:	8a 85 dc 0f 40 ff    	mov    -0xbff024(%ebp),%al
  80019c:	3c 02                	cmp    $0x2,%al
  80019e:	74 17                	je     8001b7 <_main+0x17f>
  8001a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	68 d0 20 80 00       	push   $0x8020d0
  8001af:	e8 a2 07 00 00       	call   800956 <cprintf>
  8001b4:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024*2] !=  3)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  8001b7:	8a 85 dc ff 7f ff    	mov    -0x800024(%ebp),%al
  8001bd:	3c 03                	cmp    $0x3,%al
  8001bf:	74 17                	je     8001d8 <_main+0x1a0>
  8001c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	68 d0 20 80 00       	push   $0x8020d0
  8001d0:	e8 81 07 00 00       	call   800956 <cprintf>
  8001d5:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  3)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  8001d8:	8a 85 dc 0f 80 ff    	mov    -0x7ff024(%ebp),%al
  8001de:	3c 03                	cmp    $0x3,%al
  8001e0:	74 17                	je     8001f9 <_main+0x1c1>
  8001e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001e9:	83 ec 0c             	sub    $0xc,%esp
  8001ec:	68 d0 20 80 00       	push   $0x8020d0
  8001f1:	e8 60 07 00 00       	call   800956 <cprintf>
  8001f6:	83 c4 10             	add    $0x10,%esp


		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("new stack pages should NOT be written to Page File until evicted as victim\n");}
  8001f9:	e8 5d 16 00 00       	call   80185b <sys_pf_calculate_allocated_pages>
  8001fe:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800201:	74 17                	je     80021a <_main+0x1e2>
  800203:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80020a:	83 ec 0c             	sub    $0xc,%esp
  80020d:	68 f0 20 80 00       	push   $0x8020f0
  800212:	e8 3f 07 00 00       	call   800956 <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp

		int expected = 5 /*pages*/ + 2 /*tables*/;
  80021a:	c7 45 dc 07 00 00 00 	movl   $0x7,-0x24(%ebp)
		if( (freePages - sys_calculate_free_frames() ) != expected )
  800221:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800224:	e8 e7 15 00 00       	call   801810 <sys_calculate_free_frames>
  800229:	29 c3                	sub    %eax,%ebx
  80022b:	89 da                	mov    %ebx,%edx
  80022d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800230:	39 c2                	cmp    %eax,%edx
  800232:	74 27                	je     80025b <_main+0x223>
		{ is_correct = 0; cprintf("allocated memory size incorrect. Expected Difference = %d, Actual = %d\n", expected, (freePages - sys_calculate_free_frames() ));}
  800234:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80023b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80023e:	e8 cd 15 00 00       	call   801810 <sys_calculate_free_frames>
  800243:	29 c3                	sub    %eax,%ebx
  800245:	89 d8                	mov    %ebx,%eax
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	50                   	push   %eax
  80024b:	ff 75 dc             	pushl  -0x24(%ebp)
  80024e:	68 3c 21 80 00       	push   $0x80213c
  800253:	e8 fe 06 00 00       	call   800956 <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP A finished: PLACEMENT fault handling !\n\n\n");
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 84 21 80 00       	push   $0x802184
  800263:	e8 ee 06 00 00       	call   800956 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp

	if (is_correct)
  80026b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80026f:	74 04                	je     800275 <_main+0x23d>
	{
		eval += 40;
  800271:	83 45 f4 28          	addl   $0x28,-0xc(%ebp)
	}
	is_correct = 1;
  800275:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("STEP B: checking WS entries... [30%]\n");
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	68 b4 21 80 00       	push   $0x8021b4
  800284:	e8 cd 06 00 00       	call   800956 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
		//				0x200000,0x201000,0x202000,0x203000,0x204000,0x205000,0x206000,0x207000,
		//				0x800000,0x801000,0x802000,0x803000,
		//				0xeebfd000,0xedbfd000,0xedbfe000,0xedffd000,0xedffe000,0xee3fd000,0xee3fe000};
		uint32 expectedPages[19] ;
		{
			expectedPages[0] = 0x200000 ;
  80028c:	c7 85 90 ff ff fe 00 	movl   $0x200000,-0x1000070(%ebp)
  800293:	00 20 00 
			expectedPages[1] = 0x201000 ;
  800296:	c7 85 94 ff ff fe 00 	movl   $0x201000,-0x100006c(%ebp)
  80029d:	10 20 00 
			expectedPages[2] = 0x202000 ;
  8002a0:	c7 85 98 ff ff fe 00 	movl   $0x202000,-0x1000068(%ebp)
  8002a7:	20 20 00 
			expectedPages[3] = 0x203000 ;
  8002aa:	c7 85 9c ff ff fe 00 	movl   $0x203000,-0x1000064(%ebp)
  8002b1:	30 20 00 
			expectedPages[4] = 0x204000 ;
  8002b4:	c7 85 a0 ff ff fe 00 	movl   $0x204000,-0x1000060(%ebp)
  8002bb:	40 20 00 
			expectedPages[5] = 0x205000 ;
  8002be:	c7 85 a4 ff ff fe 00 	movl   $0x205000,-0x100005c(%ebp)
  8002c5:	50 20 00 
			expectedPages[6] = 0x206000 ;
  8002c8:	c7 85 a8 ff ff fe 00 	movl   $0x206000,-0x1000058(%ebp)
  8002cf:	60 20 00 
			expectedPages[7] = 0x207000 ;
  8002d2:	c7 85 ac ff ff fe 00 	movl   $0x207000,-0x1000054(%ebp)
  8002d9:	70 20 00 
			expectedPages[8] = 0x800000 ;
  8002dc:	c7 85 b0 ff ff fe 00 	movl   $0x800000,-0x1000050(%ebp)
  8002e3:	00 80 00 
			expectedPages[9] = 0x801000 ;
  8002e6:	c7 85 b4 ff ff fe 00 	movl   $0x801000,-0x100004c(%ebp)
  8002ed:	10 80 00 
			expectedPages[10] = 0x802000 ;
  8002f0:	c7 85 b8 ff ff fe 00 	movl   $0x802000,-0x1000048(%ebp)
  8002f7:	20 80 00 
			expectedPages[11] = 0x803000 ;
  8002fa:	c7 85 bc ff ff fe 00 	movl   $0x803000,-0x1000044(%ebp)
  800301:	30 80 00 
			expectedPages[12] = 0xeebfd000 ;
  800304:	c7 85 c0 ff ff fe 00 	movl   $0xeebfd000,-0x1000040(%ebp)
  80030b:	d0 bf ee 
			expectedPages[13] = 0xedbfd000 ;
  80030e:	c7 85 c4 ff ff fe 00 	movl   $0xedbfd000,-0x100003c(%ebp)
  800315:	d0 bf ed 
			expectedPages[14] = 0xedbfe000 ;
  800318:	c7 85 c8 ff ff fe 00 	movl   $0xedbfe000,-0x1000038(%ebp)
  80031f:	e0 bf ed 
			expectedPages[15] = 0xedffd000 ;
  800322:	c7 85 cc ff ff fe 00 	movl   $0xedffd000,-0x1000034(%ebp)
  800329:	d0 ff ed 
			expectedPages[16] = 0xedffe000 ;
  80032c:	c7 85 d0 ff ff fe 00 	movl   $0xedffe000,-0x1000030(%ebp)
  800333:	e0 ff ed 
			expectedPages[17] = 0xee3fd000 ;
  800336:	c7 85 d4 ff ff fe 00 	movl   $0xee3fd000,-0x100002c(%ebp)
  80033d:	d0 3f ee 
			expectedPages[18] = 0xee3fe000 ;
  800340:	c7 85 d8 ff ff fe 00 	movl   $0xee3fe000,-0x1000028(%ebp)
  800347:	e0 3f ee 
		}
		found = sys_check_WS_list(expectedPages, 19, 0, 1);
  80034a:	6a 01                	push   $0x1
  80034c:	6a 00                	push   $0x0
  80034e:	6a 13                	push   $0x13
  800350:	8d 85 90 ff ff fe    	lea    -0x1000070(%ebp),%eax
  800356:	50                   	push   %eax
  800357:	e8 0f 19 00 00       	call   801c6b <sys_check_WS_list>
  80035c:	83 c4 10             	add    $0x10,%esp
  80035f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (found != 1)
  800362:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  800366:	74 17                	je     80037f <_main+0x347>
		{ is_correct = 0; cprintf("PAGE WS entry checking failed... trace it by printing page WS before & after fault\n");}
  800368:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80036f:	83 ec 0c             	sub    $0xc,%esp
  800372:	68 dc 21 80 00       	push   $0x8021dc
  800377:	e8 da 05 00 00       	call   800956 <cprintf>
  80037c:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP B finished: WS entries test \n\n\n");
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 30 22 80 00       	push   $0x802230
  800387:	e8 ca 05 00 00       	call   800956 <cprintf>
  80038c:	83 c4 10             	add    $0x10,%esp
	if (is_correct)
  80038f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800393:	74 04                	je     800399 <_main+0x361>
	{
		eval += 30;
  800395:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	}
	is_correct = 1;
  800399:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf("STEP C: checking working sets WHEN BECOMES FULL... [30%]\n");
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	68 58 22 80 00       	push   $0x802258
  8003a8:	e8 a9 05 00 00       	call   800956 <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp
	{
		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		if(myEnv->page_last_WS_element != NULL)
  8003b0:	a1 40 30 80 00       	mov    0x803040,%eax
  8003b5:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
  8003bb:	85 c0                	test   %eax,%eax
  8003bd:	74 17                	je     8003d6 <_main+0x39e>
		{ is_correct = 0; cprintf("wrong PAGE WS pointer location... trace it by printing page WS before & after fault\n");}
  8003bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003c6:	83 ec 0c             	sub    $0xc,%esp
  8003c9:	68 94 22 80 00       	push   $0x802294
  8003ce:	e8 83 05 00 00       	call   800956 <cprintf>
  8003d3:	83 c4 10             	add    $0x10,%esp

		i=PAGE_SIZE*1024*3;
  8003d6:	c7 45 ec 00 00 c0 00 	movl   $0xc00000,-0x14(%ebp)
		for(;i<=(PAGE_SIZE*1024*3);i++)
  8003dd:	eb 11                	jmp    8003f0 <_main+0x3b8>
		{
			arr[i] = 4;
  8003df:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  8003e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e8:	01 d0                	add    %edx,%eax
  8003ea:	c6 00 04             	movb   $0x4,(%eax)
		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		if(myEnv->page_last_WS_element != NULL)
		{ is_correct = 0; cprintf("wrong PAGE WS pointer location... trace it by printing page WS before & after fault\n");}

		i=PAGE_SIZE*1024*3;
		for(;i<=(PAGE_SIZE*1024*3);i++)
  8003ed:	ff 45 ec             	incl   -0x14(%ebp)
  8003f0:	81 7d ec 00 00 c0 00 	cmpl   $0xc00000,-0x14(%ebp)
  8003f7:	7e e6                	jle    8003df <_main+0x3a7>
		{
			arr[i] = 4;
		}

		if( arr[PAGE_SIZE*1024*3] != 4)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  8003f9:	8a 85 dc ff bf ff    	mov    -0x400024(%ebp),%al
  8003ff:	3c 04                	cmp    $0x4,%al
  800401:	74 17                	je     80041a <_main+0x3e2>
  800403:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80040a:	83 ec 0c             	sub    $0xc,%esp
  80040d:	68 d0 20 80 00       	push   $0x8020d0
  800412:	e8 3f 05 00 00       	call   800956 <cprintf>
  800417:	83 c4 10             	add    $0x10,%esp
//				0x200000,0x201000,0x202000,0x203000,0x204000,0x205000,0x206000,0x207000,
//				0x800000,0x801000,0x802000,0x803000,
//				0xeebfd000,0xedbfd000,0xedbfe000,0xedffd000,0xedffe000,0xee3fd000,0xee3fe000,0xee7fd000};
		uint32 expectedPages[19] ;
		{
			expectedPages[0] = 0x200000 ;
  80041a:	c7 85 90 ff ff fe 00 	movl   $0x200000,-0x1000070(%ebp)
  800421:	00 20 00 
			expectedPages[1] = 0x201000 ;
  800424:	c7 85 94 ff ff fe 00 	movl   $0x201000,-0x100006c(%ebp)
  80042b:	10 20 00 
			expectedPages[2] = 0x202000 ;
  80042e:	c7 85 98 ff ff fe 00 	movl   $0x202000,-0x1000068(%ebp)
  800435:	20 20 00 
			expectedPages[3] = 0x203000 ;
  800438:	c7 85 9c ff ff fe 00 	movl   $0x203000,-0x1000064(%ebp)
  80043f:	30 20 00 
			expectedPages[4] = 0x204000 ;
  800442:	c7 85 a0 ff ff fe 00 	movl   $0x204000,-0x1000060(%ebp)
  800449:	40 20 00 
			expectedPages[5] = 0x205000 ;
  80044c:	c7 85 a4 ff ff fe 00 	movl   $0x205000,-0x100005c(%ebp)
  800453:	50 20 00 
			expectedPages[6] = 0x206000 ;
  800456:	c7 85 a8 ff ff fe 00 	movl   $0x206000,-0x1000058(%ebp)
  80045d:	60 20 00 
			expectedPages[7] = 0x207000 ;
  800460:	c7 85 ac ff ff fe 00 	movl   $0x207000,-0x1000054(%ebp)
  800467:	70 20 00 
			expectedPages[8] = 0x800000 ;
  80046a:	c7 85 b0 ff ff fe 00 	movl   $0x800000,-0x1000050(%ebp)
  800471:	00 80 00 
			expectedPages[9] = 0x801000 ;
  800474:	c7 85 b4 ff ff fe 00 	movl   $0x801000,-0x100004c(%ebp)
  80047b:	10 80 00 
			expectedPages[10] = 0x802000 ;
  80047e:	c7 85 b8 ff ff fe 00 	movl   $0x802000,-0x1000048(%ebp)
  800485:	20 80 00 
			expectedPages[11] = 0x803000 ;
  800488:	c7 85 bc ff ff fe 00 	movl   $0x803000,-0x1000044(%ebp)
  80048f:	30 80 00 
			expectedPages[12] = 0xeebfd000 ;
  800492:	c7 85 c0 ff ff fe 00 	movl   $0xeebfd000,-0x1000040(%ebp)
  800499:	d0 bf ee 
			expectedPages[13] = 0xedbfd000 ;
  80049c:	c7 85 c4 ff ff fe 00 	movl   $0xedbfd000,-0x100003c(%ebp)
  8004a3:	d0 bf ed 
			expectedPages[14] = 0xedbfe000 ;
  8004a6:	c7 85 c8 ff ff fe 00 	movl   $0xedbfe000,-0x1000038(%ebp)
  8004ad:	e0 bf ed 
			expectedPages[15] = 0xedffd000 ;
  8004b0:	c7 85 cc ff ff fe 00 	movl   $0xedffd000,-0x1000034(%ebp)
  8004b7:	d0 ff ed 
			expectedPages[16] = 0xedffe000 ;
  8004ba:	c7 85 d0 ff ff fe 00 	movl   $0xedffe000,-0x1000030(%ebp)
  8004c1:	e0 ff ed 
			expectedPages[17] = 0xee3fd000 ;
  8004c4:	c7 85 d4 ff ff fe 00 	movl   $0xee3fd000,-0x100002c(%ebp)
  8004cb:	d0 3f ee 
			expectedPages[18] = 0xee3fe000 ;
  8004ce:	c7 85 d8 ff ff fe 00 	movl   $0xee3fe000,-0x1000028(%ebp)
  8004d5:	e0 3f ee 
			expectedPages[19] = 0xee7fd000 ;
  8004d8:	c7 85 dc ff ff fe 00 	movl   $0xee7fd000,-0x1000024(%ebp)
  8004df:	d0 7f ee 
		}
		found = sys_check_WS_list(expectedPages, 20, 0x200000, 1);
  8004e2:	6a 01                	push   $0x1
  8004e4:	68 00 00 20 00       	push   $0x200000
  8004e9:	6a 14                	push   $0x14
  8004eb:	8d 85 90 ff ff fe    	lea    -0x1000070(%ebp),%eax
  8004f1:	50                   	push   %eax
  8004f2:	e8 74 17 00 00       	call   801c6b <sys_check_WS_list>
  8004f7:	83 c4 10             	add    $0x10,%esp
  8004fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (found != 1)
  8004fd:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  800501:	74 17                	je     80051a <_main+0x4e2>
		{ is_correct = 0; cprintf("PAGE WS entry checking failed... trace it by printing page WS before & after fault\n");}
  800503:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80050a:	83 ec 0c             	sub    $0xc,%esp
  80050d:	68 dc 21 80 00       	push   $0x8021dc
  800512:	e8 3f 04 00 00       	call   800956 <cprintf>
  800517:	83 c4 10             	add    $0x10,%esp
		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		//if(myEnv->page_last_WS_index != 0) { is_correct = 0; cprintf("wrong PAGE WS pointer location... trace it by printing page WS before & after fault\n");}

	}
	cprintf("STEP C finished: WS is FULL now\n\n\n");
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	68 ec 22 80 00       	push   $0x8022ec
  800522:	e8 2f 04 00 00       	call   800956 <cprintf>
  800527:	83 c4 10             	add    $0x10,%esp
	if (is_correct)
  80052a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80052e:	74 04                	je     800534 <_main+0x4fc>
	{
		eval += 30;
  800530:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	}
	is_correct = 1;
  800534:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf("%~\nTest of PAGE PLACEMENT completed. Eval = %d\n\n", eval);
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	ff 75 f4             	pushl  -0xc(%ebp)
  800541:	68 10 23 80 00       	push   $0x802310
  800546:	e8 0b 04 00 00       	call   800956 <cprintf>
  80054b:	83 c4 10             	add    $0x10,%esp

	return;
  80054e:	90                   	nop
#endif
}
  80054f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800552:	c9                   	leave  
  800553:	c3                   	ret    

00800554 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800554:	55                   	push   %ebp
  800555:	89 e5                	mov    %esp,%ebp
  800557:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80055a:	e8 7a 14 00 00       	call   8019d9 <sys_getenvindex>
  80055f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800562:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800565:	89 d0                	mov    %edx,%eax
  800567:	c1 e0 02             	shl    $0x2,%eax
  80056a:	01 d0                	add    %edx,%eax
  80056c:	c1 e0 03             	shl    $0x3,%eax
  80056f:	01 d0                	add    %edx,%eax
  800571:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800578:	01 d0                	add    %edx,%eax
  80057a:	c1 e0 02             	shl    $0x2,%eax
  80057d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800582:	a3 40 30 80 00       	mov    %eax,0x803040

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800587:	a1 40 30 80 00       	mov    0x803040,%eax
  80058c:	8a 40 20             	mov    0x20(%eax),%al
  80058f:	84 c0                	test   %al,%al
  800591:	74 0d                	je     8005a0 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800593:	a1 40 30 80 00       	mov    0x803040,%eax
  800598:	83 c0 20             	add    $0x20,%eax
  80059b:	a3 3c 30 80 00       	mov    %eax,0x80303c

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005a4:	7e 0a                	jle    8005b0 <libmain+0x5c>
		binaryname = argv[0];
  8005a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	a3 3c 30 80 00       	mov    %eax,0x80303c

	// call user main routine
	_main(argc, argv);
  8005b0:	83 ec 08             	sub    $0x8,%esp
  8005b3:	ff 75 0c             	pushl  0xc(%ebp)
  8005b6:	ff 75 08             	pushl  0x8(%ebp)
  8005b9:	e8 7a fa ff ff       	call   800038 <_main>
  8005be:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8005c1:	a1 38 30 80 00       	mov    0x803038,%eax
  8005c6:	85 c0                	test   %eax,%eax
  8005c8:	0f 84 9f 00 00 00    	je     80066d <libmain+0x119>
	{
		sys_lock_cons();
  8005ce:	e8 8a 11 00 00       	call   80175d <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8005d3:	83 ec 0c             	sub    $0xc,%esp
  8005d6:	68 5c 23 80 00       	push   $0x80235c
  8005db:	e8 76 03 00 00       	call   800956 <cprintf>
  8005e0:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005e3:	a1 40 30 80 00       	mov    0x803040,%eax
  8005e8:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8005ee:	a1 40 30 80 00       	mov    0x803040,%eax
  8005f3:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8005f9:	83 ec 04             	sub    $0x4,%esp
  8005fc:	52                   	push   %edx
  8005fd:	50                   	push   %eax
  8005fe:	68 84 23 80 00       	push   $0x802384
  800603:	e8 4e 03 00 00       	call   800956 <cprintf>
  800608:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80060b:	a1 40 30 80 00       	mov    0x803040,%eax
  800610:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800616:	a1 40 30 80 00       	mov    0x803040,%eax
  80061b:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800621:	a1 40 30 80 00       	mov    0x803040,%eax
  800626:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80062c:	51                   	push   %ecx
  80062d:	52                   	push   %edx
  80062e:	50                   	push   %eax
  80062f:	68 ac 23 80 00       	push   $0x8023ac
  800634:	e8 1d 03 00 00       	call   800956 <cprintf>
  800639:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80063c:	a1 40 30 80 00       	mov    0x803040,%eax
  800641:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800647:	83 ec 08             	sub    $0x8,%esp
  80064a:	50                   	push   %eax
  80064b:	68 04 24 80 00       	push   $0x802404
  800650:	e8 01 03 00 00       	call   800956 <cprintf>
  800655:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	68 5c 23 80 00       	push   $0x80235c
  800660:	e8 f1 02 00 00       	call   800956 <cprintf>
  800665:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800668:	e8 0a 11 00 00       	call   801777 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80066d:	e8 19 00 00 00       	call   80068b <exit>
}
  800672:	90                   	nop
  800673:	c9                   	leave  
  800674:	c3                   	ret    

00800675 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800675:	55                   	push   %ebp
  800676:	89 e5                	mov    %esp,%ebp
  800678:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80067b:	83 ec 0c             	sub    $0xc,%esp
  80067e:	6a 00                	push   $0x0
  800680:	e8 20 13 00 00       	call   8019a5 <sys_destroy_env>
  800685:	83 c4 10             	add    $0x10,%esp
}
  800688:	90                   	nop
  800689:	c9                   	leave  
  80068a:	c3                   	ret    

0080068b <exit>:

void
exit(void)
{
  80068b:	55                   	push   %ebp
  80068c:	89 e5                	mov    %esp,%ebp
  80068e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800691:	e8 75 13 00 00       	call   801a0b <sys_exit_env>
}
  800696:	90                   	nop
  800697:	c9                   	leave  
  800698:	c3                   	ret    

00800699 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800699:	55                   	push   %ebp
  80069a:	89 e5                	mov    %esp,%ebp
  80069c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80069f:	8d 45 10             	lea    0x10(%ebp),%eax
  8006a2:	83 c0 04             	add    $0x4,%eax
  8006a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006a8:	a1 60 30 80 00       	mov    0x803060,%eax
  8006ad:	85 c0                	test   %eax,%eax
  8006af:	74 16                	je     8006c7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006b1:	a1 60 30 80 00       	mov    0x803060,%eax
  8006b6:	83 ec 08             	sub    $0x8,%esp
  8006b9:	50                   	push   %eax
  8006ba:	68 18 24 80 00       	push   $0x802418
  8006bf:	e8 92 02 00 00       	call   800956 <cprintf>
  8006c4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006c7:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8006cc:	ff 75 0c             	pushl  0xc(%ebp)
  8006cf:	ff 75 08             	pushl  0x8(%ebp)
  8006d2:	50                   	push   %eax
  8006d3:	68 1d 24 80 00       	push   $0x80241d
  8006d8:	e8 79 02 00 00       	call   800956 <cprintf>
  8006dd:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8006e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8006e3:	83 ec 08             	sub    $0x8,%esp
  8006e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8006e9:	50                   	push   %eax
  8006ea:	e8 fc 01 00 00       	call   8008eb <vcprintf>
  8006ef:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8006f2:	83 ec 08             	sub    $0x8,%esp
  8006f5:	6a 00                	push   $0x0
  8006f7:	68 39 24 80 00       	push   $0x802439
  8006fc:	e8 ea 01 00 00       	call   8008eb <vcprintf>
  800701:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800704:	e8 82 ff ff ff       	call   80068b <exit>

	// should not return here
	while (1) ;
  800709:	eb fe                	jmp    800709 <_panic+0x70>

0080070b <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80070b:	55                   	push   %ebp
  80070c:	89 e5                	mov    %esp,%ebp
  80070e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800711:	a1 40 30 80 00       	mov    0x803040,%eax
  800716:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80071c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80071f:	39 c2                	cmp    %eax,%edx
  800721:	74 14                	je     800737 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800723:	83 ec 04             	sub    $0x4,%esp
  800726:	68 3c 24 80 00       	push   $0x80243c
  80072b:	6a 26                	push   $0x26
  80072d:	68 88 24 80 00       	push   $0x802488
  800732:	e8 62 ff ff ff       	call   800699 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800737:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80073e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800745:	e9 c5 00 00 00       	jmp    80080f <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80074a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80074d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800754:	8b 45 08             	mov    0x8(%ebp),%eax
  800757:	01 d0                	add    %edx,%eax
  800759:	8b 00                	mov    (%eax),%eax
  80075b:	85 c0                	test   %eax,%eax
  80075d:	75 08                	jne    800767 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80075f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800762:	e9 a5 00 00 00       	jmp    80080c <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800767:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80076e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800775:	eb 69                	jmp    8007e0 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800777:	a1 40 30 80 00       	mov    0x803040,%eax
  80077c:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800782:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800785:	89 d0                	mov    %edx,%eax
  800787:	01 c0                	add    %eax,%eax
  800789:	01 d0                	add    %edx,%eax
  80078b:	c1 e0 03             	shl    $0x3,%eax
  80078e:	01 c8                	add    %ecx,%eax
  800790:	8a 40 04             	mov    0x4(%eax),%al
  800793:	84 c0                	test   %al,%al
  800795:	75 46                	jne    8007dd <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800797:	a1 40 30 80 00       	mov    0x803040,%eax
  80079c:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8007a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007a5:	89 d0                	mov    %edx,%eax
  8007a7:	01 c0                	add    %eax,%eax
  8007a9:	01 d0                	add    %edx,%eax
  8007ab:	c1 e0 03             	shl    $0x3,%eax
  8007ae:	01 c8                	add    %ecx,%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007bd:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cc:	01 c8                	add    %ecx,%eax
  8007ce:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007d0:	39 c2                	cmp    %eax,%edx
  8007d2:	75 09                	jne    8007dd <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8007d4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8007db:	eb 15                	jmp    8007f2 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007dd:	ff 45 e8             	incl   -0x18(%ebp)
  8007e0:	a1 40 30 80 00       	mov    0x803040,%eax
  8007e5:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8007eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007ee:	39 c2                	cmp    %eax,%edx
  8007f0:	77 85                	ja     800777 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8007f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8007f6:	75 14                	jne    80080c <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8007f8:	83 ec 04             	sub    $0x4,%esp
  8007fb:	68 94 24 80 00       	push   $0x802494
  800800:	6a 3a                	push   $0x3a
  800802:	68 88 24 80 00       	push   $0x802488
  800807:	e8 8d fe ff ff       	call   800699 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80080c:	ff 45 f0             	incl   -0x10(%ebp)
  80080f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800812:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800815:	0f 8c 2f ff ff ff    	jl     80074a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80081b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800822:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800829:	eb 26                	jmp    800851 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80082b:	a1 40 30 80 00       	mov    0x803040,%eax
  800830:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800836:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800839:	89 d0                	mov    %edx,%eax
  80083b:	01 c0                	add    %eax,%eax
  80083d:	01 d0                	add    %edx,%eax
  80083f:	c1 e0 03             	shl    $0x3,%eax
  800842:	01 c8                	add    %ecx,%eax
  800844:	8a 40 04             	mov    0x4(%eax),%al
  800847:	3c 01                	cmp    $0x1,%al
  800849:	75 03                	jne    80084e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80084b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80084e:	ff 45 e0             	incl   -0x20(%ebp)
  800851:	a1 40 30 80 00       	mov    0x803040,%eax
  800856:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80085c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80085f:	39 c2                	cmp    %eax,%edx
  800861:	77 c8                	ja     80082b <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800866:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800869:	74 14                	je     80087f <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80086b:	83 ec 04             	sub    $0x4,%esp
  80086e:	68 e8 24 80 00       	push   $0x8024e8
  800873:	6a 44                	push   $0x44
  800875:	68 88 24 80 00       	push   $0x802488
  80087a:	e8 1a fe ff ff       	call   800699 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80087f:	90                   	nop
  800880:	c9                   	leave  
  800881:	c3                   	ret    

00800882 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800888:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088b:	8b 00                	mov    (%eax),%eax
  80088d:	8d 48 01             	lea    0x1(%eax),%ecx
  800890:	8b 55 0c             	mov    0xc(%ebp),%edx
  800893:	89 0a                	mov    %ecx,(%edx)
  800895:	8b 55 08             	mov    0x8(%ebp),%edx
  800898:	88 d1                	mov    %dl,%cl
  80089a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80089d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a4:	8b 00                	mov    (%eax),%eax
  8008a6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008ab:	75 2c                	jne    8008d9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008ad:	a0 44 30 80 00       	mov    0x803044,%al
  8008b2:	0f b6 c0             	movzbl %al,%eax
  8008b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b8:	8b 12                	mov    (%edx),%edx
  8008ba:	89 d1                	mov    %edx,%ecx
  8008bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bf:	83 c2 08             	add    $0x8,%edx
  8008c2:	83 ec 04             	sub    $0x4,%esp
  8008c5:	50                   	push   %eax
  8008c6:	51                   	push   %ecx
  8008c7:	52                   	push   %edx
  8008c8:	e8 4e 0e 00 00       	call   80171b <sys_cputs>
  8008cd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8008d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008dc:	8b 40 04             	mov    0x4(%eax),%eax
  8008df:	8d 50 01             	lea    0x1(%eax),%edx
  8008e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8008e8:	90                   	nop
  8008e9:	c9                   	leave  
  8008ea:	c3                   	ret    

008008eb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8008f4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8008fb:	00 00 00 
	b.cnt = 0;
  8008fe:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800905:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800908:	ff 75 0c             	pushl  0xc(%ebp)
  80090b:	ff 75 08             	pushl  0x8(%ebp)
  80090e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800914:	50                   	push   %eax
  800915:	68 82 08 80 00       	push   $0x800882
  80091a:	e8 11 02 00 00       	call   800b30 <vprintfmt>
  80091f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800922:	a0 44 30 80 00       	mov    0x803044,%al
  800927:	0f b6 c0             	movzbl %al,%eax
  80092a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800930:	83 ec 04             	sub    $0x4,%esp
  800933:	50                   	push   %eax
  800934:	52                   	push   %edx
  800935:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80093b:	83 c0 08             	add    $0x8,%eax
  80093e:	50                   	push   %eax
  80093f:	e8 d7 0d 00 00       	call   80171b <sys_cputs>
  800944:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800947:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80094e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800954:	c9                   	leave  
  800955:	c3                   	ret    

00800956 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80095c:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800963:	8d 45 0c             	lea    0xc(%ebp),%eax
  800966:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	83 ec 08             	sub    $0x8,%esp
  80096f:	ff 75 f4             	pushl  -0xc(%ebp)
  800972:	50                   	push   %eax
  800973:	e8 73 ff ff ff       	call   8008eb <vcprintf>
  800978:	83 c4 10             	add    $0x10,%esp
  80097b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80097e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800981:	c9                   	leave  
  800982:	c3                   	ret    

00800983 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800989:	e8 cf 0d 00 00       	call   80175d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80098e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800991:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	83 ec 08             	sub    $0x8,%esp
  80099a:	ff 75 f4             	pushl  -0xc(%ebp)
  80099d:	50                   	push   %eax
  80099e:	e8 48 ff ff ff       	call   8008eb <vcprintf>
  8009a3:	83 c4 10             	add    $0x10,%esp
  8009a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8009a9:	e8 c9 0d 00 00       	call   801777 <sys_unlock_cons>
	return cnt;
  8009ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009b1:	c9                   	leave  
  8009b2:	c3                   	ret    

008009b3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009b3:	55                   	push   %ebp
  8009b4:	89 e5                	mov    %esp,%ebp
  8009b6:	53                   	push   %ebx
  8009b7:	83 ec 14             	sub    $0x14,%esp
  8009ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8009bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009c6:	8b 45 18             	mov    0x18(%ebp),%eax
  8009c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009d1:	77 55                	ja     800a28 <printnum+0x75>
  8009d3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009d6:	72 05                	jb     8009dd <printnum+0x2a>
  8009d8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009db:	77 4b                	ja     800a28 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009dd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009e0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009e3:	8b 45 18             	mov    0x18(%ebp),%eax
  8009e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009eb:	52                   	push   %edx
  8009ec:	50                   	push   %eax
  8009ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8009f3:	e8 98 13 00 00       	call   801d90 <__udivdi3>
  8009f8:	83 c4 10             	add    $0x10,%esp
  8009fb:	83 ec 04             	sub    $0x4,%esp
  8009fe:	ff 75 20             	pushl  0x20(%ebp)
  800a01:	53                   	push   %ebx
  800a02:	ff 75 18             	pushl  0x18(%ebp)
  800a05:	52                   	push   %edx
  800a06:	50                   	push   %eax
  800a07:	ff 75 0c             	pushl  0xc(%ebp)
  800a0a:	ff 75 08             	pushl  0x8(%ebp)
  800a0d:	e8 a1 ff ff ff       	call   8009b3 <printnum>
  800a12:	83 c4 20             	add    $0x20,%esp
  800a15:	eb 1a                	jmp    800a31 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a17:	83 ec 08             	sub    $0x8,%esp
  800a1a:	ff 75 0c             	pushl  0xc(%ebp)
  800a1d:	ff 75 20             	pushl  0x20(%ebp)
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	ff d0                	call   *%eax
  800a25:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a28:	ff 4d 1c             	decl   0x1c(%ebp)
  800a2b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a2f:	7f e6                	jg     800a17 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a31:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a34:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a3f:	53                   	push   %ebx
  800a40:	51                   	push   %ecx
  800a41:	52                   	push   %edx
  800a42:	50                   	push   %eax
  800a43:	e8 58 14 00 00       	call   801ea0 <__umoddi3>
  800a48:	83 c4 10             	add    $0x10,%esp
  800a4b:	05 54 27 80 00       	add    $0x802754,%eax
  800a50:	8a 00                	mov    (%eax),%al
  800a52:	0f be c0             	movsbl %al,%eax
  800a55:	83 ec 08             	sub    $0x8,%esp
  800a58:	ff 75 0c             	pushl  0xc(%ebp)
  800a5b:	50                   	push   %eax
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	ff d0                	call   *%eax
  800a61:	83 c4 10             	add    $0x10,%esp
}
  800a64:	90                   	nop
  800a65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a68:	c9                   	leave  
  800a69:	c3                   	ret    

00800a6a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a6d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a71:	7e 1c                	jle    800a8f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a73:	8b 45 08             	mov    0x8(%ebp),%eax
  800a76:	8b 00                	mov    (%eax),%eax
  800a78:	8d 50 08             	lea    0x8(%eax),%edx
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	89 10                	mov    %edx,(%eax)
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	8b 00                	mov    (%eax),%eax
  800a85:	83 e8 08             	sub    $0x8,%eax
  800a88:	8b 50 04             	mov    0x4(%eax),%edx
  800a8b:	8b 00                	mov    (%eax),%eax
  800a8d:	eb 40                	jmp    800acf <getuint+0x65>
	else if (lflag)
  800a8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a93:	74 1e                	je     800ab3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	8b 00                	mov    (%eax),%eax
  800a9a:	8d 50 04             	lea    0x4(%eax),%edx
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	89 10                	mov    %edx,(%eax)
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	8b 00                	mov    (%eax),%eax
  800aa7:	83 e8 04             	sub    $0x4,%eax
  800aaa:	8b 00                	mov    (%eax),%eax
  800aac:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab1:	eb 1c                	jmp    800acf <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	8b 00                	mov    (%eax),%eax
  800ab8:	8d 50 04             	lea    0x4(%eax),%edx
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	89 10                	mov    %edx,(%eax)
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	8b 00                	mov    (%eax),%eax
  800ac5:	83 e8 04             	sub    $0x4,%eax
  800ac8:	8b 00                	mov    (%eax),%eax
  800aca:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800acf:	5d                   	pop    %ebp
  800ad0:	c3                   	ret    

00800ad1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ad4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ad8:	7e 1c                	jle    800af6 <getint+0x25>
		return va_arg(*ap, long long);
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	8b 00                	mov    (%eax),%eax
  800adf:	8d 50 08             	lea    0x8(%eax),%edx
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	89 10                	mov    %edx,(%eax)
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	8b 00                	mov    (%eax),%eax
  800aec:	83 e8 08             	sub    $0x8,%eax
  800aef:	8b 50 04             	mov    0x4(%eax),%edx
  800af2:	8b 00                	mov    (%eax),%eax
  800af4:	eb 38                	jmp    800b2e <getint+0x5d>
	else if (lflag)
  800af6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800afa:	74 1a                	je     800b16 <getint+0x45>
		return va_arg(*ap, long);
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	8b 00                	mov    (%eax),%eax
  800b01:	8d 50 04             	lea    0x4(%eax),%edx
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	89 10                	mov    %edx,(%eax)
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	8b 00                	mov    (%eax),%eax
  800b0e:	83 e8 04             	sub    $0x4,%eax
  800b11:	8b 00                	mov    (%eax),%eax
  800b13:	99                   	cltd   
  800b14:	eb 18                	jmp    800b2e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	8b 00                	mov    (%eax),%eax
  800b1b:	8d 50 04             	lea    0x4(%eax),%edx
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	89 10                	mov    %edx,(%eax)
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	8b 00                	mov    (%eax),%eax
  800b28:	83 e8 04             	sub    $0x4,%eax
  800b2b:	8b 00                	mov    (%eax),%eax
  800b2d:	99                   	cltd   
}
  800b2e:	5d                   	pop    %ebp
  800b2f:	c3                   	ret    

00800b30 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
  800b33:	56                   	push   %esi
  800b34:	53                   	push   %ebx
  800b35:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b38:	eb 17                	jmp    800b51 <vprintfmt+0x21>
			if (ch == '\0')
  800b3a:	85 db                	test   %ebx,%ebx
  800b3c:	0f 84 c1 03 00 00    	je     800f03 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800b42:	83 ec 08             	sub    $0x8,%esp
  800b45:	ff 75 0c             	pushl  0xc(%ebp)
  800b48:	53                   	push   %ebx
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	ff d0                	call   *%eax
  800b4e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b51:	8b 45 10             	mov    0x10(%ebp),%eax
  800b54:	8d 50 01             	lea    0x1(%eax),%edx
  800b57:	89 55 10             	mov    %edx,0x10(%ebp)
  800b5a:	8a 00                	mov    (%eax),%al
  800b5c:	0f b6 d8             	movzbl %al,%ebx
  800b5f:	83 fb 25             	cmp    $0x25,%ebx
  800b62:	75 d6                	jne    800b3a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b64:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b68:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b6f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b76:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b7d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b84:	8b 45 10             	mov    0x10(%ebp),%eax
  800b87:	8d 50 01             	lea    0x1(%eax),%edx
  800b8a:	89 55 10             	mov    %edx,0x10(%ebp)
  800b8d:	8a 00                	mov    (%eax),%al
  800b8f:	0f b6 d8             	movzbl %al,%ebx
  800b92:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b95:	83 f8 5b             	cmp    $0x5b,%eax
  800b98:	0f 87 3d 03 00 00    	ja     800edb <vprintfmt+0x3ab>
  800b9e:	8b 04 85 78 27 80 00 	mov    0x802778(,%eax,4),%eax
  800ba5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ba7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bab:	eb d7                	jmp    800b84 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bad:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bb1:	eb d1                	jmp    800b84 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bb3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bbd:	89 d0                	mov    %edx,%eax
  800bbf:	c1 e0 02             	shl    $0x2,%eax
  800bc2:	01 d0                	add    %edx,%eax
  800bc4:	01 c0                	add    %eax,%eax
  800bc6:	01 d8                	add    %ebx,%eax
  800bc8:	83 e8 30             	sub    $0x30,%eax
  800bcb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bce:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd1:	8a 00                	mov    (%eax),%al
  800bd3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bd6:	83 fb 2f             	cmp    $0x2f,%ebx
  800bd9:	7e 3e                	jle    800c19 <vprintfmt+0xe9>
  800bdb:	83 fb 39             	cmp    $0x39,%ebx
  800bde:	7f 39                	jg     800c19 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800be0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800be3:	eb d5                	jmp    800bba <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800be5:	8b 45 14             	mov    0x14(%ebp),%eax
  800be8:	83 c0 04             	add    $0x4,%eax
  800beb:	89 45 14             	mov    %eax,0x14(%ebp)
  800bee:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf1:	83 e8 04             	sub    $0x4,%eax
  800bf4:	8b 00                	mov    (%eax),%eax
  800bf6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800bf9:	eb 1f                	jmp    800c1a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800bfb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bff:	79 83                	jns    800b84 <vprintfmt+0x54>
				width = 0;
  800c01:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c08:	e9 77 ff ff ff       	jmp    800b84 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c0d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c14:	e9 6b ff ff ff       	jmp    800b84 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c19:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c1e:	0f 89 60 ff ff ff    	jns    800b84 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c2a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c31:	e9 4e ff ff ff       	jmp    800b84 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c36:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c39:	e9 46 ff ff ff       	jmp    800b84 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c41:	83 c0 04             	add    $0x4,%eax
  800c44:	89 45 14             	mov    %eax,0x14(%ebp)
  800c47:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4a:	83 e8 04             	sub    $0x4,%eax
  800c4d:	8b 00                	mov    (%eax),%eax
  800c4f:	83 ec 08             	sub    $0x8,%esp
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	50                   	push   %eax
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	ff d0                	call   *%eax
  800c5b:	83 c4 10             	add    $0x10,%esp
			break;
  800c5e:	e9 9b 02 00 00       	jmp    800efe <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c63:	8b 45 14             	mov    0x14(%ebp),%eax
  800c66:	83 c0 04             	add    $0x4,%eax
  800c69:	89 45 14             	mov    %eax,0x14(%ebp)
  800c6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6f:	83 e8 04             	sub    $0x4,%eax
  800c72:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c74:	85 db                	test   %ebx,%ebx
  800c76:	79 02                	jns    800c7a <vprintfmt+0x14a>
				err = -err;
  800c78:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c7a:	83 fb 64             	cmp    $0x64,%ebx
  800c7d:	7f 0b                	jg     800c8a <vprintfmt+0x15a>
  800c7f:	8b 34 9d c0 25 80 00 	mov    0x8025c0(,%ebx,4),%esi
  800c86:	85 f6                	test   %esi,%esi
  800c88:	75 19                	jne    800ca3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c8a:	53                   	push   %ebx
  800c8b:	68 65 27 80 00       	push   $0x802765
  800c90:	ff 75 0c             	pushl  0xc(%ebp)
  800c93:	ff 75 08             	pushl  0x8(%ebp)
  800c96:	e8 70 02 00 00       	call   800f0b <printfmt>
  800c9b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c9e:	e9 5b 02 00 00       	jmp    800efe <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ca3:	56                   	push   %esi
  800ca4:	68 6e 27 80 00       	push   $0x80276e
  800ca9:	ff 75 0c             	pushl  0xc(%ebp)
  800cac:	ff 75 08             	pushl  0x8(%ebp)
  800caf:	e8 57 02 00 00       	call   800f0b <printfmt>
  800cb4:	83 c4 10             	add    $0x10,%esp
			break;
  800cb7:	e9 42 02 00 00       	jmp    800efe <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cbc:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbf:	83 c0 04             	add    $0x4,%eax
  800cc2:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc5:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc8:	83 e8 04             	sub    $0x4,%eax
  800ccb:	8b 30                	mov    (%eax),%esi
  800ccd:	85 f6                	test   %esi,%esi
  800ccf:	75 05                	jne    800cd6 <vprintfmt+0x1a6>
				p = "(null)";
  800cd1:	be 71 27 80 00       	mov    $0x802771,%esi
			if (width > 0 && padc != '-')
  800cd6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cda:	7e 6d                	jle    800d49 <vprintfmt+0x219>
  800cdc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ce0:	74 67                	je     800d49 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ce2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ce5:	83 ec 08             	sub    $0x8,%esp
  800ce8:	50                   	push   %eax
  800ce9:	56                   	push   %esi
  800cea:	e8 1e 03 00 00       	call   80100d <strnlen>
  800cef:	83 c4 10             	add    $0x10,%esp
  800cf2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800cf5:	eb 16                	jmp    800d0d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800cf7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800cfb:	83 ec 08             	sub    $0x8,%esp
  800cfe:	ff 75 0c             	pushl  0xc(%ebp)
  800d01:	50                   	push   %eax
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	ff d0                	call   *%eax
  800d07:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d0a:	ff 4d e4             	decl   -0x1c(%ebp)
  800d0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d11:	7f e4                	jg     800cf7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d13:	eb 34                	jmp    800d49 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d15:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d19:	74 1c                	je     800d37 <vprintfmt+0x207>
  800d1b:	83 fb 1f             	cmp    $0x1f,%ebx
  800d1e:	7e 05                	jle    800d25 <vprintfmt+0x1f5>
  800d20:	83 fb 7e             	cmp    $0x7e,%ebx
  800d23:	7e 12                	jle    800d37 <vprintfmt+0x207>
					putch('?', putdat);
  800d25:	83 ec 08             	sub    $0x8,%esp
  800d28:	ff 75 0c             	pushl  0xc(%ebp)
  800d2b:	6a 3f                	push   $0x3f
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	ff d0                	call   *%eax
  800d32:	83 c4 10             	add    $0x10,%esp
  800d35:	eb 0f                	jmp    800d46 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d37:	83 ec 08             	sub    $0x8,%esp
  800d3a:	ff 75 0c             	pushl  0xc(%ebp)
  800d3d:	53                   	push   %ebx
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	ff d0                	call   *%eax
  800d43:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d46:	ff 4d e4             	decl   -0x1c(%ebp)
  800d49:	89 f0                	mov    %esi,%eax
  800d4b:	8d 70 01             	lea    0x1(%eax),%esi
  800d4e:	8a 00                	mov    (%eax),%al
  800d50:	0f be d8             	movsbl %al,%ebx
  800d53:	85 db                	test   %ebx,%ebx
  800d55:	74 24                	je     800d7b <vprintfmt+0x24b>
  800d57:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d5b:	78 b8                	js     800d15 <vprintfmt+0x1e5>
  800d5d:	ff 4d e0             	decl   -0x20(%ebp)
  800d60:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d64:	79 af                	jns    800d15 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d66:	eb 13                	jmp    800d7b <vprintfmt+0x24b>
				putch(' ', putdat);
  800d68:	83 ec 08             	sub    $0x8,%esp
  800d6b:	ff 75 0c             	pushl  0xc(%ebp)
  800d6e:	6a 20                	push   $0x20
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	ff d0                	call   *%eax
  800d75:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d78:	ff 4d e4             	decl   -0x1c(%ebp)
  800d7b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d7f:	7f e7                	jg     800d68 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d81:	e9 78 01 00 00       	jmp    800efe <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d86:	83 ec 08             	sub    $0x8,%esp
  800d89:	ff 75 e8             	pushl  -0x18(%ebp)
  800d8c:	8d 45 14             	lea    0x14(%ebp),%eax
  800d8f:	50                   	push   %eax
  800d90:	e8 3c fd ff ff       	call   800ad1 <getint>
  800d95:	83 c4 10             	add    $0x10,%esp
  800d98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d9b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800da1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800da4:	85 d2                	test   %edx,%edx
  800da6:	79 23                	jns    800dcb <vprintfmt+0x29b>
				putch('-', putdat);
  800da8:	83 ec 08             	sub    $0x8,%esp
  800dab:	ff 75 0c             	pushl  0xc(%ebp)
  800dae:	6a 2d                	push   $0x2d
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	ff d0                	call   *%eax
  800db5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800db8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dbe:	f7 d8                	neg    %eax
  800dc0:	83 d2 00             	adc    $0x0,%edx
  800dc3:	f7 da                	neg    %edx
  800dc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800dcb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800dd2:	e9 bc 00 00 00       	jmp    800e93 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800dd7:	83 ec 08             	sub    $0x8,%esp
  800dda:	ff 75 e8             	pushl  -0x18(%ebp)
  800ddd:	8d 45 14             	lea    0x14(%ebp),%eax
  800de0:	50                   	push   %eax
  800de1:	e8 84 fc ff ff       	call   800a6a <getuint>
  800de6:	83 c4 10             	add    $0x10,%esp
  800de9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800def:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800df6:	e9 98 00 00 00       	jmp    800e93 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800dfb:	83 ec 08             	sub    $0x8,%esp
  800dfe:	ff 75 0c             	pushl  0xc(%ebp)
  800e01:	6a 58                	push   $0x58
  800e03:	8b 45 08             	mov    0x8(%ebp),%eax
  800e06:	ff d0                	call   *%eax
  800e08:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e0b:	83 ec 08             	sub    $0x8,%esp
  800e0e:	ff 75 0c             	pushl  0xc(%ebp)
  800e11:	6a 58                	push   $0x58
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	ff d0                	call   *%eax
  800e18:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e1b:	83 ec 08             	sub    $0x8,%esp
  800e1e:	ff 75 0c             	pushl  0xc(%ebp)
  800e21:	6a 58                	push   $0x58
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	ff d0                	call   *%eax
  800e28:	83 c4 10             	add    $0x10,%esp
			break;
  800e2b:	e9 ce 00 00 00       	jmp    800efe <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800e30:	83 ec 08             	sub    $0x8,%esp
  800e33:	ff 75 0c             	pushl  0xc(%ebp)
  800e36:	6a 30                	push   $0x30
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	ff d0                	call   *%eax
  800e3d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e40:	83 ec 08             	sub    $0x8,%esp
  800e43:	ff 75 0c             	pushl  0xc(%ebp)
  800e46:	6a 78                	push   $0x78
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	ff d0                	call   *%eax
  800e4d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e50:	8b 45 14             	mov    0x14(%ebp),%eax
  800e53:	83 c0 04             	add    $0x4,%eax
  800e56:	89 45 14             	mov    %eax,0x14(%ebp)
  800e59:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5c:	83 e8 04             	sub    $0x4,%eax
  800e5f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e64:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e6b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e72:	eb 1f                	jmp    800e93 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e74:	83 ec 08             	sub    $0x8,%esp
  800e77:	ff 75 e8             	pushl  -0x18(%ebp)
  800e7a:	8d 45 14             	lea    0x14(%ebp),%eax
  800e7d:	50                   	push   %eax
  800e7e:	e8 e7 fb ff ff       	call   800a6a <getuint>
  800e83:	83 c4 10             	add    $0x10,%esp
  800e86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e89:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e8c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e93:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e9a:	83 ec 04             	sub    $0x4,%esp
  800e9d:	52                   	push   %edx
  800e9e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ea1:	50                   	push   %eax
  800ea2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ea5:	ff 75 f0             	pushl  -0x10(%ebp)
  800ea8:	ff 75 0c             	pushl  0xc(%ebp)
  800eab:	ff 75 08             	pushl  0x8(%ebp)
  800eae:	e8 00 fb ff ff       	call   8009b3 <printnum>
  800eb3:	83 c4 20             	add    $0x20,%esp
			break;
  800eb6:	eb 46                	jmp    800efe <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800eb8:	83 ec 08             	sub    $0x8,%esp
  800ebb:	ff 75 0c             	pushl  0xc(%ebp)
  800ebe:	53                   	push   %ebx
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	ff d0                	call   *%eax
  800ec4:	83 c4 10             	add    $0x10,%esp
			break;
  800ec7:	eb 35                	jmp    800efe <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ec9:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800ed0:	eb 2c                	jmp    800efe <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ed2:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800ed9:	eb 23                	jmp    800efe <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800edb:	83 ec 08             	sub    $0x8,%esp
  800ede:	ff 75 0c             	pushl  0xc(%ebp)
  800ee1:	6a 25                	push   $0x25
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	ff d0                	call   *%eax
  800ee8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800eeb:	ff 4d 10             	decl   0x10(%ebp)
  800eee:	eb 03                	jmp    800ef3 <vprintfmt+0x3c3>
  800ef0:	ff 4d 10             	decl   0x10(%ebp)
  800ef3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef6:	48                   	dec    %eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	3c 25                	cmp    $0x25,%al
  800efb:	75 f3                	jne    800ef0 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800efd:	90                   	nop
		}
	}
  800efe:	e9 35 fc ff ff       	jmp    800b38 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f03:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f04:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f07:	5b                   	pop    %ebx
  800f08:	5e                   	pop    %esi
  800f09:	5d                   	pop    %ebp
  800f0a:	c3                   	ret    

00800f0b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f11:	8d 45 10             	lea    0x10(%ebp),%eax
  800f14:	83 c0 04             	add    $0x4,%eax
  800f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1d:	ff 75 f4             	pushl  -0xc(%ebp)
  800f20:	50                   	push   %eax
  800f21:	ff 75 0c             	pushl  0xc(%ebp)
  800f24:	ff 75 08             	pushl  0x8(%ebp)
  800f27:	e8 04 fc ff ff       	call   800b30 <vprintfmt>
  800f2c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f2f:	90                   	nop
  800f30:	c9                   	leave  
  800f31:	c3                   	ret    

00800f32 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f38:	8b 40 08             	mov    0x8(%eax),%eax
  800f3b:	8d 50 01             	lea    0x1(%eax),%edx
  800f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f41:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f47:	8b 10                	mov    (%eax),%edx
  800f49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4c:	8b 40 04             	mov    0x4(%eax),%eax
  800f4f:	39 c2                	cmp    %eax,%edx
  800f51:	73 12                	jae    800f65 <sprintputch+0x33>
		*b->buf++ = ch;
  800f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f56:	8b 00                	mov    (%eax),%eax
  800f58:	8d 48 01             	lea    0x1(%eax),%ecx
  800f5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5e:	89 0a                	mov    %ecx,(%edx)
  800f60:	8b 55 08             	mov    0x8(%ebp),%edx
  800f63:	88 10                	mov    %dl,(%eax)
}
  800f65:	90                   	nop
  800f66:	5d                   	pop    %ebp
  800f67:	c3                   	ret    

00800f68 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f77:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	01 d0                	add    %edx,%eax
  800f7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f89:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f8d:	74 06                	je     800f95 <vsnprintf+0x2d>
  800f8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f93:	7f 07                	jg     800f9c <vsnprintf+0x34>
		return -E_INVAL;
  800f95:	b8 03 00 00 00       	mov    $0x3,%eax
  800f9a:	eb 20                	jmp    800fbc <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f9c:	ff 75 14             	pushl  0x14(%ebp)
  800f9f:	ff 75 10             	pushl  0x10(%ebp)
  800fa2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fa5:	50                   	push   %eax
  800fa6:	68 32 0f 80 00       	push   $0x800f32
  800fab:	e8 80 fb ff ff       	call   800b30 <vprintfmt>
  800fb0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fb6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fbc:	c9                   	leave  
  800fbd:	c3                   	ret    

00800fbe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fbe:	55                   	push   %ebp
  800fbf:	89 e5                	mov    %esp,%ebp
  800fc1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fc4:	8d 45 10             	lea    0x10(%ebp),%eax
  800fc7:	83 c0 04             	add    $0x4,%eax
  800fca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd0:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd3:	50                   	push   %eax
  800fd4:	ff 75 0c             	pushl  0xc(%ebp)
  800fd7:	ff 75 08             	pushl  0x8(%ebp)
  800fda:	e8 89 ff ff ff       	call   800f68 <vsnprintf>
  800fdf:	83 c4 10             	add    $0x10,%esp
  800fe2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fe8:	c9                   	leave  
  800fe9:	c3                   	ret    

00800fea <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ff0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ff7:	eb 06                	jmp    800fff <strlen+0x15>
		n++;
  800ff9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ffc:	ff 45 08             	incl   0x8(%ebp)
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	8a 00                	mov    (%eax),%al
  801004:	84 c0                	test   %al,%al
  801006:	75 f1                	jne    800ff9 <strlen+0xf>
		n++;
	return n;
  801008:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80100b:	c9                   	leave  
  80100c:	c3                   	ret    

0080100d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80100d:	55                   	push   %ebp
  80100e:	89 e5                	mov    %esp,%ebp
  801010:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801013:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80101a:	eb 09                	jmp    801025 <strnlen+0x18>
		n++;
  80101c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80101f:	ff 45 08             	incl   0x8(%ebp)
  801022:	ff 4d 0c             	decl   0xc(%ebp)
  801025:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801029:	74 09                	je     801034 <strnlen+0x27>
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	8a 00                	mov    (%eax),%al
  801030:	84 c0                	test   %al,%al
  801032:	75 e8                	jne    80101c <strnlen+0xf>
		n++;
	return n;
  801034:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801037:	c9                   	leave  
  801038:	c3                   	ret    

00801039 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801045:	90                   	nop
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8d 50 01             	lea    0x1(%eax),%edx
  80104c:	89 55 08             	mov    %edx,0x8(%ebp)
  80104f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801052:	8d 4a 01             	lea    0x1(%edx),%ecx
  801055:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801058:	8a 12                	mov    (%edx),%dl
  80105a:	88 10                	mov    %dl,(%eax)
  80105c:	8a 00                	mov    (%eax),%al
  80105e:	84 c0                	test   %al,%al
  801060:	75 e4                	jne    801046 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801062:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801065:	c9                   	leave  
  801066:	c3                   	ret    

00801067 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801073:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80107a:	eb 1f                	jmp    80109b <strncpy+0x34>
		*dst++ = *src;
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8d 50 01             	lea    0x1(%eax),%edx
  801082:	89 55 08             	mov    %edx,0x8(%ebp)
  801085:	8b 55 0c             	mov    0xc(%ebp),%edx
  801088:	8a 12                	mov    (%edx),%dl
  80108a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80108c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108f:	8a 00                	mov    (%eax),%al
  801091:	84 c0                	test   %al,%al
  801093:	74 03                	je     801098 <strncpy+0x31>
			src++;
  801095:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801098:	ff 45 fc             	incl   -0x4(%ebp)
  80109b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109e:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010a1:	72 d9                	jb     80107c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010a6:	c9                   	leave  
  8010a7:	c3                   	ret    

008010a8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
  8010ab:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b8:	74 30                	je     8010ea <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010ba:	eb 16                	jmp    8010d2 <strlcpy+0x2a>
			*dst++ = *src++;
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bf:	8d 50 01             	lea    0x1(%eax),%edx
  8010c2:	89 55 08             	mov    %edx,0x8(%ebp)
  8010c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010cb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010ce:	8a 12                	mov    (%edx),%dl
  8010d0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010d2:	ff 4d 10             	decl   0x10(%ebp)
  8010d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d9:	74 09                	je     8010e4 <strlcpy+0x3c>
  8010db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010de:	8a 00                	mov    (%eax),%al
  8010e0:	84 c0                	test   %al,%al
  8010e2:	75 d8                	jne    8010bc <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f0:	29 c2                	sub    %eax,%edx
  8010f2:	89 d0                	mov    %edx,%eax
}
  8010f4:	c9                   	leave  
  8010f5:	c3                   	ret    

008010f6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010f9:	eb 06                	jmp    801101 <strcmp+0xb>
		p++, q++;
  8010fb:	ff 45 08             	incl   0x8(%ebp)
  8010fe:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	8a 00                	mov    (%eax),%al
  801106:	84 c0                	test   %al,%al
  801108:	74 0e                	je     801118 <strcmp+0x22>
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 10                	mov    (%eax),%dl
  80110f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801112:	8a 00                	mov    (%eax),%al
  801114:	38 c2                	cmp    %al,%dl
  801116:	74 e3                	je     8010fb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	8a 00                	mov    (%eax),%al
  80111d:	0f b6 d0             	movzbl %al,%edx
  801120:	8b 45 0c             	mov    0xc(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	0f b6 c0             	movzbl %al,%eax
  801128:	29 c2                	sub    %eax,%edx
  80112a:	89 d0                	mov    %edx,%eax
}
  80112c:	5d                   	pop    %ebp
  80112d:	c3                   	ret    

0080112e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80112e:	55                   	push   %ebp
  80112f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801131:	eb 09                	jmp    80113c <strncmp+0xe>
		n--, p++, q++;
  801133:	ff 4d 10             	decl   0x10(%ebp)
  801136:	ff 45 08             	incl   0x8(%ebp)
  801139:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80113c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801140:	74 17                	je     801159 <strncmp+0x2b>
  801142:	8b 45 08             	mov    0x8(%ebp),%eax
  801145:	8a 00                	mov    (%eax),%al
  801147:	84 c0                	test   %al,%al
  801149:	74 0e                	je     801159 <strncmp+0x2b>
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	8a 10                	mov    (%eax),%dl
  801150:	8b 45 0c             	mov    0xc(%ebp),%eax
  801153:	8a 00                	mov    (%eax),%al
  801155:	38 c2                	cmp    %al,%dl
  801157:	74 da                	je     801133 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801159:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115d:	75 07                	jne    801166 <strncmp+0x38>
		return 0;
  80115f:	b8 00 00 00 00       	mov    $0x0,%eax
  801164:	eb 14                	jmp    80117a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8a 00                	mov    (%eax),%al
  80116b:	0f b6 d0             	movzbl %al,%edx
  80116e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	0f b6 c0             	movzbl %al,%eax
  801176:	29 c2                	sub    %eax,%edx
  801178:	89 d0                	mov    %edx,%eax
}
  80117a:	5d                   	pop    %ebp
  80117b:	c3                   	ret    

0080117c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80117c:	55                   	push   %ebp
  80117d:	89 e5                	mov    %esp,%ebp
  80117f:	83 ec 04             	sub    $0x4,%esp
  801182:	8b 45 0c             	mov    0xc(%ebp),%eax
  801185:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801188:	eb 12                	jmp    80119c <strchr+0x20>
		if (*s == c)
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801192:	75 05                	jne    801199 <strchr+0x1d>
			return (char *) s;
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	eb 11                	jmp    8011aa <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801199:	ff 45 08             	incl   0x8(%ebp)
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	8a 00                	mov    (%eax),%al
  8011a1:	84 c0                	test   %al,%al
  8011a3:	75 e5                	jne    80118a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011aa:	c9                   	leave  
  8011ab:	c3                   	ret    

008011ac <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	83 ec 04             	sub    $0x4,%esp
  8011b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011b8:	eb 0d                	jmp    8011c7 <strfind+0x1b>
		if (*s == c)
  8011ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bd:	8a 00                	mov    (%eax),%al
  8011bf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011c2:	74 0e                	je     8011d2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011c4:	ff 45 08             	incl   0x8(%ebp)
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	84 c0                	test   %al,%al
  8011ce:	75 ea                	jne    8011ba <strfind+0xe>
  8011d0:	eb 01                	jmp    8011d3 <strfind+0x27>
		if (*s == c)
			break;
  8011d2:	90                   	nop
	return (char *) s;
  8011d3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011d6:	c9                   	leave  
  8011d7:	c3                   	ret    

008011d8 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011de:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8011ea:	eb 0e                	jmp    8011fa <memset+0x22>
		*p++ = c;
  8011ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ef:	8d 50 01             	lea    0x1(%eax),%edx
  8011f2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f8:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8011fa:	ff 4d f8             	decl   -0x8(%ebp)
  8011fd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801201:	79 e9                	jns    8011ec <memset+0x14>
		*p++ = c;

	return v;
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801206:	c9                   	leave  
  801207:	c3                   	ret    

00801208 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
  80120b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80120e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801211:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80121a:	eb 16                	jmp    801232 <memcpy+0x2a>
		*d++ = *s++;
  80121c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121f:	8d 50 01             	lea    0x1(%eax),%edx
  801222:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801225:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801228:	8d 4a 01             	lea    0x1(%edx),%ecx
  80122b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80122e:	8a 12                	mov    (%edx),%dl
  801230:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801232:	8b 45 10             	mov    0x10(%ebp),%eax
  801235:	8d 50 ff             	lea    -0x1(%eax),%edx
  801238:	89 55 10             	mov    %edx,0x10(%ebp)
  80123b:	85 c0                	test   %eax,%eax
  80123d:	75 dd                	jne    80121c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801242:	c9                   	leave  
  801243:	c3                   	ret    

00801244 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801244:	55                   	push   %ebp
  801245:	89 e5                	mov    %esp,%ebp
  801247:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80124a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801256:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801259:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80125c:	73 50                	jae    8012ae <memmove+0x6a>
  80125e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801261:	8b 45 10             	mov    0x10(%ebp),%eax
  801264:	01 d0                	add    %edx,%eax
  801266:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801269:	76 43                	jbe    8012ae <memmove+0x6a>
		s += n;
  80126b:	8b 45 10             	mov    0x10(%ebp),%eax
  80126e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801271:	8b 45 10             	mov    0x10(%ebp),%eax
  801274:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801277:	eb 10                	jmp    801289 <memmove+0x45>
			*--d = *--s;
  801279:	ff 4d f8             	decl   -0x8(%ebp)
  80127c:	ff 4d fc             	decl   -0x4(%ebp)
  80127f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801282:	8a 10                	mov    (%eax),%dl
  801284:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801287:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801289:	8b 45 10             	mov    0x10(%ebp),%eax
  80128c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80128f:	89 55 10             	mov    %edx,0x10(%ebp)
  801292:	85 c0                	test   %eax,%eax
  801294:	75 e3                	jne    801279 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801296:	eb 23                	jmp    8012bb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801298:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129b:	8d 50 01             	lea    0x1(%eax),%edx
  80129e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012a7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012aa:	8a 12                	mov    (%edx),%dl
  8012ac:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012b4:	89 55 10             	mov    %edx,0x10(%ebp)
  8012b7:	85 c0                	test   %eax,%eax
  8012b9:	75 dd                	jne    801298 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    

008012c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cf:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012d2:	eb 2a                	jmp    8012fe <memcmp+0x3e>
		if (*s1 != *s2)
  8012d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d7:	8a 10                	mov    (%eax),%dl
  8012d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	38 c2                	cmp    %al,%dl
  8012e0:	74 16                	je     8012f8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	0f b6 d0             	movzbl %al,%edx
  8012ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ed:	8a 00                	mov    (%eax),%al
  8012ef:	0f b6 c0             	movzbl %al,%eax
  8012f2:	29 c2                	sub    %eax,%edx
  8012f4:	89 d0                	mov    %edx,%eax
  8012f6:	eb 18                	jmp    801310 <memcmp+0x50>
		s1++, s2++;
  8012f8:	ff 45 fc             	incl   -0x4(%ebp)
  8012fb:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8012fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801301:	8d 50 ff             	lea    -0x1(%eax),%edx
  801304:	89 55 10             	mov    %edx,0x10(%ebp)
  801307:	85 c0                	test   %eax,%eax
  801309:	75 c9                	jne    8012d4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80130b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801310:	c9                   	leave  
  801311:	c3                   	ret    

00801312 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
  801315:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801318:	8b 55 08             	mov    0x8(%ebp),%edx
  80131b:	8b 45 10             	mov    0x10(%ebp),%eax
  80131e:	01 d0                	add    %edx,%eax
  801320:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801323:	eb 15                	jmp    80133a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
  801328:	8a 00                	mov    (%eax),%al
  80132a:	0f b6 d0             	movzbl %al,%edx
  80132d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801330:	0f b6 c0             	movzbl %al,%eax
  801333:	39 c2                	cmp    %eax,%edx
  801335:	74 0d                	je     801344 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801337:	ff 45 08             	incl   0x8(%ebp)
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801340:	72 e3                	jb     801325 <memfind+0x13>
  801342:	eb 01                	jmp    801345 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801344:	90                   	nop
	return (void *) s;
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801348:	c9                   	leave  
  801349:	c3                   	ret    

0080134a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801350:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801357:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80135e:	eb 03                	jmp    801363 <strtol+0x19>
		s++;
  801360:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	8a 00                	mov    (%eax),%al
  801368:	3c 20                	cmp    $0x20,%al
  80136a:	74 f4                	je     801360 <strtol+0x16>
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	8a 00                	mov    (%eax),%al
  801371:	3c 09                	cmp    $0x9,%al
  801373:	74 eb                	je     801360 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801375:	8b 45 08             	mov    0x8(%ebp),%eax
  801378:	8a 00                	mov    (%eax),%al
  80137a:	3c 2b                	cmp    $0x2b,%al
  80137c:	75 05                	jne    801383 <strtol+0x39>
		s++;
  80137e:	ff 45 08             	incl   0x8(%ebp)
  801381:	eb 13                	jmp    801396 <strtol+0x4c>
	else if (*s == '-')
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	8a 00                	mov    (%eax),%al
  801388:	3c 2d                	cmp    $0x2d,%al
  80138a:	75 0a                	jne    801396 <strtol+0x4c>
		s++, neg = 1;
  80138c:	ff 45 08             	incl   0x8(%ebp)
  80138f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801396:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80139a:	74 06                	je     8013a2 <strtol+0x58>
  80139c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013a0:	75 20                	jne    8013c2 <strtol+0x78>
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8a 00                	mov    (%eax),%al
  8013a7:	3c 30                	cmp    $0x30,%al
  8013a9:	75 17                	jne    8013c2 <strtol+0x78>
  8013ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ae:	40                   	inc    %eax
  8013af:	8a 00                	mov    (%eax),%al
  8013b1:	3c 78                	cmp    $0x78,%al
  8013b3:	75 0d                	jne    8013c2 <strtol+0x78>
		s += 2, base = 16;
  8013b5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013b9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013c0:	eb 28                	jmp    8013ea <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c6:	75 15                	jne    8013dd <strtol+0x93>
  8013c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cb:	8a 00                	mov    (%eax),%al
  8013cd:	3c 30                	cmp    $0x30,%al
  8013cf:	75 0c                	jne    8013dd <strtol+0x93>
		s++, base = 8;
  8013d1:	ff 45 08             	incl   0x8(%ebp)
  8013d4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013db:	eb 0d                	jmp    8013ea <strtol+0xa0>
	else if (base == 0)
  8013dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e1:	75 07                	jne    8013ea <strtol+0xa0>
		base = 10;
  8013e3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	3c 2f                	cmp    $0x2f,%al
  8013f1:	7e 19                	jle    80140c <strtol+0xc2>
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	8a 00                	mov    (%eax),%al
  8013f8:	3c 39                	cmp    $0x39,%al
  8013fa:	7f 10                	jg     80140c <strtol+0xc2>
			dig = *s - '0';
  8013fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ff:	8a 00                	mov    (%eax),%al
  801401:	0f be c0             	movsbl %al,%eax
  801404:	83 e8 30             	sub    $0x30,%eax
  801407:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80140a:	eb 42                	jmp    80144e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	3c 60                	cmp    $0x60,%al
  801413:	7e 19                	jle    80142e <strtol+0xe4>
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	8a 00                	mov    (%eax),%al
  80141a:	3c 7a                	cmp    $0x7a,%al
  80141c:	7f 10                	jg     80142e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80141e:	8b 45 08             	mov    0x8(%ebp),%eax
  801421:	8a 00                	mov    (%eax),%al
  801423:	0f be c0             	movsbl %al,%eax
  801426:	83 e8 57             	sub    $0x57,%eax
  801429:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80142c:	eb 20                	jmp    80144e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	8a 00                	mov    (%eax),%al
  801433:	3c 40                	cmp    $0x40,%al
  801435:	7e 39                	jle    801470 <strtol+0x126>
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	8a 00                	mov    (%eax),%al
  80143c:	3c 5a                	cmp    $0x5a,%al
  80143e:	7f 30                	jg     801470 <strtol+0x126>
			dig = *s - 'A' + 10;
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	0f be c0             	movsbl %al,%eax
  801448:	83 e8 37             	sub    $0x37,%eax
  80144b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80144e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801451:	3b 45 10             	cmp    0x10(%ebp),%eax
  801454:	7d 19                	jge    80146f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801456:	ff 45 08             	incl   0x8(%ebp)
  801459:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801460:	89 c2                	mov    %eax,%edx
  801462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801465:	01 d0                	add    %edx,%eax
  801467:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80146a:	e9 7b ff ff ff       	jmp    8013ea <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80146f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801470:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801474:	74 08                	je     80147e <strtol+0x134>
		*endptr = (char *) s;
  801476:	8b 45 0c             	mov    0xc(%ebp),%eax
  801479:	8b 55 08             	mov    0x8(%ebp),%edx
  80147c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80147e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801482:	74 07                	je     80148b <strtol+0x141>
  801484:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801487:	f7 d8                	neg    %eax
  801489:	eb 03                	jmp    80148e <strtol+0x144>
  80148b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80148e:	c9                   	leave  
  80148f:	c3                   	ret    

00801490 <ltostr>:

void
ltostr(long value, char *str)
{
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801496:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80149d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a8:	79 13                	jns    8014bd <ltostr+0x2d>
	{
		neg = 1;
  8014aa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014b7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014ba:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014c5:	99                   	cltd   
  8014c6:	f7 f9                	idiv   %ecx
  8014c8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ce:	8d 50 01             	lea    0x1(%eax),%edx
  8014d1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014d4:	89 c2                	mov    %eax,%edx
  8014d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d9:	01 d0                	add    %edx,%eax
  8014db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014de:	83 c2 30             	add    $0x30,%edx
  8014e1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014e6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014eb:	f7 e9                	imul   %ecx
  8014ed:	c1 fa 02             	sar    $0x2,%edx
  8014f0:	89 c8                	mov    %ecx,%eax
  8014f2:	c1 f8 1f             	sar    $0x1f,%eax
  8014f5:	29 c2                	sub    %eax,%edx
  8014f7:	89 d0                	mov    %edx,%eax
  8014f9:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8014fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801500:	75 bb                	jne    8014bd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801502:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801509:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80150c:	48                   	dec    %eax
  80150d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801510:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801514:	74 3d                	je     801553 <ltostr+0xc3>
		start = 1 ;
  801516:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80151d:	eb 34                	jmp    801553 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80151f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801522:	8b 45 0c             	mov    0xc(%ebp),%eax
  801525:	01 d0                	add    %edx,%eax
  801527:	8a 00                	mov    (%eax),%al
  801529:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80152c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80152f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801532:	01 c2                	add    %eax,%edx
  801534:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801537:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153a:	01 c8                	add    %ecx,%eax
  80153c:	8a 00                	mov    (%eax),%al
  80153e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801540:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801543:	8b 45 0c             	mov    0xc(%ebp),%eax
  801546:	01 c2                	add    %eax,%edx
  801548:	8a 45 eb             	mov    -0x15(%ebp),%al
  80154b:	88 02                	mov    %al,(%edx)
		start++ ;
  80154d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801550:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801556:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801559:	7c c4                	jl     80151f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80155b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80155e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801561:	01 d0                	add    %edx,%eax
  801563:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801566:	90                   	nop
  801567:	c9                   	leave  
  801568:	c3                   	ret    

00801569 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80156f:	ff 75 08             	pushl  0x8(%ebp)
  801572:	e8 73 fa ff ff       	call   800fea <strlen>
  801577:	83 c4 04             	add    $0x4,%esp
  80157a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80157d:	ff 75 0c             	pushl  0xc(%ebp)
  801580:	e8 65 fa ff ff       	call   800fea <strlen>
  801585:	83 c4 04             	add    $0x4,%esp
  801588:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80158b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801592:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801599:	eb 17                	jmp    8015b2 <strcconcat+0x49>
		final[s] = str1[s] ;
  80159b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80159e:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a1:	01 c2                	add    %eax,%edx
  8015a3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	01 c8                	add    %ecx,%eax
  8015ab:	8a 00                	mov    (%eax),%al
  8015ad:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015af:	ff 45 fc             	incl   -0x4(%ebp)
  8015b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015b8:	7c e1                	jl     80159b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015ba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015c1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015c8:	eb 1f                	jmp    8015e9 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015cd:	8d 50 01             	lea    0x1(%eax),%edx
  8015d0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015d3:	89 c2                	mov    %eax,%edx
  8015d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d8:	01 c2                	add    %eax,%edx
  8015da:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e0:	01 c8                	add    %ecx,%eax
  8015e2:	8a 00                	mov    (%eax),%al
  8015e4:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8015e6:	ff 45 f8             	incl   -0x8(%ebp)
  8015e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015ef:	7c d9                	jl     8015ca <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8015f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f7:	01 d0                	add    %edx,%eax
  8015f9:	c6 00 00             	movb   $0x0,(%eax)
}
  8015fc:	90                   	nop
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801602:	8b 45 14             	mov    0x14(%ebp),%eax
  801605:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80160b:	8b 45 14             	mov    0x14(%ebp),%eax
  80160e:	8b 00                	mov    (%eax),%eax
  801610:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801617:	8b 45 10             	mov    0x10(%ebp),%eax
  80161a:	01 d0                	add    %edx,%eax
  80161c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801622:	eb 0c                	jmp    801630 <strsplit+0x31>
			*string++ = 0;
  801624:	8b 45 08             	mov    0x8(%ebp),%eax
  801627:	8d 50 01             	lea    0x1(%eax),%edx
  80162a:	89 55 08             	mov    %edx,0x8(%ebp)
  80162d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801630:	8b 45 08             	mov    0x8(%ebp),%eax
  801633:	8a 00                	mov    (%eax),%al
  801635:	84 c0                	test   %al,%al
  801637:	74 18                	je     801651 <strsplit+0x52>
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	8a 00                	mov    (%eax),%al
  80163e:	0f be c0             	movsbl %al,%eax
  801641:	50                   	push   %eax
  801642:	ff 75 0c             	pushl  0xc(%ebp)
  801645:	e8 32 fb ff ff       	call   80117c <strchr>
  80164a:	83 c4 08             	add    $0x8,%esp
  80164d:	85 c0                	test   %eax,%eax
  80164f:	75 d3                	jne    801624 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	8a 00                	mov    (%eax),%al
  801656:	84 c0                	test   %al,%al
  801658:	74 5a                	je     8016b4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80165a:	8b 45 14             	mov    0x14(%ebp),%eax
  80165d:	8b 00                	mov    (%eax),%eax
  80165f:	83 f8 0f             	cmp    $0xf,%eax
  801662:	75 07                	jne    80166b <strsplit+0x6c>
		{
			return 0;
  801664:	b8 00 00 00 00       	mov    $0x0,%eax
  801669:	eb 66                	jmp    8016d1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80166b:	8b 45 14             	mov    0x14(%ebp),%eax
  80166e:	8b 00                	mov    (%eax),%eax
  801670:	8d 48 01             	lea    0x1(%eax),%ecx
  801673:	8b 55 14             	mov    0x14(%ebp),%edx
  801676:	89 0a                	mov    %ecx,(%edx)
  801678:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80167f:	8b 45 10             	mov    0x10(%ebp),%eax
  801682:	01 c2                	add    %eax,%edx
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801689:	eb 03                	jmp    80168e <strsplit+0x8f>
			string++;
  80168b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	8a 00                	mov    (%eax),%al
  801693:	84 c0                	test   %al,%al
  801695:	74 8b                	je     801622 <strsplit+0x23>
  801697:	8b 45 08             	mov    0x8(%ebp),%eax
  80169a:	8a 00                	mov    (%eax),%al
  80169c:	0f be c0             	movsbl %al,%eax
  80169f:	50                   	push   %eax
  8016a0:	ff 75 0c             	pushl  0xc(%ebp)
  8016a3:	e8 d4 fa ff ff       	call   80117c <strchr>
  8016a8:	83 c4 08             	add    $0x8,%esp
  8016ab:	85 c0                	test   %eax,%eax
  8016ad:	74 dc                	je     80168b <strsplit+0x8c>
			string++;
	}
  8016af:	e9 6e ff ff ff       	jmp    801622 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016b4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8016b8:	8b 00                	mov    (%eax),%eax
  8016ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c4:	01 d0                	add    %edx,%eax
  8016c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016cc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8016d9:	83 ec 04             	sub    $0x4,%esp
  8016dc:	68 e8 28 80 00       	push   $0x8028e8
  8016e1:	68 3f 01 00 00       	push   $0x13f
  8016e6:	68 0a 29 80 00       	push   $0x80290a
  8016eb:	e8 a9 ef ff ff       	call   800699 <_panic>

008016f0 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	57                   	push   %edi
  8016f4:	56                   	push   %esi
  8016f5:	53                   	push   %ebx
  8016f6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801702:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801705:	8b 7d 18             	mov    0x18(%ebp),%edi
  801708:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80170b:	cd 30                	int    $0x30
  80170d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801710:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801713:	83 c4 10             	add    $0x10,%esp
  801716:	5b                   	pop    %ebx
  801717:	5e                   	pop    %esi
  801718:	5f                   	pop    %edi
  801719:	5d                   	pop    %ebp
  80171a:	c3                   	ret    

0080171b <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
  80171e:	83 ec 04             	sub    $0x4,%esp
  801721:	8b 45 10             	mov    0x10(%ebp),%eax
  801724:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801727:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	52                   	push   %edx
  801733:	ff 75 0c             	pushl  0xc(%ebp)
  801736:	50                   	push   %eax
  801737:	6a 00                	push   $0x0
  801739:	e8 b2 ff ff ff       	call   8016f0 <syscall>
  80173e:	83 c4 18             	add    $0x18,%esp
}
  801741:	90                   	nop
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <sys_cgetc>:

int sys_cgetc(void) {
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 02                	push   $0x2
  801753:	e8 98 ff ff ff       	call   8016f0 <syscall>
  801758:	83 c4 18             	add    $0x18,%esp
}
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <sys_lock_cons>:

void sys_lock_cons(void) {
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 03                	push   $0x3
  80176c:	e8 7f ff ff ff       	call   8016f0 <syscall>
  801771:	83 c4 18             	add    $0x18,%esp
}
  801774:	90                   	nop
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 04                	push   $0x4
  801786:	e8 65 ff ff ff       	call   8016f0 <syscall>
  80178b:	83 c4 18             	add    $0x18,%esp
}
  80178e:	90                   	nop
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801794:	8b 55 0c             	mov    0xc(%ebp),%edx
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	52                   	push   %edx
  8017a1:	50                   	push   %eax
  8017a2:	6a 08                	push   $0x8
  8017a4:	e8 47 ff ff ff       	call   8016f0 <syscall>
  8017a9:	83 c4 18             	add    $0x18,%esp
}
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	56                   	push   %esi
  8017b2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  8017b3:	8b 75 18             	mov    0x18(%ebp),%esi
  8017b6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	56                   	push   %esi
  8017c3:	53                   	push   %ebx
  8017c4:	51                   	push   %ecx
  8017c5:	52                   	push   %edx
  8017c6:	50                   	push   %eax
  8017c7:	6a 09                	push   $0x9
  8017c9:	e8 22 ff ff ff       	call   8016f0 <syscall>
  8017ce:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  8017d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017d4:	5b                   	pop    %ebx
  8017d5:	5e                   	pop    %esi
  8017d6:	5d                   	pop    %ebp
  8017d7:	c3                   	ret    

008017d8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	52                   	push   %edx
  8017e8:	50                   	push   %eax
  8017e9:	6a 0a                	push   $0xa
  8017eb:	e8 00 ff ff ff       	call   8016f0 <syscall>
  8017f0:	83 c4 18             	add    $0x18,%esp
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	ff 75 0c             	pushl  0xc(%ebp)
  801801:	ff 75 08             	pushl  0x8(%ebp)
  801804:	6a 0b                	push   $0xb
  801806:	e8 e5 fe ff ff       	call   8016f0 <syscall>
  80180b:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 0c                	push   $0xc
  80181f:	e8 cc fe ff ff       	call   8016f0 <syscall>
  801824:	83 c4 18             	add    $0x18,%esp
}
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 0d                	push   $0xd
  801838:	e8 b3 fe ff ff       	call   8016f0 <syscall>
  80183d:	83 c4 18             	add    $0x18,%esp
}
  801840:	c9                   	leave  
  801841:	c3                   	ret    

00801842 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 0e                	push   $0xe
  801851:	e8 9a fe ff ff       	call   8016f0 <syscall>
  801856:	83 c4 18             	add    $0x18,%esp
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 0f                	push   $0xf
  80186a:	e8 81 fe ff ff       	call   8016f0 <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
}
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	ff 75 08             	pushl  0x8(%ebp)
  801882:	6a 10                	push   $0x10
  801884:	e8 67 fe ff ff       	call   8016f0 <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <sys_scarce_memory>:

void sys_scarce_memory() {
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 11                	push   $0x11
  80189d:	e8 4e fe ff ff       	call   8016f0 <syscall>
  8018a2:	83 c4 18             	add    $0x18,%esp
}
  8018a5:	90                   	nop
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <sys_cputc>:

void sys_cputc(const char c) {
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
  8018ab:	83 ec 04             	sub    $0x4,%esp
  8018ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018b4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	50                   	push   %eax
  8018c1:	6a 01                	push   $0x1
  8018c3:	e8 28 fe ff ff       	call   8016f0 <syscall>
  8018c8:	83 c4 18             	add    $0x18,%esp
}
  8018cb:	90                   	nop
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 14                	push   $0x14
  8018dd:	e8 0e fe ff ff       	call   8016f0 <syscall>
  8018e2:	83 c4 18             	add    $0x18,%esp
}
  8018e5:	90                   	nop
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	83 ec 04             	sub    $0x4,%esp
  8018ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  8018f4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018f7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	6a 00                	push   $0x0
  801900:	51                   	push   %ecx
  801901:	52                   	push   %edx
  801902:	ff 75 0c             	pushl  0xc(%ebp)
  801905:	50                   	push   %eax
  801906:	6a 15                	push   $0x15
  801908:	e8 e3 fd ff ff       	call   8016f0 <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801915:	8b 55 0c             	mov    0xc(%ebp),%edx
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	52                   	push   %edx
  801922:	50                   	push   %eax
  801923:	6a 16                	push   $0x16
  801925:	e8 c6 fd ff ff       	call   8016f0 <syscall>
  80192a:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    

0080192f <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801932:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801935:	8b 55 0c             	mov    0xc(%ebp),%edx
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	51                   	push   %ecx
  801940:	52                   	push   %edx
  801941:	50                   	push   %eax
  801942:	6a 17                	push   $0x17
  801944:	e8 a7 fd ff ff       	call   8016f0 <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801951:	8b 55 0c             	mov    0xc(%ebp),%edx
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	52                   	push   %edx
  80195e:	50                   	push   %eax
  80195f:	6a 18                	push   $0x18
  801961:	e8 8a fd ff ff       	call   8016f0 <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
  801971:	6a 00                	push   $0x0
  801973:	ff 75 14             	pushl  0x14(%ebp)
  801976:	ff 75 10             	pushl  0x10(%ebp)
  801979:	ff 75 0c             	pushl  0xc(%ebp)
  80197c:	50                   	push   %eax
  80197d:	6a 19                	push   $0x19
  80197f:	e8 6c fd ff ff       	call   8016f0 <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sys_run_env>:

void sys_run_env(int32 envId) {
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	50                   	push   %eax
  801998:	6a 1a                	push   $0x1a
  80199a:	e8 51 fd ff ff       	call   8016f0 <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
}
  8019a2:	90                   	nop
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	50                   	push   %eax
  8019b4:	6a 1b                	push   $0x1b
  8019b6:	e8 35 fd ff ff       	call   8016f0 <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <sys_getenvid>:

int32 sys_getenvid(void) {
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 05                	push   $0x5
  8019cf:	e8 1c fd ff ff       	call   8016f0 <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 06                	push   $0x6
  8019e8:	e8 03 fd ff ff       	call   8016f0 <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 07                	push   $0x7
  801a01:	e8 ea fc ff ff       	call   8016f0 <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <sys_exit_env>:

void sys_exit_env(void) {
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 1c                	push   $0x1c
  801a1a:	e8 d1 fc ff ff       	call   8016f0 <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
}
  801a22:	90                   	nop
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801a2b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a2e:	8d 50 04             	lea    0x4(%eax),%edx
  801a31:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	52                   	push   %edx
  801a3b:	50                   	push   %eax
  801a3c:	6a 1d                	push   $0x1d
  801a3e:	e8 ad fc ff ff       	call   8016f0 <syscall>
  801a43:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801a46:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a49:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a4c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a4f:	89 01                	mov    %eax,(%ecx)
  801a51:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	c9                   	leave  
  801a58:	c2 04 00             	ret    $0x4

00801a5b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	ff 75 10             	pushl  0x10(%ebp)
  801a65:	ff 75 0c             	pushl  0xc(%ebp)
  801a68:	ff 75 08             	pushl  0x8(%ebp)
  801a6b:	6a 13                	push   $0x13
  801a6d:	e8 7e fc ff ff       	call   8016f0 <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801a75:	90                   	nop
}
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <sys_rcr2>:
uint32 sys_rcr2() {
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 1e                	push   $0x1e
  801a87:	e8 64 fc ff ff       	call   8016f0 <syscall>
  801a8c:	83 c4 18             	add    $0x18,%esp
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
  801a94:	83 ec 04             	sub    $0x4,%esp
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a9d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	50                   	push   %eax
  801aaa:	6a 1f                	push   $0x1f
  801aac:	e8 3f fc ff ff       	call   8016f0 <syscall>
  801ab1:	83 c4 18             	add    $0x18,%esp
	return;
  801ab4:	90                   	nop
}
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <rsttst>:
void rsttst() {
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 21                	push   $0x21
  801ac6:	e8 25 fc ff ff       	call   8016f0 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
	return;
  801ace:	90                   	nop
}
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	83 ec 04             	sub    $0x4,%esp
  801ad7:	8b 45 14             	mov    0x14(%ebp),%eax
  801ada:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801add:	8b 55 18             	mov    0x18(%ebp),%edx
  801ae0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ae4:	52                   	push   %edx
  801ae5:	50                   	push   %eax
  801ae6:	ff 75 10             	pushl  0x10(%ebp)
  801ae9:	ff 75 0c             	pushl  0xc(%ebp)
  801aec:	ff 75 08             	pushl  0x8(%ebp)
  801aef:	6a 20                	push   $0x20
  801af1:	e8 fa fb ff ff       	call   8016f0 <syscall>
  801af6:	83 c4 18             	add    $0x18,%esp
	return;
  801af9:	90                   	nop
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <chktst>:
void chktst(uint32 n) {
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	ff 75 08             	pushl  0x8(%ebp)
  801b0a:	6a 22                	push   $0x22
  801b0c:	e8 df fb ff ff       	call   8016f0 <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
	return;
  801b14:	90                   	nop
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <inctst>:

void inctst() {
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 23                	push   $0x23
  801b26:	e8 c5 fb ff ff       	call   8016f0 <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
	return;
  801b2e:	90                   	nop
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <gettst>:
uint32 gettst() {
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 24                	push   $0x24
  801b40:	e8 ab fb ff ff       	call   8016f0 <syscall>
  801b45:	83 c4 18             	add    $0x18,%esp
}
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 25                	push   $0x25
  801b5c:	e8 8f fb ff ff       	call   8016f0 <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
  801b64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b67:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b6b:	75 07                	jne    801b74 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b72:	eb 05                	jmp    801b79 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 25                	push   $0x25
  801b8d:	e8 5e fb ff ff       	call   8016f0 <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
  801b95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b98:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b9c:	75 07                	jne    801ba5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba3:	eb 05                	jmp    801baa <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ba5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 25                	push   $0x25
  801bbe:	e8 2d fb ff ff       	call   8016f0 <syscall>
  801bc3:	83 c4 18             	add    $0x18,%esp
  801bc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bc9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801bcd:	75 07                	jne    801bd6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bcf:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd4:	eb 05                	jmp    801bdb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 25                	push   $0x25
  801bef:	e8 fc fa ff ff       	call   8016f0 <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
  801bf7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801bfa:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801bfe:	75 07                	jne    801c07 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c00:	b8 01 00 00 00       	mov    $0x1,%eax
  801c05:	eb 05                	jmp    801c0c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	ff 75 08             	pushl  0x8(%ebp)
  801c1c:	6a 26                	push   $0x26
  801c1e:	e8 cd fa ff ff       	call   8016f0 <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
	return;
  801c26:	90                   	nop
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801c2d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c30:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c36:	8b 45 08             	mov    0x8(%ebp),%eax
  801c39:	6a 00                	push   $0x0
  801c3b:	53                   	push   %ebx
  801c3c:	51                   	push   %ecx
  801c3d:	52                   	push   %edx
  801c3e:	50                   	push   %eax
  801c3f:	6a 27                	push   $0x27
  801c41:	e8 aa fa ff ff       	call   8016f0 <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801c49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801c51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c54:	8b 45 08             	mov    0x8(%ebp),%eax
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	52                   	push   %edx
  801c5e:	50                   	push   %eax
  801c5f:	6a 28                	push   $0x28
  801c61:	e8 8a fa ff ff       	call   8016f0 <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801c6e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	6a 00                	push   $0x0
  801c79:	51                   	push   %ecx
  801c7a:	ff 75 10             	pushl  0x10(%ebp)
  801c7d:	52                   	push   %edx
  801c7e:	50                   	push   %eax
  801c7f:	6a 29                	push   $0x29
  801c81:	e8 6a fa ff ff       	call   8016f0 <syscall>
  801c86:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	ff 75 10             	pushl  0x10(%ebp)
  801c95:	ff 75 0c             	pushl  0xc(%ebp)
  801c98:	ff 75 08             	pushl  0x8(%ebp)
  801c9b:	6a 12                	push   $0x12
  801c9d:	e8 4e fa ff ff       	call   8016f0 <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
	return;
  801ca5:	90                   	nop
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801cab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cae:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	52                   	push   %edx
  801cb8:	50                   	push   %eax
  801cb9:	6a 2a                	push   $0x2a
  801cbb:	e8 30 fa ff ff       	call   8016f0 <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
	return;
  801cc3:	90                   	nop
}
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	50                   	push   %eax
  801cd5:	6a 2b                	push   $0x2b
  801cd7:	e8 14 fa ff ff       	call   8016f0 <syscall>
  801cdc:	83 c4 18             	add    $0x18,%esp
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	ff 75 0c             	pushl  0xc(%ebp)
  801ced:	ff 75 08             	pushl  0x8(%ebp)
  801cf0:	6a 2c                	push   $0x2c
  801cf2:	e8 f9 f9 ff ff       	call   8016f0 <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
	return;
  801cfa:	90                   	nop
}
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	ff 75 0c             	pushl  0xc(%ebp)
  801d09:	ff 75 08             	pushl  0x8(%ebp)
  801d0c:	6a 2d                	push   $0x2d
  801d0e:	e8 dd f9 ff ff       	call   8016f0 <syscall>
  801d13:	83 c4 18             	add    $0x18,%esp
	return;
  801d16:	90                   	nop
}
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	50                   	push   %eax
  801d28:	6a 2f                	push   $0x2f
  801d2a:	e8 c1 f9 ff ff       	call   8016f0 <syscall>
  801d2f:	83 c4 18             	add    $0x18,%esp
	return;
  801d32:	90                   	nop
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  801d38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	52                   	push   %edx
  801d45:	50                   	push   %eax
  801d46:	6a 30                	push   $0x30
  801d48:	e8 a3 f9 ff ff       	call   8016f0 <syscall>
  801d4d:	83 c4 18             	add    $0x18,%esp
	return;
  801d50:	90                   	nop
}
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	50                   	push   %eax
  801d62:	6a 31                	push   $0x31
  801d64:	e8 87 f9 ff ff       	call   8016f0 <syscall>
  801d69:	83 c4 18             	add    $0x18,%esp
	return;
  801d6c:	90                   	nop
}
  801d6d:	c9                   	leave  
  801d6e:	c3                   	ret    

00801d6f <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801d72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d75:	8b 45 08             	mov    0x8(%ebp),%eax
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	52                   	push   %edx
  801d7f:	50                   	push   %eax
  801d80:	6a 2e                	push   $0x2e
  801d82:	e8 69 f9 ff ff       	call   8016f0 <syscall>
  801d87:	83 c4 18             	add    $0x18,%esp
    return;
  801d8a:	90                   	nop
}
  801d8b:	c9                   	leave  
  801d8c:	c3                   	ret    
  801d8d:	66 90                	xchg   %ax,%ax
  801d8f:	90                   	nop

00801d90 <__udivdi3>:
  801d90:	55                   	push   %ebp
  801d91:	57                   	push   %edi
  801d92:	56                   	push   %esi
  801d93:	53                   	push   %ebx
  801d94:	83 ec 1c             	sub    $0x1c,%esp
  801d97:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d9b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d9f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801da3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801da7:	89 ca                	mov    %ecx,%edx
  801da9:	89 f8                	mov    %edi,%eax
  801dab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801daf:	85 f6                	test   %esi,%esi
  801db1:	75 2d                	jne    801de0 <__udivdi3+0x50>
  801db3:	39 cf                	cmp    %ecx,%edi
  801db5:	77 65                	ja     801e1c <__udivdi3+0x8c>
  801db7:	89 fd                	mov    %edi,%ebp
  801db9:	85 ff                	test   %edi,%edi
  801dbb:	75 0b                	jne    801dc8 <__udivdi3+0x38>
  801dbd:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc2:	31 d2                	xor    %edx,%edx
  801dc4:	f7 f7                	div    %edi
  801dc6:	89 c5                	mov    %eax,%ebp
  801dc8:	31 d2                	xor    %edx,%edx
  801dca:	89 c8                	mov    %ecx,%eax
  801dcc:	f7 f5                	div    %ebp
  801dce:	89 c1                	mov    %eax,%ecx
  801dd0:	89 d8                	mov    %ebx,%eax
  801dd2:	f7 f5                	div    %ebp
  801dd4:	89 cf                	mov    %ecx,%edi
  801dd6:	89 fa                	mov    %edi,%edx
  801dd8:	83 c4 1c             	add    $0x1c,%esp
  801ddb:	5b                   	pop    %ebx
  801ddc:	5e                   	pop    %esi
  801ddd:	5f                   	pop    %edi
  801dde:	5d                   	pop    %ebp
  801ddf:	c3                   	ret    
  801de0:	39 ce                	cmp    %ecx,%esi
  801de2:	77 28                	ja     801e0c <__udivdi3+0x7c>
  801de4:	0f bd fe             	bsr    %esi,%edi
  801de7:	83 f7 1f             	xor    $0x1f,%edi
  801dea:	75 40                	jne    801e2c <__udivdi3+0x9c>
  801dec:	39 ce                	cmp    %ecx,%esi
  801dee:	72 0a                	jb     801dfa <__udivdi3+0x6a>
  801df0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801df4:	0f 87 9e 00 00 00    	ja     801e98 <__udivdi3+0x108>
  801dfa:	b8 01 00 00 00       	mov    $0x1,%eax
  801dff:	89 fa                	mov    %edi,%edx
  801e01:	83 c4 1c             	add    $0x1c,%esp
  801e04:	5b                   	pop    %ebx
  801e05:	5e                   	pop    %esi
  801e06:	5f                   	pop    %edi
  801e07:	5d                   	pop    %ebp
  801e08:	c3                   	ret    
  801e09:	8d 76 00             	lea    0x0(%esi),%esi
  801e0c:	31 ff                	xor    %edi,%edi
  801e0e:	31 c0                	xor    %eax,%eax
  801e10:	89 fa                	mov    %edi,%edx
  801e12:	83 c4 1c             	add    $0x1c,%esp
  801e15:	5b                   	pop    %ebx
  801e16:	5e                   	pop    %esi
  801e17:	5f                   	pop    %edi
  801e18:	5d                   	pop    %ebp
  801e19:	c3                   	ret    
  801e1a:	66 90                	xchg   %ax,%ax
  801e1c:	89 d8                	mov    %ebx,%eax
  801e1e:	f7 f7                	div    %edi
  801e20:	31 ff                	xor    %edi,%edi
  801e22:	89 fa                	mov    %edi,%edx
  801e24:	83 c4 1c             	add    $0x1c,%esp
  801e27:	5b                   	pop    %ebx
  801e28:	5e                   	pop    %esi
  801e29:	5f                   	pop    %edi
  801e2a:	5d                   	pop    %ebp
  801e2b:	c3                   	ret    
  801e2c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801e31:	89 eb                	mov    %ebp,%ebx
  801e33:	29 fb                	sub    %edi,%ebx
  801e35:	89 f9                	mov    %edi,%ecx
  801e37:	d3 e6                	shl    %cl,%esi
  801e39:	89 c5                	mov    %eax,%ebp
  801e3b:	88 d9                	mov    %bl,%cl
  801e3d:	d3 ed                	shr    %cl,%ebp
  801e3f:	89 e9                	mov    %ebp,%ecx
  801e41:	09 f1                	or     %esi,%ecx
  801e43:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e47:	89 f9                	mov    %edi,%ecx
  801e49:	d3 e0                	shl    %cl,%eax
  801e4b:	89 c5                	mov    %eax,%ebp
  801e4d:	89 d6                	mov    %edx,%esi
  801e4f:	88 d9                	mov    %bl,%cl
  801e51:	d3 ee                	shr    %cl,%esi
  801e53:	89 f9                	mov    %edi,%ecx
  801e55:	d3 e2                	shl    %cl,%edx
  801e57:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e5b:	88 d9                	mov    %bl,%cl
  801e5d:	d3 e8                	shr    %cl,%eax
  801e5f:	09 c2                	or     %eax,%edx
  801e61:	89 d0                	mov    %edx,%eax
  801e63:	89 f2                	mov    %esi,%edx
  801e65:	f7 74 24 0c          	divl   0xc(%esp)
  801e69:	89 d6                	mov    %edx,%esi
  801e6b:	89 c3                	mov    %eax,%ebx
  801e6d:	f7 e5                	mul    %ebp
  801e6f:	39 d6                	cmp    %edx,%esi
  801e71:	72 19                	jb     801e8c <__udivdi3+0xfc>
  801e73:	74 0b                	je     801e80 <__udivdi3+0xf0>
  801e75:	89 d8                	mov    %ebx,%eax
  801e77:	31 ff                	xor    %edi,%edi
  801e79:	e9 58 ff ff ff       	jmp    801dd6 <__udivdi3+0x46>
  801e7e:	66 90                	xchg   %ax,%ax
  801e80:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e84:	89 f9                	mov    %edi,%ecx
  801e86:	d3 e2                	shl    %cl,%edx
  801e88:	39 c2                	cmp    %eax,%edx
  801e8a:	73 e9                	jae    801e75 <__udivdi3+0xe5>
  801e8c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e8f:	31 ff                	xor    %edi,%edi
  801e91:	e9 40 ff ff ff       	jmp    801dd6 <__udivdi3+0x46>
  801e96:	66 90                	xchg   %ax,%ax
  801e98:	31 c0                	xor    %eax,%eax
  801e9a:	e9 37 ff ff ff       	jmp    801dd6 <__udivdi3+0x46>
  801e9f:	90                   	nop

00801ea0 <__umoddi3>:
  801ea0:	55                   	push   %ebp
  801ea1:	57                   	push   %edi
  801ea2:	56                   	push   %esi
  801ea3:	53                   	push   %ebx
  801ea4:	83 ec 1c             	sub    $0x1c,%esp
  801ea7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801eab:	8b 74 24 34          	mov    0x34(%esp),%esi
  801eaf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801eb3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801eb7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ebb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ebf:	89 f3                	mov    %esi,%ebx
  801ec1:	89 fa                	mov    %edi,%edx
  801ec3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ec7:	89 34 24             	mov    %esi,(%esp)
  801eca:	85 c0                	test   %eax,%eax
  801ecc:	75 1a                	jne    801ee8 <__umoddi3+0x48>
  801ece:	39 f7                	cmp    %esi,%edi
  801ed0:	0f 86 a2 00 00 00    	jbe    801f78 <__umoddi3+0xd8>
  801ed6:	89 c8                	mov    %ecx,%eax
  801ed8:	89 f2                	mov    %esi,%edx
  801eda:	f7 f7                	div    %edi
  801edc:	89 d0                	mov    %edx,%eax
  801ede:	31 d2                	xor    %edx,%edx
  801ee0:	83 c4 1c             	add    $0x1c,%esp
  801ee3:	5b                   	pop    %ebx
  801ee4:	5e                   	pop    %esi
  801ee5:	5f                   	pop    %edi
  801ee6:	5d                   	pop    %ebp
  801ee7:	c3                   	ret    
  801ee8:	39 f0                	cmp    %esi,%eax
  801eea:	0f 87 ac 00 00 00    	ja     801f9c <__umoddi3+0xfc>
  801ef0:	0f bd e8             	bsr    %eax,%ebp
  801ef3:	83 f5 1f             	xor    $0x1f,%ebp
  801ef6:	0f 84 ac 00 00 00    	je     801fa8 <__umoddi3+0x108>
  801efc:	bf 20 00 00 00       	mov    $0x20,%edi
  801f01:	29 ef                	sub    %ebp,%edi
  801f03:	89 fe                	mov    %edi,%esi
  801f05:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f09:	89 e9                	mov    %ebp,%ecx
  801f0b:	d3 e0                	shl    %cl,%eax
  801f0d:	89 d7                	mov    %edx,%edi
  801f0f:	89 f1                	mov    %esi,%ecx
  801f11:	d3 ef                	shr    %cl,%edi
  801f13:	09 c7                	or     %eax,%edi
  801f15:	89 e9                	mov    %ebp,%ecx
  801f17:	d3 e2                	shl    %cl,%edx
  801f19:	89 14 24             	mov    %edx,(%esp)
  801f1c:	89 d8                	mov    %ebx,%eax
  801f1e:	d3 e0                	shl    %cl,%eax
  801f20:	89 c2                	mov    %eax,%edx
  801f22:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f26:	d3 e0                	shl    %cl,%eax
  801f28:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f2c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f30:	89 f1                	mov    %esi,%ecx
  801f32:	d3 e8                	shr    %cl,%eax
  801f34:	09 d0                	or     %edx,%eax
  801f36:	d3 eb                	shr    %cl,%ebx
  801f38:	89 da                	mov    %ebx,%edx
  801f3a:	f7 f7                	div    %edi
  801f3c:	89 d3                	mov    %edx,%ebx
  801f3e:	f7 24 24             	mull   (%esp)
  801f41:	89 c6                	mov    %eax,%esi
  801f43:	89 d1                	mov    %edx,%ecx
  801f45:	39 d3                	cmp    %edx,%ebx
  801f47:	0f 82 87 00 00 00    	jb     801fd4 <__umoddi3+0x134>
  801f4d:	0f 84 91 00 00 00    	je     801fe4 <__umoddi3+0x144>
  801f53:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f57:	29 f2                	sub    %esi,%edx
  801f59:	19 cb                	sbb    %ecx,%ebx
  801f5b:	89 d8                	mov    %ebx,%eax
  801f5d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801f61:	d3 e0                	shl    %cl,%eax
  801f63:	89 e9                	mov    %ebp,%ecx
  801f65:	d3 ea                	shr    %cl,%edx
  801f67:	09 d0                	or     %edx,%eax
  801f69:	89 e9                	mov    %ebp,%ecx
  801f6b:	d3 eb                	shr    %cl,%ebx
  801f6d:	89 da                	mov    %ebx,%edx
  801f6f:	83 c4 1c             	add    $0x1c,%esp
  801f72:	5b                   	pop    %ebx
  801f73:	5e                   	pop    %esi
  801f74:	5f                   	pop    %edi
  801f75:	5d                   	pop    %ebp
  801f76:	c3                   	ret    
  801f77:	90                   	nop
  801f78:	89 fd                	mov    %edi,%ebp
  801f7a:	85 ff                	test   %edi,%edi
  801f7c:	75 0b                	jne    801f89 <__umoddi3+0xe9>
  801f7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f83:	31 d2                	xor    %edx,%edx
  801f85:	f7 f7                	div    %edi
  801f87:	89 c5                	mov    %eax,%ebp
  801f89:	89 f0                	mov    %esi,%eax
  801f8b:	31 d2                	xor    %edx,%edx
  801f8d:	f7 f5                	div    %ebp
  801f8f:	89 c8                	mov    %ecx,%eax
  801f91:	f7 f5                	div    %ebp
  801f93:	89 d0                	mov    %edx,%eax
  801f95:	e9 44 ff ff ff       	jmp    801ede <__umoddi3+0x3e>
  801f9a:	66 90                	xchg   %ax,%ax
  801f9c:	89 c8                	mov    %ecx,%eax
  801f9e:	89 f2                	mov    %esi,%edx
  801fa0:	83 c4 1c             	add    $0x1c,%esp
  801fa3:	5b                   	pop    %ebx
  801fa4:	5e                   	pop    %esi
  801fa5:	5f                   	pop    %edi
  801fa6:	5d                   	pop    %ebp
  801fa7:	c3                   	ret    
  801fa8:	3b 04 24             	cmp    (%esp),%eax
  801fab:	72 06                	jb     801fb3 <__umoddi3+0x113>
  801fad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801fb1:	77 0f                	ja     801fc2 <__umoddi3+0x122>
  801fb3:	89 f2                	mov    %esi,%edx
  801fb5:	29 f9                	sub    %edi,%ecx
  801fb7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801fbb:	89 14 24             	mov    %edx,(%esp)
  801fbe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fc2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fc6:	8b 14 24             	mov    (%esp),%edx
  801fc9:	83 c4 1c             	add    $0x1c,%esp
  801fcc:	5b                   	pop    %ebx
  801fcd:	5e                   	pop    %esi
  801fce:	5f                   	pop    %edi
  801fcf:	5d                   	pop    %ebp
  801fd0:	c3                   	ret    
  801fd1:	8d 76 00             	lea    0x0(%esi),%esi
  801fd4:	2b 04 24             	sub    (%esp),%eax
  801fd7:	19 fa                	sbb    %edi,%edx
  801fd9:	89 d1                	mov    %edx,%ecx
  801fdb:	89 c6                	mov    %eax,%esi
  801fdd:	e9 71 ff ff ff       	jmp    801f53 <__umoddi3+0xb3>
  801fe2:	66 90                	xchg   %ax,%ax
  801fe4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801fe8:	72 ea                	jb     801fd4 <__umoddi3+0x134>
  801fea:	89 d9                	mov    %ebx,%ecx
  801fec:	e9 62 ff ff ff       	jmp    801f53 <__umoddi3+0xb3>
