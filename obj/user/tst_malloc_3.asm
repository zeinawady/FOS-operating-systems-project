
obj/user/tst_malloc_3:     file format elf32-i386


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
  800031:	e8 0b 0e 00 00       	call   800e41 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	short b;
	int c;
};

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 20 01 00 00    	sub    $0x120,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800043:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004e:	eb 29                	jmp    800079 <_main+0x41>
		{
			if (myEnv->__uptr_pws[i].empty)
  800050:	a1 20 50 80 00       	mov    0x805020,%eax
  800055:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80005b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005e:	89 d0                	mov    %edx,%eax
  800060:	01 c0                	add    %eax,%eax
  800062:	01 d0                	add    %edx,%eax
  800064:	c1 e0 03             	shl    $0x3,%eax
  800067:	01 c8                	add    %ecx,%eax
  800069:	8a 40 04             	mov    0x4(%eax),%al
  80006c:	84 c0                	test   %al,%al
  80006e:	74 06                	je     800076 <_main+0x3e>
			{
				fullWS = 0;
  800070:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800074:	eb 15                	jmp    80008b <_main+0x53>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800076:	ff 45 f0             	incl   -0x10(%ebp)
  800079:	a1 20 50 80 00       	mov    0x805020,%eax
  80007e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800084:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800087:	39 c2                	cmp    %eax,%edx
  800089:	77 c5                	ja     800050 <_main+0x18>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80008b:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008f:	74 14                	je     8000a5 <_main+0x6d>
  800091:	83 ec 04             	sub    $0x4,%esp
  800094:	68 40 42 80 00       	push   $0x804240
  800099:	6a 1a                	push   $0x1a
  80009b:	68 5c 42 80 00       	push   $0x80425c
  8000a0:	e8 e1 0e 00 00       	call   800f86 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a5:	83 ec 0c             	sub    $0xc,%esp
  8000a8:	6a 00                	push   $0x0
  8000aa:	e8 44 1f 00 00       	call   801ff3 <malloc>
  8000af:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  8000b2:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  8000b9:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)
	char minByte = 1<<7;
  8000c0:	c6 45 df 80          	movb   $0x80,-0x21(%ebp)
	char maxByte = 0x7F;
  8000c4:	c6 45 de 7f          	movb   $0x7f,-0x22(%ebp)
	short minShort = 1<<15 ;
  8000c8:	66 c7 45 dc 00 80    	movw   $0x8000,-0x24(%ebp)
	short maxShort = 0x7FFF;
  8000ce:	66 c7 45 da ff 7f    	movw   $0x7fff,-0x26(%ebp)
	int minInt = 1<<31 ;
  8000d4:	c7 45 d4 00 00 00 80 	movl   $0x80000000,-0x2c(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000db:	c7 45 d0 ff ff ff 7f 	movl   $0x7fffffff,-0x30(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	int start_freeFrames = sys_calculate_free_frames() ;
  8000e2:	e8 e1 26 00 00       	call   8027c8 <sys_calculate_free_frames>
  8000e7:	89 45 cc             	mov    %eax,-0x34(%ebp)

	void* ptr_allocations[20] = {0};
  8000ea:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  8000f0:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fa:	89 d7                	mov    %edx,%edi
  8000fc:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//2 MB
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fe:	e8 10 27 00 00       	call   802813 <sys_pf_calculate_allocated_pages>
  800103:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800109:	01 c0                	add    %eax,%eax
  80010b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	50                   	push   %eax
  800112:	e8 dc 1e 00 00       	call   801ff3 <malloc>
  800117:	83 c4 10             	add    $0x10,%esp
  80011a:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800120:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800126:	85 c0                	test   %eax,%eax
  800128:	79 0d                	jns    800137 <_main+0xff>
  80012a:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800130:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800135:	76 14                	jbe    80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 70 42 80 00       	push   $0x804270
  80013f:	6a 39                	push   $0x39
  800141:	68 5c 42 80 00       	push   $0x80425c
  800146:	e8 3b 0e 00 00       	call   800f86 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80014b:	e8 c3 26 00 00       	call   802813 <sys_pf_calculate_allocated_pages>
  800150:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 d8 42 80 00       	push   $0x8042d8
  80015d:	6a 3a                	push   $0x3a
  80015f:	68 5c 42 80 00       	push   $0x80425c
  800164:	e8 1d 0e 00 00       	call   800f86 <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800169:	e8 5a 26 00 00       	call   8027c8 <sys_calculate_free_frames>
  80016e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  800171:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800174:	01 c0                	add    %eax,%eax
  800176:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800179:	48                   	dec    %eax
  80017a:	89 45 c0             	mov    %eax,-0x40(%ebp)
		byteArr = (char *) ptr_allocations[0];
  80017d:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800183:	89 45 bc             	mov    %eax,-0x44(%ebp)
		byteArr[0] = minByte ;
  800186:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800189:	8a 55 df             	mov    -0x21(%ebp),%dl
  80018c:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80018e:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800191:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800194:	01 c2                	add    %eax,%edx
  800196:	8a 45 de             	mov    -0x22(%ebp),%al
  800199:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  80019b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80019e:	e8 25 26 00 00       	call   8027c8 <sys_calculate_free_frames>
  8001a3:	29 c3                	sub    %eax,%ebx
  8001a5:	89 d8                	mov    %ebx,%eax
  8001a7:	83 f8 03             	cmp    $0x3,%eax
  8001aa:	74 14                	je     8001c0 <_main+0x188>
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	68 08 43 80 00       	push   $0x804308
  8001b4:	6a 41                	push   $0x41
  8001b6:	68 5c 42 80 00       	push   $0x80425c
  8001bb:	e8 c6 0d 00 00       	call   800f86 <_panic>
		int var;
		int found = 0;
  8001c0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8001c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001ce:	e9 82 00 00 00       	jmp    800255 <_main+0x21d>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  8001d3:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d8:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8001de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001e1:	89 d0                	mov    %edx,%eax
  8001e3:	01 c0                	add    %eax,%eax
  8001e5:	01 d0                	add    %edx,%eax
  8001e7:	c1 e0 03             	shl    $0x3,%eax
  8001ea:	01 c8                	add    %ecx,%eax
  8001ec:	8b 00                	mov    (%eax),%eax
  8001ee:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001f1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001f9:	89 c2                	mov    %eax,%edx
  8001fb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001fe:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800201:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800204:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800209:	39 c2                	cmp    %eax,%edx
  80020b:	75 03                	jne    800210 <_main+0x1d8>
				found++;
  80020d:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  800210:	a1 20 50 80 00       	mov    0x805020,%eax
  800215:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80021b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80021e:	89 d0                	mov    %edx,%eax
  800220:	01 c0                	add    %eax,%eax
  800222:	01 d0                	add    %edx,%eax
  800224:	c1 e0 03             	shl    $0x3,%eax
  800227:	01 c8                	add    %ecx,%eax
  800229:	8b 00                	mov    (%eax),%eax
  80022b:	89 45 b0             	mov    %eax,-0x50(%ebp)
  80022e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800231:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800236:	89 c1                	mov    %eax,%ecx
  800238:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80023b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80023e:	01 d0                	add    %edx,%eax
  800240:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800243:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800246:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80024b:	39 c1                	cmp    %eax,%ecx
  80024d:	75 03                	jne    800252 <_main+0x21a>
				found++;
  80024f:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr[0] = minByte ;
		byteArr[lastIndexOfByte] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int var;
		int found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800252:	ff 45 ec             	incl   -0x14(%ebp)
  800255:	a1 20 50 80 00       	mov    0x805020,%eax
  80025a:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800260:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800263:	39 c2                	cmp    %eax,%edx
  800265:	0f 87 68 ff ff ff    	ja     8001d3 <_main+0x19b>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  80026b:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  80026f:	74 14                	je     800285 <_main+0x24d>
  800271:	83 ec 04             	sub    $0x4,%esp
  800274:	68 4c 43 80 00       	push   $0x80434c
  800279:	6a 4b                	push   $0x4b
  80027b:	68 5c 42 80 00       	push   $0x80425c
  800280:	e8 01 0d 00 00       	call   800f86 <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800285:	e8 89 25 00 00       	call   802813 <sys_pf_calculate_allocated_pages>
  80028a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80028d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800290:	01 c0                	add    %eax,%eax
  800292:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	50                   	push   %eax
  800299:	e8 55 1d 00 00       	call   801ff3 <malloc>
  80029e:	83 c4 10             	add    $0x10,%esp
  8002a1:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8002a7:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002ad:	89 c2                	mov    %eax,%edx
  8002af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b2:	01 c0                	add    %eax,%eax
  8002b4:	05 00 00 00 80       	add    $0x80000000,%eax
  8002b9:	39 c2                	cmp    %eax,%edx
  8002bb:	72 16                	jb     8002d3 <_main+0x29b>
  8002bd:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002c3:	89 c2                	mov    %eax,%edx
  8002c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002c8:	01 c0                	add    %eax,%eax
  8002ca:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002cf:	39 c2                	cmp    %eax,%edx
  8002d1:	76 14                	jbe    8002e7 <_main+0x2af>
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	68 70 42 80 00       	push   $0x804270
  8002db:	6a 50                	push   $0x50
  8002dd:	68 5c 42 80 00       	push   $0x80425c
  8002e2:	e8 9f 0c 00 00       	call   800f86 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e7:	e8 27 25 00 00       	call   802813 <sys_pf_calculate_allocated_pages>
  8002ec:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8002ef:	74 14                	je     800305 <_main+0x2cd>
  8002f1:	83 ec 04             	sub    $0x4,%esp
  8002f4:	68 d8 42 80 00       	push   $0x8042d8
  8002f9:	6a 51                	push   $0x51
  8002fb:	68 5c 42 80 00       	push   $0x80425c
  800300:	e8 81 0c 00 00       	call   800f86 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800305:	e8 be 24 00 00       	call   8027c8 <sys_calculate_free_frames>
  80030a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr = (short *) ptr_allocations[1];
  80030d:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  800313:	89 45 a8             	mov    %eax,-0x58(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800316:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800319:	01 c0                	add    %eax,%eax
  80031b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80031e:	d1 e8                	shr    %eax
  800320:	48                   	dec    %eax
  800321:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		shortArr[0] = minShort;
  800324:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800327:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80032a:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  80032d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800330:	01 c0                	add    %eax,%eax
  800332:	89 c2                	mov    %eax,%edx
  800334:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800337:	01 c2                	add    %eax,%edx
  800339:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  80033d:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800340:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800343:	e8 80 24 00 00       	call   8027c8 <sys_calculate_free_frames>
  800348:	29 c3                	sub    %eax,%ebx
  80034a:	89 d8                	mov    %ebx,%eax
  80034c:	83 f8 02             	cmp    $0x2,%eax
  80034f:	74 14                	je     800365 <_main+0x32d>
  800351:	83 ec 04             	sub    $0x4,%esp
  800354:	68 08 43 80 00       	push   $0x804308
  800359:	6a 58                	push   $0x58
  80035b:	68 5c 42 80 00       	push   $0x80425c
  800360:	e8 21 0c 00 00       	call   800f86 <_panic>
		found = 0;
  800365:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80036c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800373:	e9 86 00 00 00       	jmp    8003fe <_main+0x3c6>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800378:	a1 20 50 80 00       	mov    0x805020,%eax
  80037d:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800383:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800386:	89 d0                	mov    %edx,%eax
  800388:	01 c0                	add    %eax,%eax
  80038a:	01 d0                	add    %edx,%eax
  80038c:	c1 e0 03             	shl    $0x3,%eax
  80038f:	01 c8                	add    %ecx,%eax
  800391:	8b 00                	mov    (%eax),%eax
  800393:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800396:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800399:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80039e:	89 c2                	mov    %eax,%edx
  8003a0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003a3:	89 45 9c             	mov    %eax,-0x64(%ebp)
  8003a6:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8003a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ae:	39 c2                	cmp    %eax,%edx
  8003b0:	75 03                	jne    8003b5 <_main+0x37d>
				found++;
  8003b2:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  8003b5:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ba:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8003c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003c3:	89 d0                	mov    %edx,%eax
  8003c5:	01 c0                	add    %eax,%eax
  8003c7:	01 d0                	add    %edx,%eax
  8003c9:	c1 e0 03             	shl    $0x3,%eax
  8003cc:	01 c8                	add    %ecx,%eax
  8003ce:	8b 00                	mov    (%eax),%eax
  8003d0:	89 45 98             	mov    %eax,-0x68(%ebp)
  8003d3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003db:	89 c2                	mov    %eax,%edx
  8003dd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003e0:	01 c0                	add    %eax,%eax
  8003e2:	89 c1                	mov    %eax,%ecx
  8003e4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003e7:	01 c8                	add    %ecx,%eax
  8003e9:	89 45 94             	mov    %eax,-0x6c(%ebp)
  8003ec:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8003ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003f4:	39 c2                	cmp    %eax,%edx
  8003f6:	75 03                	jne    8003fb <_main+0x3c3>
				found++;
  8003f8:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
		shortArr[0] = minShort;
		shortArr[lastIndexOfShort] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8003fb:	ff 45 ec             	incl   -0x14(%ebp)
  8003fe:	a1 20 50 80 00       	mov    0x805020,%eax
  800403:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800409:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	0f 87 64 ff ff ff    	ja     800378 <_main+0x340>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800414:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800418:	74 14                	je     80042e <_main+0x3f6>
  80041a:	83 ec 04             	sub    $0x4,%esp
  80041d:	68 4c 43 80 00       	push   $0x80434c
  800422:	6a 61                	push   $0x61
  800424:	68 5c 42 80 00       	push   $0x80425c
  800429:	e8 58 0b 00 00       	call   800f86 <_panic>

		//3 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042e:	e8 e0 23 00 00       	call   802813 <sys_pf_calculate_allocated_pages>
  800433:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  800436:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800439:	89 c2                	mov    %eax,%edx
  80043b:	01 d2                	add    %edx,%edx
  80043d:	01 d0                	add    %edx,%eax
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	50                   	push   %eax
  800443:	e8 ab 1b 00 00       	call   801ff3 <malloc>
  800448:	83 c4 10             	add    $0x10,%esp
  80044b:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800451:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  800457:	89 c2                	mov    %eax,%edx
  800459:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80045c:	c1 e0 02             	shl    $0x2,%eax
  80045f:	05 00 00 00 80       	add    $0x80000000,%eax
  800464:	39 c2                	cmp    %eax,%edx
  800466:	72 17                	jb     80047f <_main+0x447>
  800468:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  80046e:	89 c2                	mov    %eax,%edx
  800470:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800473:	c1 e0 02             	shl    $0x2,%eax
  800476:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80047b:	39 c2                	cmp    %eax,%edx
  80047d:	76 14                	jbe    800493 <_main+0x45b>
  80047f:	83 ec 04             	sub    $0x4,%esp
  800482:	68 70 42 80 00       	push   $0x804270
  800487:	6a 66                	push   $0x66
  800489:	68 5c 42 80 00       	push   $0x80425c
  80048e:	e8 f3 0a 00 00       	call   800f86 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800493:	e8 7b 23 00 00       	call   802813 <sys_pf_calculate_allocated_pages>
  800498:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80049b:	74 14                	je     8004b1 <_main+0x479>
  80049d:	83 ec 04             	sub    $0x4,%esp
  8004a0:	68 d8 42 80 00       	push   $0x8042d8
  8004a5:	6a 67                	push   $0x67
  8004a7:	68 5c 42 80 00       	push   $0x80425c
  8004ac:	e8 d5 0a 00 00       	call   800f86 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004b1:	e8 12 23 00 00       	call   8027c8 <sys_calculate_free_frames>
  8004b6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		intArr = (int *) ptr_allocations[2];
  8004b9:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  8004bf:	89 45 90             	mov    %eax,-0x70(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8004c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c5:	01 c0                	add    %eax,%eax
  8004c7:	c1 e8 02             	shr    $0x2,%eax
  8004ca:	48                   	dec    %eax
  8004cb:	89 45 8c             	mov    %eax,-0x74(%ebp)
		intArr[0] = minInt;
  8004ce:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004d4:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8004d6:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004e0:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004e3:	01 c2                	add    %eax,%edx
  8004e5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004e8:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8004ea:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8004ed:	e8 d6 22 00 00       	call   8027c8 <sys_calculate_free_frames>
  8004f2:	29 c3                	sub    %eax,%ebx
  8004f4:	89 d8                	mov    %ebx,%eax
  8004f6:	83 f8 02             	cmp    $0x2,%eax
  8004f9:	74 14                	je     80050f <_main+0x4d7>
  8004fb:	83 ec 04             	sub    $0x4,%esp
  8004fe:	68 08 43 80 00       	push   $0x804308
  800503:	6a 6e                	push   $0x6e
  800505:	68 5c 42 80 00       	push   $0x80425c
  80050a:	e8 77 0a 00 00       	call   800f86 <_panic>
		found = 0;
  80050f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800516:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80051d:	e9 8f 00 00 00       	jmp    8005b1 <_main+0x579>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800522:	a1 20 50 80 00       	mov    0x805020,%eax
  800527:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80052d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800530:	89 d0                	mov    %edx,%eax
  800532:	01 c0                	add    %eax,%eax
  800534:	01 d0                	add    %edx,%eax
  800536:	c1 e0 03             	shl    $0x3,%eax
  800539:	01 c8                	add    %ecx,%eax
  80053b:	8b 00                	mov    (%eax),%eax
  80053d:	89 45 88             	mov    %eax,-0x78(%ebp)
  800540:	8b 45 88             	mov    -0x78(%ebp),%eax
  800543:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800548:	89 c2                	mov    %eax,%edx
  80054a:	8b 45 90             	mov    -0x70(%ebp),%eax
  80054d:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800550:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800553:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800558:	39 c2                	cmp    %eax,%edx
  80055a:	75 03                	jne    80055f <_main+0x527>
				found++;
  80055c:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  80055f:	a1 20 50 80 00       	mov    0x805020,%eax
  800564:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80056a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80056d:	89 d0                	mov    %edx,%eax
  80056f:	01 c0                	add    %eax,%eax
  800571:	01 d0                	add    %edx,%eax
  800573:	c1 e0 03             	shl    $0x3,%eax
  800576:	01 c8                	add    %ecx,%eax
  800578:	8b 00                	mov    (%eax),%eax
  80057a:	89 45 80             	mov    %eax,-0x80(%ebp)
  80057d:	8b 45 80             	mov    -0x80(%ebp),%eax
  800580:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800585:	89 c2                	mov    %eax,%edx
  800587:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80058a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800591:	8b 45 90             	mov    -0x70(%ebp),%eax
  800594:	01 c8                	add    %ecx,%eax
  800596:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  80059c:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005a7:	39 c2                	cmp    %eax,%edx
  8005a9:	75 03                	jne    8005ae <_main+0x576>
				found++;
  8005ab:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8005ae:	ff 45 ec             	incl   -0x14(%ebp)
  8005b1:	a1 20 50 80 00       	mov    0x805020,%eax
  8005b6:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8005bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005bf:	39 c2                	cmp    %eax,%edx
  8005c1:	0f 87 5b ff ff ff    	ja     800522 <_main+0x4ea>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8005c7:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8005cb:	74 14                	je     8005e1 <_main+0x5a9>
  8005cd:	83 ec 04             	sub    $0x4,%esp
  8005d0:	68 4c 43 80 00       	push   $0x80434c
  8005d5:	6a 77                	push   $0x77
  8005d7:	68 5c 42 80 00       	push   $0x80425c
  8005dc:	e8 a5 09 00 00       	call   800f86 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8005e1:	e8 e2 21 00 00       	call   8027c8 <sys_calculate_free_frames>
  8005e6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005e9:	e8 25 22 00 00       	call   802813 <sys_pf_calculate_allocated_pages>
  8005ee:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8005f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f4:	89 c2                	mov    %eax,%edx
  8005f6:	01 d2                	add    %edx,%edx
  8005f8:	01 d0                	add    %edx,%eax
  8005fa:	83 ec 0c             	sub    $0xc,%esp
  8005fd:	50                   	push   %eax
  8005fe:	e8 f0 19 00 00       	call   801ff3 <malloc>
  800603:	83 c4 10             	add    $0x10,%esp
  800606:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80060c:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  800612:	89 c2                	mov    %eax,%edx
  800614:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800617:	c1 e0 02             	shl    $0x2,%eax
  80061a:	89 c1                	mov    %eax,%ecx
  80061c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80061f:	c1 e0 02             	shl    $0x2,%eax
  800622:	01 c8                	add    %ecx,%eax
  800624:	05 00 00 00 80       	add    $0x80000000,%eax
  800629:	39 c2                	cmp    %eax,%edx
  80062b:	72 21                	jb     80064e <_main+0x616>
  80062d:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  800633:	89 c2                	mov    %eax,%edx
  800635:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800638:	c1 e0 02             	shl    $0x2,%eax
  80063b:	89 c1                	mov    %eax,%ecx
  80063d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800640:	c1 e0 02             	shl    $0x2,%eax
  800643:	01 c8                	add    %ecx,%eax
  800645:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80064a:	39 c2                	cmp    %eax,%edx
  80064c:	76 14                	jbe    800662 <_main+0x62a>
  80064e:	83 ec 04             	sub    $0x4,%esp
  800651:	68 70 42 80 00       	push   $0x804270
  800656:	6a 7d                	push   $0x7d
  800658:	68 5c 42 80 00       	push   $0x80425c
  80065d:	e8 24 09 00 00       	call   800f86 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800662:	e8 ac 21 00 00       	call   802813 <sys_pf_calculate_allocated_pages>
  800667:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80066a:	74 14                	je     800680 <_main+0x648>
  80066c:	83 ec 04             	sub    $0x4,%esp
  80066f:	68 d8 42 80 00       	push   $0x8042d8
  800674:	6a 7e                	push   $0x7e
  800676:	68 5c 42 80 00       	push   $0x80425c
  80067b:	e8 06 09 00 00       	call   800f86 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800680:	e8 8e 21 00 00       	call   802813 <sys_pf_calculate_allocated_pages>
  800685:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800688:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80068b:	89 d0                	mov    %edx,%eax
  80068d:	01 c0                	add    %eax,%eax
  80068f:	01 d0                	add    %edx,%eax
  800691:	01 c0                	add    %eax,%eax
  800693:	01 d0                	add    %edx,%eax
  800695:	83 ec 0c             	sub    $0xc,%esp
  800698:	50                   	push   %eax
  800699:	e8 55 19 00 00       	call   801ff3 <malloc>
  80069e:	83 c4 10             	add    $0x10,%esp
  8006a1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8006a7:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8006ad:	89 c2                	mov    %eax,%edx
  8006af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006b2:	c1 e0 02             	shl    $0x2,%eax
  8006b5:	89 c1                	mov    %eax,%ecx
  8006b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006ba:	c1 e0 03             	shl    $0x3,%eax
  8006bd:	01 c8                	add    %ecx,%eax
  8006bf:	05 00 00 00 80       	add    $0x80000000,%eax
  8006c4:	39 c2                	cmp    %eax,%edx
  8006c6:	72 21                	jb     8006e9 <_main+0x6b1>
  8006c8:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8006ce:	89 c2                	mov    %eax,%edx
  8006d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006d3:	c1 e0 02             	shl    $0x2,%eax
  8006d6:	89 c1                	mov    %eax,%ecx
  8006d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006db:	c1 e0 03             	shl    $0x3,%eax
  8006de:	01 c8                	add    %ecx,%eax
  8006e0:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8006e5:	39 c2                	cmp    %eax,%edx
  8006e7:	76 17                	jbe    800700 <_main+0x6c8>
  8006e9:	83 ec 04             	sub    $0x4,%esp
  8006ec:	68 70 42 80 00       	push   $0x804270
  8006f1:	68 84 00 00 00       	push   $0x84
  8006f6:	68 5c 42 80 00       	push   $0x80425c
  8006fb:	e8 86 08 00 00       	call   800f86 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800700:	e8 0e 21 00 00       	call   802813 <sys_pf_calculate_allocated_pages>
  800705:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800708:	74 17                	je     800721 <_main+0x6e9>
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 d8 42 80 00       	push   $0x8042d8
  800712:	68 85 00 00 00       	push   $0x85
  800717:	68 5c 42 80 00       	push   $0x80425c
  80071c:	e8 65 08 00 00       	call   800f86 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800721:	e8 a2 20 00 00       	call   8027c8 <sys_calculate_free_frames>
  800726:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		structArr = (struct MyStruct *) ptr_allocations[4];
  800729:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  80072f:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  800735:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800738:	89 d0                	mov    %edx,%eax
  80073a:	01 c0                	add    %eax,%eax
  80073c:	01 d0                	add    %edx,%eax
  80073e:	01 c0                	add    %eax,%eax
  800740:	01 d0                	add    %edx,%eax
  800742:	c1 e8 03             	shr    $0x3,%eax
  800745:	48                   	dec    %eax
  800746:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  80074c:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800752:	8a 55 df             	mov    -0x21(%ebp),%dl
  800755:	88 10                	mov    %dl,(%eax)
  800757:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  80075d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800760:	66 89 42 02          	mov    %ax,0x2(%edx)
  800764:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80076a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80076d:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800770:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800776:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80077d:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800783:	01 c2                	add    %eax,%edx
  800785:	8a 45 de             	mov    -0x22(%ebp),%al
  800788:	88 02                	mov    %al,(%edx)
  80078a:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800790:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800797:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80079d:	01 c2                	add    %eax,%edx
  80079f:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  8007a3:	66 89 42 02          	mov    %ax,0x2(%edx)
  8007a7:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8007ad:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007b4:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8007ba:	01 c2                	add    %eax,%edx
  8007bc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007bf:	89 42 04             	mov    %eax,0x4(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007c2:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8007c5:	e8 fe 1f 00 00       	call   8027c8 <sys_calculate_free_frames>
  8007ca:	29 c3                	sub    %eax,%ebx
  8007cc:	89 d8                	mov    %ebx,%eax
  8007ce:	83 f8 02             	cmp    $0x2,%eax
  8007d1:	74 17                	je     8007ea <_main+0x7b2>
  8007d3:	83 ec 04             	sub    $0x4,%esp
  8007d6:	68 08 43 80 00       	push   $0x804308
  8007db:	68 8c 00 00 00       	push   $0x8c
  8007e0:	68 5c 42 80 00       	push   $0x80425c
  8007e5:	e8 9c 07 00 00       	call   800f86 <_panic>
		found = 0;
  8007ea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8007f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8007f8:	e9 aa 00 00 00       	jmp    8008a7 <_main+0x86f>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  8007fd:	a1 20 50 80 00       	mov    0x805020,%eax
  800802:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800808:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80080b:	89 d0                	mov    %edx,%eax
  80080d:	01 c0                	add    %eax,%eax
  80080f:	01 d0                	add    %edx,%eax
  800811:	c1 e0 03             	shl    $0x3,%eax
  800814:	01 c8                	add    %ecx,%eax
  800816:	8b 00                	mov    (%eax),%eax
  800818:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  80081e:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800824:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800829:	89 c2                	mov    %eax,%edx
  80082b:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800831:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800837:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80083d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800842:	39 c2                	cmp    %eax,%edx
  800844:	75 03                	jne    800849 <_main+0x811>
				found++;
  800846:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  800849:	a1 20 50 80 00       	mov    0x805020,%eax
  80084e:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800854:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800857:	89 d0                	mov    %edx,%eax
  800859:	01 c0                	add    %eax,%eax
  80085b:	01 d0                	add    %edx,%eax
  80085d:	c1 e0 03             	shl    $0x3,%eax
  800860:	01 c8                	add    %ecx,%eax
  800862:	8b 00                	mov    (%eax),%eax
  800864:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  80086a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800870:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800875:	89 c2                	mov    %eax,%edx
  800877:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80087d:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800884:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80088a:	01 c8                	add    %ecx,%eax
  80088c:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  800892:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800898:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80089d:	39 c2                	cmp    %eax,%edx
  80089f:	75 03                	jne    8008a4 <_main+0x86c>
				found++;
  8008a1:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8008a4:	ff 45 ec             	incl   -0x14(%ebp)
  8008a7:	a1 20 50 80 00       	mov    0x805020,%eax
  8008ac:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8008b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b5:	39 c2                	cmp    %eax,%edx
  8008b7:	0f 87 40 ff ff ff    	ja     8007fd <_main+0x7c5>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8008bd:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8008c1:	74 17                	je     8008da <_main+0x8a2>
  8008c3:	83 ec 04             	sub    $0x4,%esp
  8008c6:	68 4c 43 80 00       	push   $0x80434c
  8008cb:	68 95 00 00 00       	push   $0x95
  8008d0:	68 5c 42 80 00       	push   $0x80425c
  8008d5:	e8 ac 06 00 00       	call   800f86 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008da:	e8 e9 1e 00 00       	call   8027c8 <sys_calculate_free_frames>
  8008df:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008e2:	e8 2c 1f 00 00       	call   802813 <sys_pf_calculate_allocated_pages>
  8008e7:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8008ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008ed:	89 c2                	mov    %eax,%edx
  8008ef:	01 d2                	add    %edx,%edx
  8008f1:	01 d0                	add    %edx,%eax
  8008f3:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8008f6:	83 ec 0c             	sub    $0xc,%esp
  8008f9:	50                   	push   %eax
  8008fa:	e8 f4 16 00 00       	call   801ff3 <malloc>
  8008ff:	83 c4 10             	add    $0x10,%esp
  800902:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800908:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80090e:	89 c2                	mov    %eax,%edx
  800910:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800913:	c1 e0 02             	shl    $0x2,%eax
  800916:	89 c1                	mov    %eax,%ecx
  800918:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80091b:	c1 e0 04             	shl    $0x4,%eax
  80091e:	01 c8                	add    %ecx,%eax
  800920:	05 00 00 00 80       	add    $0x80000000,%eax
  800925:	39 c2                	cmp    %eax,%edx
  800927:	72 21                	jb     80094a <_main+0x912>
  800929:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80092f:	89 c2                	mov    %eax,%edx
  800931:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800934:	c1 e0 02             	shl    $0x2,%eax
  800937:	89 c1                	mov    %eax,%ecx
  800939:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80093c:	c1 e0 04             	shl    $0x4,%eax
  80093f:	01 c8                	add    %ecx,%eax
  800941:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800946:	39 c2                	cmp    %eax,%edx
  800948:	76 17                	jbe    800961 <_main+0x929>
  80094a:	83 ec 04             	sub    $0x4,%esp
  80094d:	68 70 42 80 00       	push   $0x804270
  800952:	68 9b 00 00 00       	push   $0x9b
  800957:	68 5c 42 80 00       	push   $0x80425c
  80095c:	e8 25 06 00 00       	call   800f86 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800961:	e8 ad 1e 00 00       	call   802813 <sys_pf_calculate_allocated_pages>
  800966:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800969:	74 17                	je     800982 <_main+0x94a>
  80096b:	83 ec 04             	sub    $0x4,%esp
  80096e:	68 d8 42 80 00       	push   $0x8042d8
  800973:	68 9c 00 00 00       	push   $0x9c
  800978:	68 5c 42 80 00       	push   $0x80425c
  80097d:	e8 04 06 00 00       	call   800f86 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800982:	e8 8c 1e 00 00       	call   802813 <sys_pf_calculate_allocated_pages>
  800987:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  80098a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80098d:	89 d0                	mov    %edx,%eax
  80098f:	01 c0                	add    %eax,%eax
  800991:	01 d0                	add    %edx,%eax
  800993:	01 c0                	add    %eax,%eax
  800995:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800998:	83 ec 0c             	sub    $0xc,%esp
  80099b:	50                   	push   %eax
  80099c:	e8 52 16 00 00       	call   801ff3 <malloc>
  8009a1:	83 c4 10             	add    $0x10,%esp
  8009a4:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8009aa:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009b0:	89 c1                	mov    %eax,%ecx
  8009b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009b5:	89 d0                	mov    %edx,%eax
  8009b7:	01 c0                	add    %eax,%eax
  8009b9:	01 d0                	add    %edx,%eax
  8009bb:	01 c0                	add    %eax,%eax
  8009bd:	01 d0                	add    %edx,%eax
  8009bf:	89 c2                	mov    %eax,%edx
  8009c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c4:	c1 e0 04             	shl    $0x4,%eax
  8009c7:	01 d0                	add    %edx,%eax
  8009c9:	05 00 00 00 80       	add    $0x80000000,%eax
  8009ce:	39 c1                	cmp    %eax,%ecx
  8009d0:	72 28                	jb     8009fa <_main+0x9c2>
  8009d2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009d8:	89 c1                	mov    %eax,%ecx
  8009da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009dd:	89 d0                	mov    %edx,%eax
  8009df:	01 c0                	add    %eax,%eax
  8009e1:	01 d0                	add    %edx,%eax
  8009e3:	01 c0                	add    %eax,%eax
  8009e5:	01 d0                	add    %edx,%eax
  8009e7:	89 c2                	mov    %eax,%edx
  8009e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ec:	c1 e0 04             	shl    $0x4,%eax
  8009ef:	01 d0                	add    %edx,%eax
  8009f1:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8009f6:	39 c1                	cmp    %eax,%ecx
  8009f8:	76 17                	jbe    800a11 <_main+0x9d9>
  8009fa:	83 ec 04             	sub    $0x4,%esp
  8009fd:	68 70 42 80 00       	push   $0x804270
  800a02:	68 a2 00 00 00       	push   $0xa2
  800a07:	68 5c 42 80 00       	push   $0x80425c
  800a0c:	e8 75 05 00 00       	call   800f86 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a11:	e8 fd 1d 00 00       	call   802813 <sys_pf_calculate_allocated_pages>
  800a16:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a19:	74 17                	je     800a32 <_main+0x9fa>
  800a1b:	83 ec 04             	sub    $0x4,%esp
  800a1e:	68 d8 42 80 00       	push   $0x8042d8
  800a23:	68 a3 00 00 00       	push   $0xa3
  800a28:	68 5c 42 80 00       	push   $0x80425c
  800a2d:	e8 54 05 00 00       	call   800f86 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a32:	e8 91 1d 00 00       	call   8027c8 <sys_calculate_free_frames>
  800a37:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a3d:	89 d0                	mov    %edx,%eax
  800a3f:	01 c0                	add    %eax,%eax
  800a41:	01 d0                	add    %edx,%eax
  800a43:	01 c0                	add    %eax,%eax
  800a45:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800a48:	48                   	dec    %eax
  800a49:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  800a4f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800a55:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		byteArr2[0] = minByte ;
  800a5b:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a61:	8a 55 df             	mov    -0x21(%ebp),%dl
  800a64:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800a66:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800a6c:	89 c2                	mov    %eax,%edx
  800a6e:	c1 ea 1f             	shr    $0x1f,%edx
  800a71:	01 d0                	add    %edx,%eax
  800a73:	d1 f8                	sar    %eax
  800a75:	89 c2                	mov    %eax,%edx
  800a77:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a7d:	01 c2                	add    %eax,%edx
  800a7f:	8a 45 de             	mov    -0x22(%ebp),%al
  800a82:	88 c1                	mov    %al,%cl
  800a84:	c0 e9 07             	shr    $0x7,%cl
  800a87:	01 c8                	add    %ecx,%eax
  800a89:	d0 f8                	sar    %al
  800a8b:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  800a8d:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800a93:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a99:	01 c2                	add    %eax,%edx
  800a9b:	8a 45 de             	mov    -0x22(%ebp),%al
  800a9e:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800aa0:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800aa3:	e8 20 1d 00 00       	call   8027c8 <sys_calculate_free_frames>
  800aa8:	29 c3                	sub    %eax,%ebx
  800aaa:	89 d8                	mov    %ebx,%eax
  800aac:	83 f8 05             	cmp    $0x5,%eax
  800aaf:	74 17                	je     800ac8 <_main+0xa90>
  800ab1:	83 ec 04             	sub    $0x4,%esp
  800ab4:	68 08 43 80 00       	push   $0x804308
  800ab9:	68 ab 00 00 00       	push   $0xab
  800abe:	68 5c 42 80 00       	push   $0x80425c
  800ac3:	e8 be 04 00 00       	call   800f86 <_panic>
		found = 0;
  800ac8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800acf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800ad6:	e9 02 01 00 00       	jmp    800bdd <_main+0xba5>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  800adb:	a1 20 50 80 00       	mov    0x805020,%eax
  800ae0:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800ae6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ae9:	89 d0                	mov    %edx,%eax
  800aeb:	01 c0                	add    %eax,%eax
  800aed:	01 d0                	add    %edx,%eax
  800aef:	c1 e0 03             	shl    $0x3,%eax
  800af2:	01 c8                	add    %ecx,%eax
  800af4:	8b 00                	mov    (%eax),%eax
  800af6:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800afc:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800b02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b07:	89 c2                	mov    %eax,%edx
  800b09:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b0f:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800b15:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b20:	39 c2                	cmp    %eax,%edx
  800b22:	75 03                	jne    800b27 <_main+0xaef>
				found++;
  800b24:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  800b27:	a1 20 50 80 00       	mov    0x805020,%eax
  800b2c:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800b32:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b35:	89 d0                	mov    %edx,%eax
  800b37:	01 c0                	add    %eax,%eax
  800b39:	01 d0                	add    %edx,%eax
  800b3b:	c1 e0 03             	shl    $0x3,%eax
  800b3e:	01 c8                	add    %ecx,%eax
  800b40:	8b 00                	mov    (%eax),%eax
  800b42:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b48:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b4e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b53:	89 c2                	mov    %eax,%edx
  800b55:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800b5b:	89 c1                	mov    %eax,%ecx
  800b5d:	c1 e9 1f             	shr    $0x1f,%ecx
  800b60:	01 c8                	add    %ecx,%eax
  800b62:	d1 f8                	sar    %eax
  800b64:	89 c1                	mov    %eax,%ecx
  800b66:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b6c:	01 c8                	add    %ecx,%eax
  800b6e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b74:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b7f:	39 c2                	cmp    %eax,%edx
  800b81:	75 03                	jne    800b86 <_main+0xb4e>
				found++;
  800b83:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  800b86:	a1 20 50 80 00       	mov    0x805020,%eax
  800b8b:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800b91:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b94:	89 d0                	mov    %edx,%eax
  800b96:	01 c0                	add    %eax,%eax
  800b98:	01 d0                	add    %edx,%eax
  800b9a:	c1 e0 03             	shl    $0x3,%eax
  800b9d:	01 c8                	add    %ecx,%eax
  800b9f:	8b 00                	mov    (%eax),%eax
  800ba1:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800ba7:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800bad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bb2:	89 c1                	mov    %eax,%ecx
  800bb4:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800bba:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800bc0:	01 d0                	add    %edx,%eax
  800bc2:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800bc8:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800bce:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bd3:	39 c1                	cmp    %eax,%ecx
  800bd5:	75 03                	jne    800bda <_main+0xba2>
				found++;
  800bd7:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800bda:	ff 45 ec             	incl   -0x14(%ebp)
  800bdd:	a1 20 50 80 00       	mov    0x805020,%eax
  800be2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800beb:	39 c2                	cmp    %eax,%edx
  800bed:	0f 87 e8 fe ff ff    	ja     800adb <_main+0xaa3>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  800bf3:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  800bf7:	74 17                	je     800c10 <_main+0xbd8>
  800bf9:	83 ec 04             	sub    $0x4,%esp
  800bfc:	68 4c 43 80 00       	push   $0x80434c
  800c01:	68 b6 00 00 00       	push   $0xb6
  800c06:	68 5c 42 80 00       	push   $0x80425c
  800c0b:	e8 76 03 00 00       	call   800f86 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c10:	e8 fe 1b 00 00       	call   802813 <sys_pf_calculate_allocated_pages>
  800c15:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  800c18:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c1b:	89 d0                	mov    %edx,%eax
  800c1d:	01 c0                	add    %eax,%eax
  800c1f:	01 d0                	add    %edx,%eax
  800c21:	01 c0                	add    %eax,%eax
  800c23:	01 d0                	add    %edx,%eax
  800c25:	01 c0                	add    %eax,%eax
  800c27:	83 ec 0c             	sub    $0xc,%esp
  800c2a:	50                   	push   %eax
  800c2b:	e8 c3 13 00 00       	call   801ff3 <malloc>
  800c30:	83 c4 10             	add    $0x10,%esp
  800c33:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800c39:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c3f:	89 c1                	mov    %eax,%ecx
  800c41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c44:	89 d0                	mov    %edx,%eax
  800c46:	01 c0                	add    %eax,%eax
  800c48:	01 d0                	add    %edx,%eax
  800c4a:	c1 e0 02             	shl    $0x2,%eax
  800c4d:	01 d0                	add    %edx,%eax
  800c4f:	89 c2                	mov    %eax,%edx
  800c51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c54:	c1 e0 04             	shl    $0x4,%eax
  800c57:	01 d0                	add    %edx,%eax
  800c59:	05 00 00 00 80       	add    $0x80000000,%eax
  800c5e:	39 c1                	cmp    %eax,%ecx
  800c60:	72 29                	jb     800c8b <_main+0xc53>
  800c62:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c68:	89 c1                	mov    %eax,%ecx
  800c6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c6d:	89 d0                	mov    %edx,%eax
  800c6f:	01 c0                	add    %eax,%eax
  800c71:	01 d0                	add    %edx,%eax
  800c73:	c1 e0 02             	shl    $0x2,%eax
  800c76:	01 d0                	add    %edx,%eax
  800c78:	89 c2                	mov    %eax,%edx
  800c7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c7d:	c1 e0 04             	shl    $0x4,%eax
  800c80:	01 d0                	add    %edx,%eax
  800c82:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800c87:	39 c1                	cmp    %eax,%ecx
  800c89:	76 17                	jbe    800ca2 <_main+0xc6a>
  800c8b:	83 ec 04             	sub    $0x4,%esp
  800c8e:	68 70 42 80 00       	push   $0x804270
  800c93:	68 bb 00 00 00       	push   $0xbb
  800c98:	68 5c 42 80 00       	push   $0x80425c
  800c9d:	e8 e4 02 00 00       	call   800f86 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800ca2:	e8 6c 1b 00 00       	call   802813 <sys_pf_calculate_allocated_pages>
  800ca7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800caa:	74 17                	je     800cc3 <_main+0xc8b>
  800cac:	83 ec 04             	sub    $0x4,%esp
  800caf:	68 d8 42 80 00       	push   $0x8042d8
  800cb4:	68 bc 00 00 00       	push   $0xbc
  800cb9:	68 5c 42 80 00       	push   $0x80425c
  800cbe:	e8 c3 02 00 00       	call   800f86 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800cc3:	e8 00 1b 00 00       	call   8027c8 <sys_calculate_free_frames>
  800cc8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  800ccb:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800cd1:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800cd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cda:	89 d0                	mov    %edx,%eax
  800cdc:	01 c0                	add    %eax,%eax
  800cde:	01 d0                	add    %edx,%eax
  800ce0:	01 c0                	add    %eax,%eax
  800ce2:	01 d0                	add    %edx,%eax
  800ce4:	01 c0                	add    %eax,%eax
  800ce6:	d1 e8                	shr    %eax
  800ce8:	48                   	dec    %eax
  800ce9:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
		shortArr2[0] = minShort;
  800cef:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  800cf5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800cf8:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  800cfb:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d01:	01 c0                	add    %eax,%eax
  800d03:	89 c2                	mov    %eax,%edx
  800d05:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d0b:	01 c2                	add    %eax,%edx
  800d0d:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800d11:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800d14:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800d17:	e8 ac 1a 00 00       	call   8027c8 <sys_calculate_free_frames>
  800d1c:	29 c3                	sub    %eax,%ebx
  800d1e:	89 d8                	mov    %ebx,%eax
  800d20:	83 f8 02             	cmp    $0x2,%eax
  800d23:	74 17                	je     800d3c <_main+0xd04>
  800d25:	83 ec 04             	sub    $0x4,%esp
  800d28:	68 08 43 80 00       	push   $0x804308
  800d2d:	68 c3 00 00 00       	push   $0xc3
  800d32:	68 5c 42 80 00       	push   $0x80425c
  800d37:	e8 4a 02 00 00       	call   800f86 <_panic>
		found = 0;
  800d3c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d43:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800d4a:	e9 a7 00 00 00       	jmp    800df6 <_main+0xdbe>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  800d4f:	a1 20 50 80 00       	mov    0x805020,%eax
  800d54:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800d5a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d5d:	89 d0                	mov    %edx,%eax
  800d5f:	01 c0                	add    %eax,%eax
  800d61:	01 d0                	add    %edx,%eax
  800d63:	c1 e0 03             	shl    $0x3,%eax
  800d66:	01 c8                	add    %ecx,%eax
  800d68:	8b 00                	mov    (%eax),%eax
  800d6a:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  800d70:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d7b:	89 c2                	mov    %eax,%edx
  800d7d:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d83:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d89:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d8f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d94:	39 c2                	cmp    %eax,%edx
  800d96:	75 03                	jne    800d9b <_main+0xd63>
				found++;
  800d98:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  800d9b:	a1 20 50 80 00       	mov    0x805020,%eax
  800da0:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800da6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800da9:	89 d0                	mov    %edx,%eax
  800dab:	01 c0                	add    %eax,%eax
  800dad:	01 d0                	add    %edx,%eax
  800daf:	c1 e0 03             	shl    $0x3,%eax
  800db2:	01 c8                	add    %ecx,%eax
  800db4:	8b 00                	mov    (%eax),%eax
  800db6:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800dbc:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800dc2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dc7:	89 c2                	mov    %eax,%edx
  800dc9:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800dcf:	01 c0                	add    %eax,%eax
  800dd1:	89 c1                	mov    %eax,%ecx
  800dd3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800dd9:	01 c8                	add    %ecx,%eax
  800ddb:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800de1:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800de7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dec:	39 c2                	cmp    %eax,%edx
  800dee:	75 03                	jne    800df3 <_main+0xdbb>
				found++;
  800df0:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800df3:	ff 45 ec             	incl   -0x14(%ebp)
  800df6:	a1 20 50 80 00       	mov    0x805020,%eax
  800dfb:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800e01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e04:	39 c2                	cmp    %eax,%edx
  800e06:	0f 87 43 ff ff ff    	ja     800d4f <_main+0xd17>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800e0c:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800e10:	74 17                	je     800e29 <_main+0xdf1>
  800e12:	83 ec 04             	sub    $0x4,%esp
  800e15:	68 4c 43 80 00       	push   $0x80434c
  800e1a:	68 cc 00 00 00       	push   $0xcc
  800e1f:	68 5c 42 80 00       	push   $0x80425c
  800e24:	e8 5d 01 00 00       	call   800f86 <_panic>
	}

	cprintf("Congratulations!! test malloc [3] completed successfully.\n");
  800e29:	83 ec 0c             	sub    $0xc,%esp
  800e2c:	68 6c 43 80 00       	push   $0x80436c
  800e31:	e8 0d 04 00 00       	call   801243 <cprintf>
  800e36:	83 c4 10             	add    $0x10,%esp

	return;
  800e39:	90                   	nop
}
  800e3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e3d:	5b                   	pop    %ebx
  800e3e:	5f                   	pop    %edi
  800e3f:	5d                   	pop    %ebp
  800e40:	c3                   	ret    

00800e41 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800e47:	e8 45 1b 00 00       	call   802991 <sys_getenvindex>
  800e4c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e52:	89 d0                	mov    %edx,%eax
  800e54:	c1 e0 02             	shl    $0x2,%eax
  800e57:	01 d0                	add    %edx,%eax
  800e59:	c1 e0 03             	shl    $0x3,%eax
  800e5c:	01 d0                	add    %edx,%eax
  800e5e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800e65:	01 d0                	add    %edx,%eax
  800e67:	c1 e0 02             	shl    $0x2,%eax
  800e6a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800e6f:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800e74:	a1 20 50 80 00       	mov    0x805020,%eax
  800e79:	8a 40 20             	mov    0x20(%eax),%al
  800e7c:	84 c0                	test   %al,%al
  800e7e:	74 0d                	je     800e8d <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800e80:	a1 20 50 80 00       	mov    0x805020,%eax
  800e85:	83 c0 20             	add    $0x20,%eax
  800e88:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800e8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e91:	7e 0a                	jle    800e9d <libmain+0x5c>
		binaryname = argv[0];
  800e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e96:	8b 00                	mov    (%eax),%eax
  800e98:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800e9d:	83 ec 08             	sub    $0x8,%esp
  800ea0:	ff 75 0c             	pushl  0xc(%ebp)
  800ea3:	ff 75 08             	pushl  0x8(%ebp)
  800ea6:	e8 8d f1 ff ff       	call   800038 <_main>
  800eab:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800eae:	a1 00 50 80 00       	mov    0x805000,%eax
  800eb3:	85 c0                	test   %eax,%eax
  800eb5:	0f 84 9f 00 00 00    	je     800f5a <libmain+0x119>
	{
		sys_lock_cons();
  800ebb:	e8 55 18 00 00       	call   802715 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800ec0:	83 ec 0c             	sub    $0xc,%esp
  800ec3:	68 c0 43 80 00       	push   $0x8043c0
  800ec8:	e8 76 03 00 00       	call   801243 <cprintf>
  800ecd:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800ed0:	a1 20 50 80 00       	mov    0x805020,%eax
  800ed5:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800edb:	a1 20 50 80 00       	mov    0x805020,%eax
  800ee0:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800ee6:	83 ec 04             	sub    $0x4,%esp
  800ee9:	52                   	push   %edx
  800eea:	50                   	push   %eax
  800eeb:	68 e8 43 80 00       	push   $0x8043e8
  800ef0:	e8 4e 03 00 00       	call   801243 <cprintf>
  800ef5:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800ef8:	a1 20 50 80 00       	mov    0x805020,%eax
  800efd:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800f03:	a1 20 50 80 00       	mov    0x805020,%eax
  800f08:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800f0e:	a1 20 50 80 00       	mov    0x805020,%eax
  800f13:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800f19:	51                   	push   %ecx
  800f1a:	52                   	push   %edx
  800f1b:	50                   	push   %eax
  800f1c:	68 10 44 80 00       	push   $0x804410
  800f21:	e8 1d 03 00 00       	call   801243 <cprintf>
  800f26:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800f29:	a1 20 50 80 00       	mov    0x805020,%eax
  800f2e:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800f34:	83 ec 08             	sub    $0x8,%esp
  800f37:	50                   	push   %eax
  800f38:	68 68 44 80 00       	push   $0x804468
  800f3d:	e8 01 03 00 00       	call   801243 <cprintf>
  800f42:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800f45:	83 ec 0c             	sub    $0xc,%esp
  800f48:	68 c0 43 80 00       	push   $0x8043c0
  800f4d:	e8 f1 02 00 00       	call   801243 <cprintf>
  800f52:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800f55:	e8 d5 17 00 00       	call   80272f <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800f5a:	e8 19 00 00 00       	call   800f78 <exit>
}
  800f5f:	90                   	nop
  800f60:	c9                   	leave  
  800f61:	c3                   	ret    

00800f62 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800f68:	83 ec 0c             	sub    $0xc,%esp
  800f6b:	6a 00                	push   $0x0
  800f6d:	e8 eb 19 00 00       	call   80295d <sys_destroy_env>
  800f72:	83 c4 10             	add    $0x10,%esp
}
  800f75:	90                   	nop
  800f76:	c9                   	leave  
  800f77:	c3                   	ret    

00800f78 <exit>:

void
exit(void)
{
  800f78:	55                   	push   %ebp
  800f79:	89 e5                	mov    %esp,%ebp
  800f7b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800f7e:	e8 40 1a 00 00       	call   8029c3 <sys_exit_env>
}
  800f83:	90                   	nop
  800f84:	c9                   	leave  
  800f85:	c3                   	ret    

00800f86 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800f8c:	8d 45 10             	lea    0x10(%ebp),%eax
  800f8f:	83 c0 04             	add    $0x4,%eax
  800f92:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800f95:	a1 60 50 98 00       	mov    0x985060,%eax
  800f9a:	85 c0                	test   %eax,%eax
  800f9c:	74 16                	je     800fb4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800f9e:	a1 60 50 98 00       	mov    0x985060,%eax
  800fa3:	83 ec 08             	sub    $0x8,%esp
  800fa6:	50                   	push   %eax
  800fa7:	68 7c 44 80 00       	push   $0x80447c
  800fac:	e8 92 02 00 00       	call   801243 <cprintf>
  800fb1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800fb4:	a1 04 50 80 00       	mov    0x805004,%eax
  800fb9:	ff 75 0c             	pushl  0xc(%ebp)
  800fbc:	ff 75 08             	pushl  0x8(%ebp)
  800fbf:	50                   	push   %eax
  800fc0:	68 81 44 80 00       	push   $0x804481
  800fc5:	e8 79 02 00 00       	call   801243 <cprintf>
  800fca:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800fcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd0:	83 ec 08             	sub    $0x8,%esp
  800fd3:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd6:	50                   	push   %eax
  800fd7:	e8 fc 01 00 00       	call   8011d8 <vcprintf>
  800fdc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800fdf:	83 ec 08             	sub    $0x8,%esp
  800fe2:	6a 00                	push   $0x0
  800fe4:	68 9d 44 80 00       	push   $0x80449d
  800fe9:	e8 ea 01 00 00       	call   8011d8 <vcprintf>
  800fee:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800ff1:	e8 82 ff ff ff       	call   800f78 <exit>

	// should not return here
	while (1) ;
  800ff6:	eb fe                	jmp    800ff6 <_panic+0x70>

00800ff8 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800ff8:	55                   	push   %ebp
  800ff9:	89 e5                	mov    %esp,%ebp
  800ffb:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800ffe:	a1 20 50 80 00       	mov    0x805020,%eax
  801003:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100c:	39 c2                	cmp    %eax,%edx
  80100e:	74 14                	je     801024 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801010:	83 ec 04             	sub    $0x4,%esp
  801013:	68 a0 44 80 00       	push   $0x8044a0
  801018:	6a 26                	push   $0x26
  80101a:	68 ec 44 80 00       	push   $0x8044ec
  80101f:	e8 62 ff ff ff       	call   800f86 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801024:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80102b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801032:	e9 c5 00 00 00       	jmp    8010fc <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801037:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80103a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	01 d0                	add    %edx,%eax
  801046:	8b 00                	mov    (%eax),%eax
  801048:	85 c0                	test   %eax,%eax
  80104a:	75 08                	jne    801054 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80104c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80104f:	e9 a5 00 00 00       	jmp    8010f9 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801054:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80105b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801062:	eb 69                	jmp    8010cd <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801064:	a1 20 50 80 00       	mov    0x805020,%eax
  801069:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80106f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801072:	89 d0                	mov    %edx,%eax
  801074:	01 c0                	add    %eax,%eax
  801076:	01 d0                	add    %edx,%eax
  801078:	c1 e0 03             	shl    $0x3,%eax
  80107b:	01 c8                	add    %ecx,%eax
  80107d:	8a 40 04             	mov    0x4(%eax),%al
  801080:	84 c0                	test   %al,%al
  801082:	75 46                	jne    8010ca <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801084:	a1 20 50 80 00       	mov    0x805020,%eax
  801089:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80108f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801092:	89 d0                	mov    %edx,%eax
  801094:	01 c0                	add    %eax,%eax
  801096:	01 d0                	add    %edx,%eax
  801098:	c1 e0 03             	shl    $0x3,%eax
  80109b:	01 c8                	add    %ecx,%eax
  80109d:	8b 00                	mov    (%eax),%eax
  80109f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8010a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8010a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010aa:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8010ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010af:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	01 c8                	add    %ecx,%eax
  8010bb:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8010bd:	39 c2                	cmp    %eax,%edx
  8010bf:	75 09                	jne    8010ca <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8010c1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8010c8:	eb 15                	jmp    8010df <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010ca:	ff 45 e8             	incl   -0x18(%ebp)
  8010cd:	a1 20 50 80 00       	mov    0x805020,%eax
  8010d2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8010d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010db:	39 c2                	cmp    %eax,%edx
  8010dd:	77 85                	ja     801064 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8010df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010e3:	75 14                	jne    8010f9 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8010e5:	83 ec 04             	sub    $0x4,%esp
  8010e8:	68 f8 44 80 00       	push   $0x8044f8
  8010ed:	6a 3a                	push   $0x3a
  8010ef:	68 ec 44 80 00       	push   $0x8044ec
  8010f4:	e8 8d fe ff ff       	call   800f86 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8010f9:	ff 45 f0             	incl   -0x10(%ebp)
  8010fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801102:	0f 8c 2f ff ff ff    	jl     801037 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801108:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80110f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801116:	eb 26                	jmp    80113e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801118:	a1 20 50 80 00       	mov    0x805020,%eax
  80111d:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801123:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801126:	89 d0                	mov    %edx,%eax
  801128:	01 c0                	add    %eax,%eax
  80112a:	01 d0                	add    %edx,%eax
  80112c:	c1 e0 03             	shl    $0x3,%eax
  80112f:	01 c8                	add    %ecx,%eax
  801131:	8a 40 04             	mov    0x4(%eax),%al
  801134:	3c 01                	cmp    $0x1,%al
  801136:	75 03                	jne    80113b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801138:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80113b:	ff 45 e0             	incl   -0x20(%ebp)
  80113e:	a1 20 50 80 00       	mov    0x805020,%eax
  801143:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801149:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80114c:	39 c2                	cmp    %eax,%edx
  80114e:	77 c8                	ja     801118 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801153:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801156:	74 14                	je     80116c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801158:	83 ec 04             	sub    $0x4,%esp
  80115b:	68 4c 45 80 00       	push   $0x80454c
  801160:	6a 44                	push   $0x44
  801162:	68 ec 44 80 00       	push   $0x8044ec
  801167:	e8 1a fe ff ff       	call   800f86 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80116c:	90                   	nop
  80116d:	c9                   	leave  
  80116e:	c3                   	ret    

0080116f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801175:	8b 45 0c             	mov    0xc(%ebp),%eax
  801178:	8b 00                	mov    (%eax),%eax
  80117a:	8d 48 01             	lea    0x1(%eax),%ecx
  80117d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801180:	89 0a                	mov    %ecx,(%edx)
  801182:	8b 55 08             	mov    0x8(%ebp),%edx
  801185:	88 d1                	mov    %dl,%cl
  801187:	8b 55 0c             	mov    0xc(%ebp),%edx
  80118a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80118e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801191:	8b 00                	mov    (%eax),%eax
  801193:	3d ff 00 00 00       	cmp    $0xff,%eax
  801198:	75 2c                	jne    8011c6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80119a:	a0 44 50 98 00       	mov    0x985044,%al
  80119f:	0f b6 c0             	movzbl %al,%eax
  8011a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011a5:	8b 12                	mov    (%edx),%edx
  8011a7:	89 d1                	mov    %edx,%ecx
  8011a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ac:	83 c2 08             	add    $0x8,%edx
  8011af:	83 ec 04             	sub    $0x4,%esp
  8011b2:	50                   	push   %eax
  8011b3:	51                   	push   %ecx
  8011b4:	52                   	push   %edx
  8011b5:	e8 19 15 00 00       	call   8026d3 <sys_cputs>
  8011ba:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8011bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8011c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c9:	8b 40 04             	mov    0x4(%eax),%eax
  8011cc:	8d 50 01             	lea    0x1(%eax),%edx
  8011cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8011d5:	90                   	nop
  8011d6:	c9                   	leave  
  8011d7:	c3                   	ret    

008011d8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8011e1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8011e8:	00 00 00 
	b.cnt = 0;
  8011eb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8011f2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8011f5:	ff 75 0c             	pushl  0xc(%ebp)
  8011f8:	ff 75 08             	pushl  0x8(%ebp)
  8011fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801201:	50                   	push   %eax
  801202:	68 6f 11 80 00       	push   $0x80116f
  801207:	e8 11 02 00 00       	call   80141d <vprintfmt>
  80120c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80120f:	a0 44 50 98 00       	mov    0x985044,%al
  801214:	0f b6 c0             	movzbl %al,%eax
  801217:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80121d:	83 ec 04             	sub    $0x4,%esp
  801220:	50                   	push   %eax
  801221:	52                   	push   %edx
  801222:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801228:	83 c0 08             	add    $0x8,%eax
  80122b:	50                   	push   %eax
  80122c:	e8 a2 14 00 00       	call   8026d3 <sys_cputs>
  801231:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801234:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  80123b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801241:	c9                   	leave  
  801242:	c3                   	ret    

00801243 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801249:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  801250:	8d 45 0c             	lea    0xc(%ebp),%eax
  801253:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	83 ec 08             	sub    $0x8,%esp
  80125c:	ff 75 f4             	pushl  -0xc(%ebp)
  80125f:	50                   	push   %eax
  801260:	e8 73 ff ff ff       	call   8011d8 <vcprintf>
  801265:	83 c4 10             	add    $0x10,%esp
  801268:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80126b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80126e:	c9                   	leave  
  80126f:	c3                   	ret    

00801270 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801270:	55                   	push   %ebp
  801271:	89 e5                	mov    %esp,%ebp
  801273:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801276:	e8 9a 14 00 00       	call   802715 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80127b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80127e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	83 ec 08             	sub    $0x8,%esp
  801287:	ff 75 f4             	pushl  -0xc(%ebp)
  80128a:	50                   	push   %eax
  80128b:	e8 48 ff ff ff       	call   8011d8 <vcprintf>
  801290:	83 c4 10             	add    $0x10,%esp
  801293:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801296:	e8 94 14 00 00       	call   80272f <sys_unlock_cons>
	return cnt;
  80129b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80129e:	c9                   	leave  
  80129f:	c3                   	ret    

008012a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
  8012a3:	53                   	push   %ebx
  8012a4:	83 ec 14             	sub    $0x14,%esp
  8012a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8012b3:	8b 45 18             	mov    0x18(%ebp),%eax
  8012b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8012bb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8012be:	77 55                	ja     801315 <printnum+0x75>
  8012c0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8012c3:	72 05                	jb     8012ca <printnum+0x2a>
  8012c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c8:	77 4b                	ja     801315 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8012ca:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8012cd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8012d0:	8b 45 18             	mov    0x18(%ebp),%eax
  8012d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8012d8:	52                   	push   %edx
  8012d9:	50                   	push   %eax
  8012da:	ff 75 f4             	pushl  -0xc(%ebp)
  8012dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8012e0:	e8 ef 2c 00 00       	call   803fd4 <__udivdi3>
  8012e5:	83 c4 10             	add    $0x10,%esp
  8012e8:	83 ec 04             	sub    $0x4,%esp
  8012eb:	ff 75 20             	pushl  0x20(%ebp)
  8012ee:	53                   	push   %ebx
  8012ef:	ff 75 18             	pushl  0x18(%ebp)
  8012f2:	52                   	push   %edx
  8012f3:	50                   	push   %eax
  8012f4:	ff 75 0c             	pushl  0xc(%ebp)
  8012f7:	ff 75 08             	pushl  0x8(%ebp)
  8012fa:	e8 a1 ff ff ff       	call   8012a0 <printnum>
  8012ff:	83 c4 20             	add    $0x20,%esp
  801302:	eb 1a                	jmp    80131e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801304:	83 ec 08             	sub    $0x8,%esp
  801307:	ff 75 0c             	pushl  0xc(%ebp)
  80130a:	ff 75 20             	pushl  0x20(%ebp)
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	ff d0                	call   *%eax
  801312:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801315:	ff 4d 1c             	decl   0x1c(%ebp)
  801318:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80131c:	7f e6                	jg     801304 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80131e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801321:	bb 00 00 00 00       	mov    $0x0,%ebx
  801326:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801329:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80132c:	53                   	push   %ebx
  80132d:	51                   	push   %ecx
  80132e:	52                   	push   %edx
  80132f:	50                   	push   %eax
  801330:	e8 af 2d 00 00       	call   8040e4 <__umoddi3>
  801335:	83 c4 10             	add    $0x10,%esp
  801338:	05 b4 47 80 00       	add    $0x8047b4,%eax
  80133d:	8a 00                	mov    (%eax),%al
  80133f:	0f be c0             	movsbl %al,%eax
  801342:	83 ec 08             	sub    $0x8,%esp
  801345:	ff 75 0c             	pushl  0xc(%ebp)
  801348:	50                   	push   %eax
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	ff d0                	call   *%eax
  80134e:	83 c4 10             	add    $0x10,%esp
}
  801351:	90                   	nop
  801352:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801355:	c9                   	leave  
  801356:	c3                   	ret    

00801357 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80135a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80135e:	7e 1c                	jle    80137c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
  801363:	8b 00                	mov    (%eax),%eax
  801365:	8d 50 08             	lea    0x8(%eax),%edx
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	89 10                	mov    %edx,(%eax)
  80136d:	8b 45 08             	mov    0x8(%ebp),%eax
  801370:	8b 00                	mov    (%eax),%eax
  801372:	83 e8 08             	sub    $0x8,%eax
  801375:	8b 50 04             	mov    0x4(%eax),%edx
  801378:	8b 00                	mov    (%eax),%eax
  80137a:	eb 40                	jmp    8013bc <getuint+0x65>
	else if (lflag)
  80137c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801380:	74 1e                	je     8013a0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	8b 00                	mov    (%eax),%eax
  801387:	8d 50 04             	lea    0x4(%eax),%edx
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	89 10                	mov    %edx,(%eax)
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	8b 00                	mov    (%eax),%eax
  801394:	83 e8 04             	sub    $0x4,%eax
  801397:	8b 00                	mov    (%eax),%eax
  801399:	ba 00 00 00 00       	mov    $0x0,%edx
  80139e:	eb 1c                	jmp    8013bc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8b 00                	mov    (%eax),%eax
  8013a5:	8d 50 04             	lea    0x4(%eax),%edx
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	89 10                	mov    %edx,(%eax)
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	8b 00                	mov    (%eax),%eax
  8013b2:	83 e8 04             	sub    $0x4,%eax
  8013b5:	8b 00                	mov    (%eax),%eax
  8013b7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8013bc:	5d                   	pop    %ebp
  8013bd:	c3                   	ret    

008013be <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8013c1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8013c5:	7e 1c                	jle    8013e3 <getint+0x25>
		return va_arg(*ap, long long);
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	8b 00                	mov    (%eax),%eax
  8013cc:	8d 50 08             	lea    0x8(%eax),%edx
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	89 10                	mov    %edx,(%eax)
  8013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d7:	8b 00                	mov    (%eax),%eax
  8013d9:	83 e8 08             	sub    $0x8,%eax
  8013dc:	8b 50 04             	mov    0x4(%eax),%edx
  8013df:	8b 00                	mov    (%eax),%eax
  8013e1:	eb 38                	jmp    80141b <getint+0x5d>
	else if (lflag)
  8013e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013e7:	74 1a                	je     801403 <getint+0x45>
		return va_arg(*ap, long);
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	8b 00                	mov    (%eax),%eax
  8013ee:	8d 50 04             	lea    0x4(%eax),%edx
  8013f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f4:	89 10                	mov    %edx,(%eax)
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	8b 00                	mov    (%eax),%eax
  8013fb:	83 e8 04             	sub    $0x4,%eax
  8013fe:	8b 00                	mov    (%eax),%eax
  801400:	99                   	cltd   
  801401:	eb 18                	jmp    80141b <getint+0x5d>
	else
		return va_arg(*ap, int);
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	8b 00                	mov    (%eax),%eax
  801408:	8d 50 04             	lea    0x4(%eax),%edx
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	89 10                	mov    %edx,(%eax)
  801410:	8b 45 08             	mov    0x8(%ebp),%eax
  801413:	8b 00                	mov    (%eax),%eax
  801415:	83 e8 04             	sub    $0x4,%eax
  801418:	8b 00                	mov    (%eax),%eax
  80141a:	99                   	cltd   
}
  80141b:	5d                   	pop    %ebp
  80141c:	c3                   	ret    

0080141d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	56                   	push   %esi
  801421:	53                   	push   %ebx
  801422:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801425:	eb 17                	jmp    80143e <vprintfmt+0x21>
			if (ch == '\0')
  801427:	85 db                	test   %ebx,%ebx
  801429:	0f 84 c1 03 00 00    	je     8017f0 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80142f:	83 ec 08             	sub    $0x8,%esp
  801432:	ff 75 0c             	pushl  0xc(%ebp)
  801435:	53                   	push   %ebx
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	ff d0                	call   *%eax
  80143b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80143e:	8b 45 10             	mov    0x10(%ebp),%eax
  801441:	8d 50 01             	lea    0x1(%eax),%edx
  801444:	89 55 10             	mov    %edx,0x10(%ebp)
  801447:	8a 00                	mov    (%eax),%al
  801449:	0f b6 d8             	movzbl %al,%ebx
  80144c:	83 fb 25             	cmp    $0x25,%ebx
  80144f:	75 d6                	jne    801427 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801451:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801455:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80145c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801463:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80146a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801471:	8b 45 10             	mov    0x10(%ebp),%eax
  801474:	8d 50 01             	lea    0x1(%eax),%edx
  801477:	89 55 10             	mov    %edx,0x10(%ebp)
  80147a:	8a 00                	mov    (%eax),%al
  80147c:	0f b6 d8             	movzbl %al,%ebx
  80147f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801482:	83 f8 5b             	cmp    $0x5b,%eax
  801485:	0f 87 3d 03 00 00    	ja     8017c8 <vprintfmt+0x3ab>
  80148b:	8b 04 85 d8 47 80 00 	mov    0x8047d8(,%eax,4),%eax
  801492:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801494:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801498:	eb d7                	jmp    801471 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80149a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80149e:	eb d1                	jmp    801471 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8014a0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8014a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014aa:	89 d0                	mov    %edx,%eax
  8014ac:	c1 e0 02             	shl    $0x2,%eax
  8014af:	01 d0                	add    %edx,%eax
  8014b1:	01 c0                	add    %eax,%eax
  8014b3:	01 d8                	add    %ebx,%eax
  8014b5:	83 e8 30             	sub    $0x30,%eax
  8014b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8014bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8014be:	8a 00                	mov    (%eax),%al
  8014c0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8014c3:	83 fb 2f             	cmp    $0x2f,%ebx
  8014c6:	7e 3e                	jle    801506 <vprintfmt+0xe9>
  8014c8:	83 fb 39             	cmp    $0x39,%ebx
  8014cb:	7f 39                	jg     801506 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8014cd:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8014d0:	eb d5                	jmp    8014a7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8014d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d5:	83 c0 04             	add    $0x4,%eax
  8014d8:	89 45 14             	mov    %eax,0x14(%ebp)
  8014db:	8b 45 14             	mov    0x14(%ebp),%eax
  8014de:	83 e8 04             	sub    $0x4,%eax
  8014e1:	8b 00                	mov    (%eax),%eax
  8014e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8014e6:	eb 1f                	jmp    801507 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8014e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014ec:	79 83                	jns    801471 <vprintfmt+0x54>
				width = 0;
  8014ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8014f5:	e9 77 ff ff ff       	jmp    801471 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8014fa:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801501:	e9 6b ff ff ff       	jmp    801471 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801506:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801507:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80150b:	0f 89 60 ff ff ff    	jns    801471 <vprintfmt+0x54>
				width = precision, precision = -1;
  801511:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801514:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801517:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80151e:	e9 4e ff ff ff       	jmp    801471 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801523:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801526:	e9 46 ff ff ff       	jmp    801471 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80152b:	8b 45 14             	mov    0x14(%ebp),%eax
  80152e:	83 c0 04             	add    $0x4,%eax
  801531:	89 45 14             	mov    %eax,0x14(%ebp)
  801534:	8b 45 14             	mov    0x14(%ebp),%eax
  801537:	83 e8 04             	sub    $0x4,%eax
  80153a:	8b 00                	mov    (%eax),%eax
  80153c:	83 ec 08             	sub    $0x8,%esp
  80153f:	ff 75 0c             	pushl  0xc(%ebp)
  801542:	50                   	push   %eax
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	ff d0                	call   *%eax
  801548:	83 c4 10             	add    $0x10,%esp
			break;
  80154b:	e9 9b 02 00 00       	jmp    8017eb <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801550:	8b 45 14             	mov    0x14(%ebp),%eax
  801553:	83 c0 04             	add    $0x4,%eax
  801556:	89 45 14             	mov    %eax,0x14(%ebp)
  801559:	8b 45 14             	mov    0x14(%ebp),%eax
  80155c:	83 e8 04             	sub    $0x4,%eax
  80155f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801561:	85 db                	test   %ebx,%ebx
  801563:	79 02                	jns    801567 <vprintfmt+0x14a>
				err = -err;
  801565:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801567:	83 fb 64             	cmp    $0x64,%ebx
  80156a:	7f 0b                	jg     801577 <vprintfmt+0x15a>
  80156c:	8b 34 9d 20 46 80 00 	mov    0x804620(,%ebx,4),%esi
  801573:	85 f6                	test   %esi,%esi
  801575:	75 19                	jne    801590 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801577:	53                   	push   %ebx
  801578:	68 c5 47 80 00       	push   $0x8047c5
  80157d:	ff 75 0c             	pushl  0xc(%ebp)
  801580:	ff 75 08             	pushl  0x8(%ebp)
  801583:	e8 70 02 00 00       	call   8017f8 <printfmt>
  801588:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80158b:	e9 5b 02 00 00       	jmp    8017eb <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801590:	56                   	push   %esi
  801591:	68 ce 47 80 00       	push   $0x8047ce
  801596:	ff 75 0c             	pushl  0xc(%ebp)
  801599:	ff 75 08             	pushl  0x8(%ebp)
  80159c:	e8 57 02 00 00       	call   8017f8 <printfmt>
  8015a1:	83 c4 10             	add    $0x10,%esp
			break;
  8015a4:	e9 42 02 00 00       	jmp    8017eb <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8015a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ac:	83 c0 04             	add    $0x4,%eax
  8015af:	89 45 14             	mov    %eax,0x14(%ebp)
  8015b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b5:	83 e8 04             	sub    $0x4,%eax
  8015b8:	8b 30                	mov    (%eax),%esi
  8015ba:	85 f6                	test   %esi,%esi
  8015bc:	75 05                	jne    8015c3 <vprintfmt+0x1a6>
				p = "(null)";
  8015be:	be d1 47 80 00       	mov    $0x8047d1,%esi
			if (width > 0 && padc != '-')
  8015c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015c7:	7e 6d                	jle    801636 <vprintfmt+0x219>
  8015c9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8015cd:	74 67                	je     801636 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8015cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015d2:	83 ec 08             	sub    $0x8,%esp
  8015d5:	50                   	push   %eax
  8015d6:	56                   	push   %esi
  8015d7:	e8 1e 03 00 00       	call   8018fa <strnlen>
  8015dc:	83 c4 10             	add    $0x10,%esp
  8015df:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8015e2:	eb 16                	jmp    8015fa <vprintfmt+0x1dd>
					putch(padc, putdat);
  8015e4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8015e8:	83 ec 08             	sub    $0x8,%esp
  8015eb:	ff 75 0c             	pushl  0xc(%ebp)
  8015ee:	50                   	push   %eax
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	ff d0                	call   *%eax
  8015f4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8015f7:	ff 4d e4             	decl   -0x1c(%ebp)
  8015fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015fe:	7f e4                	jg     8015e4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801600:	eb 34                	jmp    801636 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801602:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801606:	74 1c                	je     801624 <vprintfmt+0x207>
  801608:	83 fb 1f             	cmp    $0x1f,%ebx
  80160b:	7e 05                	jle    801612 <vprintfmt+0x1f5>
  80160d:	83 fb 7e             	cmp    $0x7e,%ebx
  801610:	7e 12                	jle    801624 <vprintfmt+0x207>
					putch('?', putdat);
  801612:	83 ec 08             	sub    $0x8,%esp
  801615:	ff 75 0c             	pushl  0xc(%ebp)
  801618:	6a 3f                	push   $0x3f
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	ff d0                	call   *%eax
  80161f:	83 c4 10             	add    $0x10,%esp
  801622:	eb 0f                	jmp    801633 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801624:	83 ec 08             	sub    $0x8,%esp
  801627:	ff 75 0c             	pushl  0xc(%ebp)
  80162a:	53                   	push   %ebx
  80162b:	8b 45 08             	mov    0x8(%ebp),%eax
  80162e:	ff d0                	call   *%eax
  801630:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801633:	ff 4d e4             	decl   -0x1c(%ebp)
  801636:	89 f0                	mov    %esi,%eax
  801638:	8d 70 01             	lea    0x1(%eax),%esi
  80163b:	8a 00                	mov    (%eax),%al
  80163d:	0f be d8             	movsbl %al,%ebx
  801640:	85 db                	test   %ebx,%ebx
  801642:	74 24                	je     801668 <vprintfmt+0x24b>
  801644:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801648:	78 b8                	js     801602 <vprintfmt+0x1e5>
  80164a:	ff 4d e0             	decl   -0x20(%ebp)
  80164d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801651:	79 af                	jns    801602 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801653:	eb 13                	jmp    801668 <vprintfmt+0x24b>
				putch(' ', putdat);
  801655:	83 ec 08             	sub    $0x8,%esp
  801658:	ff 75 0c             	pushl  0xc(%ebp)
  80165b:	6a 20                	push   $0x20
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	ff d0                	call   *%eax
  801662:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801665:	ff 4d e4             	decl   -0x1c(%ebp)
  801668:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80166c:	7f e7                	jg     801655 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80166e:	e9 78 01 00 00       	jmp    8017eb <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801673:	83 ec 08             	sub    $0x8,%esp
  801676:	ff 75 e8             	pushl  -0x18(%ebp)
  801679:	8d 45 14             	lea    0x14(%ebp),%eax
  80167c:	50                   	push   %eax
  80167d:	e8 3c fd ff ff       	call   8013be <getint>
  801682:	83 c4 10             	add    $0x10,%esp
  801685:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801688:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80168b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801691:	85 d2                	test   %edx,%edx
  801693:	79 23                	jns    8016b8 <vprintfmt+0x29b>
				putch('-', putdat);
  801695:	83 ec 08             	sub    $0x8,%esp
  801698:	ff 75 0c             	pushl  0xc(%ebp)
  80169b:	6a 2d                	push   $0x2d
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	ff d0                	call   *%eax
  8016a2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8016a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ab:	f7 d8                	neg    %eax
  8016ad:	83 d2 00             	adc    $0x0,%edx
  8016b0:	f7 da                	neg    %edx
  8016b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016b5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8016b8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8016bf:	e9 bc 00 00 00       	jmp    801780 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8016c4:	83 ec 08             	sub    $0x8,%esp
  8016c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8016ca:	8d 45 14             	lea    0x14(%ebp),%eax
  8016cd:	50                   	push   %eax
  8016ce:	e8 84 fc ff ff       	call   801357 <getuint>
  8016d3:	83 c4 10             	add    $0x10,%esp
  8016d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8016dc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8016e3:	e9 98 00 00 00       	jmp    801780 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8016e8:	83 ec 08             	sub    $0x8,%esp
  8016eb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ee:	6a 58                	push   $0x58
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	ff d0                	call   *%eax
  8016f5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8016f8:	83 ec 08             	sub    $0x8,%esp
  8016fb:	ff 75 0c             	pushl  0xc(%ebp)
  8016fe:	6a 58                	push   $0x58
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	ff d0                	call   *%eax
  801705:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801708:	83 ec 08             	sub    $0x8,%esp
  80170b:	ff 75 0c             	pushl  0xc(%ebp)
  80170e:	6a 58                	push   $0x58
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	ff d0                	call   *%eax
  801715:	83 c4 10             	add    $0x10,%esp
			break;
  801718:	e9 ce 00 00 00       	jmp    8017eb <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80171d:	83 ec 08             	sub    $0x8,%esp
  801720:	ff 75 0c             	pushl  0xc(%ebp)
  801723:	6a 30                	push   $0x30
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	ff d0                	call   *%eax
  80172a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80172d:	83 ec 08             	sub    $0x8,%esp
  801730:	ff 75 0c             	pushl  0xc(%ebp)
  801733:	6a 78                	push   $0x78
  801735:	8b 45 08             	mov    0x8(%ebp),%eax
  801738:	ff d0                	call   *%eax
  80173a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80173d:	8b 45 14             	mov    0x14(%ebp),%eax
  801740:	83 c0 04             	add    $0x4,%eax
  801743:	89 45 14             	mov    %eax,0x14(%ebp)
  801746:	8b 45 14             	mov    0x14(%ebp),%eax
  801749:	83 e8 04             	sub    $0x4,%eax
  80174c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80174e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801751:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801758:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80175f:	eb 1f                	jmp    801780 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801761:	83 ec 08             	sub    $0x8,%esp
  801764:	ff 75 e8             	pushl  -0x18(%ebp)
  801767:	8d 45 14             	lea    0x14(%ebp),%eax
  80176a:	50                   	push   %eax
  80176b:	e8 e7 fb ff ff       	call   801357 <getuint>
  801770:	83 c4 10             	add    $0x10,%esp
  801773:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801776:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801779:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801780:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801784:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801787:	83 ec 04             	sub    $0x4,%esp
  80178a:	52                   	push   %edx
  80178b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80178e:	50                   	push   %eax
  80178f:	ff 75 f4             	pushl  -0xc(%ebp)
  801792:	ff 75 f0             	pushl  -0x10(%ebp)
  801795:	ff 75 0c             	pushl  0xc(%ebp)
  801798:	ff 75 08             	pushl  0x8(%ebp)
  80179b:	e8 00 fb ff ff       	call   8012a0 <printnum>
  8017a0:	83 c4 20             	add    $0x20,%esp
			break;
  8017a3:	eb 46                	jmp    8017eb <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8017a5:	83 ec 08             	sub    $0x8,%esp
  8017a8:	ff 75 0c             	pushl  0xc(%ebp)
  8017ab:	53                   	push   %ebx
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	ff d0                	call   *%eax
  8017b1:	83 c4 10             	add    $0x10,%esp
			break;
  8017b4:	eb 35                	jmp    8017eb <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8017b6:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  8017bd:	eb 2c                	jmp    8017eb <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8017bf:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  8017c6:	eb 23                	jmp    8017eb <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8017c8:	83 ec 08             	sub    $0x8,%esp
  8017cb:	ff 75 0c             	pushl  0xc(%ebp)
  8017ce:	6a 25                	push   $0x25
  8017d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d3:	ff d0                	call   *%eax
  8017d5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8017d8:	ff 4d 10             	decl   0x10(%ebp)
  8017db:	eb 03                	jmp    8017e0 <vprintfmt+0x3c3>
  8017dd:	ff 4d 10             	decl   0x10(%ebp)
  8017e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e3:	48                   	dec    %eax
  8017e4:	8a 00                	mov    (%eax),%al
  8017e6:	3c 25                	cmp    $0x25,%al
  8017e8:	75 f3                	jne    8017dd <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8017ea:	90                   	nop
		}
	}
  8017eb:	e9 35 fc ff ff       	jmp    801425 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8017f0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8017f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017f4:	5b                   	pop    %ebx
  8017f5:	5e                   	pop    %esi
  8017f6:	5d                   	pop    %ebp
  8017f7:	c3                   	ret    

008017f8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8017fe:	8d 45 10             	lea    0x10(%ebp),%eax
  801801:	83 c0 04             	add    $0x4,%eax
  801804:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801807:	8b 45 10             	mov    0x10(%ebp),%eax
  80180a:	ff 75 f4             	pushl  -0xc(%ebp)
  80180d:	50                   	push   %eax
  80180e:	ff 75 0c             	pushl  0xc(%ebp)
  801811:	ff 75 08             	pushl  0x8(%ebp)
  801814:	e8 04 fc ff ff       	call   80141d <vprintfmt>
  801819:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80181c:	90                   	nop
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801822:	8b 45 0c             	mov    0xc(%ebp),%eax
  801825:	8b 40 08             	mov    0x8(%eax),%eax
  801828:	8d 50 01             	lea    0x1(%eax),%edx
  80182b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801831:	8b 45 0c             	mov    0xc(%ebp),%eax
  801834:	8b 10                	mov    (%eax),%edx
  801836:	8b 45 0c             	mov    0xc(%ebp),%eax
  801839:	8b 40 04             	mov    0x4(%eax),%eax
  80183c:	39 c2                	cmp    %eax,%edx
  80183e:	73 12                	jae    801852 <sprintputch+0x33>
		*b->buf++ = ch;
  801840:	8b 45 0c             	mov    0xc(%ebp),%eax
  801843:	8b 00                	mov    (%eax),%eax
  801845:	8d 48 01             	lea    0x1(%eax),%ecx
  801848:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184b:	89 0a                	mov    %ecx,(%edx)
  80184d:	8b 55 08             	mov    0x8(%ebp),%edx
  801850:	88 10                	mov    %dl,(%eax)
}
  801852:	90                   	nop
  801853:	5d                   	pop    %ebp
  801854:	c3                   	ret    

00801855 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80185b:	8b 45 08             	mov    0x8(%ebp),%eax
  80185e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801861:	8b 45 0c             	mov    0xc(%ebp),%eax
  801864:	8d 50 ff             	lea    -0x1(%eax),%edx
  801867:	8b 45 08             	mov    0x8(%ebp),%eax
  80186a:	01 d0                	add    %edx,%eax
  80186c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80186f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801876:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80187a:	74 06                	je     801882 <vsnprintf+0x2d>
  80187c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801880:	7f 07                	jg     801889 <vsnprintf+0x34>
		return -E_INVAL;
  801882:	b8 03 00 00 00       	mov    $0x3,%eax
  801887:	eb 20                	jmp    8018a9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801889:	ff 75 14             	pushl  0x14(%ebp)
  80188c:	ff 75 10             	pushl  0x10(%ebp)
  80188f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801892:	50                   	push   %eax
  801893:	68 1f 18 80 00       	push   $0x80181f
  801898:	e8 80 fb ff ff       	call   80141d <vprintfmt>
  80189d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8018a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8018a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8018b1:	8d 45 10             	lea    0x10(%ebp),%eax
  8018b4:	83 c0 04             	add    $0x4,%eax
  8018b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8018ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8018bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c0:	50                   	push   %eax
  8018c1:	ff 75 0c             	pushl  0xc(%ebp)
  8018c4:	ff 75 08             	pushl  0x8(%ebp)
  8018c7:	e8 89 ff ff ff       	call   801855 <vsnprintf>
  8018cc:	83 c4 10             	add    $0x10,%esp
  8018cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8018d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8018dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018e4:	eb 06                	jmp    8018ec <strlen+0x15>
		n++;
  8018e6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8018e9:	ff 45 08             	incl   0x8(%ebp)
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	8a 00                	mov    (%eax),%al
  8018f1:	84 c0                	test   %al,%al
  8018f3:	75 f1                	jne    8018e6 <strlen+0xf>
		n++;
	return n;
  8018f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
  8018fd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801900:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801907:	eb 09                	jmp    801912 <strnlen+0x18>
		n++;
  801909:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80190c:	ff 45 08             	incl   0x8(%ebp)
  80190f:	ff 4d 0c             	decl   0xc(%ebp)
  801912:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801916:	74 09                	je     801921 <strnlen+0x27>
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	8a 00                	mov    (%eax),%al
  80191d:	84 c0                	test   %al,%al
  80191f:	75 e8                	jne    801909 <strnlen+0xf>
		n++;
	return n;
  801921:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
  801929:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80192c:	8b 45 08             	mov    0x8(%ebp),%eax
  80192f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801932:	90                   	nop
  801933:	8b 45 08             	mov    0x8(%ebp),%eax
  801936:	8d 50 01             	lea    0x1(%eax),%edx
  801939:	89 55 08             	mov    %edx,0x8(%ebp)
  80193c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801942:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801945:	8a 12                	mov    (%edx),%dl
  801947:	88 10                	mov    %dl,(%eax)
  801949:	8a 00                	mov    (%eax),%al
  80194b:	84 c0                	test   %al,%al
  80194d:	75 e4                	jne    801933 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80194f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801952:	c9                   	leave  
  801953:	c3                   	ret    

00801954 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
  801957:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801960:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801967:	eb 1f                	jmp    801988 <strncpy+0x34>
		*dst++ = *src;
  801969:	8b 45 08             	mov    0x8(%ebp),%eax
  80196c:	8d 50 01             	lea    0x1(%eax),%edx
  80196f:	89 55 08             	mov    %edx,0x8(%ebp)
  801972:	8b 55 0c             	mov    0xc(%ebp),%edx
  801975:	8a 12                	mov    (%edx),%dl
  801977:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801979:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197c:	8a 00                	mov    (%eax),%al
  80197e:	84 c0                	test   %al,%al
  801980:	74 03                	je     801985 <strncpy+0x31>
			src++;
  801982:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801985:	ff 45 fc             	incl   -0x4(%ebp)
  801988:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80198b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80198e:	72 d9                	jb     801969 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801990:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
  801998:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8019a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019a5:	74 30                	je     8019d7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8019a7:	eb 16                	jmp    8019bf <strlcpy+0x2a>
			*dst++ = *src++;
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	8d 50 01             	lea    0x1(%eax),%edx
  8019af:	89 55 08             	mov    %edx,0x8(%ebp)
  8019b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8019b8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8019bb:	8a 12                	mov    (%edx),%dl
  8019bd:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8019bf:	ff 4d 10             	decl   0x10(%ebp)
  8019c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019c6:	74 09                	je     8019d1 <strlcpy+0x3c>
  8019c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019cb:	8a 00                	mov    (%eax),%al
  8019cd:	84 c0                	test   %al,%al
  8019cf:	75 d8                	jne    8019a9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8019d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8019da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019dd:	29 c2                	sub    %eax,%edx
  8019df:	89 d0                	mov    %edx,%eax
}
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8019e6:	eb 06                	jmp    8019ee <strcmp+0xb>
		p++, q++;
  8019e8:	ff 45 08             	incl   0x8(%ebp)
  8019eb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f1:	8a 00                	mov    (%eax),%al
  8019f3:	84 c0                	test   %al,%al
  8019f5:	74 0e                	je     801a05 <strcmp+0x22>
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	8a 10                	mov    (%eax),%dl
  8019fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ff:	8a 00                	mov    (%eax),%al
  801a01:	38 c2                	cmp    %al,%dl
  801a03:	74 e3                	je     8019e8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	8a 00                	mov    (%eax),%al
  801a0a:	0f b6 d0             	movzbl %al,%edx
  801a0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a10:	8a 00                	mov    (%eax),%al
  801a12:	0f b6 c0             	movzbl %al,%eax
  801a15:	29 c2                	sub    %eax,%edx
  801a17:	89 d0                	mov    %edx,%eax
}
  801a19:	5d                   	pop    %ebp
  801a1a:	c3                   	ret    

00801a1b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801a1e:	eb 09                	jmp    801a29 <strncmp+0xe>
		n--, p++, q++;
  801a20:	ff 4d 10             	decl   0x10(%ebp)
  801a23:	ff 45 08             	incl   0x8(%ebp)
  801a26:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801a29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a2d:	74 17                	je     801a46 <strncmp+0x2b>
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	8a 00                	mov    (%eax),%al
  801a34:	84 c0                	test   %al,%al
  801a36:	74 0e                	je     801a46 <strncmp+0x2b>
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	8a 10                	mov    (%eax),%dl
  801a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a40:	8a 00                	mov    (%eax),%al
  801a42:	38 c2                	cmp    %al,%dl
  801a44:	74 da                	je     801a20 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801a46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a4a:	75 07                	jne    801a53 <strncmp+0x38>
		return 0;
  801a4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a51:	eb 14                	jmp    801a67 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a53:	8b 45 08             	mov    0x8(%ebp),%eax
  801a56:	8a 00                	mov    (%eax),%al
  801a58:	0f b6 d0             	movzbl %al,%edx
  801a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5e:	8a 00                	mov    (%eax),%al
  801a60:	0f b6 c0             	movzbl %al,%eax
  801a63:	29 c2                	sub    %eax,%edx
  801a65:	89 d0                	mov    %edx,%eax
}
  801a67:	5d                   	pop    %ebp
  801a68:	c3                   	ret    

00801a69 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	83 ec 04             	sub    $0x4,%esp
  801a6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a72:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a75:	eb 12                	jmp    801a89 <strchr+0x20>
		if (*s == c)
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	8a 00                	mov    (%eax),%al
  801a7c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a7f:	75 05                	jne    801a86 <strchr+0x1d>
			return (char *) s;
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	eb 11                	jmp    801a97 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801a86:	ff 45 08             	incl   0x8(%ebp)
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	8a 00                	mov    (%eax),%al
  801a8e:	84 c0                	test   %al,%al
  801a90:	75 e5                	jne    801a77 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801a92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	83 ec 04             	sub    $0x4,%esp
  801a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801aa5:	eb 0d                	jmp    801ab4 <strfind+0x1b>
		if (*s == c)
  801aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaa:	8a 00                	mov    (%eax),%al
  801aac:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801aaf:	74 0e                	je     801abf <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801ab1:	ff 45 08             	incl   0x8(%ebp)
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	8a 00                	mov    (%eax),%al
  801ab9:	84 c0                	test   %al,%al
  801abb:	75 ea                	jne    801aa7 <strfind+0xe>
  801abd:	eb 01                	jmp    801ac0 <strfind+0x27>
		if (*s == c)
			break;
  801abf:	90                   	nop
	return (char *) s;
  801ac0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801acb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ace:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801ad1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801ad7:	eb 0e                	jmp    801ae7 <memset+0x22>
		*p++ = c;
  801ad9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801adc:	8d 50 01             	lea    0x1(%eax),%edx
  801adf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ae2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801ae7:	ff 4d f8             	decl   -0x8(%ebp)
  801aea:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801aee:	79 e9                	jns    801ad9 <memset+0x14>
		*p++ = c;

	return v;
  801af0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801afe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801b07:	eb 16                	jmp    801b1f <memcpy+0x2a>
		*d++ = *s++;
  801b09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b0c:	8d 50 01             	lea    0x1(%eax),%edx
  801b0f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b12:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b15:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b18:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b1b:	8a 12                	mov    (%edx),%dl
  801b1d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801b1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b22:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b25:	89 55 10             	mov    %edx,0x10(%ebp)
  801b28:	85 c0                	test   %eax,%eax
  801b2a:	75 dd                	jne    801b09 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801b43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b46:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b49:	73 50                	jae    801b9b <memmove+0x6a>
  801b4b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b4e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b51:	01 d0                	add    %edx,%eax
  801b53:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b56:	76 43                	jbe    801b9b <memmove+0x6a>
		s += n;
  801b58:	8b 45 10             	mov    0x10(%ebp),%eax
  801b5b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801b5e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b61:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801b64:	eb 10                	jmp    801b76 <memmove+0x45>
			*--d = *--s;
  801b66:	ff 4d f8             	decl   -0x8(%ebp)
  801b69:	ff 4d fc             	decl   -0x4(%ebp)
  801b6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b6f:	8a 10                	mov    (%eax),%dl
  801b71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b74:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801b76:	8b 45 10             	mov    0x10(%ebp),%eax
  801b79:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b7c:	89 55 10             	mov    %edx,0x10(%ebp)
  801b7f:	85 c0                	test   %eax,%eax
  801b81:	75 e3                	jne    801b66 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801b83:	eb 23                	jmp    801ba8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801b85:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b88:	8d 50 01             	lea    0x1(%eax),%edx
  801b8b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b91:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b94:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b97:	8a 12                	mov    (%edx),%dl
  801b99:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b9e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ba1:	89 55 10             	mov    %edx,0x10(%ebp)
  801ba4:	85 c0                	test   %eax,%eax
  801ba6:	75 dd                	jne    801b85 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801ba8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
  801bb0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801bb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801bbf:	eb 2a                	jmp    801beb <memcmp+0x3e>
		if (*s1 != *s2)
  801bc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bc4:	8a 10                	mov    (%eax),%dl
  801bc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bc9:	8a 00                	mov    (%eax),%al
  801bcb:	38 c2                	cmp    %al,%dl
  801bcd:	74 16                	je     801be5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801bcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bd2:	8a 00                	mov    (%eax),%al
  801bd4:	0f b6 d0             	movzbl %al,%edx
  801bd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bda:	8a 00                	mov    (%eax),%al
  801bdc:	0f b6 c0             	movzbl %al,%eax
  801bdf:	29 c2                	sub    %eax,%edx
  801be1:	89 d0                	mov    %edx,%eax
  801be3:	eb 18                	jmp    801bfd <memcmp+0x50>
		s1++, s2++;
  801be5:	ff 45 fc             	incl   -0x4(%ebp)
  801be8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801beb:	8b 45 10             	mov    0x10(%ebp),%eax
  801bee:	8d 50 ff             	lea    -0x1(%eax),%edx
  801bf1:	89 55 10             	mov    %edx,0x10(%ebp)
  801bf4:	85 c0                	test   %eax,%eax
  801bf6:	75 c9                	jne    801bc1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801bf8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
  801c02:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801c05:	8b 55 08             	mov    0x8(%ebp),%edx
  801c08:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0b:	01 d0                	add    %edx,%eax
  801c0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801c10:	eb 15                	jmp    801c27 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	8a 00                	mov    (%eax),%al
  801c17:	0f b6 d0             	movzbl %al,%edx
  801c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c1d:	0f b6 c0             	movzbl %al,%eax
  801c20:	39 c2                	cmp    %eax,%edx
  801c22:	74 0d                	je     801c31 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801c24:	ff 45 08             	incl   0x8(%ebp)
  801c27:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801c2d:	72 e3                	jb     801c12 <memfind+0x13>
  801c2f:	eb 01                	jmp    801c32 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801c31:	90                   	nop
	return (void *) s;
  801c32:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
  801c3a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801c3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801c44:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c4b:	eb 03                	jmp    801c50 <strtol+0x19>
		s++;
  801c4d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c50:	8b 45 08             	mov    0x8(%ebp),%eax
  801c53:	8a 00                	mov    (%eax),%al
  801c55:	3c 20                	cmp    $0x20,%al
  801c57:	74 f4                	je     801c4d <strtol+0x16>
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	8a 00                	mov    (%eax),%al
  801c5e:	3c 09                	cmp    $0x9,%al
  801c60:	74 eb                	je     801c4d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	8a 00                	mov    (%eax),%al
  801c67:	3c 2b                	cmp    $0x2b,%al
  801c69:	75 05                	jne    801c70 <strtol+0x39>
		s++;
  801c6b:	ff 45 08             	incl   0x8(%ebp)
  801c6e:	eb 13                	jmp    801c83 <strtol+0x4c>
	else if (*s == '-')
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	8a 00                	mov    (%eax),%al
  801c75:	3c 2d                	cmp    $0x2d,%al
  801c77:	75 0a                	jne    801c83 <strtol+0x4c>
		s++, neg = 1;
  801c79:	ff 45 08             	incl   0x8(%ebp)
  801c7c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c87:	74 06                	je     801c8f <strtol+0x58>
  801c89:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801c8d:	75 20                	jne    801caf <strtol+0x78>
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	8a 00                	mov    (%eax),%al
  801c94:	3c 30                	cmp    $0x30,%al
  801c96:	75 17                	jne    801caf <strtol+0x78>
  801c98:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9b:	40                   	inc    %eax
  801c9c:	8a 00                	mov    (%eax),%al
  801c9e:	3c 78                	cmp    $0x78,%al
  801ca0:	75 0d                	jne    801caf <strtol+0x78>
		s += 2, base = 16;
  801ca2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801ca6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801cad:	eb 28                	jmp    801cd7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801caf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cb3:	75 15                	jne    801cca <strtol+0x93>
  801cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb8:	8a 00                	mov    (%eax),%al
  801cba:	3c 30                	cmp    $0x30,%al
  801cbc:	75 0c                	jne    801cca <strtol+0x93>
		s++, base = 8;
  801cbe:	ff 45 08             	incl   0x8(%ebp)
  801cc1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801cc8:	eb 0d                	jmp    801cd7 <strtol+0xa0>
	else if (base == 0)
  801cca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cce:	75 07                	jne    801cd7 <strtol+0xa0>
		base = 10;
  801cd0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	8a 00                	mov    (%eax),%al
  801cdc:	3c 2f                	cmp    $0x2f,%al
  801cde:	7e 19                	jle    801cf9 <strtol+0xc2>
  801ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce3:	8a 00                	mov    (%eax),%al
  801ce5:	3c 39                	cmp    $0x39,%al
  801ce7:	7f 10                	jg     801cf9 <strtol+0xc2>
			dig = *s - '0';
  801ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cec:	8a 00                	mov    (%eax),%al
  801cee:	0f be c0             	movsbl %al,%eax
  801cf1:	83 e8 30             	sub    $0x30,%eax
  801cf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cf7:	eb 42                	jmp    801d3b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfc:	8a 00                	mov    (%eax),%al
  801cfe:	3c 60                	cmp    $0x60,%al
  801d00:	7e 19                	jle    801d1b <strtol+0xe4>
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	8a 00                	mov    (%eax),%al
  801d07:	3c 7a                	cmp    $0x7a,%al
  801d09:	7f 10                	jg     801d1b <strtol+0xe4>
			dig = *s - 'a' + 10;
  801d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0e:	8a 00                	mov    (%eax),%al
  801d10:	0f be c0             	movsbl %al,%eax
  801d13:	83 e8 57             	sub    $0x57,%eax
  801d16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d19:	eb 20                	jmp    801d3b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1e:	8a 00                	mov    (%eax),%al
  801d20:	3c 40                	cmp    $0x40,%al
  801d22:	7e 39                	jle    801d5d <strtol+0x126>
  801d24:	8b 45 08             	mov    0x8(%ebp),%eax
  801d27:	8a 00                	mov    (%eax),%al
  801d29:	3c 5a                	cmp    $0x5a,%al
  801d2b:	7f 30                	jg     801d5d <strtol+0x126>
			dig = *s - 'A' + 10;
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	8a 00                	mov    (%eax),%al
  801d32:	0f be c0             	movsbl %al,%eax
  801d35:	83 e8 37             	sub    $0x37,%eax
  801d38:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801d41:	7d 19                	jge    801d5c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801d43:	ff 45 08             	incl   0x8(%ebp)
  801d46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d49:	0f af 45 10          	imul   0x10(%ebp),%eax
  801d4d:	89 c2                	mov    %eax,%edx
  801d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d52:	01 d0                	add    %edx,%eax
  801d54:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801d57:	e9 7b ff ff ff       	jmp    801cd7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801d5c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801d5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d61:	74 08                	je     801d6b <strtol+0x134>
		*endptr = (char *) s;
  801d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d66:	8b 55 08             	mov    0x8(%ebp),%edx
  801d69:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801d6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d6f:	74 07                	je     801d78 <strtol+0x141>
  801d71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d74:	f7 d8                	neg    %eax
  801d76:	eb 03                	jmp    801d7b <strtol+0x144>
  801d78:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <ltostr>:

void
ltostr(long value, char *str)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
  801d80:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801d83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801d8a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801d91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d95:	79 13                	jns    801daa <ltostr+0x2d>
	{
		neg = 1;
  801d97:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801da4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801da7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801daa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dad:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801db2:	99                   	cltd   
  801db3:	f7 f9                	idiv   %ecx
  801db5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801db8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dbb:	8d 50 01             	lea    0x1(%eax),%edx
  801dbe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801dc1:	89 c2                	mov    %eax,%edx
  801dc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc6:	01 d0                	add    %edx,%eax
  801dc8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801dcb:	83 c2 30             	add    $0x30,%edx
  801dce:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801dd0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dd3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801dd8:	f7 e9                	imul   %ecx
  801dda:	c1 fa 02             	sar    $0x2,%edx
  801ddd:	89 c8                	mov    %ecx,%eax
  801ddf:	c1 f8 1f             	sar    $0x1f,%eax
  801de2:	29 c2                	sub    %eax,%edx
  801de4:	89 d0                	mov    %edx,%eax
  801de6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801de9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ded:	75 bb                	jne    801daa <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801def:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801df6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801df9:	48                   	dec    %eax
  801dfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801dfd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801e01:	74 3d                	je     801e40 <ltostr+0xc3>
		start = 1 ;
  801e03:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801e0a:	eb 34                	jmp    801e40 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801e0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e12:	01 d0                	add    %edx,%eax
  801e14:	8a 00                	mov    (%eax),%al
  801e16:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801e19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1f:	01 c2                	add    %eax,%edx
  801e21:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e27:	01 c8                	add    %ecx,%eax
  801e29:	8a 00                	mov    (%eax),%al
  801e2b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801e2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e33:	01 c2                	add    %eax,%edx
  801e35:	8a 45 eb             	mov    -0x15(%ebp),%al
  801e38:	88 02                	mov    %al,(%edx)
		start++ ;
  801e3a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801e3d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e43:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e46:	7c c4                	jl     801e0c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801e48:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4e:	01 d0                	add    %edx,%eax
  801e50:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801e53:	90                   	nop
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801e5c:	ff 75 08             	pushl  0x8(%ebp)
  801e5f:	e8 73 fa ff ff       	call   8018d7 <strlen>
  801e64:	83 c4 04             	add    $0x4,%esp
  801e67:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801e6a:	ff 75 0c             	pushl  0xc(%ebp)
  801e6d:	e8 65 fa ff ff       	call   8018d7 <strlen>
  801e72:	83 c4 04             	add    $0x4,%esp
  801e75:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801e78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801e7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801e86:	eb 17                	jmp    801e9f <strcconcat+0x49>
		final[s] = str1[s] ;
  801e88:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e8e:	01 c2                	add    %eax,%edx
  801e90:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801e93:	8b 45 08             	mov    0x8(%ebp),%eax
  801e96:	01 c8                	add    %ecx,%eax
  801e98:	8a 00                	mov    (%eax),%al
  801e9a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801e9c:	ff 45 fc             	incl   -0x4(%ebp)
  801e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ea2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801ea5:	7c e1                	jl     801e88 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801ea7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801eae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801eb5:	eb 1f                	jmp    801ed6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801eb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eba:	8d 50 01             	lea    0x1(%eax),%edx
  801ebd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ec0:	89 c2                	mov    %eax,%edx
  801ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec5:	01 c2                	add    %eax,%edx
  801ec7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ecd:	01 c8                	add    %ecx,%eax
  801ecf:	8a 00                	mov    (%eax),%al
  801ed1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801ed3:	ff 45 f8             	incl   -0x8(%ebp)
  801ed6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ed9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801edc:	7c d9                	jl     801eb7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801ede:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ee1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee4:	01 d0                	add    %edx,%eax
  801ee6:	c6 00 00             	movb   $0x0,(%eax)
}
  801ee9:	90                   	nop
  801eea:	c9                   	leave  
  801eeb:	c3                   	ret    

00801eec <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801eef:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801ef8:	8b 45 14             	mov    0x14(%ebp),%eax
  801efb:	8b 00                	mov    (%eax),%eax
  801efd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f04:	8b 45 10             	mov    0x10(%ebp),%eax
  801f07:	01 d0                	add    %edx,%eax
  801f09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801f0f:	eb 0c                	jmp    801f1d <strsplit+0x31>
			*string++ = 0;
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	8d 50 01             	lea    0x1(%eax),%edx
  801f17:	89 55 08             	mov    %edx,0x8(%ebp)
  801f1a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f20:	8a 00                	mov    (%eax),%al
  801f22:	84 c0                	test   %al,%al
  801f24:	74 18                	je     801f3e <strsplit+0x52>
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	8a 00                	mov    (%eax),%al
  801f2b:	0f be c0             	movsbl %al,%eax
  801f2e:	50                   	push   %eax
  801f2f:	ff 75 0c             	pushl  0xc(%ebp)
  801f32:	e8 32 fb ff ff       	call   801a69 <strchr>
  801f37:	83 c4 08             	add    $0x8,%esp
  801f3a:	85 c0                	test   %eax,%eax
  801f3c:	75 d3                	jne    801f11 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f41:	8a 00                	mov    (%eax),%al
  801f43:	84 c0                	test   %al,%al
  801f45:	74 5a                	je     801fa1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801f47:	8b 45 14             	mov    0x14(%ebp),%eax
  801f4a:	8b 00                	mov    (%eax),%eax
  801f4c:	83 f8 0f             	cmp    $0xf,%eax
  801f4f:	75 07                	jne    801f58 <strsplit+0x6c>
		{
			return 0;
  801f51:	b8 00 00 00 00       	mov    $0x0,%eax
  801f56:	eb 66                	jmp    801fbe <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801f58:	8b 45 14             	mov    0x14(%ebp),%eax
  801f5b:	8b 00                	mov    (%eax),%eax
  801f5d:	8d 48 01             	lea    0x1(%eax),%ecx
  801f60:	8b 55 14             	mov    0x14(%ebp),%edx
  801f63:	89 0a                	mov    %ecx,(%edx)
  801f65:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f6c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f6f:	01 c2                	add    %eax,%edx
  801f71:	8b 45 08             	mov    0x8(%ebp),%eax
  801f74:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f76:	eb 03                	jmp    801f7b <strsplit+0x8f>
			string++;
  801f78:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7e:	8a 00                	mov    (%eax),%al
  801f80:	84 c0                	test   %al,%al
  801f82:	74 8b                	je     801f0f <strsplit+0x23>
  801f84:	8b 45 08             	mov    0x8(%ebp),%eax
  801f87:	8a 00                	mov    (%eax),%al
  801f89:	0f be c0             	movsbl %al,%eax
  801f8c:	50                   	push   %eax
  801f8d:	ff 75 0c             	pushl  0xc(%ebp)
  801f90:	e8 d4 fa ff ff       	call   801a69 <strchr>
  801f95:	83 c4 08             	add    $0x8,%esp
  801f98:	85 c0                	test   %eax,%eax
  801f9a:	74 dc                	je     801f78 <strsplit+0x8c>
			string++;
	}
  801f9c:	e9 6e ff ff ff       	jmp    801f0f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801fa1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801fa2:	8b 45 14             	mov    0x14(%ebp),%eax
  801fa5:	8b 00                	mov    (%eax),%eax
  801fa7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801fae:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb1:	01 d0                	add    %edx,%eax
  801fb3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801fb9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    

00801fc0 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
  801fc3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801fc6:	83 ec 04             	sub    $0x4,%esp
  801fc9:	68 48 49 80 00       	push   $0x804948
  801fce:	68 3f 01 00 00       	push   $0x13f
  801fd3:	68 6a 49 80 00       	push   $0x80496a
  801fd8:	e8 a9 ef ff ff       	call   800f86 <_panic>

00801fdd <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
  801fe0:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801fe3:	83 ec 0c             	sub    $0xc,%esp
  801fe6:	ff 75 08             	pushl  0x8(%ebp)
  801fe9:	e8 90 0c 00 00       	call   802c7e <sys_sbrk>
  801fee:	83 c4 10             	add    $0x10,%esp
}
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
  801ff6:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801ff9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ffd:	75 0a                	jne    802009 <malloc+0x16>
		return NULL;
  801fff:	b8 00 00 00 00       	mov    $0x0,%eax
  802004:	e9 9e 01 00 00       	jmp    8021a7 <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  802009:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802010:	77 2c                	ja     80203e <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  802012:	e8 eb 0a 00 00       	call   802b02 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802017:	85 c0                	test   %eax,%eax
  802019:	74 19                	je     802034 <malloc+0x41>

			void * block = alloc_block_FF(size);
  80201b:	83 ec 0c             	sub    $0xc,%esp
  80201e:	ff 75 08             	pushl  0x8(%ebp)
  802021:	e8 85 11 00 00       	call   8031ab <alloc_block_FF>
  802026:	83 c4 10             	add    $0x10,%esp
  802029:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  80202c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80202f:	e9 73 01 00 00       	jmp    8021a7 <malloc+0x1b4>
		} else {
			return NULL;
  802034:	b8 00 00 00 00       	mov    $0x0,%eax
  802039:	e9 69 01 00 00       	jmp    8021a7 <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  80203e:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802045:	8b 55 08             	mov    0x8(%ebp),%edx
  802048:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80204b:	01 d0                	add    %edx,%eax
  80204d:	48                   	dec    %eax
  80204e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802051:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802054:	ba 00 00 00 00       	mov    $0x0,%edx
  802059:	f7 75 e0             	divl   -0x20(%ebp)
  80205c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80205f:	29 d0                	sub    %edx,%eax
  802061:	c1 e8 0c             	shr    $0xc,%eax
  802064:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  802067:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  80206e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  802075:	a1 20 50 80 00       	mov    0x805020,%eax
  80207a:	8b 40 7c             	mov    0x7c(%eax),%eax
  80207d:	05 00 10 00 00       	add    $0x1000,%eax
  802082:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  802085:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80208a:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80208d:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  802090:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802097:	8b 55 08             	mov    0x8(%ebp),%edx
  80209a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80209d:	01 d0                	add    %edx,%eax
  80209f:	48                   	dec    %eax
  8020a0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8020a3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8020a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8020ab:	f7 75 cc             	divl   -0x34(%ebp)
  8020ae:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8020b1:	29 d0                	sub    %edx,%eax
  8020b3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8020b6:	76 0a                	jbe    8020c2 <malloc+0xcf>
		return NULL;
  8020b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bd:	e9 e5 00 00 00       	jmp    8021a7 <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  8020c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8020c8:	eb 48                	jmp    802112 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  8020ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020cd:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8020d0:	c1 e8 0c             	shr    $0xc,%eax
  8020d3:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  8020d6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8020d9:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8020e0:	85 c0                	test   %eax,%eax
  8020e2:	75 11                	jne    8020f5 <malloc+0x102>
			freePagesCount++;
  8020e4:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8020e7:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8020eb:	75 16                	jne    802103 <malloc+0x110>
				start = i;
  8020ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020f3:	eb 0e                	jmp    802103 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  8020f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8020fc:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  802103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802106:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802109:	74 12                	je     80211d <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  80210b:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  802112:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  802119:	76 af                	jbe    8020ca <malloc+0xd7>
  80211b:	eb 01                	jmp    80211e <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  80211d:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  80211e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802122:	74 08                	je     80212c <malloc+0x139>
  802124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802127:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80212a:	74 07                	je     802133 <malloc+0x140>
		return NULL;
  80212c:	b8 00 00 00 00       	mov    $0x0,%eax
  802131:	eb 74                	jmp    8021a7 <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  802133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802136:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802139:	c1 e8 0c             	shr    $0xc,%eax
  80213c:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  80213f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802142:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802145:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  80214c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80214f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802152:	eb 11                	jmp    802165 <malloc+0x172>
		markedPages[i] = 1;
  802154:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802157:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  80215e:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  802162:	ff 45 e8             	incl   -0x18(%ebp)
  802165:	8b 55 c0             	mov    -0x40(%ebp),%edx
  802168:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80216b:	01 d0                	add    %edx,%eax
  80216d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802170:	77 e2                	ja     802154 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  802172:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802179:	8b 55 08             	mov    0x8(%ebp),%edx
  80217c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80217f:	01 d0                	add    %edx,%eax
  802181:	48                   	dec    %eax
  802182:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802185:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802188:	ba 00 00 00 00       	mov    $0x0,%edx
  80218d:	f7 75 bc             	divl   -0x44(%ebp)
  802190:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802193:	29 d0                	sub    %edx,%eax
  802195:	83 ec 08             	sub    $0x8,%esp
  802198:	50                   	push   %eax
  802199:	ff 75 f0             	pushl  -0x10(%ebp)
  80219c:	e8 14 0b 00 00       	call   802cb5 <sys_allocate_user_mem>
  8021a1:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  8021a4:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  8021a7:	c9                   	leave  
  8021a8:	c3                   	ret    

008021a9 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  8021af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021b3:	0f 84 ee 00 00 00    	je     8022a7 <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  8021b9:	a1 20 50 80 00       	mov    0x805020,%eax
  8021be:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  8021c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021c4:	77 09                	ja     8021cf <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  8021c6:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  8021cd:	76 14                	jbe    8021e3 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  8021cf:	83 ec 04             	sub    $0x4,%esp
  8021d2:	68 78 49 80 00       	push   $0x804978
  8021d7:	6a 68                	push   $0x68
  8021d9:	68 92 49 80 00       	push   $0x804992
  8021de:	e8 a3 ed ff ff       	call   800f86 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  8021e3:	a1 20 50 80 00       	mov    0x805020,%eax
  8021e8:	8b 40 74             	mov    0x74(%eax),%eax
  8021eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021ee:	77 20                	ja     802210 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  8021f0:	a1 20 50 80 00       	mov    0x805020,%eax
  8021f5:	8b 40 78             	mov    0x78(%eax),%eax
  8021f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021fb:	76 13                	jbe    802210 <free+0x67>
		free_block(virtual_address);
  8021fd:	83 ec 0c             	sub    $0xc,%esp
  802200:	ff 75 08             	pushl  0x8(%ebp)
  802203:	e8 6c 16 00 00       	call   803874 <free_block>
  802208:	83 c4 10             	add    $0x10,%esp
		return;
  80220b:	e9 98 00 00 00       	jmp    8022a8 <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  802210:	8b 55 08             	mov    0x8(%ebp),%edx
  802213:	a1 20 50 80 00       	mov    0x805020,%eax
  802218:	8b 40 7c             	mov    0x7c(%eax),%eax
  80221b:	29 c2                	sub    %eax,%edx
  80221d:	89 d0                	mov    %edx,%eax
  80221f:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  802224:	c1 e8 0c             	shr    $0xc,%eax
  802227:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  80222a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802231:	eb 16                	jmp    802249 <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  802233:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802236:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802239:	01 d0                	add    %edx,%eax
  80223b:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  802242:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  802246:	ff 45 f4             	incl   -0xc(%ebp)
  802249:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80224c:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  802253:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802256:	7f db                	jg     802233 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  802258:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80225b:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  802262:	c1 e0 0c             	shl    $0xc,%eax
  802265:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  802268:	8b 45 08             	mov    0x8(%ebp),%eax
  80226b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80226e:	eb 1a                	jmp    80228a <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  802270:	83 ec 08             	sub    $0x8,%esp
  802273:	68 00 10 00 00       	push   $0x1000
  802278:	ff 75 f0             	pushl  -0x10(%ebp)
  80227b:	e8 19 0a 00 00       	call   802c99 <sys_free_user_mem>
  802280:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  802283:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  80228a:	8b 55 08             	mov    0x8(%ebp),%edx
  80228d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802290:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  802292:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802295:	77 d9                	ja     802270 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  802297:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229a:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  8022a1:	00 00 00 00 
  8022a5:	eb 01                	jmp    8022a8 <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  8022a7:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  8022a8:	c9                   	leave  
  8022a9:	c3                   	ret    

008022aa <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
  8022ad:	83 ec 58             	sub    $0x58,%esp
  8022b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8022b3:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8022b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022ba:	75 0a                	jne    8022c6 <smalloc+0x1c>
		return NULL;
  8022bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c1:	e9 7d 01 00 00       	jmp    802443 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8022c6:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8022cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022d3:	01 d0                	add    %edx,%eax
  8022d5:	48                   	dec    %eax
  8022d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8022d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8022e1:	f7 75 e4             	divl   -0x1c(%ebp)
  8022e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022e7:	29 d0                	sub    %edx,%eax
  8022e9:	c1 e8 0c             	shr    $0xc,%eax
  8022ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  8022ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8022f6:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8022fd:	a1 20 50 80 00       	mov    0x805020,%eax
  802302:	8b 40 7c             	mov    0x7c(%eax),%eax
  802305:	05 00 10 00 00       	add    $0x1000,%eax
  80230a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  80230d:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802312:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802315:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  802318:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80231f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802322:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802325:	01 d0                	add    %edx,%eax
  802327:	48                   	dec    %eax
  802328:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80232b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80232e:	ba 00 00 00 00       	mov    $0x0,%edx
  802333:	f7 75 d0             	divl   -0x30(%ebp)
  802336:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802339:	29 d0                	sub    %edx,%eax
  80233b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80233e:	76 0a                	jbe    80234a <smalloc+0xa0>
		return NULL;
  802340:	b8 00 00 00 00       	mov    $0x0,%eax
  802345:	e9 f9 00 00 00       	jmp    802443 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80234a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80234d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802350:	eb 48                	jmp    80239a <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  802352:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802355:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802358:	c1 e8 0c             	shr    $0xc,%eax
  80235b:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  80235e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802361:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  802368:	85 c0                	test   %eax,%eax
  80236a:	75 11                	jne    80237d <smalloc+0xd3>
			freePagesCount++;
  80236c:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  80236f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802373:	75 16                	jne    80238b <smalloc+0xe1>
				start = s;
  802375:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802378:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80237b:	eb 0e                	jmp    80238b <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  80237d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  802384:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  80238b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802391:	74 12                	je     8023a5 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  802393:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  80239a:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8023a1:	76 af                	jbe    802352 <smalloc+0xa8>
  8023a3:	eb 01                	jmp    8023a6 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  8023a5:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  8023a6:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8023aa:	74 08                	je     8023b4 <smalloc+0x10a>
  8023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023af:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8023b2:	74 0a                	je     8023be <smalloc+0x114>
		return NULL;
  8023b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b9:	e9 85 00 00 00       	jmp    802443 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8023be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c1:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8023c4:	c1 e8 0c             	shr    $0xc,%eax
  8023c7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  8023ca:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8023cd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8023d0:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8023d7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8023da:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8023dd:	eb 11                	jmp    8023f0 <smalloc+0x146>
		markedPages[s] = 1;
  8023df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023e2:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  8023e9:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8023ed:	ff 45 e8             	incl   -0x18(%ebp)
  8023f0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8023f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023f6:	01 d0                	add    %edx,%eax
  8023f8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8023fb:	77 e2                	ja     8023df <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  8023fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802400:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  802404:	52                   	push   %edx
  802405:	50                   	push   %eax
  802406:	ff 75 0c             	pushl  0xc(%ebp)
  802409:	ff 75 08             	pushl  0x8(%ebp)
  80240c:	e8 8f 04 00 00       	call   8028a0 <sys_createSharedObject>
  802411:	83 c4 10             	add    $0x10,%esp
  802414:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  802417:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  80241b:	78 12                	js     80242f <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  80241d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802420:	8b 55 c0             	mov    -0x40(%ebp),%edx
  802423:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  80242a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242d:	eb 14                	jmp    802443 <smalloc+0x199>
	}
	free((void*) start);
  80242f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802432:	83 ec 0c             	sub    $0xc,%esp
  802435:	50                   	push   %eax
  802436:	e8 6e fd ff ff       	call   8021a9 <free>
  80243b:	83 c4 10             	add    $0x10,%esp
	return NULL;
  80243e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802443:	c9                   	leave  
  802444:	c3                   	ret    

00802445 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  802445:	55                   	push   %ebp
  802446:	89 e5                	mov    %esp,%ebp
  802448:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  80244b:	83 ec 08             	sub    $0x8,%esp
  80244e:	ff 75 0c             	pushl  0xc(%ebp)
  802451:	ff 75 08             	pushl  0x8(%ebp)
  802454:	e8 71 04 00 00       	call   8028ca <sys_getSizeOfSharedObject>
  802459:	83 c4 10             	add    $0x10,%esp
  80245c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  80245f:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802466:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802469:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80246c:	01 d0                	add    %edx,%eax
  80246e:	48                   	dec    %eax
  80246f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802472:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802475:	ba 00 00 00 00       	mov    $0x0,%edx
  80247a:	f7 75 e0             	divl   -0x20(%ebp)
  80247d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802480:	29 d0                	sub    %edx,%eax
  802482:	c1 e8 0c             	shr    $0xc,%eax
  802485:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  802488:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  80248f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  802496:	a1 20 50 80 00       	mov    0x805020,%eax
  80249b:	8b 40 7c             	mov    0x7c(%eax),%eax
  80249e:	05 00 10 00 00       	add    $0x1000,%eax
  8024a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  8024a6:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8024ab:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8024ae:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  8024b1:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8024b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024bb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8024be:	01 d0                	add    %edx,%eax
  8024c0:	48                   	dec    %eax
  8024c1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8024c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8024c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8024cc:	f7 75 cc             	divl   -0x34(%ebp)
  8024cf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8024d2:	29 d0                	sub    %edx,%eax
  8024d4:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8024d7:	76 0a                	jbe    8024e3 <sget+0x9e>
		return NULL;
  8024d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024de:	e9 f7 00 00 00       	jmp    8025da <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8024e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8024e9:	eb 48                	jmp    802533 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  8024eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ee:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8024f1:	c1 e8 0c             	shr    $0xc,%eax
  8024f4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  8024f7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8024fa:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  802501:	85 c0                	test   %eax,%eax
  802503:	75 11                	jne    802516 <sget+0xd1>
			free_Pages_Count++;
  802505:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  802508:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80250c:	75 16                	jne    802524 <sget+0xdf>
				start = s;
  80250e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802511:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802514:	eb 0e                	jmp    802524 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  802516:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80251d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80252a:	74 12                	je     80253e <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80252c:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  802533:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80253a:	76 af                	jbe    8024eb <sget+0xa6>
  80253c:	eb 01                	jmp    80253f <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  80253e:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  80253f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802543:	74 08                	je     80254d <sget+0x108>
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80254b:	74 0a                	je     802557 <sget+0x112>
		return NULL;
  80254d:	b8 00 00 00 00       	mov    $0x0,%eax
  802552:	e9 83 00 00 00       	jmp    8025da <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  802557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255a:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80255d:	c1 e8 0c             	shr    $0xc,%eax
  802560:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  802563:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802566:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802569:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  802570:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802573:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802576:	eb 11                	jmp    802589 <sget+0x144>
		markedPages[k] = 1;
  802578:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80257b:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  802582:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  802586:	ff 45 e8             	incl   -0x18(%ebp)
  802589:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80258c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80258f:	01 d0                	add    %edx,%eax
  802591:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802594:	77 e2                	ja     802578 <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  802596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802599:	83 ec 04             	sub    $0x4,%esp
  80259c:	50                   	push   %eax
  80259d:	ff 75 0c             	pushl  0xc(%ebp)
  8025a0:	ff 75 08             	pushl  0x8(%ebp)
  8025a3:	e8 3f 03 00 00       	call   8028e7 <sys_getSharedObject>
  8025a8:	83 c4 10             	add    $0x10,%esp
  8025ab:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  8025ae:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  8025b2:	78 12                	js     8025c6 <sget+0x181>
		shardIDs[startPage] = ss;
  8025b4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8025b7:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8025ba:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  8025c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c4:	eb 14                	jmp    8025da <sget+0x195>
	}
	free((void*) start);
  8025c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c9:	83 ec 0c             	sub    $0xc,%esp
  8025cc:	50                   	push   %eax
  8025cd:	e8 d7 fb ff ff       	call   8021a9 <free>
  8025d2:	83 c4 10             	add    $0x10,%esp
	return NULL;
  8025d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025da:	c9                   	leave  
  8025db:	c3                   	ret    

008025dc <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
  8025df:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8025e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8025e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8025ea:	8b 40 7c             	mov    0x7c(%eax),%eax
  8025ed:	29 c2                	sub    %eax,%edx
  8025ef:	89 d0                	mov    %edx,%eax
  8025f1:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  8025f6:	c1 e8 0c             	shr    $0xc,%eax
  8025f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  8025fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ff:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  802606:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  802609:	83 ec 08             	sub    $0x8,%esp
  80260c:	ff 75 08             	pushl  0x8(%ebp)
  80260f:	ff 75 f0             	pushl  -0x10(%ebp)
  802612:	e8 ef 02 00 00       	call   802906 <sys_freeSharedObject>
  802617:	83 c4 10             	add    $0x10,%esp
  80261a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  80261d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802621:	75 0e                	jne    802631 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  802623:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802626:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  80262d:	ff ff ff ff 
	}

}
  802631:	90                   	nop
  802632:	c9                   	leave  
  802633:	c3                   	ret    

00802634 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  802634:	55                   	push   %ebp
  802635:	89 e5                	mov    %esp,%ebp
  802637:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80263a:	83 ec 04             	sub    $0x4,%esp
  80263d:	68 a0 49 80 00       	push   $0x8049a0
  802642:	68 19 01 00 00       	push   $0x119
  802647:	68 92 49 80 00       	push   $0x804992
  80264c:	e8 35 e9 ff ff       	call   800f86 <_panic>

00802651 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  802651:	55                   	push   %ebp
  802652:	89 e5                	mov    %esp,%ebp
  802654:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802657:	83 ec 04             	sub    $0x4,%esp
  80265a:	68 c6 49 80 00       	push   $0x8049c6
  80265f:	68 23 01 00 00       	push   $0x123
  802664:	68 92 49 80 00       	push   $0x804992
  802669:	e8 18 e9 ff ff       	call   800f86 <_panic>

0080266e <shrink>:

}
void shrink(uint32 newSize) {
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
  802671:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802674:	83 ec 04             	sub    $0x4,%esp
  802677:	68 c6 49 80 00       	push   $0x8049c6
  80267c:	68 27 01 00 00       	push   $0x127
  802681:	68 92 49 80 00       	push   $0x804992
  802686:	e8 fb e8 ff ff       	call   800f86 <_panic>

0080268b <freeHeap>:

}
void freeHeap(void* virtual_address) {
  80268b:	55                   	push   %ebp
  80268c:	89 e5                	mov    %esp,%ebp
  80268e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802691:	83 ec 04             	sub    $0x4,%esp
  802694:	68 c6 49 80 00       	push   $0x8049c6
  802699:	68 2b 01 00 00       	push   $0x12b
  80269e:	68 92 49 80 00       	push   $0x804992
  8026a3:	e8 de e8 ff ff       	call   800f86 <_panic>

008026a8 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8026a8:	55                   	push   %ebp
  8026a9:	89 e5                	mov    %esp,%ebp
  8026ab:	57                   	push   %edi
  8026ac:	56                   	push   %esi
  8026ad:	53                   	push   %ebx
  8026ae:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8026b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026bd:	8b 7d 18             	mov    0x18(%ebp),%edi
  8026c0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8026c3:	cd 30                	int    $0x30
  8026c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  8026c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8026cb:	83 c4 10             	add    $0x10,%esp
  8026ce:	5b                   	pop    %ebx
  8026cf:	5e                   	pop    %esi
  8026d0:	5f                   	pop    %edi
  8026d1:	5d                   	pop    %ebp
  8026d2:	c3                   	ret    

008026d3 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8026d3:	55                   	push   %ebp
  8026d4:	89 e5                	mov    %esp,%ebp
  8026d6:	83 ec 04             	sub    $0x4,%esp
  8026d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8026dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8026df:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8026e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 00                	push   $0x0
  8026ea:	52                   	push   %edx
  8026eb:	ff 75 0c             	pushl  0xc(%ebp)
  8026ee:	50                   	push   %eax
  8026ef:	6a 00                	push   $0x0
  8026f1:	e8 b2 ff ff ff       	call   8026a8 <syscall>
  8026f6:	83 c4 18             	add    $0x18,%esp
}
  8026f9:	90                   	nop
  8026fa:	c9                   	leave  
  8026fb:	c3                   	ret    

008026fc <sys_cgetc>:

int sys_cgetc(void) {
  8026fc:	55                   	push   %ebp
  8026fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8026ff:	6a 00                	push   $0x0
  802701:	6a 00                	push   $0x0
  802703:	6a 00                	push   $0x0
  802705:	6a 00                	push   $0x0
  802707:	6a 00                	push   $0x0
  802709:	6a 02                	push   $0x2
  80270b:	e8 98 ff ff ff       	call   8026a8 <syscall>
  802710:	83 c4 18             	add    $0x18,%esp
}
  802713:	c9                   	leave  
  802714:	c3                   	ret    

00802715 <sys_lock_cons>:

void sys_lock_cons(void) {
  802715:	55                   	push   %ebp
  802716:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802718:	6a 00                	push   $0x0
  80271a:	6a 00                	push   $0x0
  80271c:	6a 00                	push   $0x0
  80271e:	6a 00                	push   $0x0
  802720:	6a 00                	push   $0x0
  802722:	6a 03                	push   $0x3
  802724:	e8 7f ff ff ff       	call   8026a8 <syscall>
  802729:	83 c4 18             	add    $0x18,%esp
}
  80272c:	90                   	nop
  80272d:	c9                   	leave  
  80272e:	c3                   	ret    

0080272f <sys_unlock_cons>:
void sys_unlock_cons(void) {
  80272f:	55                   	push   %ebp
  802730:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802732:	6a 00                	push   $0x0
  802734:	6a 00                	push   $0x0
  802736:	6a 00                	push   $0x0
  802738:	6a 00                	push   $0x0
  80273a:	6a 00                	push   $0x0
  80273c:	6a 04                	push   $0x4
  80273e:	e8 65 ff ff ff       	call   8026a8 <syscall>
  802743:	83 c4 18             	add    $0x18,%esp
}
  802746:	90                   	nop
  802747:	c9                   	leave  
  802748:	c3                   	ret    

00802749 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  802749:	55                   	push   %ebp
  80274a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  80274c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80274f:	8b 45 08             	mov    0x8(%ebp),%eax
  802752:	6a 00                	push   $0x0
  802754:	6a 00                	push   $0x0
  802756:	6a 00                	push   $0x0
  802758:	52                   	push   %edx
  802759:	50                   	push   %eax
  80275a:	6a 08                	push   $0x8
  80275c:	e8 47 ff ff ff       	call   8026a8 <syscall>
  802761:	83 c4 18             	add    $0x18,%esp
}
  802764:	c9                   	leave  
  802765:	c3                   	ret    

00802766 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  802766:	55                   	push   %ebp
  802767:	89 e5                	mov    %esp,%ebp
  802769:	56                   	push   %esi
  80276a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  80276b:	8b 75 18             	mov    0x18(%ebp),%esi
  80276e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802771:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802774:	8b 55 0c             	mov    0xc(%ebp),%edx
  802777:	8b 45 08             	mov    0x8(%ebp),%eax
  80277a:	56                   	push   %esi
  80277b:	53                   	push   %ebx
  80277c:	51                   	push   %ecx
  80277d:	52                   	push   %edx
  80277e:	50                   	push   %eax
  80277f:	6a 09                	push   $0x9
  802781:	e8 22 ff ff ff       	call   8026a8 <syscall>
  802786:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  802789:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80278c:	5b                   	pop    %ebx
  80278d:	5e                   	pop    %esi
  80278e:	5d                   	pop    %ebp
  80278f:	c3                   	ret    

00802790 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  802790:	55                   	push   %ebp
  802791:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802793:	8b 55 0c             	mov    0xc(%ebp),%edx
  802796:	8b 45 08             	mov    0x8(%ebp),%eax
  802799:	6a 00                	push   $0x0
  80279b:	6a 00                	push   $0x0
  80279d:	6a 00                	push   $0x0
  80279f:	52                   	push   %edx
  8027a0:	50                   	push   %eax
  8027a1:	6a 0a                	push   $0xa
  8027a3:	e8 00 ff ff ff       	call   8026a8 <syscall>
  8027a8:	83 c4 18             	add    $0x18,%esp
}
  8027ab:	c9                   	leave  
  8027ac:	c3                   	ret    

008027ad <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  8027ad:	55                   	push   %ebp
  8027ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  8027b0:	6a 00                	push   $0x0
  8027b2:	6a 00                	push   $0x0
  8027b4:	6a 00                	push   $0x0
  8027b6:	ff 75 0c             	pushl  0xc(%ebp)
  8027b9:	ff 75 08             	pushl  0x8(%ebp)
  8027bc:	6a 0b                	push   $0xb
  8027be:	e8 e5 fe ff ff       	call   8026a8 <syscall>
  8027c3:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  8027c6:	c9                   	leave  
  8027c7:	c3                   	ret    

008027c8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  8027c8:	55                   	push   %ebp
  8027c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8027cb:	6a 00                	push   $0x0
  8027cd:	6a 00                	push   $0x0
  8027cf:	6a 00                	push   $0x0
  8027d1:	6a 00                	push   $0x0
  8027d3:	6a 00                	push   $0x0
  8027d5:	6a 0c                	push   $0xc
  8027d7:	e8 cc fe ff ff       	call   8026a8 <syscall>
  8027dc:	83 c4 18             	add    $0x18,%esp
}
  8027df:	c9                   	leave  
  8027e0:	c3                   	ret    

008027e1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  8027e1:	55                   	push   %ebp
  8027e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8027e4:	6a 00                	push   $0x0
  8027e6:	6a 00                	push   $0x0
  8027e8:	6a 00                	push   $0x0
  8027ea:	6a 00                	push   $0x0
  8027ec:	6a 00                	push   $0x0
  8027ee:	6a 0d                	push   $0xd
  8027f0:	e8 b3 fe ff ff       	call   8026a8 <syscall>
  8027f5:	83 c4 18             	add    $0x18,%esp
}
  8027f8:	c9                   	leave  
  8027f9:	c3                   	ret    

008027fa <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  8027fa:	55                   	push   %ebp
  8027fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8027fd:	6a 00                	push   $0x0
  8027ff:	6a 00                	push   $0x0
  802801:	6a 00                	push   $0x0
  802803:	6a 00                	push   $0x0
  802805:	6a 00                	push   $0x0
  802807:	6a 0e                	push   $0xe
  802809:	e8 9a fe ff ff       	call   8026a8 <syscall>
  80280e:	83 c4 18             	add    $0x18,%esp
}
  802811:	c9                   	leave  
  802812:	c3                   	ret    

00802813 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  802813:	55                   	push   %ebp
  802814:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  802816:	6a 00                	push   $0x0
  802818:	6a 00                	push   $0x0
  80281a:	6a 00                	push   $0x0
  80281c:	6a 00                	push   $0x0
  80281e:	6a 00                	push   $0x0
  802820:	6a 0f                	push   $0xf
  802822:	e8 81 fe ff ff       	call   8026a8 <syscall>
  802827:	83 c4 18             	add    $0x18,%esp
}
  80282a:	c9                   	leave  
  80282b:	c3                   	ret    

0080282c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  80282c:	55                   	push   %ebp
  80282d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  80282f:	6a 00                	push   $0x0
  802831:	6a 00                	push   $0x0
  802833:	6a 00                	push   $0x0
  802835:	6a 00                	push   $0x0
  802837:	ff 75 08             	pushl  0x8(%ebp)
  80283a:	6a 10                	push   $0x10
  80283c:	e8 67 fe ff ff       	call   8026a8 <syscall>
  802841:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  802844:	c9                   	leave  
  802845:	c3                   	ret    

00802846 <sys_scarce_memory>:

void sys_scarce_memory() {
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  802849:	6a 00                	push   $0x0
  80284b:	6a 00                	push   $0x0
  80284d:	6a 00                	push   $0x0
  80284f:	6a 00                	push   $0x0
  802851:	6a 00                	push   $0x0
  802853:	6a 11                	push   $0x11
  802855:	e8 4e fe ff ff       	call   8026a8 <syscall>
  80285a:	83 c4 18             	add    $0x18,%esp
}
  80285d:	90                   	nop
  80285e:	c9                   	leave  
  80285f:	c3                   	ret    

00802860 <sys_cputc>:

void sys_cputc(const char c) {
  802860:	55                   	push   %ebp
  802861:	89 e5                	mov    %esp,%ebp
  802863:	83 ec 04             	sub    $0x4,%esp
  802866:	8b 45 08             	mov    0x8(%ebp),%eax
  802869:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80286c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802870:	6a 00                	push   $0x0
  802872:	6a 00                	push   $0x0
  802874:	6a 00                	push   $0x0
  802876:	6a 00                	push   $0x0
  802878:	50                   	push   %eax
  802879:	6a 01                	push   $0x1
  80287b:	e8 28 fe ff ff       	call   8026a8 <syscall>
  802880:	83 c4 18             	add    $0x18,%esp
}
  802883:	90                   	nop
  802884:	c9                   	leave  
  802885:	c3                   	ret    

00802886 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  802886:	55                   	push   %ebp
  802887:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  802889:	6a 00                	push   $0x0
  80288b:	6a 00                	push   $0x0
  80288d:	6a 00                	push   $0x0
  80288f:	6a 00                	push   $0x0
  802891:	6a 00                	push   $0x0
  802893:	6a 14                	push   $0x14
  802895:	e8 0e fe ff ff       	call   8026a8 <syscall>
  80289a:	83 c4 18             	add    $0x18,%esp
}
  80289d:	90                   	nop
  80289e:	c9                   	leave  
  80289f:	c3                   	ret    

008028a0 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8028a0:	55                   	push   %ebp
  8028a1:	89 e5                	mov    %esp,%ebp
  8028a3:	83 ec 04             	sub    $0x4,%esp
  8028a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8028a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  8028ac:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8028af:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8028b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b6:	6a 00                	push   $0x0
  8028b8:	51                   	push   %ecx
  8028b9:	52                   	push   %edx
  8028ba:	ff 75 0c             	pushl  0xc(%ebp)
  8028bd:	50                   	push   %eax
  8028be:	6a 15                	push   $0x15
  8028c0:	e8 e3 fd ff ff       	call   8026a8 <syscall>
  8028c5:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  8028c8:	c9                   	leave  
  8028c9:	c3                   	ret    

008028ca <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  8028ca:	55                   	push   %ebp
  8028cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  8028cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d3:	6a 00                	push   $0x0
  8028d5:	6a 00                	push   $0x0
  8028d7:	6a 00                	push   $0x0
  8028d9:	52                   	push   %edx
  8028da:	50                   	push   %eax
  8028db:	6a 16                	push   $0x16
  8028dd:	e8 c6 fd ff ff       	call   8026a8 <syscall>
  8028e2:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  8028e5:	c9                   	leave  
  8028e6:	c3                   	ret    

008028e7 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  8028e7:	55                   	push   %ebp
  8028e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  8028ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f3:	6a 00                	push   $0x0
  8028f5:	6a 00                	push   $0x0
  8028f7:	51                   	push   %ecx
  8028f8:	52                   	push   %edx
  8028f9:	50                   	push   %eax
  8028fa:	6a 17                	push   $0x17
  8028fc:	e8 a7 fd ff ff       	call   8026a8 <syscall>
  802901:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  802904:	c9                   	leave  
  802905:	c3                   	ret    

00802906 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  802906:	55                   	push   %ebp
  802907:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  802909:	8b 55 0c             	mov    0xc(%ebp),%edx
  80290c:	8b 45 08             	mov    0x8(%ebp),%eax
  80290f:	6a 00                	push   $0x0
  802911:	6a 00                	push   $0x0
  802913:	6a 00                	push   $0x0
  802915:	52                   	push   %edx
  802916:	50                   	push   %eax
  802917:	6a 18                	push   $0x18
  802919:	e8 8a fd ff ff       	call   8026a8 <syscall>
  80291e:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  802921:	c9                   	leave  
  802922:	c3                   	ret    

00802923 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  802923:	55                   	push   %ebp
  802924:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  802926:	8b 45 08             	mov    0x8(%ebp),%eax
  802929:	6a 00                	push   $0x0
  80292b:	ff 75 14             	pushl  0x14(%ebp)
  80292e:	ff 75 10             	pushl  0x10(%ebp)
  802931:	ff 75 0c             	pushl  0xc(%ebp)
  802934:	50                   	push   %eax
  802935:	6a 19                	push   $0x19
  802937:	e8 6c fd ff ff       	call   8026a8 <syscall>
  80293c:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  80293f:	c9                   	leave  
  802940:	c3                   	ret    

00802941 <sys_run_env>:

void sys_run_env(int32 envId) {
  802941:	55                   	push   %ebp
  802942:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  802944:	8b 45 08             	mov    0x8(%ebp),%eax
  802947:	6a 00                	push   $0x0
  802949:	6a 00                	push   $0x0
  80294b:	6a 00                	push   $0x0
  80294d:	6a 00                	push   $0x0
  80294f:	50                   	push   %eax
  802950:	6a 1a                	push   $0x1a
  802952:	e8 51 fd ff ff       	call   8026a8 <syscall>
  802957:	83 c4 18             	add    $0x18,%esp
}
  80295a:	90                   	nop
  80295b:	c9                   	leave  
  80295c:	c3                   	ret    

0080295d <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  80295d:	55                   	push   %ebp
  80295e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802960:	8b 45 08             	mov    0x8(%ebp),%eax
  802963:	6a 00                	push   $0x0
  802965:	6a 00                	push   $0x0
  802967:	6a 00                	push   $0x0
  802969:	6a 00                	push   $0x0
  80296b:	50                   	push   %eax
  80296c:	6a 1b                	push   $0x1b
  80296e:	e8 35 fd ff ff       	call   8026a8 <syscall>
  802973:	83 c4 18             	add    $0x18,%esp
}
  802976:	c9                   	leave  
  802977:	c3                   	ret    

00802978 <sys_getenvid>:

int32 sys_getenvid(void) {
  802978:	55                   	push   %ebp
  802979:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80297b:	6a 00                	push   $0x0
  80297d:	6a 00                	push   $0x0
  80297f:	6a 00                	push   $0x0
  802981:	6a 00                	push   $0x0
  802983:	6a 00                	push   $0x0
  802985:	6a 05                	push   $0x5
  802987:	e8 1c fd ff ff       	call   8026a8 <syscall>
  80298c:	83 c4 18             	add    $0x18,%esp
}
  80298f:	c9                   	leave  
  802990:	c3                   	ret    

00802991 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  802991:	55                   	push   %ebp
  802992:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802994:	6a 00                	push   $0x0
  802996:	6a 00                	push   $0x0
  802998:	6a 00                	push   $0x0
  80299a:	6a 00                	push   $0x0
  80299c:	6a 00                	push   $0x0
  80299e:	6a 06                	push   $0x6
  8029a0:	e8 03 fd ff ff       	call   8026a8 <syscall>
  8029a5:	83 c4 18             	add    $0x18,%esp
}
  8029a8:	c9                   	leave  
  8029a9:	c3                   	ret    

008029aa <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  8029aa:	55                   	push   %ebp
  8029ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8029ad:	6a 00                	push   $0x0
  8029af:	6a 00                	push   $0x0
  8029b1:	6a 00                	push   $0x0
  8029b3:	6a 00                	push   $0x0
  8029b5:	6a 00                	push   $0x0
  8029b7:	6a 07                	push   $0x7
  8029b9:	e8 ea fc ff ff       	call   8026a8 <syscall>
  8029be:	83 c4 18             	add    $0x18,%esp
}
  8029c1:	c9                   	leave  
  8029c2:	c3                   	ret    

008029c3 <sys_exit_env>:

void sys_exit_env(void) {
  8029c3:	55                   	push   %ebp
  8029c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8029c6:	6a 00                	push   $0x0
  8029c8:	6a 00                	push   $0x0
  8029ca:	6a 00                	push   $0x0
  8029cc:	6a 00                	push   $0x0
  8029ce:	6a 00                	push   $0x0
  8029d0:	6a 1c                	push   $0x1c
  8029d2:	e8 d1 fc ff ff       	call   8026a8 <syscall>
  8029d7:	83 c4 18             	add    $0x18,%esp
}
  8029da:	90                   	nop
  8029db:	c9                   	leave  
  8029dc:	c3                   	ret    

008029dd <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  8029dd:	55                   	push   %ebp
  8029de:	89 e5                	mov    %esp,%ebp
  8029e0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  8029e3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8029e6:	8d 50 04             	lea    0x4(%eax),%edx
  8029e9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8029ec:	6a 00                	push   $0x0
  8029ee:	6a 00                	push   $0x0
  8029f0:	6a 00                	push   $0x0
  8029f2:	52                   	push   %edx
  8029f3:	50                   	push   %eax
  8029f4:	6a 1d                	push   $0x1d
  8029f6:	e8 ad fc ff ff       	call   8026a8 <syscall>
  8029fb:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  8029fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a01:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802a04:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802a07:	89 01                	mov    %eax,(%ecx)
  802a09:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	c9                   	leave  
  802a10:	c2 04 00             	ret    $0x4

00802a13 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  802a13:	55                   	push   %ebp
  802a14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  802a16:	6a 00                	push   $0x0
  802a18:	6a 00                	push   $0x0
  802a1a:	ff 75 10             	pushl  0x10(%ebp)
  802a1d:	ff 75 0c             	pushl  0xc(%ebp)
  802a20:	ff 75 08             	pushl  0x8(%ebp)
  802a23:	6a 13                	push   $0x13
  802a25:	e8 7e fc ff ff       	call   8026a8 <syscall>
  802a2a:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  802a2d:	90                   	nop
}
  802a2e:	c9                   	leave  
  802a2f:	c3                   	ret    

00802a30 <sys_rcr2>:
uint32 sys_rcr2() {
  802a30:	55                   	push   %ebp
  802a31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802a33:	6a 00                	push   $0x0
  802a35:	6a 00                	push   $0x0
  802a37:	6a 00                	push   $0x0
  802a39:	6a 00                	push   $0x0
  802a3b:	6a 00                	push   $0x0
  802a3d:	6a 1e                	push   $0x1e
  802a3f:	e8 64 fc ff ff       	call   8026a8 <syscall>
  802a44:	83 c4 18             	add    $0x18,%esp
}
  802a47:	c9                   	leave  
  802a48:	c3                   	ret    

00802a49 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  802a49:	55                   	push   %ebp
  802a4a:	89 e5                	mov    %esp,%ebp
  802a4c:	83 ec 04             	sub    $0x4,%esp
  802a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a52:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802a55:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802a59:	6a 00                	push   $0x0
  802a5b:	6a 00                	push   $0x0
  802a5d:	6a 00                	push   $0x0
  802a5f:	6a 00                	push   $0x0
  802a61:	50                   	push   %eax
  802a62:	6a 1f                	push   $0x1f
  802a64:	e8 3f fc ff ff       	call   8026a8 <syscall>
  802a69:	83 c4 18             	add    $0x18,%esp
	return;
  802a6c:	90                   	nop
}
  802a6d:	c9                   	leave  
  802a6e:	c3                   	ret    

00802a6f <rsttst>:
void rsttst() {
  802a6f:	55                   	push   %ebp
  802a70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802a72:	6a 00                	push   $0x0
  802a74:	6a 00                	push   $0x0
  802a76:	6a 00                	push   $0x0
  802a78:	6a 00                	push   $0x0
  802a7a:	6a 00                	push   $0x0
  802a7c:	6a 21                	push   $0x21
  802a7e:	e8 25 fc ff ff       	call   8026a8 <syscall>
  802a83:	83 c4 18             	add    $0x18,%esp
	return;
  802a86:	90                   	nop
}
  802a87:	c9                   	leave  
  802a88:	c3                   	ret    

00802a89 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  802a89:	55                   	push   %ebp
  802a8a:	89 e5                	mov    %esp,%ebp
  802a8c:	83 ec 04             	sub    $0x4,%esp
  802a8f:	8b 45 14             	mov    0x14(%ebp),%eax
  802a92:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802a95:	8b 55 18             	mov    0x18(%ebp),%edx
  802a98:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a9c:	52                   	push   %edx
  802a9d:	50                   	push   %eax
  802a9e:	ff 75 10             	pushl  0x10(%ebp)
  802aa1:	ff 75 0c             	pushl  0xc(%ebp)
  802aa4:	ff 75 08             	pushl  0x8(%ebp)
  802aa7:	6a 20                	push   $0x20
  802aa9:	e8 fa fb ff ff       	call   8026a8 <syscall>
  802aae:	83 c4 18             	add    $0x18,%esp
	return;
  802ab1:	90                   	nop
}
  802ab2:	c9                   	leave  
  802ab3:	c3                   	ret    

00802ab4 <chktst>:
void chktst(uint32 n) {
  802ab4:	55                   	push   %ebp
  802ab5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802ab7:	6a 00                	push   $0x0
  802ab9:	6a 00                	push   $0x0
  802abb:	6a 00                	push   $0x0
  802abd:	6a 00                	push   $0x0
  802abf:	ff 75 08             	pushl  0x8(%ebp)
  802ac2:	6a 22                	push   $0x22
  802ac4:	e8 df fb ff ff       	call   8026a8 <syscall>
  802ac9:	83 c4 18             	add    $0x18,%esp
	return;
  802acc:	90                   	nop
}
  802acd:	c9                   	leave  
  802ace:	c3                   	ret    

00802acf <inctst>:

void inctst() {
  802acf:	55                   	push   %ebp
  802ad0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802ad2:	6a 00                	push   $0x0
  802ad4:	6a 00                	push   $0x0
  802ad6:	6a 00                	push   $0x0
  802ad8:	6a 00                	push   $0x0
  802ada:	6a 00                	push   $0x0
  802adc:	6a 23                	push   $0x23
  802ade:	e8 c5 fb ff ff       	call   8026a8 <syscall>
  802ae3:	83 c4 18             	add    $0x18,%esp
	return;
  802ae6:	90                   	nop
}
  802ae7:	c9                   	leave  
  802ae8:	c3                   	ret    

00802ae9 <gettst>:
uint32 gettst() {
  802ae9:	55                   	push   %ebp
  802aea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802aec:	6a 00                	push   $0x0
  802aee:	6a 00                	push   $0x0
  802af0:	6a 00                	push   $0x0
  802af2:	6a 00                	push   $0x0
  802af4:	6a 00                	push   $0x0
  802af6:	6a 24                	push   $0x24
  802af8:	e8 ab fb ff ff       	call   8026a8 <syscall>
  802afd:	83 c4 18             	add    $0x18,%esp
}
  802b00:	c9                   	leave  
  802b01:	c3                   	ret    

00802b02 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  802b02:	55                   	push   %ebp
  802b03:	89 e5                	mov    %esp,%ebp
  802b05:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b08:	6a 00                	push   $0x0
  802b0a:	6a 00                	push   $0x0
  802b0c:	6a 00                	push   $0x0
  802b0e:	6a 00                	push   $0x0
  802b10:	6a 00                	push   $0x0
  802b12:	6a 25                	push   $0x25
  802b14:	e8 8f fb ff ff       	call   8026a8 <syscall>
  802b19:	83 c4 18             	add    $0x18,%esp
  802b1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802b1f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802b23:	75 07                	jne    802b2c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802b25:	b8 01 00 00 00       	mov    $0x1,%eax
  802b2a:	eb 05                	jmp    802b31 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802b2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b31:	c9                   	leave  
  802b32:	c3                   	ret    

00802b33 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  802b33:	55                   	push   %ebp
  802b34:	89 e5                	mov    %esp,%ebp
  802b36:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b39:	6a 00                	push   $0x0
  802b3b:	6a 00                	push   $0x0
  802b3d:	6a 00                	push   $0x0
  802b3f:	6a 00                	push   $0x0
  802b41:	6a 00                	push   $0x0
  802b43:	6a 25                	push   $0x25
  802b45:	e8 5e fb ff ff       	call   8026a8 <syscall>
  802b4a:	83 c4 18             	add    $0x18,%esp
  802b4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802b50:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802b54:	75 07                	jne    802b5d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802b56:	b8 01 00 00 00       	mov    $0x1,%eax
  802b5b:	eb 05                	jmp    802b62 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802b5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b62:	c9                   	leave  
  802b63:	c3                   	ret    

00802b64 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  802b64:	55                   	push   %ebp
  802b65:	89 e5                	mov    %esp,%ebp
  802b67:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b6a:	6a 00                	push   $0x0
  802b6c:	6a 00                	push   $0x0
  802b6e:	6a 00                	push   $0x0
  802b70:	6a 00                	push   $0x0
  802b72:	6a 00                	push   $0x0
  802b74:	6a 25                	push   $0x25
  802b76:	e8 2d fb ff ff       	call   8026a8 <syscall>
  802b7b:	83 c4 18             	add    $0x18,%esp
  802b7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802b81:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802b85:	75 07                	jne    802b8e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802b87:	b8 01 00 00 00       	mov    $0x1,%eax
  802b8c:	eb 05                	jmp    802b93 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802b8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b93:	c9                   	leave  
  802b94:	c3                   	ret    

00802b95 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  802b95:	55                   	push   %ebp
  802b96:	89 e5                	mov    %esp,%ebp
  802b98:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b9b:	6a 00                	push   $0x0
  802b9d:	6a 00                	push   $0x0
  802b9f:	6a 00                	push   $0x0
  802ba1:	6a 00                	push   $0x0
  802ba3:	6a 00                	push   $0x0
  802ba5:	6a 25                	push   $0x25
  802ba7:	e8 fc fa ff ff       	call   8026a8 <syscall>
  802bac:	83 c4 18             	add    $0x18,%esp
  802baf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802bb2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802bb6:	75 07                	jne    802bbf <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802bb8:	b8 01 00 00 00       	mov    $0x1,%eax
  802bbd:	eb 05                	jmp    802bc4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802bbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bc4:	c9                   	leave  
  802bc5:	c3                   	ret    

00802bc6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  802bc6:	55                   	push   %ebp
  802bc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802bc9:	6a 00                	push   $0x0
  802bcb:	6a 00                	push   $0x0
  802bcd:	6a 00                	push   $0x0
  802bcf:	6a 00                	push   $0x0
  802bd1:	ff 75 08             	pushl  0x8(%ebp)
  802bd4:	6a 26                	push   $0x26
  802bd6:	e8 cd fa ff ff       	call   8026a8 <syscall>
  802bdb:	83 c4 18             	add    $0x18,%esp
	return;
  802bde:	90                   	nop
}
  802bdf:	c9                   	leave  
  802be0:	c3                   	ret    

00802be1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  802be1:	55                   	push   %ebp
  802be2:	89 e5                	mov    %esp,%ebp
  802be4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  802be5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802be8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802beb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bee:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf1:	6a 00                	push   $0x0
  802bf3:	53                   	push   %ebx
  802bf4:	51                   	push   %ecx
  802bf5:	52                   	push   %edx
  802bf6:	50                   	push   %eax
  802bf7:	6a 27                	push   $0x27
  802bf9:	e8 aa fa ff ff       	call   8026a8 <syscall>
  802bfe:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  802c01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c04:	c9                   	leave  
  802c05:	c3                   	ret    

00802c06 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  802c06:	55                   	push   %ebp
  802c07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  802c09:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0f:	6a 00                	push   $0x0
  802c11:	6a 00                	push   $0x0
  802c13:	6a 00                	push   $0x0
  802c15:	52                   	push   %edx
  802c16:	50                   	push   %eax
  802c17:	6a 28                	push   $0x28
  802c19:	e8 8a fa ff ff       	call   8026a8 <syscall>
  802c1e:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  802c21:	c9                   	leave  
  802c22:	c3                   	ret    

00802c23 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  802c23:	55                   	push   %ebp
  802c24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  802c26:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802c29:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2f:	6a 00                	push   $0x0
  802c31:	51                   	push   %ecx
  802c32:	ff 75 10             	pushl  0x10(%ebp)
  802c35:	52                   	push   %edx
  802c36:	50                   	push   %eax
  802c37:	6a 29                	push   $0x29
  802c39:	e8 6a fa ff ff       	call   8026a8 <syscall>
  802c3e:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  802c41:	c9                   	leave  
  802c42:	c3                   	ret    

00802c43 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  802c43:	55                   	push   %ebp
  802c44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802c46:	6a 00                	push   $0x0
  802c48:	6a 00                	push   $0x0
  802c4a:	ff 75 10             	pushl  0x10(%ebp)
  802c4d:	ff 75 0c             	pushl  0xc(%ebp)
  802c50:	ff 75 08             	pushl  0x8(%ebp)
  802c53:	6a 12                	push   $0x12
  802c55:	e8 4e fa ff ff       	call   8026a8 <syscall>
  802c5a:	83 c4 18             	add    $0x18,%esp
	return;
  802c5d:	90                   	nop
}
  802c5e:	c9                   	leave  
  802c5f:	c3                   	ret    

00802c60 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  802c60:	55                   	push   %ebp
  802c61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  802c63:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c66:	8b 45 08             	mov    0x8(%ebp),%eax
  802c69:	6a 00                	push   $0x0
  802c6b:	6a 00                	push   $0x0
  802c6d:	6a 00                	push   $0x0
  802c6f:	52                   	push   %edx
  802c70:	50                   	push   %eax
  802c71:	6a 2a                	push   $0x2a
  802c73:	e8 30 fa ff ff       	call   8026a8 <syscall>
  802c78:	83 c4 18             	add    $0x18,%esp
	return;
  802c7b:	90                   	nop
}
  802c7c:	c9                   	leave  
  802c7d:	c3                   	ret    

00802c7e <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  802c7e:	55                   	push   %ebp
  802c7f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  802c81:	8b 45 08             	mov    0x8(%ebp),%eax
  802c84:	6a 00                	push   $0x0
  802c86:	6a 00                	push   $0x0
  802c88:	6a 00                	push   $0x0
  802c8a:	6a 00                	push   $0x0
  802c8c:	50                   	push   %eax
  802c8d:	6a 2b                	push   $0x2b
  802c8f:	e8 14 fa ff ff       	call   8026a8 <syscall>
  802c94:	83 c4 18             	add    $0x18,%esp
}
  802c97:	c9                   	leave  
  802c98:	c3                   	ret    

00802c99 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  802c99:	55                   	push   %ebp
  802c9a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802c9c:	6a 00                	push   $0x0
  802c9e:	6a 00                	push   $0x0
  802ca0:	6a 00                	push   $0x0
  802ca2:	ff 75 0c             	pushl  0xc(%ebp)
  802ca5:	ff 75 08             	pushl  0x8(%ebp)
  802ca8:	6a 2c                	push   $0x2c
  802caa:	e8 f9 f9 ff ff       	call   8026a8 <syscall>
  802caf:	83 c4 18             	add    $0x18,%esp
	return;
  802cb2:	90                   	nop
}
  802cb3:	c9                   	leave  
  802cb4:	c3                   	ret    

00802cb5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  802cb5:	55                   	push   %ebp
  802cb6:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802cb8:	6a 00                	push   $0x0
  802cba:	6a 00                	push   $0x0
  802cbc:	6a 00                	push   $0x0
  802cbe:	ff 75 0c             	pushl  0xc(%ebp)
  802cc1:	ff 75 08             	pushl  0x8(%ebp)
  802cc4:	6a 2d                	push   $0x2d
  802cc6:	e8 dd f9 ff ff       	call   8026a8 <syscall>
  802ccb:	83 c4 18             	add    $0x18,%esp
	return;
  802cce:	90                   	nop
}
  802ccf:	c9                   	leave  
  802cd0:	c3                   	ret    

00802cd1 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  802cd1:	55                   	push   %ebp
  802cd2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  802cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd7:	6a 00                	push   $0x0
  802cd9:	6a 00                	push   $0x0
  802cdb:	6a 00                	push   $0x0
  802cdd:	6a 00                	push   $0x0
  802cdf:	50                   	push   %eax
  802ce0:	6a 2f                	push   $0x2f
  802ce2:	e8 c1 f9 ff ff       	call   8026a8 <syscall>
  802ce7:	83 c4 18             	add    $0x18,%esp
	return;
  802cea:	90                   	nop
}
  802ceb:	c9                   	leave  
  802cec:	c3                   	ret    

00802ced <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  802ced:	55                   	push   %ebp
  802cee:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  802cf0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf6:	6a 00                	push   $0x0
  802cf8:	6a 00                	push   $0x0
  802cfa:	6a 00                	push   $0x0
  802cfc:	52                   	push   %edx
  802cfd:	50                   	push   %eax
  802cfe:	6a 30                	push   $0x30
  802d00:	e8 a3 f9 ff ff       	call   8026a8 <syscall>
  802d05:	83 c4 18             	add    $0x18,%esp
	return;
  802d08:	90                   	nop
}
  802d09:	c9                   	leave  
  802d0a:	c3                   	ret    

00802d0b <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  802d0b:	55                   	push   %ebp
  802d0c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  802d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d11:	6a 00                	push   $0x0
  802d13:	6a 00                	push   $0x0
  802d15:	6a 00                	push   $0x0
  802d17:	6a 00                	push   $0x0
  802d19:	50                   	push   %eax
  802d1a:	6a 31                	push   $0x31
  802d1c:	e8 87 f9 ff ff       	call   8026a8 <syscall>
  802d21:	83 c4 18             	add    $0x18,%esp
	return;
  802d24:	90                   	nop
}
  802d25:	c9                   	leave  
  802d26:	c3                   	ret    

00802d27 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  802d27:	55                   	push   %ebp
  802d28:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802d2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d30:	6a 00                	push   $0x0
  802d32:	6a 00                	push   $0x0
  802d34:	6a 00                	push   $0x0
  802d36:	52                   	push   %edx
  802d37:	50                   	push   %eax
  802d38:	6a 2e                	push   $0x2e
  802d3a:	e8 69 f9 ff ff       	call   8026a8 <syscall>
  802d3f:	83 c4 18             	add    $0x18,%esp
    return;
  802d42:	90                   	nop
}
  802d43:	c9                   	leave  
  802d44:	c3                   	ret    

00802d45 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802d45:	55                   	push   %ebp
  802d46:	89 e5                	mov    %esp,%ebp
  802d48:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4e:	83 e8 04             	sub    $0x4,%eax
  802d51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802d54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d57:	8b 00                	mov    (%eax),%eax
  802d59:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802d5c:	c9                   	leave  
  802d5d:	c3                   	ret    

00802d5e <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802d5e:	55                   	push   %ebp
  802d5f:	89 e5                	mov    %esp,%ebp
  802d61:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802d64:	8b 45 08             	mov    0x8(%ebp),%eax
  802d67:	83 e8 04             	sub    $0x4,%eax
  802d6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802d6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d70:	8b 00                	mov    (%eax),%eax
  802d72:	83 e0 01             	and    $0x1,%eax
  802d75:	85 c0                	test   %eax,%eax
  802d77:	0f 94 c0             	sete   %al
}
  802d7a:	c9                   	leave  
  802d7b:	c3                   	ret    

00802d7c <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802d7c:	55                   	push   %ebp
  802d7d:	89 e5                	mov    %esp,%ebp
  802d7f:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802d82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802d89:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d8c:	83 f8 02             	cmp    $0x2,%eax
  802d8f:	74 2b                	je     802dbc <alloc_block+0x40>
  802d91:	83 f8 02             	cmp    $0x2,%eax
  802d94:	7f 07                	jg     802d9d <alloc_block+0x21>
  802d96:	83 f8 01             	cmp    $0x1,%eax
  802d99:	74 0e                	je     802da9 <alloc_block+0x2d>
  802d9b:	eb 58                	jmp    802df5 <alloc_block+0x79>
  802d9d:	83 f8 03             	cmp    $0x3,%eax
  802da0:	74 2d                	je     802dcf <alloc_block+0x53>
  802da2:	83 f8 04             	cmp    $0x4,%eax
  802da5:	74 3b                	je     802de2 <alloc_block+0x66>
  802da7:	eb 4c                	jmp    802df5 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802da9:	83 ec 0c             	sub    $0xc,%esp
  802dac:	ff 75 08             	pushl  0x8(%ebp)
  802daf:	e8 f7 03 00 00       	call   8031ab <alloc_block_FF>
  802db4:	83 c4 10             	add    $0x10,%esp
  802db7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802dba:	eb 4a                	jmp    802e06 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802dbc:	83 ec 0c             	sub    $0xc,%esp
  802dbf:	ff 75 08             	pushl  0x8(%ebp)
  802dc2:	e8 f0 11 00 00       	call   803fb7 <alloc_block_NF>
  802dc7:	83 c4 10             	add    $0x10,%esp
  802dca:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802dcd:	eb 37                	jmp    802e06 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802dcf:	83 ec 0c             	sub    $0xc,%esp
  802dd2:	ff 75 08             	pushl  0x8(%ebp)
  802dd5:	e8 08 08 00 00       	call   8035e2 <alloc_block_BF>
  802dda:	83 c4 10             	add    $0x10,%esp
  802ddd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802de0:	eb 24                	jmp    802e06 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802de2:	83 ec 0c             	sub    $0xc,%esp
  802de5:	ff 75 08             	pushl  0x8(%ebp)
  802de8:	e8 ad 11 00 00       	call   803f9a <alloc_block_WF>
  802ded:	83 c4 10             	add    $0x10,%esp
  802df0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802df3:	eb 11                	jmp    802e06 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802df5:	83 ec 0c             	sub    $0xc,%esp
  802df8:	68 d8 49 80 00       	push   $0x8049d8
  802dfd:	e8 41 e4 ff ff       	call   801243 <cprintf>
  802e02:	83 c4 10             	add    $0x10,%esp
		break;
  802e05:	90                   	nop
	}
	return va;
  802e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802e09:	c9                   	leave  
  802e0a:	c3                   	ret    

00802e0b <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802e0b:	55                   	push   %ebp
  802e0c:	89 e5                	mov    %esp,%ebp
  802e0e:	53                   	push   %ebx
  802e0f:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802e12:	83 ec 0c             	sub    $0xc,%esp
  802e15:	68 f8 49 80 00       	push   $0x8049f8
  802e1a:	e8 24 e4 ff ff       	call   801243 <cprintf>
  802e1f:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802e22:	83 ec 0c             	sub    $0xc,%esp
  802e25:	68 23 4a 80 00       	push   $0x804a23
  802e2a:	e8 14 e4 ff ff       	call   801243 <cprintf>
  802e2f:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802e32:	8b 45 08             	mov    0x8(%ebp),%eax
  802e35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e38:	eb 37                	jmp    802e71 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802e3a:	83 ec 0c             	sub    $0xc,%esp
  802e3d:	ff 75 f4             	pushl  -0xc(%ebp)
  802e40:	e8 19 ff ff ff       	call   802d5e <is_free_block>
  802e45:	83 c4 10             	add    $0x10,%esp
  802e48:	0f be d8             	movsbl %al,%ebx
  802e4b:	83 ec 0c             	sub    $0xc,%esp
  802e4e:	ff 75 f4             	pushl  -0xc(%ebp)
  802e51:	e8 ef fe ff ff       	call   802d45 <get_block_size>
  802e56:	83 c4 10             	add    $0x10,%esp
  802e59:	83 ec 04             	sub    $0x4,%esp
  802e5c:	53                   	push   %ebx
  802e5d:	50                   	push   %eax
  802e5e:	68 3b 4a 80 00       	push   $0x804a3b
  802e63:	e8 db e3 ff ff       	call   801243 <cprintf>
  802e68:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802e6b:	8b 45 10             	mov    0x10(%ebp),%eax
  802e6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e75:	74 07                	je     802e7e <print_blocks_list+0x73>
  802e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7a:	8b 00                	mov    (%eax),%eax
  802e7c:	eb 05                	jmp    802e83 <print_blocks_list+0x78>
  802e7e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e83:	89 45 10             	mov    %eax,0x10(%ebp)
  802e86:	8b 45 10             	mov    0x10(%ebp),%eax
  802e89:	85 c0                	test   %eax,%eax
  802e8b:	75 ad                	jne    802e3a <print_blocks_list+0x2f>
  802e8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e91:	75 a7                	jne    802e3a <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802e93:	83 ec 0c             	sub    $0xc,%esp
  802e96:	68 f8 49 80 00       	push   $0x8049f8
  802e9b:	e8 a3 e3 ff ff       	call   801243 <cprintf>
  802ea0:	83 c4 10             	add    $0x10,%esp

}
  802ea3:	90                   	nop
  802ea4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ea7:	c9                   	leave  
  802ea8:	c3                   	ret    

00802ea9 <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802ea9:	55                   	push   %ebp
  802eaa:	89 e5                	mov    %esp,%ebp
  802eac:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb2:	83 e0 01             	and    $0x1,%eax
  802eb5:	85 c0                	test   %eax,%eax
  802eb7:	74 03                	je     802ebc <initialize_dynamic_allocator+0x13>
  802eb9:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  802ebc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ec0:	0f 84 f8 00 00 00    	je     802fbe <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  802ec6:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  802ecd:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  802ed0:	a1 40 50 98 00       	mov    0x985040,%eax
  802ed5:	85 c0                	test   %eax,%eax
  802ed7:	0f 84 e2 00 00 00    	je     802fbf <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  802edd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  802eec:	8b 55 08             	mov    0x8(%ebp),%edx
  802eef:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef2:	01 d0                	add    %edx,%eax
  802ef4:	83 e8 04             	sub    $0x4,%eax
  802ef7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	83 c0 08             	add    $0x8,%eax
  802f09:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  802f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f0f:	83 e8 08             	sub    $0x8,%eax
  802f12:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  802f15:	83 ec 04             	sub    $0x4,%esp
  802f18:	6a 00                	push   $0x0
  802f1a:	ff 75 e8             	pushl  -0x18(%ebp)
  802f1d:	ff 75 ec             	pushl  -0x14(%ebp)
  802f20:	e8 9c 00 00 00       	call   802fc1 <set_block_data>
  802f25:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  802f28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802f31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  802f3b:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  802f42:	00 00 00 
  802f45:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  802f4c:	00 00 00 
  802f4f:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  802f56:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  802f59:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f5d:	75 17                	jne    802f76 <initialize_dynamic_allocator+0xcd>
  802f5f:	83 ec 04             	sub    $0x4,%esp
  802f62:	68 54 4a 80 00       	push   $0x804a54
  802f67:	68 80 00 00 00       	push   $0x80
  802f6c:	68 77 4a 80 00       	push   $0x804a77
  802f71:	e8 10 e0 ff ff       	call   800f86 <_panic>
  802f76:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802f7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7f:	89 10                	mov    %edx,(%eax)
  802f81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f84:	8b 00                	mov    (%eax),%eax
  802f86:	85 c0                	test   %eax,%eax
  802f88:	74 0d                	je     802f97 <initialize_dynamic_allocator+0xee>
  802f8a:	a1 48 50 98 00       	mov    0x985048,%eax
  802f8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f92:	89 50 04             	mov    %edx,0x4(%eax)
  802f95:	eb 08                	jmp    802f9f <initialize_dynamic_allocator+0xf6>
  802f97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9a:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802f9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa2:	a3 48 50 98 00       	mov    %eax,0x985048
  802fa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802faa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb1:	a1 54 50 98 00       	mov    0x985054,%eax
  802fb6:	40                   	inc    %eax
  802fb7:	a3 54 50 98 00       	mov    %eax,0x985054
  802fbc:	eb 01                	jmp    802fbf <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802fbe:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  802fbf:	c9                   	leave  
  802fc0:	c3                   	ret    

00802fc1 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802fc1:	55                   	push   %ebp
  802fc2:	89 e5                	mov    %esp,%ebp
  802fc4:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  802fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fca:	83 e0 01             	and    $0x1,%eax
  802fcd:	85 c0                	test   %eax,%eax
  802fcf:	74 03                	je     802fd4 <set_block_data+0x13>
	{
		totalSize++;
  802fd1:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  802fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd7:	83 e8 04             	sub    $0x4,%eax
  802fda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  802fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe0:	83 e0 fe             	and    $0xfffffffe,%eax
  802fe3:	89 c2                	mov    %eax,%edx
  802fe5:	8b 45 10             	mov    0x10(%ebp),%eax
  802fe8:	83 e0 01             	and    $0x1,%eax
  802feb:	09 c2                	or     %eax,%edx
  802fed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ff0:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  802ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff5:	8d 50 f8             	lea    -0x8(%eax),%edx
  802ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffb:	01 d0                	add    %edx,%eax
  802ffd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  803000:	8b 45 0c             	mov    0xc(%ebp),%eax
  803003:	83 e0 fe             	and    $0xfffffffe,%eax
  803006:	89 c2                	mov    %eax,%edx
  803008:	8b 45 10             	mov    0x10(%ebp),%eax
  80300b:	83 e0 01             	and    $0x1,%eax
  80300e:	09 c2                	or     %eax,%edx
  803010:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803013:	89 10                	mov    %edx,(%eax)
}
  803015:	90                   	nop
  803016:	c9                   	leave  
  803017:	c3                   	ret    

00803018 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  803018:	55                   	push   %ebp
  803019:	89 e5                	mov    %esp,%ebp
  80301b:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  80301e:	a1 48 50 98 00       	mov    0x985048,%eax
  803023:	85 c0                	test   %eax,%eax
  803025:	75 68                	jne    80308f <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  803027:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80302b:	75 17                	jne    803044 <insert_sorted_in_freeList+0x2c>
  80302d:	83 ec 04             	sub    $0x4,%esp
  803030:	68 54 4a 80 00       	push   $0x804a54
  803035:	68 9d 00 00 00       	push   $0x9d
  80303a:	68 77 4a 80 00       	push   $0x804a77
  80303f:	e8 42 df ff ff       	call   800f86 <_panic>
  803044:	8b 15 48 50 98 00    	mov    0x985048,%edx
  80304a:	8b 45 08             	mov    0x8(%ebp),%eax
  80304d:	89 10                	mov    %edx,(%eax)
  80304f:	8b 45 08             	mov    0x8(%ebp),%eax
  803052:	8b 00                	mov    (%eax),%eax
  803054:	85 c0                	test   %eax,%eax
  803056:	74 0d                	je     803065 <insert_sorted_in_freeList+0x4d>
  803058:	a1 48 50 98 00       	mov    0x985048,%eax
  80305d:	8b 55 08             	mov    0x8(%ebp),%edx
  803060:	89 50 04             	mov    %edx,0x4(%eax)
  803063:	eb 08                	jmp    80306d <insert_sorted_in_freeList+0x55>
  803065:	8b 45 08             	mov    0x8(%ebp),%eax
  803068:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	a3 48 50 98 00       	mov    %eax,0x985048
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80307f:	a1 54 50 98 00       	mov    0x985054,%eax
  803084:	40                   	inc    %eax
  803085:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  80308a:	e9 1a 01 00 00       	jmp    8031a9 <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  80308f:	a1 48 50 98 00       	mov    0x985048,%eax
  803094:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803097:	eb 7f                	jmp    803118 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  803099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80309f:	76 6f                	jbe    803110 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  8030a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a5:	74 06                	je     8030ad <insert_sorted_in_freeList+0x95>
  8030a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ab:	75 17                	jne    8030c4 <insert_sorted_in_freeList+0xac>
  8030ad:	83 ec 04             	sub    $0x4,%esp
  8030b0:	68 90 4a 80 00       	push   $0x804a90
  8030b5:	68 a6 00 00 00       	push   $0xa6
  8030ba:	68 77 4a 80 00       	push   $0x804a77
  8030bf:	e8 c2 de ff ff       	call   800f86 <_panic>
  8030c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c7:	8b 50 04             	mov    0x4(%eax),%edx
  8030ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cd:	89 50 04             	mov    %edx,0x4(%eax)
  8030d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030d6:	89 10                	mov    %edx,(%eax)
  8030d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030db:	8b 40 04             	mov    0x4(%eax),%eax
  8030de:	85 c0                	test   %eax,%eax
  8030e0:	74 0d                	je     8030ef <insert_sorted_in_freeList+0xd7>
  8030e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e5:	8b 40 04             	mov    0x4(%eax),%eax
  8030e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8030eb:	89 10                	mov    %edx,(%eax)
  8030ed:	eb 08                	jmp    8030f7 <insert_sorted_in_freeList+0xdf>
  8030ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f2:	a3 48 50 98 00       	mov    %eax,0x985048
  8030f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8030fd:	89 50 04             	mov    %edx,0x4(%eax)
  803100:	a1 54 50 98 00       	mov    0x985054,%eax
  803105:	40                   	inc    %eax
  803106:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  80310b:	e9 99 00 00 00       	jmp    8031a9 <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  803110:	a1 50 50 98 00       	mov    0x985050,%eax
  803115:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803118:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80311c:	74 07                	je     803125 <insert_sorted_in_freeList+0x10d>
  80311e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803121:	8b 00                	mov    (%eax),%eax
  803123:	eb 05                	jmp    80312a <insert_sorted_in_freeList+0x112>
  803125:	b8 00 00 00 00       	mov    $0x0,%eax
  80312a:	a3 50 50 98 00       	mov    %eax,0x985050
  80312f:	a1 50 50 98 00       	mov    0x985050,%eax
  803134:	85 c0                	test   %eax,%eax
  803136:	0f 85 5d ff ff ff    	jne    803099 <insert_sorted_in_freeList+0x81>
  80313c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803140:	0f 85 53 ff ff ff    	jne    803099 <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  803146:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80314a:	75 17                	jne    803163 <insert_sorted_in_freeList+0x14b>
  80314c:	83 ec 04             	sub    $0x4,%esp
  80314f:	68 c8 4a 80 00       	push   $0x804ac8
  803154:	68 ab 00 00 00       	push   $0xab
  803159:	68 77 4a 80 00       	push   $0x804a77
  80315e:	e8 23 de ff ff       	call   800f86 <_panic>
  803163:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  803169:	8b 45 08             	mov    0x8(%ebp),%eax
  80316c:	89 50 04             	mov    %edx,0x4(%eax)
  80316f:	8b 45 08             	mov    0x8(%ebp),%eax
  803172:	8b 40 04             	mov    0x4(%eax),%eax
  803175:	85 c0                	test   %eax,%eax
  803177:	74 0c                	je     803185 <insert_sorted_in_freeList+0x16d>
  803179:	a1 4c 50 98 00       	mov    0x98504c,%eax
  80317e:	8b 55 08             	mov    0x8(%ebp),%edx
  803181:	89 10                	mov    %edx,(%eax)
  803183:	eb 08                	jmp    80318d <insert_sorted_in_freeList+0x175>
  803185:	8b 45 08             	mov    0x8(%ebp),%eax
  803188:	a3 48 50 98 00       	mov    %eax,0x985048
  80318d:	8b 45 08             	mov    0x8(%ebp),%eax
  803190:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803195:	8b 45 08             	mov    0x8(%ebp),%eax
  803198:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80319e:	a1 54 50 98 00       	mov    0x985054,%eax
  8031a3:	40                   	inc    %eax
  8031a4:	a3 54 50 98 00       	mov    %eax,0x985054
}
  8031a9:	c9                   	leave  
  8031aa:	c3                   	ret    

008031ab <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8031ab:	55                   	push   %ebp
  8031ac:	89 e5                	mov    %esp,%ebp
  8031ae:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8031b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b4:	83 e0 01             	and    $0x1,%eax
  8031b7:	85 c0                	test   %eax,%eax
  8031b9:	74 03                	je     8031be <alloc_block_FF+0x13>
  8031bb:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8031be:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8031c2:	77 07                	ja     8031cb <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8031c4:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8031cb:	a1 40 50 98 00       	mov    0x985040,%eax
  8031d0:	85 c0                	test   %eax,%eax
  8031d2:	75 63                	jne    803237 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8031d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d7:	83 c0 10             	add    $0x10,%eax
  8031da:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8031dd:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8031e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ea:	01 d0                	add    %edx,%eax
  8031ec:	48                   	dec    %eax
  8031ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8031f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8031f8:	f7 75 ec             	divl   -0x14(%ebp)
  8031fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fe:	29 d0                	sub    %edx,%eax
  803200:	c1 e8 0c             	shr    $0xc,%eax
  803203:	83 ec 0c             	sub    $0xc,%esp
  803206:	50                   	push   %eax
  803207:	e8 d1 ed ff ff       	call   801fdd <sbrk>
  80320c:	83 c4 10             	add    $0x10,%esp
  80320f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803212:	83 ec 0c             	sub    $0xc,%esp
  803215:	6a 00                	push   $0x0
  803217:	e8 c1 ed ff ff       	call   801fdd <sbrk>
  80321c:	83 c4 10             	add    $0x10,%esp
  80321f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803222:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803225:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803228:	83 ec 08             	sub    $0x8,%esp
  80322b:	50                   	push   %eax
  80322c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80322f:	e8 75 fc ff ff       	call   802ea9 <initialize_dynamic_allocator>
  803234:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  803237:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80323b:	75 0a                	jne    803247 <alloc_block_FF+0x9c>
	{
		return NULL;
  80323d:	b8 00 00 00 00       	mov    $0x0,%eax
  803242:	e9 99 03 00 00       	jmp    8035e0 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  803247:	8b 45 08             	mov    0x8(%ebp),%eax
  80324a:	83 c0 08             	add    $0x8,%eax
  80324d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803250:	a1 48 50 98 00       	mov    0x985048,%eax
  803255:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803258:	e9 03 02 00 00       	jmp    803460 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  80325d:	83 ec 0c             	sub    $0xc,%esp
  803260:	ff 75 f4             	pushl  -0xc(%ebp)
  803263:	e8 dd fa ff ff       	call   802d45 <get_block_size>
  803268:	83 c4 10             	add    $0x10,%esp
  80326b:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  80326e:	8b 45 9c             	mov    -0x64(%ebp),%eax
  803271:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803274:	0f 82 de 01 00 00    	jb     803458 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  80327a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80327d:	83 c0 10             	add    $0x10,%eax
  803280:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  803283:	0f 87 32 01 00 00    	ja     8033bb <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  803289:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80328c:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80328f:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  803292:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803295:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803298:	01 d0                	add    %edx,%eax
  80329a:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  80329d:	83 ec 04             	sub    $0x4,%esp
  8032a0:	6a 00                	push   $0x0
  8032a2:	ff 75 98             	pushl  -0x68(%ebp)
  8032a5:	ff 75 94             	pushl  -0x6c(%ebp)
  8032a8:	e8 14 fd ff ff       	call   802fc1 <set_block_data>
  8032ad:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  8032b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032b4:	74 06                	je     8032bc <alloc_block_FF+0x111>
  8032b6:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  8032ba:	75 17                	jne    8032d3 <alloc_block_FF+0x128>
  8032bc:	83 ec 04             	sub    $0x4,%esp
  8032bf:	68 ec 4a 80 00       	push   $0x804aec
  8032c4:	68 de 00 00 00       	push   $0xde
  8032c9:	68 77 4a 80 00       	push   $0x804a77
  8032ce:	e8 b3 dc ff ff       	call   800f86 <_panic>
  8032d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d6:	8b 10                	mov    (%eax),%edx
  8032d8:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8032db:	89 10                	mov    %edx,(%eax)
  8032dd:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8032e0:	8b 00                	mov    (%eax),%eax
  8032e2:	85 c0                	test   %eax,%eax
  8032e4:	74 0b                	je     8032f1 <alloc_block_FF+0x146>
  8032e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e9:	8b 00                	mov    (%eax),%eax
  8032eb:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8032ee:	89 50 04             	mov    %edx,0x4(%eax)
  8032f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f4:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8032f7:	89 10                	mov    %edx,(%eax)
  8032f9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8032fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032ff:	89 50 04             	mov    %edx,0x4(%eax)
  803302:	8b 45 94             	mov    -0x6c(%ebp),%eax
  803305:	8b 00                	mov    (%eax),%eax
  803307:	85 c0                	test   %eax,%eax
  803309:	75 08                	jne    803313 <alloc_block_FF+0x168>
  80330b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80330e:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803313:	a1 54 50 98 00       	mov    0x985054,%eax
  803318:	40                   	inc    %eax
  803319:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  80331e:	83 ec 04             	sub    $0x4,%esp
  803321:	6a 01                	push   $0x1
  803323:	ff 75 dc             	pushl  -0x24(%ebp)
  803326:	ff 75 f4             	pushl  -0xc(%ebp)
  803329:	e8 93 fc ff ff       	call   802fc1 <set_block_data>
  80332e:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  803331:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803335:	75 17                	jne    80334e <alloc_block_FF+0x1a3>
  803337:	83 ec 04             	sub    $0x4,%esp
  80333a:	68 20 4b 80 00       	push   $0x804b20
  80333f:	68 e3 00 00 00       	push   $0xe3
  803344:	68 77 4a 80 00       	push   $0x804a77
  803349:	e8 38 dc ff ff       	call   800f86 <_panic>
  80334e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803351:	8b 00                	mov    (%eax),%eax
  803353:	85 c0                	test   %eax,%eax
  803355:	74 10                	je     803367 <alloc_block_FF+0x1bc>
  803357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335a:	8b 00                	mov    (%eax),%eax
  80335c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80335f:	8b 52 04             	mov    0x4(%edx),%edx
  803362:	89 50 04             	mov    %edx,0x4(%eax)
  803365:	eb 0b                	jmp    803372 <alloc_block_FF+0x1c7>
  803367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336a:	8b 40 04             	mov    0x4(%eax),%eax
  80336d:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803375:	8b 40 04             	mov    0x4(%eax),%eax
  803378:	85 c0                	test   %eax,%eax
  80337a:	74 0f                	je     80338b <alloc_block_FF+0x1e0>
  80337c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337f:	8b 40 04             	mov    0x4(%eax),%eax
  803382:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803385:	8b 12                	mov    (%edx),%edx
  803387:	89 10                	mov    %edx,(%eax)
  803389:	eb 0a                	jmp    803395 <alloc_block_FF+0x1ea>
  80338b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338e:	8b 00                	mov    (%eax),%eax
  803390:	a3 48 50 98 00       	mov    %eax,0x985048
  803395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803398:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80339e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a8:	a1 54 50 98 00       	mov    0x985054,%eax
  8033ad:	48                   	dec    %eax
  8033ae:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  8033b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b6:	e9 25 02 00 00       	jmp    8035e0 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  8033bb:	83 ec 04             	sub    $0x4,%esp
  8033be:	6a 01                	push   $0x1
  8033c0:	ff 75 9c             	pushl  -0x64(%ebp)
  8033c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8033c6:	e8 f6 fb ff ff       	call   802fc1 <set_block_data>
  8033cb:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  8033ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d2:	75 17                	jne    8033eb <alloc_block_FF+0x240>
  8033d4:	83 ec 04             	sub    $0x4,%esp
  8033d7:	68 20 4b 80 00       	push   $0x804b20
  8033dc:	68 eb 00 00 00       	push   $0xeb
  8033e1:	68 77 4a 80 00       	push   $0x804a77
  8033e6:	e8 9b db ff ff       	call   800f86 <_panic>
  8033eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ee:	8b 00                	mov    (%eax),%eax
  8033f0:	85 c0                	test   %eax,%eax
  8033f2:	74 10                	je     803404 <alloc_block_FF+0x259>
  8033f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f7:	8b 00                	mov    (%eax),%eax
  8033f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033fc:	8b 52 04             	mov    0x4(%edx),%edx
  8033ff:	89 50 04             	mov    %edx,0x4(%eax)
  803402:	eb 0b                	jmp    80340f <alloc_block_FF+0x264>
  803404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803407:	8b 40 04             	mov    0x4(%eax),%eax
  80340a:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80340f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803412:	8b 40 04             	mov    0x4(%eax),%eax
  803415:	85 c0                	test   %eax,%eax
  803417:	74 0f                	je     803428 <alloc_block_FF+0x27d>
  803419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341c:	8b 40 04             	mov    0x4(%eax),%eax
  80341f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803422:	8b 12                	mov    (%edx),%edx
  803424:	89 10                	mov    %edx,(%eax)
  803426:	eb 0a                	jmp    803432 <alloc_block_FF+0x287>
  803428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342b:	8b 00                	mov    (%eax),%eax
  80342d:	a3 48 50 98 00       	mov    %eax,0x985048
  803432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803435:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80343b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803445:	a1 54 50 98 00       	mov    0x985054,%eax
  80344a:	48                   	dec    %eax
  80344b:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  803450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803453:	e9 88 01 00 00       	jmp    8035e0 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803458:	a1 50 50 98 00       	mov    0x985050,%eax
  80345d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803460:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803464:	74 07                	je     80346d <alloc_block_FF+0x2c2>
  803466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803469:	8b 00                	mov    (%eax),%eax
  80346b:	eb 05                	jmp    803472 <alloc_block_FF+0x2c7>
  80346d:	b8 00 00 00 00       	mov    $0x0,%eax
  803472:	a3 50 50 98 00       	mov    %eax,0x985050
  803477:	a1 50 50 98 00       	mov    0x985050,%eax
  80347c:	85 c0                	test   %eax,%eax
  80347e:	0f 85 d9 fd ff ff    	jne    80325d <alloc_block_FF+0xb2>
  803484:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803488:	0f 85 cf fd ff ff    	jne    80325d <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  80348e:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  803495:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803498:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80349b:	01 d0                	add    %edx,%eax
  80349d:	48                   	dec    %eax
  80349e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8034a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8034a9:	f7 75 d8             	divl   -0x28(%ebp)
  8034ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034af:	29 d0                	sub    %edx,%eax
  8034b1:	c1 e8 0c             	shr    $0xc,%eax
  8034b4:	83 ec 0c             	sub    $0xc,%esp
  8034b7:	50                   	push   %eax
  8034b8:	e8 20 eb ff ff       	call   801fdd <sbrk>
  8034bd:	83 c4 10             	add    $0x10,%esp
  8034c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  8034c3:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8034c7:	75 0a                	jne    8034d3 <alloc_block_FF+0x328>
		return NULL;
  8034c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ce:	e9 0d 01 00 00       	jmp    8035e0 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  8034d3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034d6:	83 e8 04             	sub    $0x4,%eax
  8034d9:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  8034dc:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  8034e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034e9:	01 d0                	add    %edx,%eax
  8034eb:	48                   	dec    %eax
  8034ec:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8034ef:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8034f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8034f7:	f7 75 c8             	divl   -0x38(%ebp)
  8034fa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8034fd:	29 d0                	sub    %edx,%eax
  8034ff:	c1 e8 02             	shr    $0x2,%eax
  803502:	c1 e0 02             	shl    $0x2,%eax
  803505:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  803508:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80350b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  803511:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803514:	83 e8 08             	sub    $0x8,%eax
  803517:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  80351a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80351d:	8b 00                	mov    (%eax),%eax
  80351f:	83 e0 fe             	and    $0xfffffffe,%eax
  803522:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  803525:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803528:	f7 d8                	neg    %eax
  80352a:	89 c2                	mov    %eax,%edx
  80352c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80352f:	01 d0                	add    %edx,%eax
  803531:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  803534:	83 ec 0c             	sub    $0xc,%esp
  803537:	ff 75 b8             	pushl  -0x48(%ebp)
  80353a:	e8 1f f8 ff ff       	call   802d5e <is_free_block>
  80353f:	83 c4 10             	add    $0x10,%esp
  803542:	0f be c0             	movsbl %al,%eax
  803545:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  803548:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  80354c:	74 42                	je     803590 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  80354e:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803555:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803558:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80355b:	01 d0                	add    %edx,%eax
  80355d:	48                   	dec    %eax
  80355e:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803561:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803564:	ba 00 00 00 00       	mov    $0x0,%edx
  803569:	f7 75 b0             	divl   -0x50(%ebp)
  80356c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80356f:	29 d0                	sub    %edx,%eax
  803571:	89 c2                	mov    %eax,%edx
  803573:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803576:	01 d0                	add    %edx,%eax
  803578:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  80357b:	83 ec 04             	sub    $0x4,%esp
  80357e:	6a 00                	push   $0x0
  803580:	ff 75 a8             	pushl  -0x58(%ebp)
  803583:	ff 75 b8             	pushl  -0x48(%ebp)
  803586:	e8 36 fa ff ff       	call   802fc1 <set_block_data>
  80358b:	83 c4 10             	add    $0x10,%esp
  80358e:	eb 42                	jmp    8035d2 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  803590:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  803597:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80359a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80359d:	01 d0                	add    %edx,%eax
  80359f:	48                   	dec    %eax
  8035a0:	89 45 a0             	mov    %eax,-0x60(%ebp)
  8035a3:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8035a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8035ab:	f7 75 a4             	divl   -0x5c(%ebp)
  8035ae:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8035b1:	29 d0                	sub    %edx,%eax
  8035b3:	83 ec 04             	sub    $0x4,%esp
  8035b6:	6a 00                	push   $0x0
  8035b8:	50                   	push   %eax
  8035b9:	ff 75 d0             	pushl  -0x30(%ebp)
  8035bc:	e8 00 fa ff ff       	call   802fc1 <set_block_data>
  8035c1:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  8035c4:	83 ec 0c             	sub    $0xc,%esp
  8035c7:	ff 75 d0             	pushl  -0x30(%ebp)
  8035ca:	e8 49 fa ff ff       	call   803018 <insert_sorted_in_freeList>
  8035cf:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  8035d2:	83 ec 0c             	sub    $0xc,%esp
  8035d5:	ff 75 08             	pushl  0x8(%ebp)
  8035d8:	e8 ce fb ff ff       	call   8031ab <alloc_block_FF>
  8035dd:	83 c4 10             	add    $0x10,%esp
}
  8035e0:	c9                   	leave  
  8035e1:	c3                   	ret    

008035e2 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8035e2:	55                   	push   %ebp
  8035e3:	89 e5                	mov    %esp,%ebp
  8035e5:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  8035e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035ec:	75 0a                	jne    8035f8 <alloc_block_BF+0x16>
	{
		return NULL;
  8035ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8035f3:	e9 7a 02 00 00       	jmp    803872 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  8035f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fb:	83 c0 08             	add    $0x8,%eax
  8035fe:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  803601:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  803608:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  80360f:	a1 48 50 98 00       	mov    0x985048,%eax
  803614:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803617:	eb 32                	jmp    80364b <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  803619:	ff 75 ec             	pushl  -0x14(%ebp)
  80361c:	e8 24 f7 ff ff       	call   802d45 <get_block_size>
  803621:	83 c4 04             	add    $0x4,%esp
  803624:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  803627:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80362a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80362d:	72 14                	jb     803643 <alloc_block_BF+0x61>
  80362f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803632:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803635:	73 0c                	jae    803643 <alloc_block_BF+0x61>
		{
			minBlk = block;
  803637:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80363a:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  80363d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803640:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803643:	a1 50 50 98 00       	mov    0x985050,%eax
  803648:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80364b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80364f:	74 07                	je     803658 <alloc_block_BF+0x76>
  803651:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803654:	8b 00                	mov    (%eax),%eax
  803656:	eb 05                	jmp    80365d <alloc_block_BF+0x7b>
  803658:	b8 00 00 00 00       	mov    $0x0,%eax
  80365d:	a3 50 50 98 00       	mov    %eax,0x985050
  803662:	a1 50 50 98 00       	mov    0x985050,%eax
  803667:	85 c0                	test   %eax,%eax
  803669:	75 ae                	jne    803619 <alloc_block_BF+0x37>
  80366b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80366f:	75 a8                	jne    803619 <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  803671:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803675:	75 22                	jne    803699 <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  803677:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367a:	83 ec 0c             	sub    $0xc,%esp
  80367d:	50                   	push   %eax
  80367e:	e8 5a e9 ff ff       	call   801fdd <sbrk>
  803683:	83 c4 10             	add    $0x10,%esp
  803686:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  803689:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80368d:	75 0a                	jne    803699 <alloc_block_BF+0xb7>
			return NULL;
  80368f:	b8 00 00 00 00       	mov    $0x0,%eax
  803694:	e9 d9 01 00 00       	jmp    803872 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  803699:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80369c:	83 c0 10             	add    $0x10,%eax
  80369f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8036a2:	0f 87 32 01 00 00    	ja     8037da <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  8036a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ab:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8036ae:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  8036b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b7:	01 d0                	add    %edx,%eax
  8036b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  8036bc:	83 ec 04             	sub    $0x4,%esp
  8036bf:	6a 00                	push   $0x0
  8036c1:	ff 75 dc             	pushl  -0x24(%ebp)
  8036c4:	ff 75 d8             	pushl  -0x28(%ebp)
  8036c7:	e8 f5 f8 ff ff       	call   802fc1 <set_block_data>
  8036cc:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  8036cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036d3:	74 06                	je     8036db <alloc_block_BF+0xf9>
  8036d5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8036d9:	75 17                	jne    8036f2 <alloc_block_BF+0x110>
  8036db:	83 ec 04             	sub    $0x4,%esp
  8036de:	68 ec 4a 80 00       	push   $0x804aec
  8036e3:	68 49 01 00 00       	push   $0x149
  8036e8:	68 77 4a 80 00       	push   $0x804a77
  8036ed:	e8 94 d8 ff ff       	call   800f86 <_panic>
  8036f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f5:	8b 10                	mov    (%eax),%edx
  8036f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8036fa:	89 10                	mov    %edx,(%eax)
  8036fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8036ff:	8b 00                	mov    (%eax),%eax
  803701:	85 c0                	test   %eax,%eax
  803703:	74 0b                	je     803710 <alloc_block_BF+0x12e>
  803705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803708:	8b 00                	mov    (%eax),%eax
  80370a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80370d:	89 50 04             	mov    %edx,0x4(%eax)
  803710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803713:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803716:	89 10                	mov    %edx,(%eax)
  803718:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80371b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80371e:	89 50 04             	mov    %edx,0x4(%eax)
  803721:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803724:	8b 00                	mov    (%eax),%eax
  803726:	85 c0                	test   %eax,%eax
  803728:	75 08                	jne    803732 <alloc_block_BF+0x150>
  80372a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80372d:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803732:	a1 54 50 98 00       	mov    0x985054,%eax
  803737:	40                   	inc    %eax
  803738:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  80373d:	83 ec 04             	sub    $0x4,%esp
  803740:	6a 01                	push   $0x1
  803742:	ff 75 e8             	pushl  -0x18(%ebp)
  803745:	ff 75 f4             	pushl  -0xc(%ebp)
  803748:	e8 74 f8 ff ff       	call   802fc1 <set_block_data>
  80374d:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  803750:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803754:	75 17                	jne    80376d <alloc_block_BF+0x18b>
  803756:	83 ec 04             	sub    $0x4,%esp
  803759:	68 20 4b 80 00       	push   $0x804b20
  80375e:	68 4e 01 00 00       	push   $0x14e
  803763:	68 77 4a 80 00       	push   $0x804a77
  803768:	e8 19 d8 ff ff       	call   800f86 <_panic>
  80376d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803770:	8b 00                	mov    (%eax),%eax
  803772:	85 c0                	test   %eax,%eax
  803774:	74 10                	je     803786 <alloc_block_BF+0x1a4>
  803776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803779:	8b 00                	mov    (%eax),%eax
  80377b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80377e:	8b 52 04             	mov    0x4(%edx),%edx
  803781:	89 50 04             	mov    %edx,0x4(%eax)
  803784:	eb 0b                	jmp    803791 <alloc_block_BF+0x1af>
  803786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803789:	8b 40 04             	mov    0x4(%eax),%eax
  80378c:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803794:	8b 40 04             	mov    0x4(%eax),%eax
  803797:	85 c0                	test   %eax,%eax
  803799:	74 0f                	je     8037aa <alloc_block_BF+0x1c8>
  80379b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379e:	8b 40 04             	mov    0x4(%eax),%eax
  8037a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037a4:	8b 12                	mov    (%edx),%edx
  8037a6:	89 10                	mov    %edx,(%eax)
  8037a8:	eb 0a                	jmp    8037b4 <alloc_block_BF+0x1d2>
  8037aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ad:	8b 00                	mov    (%eax),%eax
  8037af:	a3 48 50 98 00       	mov    %eax,0x985048
  8037b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037c7:	a1 54 50 98 00       	mov    0x985054,%eax
  8037cc:	48                   	dec    %eax
  8037cd:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  8037d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d5:	e9 98 00 00 00       	jmp    803872 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  8037da:	83 ec 04             	sub    $0x4,%esp
  8037dd:	6a 01                	push   $0x1
  8037df:	ff 75 f0             	pushl  -0x10(%ebp)
  8037e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8037e5:	e8 d7 f7 ff ff       	call   802fc1 <set_block_data>
  8037ea:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  8037ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037f1:	75 17                	jne    80380a <alloc_block_BF+0x228>
  8037f3:	83 ec 04             	sub    $0x4,%esp
  8037f6:	68 20 4b 80 00       	push   $0x804b20
  8037fb:	68 56 01 00 00       	push   $0x156
  803800:	68 77 4a 80 00       	push   $0x804a77
  803805:	e8 7c d7 ff ff       	call   800f86 <_panic>
  80380a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380d:	8b 00                	mov    (%eax),%eax
  80380f:	85 c0                	test   %eax,%eax
  803811:	74 10                	je     803823 <alloc_block_BF+0x241>
  803813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803816:	8b 00                	mov    (%eax),%eax
  803818:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80381b:	8b 52 04             	mov    0x4(%edx),%edx
  80381e:	89 50 04             	mov    %edx,0x4(%eax)
  803821:	eb 0b                	jmp    80382e <alloc_block_BF+0x24c>
  803823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803826:	8b 40 04             	mov    0x4(%eax),%eax
  803829:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80382e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803831:	8b 40 04             	mov    0x4(%eax),%eax
  803834:	85 c0                	test   %eax,%eax
  803836:	74 0f                	je     803847 <alloc_block_BF+0x265>
  803838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383b:	8b 40 04             	mov    0x4(%eax),%eax
  80383e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803841:	8b 12                	mov    (%edx),%edx
  803843:	89 10                	mov    %edx,(%eax)
  803845:	eb 0a                	jmp    803851 <alloc_block_BF+0x26f>
  803847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384a:	8b 00                	mov    (%eax),%eax
  80384c:	a3 48 50 98 00       	mov    %eax,0x985048
  803851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803854:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80385a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80385d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803864:	a1 54 50 98 00       	mov    0x985054,%eax
  803869:	48                   	dec    %eax
  80386a:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  80386f:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  803872:	c9                   	leave  
  803873:	c3                   	ret    

00803874 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803874:	55                   	push   %ebp
  803875:	89 e5                	mov    %esp,%ebp
  803877:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  80387a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80387e:	0f 84 6a 02 00 00    	je     803aee <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  803884:	ff 75 08             	pushl  0x8(%ebp)
  803887:	e8 b9 f4 ff ff       	call   802d45 <get_block_size>
  80388c:	83 c4 04             	add    $0x4,%esp
  80388f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  803892:	8b 45 08             	mov    0x8(%ebp),%eax
  803895:	83 e8 08             	sub    $0x8,%eax
  803898:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  80389b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80389e:	8b 00                	mov    (%eax),%eax
  8038a0:	83 e0 fe             	and    $0xfffffffe,%eax
  8038a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  8038a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038a9:	f7 d8                	neg    %eax
  8038ab:	89 c2                	mov    %eax,%edx
  8038ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b0:	01 d0                	add    %edx,%eax
  8038b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  8038b5:	ff 75 e8             	pushl  -0x18(%ebp)
  8038b8:	e8 a1 f4 ff ff       	call   802d5e <is_free_block>
  8038bd:	83 c4 04             	add    $0x4,%esp
  8038c0:	0f be c0             	movsbl %al,%eax
  8038c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  8038c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8038c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038cc:	01 d0                	add    %edx,%eax
  8038ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  8038d1:	ff 75 e0             	pushl  -0x20(%ebp)
  8038d4:	e8 85 f4 ff ff       	call   802d5e <is_free_block>
  8038d9:	83 c4 04             	add    $0x4,%esp
  8038dc:	0f be c0             	movsbl %al,%eax
  8038df:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  8038e2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8038e6:	75 34                	jne    80391c <free_block+0xa8>
  8038e8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8038ec:	75 2e                	jne    80391c <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  8038ee:	ff 75 e8             	pushl  -0x18(%ebp)
  8038f1:	e8 4f f4 ff ff       	call   802d45 <get_block_size>
  8038f6:	83 c4 04             	add    $0x4,%esp
  8038f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  8038fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803902:	01 d0                	add    %edx,%eax
  803904:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  803907:	6a 00                	push   $0x0
  803909:	ff 75 d4             	pushl  -0x2c(%ebp)
  80390c:	ff 75 e8             	pushl  -0x18(%ebp)
  80390f:	e8 ad f6 ff ff       	call   802fc1 <set_block_data>
  803914:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  803917:	e9 d3 01 00 00       	jmp    803aef <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  80391c:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  803920:	0f 85 c8 00 00 00    	jne    8039ee <free_block+0x17a>
  803926:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80392a:	0f 85 be 00 00 00    	jne    8039ee <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  803930:	ff 75 e0             	pushl  -0x20(%ebp)
  803933:	e8 0d f4 ff ff       	call   802d45 <get_block_size>
  803938:	83 c4 04             	add    $0x4,%esp
  80393b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  80393e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803941:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803944:	01 d0                	add    %edx,%eax
  803946:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  803949:	6a 00                	push   $0x0
  80394b:	ff 75 cc             	pushl  -0x34(%ebp)
  80394e:	ff 75 08             	pushl  0x8(%ebp)
  803951:	e8 6b f6 ff ff       	call   802fc1 <set_block_data>
  803956:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  803959:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80395d:	75 17                	jne    803976 <free_block+0x102>
  80395f:	83 ec 04             	sub    $0x4,%esp
  803962:	68 20 4b 80 00       	push   $0x804b20
  803967:	68 87 01 00 00       	push   $0x187
  80396c:	68 77 4a 80 00       	push   $0x804a77
  803971:	e8 10 d6 ff ff       	call   800f86 <_panic>
  803976:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803979:	8b 00                	mov    (%eax),%eax
  80397b:	85 c0                	test   %eax,%eax
  80397d:	74 10                	je     80398f <free_block+0x11b>
  80397f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803982:	8b 00                	mov    (%eax),%eax
  803984:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803987:	8b 52 04             	mov    0x4(%edx),%edx
  80398a:	89 50 04             	mov    %edx,0x4(%eax)
  80398d:	eb 0b                	jmp    80399a <free_block+0x126>
  80398f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803992:	8b 40 04             	mov    0x4(%eax),%eax
  803995:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80399a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80399d:	8b 40 04             	mov    0x4(%eax),%eax
  8039a0:	85 c0                	test   %eax,%eax
  8039a2:	74 0f                	je     8039b3 <free_block+0x13f>
  8039a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039a7:	8b 40 04             	mov    0x4(%eax),%eax
  8039aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039ad:	8b 12                	mov    (%edx),%edx
  8039af:	89 10                	mov    %edx,(%eax)
  8039b1:	eb 0a                	jmp    8039bd <free_block+0x149>
  8039b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039b6:	8b 00                	mov    (%eax),%eax
  8039b8:	a3 48 50 98 00       	mov    %eax,0x985048
  8039bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039d0:	a1 54 50 98 00       	mov    0x985054,%eax
  8039d5:	48                   	dec    %eax
  8039d6:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  8039db:	83 ec 0c             	sub    $0xc,%esp
  8039de:	ff 75 08             	pushl  0x8(%ebp)
  8039e1:	e8 32 f6 ff ff       	call   803018 <insert_sorted_in_freeList>
  8039e6:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  8039e9:	e9 01 01 00 00       	jmp    803aef <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  8039ee:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8039f2:	0f 85 d3 00 00 00    	jne    803acb <free_block+0x257>
  8039f8:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  8039fc:	0f 85 c9 00 00 00    	jne    803acb <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  803a02:	83 ec 0c             	sub    $0xc,%esp
  803a05:	ff 75 e8             	pushl  -0x18(%ebp)
  803a08:	e8 38 f3 ff ff       	call   802d45 <get_block_size>
  803a0d:	83 c4 10             	add    $0x10,%esp
  803a10:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  803a13:	83 ec 0c             	sub    $0xc,%esp
  803a16:	ff 75 e0             	pushl  -0x20(%ebp)
  803a19:	e8 27 f3 ff ff       	call   802d45 <get_block_size>
  803a1e:	83 c4 10             	add    $0x10,%esp
  803a21:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  803a24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a27:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a2a:	01 c2                	add    %eax,%edx
  803a2c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803a2f:	01 d0                	add    %edx,%eax
  803a31:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  803a34:	83 ec 04             	sub    $0x4,%esp
  803a37:	6a 00                	push   $0x0
  803a39:	ff 75 c0             	pushl  -0x40(%ebp)
  803a3c:	ff 75 e8             	pushl  -0x18(%ebp)
  803a3f:	e8 7d f5 ff ff       	call   802fc1 <set_block_data>
  803a44:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  803a47:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803a4b:	75 17                	jne    803a64 <free_block+0x1f0>
  803a4d:	83 ec 04             	sub    $0x4,%esp
  803a50:	68 20 4b 80 00       	push   $0x804b20
  803a55:	68 94 01 00 00       	push   $0x194
  803a5a:	68 77 4a 80 00       	push   $0x804a77
  803a5f:	e8 22 d5 ff ff       	call   800f86 <_panic>
  803a64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a67:	8b 00                	mov    (%eax),%eax
  803a69:	85 c0                	test   %eax,%eax
  803a6b:	74 10                	je     803a7d <free_block+0x209>
  803a6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a70:	8b 00                	mov    (%eax),%eax
  803a72:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a75:	8b 52 04             	mov    0x4(%edx),%edx
  803a78:	89 50 04             	mov    %edx,0x4(%eax)
  803a7b:	eb 0b                	jmp    803a88 <free_block+0x214>
  803a7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a80:	8b 40 04             	mov    0x4(%eax),%eax
  803a83:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803a88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a8b:	8b 40 04             	mov    0x4(%eax),%eax
  803a8e:	85 c0                	test   %eax,%eax
  803a90:	74 0f                	je     803aa1 <free_block+0x22d>
  803a92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a95:	8b 40 04             	mov    0x4(%eax),%eax
  803a98:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a9b:	8b 12                	mov    (%edx),%edx
  803a9d:	89 10                	mov    %edx,(%eax)
  803a9f:	eb 0a                	jmp    803aab <free_block+0x237>
  803aa1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803aa4:	8b 00                	mov    (%eax),%eax
  803aa6:	a3 48 50 98 00       	mov    %eax,0x985048
  803aab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803aae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ab4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ab7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803abe:	a1 54 50 98 00       	mov    0x985054,%eax
  803ac3:	48                   	dec    %eax
  803ac4:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  803ac9:	eb 24                	jmp    803aef <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  803acb:	83 ec 04             	sub    $0x4,%esp
  803ace:	6a 00                	push   $0x0
  803ad0:	ff 75 f4             	pushl  -0xc(%ebp)
  803ad3:	ff 75 08             	pushl  0x8(%ebp)
  803ad6:	e8 e6 f4 ff ff       	call   802fc1 <set_block_data>
  803adb:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  803ade:	83 ec 0c             	sub    $0xc,%esp
  803ae1:	ff 75 08             	pushl  0x8(%ebp)
  803ae4:	e8 2f f5 ff ff       	call   803018 <insert_sorted_in_freeList>
  803ae9:	83 c4 10             	add    $0x10,%esp
  803aec:	eb 01                	jmp    803aef <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  803aee:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  803aef:	c9                   	leave  
  803af0:	c3                   	ret    

00803af1 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  803af1:	55                   	push   %ebp
  803af2:	89 e5                	mov    %esp,%ebp
  803af4:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  803af7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803afb:	75 10                	jne    803b0d <realloc_block_FF+0x1c>
  803afd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b01:	75 0a                	jne    803b0d <realloc_block_FF+0x1c>
	{
		return NULL;
  803b03:	b8 00 00 00 00       	mov    $0x0,%eax
  803b08:	e9 8b 04 00 00       	jmp    803f98 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  803b0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b11:	75 18                	jne    803b2b <realloc_block_FF+0x3a>
	{
		free_block(va);
  803b13:	83 ec 0c             	sub    $0xc,%esp
  803b16:	ff 75 08             	pushl  0x8(%ebp)
  803b19:	e8 56 fd ff ff       	call   803874 <free_block>
  803b1e:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803b21:	b8 00 00 00 00       	mov    $0x0,%eax
  803b26:	e9 6d 04 00 00       	jmp    803f98 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  803b2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b2f:	75 13                	jne    803b44 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  803b31:	83 ec 0c             	sub    $0xc,%esp
  803b34:	ff 75 0c             	pushl  0xc(%ebp)
  803b37:	e8 6f f6 ff ff       	call   8031ab <alloc_block_FF>
  803b3c:	83 c4 10             	add    $0x10,%esp
  803b3f:	e9 54 04 00 00       	jmp    803f98 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  803b44:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b47:	83 e0 01             	and    $0x1,%eax
  803b4a:	85 c0                	test   %eax,%eax
  803b4c:	74 03                	je     803b51 <realloc_block_FF+0x60>
	{
		new_size++;
  803b4e:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  803b51:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803b55:	77 07                	ja     803b5e <realloc_block_FF+0x6d>
	{
		new_size = 8;
  803b57:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  803b5e:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  803b62:	83 ec 0c             	sub    $0xc,%esp
  803b65:	ff 75 08             	pushl  0x8(%ebp)
  803b68:	e8 d8 f1 ff ff       	call   802d45 <get_block_size>
  803b6d:	83 c4 10             	add    $0x10,%esp
  803b70:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  803b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b76:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803b79:	75 08                	jne    803b83 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  803b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b7e:	e9 15 04 00 00       	jmp    803f98 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  803b83:	8b 55 08             	mov    0x8(%ebp),%edx
  803b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b89:	01 d0                	add    %edx,%eax
  803b8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  803b8e:	83 ec 0c             	sub    $0xc,%esp
  803b91:	ff 75 f0             	pushl  -0x10(%ebp)
  803b94:	e8 c5 f1 ff ff       	call   802d5e <is_free_block>
  803b99:	83 c4 10             	add    $0x10,%esp
  803b9c:	0f be c0             	movsbl %al,%eax
  803b9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  803ba2:	83 ec 0c             	sub    $0xc,%esp
  803ba5:	ff 75 f0             	pushl  -0x10(%ebp)
  803ba8:	e8 98 f1 ff ff       	call   802d45 <get_block_size>
  803bad:	83 c4 10             	add    $0x10,%esp
  803bb0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  803bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bb6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803bb9:	0f 86 a7 02 00 00    	jbe    803e66 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  803bbf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803bc3:	0f 84 86 02 00 00    	je     803e4f <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  803bc9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bcf:	01 d0                	add    %edx,%eax
  803bd1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803bd4:	0f 85 b2 00 00 00    	jne    803c8c <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  803bda:	83 ec 0c             	sub    $0xc,%esp
  803bdd:	ff 75 08             	pushl  0x8(%ebp)
  803be0:	e8 79 f1 ff ff       	call   802d5e <is_free_block>
  803be5:	83 c4 10             	add    $0x10,%esp
  803be8:	84 c0                	test   %al,%al
  803bea:	0f 94 c0             	sete   %al
  803bed:	0f b6 c0             	movzbl %al,%eax
  803bf0:	83 ec 04             	sub    $0x4,%esp
  803bf3:	50                   	push   %eax
  803bf4:	ff 75 0c             	pushl  0xc(%ebp)
  803bf7:	ff 75 08             	pushl  0x8(%ebp)
  803bfa:	e8 c2 f3 ff ff       	call   802fc1 <set_block_data>
  803bff:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  803c02:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c06:	75 17                	jne    803c1f <realloc_block_FF+0x12e>
  803c08:	83 ec 04             	sub    $0x4,%esp
  803c0b:	68 20 4b 80 00       	push   $0x804b20
  803c10:	68 db 01 00 00       	push   $0x1db
  803c15:	68 77 4a 80 00       	push   $0x804a77
  803c1a:	e8 67 d3 ff ff       	call   800f86 <_panic>
  803c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c22:	8b 00                	mov    (%eax),%eax
  803c24:	85 c0                	test   %eax,%eax
  803c26:	74 10                	je     803c38 <realloc_block_FF+0x147>
  803c28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c2b:	8b 00                	mov    (%eax),%eax
  803c2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c30:	8b 52 04             	mov    0x4(%edx),%edx
  803c33:	89 50 04             	mov    %edx,0x4(%eax)
  803c36:	eb 0b                	jmp    803c43 <realloc_block_FF+0x152>
  803c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c3b:	8b 40 04             	mov    0x4(%eax),%eax
  803c3e:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c46:	8b 40 04             	mov    0x4(%eax),%eax
  803c49:	85 c0                	test   %eax,%eax
  803c4b:	74 0f                	je     803c5c <realloc_block_FF+0x16b>
  803c4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c50:	8b 40 04             	mov    0x4(%eax),%eax
  803c53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c56:	8b 12                	mov    (%edx),%edx
  803c58:	89 10                	mov    %edx,(%eax)
  803c5a:	eb 0a                	jmp    803c66 <realloc_block_FF+0x175>
  803c5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c5f:	8b 00                	mov    (%eax),%eax
  803c61:	a3 48 50 98 00       	mov    %eax,0x985048
  803c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c79:	a1 54 50 98 00       	mov    0x985054,%eax
  803c7e:	48                   	dec    %eax
  803c7f:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  803c84:	8b 45 08             	mov    0x8(%ebp),%eax
  803c87:	e9 0c 03 00 00       	jmp    803f98 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  803c8c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c92:	01 d0                	add    %edx,%eax
  803c94:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803c97:	0f 86 b2 01 00 00    	jbe    803e4f <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  803c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ca0:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803ca3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  803ca6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ca9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803cac:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  803caf:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  803cb3:	0f 87 b8 00 00 00    	ja     803d71 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  803cb9:	83 ec 0c             	sub    $0xc,%esp
  803cbc:	ff 75 08             	pushl  0x8(%ebp)
  803cbf:	e8 9a f0 ff ff       	call   802d5e <is_free_block>
  803cc4:	83 c4 10             	add    $0x10,%esp
  803cc7:	84 c0                	test   %al,%al
  803cc9:	0f 94 c0             	sete   %al
  803ccc:	0f b6 c0             	movzbl %al,%eax
  803ccf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803cd2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803cd5:	01 ca                	add    %ecx,%edx
  803cd7:	83 ec 04             	sub    $0x4,%esp
  803cda:	50                   	push   %eax
  803cdb:	52                   	push   %edx
  803cdc:	ff 75 08             	pushl  0x8(%ebp)
  803cdf:	e8 dd f2 ff ff       	call   802fc1 <set_block_data>
  803ce4:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803ce7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ceb:	75 17                	jne    803d04 <realloc_block_FF+0x213>
  803ced:	83 ec 04             	sub    $0x4,%esp
  803cf0:	68 20 4b 80 00       	push   $0x804b20
  803cf5:	68 e8 01 00 00       	push   $0x1e8
  803cfa:	68 77 4a 80 00       	push   $0x804a77
  803cff:	e8 82 d2 ff ff       	call   800f86 <_panic>
  803d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d07:	8b 00                	mov    (%eax),%eax
  803d09:	85 c0                	test   %eax,%eax
  803d0b:	74 10                	je     803d1d <realloc_block_FF+0x22c>
  803d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d10:	8b 00                	mov    (%eax),%eax
  803d12:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d15:	8b 52 04             	mov    0x4(%edx),%edx
  803d18:	89 50 04             	mov    %edx,0x4(%eax)
  803d1b:	eb 0b                	jmp    803d28 <realloc_block_FF+0x237>
  803d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d20:	8b 40 04             	mov    0x4(%eax),%eax
  803d23:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803d28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d2b:	8b 40 04             	mov    0x4(%eax),%eax
  803d2e:	85 c0                	test   %eax,%eax
  803d30:	74 0f                	je     803d41 <realloc_block_FF+0x250>
  803d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d35:	8b 40 04             	mov    0x4(%eax),%eax
  803d38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d3b:	8b 12                	mov    (%edx),%edx
  803d3d:	89 10                	mov    %edx,(%eax)
  803d3f:	eb 0a                	jmp    803d4b <realloc_block_FF+0x25a>
  803d41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d44:	8b 00                	mov    (%eax),%eax
  803d46:	a3 48 50 98 00       	mov    %eax,0x985048
  803d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d5e:	a1 54 50 98 00       	mov    0x985054,%eax
  803d63:	48                   	dec    %eax
  803d64:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  803d69:	8b 45 08             	mov    0x8(%ebp),%eax
  803d6c:	e9 27 02 00 00       	jmp    803f98 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803d71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d75:	75 17                	jne    803d8e <realloc_block_FF+0x29d>
  803d77:	83 ec 04             	sub    $0x4,%esp
  803d7a:	68 20 4b 80 00       	push   $0x804b20
  803d7f:	68 ed 01 00 00       	push   $0x1ed
  803d84:	68 77 4a 80 00       	push   $0x804a77
  803d89:	e8 f8 d1 ff ff       	call   800f86 <_panic>
  803d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d91:	8b 00                	mov    (%eax),%eax
  803d93:	85 c0                	test   %eax,%eax
  803d95:	74 10                	je     803da7 <realloc_block_FF+0x2b6>
  803d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d9a:	8b 00                	mov    (%eax),%eax
  803d9c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d9f:	8b 52 04             	mov    0x4(%edx),%edx
  803da2:	89 50 04             	mov    %edx,0x4(%eax)
  803da5:	eb 0b                	jmp    803db2 <realloc_block_FF+0x2c1>
  803da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803daa:	8b 40 04             	mov    0x4(%eax),%eax
  803dad:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803db5:	8b 40 04             	mov    0x4(%eax),%eax
  803db8:	85 c0                	test   %eax,%eax
  803dba:	74 0f                	je     803dcb <realloc_block_FF+0x2da>
  803dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dbf:	8b 40 04             	mov    0x4(%eax),%eax
  803dc2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dc5:	8b 12                	mov    (%edx),%edx
  803dc7:	89 10                	mov    %edx,(%eax)
  803dc9:	eb 0a                	jmp    803dd5 <realloc_block_FF+0x2e4>
  803dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dce:	8b 00                	mov    (%eax),%eax
  803dd0:	a3 48 50 98 00       	mov    %eax,0x985048
  803dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803de1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803de8:	a1 54 50 98 00       	mov    0x985054,%eax
  803ded:	48                   	dec    %eax
  803dee:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  803df3:	8b 55 08             	mov    0x8(%ebp),%edx
  803df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  803df9:	01 d0                	add    %edx,%eax
  803dfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  803dfe:	83 ec 04             	sub    $0x4,%esp
  803e01:	6a 00                	push   $0x0
  803e03:	ff 75 e0             	pushl  -0x20(%ebp)
  803e06:	ff 75 f0             	pushl  -0x10(%ebp)
  803e09:	e8 b3 f1 ff ff       	call   802fc1 <set_block_data>
  803e0e:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  803e11:	83 ec 0c             	sub    $0xc,%esp
  803e14:	ff 75 08             	pushl  0x8(%ebp)
  803e17:	e8 42 ef ff ff       	call   802d5e <is_free_block>
  803e1c:	83 c4 10             	add    $0x10,%esp
  803e1f:	84 c0                	test   %al,%al
  803e21:	0f 94 c0             	sete   %al
  803e24:	0f b6 c0             	movzbl %al,%eax
  803e27:	83 ec 04             	sub    $0x4,%esp
  803e2a:	50                   	push   %eax
  803e2b:	ff 75 0c             	pushl  0xc(%ebp)
  803e2e:	ff 75 08             	pushl  0x8(%ebp)
  803e31:	e8 8b f1 ff ff       	call   802fc1 <set_block_data>
  803e36:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  803e39:	83 ec 0c             	sub    $0xc,%esp
  803e3c:	ff 75 f0             	pushl  -0x10(%ebp)
  803e3f:	e8 d4 f1 ff ff       	call   803018 <insert_sorted_in_freeList>
  803e44:	83 c4 10             	add    $0x10,%esp
					return va;
  803e47:	8b 45 08             	mov    0x8(%ebp),%eax
  803e4a:	e9 49 01 00 00       	jmp    803f98 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e52:	83 e8 08             	sub    $0x8,%eax
  803e55:	83 ec 0c             	sub    $0xc,%esp
  803e58:	50                   	push   %eax
  803e59:	e8 4d f3 ff ff       	call   8031ab <alloc_block_FF>
  803e5e:	83 c4 10             	add    $0x10,%esp
  803e61:	e9 32 01 00 00       	jmp    803f98 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  803e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e69:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803e6c:	0f 83 21 01 00 00    	jae    803f93 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  803e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e75:	2b 45 0c             	sub    0xc(%ebp),%eax
  803e78:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  803e7b:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  803e7f:	77 0e                	ja     803e8f <realloc_block_FF+0x39e>
  803e81:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803e85:	75 08                	jne    803e8f <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  803e87:	8b 45 08             	mov    0x8(%ebp),%eax
  803e8a:	e9 09 01 00 00       	jmp    803f98 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  803e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  803e92:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  803e95:	83 ec 0c             	sub    $0xc,%esp
  803e98:	ff 75 08             	pushl  0x8(%ebp)
  803e9b:	e8 be ee ff ff       	call   802d5e <is_free_block>
  803ea0:	83 c4 10             	add    $0x10,%esp
  803ea3:	84 c0                	test   %al,%al
  803ea5:	0f 94 c0             	sete   %al
  803ea8:	0f b6 c0             	movzbl %al,%eax
  803eab:	83 ec 04             	sub    $0x4,%esp
  803eae:	50                   	push   %eax
  803eaf:	ff 75 0c             	pushl  0xc(%ebp)
  803eb2:	ff 75 d8             	pushl  -0x28(%ebp)
  803eb5:	e8 07 f1 ff ff       	call   802fc1 <set_block_data>
  803eba:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  803ebd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ec3:	01 d0                	add    %edx,%eax
  803ec5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  803ec8:	83 ec 04             	sub    $0x4,%esp
  803ecb:	6a 00                	push   $0x0
  803ecd:	ff 75 dc             	pushl  -0x24(%ebp)
  803ed0:	ff 75 d4             	pushl  -0x2c(%ebp)
  803ed3:	e8 e9 f0 ff ff       	call   802fc1 <set_block_data>
  803ed8:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  803edb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803edf:	0f 84 9b 00 00 00    	je     803f80 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  803ee5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ee8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803eeb:	01 d0                	add    %edx,%eax
  803eed:	83 ec 04             	sub    $0x4,%esp
  803ef0:	6a 00                	push   $0x0
  803ef2:	50                   	push   %eax
  803ef3:	ff 75 d4             	pushl  -0x2c(%ebp)
  803ef6:	e8 c6 f0 ff ff       	call   802fc1 <set_block_data>
  803efb:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  803efe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f02:	75 17                	jne    803f1b <realloc_block_FF+0x42a>
  803f04:	83 ec 04             	sub    $0x4,%esp
  803f07:	68 20 4b 80 00       	push   $0x804b20
  803f0c:	68 10 02 00 00       	push   $0x210
  803f11:	68 77 4a 80 00       	push   $0x804a77
  803f16:	e8 6b d0 ff ff       	call   800f86 <_panic>
  803f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f1e:	8b 00                	mov    (%eax),%eax
  803f20:	85 c0                	test   %eax,%eax
  803f22:	74 10                	je     803f34 <realloc_block_FF+0x443>
  803f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f27:	8b 00                	mov    (%eax),%eax
  803f29:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f2c:	8b 52 04             	mov    0x4(%edx),%edx
  803f2f:	89 50 04             	mov    %edx,0x4(%eax)
  803f32:	eb 0b                	jmp    803f3f <realloc_block_FF+0x44e>
  803f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f37:	8b 40 04             	mov    0x4(%eax),%eax
  803f3a:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f42:	8b 40 04             	mov    0x4(%eax),%eax
  803f45:	85 c0                	test   %eax,%eax
  803f47:	74 0f                	je     803f58 <realloc_block_FF+0x467>
  803f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f4c:	8b 40 04             	mov    0x4(%eax),%eax
  803f4f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f52:	8b 12                	mov    (%edx),%edx
  803f54:	89 10                	mov    %edx,(%eax)
  803f56:	eb 0a                	jmp    803f62 <realloc_block_FF+0x471>
  803f58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f5b:	8b 00                	mov    (%eax),%eax
  803f5d:	a3 48 50 98 00       	mov    %eax,0x985048
  803f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f75:	a1 54 50 98 00       	mov    0x985054,%eax
  803f7a:	48                   	dec    %eax
  803f7b:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  803f80:	83 ec 0c             	sub    $0xc,%esp
  803f83:	ff 75 d4             	pushl  -0x2c(%ebp)
  803f86:	e8 8d f0 ff ff       	call   803018 <insert_sorted_in_freeList>
  803f8b:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  803f8e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803f91:	eb 05                	jmp    803f98 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  803f93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f98:	c9                   	leave  
  803f99:	c3                   	ret    

00803f9a <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803f9a:	55                   	push   %ebp
  803f9b:	89 e5                	mov    %esp,%ebp
  803f9d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803fa0:	83 ec 04             	sub    $0x4,%esp
  803fa3:	68 40 4b 80 00       	push   $0x804b40
  803fa8:	68 20 02 00 00       	push   $0x220
  803fad:	68 77 4a 80 00       	push   $0x804a77
  803fb2:	e8 cf cf ff ff       	call   800f86 <_panic>

00803fb7 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803fb7:	55                   	push   %ebp
  803fb8:	89 e5                	mov    %esp,%ebp
  803fba:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803fbd:	83 ec 04             	sub    $0x4,%esp
  803fc0:	68 68 4b 80 00       	push   $0x804b68
  803fc5:	68 28 02 00 00       	push   $0x228
  803fca:	68 77 4a 80 00       	push   $0x804a77
  803fcf:	e8 b2 cf ff ff       	call   800f86 <_panic>

00803fd4 <__udivdi3>:
  803fd4:	55                   	push   %ebp
  803fd5:	57                   	push   %edi
  803fd6:	56                   	push   %esi
  803fd7:	53                   	push   %ebx
  803fd8:	83 ec 1c             	sub    $0x1c,%esp
  803fdb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803fdf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803fe3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803fe7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803feb:	89 ca                	mov    %ecx,%edx
  803fed:	89 f8                	mov    %edi,%eax
  803fef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803ff3:	85 f6                	test   %esi,%esi
  803ff5:	75 2d                	jne    804024 <__udivdi3+0x50>
  803ff7:	39 cf                	cmp    %ecx,%edi
  803ff9:	77 65                	ja     804060 <__udivdi3+0x8c>
  803ffb:	89 fd                	mov    %edi,%ebp
  803ffd:	85 ff                	test   %edi,%edi
  803fff:	75 0b                	jne    80400c <__udivdi3+0x38>
  804001:	b8 01 00 00 00       	mov    $0x1,%eax
  804006:	31 d2                	xor    %edx,%edx
  804008:	f7 f7                	div    %edi
  80400a:	89 c5                	mov    %eax,%ebp
  80400c:	31 d2                	xor    %edx,%edx
  80400e:	89 c8                	mov    %ecx,%eax
  804010:	f7 f5                	div    %ebp
  804012:	89 c1                	mov    %eax,%ecx
  804014:	89 d8                	mov    %ebx,%eax
  804016:	f7 f5                	div    %ebp
  804018:	89 cf                	mov    %ecx,%edi
  80401a:	89 fa                	mov    %edi,%edx
  80401c:	83 c4 1c             	add    $0x1c,%esp
  80401f:	5b                   	pop    %ebx
  804020:	5e                   	pop    %esi
  804021:	5f                   	pop    %edi
  804022:	5d                   	pop    %ebp
  804023:	c3                   	ret    
  804024:	39 ce                	cmp    %ecx,%esi
  804026:	77 28                	ja     804050 <__udivdi3+0x7c>
  804028:	0f bd fe             	bsr    %esi,%edi
  80402b:	83 f7 1f             	xor    $0x1f,%edi
  80402e:	75 40                	jne    804070 <__udivdi3+0x9c>
  804030:	39 ce                	cmp    %ecx,%esi
  804032:	72 0a                	jb     80403e <__udivdi3+0x6a>
  804034:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804038:	0f 87 9e 00 00 00    	ja     8040dc <__udivdi3+0x108>
  80403e:	b8 01 00 00 00       	mov    $0x1,%eax
  804043:	89 fa                	mov    %edi,%edx
  804045:	83 c4 1c             	add    $0x1c,%esp
  804048:	5b                   	pop    %ebx
  804049:	5e                   	pop    %esi
  80404a:	5f                   	pop    %edi
  80404b:	5d                   	pop    %ebp
  80404c:	c3                   	ret    
  80404d:	8d 76 00             	lea    0x0(%esi),%esi
  804050:	31 ff                	xor    %edi,%edi
  804052:	31 c0                	xor    %eax,%eax
  804054:	89 fa                	mov    %edi,%edx
  804056:	83 c4 1c             	add    $0x1c,%esp
  804059:	5b                   	pop    %ebx
  80405a:	5e                   	pop    %esi
  80405b:	5f                   	pop    %edi
  80405c:	5d                   	pop    %ebp
  80405d:	c3                   	ret    
  80405e:	66 90                	xchg   %ax,%ax
  804060:	89 d8                	mov    %ebx,%eax
  804062:	f7 f7                	div    %edi
  804064:	31 ff                	xor    %edi,%edi
  804066:	89 fa                	mov    %edi,%edx
  804068:	83 c4 1c             	add    $0x1c,%esp
  80406b:	5b                   	pop    %ebx
  80406c:	5e                   	pop    %esi
  80406d:	5f                   	pop    %edi
  80406e:	5d                   	pop    %ebp
  80406f:	c3                   	ret    
  804070:	bd 20 00 00 00       	mov    $0x20,%ebp
  804075:	89 eb                	mov    %ebp,%ebx
  804077:	29 fb                	sub    %edi,%ebx
  804079:	89 f9                	mov    %edi,%ecx
  80407b:	d3 e6                	shl    %cl,%esi
  80407d:	89 c5                	mov    %eax,%ebp
  80407f:	88 d9                	mov    %bl,%cl
  804081:	d3 ed                	shr    %cl,%ebp
  804083:	89 e9                	mov    %ebp,%ecx
  804085:	09 f1                	or     %esi,%ecx
  804087:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80408b:	89 f9                	mov    %edi,%ecx
  80408d:	d3 e0                	shl    %cl,%eax
  80408f:	89 c5                	mov    %eax,%ebp
  804091:	89 d6                	mov    %edx,%esi
  804093:	88 d9                	mov    %bl,%cl
  804095:	d3 ee                	shr    %cl,%esi
  804097:	89 f9                	mov    %edi,%ecx
  804099:	d3 e2                	shl    %cl,%edx
  80409b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80409f:	88 d9                	mov    %bl,%cl
  8040a1:	d3 e8                	shr    %cl,%eax
  8040a3:	09 c2                	or     %eax,%edx
  8040a5:	89 d0                	mov    %edx,%eax
  8040a7:	89 f2                	mov    %esi,%edx
  8040a9:	f7 74 24 0c          	divl   0xc(%esp)
  8040ad:	89 d6                	mov    %edx,%esi
  8040af:	89 c3                	mov    %eax,%ebx
  8040b1:	f7 e5                	mul    %ebp
  8040b3:	39 d6                	cmp    %edx,%esi
  8040b5:	72 19                	jb     8040d0 <__udivdi3+0xfc>
  8040b7:	74 0b                	je     8040c4 <__udivdi3+0xf0>
  8040b9:	89 d8                	mov    %ebx,%eax
  8040bb:	31 ff                	xor    %edi,%edi
  8040bd:	e9 58 ff ff ff       	jmp    80401a <__udivdi3+0x46>
  8040c2:	66 90                	xchg   %ax,%ax
  8040c4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8040c8:	89 f9                	mov    %edi,%ecx
  8040ca:	d3 e2                	shl    %cl,%edx
  8040cc:	39 c2                	cmp    %eax,%edx
  8040ce:	73 e9                	jae    8040b9 <__udivdi3+0xe5>
  8040d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8040d3:	31 ff                	xor    %edi,%edi
  8040d5:	e9 40 ff ff ff       	jmp    80401a <__udivdi3+0x46>
  8040da:	66 90                	xchg   %ax,%ax
  8040dc:	31 c0                	xor    %eax,%eax
  8040de:	e9 37 ff ff ff       	jmp    80401a <__udivdi3+0x46>
  8040e3:	90                   	nop

008040e4 <__umoddi3>:
  8040e4:	55                   	push   %ebp
  8040e5:	57                   	push   %edi
  8040e6:	56                   	push   %esi
  8040e7:	53                   	push   %ebx
  8040e8:	83 ec 1c             	sub    $0x1c,%esp
  8040eb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8040ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8040f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040f7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8040fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8040ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804103:	89 f3                	mov    %esi,%ebx
  804105:	89 fa                	mov    %edi,%edx
  804107:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80410b:	89 34 24             	mov    %esi,(%esp)
  80410e:	85 c0                	test   %eax,%eax
  804110:	75 1a                	jne    80412c <__umoddi3+0x48>
  804112:	39 f7                	cmp    %esi,%edi
  804114:	0f 86 a2 00 00 00    	jbe    8041bc <__umoddi3+0xd8>
  80411a:	89 c8                	mov    %ecx,%eax
  80411c:	89 f2                	mov    %esi,%edx
  80411e:	f7 f7                	div    %edi
  804120:	89 d0                	mov    %edx,%eax
  804122:	31 d2                	xor    %edx,%edx
  804124:	83 c4 1c             	add    $0x1c,%esp
  804127:	5b                   	pop    %ebx
  804128:	5e                   	pop    %esi
  804129:	5f                   	pop    %edi
  80412a:	5d                   	pop    %ebp
  80412b:	c3                   	ret    
  80412c:	39 f0                	cmp    %esi,%eax
  80412e:	0f 87 ac 00 00 00    	ja     8041e0 <__umoddi3+0xfc>
  804134:	0f bd e8             	bsr    %eax,%ebp
  804137:	83 f5 1f             	xor    $0x1f,%ebp
  80413a:	0f 84 ac 00 00 00    	je     8041ec <__umoddi3+0x108>
  804140:	bf 20 00 00 00       	mov    $0x20,%edi
  804145:	29 ef                	sub    %ebp,%edi
  804147:	89 fe                	mov    %edi,%esi
  804149:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80414d:	89 e9                	mov    %ebp,%ecx
  80414f:	d3 e0                	shl    %cl,%eax
  804151:	89 d7                	mov    %edx,%edi
  804153:	89 f1                	mov    %esi,%ecx
  804155:	d3 ef                	shr    %cl,%edi
  804157:	09 c7                	or     %eax,%edi
  804159:	89 e9                	mov    %ebp,%ecx
  80415b:	d3 e2                	shl    %cl,%edx
  80415d:	89 14 24             	mov    %edx,(%esp)
  804160:	89 d8                	mov    %ebx,%eax
  804162:	d3 e0                	shl    %cl,%eax
  804164:	89 c2                	mov    %eax,%edx
  804166:	8b 44 24 08          	mov    0x8(%esp),%eax
  80416a:	d3 e0                	shl    %cl,%eax
  80416c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804170:	8b 44 24 08          	mov    0x8(%esp),%eax
  804174:	89 f1                	mov    %esi,%ecx
  804176:	d3 e8                	shr    %cl,%eax
  804178:	09 d0                	or     %edx,%eax
  80417a:	d3 eb                	shr    %cl,%ebx
  80417c:	89 da                	mov    %ebx,%edx
  80417e:	f7 f7                	div    %edi
  804180:	89 d3                	mov    %edx,%ebx
  804182:	f7 24 24             	mull   (%esp)
  804185:	89 c6                	mov    %eax,%esi
  804187:	89 d1                	mov    %edx,%ecx
  804189:	39 d3                	cmp    %edx,%ebx
  80418b:	0f 82 87 00 00 00    	jb     804218 <__umoddi3+0x134>
  804191:	0f 84 91 00 00 00    	je     804228 <__umoddi3+0x144>
  804197:	8b 54 24 04          	mov    0x4(%esp),%edx
  80419b:	29 f2                	sub    %esi,%edx
  80419d:	19 cb                	sbb    %ecx,%ebx
  80419f:	89 d8                	mov    %ebx,%eax
  8041a1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8041a5:	d3 e0                	shl    %cl,%eax
  8041a7:	89 e9                	mov    %ebp,%ecx
  8041a9:	d3 ea                	shr    %cl,%edx
  8041ab:	09 d0                	or     %edx,%eax
  8041ad:	89 e9                	mov    %ebp,%ecx
  8041af:	d3 eb                	shr    %cl,%ebx
  8041b1:	89 da                	mov    %ebx,%edx
  8041b3:	83 c4 1c             	add    $0x1c,%esp
  8041b6:	5b                   	pop    %ebx
  8041b7:	5e                   	pop    %esi
  8041b8:	5f                   	pop    %edi
  8041b9:	5d                   	pop    %ebp
  8041ba:	c3                   	ret    
  8041bb:	90                   	nop
  8041bc:	89 fd                	mov    %edi,%ebp
  8041be:	85 ff                	test   %edi,%edi
  8041c0:	75 0b                	jne    8041cd <__umoddi3+0xe9>
  8041c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8041c7:	31 d2                	xor    %edx,%edx
  8041c9:	f7 f7                	div    %edi
  8041cb:	89 c5                	mov    %eax,%ebp
  8041cd:	89 f0                	mov    %esi,%eax
  8041cf:	31 d2                	xor    %edx,%edx
  8041d1:	f7 f5                	div    %ebp
  8041d3:	89 c8                	mov    %ecx,%eax
  8041d5:	f7 f5                	div    %ebp
  8041d7:	89 d0                	mov    %edx,%eax
  8041d9:	e9 44 ff ff ff       	jmp    804122 <__umoddi3+0x3e>
  8041de:	66 90                	xchg   %ax,%ax
  8041e0:	89 c8                	mov    %ecx,%eax
  8041e2:	89 f2                	mov    %esi,%edx
  8041e4:	83 c4 1c             	add    $0x1c,%esp
  8041e7:	5b                   	pop    %ebx
  8041e8:	5e                   	pop    %esi
  8041e9:	5f                   	pop    %edi
  8041ea:	5d                   	pop    %ebp
  8041eb:	c3                   	ret    
  8041ec:	3b 04 24             	cmp    (%esp),%eax
  8041ef:	72 06                	jb     8041f7 <__umoddi3+0x113>
  8041f1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8041f5:	77 0f                	ja     804206 <__umoddi3+0x122>
  8041f7:	89 f2                	mov    %esi,%edx
  8041f9:	29 f9                	sub    %edi,%ecx
  8041fb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8041ff:	89 14 24             	mov    %edx,(%esp)
  804202:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804206:	8b 44 24 04          	mov    0x4(%esp),%eax
  80420a:	8b 14 24             	mov    (%esp),%edx
  80420d:	83 c4 1c             	add    $0x1c,%esp
  804210:	5b                   	pop    %ebx
  804211:	5e                   	pop    %esi
  804212:	5f                   	pop    %edi
  804213:	5d                   	pop    %ebp
  804214:	c3                   	ret    
  804215:	8d 76 00             	lea    0x0(%esi),%esi
  804218:	2b 04 24             	sub    (%esp),%eax
  80421b:	19 fa                	sbb    %edi,%edx
  80421d:	89 d1                	mov    %edx,%ecx
  80421f:	89 c6                	mov    %eax,%esi
  804221:	e9 71 ff ff ff       	jmp    804197 <__umoddi3+0xb3>
  804226:	66 90                	xchg   %ax,%ax
  804228:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80422c:	72 ea                	jb     804218 <__umoddi3+0x134>
  80422e:	89 d9                	mov    %ebx,%ecx
  804230:	e9 62 ff ff ff       	jmp    804197 <__umoddi3+0xb3>
