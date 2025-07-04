
obj/user/tst_free_1_slave1:     file format elf32-i386


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
  800031:	e8 b7 02 00 00       	call   8002ed <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec b0 00 00 00    	sub    $0xb0,%esp
	 *********************************************************/
#if USE_KHEAP
	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800043:	a1 20 50 80 00       	mov    0x805020,%eax
  800048:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  80004e:	a1 20 50 80 00       	mov    0x805020,%eax
  800053:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800059:	39 c2                	cmp    %eax,%edx
  80005b:	72 14                	jb     800071 <_main+0x39>
			panic("Please increase the WS size");
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 00 37 80 00       	push   $0x803700
  800065:	6a 11                	push   $0x11
  800067:	68 1c 37 80 00       	push   $0x80371c
  80006c:	e8 c1 03 00 00       	call   800432 <_panic>
	//	malloc(0);
	/*=================================================*/
#else
	panic("not handled!");
#endif
	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800071:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int Mega = 1024*1024;
  800078:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  80007f:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	char minByte = 1<<7;
  800086:	c6 45 eb 80          	movb   $0x80,-0x15(%ebp)
	char maxByte = 0x7F;
  80008a:	c6 45 ea 7f          	movb   $0x7f,-0x16(%ebp)
	short minShort = 1<<15 ;
  80008e:	66 c7 45 e8 00 80    	movw   $0x8000,-0x18(%ebp)
	short maxShort = 0x7FFF;
  800094:	66 c7 45 e6 ff 7f    	movw   $0x7fff,-0x1a(%ebp)
	int minInt = 1<<31 ;
  80009a:	c7 45 e0 00 00 00 80 	movl   $0x80000000,-0x20(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000a1:	c7 45 dc ff ff ff 7f 	movl   $0x7fffffff,-0x24(%ebp)
	char *byteArr ;
	int lastIndexOfByte;

	int freeFrames, usedDiskPages, chk;
	int expectedNumOfFrames, actualNumOfFrames;
	void* ptr_allocations[20] = {0};
  8000a8:	8d 95 60 ff ff ff    	lea    -0xa0(%ebp),%edx
  8000ae:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b8:	89 d7                	mov    %edx,%edi
  8000ba:	f3 ab                	rep stos %eax,%es:(%edi)
	//ALLOCATE ONE SPACE
	{
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8000bc:	e8 b3 1b 00 00       	call   801c74 <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 f6 1b 00 00       	call   801cbf <sys_pf_calculate_allocated_pages>
  8000c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  8000cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000cf:	01 c0                	add    %eax,%eax
  8000d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	50                   	push   %eax
  8000d8:	e8 c2 13 00 00       	call   80149f <malloc>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000e6:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8000ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000ef:	74 14                	je     800105 <_main+0xcd>
  8000f1:	83 ec 04             	sub    $0x4,%esp
  8000f4:	68 38 37 80 00       	push   $0x803738
  8000f9:	6a 32                	push   $0x32
  8000fb:	68 1c 37 80 00       	push   $0x80371c
  800100:	e8 2d 03 00 00       	call   800432 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 b5 1b 00 00       	call   801cbf <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 68 37 80 00       	push   $0x803768
  800117:	6a 33                	push   $0x33
  800119:	68 1c 37 80 00       	push   $0x80371c
  80011e:	e8 0f 03 00 00       	call   800432 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 4c 1b 00 00       	call   801c74 <sys_calculate_free_frames>
  800128:	89 45 d8             	mov    %eax,-0x28(%ebp)
			lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80012b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80012e:	01 c0                	add    %eax,%eax
  800130:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800133:	48                   	dec    %eax
  800134:	89 45 d0             	mov    %eax,-0x30(%ebp)
			byteArr = (char *) ptr_allocations[0];
  800137:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80013d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			byteArr[0] = minByte ;
  800140:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800143:	8a 55 eb             	mov    -0x15(%ebp),%dl
  800146:	88 10                	mov    %dl,(%eax)
			byteArr[lastIndexOfByte] = maxByte ;
  800148:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80014b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80014e:	01 c2                	add    %eax,%edx
  800150:	8a 45 ea             	mov    -0x16(%ebp),%al
  800153:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/ ;
  800155:	c7 45 c8 02 00 00 00 	movl   $0x2,-0x38(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80015c:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  80015f:	e8 10 1b 00 00       	call   801c74 <sys_calculate_free_frames>
  800164:	29 c3                	sub    %eax,%ebx
  800166:	89 d8                	mov    %ebx,%eax
  800168:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  80016b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80016e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800171:	7d 1a                	jge    80018d <_main+0x155>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	ff 75 c4             	pushl  -0x3c(%ebp)
  800179:	ff 75 c8             	pushl  -0x38(%ebp)
  80017c:	68 98 37 80 00       	push   $0x803798
  800181:	6a 3d                	push   $0x3d
  800183:	68 1c 37 80 00       	push   $0x80371c
  800188:	e8 a5 02 00 00       	call   800432 <_panic>

			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  80018d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800190:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800193:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800196:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019b:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  8001a1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8001a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001a7:	01 d0                	add    %edx,%eax
  8001a9:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8001ac:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001b4:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
			chk = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8001ba:	6a 02                	push   $0x2
  8001bc:	6a 00                	push   $0x0
  8001be:	6a 02                	push   $0x2
  8001c0:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  8001c6:	50                   	push   %eax
  8001c7:	e8 03 1f 00 00       	call   8020cf <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 14 38 80 00       	push   $0x803814
  8001e0:	6a 41                	push   $0x41
  8001e2:	68 1c 37 80 00       	push   $0x80371c
  8001e7:	e8 46 02 00 00       	call   800432 <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 83 1a 00 00       	call   801c74 <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 c6 1a 00 00       	call   801cbf <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 4a 14 00 00       	call   801655 <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 ac 1a 00 00       	call   801cbf <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 34 38 80 00       	push   $0x803834
  800220:	6a 4e                	push   $0x4e
  800222:	68 1c 37 80 00       	push   $0x80371c
  800227:	e8 06 02 00 00       	call   800432 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 43 1a 00 00       	call   801c74 <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 70 38 80 00       	push   $0x803870
  800247:	6a 4f                	push   $0x4f
  800249:	68 1c 37 80 00       	push   $0x80371c
  80024e:	e8 df 01 00 00       	call   800432 <_panic>
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800253:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800256:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800259:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80025c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800261:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800267:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80026a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80026d:	01 d0                	add    %edx,%eax
  80026f:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800272:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800275:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027a:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800280:	6a 03                	push   $0x3
  800282:	6a 00                	push   $0x0
  800284:	6a 02                	push   $0x2
  800286:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  80028c:	50                   	push   %eax
  80028d:	e8 3d 1e 00 00       	call   8020cf <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 bc 38 80 00       	push   $0x8038bc
  8002a6:	6a 52                	push   $0x52
  8002a8:	68 1c 37 80 00       	push   $0x80371c
  8002ad:	e8 80 01 00 00       	call   800432 <_panic>
		}
	}
	inctst(); //to ensure that it reached here
  8002b2:	e8 c4 1c 00 00       	call   801f7b <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  8002b7:	90                   	nop
  8002b8:	e8 d8 1c 00 00       	call   801f95 <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	75 f6                	jne    8002b8 <_main+0x280>

	//Test accessing a freed area but NOT ACCESSED Before (processes should be killed by the validation of the fault handler)
	{
		byteArr[8*kilo] = minByte ;
  8002c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002c5:	c1 e0 03             	shl    $0x3,%eax
  8002c8:	89 c2                	mov    %eax,%edx
  8002ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002cd:	01 c2                	add    %eax,%edx
  8002cf:	8a 45 eb             	mov    -0x15(%ebp),%al
  8002d2:	88 02                	mov    %al,(%edx)
		inctst();
  8002d4:	e8 a2 1c 00 00       	call   801f7b <inctst>
		panic("tst_free_1_slave2 failed: The env must be killed and shouldn't return here.");
  8002d9:	83 ec 04             	sub    $0x4,%esp
  8002dc:	68 e0 38 80 00       	push   $0x8038e0
  8002e1:	6a 5e                	push   $0x5e
  8002e3:	68 1c 37 80 00       	push   $0x80371c
  8002e8:	e8 45 01 00 00       	call   800432 <_panic>

008002ed <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002ed:	55                   	push   %ebp
  8002ee:	89 e5                	mov    %esp,%ebp
  8002f0:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002f3:	e8 45 1b 00 00       	call   801e3d <sys_getenvindex>
  8002f8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8002fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002fe:	89 d0                	mov    %edx,%eax
  800300:	c1 e0 02             	shl    $0x2,%eax
  800303:	01 d0                	add    %edx,%eax
  800305:	c1 e0 03             	shl    $0x3,%eax
  800308:	01 d0                	add    %edx,%eax
  80030a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800311:	01 d0                	add    %edx,%eax
  800313:	c1 e0 02             	shl    $0x2,%eax
  800316:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80031b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800320:	a1 20 50 80 00       	mov    0x805020,%eax
  800325:	8a 40 20             	mov    0x20(%eax),%al
  800328:	84 c0                	test   %al,%al
  80032a:	74 0d                	je     800339 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  80032c:	a1 20 50 80 00       	mov    0x805020,%eax
  800331:	83 c0 20             	add    $0x20,%eax
  800334:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800339:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80033d:	7e 0a                	jle    800349 <libmain+0x5c>
		binaryname = argv[0];
  80033f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800342:	8b 00                	mov    (%eax),%eax
  800344:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800349:	83 ec 08             	sub    $0x8,%esp
  80034c:	ff 75 0c             	pushl  0xc(%ebp)
  80034f:	ff 75 08             	pushl  0x8(%ebp)
  800352:	e8 e1 fc ff ff       	call   800038 <_main>
  800357:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80035a:	a1 00 50 80 00       	mov    0x805000,%eax
  80035f:	85 c0                	test   %eax,%eax
  800361:	0f 84 9f 00 00 00    	je     800406 <libmain+0x119>
	{
		sys_lock_cons();
  800367:	e8 55 18 00 00       	call   801bc1 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80036c:	83 ec 0c             	sub    $0xc,%esp
  80036f:	68 44 39 80 00       	push   $0x803944
  800374:	e8 76 03 00 00       	call   8006ef <cprintf>
  800379:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80037c:	a1 20 50 80 00       	mov    0x805020,%eax
  800381:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800387:	a1 20 50 80 00       	mov    0x805020,%eax
  80038c:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800392:	83 ec 04             	sub    $0x4,%esp
  800395:	52                   	push   %edx
  800396:	50                   	push   %eax
  800397:	68 6c 39 80 00       	push   $0x80396c
  80039c:	e8 4e 03 00 00       	call   8006ef <cprintf>
  8003a1:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8003a9:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8003af:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b4:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8003ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8003bf:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8003c5:	51                   	push   %ecx
  8003c6:	52                   	push   %edx
  8003c7:	50                   	push   %eax
  8003c8:	68 94 39 80 00       	push   $0x803994
  8003cd:	e8 1d 03 00 00       	call   8006ef <cprintf>
  8003d2:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003d5:	a1 20 50 80 00       	mov    0x805020,%eax
  8003da:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8003e0:	83 ec 08             	sub    $0x8,%esp
  8003e3:	50                   	push   %eax
  8003e4:	68 ec 39 80 00       	push   $0x8039ec
  8003e9:	e8 01 03 00 00       	call   8006ef <cprintf>
  8003ee:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003f1:	83 ec 0c             	sub    $0xc,%esp
  8003f4:	68 44 39 80 00       	push   $0x803944
  8003f9:	e8 f1 02 00 00       	call   8006ef <cprintf>
  8003fe:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800401:	e8 d5 17 00 00       	call   801bdb <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800406:	e8 19 00 00 00       	call   800424 <exit>
}
  80040b:	90                   	nop
  80040c:	c9                   	leave  
  80040d:	c3                   	ret    

0080040e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
  800411:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800414:	83 ec 0c             	sub    $0xc,%esp
  800417:	6a 00                	push   $0x0
  800419:	e8 eb 19 00 00       	call   801e09 <sys_destroy_env>
  80041e:	83 c4 10             	add    $0x10,%esp
}
  800421:	90                   	nop
  800422:	c9                   	leave  
  800423:	c3                   	ret    

00800424 <exit>:

void
exit(void)
{
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80042a:	e8 40 1a 00 00       	call   801e6f <sys_exit_env>
}
  80042f:	90                   	nop
  800430:	c9                   	leave  
  800431:	c3                   	ret    

00800432 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800432:	55                   	push   %ebp
  800433:	89 e5                	mov    %esp,%ebp
  800435:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800438:	8d 45 10             	lea    0x10(%ebp),%eax
  80043b:	83 c0 04             	add    $0x4,%eax
  80043e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800441:	a1 60 50 98 00       	mov    0x985060,%eax
  800446:	85 c0                	test   %eax,%eax
  800448:	74 16                	je     800460 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80044a:	a1 60 50 98 00       	mov    0x985060,%eax
  80044f:	83 ec 08             	sub    $0x8,%esp
  800452:	50                   	push   %eax
  800453:	68 00 3a 80 00       	push   $0x803a00
  800458:	e8 92 02 00 00       	call   8006ef <cprintf>
  80045d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800460:	a1 04 50 80 00       	mov    0x805004,%eax
  800465:	ff 75 0c             	pushl  0xc(%ebp)
  800468:	ff 75 08             	pushl  0x8(%ebp)
  80046b:	50                   	push   %eax
  80046c:	68 05 3a 80 00       	push   $0x803a05
  800471:	e8 79 02 00 00       	call   8006ef <cprintf>
  800476:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800479:	8b 45 10             	mov    0x10(%ebp),%eax
  80047c:	83 ec 08             	sub    $0x8,%esp
  80047f:	ff 75 f4             	pushl  -0xc(%ebp)
  800482:	50                   	push   %eax
  800483:	e8 fc 01 00 00       	call   800684 <vcprintf>
  800488:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80048b:	83 ec 08             	sub    $0x8,%esp
  80048e:	6a 00                	push   $0x0
  800490:	68 21 3a 80 00       	push   $0x803a21
  800495:	e8 ea 01 00 00       	call   800684 <vcprintf>
  80049a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80049d:	e8 82 ff ff ff       	call   800424 <exit>

	// should not return here
	while (1) ;
  8004a2:	eb fe                	jmp    8004a2 <_panic+0x70>

008004a4 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004a4:	55                   	push   %ebp
  8004a5:	89 e5                	mov    %esp,%ebp
  8004a7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8004af:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8004b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b8:	39 c2                	cmp    %eax,%edx
  8004ba:	74 14                	je     8004d0 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004bc:	83 ec 04             	sub    $0x4,%esp
  8004bf:	68 24 3a 80 00       	push   $0x803a24
  8004c4:	6a 26                	push   $0x26
  8004c6:	68 70 3a 80 00       	push   $0x803a70
  8004cb:	e8 62 ff ff ff       	call   800432 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004de:	e9 c5 00 00 00       	jmp    8005a8 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f0:	01 d0                	add    %edx,%eax
  8004f2:	8b 00                	mov    (%eax),%eax
  8004f4:	85 c0                	test   %eax,%eax
  8004f6:	75 08                	jne    800500 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004f8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004fb:	e9 a5 00 00 00       	jmp    8005a5 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800500:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800507:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80050e:	eb 69                	jmp    800579 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800510:	a1 20 50 80 00       	mov    0x805020,%eax
  800515:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80051b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80051e:	89 d0                	mov    %edx,%eax
  800520:	01 c0                	add    %eax,%eax
  800522:	01 d0                	add    %edx,%eax
  800524:	c1 e0 03             	shl    $0x3,%eax
  800527:	01 c8                	add    %ecx,%eax
  800529:	8a 40 04             	mov    0x4(%eax),%al
  80052c:	84 c0                	test   %al,%al
  80052e:	75 46                	jne    800576 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800530:	a1 20 50 80 00       	mov    0x805020,%eax
  800535:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80053b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80053e:	89 d0                	mov    %edx,%eax
  800540:	01 c0                	add    %eax,%eax
  800542:	01 d0                	add    %edx,%eax
  800544:	c1 e0 03             	shl    $0x3,%eax
  800547:	01 c8                	add    %ecx,%eax
  800549:	8b 00                	mov    (%eax),%eax
  80054b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80054e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800551:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800556:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800558:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80055b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800562:	8b 45 08             	mov    0x8(%ebp),%eax
  800565:	01 c8                	add    %ecx,%eax
  800567:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800569:	39 c2                	cmp    %eax,%edx
  80056b:	75 09                	jne    800576 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80056d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800574:	eb 15                	jmp    80058b <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800576:	ff 45 e8             	incl   -0x18(%ebp)
  800579:	a1 20 50 80 00       	mov    0x805020,%eax
  80057e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800584:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800587:	39 c2                	cmp    %eax,%edx
  800589:	77 85                	ja     800510 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80058b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80058f:	75 14                	jne    8005a5 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800591:	83 ec 04             	sub    $0x4,%esp
  800594:	68 7c 3a 80 00       	push   $0x803a7c
  800599:	6a 3a                	push   $0x3a
  80059b:	68 70 3a 80 00       	push   $0x803a70
  8005a0:	e8 8d fe ff ff       	call   800432 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005a5:	ff 45 f0             	incl   -0x10(%ebp)
  8005a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ab:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005ae:	0f 8c 2f ff ff ff    	jl     8004e3 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005b4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005c2:	eb 26                	jmp    8005ea <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005c4:	a1 20 50 80 00       	mov    0x805020,%eax
  8005c9:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8005cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005d2:	89 d0                	mov    %edx,%eax
  8005d4:	01 c0                	add    %eax,%eax
  8005d6:	01 d0                	add    %edx,%eax
  8005d8:	c1 e0 03             	shl    $0x3,%eax
  8005db:	01 c8                	add    %ecx,%eax
  8005dd:	8a 40 04             	mov    0x4(%eax),%al
  8005e0:	3c 01                	cmp    $0x1,%al
  8005e2:	75 03                	jne    8005e7 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005e4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e7:	ff 45 e0             	incl   -0x20(%ebp)
  8005ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ef:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8005f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f8:	39 c2                	cmp    %eax,%edx
  8005fa:	77 c8                	ja     8005c4 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005ff:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800602:	74 14                	je     800618 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800604:	83 ec 04             	sub    $0x4,%esp
  800607:	68 d0 3a 80 00       	push   $0x803ad0
  80060c:	6a 44                	push   $0x44
  80060e:	68 70 3a 80 00       	push   $0x803a70
  800613:	e8 1a fe ff ff       	call   800432 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800618:	90                   	nop
  800619:	c9                   	leave  
  80061a:	c3                   	ret    

0080061b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80061b:	55                   	push   %ebp
  80061c:	89 e5                	mov    %esp,%ebp
  80061e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800621:	8b 45 0c             	mov    0xc(%ebp),%eax
  800624:	8b 00                	mov    (%eax),%eax
  800626:	8d 48 01             	lea    0x1(%eax),%ecx
  800629:	8b 55 0c             	mov    0xc(%ebp),%edx
  80062c:	89 0a                	mov    %ecx,(%edx)
  80062e:	8b 55 08             	mov    0x8(%ebp),%edx
  800631:	88 d1                	mov    %dl,%cl
  800633:	8b 55 0c             	mov    0xc(%ebp),%edx
  800636:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80063a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800644:	75 2c                	jne    800672 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800646:	a0 44 50 98 00       	mov    0x985044,%al
  80064b:	0f b6 c0             	movzbl %al,%eax
  80064e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800651:	8b 12                	mov    (%edx),%edx
  800653:	89 d1                	mov    %edx,%ecx
  800655:	8b 55 0c             	mov    0xc(%ebp),%edx
  800658:	83 c2 08             	add    $0x8,%edx
  80065b:	83 ec 04             	sub    $0x4,%esp
  80065e:	50                   	push   %eax
  80065f:	51                   	push   %ecx
  800660:	52                   	push   %edx
  800661:	e8 19 15 00 00       	call   801b7f <sys_cputs>
  800666:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800669:	8b 45 0c             	mov    0xc(%ebp),%eax
  80066c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800672:	8b 45 0c             	mov    0xc(%ebp),%eax
  800675:	8b 40 04             	mov    0x4(%eax),%eax
  800678:	8d 50 01             	lea    0x1(%eax),%edx
  80067b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80067e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800681:	90                   	nop
  800682:	c9                   	leave  
  800683:	c3                   	ret    

00800684 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800684:	55                   	push   %ebp
  800685:	89 e5                	mov    %esp,%ebp
  800687:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80068d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800694:	00 00 00 
	b.cnt = 0;
  800697:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80069e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006a1:	ff 75 0c             	pushl  0xc(%ebp)
  8006a4:	ff 75 08             	pushl  0x8(%ebp)
  8006a7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006ad:	50                   	push   %eax
  8006ae:	68 1b 06 80 00       	push   $0x80061b
  8006b3:	e8 11 02 00 00       	call   8008c9 <vprintfmt>
  8006b8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8006bb:	a0 44 50 98 00       	mov    0x985044,%al
  8006c0:	0f b6 c0             	movzbl %al,%eax
  8006c3:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8006c9:	83 ec 04             	sub    $0x4,%esp
  8006cc:	50                   	push   %eax
  8006cd:	52                   	push   %edx
  8006ce:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006d4:	83 c0 08             	add    $0x8,%eax
  8006d7:	50                   	push   %eax
  8006d8:	e8 a2 14 00 00       	call   801b7f <sys_cputs>
  8006dd:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006e0:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  8006e7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006ed:	c9                   	leave  
  8006ee:	c3                   	ret    

008006ef <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006ef:	55                   	push   %ebp
  8006f0:	89 e5                	mov    %esp,%ebp
  8006f2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006f5:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  8006fc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	83 ec 08             	sub    $0x8,%esp
  800708:	ff 75 f4             	pushl  -0xc(%ebp)
  80070b:	50                   	push   %eax
  80070c:	e8 73 ff ff ff       	call   800684 <vcprintf>
  800711:	83 c4 10             	add    $0x10,%esp
  800714:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800717:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80071a:	c9                   	leave  
  80071b:	c3                   	ret    

0080071c <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80071c:	55                   	push   %ebp
  80071d:	89 e5                	mov    %esp,%ebp
  80071f:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800722:	e8 9a 14 00 00       	call   801bc1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800727:	8d 45 0c             	lea    0xc(%ebp),%eax
  80072a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80072d:	8b 45 08             	mov    0x8(%ebp),%eax
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	ff 75 f4             	pushl  -0xc(%ebp)
  800736:	50                   	push   %eax
  800737:	e8 48 ff ff ff       	call   800684 <vcprintf>
  80073c:	83 c4 10             	add    $0x10,%esp
  80073f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800742:	e8 94 14 00 00       	call   801bdb <sys_unlock_cons>
	return cnt;
  800747:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80074a:	c9                   	leave  
  80074b:	c3                   	ret    

0080074c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80074c:	55                   	push   %ebp
  80074d:	89 e5                	mov    %esp,%ebp
  80074f:	53                   	push   %ebx
  800750:	83 ec 14             	sub    $0x14,%esp
  800753:	8b 45 10             	mov    0x10(%ebp),%eax
  800756:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80075f:	8b 45 18             	mov    0x18(%ebp),%eax
  800762:	ba 00 00 00 00       	mov    $0x0,%edx
  800767:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80076a:	77 55                	ja     8007c1 <printnum+0x75>
  80076c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80076f:	72 05                	jb     800776 <printnum+0x2a>
  800771:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800774:	77 4b                	ja     8007c1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800776:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800779:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80077c:	8b 45 18             	mov    0x18(%ebp),%eax
  80077f:	ba 00 00 00 00       	mov    $0x0,%edx
  800784:	52                   	push   %edx
  800785:	50                   	push   %eax
  800786:	ff 75 f4             	pushl  -0xc(%ebp)
  800789:	ff 75 f0             	pushl  -0x10(%ebp)
  80078c:	e8 ef 2c 00 00       	call   803480 <__udivdi3>
  800791:	83 c4 10             	add    $0x10,%esp
  800794:	83 ec 04             	sub    $0x4,%esp
  800797:	ff 75 20             	pushl  0x20(%ebp)
  80079a:	53                   	push   %ebx
  80079b:	ff 75 18             	pushl  0x18(%ebp)
  80079e:	52                   	push   %edx
  80079f:	50                   	push   %eax
  8007a0:	ff 75 0c             	pushl  0xc(%ebp)
  8007a3:	ff 75 08             	pushl  0x8(%ebp)
  8007a6:	e8 a1 ff ff ff       	call   80074c <printnum>
  8007ab:	83 c4 20             	add    $0x20,%esp
  8007ae:	eb 1a                	jmp    8007ca <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007b0:	83 ec 08             	sub    $0x8,%esp
  8007b3:	ff 75 0c             	pushl  0xc(%ebp)
  8007b6:	ff 75 20             	pushl  0x20(%ebp)
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	ff d0                	call   *%eax
  8007be:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007c1:	ff 4d 1c             	decl   0x1c(%ebp)
  8007c4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007c8:	7f e6                	jg     8007b0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007ca:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d8:	53                   	push   %ebx
  8007d9:	51                   	push   %ecx
  8007da:	52                   	push   %edx
  8007db:	50                   	push   %eax
  8007dc:	e8 af 2d 00 00       	call   803590 <__umoddi3>
  8007e1:	83 c4 10             	add    $0x10,%esp
  8007e4:	05 34 3d 80 00       	add    $0x803d34,%eax
  8007e9:	8a 00                	mov    (%eax),%al
  8007eb:	0f be c0             	movsbl %al,%eax
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	ff 75 0c             	pushl  0xc(%ebp)
  8007f4:	50                   	push   %eax
  8007f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f8:	ff d0                	call   *%eax
  8007fa:	83 c4 10             	add    $0x10,%esp
}
  8007fd:	90                   	nop
  8007fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800801:	c9                   	leave  
  800802:	c3                   	ret    

00800803 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800806:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80080a:	7e 1c                	jle    800828 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80080c:	8b 45 08             	mov    0x8(%ebp),%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	8d 50 08             	lea    0x8(%eax),%edx
  800814:	8b 45 08             	mov    0x8(%ebp),%eax
  800817:	89 10                	mov    %edx,(%eax)
  800819:	8b 45 08             	mov    0x8(%ebp),%eax
  80081c:	8b 00                	mov    (%eax),%eax
  80081e:	83 e8 08             	sub    $0x8,%eax
  800821:	8b 50 04             	mov    0x4(%eax),%edx
  800824:	8b 00                	mov    (%eax),%eax
  800826:	eb 40                	jmp    800868 <getuint+0x65>
	else if (lflag)
  800828:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80082c:	74 1e                	je     80084c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80082e:	8b 45 08             	mov    0x8(%ebp),%eax
  800831:	8b 00                	mov    (%eax),%eax
  800833:	8d 50 04             	lea    0x4(%eax),%edx
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	89 10                	mov    %edx,(%eax)
  80083b:	8b 45 08             	mov    0x8(%ebp),%eax
  80083e:	8b 00                	mov    (%eax),%eax
  800840:	83 e8 04             	sub    $0x4,%eax
  800843:	8b 00                	mov    (%eax),%eax
  800845:	ba 00 00 00 00       	mov    $0x0,%edx
  80084a:	eb 1c                	jmp    800868 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	8b 00                	mov    (%eax),%eax
  800851:	8d 50 04             	lea    0x4(%eax),%edx
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	89 10                	mov    %edx,(%eax)
  800859:	8b 45 08             	mov    0x8(%ebp),%eax
  80085c:	8b 00                	mov    (%eax),%eax
  80085e:	83 e8 04             	sub    $0x4,%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800868:	5d                   	pop    %ebp
  800869:	c3                   	ret    

0080086a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80086d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800871:	7e 1c                	jle    80088f <getint+0x25>
		return va_arg(*ap, long long);
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	8b 00                	mov    (%eax),%eax
  800878:	8d 50 08             	lea    0x8(%eax),%edx
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	89 10                	mov    %edx,(%eax)
  800880:	8b 45 08             	mov    0x8(%ebp),%eax
  800883:	8b 00                	mov    (%eax),%eax
  800885:	83 e8 08             	sub    $0x8,%eax
  800888:	8b 50 04             	mov    0x4(%eax),%edx
  80088b:	8b 00                	mov    (%eax),%eax
  80088d:	eb 38                	jmp    8008c7 <getint+0x5d>
	else if (lflag)
  80088f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800893:	74 1a                	je     8008af <getint+0x45>
		return va_arg(*ap, long);
  800895:	8b 45 08             	mov    0x8(%ebp),%eax
  800898:	8b 00                	mov    (%eax),%eax
  80089a:	8d 50 04             	lea    0x4(%eax),%edx
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	89 10                	mov    %edx,(%eax)
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	83 e8 04             	sub    $0x4,%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	99                   	cltd   
  8008ad:	eb 18                	jmp    8008c7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	8b 00                	mov    (%eax),%eax
  8008b4:	8d 50 04             	lea    0x4(%eax),%edx
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	89 10                	mov    %edx,(%eax)
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	83 e8 04             	sub    $0x4,%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	99                   	cltd   
}
  8008c7:	5d                   	pop    %ebp
  8008c8:	c3                   	ret    

008008c9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	56                   	push   %esi
  8008cd:	53                   	push   %ebx
  8008ce:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008d1:	eb 17                	jmp    8008ea <vprintfmt+0x21>
			if (ch == '\0')
  8008d3:	85 db                	test   %ebx,%ebx
  8008d5:	0f 84 c1 03 00 00    	je     800c9c <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8008db:	83 ec 08             	sub    $0x8,%esp
  8008de:	ff 75 0c             	pushl  0xc(%ebp)
  8008e1:	53                   	push   %ebx
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	ff d0                	call   *%eax
  8008e7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ed:	8d 50 01             	lea    0x1(%eax),%edx
  8008f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8008f3:	8a 00                	mov    (%eax),%al
  8008f5:	0f b6 d8             	movzbl %al,%ebx
  8008f8:	83 fb 25             	cmp    $0x25,%ebx
  8008fb:	75 d6                	jne    8008d3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008fd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800901:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800908:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80090f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800916:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80091d:	8b 45 10             	mov    0x10(%ebp),%eax
  800920:	8d 50 01             	lea    0x1(%eax),%edx
  800923:	89 55 10             	mov    %edx,0x10(%ebp)
  800926:	8a 00                	mov    (%eax),%al
  800928:	0f b6 d8             	movzbl %al,%ebx
  80092b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80092e:	83 f8 5b             	cmp    $0x5b,%eax
  800931:	0f 87 3d 03 00 00    	ja     800c74 <vprintfmt+0x3ab>
  800937:	8b 04 85 58 3d 80 00 	mov    0x803d58(,%eax,4),%eax
  80093e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800940:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800944:	eb d7                	jmp    80091d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800946:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80094a:	eb d1                	jmp    80091d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80094c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800953:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800956:	89 d0                	mov    %edx,%eax
  800958:	c1 e0 02             	shl    $0x2,%eax
  80095b:	01 d0                	add    %edx,%eax
  80095d:	01 c0                	add    %eax,%eax
  80095f:	01 d8                	add    %ebx,%eax
  800961:	83 e8 30             	sub    $0x30,%eax
  800964:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800967:	8b 45 10             	mov    0x10(%ebp),%eax
  80096a:	8a 00                	mov    (%eax),%al
  80096c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80096f:	83 fb 2f             	cmp    $0x2f,%ebx
  800972:	7e 3e                	jle    8009b2 <vprintfmt+0xe9>
  800974:	83 fb 39             	cmp    $0x39,%ebx
  800977:	7f 39                	jg     8009b2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800979:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80097c:	eb d5                	jmp    800953 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80097e:	8b 45 14             	mov    0x14(%ebp),%eax
  800981:	83 c0 04             	add    $0x4,%eax
  800984:	89 45 14             	mov    %eax,0x14(%ebp)
  800987:	8b 45 14             	mov    0x14(%ebp),%eax
  80098a:	83 e8 04             	sub    $0x4,%eax
  80098d:	8b 00                	mov    (%eax),%eax
  80098f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800992:	eb 1f                	jmp    8009b3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800994:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800998:	79 83                	jns    80091d <vprintfmt+0x54>
				width = 0;
  80099a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009a1:	e9 77 ff ff ff       	jmp    80091d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009a6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009ad:	e9 6b ff ff ff       	jmp    80091d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009b2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b7:	0f 89 60 ff ff ff    	jns    80091d <vprintfmt+0x54>
				width = precision, precision = -1;
  8009bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009c3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009ca:	e9 4e ff ff ff       	jmp    80091d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009cf:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009d2:	e9 46 ff ff ff       	jmp    80091d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009da:	83 c0 04             	add    $0x4,%eax
  8009dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8009e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e3:	83 e8 04             	sub    $0x4,%eax
  8009e6:	8b 00                	mov    (%eax),%eax
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	50                   	push   %eax
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	ff d0                	call   *%eax
  8009f4:	83 c4 10             	add    $0x10,%esp
			break;
  8009f7:	e9 9b 02 00 00       	jmp    800c97 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ff:	83 c0 04             	add    $0x4,%eax
  800a02:	89 45 14             	mov    %eax,0x14(%ebp)
  800a05:	8b 45 14             	mov    0x14(%ebp),%eax
  800a08:	83 e8 04             	sub    $0x4,%eax
  800a0b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a0d:	85 db                	test   %ebx,%ebx
  800a0f:	79 02                	jns    800a13 <vprintfmt+0x14a>
				err = -err;
  800a11:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a13:	83 fb 64             	cmp    $0x64,%ebx
  800a16:	7f 0b                	jg     800a23 <vprintfmt+0x15a>
  800a18:	8b 34 9d a0 3b 80 00 	mov    0x803ba0(,%ebx,4),%esi
  800a1f:	85 f6                	test   %esi,%esi
  800a21:	75 19                	jne    800a3c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a23:	53                   	push   %ebx
  800a24:	68 45 3d 80 00       	push   $0x803d45
  800a29:	ff 75 0c             	pushl  0xc(%ebp)
  800a2c:	ff 75 08             	pushl  0x8(%ebp)
  800a2f:	e8 70 02 00 00       	call   800ca4 <printfmt>
  800a34:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a37:	e9 5b 02 00 00       	jmp    800c97 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a3c:	56                   	push   %esi
  800a3d:	68 4e 3d 80 00       	push   $0x803d4e
  800a42:	ff 75 0c             	pushl  0xc(%ebp)
  800a45:	ff 75 08             	pushl  0x8(%ebp)
  800a48:	e8 57 02 00 00       	call   800ca4 <printfmt>
  800a4d:	83 c4 10             	add    $0x10,%esp
			break;
  800a50:	e9 42 02 00 00       	jmp    800c97 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a55:	8b 45 14             	mov    0x14(%ebp),%eax
  800a58:	83 c0 04             	add    $0x4,%eax
  800a5b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a61:	83 e8 04             	sub    $0x4,%eax
  800a64:	8b 30                	mov    (%eax),%esi
  800a66:	85 f6                	test   %esi,%esi
  800a68:	75 05                	jne    800a6f <vprintfmt+0x1a6>
				p = "(null)";
  800a6a:	be 51 3d 80 00       	mov    $0x803d51,%esi
			if (width > 0 && padc != '-')
  800a6f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a73:	7e 6d                	jle    800ae2 <vprintfmt+0x219>
  800a75:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a79:	74 67                	je     800ae2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a7e:	83 ec 08             	sub    $0x8,%esp
  800a81:	50                   	push   %eax
  800a82:	56                   	push   %esi
  800a83:	e8 1e 03 00 00       	call   800da6 <strnlen>
  800a88:	83 c4 10             	add    $0x10,%esp
  800a8b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a8e:	eb 16                	jmp    800aa6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a90:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a94:	83 ec 08             	sub    $0x8,%esp
  800a97:	ff 75 0c             	pushl  0xc(%ebp)
  800a9a:	50                   	push   %eax
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	ff d0                	call   *%eax
  800aa0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800aa3:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aaa:	7f e4                	jg     800a90 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aac:	eb 34                	jmp    800ae2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800aae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ab2:	74 1c                	je     800ad0 <vprintfmt+0x207>
  800ab4:	83 fb 1f             	cmp    $0x1f,%ebx
  800ab7:	7e 05                	jle    800abe <vprintfmt+0x1f5>
  800ab9:	83 fb 7e             	cmp    $0x7e,%ebx
  800abc:	7e 12                	jle    800ad0 <vprintfmt+0x207>
					putch('?', putdat);
  800abe:	83 ec 08             	sub    $0x8,%esp
  800ac1:	ff 75 0c             	pushl  0xc(%ebp)
  800ac4:	6a 3f                	push   $0x3f
  800ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac9:	ff d0                	call   *%eax
  800acb:	83 c4 10             	add    $0x10,%esp
  800ace:	eb 0f                	jmp    800adf <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ad0:	83 ec 08             	sub    $0x8,%esp
  800ad3:	ff 75 0c             	pushl  0xc(%ebp)
  800ad6:	53                   	push   %ebx
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	ff d0                	call   *%eax
  800adc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800adf:	ff 4d e4             	decl   -0x1c(%ebp)
  800ae2:	89 f0                	mov    %esi,%eax
  800ae4:	8d 70 01             	lea    0x1(%eax),%esi
  800ae7:	8a 00                	mov    (%eax),%al
  800ae9:	0f be d8             	movsbl %al,%ebx
  800aec:	85 db                	test   %ebx,%ebx
  800aee:	74 24                	je     800b14 <vprintfmt+0x24b>
  800af0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800af4:	78 b8                	js     800aae <vprintfmt+0x1e5>
  800af6:	ff 4d e0             	decl   -0x20(%ebp)
  800af9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800afd:	79 af                	jns    800aae <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aff:	eb 13                	jmp    800b14 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b01:	83 ec 08             	sub    $0x8,%esp
  800b04:	ff 75 0c             	pushl  0xc(%ebp)
  800b07:	6a 20                	push   $0x20
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	ff d0                	call   *%eax
  800b0e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b11:	ff 4d e4             	decl   -0x1c(%ebp)
  800b14:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b18:	7f e7                	jg     800b01 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b1a:	e9 78 01 00 00       	jmp    800c97 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b1f:	83 ec 08             	sub    $0x8,%esp
  800b22:	ff 75 e8             	pushl  -0x18(%ebp)
  800b25:	8d 45 14             	lea    0x14(%ebp),%eax
  800b28:	50                   	push   %eax
  800b29:	e8 3c fd ff ff       	call   80086a <getint>
  800b2e:	83 c4 10             	add    $0x10,%esp
  800b31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b34:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b3d:	85 d2                	test   %edx,%edx
  800b3f:	79 23                	jns    800b64 <vprintfmt+0x29b>
				putch('-', putdat);
  800b41:	83 ec 08             	sub    $0x8,%esp
  800b44:	ff 75 0c             	pushl  0xc(%ebp)
  800b47:	6a 2d                	push   $0x2d
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	ff d0                	call   *%eax
  800b4e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b57:	f7 d8                	neg    %eax
  800b59:	83 d2 00             	adc    $0x0,%edx
  800b5c:	f7 da                	neg    %edx
  800b5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b61:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b64:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b6b:	e9 bc 00 00 00       	jmp    800c2c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b70:	83 ec 08             	sub    $0x8,%esp
  800b73:	ff 75 e8             	pushl  -0x18(%ebp)
  800b76:	8d 45 14             	lea    0x14(%ebp),%eax
  800b79:	50                   	push   %eax
  800b7a:	e8 84 fc ff ff       	call   800803 <getuint>
  800b7f:	83 c4 10             	add    $0x10,%esp
  800b82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b85:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b88:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b8f:	e9 98 00 00 00       	jmp    800c2c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b94:	83 ec 08             	sub    $0x8,%esp
  800b97:	ff 75 0c             	pushl  0xc(%ebp)
  800b9a:	6a 58                	push   $0x58
  800b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9f:	ff d0                	call   *%eax
  800ba1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ba4:	83 ec 08             	sub    $0x8,%esp
  800ba7:	ff 75 0c             	pushl  0xc(%ebp)
  800baa:	6a 58                	push   $0x58
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	ff d0                	call   *%eax
  800bb1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bb4:	83 ec 08             	sub    $0x8,%esp
  800bb7:	ff 75 0c             	pushl  0xc(%ebp)
  800bba:	6a 58                	push   $0x58
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	ff d0                	call   *%eax
  800bc1:	83 c4 10             	add    $0x10,%esp
			break;
  800bc4:	e9 ce 00 00 00       	jmp    800c97 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800bc9:	83 ec 08             	sub    $0x8,%esp
  800bcc:	ff 75 0c             	pushl  0xc(%ebp)
  800bcf:	6a 30                	push   $0x30
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	ff d0                	call   *%eax
  800bd6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800bd9:	83 ec 08             	sub    $0x8,%esp
  800bdc:	ff 75 0c             	pushl  0xc(%ebp)
  800bdf:	6a 78                	push   $0x78
  800be1:	8b 45 08             	mov    0x8(%ebp),%eax
  800be4:	ff d0                	call   *%eax
  800be6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800be9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bec:	83 c0 04             	add    $0x4,%eax
  800bef:	89 45 14             	mov    %eax,0x14(%ebp)
  800bf2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf5:	83 e8 04             	sub    $0x4,%eax
  800bf8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c04:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c0b:	eb 1f                	jmp    800c2c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c0d:	83 ec 08             	sub    $0x8,%esp
  800c10:	ff 75 e8             	pushl  -0x18(%ebp)
  800c13:	8d 45 14             	lea    0x14(%ebp),%eax
  800c16:	50                   	push   %eax
  800c17:	e8 e7 fb ff ff       	call   800803 <getuint>
  800c1c:	83 c4 10             	add    $0x10,%esp
  800c1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c25:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c2c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c33:	83 ec 04             	sub    $0x4,%esp
  800c36:	52                   	push   %edx
  800c37:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c3a:	50                   	push   %eax
  800c3b:	ff 75 f4             	pushl  -0xc(%ebp)
  800c3e:	ff 75 f0             	pushl  -0x10(%ebp)
  800c41:	ff 75 0c             	pushl  0xc(%ebp)
  800c44:	ff 75 08             	pushl  0x8(%ebp)
  800c47:	e8 00 fb ff ff       	call   80074c <printnum>
  800c4c:	83 c4 20             	add    $0x20,%esp
			break;
  800c4f:	eb 46                	jmp    800c97 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c51:	83 ec 08             	sub    $0x8,%esp
  800c54:	ff 75 0c             	pushl  0xc(%ebp)
  800c57:	53                   	push   %ebx
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	ff d0                	call   *%eax
  800c5d:	83 c4 10             	add    $0x10,%esp
			break;
  800c60:	eb 35                	jmp    800c97 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c62:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  800c69:	eb 2c                	jmp    800c97 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c6b:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  800c72:	eb 23                	jmp    800c97 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c74:	83 ec 08             	sub    $0x8,%esp
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	6a 25                	push   $0x25
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	ff d0                	call   *%eax
  800c81:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c84:	ff 4d 10             	decl   0x10(%ebp)
  800c87:	eb 03                	jmp    800c8c <vprintfmt+0x3c3>
  800c89:	ff 4d 10             	decl   0x10(%ebp)
  800c8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8f:	48                   	dec    %eax
  800c90:	8a 00                	mov    (%eax),%al
  800c92:	3c 25                	cmp    $0x25,%al
  800c94:	75 f3                	jne    800c89 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c96:	90                   	nop
		}
	}
  800c97:	e9 35 fc ff ff       	jmp    8008d1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c9c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c9d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ca0:	5b                   	pop    %ebx
  800ca1:	5e                   	pop    %esi
  800ca2:	5d                   	pop    %ebp
  800ca3:	c3                   	ret    

00800ca4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800caa:	8d 45 10             	lea    0x10(%ebp),%eax
  800cad:	83 c0 04             	add    $0x4,%eax
  800cb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb6:	ff 75 f4             	pushl  -0xc(%ebp)
  800cb9:	50                   	push   %eax
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	ff 75 08             	pushl  0x8(%ebp)
  800cc0:	e8 04 fc ff ff       	call   8008c9 <vprintfmt>
  800cc5:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800cc8:	90                   	nop
  800cc9:	c9                   	leave  
  800cca:	c3                   	ret    

00800ccb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ccb:	55                   	push   %ebp
  800ccc:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800cce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd1:	8b 40 08             	mov    0x8(%eax),%eax
  800cd4:	8d 50 01             	lea    0x1(%eax),%edx
  800cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cda:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8b 10                	mov    (%eax),%edx
  800ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce5:	8b 40 04             	mov    0x4(%eax),%eax
  800ce8:	39 c2                	cmp    %eax,%edx
  800cea:	73 12                	jae    800cfe <sprintputch+0x33>
		*b->buf++ = ch;
  800cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cef:	8b 00                	mov    (%eax),%eax
  800cf1:	8d 48 01             	lea    0x1(%eax),%ecx
  800cf4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf7:	89 0a                	mov    %ecx,(%edx)
  800cf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfc:	88 10                	mov    %dl,(%eax)
}
  800cfe:	90                   	nop
  800cff:	5d                   	pop    %ebp
  800d00:	c3                   	ret    

00800d01 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d01:	55                   	push   %ebp
  800d02:	89 e5                	mov    %esp,%ebp
  800d04:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	01 d0                	add    %edx,%eax
  800d18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d26:	74 06                	je     800d2e <vsnprintf+0x2d>
  800d28:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d2c:	7f 07                	jg     800d35 <vsnprintf+0x34>
		return -E_INVAL;
  800d2e:	b8 03 00 00 00       	mov    $0x3,%eax
  800d33:	eb 20                	jmp    800d55 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d35:	ff 75 14             	pushl  0x14(%ebp)
  800d38:	ff 75 10             	pushl  0x10(%ebp)
  800d3b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d3e:	50                   	push   %eax
  800d3f:	68 cb 0c 80 00       	push   $0x800ccb
  800d44:	e8 80 fb ff ff       	call   8008c9 <vprintfmt>
  800d49:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d4f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d55:	c9                   	leave  
  800d56:	c3                   	ret    

00800d57 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d5d:	8d 45 10             	lea    0x10(%ebp),%eax
  800d60:	83 c0 04             	add    $0x4,%eax
  800d63:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d66:	8b 45 10             	mov    0x10(%ebp),%eax
  800d69:	ff 75 f4             	pushl  -0xc(%ebp)
  800d6c:	50                   	push   %eax
  800d6d:	ff 75 0c             	pushl  0xc(%ebp)
  800d70:	ff 75 08             	pushl  0x8(%ebp)
  800d73:	e8 89 ff ff ff       	call   800d01 <vsnprintf>
  800d78:	83 c4 10             	add    $0x10,%esp
  800d7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d81:	c9                   	leave  
  800d82:	c3                   	ret    

00800d83 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d90:	eb 06                	jmp    800d98 <strlen+0x15>
		n++;
  800d92:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d95:	ff 45 08             	incl   0x8(%ebp)
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	8a 00                	mov    (%eax),%al
  800d9d:	84 c0                	test   %al,%al
  800d9f:	75 f1                	jne    800d92 <strlen+0xf>
		n++;
	return n;
  800da1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800da4:	c9                   	leave  
  800da5:	c3                   	ret    

00800da6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800db3:	eb 09                	jmp    800dbe <strnlen+0x18>
		n++;
  800db5:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800db8:	ff 45 08             	incl   0x8(%ebp)
  800dbb:	ff 4d 0c             	decl   0xc(%ebp)
  800dbe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dc2:	74 09                	je     800dcd <strnlen+0x27>
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	84 c0                	test   %al,%al
  800dcb:	75 e8                	jne    800db5 <strnlen+0xf>
		n++;
	return n;
  800dcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dd0:	c9                   	leave  
  800dd1:	c3                   	ret    

00800dd2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800dde:	90                   	nop
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	8d 50 01             	lea    0x1(%eax),%edx
  800de5:	89 55 08             	mov    %edx,0x8(%ebp)
  800de8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800deb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dee:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800df1:	8a 12                	mov    (%edx),%dl
  800df3:	88 10                	mov    %dl,(%eax)
  800df5:	8a 00                	mov    (%eax),%al
  800df7:	84 c0                	test   %al,%al
  800df9:	75 e4                	jne    800ddf <strcpy+0xd>
		/* do nothing */;
	return ret;
  800dfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dfe:	c9                   	leave  
  800dff:	c3                   	ret    

00800e00 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e13:	eb 1f                	jmp    800e34 <strncpy+0x34>
		*dst++ = *src;
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	8d 50 01             	lea    0x1(%eax),%edx
  800e1b:	89 55 08             	mov    %edx,0x8(%ebp)
  800e1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e21:	8a 12                	mov    (%edx),%dl
  800e23:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e28:	8a 00                	mov    (%eax),%al
  800e2a:	84 c0                	test   %al,%al
  800e2c:	74 03                	je     800e31 <strncpy+0x31>
			src++;
  800e2e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e31:	ff 45 fc             	incl   -0x4(%ebp)
  800e34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e37:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e3a:	72 d9                	jb     800e15 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e3f:	c9                   	leave  
  800e40:	c3                   	ret    

00800e41 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e51:	74 30                	je     800e83 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e53:	eb 16                	jmp    800e6b <strlcpy+0x2a>
			*dst++ = *src++;
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	8d 50 01             	lea    0x1(%eax),%edx
  800e5b:	89 55 08             	mov    %edx,0x8(%ebp)
  800e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e61:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e64:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e67:	8a 12                	mov    (%edx),%dl
  800e69:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e6b:	ff 4d 10             	decl   0x10(%ebp)
  800e6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e72:	74 09                	je     800e7d <strlcpy+0x3c>
  800e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	84 c0                	test   %al,%al
  800e7b:	75 d8                	jne    800e55 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e83:	8b 55 08             	mov    0x8(%ebp),%edx
  800e86:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e89:	29 c2                	sub    %eax,%edx
  800e8b:	89 d0                	mov    %edx,%eax
}
  800e8d:	c9                   	leave  
  800e8e:	c3                   	ret    

00800e8f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e8f:	55                   	push   %ebp
  800e90:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e92:	eb 06                	jmp    800e9a <strcmp+0xb>
		p++, q++;
  800e94:	ff 45 08             	incl   0x8(%ebp)
  800e97:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	8a 00                	mov    (%eax),%al
  800e9f:	84 c0                	test   %al,%al
  800ea1:	74 0e                	je     800eb1 <strcmp+0x22>
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 10                	mov    (%eax),%dl
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	8a 00                	mov    (%eax),%al
  800ead:	38 c2                	cmp    %al,%dl
  800eaf:	74 e3                	je     800e94 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	8a 00                	mov    (%eax),%al
  800eb6:	0f b6 d0             	movzbl %al,%edx
  800eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebc:	8a 00                	mov    (%eax),%al
  800ebe:	0f b6 c0             	movzbl %al,%eax
  800ec1:	29 c2                	sub    %eax,%edx
  800ec3:	89 d0                	mov    %edx,%eax
}
  800ec5:	5d                   	pop    %ebp
  800ec6:	c3                   	ret    

00800ec7 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800eca:	eb 09                	jmp    800ed5 <strncmp+0xe>
		n--, p++, q++;
  800ecc:	ff 4d 10             	decl   0x10(%ebp)
  800ecf:	ff 45 08             	incl   0x8(%ebp)
  800ed2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ed5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed9:	74 17                	je     800ef2 <strncmp+0x2b>
  800edb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ede:	8a 00                	mov    (%eax),%al
  800ee0:	84 c0                	test   %al,%al
  800ee2:	74 0e                	je     800ef2 <strncmp+0x2b>
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	8a 10                	mov    (%eax),%dl
  800ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eec:	8a 00                	mov    (%eax),%al
  800eee:	38 c2                	cmp    %al,%dl
  800ef0:	74 da                	je     800ecc <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ef2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef6:	75 07                	jne    800eff <strncmp+0x38>
		return 0;
  800ef8:	b8 00 00 00 00       	mov    $0x0,%eax
  800efd:	eb 14                	jmp    800f13 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	0f b6 d0             	movzbl %al,%edx
  800f07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	0f b6 c0             	movzbl %al,%eax
  800f0f:	29 c2                	sub    %eax,%edx
  800f11:	89 d0                	mov    %edx,%eax
}
  800f13:	5d                   	pop    %ebp
  800f14:	c3                   	ret    

00800f15 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	83 ec 04             	sub    $0x4,%esp
  800f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f21:	eb 12                	jmp    800f35 <strchr+0x20>
		if (*s == c)
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f2b:	75 05                	jne    800f32 <strchr+0x1d>
			return (char *) s;
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	eb 11                	jmp    800f43 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f32:	ff 45 08             	incl   0x8(%ebp)
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	84 c0                	test   %al,%al
  800f3c:	75 e5                	jne    800f23 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f43:	c9                   	leave  
  800f44:	c3                   	ret    

00800f45 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	83 ec 04             	sub    $0x4,%esp
  800f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f51:	eb 0d                	jmp    800f60 <strfind+0x1b>
		if (*s == c)
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f5b:	74 0e                	je     800f6b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f5d:	ff 45 08             	incl   0x8(%ebp)
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	8a 00                	mov    (%eax),%al
  800f65:	84 c0                	test   %al,%al
  800f67:	75 ea                	jne    800f53 <strfind+0xe>
  800f69:	eb 01                	jmp    800f6c <strfind+0x27>
		if (*s == c)
			break;
  800f6b:	90                   	nop
	return (char *) s;
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f6f:	c9                   	leave  
  800f70:	c3                   	ret    

00800f71 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f80:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f83:	eb 0e                	jmp    800f93 <memset+0x22>
		*p++ = c;
  800f85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f88:	8d 50 01             	lea    0x1(%eax),%edx
  800f8b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f91:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f93:	ff 4d f8             	decl   -0x8(%ebp)
  800f96:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f9a:	79 e9                	jns    800f85 <memset+0x14>
		*p++ = c;

	return v;
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f9f:	c9                   	leave  
  800fa0:	c3                   	ret    

00800fa1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fb3:	eb 16                	jmp    800fcb <memcpy+0x2a>
		*d++ = *s++;
  800fb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb8:	8d 50 01             	lea    0x1(%eax),%edx
  800fbb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fbe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fc1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fc7:	8a 12                	mov    (%edx),%dl
  800fc9:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800fcb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fce:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd1:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd4:	85 c0                	test   %eax,%eax
  800fd6:	75 dd                	jne    800fb5 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fdb:	c9                   	leave  
  800fdc:	c3                   	ret    

00800fdd <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ff5:	73 50                	jae    801047 <memmove+0x6a>
  800ff7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffd:	01 d0                	add    %edx,%eax
  800fff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801002:	76 43                	jbe    801047 <memmove+0x6a>
		s += n;
  801004:	8b 45 10             	mov    0x10(%ebp),%eax
  801007:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80100a:	8b 45 10             	mov    0x10(%ebp),%eax
  80100d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801010:	eb 10                	jmp    801022 <memmove+0x45>
			*--d = *--s;
  801012:	ff 4d f8             	decl   -0x8(%ebp)
  801015:	ff 4d fc             	decl   -0x4(%ebp)
  801018:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101b:	8a 10                	mov    (%eax),%dl
  80101d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801020:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	8d 50 ff             	lea    -0x1(%eax),%edx
  801028:	89 55 10             	mov    %edx,0x10(%ebp)
  80102b:	85 c0                	test   %eax,%eax
  80102d:	75 e3                	jne    801012 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80102f:	eb 23                	jmp    801054 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801031:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801034:	8d 50 01             	lea    0x1(%eax),%edx
  801037:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80103a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80103d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801040:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801043:	8a 12                	mov    (%edx),%dl
  801045:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801047:	8b 45 10             	mov    0x10(%ebp),%eax
  80104a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80104d:	89 55 10             	mov    %edx,0x10(%ebp)
  801050:	85 c0                	test   %eax,%eax
  801052:	75 dd                	jne    801031 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801057:	c9                   	leave  
  801058:	c3                   	ret    

00801059 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
  80105c:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801065:	8b 45 0c             	mov    0xc(%ebp),%eax
  801068:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80106b:	eb 2a                	jmp    801097 <memcmp+0x3e>
		if (*s1 != *s2)
  80106d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801070:	8a 10                	mov    (%eax),%dl
  801072:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801075:	8a 00                	mov    (%eax),%al
  801077:	38 c2                	cmp    %al,%dl
  801079:	74 16                	je     801091 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80107b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107e:	8a 00                	mov    (%eax),%al
  801080:	0f b6 d0             	movzbl %al,%edx
  801083:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	0f b6 c0             	movzbl %al,%eax
  80108b:	29 c2                	sub    %eax,%edx
  80108d:	89 d0                	mov    %edx,%eax
  80108f:	eb 18                	jmp    8010a9 <memcmp+0x50>
		s1++, s2++;
  801091:	ff 45 fc             	incl   -0x4(%ebp)
  801094:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801097:	8b 45 10             	mov    0x10(%ebp),%eax
  80109a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80109d:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a0:	85 c0                	test   %eax,%eax
  8010a2:	75 c9                	jne    80106d <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a9:	c9                   	leave  
  8010aa:	c3                   	ret    

008010ab <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b7:	01 d0                	add    %edx,%eax
  8010b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010bc:	eb 15                	jmp    8010d3 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	8a 00                	mov    (%eax),%al
  8010c3:	0f b6 d0             	movzbl %al,%edx
  8010c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c9:	0f b6 c0             	movzbl %al,%eax
  8010cc:	39 c2                	cmp    %eax,%edx
  8010ce:	74 0d                	je     8010dd <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010d0:	ff 45 08             	incl   0x8(%ebp)
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010d9:	72 e3                	jb     8010be <memfind+0x13>
  8010db:	eb 01                	jmp    8010de <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010dd:	90                   	nop
	return (void *) s;
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010e1:	c9                   	leave  
  8010e2:	c3                   	ret    

008010e3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010e3:	55                   	push   %ebp
  8010e4:	89 e5                	mov    %esp,%ebp
  8010e6:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010f0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010f7:	eb 03                	jmp    8010fc <strtol+0x19>
		s++;
  8010f9:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	8a 00                	mov    (%eax),%al
  801101:	3c 20                	cmp    $0x20,%al
  801103:	74 f4                	je     8010f9 <strtol+0x16>
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	8a 00                	mov    (%eax),%al
  80110a:	3c 09                	cmp    $0x9,%al
  80110c:	74 eb                	je     8010f9 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	3c 2b                	cmp    $0x2b,%al
  801115:	75 05                	jne    80111c <strtol+0x39>
		s++;
  801117:	ff 45 08             	incl   0x8(%ebp)
  80111a:	eb 13                	jmp    80112f <strtol+0x4c>
	else if (*s == '-')
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	3c 2d                	cmp    $0x2d,%al
  801123:	75 0a                	jne    80112f <strtol+0x4c>
		s++, neg = 1;
  801125:	ff 45 08             	incl   0x8(%ebp)
  801128:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80112f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801133:	74 06                	je     80113b <strtol+0x58>
  801135:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801139:	75 20                	jne    80115b <strtol+0x78>
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	3c 30                	cmp    $0x30,%al
  801142:	75 17                	jne    80115b <strtol+0x78>
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	40                   	inc    %eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	3c 78                	cmp    $0x78,%al
  80114c:	75 0d                	jne    80115b <strtol+0x78>
		s += 2, base = 16;
  80114e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801152:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801159:	eb 28                	jmp    801183 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80115b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115f:	75 15                	jne    801176 <strtol+0x93>
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	3c 30                	cmp    $0x30,%al
  801168:	75 0c                	jne    801176 <strtol+0x93>
		s++, base = 8;
  80116a:	ff 45 08             	incl   0x8(%ebp)
  80116d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801174:	eb 0d                	jmp    801183 <strtol+0xa0>
	else if (base == 0)
  801176:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80117a:	75 07                	jne    801183 <strtol+0xa0>
		base = 10;
  80117c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	8a 00                	mov    (%eax),%al
  801188:	3c 2f                	cmp    $0x2f,%al
  80118a:	7e 19                	jle    8011a5 <strtol+0xc2>
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	3c 39                	cmp    $0x39,%al
  801193:	7f 10                	jg     8011a5 <strtol+0xc2>
			dig = *s - '0';
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	0f be c0             	movsbl %al,%eax
  80119d:	83 e8 30             	sub    $0x30,%eax
  8011a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011a3:	eb 42                	jmp    8011e7 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	3c 60                	cmp    $0x60,%al
  8011ac:	7e 19                	jle    8011c7 <strtol+0xe4>
  8011ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b1:	8a 00                	mov    (%eax),%al
  8011b3:	3c 7a                	cmp    $0x7a,%al
  8011b5:	7f 10                	jg     8011c7 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	0f be c0             	movsbl %al,%eax
  8011bf:	83 e8 57             	sub    $0x57,%eax
  8011c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011c5:	eb 20                	jmp    8011e7 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	3c 40                	cmp    $0x40,%al
  8011ce:	7e 39                	jle    801209 <strtol+0x126>
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	3c 5a                	cmp    $0x5a,%al
  8011d7:	7f 30                	jg     801209 <strtol+0x126>
			dig = *s - 'A' + 10;
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	8a 00                	mov    (%eax),%al
  8011de:	0f be c0             	movsbl %al,%eax
  8011e1:	83 e8 37             	sub    $0x37,%eax
  8011e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ea:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011ed:	7d 19                	jge    801208 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011ef:	ff 45 08             	incl   0x8(%ebp)
  8011f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f5:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011f9:	89 c2                	mov    %eax,%edx
  8011fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011fe:	01 d0                	add    %edx,%eax
  801200:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801203:	e9 7b ff ff ff       	jmp    801183 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801208:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801209:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80120d:	74 08                	je     801217 <strtol+0x134>
		*endptr = (char *) s;
  80120f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801212:	8b 55 08             	mov    0x8(%ebp),%edx
  801215:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801217:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80121b:	74 07                	je     801224 <strtol+0x141>
  80121d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801220:	f7 d8                	neg    %eax
  801222:	eb 03                	jmp    801227 <strtol+0x144>
  801224:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801227:	c9                   	leave  
  801228:	c3                   	ret    

00801229 <ltostr>:

void
ltostr(long value, char *str)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80122f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801236:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80123d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801241:	79 13                	jns    801256 <ltostr+0x2d>
	{
		neg = 1;
  801243:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80124a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801250:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801253:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80125e:	99                   	cltd   
  80125f:	f7 f9                	idiv   %ecx
  801261:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801264:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801267:	8d 50 01             	lea    0x1(%eax),%edx
  80126a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80126d:	89 c2                	mov    %eax,%edx
  80126f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801272:	01 d0                	add    %edx,%eax
  801274:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801277:	83 c2 30             	add    $0x30,%edx
  80127a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80127c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80127f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801284:	f7 e9                	imul   %ecx
  801286:	c1 fa 02             	sar    $0x2,%edx
  801289:	89 c8                	mov    %ecx,%eax
  80128b:	c1 f8 1f             	sar    $0x1f,%eax
  80128e:	29 c2                	sub    %eax,%edx
  801290:	89 d0                	mov    %edx,%eax
  801292:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801295:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801299:	75 bb                	jne    801256 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80129b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a5:	48                   	dec    %eax
  8012a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8012a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012ad:	74 3d                	je     8012ec <ltostr+0xc3>
		start = 1 ;
  8012af:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012b6:	eb 34                	jmp    8012ec <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8012b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012be:	01 d0                	add    %edx,%eax
  8012c0:	8a 00                	mov    (%eax),%al
  8012c2:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cb:	01 c2                	add    %eax,%edx
  8012cd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d3:	01 c8                	add    %ecx,%eax
  8012d5:	8a 00                	mov    (%eax),%al
  8012d7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012df:	01 c2                	add    %eax,%edx
  8012e1:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012e4:	88 02                	mov    %al,(%edx)
		start++ ;
  8012e6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012e9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012f2:	7c c4                	jl     8012b8 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012f4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fa:	01 d0                	add    %edx,%eax
  8012fc:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012ff:	90                   	nop
  801300:	c9                   	leave  
  801301:	c3                   	ret    

00801302 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801302:	55                   	push   %ebp
  801303:	89 e5                	mov    %esp,%ebp
  801305:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801308:	ff 75 08             	pushl  0x8(%ebp)
  80130b:	e8 73 fa ff ff       	call   800d83 <strlen>
  801310:	83 c4 04             	add    $0x4,%esp
  801313:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801316:	ff 75 0c             	pushl  0xc(%ebp)
  801319:	e8 65 fa ff ff       	call   800d83 <strlen>
  80131e:	83 c4 04             	add    $0x4,%esp
  801321:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801324:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80132b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801332:	eb 17                	jmp    80134b <strcconcat+0x49>
		final[s] = str1[s] ;
  801334:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801337:	8b 45 10             	mov    0x10(%ebp),%eax
  80133a:	01 c2                	add    %eax,%edx
  80133c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	01 c8                	add    %ecx,%eax
  801344:	8a 00                	mov    (%eax),%al
  801346:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801348:	ff 45 fc             	incl   -0x4(%ebp)
  80134b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80134e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801351:	7c e1                	jl     801334 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801353:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80135a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801361:	eb 1f                	jmp    801382 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801363:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801366:	8d 50 01             	lea    0x1(%eax),%edx
  801369:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80136c:	89 c2                	mov    %eax,%edx
  80136e:	8b 45 10             	mov    0x10(%ebp),%eax
  801371:	01 c2                	add    %eax,%edx
  801373:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801376:	8b 45 0c             	mov    0xc(%ebp),%eax
  801379:	01 c8                	add    %ecx,%eax
  80137b:	8a 00                	mov    (%eax),%al
  80137d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80137f:	ff 45 f8             	incl   -0x8(%ebp)
  801382:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801385:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801388:	7c d9                	jl     801363 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80138a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80138d:	8b 45 10             	mov    0x10(%ebp),%eax
  801390:	01 d0                	add    %edx,%eax
  801392:	c6 00 00             	movb   $0x0,(%eax)
}
  801395:	90                   	nop
  801396:	c9                   	leave  
  801397:	c3                   	ret    

00801398 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80139b:	8b 45 14             	mov    0x14(%ebp),%eax
  80139e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a7:	8b 00                	mov    (%eax),%eax
  8013a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b3:	01 d0                	add    %edx,%eax
  8013b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013bb:	eb 0c                	jmp    8013c9 <strsplit+0x31>
			*string++ = 0;
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c0:	8d 50 01             	lea    0x1(%eax),%edx
  8013c3:	89 55 08             	mov    %edx,0x8(%ebp)
  8013c6:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cc:	8a 00                	mov    (%eax),%al
  8013ce:	84 c0                	test   %al,%al
  8013d0:	74 18                	je     8013ea <strsplit+0x52>
  8013d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d5:	8a 00                	mov    (%eax),%al
  8013d7:	0f be c0             	movsbl %al,%eax
  8013da:	50                   	push   %eax
  8013db:	ff 75 0c             	pushl  0xc(%ebp)
  8013de:	e8 32 fb ff ff       	call   800f15 <strchr>
  8013e3:	83 c4 08             	add    $0x8,%esp
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	75 d3                	jne    8013bd <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	84 c0                	test   %al,%al
  8013f1:	74 5a                	je     80144d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f6:	8b 00                	mov    (%eax),%eax
  8013f8:	83 f8 0f             	cmp    $0xf,%eax
  8013fb:	75 07                	jne    801404 <strsplit+0x6c>
		{
			return 0;
  8013fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801402:	eb 66                	jmp    80146a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801404:	8b 45 14             	mov    0x14(%ebp),%eax
  801407:	8b 00                	mov    (%eax),%eax
  801409:	8d 48 01             	lea    0x1(%eax),%ecx
  80140c:	8b 55 14             	mov    0x14(%ebp),%edx
  80140f:	89 0a                	mov    %ecx,(%edx)
  801411:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801418:	8b 45 10             	mov    0x10(%ebp),%eax
  80141b:	01 c2                	add    %eax,%edx
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801422:	eb 03                	jmp    801427 <strsplit+0x8f>
			string++;
  801424:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
  80142a:	8a 00                	mov    (%eax),%al
  80142c:	84 c0                	test   %al,%al
  80142e:	74 8b                	je     8013bb <strsplit+0x23>
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	8a 00                	mov    (%eax),%al
  801435:	0f be c0             	movsbl %al,%eax
  801438:	50                   	push   %eax
  801439:	ff 75 0c             	pushl  0xc(%ebp)
  80143c:	e8 d4 fa ff ff       	call   800f15 <strchr>
  801441:	83 c4 08             	add    $0x8,%esp
  801444:	85 c0                	test   %eax,%eax
  801446:	74 dc                	je     801424 <strsplit+0x8c>
			string++;
	}
  801448:	e9 6e ff ff ff       	jmp    8013bb <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80144d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80144e:	8b 45 14             	mov    0x14(%ebp),%eax
  801451:	8b 00                	mov    (%eax),%eax
  801453:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80145a:	8b 45 10             	mov    0x10(%ebp),%eax
  80145d:	01 d0                	add    %edx,%eax
  80145f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801465:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80146a:	c9                   	leave  
  80146b:	c3                   	ret    

0080146c <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
  80146f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801472:	83 ec 04             	sub    $0x4,%esp
  801475:	68 c8 3e 80 00       	push   $0x803ec8
  80147a:	68 3f 01 00 00       	push   $0x13f
  80147f:	68 ea 3e 80 00       	push   $0x803eea
  801484:	e8 a9 ef ff ff       	call   800432 <_panic>

00801489 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801489:	55                   	push   %ebp
  80148a:	89 e5                	mov    %esp,%ebp
  80148c:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80148f:	83 ec 0c             	sub    $0xc,%esp
  801492:	ff 75 08             	pushl  0x8(%ebp)
  801495:	e8 90 0c 00 00       	call   80212a <sys_sbrk>
  80149a:	83 c4 10             	add    $0x10,%esp
}
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
  8014a2:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8014a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a9:	75 0a                	jne    8014b5 <malloc+0x16>
		return NULL;
  8014ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b0:	e9 9e 01 00 00       	jmp    801653 <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  8014b5:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8014bc:	77 2c                	ja     8014ea <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  8014be:	e8 eb 0a 00 00       	call   801fae <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014c3:	85 c0                	test   %eax,%eax
  8014c5:	74 19                	je     8014e0 <malloc+0x41>

			void * block = alloc_block_FF(size);
  8014c7:	83 ec 0c             	sub    $0xc,%esp
  8014ca:	ff 75 08             	pushl  0x8(%ebp)
  8014cd:	e8 85 11 00 00       	call   802657 <alloc_block_FF>
  8014d2:	83 c4 10             	add    $0x10,%esp
  8014d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  8014d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014db:	e9 73 01 00 00       	jmp    801653 <malloc+0x1b4>
		} else {
			return NULL;
  8014e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e5:	e9 69 01 00 00       	jmp    801653 <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8014ea:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8014f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f7:	01 d0                	add    %edx,%eax
  8014f9:	48                   	dec    %eax
  8014fa:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8014fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801500:	ba 00 00 00 00       	mov    $0x0,%edx
  801505:	f7 75 e0             	divl   -0x20(%ebp)
  801508:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80150b:	29 d0                	sub    %edx,%eax
  80150d:	c1 e8 0c             	shr    $0xc,%eax
  801510:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  801513:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  80151a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801521:	a1 20 50 80 00       	mov    0x805020,%eax
  801526:	8b 40 7c             	mov    0x7c(%eax),%eax
  801529:	05 00 10 00 00       	add    $0x1000,%eax
  80152e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801531:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801536:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801539:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  80153c:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801543:	8b 55 08             	mov    0x8(%ebp),%edx
  801546:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801549:	01 d0                	add    %edx,%eax
  80154b:	48                   	dec    %eax
  80154c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80154f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801552:	ba 00 00 00 00       	mov    $0x0,%edx
  801557:	f7 75 cc             	divl   -0x34(%ebp)
  80155a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80155d:	29 d0                	sub    %edx,%eax
  80155f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801562:	76 0a                	jbe    80156e <malloc+0xcf>
		return NULL;
  801564:	b8 00 00 00 00       	mov    $0x0,%eax
  801569:	e9 e5 00 00 00       	jmp    801653 <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  80156e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801571:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801574:	eb 48                	jmp    8015be <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  801576:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801579:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80157c:	c1 e8 0c             	shr    $0xc,%eax
  80157f:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801582:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801585:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  80158c:	85 c0                	test   %eax,%eax
  80158e:	75 11                	jne    8015a1 <malloc+0x102>
			freePagesCount++;
  801590:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801593:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801597:	75 16                	jne    8015af <malloc+0x110>
				start = i;
  801599:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80159c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80159f:	eb 0e                	jmp    8015af <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  8015a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8015a8:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  8015af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b2:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8015b5:	74 12                	je     8015c9 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  8015b7:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8015be:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8015c5:	76 af                	jbe    801576 <malloc+0xd7>
  8015c7:	eb 01                	jmp    8015ca <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  8015c9:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  8015ca:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8015ce:	74 08                	je     8015d8 <malloc+0x139>
  8015d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d3:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8015d6:	74 07                	je     8015df <malloc+0x140>
		return NULL;
  8015d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015dd:	eb 74                	jmp    801653 <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8015df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e2:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8015e5:	c1 e8 0c             	shr    $0xc,%eax
  8015e8:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  8015eb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8015ee:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8015f1:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  8015f8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8015fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8015fe:	eb 11                	jmp    801611 <malloc+0x172>
		markedPages[i] = 1;
  801600:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801603:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  80160a:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  80160e:	ff 45 e8             	incl   -0x18(%ebp)
  801611:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801614:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801617:	01 d0                	add    %edx,%eax
  801619:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80161c:	77 e2                	ja     801600 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  80161e:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801625:	8b 55 08             	mov    0x8(%ebp),%edx
  801628:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80162b:	01 d0                	add    %edx,%eax
  80162d:	48                   	dec    %eax
  80162e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801631:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801634:	ba 00 00 00 00       	mov    $0x0,%edx
  801639:	f7 75 bc             	divl   -0x44(%ebp)
  80163c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80163f:	29 d0                	sub    %edx,%eax
  801641:	83 ec 08             	sub    $0x8,%esp
  801644:	50                   	push   %eax
  801645:	ff 75 f0             	pushl  -0x10(%ebp)
  801648:	e8 14 0b 00 00       	call   802161 <sys_allocate_user_mem>
  80164d:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  801650:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  80165b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80165f:	0f 84 ee 00 00 00    	je     801753 <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801665:	a1 20 50 80 00       	mov    0x805020,%eax
  80166a:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  80166d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801670:	77 09                	ja     80167b <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801672:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801679:	76 14                	jbe    80168f <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  80167b:	83 ec 04             	sub    $0x4,%esp
  80167e:	68 f8 3e 80 00       	push   $0x803ef8
  801683:	6a 68                	push   $0x68
  801685:	68 12 3f 80 00       	push   $0x803f12
  80168a:	e8 a3 ed ff ff       	call   800432 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  80168f:	a1 20 50 80 00       	mov    0x805020,%eax
  801694:	8b 40 74             	mov    0x74(%eax),%eax
  801697:	3b 45 08             	cmp    0x8(%ebp),%eax
  80169a:	77 20                	ja     8016bc <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  80169c:	a1 20 50 80 00       	mov    0x805020,%eax
  8016a1:	8b 40 78             	mov    0x78(%eax),%eax
  8016a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8016a7:	76 13                	jbe    8016bc <free+0x67>
		free_block(virtual_address);
  8016a9:	83 ec 0c             	sub    $0xc,%esp
  8016ac:	ff 75 08             	pushl  0x8(%ebp)
  8016af:	e8 6c 16 00 00       	call   802d20 <free_block>
  8016b4:	83 c4 10             	add    $0x10,%esp
		return;
  8016b7:	e9 98 00 00 00       	jmp    801754 <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8016bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8016bf:	a1 20 50 80 00       	mov    0x805020,%eax
  8016c4:	8b 40 7c             	mov    0x7c(%eax),%eax
  8016c7:	29 c2                	sub    %eax,%edx
  8016c9:	89 d0                	mov    %edx,%eax
  8016cb:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  8016d0:	c1 e8 0c             	shr    $0xc,%eax
  8016d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  8016d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8016dd:	eb 16                	jmp    8016f5 <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  8016df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e5:	01 d0                	add    %edx,%eax
  8016e7:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  8016ee:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  8016f2:	ff 45 f4             	incl   -0xc(%ebp)
  8016f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f8:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  8016ff:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801702:	7f db                	jg     8016df <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  801704:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801707:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  80170e:	c1 e0 0c             	shl    $0xc,%eax
  801711:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80171a:	eb 1a                	jmp    801736 <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  80171c:	83 ec 08             	sub    $0x8,%esp
  80171f:	68 00 10 00 00       	push   $0x1000
  801724:	ff 75 f0             	pushl  -0x10(%ebp)
  801727:	e8 19 0a 00 00       	call   802145 <sys_free_user_mem>
  80172c:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  80172f:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801736:	8b 55 08             	mov    0x8(%ebp),%edx
  801739:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80173c:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  80173e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801741:	77 d9                	ja     80171c <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801743:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801746:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  80174d:	00 00 00 00 
  801751:	eb 01                	jmp    801754 <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  801753:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	83 ec 58             	sub    $0x58,%esp
  80175c:	8b 45 10             	mov    0x10(%ebp),%eax
  80175f:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801762:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801766:	75 0a                	jne    801772 <smalloc+0x1c>
		return NULL;
  801768:	b8 00 00 00 00       	mov    $0x0,%eax
  80176d:	e9 7d 01 00 00       	jmp    8018ef <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801772:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801779:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80177f:	01 d0                	add    %edx,%eax
  801781:	48                   	dec    %eax
  801782:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801785:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801788:	ba 00 00 00 00       	mov    $0x0,%edx
  80178d:	f7 75 e4             	divl   -0x1c(%ebp)
  801790:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801793:	29 d0                	sub    %edx,%eax
  801795:	c1 e8 0c             	shr    $0xc,%eax
  801798:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  80179b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8017a2:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8017a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8017ae:	8b 40 7c             	mov    0x7c(%eax),%eax
  8017b1:	05 00 10 00 00       	add    $0x1000,%eax
  8017b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  8017b9:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8017be:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8017c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  8017c4:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8017cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8017d1:	01 d0                	add    %edx,%eax
  8017d3:	48                   	dec    %eax
  8017d4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8017d7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8017da:	ba 00 00 00 00       	mov    $0x0,%edx
  8017df:	f7 75 d0             	divl   -0x30(%ebp)
  8017e2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8017e5:	29 d0                	sub    %edx,%eax
  8017e7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8017ea:	76 0a                	jbe    8017f6 <smalloc+0xa0>
		return NULL;
  8017ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f1:	e9 f9 00 00 00       	jmp    8018ef <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8017f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017fc:	eb 48                	jmp    801846 <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  8017fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801801:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801804:	c1 e8 0c             	shr    $0xc,%eax
  801807:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  80180a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80180d:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801814:	85 c0                	test   %eax,%eax
  801816:	75 11                	jne    801829 <smalloc+0xd3>
			freePagesCount++;
  801818:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  80181b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80181f:	75 16                	jne    801837 <smalloc+0xe1>
				start = s;
  801821:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801824:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801827:	eb 0e                	jmp    801837 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  801829:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801830:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  801837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80183d:	74 12                	je     801851 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80183f:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801846:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80184d:	76 af                	jbe    8017fe <smalloc+0xa8>
  80184f:	eb 01                	jmp    801852 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  801851:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  801852:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801856:	74 08                	je     801860 <smalloc+0x10a>
  801858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80185e:	74 0a                	je     80186a <smalloc+0x114>
		return NULL;
  801860:	b8 00 00 00 00       	mov    $0x0,%eax
  801865:	e9 85 00 00 00       	jmp    8018ef <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  80186a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186d:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801870:	c1 e8 0c             	shr    $0xc,%eax
  801873:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  801876:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801879:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80187c:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801883:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801886:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801889:	eb 11                	jmp    80189c <smalloc+0x146>
		markedPages[s] = 1;
  80188b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80188e:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801895:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801899:	ff 45 e8             	incl   -0x18(%ebp)
  80189c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80189f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018a2:	01 d0                	add    %edx,%eax
  8018a4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8018a7:	77 e2                	ja     80188b <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  8018a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018ac:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  8018b0:	52                   	push   %edx
  8018b1:	50                   	push   %eax
  8018b2:	ff 75 0c             	pushl  0xc(%ebp)
  8018b5:	ff 75 08             	pushl  0x8(%ebp)
  8018b8:	e8 8f 04 00 00       	call   801d4c <sys_createSharedObject>
  8018bd:	83 c4 10             	add    $0x10,%esp
  8018c0:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  8018c3:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  8018c7:	78 12                	js     8018db <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  8018c9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8018cc:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8018cf:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  8018d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d9:	eb 14                	jmp    8018ef <smalloc+0x199>
	}
	free((void*) start);
  8018db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018de:	83 ec 0c             	sub    $0xc,%esp
  8018e1:	50                   	push   %eax
  8018e2:	e8 6e fd ff ff       	call   801655 <free>
  8018e7:	83 c4 10             	add    $0x10,%esp
	return NULL;
  8018ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
  8018f4:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  8018f7:	83 ec 08             	sub    $0x8,%esp
  8018fa:	ff 75 0c             	pushl  0xc(%ebp)
  8018fd:	ff 75 08             	pushl  0x8(%ebp)
  801900:	e8 71 04 00 00       	call   801d76 <sys_getSizeOfSharedObject>
  801905:	83 c4 10             	add    $0x10,%esp
  801908:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  80190b:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801912:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801915:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801918:	01 d0                	add    %edx,%eax
  80191a:	48                   	dec    %eax
  80191b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80191e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801921:	ba 00 00 00 00       	mov    $0x0,%edx
  801926:	f7 75 e0             	divl   -0x20(%ebp)
  801929:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80192c:	29 d0                	sub    %edx,%eax
  80192e:	c1 e8 0c             	shr    $0xc,%eax
  801931:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  801934:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  80193b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  801942:	a1 20 50 80 00       	mov    0x805020,%eax
  801947:	8b 40 7c             	mov    0x7c(%eax),%eax
  80194a:	05 00 10 00 00       	add    $0x1000,%eax
  80194f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  801952:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801957:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80195a:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  80195d:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801964:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801967:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80196a:	01 d0                	add    %edx,%eax
  80196c:	48                   	dec    %eax
  80196d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801970:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801973:	ba 00 00 00 00       	mov    $0x0,%edx
  801978:	f7 75 cc             	divl   -0x34(%ebp)
  80197b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80197e:	29 d0                	sub    %edx,%eax
  801980:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801983:	76 0a                	jbe    80198f <sget+0x9e>
		return NULL;
  801985:	b8 00 00 00 00       	mov    $0x0,%eax
  80198a:	e9 f7 00 00 00       	jmp    801a86 <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80198f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801992:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801995:	eb 48                	jmp    8019df <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  801997:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80199a:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80199d:	c1 e8 0c             	shr    $0xc,%eax
  8019a0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  8019a3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8019a6:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8019ad:	85 c0                	test   %eax,%eax
  8019af:	75 11                	jne    8019c2 <sget+0xd1>
			free_Pages_Count++;
  8019b1:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8019b4:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8019b8:	75 16                	jne    8019d0 <sget+0xdf>
				start = s;
  8019ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019c0:	eb 0e                	jmp    8019d0 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  8019c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8019c9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  8019d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d3:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8019d6:	74 12                	je     8019ea <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8019d8:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8019df:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8019e6:	76 af                	jbe    801997 <sget+0xa6>
  8019e8:	eb 01                	jmp    8019eb <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  8019ea:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  8019eb:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8019ef:	74 08                	je     8019f9 <sget+0x108>
  8019f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f4:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8019f7:	74 0a                	je     801a03 <sget+0x112>
		return NULL;
  8019f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fe:	e9 83 00 00 00       	jmp    801a86 <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  801a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a06:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801a09:	c1 e8 0c             	shr    $0xc,%eax
  801a0c:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  801a0f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a12:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a15:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801a1c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a22:	eb 11                	jmp    801a35 <sget+0x144>
		markedPages[k] = 1;
  801a24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a27:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801a2e:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801a32:	ff 45 e8             	incl   -0x18(%ebp)
  801a35:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801a38:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a3b:	01 d0                	add    %edx,%eax
  801a3d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a40:	77 e2                	ja     801a24 <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  801a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a45:	83 ec 04             	sub    $0x4,%esp
  801a48:	50                   	push   %eax
  801a49:	ff 75 0c             	pushl  0xc(%ebp)
  801a4c:	ff 75 08             	pushl  0x8(%ebp)
  801a4f:	e8 3f 03 00 00       	call   801d93 <sys_getSharedObject>
  801a54:	83 c4 10             	add    $0x10,%esp
  801a57:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  801a5a:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  801a5e:	78 12                	js     801a72 <sget+0x181>
		shardIDs[startPage] = ss;
  801a60:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a63:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801a66:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a70:	eb 14                	jmp    801a86 <sget+0x195>
	}
	free((void*) start);
  801a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a75:	83 ec 0c             	sub    $0xc,%esp
  801a78:	50                   	push   %eax
  801a79:	e8 d7 fb ff ff       	call   801655 <free>
  801a7e:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801a81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801a8e:	8b 55 08             	mov    0x8(%ebp),%edx
  801a91:	a1 20 50 80 00       	mov    0x805020,%eax
  801a96:	8b 40 7c             	mov    0x7c(%eax),%eax
  801a99:	29 c2                	sub    %eax,%edx
  801a9b:	89 d0                	mov    %edx,%eax
  801a9d:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  801aa2:	c1 e8 0c             	shr    $0xc,%eax
  801aa5:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  801aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aab:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  801ab2:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  801ab5:	83 ec 08             	sub    $0x8,%esp
  801ab8:	ff 75 08             	pushl  0x8(%ebp)
  801abb:	ff 75 f0             	pushl  -0x10(%ebp)
  801abe:	e8 ef 02 00 00       	call   801db2 <sys_freeSharedObject>
  801ac3:	83 c4 10             	add    $0x10,%esp
  801ac6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  801ac9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801acd:	75 0e                	jne    801add <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  801acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad2:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  801ad9:	ff ff ff ff 
	}

}
  801add:	90                   	nop
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ae6:	83 ec 04             	sub    $0x4,%esp
  801ae9:	68 20 3f 80 00       	push   $0x803f20
  801aee:	68 19 01 00 00       	push   $0x119
  801af3:	68 12 3f 80 00       	push   $0x803f12
  801af8:	e8 35 e9 ff ff       	call   800432 <_panic>

00801afd <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
  801b00:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b03:	83 ec 04             	sub    $0x4,%esp
  801b06:	68 46 3f 80 00       	push   $0x803f46
  801b0b:	68 23 01 00 00       	push   $0x123
  801b10:	68 12 3f 80 00       	push   $0x803f12
  801b15:	e8 18 e9 ff ff       	call   800432 <_panic>

00801b1a <shrink>:

}
void shrink(uint32 newSize) {
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b20:	83 ec 04             	sub    $0x4,%esp
  801b23:	68 46 3f 80 00       	push   $0x803f46
  801b28:	68 27 01 00 00       	push   $0x127
  801b2d:	68 12 3f 80 00       	push   $0x803f12
  801b32:	e8 fb e8 ff ff       	call   800432 <_panic>

00801b37 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
  801b3a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b3d:	83 ec 04             	sub    $0x4,%esp
  801b40:	68 46 3f 80 00       	push   $0x803f46
  801b45:	68 2b 01 00 00       	push   $0x12b
  801b4a:	68 12 3f 80 00       	push   $0x803f12
  801b4f:	e8 de e8 ff ff       	call   800432 <_panic>

00801b54 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	57                   	push   %edi
  801b58:	56                   	push   %esi
  801b59:	53                   	push   %ebx
  801b5a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b63:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b66:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b69:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b6c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b6f:	cd 30                	int    $0x30
  801b71:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b77:	83 c4 10             	add    $0x10,%esp
  801b7a:	5b                   	pop    %ebx
  801b7b:	5e                   	pop    %esi
  801b7c:	5f                   	pop    %edi
  801b7d:	5d                   	pop    %ebp
  801b7e:	c3                   	ret    

00801b7f <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	83 ec 04             	sub    $0x4,%esp
  801b85:	8b 45 10             	mov    0x10(%ebp),%eax
  801b88:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801b8b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	52                   	push   %edx
  801b97:	ff 75 0c             	pushl  0xc(%ebp)
  801b9a:	50                   	push   %eax
  801b9b:	6a 00                	push   $0x0
  801b9d:	e8 b2 ff ff ff       	call   801b54 <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	90                   	nop
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sys_cgetc>:

int sys_cgetc(void) {
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 02                	push   $0x2
  801bb7:	e8 98 ff ff ff       	call   801b54 <syscall>
  801bbc:	83 c4 18             	add    $0x18,%esp
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <sys_lock_cons>:

void sys_lock_cons(void) {
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 03                	push   $0x3
  801bd0:	e8 7f ff ff ff       	call   801b54 <syscall>
  801bd5:	83 c4 18             	add    $0x18,%esp
}
  801bd8:	90                   	nop
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 04                	push   $0x4
  801bea:	e8 65 ff ff ff       	call   801b54 <syscall>
  801bef:	83 c4 18             	add    $0x18,%esp
}
  801bf2:	90                   	nop
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801bf8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	52                   	push   %edx
  801c05:	50                   	push   %eax
  801c06:	6a 08                	push   $0x8
  801c08:	e8 47 ff ff ff       	call   801b54 <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
  801c15:	56                   	push   %esi
  801c16:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801c17:	8b 75 18             	mov    0x18(%ebp),%esi
  801c1a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c1d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	56                   	push   %esi
  801c27:	53                   	push   %ebx
  801c28:	51                   	push   %ecx
  801c29:	52                   	push   %edx
  801c2a:	50                   	push   %eax
  801c2b:	6a 09                	push   $0x9
  801c2d:	e8 22 ff ff ff       	call   801b54 <syscall>
  801c32:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801c35:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c38:	5b                   	pop    %ebx
  801c39:	5e                   	pop    %esi
  801c3a:	5d                   	pop    %ebp
  801c3b:	c3                   	ret    

00801c3c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c42:	8b 45 08             	mov    0x8(%ebp),%eax
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	52                   	push   %edx
  801c4c:	50                   	push   %eax
  801c4d:	6a 0a                	push   $0xa
  801c4f:	e8 00 ff ff ff       	call   801b54 <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
}
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	ff 75 0c             	pushl  0xc(%ebp)
  801c65:	ff 75 08             	pushl  0x8(%ebp)
  801c68:	6a 0b                	push   $0xb
  801c6a:	e8 e5 fe ff ff       	call   801b54 <syscall>
  801c6f:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 0c                	push   $0xc
  801c83:	e8 cc fe ff ff       	call   801b54 <syscall>
  801c88:	83 c4 18             	add    $0x18,%esp
}
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    

00801c8d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 0d                	push   $0xd
  801c9c:	e8 b3 fe ff ff       	call   801b54 <syscall>
  801ca1:	83 c4 18             	add    $0x18,%esp
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 0e                	push   $0xe
  801cb5:	e8 9a fe ff ff       	call   801b54 <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 0f                	push   $0xf
  801cce:	e8 81 fe ff ff       	call   801b54 <syscall>
  801cd3:	83 c4 18             	add    $0x18,%esp
}
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	ff 75 08             	pushl  0x8(%ebp)
  801ce6:	6a 10                	push   $0x10
  801ce8:	e8 67 fe ff ff       	call   801b54 <syscall>
  801ced:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <sys_scarce_memory>:

void sys_scarce_memory() {
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 11                	push   $0x11
  801d01:	e8 4e fe ff ff       	call   801b54 <syscall>
  801d06:	83 c4 18             	add    $0x18,%esp
}
  801d09:	90                   	nop
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <sys_cputc>:

void sys_cputc(const char c) {
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	83 ec 04             	sub    $0x4,%esp
  801d12:	8b 45 08             	mov    0x8(%ebp),%eax
  801d15:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d18:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	50                   	push   %eax
  801d25:	6a 01                	push   $0x1
  801d27:	e8 28 fe ff ff       	call   801b54 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
}
  801d2f:	90                   	nop
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 14                	push   $0x14
  801d41:	e8 0e fe ff ff       	call   801b54 <syscall>
  801d46:	83 c4 18             	add    $0x18,%esp
}
  801d49:	90                   	nop
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
  801d4f:	83 ec 04             	sub    $0x4,%esp
  801d52:	8b 45 10             	mov    0x10(%ebp),%eax
  801d55:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801d58:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d5b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d62:	6a 00                	push   $0x0
  801d64:	51                   	push   %ecx
  801d65:	52                   	push   %edx
  801d66:	ff 75 0c             	pushl  0xc(%ebp)
  801d69:	50                   	push   %eax
  801d6a:	6a 15                	push   $0x15
  801d6c:	e8 e3 fd ff ff       	call   801b54 <syscall>
  801d71:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801d79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	52                   	push   %edx
  801d86:	50                   	push   %eax
  801d87:	6a 16                	push   $0x16
  801d89:	e8 c6 fd ff ff       	call   801b54 <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801d96:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	51                   	push   %ecx
  801da4:	52                   	push   %edx
  801da5:	50                   	push   %eax
  801da6:	6a 17                	push   $0x17
  801da8:	e8 a7 fd ff ff       	call   801b54 <syscall>
  801dad:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801db5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	52                   	push   %edx
  801dc2:	50                   	push   %eax
  801dc3:	6a 18                	push   $0x18
  801dc5:	e8 8a fd ff ff       	call   801b54 <syscall>
  801dca:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd5:	6a 00                	push   $0x0
  801dd7:	ff 75 14             	pushl  0x14(%ebp)
  801dda:	ff 75 10             	pushl  0x10(%ebp)
  801ddd:	ff 75 0c             	pushl  0xc(%ebp)
  801de0:	50                   	push   %eax
  801de1:	6a 19                	push   $0x19
  801de3:	e8 6c fd ff ff       	call   801b54 <syscall>
  801de8:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <sys_run_env>:

void sys_run_env(int32 envId) {
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801df0:	8b 45 08             	mov    0x8(%ebp),%eax
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	50                   	push   %eax
  801dfc:	6a 1a                	push   $0x1a
  801dfe:	e8 51 fd ff ff       	call   801b54 <syscall>
  801e03:	83 c4 18             	add    $0x18,%esp
}
  801e06:	90                   	nop
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	50                   	push   %eax
  801e18:	6a 1b                	push   $0x1b
  801e1a:	e8 35 fd ff ff       	call   801b54 <syscall>
  801e1f:	83 c4 18             	add    $0x18,%esp
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <sys_getenvid>:

int32 sys_getenvid(void) {
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 05                	push   $0x5
  801e33:	e8 1c fd ff ff       	call   801b54 <syscall>
  801e38:	83 c4 18             	add    $0x18,%esp
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 06                	push   $0x6
  801e4c:	e8 03 fd ff ff       	call   801b54 <syscall>
  801e51:	83 c4 18             	add    $0x18,%esp
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 07                	push   $0x7
  801e65:	e8 ea fc ff ff       	call   801b54 <syscall>
  801e6a:	83 c4 18             	add    $0x18,%esp
}
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <sys_exit_env>:

void sys_exit_env(void) {
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 1c                	push   $0x1c
  801e7e:	e8 d1 fc ff ff       	call   801b54 <syscall>
  801e83:	83 c4 18             	add    $0x18,%esp
}
  801e86:	90                   	nop
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801e8f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e92:	8d 50 04             	lea    0x4(%eax),%edx
  801e95:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	52                   	push   %edx
  801e9f:	50                   	push   %eax
  801ea0:	6a 1d                	push   $0x1d
  801ea2:	e8 ad fc ff ff       	call   801b54 <syscall>
  801ea7:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801eaa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ead:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801eb0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801eb3:	89 01                	mov    %eax,(%ecx)
  801eb5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebb:	c9                   	leave  
  801ebc:	c2 04 00             	ret    $0x4

00801ebf <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	ff 75 10             	pushl  0x10(%ebp)
  801ec9:	ff 75 0c             	pushl  0xc(%ebp)
  801ecc:	ff 75 08             	pushl  0x8(%ebp)
  801ecf:	6a 13                	push   $0x13
  801ed1:	e8 7e fc ff ff       	call   801b54 <syscall>
  801ed6:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801ed9:	90                   	nop
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <sys_rcr2>:
uint32 sys_rcr2() {
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 1e                	push   $0x1e
  801eeb:	e8 64 fc ff ff       	call   801b54 <syscall>
  801ef0:	83 c4 18             	add    $0x18,%esp
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
  801ef8:	83 ec 04             	sub    $0x4,%esp
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f01:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	50                   	push   %eax
  801f0e:	6a 1f                	push   $0x1f
  801f10:	e8 3f fc ff ff       	call   801b54 <syscall>
  801f15:	83 c4 18             	add    $0x18,%esp
	return;
  801f18:	90                   	nop
}
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <rsttst>:
void rsttst() {
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 21                	push   $0x21
  801f2a:	e8 25 fc ff ff       	call   801b54 <syscall>
  801f2f:	83 c4 18             	add    $0x18,%esp
	return;
  801f32:	90                   	nop
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	83 ec 04             	sub    $0x4,%esp
  801f3b:	8b 45 14             	mov    0x14(%ebp),%eax
  801f3e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f41:	8b 55 18             	mov    0x18(%ebp),%edx
  801f44:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f48:	52                   	push   %edx
  801f49:	50                   	push   %eax
  801f4a:	ff 75 10             	pushl  0x10(%ebp)
  801f4d:	ff 75 0c             	pushl  0xc(%ebp)
  801f50:	ff 75 08             	pushl  0x8(%ebp)
  801f53:	6a 20                	push   $0x20
  801f55:	e8 fa fb ff ff       	call   801b54 <syscall>
  801f5a:	83 c4 18             	add    $0x18,%esp
	return;
  801f5d:	90                   	nop
}
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <chktst>:
void chktst(uint32 n) {
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	ff 75 08             	pushl  0x8(%ebp)
  801f6e:	6a 22                	push   $0x22
  801f70:	e8 df fb ff ff       	call   801b54 <syscall>
  801f75:	83 c4 18             	add    $0x18,%esp
	return;
  801f78:	90                   	nop
}
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    

00801f7b <inctst>:

void inctst() {
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 23                	push   $0x23
  801f8a:	e8 c5 fb ff ff       	call   801b54 <syscall>
  801f8f:	83 c4 18             	add    $0x18,%esp
	return;
  801f92:	90                   	nop
}
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <gettst>:
uint32 gettst() {
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 24                	push   $0x24
  801fa4:	e8 ab fb ff ff       	call   801b54 <syscall>
  801fa9:	83 c4 18             	add    $0x18,%esp
}
  801fac:	c9                   	leave  
  801fad:	c3                   	ret    

00801fae <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
  801fb1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 25                	push   $0x25
  801fc0:	e8 8f fb ff ff       	call   801b54 <syscall>
  801fc5:	83 c4 18             	add    $0x18,%esp
  801fc8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801fcb:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801fcf:	75 07                	jne    801fd8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801fd1:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd6:	eb 05                	jmp    801fdd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
  801fe2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 25                	push   $0x25
  801ff1:	e8 5e fb ff ff       	call   801b54 <syscall>
  801ff6:	83 c4 18             	add    $0x18,%esp
  801ff9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ffc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802000:	75 07                	jne    802009 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802002:	b8 01 00 00 00       	mov    $0x1,%eax
  802007:	eb 05                	jmp    80200e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802009:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
  802013:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 25                	push   $0x25
  802022:	e8 2d fb ff ff       	call   801b54 <syscall>
  802027:	83 c4 18             	add    $0x18,%esp
  80202a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80202d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802031:	75 07                	jne    80203a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802033:	b8 01 00 00 00       	mov    $0x1,%eax
  802038:	eb 05                	jmp    80203f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80203a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 25                	push   $0x25
  802053:	e8 fc fa ff ff       	call   801b54 <syscall>
  802058:	83 c4 18             	add    $0x18,%esp
  80205b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80205e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802062:	75 07                	jne    80206b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802064:	b8 01 00 00 00       	mov    $0x1,%eax
  802069:	eb 05                	jmp    802070 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80206b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802070:	c9                   	leave  
  802071:	c3                   	ret    

00802072 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  802072:	55                   	push   %ebp
  802073:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	ff 75 08             	pushl  0x8(%ebp)
  802080:	6a 26                	push   $0x26
  802082:	e8 cd fa ff ff       	call   801b54 <syscall>
  802087:	83 c4 18             	add    $0x18,%esp
	return;
  80208a:	90                   	nop
}
  80208b:	c9                   	leave  
  80208c:	c3                   	ret    

0080208d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  80208d:	55                   	push   %ebp
  80208e:	89 e5                	mov    %esp,%ebp
  802090:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  802091:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802094:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802097:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	6a 00                	push   $0x0
  80209f:	53                   	push   %ebx
  8020a0:	51                   	push   %ecx
  8020a1:	52                   	push   %edx
  8020a2:	50                   	push   %eax
  8020a3:	6a 27                	push   $0x27
  8020a5:	e8 aa fa ff ff       	call   801b54 <syscall>
  8020aa:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  8020ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  8020b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	52                   	push   %edx
  8020c2:	50                   	push   %eax
  8020c3:	6a 28                	push   $0x28
  8020c5:	e8 8a fa ff ff       	call   801b54 <syscall>
  8020ca:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    

008020cf <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  8020d2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8020d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	6a 00                	push   $0x0
  8020dd:	51                   	push   %ecx
  8020de:	ff 75 10             	pushl  0x10(%ebp)
  8020e1:	52                   	push   %edx
  8020e2:	50                   	push   %eax
  8020e3:	6a 29                	push   $0x29
  8020e5:	e8 6a fa ff ff       	call   801b54 <syscall>
  8020ea:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  8020ed:	c9                   	leave  
  8020ee:	c3                   	ret    

008020ef <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	ff 75 10             	pushl  0x10(%ebp)
  8020f9:	ff 75 0c             	pushl  0xc(%ebp)
  8020fc:	ff 75 08             	pushl  0x8(%ebp)
  8020ff:	6a 12                	push   $0x12
  802101:	e8 4e fa ff ff       	call   801b54 <syscall>
  802106:	83 c4 18             	add    $0x18,%esp
	return;
  802109:	90                   	nop
}
  80210a:	c9                   	leave  
  80210b:	c3                   	ret    

0080210c <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  80210f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802112:	8b 45 08             	mov    0x8(%ebp),%eax
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	52                   	push   %edx
  80211c:	50                   	push   %eax
  80211d:	6a 2a                	push   $0x2a
  80211f:	e8 30 fa ff ff       	call   801b54 <syscall>
  802124:	83 c4 18             	add    $0x18,%esp
	return;
  802127:	90                   	nop
}
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  80212d:	8b 45 08             	mov    0x8(%ebp),%eax
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	50                   	push   %eax
  802139:	6a 2b                	push   $0x2b
  80213b:	e8 14 fa ff ff       	call   801b54 <syscall>
  802140:	83 c4 18             	add    $0x18,%esp
}
  802143:	c9                   	leave  
  802144:	c3                   	ret    

00802145 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	ff 75 0c             	pushl  0xc(%ebp)
  802151:	ff 75 08             	pushl  0x8(%ebp)
  802154:	6a 2c                	push   $0x2c
  802156:	e8 f9 f9 ff ff       	call   801b54 <syscall>
  80215b:	83 c4 18             	add    $0x18,%esp
	return;
  80215e:	90                   	nop
}
  80215f:	c9                   	leave  
  802160:	c3                   	ret    

00802161 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  802161:	55                   	push   %ebp
  802162:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	ff 75 0c             	pushl  0xc(%ebp)
  80216d:	ff 75 08             	pushl  0x8(%ebp)
  802170:	6a 2d                	push   $0x2d
  802172:	e8 dd f9 ff ff       	call   801b54 <syscall>
  802177:	83 c4 18             	add    $0x18,%esp
	return;
  80217a:	90                   	nop
}
  80217b:	c9                   	leave  
  80217c:	c3                   	ret    

0080217d <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  802180:	8b 45 08             	mov    0x8(%ebp),%eax
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	50                   	push   %eax
  80218c:	6a 2f                	push   $0x2f
  80218e:	e8 c1 f9 ff ff       	call   801b54 <syscall>
  802193:	83 c4 18             	add    $0x18,%esp
	return;
  802196:	90                   	nop
}
  802197:	c9                   	leave  
  802198:	c3                   	ret    

00802199 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  802199:	55                   	push   %ebp
  80219a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  80219c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	52                   	push   %edx
  8021a9:	50                   	push   %eax
  8021aa:	6a 30                	push   $0x30
  8021ac:	e8 a3 f9 ff ff       	call   801b54 <syscall>
  8021b1:	83 c4 18             	add    $0x18,%esp
	return;
  8021b4:	90                   	nop
}
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	50                   	push   %eax
  8021c6:	6a 31                	push   $0x31
  8021c8:	e8 87 f9 ff ff       	call   801b54 <syscall>
  8021cd:	83 c4 18             	add    $0x18,%esp
	return;
  8021d0:	90                   	nop
}
  8021d1:	c9                   	leave  
  8021d2:	c3                   	ret    

008021d3 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8021d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	52                   	push   %edx
  8021e3:	50                   	push   %eax
  8021e4:	6a 2e                	push   $0x2e
  8021e6:	e8 69 f9 ff ff       	call   801b54 <syscall>
  8021eb:	83 c4 18             	add    $0x18,%esp
    return;
  8021ee:	90                   	nop
}
  8021ef:	c9                   	leave  
  8021f0:	c3                   	ret    

008021f1 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
  8021f4:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8021f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fa:	83 e8 04             	sub    $0x4,%eax
  8021fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802200:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802203:	8b 00                	mov    (%eax),%eax
  802205:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802208:	c9                   	leave  
  802209:	c3                   	ret    

0080220a <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
  80220d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802210:	8b 45 08             	mov    0x8(%ebp),%eax
  802213:	83 e8 04             	sub    $0x4,%eax
  802216:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802219:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80221c:	8b 00                	mov    (%eax),%eax
  80221e:	83 e0 01             	and    $0x1,%eax
  802221:	85 c0                	test   %eax,%eax
  802223:	0f 94 c0             	sete   %al
}
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
  80222b:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80222e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802235:	8b 45 0c             	mov    0xc(%ebp),%eax
  802238:	83 f8 02             	cmp    $0x2,%eax
  80223b:	74 2b                	je     802268 <alloc_block+0x40>
  80223d:	83 f8 02             	cmp    $0x2,%eax
  802240:	7f 07                	jg     802249 <alloc_block+0x21>
  802242:	83 f8 01             	cmp    $0x1,%eax
  802245:	74 0e                	je     802255 <alloc_block+0x2d>
  802247:	eb 58                	jmp    8022a1 <alloc_block+0x79>
  802249:	83 f8 03             	cmp    $0x3,%eax
  80224c:	74 2d                	je     80227b <alloc_block+0x53>
  80224e:	83 f8 04             	cmp    $0x4,%eax
  802251:	74 3b                	je     80228e <alloc_block+0x66>
  802253:	eb 4c                	jmp    8022a1 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802255:	83 ec 0c             	sub    $0xc,%esp
  802258:	ff 75 08             	pushl  0x8(%ebp)
  80225b:	e8 f7 03 00 00       	call   802657 <alloc_block_FF>
  802260:	83 c4 10             	add    $0x10,%esp
  802263:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802266:	eb 4a                	jmp    8022b2 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802268:	83 ec 0c             	sub    $0xc,%esp
  80226b:	ff 75 08             	pushl  0x8(%ebp)
  80226e:	e8 f0 11 00 00       	call   803463 <alloc_block_NF>
  802273:	83 c4 10             	add    $0x10,%esp
  802276:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802279:	eb 37                	jmp    8022b2 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80227b:	83 ec 0c             	sub    $0xc,%esp
  80227e:	ff 75 08             	pushl  0x8(%ebp)
  802281:	e8 08 08 00 00       	call   802a8e <alloc_block_BF>
  802286:	83 c4 10             	add    $0x10,%esp
  802289:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80228c:	eb 24                	jmp    8022b2 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80228e:	83 ec 0c             	sub    $0xc,%esp
  802291:	ff 75 08             	pushl  0x8(%ebp)
  802294:	e8 ad 11 00 00       	call   803446 <alloc_block_WF>
  802299:	83 c4 10             	add    $0x10,%esp
  80229c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80229f:	eb 11                	jmp    8022b2 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8022a1:	83 ec 0c             	sub    $0xc,%esp
  8022a4:	68 58 3f 80 00       	push   $0x803f58
  8022a9:	e8 41 e4 ff ff       	call   8006ef <cprintf>
  8022ae:	83 c4 10             	add    $0x10,%esp
		break;
  8022b1:	90                   	nop
	}
	return va;
  8022b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8022b5:	c9                   	leave  
  8022b6:	c3                   	ret    

008022b7 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
  8022ba:	53                   	push   %ebx
  8022bb:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8022be:	83 ec 0c             	sub    $0xc,%esp
  8022c1:	68 78 3f 80 00       	push   $0x803f78
  8022c6:	e8 24 e4 ff ff       	call   8006ef <cprintf>
  8022cb:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8022ce:	83 ec 0c             	sub    $0xc,%esp
  8022d1:	68 a3 3f 80 00       	push   $0x803fa3
  8022d6:	e8 14 e4 ff ff       	call   8006ef <cprintf>
  8022db:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8022de:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e4:	eb 37                	jmp    80231d <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8022e6:	83 ec 0c             	sub    $0xc,%esp
  8022e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8022ec:	e8 19 ff ff ff       	call   80220a <is_free_block>
  8022f1:	83 c4 10             	add    $0x10,%esp
  8022f4:	0f be d8             	movsbl %al,%ebx
  8022f7:	83 ec 0c             	sub    $0xc,%esp
  8022fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8022fd:	e8 ef fe ff ff       	call   8021f1 <get_block_size>
  802302:	83 c4 10             	add    $0x10,%esp
  802305:	83 ec 04             	sub    $0x4,%esp
  802308:	53                   	push   %ebx
  802309:	50                   	push   %eax
  80230a:	68 bb 3f 80 00       	push   $0x803fbb
  80230f:	e8 db e3 ff ff       	call   8006ef <cprintf>
  802314:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802317:	8b 45 10             	mov    0x10(%ebp),%eax
  80231a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802321:	74 07                	je     80232a <print_blocks_list+0x73>
  802323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802326:	8b 00                	mov    (%eax),%eax
  802328:	eb 05                	jmp    80232f <print_blocks_list+0x78>
  80232a:	b8 00 00 00 00       	mov    $0x0,%eax
  80232f:	89 45 10             	mov    %eax,0x10(%ebp)
  802332:	8b 45 10             	mov    0x10(%ebp),%eax
  802335:	85 c0                	test   %eax,%eax
  802337:	75 ad                	jne    8022e6 <print_blocks_list+0x2f>
  802339:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233d:	75 a7                	jne    8022e6 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80233f:	83 ec 0c             	sub    $0xc,%esp
  802342:	68 78 3f 80 00       	push   $0x803f78
  802347:	e8 a3 e3 ff ff       	call   8006ef <cprintf>
  80234c:	83 c4 10             	add    $0x10,%esp

}
  80234f:	90                   	nop
  802350:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802353:	c9                   	leave  
  802354:	c3                   	ret    

00802355 <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802355:	55                   	push   %ebp
  802356:	89 e5                	mov    %esp,%ebp
  802358:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80235b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80235e:	83 e0 01             	and    $0x1,%eax
  802361:	85 c0                	test   %eax,%eax
  802363:	74 03                	je     802368 <initialize_dynamic_allocator+0x13>
  802365:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  802368:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80236c:	0f 84 f8 00 00 00    	je     80246a <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  802372:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  802379:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  80237c:	a1 40 50 98 00       	mov    0x985040,%eax
  802381:	85 c0                	test   %eax,%eax
  802383:	0f 84 e2 00 00 00    	je     80246b <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  802389:	8b 45 08             	mov    0x8(%ebp),%eax
  80238c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  80238f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802392:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  802398:	8b 55 08             	mov    0x8(%ebp),%edx
  80239b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80239e:	01 d0                	add    %edx,%eax
  8023a0:	83 e8 04             	sub    $0x4,%eax
  8023a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8023a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  8023af:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b2:	83 c0 08             	add    $0x8,%eax
  8023b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  8023b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023bb:	83 e8 08             	sub    $0x8,%eax
  8023be:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  8023c1:	83 ec 04             	sub    $0x4,%esp
  8023c4:	6a 00                	push   $0x0
  8023c6:	ff 75 e8             	pushl  -0x18(%ebp)
  8023c9:	ff 75 ec             	pushl  -0x14(%ebp)
  8023cc:	e8 9c 00 00 00       	call   80246d <set_block_data>
  8023d1:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  8023d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  8023dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  8023e7:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  8023ee:	00 00 00 
  8023f1:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  8023f8:	00 00 00 
  8023fb:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  802402:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  802405:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802409:	75 17                	jne    802422 <initialize_dynamic_allocator+0xcd>
  80240b:	83 ec 04             	sub    $0x4,%esp
  80240e:	68 d4 3f 80 00       	push   $0x803fd4
  802413:	68 80 00 00 00       	push   $0x80
  802418:	68 f7 3f 80 00       	push   $0x803ff7
  80241d:	e8 10 e0 ff ff       	call   800432 <_panic>
  802422:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802428:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80242b:	89 10                	mov    %edx,(%eax)
  80242d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802430:	8b 00                	mov    (%eax),%eax
  802432:	85 c0                	test   %eax,%eax
  802434:	74 0d                	je     802443 <initialize_dynamic_allocator+0xee>
  802436:	a1 48 50 98 00       	mov    0x985048,%eax
  80243b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80243e:	89 50 04             	mov    %edx,0x4(%eax)
  802441:	eb 08                	jmp    80244b <initialize_dynamic_allocator+0xf6>
  802443:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802446:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80244b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80244e:	a3 48 50 98 00       	mov    %eax,0x985048
  802453:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802456:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80245d:	a1 54 50 98 00       	mov    0x985054,%eax
  802462:	40                   	inc    %eax
  802463:	a3 54 50 98 00       	mov    %eax,0x985054
  802468:	eb 01                	jmp    80246b <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  80246a:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  80246b:	c9                   	leave  
  80246c:	c3                   	ret    

0080246d <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80246d:	55                   	push   %ebp
  80246e:	89 e5                	mov    %esp,%ebp
  802470:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  802473:	8b 45 0c             	mov    0xc(%ebp),%eax
  802476:	83 e0 01             	and    $0x1,%eax
  802479:	85 c0                	test   %eax,%eax
  80247b:	74 03                	je     802480 <set_block_data+0x13>
	{
		totalSize++;
  80247d:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  802480:	8b 45 08             	mov    0x8(%ebp),%eax
  802483:	83 e8 04             	sub    $0x4,%eax
  802486:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  802489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80248c:	83 e0 fe             	and    $0xfffffffe,%eax
  80248f:	89 c2                	mov    %eax,%edx
  802491:	8b 45 10             	mov    0x10(%ebp),%eax
  802494:	83 e0 01             	and    $0x1,%eax
  802497:	09 c2                	or     %eax,%edx
  802499:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80249c:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  80249e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a1:	8d 50 f8             	lea    -0x8(%eax),%edx
  8024a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a7:	01 d0                	add    %edx,%eax
  8024a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  8024ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024af:	83 e0 fe             	and    $0xfffffffe,%eax
  8024b2:	89 c2                	mov    %eax,%edx
  8024b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8024b7:	83 e0 01             	and    $0x1,%eax
  8024ba:	09 c2                	or     %eax,%edx
  8024bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024bf:	89 10                	mov    %edx,(%eax)
}
  8024c1:	90                   	nop
  8024c2:	c9                   	leave  
  8024c3:	c3                   	ret    

008024c4 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
  8024c7:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  8024ca:	a1 48 50 98 00       	mov    0x985048,%eax
  8024cf:	85 c0                	test   %eax,%eax
  8024d1:	75 68                	jne    80253b <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  8024d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024d7:	75 17                	jne    8024f0 <insert_sorted_in_freeList+0x2c>
  8024d9:	83 ec 04             	sub    $0x4,%esp
  8024dc:	68 d4 3f 80 00       	push   $0x803fd4
  8024e1:	68 9d 00 00 00       	push   $0x9d
  8024e6:	68 f7 3f 80 00       	push   $0x803ff7
  8024eb:	e8 42 df ff ff       	call   800432 <_panic>
  8024f0:	8b 15 48 50 98 00    	mov    0x985048,%edx
  8024f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f9:	89 10                	mov    %edx,(%eax)
  8024fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fe:	8b 00                	mov    (%eax),%eax
  802500:	85 c0                	test   %eax,%eax
  802502:	74 0d                	je     802511 <insert_sorted_in_freeList+0x4d>
  802504:	a1 48 50 98 00       	mov    0x985048,%eax
  802509:	8b 55 08             	mov    0x8(%ebp),%edx
  80250c:	89 50 04             	mov    %edx,0x4(%eax)
  80250f:	eb 08                	jmp    802519 <insert_sorted_in_freeList+0x55>
  802511:	8b 45 08             	mov    0x8(%ebp),%eax
  802514:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802519:	8b 45 08             	mov    0x8(%ebp),%eax
  80251c:	a3 48 50 98 00       	mov    %eax,0x985048
  802521:	8b 45 08             	mov    0x8(%ebp),%eax
  802524:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80252b:	a1 54 50 98 00       	mov    0x985054,%eax
  802530:	40                   	inc    %eax
  802531:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  802536:	e9 1a 01 00 00       	jmp    802655 <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  80253b:	a1 48 50 98 00       	mov    0x985048,%eax
  802540:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802543:	eb 7f                	jmp    8025c4 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	3b 45 08             	cmp    0x8(%ebp),%eax
  80254b:	76 6f                	jbe    8025bc <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  80254d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802551:	74 06                	je     802559 <insert_sorted_in_freeList+0x95>
  802553:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802557:	75 17                	jne    802570 <insert_sorted_in_freeList+0xac>
  802559:	83 ec 04             	sub    $0x4,%esp
  80255c:	68 10 40 80 00       	push   $0x804010
  802561:	68 a6 00 00 00       	push   $0xa6
  802566:	68 f7 3f 80 00       	push   $0x803ff7
  80256b:	e8 c2 de ff ff       	call   800432 <_panic>
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	8b 50 04             	mov    0x4(%eax),%edx
  802576:	8b 45 08             	mov    0x8(%ebp),%eax
  802579:	89 50 04             	mov    %edx,0x4(%eax)
  80257c:	8b 45 08             	mov    0x8(%ebp),%eax
  80257f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802582:	89 10                	mov    %edx,(%eax)
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	8b 40 04             	mov    0x4(%eax),%eax
  80258a:	85 c0                	test   %eax,%eax
  80258c:	74 0d                	je     80259b <insert_sorted_in_freeList+0xd7>
  80258e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802591:	8b 40 04             	mov    0x4(%eax),%eax
  802594:	8b 55 08             	mov    0x8(%ebp),%edx
  802597:	89 10                	mov    %edx,(%eax)
  802599:	eb 08                	jmp    8025a3 <insert_sorted_in_freeList+0xdf>
  80259b:	8b 45 08             	mov    0x8(%ebp),%eax
  80259e:	a3 48 50 98 00       	mov    %eax,0x985048
  8025a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8025a9:	89 50 04             	mov    %edx,0x4(%eax)
  8025ac:	a1 54 50 98 00       	mov    0x985054,%eax
  8025b1:	40                   	inc    %eax
  8025b2:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  8025b7:	e9 99 00 00 00       	jmp    802655 <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8025bc:	a1 50 50 98 00       	mov    0x985050,%eax
  8025c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c8:	74 07                	je     8025d1 <insert_sorted_in_freeList+0x10d>
  8025ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cd:	8b 00                	mov    (%eax),%eax
  8025cf:	eb 05                	jmp    8025d6 <insert_sorted_in_freeList+0x112>
  8025d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d6:	a3 50 50 98 00       	mov    %eax,0x985050
  8025db:	a1 50 50 98 00       	mov    0x985050,%eax
  8025e0:	85 c0                	test   %eax,%eax
  8025e2:	0f 85 5d ff ff ff    	jne    802545 <insert_sorted_in_freeList+0x81>
  8025e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ec:	0f 85 53 ff ff ff    	jne    802545 <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  8025f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025f6:	75 17                	jne    80260f <insert_sorted_in_freeList+0x14b>
  8025f8:	83 ec 04             	sub    $0x4,%esp
  8025fb:	68 48 40 80 00       	push   $0x804048
  802600:	68 ab 00 00 00       	push   $0xab
  802605:	68 f7 3f 80 00       	push   $0x803ff7
  80260a:	e8 23 de ff ff       	call   800432 <_panic>
  80260f:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  802615:	8b 45 08             	mov    0x8(%ebp),%eax
  802618:	89 50 04             	mov    %edx,0x4(%eax)
  80261b:	8b 45 08             	mov    0x8(%ebp),%eax
  80261e:	8b 40 04             	mov    0x4(%eax),%eax
  802621:	85 c0                	test   %eax,%eax
  802623:	74 0c                	je     802631 <insert_sorted_in_freeList+0x16d>
  802625:	a1 4c 50 98 00       	mov    0x98504c,%eax
  80262a:	8b 55 08             	mov    0x8(%ebp),%edx
  80262d:	89 10                	mov    %edx,(%eax)
  80262f:	eb 08                	jmp    802639 <insert_sorted_in_freeList+0x175>
  802631:	8b 45 08             	mov    0x8(%ebp),%eax
  802634:	a3 48 50 98 00       	mov    %eax,0x985048
  802639:	8b 45 08             	mov    0x8(%ebp),%eax
  80263c:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802641:	8b 45 08             	mov    0x8(%ebp),%eax
  802644:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80264a:	a1 54 50 98 00       	mov    0x985054,%eax
  80264f:	40                   	inc    %eax
  802650:	a3 54 50 98 00       	mov    %eax,0x985054
}
  802655:	c9                   	leave  
  802656:	c3                   	ret    

00802657 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802657:	55                   	push   %ebp
  802658:	89 e5                	mov    %esp,%ebp
  80265a:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80265d:	8b 45 08             	mov    0x8(%ebp),%eax
  802660:	83 e0 01             	and    $0x1,%eax
  802663:	85 c0                	test   %eax,%eax
  802665:	74 03                	je     80266a <alloc_block_FF+0x13>
  802667:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80266a:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80266e:	77 07                	ja     802677 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802670:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802677:	a1 40 50 98 00       	mov    0x985040,%eax
  80267c:	85 c0                	test   %eax,%eax
  80267e:	75 63                	jne    8026e3 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802680:	8b 45 08             	mov    0x8(%ebp),%eax
  802683:	83 c0 10             	add    $0x10,%eax
  802686:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802689:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802690:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802693:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802696:	01 d0                	add    %edx,%eax
  802698:	48                   	dec    %eax
  802699:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80269c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80269f:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a4:	f7 75 ec             	divl   -0x14(%ebp)
  8026a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026aa:	29 d0                	sub    %edx,%eax
  8026ac:	c1 e8 0c             	shr    $0xc,%eax
  8026af:	83 ec 0c             	sub    $0xc,%esp
  8026b2:	50                   	push   %eax
  8026b3:	e8 d1 ed ff ff       	call   801489 <sbrk>
  8026b8:	83 c4 10             	add    $0x10,%esp
  8026bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8026be:	83 ec 0c             	sub    $0xc,%esp
  8026c1:	6a 00                	push   $0x0
  8026c3:	e8 c1 ed ff ff       	call   801489 <sbrk>
  8026c8:	83 c4 10             	add    $0x10,%esp
  8026cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8026ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8026d4:	83 ec 08             	sub    $0x8,%esp
  8026d7:	50                   	push   %eax
  8026d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8026db:	e8 75 fc ff ff       	call   802355 <initialize_dynamic_allocator>
  8026e0:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  8026e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026e7:	75 0a                	jne    8026f3 <alloc_block_FF+0x9c>
	{
		return NULL;
  8026e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ee:	e9 99 03 00 00       	jmp    802a8c <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  8026f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f6:	83 c0 08             	add    $0x8,%eax
  8026f9:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8026fc:	a1 48 50 98 00       	mov    0x985048,%eax
  802701:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802704:	e9 03 02 00 00       	jmp    80290c <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802709:	83 ec 0c             	sub    $0xc,%esp
  80270c:	ff 75 f4             	pushl  -0xc(%ebp)
  80270f:	e8 dd fa ff ff       	call   8021f1 <get_block_size>
  802714:	83 c4 10             	add    $0x10,%esp
  802717:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  80271a:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80271d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802720:	0f 82 de 01 00 00    	jb     802904 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  802726:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802729:	83 c0 10             	add    $0x10,%eax
  80272c:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  80272f:	0f 87 32 01 00 00    	ja     802867 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  802735:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802738:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80273b:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  80273e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802741:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802744:	01 d0                	add    %edx,%eax
  802746:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  802749:	83 ec 04             	sub    $0x4,%esp
  80274c:	6a 00                	push   $0x0
  80274e:	ff 75 98             	pushl  -0x68(%ebp)
  802751:	ff 75 94             	pushl  -0x6c(%ebp)
  802754:	e8 14 fd ff ff       	call   80246d <set_block_data>
  802759:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  80275c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802760:	74 06                	je     802768 <alloc_block_FF+0x111>
  802762:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  802766:	75 17                	jne    80277f <alloc_block_FF+0x128>
  802768:	83 ec 04             	sub    $0x4,%esp
  80276b:	68 6c 40 80 00       	push   $0x80406c
  802770:	68 de 00 00 00       	push   $0xde
  802775:	68 f7 3f 80 00       	push   $0x803ff7
  80277a:	e8 b3 dc ff ff       	call   800432 <_panic>
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	8b 10                	mov    (%eax),%edx
  802784:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802787:	89 10                	mov    %edx,(%eax)
  802789:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80278c:	8b 00                	mov    (%eax),%eax
  80278e:	85 c0                	test   %eax,%eax
  802790:	74 0b                	je     80279d <alloc_block_FF+0x146>
  802792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802795:	8b 00                	mov    (%eax),%eax
  802797:	8b 55 94             	mov    -0x6c(%ebp),%edx
  80279a:	89 50 04             	mov    %edx,0x4(%eax)
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8027a3:	89 10                	mov    %edx,(%eax)
  8027a5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8027a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ab:	89 50 04             	mov    %edx,0x4(%eax)
  8027ae:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8027b1:	8b 00                	mov    (%eax),%eax
  8027b3:	85 c0                	test   %eax,%eax
  8027b5:	75 08                	jne    8027bf <alloc_block_FF+0x168>
  8027b7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8027ba:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8027bf:	a1 54 50 98 00       	mov    0x985054,%eax
  8027c4:	40                   	inc    %eax
  8027c5:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  8027ca:	83 ec 04             	sub    $0x4,%esp
  8027cd:	6a 01                	push   $0x1
  8027cf:	ff 75 dc             	pushl  -0x24(%ebp)
  8027d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8027d5:	e8 93 fc ff ff       	call   80246d <set_block_data>
  8027da:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  8027dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e1:	75 17                	jne    8027fa <alloc_block_FF+0x1a3>
  8027e3:	83 ec 04             	sub    $0x4,%esp
  8027e6:	68 a0 40 80 00       	push   $0x8040a0
  8027eb:	68 e3 00 00 00       	push   $0xe3
  8027f0:	68 f7 3f 80 00       	push   $0x803ff7
  8027f5:	e8 38 dc ff ff       	call   800432 <_panic>
  8027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fd:	8b 00                	mov    (%eax),%eax
  8027ff:	85 c0                	test   %eax,%eax
  802801:	74 10                	je     802813 <alloc_block_FF+0x1bc>
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	8b 00                	mov    (%eax),%eax
  802808:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80280b:	8b 52 04             	mov    0x4(%edx),%edx
  80280e:	89 50 04             	mov    %edx,0x4(%eax)
  802811:	eb 0b                	jmp    80281e <alloc_block_FF+0x1c7>
  802813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802816:	8b 40 04             	mov    0x4(%eax),%eax
  802819:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	8b 40 04             	mov    0x4(%eax),%eax
  802824:	85 c0                	test   %eax,%eax
  802826:	74 0f                	je     802837 <alloc_block_FF+0x1e0>
  802828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282b:	8b 40 04             	mov    0x4(%eax),%eax
  80282e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802831:	8b 12                	mov    (%edx),%edx
  802833:	89 10                	mov    %edx,(%eax)
  802835:	eb 0a                	jmp    802841 <alloc_block_FF+0x1ea>
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	8b 00                	mov    (%eax),%eax
  80283c:	a3 48 50 98 00       	mov    %eax,0x985048
  802841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802844:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802854:	a1 54 50 98 00       	mov    0x985054,%eax
  802859:	48                   	dec    %eax
  80285a:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	e9 25 02 00 00       	jmp    802a8c <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  802867:	83 ec 04             	sub    $0x4,%esp
  80286a:	6a 01                	push   $0x1
  80286c:	ff 75 9c             	pushl  -0x64(%ebp)
  80286f:	ff 75 f4             	pushl  -0xc(%ebp)
  802872:	e8 f6 fb ff ff       	call   80246d <set_block_data>
  802877:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  80287a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287e:	75 17                	jne    802897 <alloc_block_FF+0x240>
  802880:	83 ec 04             	sub    $0x4,%esp
  802883:	68 a0 40 80 00       	push   $0x8040a0
  802888:	68 eb 00 00 00       	push   $0xeb
  80288d:	68 f7 3f 80 00       	push   $0x803ff7
  802892:	e8 9b db ff ff       	call   800432 <_panic>
  802897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289a:	8b 00                	mov    (%eax),%eax
  80289c:	85 c0                	test   %eax,%eax
  80289e:	74 10                	je     8028b0 <alloc_block_FF+0x259>
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	8b 00                	mov    (%eax),%eax
  8028a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a8:	8b 52 04             	mov    0x4(%edx),%edx
  8028ab:	89 50 04             	mov    %edx,0x4(%eax)
  8028ae:	eb 0b                	jmp    8028bb <alloc_block_FF+0x264>
  8028b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b3:	8b 40 04             	mov    0x4(%eax),%eax
  8028b6:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8028bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028be:	8b 40 04             	mov    0x4(%eax),%eax
  8028c1:	85 c0                	test   %eax,%eax
  8028c3:	74 0f                	je     8028d4 <alloc_block_FF+0x27d>
  8028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c8:	8b 40 04             	mov    0x4(%eax),%eax
  8028cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ce:	8b 12                	mov    (%edx),%edx
  8028d0:	89 10                	mov    %edx,(%eax)
  8028d2:	eb 0a                	jmp    8028de <alloc_block_FF+0x287>
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	8b 00                	mov    (%eax),%eax
  8028d9:	a3 48 50 98 00       	mov    %eax,0x985048
  8028de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f1:	a1 54 50 98 00       	mov    0x985054,%eax
  8028f6:	48                   	dec    %eax
  8028f7:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  8028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ff:	e9 88 01 00 00       	jmp    802a8c <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802904:	a1 50 50 98 00       	mov    0x985050,%eax
  802909:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80290c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802910:	74 07                	je     802919 <alloc_block_FF+0x2c2>
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 00                	mov    (%eax),%eax
  802917:	eb 05                	jmp    80291e <alloc_block_FF+0x2c7>
  802919:	b8 00 00 00 00       	mov    $0x0,%eax
  80291e:	a3 50 50 98 00       	mov    %eax,0x985050
  802923:	a1 50 50 98 00       	mov    0x985050,%eax
  802928:	85 c0                	test   %eax,%eax
  80292a:	0f 85 d9 fd ff ff    	jne    802709 <alloc_block_FF+0xb2>
  802930:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802934:	0f 85 cf fd ff ff    	jne    802709 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  80293a:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802941:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802944:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802947:	01 d0                	add    %edx,%eax
  802949:	48                   	dec    %eax
  80294a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80294d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802950:	ba 00 00 00 00       	mov    $0x0,%edx
  802955:	f7 75 d8             	divl   -0x28(%ebp)
  802958:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80295b:	29 d0                	sub    %edx,%eax
  80295d:	c1 e8 0c             	shr    $0xc,%eax
  802960:	83 ec 0c             	sub    $0xc,%esp
  802963:	50                   	push   %eax
  802964:	e8 20 eb ff ff       	call   801489 <sbrk>
  802969:	83 c4 10             	add    $0x10,%esp
  80296c:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  80296f:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802973:	75 0a                	jne    80297f <alloc_block_FF+0x328>
		return NULL;
  802975:	b8 00 00 00 00       	mov    $0x0,%eax
  80297a:	e9 0d 01 00 00       	jmp    802a8c <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  80297f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802982:	83 e8 04             	sub    $0x4,%eax
  802985:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  802988:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  80298f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802992:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802995:	01 d0                	add    %edx,%eax
  802997:	48                   	dec    %eax
  802998:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80299b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80299e:	ba 00 00 00 00       	mov    $0x0,%edx
  8029a3:	f7 75 c8             	divl   -0x38(%ebp)
  8029a6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8029a9:	29 d0                	sub    %edx,%eax
  8029ab:	c1 e8 02             	shr    $0x2,%eax
  8029ae:	c1 e0 02             	shl    $0x2,%eax
  8029b1:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  8029b4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029b7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  8029bd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029c0:	83 e8 08             	sub    $0x8,%eax
  8029c3:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  8029c6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029c9:	8b 00                	mov    (%eax),%eax
  8029cb:	83 e0 fe             	and    $0xfffffffe,%eax
  8029ce:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  8029d1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8029d4:	f7 d8                	neg    %eax
  8029d6:	89 c2                	mov    %eax,%edx
  8029d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029db:	01 d0                	add    %edx,%eax
  8029dd:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  8029e0:	83 ec 0c             	sub    $0xc,%esp
  8029e3:	ff 75 b8             	pushl  -0x48(%ebp)
  8029e6:	e8 1f f8 ff ff       	call   80220a <is_free_block>
  8029eb:	83 c4 10             	add    $0x10,%esp
  8029ee:	0f be c0             	movsbl %al,%eax
  8029f1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  8029f4:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8029f8:	74 42                	je     802a3c <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  8029fa:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802a01:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a04:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a07:	01 d0                	add    %edx,%eax
  802a09:	48                   	dec    %eax
  802a0a:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802a0d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a10:	ba 00 00 00 00       	mov    $0x0,%edx
  802a15:	f7 75 b0             	divl   -0x50(%ebp)
  802a18:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a1b:	29 d0                	sub    %edx,%eax
  802a1d:	89 c2                	mov    %eax,%edx
  802a1f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a22:	01 d0                	add    %edx,%eax
  802a24:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  802a27:	83 ec 04             	sub    $0x4,%esp
  802a2a:	6a 00                	push   $0x0
  802a2c:	ff 75 a8             	pushl  -0x58(%ebp)
  802a2f:	ff 75 b8             	pushl  -0x48(%ebp)
  802a32:	e8 36 fa ff ff       	call   80246d <set_block_data>
  802a37:	83 c4 10             	add    $0x10,%esp
  802a3a:	eb 42                	jmp    802a7e <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802a3c:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  802a43:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a46:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a49:	01 d0                	add    %edx,%eax
  802a4b:	48                   	dec    %eax
  802a4c:	89 45 a0             	mov    %eax,-0x60(%ebp)
  802a4f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802a52:	ba 00 00 00 00       	mov    $0x0,%edx
  802a57:	f7 75 a4             	divl   -0x5c(%ebp)
  802a5a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802a5d:	29 d0                	sub    %edx,%eax
  802a5f:	83 ec 04             	sub    $0x4,%esp
  802a62:	6a 00                	push   $0x0
  802a64:	50                   	push   %eax
  802a65:	ff 75 d0             	pushl  -0x30(%ebp)
  802a68:	e8 00 fa ff ff       	call   80246d <set_block_data>
  802a6d:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802a70:	83 ec 0c             	sub    $0xc,%esp
  802a73:	ff 75 d0             	pushl  -0x30(%ebp)
  802a76:	e8 49 fa ff ff       	call   8024c4 <insert_sorted_in_freeList>
  802a7b:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802a7e:	83 ec 0c             	sub    $0xc,%esp
  802a81:	ff 75 08             	pushl  0x8(%ebp)
  802a84:	e8 ce fb ff ff       	call   802657 <alloc_block_FF>
  802a89:	83 c4 10             	add    $0x10,%esp
}
  802a8c:	c9                   	leave  
  802a8d:	c3                   	ret    

00802a8e <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802a8e:	55                   	push   %ebp
  802a8f:	89 e5                	mov    %esp,%ebp
  802a91:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  802a94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a98:	75 0a                	jne    802aa4 <alloc_block_BF+0x16>
	{
		return NULL;
  802a9a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a9f:	e9 7a 02 00 00       	jmp    802d1e <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa7:	83 c0 08             	add    $0x8,%eax
  802aaa:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802aad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  802ab4:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802abb:	a1 48 50 98 00       	mov    0x985048,%eax
  802ac0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802ac3:	eb 32                	jmp    802af7 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  802ac5:	ff 75 ec             	pushl  -0x14(%ebp)
  802ac8:	e8 24 f7 ff ff       	call   8021f1 <get_block_size>
  802acd:	83 c4 04             	add    $0x4,%esp
  802ad0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  802ad3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ad6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802ad9:	72 14                	jb     802aef <alloc_block_BF+0x61>
  802adb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ade:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ae1:	73 0c                	jae    802aef <alloc_block_BF+0x61>
		{
			minBlk = block;
  802ae3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae6:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  802ae9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802aef:	a1 50 50 98 00       	mov    0x985050,%eax
  802af4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802af7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802afb:	74 07                	je     802b04 <alloc_block_BF+0x76>
  802afd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b00:	8b 00                	mov    (%eax),%eax
  802b02:	eb 05                	jmp    802b09 <alloc_block_BF+0x7b>
  802b04:	b8 00 00 00 00       	mov    $0x0,%eax
  802b09:	a3 50 50 98 00       	mov    %eax,0x985050
  802b0e:	a1 50 50 98 00       	mov    0x985050,%eax
  802b13:	85 c0                	test   %eax,%eax
  802b15:	75 ae                	jne    802ac5 <alloc_block_BF+0x37>
  802b17:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b1b:	75 a8                	jne    802ac5 <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802b1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b21:	75 22                	jne    802b45 <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802b23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b26:	83 ec 0c             	sub    $0xc,%esp
  802b29:	50                   	push   %eax
  802b2a:	e8 5a e9 ff ff       	call   801489 <sbrk>
  802b2f:	83 c4 10             	add    $0x10,%esp
  802b32:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  802b35:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802b39:	75 0a                	jne    802b45 <alloc_block_BF+0xb7>
			return NULL;
  802b3b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b40:	e9 d9 01 00 00       	jmp    802d1e <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  802b45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b48:	83 c0 10             	add    $0x10,%eax
  802b4b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b4e:	0f 87 32 01 00 00    	ja     802c86 <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  802b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b57:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802b5a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802b5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b63:	01 d0                	add    %edx,%eax
  802b65:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  802b68:	83 ec 04             	sub    $0x4,%esp
  802b6b:	6a 00                	push   $0x0
  802b6d:	ff 75 dc             	pushl  -0x24(%ebp)
  802b70:	ff 75 d8             	pushl  -0x28(%ebp)
  802b73:	e8 f5 f8 ff ff       	call   80246d <set_block_data>
  802b78:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802b7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b7f:	74 06                	je     802b87 <alloc_block_BF+0xf9>
  802b81:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802b85:	75 17                	jne    802b9e <alloc_block_BF+0x110>
  802b87:	83 ec 04             	sub    $0x4,%esp
  802b8a:	68 6c 40 80 00       	push   $0x80406c
  802b8f:	68 49 01 00 00       	push   $0x149
  802b94:	68 f7 3f 80 00       	push   $0x803ff7
  802b99:	e8 94 d8 ff ff       	call   800432 <_panic>
  802b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba1:	8b 10                	mov    (%eax),%edx
  802ba3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ba6:	89 10                	mov    %edx,(%eax)
  802ba8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bab:	8b 00                	mov    (%eax),%eax
  802bad:	85 c0                	test   %eax,%eax
  802baf:	74 0b                	je     802bbc <alloc_block_BF+0x12e>
  802bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb4:	8b 00                	mov    (%eax),%eax
  802bb6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802bb9:	89 50 04             	mov    %edx,0x4(%eax)
  802bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802bc2:	89 10                	mov    %edx,(%eax)
  802bc4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bca:	89 50 04             	mov    %edx,0x4(%eax)
  802bcd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bd0:	8b 00                	mov    (%eax),%eax
  802bd2:	85 c0                	test   %eax,%eax
  802bd4:	75 08                	jne    802bde <alloc_block_BF+0x150>
  802bd6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bd9:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802bde:	a1 54 50 98 00       	mov    0x985054,%eax
  802be3:	40                   	inc    %eax
  802be4:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802be9:	83 ec 04             	sub    $0x4,%esp
  802bec:	6a 01                	push   $0x1
  802bee:	ff 75 e8             	pushl  -0x18(%ebp)
  802bf1:	ff 75 f4             	pushl  -0xc(%ebp)
  802bf4:	e8 74 f8 ff ff       	call   80246d <set_block_data>
  802bf9:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802bfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c00:	75 17                	jne    802c19 <alloc_block_BF+0x18b>
  802c02:	83 ec 04             	sub    $0x4,%esp
  802c05:	68 a0 40 80 00       	push   $0x8040a0
  802c0a:	68 4e 01 00 00       	push   $0x14e
  802c0f:	68 f7 3f 80 00       	push   $0x803ff7
  802c14:	e8 19 d8 ff ff       	call   800432 <_panic>
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	8b 00                	mov    (%eax),%eax
  802c1e:	85 c0                	test   %eax,%eax
  802c20:	74 10                	je     802c32 <alloc_block_BF+0x1a4>
  802c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c25:	8b 00                	mov    (%eax),%eax
  802c27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c2a:	8b 52 04             	mov    0x4(%edx),%edx
  802c2d:	89 50 04             	mov    %edx,0x4(%eax)
  802c30:	eb 0b                	jmp    802c3d <alloc_block_BF+0x1af>
  802c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c35:	8b 40 04             	mov    0x4(%eax),%eax
  802c38:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c40:	8b 40 04             	mov    0x4(%eax),%eax
  802c43:	85 c0                	test   %eax,%eax
  802c45:	74 0f                	je     802c56 <alloc_block_BF+0x1c8>
  802c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4a:	8b 40 04             	mov    0x4(%eax),%eax
  802c4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c50:	8b 12                	mov    (%edx),%edx
  802c52:	89 10                	mov    %edx,(%eax)
  802c54:	eb 0a                	jmp    802c60 <alloc_block_BF+0x1d2>
  802c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c59:	8b 00                	mov    (%eax),%eax
  802c5b:	a3 48 50 98 00       	mov    %eax,0x985048
  802c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c73:	a1 54 50 98 00       	mov    0x985054,%eax
  802c78:	48                   	dec    %eax
  802c79:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	e9 98 00 00 00       	jmp    802d1e <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  802c86:	83 ec 04             	sub    $0x4,%esp
  802c89:	6a 01                	push   $0x1
  802c8b:	ff 75 f0             	pushl  -0x10(%ebp)
  802c8e:	ff 75 f4             	pushl  -0xc(%ebp)
  802c91:	e8 d7 f7 ff ff       	call   80246d <set_block_data>
  802c96:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802c99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9d:	75 17                	jne    802cb6 <alloc_block_BF+0x228>
  802c9f:	83 ec 04             	sub    $0x4,%esp
  802ca2:	68 a0 40 80 00       	push   $0x8040a0
  802ca7:	68 56 01 00 00       	push   $0x156
  802cac:	68 f7 3f 80 00       	push   $0x803ff7
  802cb1:	e8 7c d7 ff ff       	call   800432 <_panic>
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	8b 00                	mov    (%eax),%eax
  802cbb:	85 c0                	test   %eax,%eax
  802cbd:	74 10                	je     802ccf <alloc_block_BF+0x241>
  802cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc2:	8b 00                	mov    (%eax),%eax
  802cc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc7:	8b 52 04             	mov    0x4(%edx),%edx
  802cca:	89 50 04             	mov    %edx,0x4(%eax)
  802ccd:	eb 0b                	jmp    802cda <alloc_block_BF+0x24c>
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	8b 40 04             	mov    0x4(%eax),%eax
  802cd5:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdd:	8b 40 04             	mov    0x4(%eax),%eax
  802ce0:	85 c0                	test   %eax,%eax
  802ce2:	74 0f                	je     802cf3 <alloc_block_BF+0x265>
  802ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce7:	8b 40 04             	mov    0x4(%eax),%eax
  802cea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ced:	8b 12                	mov    (%edx),%edx
  802cef:	89 10                	mov    %edx,(%eax)
  802cf1:	eb 0a                	jmp    802cfd <alloc_block_BF+0x26f>
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	8b 00                	mov    (%eax),%eax
  802cf8:	a3 48 50 98 00       	mov    %eax,0x985048
  802cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d09:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d10:	a1 54 50 98 00       	mov    0x985054,%eax
  802d15:	48                   	dec    %eax
  802d16:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802d1e:	c9                   	leave  
  802d1f:	c3                   	ret    

00802d20 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802d20:	55                   	push   %ebp
  802d21:	89 e5                	mov    %esp,%ebp
  802d23:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802d26:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d2a:	0f 84 6a 02 00 00    	je     802f9a <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  802d30:	ff 75 08             	pushl  0x8(%ebp)
  802d33:	e8 b9 f4 ff ff       	call   8021f1 <get_block_size>
  802d38:	83 c4 04             	add    $0x4,%esp
  802d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  802d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d41:	83 e8 08             	sub    $0x8,%eax
  802d44:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  802d47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4a:	8b 00                	mov    (%eax),%eax
  802d4c:	83 e0 fe             	and    $0xfffffffe,%eax
  802d4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  802d52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d55:	f7 d8                	neg    %eax
  802d57:	89 c2                	mov    %eax,%edx
  802d59:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5c:	01 d0                	add    %edx,%eax
  802d5e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802d61:	ff 75 e8             	pushl  -0x18(%ebp)
  802d64:	e8 a1 f4 ff ff       	call   80220a <is_free_block>
  802d69:	83 c4 04             	add    $0x4,%esp
  802d6c:	0f be c0             	movsbl %al,%eax
  802d6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802d72:	8b 55 08             	mov    0x8(%ebp),%edx
  802d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d78:	01 d0                	add    %edx,%eax
  802d7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802d7d:	ff 75 e0             	pushl  -0x20(%ebp)
  802d80:	e8 85 f4 ff ff       	call   80220a <is_free_block>
  802d85:	83 c4 04             	add    $0x4,%esp
  802d88:	0f be c0             	movsbl %al,%eax
  802d8b:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802d8e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802d92:	75 34                	jne    802dc8 <free_block+0xa8>
  802d94:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d98:	75 2e                	jne    802dc8 <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802d9a:	ff 75 e8             	pushl  -0x18(%ebp)
  802d9d:	e8 4f f4 ff ff       	call   8021f1 <get_block_size>
  802da2:	83 c4 04             	add    $0x4,%esp
  802da5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802da8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802dae:	01 d0                	add    %edx,%eax
  802db0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802db3:	6a 00                	push   $0x0
  802db5:	ff 75 d4             	pushl  -0x2c(%ebp)
  802db8:	ff 75 e8             	pushl  -0x18(%ebp)
  802dbb:	e8 ad f6 ff ff       	call   80246d <set_block_data>
  802dc0:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802dc3:	e9 d3 01 00 00       	jmp    802f9b <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802dc8:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802dcc:	0f 85 c8 00 00 00    	jne    802e9a <free_block+0x17a>
  802dd2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802dd6:	0f 85 be 00 00 00    	jne    802e9a <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802ddc:	ff 75 e0             	pushl  -0x20(%ebp)
  802ddf:	e8 0d f4 ff ff       	call   8021f1 <get_block_size>
  802de4:	83 c4 04             	add    $0x4,%esp
  802de7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802dea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ded:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802df0:	01 d0                	add    %edx,%eax
  802df2:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802df5:	6a 00                	push   $0x0
  802df7:	ff 75 cc             	pushl  -0x34(%ebp)
  802dfa:	ff 75 08             	pushl  0x8(%ebp)
  802dfd:	e8 6b f6 ff ff       	call   80246d <set_block_data>
  802e02:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802e05:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e09:	75 17                	jne    802e22 <free_block+0x102>
  802e0b:	83 ec 04             	sub    $0x4,%esp
  802e0e:	68 a0 40 80 00       	push   $0x8040a0
  802e13:	68 87 01 00 00       	push   $0x187
  802e18:	68 f7 3f 80 00       	push   $0x803ff7
  802e1d:	e8 10 d6 ff ff       	call   800432 <_panic>
  802e22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e25:	8b 00                	mov    (%eax),%eax
  802e27:	85 c0                	test   %eax,%eax
  802e29:	74 10                	je     802e3b <free_block+0x11b>
  802e2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e2e:	8b 00                	mov    (%eax),%eax
  802e30:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e33:	8b 52 04             	mov    0x4(%edx),%edx
  802e36:	89 50 04             	mov    %edx,0x4(%eax)
  802e39:	eb 0b                	jmp    802e46 <free_block+0x126>
  802e3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e3e:	8b 40 04             	mov    0x4(%eax),%eax
  802e41:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802e46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e49:	8b 40 04             	mov    0x4(%eax),%eax
  802e4c:	85 c0                	test   %eax,%eax
  802e4e:	74 0f                	je     802e5f <free_block+0x13f>
  802e50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e53:	8b 40 04             	mov    0x4(%eax),%eax
  802e56:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e59:	8b 12                	mov    (%edx),%edx
  802e5b:	89 10                	mov    %edx,(%eax)
  802e5d:	eb 0a                	jmp    802e69 <free_block+0x149>
  802e5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e62:	8b 00                	mov    (%eax),%eax
  802e64:	a3 48 50 98 00       	mov    %eax,0x985048
  802e69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e7c:	a1 54 50 98 00       	mov    0x985054,%eax
  802e81:	48                   	dec    %eax
  802e82:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802e87:	83 ec 0c             	sub    $0xc,%esp
  802e8a:	ff 75 08             	pushl  0x8(%ebp)
  802e8d:	e8 32 f6 ff ff       	call   8024c4 <insert_sorted_in_freeList>
  802e92:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802e95:	e9 01 01 00 00       	jmp    802f9b <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  802e9a:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802e9e:	0f 85 d3 00 00 00    	jne    802f77 <free_block+0x257>
  802ea4:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802ea8:	0f 85 c9 00 00 00    	jne    802f77 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  802eae:	83 ec 0c             	sub    $0xc,%esp
  802eb1:	ff 75 e8             	pushl  -0x18(%ebp)
  802eb4:	e8 38 f3 ff ff       	call   8021f1 <get_block_size>
  802eb9:	83 c4 10             	add    $0x10,%esp
  802ebc:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  802ebf:	83 ec 0c             	sub    $0xc,%esp
  802ec2:	ff 75 e0             	pushl  -0x20(%ebp)
  802ec5:	e8 27 f3 ff ff       	call   8021f1 <get_block_size>
  802eca:	83 c4 10             	add    $0x10,%esp
  802ecd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  802ed0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ed6:	01 c2                	add    %eax,%edx
  802ed8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802edb:	01 d0                	add    %edx,%eax
  802edd:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  802ee0:	83 ec 04             	sub    $0x4,%esp
  802ee3:	6a 00                	push   $0x0
  802ee5:	ff 75 c0             	pushl  -0x40(%ebp)
  802ee8:	ff 75 e8             	pushl  -0x18(%ebp)
  802eeb:	e8 7d f5 ff ff       	call   80246d <set_block_data>
  802ef0:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  802ef3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ef7:	75 17                	jne    802f10 <free_block+0x1f0>
  802ef9:	83 ec 04             	sub    $0x4,%esp
  802efc:	68 a0 40 80 00       	push   $0x8040a0
  802f01:	68 94 01 00 00       	push   $0x194
  802f06:	68 f7 3f 80 00       	push   $0x803ff7
  802f0b:	e8 22 d5 ff ff       	call   800432 <_panic>
  802f10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f13:	8b 00                	mov    (%eax),%eax
  802f15:	85 c0                	test   %eax,%eax
  802f17:	74 10                	je     802f29 <free_block+0x209>
  802f19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f1c:	8b 00                	mov    (%eax),%eax
  802f1e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f21:	8b 52 04             	mov    0x4(%edx),%edx
  802f24:	89 50 04             	mov    %edx,0x4(%eax)
  802f27:	eb 0b                	jmp    802f34 <free_block+0x214>
  802f29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f2c:	8b 40 04             	mov    0x4(%eax),%eax
  802f2f:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802f34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f37:	8b 40 04             	mov    0x4(%eax),%eax
  802f3a:	85 c0                	test   %eax,%eax
  802f3c:	74 0f                	je     802f4d <free_block+0x22d>
  802f3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f41:	8b 40 04             	mov    0x4(%eax),%eax
  802f44:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f47:	8b 12                	mov    (%edx),%edx
  802f49:	89 10                	mov    %edx,(%eax)
  802f4b:	eb 0a                	jmp    802f57 <free_block+0x237>
  802f4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f50:	8b 00                	mov    (%eax),%eax
  802f52:	a3 48 50 98 00       	mov    %eax,0x985048
  802f57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f6a:	a1 54 50 98 00       	mov    0x985054,%eax
  802f6f:	48                   	dec    %eax
  802f70:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  802f75:	eb 24                	jmp    802f9b <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  802f77:	83 ec 04             	sub    $0x4,%esp
  802f7a:	6a 00                	push   $0x0
  802f7c:	ff 75 f4             	pushl  -0xc(%ebp)
  802f7f:	ff 75 08             	pushl  0x8(%ebp)
  802f82:	e8 e6 f4 ff ff       	call   80246d <set_block_data>
  802f87:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802f8a:	83 ec 0c             	sub    $0xc,%esp
  802f8d:	ff 75 08             	pushl  0x8(%ebp)
  802f90:	e8 2f f5 ff ff       	call   8024c4 <insert_sorted_in_freeList>
  802f95:	83 c4 10             	add    $0x10,%esp
  802f98:	eb 01                	jmp    802f9b <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  802f9a:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  802f9b:	c9                   	leave  
  802f9c:	c3                   	ret    

00802f9d <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802f9d:	55                   	push   %ebp
  802f9e:	89 e5                	mov    %esp,%ebp
  802fa0:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  802fa3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fa7:	75 10                	jne    802fb9 <realloc_block_FF+0x1c>
  802fa9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fad:	75 0a                	jne    802fb9 <realloc_block_FF+0x1c>
	{
		return NULL;
  802faf:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb4:	e9 8b 04 00 00       	jmp    803444 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  802fb9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fbd:	75 18                	jne    802fd7 <realloc_block_FF+0x3a>
	{
		free_block(va);
  802fbf:	83 ec 0c             	sub    $0xc,%esp
  802fc2:	ff 75 08             	pushl  0x8(%ebp)
  802fc5:	e8 56 fd ff ff       	call   802d20 <free_block>
  802fca:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802fcd:	b8 00 00 00 00       	mov    $0x0,%eax
  802fd2:	e9 6d 04 00 00       	jmp    803444 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  802fd7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fdb:	75 13                	jne    802ff0 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  802fdd:	83 ec 0c             	sub    $0xc,%esp
  802fe0:	ff 75 0c             	pushl  0xc(%ebp)
  802fe3:	e8 6f f6 ff ff       	call   802657 <alloc_block_FF>
  802fe8:	83 c4 10             	add    $0x10,%esp
  802feb:	e9 54 04 00 00       	jmp    803444 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  802ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff3:	83 e0 01             	and    $0x1,%eax
  802ff6:	85 c0                	test   %eax,%eax
  802ff8:	74 03                	je     802ffd <realloc_block_FF+0x60>
	{
		new_size++;
  802ffa:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  802ffd:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803001:	77 07                	ja     80300a <realloc_block_FF+0x6d>
	{
		new_size = 8;
  803003:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  80300a:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  80300e:	83 ec 0c             	sub    $0xc,%esp
  803011:	ff 75 08             	pushl  0x8(%ebp)
  803014:	e8 d8 f1 ff ff       	call   8021f1 <get_block_size>
  803019:	83 c4 10             	add    $0x10,%esp
  80301c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  80301f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803022:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803025:	75 08                	jne    80302f <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  803027:	8b 45 08             	mov    0x8(%ebp),%eax
  80302a:	e9 15 04 00 00       	jmp    803444 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  80302f:	8b 55 08             	mov    0x8(%ebp),%edx
  803032:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803035:	01 d0                	add    %edx,%eax
  803037:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  80303a:	83 ec 0c             	sub    $0xc,%esp
  80303d:	ff 75 f0             	pushl  -0x10(%ebp)
  803040:	e8 c5 f1 ff ff       	call   80220a <is_free_block>
  803045:	83 c4 10             	add    $0x10,%esp
  803048:	0f be c0             	movsbl %al,%eax
  80304b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  80304e:	83 ec 0c             	sub    $0xc,%esp
  803051:	ff 75 f0             	pushl  -0x10(%ebp)
  803054:	e8 98 f1 ff ff       	call   8021f1 <get_block_size>
  803059:	83 c4 10             	add    $0x10,%esp
  80305c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  80305f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803062:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803065:	0f 86 a7 02 00 00    	jbe    803312 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  80306b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80306f:	0f 84 86 02 00 00    	je     8032fb <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  803075:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307b:	01 d0                	add    %edx,%eax
  80307d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803080:	0f 85 b2 00 00 00    	jne    803138 <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  803086:	83 ec 0c             	sub    $0xc,%esp
  803089:	ff 75 08             	pushl  0x8(%ebp)
  80308c:	e8 79 f1 ff ff       	call   80220a <is_free_block>
  803091:	83 c4 10             	add    $0x10,%esp
  803094:	84 c0                	test   %al,%al
  803096:	0f 94 c0             	sete   %al
  803099:	0f b6 c0             	movzbl %al,%eax
  80309c:	83 ec 04             	sub    $0x4,%esp
  80309f:	50                   	push   %eax
  8030a0:	ff 75 0c             	pushl  0xc(%ebp)
  8030a3:	ff 75 08             	pushl  0x8(%ebp)
  8030a6:	e8 c2 f3 ff ff       	call   80246d <set_block_data>
  8030ab:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  8030ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030b2:	75 17                	jne    8030cb <realloc_block_FF+0x12e>
  8030b4:	83 ec 04             	sub    $0x4,%esp
  8030b7:	68 a0 40 80 00       	push   $0x8040a0
  8030bc:	68 db 01 00 00       	push   $0x1db
  8030c1:	68 f7 3f 80 00       	push   $0x803ff7
  8030c6:	e8 67 d3 ff ff       	call   800432 <_panic>
  8030cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ce:	8b 00                	mov    (%eax),%eax
  8030d0:	85 c0                	test   %eax,%eax
  8030d2:	74 10                	je     8030e4 <realloc_block_FF+0x147>
  8030d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d7:	8b 00                	mov    (%eax),%eax
  8030d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030dc:	8b 52 04             	mov    0x4(%edx),%edx
  8030df:	89 50 04             	mov    %edx,0x4(%eax)
  8030e2:	eb 0b                	jmp    8030ef <realloc_block_FF+0x152>
  8030e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e7:	8b 40 04             	mov    0x4(%eax),%eax
  8030ea:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8030ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f2:	8b 40 04             	mov    0x4(%eax),%eax
  8030f5:	85 c0                	test   %eax,%eax
  8030f7:	74 0f                	je     803108 <realloc_block_FF+0x16b>
  8030f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fc:	8b 40 04             	mov    0x4(%eax),%eax
  8030ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803102:	8b 12                	mov    (%edx),%edx
  803104:	89 10                	mov    %edx,(%eax)
  803106:	eb 0a                	jmp    803112 <realloc_block_FF+0x175>
  803108:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310b:	8b 00                	mov    (%eax),%eax
  80310d:	a3 48 50 98 00       	mov    %eax,0x985048
  803112:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803115:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80311b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803125:	a1 54 50 98 00       	mov    0x985054,%eax
  80312a:	48                   	dec    %eax
  80312b:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  803130:	8b 45 08             	mov    0x8(%ebp),%eax
  803133:	e9 0c 03 00 00       	jmp    803444 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  803138:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80313b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313e:	01 d0                	add    %edx,%eax
  803140:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803143:	0f 86 b2 01 00 00    	jbe    8032fb <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  803149:	8b 45 0c             	mov    0xc(%ebp),%eax
  80314c:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80314f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  803152:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803155:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803158:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  80315b:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  80315f:	0f 87 b8 00 00 00    	ja     80321d <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  803165:	83 ec 0c             	sub    $0xc,%esp
  803168:	ff 75 08             	pushl  0x8(%ebp)
  80316b:	e8 9a f0 ff ff       	call   80220a <is_free_block>
  803170:	83 c4 10             	add    $0x10,%esp
  803173:	84 c0                	test   %al,%al
  803175:	0f 94 c0             	sete   %al
  803178:	0f b6 c0             	movzbl %al,%eax
  80317b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80317e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803181:	01 ca                	add    %ecx,%edx
  803183:	83 ec 04             	sub    $0x4,%esp
  803186:	50                   	push   %eax
  803187:	52                   	push   %edx
  803188:	ff 75 08             	pushl  0x8(%ebp)
  80318b:	e8 dd f2 ff ff       	call   80246d <set_block_data>
  803190:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803193:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803197:	75 17                	jne    8031b0 <realloc_block_FF+0x213>
  803199:	83 ec 04             	sub    $0x4,%esp
  80319c:	68 a0 40 80 00       	push   $0x8040a0
  8031a1:	68 e8 01 00 00       	push   $0x1e8
  8031a6:	68 f7 3f 80 00       	push   $0x803ff7
  8031ab:	e8 82 d2 ff ff       	call   800432 <_panic>
  8031b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b3:	8b 00                	mov    (%eax),%eax
  8031b5:	85 c0                	test   %eax,%eax
  8031b7:	74 10                	je     8031c9 <realloc_block_FF+0x22c>
  8031b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031bc:	8b 00                	mov    (%eax),%eax
  8031be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031c1:	8b 52 04             	mov    0x4(%edx),%edx
  8031c4:	89 50 04             	mov    %edx,0x4(%eax)
  8031c7:	eb 0b                	jmp    8031d4 <realloc_block_FF+0x237>
  8031c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031cc:	8b 40 04             	mov    0x4(%eax),%eax
  8031cf:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8031d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d7:	8b 40 04             	mov    0x4(%eax),%eax
  8031da:	85 c0                	test   %eax,%eax
  8031dc:	74 0f                	je     8031ed <realloc_block_FF+0x250>
  8031de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e1:	8b 40 04             	mov    0x4(%eax),%eax
  8031e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031e7:	8b 12                	mov    (%edx),%edx
  8031e9:	89 10                	mov    %edx,(%eax)
  8031eb:	eb 0a                	jmp    8031f7 <realloc_block_FF+0x25a>
  8031ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f0:	8b 00                	mov    (%eax),%eax
  8031f2:	a3 48 50 98 00       	mov    %eax,0x985048
  8031f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803200:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803203:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80320a:	a1 54 50 98 00       	mov    0x985054,%eax
  80320f:	48                   	dec    %eax
  803210:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  803215:	8b 45 08             	mov    0x8(%ebp),%eax
  803218:	e9 27 02 00 00       	jmp    803444 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  80321d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803221:	75 17                	jne    80323a <realloc_block_FF+0x29d>
  803223:	83 ec 04             	sub    $0x4,%esp
  803226:	68 a0 40 80 00       	push   $0x8040a0
  80322b:	68 ed 01 00 00       	push   $0x1ed
  803230:	68 f7 3f 80 00       	push   $0x803ff7
  803235:	e8 f8 d1 ff ff       	call   800432 <_panic>
  80323a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323d:	8b 00                	mov    (%eax),%eax
  80323f:	85 c0                	test   %eax,%eax
  803241:	74 10                	je     803253 <realloc_block_FF+0x2b6>
  803243:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803246:	8b 00                	mov    (%eax),%eax
  803248:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80324b:	8b 52 04             	mov    0x4(%edx),%edx
  80324e:	89 50 04             	mov    %edx,0x4(%eax)
  803251:	eb 0b                	jmp    80325e <realloc_block_FF+0x2c1>
  803253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803256:	8b 40 04             	mov    0x4(%eax),%eax
  803259:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80325e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803261:	8b 40 04             	mov    0x4(%eax),%eax
  803264:	85 c0                	test   %eax,%eax
  803266:	74 0f                	je     803277 <realloc_block_FF+0x2da>
  803268:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326b:	8b 40 04             	mov    0x4(%eax),%eax
  80326e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803271:	8b 12                	mov    (%edx),%edx
  803273:	89 10                	mov    %edx,(%eax)
  803275:	eb 0a                	jmp    803281 <realloc_block_FF+0x2e4>
  803277:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327a:	8b 00                	mov    (%eax),%eax
  80327c:	a3 48 50 98 00       	mov    %eax,0x985048
  803281:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803284:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80328a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80328d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803294:	a1 54 50 98 00       	mov    0x985054,%eax
  803299:	48                   	dec    %eax
  80329a:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  80329f:	8b 55 08             	mov    0x8(%ebp),%edx
  8032a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032a5:	01 d0                	add    %edx,%eax
  8032a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  8032aa:	83 ec 04             	sub    $0x4,%esp
  8032ad:	6a 00                	push   $0x0
  8032af:	ff 75 e0             	pushl  -0x20(%ebp)
  8032b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8032b5:	e8 b3 f1 ff ff       	call   80246d <set_block_data>
  8032ba:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  8032bd:	83 ec 0c             	sub    $0xc,%esp
  8032c0:	ff 75 08             	pushl  0x8(%ebp)
  8032c3:	e8 42 ef ff ff       	call   80220a <is_free_block>
  8032c8:	83 c4 10             	add    $0x10,%esp
  8032cb:	84 c0                	test   %al,%al
  8032cd:	0f 94 c0             	sete   %al
  8032d0:	0f b6 c0             	movzbl %al,%eax
  8032d3:	83 ec 04             	sub    $0x4,%esp
  8032d6:	50                   	push   %eax
  8032d7:	ff 75 0c             	pushl  0xc(%ebp)
  8032da:	ff 75 08             	pushl  0x8(%ebp)
  8032dd:	e8 8b f1 ff ff       	call   80246d <set_block_data>
  8032e2:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  8032e5:	83 ec 0c             	sub    $0xc,%esp
  8032e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8032eb:	e8 d4 f1 ff ff       	call   8024c4 <insert_sorted_in_freeList>
  8032f0:	83 c4 10             	add    $0x10,%esp
					return va;
  8032f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f6:	e9 49 01 00 00       	jmp    803444 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  8032fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032fe:	83 e8 08             	sub    $0x8,%eax
  803301:	83 ec 0c             	sub    $0xc,%esp
  803304:	50                   	push   %eax
  803305:	e8 4d f3 ff ff       	call   802657 <alloc_block_FF>
  80330a:	83 c4 10             	add    $0x10,%esp
  80330d:	e9 32 01 00 00       	jmp    803444 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  803312:	8b 45 0c             	mov    0xc(%ebp),%eax
  803315:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803318:	0f 83 21 01 00 00    	jae    80343f <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  80331e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803321:	2b 45 0c             	sub    0xc(%ebp),%eax
  803324:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  803327:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  80332b:	77 0e                	ja     80333b <realloc_block_FF+0x39e>
  80332d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803331:	75 08                	jne    80333b <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  803333:	8b 45 08             	mov    0x8(%ebp),%eax
  803336:	e9 09 01 00 00       	jmp    803444 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  80333b:	8b 45 08             	mov    0x8(%ebp),%eax
  80333e:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  803341:	83 ec 0c             	sub    $0xc,%esp
  803344:	ff 75 08             	pushl  0x8(%ebp)
  803347:	e8 be ee ff ff       	call   80220a <is_free_block>
  80334c:	83 c4 10             	add    $0x10,%esp
  80334f:	84 c0                	test   %al,%al
  803351:	0f 94 c0             	sete   %al
  803354:	0f b6 c0             	movzbl %al,%eax
  803357:	83 ec 04             	sub    $0x4,%esp
  80335a:	50                   	push   %eax
  80335b:	ff 75 0c             	pushl  0xc(%ebp)
  80335e:	ff 75 d8             	pushl  -0x28(%ebp)
  803361:	e8 07 f1 ff ff       	call   80246d <set_block_data>
  803366:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  803369:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80336c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80336f:	01 d0                	add    %edx,%eax
  803371:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  803374:	83 ec 04             	sub    $0x4,%esp
  803377:	6a 00                	push   $0x0
  803379:	ff 75 dc             	pushl  -0x24(%ebp)
  80337c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80337f:	e8 e9 f0 ff ff       	call   80246d <set_block_data>
  803384:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  803387:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80338b:	0f 84 9b 00 00 00    	je     80342c <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  803391:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803394:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803397:	01 d0                	add    %edx,%eax
  803399:	83 ec 04             	sub    $0x4,%esp
  80339c:	6a 00                	push   $0x0
  80339e:	50                   	push   %eax
  80339f:	ff 75 d4             	pushl  -0x2c(%ebp)
  8033a2:	e8 c6 f0 ff ff       	call   80246d <set_block_data>
  8033a7:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  8033aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033ae:	75 17                	jne    8033c7 <realloc_block_FF+0x42a>
  8033b0:	83 ec 04             	sub    $0x4,%esp
  8033b3:	68 a0 40 80 00       	push   $0x8040a0
  8033b8:	68 10 02 00 00       	push   $0x210
  8033bd:	68 f7 3f 80 00       	push   $0x803ff7
  8033c2:	e8 6b d0 ff ff       	call   800432 <_panic>
  8033c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ca:	8b 00                	mov    (%eax),%eax
  8033cc:	85 c0                	test   %eax,%eax
  8033ce:	74 10                	je     8033e0 <realloc_block_FF+0x443>
  8033d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d3:	8b 00                	mov    (%eax),%eax
  8033d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033d8:	8b 52 04             	mov    0x4(%edx),%edx
  8033db:	89 50 04             	mov    %edx,0x4(%eax)
  8033de:	eb 0b                	jmp    8033eb <realloc_block_FF+0x44e>
  8033e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e3:	8b 40 04             	mov    0x4(%eax),%eax
  8033e6:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8033eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ee:	8b 40 04             	mov    0x4(%eax),%eax
  8033f1:	85 c0                	test   %eax,%eax
  8033f3:	74 0f                	je     803404 <realloc_block_FF+0x467>
  8033f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f8:	8b 40 04             	mov    0x4(%eax),%eax
  8033fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033fe:	8b 12                	mov    (%edx),%edx
  803400:	89 10                	mov    %edx,(%eax)
  803402:	eb 0a                	jmp    80340e <realloc_block_FF+0x471>
  803404:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803407:	8b 00                	mov    (%eax),%eax
  803409:	a3 48 50 98 00       	mov    %eax,0x985048
  80340e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803411:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803417:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80341a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803421:	a1 54 50 98 00       	mov    0x985054,%eax
  803426:	48                   	dec    %eax
  803427:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  80342c:	83 ec 0c             	sub    $0xc,%esp
  80342f:	ff 75 d4             	pushl  -0x2c(%ebp)
  803432:	e8 8d f0 ff ff       	call   8024c4 <insert_sorted_in_freeList>
  803437:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  80343a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80343d:	eb 05                	jmp    803444 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  80343f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803444:	c9                   	leave  
  803445:	c3                   	ret    

00803446 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803446:	55                   	push   %ebp
  803447:	89 e5                	mov    %esp,%ebp
  803449:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80344c:	83 ec 04             	sub    $0x4,%esp
  80344f:	68 c0 40 80 00       	push   $0x8040c0
  803454:	68 20 02 00 00       	push   $0x220
  803459:	68 f7 3f 80 00       	push   $0x803ff7
  80345e:	e8 cf cf ff ff       	call   800432 <_panic>

00803463 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803463:	55                   	push   %ebp
  803464:	89 e5                	mov    %esp,%ebp
  803466:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803469:	83 ec 04             	sub    $0x4,%esp
  80346c:	68 e8 40 80 00       	push   $0x8040e8
  803471:	68 28 02 00 00       	push   $0x228
  803476:	68 f7 3f 80 00       	push   $0x803ff7
  80347b:	e8 b2 cf ff ff       	call   800432 <_panic>

00803480 <__udivdi3>:
  803480:	55                   	push   %ebp
  803481:	57                   	push   %edi
  803482:	56                   	push   %esi
  803483:	53                   	push   %ebx
  803484:	83 ec 1c             	sub    $0x1c,%esp
  803487:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80348b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80348f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803493:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803497:	89 ca                	mov    %ecx,%edx
  803499:	89 f8                	mov    %edi,%eax
  80349b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80349f:	85 f6                	test   %esi,%esi
  8034a1:	75 2d                	jne    8034d0 <__udivdi3+0x50>
  8034a3:	39 cf                	cmp    %ecx,%edi
  8034a5:	77 65                	ja     80350c <__udivdi3+0x8c>
  8034a7:	89 fd                	mov    %edi,%ebp
  8034a9:	85 ff                	test   %edi,%edi
  8034ab:	75 0b                	jne    8034b8 <__udivdi3+0x38>
  8034ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8034b2:	31 d2                	xor    %edx,%edx
  8034b4:	f7 f7                	div    %edi
  8034b6:	89 c5                	mov    %eax,%ebp
  8034b8:	31 d2                	xor    %edx,%edx
  8034ba:	89 c8                	mov    %ecx,%eax
  8034bc:	f7 f5                	div    %ebp
  8034be:	89 c1                	mov    %eax,%ecx
  8034c0:	89 d8                	mov    %ebx,%eax
  8034c2:	f7 f5                	div    %ebp
  8034c4:	89 cf                	mov    %ecx,%edi
  8034c6:	89 fa                	mov    %edi,%edx
  8034c8:	83 c4 1c             	add    $0x1c,%esp
  8034cb:	5b                   	pop    %ebx
  8034cc:	5e                   	pop    %esi
  8034cd:	5f                   	pop    %edi
  8034ce:	5d                   	pop    %ebp
  8034cf:	c3                   	ret    
  8034d0:	39 ce                	cmp    %ecx,%esi
  8034d2:	77 28                	ja     8034fc <__udivdi3+0x7c>
  8034d4:	0f bd fe             	bsr    %esi,%edi
  8034d7:	83 f7 1f             	xor    $0x1f,%edi
  8034da:	75 40                	jne    80351c <__udivdi3+0x9c>
  8034dc:	39 ce                	cmp    %ecx,%esi
  8034de:	72 0a                	jb     8034ea <__udivdi3+0x6a>
  8034e0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034e4:	0f 87 9e 00 00 00    	ja     803588 <__udivdi3+0x108>
  8034ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8034ef:	89 fa                	mov    %edi,%edx
  8034f1:	83 c4 1c             	add    $0x1c,%esp
  8034f4:	5b                   	pop    %ebx
  8034f5:	5e                   	pop    %esi
  8034f6:	5f                   	pop    %edi
  8034f7:	5d                   	pop    %ebp
  8034f8:	c3                   	ret    
  8034f9:	8d 76 00             	lea    0x0(%esi),%esi
  8034fc:	31 ff                	xor    %edi,%edi
  8034fe:	31 c0                	xor    %eax,%eax
  803500:	89 fa                	mov    %edi,%edx
  803502:	83 c4 1c             	add    $0x1c,%esp
  803505:	5b                   	pop    %ebx
  803506:	5e                   	pop    %esi
  803507:	5f                   	pop    %edi
  803508:	5d                   	pop    %ebp
  803509:	c3                   	ret    
  80350a:	66 90                	xchg   %ax,%ax
  80350c:	89 d8                	mov    %ebx,%eax
  80350e:	f7 f7                	div    %edi
  803510:	31 ff                	xor    %edi,%edi
  803512:	89 fa                	mov    %edi,%edx
  803514:	83 c4 1c             	add    $0x1c,%esp
  803517:	5b                   	pop    %ebx
  803518:	5e                   	pop    %esi
  803519:	5f                   	pop    %edi
  80351a:	5d                   	pop    %ebp
  80351b:	c3                   	ret    
  80351c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803521:	89 eb                	mov    %ebp,%ebx
  803523:	29 fb                	sub    %edi,%ebx
  803525:	89 f9                	mov    %edi,%ecx
  803527:	d3 e6                	shl    %cl,%esi
  803529:	89 c5                	mov    %eax,%ebp
  80352b:	88 d9                	mov    %bl,%cl
  80352d:	d3 ed                	shr    %cl,%ebp
  80352f:	89 e9                	mov    %ebp,%ecx
  803531:	09 f1                	or     %esi,%ecx
  803533:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803537:	89 f9                	mov    %edi,%ecx
  803539:	d3 e0                	shl    %cl,%eax
  80353b:	89 c5                	mov    %eax,%ebp
  80353d:	89 d6                	mov    %edx,%esi
  80353f:	88 d9                	mov    %bl,%cl
  803541:	d3 ee                	shr    %cl,%esi
  803543:	89 f9                	mov    %edi,%ecx
  803545:	d3 e2                	shl    %cl,%edx
  803547:	8b 44 24 08          	mov    0x8(%esp),%eax
  80354b:	88 d9                	mov    %bl,%cl
  80354d:	d3 e8                	shr    %cl,%eax
  80354f:	09 c2                	or     %eax,%edx
  803551:	89 d0                	mov    %edx,%eax
  803553:	89 f2                	mov    %esi,%edx
  803555:	f7 74 24 0c          	divl   0xc(%esp)
  803559:	89 d6                	mov    %edx,%esi
  80355b:	89 c3                	mov    %eax,%ebx
  80355d:	f7 e5                	mul    %ebp
  80355f:	39 d6                	cmp    %edx,%esi
  803561:	72 19                	jb     80357c <__udivdi3+0xfc>
  803563:	74 0b                	je     803570 <__udivdi3+0xf0>
  803565:	89 d8                	mov    %ebx,%eax
  803567:	31 ff                	xor    %edi,%edi
  803569:	e9 58 ff ff ff       	jmp    8034c6 <__udivdi3+0x46>
  80356e:	66 90                	xchg   %ax,%ax
  803570:	8b 54 24 08          	mov    0x8(%esp),%edx
  803574:	89 f9                	mov    %edi,%ecx
  803576:	d3 e2                	shl    %cl,%edx
  803578:	39 c2                	cmp    %eax,%edx
  80357a:	73 e9                	jae    803565 <__udivdi3+0xe5>
  80357c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80357f:	31 ff                	xor    %edi,%edi
  803581:	e9 40 ff ff ff       	jmp    8034c6 <__udivdi3+0x46>
  803586:	66 90                	xchg   %ax,%ax
  803588:	31 c0                	xor    %eax,%eax
  80358a:	e9 37 ff ff ff       	jmp    8034c6 <__udivdi3+0x46>
  80358f:	90                   	nop

00803590 <__umoddi3>:
  803590:	55                   	push   %ebp
  803591:	57                   	push   %edi
  803592:	56                   	push   %esi
  803593:	53                   	push   %ebx
  803594:	83 ec 1c             	sub    $0x1c,%esp
  803597:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80359b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80359f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035a3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035af:	89 f3                	mov    %esi,%ebx
  8035b1:	89 fa                	mov    %edi,%edx
  8035b3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035b7:	89 34 24             	mov    %esi,(%esp)
  8035ba:	85 c0                	test   %eax,%eax
  8035bc:	75 1a                	jne    8035d8 <__umoddi3+0x48>
  8035be:	39 f7                	cmp    %esi,%edi
  8035c0:	0f 86 a2 00 00 00    	jbe    803668 <__umoddi3+0xd8>
  8035c6:	89 c8                	mov    %ecx,%eax
  8035c8:	89 f2                	mov    %esi,%edx
  8035ca:	f7 f7                	div    %edi
  8035cc:	89 d0                	mov    %edx,%eax
  8035ce:	31 d2                	xor    %edx,%edx
  8035d0:	83 c4 1c             	add    $0x1c,%esp
  8035d3:	5b                   	pop    %ebx
  8035d4:	5e                   	pop    %esi
  8035d5:	5f                   	pop    %edi
  8035d6:	5d                   	pop    %ebp
  8035d7:	c3                   	ret    
  8035d8:	39 f0                	cmp    %esi,%eax
  8035da:	0f 87 ac 00 00 00    	ja     80368c <__umoddi3+0xfc>
  8035e0:	0f bd e8             	bsr    %eax,%ebp
  8035e3:	83 f5 1f             	xor    $0x1f,%ebp
  8035e6:	0f 84 ac 00 00 00    	je     803698 <__umoddi3+0x108>
  8035ec:	bf 20 00 00 00       	mov    $0x20,%edi
  8035f1:	29 ef                	sub    %ebp,%edi
  8035f3:	89 fe                	mov    %edi,%esi
  8035f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035f9:	89 e9                	mov    %ebp,%ecx
  8035fb:	d3 e0                	shl    %cl,%eax
  8035fd:	89 d7                	mov    %edx,%edi
  8035ff:	89 f1                	mov    %esi,%ecx
  803601:	d3 ef                	shr    %cl,%edi
  803603:	09 c7                	or     %eax,%edi
  803605:	89 e9                	mov    %ebp,%ecx
  803607:	d3 e2                	shl    %cl,%edx
  803609:	89 14 24             	mov    %edx,(%esp)
  80360c:	89 d8                	mov    %ebx,%eax
  80360e:	d3 e0                	shl    %cl,%eax
  803610:	89 c2                	mov    %eax,%edx
  803612:	8b 44 24 08          	mov    0x8(%esp),%eax
  803616:	d3 e0                	shl    %cl,%eax
  803618:	89 44 24 04          	mov    %eax,0x4(%esp)
  80361c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803620:	89 f1                	mov    %esi,%ecx
  803622:	d3 e8                	shr    %cl,%eax
  803624:	09 d0                	or     %edx,%eax
  803626:	d3 eb                	shr    %cl,%ebx
  803628:	89 da                	mov    %ebx,%edx
  80362a:	f7 f7                	div    %edi
  80362c:	89 d3                	mov    %edx,%ebx
  80362e:	f7 24 24             	mull   (%esp)
  803631:	89 c6                	mov    %eax,%esi
  803633:	89 d1                	mov    %edx,%ecx
  803635:	39 d3                	cmp    %edx,%ebx
  803637:	0f 82 87 00 00 00    	jb     8036c4 <__umoddi3+0x134>
  80363d:	0f 84 91 00 00 00    	je     8036d4 <__umoddi3+0x144>
  803643:	8b 54 24 04          	mov    0x4(%esp),%edx
  803647:	29 f2                	sub    %esi,%edx
  803649:	19 cb                	sbb    %ecx,%ebx
  80364b:	89 d8                	mov    %ebx,%eax
  80364d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803651:	d3 e0                	shl    %cl,%eax
  803653:	89 e9                	mov    %ebp,%ecx
  803655:	d3 ea                	shr    %cl,%edx
  803657:	09 d0                	or     %edx,%eax
  803659:	89 e9                	mov    %ebp,%ecx
  80365b:	d3 eb                	shr    %cl,%ebx
  80365d:	89 da                	mov    %ebx,%edx
  80365f:	83 c4 1c             	add    $0x1c,%esp
  803662:	5b                   	pop    %ebx
  803663:	5e                   	pop    %esi
  803664:	5f                   	pop    %edi
  803665:	5d                   	pop    %ebp
  803666:	c3                   	ret    
  803667:	90                   	nop
  803668:	89 fd                	mov    %edi,%ebp
  80366a:	85 ff                	test   %edi,%edi
  80366c:	75 0b                	jne    803679 <__umoddi3+0xe9>
  80366e:	b8 01 00 00 00       	mov    $0x1,%eax
  803673:	31 d2                	xor    %edx,%edx
  803675:	f7 f7                	div    %edi
  803677:	89 c5                	mov    %eax,%ebp
  803679:	89 f0                	mov    %esi,%eax
  80367b:	31 d2                	xor    %edx,%edx
  80367d:	f7 f5                	div    %ebp
  80367f:	89 c8                	mov    %ecx,%eax
  803681:	f7 f5                	div    %ebp
  803683:	89 d0                	mov    %edx,%eax
  803685:	e9 44 ff ff ff       	jmp    8035ce <__umoddi3+0x3e>
  80368a:	66 90                	xchg   %ax,%ax
  80368c:	89 c8                	mov    %ecx,%eax
  80368e:	89 f2                	mov    %esi,%edx
  803690:	83 c4 1c             	add    $0x1c,%esp
  803693:	5b                   	pop    %ebx
  803694:	5e                   	pop    %esi
  803695:	5f                   	pop    %edi
  803696:	5d                   	pop    %ebp
  803697:	c3                   	ret    
  803698:	3b 04 24             	cmp    (%esp),%eax
  80369b:	72 06                	jb     8036a3 <__umoddi3+0x113>
  80369d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036a1:	77 0f                	ja     8036b2 <__umoddi3+0x122>
  8036a3:	89 f2                	mov    %esi,%edx
  8036a5:	29 f9                	sub    %edi,%ecx
  8036a7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036ab:	89 14 24             	mov    %edx,(%esp)
  8036ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036b2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036b6:	8b 14 24             	mov    (%esp),%edx
  8036b9:	83 c4 1c             	add    $0x1c,%esp
  8036bc:	5b                   	pop    %ebx
  8036bd:	5e                   	pop    %esi
  8036be:	5f                   	pop    %edi
  8036bf:	5d                   	pop    %ebp
  8036c0:	c3                   	ret    
  8036c1:	8d 76 00             	lea    0x0(%esi),%esi
  8036c4:	2b 04 24             	sub    (%esp),%eax
  8036c7:	19 fa                	sbb    %edi,%edx
  8036c9:	89 d1                	mov    %edx,%ecx
  8036cb:	89 c6                	mov    %eax,%esi
  8036cd:	e9 71 ff ff ff       	jmp    803643 <__umoddi3+0xb3>
  8036d2:	66 90                	xchg   %ax,%ax
  8036d4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036d8:	72 ea                	jb     8036c4 <__umoddi3+0x134>
  8036da:	89 d9                	mov    %ebx,%ecx
  8036dc:	e9 62 ff ff ff       	jmp    803643 <__umoddi3+0xb3>
